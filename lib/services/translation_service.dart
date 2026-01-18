import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Translation service using free Google Translate API
class TranslationService {
  // Free Google Translate API (no API key required)
  static const String _baseUrl = 'https://translate.googleapis.com/translate_a/single';

  /// Translate text from source language to target language
  /// Uses free Google Translate API
  static Future<String> translate({
    required String text,
    required String from,
    required String to,
  }) async {
    if (text.isEmpty) return '';

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'client': 'gtx',
        'sl': from,
        'tl': to,
        'dt': 't',
        'q': text,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Response format: [[["translated text","original text",null,null,10]],null,"en",...]
        if (data is List && data.isNotEmpty && data[0] is List) {
          final StringBuffer translatedText = StringBuffer();
          for (var segment in data[0]) {
            if (segment is List && segment.isNotEmpty) {
              translatedText.write(segment[0] ?? '');
            }
          }
          return translatedText.toString();
        }
      }
      return text; // Return original if translation fails
    } catch (e) {
      debugPrint('Translation error: $e');
      return text; // Return original text on error
    }
  }

  /// Translate English to Hindi
  static Future<String> translateToHindi(String englishText) async {
    return translate(text: englishText, from: 'en', to: 'hi');
  }

  /// Translate Urdu to Hindi
  static Future<String> translateUrduToHindi(String urduText) async {
    return translate(text: urduText, from: 'ur', to: 'hi');
  }

  /// Translate Arabic to Hindi
  static Future<String> translateArabicToHindi(String arabicText) async {
    return translate(text: arabicText, from: 'ar', to: 'hi');
  }
}
