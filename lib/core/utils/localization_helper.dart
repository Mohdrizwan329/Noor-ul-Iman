import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return Provider.of<LanguageProvider>(this, listen: false).translate(key);
  }

  LanguageProvider get languageProvider =>
      Provider.of<LanguageProvider>(this, listen: false);
}
