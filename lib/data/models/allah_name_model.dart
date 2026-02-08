enum AllahNameLanguage { english, urdu, hindi }

class AllahNameModel {
  final int number;
  final String name;
  final String transliteration;
  final String meaning;
  final String meaningUrdu;
  final String meaningHindi;
  final String description;
  final String descriptionUrdu;
  final String descriptionHindi;
  final String? audioUrl;

  AllahNameModel({
    required this.number,
    required this.name,
    required this.transliteration,
    required this.meaning,
    this.meaningUrdu = '',
    this.meaningHindi = '',
    required this.description,
    this.descriptionUrdu = '',
    this.descriptionHindi = '',
    this.audioUrl,
  });

  // Get meaning based on language
  String getMeaning(AllahNameLanguage language) {
    switch (language) {
      case AllahNameLanguage.urdu:
        final urdu = meaningUrdu;
        return urdu.isNotEmpty ? urdu : meaning;
      case AllahNameLanguage.hindi:
        final hindi = meaningHindi;
        return hindi.isNotEmpty ? hindi : meaning;
      case AllahNameLanguage.english:
        return meaning;
    }
  }

  // Get description based on language
  String getDescription(AllahNameLanguage language) {
    switch (language) {
      case AllahNameLanguage.urdu:
        final urdu = descriptionUrdu;
        return urdu.isNotEmpty ? urdu : description;
      case AllahNameLanguage.hindi:
        final hindi = descriptionHindi;
        return hindi.isNotEmpty ? hindi : description;
      case AllahNameLanguage.english:
        return description;
    }
  }

  factory AllahNameModel.fromJson(Map<String, dynamic> json) {
    return AllahNameModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaning: json['meaning'] ?? '',
      meaningUrdu: json['meaningUrdu'] ?? '',
      meaningHindi: json['meaningHindi'] ?? '',
      description: json['description'] ?? '',
      descriptionUrdu: json['descriptionUrdu'] ?? '',
      descriptionHindi: json['descriptionHindi'] ?? '',
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'transliteration': transliteration,
      'meaning': meaning,
      'meaningUrdu': meaningUrdu,
      'meaningHindi': meaningHindi,
      'description': description,
      'descriptionUrdu': descriptionUrdu,
      'descriptionHindi': descriptionHindi,
      'audioUrl': audioUrl,
    };
  }
}
