class AppAssets {
  AppAssets._();

  // Base paths
  static const String _images = 'assets/images';
  static const String _data = 'assets/data';

  // Images
  static const String appLogo = '$_images/Applogo.png';

  // Data files
  static const String quranData = '$_data/quran/quran.json';
  static const String quranTranslationUrdu = '$_data/quran/translation_urdu.json';
  static const String quranTranslationEnglish = '$_data/quran/translation_english.json';
  static const String hadithBukhari = '$_data/hadith/bukhari.json';
  static const String hadithMuslim = '$_data/hadith/muslim.json';
  static const String duasData = '$_data/duas/duas.json';
  static const String namesOfAllah = '$_data/names_of_allah/names.json';

  // Audio URLs (Quran Recitation)
  static const String audioBaseUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy';

  // Reciters
  static const Map<String, String> reciters = {
    'ar.alafasy': 'Mishary Alafasy',
    'ar.abdulbasit': 'Abdul Basit',
    'ar.abdurrahmaansudais': 'Abdur Rahman As-Sudais',
    'ar.saaborinza': 'Saad Al-Ghamdi',
  };
}
