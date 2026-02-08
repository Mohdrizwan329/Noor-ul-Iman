import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/content_service.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language
  static const String _languageKey = 'selected_language';
  bool _isInitialized = false;

  // Dynamic translations loaded from ContentService (Firebase/Hive/JSON)
  Map<String, Map<String, String>> _translations = {};
  bool _isTranslationsLoaded = false;

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  bool get isInitialized => _isInitialized;

  bool get isTranslationsLoaded => _isTranslationsLoaded;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        _locale = Locale(languageCode);
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Load translations from ContentService (Firebase → Hive cache → local JSON)
  /// Call once during app startup in main.dart
  Future<void> loadTranslations() async {
    try {
      final contentService = ContentService();
      _translations = await contentService.getUITranslations();
      _isTranslationsLoaded = _translations.isNotEmpty;
      notifyListeners();
      debugPrint(
          'Translations loaded: ${_translations.keys.length} languages, '
          '${_translations.values.fold<int>(0, (sum, m) => sum + m.length)} total keys');
    } catch (e) {
      debugPrint('Error loading translations: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      _locale = Locale(languageCode);
      debugPrint('Language changed to: $languageCode');
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  // Get translated text
  String translate(String key) {
    return _translations[_locale.languageCode]?[key] ?? key;
  }

  // Get translation for a specific language (useful for multi-language search)
  String getTranslationForLanguage(String languageCode, String key) {
    return _translations[languageCode]?[key] ?? key;
  }
}
