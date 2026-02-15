import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/surah_model.dart';
import '../data/models/firestore_models.dart';
import '../core/services/content_service.dart';

// Language enum for Quran display
enum QuranLanguage { english, hindi, urdu, arabic }

class QuranProvider with ChangeNotifier {
  static const String _lastReadKey = 'last_read_surah';
  static const String _lastReadAyahKey = 'last_read_ayah';
  static const String _bookmarksKey = 'quran_bookmarks';
  static const String _languageKey = 'quran_language';

  // Fallback API URL (used only when Firebase data is not available)
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  // Standard ayah counts per surah (index 0 = Surah 1)
  static const List<int> _surahAyahCounts = [
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109,     // 1-10
    123, 111, 43, 52, 99, 128, 111, 110, 98, 135,       // 11-20
    112, 78, 118, 64, 77, 227, 93, 88, 69, 60,          // 21-30
    34, 30, 73, 54, 45, 83, 182, 88, 75, 85,            // 31-40
    54, 53, 89, 59, 37, 35, 38, 29, 18, 45,             // 41-50
    60, 49, 62, 55, 78, 96, 29, 22, 24, 13,             // 51-60
    14, 11, 11, 18, 12, 12, 30, 52, 52, 44,             // 61-70
    28, 28, 20, 56, 40, 31, 50, 40, 46, 42,             // 71-80
    29, 19, 36, 25, 22, 17, 19, 26, 30, 20,             // 81-90
    15, 21, 11, 8, 8, 19, 5, 8, 8, 11,                  // 91-100
    11, 8, 3, 9, 5, 4, 7, 3, 6, 3,                      // 101-110
    5, 4, 5, 6,                                           // 111-114
  ];

  final ContentService _contentService = ContentService();

  List<SurahInfo> _surahList = [];
  List<JuzInfo> _juzList = [];
  SurahModel? _currentSurah;
  List<AyahModel> _currentJuzAyahs = [];
  List<AyahModel> _currentJuzTranslation = [];
  List<AyahModel> _currentJuzTransliteration = [];
  List<AyahModel> _currentTranslation = [];
  List<AyahModel> _currentTransliteration = [];
  bool _isLoading = false;
  String? _error;
  int _lastReadSurah = 1;
  int _lastReadAyah = 1;
  Set<String> _bookmarks = {}; // Format: "surahNumber:ayahNumber"
  String _selectedReciter = 'ar.alafasy';
  String _selectedTranslation = 'en.sahih';
  bool _showTransliteration = true;
  QuranLanguage _selectedLanguage = QuranLanguage.english;

  // Firebase-loaded config
  QuranScreenContentFirestore? _quranContent;

  // Getters
  List<SurahInfo> get surahList => _surahList;
  List<JuzInfo> get juzList => _juzList;
  SurahModel? get currentSurah => _currentSurah;
  List<AyahModel> get currentJuzAyahs => _currentJuzAyahs;
  List<AyahModel> get currentJuzTranslation => _currentJuzTranslation;
  List<AyahModel> get currentJuzTransliteration => _currentJuzTransliteration;
  List<AyahModel> get currentTranslation => _currentTranslation;
  List<AyahModel> get currentTransliteration => _currentTransliteration;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get lastReadSurah => _lastReadSurah;
  int get lastReadAyah => _lastReadAyah;
  Set<String> get bookmarks => _bookmarks;
  String get selectedReciter => _selectedReciter;
  String get selectedTranslation => _selectedTranslation;
  bool get showTransliteration => _showTransliteration;
  QuranLanguage get selectedLanguage => _selectedLanguage;
  QuranScreenContentFirestore? get quranContent => _quranContent;

  // Get language display names from Firebase
  Map<QuranLanguage, String> getLanguageNames(String langCode) {
    if (_quranContent == null) return {};
    return {
      for (final lang in QuranLanguage.values)
        lang: _quranContent!.getLanguageDisplayName(lang.name, langCode),
    };
  }

  // Get available translations from Firebase as Map<id, name>
  Map<String, String> getTranslations(String langCode) {
    if (_quranContent == null) return {};
    return {
      for (final t in _quranContent!.availableTranslations)
        t.id: t.name.get(langCode),
    };
  }

