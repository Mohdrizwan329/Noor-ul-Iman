import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/hadith_model.dart';
import '../services/translation_service.dart';

// Hadith Language enum
enum HadithLanguage { english, urdu, hindi }

// Hadith Collection enum
enum HadithCollection {
  bukhari,
  muslim,
  nasai,
  abudawud,
  tirmidhi,
  ibnmajah,
}

class HadithProvider with ChangeNotifier {
  // API base URLs
  static const String _hadithApiUrl = 'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1';

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

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  HadithLanguage get selectedLanguage => _selectedLanguage;
  Set<String> get favorites => _favorites;
  List<HadithChapterInfo> get chapters => _chapters;
  List<HadithModel> get currentHadiths => _currentHadiths;
  HadithCollection? get currentCollection => _currentCollection;
  int? get currentChapter => _currentChapter;

  // Collection info
  static const Map<HadithCollection, HadithCollectionInfo> collectionInfo = {
    HadithCollection.bukhari: HadithCollectionInfo(
      id: 'bukhari',
      name: 'Sahih al-Bukhari',
      arabicName: 'صحيح البخاري',
      compiler: 'Imam Muhammad al-Bukhari',
      compilerArabic: 'الإمام محمد البخاري',
      totalHadith: 7563,
      totalBooks: 96,
      description: 'Sahih al-Bukhari is considered the most authentic collection of Hadith. Imam Bukhari spent 16 years compiling it.',
    ),
    HadithCollection.muslim: HadithCollectionInfo(
      id: 'muslim',
      name: 'Sahih Muslim',
      arabicName: 'صحيح مسلم',
      compiler: 'Imam Muslim ibn al-Hajjaj',
      compilerArabic: 'الإمام مسلم بن الحجاج',
      totalHadith: 7500,
      totalBooks: 56,
      description: 'Sahih Muslim is the second most authentic collection of Hadith after Sahih Bukhari.',
    ),
    HadithCollection.nasai: HadithCollectionInfo(
      id: 'nasai',
      name: 'Sunan an-Nasai',
      arabicName: 'السنن الصغرى',
      compiler: 'Imam Ahmad an-Nasai',
      compilerArabic: 'الإمام أحمد النسائي',
      totalHadith: 5761,
      totalBooks: 38,
      description: 'Sunan an-Nasai is one of the Kutub al-Sittah (six major hadith collections).',
    ),
    HadithCollection.abudawud: HadithCollectionInfo(
      id: 'abudawud',
      name: 'Sunan Abu Dawud',
      arabicName: 'سنن أبي داود',
      compiler: 'Imam Abu Dawud',
      compilerArabic: 'الإمام أبو داود',
      totalHadith: 5274,
      totalBooks: 28,
      description: 'Sunan Abu Dawud is one of the six canonical hadith collections. It contains hadiths on a wide range of Islamic topics.',
    ),
    HadithCollection.tirmidhi: HadithCollectionInfo(
      id: 'tirmidhi',
      name: 'Jami at-Tirmidhi',
      arabicName: 'جامع الترمذي',
      compiler: 'Imam at-Tirmidhi',
      compilerArabic: 'الإمام الترمذي',
      totalHadith: 3956,
      totalBooks: 33,
      description: 'Jami at-Tirmidhi is one of the six major hadith collections, known for its unique classifications.',
    ),
    HadithCollection.ibnmajah: HadithCollectionInfo(
      id: 'ibnmajah',
      name: 'Sunan Ibn Majah',
      arabicName: 'سنن ابن ماجه',
      compiler: 'Imam Ibn Majah',
      compilerArabic: 'الإمام ابن ماجه',
      totalHadith: 4341,
      totalBooks: 37,
      description: 'Sunan Ibn Majah is one of the six major hadith collections.',
    ),
  };

  // Language names
  static const Map<HadithLanguage, String> languageNames = {
    HadithLanguage.english: 'English',
    HadithLanguage.urdu: 'اردو',
    HadithLanguage.hindi: 'हिंदी',
  };

