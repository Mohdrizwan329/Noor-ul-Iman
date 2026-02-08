import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  /// Always merges local JSON asset as base so new keys work immediately,
  /// with Firestore translations overriding.
  Future<void> loadTranslations() async {
    try {
      // 1. Load local JSON asset as base (always has latest keys)
      final localTranslations = await _loadLocalAssetTranslations();

      // 2. Load from ContentService (Firestore → Hive cache)
      final contentService = ContentService();
      final remoteTranslations = await contentService.getUITranslations();

      // 3. Merge: local JSON as base, remote overrides
      _translations = _mergeTranslations(localTranslations, remoteTranslations);

      _isTranslationsLoaded = _translations.isNotEmpty;
      notifyListeners();
      debugPrint(
          'Translations loaded: ${_translations.keys.length} languages, '
          '${_translations.values.fold<int>(0, (sum, m) => sum + m.length)} total keys');
    } catch (e) {
      debugPrint('Error loading translations: $e');
    }
  }

  /// Load translations from local JSON asset
  Future<Map<String, Map<String, String>>> _loadLocalAssetTranslations() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/ui_translations.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      // Handle "translations" wrapper if present
      final langData = jsonData.containsKey('translations')
          ? jsonData['translations'] as Map<String, dynamic>
          : jsonData;
      final result = <String, Map<String, String>>{};
      for (final lang in langData.keys) {
        final langMap = langData[lang] as Map<String, dynamic>;
        result[lang] = langMap.map((k, v) => MapEntry(k, v.toString()));
      }
      return result;
    } catch (e) {
      debugPrint('Error loading local translations: $e');
      return {};
    }
  }

  /// Merge two translation maps: base first, then override on top
  Map<String, Map<String, String>> _mergeTranslations(
    Map<String, Map<String, String>> base,
    Map<String, Map<String, String>> override,
  ) {
    final merged = <String, Map<String, String>>{};
    // Add all base keys
    for (final lang in base.keys) {
      merged[lang] = Map<String, String>.from(base[lang]!);
    }
    // Override with remote keys
    for (final lang in override.keys) {
      if (merged.containsKey(lang)) {
        merged[lang]!.addAll(override[lang]!);
      } else {
        merged[lang] = Map<String, String>.from(override[lang]!);
      }
    }
    return merged;
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
