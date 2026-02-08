class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final List<AyahModel> ayahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    this.ayahs = const [],
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
      ayahs: json['ayahs'] != null
          ? (json['ayahs'] as List)
              .map((ayah) => AyahModel.fromJson(ayah))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
    };
  }

  bool get isMeccan => revelationType.toLowerCase() == 'meccan';
}

class AyahModel {
  final int number;
  final int numberInSurah;
  final String text;
  final String? translation;
  final int juz;
  final int page;
  final int hizbQuarter;
  final bool sajda;
  final int surahNumber;
  final String? surahName;
  final String? surahEnglishName;

  AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.text,
    this.translation,
    required this.juz,
    required this.page,
    required this.hizbQuarter,
    this.sajda = false,
    this.surahNumber = 0,
    this.surahName,
    this.surahEnglishName,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    // Extract surah info from nested surah object if available
    final surahData = json['surah'] as Map<String, dynamic>?;

    return AyahModel(
      number: json['number'] ?? 0,
      numberInSurah: json['numberInSurah'] ?? 0,
      text: json['text'] ?? '',
      translation: json['translation'],
      juz: json['juz'] ?? 0,
      page: json['page'] ?? 0,
      hizbQuarter: json['hizbQuarter'] ?? 0,
      sajda: json['sajda'] is bool ? json['sajda'] : false,
      surahNumber: surahData?['number'] ?? 0,
      surahName: surahData?['name'],
      surahEnglishName: surahData?['englishName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'numberInSurah': numberInSurah,
      'text': text,
      'translation': translation,
      'juz': juz,
      'page': page,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'surahEnglishName': surahEnglishName,
    };
  }
}

// Juz/Para info for quick list display
class JuzInfo {
  final int number;
  final String arabicName;
  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;

  JuzInfo({
    required this.number,
    required this.arabicName,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
  });

  factory JuzInfo.fromJson(Map<String, dynamic> json) {
    return JuzInfo(
      number: json['number'] as int? ?? 0,
      arabicName: json['arabic_name'] as String? ?? '',
      startSurah: json['start_surah'] as int? ?? 0,
      startAyah: json['start_ayah'] as int? ?? 0,
      endSurah: json['end_surah'] as int? ?? 0,
      endAyah: json['end_ayah'] as int? ?? 0,
    );
  }
}

// Surah info for quick list display
class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
    );
  }
}