  // Initialize
  Future<void> initialize() async {
    await _loadPreferences();
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
      final collectionId = collectionInfo[collection]!.id;
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
  Future<void> fetchChapterHadiths(HadithCollection collection, int chapter) async {
    _isLoading = true;
    _error = null;
    _currentCollection = collection;
    _currentChapter = chapter;
    _currentHadiths = [];
    notifyListeners();

    try {
      final collectionId = collectionInfo[collection]!.id;
      // For Hindi, we fetch English and translate to Hindi
      // For Urdu, we fetch Urdu directly
      final langCode = _selectedLanguage == HadithLanguage.urdu ? 'urd' : 'eng';

      final url = '$_hadithApiUrl/editions/$langCode-$collectionId/sections/$chapter.json';
      final arabicUrl = '$_hadithApiUrl/editions/ara-$collectionId/sections/$chapter.json';

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
                arabicTexts[hadithNum.toString()] = hadith['text']?.toString() ?? '';
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

                final hadithNumInt = hadithNum is int ? hadithNum : int.tryParse(hadithNum.toString()) ?? 0;

                hadithsList.add(HadithModel(
                  id: hadithNumInt,
                  hadithNumber: hadithNum.toString(),
                  arabic: arabicTexts[hadithNum.toString()] ?? '',
                  english: (_selectedLanguage == HadithLanguage.english || _selectedLanguage == HadithLanguage.hindi) ? text : '',
                  urdu: _selectedLanguage == HadithLanguage.urdu ? text : '',
                  narrator: _extractNarrator(text),
                  grade: grade,
                  reference: '${collectionInfo[collection]!.name}, Book $chapter, Hadith $hadithNum',
                  isFavorite: _favorites.contains('$collectionId:$hadithNum'),
                ));
              } catch (e) {
                debugPrint('Error parsing hadith: $e');
              }
            }

            // If Hindi is selected, translate English to Hindi
            if (_selectedLanguage == HadithLanguage.hindi) {
              _currentHadiths = hadithsList;
              notifyListeners();

              // Translate in background
              _translateHadithsToHindi(hadithsList);
            } else {
              _currentHadiths = hadithsList;
            }
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

  // Translate hadiths to Hindi in background
  Future<void> _translateHadithsToHindi(List<HadithModel> hadiths) async {
    for (final hadith in hadiths) {
      if (hadith.english.isNotEmpty && hadith.hindi.isEmpty) {
        try {
          final hindiText = await TranslationService.translateToHindi(hadith.english);
          // Find the hadith in current list by hadith number and update it
          final index = _currentHadiths.indexWhere((h) => h.hadithNumber == hadith.hadithNumber);
          if (index != -1 && index < _currentHadiths.length) {
            _currentHadiths[index] = _currentHadiths[index].copyWith(hindi: hindiText);
            notifyListeners();
          }
        } catch (e) {
          debugPrint('Hindi translation error for hadith ${hadith.hadithNumber}: $e');
        }
      }
    }
  }

  // Fetch all hadiths for a collection (paginated)
  Future<void> fetchAllHadiths(HadithCollection collection, {int page = 1, int limit = 50}) async {
    _isLoading = true;
    _error = null;
    _currentCollection = collection;
    _currentChapter = null;
    if (page == 1) {
      _currentHadiths = [];
    }
    notifyListeners();

    try {
      final collectionId = collectionInfo[collection]!.id;
      // For Hindi, we fetch English and translate to Hindi
      final langCode = _selectedLanguage == HadithLanguage.urdu ? 'urd' : 'eng';

      final start = (page - 1) * limit + 1;
      final end = page * limit;

      // Fetch hadiths
      final response = await http.get(
        Uri.parse('$_hadithApiUrl/editions/$langCode-$collectionId/$start-$end.json'),
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

            final hadithNumInt = hadithNum is int ? hadithNum : int.tryParse(hadithNum.toString()) ?? 0;

            return HadithModel(
              id: hadithNumInt,
              hadithNumber: hadithNum.toString(),
              arabic: arabicTexts[hadithNum.toString()] ?? '',
              english: (_selectedLanguage == HadithLanguage.english || _selectedLanguage == HadithLanguage.hindi) ? text : '',
              urdu: _selectedLanguage == HadithLanguage.urdu ? text : '',
              narrator: _extractNarrator(text),
              grade: grade,
              reference: '${collectionInfo[collection]!.name}, Hadith $hadithNum',
              isFavorite: _favorites.contains('$collectionId:$hadithNum'),
            );
          }).toList();

          _currentHadiths.addAll(newHadiths);

          // If Hindi is selected, translate in background
          if (_selectedLanguage == HadithLanguage.hindi) {
            _translateHadithsToHindi(newHadiths);
          }
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
      final abuPattern = RegExp(r'^(Abu\s+\w+)\s+reported:', caseSensitive: false);
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
  Future<void> toggleFavorite(HadithCollection collection, String hadithNumber) async {
    final collectionId = collectionInfo[collection]!.id;
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
    final collectionId = collectionInfo[collection]!.id;
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

// Collection info class
class HadithCollectionInfo {
  final String id;
  final String name;
  final String arabicName;
  final String compiler;
  final String compilerArabic;
  final int totalHadith;
  final int totalBooks;
  final String description;

  const HadithCollectionInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.compiler,
    required this.compilerArabic,
    required this.totalHadith,
    required this.totalBooks,
    required this.description,
  });
}
