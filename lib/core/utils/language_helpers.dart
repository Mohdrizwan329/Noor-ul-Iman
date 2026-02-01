import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

/// Utility class for language-related helper functions.
/// Centralizes language switching, font selection, and RTL detection.
///
/// Example usage:
/// ```dart
/// // Get localized text
/// final text = LanguageHelpers.getLocalizedText(
///   context,
///   arabic: 'مرحبا',
///   urdu: 'ہیلو',
///   english: 'Hello',
/// );
///
/// // Get font family
/// final font = LanguageHelpers.getFontFamily('ar'); // Returns 'Poppins'
///
/// // Check if RTL
/// final isRtl = LanguageHelpers.isRTL('ur'); // Returns true
/// ```
class LanguageHelpers {
  /// Get localized text based on current app language
  ///
  /// Parameters:
  /// - context: BuildContext to access LanguageProvider
  /// - arabic: Arabic text
  /// - urdu: Urdu text
  /// - hindi: Hindi text
  /// - english: English text (fallback)
  ///
  /// Returns the text in the current language, falling back to English if not available
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
  ///
  /// Returns 'Poppins' for all languages to maintain consistent UI
  static String getFontFamily(String languageCode) {
    // Use Poppins font for all languages (English, Urdu, Arabic, Hindi)
    return 'Poppins';
  }

  /// Check if a language uses Right-to-Left (RTL) text direction
  ///
  /// RTL languages: Arabic, Urdu
  /// LTR languages: English, Hindi, and others
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
  ///
  /// Returns consistent line height for Poppins font
  static double getLineHeight(String languageCode) {
    // Use standard line height for Poppins font across all languages
    return 1.5;
  }

  /// Get language name in the current app language
  ///
  /// Returns localized name of the language.
  /// For example, if app is in English: 'Arabic', 'Urdu', etc.
  /// If app is in Urdu: 'عربی', 'اردو', etc.
  static String getLanguageName(BuildContext context, String languageCode) {
    final currentLang = context.read<LanguageProvider>().languageCode;

    // Language names in different languages
    final names = <String, Map<String, String>>{
      'ar': {'en': 'Arabic', 'ur': 'عربی', 'hi': 'अरबी', 'ar': 'العربية'},
      'ur': {'en': 'Urdu', 'ur': 'اردو', 'hi': 'उर्दू', 'ar': 'الأردية'},
      'hi': {'en': 'Hindi', 'ur': 'ہندی', 'hi': 'हिन्दी', 'ar': 'الهندية'},
      'en': {
        'en': 'English',
        'ur': 'انگریزی',
        'hi': 'अंग्रेज़ी',
        'ar': 'الإنجليزية',
      },
    };

    return names[languageCode]?[currentLang] ?? languageCode.toUpperCase();
  }

  /// Get language code from language name
  /// Useful for reverse lookup
  static String? getLanguageCode(String languageName) {
    final normalized = languageName.toLowerCase().trim();

    switch (normalized) {
      case 'arabic':
      case 'العربية':
      case 'عربی':
        return 'ar';
      case 'urdu':
      case 'اردو':
        return 'ur';
      case 'hindi':
      case 'हिन्दी':
      case 'ہندی':
        return 'hi';
      case 'english':
      case 'انگریزی':
      case 'अंग्रेज़ी':
        return 'en';
      default:
        return null;
    }
  }

  /// Format text with proper styling for the language
  ///
  /// Returns a TextStyle with appropriate font family, line height, and direction
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
  ///
  /// Parameters:
  /// - context: BuildContext to access LanguageProvider
  /// - translationKey: The translation key to check (e.g., 'quran', 'duas')
  /// - query: The search query to match against
  ///
  /// Returns true if the translation in any of the 4 languages contains the query
  static bool matchesInAnyLanguage(
    BuildContext context,
    String translationKey,
    String query,
  ) {
    if (query.isEmpty) return true;

    final langProvider = context.read<LanguageProvider>();
    final normalizedQuery = query.toLowerCase().trim();

    // Get translations in all 4 languages
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