  // Get available reciters from Firebase as Map<id, name>
  Map<String, String> getReciters(String langCode) {
    if (_quranContent == null) return {};
    return {
      for (final r in _quranContent!.availableReciters)
        r.id: r.name.get(langCode),
    };
  }

  // Get translation ID for a language
  String _getTranslationId(QuranLanguage language) {
    if (_quranContent != null) {
      return _quranContent!.getTranslationId(language.name);
    }
    return 'en.sahih';
  }

  /// Get language code from QuranLanguage enum
  String _langCodeFromLanguage(QuranLanguage language) {
    switch (language) {
      case QuranLanguage.hindi:
        return 'hi';
      case QuranLanguage.urdu:
        return 'ur';
      case QuranLanguage.arabic:
        return 'ar';
      default:
        return 'en';
    }
  }

  Future<void> initialize() async {
    await _loadFirebaseContent();
    await _loadPreferences();
    await fetchSurahList();
  }

  Future<void> _loadFirebaseContent() async {
    final content = await _contentService.getQuranScreenContent();
    if (content != null) {
      _quranContent = content;

      // Load juz data from Firebase
      if (content.juzData.isNotEmpty) {
        _juzList = content.juzData
            .map((e) => JuzInfo(
                  number: e.number,
                  arabicName: e.arabicName,
                  startSurah: e.startSurah,
                  startAyah: e.startAyah,
                  endSurah: e.endSurah,
                  endAyah: e.endAyah,
                ))
            .toList();
      }

      // Load surah list from Firebase metadata
      if (content.surahNames.isNotEmpty) {
        _surahList = content.surahNames
            .map((e) => SurahInfo(
                  number: e.number,
                  name: e.name.get('ar'),
                  englishName: e.name.get('en'),
                  englishNameTranslation: e.englishNameTranslation.get('en'),
                  numberOfAyahs: e.numberOfAyahs > 0
                      ? e.numberOfAyahs
                      : (e.number >= 1 && e.number <= 114
                          ? _surahAyahCounts[e.number - 1]
                          : 0),
                  revelationType: e.revelationType,
                ))
            .toList();
      }
    }
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _lastReadSurah = prefs.getInt(_lastReadKey) ?? 1;
    _lastReadAyah = prefs.getInt(_lastReadAyahKey) ?? 1;

    // Load saved language
    final languageIndex = prefs.getInt(_languageKey) ?? 0;
    _selectedLanguage = QuranLanguage.values[languageIndex];
    _selectedTranslation = _getTranslationId(_selectedLanguage);

    final bookmarksJson = prefs.getString(_bookmarksKey);
    if (bookmarksJson != null) {
      _bookmarks = Set<String>.from(json.decode(bookmarksJson));
    }

    notifyListeners();
  }

