import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

extension LocalizationExtension on BuildContext {
  /// Translate a key - listens to language changes for auto-refresh
  String tr(String key) {
    return Provider.of<LanguageProvider>(this, listen: true).translate(key);
  }

  /// Get language provider without listening (for one-time access)
  LanguageProvider get languageProvider =>
      Provider.of<LanguageProvider>(this, listen: false);

  /// Get language provider with listening (for reactive updates)
  LanguageProvider get watchLanguage =>
      Provider.of<LanguageProvider>(this, listen: true);
}
