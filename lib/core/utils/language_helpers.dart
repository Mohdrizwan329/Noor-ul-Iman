import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

/// Hardcoded language name translations
const Map<String, Map<String, String>> _languageNames = {
  'ar': {'en': 'Arabic', 'ur': 'عربی', 'hi': 'अरबी', 'ar': 'العربية'},
  'ur': {'en': 'Urdu', 'ur': 'اردو', 'hi': 'उर्दू', 'ar': 'الأردية'},
  'hi': {'en': 'Hindi', 'ur': 'ہندی', 'hi': 'हिन्दी', 'ar': 'الهندية'},
  'en': {'en': 'English', 'ur': 'انگریزی', 'hi': 'अंग्रेज़ी', 'ar': 'الإنجليزية'},
};

/// Export hardcoded language names for Firestore migration
Map<String, dynamic> getHardcodedLanguageNames() {
  return Map<String, dynamic>.from(_languageNames);
}

/// Utility class for language-related helper functions.
/// Centralizes language switching, font selection, and RTL detection.
class LanguageHelpers {
  // Firestore-loaded language names
  static Map<String, Map<String, String>>? _firestoreLanguageNames;

  /// Load language names from Firestore data
  static void loadFromFirestore(Map<String, dynamic> data) {
    _firestoreLanguageNames = {};
    data.forEach((key, value) {
      if (value is Map) {
        _firestoreLanguageNames![key] = Map<String, String>.from(value);
      }
    });
  }

  /// Get localized text based on current app language
  static String getLocalizedText(
    BuildContext context, {
    String? arabic,
    String? urdu,
    String? hindi,
    String? english,
  }) {
    final langProvider = context.read<LanguageProvider>();
    final langCode = langProvider.languageCode;

    switch (langCode) {
      case 'ar':
        return arabic ?? english ?? '';
      case 'ur':
        return urdu ?? english ?? '';
      case 'hi':
        return hindi ?? english ?? '';
      case 'en':
      default:
        return english ?? '';
    }
  }

  /// Get the appropriate font family for a given language code
  static String getFontFamily(String languageCode) {
    return 'Poppins';
  }

  /// Check if a language uses Right-to-Left (RTL) text direction
  static bool isRTL(String languageCode) {
    return languageCode.toLowerCase() == 'ar' ||
        languageCode.toLowerCase() == 'arabic' ||
        languageCode.toLowerCase() == 'ur' ||
        languageCode.toLowerCase() == 'urdu';
  }

  /// Get text direction (RTL or LTR) for a language
  static TextDirection getTextDirection(String languageCode) {
    return isRTL(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get optimal line height for a language
  static double getLineHeight(String languageCode) {
    return 1.5;
  }

  /// Get language name in the current app language
  static String getLanguageName(BuildContext context, String languageCode) {
    final currentLang = context.read<LanguageProvider>().languageCode;
    final names = _firestoreLanguageNames ?? _languageNames;
    return names[languageCode]?[currentLang] ?? languageCode.toUpperCase();
  }

  /// Get language code from language name
  static String? getLanguageCode(String languageName) {
    final normalized = languageName.toLowerCase().trim();
    final names = _firestoreLanguageNames ?? _languageNames;

    // Check all language names across all locales
    for (final entry in names.entries) {
      for (final nameEntry in entry.value.values) {
        if (nameEntry.toLowerCase() == normalized) {
          return entry.key;
        }
      }
    }
    return null;
  }

  /// Format text with proper styling for the language
  static TextStyle getStyledTextForLanguage(
    String languageCode, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(languageCode),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: getLineHeight(languageCode),
    );
  }

  /// Get all supported languages with their codes
  static Map<String, String> getSupportedLanguages(BuildContext context) {
    return {
      'en': getLanguageName(context, 'en'),
      'ur': getLanguageName(context, 'ur'),
      'hi': getLanguageName(context, 'hi'),
      'ar': getLanguageName(context, 'ar'),
    };
  }

  /// Check if a translation key matches a search query in any language
  static bool matchesInAnyLanguage(
    BuildContext context,
    String translationKey,
    String query,
  ) {
    if (query.isEmpty) return true;

    final langProvider = context.read<LanguageProvider>();
    final normalizedQuery = query.toLowerCase().trim();

    final languages = ['en', 'ur', 'ar', 'hi'];

    for (final lang in languages) {
      final translation = langProvider.getTranslationForLanguage(lang, translationKey);
      if (translation.toLowerCase().contains(normalizedQuery)) {
        return true;
      }
    }

    return false;
  }
}
