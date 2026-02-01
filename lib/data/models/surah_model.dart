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

  // Arabic names for each Juz
  static const List<String> juzArabicNames = [
    'الم',           // Juz 1
    'سَيَقُولُ',      // Juz 2
    'تِلْكَ الرُّسُلُ', // Juz 3
    'لَنْ تَنَالُوا',  // Juz 4
    'وَالْمُحْصَنَاتُ', // Juz 5
    'لَا يُحِبُّ اللَّهُ', // Juz 6
    'وَإِذَا سَمِعُوا', // Juz 7
    'وَلَوْ أَنَّنَا',  // Juz 8
    'قَالَ الْمَلَأُ', // Juz 9
    'وَاعْلَمُوا',    // Juz 10
    'يَعْتَذِرُونَ',  // Juz 11
    'وَمَا مِنْ دَابَّةٍ', // Juz 12
    'وَمَا أُبَرِّئُ', // Juz 13
    'رُبَمَا',        // Juz 14
    'سُبْحَانَ الَّذِي', // Juz 15
    'قَالَ أَلَمْ',   // Juz 16
    'اقْتَرَبَ',      // Juz 17
    'قَدْ أَفْلَحَ',  // Juz 18
    'وَقَالَ الَّذِينَ', // Juz 19
    'أَمَّنْ خَلَقَ', // Juz 20
    'اتْلُ مَا أُوحِيَ', // Juz 21
    'وَمَنْ يَقْنُتْ', // Juz 22
    'وَمَا لِيَ',    // Juz 23
    'فَمَنْ أَظْلَمُ', // Juz 24
    'إِلَيْهِ يُرَدُّ', // Juz 25
    'حم',            // Juz 26
    'قَالَ فَمَا خَطْبُكُمْ', // Juz 27
    'قَدْ سَمِعَ اللَّهُ', // Juz 28
    'تَبَارَكَ الَّذِي', // Juz 29
    'عَمَّ',          // Juz 30
  ];

  // Static data for Juz boundaries (Surah:Ayah)
  static List<JuzInfo> getAllJuz() {
    const boundaries = [
      [1, 1, 2, 141],    // Juz 1
      [2, 142, 2, 252],  // Juz 2
      [2, 253, 3, 92],   // Juz 3
      [3, 93, 4, 23],    // Juz 4
      [4, 24, 4, 147],   // Juz 5
      [4, 148, 5, 81],   // Juz 6
      [5, 82, 6, 110],   // Juz 7
      [6, 111, 7, 87],   // Juz 8
      [7, 88, 8, 40],    // Juz 9
      [8, 41, 9, 92],    // Juz 10
      [9, 93, 11, 5],    // Juz 11
      [11, 6, 12, 52],   // Juz 12
      [12, 53, 14, 52],  // Juz 13
      [15, 1, 16, 128],  // Juz 14
      [17, 1, 18, 74],   // Juz 15
      [18, 75, 20, 135], // Juz 16
      [21, 1, 22, 78],   // Juz 17
      [23, 1, 25, 20],   // Juz 18
      [25, 21, 27, 55],  // Juz 19
      [27, 56, 29, 45],  // Juz 20
      [29, 46, 33, 30],  // Juz 21
      [33, 31, 36, 27],  // Juz 22
      [36, 28, 39, 31],  // Juz 23
      [39, 32, 41, 46],  // Juz 24
      [41, 47, 45, 37],  // Juz 25
      [46, 1, 51, 30],   // Juz 26
      [51, 31, 57, 29],  // Juz 27
      [58, 1, 66, 12],   // Juz 28
      [67, 1, 77, 50],   // Juz 29
      [78, 1, 114, 6],   // Juz 30
    ];

    return List.generate(30, (index) {
      final b = boundaries[index];
      return JuzInfo(
        number: index + 1,
        arabicName: juzArabicNames[index],
        startSurah: b[0],
        startAyah: b[1],
        endSurah: b[2],
        endAyah: b[3],
      );
    });
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
