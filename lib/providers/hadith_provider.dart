import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/hadith_model.dart';
import '../data/models/firestore_models.dart';
import '../core/services/content_service.dart';

// Hadith Language enum
enum HadithLanguage { english, urdu, hindi, arabic }

// Hadith Collection enum
enum HadithCollection { bukhari, muslim, nasai, abudawud, tirmidhi, ibnmajah }

class HadithProvider with ChangeNotifier {
  // API base URLs
  static const String _hadithApiUrl =
      'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1';

  // Saved preferences keys
  static const String _favoritesKey = 'hadith_favorites';
  static const String _languageKey = 'hadith_language';

  // State variables
  bool _isLoading = false;
  String? _error;
  HadithLanguage _selectedLanguage = HadithLanguage.english;
  Set<String> _favorites = {}; // Format: "collection:hadithNumber"

  // Current data
  List<HadithChapterInfo> _chapters = [];
  List<HadithModel> _currentHadiths = [];
  HadithCollection? _currentCollection;
  int? _currentChapter;

  // Firebase-loaded collection info
  Map<String, HadithCollectionInfoFirestore> _collectionsInfo = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  HadithLanguage get selectedLanguage => _selectedLanguage;
  Set<String> get favorites => _favorites;
  List<HadithChapterInfo> get chapters => _chapters;
  List<HadithModel> get currentHadiths => _currentHadiths;
  HadithCollection? get currentCollection => _currentCollection;
  int? get currentChapter => _currentChapter;
  Map<String, HadithCollectionInfoFirestore> get collectionsInfo =>
      _collectionsInfo;

  // Get collection info for a specific collection
  HadithCollectionInfoFirestore? getCollectionInfo(
      HadithCollection collection) {
    return _collectionsInfo[collection.name];
  }

  // Get collection name in the current language
  String getCollectionName(HadithCollection collection, String langCode) {
    final info = _collectionsInfo[collection.name];
    return info?.name.get(langCode) ?? collection.name;
  }

  // Get language display name from Firebase
  String getLanguageName(HadithLanguage language, String langCode) {
    final info = _collectionsInfo.values.firstOrNull;
    if (info == null) return language.name;
    // Language names are stored alongside collections info
    return language.name;
  }

  // Initialize
  Future<void> initialize() async {
    await _loadCollectionsInfo();
    await _loadPreferences();
  }

