import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/surah_model.dart';

// Language enum for Quran display
enum QuranLanguage { english, hindi, urdu, arabic }

class QuranProvider with ChangeNotifier {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _lastReadKey = 'last_read_surah';
  static const String _lastReadAyahKey = 'last_read_ayah';
  static const String _bookmarksKey = 'quran_bookmarks';
  static const String _languageKey = 'quran_language';

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

  // Language-specific translations
  static const Map<QuranLanguage, String> languageTranslations = {
    QuranLanguage.english: 'en.sahih',
    QuranLanguage.hindi: 'hi.hindi',
    QuranLanguage.urdu: 'ur.jalandhry',
    QuranLanguage.arabic: 'ar.jalalayn',
  };

  // Language display names
  static const Map<QuranLanguage, String> languageNames = {
    QuranLanguage.english: 'English',
    QuranLanguage.hindi: 'हिंदी',
    QuranLanguage.urdu: 'اردو',
    QuranLanguage.arabic: 'العربية',
  };

  // Available translations
  static const Map<String, String> translations = {
    'en.asad': 'Muhammad Asad',
    'en.pickthall': 'Pickthall',
    'en.yusufali': 'Yusuf Ali',
    'en.sahih': 'Sahih International',
    'ur.jalandhry': 'Fateh Muhammad Jalandhry',
    'ur.ahmedali': 'Ahmed Ali',
    'hi.hindi': 'Hindi',
    'ar.jalalayn': 'Tafsir al-Jalalayn',
  };

  // Available reciters
  static const Map<String, String> reciters = {
    'ar.alafasy': 'Mishary Alafasy',
    'ar.abdulbasit': 'Abdul Basit',
    'ar.abdurrahmaansudais': 'Abdur Rahman As-Sudais',
    'ar.hudhaify': 'Ali Al-Hudhaify',
    'ar.minshawi': 'Mohamed Siddiq Al-Minshawi',
  };

  Future<void> initialize() async {
    await _loadPreferences();
    _juzList = JuzInfo.getAllJuz();
    await fetchSurahList();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _lastReadSurah = prefs.getInt(_lastReadKey) ?? 1;
    _lastReadAyah = prefs.getInt(_lastReadAyahKey) ?? 1;

    // Load saved language
    final languageIndex = prefs.getInt(_languageKey) ?? 0;
    _selectedLanguage = QuranLanguage.values[languageIndex];
    _selectedTranslation = languageTranslations[_selectedLanguage]!;

    final bookmarksJson = prefs.getString(_bookmarksKey);
    if (bookmarksJson != null) {
      _bookmarks = Set<String>.from(json.decode(bookmarksJson));
    }

    notifyListeners();
  }

  Future<void> fetchSurahList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
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
    } catch (e) {
      _error = 'Network error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchJuz(int juzNumber) async {
    _isLoading = true;
    _error = null;
    _currentJuzAyahs = [];
    _currentJuzTranslation = [];
    _currentJuzTransliteration = [];
    notifyListeners();

    try {
      // Fetch Arabic text, translation, and transliteration in parallel
      final responses = await Future.wait([
        http.get(Uri.parse('$_baseUrl/juz/$juzNumber/ar.alafasy')),
        http.get(Uri.parse('$_baseUrl/juz/$juzNumber/$_selectedTranslation')),
        http.get(Uri.parse('$_baseUrl/juz/$juzNumber/en.transliteration')),
      ]);

      // Parse Arabic text
      if (responses[0].statusCode == 200) {
        final data = json.decode(responses[0].body);
        if (data['code'] == 200 && data['data'] != null) {
          final ayahsData = data['data']['ayahs'] as List;
          _currentJuzAyahs = ayahsData.map((ayah) => AyahModel.fromJson(ayah)).toList();
        }
      }

      // Parse translation
      if (responses[1].statusCode == 200) {
        final data = json.decode(responses[1].body);
        if (data['code'] == 200 && data['data'] != null) {
          final ayahsData = data['data']['ayahs'] as List;
          _currentJuzTranslation = ayahsData.map((ayah) => AyahModel.fromJson(ayah)).toList();
        }
      }

      // Parse transliteration
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

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSurah(int surahNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

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
        fetchTranslation(surahNumber),
        fetchTransliteration(surahNumber),
      ]);
    } catch (e) {
      _error = 'Failed to fetch surah: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTranslation(int surahNumber) async {
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
      notifyListeners();
    } catch (e) {
      // Translation fetch failed, continue without translation
    }
  }

  Future<void> fetchTransliteration(int surahNumber) async {
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
      notifyListeners();
    } catch (e) {
      // Transliteration fetch failed, continue without transliteration
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

  Future<void> setLanguage(QuranLanguage language) async {
    _selectedLanguage = language;
    _selectedTranslation = languageTranslations[language]!;

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
