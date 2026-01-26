/// Utility class for translating hadith-related text
class HadithTranslator {
  /// Translates narrator text based on language
  /// Input: "Narrated by Umar ibn Al-Khattab (RA)"
  /// Output (Urdu): "روایت کردہ عمر بن الخطاب (رض)"
  static String translateNarrator(String narrator, String languageCode) {
    if (narrator.isEmpty) return '';

    // Extract narrator name from "Narrated by [Name]" format
    if (narrator.startsWith('Narrated by ')) {
      final narratorName = narrator.replaceFirst('Narrated by ', '');

      switch (languageCode) {
        case 'ur':
          return 'روایت کردہ $narratorName';
        case 'hi':
          return 'रिवायत $narratorName';
        case 'ar':
          return 'رواه $narratorName';
        case 'en':
        default:
          return narrator; // Keep original English
      }
    }

    // If format is different, return as-is
    return narrator;
  }

  /// Translates grade based on language
  static String translateGrade(String grade, String languageCode) {
    if (grade.isEmpty) return '';

    final lowerGrade = grade.toLowerCase();

    switch (languageCode) {
      case 'ur':
        if (lowerGrade.contains('sahih')) return 'صحیح';
        if (lowerGrade.contains('hasan')) return 'حسن';
        if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) return 'ضعیف';
        return grade;

      case 'hi':
        if (lowerGrade.contains('sahih')) return 'सहीह (प्रामाणिक)';
        if (lowerGrade.contains('hasan')) return 'हसन (अच्छा)';
        if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) return 'ज़ईफ़ (कमज़ोर)';
        return grade;

      case 'ar':
        if (lowerGrade.contains('sahih')) return 'صحيح';
        if (lowerGrade.contains('hasan')) return 'حسن';
        if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) return 'ضعيف';
        return grade;

      case 'en':
      default:
        return grade; // Keep original English
    }
  }

  /// Translates reference based on language
  /// Input: "Sahih Bukhari, Book 1, Hadith 1"
  /// Output (Urdu): "صحیح بخاری، کتاب 1، حدیث 1"
  static String translateReference(String reference, String languageCode) {
    if (reference.isEmpty) return '';

    switch (languageCode) {
      case 'ur':
        return reference
            .replaceAll('Sahih al-Bukhari', 'صحیح بخاری')
            .replaceAll('Sahih Bukhari', 'صحیح بخاری')
            .replaceAll('Sahih Muslim', 'صحیح مسلم')
            .replaceAll('Sunan Abu Dawud', 'سنن ابو داؤد')
            .replaceAll('Sunan an-Nasai', 'سنن نسائی')
            .replaceAll("Sunan an-Nasa'i", 'سنن نسائی')
            .replaceAll('Sunan Nasai', 'سنن نسائی')
            .replaceAll('Jami at-Tirmidhi', 'جامع ترمذی')
            .replaceAll('Jami Tirmidhi', 'جامع ترمذی')
            .replaceAll('Sunan Ibn Majah', 'سنن ابن ماجہ')
            .replaceAll('Ibn Majah', 'ابن ماجہ')
            .replaceAll('Book', 'کتاب')
            .replaceAll('Hadith', 'حدیث');

      case 'hi':
        return reference
            .replaceAll('Sahih al-Bukhari', 'सहीह बुखारी')
            .replaceAll('Sahih Bukhari', 'सहीह बुखारी')
            .replaceAll('Sahih Muslim', 'सहीह मुस्लिम')
            .replaceAll('Sunan Abu Dawud', 'सुनन अबू दाऊद')
            .replaceAll('Sunan an-Nasai', 'सुनन नसई')
            .replaceAll("Sunan an-Nasa'i", 'सुनन नसई')
            .replaceAll('Sunan Nasai', 'सुनन नसई')
            .replaceAll('Jami at-Tirmidhi', 'जामी तिर्मिज़ी')
            .replaceAll('Jami Tirmidhi', 'जामी तिर्मिज़ी')
            .replaceAll('Sunan Ibn Majah', 'सुनन इब्न माजाह')
            .replaceAll('Ibn Majah', 'इब्न माजाह')
            .replaceAll('Book', 'किताब')
            .replaceAll('Hadith', 'हदीस');

      case 'ar':
        return reference
            .replaceAll('Sahih al-Bukhari', 'صحيح البخاري')
            .replaceAll('Sahih Bukhari', 'صحيح البخاري')
            .replaceAll('Sahih Muslim', 'صحيح مسلم')
            .replaceAll('Sunan Abu Dawud', 'سنن أبي داود')
            .replaceAll('Sunan an-Nasai', 'سنن النسائي')
            .replaceAll("Sunan an-Nasa'i", 'سنن النسائي')
            .replaceAll('Sunan Nasai', 'سنن النسائي')
            .replaceAll('Jami at-Tirmidhi', 'جامع الترمذي')
            .replaceAll('Jami Tirmidhi', 'جامع الترمذي')
            .replaceAll('Sunan Ibn Majah', 'سنن ابن ماجه')
            .replaceAll('Ibn Majah', 'ابن ماجه')
            .replaceAll('Book', 'كتاب')
            .replaceAll('Hadith', 'حديث');

      case 'en':
      default:
        return reference; // Keep original English
    }
  }
}
