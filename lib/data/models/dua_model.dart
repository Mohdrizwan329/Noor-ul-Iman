class DuaCategory {
  final String id;
  final String name;
  final String? nameUrdu;
  final String? nameHindi;
  final String icon;
  final List<DuaModel> duas;

  DuaCategory({
    required this.id,
    required this.name,
    this.nameUrdu,
    this.nameHindi,
    required this.icon,
    required this.duas,
  });

  String getName(DuaLanguage language) {
    switch (language) {
      case DuaLanguage.urdu:
        return nameUrdu ?? name;
      case DuaLanguage.hindi:
        return nameHindi ?? name;
      case DuaLanguage.arabic:
        return nameUrdu ?? name; // Arabic users will see Urdu or English
      case DuaLanguage.english:
        return name;
    }
  }

  factory DuaCategory.fromJson(Map<String, dynamic> json) {
    return DuaCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameUrdu: json['nameUrdu'],
      nameHindi: json['nameHindi'],
      icon: json['icon'] ?? '',
      duas: json['duas'] != null
          ? (json['duas'] as List)
              .map((dua) => DuaModel.fromJson(dua))
              .toList()
          : [],
    );
  }
}

enum DuaLanguage { hindi, english, urdu, arabic }

class DuaModel {
  final int id;
  final String title;
  final String? titleUrdu;
  final String? titleHindi;
  final String arabic;
  final String transliteration;
  final String translation;
  final String? translationHindi;
  final String? translationEnglish;
  final String? translationUrdu;
  final String reference;
  final String? referenceUrdu;
  final String? referenceHindi;
  final String? referenceArabic;
  final String? audioUrl;
  final int? repeatCount;

  DuaModel({
    required this.id,
    required this.title,
    this.titleUrdu,
    this.titleHindi,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.translationHindi,
    this.translationEnglish,
    this.translationUrdu,
    required this.reference,
    this.referenceUrdu,
    this.referenceHindi,
    this.referenceArabic,
    this.audioUrl,
    this.repeatCount,
  });

  // Get translation based on selected language
  String getTranslation(DuaLanguage language) {
    switch (language) {
      case DuaLanguage.english:
        return translationEnglish ?? translation;
      case DuaLanguage.urdu:
        return translationUrdu ?? translation;
      case DuaLanguage.hindi:
        return translationHindi ?? translation;
      case DuaLanguage.arabic:
        return translationEnglish ?? translation; // Arabic users will see English translation
    }
  }

  // Get reference based on selected language
  String getReference(DuaLanguage language) {
    switch (language) {
      case DuaLanguage.english:
        return reference;
      case DuaLanguage.urdu:
        return referenceUrdu ?? reference;
      case DuaLanguage.hindi:
        return referenceHindi ?? reference;
      case DuaLanguage.arabic:
        return referenceArabic ?? reference;
    }
  }

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleUrdu: json['titleUrdu'],
      titleHindi: json['titleHindi'],
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      translationHindi: json['translationHindi'],
      translationEnglish: json['translationEnglish'],
      translationUrdu: json['translationUrdu'],
      reference: json['reference'] ?? '',
      referenceUrdu: json['referenceUrdu'],
      referenceHindi: json['referenceHindi'],
      referenceArabic: json['referenceArabic'],
      audioUrl: json['audioUrl'],
      repeatCount: json['repeatCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleUrdu': titleUrdu,
      'titleHindi': titleHindi,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'translationHindi': translationHindi,
      'translationEnglish': translationEnglish,
      'translationUrdu': translationUrdu,
      'reference': reference,
      'referenceUrdu': referenceUrdu,
      'referenceHindi': referenceHindi,
      'referenceArabic': referenceArabic,
      'audioUrl': audioUrl,
      'repeatCount': repeatCount,
    };
  }
}

class AdhkarModel {
  final String category;
  final String arabicCategory;
  final List<DuaModel> adhkar;

  AdhkarModel({
    required this.category,
    required this.arabicCategory,
    required this.adhkar,
  });

  factory AdhkarModel.fromJson(Map<String, dynamic> json) {
    return AdhkarModel(
      category: json['category'] ?? '',
      arabicCategory: json['arabicCategory'] ?? '',
      adhkar: json['adhkar'] != null
          ? (json['adhkar'] as List)
              .map((dua) => DuaModel.fromJson(dua))
              .toList()
          : [],
    );
  }
}