  Future<void> _loadCollectionsInfo() async {
    try {
      final info = await ContentService().getHadithCollectionsInfo();
      if (info.isNotEmpty) {
        _collectionsInfo = info;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading hadith collections info: $e');
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load language
      final languageIndex = prefs.getInt(_languageKey) ?? 0;
      _selectedLanguage = HadithLanguage.values[languageIndex];

      // Load favorites
      final favoritesJson = prefs.getString(_favoritesKey);
      if (favoritesJson != null) {
        _favorites = Set<String>.from(json.decode(favoritesJson));
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading hadith preferences: $e');
    }
  }

  // Sync hadith language with app language
  void syncWithAppLanguage(String appLanguageCode) {
    HadithLanguage newLanguage;
    switch (appLanguageCode) {
      case 'ur':
        newLanguage = HadithLanguage.urdu;
        break;
      case 'hi':
        newLanguage = HadithLanguage.hindi;
        break;
      case 'ar':
        newLanguage = HadithLanguage.arabic;
        break;
      default:
        newLanguage = HadithLanguage.english;
    }

    if (_selectedLanguage != newLanguage) {
      setLanguage(newLanguage);
    }
  }

  // Set language
  Future<void> setLanguage(HadithLanguage language) async {
    _selectedLanguage = language;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_languageKey, language.index);

    // Reload current hadiths if any
    if (_currentCollection != null) {
      if (_currentChapter != null) {
        await fetchChapterHadiths(_currentCollection!, _currentChapter!);
      }
    }
  }

  // Fetch chapters for a collection
  Future<void> fetchChapters(HadithCollection collection) async {
    _isLoading = true;
    _error = null;
    _currentCollection = collection;
    _chapters = [];
    notifyListeners();

    try {
      final collectionId = collection.name;
      final response = await http.get(
        Uri.parse('$_hadithApiUrl/editions/eng-$collectionId.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['metadata'] != null && data['metadata']['sections'] != null) {
          final sections = data['metadata']['sections'] as Map<String, dynamic>;
          _chapters = sections.entries.map((entry) {
            return HadithChapterInfo(
              id: int.tryParse(entry.key) ?? 0,
              name: entry.value.toString(),
              arabicName: entry.value.toString(),
            );
          }).toList();
        }
      } else {
        _error = 'Failed to fetch chapters';
      }
    } catch (e) {
      _error = 'Network error: $e';
      debugPrint('Error fetching chapters: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch hadiths for a chapter
  Future<void> fetchChapterHadiths(
    HadithCollection collection,
    int chapter,
  ) async {
    _isLoading = true;
    _error = null;
    _currentCollection = collection;
    _currentChapter = chapter;
    _currentHadiths = [];
    notifyListeners();

    try {
      final collectionId = collection.name;
      // For Hindi, we fetch English and translate to Hindi
      // For Urdu, we fetch Urdu directly
      final langCode = _selectedLanguage == HadithLanguage.urdu ? 'urd' : 'eng';

      final url =
          '$_hadithApiUrl/editions/$langCode-$collectionId/sections/$chapter.json';
      final arabicUrl =
          '$_hadithApiUrl/editions/ara-$collectionId/sections/$chapter.json';

      debugPrint('Fetching hadiths from: $url');

      // Fetch hadiths
      final response = await http.get(Uri.parse(url));

      // Also fetch Arabic text
      final arabicResponse = await http.get(Uri.parse(arabicUrl));

      Map<String, String> arabicTexts = {};
      if (arabicResponse.statusCode == 200) {
        try {
          final arabicData = json.decode(arabicResponse.body);
          if (arabicData['hadiths'] != null && arabicData['hadiths'] is List) {
            for (var hadith in arabicData['hadiths']) {
              final hadithNum = hadith['hadithnumber'];
              if (hadithNum != null) {
                arabicTexts[hadithNum.toString()] =
                    hadith['text']?.toString() ?? '';
              }
            }
          }
        } catch (e) {
          debugPrint('Error parsing Arabic response: $e');
        }
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['hadiths'] != null && data['hadiths'] is List) {
            final List<HadithModel> hadithsList = [];

            for (var hadith in data['hadiths']) {
              try {
                final hadithNum = hadith['hadithnumber'] ?? 0;
                final text = hadith['text']?.toString() ?? '';

                // Safely extract grade
                String grade = '';
                final grades = hadith['grades'];
                if (grades != null && grades is List && grades.isNotEmpty) {
                  final firstGrade = grades[0];
                  if (firstGrade is Map) {
                    grade = firstGrade['grade']?.toString() ?? '';
                  }
                }

                final hadithNumInt = hadithNum is int
                    ? hadithNum
                    : int.tryParse(hadithNum.toString()) ?? 0;

                hadithsList.add(
                  HadithModel(
                    id: hadithNumInt,
                    hadithNumber: hadithNum.toString(),
                    arabic: arabicTexts[hadithNum.toString()] ?? '',
                    english:
                        (_selectedLanguage == HadithLanguage.english ||
                            _selectedLanguage == HadithLanguage.hindi)
                        ? text
                        : '',
                    urdu: _selectedLanguage == HadithLanguage.urdu ? text : '',
                    narrator: _extractNarrator(text),
                    grade: grade,
                    reference:
                        '${getCollectionName(collection, 'en')}, Book $chapter, Hadith $hadithNum',
                    isFavorite: _favorites.contains('$collectionId:$hadithNum'),
                  ),
                );
              } catch (e) {
                debugPrint('Error parsing hadith: $e');
              }
            }

            _currentHadiths = hadithsList;
          }
        } catch (e) {
          debugPrint('Error parsing response: $e');
          _error = 'Error parsing response';
        }
      } else {
        _error = 'Failed to fetch hadiths (${response.statusCode})';
        debugPrint('API returned status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _error = 'Network error';
      debugPrint('Error fetching hadiths: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch all hadiths for a collection (paginated)
  Future<void> fetchAllHadiths(
    HadithCollection collection, {
    int page = 1,
    int limit = 50,
  }) async {
    _isLoading = true;
    _error = null;
    _currentCollection = collection;
    _currentChapter = null;
    if (page == 1) {
      _currentHadiths = [];
    }
    notifyListeners();

    try {
      final collectionId = collection.name;
      // For Hindi, we fetch English and translate to Hindi
      final langCode = _selectedLanguage == HadithLanguage.urdu ? 'urd' : 'eng';

      final start = (page - 1) * limit + 1;
      final end = page * limit;

      // Fetch hadiths
      final response = await http.get(
        Uri.parse(
          '$_hadithApiUrl/editions/$langCode-$collectionId/$start-$end.json',
        ),
      );

      // Also fetch Arabic text
      final arabicResponse = await http.get(
        Uri.parse('$_hadithApiUrl/editions/ara-$collectionId/$start-$end.json'),
      );

      Map<String, String> arabicTexts = {};
      if (arabicResponse.statusCode == 200) {
        final arabicData = json.decode(arabicResponse.body);
        if (arabicData['hadiths'] != null) {
          for (var hadith in arabicData['hadiths']) {
            final hadithNum = hadith['hadithnumber'];
            if (hadithNum != null) {
              arabicTexts[hadithNum.toString()] = hadith['text'] ?? '';
            }
          }
        }
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['hadiths'] != null) {
          final newHadiths = (data['hadiths'] as List).map((hadith) {
            final hadithNum = hadith['hadithnumber'] ?? 0;
            final text = hadith['text'] ?? '';

            // Safely extract grade
            String grade = '';
            final grades = hadith['grades'];
            if (grades != null && grades is List && grades.isNotEmpty) {
              final firstGrade = grades[0];
              if (firstGrade is Map) {
                grade = firstGrade['grade']?.toString() ?? '';
              }
            }

            final hadithNumInt = hadithNum is int
                ? hadithNum
                : int.tryParse(hadithNum.toString()) ?? 0;

            return HadithModel(
              id: hadithNumInt,
              hadithNumber: hadithNum.toString(),
              arabic: arabicTexts[hadithNum.toString()] ?? '',
              english:
                  (_selectedLanguage == HadithLanguage.english ||
                      _selectedLanguage == HadithLanguage.hindi)
                  ? text
                  : '',
              urdu: _selectedLanguage == HadithLanguage.urdu ? text : '',
              narrator: _extractNarrator(text),
              grade: grade,
              reference:
                  '${getCollectionName(collection, 'en')}, Hadith $hadithNum',
              isFavorite: _favorites.contains('$collectionId:$hadithNum'),
            );
          }).toList();

          _currentHadiths.addAll(newHadiths);
        }
      } else {
        _error = 'Failed to fetch hadiths';
      }
    } catch (e) {
      _error = 'Network error: $e';
      debugPrint('Error fetching hadiths: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Extract narrator from hadith text
  String _extractNarrator(String text) {
    if (text.isEmpty) return '';

    try {
      // Common patterns for narrator extraction
      final patterns = [
        RegExp(r'^Narrated\s+([^:]+):', caseSensitive: false),
        RegExp(r"^It was narrated from\s+([^:]+):", caseSensitive: false),
        RegExp(r"^It was narrated that\s+([^:]+)", caseSensitive: false),
      ];

      for (var pattern in patterns) {
        final match = pattern.firstMatch(text);
        if (match != null && match.groupCount >= 1) {
          final narrator = match.group(1);
          if (narrator != null) {
            return narrator.trim();
          }
        }
      }

      // Check for Abu pattern separately (no capturing group)
      final abuPattern = RegExp(
        r'^(Abu\s+\w+)\s+reported:',
        caseSensitive: false,
      );
      final abuMatch = abuPattern.firstMatch(text);
      if (abuMatch != null && abuMatch.groupCount >= 1) {
        final narrator = abuMatch.group(1);
        if (narrator != null) {
          return narrator.trim();
        }
      }
    } catch (e) {
      debugPrint('Error extracting narrator: $e');
    }

    return '';
  }

  // Toggle favorite
  Future<void> toggleFavorite(
    HadithCollection collection,
    String hadithNumber,
  ) async {
    final collectionId = collection.name;
    final key = '$collectionId:$hadithNumber';

    if (_favorites.contains(key)) {
      _favorites.remove(key);
    } else {
      _favorites.add(key);
    }

    // Update current hadiths list
    _currentHadiths = _currentHadiths.map((h) {
      if (h.hadithNumber == hadithNumber) {
        return h.copyWith(isFavorite: _favorites.contains(key));
      }
      return h;
    }).toList();

    notifyListeners();

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(_favorites.toList()));
  }

  // Check if hadith is favorite
  bool isFavorite(HadithCollection collection, String hadithNumber) {
    final collectionId = collection.name;
    return _favorites.contains('$collectionId:$hadithNumber');
  }

  // Search hadiths
  List<HadithModel> searchHadiths(String query) {
    if (query.isEmpty) return _currentHadiths;

    final lowerQuery = query.toLowerCase();
    return _currentHadiths.where((hadith) {
      return hadith.english.toLowerCase().contains(lowerQuery) ||
          hadith.arabic.contains(query) ||
          hadith.urdu.contains(query) ||
          hadith.narrator.toLowerCase().contains(lowerQuery) ||
          hadith.hadithNumber.contains(query);
    }).toList();
  }

  // Clear current data
  void clear() {
    _currentHadiths = [];
    _chapters = [];
    _currentCollection = null;
    _currentChapter = null;
    _error = null;
    notifyListeners();
  }
}

// Chapter info class
class HadithChapterInfo {
  final int id;
  final String name;
  final String arabicName;

  HadithChapterInfo({
    required this.id,
    required this.name,
    required this.arabicName,
  });
}

