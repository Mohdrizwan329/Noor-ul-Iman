import '../utils/localization_helper.dart';
import 'package:flutter/material.dart';

/// Translates hadith references from English format to the current language
/// Example: "Jami at-Tirmidhi, Book 4, Hadith 489" -> "جامع ترمذی، کتاب 4، حدیث 489"
String translateHadithReference(BuildContext context, String reference) {
  if (reference.isEmpty) return reference;

  // Map of English collection names to translation keys
  final collectionMap = {
    'Sahih Bukhari': 'sahih_bukhari',
    'Sahih Muslim': 'sahih_muslim',
    'Sunan Abu Dawud': 'sunan_abu_dawud',
    'Sunan Abu-Dawud': 'sunan_abu_dawud',
    'Sunan Abu Dawood': 'sunan_abu_dawud',
    'Jami at-Tirmidhi': 'jami_tirmidhi',
    'Jami\' at-Tirmidhi': 'jami_tirmidhi',
    'Jami Tirmidhi': 'jami_tirmidhi',
    'Sunan Ibn Majah': 'sunan_ibn_majah',
    'Sunan an-Nasa\'i': 'sunan_nasai',
    'Sunan an-Nasai': 'sunan_nasai',
    'Sunan Nasai': 'sunan_nasai',
  };

  String translatedRef = reference;

  // Find and replace collection name
  for (var entry in collectionMap.entries) {
    if (reference.contains(entry.key)) {
      final translatedName = context.tr(entry.value);
      translatedRef = translatedRef.replaceFirst(entry.key, translatedName);
      break;
    }
  }

  // Replace "Book" with translated version
  // Match "Book X" where X is a number
  final bookRegex = RegExp(r'Book\s+(\d+)');
  final bookMatch = bookRegex.firstMatch(translatedRef);
  if (bookMatch != null) {
    final bookNumber = bookMatch.group(1);
    final translatedBook = '${context.tr('book')} $bookNumber';
    translatedRef = translatedRef.replaceFirst(bookMatch.group(0)!, translatedBook);
  }

  // Replace "Hadith" with translated version
  // Match "Hadith X" where X is a number
  final hadithRegex = RegExp(r'Hadith\s+(\d+)');
  final hadithMatch = hadithRegex.firstMatch(translatedRef);
  if (hadithMatch != null) {
    final hadithNumber = hadithMatch.group(1);
    final translatedHadith = '${context.tr('hadith')} $hadithNumber';
    translatedRef = translatedRef.replaceFirst(hadithMatch.group(0)!, translatedHadith);
  }

  return translatedRef;
}