  /// Fetch surah list - loads from Firebase first, falls back to API
  Future<void> fetchSurahList() async {
    // If already loaded from Firebase, skip
    if (_surahList.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try loading from Firebase content (already done in _loadFirebaseContent)
      if (_surahList.isEmpty && _quranContent != null && _quranContent!.surahNames.isNotEmpty) {
        _surahList = _quranContent!.surahNames
            .map((e) => SurahInfo(
                  number: e.number,
                  name: e.name.get('ar'),
                  englishName: e.name.get('en'),
                  englishNameTranslation: e.englishNameTranslation.get('en'),
                  numberOfAyahs: e.numberOfAyahs > 0
                      ? e.numberOfAyahs
                      : (e.number >= 1 && e.number <= 114
                          ? _surahAyahCounts[e.number - 1]
                          : 0),
                  revelationType: e.revelationType,
                ))
            .toList();
      }

      // Fallback to API if Firebase data not available
      if (_surahList.isEmpty) {
        final response = await http.get(Uri.parse('$_baseUrl/surah'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['code'] == 200 && data['data'] != null) {
            _surahList = (data['data'] as List)
                .map((surah) => SurahInfo.fromJson(surah))
                .toList();
          }
        } else {
          _error = 'Failed to fetch surah list';
        }
      }
    } catch (e) {
      _error = 'Network error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch surah content - loads from Firebase first, falls back to API
  Future<void> fetchSurah(int surahNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try Firebase first
      final firebaseSurah = await _contentService.getSurahContent(surahNumber);

      if (firebaseSurah != null && firebaseSurah.ayahs.isNotEmpty) {
        // Build SurahModel from Firebase data
        final langCode = _langCodeFromLanguage(_selectedLanguage);

        _currentSurah = SurahModel(
          number: firebaseSurah.number,
          name: firebaseSurah.name.get('ar'),
          englishName: firebaseSurah.name.get('en'),
          englishNameTranslation: firebaseSurah.englishNameTranslation.get('en'),
          numberOfAyahs: firebaseSurah.numberOfAyahs,
          revelationType: firebaseSurah.revelationType,
          ayahs: firebaseSurah.ayahs
              .map((a) => AyahModel(
                    number: a.number,
                    numberInSurah: a.numberInSurah,
                    text: a.arabicText,
                    juz: a.juz,
                    page: a.page,
                    hizbQuarter: a.hizbQuarter,
                    sajda: a.sajda,
                  ))
              .toList(),
        );

        // Build translation from Firebase data
        _currentTranslation = firebaseSurah.ayahs
            .map((a) => AyahModel(
                  number: a.number,
                  numberInSurah: a.numberInSurah,
                  text: a.translation.get(langCode),
                  juz: a.juz,
                  page: a.page,
                  hizbQuarter: a.hizbQuarter,
                ))
            .toList();

        // Build transliteration from Firebase data
        _currentTransliteration = firebaseSurah.ayahs
            .map((a) => AyahModel(
                  number: a.number,
                  numberInSurah: a.numberInSurah,
                  text: a.transliteration,
                  juz: a.juz,
                  page: a.page,
                  hizbQuarter: a.hizbQuarter,
                ))
            .toList();
      } else {
        // Fallback to API
        await _fetchSurahFromApi(surahNumber);
      }
    } catch (e) {
      debugPrint('Firebase surah fetch failed, falling back to API: $e');
      await _fetchSurahFromApi(surahNumber);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fallback: fetch surah from external API
  Future<void> _fetchSurahFromApi(int surahNumber) async {
    try {
      // Fetch Arabic text
      final arabicResponse = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/ar.alafasy'),
      );

      if (arabicResponse.statusCode == 200) {
        final data = json.decode(arabicResponse.body);
        if (data['code'] == 200 && data['data'] != null) {
          _currentSurah = SurahModel.fromJson(data['data']);
        }
      }

      // Fetch translation and transliteration
      await Future.wait([
        _fetchTranslationFromApi(surahNumber),
        _fetchTransliterationFromApi(surahNumber),
      ]);
    } catch (e) {
      _error = 'Failed to fetch surah: $e';
    }
  }

  Future<void> _fetchTranslationFromApi(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/$_selectedTranslation'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          final surahData = data['data'];
          if (surahData['ayahs'] != null) {
            _currentTranslation = (surahData['ayahs'] as List)
                .map((ayah) => AyahModel.fromJson(ayah))
                .toList();
          }
        }
      }
    } catch (e) {
      // Translation fetch failed, continue without translation
    }
  }

  Future<void> _fetchTransliterationFromApi(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/en.transliteration'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          final surahData = data['data'];
          if (surahData['ayahs'] != null) {
            _currentTransliteration = (surahData['ayahs'] as List)
                .map((ayah) => AyahModel.fromJson(ayah))
                .toList();
          }
        }
      }
    } catch (e) {
      // Transliteration fetch failed, continue without transliteration
    }
  }

  /// Fetch juz - loads from Firebase surah data, falls back to API
  Future<void> fetchJuz(int juzNumber) async {
    _isLoading = true;
    _error = null;
    _currentJuzAyahs = [];
    _currentJuzTranslation = [];
    _currentJuzTransliteration = [];
    notifyListeners();

    try {
      // Find which surahs are in this juz from Firebase juz data
      final juzInfo = _juzList.isNotEmpty
          ? _juzList.firstWhere((j) => j.number == juzNumber, orElse: () => _juzList.first)
          : null;

      bool loadedFromFirebase = false;

      if (juzInfo != null) {
        final langCode = _langCodeFromLanguage(_selectedLanguage);
        final List<AyahModel> arabicAyahs = [];
        final List<AyahModel> translationAyahs = [];
        final List<AyahModel> transliterationAyahs = [];

        // Fetch each surah that belongs to this juz
        for (int surahNum = juzInfo.startSurah; surahNum <= juzInfo.endSurah; surahNum++) {
          final surahContent = await _contentService.getSurahContent(surahNum);
          if (surahContent == null || surahContent.ayahs.isEmpty) {
            // If any surah fails from Firebase, fallback to API
            loadedFromFirebase = false;
            break;
          }

          for (final ayah in surahContent.ayahs) {
            if (ayah.juz == juzNumber) {
              arabicAyahs.add(AyahModel(
                number: ayah.number,
                numberInSurah: ayah.numberInSurah,
                text: ayah.arabicText,
                juz: ayah.juz,
                page: ayah.page,
                hizbQuarter: ayah.hizbQuarter,
                sajda: ayah.sajda,
                surahNumber: surahContent.number,
                surahName: surahContent.name.get('ar'),
                surahEnglishName: surahContent.name.get('en'),
              ));
              translationAyahs.add(AyahModel(
                number: ayah.number,
                numberInSurah: ayah.numberInSurah,
                text: ayah.translation.get(langCode),
                juz: ayah.juz,
                page: ayah.page,
                hizbQuarter: ayah.hizbQuarter,
                surahNumber: surahContent.number,
              ));
              transliterationAyahs.add(AyahModel(
                number: ayah.number,
                numberInSurah: ayah.numberInSurah,
                text: ayah.transliteration,
                juz: ayah.juz,
                page: ayah.page,
                hizbQuarter: ayah.hizbQuarter,
                surahNumber: surahContent.number,
              ));
            }
          }
          loadedFromFirebase = true;
        }

        if (loadedFromFirebase && arabicAyahs.isNotEmpty) {
          _currentJuzAyahs = arabicAyahs;
          _currentJuzTranslation = translationAyahs;
          _currentJuzTransliteration = transliterationAyahs;
        }
      }

      // Fallback to API if Firebase didn't work
      if (_currentJuzAyahs.isEmpty) {
        await _fetchJuzFromApi(juzNumber);
      }
    } catch (e) {
      debugPrint('Firebase juz fetch failed, falling back to API: $e');
      await _fetchJuzFromApi(juzNumber);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fallback: fetch juz from external API
  Future<void> _fetchJuzFromApi(int juzNumber) async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('$_baseUrl/juz/$juzNumber/ar.alafasy')),
        http.get(Uri.parse('$_baseUrl/juz/$juzNumber/$_selectedTranslation')),
        http.get(Uri.parse('$_baseUrl/juz/$juzNumber/en.transliteration')),
      ]);

      if (responses[0].statusCode == 200) {
        final data = json.decode(responses[0].body);
        if (data['code'] == 200 && data['data'] != null) {
          final ayahsData = data['data']['ayahs'] as List;
          _currentJuzAyahs = ayahsData.map((ayah) => AyahModel.fromJson(ayah)).toList();
        }
      }

      if (responses[1].statusCode == 200) {
        final data = json.decode(responses[1].body);
        if (data['code'] == 200 && data['data'] != null) {
          final ayahsData = data['data']['ayahs'] as List;
          _currentJuzTranslation = ayahsData.map((ayah) => AyahModel.fromJson(ayah)).toList();
        }
      }

      if (responses[2].statusCode == 200) {
        final data = json.decode(responses[2].body);
        if (data['code'] == 200 && data['data'] != null) {
          final ayahsData = data['data']['ayahs'] as List;
          _currentJuzTransliteration = ayahsData.map((ayah) => AyahModel.fromJson(ayah)).toList();
        }
      }
    } catch (e) {
      _error = 'Failed to fetch juz: $e';
    }
  }

  /// Re-fetch translation for current surah when language changes
  Future<void> fetchTranslation(int surahNumber) async {
    try {
      // Try Firebase first
      final firebaseSurah = await _contentService.getSurahContent(surahNumber);
      if (firebaseSurah != null && firebaseSurah.ayahs.isNotEmpty) {
        final langCode = _langCodeFromLanguage(_selectedLanguage);
        _currentTranslation = firebaseSurah.ayahs
            .map((a) => AyahModel(
                  number: a.number,
                  numberInSurah: a.numberInSurah,
                  text: a.translation.get(langCode),
                  juz: a.juz,
                  page: a.page,
                  hizbQuarter: a.hizbQuarter,
                ))
            .toList();
        notifyListeners();
        return;
      }

      // Fallback to API
      await _fetchTranslationFromApi(surahNumber);
      notifyListeners();
    } catch (e) {
      await _fetchTranslationFromApi(surahNumber);
      notifyListeners();
    }
  }

  /// Re-fetch transliteration for current surah
  Future<void> fetchTransliteration(int surahNumber) async {
    try {
      // Try Firebase first
      final firebaseSurah = await _contentService.getSurahContent(surahNumber);
      if (firebaseSurah != null && firebaseSurah.ayahs.isNotEmpty) {
        _currentTransliteration = firebaseSurah.ayahs
            .map((a) => AyahModel(
                  number: a.number,
                  numberInSurah: a.numberInSurah,
                  text: a.transliteration,
                  juz: a.juz,
                  page: a.page,
                  hizbQuarter: a.hizbQuarter,
                ))
            .toList();
        notifyListeners();
        return;
      }

      // Fallback to API
      await _fetchTransliterationFromApi(surahNumber);
      notifyListeners();
    } catch (e) {
      await _fetchTransliterationFromApi(surahNumber);
      notifyListeners();
    }
  }

  void setShowTransliteration(bool show) {
    _showTransliteration = show;
    notifyListeners();
  }

  Future<void> setLastRead(int surahNumber, int ayahNumber) async {
    _lastReadSurah = surahNumber;
    _lastReadAyah = ayahNumber;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadKey, surahNumber);
    await prefs.setInt(_lastReadAyahKey, ayahNumber);

    notifyListeners();
  }

  Future<void> toggleBookmark(int surahNumber, int ayahNumber) async {
    final key = '$surahNumber:$ayahNumber';

    if (_bookmarks.contains(key)) {
      _bookmarks.remove(key);
    } else {
      _bookmarks.add(key);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bookmarksKey, json.encode(_bookmarks.toList()));

    notifyListeners();
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    return _bookmarks.contains('$surahNumber:$ayahNumber');
  }

  void setReciter(String reciter) {
    _selectedReciter = reciter;
    notifyListeners();
  }

  void setTranslation(String translation) {
    _selectedTranslation = translation;
    if (_currentSurah != null) {
      fetchTranslation(_currentSurah!.number);
    }
    notifyListeners();
  }

  /// Sync Quran language with app language code (if user hasn't explicitly set one)
  void syncWithAppLanguage(String appLangCode) {
    QuranLanguage mapped;
    switch (appLangCode) {
      case 'hi':
        mapped = QuranLanguage.hindi;
      case 'ur':
        mapped = QuranLanguage.urdu;
      case 'ar':
        mapped = QuranLanguage.arabic;
      default:
        mapped = QuranLanguage.english;
    }
    if (_selectedLanguage != mapped) {
      _selectedLanguage = mapped;
      _selectedTranslation = _getTranslationId(mapped);
      notifyListeners();
    }
  }

  Future<void> setLanguage(QuranLanguage language) async {
    _selectedLanguage = language;
    _selectedTranslation = _getTranslationId(language);

    // Notify immediately so UI updates
    notifyListeners();

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_languageKey, language.index);
  }

  String getAudioUrl(int surahNumber, int ayahNumber) {
    return 'https://cdn.islamic.network/quran/audio/128/$_selectedReciter/$ayahNumber.mp3';
  }

  List<SurahInfo> searchSurah(String query) {
    if (query.isEmpty) return _surahList;

    final lowerQuery = query.toLowerCase();
    return _surahList.where((surah) {
      return surah.englishName.toLowerCase().contains(lowerQuery) ||
          surah.englishNameTranslation.toLowerCase().contains(lowerQuery) ||
          surah.number.toString() == query;
    }).toList();
  }
}
