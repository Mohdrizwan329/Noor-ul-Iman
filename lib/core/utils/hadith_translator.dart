// Utility class for translating hadith-related text
// Supports Firestore loading with hardcoded fallback

/// Hardcoded narrator prefixes for each language
const Map<String, String> _narratorPrefixes = {
  'ur': 'روایت کردہ',
  'hi': 'रिवायत',
  'ar': 'رواه',
};

/// Hardcoded grade translations
const Map<String, Map<String, String>> _gradeTranslations = {
  'sahih': {'ur': 'صحیح', 'hi': 'सहीह (प्रामाणिक)', 'ar': 'صحيح'},
  'hasan': {'ur': 'حسن', 'hi': 'हसन (अच्छा)', 'ar': 'حسن'},
  'daif': {'ur': 'ضعیف', 'hi': 'ज़ईीफ़़ (कमज़ोर)', 'ar': 'ضعيف'},
};

/// Hardcoded book name translations
const Map<String, Map<String, String>> _bookNameTranslations = {
  'Sahih al-Bukhari': {'ur': 'صحیح بخاری', 'hi': 'सहीह बुखारी', 'ar': 'صحيح البخاري'},
  'Sahih Bukhari': {'ur': 'صحیح بخاری', 'hi': 'सहीह बुखारी', 'ar': 'صحيح البخاري'},
  'Sahih Muslim': {'ur': 'صحیح مسلم', 'hi': 'सहीह मुस्लिम', 'ar': 'صحيح مسلم'},
  'Sunan Abu Dawud': {'ur': 'سنن ابو داؤد', 'hi': 'सुनन अबू दाईद', 'ar': 'سنن أبي داود'},
  'Sunan an-Nasai': {'ur': 'سنن نسائی', 'hi': 'सुनन नसई', 'ar': 'سنن النسائي'},
  "Sunan an-Nasa'i": {'ur': 'سنن نسائی', 'hi': 'सुनन नसई', 'ar': 'سنن النسائي'},
  'Sunan Nasai': {'ur': 'سنن نسائی', 'hi': 'सुनन नसई', 'ar': 'سنن النسائي'},
  'Jami at-Tirmidhi': {'ur': 'جامع ترمذی', 'hi': 'जामी तिर्मिज़ी', 'ar': 'جامع الترمذي'},
  'Jami Tirmidhi': {'ur': 'جامع ترمذی', 'hi': 'जामी तिर्मिज़ी', 'ar': 'جامع الترمذي'},
  'Sunan Ibn Majah': {'ur': 'سنن ابن ماجہ', 'hi': 'सुनन इब्न माजाह', 'ar': 'سنن ابن ماجه'},
  'Ibn Majah': {'ur': 'ابن ماجہ', 'hi': 'इब्न माजाह', 'ar': 'ابن ماجه'},
};

/// Hardcoded reference term translations
const Map<String, Map<String, String>> _referenceTermTranslations = {
  'Book': {'ur': 'کتاب', 'hi': 'किताब', 'ar': 'كتاب'},
  'Hadith': {'ur': 'حدیث', 'hi': 'हदीस', 'ar': 'حديث'},
};

/// Export all hardcoded hadith translations for Firestore migration
Map<String, dynamic> getHardcodedHadithTranslations() {
  return {
    'narrator_prefixes': _narratorPrefixes,
    'grades': _gradeTranslations,
    'book_names': _bookNameTranslations,
    'reference_terms': _referenceTermTranslations,
  };
}

class HadithTranslator {
  // Firestore-loaded translations (mutable static fields)
  static Map<String, String>? _firestoreNarratorPrefixes;
  static Map<String, Map<String, String>>? _firestoreGrades;
  static Map<String, Map<String, String>>? _firestoreBookNames;
  static Map<String, Map<String, String>>? _firestoreRefTerms;

  /// Load translations from Firestore data
  static void loadFromFirestore(Map<String, dynamic> data) {
    if (data['narrator_prefixes'] is Map) {
      _firestoreNarratorPrefixes = Map<String, String>.from(data['narrator_prefixes'] as Map);
    }
    if (data['grades'] is Map) {
      _firestoreGrades = {};
      (data['grades'] as Map).forEach((key, value) {
        if (value is Map) {
          _firestoreGrades![key.toString()] = Map<String, String>.from(value);
        }
      });
    }
    if (data['book_names'] is Map) {
      _firestoreBookNames = {};
      (data['book_names'] as Map).forEach((key, value) {
        if (value is Map) {
          _firestoreBookNames![key.toString()] = Map<String, String>.from(value);
        }
      });
    }
    if (data['reference_terms'] is Map) {
      _firestoreRefTerms = {};
      (data['reference_terms'] as Map).forEach((key, value) {
        if (value is Map) {
          _firestoreRefTerms![key.toString()] = Map<String, String>.from(value);
        }
      });
    }
  }

  /// Translates narrator text based on language
  /// Input: "Narrated by Umar ibn Al-Khattab (RA)"
  /// Output (Urdu): "\u0631\u0648\u0627\u06cc\u062a \u06a9\u0631\u062f\u06c1 Umar ibn Al-Khattab (RA)"
  static String translateNarrator(String narrator, String languageCode) {
    if (narrator.isEmpty) return '';

    if (narrator.startsWith('Narrated by ')) {
      final narratorName = narrator.replaceFirst('Narrated by ', '');

      if (languageCode == 'en') return narrator;

      final prefixes = _firestoreNarratorPrefixes ?? _narratorPrefixes;
      final prefix = prefixes[languageCode];
      if (prefix != null) return '$prefix $narratorName';
    }

    return narrator;
  }

  /// Translates grade based on language
  static String translateGrade(String grade, String languageCode) {
    if (grade.isEmpty) return '';
    if (languageCode == 'en') return grade;

    final lowerGrade = grade.toLowerCase();
    final grades = _firestoreGrades ?? _gradeTranslations;

    for (final entry in grades.entries) {
      if (lowerGrade.contains(entry.key)) {
        return entry.value[languageCode] ?? grade;
      }
    }

    return grade;
  }

  /// Translates reference based on language
  /// Input: "Sahih Bukhari, Book 1, Hadith 1"
  /// Output (Urdu): "\u0635\u062d\u06cc\u062d \u0628\u062e\u0627\u0631\u06cc\u060c \u06a9\u062a\u0627\u0628 1\u060c \u062d\u062f\u06cc\u062b 1"
  static String translateReference(String reference, String languageCode) {
    if (reference.isEmpty) return '';
    if (languageCode == 'en') return reference;

    final bookNames = _firestoreBookNames ?? _bookNameTranslations;
    final refTerms = _firestoreRefTerms ?? _referenceTermTranslations;

    String result = reference;

    for (final entry in bookNames.entries) {
      final translation = entry.value[languageCode];
      if (translation != null) {
        result = result.replaceAll(entry.key, translation);
      }
    }

    for (final entry in refTerms.entries) {
      final translation = entry.value[languageCode];
      if (translation != null) {
        result = result.replaceAll(entry.key, translation);
      }
    }

    return result;
  }
}
