import 'package:cloud_firestore/cloud_firestore.dart';
import 'multilingual_text.dart';
import 'dua_model.dart';
import 'allah_name_model.dart';

/// Content version metadata for cache invalidation
class ContentVersions {
  final int duasVersion;
  final int allahNamesVersion;
  final int kalmasVersion;
  final int islamicNamesVersion;
  final int hadithVersion;
  final int tasbihVersion;
  final int calendarVersion;
  final int basicAmalVersion;
  final int greetingCardsVersion;
  final int hajjGuideVersion;
  final int ramadanDuasVersion;
  final int zakatGuideVersion;
  final int sampleHadithVersion;
  final int qiblaContentVersion;
  final int tasbihScreenContentVersion;
  final int calendarScreenContentVersion;
  final int zakatCalculatorContentVersion;
  final int zakatGuideScreenContentVersion;
  final int quranScreenContentVersion;
  final int aboutScreenContentVersion;
  final int privacyPolicyScreenContentVersion;
  final int uiTranslationsVersion;
  final DateTime lastUpdated;

  ContentVersions({
    this.duasVersion = 1,
    this.allahNamesVersion = 1,
    this.kalmasVersion = 1,
    this.islamicNamesVersion = 1,
    this.hadithVersion = 1,
    this.tasbihVersion = 1,
    this.calendarVersion = 1,
    this.basicAmalVersion = 1,
    this.greetingCardsVersion = 1,
    this.hajjGuideVersion = 1,
    this.ramadanDuasVersion = 1,
    this.zakatGuideVersion = 1,
    this.sampleHadithVersion = 1,
    this.qiblaContentVersion = 1,
    this.tasbihScreenContentVersion = 1,
    this.calendarScreenContentVersion = 1,
    this.zakatCalculatorContentVersion = 1,
    this.zakatGuideScreenContentVersion = 1,
    this.quranScreenContentVersion = 1,
    this.aboutScreenContentVersion = 1,
    this.privacyPolicyScreenContentVersion = 1,
    this.uiTranslationsVersion = 1,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory ContentVersions.fromJson(Map<String, dynamic> json) {
    return ContentVersions(
      duasVersion: json['duas_version'] as int? ?? 1,
      allahNamesVersion: json['allah_names_version'] as int? ?? 1,
      kalmasVersion: json['kalmas_version'] as int? ?? 1,
      islamicNamesVersion: json['islamic_names_version'] as int? ?? 1,
      hadithVersion: json['hadith_version'] as int? ?? 1,
      tasbihVersion: json['tasbih_version'] as int? ?? 1,
      calendarVersion: json['calendar_version'] as int? ?? 1,
      basicAmalVersion: json['basic_amal_version'] as int? ?? 1,
      greetingCardsVersion: json['greeting_cards_version'] as int? ?? 1,
      hajjGuideVersion: json['hajj_guide_version'] as int? ?? 1,
      ramadanDuasVersion: json['ramadan_duas_version'] as int? ?? 1,
      zakatGuideVersion: json['zakat_guide_version'] as int? ?? 1,
      sampleHadithVersion: json['sample_hadith_version'] as int? ?? 1,
      qiblaContentVersion: json['qibla_content_version'] as int? ?? 1,
      tasbihScreenContentVersion: json['tasbih_screen_content_version'] as int? ?? 1,
      calendarScreenContentVersion: json['calendar_screen_content_version'] as int? ?? 1,
      zakatCalculatorContentVersion: json['zakat_calculator_content_version'] as int? ?? 1,
      zakatGuideScreenContentVersion: json['zakat_guide_screen_content_version'] as int? ?? 1,
      quranScreenContentVersion: json['quran_screen_content_version'] as int? ?? 1,
      aboutScreenContentVersion: json['about_screen_content_version'] as int? ?? 1,
      privacyPolicyScreenContentVersion: json['privacy_policy_screen_content_version'] as int? ?? 1,
      uiTranslationsVersion: json['ui_translations_version'] as int? ?? 1,
      lastUpdated: json['last_updated'] != null
          ? (json['last_updated'] is Timestamp
              ? (json['last_updated'] as Timestamp).toDate()
              : DateTime.parse(json['last_updated'] as String))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'duas_version': duasVersion,
        'allah_names_version': allahNamesVersion,
        'kalmas_version': kalmasVersion,
        'islamic_names_version': islamicNamesVersion,
        'hadith_version': hadithVersion,
        'tasbih_version': tasbihVersion,
        'calendar_version': calendarVersion,
        'basic_amal_version': basicAmalVersion,
        'greeting_cards_version': greetingCardsVersion,
        'hajj_guide_version': hajjGuideVersion,
        'ramadan_duas_version': ramadanDuasVersion,
        'zakat_guide_version': zakatGuideVersion,
        'sample_hadith_version': sampleHadithVersion,
        'qibla_content_version': qiblaContentVersion,
        'tasbih_screen_content_version': tasbihScreenContentVersion,
        'calendar_screen_content_version': calendarScreenContentVersion,
        'zakat_calculator_content_version': zakatCalculatorContentVersion,
        'zakat_guide_screen_content_version': zakatGuideScreenContentVersion,
        'quran_screen_content_version': quranScreenContentVersion,
        'about_screen_content_version': aboutScreenContentVersion,
        'privacy_policy_screen_content_version': privacyPolicyScreenContentVersion,
        'ui_translations_version': uiTranslationsVersion,
        'last_updated': lastUpdated.toIso8601String(),
      };

  int getVersionFor(String contentType) {
    switch (contentType) {
      case 'duas':
        return duasVersion;
      case 'allah_names':
        return allahNamesVersion;
      case 'kalmas':
        return kalmasVersion;
      case 'islamic_names':
        return islamicNamesVersion;
      case 'hadith':
        return hadithVersion;
      case 'tasbih':
        return tasbihVersion;
      case 'calendar':
        return calendarVersion;
      case 'basic_amal':
        return basicAmalVersion;
      case 'greeting_cards':
        return greetingCardsVersion;
      case 'hajj_guide':
        return hajjGuideVersion;
      case 'ramadan_duas':
        return ramadanDuasVersion;
      case 'zakat_guide':
        return zakatGuideVersion;
      case 'sample_hadith':
        return sampleHadithVersion;
      case 'qibla_content':
        return qiblaContentVersion;
      case 'tasbih_screen_content':
        return tasbihScreenContentVersion;
      case 'calendar_screen_content':
        return calendarScreenContentVersion;
      case 'zakat_calculator_content':
        return zakatCalculatorContentVersion;
      case 'zakat_guide_screen_content':
        return zakatGuideScreenContentVersion;
      case 'quran_screen_content':
        return quranScreenContentVersion;
      case 'about_screen_content':
        return aboutScreenContentVersion;
      case 'privacy_policy_screen_content':
        return privacyPolicyScreenContentVersion;
      case 'ui_translations':
        return uiTranslationsVersion;
      default:
        return 1;
    }
  }
}

/// Dua model for Firestore with multilingual support
class DuaModelFirestore {
  final int id;
  final MultilingualText title;
  final String arabic;
  final String transliteration;
  final MultilingualText translation;
  final MultilingualText reference;
  final String? audioUrl;
  final int? repeatCount;

  DuaModelFirestore({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    this.audioUrl,
    this.repeatCount,
  });

  factory DuaModelFirestore.fromJson(Map<String, dynamic> json) {
    return DuaModelFirestore(
      id: json['id'] as int? ?? 0,
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      translation:
          MultilingualText.fromJson(json['translation'] as Map<String, dynamic>?),
      reference:
          MultilingualText.fromJson(json['reference'] as Map<String, dynamic>?),
      audioUrl: json['audio_url'] as String?,
      repeatCount: json['repeat_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'arabic': arabic,
        'transliteration': transliteration,
        'translation': translation.toJson(),
        'reference': reference.toJson(),
        'audio_url': audioUrl,
        'repeat_count': repeatCount,
      };

  /// Convert to existing DuaModel for backward compatibility
  DuaModel toDuaModel() {
    return DuaModel(
      id: id,
      title: title.en,
      titleUrdu: title.ur,
      titleHindi: title.hi,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation.en,
      translationEnglish: translation.en,
      translationUrdu: translation.ur,
      translationHindi: translation.hi,
      reference: reference.en,
      referenceUrdu: reference.ur,
      referenceHindi: reference.hi,
      referenceArabic: reference.ar,
      audioUrl: audioUrl,
      repeatCount: repeatCount,
    );
  }
}

/// Dua category model for Firestore
class DuaCategoryFirestore {
  final String id;
  final MultilingualText name;
  final String icon;
  final int order;
  final List<DuaModelFirestore> duas;

  DuaCategoryFirestore({
    required this.id,
    required this.name,
    required this.icon,
    required this.order,
    required this.duas,
  });

  factory DuaCategoryFirestore.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return DuaCategoryFirestore.fromJson({...data, 'id': doc.id});
  }

  factory DuaCategoryFirestore.fromJson(Map<String, dynamic> json) {
    return DuaCategoryFirestore(
      id: json['id'] as String? ?? '',
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      icon: json['icon'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      duas: (json['duas'] as List<dynamic>? ?? [])
          .map((d) => DuaModelFirestore.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name.toJson(),
        'icon': icon,
        'order': order,
        'duas': duas.map((d) => d.toJson()).toList(),
      };

  /// Convert to existing DuaCategory for backward compatibility
  DuaCategory toDuaCategory() {
    return DuaCategory(
      id: id,
      name: name.en,
      nameUrdu: name.ur,
      nameHindi: name.hi,
      icon: icon,
      duas: duas.map((d) => d.toDuaModel()).toList(),
    );
  }
}

/// Allah Name model for Firestore
class AllahNameFirestore {
  final int number;
  final String name;
  final String transliteration;
  final MultilingualText meaning;
  final MultilingualText description;
  final String? audioUrl;

  AllahNameFirestore({
    required this.number,
    required this.name,
    required this.transliteration,
    required this.meaning,
    required this.description,
    this.audioUrl,
  });

  factory AllahNameFirestore.fromJson(Map<String, dynamic> json) {
    return AllahNameFirestore(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      meaning:
          MultilingualText.fromJson(json['meaning'] as Map<String, dynamic>?),
      description:
          MultilingualText.fromJson(json['description'] as Map<String, dynamic>?),
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'transliteration': transliteration,
        'meaning': meaning.toJson(),
        'description': description.toJson(),
        'audio_url': audioUrl,
      };

  /// Convert to existing AllahNameModel for backward compatibility
  AllahNameModel toAllahNameModel() {
    return AllahNameModel(
      number: number,
      name: name,
      transliteration: transliteration,
      meaning: meaning.en,
      meaningUrdu: meaning.ur,
      meaningHindi: meaning.hi,
      description: description.en,
      descriptionUrdu: description.ur,
      descriptionHindi: description.hi,
      audioUrl: audioUrl,
    );
  }
}

/// Kalma model for Firestore
class KalmaFirestore {
  final int number;
  final MultilingualText name;
  final String arabic;
  final String transliteration;
  final MultilingualText translation;

  KalmaFirestore({
    required this.number,
    required this.name,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  factory KalmaFirestore.fromJson(Map<String, dynamic> json) {
    return KalmaFirestore(
      number: json['number'] as int? ?? 0,
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      translation:
          MultilingualText.fromJson(json['translation'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name.toJson(),
        'arabic': arabic,
        'transliteration': transliteration,
        'translation': translation.toJson(),
      };
}

/// Islamic Name model for Firestore (prophets, sahaba, imams, etc.)
class IslamicNameFirestore {
  final String name;
  final String transliteration;
  final String? nameUrdu;
  final String? nameHindi;
  final MultilingualText title;
  final MultilingualText description;
  final String? fatherName;
  final String? motherName;
  final String? birthDate;
  final String? birthPlace;
  final String? deathDate;
  final String? deathPlace;
  final String? spouse;
  final String? children;
  final String? tribe;
  final String? era;
  final String? knownFor;
  final String? fullTitle;
  final String? period;
  final String? kunya;

  IslamicNameFirestore({
    required this.name,
    required this.transliteration,
    this.nameUrdu,
    this.nameHindi,
    required this.title,
    required this.description,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.birthPlace,
    this.deathDate,
    this.deathPlace,
    this.spouse,
    this.children,
    this.tribe,
    this.era,
    this.knownFor,
    this.fullTitle,
    this.period,
    this.kunya,
  });

  /// Parse a field that can be either a plain String or a multilingual Map.
  /// If it's a Map with en/ur/hi/ar keys, converts to "en | ur | hi" pipe-separated format.
  static String? _parseFlexibleField(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      final en = value['en'] as String? ?? '';
      final ur = value['ur'] as String? ?? '';
      final hi = value['hi'] as String? ?? '';
      if (en.isEmpty && ur.isEmpty && hi.isEmpty) return null;
      return '$en | $ur | $hi';
    }
    return value.toString();
  }

  factory IslamicNameFirestore.fromJson(Map<String, dynamic> json) {
    return IslamicNameFirestore(
      name: json['name'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      nameUrdu: json['name_urdu'] as String?,
      nameHindi: json['name_hindi'] as String?,
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      description:
          MultilingualText.fromJson(json['description'] as Map<String, dynamic>?),
      fatherName: _parseFlexibleField(json['father_name']),
      motherName: _parseFlexibleField(json['mother_name']),
      birthDate: _parseFlexibleField(json['birth_date']),
      birthPlace: _parseFlexibleField(json['birth_place']),
      deathDate: _parseFlexibleField(json['death_date']),
      deathPlace: _parseFlexibleField(json['death_place']),
      spouse: _parseFlexibleField(json['spouse']),
      children: _parseFlexibleField(json['children']),
      tribe: _parseFlexibleField(json['tribe']),
      era: _parseFlexibleField(json['era']),
      knownFor: _parseFlexibleField(json['known_for']),
      fullTitle: _parseFlexibleField(json['full_title']),
      period: json['period'] as String?,
      kunya: _parseFlexibleField(json['kunya']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'transliteration': transliteration,
        if (nameUrdu != null) 'name_urdu': nameUrdu,
        if (nameHindi != null) 'name_hindi': nameHindi,
        'title': title.toJson(),
        'description': description.toJson(),
        'father_name': fatherName,
        'mother_name': motherName,
        'birth_date': birthDate,
        'birth_place': birthPlace,
        'death_date': deathDate,
        'death_place': deathPlace,
        'spouse': spouse,
        'children': children,
        'tribe': tribe,
        'era': era,
        'known_for': knownFor,
        if (fullTitle != null) 'full_title': fullTitle,
        if (period != null) 'period': period,
        if (kunya != null) 'kunya': kunya,
      };
}

/// Hadith book info for Firestore
class HadithBookFirestore {
  final int id;
  final MultilingualText name;
  final String arabicName;
  final int hadithCount;
  final int startNumber;
  final int endNumber;

  HadithBookFirestore({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadithCount,
    required this.startNumber,
    required this.endNumber,
  });

  factory HadithBookFirestore.fromJson(Map<String, dynamic> json) {
    return HadithBookFirestore(
      id: json['id'] as int? ?? 0,
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      arabicName: json['arabic_name'] as String? ?? '',
      hadithCount: json['hadith_count'] as int? ?? 0,
      startNumber: json['start_number'] as int? ?? 0,
      endNumber: json['end_number'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name.toJson(),
        'arabic_name': arabicName,
        'hadith_count': hadithCount,
        'start_number': startNumber,
        'end_number': endNumber,
      };
}

/// Hadith collection for Firestore
class HadithCollectionFirestore {
  final String id;
  final MultilingualText name;
  final String arabicName;
  final int totalHadith;
  final int totalBooks;
  final List<HadithBookFirestore> books;

  HadithCollectionFirestore({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.totalHadith,
    required this.totalBooks,
    required this.books,
  });

  factory HadithCollectionFirestore.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HadithCollectionFirestore.fromJson({...data, 'id': doc.id});
  }

  factory HadithCollectionFirestore.fromJson(Map<String, dynamic> json) {
    return HadithCollectionFirestore(
      id: json['id'] as String? ?? '',
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      arabicName: json['arabic_name'] as String? ?? '',
      totalHadith: json['total_hadith'] as int? ?? 0,
      totalBooks: json['total_books'] as int? ?? 0,
      books: (json['books'] as List<dynamic>? ?? [])
          .map((b) => HadithBookFirestore.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name.toJson(),
        'arabic_name': arabicName,
        'total_hadith': totalHadith,
        'total_books': totalBooks,
        'books': books.map((b) => b.toJson()).toList(),
      };
}

/// Hadith collection info with multilingual support
class HadithCollectionInfoFirestore {
  final String id;
  final MultilingualText name;
  final String arabicName;
  final MultilingualText compiler;
  final int totalHadith;
  final int totalBooks;
  final MultilingualText description;

  HadithCollectionInfoFirestore({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.compiler,
    required this.totalHadith,
    required this.totalBooks,
    required this.description,
  });

  factory HadithCollectionInfoFirestore.fromJson(Map<String, dynamic> json) {
    return HadithCollectionInfoFirestore(
      id: json['id'] as String? ?? '',
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      arabicName: json['arabic_name'] as String? ?? '',
      compiler:
          MultilingualText.fromJson(json['compiler'] as Map<String, dynamic>?),
      totalHadith: json['total_hadith'] as int? ?? 0,
      totalBooks: json['total_books'] as int? ?? 0,
      description: MultilingualText.fromJson(
          json['description'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name.toJson(),
        'arabic_name': arabicName,
        'compiler': compiler.toJson(),
        'total_hadith': totalHadith,
        'total_books': totalBooks,
        'description': description.toJson(),
      };
}

/// Tasbih/Dhikr item for Firestore
class DhikrItemFirestore {
  final String arabic;
  final String transliteration;
  final MultilingualText meaning;
  final int defaultTarget;

  DhikrItemFirestore({
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.defaultTarget,
  });

  factory DhikrItemFirestore.fromJson(Map<String, dynamic> json) {
    return DhikrItemFirestore(
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      meaning:
          MultilingualText.fromJson(json['meaning'] as Map<String, dynamic>?),
      defaultTarget: json['default_target'] as int? ?? 33,
    );
  }

  Map<String, dynamic> toJson() => {
        'arabic': arabic,
        'transliteration': transliteration,
        'meaning': meaning.toJson(),
        'default_target': defaultTarget,
      };
}

/// Basic Amal step for Firestore (wazu, ghusl, namaz guide, etc.)
class BasicAmalStepFirestore {
  final int step;
  final MultilingualText title;
  final String titleKey;
  final String icon;
  final String color;
  final MultilingualText details;

  BasicAmalStepFirestore({
    required this.step,
    required this.title,
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.details,
  });

  factory BasicAmalStepFirestore.fromJson(Map<String, dynamic> json) {
    return BasicAmalStepFirestore(
      step: json['step'] as int? ?? 0,
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      titleKey: json['title_key'] as String? ?? '',
      icon: json['icon'] as String? ?? 'circle',
      color: json['color'] as String? ?? '#000000',
      details:
          MultilingualText.fromJson(json['details'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'step': step,
        'title': title.toJson(),
        'title_key': titleKey,
        'icon': icon,
        'color': color,
        'details': details.toJson(),
      };
}

/// Basic Amal guide for Firestore
class BasicAmalGuideFirestore {
  final String id;
  final MultilingualText title;
  final String icon;
  final List<BasicAmalStepFirestore> steps;
  final MultilingualText? additionalInfo;

  BasicAmalGuideFirestore({
    required this.id,
    required this.title,
    required this.icon,
    required this.steps,
    this.additionalInfo,
  });

  factory BasicAmalGuideFirestore.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BasicAmalGuideFirestore.fromJson({...data, 'id': doc.id});
  }

  factory BasicAmalGuideFirestore.fromJson(Map<String, dynamic> json) {
    return BasicAmalGuideFirestore(
      id: json['id'] as String? ?? '',
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      icon: json['icon'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>? ?? [])
          .map((s) => BasicAmalStepFirestore.fromJson(s as Map<String, dynamic>))
          .toList(),
      additionalInfo: json['additional_info'] != null
          ? MultilingualText.fromJson(
              json['additional_info'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'icon': icon,
        'steps': steps.map((s) => s.toJson()).toList(),
        'additional_info': additionalInfo?.toJson(),
      };
}

/// Islamic month for Firestore
class IslamicMonthFirestore {
  final int number;
  final MultilingualText name;
  final MultilingualText? specialOccasion;
  final String gradientStart;
  final String gradientEnd;
  final List<GreetingCardFirestore> cards;

  IslamicMonthFirestore({
    required this.number,
    required this.name,
    this.specialOccasion,
    required this.gradientStart,
    required this.gradientEnd,
    required this.cards,
  });

  factory IslamicMonthFirestore.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return IslamicMonthFirestore.fromJson(data);
  }

  factory IslamicMonthFirestore.fromJson(Map<String, dynamic> json) {
    return IslamicMonthFirestore(
      number: json['number'] as int? ?? 0,
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      specialOccasion: json['special_occasion'] != null
          ? MultilingualText.fromJson(json['special_occasion'] as Map<String, dynamic>?)
          : null,
      gradientStart: json['gradient_start'] as String? ?? '#4CAF50',
      gradientEnd: json['gradient_end'] as String? ?? '#2E7D32',
      cards: (json['cards'] as List<dynamic>? ?? [])
          .map((c) => GreetingCardFirestore.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name.toJson(),
        if (specialOccasion != null) 'special_occasion': specialOccasion!.toJson(),
        'gradient_start': gradientStart,
        'gradient_end': gradientEnd,
        'cards': cards.map((c) => c.toJson()).toList(),
      };
}

/// Greeting card for Firestore
class GreetingCardFirestore {
  final String id;
  final MultilingualText title;
  final MultilingualText message;
  final String icon;
  final String? templateUrl;

  GreetingCardFirestore({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    this.templateUrl,
  });

  factory GreetingCardFirestore.fromJson(Map<String, dynamic> json) {
    return GreetingCardFirestore(
      id: json['id'] as String? ?? '',
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      message:
          MultilingualText.fromJson(json['message'] as Map<String, dynamic>?),
      icon: json['icon'] as String? ?? '',
      templateUrl: json['template_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'message': message.toJson(),
        'icon': icon,
        'template_url': templateUrl,
      };
}

/// Sample Hadith model for Firestore (from hadith_screen.dart)
class SampleHadithFirestore {
  final int id;
  final String hadithNumber;
  final String arabic;
  final String english;
  final String urdu;
  final String hindi;
  final String narrator;
  final String grade;
  final String reference;

  SampleHadithFirestore({
    required this.id,
    required this.hadithNumber,
    required this.arabic,
    required this.english,
    required this.urdu,
    required this.hindi,
    required this.narrator,
    required this.grade,
    required this.reference,
  });

  factory SampleHadithFirestore.fromJson(Map<String, dynamic> json) {
    return SampleHadithFirestore(
      id: json['id'] as int? ?? 0,
      hadithNumber: json['hadith_number'] as String? ?? '',
      arabic: json['arabic'] as String? ?? '',
      english: json['english'] as String? ?? '',
      urdu: json['urdu'] as String? ?? '',
      hindi: json['hindi'] as String? ?? '',
      narrator: json['narrator'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hadith_number': hadithNumber,
        'arabic': arabic,
        'english': english,
        'urdu': urdu,
        'hindi': hindi,
        'narrator': narrator,
        'grade': grade,
        'reference': reference,
      };
}

/// Hajj guide step for Firestore
class HajjStepFirestore {
  final MultilingualText day;
  final MultilingualText title;
  final String icon;
  final String color;
  final List<MultilingualText> steps;

  HajjStepFirestore({
    required this.day,
    required this.title,
    required this.icon,
    required this.color,
    required this.steps,
  });

  factory HajjStepFirestore.fromJson(Map<String, dynamic> json) {
    return HajjStepFirestore(
      day: MultilingualText.fromJson(json['day'] as Map<String, dynamic>?),
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      icon: json['icon'] as String? ?? '',
      color: json['color'] as String? ?? '#000000',
      steps: (json['steps'] as List<dynamic>? ?? [])
          .map((s) => MultilingualText.fromJson(s as Map<String, dynamic>?))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day.toJson(),
        'title': title.toJson(),
        'icon': icon,
        'color': color,
        'steps': steps.map((s) => s.toJson()).toList(),
      };
}

/// Hajj dua for Firestore
class HajjDuaFirestore {
  final String id;
  final MultilingualText title;
  final String arabic;
  final MultilingualText translation;

  HajjDuaFirestore({
    required this.id,
    required this.title,
    required this.arabic,
    required this.translation,
  });

  factory HajjDuaFirestore.fromJson(Map<String, dynamic> json) {
    return HajjDuaFirestore(
      id: json['id'] as String? ?? '',
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      arabic: json['arabic'] as String? ?? '',
      translation:
          MultilingualText.fromJson(json['translation'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'arabic': arabic,
        'translation': translation.toJson(),
      };
}

/// Ramadan dua for Firestore
class RamadanDuaFirestore {
  final String titleKey;
  final MultilingualText title;
  final String arabic;
  final String transliteration;
  final MultilingualText translation;
  final String color;

  RamadanDuaFirestore({
    required this.titleKey,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.color,
  });

  factory RamadanDuaFirestore.fromJson(Map<String, dynamic> json) {
    return RamadanDuaFirestore(
      titleKey: json['title_key'] as String? ?? '',
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      translation:
          MultilingualText.fromJson(json['translation'] as Map<String, dynamic>?),
      color: json['color'] as String? ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() => {
        'title_key': titleKey,
        'title': title.toJson(),
        'arabic': arabic,
        'transliteration': transliteration,
        'translation': translation.toJson(),
        'color': color,
      };
}

/// Quran name entry (surah or para name in 4 languages)
class QuranNameEntryFirestore {
  final int number;
  final MultilingualText name;
  final int numberOfAyahs;
  final String revelationType;
  final MultilingualText englishNameTranslation;

  QuranNameEntryFirestore({
    required this.number,
    required this.name,
    this.numberOfAyahs = 0,
    this.revelationType = '',
    MultilingualText? englishNameTranslation,
  }) : englishNameTranslation = englishNameTranslation ?? const MultilingualText.empty();

  factory QuranNameEntryFirestore.fromJson(Map<String, dynamic> json) {
    return QuranNameEntryFirestore(
      number: json['number'] as int? ?? 0,
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      numberOfAyahs: json['number_of_ayahs'] as int? ?? 0,
      revelationType: json['revelation_type'] as String? ?? '',
      englishNameTranslation: MultilingualText.fromJson(
        json['english_name_translation'] as Map<String, dynamic>?,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name.toJson(),
        if (numberOfAyahs > 0) 'number_of_ayahs': numberOfAyahs,
        if (revelationType.isNotEmpty) 'revelation_type': revelationType,
        if (englishNameTranslation.isNotEmpty)
          'english_name_translation': englishNameTranslation.toJson(),
      };
}

/// Ayah content from Firebase with multilingual translations
class AyahContentFirestore {
  final int number;
  final int numberInSurah;
  final String arabicText;
  final MultilingualText translation;
  final String transliteration;
  final int juz;
  final int page;
  final int hizbQuarter;
  final bool sajda;

  AyahContentFirestore({
    required this.number,
    required this.numberInSurah,
    required this.arabicText,
    required this.translation,
    this.transliteration = '',
    this.juz = 0,
    this.page = 0,
    this.hizbQuarter = 0,
    this.sajda = false,
  });

  factory AyahContentFirestore.fromJson(Map<String, dynamic> json) {
    return AyahContentFirestore(
      number: json['number'] as int? ?? 0,
      numberInSurah: json['number_in_surah'] as int? ?? 0,
      arabicText: json['arabic_text'] as String? ?? '',
      translation: MultilingualText.fromJson(
        json['translation'] as Map<String, dynamic>?,
      ),
      transliteration: json['transliteration'] as String? ?? '',
      juz: json['juz'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      hizbQuarter: json['hizb_quarter'] as int? ?? 0,
      sajda: json['sajda'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'number_in_surah': numberInSurah,
        'arabic_text': arabicText,
        'translation': translation.toJson(),
        'transliteration': transliteration,
        'juz': juz,
        'page': page,
        'hizb_quarter': hizbQuarter,
        'sajda': sajda,
      };
}

/// Full surah content from Firebase (all ayahs with translations)
class SurahContentFirestore {
  final int number;
  final MultilingualText name;
  final int numberOfAyahs;
  final String revelationType;
  final MultilingualText englishNameTranslation;
  final List<AyahContentFirestore> ayahs;

  SurahContentFirestore({
    required this.number,
    required this.name,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.englishNameTranslation,
    required this.ayahs,
  });

  factory SurahContentFirestore.fromJson(Map<String, dynamic> json) {
    return SurahContentFirestore(
      number: json['number'] as int? ?? 0,
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      numberOfAyahs: json['number_of_ayahs'] as int? ?? 0,
      revelationType: json['revelation_type'] as String? ?? '',
      englishNameTranslation: MultilingualText.fromJson(
        json['english_name_translation'] as Map<String, dynamic>?,
      ),
      ayahs: (json['ayahs'] as List<dynamic>? ?? [])
          .map((a) => AyahContentFirestore.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name.toJson(),
        'number_of_ayahs': numberOfAyahs,
        'revelation_type': revelationType,
        'english_name_translation': englishNameTranslation.toJson(),
        'ayahs': ayahs.map((a) => a.toJson()).toList(),
      };
}

/// Fasting dua for Firestore
class FastingDuaFirestore {
  final String titleKey;
  final MultilingualText title;
  final String arabic;
  final String transliteration;
  final MultilingualText translation;
  final String color;
  final String? reference;

  FastingDuaFirestore({
    required this.titleKey,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.color,
    this.reference,
  });

  factory FastingDuaFirestore.fromJson(Map<String, dynamic> json) {
    return FastingDuaFirestore(
      titleKey: json['title_key'] as String? ?? '',
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      translation:
          MultilingualText.fromJson(json['translation'] as Map<String, dynamic>?),
      color: json['color'] as String? ?? '#000000',
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title_key': titleKey,
        'title': title.toJson(),
        'arabic': arabic,
        'transliteration': transliteration,
        'translation': translation.toJson(),
        'color': color,
        'reference': reference,
      };
}

/// Zakat guide section for Firestore
class ZakatSectionFirestore {
  final String icon;
  final MultilingualText title;
  final MultilingualText content;

  ZakatSectionFirestore({
    required this.icon,
    required this.title,
    required this.content,
  });

  factory ZakatSectionFirestore.fromJson(Map<String, dynamic> json) {
    return ZakatSectionFirestore(
      icon: json['icon'] as String? ?? '',
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      content:
          MultilingualText.fromJson(json['content'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'title': title.toJson(),
        'content': content.toJson(),
      };
}

/// Qibla screen content model for Firestore with multilingual support
class QiblaContentFirestore {
  final Map<String, MultilingualText> strings;
  final String duaArabicText;

  QiblaContentFirestore({
    required this.strings,
    required this.duaArabicText,
  });

  factory QiblaContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }
    return QiblaContentFirestore(
      strings: stringsMap,
      duaArabicText: json['dua_arabic_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {
      'strings': stringsJson,
      'dua_arabic_text': duaArabicText,
    };
  }

  /// Get a translated string by key and language code
  /// Falls back to English, then to the key itself
  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }
}

/// Tasbih screen content model for Firestore with multilingual support
class TasbihScreenContentFirestore {
  final Map<String, MultilingualText> strings;

  TasbihScreenContentFirestore({required this.strings});

  factory TasbihScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }
    return TasbihScreenContentFirestore(strings: stringsMap);
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {'strings': stringsJson};
  }

  /// Get a translated string by key and language code
  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }
}

/// Important date entry for calendar screen (loaded from Firebase)
class ImportantDateEntry {
  final int month;
  final int day;
  final String titleKey;
  final String descKey;
  final String icon;

  ImportantDateEntry({
    required this.month,
    required this.day,
    required this.titleKey,
    required this.descKey,
    required this.icon,
  });

  factory ImportantDateEntry.fromJson(Map<String, dynamic> json) {
    return ImportantDateEntry(
      month: json['month'] as int? ?? 1,
      day: json['day'] as int? ?? 1,
      titleKey: json['title_key'] as String? ?? '',
      descKey: json['desc_key'] as String? ?? '',
      icon: json['icon'] as String? ?? 'star',
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month,
        'day': day,
        'title_key': titleKey,
        'desc_key': descKey,
        'icon': icon,
      };
}

/// Calendar screen content model for Firestore with multilingual support
class CalendarScreenContentFirestore {
  final Map<String, MultilingualText> strings;
  final Map<String, List<String>> islamicMonths;
  final Map<String, List<String>> daysOfWeek;
  final Map<String, List<String>> islamicDaysOfWeek;
  final Map<String, List<String>> gregorianMonths;
  final Map<String, String> urduNumerals;
  final List<ImportantDateEntry> importantDates;

  CalendarScreenContentFirestore({
    required this.strings,
    required this.islamicMonths,
    required this.daysOfWeek,
    required this.islamicDaysOfWeek,
    required this.gregorianMonths,
    required this.urduNumerals,
    required this.importantDates,
  });

  factory CalendarScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }
    return CalendarScreenContentFirestore(
      strings: stringsMap,
      islamicMonths: _parseListMap(json['islamic_months']),
      daysOfWeek: _parseListMap(json['days_of_week']),
      islamicDaysOfWeek: _parseListMap(json['islamic_days_of_week']),
      gregorianMonths: _parseListMap(json['gregorian_months']),
      urduNumerals: (json['urdu_numerals'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, v.toString())),
      importantDates: (json['important_dates'] as List<dynamic>? ?? [])
          .map((e) => ImportantDateEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static Map<String, List<String>> _parseListMap(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map((key, value) {
      final list = (value as List<dynamic>).map((e) => e.toString()).toList();
      return MapEntry(key, list);
    });
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {
      'strings': stringsJson,
      'islamic_months': islamicMonths,
      'days_of_week': daysOfWeek,
      'islamic_days_of_week': islamicDaysOfWeek,
      'gregorian_months': gregorianMonths,
      'urdu_numerals': urduNumerals,
      'important_dates': importantDates.map((e) => e.toJson()).toList(),
    };
  }

  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }

  List<String> getIslamicMonths(String langCode) {
    return islamicMonths[langCode] ?? islamicMonths['en'] ?? [];
  }

  List<String> getDaysOfWeek(String langCode) {
    return daysOfWeek[langCode] ?? daysOfWeek['en'] ?? [];
  }

  List<String> getIslamicDaysOfWeek(String langCode) {
    return islamicDaysOfWeek[langCode] ?? islamicDaysOfWeek['en'] ?? [];
  }

  List<String> getGregorianMonths(String langCode) {
    return gregorianMonths[langCode] ?? gregorianMonths['en'] ?? [];
  }

  String toUrduNumerals(dynamic number) {
    String numStr = number.toString();
    for (final entry in urduNumerals.entries) {
      numStr = numStr.replaceAll(entry.key, entry.value);
    }
    return numStr;
  }
}

/// Country zakat data entry for Firebase
class CountryZakatDataEntry {
  final String countryCode;
  final MultilingualText countryName;
  final String currencyCode;
  final MultilingualText currencyName;
  final MultilingualText currencySymbol;
  final String flag;
  final double goldPricePerGram;
  final double silverPricePerGram;

  CountryZakatDataEntry({
    required this.countryCode,
    required this.countryName,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.flag,
    required this.goldPricePerGram,
    required this.silverPricePerGram,
  });

  factory CountryZakatDataEntry.fromJson(Map<String, dynamic> json) {
    return CountryZakatDataEntry(
      countryCode: json['country_code'] as String? ?? '',
      countryName: MultilingualText.fromJson(json['country_name'] as Map<String, dynamic>?),
      currencyCode: json['currency_code'] as String? ?? '',
      currencyName: MultilingualText.fromJson(json['currency_name'] as Map<String, dynamic>?),
      currencySymbol: MultilingualText.fromJson(json['currency_symbol'] as Map<String, dynamic>?),
      flag: json['flag'] as String? ?? '',
      goldPricePerGram: (json['gold_price_per_gram'] as num?)?.toDouble() ?? 0,
      silverPricePerGram: (json['silver_price_per_gram'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'country_code': countryCode,
        'country_name': countryName.toJson(),
        'currency_code': currencyCode,
        'currency_name': currencyName.toJson(),
        'currency_symbol': currencySymbol.toJson(),
        'flag': flag,
        'gold_price_per_gram': goldPricePerGram,
        'silver_price_per_gram': silverPricePerGram,
      };
}

/// Zakat calculator screen content model for Firestore
class ZakatCalculatorContentFirestore {
  final Map<String, MultilingualText> strings;
  final List<CountryZakatDataEntry> countries;
  final double nisabGoldGrams;
  final double nisabSilverGrams;

  ZakatCalculatorContentFirestore({
    required this.strings,
    required this.countries,
    required this.nisabGoldGrams,
    required this.nisabSilverGrams,
  });

  factory ZakatCalculatorContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }
    return ZakatCalculatorContentFirestore(
      strings: stringsMap,
      countries: (json['countries'] as List<dynamic>? ?? [])
          .map((e) => CountryZakatDataEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      nisabGoldGrams: (json['nisab_gold_grams'] as num?)?.toDouble() ?? 87.48,
      nisabSilverGrams: (json['nisab_silver_grams'] as num?)?.toDouble() ?? 612.36,
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {
      'nisab_gold_grams': nisabGoldGrams,
      'nisab_silver_grams': nisabSilverGrams,
      'strings': stringsJson,
      'countries': countries.map((e) => e.toJson()).toList(),
    };
  }

  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }

  CountryZakatDataEntry getByCountryCode(String code) {
    return countries.firstWhere(
      (c) => c.countryCode == code,
      orElse: () => countries.first,
    );
  }
}

/// Zakat guide section entry for Firebase (full content)
class ZakatGuideSectionEntry {
  final String icon;
  final int iconCode;
  final MultilingualText title;
  final MultilingualText content;

  ZakatGuideSectionEntry({
    required this.icon,
    required this.iconCode,
    required this.title,
    required this.content,
  });

  factory ZakatGuideSectionEntry.fromJson(Map<String, dynamic> json) {
    return ZakatGuideSectionEntry(
      icon: json['icon'] as String? ?? 'star',
      iconCode: json['icon_code'] as int? ?? 0xe5f9,
      title: MultilingualText.fromJson(json['title'] as Map<String, dynamic>?),
      content: MultilingualText.fromJson(json['content'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'icon_code': iconCode,
        'title': title.toJson(),
        'content': content.toJson(),
      };
}

/// Zakat guide screen content model for Firestore
class ZakatGuideContentFirestore {
  final Map<String, MultilingualText> strings;
  final List<ZakatGuideSectionEntry> sections;

  ZakatGuideContentFirestore({
    required this.strings,
    required this.sections,
  });

  factory ZakatGuideContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }
    return ZakatGuideContentFirestore(
      strings: stringsMap,
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((e) => ZakatGuideSectionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {
      'strings': stringsJson,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }

  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }
}

/// Juz/Para data entry for Firestore
class JuzDataEntry {
  final int number;
  final String arabicName;
  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;

  JuzDataEntry({
    required this.number,
    required this.arabicName,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
  });

  factory JuzDataEntry.fromJson(Map<String, dynamic> json) {
    return JuzDataEntry(
      number: json['number'] as int? ?? 0,
      arabicName: json['arabic_name'] as String? ?? '',
      startSurah: json['start_surah'] as int? ?? 0,
      startAyah: json['start_ayah'] as int? ?? 0,
      endSurah: json['end_surah'] as int? ?? 0,
      endAyah: json['end_ayah'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'arabic_name': arabicName,
        'start_surah': startSurah,
        'start_ayah': startAyah,
        'end_surah': endSurah,
        'end_ayah': endAyah,
      };
}

/// Quran screen content model for Firestore
/// Contains surah names, para names, transliterations, and juz data
/// Language config entry for Firestore
class QuranLanguageConfigEntry {
  final String translationId;
  final MultilingualText displayName;

  QuranLanguageConfigEntry({
    required this.translationId,
    required this.displayName,
  });

  factory QuranLanguageConfigEntry.fromJson(Map<String, dynamic> json) {
    return QuranLanguageConfigEntry(
      translationId: json['translation_id'] as String? ?? '',
      displayName: MultilingualText.fromJson(json['display_name'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'translation_id': translationId,
        'display_name': displayName.toJson(),
      };
}

/// Translation/Reciter option entry for Firestore
class QuranOptionEntry {
  final String id;
  final MultilingualText name;

  QuranOptionEntry({required this.id, required this.name});

  factory QuranOptionEntry.fromJson(Map<String, dynamic> json) {
    return QuranOptionEntry(
      id: json['id'] as String? ?? '',
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name.toJson(),
      };
}

class QuranScreenContentFirestore {
  final List<QuranNameEntryFirestore> surahNames;
  final List<QuranNameEntryFirestore> paraNames;
  final Map<String, Map<String, String>> surahTransliterations;
  final List<JuzDataEntry> juzData;
  final Map<String, QuranLanguageConfigEntry> languageConfig;
  final List<QuranOptionEntry> availableTranslations;
  final List<QuranOptionEntry> availableReciters;

  QuranScreenContentFirestore({
    required this.surahNames,
    required this.paraNames,
    required this.surahTransliterations,
    required this.juzData,
    required this.languageConfig,
    required this.availableTranslations,
    required this.availableReciters,
  });

  factory QuranScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    // Parse transliterations
    final translitMap = <String, Map<String, String>>{};
    final rawTranslit = json['surah_transliterations'] as Map<String, dynamic>? ?? {};
    for (final lang in ['urdu', 'hindi']) {
      if (rawTranslit[lang] is Map) {
        translitMap[lang] = Map<String, String>.from(rawTranslit[lang] as Map);
      }
    }

    // Parse language config
    final langConfigMap = <String, QuranLanguageConfigEntry>{};
    final rawLangConfig = json['language_config'] as Map<String, dynamic>? ?? {};
    for (final entry in rawLangConfig.entries) {
      langConfigMap[entry.key] = QuranLanguageConfigEntry.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    return QuranScreenContentFirestore(
      surahNames: (json['surah_names'] as List<dynamic>? ?? [])
          .map((e) => QuranNameEntryFirestore.fromJson(e as Map<String, dynamic>))
          .toList(),
      paraNames: (json['para_names'] as List<dynamic>? ?? [])
          .map((e) => QuranNameEntryFirestore.fromJson(e as Map<String, dynamic>))
          .toList(),
      surahTransliterations: translitMap,
      juzData: (json['juz_data'] as List<dynamic>? ?? [])
          .map((e) => JuzDataEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      languageConfig: langConfigMap,
      availableTranslations: (json['available_translations'] as List<dynamic>? ?? [])
          .map((e) => QuranOptionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableReciters: (json['available_reciters'] as List<dynamic>? ?? [])
          .map((e) => QuranOptionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final langConfigJson = <String, dynamic>{};
    for (final entry in languageConfig.entries) {
      langConfigJson[entry.key] = entry.value.toJson();
    }
    return {
      'surah_names': surahNames.map((e) => e.toJson()).toList(),
      'para_names': paraNames.map((e) => e.toJson()).toList(),
      'surah_transliterations': surahTransliterations,
      'juz_data': juzData.map((e) => e.toJson()).toList(),
      'language_config': langConfigJson,
      'available_translations': availableTranslations.map((e) => e.toJson()).toList(),
      'available_reciters': availableReciters.map((e) => e.toJson()).toList(),
    };
  }

  /// Get surah name by number and language code
  String getSurahName(int number, String langCode) {
    final entry = surahNames.firstWhere(
      (e) => e.number == number,
      orElse: () => QuranNameEntryFirestore(
        number: number,
        name: MultilingualText(en: 'Surah $number'),
      ),
    );
    return entry.name.get(langCode);
  }

  /// Get para name by number and language code
  String getParaName(int number, String langCode) {
    final entry = paraNames.firstWhere(
      (e) => e.number == number,
      orElse: () => QuranNameEntryFirestore(
        number: number,
        name: MultilingualText(en: 'Para $number'),
      ),
    );
    return entry.name.get(langCode);
  }

  /// Get Urdu transliteration for a cleaned Arabic surah name
  String getUrduTransliteration(String cleanedArabicName, String fallback) {
    return surahTransliterations['urdu']?[cleanedArabicName] ?? fallback;
  }

  /// Get Hindi transliteration for a cleaned Arabic surah name
  String getHindiTransliteration(String cleanedArabicName, String fallback) {
    return surahTransliterations['hindi']?[cleanedArabicName] ?? fallback;
  }

  /// Get translation ID for a language key (english, hindi, urdu, arabic)
  String getTranslationId(String langKey) {
    return languageConfig[langKey]?.translationId ?? 'en.sahih';
  }

  /// Get language display name
  String getLanguageDisplayName(String langKey, String displayLangCode) {
    return languageConfig[langKey]?.displayName.get(displayLangCode) ?? langKey;
  }

  /// Get translation name by ID and language code
  String getTranslationName(String translationId, String langCode) {
    final entry = availableTranslations.firstWhere(
      (e) => e.id == translationId,
      orElse: () => QuranOptionEntry(id: translationId, name: MultilingualText(en: translationId)),
    );
    return entry.name.get(langCode);
  }

  /// Get reciter name by ID and language code
  String getReciterName(String reciterId, String langCode) {
    final entry = availableReciters.firstWhere(
      (e) => e.id == reciterId,
      orElse: () => QuranOptionEntry(id: reciterId, name: MultilingualText(en: reciterId)),
    );
    return entry.name.get(langCode);
  }
}

/// Prayer item model for Firebase
class PrayerItemFirestore {
  final String key;
  final MultilingualText name;
  final String icon;
  final String apiKey;

  PrayerItemFirestore({
    required this.key,
    required this.name,
    required this.icon,
    required this.apiKey,
  });

  factory PrayerItemFirestore.fromJson(Map<String, dynamic> json) {
    return PrayerItemFirestore(
      key: json['key'] as String? ?? '',
      name: MultilingualText.fromJson(json['name'] as Map<String, dynamic>?),
      icon: json['icon'] as String? ?? '',
      apiKey: json['api_key'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name.toJson(),
    'icon': icon,
    'api_key': apiKey,
  };
}

/// Prayer times screen content model for Firestore with multilingual support
class PrayerTimesScreenContentFirestore {
  final Map<String, MultilingualText> strings;
  final List<PrayerItemFirestore> prayerItems;
  final Map<String, MultilingualText> gregorianMonths;
  final Map<String, MultilingualText> hijriMonths;

  PrayerTimesScreenContentFirestore({
    required this.strings,
    required this.prayerItems,
    required this.gregorianMonths,
    required this.hijriMonths,
  });

  factory PrayerTimesScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final prayerItemsList = <PrayerItemFirestore>[];
    final rawItems = json['prayer_items'] as List<dynamic>? ?? [];
    for (final item in rawItems) {
      prayerItemsList.add(PrayerItemFirestore.fromJson(item as Map<String, dynamic>));
    }

    final gregorianMap = <String, MultilingualText>{};
    final rawGregorian = json['gregorian_months'] as Map<String, dynamic>? ?? {};
    for (final entry in rawGregorian.entries) {
      gregorianMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final hijriMap = <String, MultilingualText>{};
    final rawHijri = json['hijri_months'] as Map<String, dynamic>? ?? {};
    for (final entry in rawHijri.entries) {
      hijriMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    return PrayerTimesScreenContentFirestore(
      strings: stringsMap,
      prayerItems: prayerItemsList,
      gregorianMonths: gregorianMap,
      hijriMonths: hijriMap,
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }

    final gregorianJson = <String, dynamic>{};
    for (final entry in gregorianMonths.entries) {
      gregorianJson[entry.key] = entry.value.toJson();
    }

    final hijriJson = <String, dynamic>{};
    for (final entry in hijriMonths.entries) {
      hijriJson[entry.key] = entry.value.toJson();
    }

    return {
      'strings': stringsJson,
      'prayer_items': prayerItems.map((e) => e.toJson()).toList(),
      'gregorian_months': gregorianJson,
      'hijri_months': hijriJson,
    };
  }

  /// Get a translated string by key and language code
  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }

  /// Get translated prayer name by key and language code
  String getPrayerName(String key, String languageCode) {
    final item = prayerItems.firstWhere(
      (e) => e.key == key.toLowerCase(),
      orElse: () => PrayerItemFirestore(
        key: key, name: MultilingualText(en: key), icon: '', apiKey: key,
      ),
    );
    return item.name.get(languageCode);
  }

  /// Get prayer icon by key
  String getPrayerIcon(String key) {
    final item = prayerItems.firstWhere(
      (e) => e.key == key.toLowerCase(),
      orElse: () => PrayerItemFirestore(
        key: key, name: MultilingualText(en: key), icon: '🕌', apiKey: key,
      ),
    );
    return item.icon;
  }

  /// Get translated Gregorian month name
  String getGregorianMonth(String monthKey, String languageCode) {
    final text = gregorianMonths[monthKey.toLowerCase()];
    if (text == null) return monthKey;
    return text.get(languageCode);
  }

  /// Get translated Hijri month name
  String getHijriMonth(String monthKey, String languageCode) {
    final text = hijriMonths[monthKey];
    if (text == null) return monthKey;
    return text.get(languageCode);
  }
}

/// Notifications screen content model for Firestore with multilingual support
class NotificationsScreenContentFirestore {
  final Map<String, MultilingualText> strings;
  final Map<String, MultilingualText> dayNames;
  final Map<String, MultilingualText> monthAbbreviations;

  NotificationsScreenContentFirestore({
    required this.strings,
    required this.dayNames,
    required this.monthAbbreviations,
  });

  factory NotificationsScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final dayNamesMap = <String, MultilingualText>{};
    final rawDayNames = json['day_names'] as Map<String, dynamic>? ?? {};
    for (final entry in rawDayNames.entries) {
      dayNamesMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final monthAbbrMap = <String, MultilingualText>{};
    final rawMonthAbbr = json['month_abbreviations'] as Map<String, dynamic>? ?? {};
    for (final entry in rawMonthAbbr.entries) {
      monthAbbrMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    return NotificationsScreenContentFirestore(
      strings: stringsMap,
      dayNames: dayNamesMap,
      monthAbbreviations: monthAbbrMap,
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }

    final dayNamesJson = <String, dynamic>{};
    for (final entry in dayNames.entries) {
      dayNamesJson[entry.key] = entry.value.toJson();
    }

    final monthAbbrJson = <String, dynamic>{};
    for (final entry in monthAbbreviations.entries) {
      monthAbbrJson[entry.key] = entry.value.toJson();
    }

    return {
      'strings': stringsJson,
      'day_names': dayNamesJson,
      'month_abbreviations': monthAbbrJson,
    };
  }

  /// Get a translated string by key and language code
  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }

  /// Get translated day name
  String getDayName(String dayKey, String languageCode) {
    final text = dayNames[dayKey.toLowerCase()];
    if (text == null) return dayKey;
    return text.get(languageCode);
  }

  /// Get translated month abbreviation (0-indexed month number)
  String getMonthAbbr(int monthIndex, String languageCode) {
    final keys = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
    if (monthIndex < 0 || monthIndex >= keys.length) return '';
    final text = monthAbbreviations[keys[monthIndex]];
    if (text == null) return keys[monthIndex];
    return text.get(languageCode);
  }
}

/// Language entry for settings screen
class LanguageEntryFirestore {
  final String code;
  final String name;
  final String nativeName;
  final String icon;

  LanguageEntryFirestore({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.icon,
  });

  factory LanguageEntryFirestore.fromJson(Map<String, dynamic> json) {
    return LanguageEntryFirestore(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nativeName: json['native_name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'native_name': nativeName,
    'icon': icon,
  };
}

/// Settings screen content model for Firestore with multilingual support
class SettingsScreenContentFirestore {
  final Map<String, MultilingualText> strings;
  final List<String> defaultUserNames;
  final List<LanguageEntryFirestore> languages;
  final Map<String, Map<String, String>> cityTranslations;
  final Map<String, Map<String, String>> countryTranslations;
  final Map<String, Map<String, String>> nameTransliterations;

  SettingsScreenContentFirestore({
    required this.strings,
    required this.defaultUserNames,
    required this.languages,
    required this.cityTranslations,
    required this.countryTranslations,
    required this.nameTransliterations,
  });

  factory SettingsScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final langList = <LanguageEntryFirestore>[];
    final rawLangs = json['languages'] as List<dynamic>? ?? [];
    for (final lang in rawLangs) {
      langList.add(LanguageEntryFirestore.fromJson(lang as Map<String, dynamic>));
    }

    final defaultNames = (json['default_user_names'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final cityMap = <String, Map<String, String>>{};
    final rawCities = json['city_translations'] as Map<String, dynamic>? ?? {};
    for (final entry in rawCities.entries) {
      cityMap[entry.key] = Map<String, String>.from(entry.value as Map);
    }

    final countryMap = <String, Map<String, String>>{};
    final rawCountries = json['country_translations'] as Map<String, dynamic>? ?? {};
    for (final entry in rawCountries.entries) {
      countryMap[entry.key] = Map<String, String>.from(entry.value as Map);
    }

    final nameMap = <String, Map<String, String>>{};
    final rawNames = json['name_transliterations'] as Map<String, dynamic>? ?? {};
    for (final entry in rawNames.entries) {
      nameMap[entry.key] = Map<String, String>.from(entry.value as Map);
    }

    return SettingsScreenContentFirestore(
      strings: stringsMap,
      defaultUserNames: defaultNames,
      languages: langList,
      cityTranslations: cityMap,
      countryTranslations: countryMap,
      nameTransliterations: nameMap,
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }

    final cityJson = <String, dynamic>{};
    for (final entry in cityTranslations.entries) {
      cityJson[entry.key] = entry.value;
    }

    final countryJson = <String, dynamic>{};
    for (final entry in countryTranslations.entries) {
      countryJson[entry.key] = entry.value;
    }

    final nameJson = <String, dynamic>{};
    for (final entry in nameTransliterations.entries) {
      nameJson[entry.key] = entry.value;
    }

    return {
      'strings': stringsJson,
      'default_user_names': defaultUserNames,
      'languages': languages.map((e) => e.toJson()).toList(),
      'city_translations': cityJson,
      'country_translations': countryJson,
      'name_transliterations': nameJson,
    };
  }

  /// Get a translated string by key and language code
  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }

  /// Get translated city name
  String getCityName(String city, String languageCode) {
    final cityData = cityTranslations[city];
    if (cityData != null) {
      return cityData[languageCode] ?? city;
    }
    return city;
  }

  /// Get translated country name
  String getCountryName(String country, String languageCode) {
    final countryData = countryTranslations[country];
    if (countryData != null) {
      return countryData[languageCode] ?? country;
    }
    return country;
  }

  /// Get transliterated name
  String transliterateName(String name, String languageCode) {
    if (languageCode == 'en') return name;

    List<String> nameParts = name.split(' ');
    List<String> transliteratedParts = [];

    for (String part in nameParts) {
      final transliteration = nameTransliterations[part];
      if (transliteration != null) {
        transliteratedParts.add(transliteration[languageCode] ?? part);
      } else {
        transliteratedParts.add(part);
      }
    }

    return transliteratedParts.join(' ');
  }
}

/// About screen content model for Firestore with multilingual support
class AboutScreenContentFirestore {
  final Map<String, MultilingualText> strings;
  final List<AboutFeatureItem> features;

  AboutScreenContentFirestore({
    required this.strings,
    required this.features,
  });

  factory AboutScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final featuresList = <AboutFeatureItem>[];
    final rawFeatures = json['features'] as List<dynamic>? ?? [];
    for (final item in rawFeatures) {
      featuresList.add(AboutFeatureItem.fromJson(item as Map<String, dynamic>));
    }

    return AboutScreenContentFirestore(
      strings: stringsMap,
      features: featuresList,
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {
      'strings': stringsJson,
      'features': features.map((f) => f.toJson()).toList(),
    };
  }

  /// Get a translated string by key and language code
  /// Falls back to English, then to the key itself
  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }
}

/// Feature item for the about screen
class AboutFeatureItem {
  final String key;
  final String icon;

  AboutFeatureItem({required this.key, required this.icon});

  factory AboutFeatureItem.fromJson(Map<String, dynamic> json) {
    return AboutFeatureItem(
      key: json['key'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'icon': icon,
      };
}

/// Privacy policy screen content model for Firestore with multilingual support
class PrivacyPolicyScreenContentFirestore {
  final Map<String, MultilingualText> strings;
  final List<PrivacyPolicySectionItem> sections;

  PrivacyPolicyScreenContentFirestore({
    required this.strings,
    required this.sections,
  });

  factory PrivacyPolicyScreenContentFirestore.fromJson(Map<String, dynamic> json) {
    final stringsMap = <String, MultilingualText>{};
    final rawStrings = json['strings'] as Map<String, dynamic>? ?? {};
    for (final entry in rawStrings.entries) {
      stringsMap[entry.key] = MultilingualText.fromJson(
        entry.value as Map<String, dynamic>?,
      );
    }

    final sectionsList = <PrivacyPolicySectionItem>[];
    final rawSections = json['sections'] as List<dynamic>? ?? [];
    for (final item in rawSections) {
      sectionsList.add(PrivacyPolicySectionItem.fromJson(item as Map<String, dynamic>));
    }

    return PrivacyPolicyScreenContentFirestore(
      strings: stringsMap,
      sections: sectionsList,
    );
  }

  Map<String, dynamic> toJson() {
    final stringsJson = <String, dynamic>{};
    for (final entry in strings.entries) {
      stringsJson[entry.key] = entry.value.toJson();
    }
    return {
      'strings': stringsJson,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }

  String getString(String key, String languageCode) {
    final text = strings[key];
    if (text == null) return key;
    return text.get(languageCode);
  }
}

/// Section item for the privacy policy screen
class PrivacyPolicySectionItem {
  final String titleKey;
  final String contentKey;
  final String icon;

  PrivacyPolicySectionItem({
    required this.titleKey,
    required this.contentKey,
    required this.icon,
  });

  factory PrivacyPolicySectionItem.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicySectionItem(
      titleKey: json['title_key'] as String? ?? '',
      contentKey: json['content_key'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title_key': titleKey,
        'content_key': contentKey,
        'icon': icon,
      };
}

/// UI translations model - all app translations in 4 languages
class UITranslationsFirestore {
  final Map<String, Map<String, String>> translations;

  UITranslationsFirestore({required this.translations});

  factory UITranslationsFirestore.fromJson(Map<String, dynamic> json) {
    final translationsMap = <String, Map<String, String>>{};
    final rawTranslations =
        json['translations'] as Map<String, dynamic>? ?? {};

    for (final langEntry in rawTranslations.entries) {
      final langCode = langEntry.key;
      final keysMap = langEntry.value as Map<String, dynamic>;
      translationsMap[langCode] =
          keysMap.map((k, v) => MapEntry(k, v.toString()));
    }

    return UITranslationsFirestore(translations: translationsMap);
  }

  Map<String, dynamic> toJson() => {
        'translations': translations,
      };
}
