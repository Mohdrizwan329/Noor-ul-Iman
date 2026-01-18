class HadithBook {
  final String id;
  final String name;
  final String arabicName;
  final int totalHadith;
  final List<HadithChapter> chapters;

  HadithBook({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.totalHadith,
    required this.chapters,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      totalHadith: json['totalHadith'] ?? 0,
      chapters: json['chapters'] != null
          ? (json['chapters'] as List)
              .map((chapter) => HadithChapter.fromJson(chapter))
              .toList()
          : [],
    );
  }
}

class HadithChapter {
  final int id;
  final String name;
  final String arabicName;
  final List<HadithModel> hadiths;

  HadithChapter({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadiths,
  });

  factory HadithChapter.fromJson(Map<String, dynamic> json) {
    return HadithChapter(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      hadiths: json['hadiths'] != null
          ? (json['hadiths'] as List)
              .map((hadith) => HadithModel.fromJson(hadith))
              .toList()
          : [],
    );
  }
}

class HadithModel {
  final int id;
  final String hadithNumber;
  final String arabic;
  final String english;
  final String urdu;
  final String hindi;
  final String narrator;
  final String grade;
  final String reference;
  final bool isFavorite;

  HadithModel({
    required this.id,
    required this.hadithNumber,
    required this.arabic,
    required this.english,
    required this.urdu,
    this.hindi = '',
    required this.narrator,
    required this.grade,
    required this.reference,
    this.isFavorite = false,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] ?? 0,
      hadithNumber: json['hadithNumber']?.toString() ?? '',
      arabic: json['arabic'] ?? '',
      english: json['english'] ?? '',
      urdu: json['urdu'] ?? '',
      hindi: json['hindi'] ?? '',
      narrator: json['narrator'] ?? '',
      grade: json['grade'] ?? '',
      reference: json['reference'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hadithNumber': hadithNumber,
      'arabic': arabic,
      'english': english,
      'urdu': urdu,
      'hindi': hindi,
      'narrator': narrator,
      'grade': grade,
      'reference': reference,
      'isFavorite': isFavorite,
    };
  }

  HadithModel copyWith({bool? isFavorite, String? hindi}) {
    return HadithModel(
      id: id,
      hadithNumber: hadithNumber,
      arabic: arabic,
      english: english,
      urdu: urdu,
      hindi: hindi ?? this.hindi,
      narrator: narrator,
      grade: grade,
      reference: reference,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
