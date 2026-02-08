import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../data/dua_data.dart';
import '../../data/models/dua_model.dart';

// Import screen data sources
import '../../screens/greeting_cards/greeting_cards_screen.dart'
    show islamicMonths;
import '../../providers/adhan_provider.dart'
    show
        getHardcodedPrayerNotificationStrings,
        getHardcodedIslamicReminderStrings;
import '../../core/constants/app_strings.dart';
import '../../core/utils/hadith_translator.dart'
    show getHardcodedHadithTranslations;
import '../../core/utils/language_helpers.dart' show getHardcodedLanguageNames;

// Settings translations (moved from settings_screen.dart to avoid static data in screen files)
Map<String, Map<String, String>> getHardcodedCityTranslations() => {
  'Bengaluru': {'en': 'Bengaluru', 'ur': 'بنگلور', 'ar': 'بنغالور', 'hi': 'बेंगलुरु'},
  'Mumbai': {'en': 'Mumbai', 'ur': 'ممبئی', 'ar': 'مومباي', 'hi': 'मुंबई'},
  'Delhi': {'en': 'Delhi', 'ur': 'دہلی', 'ar': 'دلهي', 'hi': 'दिल्ली'},
  'New Delhi': {'en': 'New Delhi', 'ur': 'نئی دہلی', 'ar': 'نيودلهي', 'hi': 'नई دिल्ली'},
  'Kolkata': {'en': 'Kolkata', 'ur': 'کولکاتا', 'ar': 'كولكاتا', 'hi': 'कोलकाता'},
  'Chennai': {'en': 'Chennai', 'ur': 'چنئی', 'ar': 'تشيناي', 'hi': 'चेन्नई'},
  'Hyderabad': {'en': 'Hyderabad', 'ur': 'حیدرآباد', 'ar': 'حيدر أباد', 'hi': 'हैदराबाद'},
  'Pune': {'en': 'Pune', 'ur': 'پونے', 'ar': 'بونا', 'hi': 'पुणे'},
  'Ahmedabad': {'en': 'Ahmedabad', 'ur': 'احمد آباد', 'ar': 'أحمد آباد', 'hi': 'अहمदाबाद'},
  'Jaipur': {'en': 'Jaipur', 'ur': 'جے پور', 'ar': 'جايبور', 'hi': 'जयपुर'},
  'Lucknow': {'en': 'Lucknow', 'ur': 'لکھنؤ', 'ar': 'لكناو', 'hi': 'लखنऊ'},
  'Karachi': {'en': 'Karachi', 'ur': 'کراچی', 'ar': 'كراتشي', 'hi': 'कراची'},
  'Lahore': {'en': 'Lahore', 'ur': 'لاہور', 'ar': 'لاهور', 'hi': 'لاहौر'},
  'Islamabad': {'en': 'Islamabad', 'ur': 'اسلام آباد', 'ar': 'إسلام آباد', 'hi': 'इस्लामाबाद'},
  'Dhaka': {'en': 'Dhaka', 'ur': 'ڈھاکہ', 'ar': 'دكا', 'hi': 'ढاका'},
  'Mecca': {'en': 'Mecca', 'ur': 'مکہ', 'ar': 'مكة', 'hi': 'مक्का'},
  'Medina': {'en': 'Medina', 'ur': 'مدینہ', 'ar': 'المدينة', 'hi': 'مدीना'},
  'Riyadh': {'en': 'Riyadh', 'ur': 'ریاض', 'ar': 'الرياض', 'hi': 'رियاد'},
  'Dubai': {'en': 'Dubai', 'ur': 'دبئی', 'ar': 'دبي', 'hi': 'دुبई'},
  'Abu Dhabi': {'en': 'Abu Dhabi', 'ur': 'ابوظبی', 'ar': 'أبو ظبي', 'hi': 'अबू धाबी'},
};

Map<String, Map<String, String>> getHardcodedCountryTranslations() => {
  'India': {'en': 'India', 'ur': 'بھارت', 'ar': 'الهند', 'hi': 'भारत'},
  'Pakistan': {'en': 'Pakistan', 'ur': 'پاکستان', 'ar': 'باكستان', 'hi': 'पाकिस्तान'},
  'Bangladesh': {'en': 'Bangladesh', 'ur': 'بنگلہ دیش', 'ar': 'بنغلاديش', 'hi': 'बांग्लादेश'},
  'Saudi Arabia': {'en': 'Saudi Arabia', 'ur': 'سعودی عرب', 'ar': 'المملكة العربية السعودية', 'hi': 'सऊदी अरब'},
  'United Arab Emirates': {'en': 'United Arab Emirates', 'ur': 'متحدہ عرب امارات', 'ar': 'الإمارات العربية المتحدة', 'hi': 'संयुक्त अरब अमीरात'},
};

Map<String, Map<String, String>> getHardcodedNameTransliterations() => {
  'Mohd': {'ur': 'محمد', 'ar': 'محمد', 'hi': 'मोहम्मद'},
  'Mohammad': {'ur': 'محمد', 'ar': 'محمد', 'hi': 'मोहम्मद'},
  'Muhammad': {'ur': 'محمد', 'ar': 'محمد', 'hi': 'मुहम्मद'},
  'Ahmed': {'ur': 'احمد', 'ar': 'أحمد', 'hi': 'अहमद'},
  'Ali': {'ur': 'علی', 'ar': 'علي', 'hi': 'अली'},
  'Hassan': {'ur': 'حسن', 'ar': 'حسن', 'hi': 'हसन'},
  'Hussain': {'ur': 'حسین', 'ar': 'حسين', 'hi': 'हुसैन'},
  'Fatima': {'ur': 'فاطمہ', 'ar': 'فاطمة', 'hi': 'फातिमा'},
  'Ayesha': {'ur': 'عائشہ', 'ar': 'عائشة', 'hi': 'आयशा'},
  'Reyan': {'ur': 'ریان', 'ar': 'ريان', 'hi': 'रेयान'},
  'Rizwan': {'ur': 'رضوان', 'ar': 'رضوان', 'hi': 'रिज़वान'},
  'Khan': {'ur': 'خان', 'ar': 'خان', 'hi': 'खान'},
  'Sheikh': {'ur': 'شیخ', 'ar': 'شيخ', 'hi': 'शेख'},
};

/// Service to migrate hardcoded data to Firestore
/// This is a one-time operation to upload all app data to Firestore
class DataMigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Migrate all data to Firestore
  Future<MigrationResult> migrateAll({
    Function(String message)? onProgress,
  }) async {
    final result = MigrationResult();

    try {
      // 1. Set up version metadata first
      onProgress?.call('Setting up version metadata...');
      await _setupVersionMetadata();
      result.versionsCreated = true;

      // 2. Migrate Duas
      onProgress?.call('Migrating duas...');
      result.duasMigrated = await migrateDuas();

      // 3. Migrate Allah Names
      onProgress?.call('Migrating 99 names of Allah...');
      result.allahNamesMigrated = await migrateAllahNames();

      // 4. Migrate Kalmas
      onProgress?.call('Migrating seven kalmas...');
      result.kalmasMigrated = await _migrateKalmasFromAsset();

      // 5. Migrate Islamic Names (6 categories)
      onProgress?.call('Migrating prophet names...');
      int namesCount = 0;
      namesCount += await _migrateProphetsFromAsset();
      onProgress?.call('Migrating sahaba names...');
      namesCount += await _migrateSahabaFromAsset();
      onProgress?.call('Migrating khalifa names...');
      namesCount += await _migrateKhalifasFromAsset();
      onProgress?.call('Migrating twelve imams...');
      namesCount += await _migrateTwelveImamsFromAsset();
      onProgress?.call('Migrating panjatan names...');
      namesCount += await _migratePanjatanFromAsset();
      onProgress?.call('Migrating ahlebait names...');
      namesCount += await _migrateAhlebaitFromAsset();
      result.islamicNamesMigrated = namesCount;

      // 6. Migrate Hadith Collections
      onProgress?.call('Migrating hadith collections...');
      result.hadithMigrated = await _migrateAllHadith();

      // 7. Migrate Tasbih Dhikr (from JSON asset)
      onProgress?.call('Migrating tasbih dhikr...');
      result.tasbihMigrated = await _migrateTasbihFromAsset();

      // 8. Migrate Basic Amal Guides
      onProgress?.call('Migrating basic amal guides...');
      result.basicAmalMigrated = await _migrateAllBasicAmal(onProgress);

      // 9. Migrate Greeting Cards
      onProgress?.call('Migrating greeting cards...');
      result.greetingCardsMigrated = await migrateAllGreetingCards();

      // 10. Migrate Sample Hadiths
      onProgress?.call('Migrating sample hadiths...');
      result.sampleHadithMigrated = await _migrateAllSampleHadiths();

      // 10b. Migrate Hadith Collections Info
      onProgress?.call('Migrating hadith collections info...');
      await _migrateHadithCollectionsInfo();

      // 11. Migrate Hajj Guide
      onProgress?.call('Migrating hajj guide...');
      result.hajjGuideMigrated = await migrateHajjGuide();

      // 12. Migrate Ramadan Duas
      onProgress?.call('Migrating ramadan duas...');
      result.ramadanDuasMigrated = await migrateRamadanDuas();

      // 13. Migrate Zakat Guide
      onProgress?.call('Migrating zakat guide...');
      result.zakatGuideMigrated = await _migrateZakatGuide();

      // 14. Migrate Quran Metadata (surah & para names)
      onProgress?.call('Migrating quran metadata...');
      result.quranMetadataMigrated = await _migrateQuranMetadata();

      // 15. Migrate Fasting Data (fasting duas)
      onProgress?.call('Migrating fasting data...');
      result.fastingDataMigrated = await migrateFastingData();

      // 15b. Migrate Fasting Virtues
      onProgress?.call('Migrating fasting virtues...');
      await migrateFastingVirtues();

      // 15c. Migrate Fasting Rules
      onProgress?.call('Migrating fasting rules...');
      await migrateFastingRules();

      // 15d. Migrate Islamic Months Chart
      onProgress?.call('Migrating islamic months data...');
      await migrateIslamicMonths();

      // 16. Migrate Settings Translations
      onProgress?.call('Migrating settings translations...');
      result.settingsTranslationsMigrated =
          await _migrateSettingsTranslations();

      // 17. Migrate Notification Strings
      onProgress?.call('Migrating notification strings...');
      result.notificationStringsMigrated = await _migrateNotificationStrings();

      // 18. Migrate Calendar Strings
      onProgress?.call('Migrating calendar strings...');
      result.calendarStringsMigrated = await _migrateCalendarStrings();

      // 19. Migrate Name Transliterations
      onProgress?.call('Migrating name transliterations...');
      result.nameTransliterationsMigrated =
          await _migrateNameTransliterations();

      // 20. Migrate Hadith Translations
      onProgress?.call('Migrating hadith translations...');
      result.hadithTranslationsMigrated = await _migrateHadithTranslations();

      // 21. Migrate Language Names
      onProgress?.call('Migrating language names...');
      result.languageNamesMigrated = await _migrateLanguageNames();

      // 22. Migrate Qibla Content
      onProgress?.call('Migrating qibla content...');
      result.qiblaContentMigrated = await migrateQiblaContent();

      // 23. Migrate Tasbih Screen Content
      onProgress?.call('Migrating tasbih screen content...');
      result.tasbihScreenContentMigrated = await migrateTasbihScreenContent();

      // 24. Migrate Calendar Screen Content
      onProgress?.call('Migrating calendar screen content...');
      result.calendarScreenContentMigrated = await migrateCalendarScreenContent();

      // 25. Migrate Zakat Calculator Content
      onProgress?.call('Migrating zakat calculator content...');
      result.zakatCalculatorContentMigrated = await migrateZakatCalculatorContent();

      // 26. Migrate Zakat Guide Screen Content
      onProgress?.call('Migrating zakat guide screen content...');
      result.zakatGuideScreenContentMigrated = await migrateZakatGuideScreenContent();

      // 27. Migrate Quran Screen Content
      onProgress?.call('Migrating quran screen content...');
      result.quranScreenContentMigrated = await migrateQuranScreenContent();

      // 28. Migrate UI Translations
      onProgress?.call('Migrating UI translations...');
      result.uiTranslationsMigrated = await migrateUITranslations();

      // 29. Migrate Islamic Events
      onProgress?.call('Migrating Islamic events...');
      result.islamicEventsMigrated = await migrateIslamicEvents();

      // 30. Migrate Fasting Times Content
      onProgress?.call('Migrating fasting times content...');
      result.fastingTimesContentMigrated = await migrateFastingTimesContent();

      result.success = true;
      onProgress?.call('Migration completed successfully!');
    } catch (e) {
      result.success = false;
      result.error = e.toString();
      onProgress?.call('Migration failed: $e');
      debugPrint('Migration error: $e');
    }

    return result;
  }

  /// Set up version metadata document
  Future<void> _setupVersionMetadata() async {
    await _firestore.collection('content_metadata').doc('versions').set({
      'duas_version': 1,
      'allah_names_version': 1,
      'kalmas_version': 1,
      'islamic_names_version': 1,
      'hadith_version': 1,
      'tasbih_version': 1,
      'calendar_version': 1,
      'basic_amal_version': 1,
      'greeting_cards_version': 1,
      'sample_hadith_version': 1,
      'hajj_guide_version': 1,
      'ramadan_duas_version': 1,
      'zakat_guide_version': 1,
      'quran_metadata_version': 1,
      'fasting_data_version': 1,
      'settings_translations_version': 1,
      'notification_strings_version': 1,
      'calendar_strings_version': 1,
      'name_transliterations_version': 1,
      'hadith_translations_version': 1,
      'language_names_version': 1,
      'qibla_content_version': 1,
      'tasbih_screen_content_version': 1,
      'calendar_screen_content_version': 1,
      'zakat_calculator_content_version': 1,
      'zakat_guide_screen_content_version': 1,
      'quran_screen_content_version': 1,
      'ui_translations_version': 2,
      'fasting_times_content_version': 1,
      'islamic_events_version': 1,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  /// Migrate all duas to Firestore
  Future<int> migrateDuas() async {
    final categories = DuaData.getAllCategories();
    int count = 0;

    final batch = _firestore.batch();

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final docRef = _firestore.collection('duas').doc(category.id);

      final categoryData = {
        'name': {
          'en': category.name,
          'ur': category.nameUrdu ?? '',
          'hi': category.nameHindi ?? '',
          'ar': '',
        },
        'icon': category.icon,
        'order': i + 1,
        'duas': category.duas.map((dua) => _duaToFirestore(dua)).toList(),
      };

      batch.set(docRef, categoryData);
      count++;
    }

    await batch.commit();
    debugPrint('Migrated $count dua categories');
    return count;
  }

  /// Convert DuaModel to Firestore format
  Map<String, dynamic> _duaToFirestore(DuaModel dua) {
    return {
      'id': dua.id,
      'title': {
        'en': dua.title,
        'ur': dua.titleUrdu ?? '',
        'hi': dua.titleHindi ?? '',
        'ar': '',
      },
      'arabic': dua.arabic,
      'transliteration': dua.transliteration,
      'translation': {
        'en': dua.translationEnglish ?? dua.translation,
        'ur': dua.translationUrdu ?? '',
        'hi': dua.translationHindi ?? '',
        'ar': '',
      },
      'reference': {
        'en': dua.reference,
        'ur': dua.referenceUrdu ?? '',
        'hi': dua.referenceHindi ?? '',
        'ar': dua.referenceArabic ?? '',
      },
      'audio_url': dua.audioUrl,
      'repeat_count': dua.repeatCount,
    };
  }

  /// Migrate all 99 names of Allah to Firestore (loads from local asset JSON)
  Future<int> migrateAllahNames() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/firebase/allah_names.json',
    );
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final namesList = jsonData['names'] as List<dynamic>? ?? [];

    await _firestore.collection('allah_names').doc('all_names').set({
      'version': 1,
      'names': namesList,
    });

    debugPrint('Migrated ${namesList.length} Allah names from asset');
    return namesList.length;
  }

  /// Migrate Seven Kalmas from local asset JSON
  Future<int> _migrateKalmasFromAsset() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/firebase/kalmas.json',
    );
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final kalmasList = jsonData['kalmas'] as List<dynamic>? ?? [];

    await _firestore.collection('kalmas').doc('seven_kalmas').set(jsonData);

    debugPrint('Migrated ${kalmasList.length} kalmas from asset');
    return kalmasList.length;
  }

  /// Migrate Seven Kalmas to Firestore
  Future<int> migrateKalmas(List<Map<String, dynamic>> kalmas) async {
    final kalmasData = kalmas
        .map(
          (k) => {
            'number': k['number'],
            'name': {
              'en': k['name'] ?? '',
              'ur': k['nameUrdu'] ?? '',
              'hi': k['nameHindi'] ?? '',
              'ar': k['nameArabic'] ?? '',
            },
            'arabic': k['arabic'] ?? '',
            'transliteration': k['transliteration'] ?? '',
            'translation': {
              'en': k['translation'] ?? k['translationEnglish'] ?? '',
              'ur': k['translationUrdu'] ?? '',
              'hi': k['translationHindi'] ?? '',
              'ar': k['translationArabic'] ?? '',
            },
          },
        )
        .toList();

    await _firestore.collection('kalmas').doc('seven_kalmas').set({
      'version': 1,
      'kalmas': kalmasData,
    });

    debugPrint('Migrated ${kalmas.length} kalmas');
    return kalmas.length;
  }

  /// Migrate Islamic names (prophets, sahaba, etc.) to Firestore
  Future<int> migrateIslamicNames(
    String category,
    List<Map<String, dynamic>> names,
  ) async {
    final namesData = names
        .map(
          (n) => {
            'name': n['name'] ?? '',
            'transliteration': n['transliteration'] ?? '',
            'title': {
              'en': n['title'] ?? n['meaning'] ?? '',
              'ur': n['titleUrdu'] ?? n['meaningUrdu'] ?? '',
              'hi': n['titleHindi'] ?? n['meaningHindi'] ?? '',
              'ar': n['titleArabic'] ?? '',
            },
            'description': {
              'en': n['description'] ?? '',
              'ur': n['descriptionUrdu'] ?? '',
              'hi': n['descriptionHindi'] ?? '',
              'ar': '',
            },
            'father_name': n['fatherName'],
            'mother_name': n['motherName'],
            'birth_date': n['birthDate'],
            'birth_place': n['birthPlace'],
            'death_date': n['deathDate'],
            'death_place': n['deathPlace'],
            'spouse': n['spouse'],
            'children': n['children'],
            'tribe': n['tribe'],
            'era': n['era'],
            'known_for': n['knownFor'],
          },
        )
        .toList();

    await _firestore.collection('islamic_names').doc(category).set({
      'version': 1,
      'names': namesData,
    });

    debugPrint('Migrated ${names.length} $category names');
    return names.length;
  }

  /// Migrate sahaba names from local JSON asset to Firestore
  Future<int> _migrateSahabaFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/sahaba_names.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = jsonData['names'] as List<dynamic>? ?? [];

      await _firestore.collection('islamic_names').doc('sahaba').set({
        'version': 1,
        'names': names,
      });

      debugPrint('Migrated ${names.length} sahaba names from asset');
      return names.length;
    } catch (e) {
      debugPrint('Error migrating sahaba from asset: $e');
      return 0;
    }
  }

  Future<int> _migrateProphetsFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/prophets_names.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = jsonData['names'] as List<dynamic>? ?? [];

      await _firestore.collection('islamic_names').doc('prophets').set({
        'version': 1,
        'names': names,
      });

      debugPrint('Migrated ${names.length} prophet names from asset');
      return names.length;
    } catch (e) {
      debugPrint('Error migrating prophets from asset: $e');
      return 0;
    }
  }

  Future<int> _migrateKhalifasFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/khalifa_names.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = jsonData['names'] as List<dynamic>? ?? [];

      await _firestore.collection('islamic_names').doc('khalifas').set({
        'version': 1,
        'names': names,
      });

      debugPrint('Migrated ${names.length} khalifa names from asset');
      return names.length;
    } catch (e) {
      debugPrint('Error migrating khalifas from asset: $e');
      return 0;
    }
  }

  Future<int> _migrateTwelveImamsFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/twelve_imams_names.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = jsonData['names'] as List<dynamic>? ?? [];

      await _firestore.collection('islamic_names').doc('twelve_imams').set({
        'version': 1,
        'names': names,
      });

      debugPrint('Migrated ${names.length} twelve imam names from asset');
      return names.length;
    } catch (e) {
      debugPrint('Error migrating twelve imams from asset: $e');
      return 0;
    }
  }

  Future<int> _migratePanjatanFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/panjatan_names.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = jsonData['names'] as List<dynamic>? ?? [];

      await _firestore.collection('islamic_names').doc('panjatan').set({
        'version': 1,
        'names': names,
      });

      debugPrint('Migrated ${names.length} panjatan names from asset');
      return names.length;
    } catch (e) {
      debugPrint('Error migrating panjatan from asset: $e');
      return 0;
    }
  }

  Future<int> _migrateAhlebaitFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/ahlebait_names.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = jsonData['names'] as List<dynamic>? ?? [];

      await _firestore.collection('islamic_names').doc('ahlebait').set({
        'version': 1,
        'names': names,
      });

      debugPrint('Migrated ${names.length} ahlebait names from asset');
      return names.length;
    } catch (e) {
      debugPrint('Error migrating ahlebait from asset: $e');
      return 0;
    }
  }

  /// Migrate all hadith collections
  Future<int> _migrateAllHadith() async {
    int totalBooks = 0;

    // Bukhari - load from JSON file
    final bukhariJson = await rootBundle.loadString(
      'assets/data/firebase/sahih_bukhari_books.json',
    );
    final bukhariParsed = json.decode(bukhariJson) as Map<String, dynamic>;
    await _firestore
        .collection('hadith_collections')
        .doc('bukhari')
        .set(bukhariParsed);
    totalBooks += (bukhariParsed['books'] as List).length;
    debugPrint('Migrated $totalBooks books for bukhari from JSON');

    // Muslim - load from JSON file
    final muslimJson = await rootBundle.loadString(
      'assets/data/firebase/sahih_muslim_books.json',
    );
    final muslimParsed = json.decode(muslimJson) as Map<String, dynamic>;
    await _firestore
        .collection('hadith_collections')
        .doc('muslim')
        .set(muslimParsed);
    totalBooks += (muslimParsed['books'] as List).length;
    debugPrint('Migrated $totalBooks books for muslim from JSON');

    // Tirmidhi - load from JSON file
    final tirmidhiJson = await rootBundle.loadString(
      'assets/data/firebase/jami_tirmidhi_books.json',
    );
    final tirmidhiParsed = json.decode(tirmidhiJson) as Map<String, dynamic>;
    await _firestore
        .collection('hadith_collections')
        .doc('tirmidhi')
        .set(tirmidhiParsed);
    totalBooks += (tirmidhiParsed['books'] as List).length;
    debugPrint('Migrated $totalBooks books for tirmidhi from JSON');

    // Nasai - load from JSON file
    final nasaiJson = await rootBundle.loadString(
      'assets/data/firebase/sunan_nasai_books.json',
    );
    final nasaiParsed = json.decode(nasaiJson) as Map<String, dynamic>;
    await _firestore
        .collection('hadith_collections')
        .doc('nasai')
        .set(nasaiParsed);
    totalBooks += (nasaiParsed['books'] as List).length;
    debugPrint('Migrated $totalBooks books for nasai from JSON');

    // Abu Dawud - load from JSON file
    final abuDawudJson = await rootBundle.loadString(
      'assets/data/firebase/sunan_abu_dawud_books.json',
    );
    final abuDawudParsed = json.decode(abuDawudJson) as Map<String, dynamic>;
    await _firestore
        .collection('hadith_collections')
        .doc('abudawud')
        .set(abuDawudParsed);
    totalBooks += (abuDawudParsed['books'] as List).length;
    debugPrint('Migrated $totalBooks books for abudawud from JSON');

    return totalBooks;
  }

  /// Migrate Hadith collection metadata to Firestore
  Future<int> migrateHadithCollection(
    String collectionId,
    Map<String, dynamic> collectionData,
    List<Map<String, dynamic>> books,
  ) async {
    final booksData = books
        .map(
          (b) => {
            'id': b['id'],
            'name': {
              'en': b['name'] ?? '',
              'ur': b['nameUrdu'] ?? '',
              'hi': b['nameHindi'] ?? '',
              'ar': '',
            },
            'arabic_name': b['arabicName'] ?? '',
            'hadith_count': b['hadithCount'] ?? 0,
            'start_number': b['startNumber'] ?? 0,
            'end_number': b['endNumber'] ?? 0,
          },
        )
        .toList();

    await _firestore.collection('hadith_collections').doc(collectionId).set({
      'name': {
        'en': collectionData['name'] ?? '',
        'ur': collectionData['nameUrdu'] ?? '',
        'hi': collectionData['nameHindi'] ?? '',
        'ar': '',
      },
      'arabic_name': collectionData['arabicName'] ?? '',
      'total_hadith': collectionData['totalHadith'] ?? 0,
      'total_books': books.length,
      'books': booksData,
    });

    debugPrint('Migrated ${books.length} books for $collectionId');
    return books.length;
  }

  /// Migrate Tasbih/Dhikr items to Firestore
  Future<int> migrateTasbihDhikr(List<Map<String, dynamic>> items) async {
    final itemsData = items
        .map(
          (d) => {
            'arabic': d['arabic'] ?? '',
            'transliteration': d['transliteration'] ?? '',
            'meaning': {
              'en': d['meaning'] ?? '',
              'ur': d['meaningUrdu'] ?? '',
              'hi': d['meaningHindi'] ?? '',
              'ar': '',
            },
            'default_target': d['defaultTarget'] ?? 33,
          },
        )
        .toList();

    await _firestore.collection('tasbih_dhikr').doc('all_dhikr').set({
      'version': 1,
      'items': itemsData,
    });

    debugPrint('Migrated ${items.length} dhikr items');
    return items.length;
  }

  /// Load tasbih dhikr from local JSON asset and migrate
  Future<int> _migrateTasbihFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/tasbih_content.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final items = (jsonData['dhikr_items'] as List<dynamic>?) ?? [];
      final itemsData = items.map((d) {
        final item = d as Map<String, dynamic>;
        final meaning = item['meaning'] as Map<String, dynamic>? ?? {};
        return {
          'arabic': item['arabic'] ?? '',
          'transliteration': item['transliteration'] ?? '',
          'meaning': {
            'en': meaning['en'] ?? '',
            'ur': meaning['ur'] ?? '',
            'hi': meaning['hi'] ?? '',
            'ar': meaning['ar'] ?? '',
          },
          'default_target': item['default_target'] ?? 33,
        };
      }).toList();

      await _firestore.collection('tasbih_dhikr').doc('all_dhikr').set({
        'version': 1,
        'items': itemsData,
      });

      debugPrint('Migrated ${items.length} dhikr items from asset');
      return items.length;
    } catch (e) {
      debugPrint('Error migrating tasbih from asset: $e');
      return 0;
    }
  }

  /// Load basic amal data from local JSON asset file
  Future<List<Map<String, dynamic>>> _loadBasicAmalFromAsset(String guideType) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/firebase/$guideType.json',
    );
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final steps = (jsonData['steps'] as List<dynamic>?) ?? [];
    return steps.map((step) {
      final s = step as Map<String, dynamic>;
      final title = s['title'] as Map<String, dynamic>? ?? {};
      final details = s['details'] as Map<String, dynamic>? ?? {};
      return <String, dynamic>{
        'number': s['step'] ?? 0,
        'titleKey': s['title_key'] ?? '',
        'title': title['en'] ?? '',
        'titleUrdu': title['ur'] ?? '',
        'titleHindi': title['hi'] ?? '',
        'titleArabic': title['ar'] ?? '',
        'icon': s['icon'] ?? 'circle',
        'color': s['color'] ?? 'green',
        'details': {
          'english': details['en'] ?? '',
          'urdu': details['ur'] ?? '',
          'hindi': details['hi'] ?? '',
          'arabic': details['ar'] ?? '',
        },
      };
    }).toList();
  }

  /// Migrate all basic amal guides
  Future<int> _migrateAllBasicAmal(Function(String)? onProgress) async {
    int count = 0;

    // All guides now load from local JSON assets instead of hardcoded data
    final guideConfigs = <String, Map<String, String>>{
      'wazu': {'title': 'Wazu (Ablution)', 'titleUrdu': 'وضو', 'titleHindi': 'वज़ू'},
      'wazu_additional_info': {'title': 'Wazu Additional Info', 'titleUrdu': 'وضو اضافی معلومات', 'titleHindi': 'वज़ू अतिरिक्त जानकारी'},
      'ghusl': {'title': 'Ghusl (Bath)', 'titleUrdu': 'غسل', 'titleHindi': 'ग़ुस्ल'},
      'azan': {'title': 'Azan (Call to Prayer)', 'titleUrdu': 'اذان', 'titleHindi': 'अज़ान'},
      'namaz_guide': {'title': 'Namaz Guide', 'titleUrdu': 'نماز گائیڈ', 'titleHindi': 'नमाज़ गाइड'},
      'fatiha': {'title': 'Surah Fatiha', 'titleUrdu': 'سورۃ الفاتحہ', 'titleHindi': 'सूरह फ़ातिहा'},
      'khutba': {'title': 'Khutba (Sermon)', 'titleUrdu': 'خطبہ', 'titleHindi': 'खुत्बा'},
      'namaz_fazilat': {'title': 'Namaz Fazilat', 'titleUrdu': 'نماز کی فضیلت', 'titleHindi': 'नमाज़ की फ़ज़ीलत'},
      'jannat_fazilat': {'title': 'Jannat Fazilat', 'titleUrdu': 'جنت کی فضیلت', 'titleHindi': 'जन्नत की फ़ज़ीलत'},
      'jahannam_fazilat': {'title': 'Jahannam Fazilat', 'titleUrdu': 'جہنم کی فضیلت', 'titleHindi': 'जहन्नम की फ़ज़ीलत'},
      'savab_fazilat': {'title': 'Savab Fazilat', 'titleUrdu': 'ثواب کی فضیلت', 'titleHindi': 'सवाब की फ़ज़ीलत'},
      'nazar_e_bad': {'title': 'Nazar e Bad', 'titleUrdu': 'نظر بد', 'titleHindi': 'नज़र-ए-बद'},
      'nazar_karika': {'title': 'Nazar Karika', 'titleUrdu': 'نظر کاریکہ', 'titleHindi': 'नज़र कारिका'},
      'family_fazilat': {'title': 'Family Fazilat', 'titleUrdu': 'خاندان کی فضیلت', 'titleHindi': 'परिवार की फ़ज़ीलत'},
      'relative_fazilat': {'title': 'Relative Fazilat', 'titleUrdu': 'رشتہ داروں کی فضیلت', 'titleHindi': 'रिश्तेदारों की फ़ज़ीलत'},
      'gunha_fazilat': {'title': 'Gunha Fazilat', 'titleUrdu': 'گناہ کی فضیلت', 'titleHindi': 'गुनाह की फ़ज़ीलत'},
      'zamzam_fazilat': {'title': 'Zamzam Fazilat', 'titleUrdu': 'زمزم کی فضیلت', 'titleHindi': 'ज़मज़म की फ़ज़ीलत'},
      'month_name_fazilat': {'title': 'Month Name Fazilat', 'titleUrdu': 'مہینوں کے نام کی فضیلت', 'titleHindi': 'महीनों के नाम की फ़ज़ीलत'},
    };

    final guides = <String, Map<String, dynamic>>{};
    for (final entry in guideConfigs.entries) {
      try {
        final data = await _loadBasicAmalFromAsset(entry.key);
        guides[entry.key] = {
          ...entry.value,
          'data': data,
        };
      } catch (e) {
        debugPrint('Warning: Could not load ${entry.key} from asset: $e');
      }
    }

    for (final entry in guides.entries) {
      onProgress?.call('Migrating ${entry.key}...');
      final data = entry.value['data'] as List<Map<String, dynamic>>;
      await migrateBasicAmalGuide(entry.key, {
        'title': entry.value['title'],
        'titleUrdu': entry.value['titleUrdu'],
        'titleHindi': entry.value['titleHindi'],
      }, data);
      count++;
    }

    return count;
  }

  /// Migrate Basic Amal guide to Firestore
  Future<int> migrateBasicAmalGuide(
    String guideId,
    Map<String, dynamic> guideData,
    List<Map<String, dynamic>> steps,
  ) async {
    final stepsData = steps
        .map(
          (s) => {
            'step': s['step'] ?? s['number'] ?? 0,
            'title': {
              'en': s['title'] ?? '',
              'ur': s['titleUrdu'] ?? '',
              'hi': s['titleHindi'] ?? '',
              'ar': s['titleArabic'] ?? '',
            },
            'title_key': s['titleKey'] ?? '',
            'icon': s['icon']?.toString() ?? 'circle',
            'color': s['color']?.toString() ?? '#000000',
            'details': {
              'en': s['details'] is Map
                  ? (s['details']?['english'] ?? '')
                  : (s['details'] ?? ''),
              'ur': s['details'] is Map ? (s['details']?['urdu'] ?? '') : '',
              'hi': s['details'] is Map ? (s['details']?['hindi'] ?? '') : '',
              'ar': s['details'] is Map ? (s['details']?['arabic'] ?? '') : '',
            },
          },
        )
        .toList();

    await _firestore.collection('basic_amal').doc(guideId).set({
      'title': {
        'en': guideData['title'] ?? '',
        'ur': guideData['titleUrdu'] ?? '',
        'hi': guideData['titleHindi'] ?? '',
        'ar': guideData['titleArabic'] ?? '',
      },
      'icon': guideData['icon'] ?? '',
      'steps': stepsData,
    });

    debugPrint('Migrated ${steps.length} steps for $guideId');
    return steps.length;
  }

  /// Convert IconData to string name for Firestore storage
  static String _iconToName(IconData icon) {
    if (icon == Icons.calendar_today) return 'calendar_today';
    if (icon == Icons.nights_stay) return 'nights_stay';
    if (icon == Icons.favorite) return 'favorite';
    if (icon == Icons.auto_awesome) return 'auto_awesome';
    if (icon == Icons.star) return 'star';
    if (icon == Icons.nightlight_round) return 'nightlight_round';
    if (icon == Icons.stars) return 'stars';
    if (icon == Icons.celebration) return 'celebration';
    if (icon == Icons.terrain) return 'terrain';
    if (icon == Icons.mosque) return 'mosque';
    if (icon == Icons.child_care) return 'child_care';
    if (icon == Icons.menu_book) return 'menu_book';
    if (icon == Icons.calendar_month) return 'calendar_month';
    if (icon == Icons.shield) return 'shield';
    if (icon == Icons.favorite_border) return 'favorite_border';
    if (icon == Icons.military_tech) return 'military_tech';
    if (icon == Icons.public) return 'public';
    if (icon == Icons.wb_sunny) return 'wb_sunny';
    if (icon == Icons.spa) return 'spa';
    if (icon == Icons.volunteer_activism) return 'volunteer_activism';
    if (icon == Icons.lightbulb) return 'lightbulb';
    if (icon == Icons.flight) return 'flight';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.card_giftcard) return 'card_giftcard';
    return 'celebration';
  }

  /// Convert Color to hex string
  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// Migrate all greeting cards/Islamic months
  Future<int> migrateAllGreetingCards() async {
    final months = islamicMonths;
    int count = 0;

    for (final month in months) {
      final monthId = month.name
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll("'", '');
      final cardsData = month.cards
          .asMap()
          .entries
          .map(
            (entry) => {
              'id': '${monthId}_${entry.key + 1}',
              'title': {
                'en': entry.value.title,
                'ur': entry.value.titleUrdu,
                'hi': entry.value.titleHindi,
                'ar': entry.value.titleArabic,
              },
              'message': {
                'en': entry.value.message,
                'ur': entry.value.messageUrdu,
                'hi': entry.value.messageHindi,
                'ar': entry.value.messageArabic,
              },
              'icon': _iconToName(entry.value.icon),
            },
          )
          .toList();

      final data = <String, dynamic>{
        'number': month.monthNumber,
        'name': {
          'en': month.name,
          'ur': month.nameUrdu,
          'hi': month.nameHindi,
          'ar': month.arabicName,
        },
        'gradient_start': _colorToHex(month.gradient[0]),
        'gradient_end': _colorToHex(month.gradient[1]),
        'cards': cardsData,
      };

      // Add special occasion if present
      if (month.specialOccasion != null) {
        data['special_occasion'] = {
          'en': month.specialOccasion ?? '',
          'ur': month.specialOccasionUrdu ?? '',
          'hi': month.specialOccasionHindi ?? '',
          'ar': month.specialOccasionArabic ?? '',
        };
      }

      await _firestore.collection('greeting_cards').doc(monthId).set(data);
      count++;
    }

    debugPrint('Migrated $count Islamic months with greeting cards');
    return count;
  }

  /// Migrate Islamic month with greeting cards to Firestore
  Future<int> migrateGreetingCards(
    String monthId,
    Map<String, dynamic> monthData,
    List<Map<String, dynamic>> cards,
  ) async {
    final cardsData = cards
        .map(
          (c) => {
            'id': c['id'] ?? '',
            'title': {
              'en': c['title'] ?? '',
              'ur': c['titleUrdu'] ?? '',
              'hi': c['titleHindi'] ?? '',
              'ar': c['titleArabic'] ?? '',
            },
            'message': {
              'en': c['message'] ?? '',
              'ur': c['messageUrdu'] ?? '',
              'hi': c['messageHindi'] ?? '',
              'ar': c['messageArabic'] ?? '',
            },
            'icon': c['icon'] ?? '',
            'template_url': c['templateUrl'],
          },
        )
        .toList();

    await _firestore.collection('greeting_cards').doc(monthId).set({
      'number': monthData['number'],
      'name': {
        'en': monthData['name'] ?? '',
        'ur': monthData['nameUrdu'] ?? '',
        'hi': monthData['nameHindi'] ?? '',
        'ar': monthData['nameArabic'] ?? '',
      },
      'gradient_start': monthData['gradientStart'] ?? '#4CAF50',
      'gradient_end': monthData['gradientEnd'] ?? '#2E7D32',
      'cards': cardsData,
    });

    debugPrint('Migrated ${cards.length} cards for $monthId');
    return cards.length;
  }

  /// Migrate all sample hadiths to Firestore from JSON
  Future<int> _migrateAllSampleHadiths() async {
    final jsonStr = await rootBundle.loadString('assets/data/firebase/hadith_sample_hadiths.json');
    final allSamples = json.decode(jsonStr) as Map<String, dynamic>;
    int count = 0;

    for (final entry in allSamples.entries) {
      final collection = entry.key;
      final hadiths = entry.value as List<dynamic>;

      await _firestore.collection('sample_hadiths').doc(collection).set({
        'hadiths': hadiths,
      });

      count += hadiths.length;
    }

    debugPrint('Migrated $count sample hadiths');
    return count;
  }

  /// Migrate hadith collections info to Firestore from JSON
  Future<void> _migrateHadithCollectionsInfo() async {
    final jsonStr = await rootBundle.loadString('assets/data/firebase/hadith_collections_info.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    await _firestore.collection('hadith_collections_info').doc('all').set(data);

    debugPrint('Migrated hadith collections info');
  }

  /// Migrate Hajj guide to Firestore
  /// Convert hardcoded steps to multilingual step list format
  static List<Map<String, String>> _convertSteps(Map<String, dynamic> s) {
    final stepsEn = (s['steps'] as List?)?.cast<String>() ?? [];
    final stepsUr = (s['stepsUrdu'] as List?)?.cast<String>() ?? [];
    final stepsHi = (s['stepsHindi'] as List?)?.cast<String>() ?? [];
    final stepsAr = (s['stepsArabic'] as List?)?.cast<String>() ?? [];
    return List.generate(
      stepsEn.length,
      (i) => {
        'en': i < stepsEn.length ? stepsEn[i] : '',
        'ur': i < stepsUr.length ? stepsUr[i] : '',
        'hi': i < stepsHi.length ? stepsHi[i] : '',
        'ar': i < stepsAr.length ? stepsAr[i] : '',
      },
    );
  }

  Future<int> migrateHajjGuide() async {
    int count = 0;

    // Migrate Hajj steps
    final hajjSteps = _getHardcodedHajjSteps();
    final hajjData = hajjSteps
        .map(
          (s) => {
            'day': {
              'en': s['day'] ?? '',
              'ur': s['dayUrdu'] ?? '',
              'hi': s['dayHindi'] ?? '',
              'ar': s['dayArabic'] ?? '',
            },
            'title': {
              'en': s['title'] ?? '',
              'ur': s['titleUrdu'] ?? '',
              'hi': s['titleHindi'] ?? '',
              'ar': s['titleArabic'] ?? '',
            },
            'icon': s['icon'] ?? '',
            'color': s['color'] ?? '#4CAF50',
            'steps': _convertSteps(s),
          },
        )
        .toList();

    await _firestore.collection('hajj_guide').doc('hajj').set({
      'steps': hajjData,
    });
    count += hajjSteps.length;

    // Migrate Umrah steps
    final umrahSteps = _getHardcodedUmrahSteps();
    final umrahData = umrahSteps
        .map(
          (s) => {
            'day': {
              'en': s['day'] ?? '',
              'ur': s['dayUrdu'] ?? '',
              'hi': s['dayHindi'] ?? '',
              'ar': s['dayArabic'] ?? '',
            },
            'title': {
              'en': s['title'] ?? '',
              'ur': s['titleUrdu'] ?? '',
              'hi': s['titleHindi'] ?? '',
              'ar': s['titleArabic'] ?? '',
            },
            'icon': s['icon'] ?? '',
            'color': s['color'] ?? '#4CAF50',
            'steps': _convertSteps(s),
          },
        )
        .toList();

    await _firestore.collection('hajj_guide').doc('umrah').set({
      'steps': umrahData,
    });
    count += umrahSteps.length;

    // Migrate Hajj duas
    final hajjDuas = _getHardcodedHajjDuas();
    await _firestore.collection('hajj_guide').doc('duas').set({
      'duas': hajjDuas,
    });
    count += hajjDuas.length;

    // Migrate Hajj prohibitions
    final prohibitions = _getHardcodedHajjProhibitions();
    await _firestore.collection('hajj_guide').doc('prohibitions').set({
      'items': prohibitions,
    });

    // Migrate Hajj intro subtitles
    await _firestore.collection('hajj_guide').doc('intro').set({
      'hajj_subtitle': {
        'en': 'The fifth pillar of Islam - obligatory once in a lifetime',
        'ur': 'اسلام کا پانچواں رکن - زندگی میں ایک بار فرض',
        'hi': 'इस्लाम का पांचवां रुक्न - ज़िंदगी में एक बार फ़र्ज़',
        'ar': 'الركن الخامس من أركان الإسلام - واجب مرة واحدة في العمر',
      },
      'umrah_subtitle': {
        'en': 'The lesser pilgrimage - can be performed at any time of the year',
        'ur': 'چھوٹا حج - سال میں کسی بھی وقت ادا کیا جا سکتا ہے',
        'hi': 'छोटा हज - साल में कभी भी अदा किया जा सकता है',
        'ar': 'الحج الأصغر - يمكن أداؤها في أي وقت من السنة',
      },
      'duas_section_title': {
        'en': 'Important Duas',
        'ur': 'اہم دعائیں',
        'hi': 'अहम दुआएं',
        'ar': 'أدعية مهمة',
      },
      'prohibitions_section_title': {
        'en': 'Ihram Prohibitions',
        'ur': 'احرام کی پابندیاں',
        'hi': 'इहराम की पाबंदियां',
        'ar': 'محظورات الإحرام',
      },
    });

    debugPrint('Migrated $count hajj/umrah steps + ${hajjDuas.length} duas + prohibitions');
    return count;
  }

  static List<Map<String, dynamic>> _getHardcodedHajjDuas() => [
    {'id': '1', 'title': {'en': 'Talbiyah', 'ur': 'تلبیہ', 'hi': 'तल्बियह', 'ar': 'التلبية'}, 'arabic': 'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ', 'translation': {'en': 'Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Verily all praise, grace and sovereignty belong to You. You have no partner.', 'ur': 'حاضر ہوں اے اللہ حاضر ہوں۔ حاضر ہوں، تیرا کوئی شریک نہیں، حاضر ہوں۔ بے شک تمام تعریف، نعمت اور بادشاہی تیری ہے۔ تیرا کوئی شریک نہیں۔', 'hi': 'हाज़िर हूं ऐ अल्लाह हाज़िर हूं। हाज़िर हूं, तेरा कोई शरीक नहीं, हाज़िर हूं। बेशक सारी तारीफ़, नेमत और बादशाही तेरी है। तेरा कोई शरीक नहीं।', 'ar': 'ها أنا ذا يا الله ها أنا ذا، ها أنا ذا لا شريك لك ها أنا ذا، إن الحمد والنعمة لك والملك، لا شريك لك.'}},
    {'id': '2', 'title': {'en': 'Dua between Yemeni Corner and Black Stone', 'ur': 'رکن یمانی اور حجر اسود کے درمیان کی دعا', 'hi': 'रुक्न यमानी और हज्र-ए-अस्वद के बीच की दुआ', 'ar': 'الدعاء بين الركن اليماني والحجر الأسود'}, 'arabic': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ', 'translation': {'en': 'Our Lord, give us good in this world and good in the Hereafter, and save us from the punishment of the Fire.', 'ur': 'اے ہمارے رب! ہمیں دنیا میں بھی بھلائی دے اور آخرت میں بھی بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔', 'hi': 'ऐ हमारे रब! हमें दुनिया में भी भलाई दे और आख़िरत में भी भलाई दे और हमें आग के अज़ाब से बचा।', 'ar': 'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار.'}},
    {'id': '3', 'title': {'en': 'Dua on Mount Safa/Marwa', 'ur': 'صفا/مروہ پر دعا', 'hi': 'सफ़ा/मरवा पर दुआ', 'ar': 'الدعاء على جبل الصفا/المروة'}, 'arabic': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 'translation': {'en': 'There is no god but Allah alone, with no partner. His is the dominion, and His is the praise, and He is able to do all things.', 'ur': 'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہی اسی کی ہے اور تعریف اسی کے لیے ہے اور وہ ہر چیز پر قادر ہے۔', 'hi': 'अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं। बादशाही उसी की है और तारीफ़ उसी के लिए है और वो हर चीज़ पर क़ादिर है।', 'ar': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.'}},
    {'id': '4', 'title': {'en': 'Dua when seeing the Kaaba', 'ur': 'کعبہ دیکھنے کی دعا', 'hi': 'काबा देखने की दुआ', 'ar': 'دعاء رؤية الكعبة'}, 'arabic': 'اللَّهُمَّ زِدْ هَذَا الْبَيْتَ تَشْرِيفًا وَتَعْظِيمًا وَتَكْرِيمًا وَمَهَابَةً، وَزِدْ مَنْ شَرَّفَهُ وَكَرَّمَهُ مِمَّنْ حَجَّهُ أَوِ اعْتَمَرَهُ تَشْرِيفًا وَتَكْرِيمًا وَتَعْظِيمًا وَبِرًّا', 'translation': {'en': 'O Allah, increase this House in honor, reverence, nobility and awe. And increase those who honor it and glorify it, from those who perform Hajj or Umrah, in honor, nobility, reverence and righteousness.', 'ur': 'اے اللہ! اس گھر کی عزت، تعظیم، تکریم اور ہیبت میں اضافہ فرما۔ اور جو لوگ اس کی عزت اور تکریم کرتے ہیں جو حج یا عمرہ کرتے ہیں ان کی عزت، تکریم، تعظیم اور نیکی میں اضافہ فرما۔', 'hi': 'ऐ अल्लाह! इस घर की इज़्ज़त, ताज़ीम, तकरीम और हैबत में इज़ाफ़ा फ़रमा। और जो लोग इसकी इज़्ज़त और तकरीम करते हैं जो हज या उमरा करते हैं उनकी इज़्ज़त, तकरीम, ताज़ीम और नेकी में इज़ाफ़ा फ़रमा।', 'ar': 'اللهم زد هذا البيت تشريفاً وتعظيماً وتكريماً ومهابة، وزد من شرّفه وكرّمه ممن حجه أو اعتمره تشريفاً وتكريماً وتعظيماً وبراً.'}},
    {'id': '5', 'title': {'en': 'Dua at Maqam Ibrahim', 'ur': 'مقام ابراہیم پر دعا', 'hi': 'मक़ाम इब्राहीम पर दुआ', 'ar': 'دعاء عند مقام إبراهيم'}, 'arabic': 'وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّى', 'translation': {'en': 'And take the standing place of Ibrahim as a place of prayer.', 'ur': 'اور مقام ابراہیم کو نماز کی جگہ بناؤ۔', 'hi': 'और मक़ाम इब्राहीम को नमाज़ की जगह बनाओ।', 'ar': 'واتخذوا من مقام إبراهيم مصلى.'}},
    {'id': '6', 'title': {'en': 'Dua at Arafah', 'ur': 'عرفات کی دعا', 'hi': 'अरफ़ात की दुआ', 'ar': 'دعاء يوم عرفة'}, 'arabic': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، بِيَدِهِ الْخَيْرُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 'translation': {'en': 'There is no god but Allah alone, with no partner. His is the dominion and His is the praise. In His hand is all good, and He is able to do all things.', 'ur': 'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہی اسی کی ہے اور تعریف اسی کے لیے ہے۔ اس کے ہاتھ میں تمام بھلائی ہے اور وہ ہر چیز پر قادر ہے۔', 'hi': 'अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं। बादशाही उसी की है और तारीफ़ उसी के लिए है। उसके हाथ में तमाम भलाई है और वो हर चीज़ पर क़ादिर है।', 'ar': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، بيده الخير، وهو على كل شيء قدير.'}},
    {'id': '7', 'title': {'en': 'Dua at Muzdalifah', 'ur': 'مزدلفہ کی دعا', 'hi': 'मुज़्दलिफ़ा की दुआ', 'ar': 'دعاء المزدلفة'}, 'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ أَنْ تَرْزُقَنِي جَوَامِعَ الْخَيْرِ، وَأَعُوذُ بِكَ مِنْ جَوَامِعِ الشَّرِّ', 'translation': {'en': 'O Allah, I ask You to grant me all forms of goodness, and I seek refuge in You from all forms of evil.', 'ur': 'اے اللہ! میں تجھ سے سواگتا ہوں کہ تو مجھے تمام بھلائیاں عطا فرما اور میں تیری پناہ مانگتا ہوں تمام برائیوں سے۔', 'hi': 'ऐ अल्लाह! मैं तुझसे सवाल करता हूं कि तू मुझे तमाम भलाइयां अता फ़रमा और मैं तेरी पनाह मांगता हूं तमाम बुराइयों से।', 'ar': 'اللهم إني أسألك أن ترزقني جوامع الخير، وأعوذ بك من جوامع الشر.'}},
    {'id': '8', 'title': {'en': 'Dua when throwing Jamarat', 'ur': 'جمرات پر کنکریاں مارنے کی دعا', 'hi': 'जमरात पर कंकरियां मारने की दुआ', 'ar': 'دعاء رمي الجمرات'}, 'arabic': 'اللَّهُ أَكْبَرُ، اللَّهُمَّ اجْعَلْهُ حَجًّا مَبْرُورًا وَسَعْيًا مَشْكُورًا وَذَنْبًا مَغْفُورًا', 'translation': {'en': 'Allah is the Greatest. O Allah, make it an accepted Hajj, an appreciated effort, and a forgiven sin.', 'ur': 'اللہ سب سے بڑا ہے۔ اے اللہ! اسے مقبول حج بنا، قبول شدہ کوشش بنا اور معاف شدہ گناہ بنا۔', 'hi': 'अल्लाह सबसे बड़ा है। ऐ अल्लाह! इसे मक़बूल हज बना, क़बूल शुदा कोशिश बना और माफ़ शुदा गुनाह बना।', 'ar': 'الله أكبر، اللهم اجعله حجاً مبروراً وسعياً مشكوراً وذنباً مغفوراً.'}},
    {'id': '9', 'title': {'en': 'Dua when drinking Zamzam', 'ur': 'زمزم پینے کی دعا', 'hi': 'ज़मज़म पीने की दुआ', 'ar': 'دعاء شرب ماء زمزم'}, 'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ', 'translation': {'en': 'O Allah, I ask You for beneficial knowledge, abundant provision, and healing from every disease.', 'ur': 'اے اللہ! میں تجھ سے نفع بخش علم، وسیع رزق اور ہر بیماری سے شفا مانگتا ہوں۔', 'hi': 'ऐ अल्लाह! मैं तुझसे फ़ायदेमंद इल्म, वसीअ रिज़्क़ और हर बीमारी से शिफ़ा मांगता हूं।', 'ar': 'اللهم إني أسألك علماً نافعاً ورزقاً واسعاً وشفاء من كل داء.'}},
    {'id': '10', 'title': {'en': 'Dua for Sacrifice (Qurbani)', 'ur': 'قربانی کی دعا', 'hi': 'क़ुर्बानी की दुआ', 'ar': 'دعاء الذبح'}, 'arabic': 'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ، اللَّهُمَّ مِنْكَ وَلَكَ، اللَّهُمَّ تَقَبَّلْ مِنِّي', 'translation': {'en': 'In the name of Allah, Allah is the Greatest. O Allah, this is from You and for You. O Allah, accept it from me.', 'ur': 'اللہ کے نام سے، اللہ سب سے بڑا ہے۔ اے اللہ! یہ تیری طرف سے ہے اور تیرے لیے ہے۔ اے اللہ! میری طرف سے قبول فرما۔', 'hi': 'अल्लाह के नाम से, अल्लाह सबसे बड़ा है। ऐ अल्लाह! यह तेरी तरफ़ से है और तेरे लिए है। ऐ अल्लाह! मेरी तरफ़ से क़बूल फ़रमा।', 'ar': 'بسم الله والله أكبر، اللهم منك ولك، اللهم تقبل مني.'}},
    {'id': '11', 'title': {'en': 'Dua for entering Ihram', 'ur': 'احرام باندھنے کی دعا', 'hi': 'इहराम बांधने की दुआ', 'ar': 'دعاء الإحرام'}, 'arabic': 'لَبَّيْكَ اللَّهُمَّ حَجًّا (أَوْ عُمْرَةً)', 'translation': {'en': 'Here I am, O Allah, for Hajj (or Umrah).', 'ur': 'حاضر ہوں اے اللہ! حج (یا عمرہ) کے لیے۔', 'hi': 'हाज़िर हूं ऐ अल्लाह! हज (या उमरा) के लिए।', 'ar': 'لبيك اللهم حجاً (أو عمرة).'}},
    {'id': '12', 'title': {'en': 'Dua when starting Tawaf', 'ur': 'طواف شروع کرنے کی دعا', 'hi': 'तवाफ़ शुरू करने की दुआ', 'ar': 'دعاء بداية الطواف'}, 'arabic': 'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ، اللَّهُمَّ إِيمَانًا بِكَ وَتَصْدِيقًا بِكِتَابِكَ وَوَفَاءً بِعَهْدِكَ وَاتِّبَاعًا لِسُنَّةِ نَبِيِّكَ مُحَمَّدٍ ﷺ', 'translation': {'en': 'In the name of Allah, Allah is the Greatest. O Allah, with faith in You, belief in Your Book, fulfillment of Your covenant, and following the Sunnah of Your Prophet Muhammad ﷺ.', 'ur': 'اللہ کے نام سے، اللہ سب سے بڑا ہے۔ اے اللہ! تجھ پر ایمان، تیری کتاب کی تصدیق، تیرے عہد کی وفا اور تیرے نبی محمد ﷺ کی سنت کی پیروی کرتے ہوئے۔', 'hi': 'अल्लाह के नाम से, अल्लाह सबसे बड़ा है। ऐ अल्लाह! तुझ पर ईमान, तेरी किताब की तस्दीक़, तेरे अहद की वफ़ा और तेरे नबी मुहम्मद ﷺ की सुन्नत की पैरवी करते हुए।', 'ar': 'بسم الله والله أكبر، اللهم إيماناً بك وتصديقاً بكتابك ووفاءً بعهدك واتباعاً لسنة نبيك محمد ﷺ.'}},
    {'id': '13', 'title': {'en': 'Dua after completing Tawaf', 'ur': 'طواف مکمل کرنے کی دعا', 'hi': 'तवाफ़ पूरा करने की दुआ', 'ar': 'دعاء بعد الطواف'}, 'arabic': 'اللَّهُمَّ اغْفِرْ وَارْحَمْ وَاعْفُ عَمَّا تَعْلَمُ إِنَّكَ أَنْتَ الْأَعَزُّ الْأَكْرَمُ', 'translation': {'en': 'O Allah, forgive, have mercy, and pardon what You know. Indeed, You are the Most Mighty, the Most Generous.', 'ur': 'اے اللہ! معاف فرما، رحم فرما اور جو تو جانتا ہے اس سے درگزر فرما۔ بے شک تو ہی سب سے عزت والا، سب سے کرم والا ہے۔', 'hi': 'ऐ अल्लाह! माफ़ फ़रमा, रहम फ़रमा और जो तू जानता है उससे दरगुज़र फ़रमा। बेशक तू ही सबसे इज़्ज़त वाला, सबसे करम वाला है।', 'ar': 'اللهم اغفر وارحم واعف عما تعلم إنك أنت الأعز الأكرم.'}},
    {'id': '14', 'title': {'en': 'Farewell Dua when leaving Haram', 'ur': 'حرم سے رخصت کی دعا', 'hi': 'हरम से रुख़्सत की दुआ', 'ar': 'دعاء الوداع'}, 'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اجْعَلْ هَذَا حَجًّا مَبْرُورًا وَذَنْبًا مَغْفُورًا وَعَمَلًا مَقْبُولًا', 'translation': {'en': 'O Allah, I ask You from Your bounty. O Allah, make this an accepted Hajj, a forgiven sin, and an accepted deed.', 'ur': 'اے اللہ! میں تجھ سے تیرے فضل سے سوال کرتا ہوں۔ اے اللہ! اسے مقبول حج، معاف شدہ گناہ اور قبول شدہ عمل بنا۔', 'hi': 'ऐ अल्लाह! मैं तुझसे तेरे फ़ज़्ल से सवाल करता हूं। ऐ अल्लाह! इसे मक़बूल हज, माफ़ शुदा गुनाह और क़बूल शुदा अमल बना।', 'ar': 'اللهم إني أسألك من فضلك، اللهم اجعل هذا حجاً مبروراً وذنباً مغفوراً وعملاً مقبولاً.'}},
  ];

  static List<Map<String, dynamic>> _getHardcodedHajjProhibitions() => [
    {'en': 'Cutting hair or nails', 'ur': 'بال یا ناخن کاٹنا', 'hi': 'बाल या नाख़ून काटना', 'ar': 'قص الشعر أو الأظافر'},
    {'en': 'Using perfume', 'ur': 'خوشبو لگانا', 'hi': 'ख़ुशबू लगाना', 'ar': 'استخدام العطر'},
    {'en': 'Covering head (men)', 'ur': 'سر ڈھانپنا (مرد)', 'hi': 'सर ढांकना (मर्द)', 'ar': 'تغطية الرأس (الرجال)'},
    {'en': 'Sewn clothes (men)', 'ur': 'سلے ہوئے کپڑے (مرد)', 'hi': 'सिले हुए कपड़े (मर्द)', 'ar': 'الملابس المخيطة (الرجال)'},
    {'en': 'Hunting animals', 'ur': 'شکار کرنا', 'hi': 'शिकार करना', 'ar': 'صيد الحيوانات'},
    {'en': 'Marriage proposals', 'ur': 'نکاح یا پیغام', 'hi': 'निकाह या पैग़ाम', 'ar': 'عقد النكاح'},
    {'en': 'Sexual relations', 'ur': 'ازدواجی تعلقات', 'hi': 'इज़्दिवाजी ताल्लुक़ात', 'ar': 'العلاقات الزوجية'},
    {'en': 'Arguing or fighting', 'ur': 'لڑائی جھگڑا', 'hi': 'लड़ाई झगड़ा', 'ar': 'الجدال والقتال'},
  ];

  static List<Map<String, dynamic>> _getHardcodedHajjSteps() => [
    {'day': 'Before Hajj', 'dayUrdu': 'حج سے پہلے', 'dayHindi': 'हज से पहले', 'dayArabic': 'قبل الحج', 'title': 'Preparation', 'titleUrdu': 'تیاری', 'titleHindi': 'तैयारी', 'titleArabic': 'التحضير', 'icon': 'checklist', 'color': '#2196F3',
      'steps': ['Make sincere intention (Niyyah) for Hajj','Repent from all sins and seek forgiveness','Pay off all debts and resolve disputes','Write a will (Wasiyyah)','Learn the rituals of Hajj','Pack appropriate Ihram clothing','Get necessary vaccinations','Prepare physically for the journey'],
      'stepsUrdu': ['حج کی نیت خالص کریں','تمام گناہوں سے توبہ کریں','تمام قرضے ادا کریں','وصیت لکھیں','حج کے مناسک سیکھیں','احرام کے کپڑے پیک کریں','ضروری ویکسینیشن لیں','جسمانی طور پر تیاری کریں'],
      'stepsHindi': ['हज की नियत सच्चे दिल से करें','सभी गुनाहों से तौबा करें','सभी कर्ज चुकाएं','वसीयत लिखें','हज के मनासिक सीखें','इहराम के कपड़े पैक करें','जरूरी वैक्सीनेशन लें','शारीरिक रूप से तैयारी करें'],
      'stepsArabic': ['قم بعمل نية خالصة للحج','تب من جميع الذنوب واطلب المغفرة','سدد جميع الديون وحل النزاعات','اكتب وصية','تعلم مناسك الحج','احزم ملابس الإحرام المناسبة','احصل على التطعيمات اللازمة','استعد جسديًا للرحلة'],
    },
    {'day': '8th Dhul Hijjah', 'dayUrdu': '8 ذو الحجہ', 'dayHindi': '8 ज़िल्हिज्जा', 'dayArabic': '8 ذو الحجة', 'title': 'Day of Tarwiyah', 'titleUrdu': 'یوم الترویہ', 'titleHindi': 'यौम अल-तरवियह', 'titleArabic': 'يوم الترويه', 'icon': 'flag', 'color': '#4CAF50',
      'steps': ['Enter state of Ihram from Miqat','Make intention for Hajj: "Labbayk Allahumma Hajj"','Recite Talbiyah continuously','Travel to Mina','Pray Dhuhr, Asr, Maghrib, Isha and Fajr at Mina','Each prayer at its own time, shortened (Qasr)','Spend the night in Mina'],
      'stepsUrdu': ['میقات سے احرام باندھیں','حج کی نیت کریں: لبیک اللہم حج','تلبیہ پڑھتے رہیں','منیٰ کی طرف روانہ ہوں','منیٰ میں تمام نمازیں پڑھیں','ہر نماز اپنے وقت پر قصر کریں','رات منیٰ میں گزاریں'],
      'stepsHindi': ['मीक़ात से इहराम बांधें','हज की नियत करें: लब्बैक अल्लाहुम्मा हज','तल्बियह पढ़ते रहें','मिना की ओर रवाना हों','मिना में सभी नमाज़ें पढ़ें','हर नमाज़ अपने वक़्त पर क़स्र करें','रात मिना में गुज़ारें'],
      'stepsArabic': ['ادخل حالة الإحرام من الميقات','اعقد النية للحج: لبيك اللهم حج','ردد التلبية باستمرار','سافر إلى منى','صلِّ الظهر والعصر والمغرب والعشاء والفجر في منى','كل صلاة في وقتها، مقصورة','اقضِ الليل في منى'],
    },
    {'day': '9th Dhul Hijjah', 'dayUrdu': '9 ذو الحجہ', 'dayHindi': '9 ज़िल्हिज्जा', 'dayArabic': '9 ذو الحجة', 'title': 'Day of Arafah', 'titleUrdu': 'یوم عرفہ', 'titleHindi': 'यौम अरफ़ा', 'titleArabic': 'يوم عرفة', 'icon': 'terrain', 'color': '#FF9800',
      'steps': ['This is the most important day of Hajj','Travel to Arafah after sunrise','Stand at Arafah (Wuquf) - this is the pillar of Hajj','Combine and shorten Dhuhr and Asr prayers','Make abundant Dua and Dhikr','After sunset, travel to Muzdalifah','Pray Maghrib and Isha combined at Muzdalifah','Collect 49-70 pebbles for Jamarat'],
      'stepsUrdu': ['یہ حج کا سب سے اہم دن ہے','طلوع آفتاب کے بعد عرفات جائیں','عرفات میں وقوف کریں - یہ حج کا رکن ہے','ظہر اور عصر جمع اور قصر کریں','کثرت سے دعا اور ذکر کریں','غروب آفتاب کے بعد مزدلفہ جائیں','مغرب اور عشاء جمع کریں','جمرات کے لیے 49-70 کنکریاں جمع کریں'],
      'stepsHindi': ['यह हज का सबसे अहम दिन है','सूर्योदय के बाद अरफ़ात जाएं','अरफ़ात में वुक़ूफ़ करें - यह हज का रुक्न है','ज़ुहर और अस्र जमा और क़स्र करें','बहुत ज़्यादा दुआ और ज़िक्र करें','सूर्यास्त के बाद मुज़दलिफ़ा जाएं','मग़रिब और इशा जमा करें','जमरात के लिए 49-70 कंकरियां जमा करें'],
      'stepsArabic': ['هذا هو أهم يوم في الحج','سافر إلى عرفة بعد شروق الشمس','قف في عرفة (الوقوف) - هذا هو ركن الحج','اجمع وقصر صلاتي الظهر والعصر','أكثر من الدعاء والذكر','بعد غروب الشمس، سافر إلى مزدلفة','صلِّ المغرب والعشاء جمعًا في مزدلفة','اجمع 49-70 حصاة للجمرات'],
    },
    {'day': '10th Dhul Hijjah', 'dayUrdu': '10 ذو الحجہ', 'dayHindi': '10 ज़िल्हिज्जा', 'dayArabic': '10 ذو الحجة', 'title': 'Eid Day (Yawm al-Nahr)', 'titleUrdu': 'عید کا دن (یوم النحر)', 'titleHindi': 'ईद का दिन (यौम अल-नहर)', 'titleArabic': 'يوم العيد (يوم النحر)', 'icon': 'celebration', 'color': '#F44336',
      'steps': ['Pray Fajr at Muzdalifah','Leave for Mina before sunrise','Stone Jamrat al-Aqabah (7 pebbles)','Perform sacrifice (Qurbani/Hady)','Shave head (Halq) or trim hair (Taqsir)','Go to Makkah for Tawaf al-Ifadah','Perform Sa\'i between Safa and Marwa','Return to Mina to spend the night'],
      'stepsUrdu': ['مزدلفہ میں فجر پڑھیں','طلوع آفتاب سے پہلے منیٰ روانہ ہوں','جمرۃ العقبہ کو 7 کنکریاں ماریں','قربانی دیں','سر منڈوائیں یا بال کٹوائیں','طواف افاضہ کے لیے مکہ جائیں','صفا اور مروہ کے درمیان سعی کریں','رات گزارنے کے لیے منیٰ واپس آئیں'],
      'stepsHindi': ['मुज़दलिफ़ा में फज्र पढ़ें','सूर्योदय से पहले मिना रवाना हों','जमरतुल अक़बा को 7 कंकरियां मारें','क़ुर्बानी दें','सर मुंडवाएं या बाल कटवाएं','तवाफ़ इफ़ाज़ा के लिए मक्का जाएं','सफ़ा और मरवा के बीच सई करें','रात गुज़ारने के लिए मिना वापस आएं'],
      'stepsArabic': ['صلِّ الفجر في مزدلفة','اذهب إلى منى قبل شر��ق الشمس','ارمِ جمرة العقبة (7 حصيات)','قم بالأضحية (القربان/الهدي)','احلق رأسك (الحلق) أو قصر شعرك (التقصير)','اذهب إلى مكة لطواف الإفاضة','أدِّ السعي بين الصفا والمروة','ارجع إلى منى لقضاء الليل'],
    },
    {'day': '11th-13th Dhul Hijjah', 'dayUrdu': '11-13 ذو الحجہ', 'dayHindi': '11-13 ज़िल्हिज्जा', 'dayArabic': '11-13 ذو الحجة', 'title': 'Days of Tashreeq', 'titleUrdu': 'ایام تشریق', 'titleHindi': 'अय्याम अल-तशरीक़', 'titleArabic': 'أيام التشريق', 'icon': 'replay', 'color': '#9C27B0',
      'steps': ['Stay in Mina for these days','Stone all three Jamarat daily (after Dhuhr)','Start with Jamrat al-Sughra (small)','Then Jamrat al-Wusta (middle)','Finally Jamrat al-Aqabah (big)','7 pebbles at each Jamrah','Can leave on 12th after stoning (if before sunset)'],
      'stepsUrdu': ['ان دنوں منیٰ میں رہیں','روزانہ تینوں جمرات کو کنکریاں ماریں','جمرۃ الصغریٰ سے شروع کریں','پھر جمرۃ الوسطیٰ','آخر میں جمرۃ العقبہ','ہر جمرہ پر 7 کنکریاں','12 تاریخ کو غروب سے پہلے جا سکتے ہیں'],
      'stepsHindi': ['इन दिनों मिना में रहें','रोज़ाना तीनों जमरात को कंकरियां मारें','जमरतुल सुग़रा से शुरू करें','फिर जमरतुल वुस्ता','आख़िर में जमरतुल अक़बा','हर जमरा पर 7 कंकरियां','12 तारीख़ को सूर्यास्त से पहले जा सकते हैं'],
      'stepsArabic': ['ابقَ في منى خلال هذه الأيام','ارمِ الجمرات الثلاث يوميًا (بعد الظهر)','ابدأ بالجمرة الصغرى','ثم الجمرة الوسطى','وأخيرًا جمرة العقبة (الكبرى)','7 حصيات لكل جمرة','يمكن المغادرة في الـ12 بعد الرمي (إذا كان قبل الغروب)'],
    },
    {'day': 'Before Leaving', 'dayUrdu': 'روانگی سے پہلے', 'dayHindi': 'रवानगी से पहले', 'dayArabic': 'قبل المغادرة', 'title': 'Farewell Tawaf', 'titleUrdu': 'طواف الوداع', 'titleHindi': 'तवाफ़ अल-विदा', 'titleArabic': 'طواف الوداع', 'icon': 'mosque', 'color': '#009688',
      'steps': ['Perform Tawaf al-Wida (Farewell Tawaf)','This should be your last act in Makkah','Make Dua at Multazam','Drink Zamzam water','Pray 2 Rakats behind Maqam Ibrahim','Leave Makkah while making Dua','Visit Madinah (recommended)'],
      'stepsUrdu': ['طواف الوداع کریں','یہ مکہ میں آخری عمل ہونا چاہیے','ملتزم پر دعا کریں','زمزم کا پانی پئیں','مقام ابراہیم کے پیچھے 2 رکعت پڑھیں','دعا کرتے ہوئے مکہ سے روانہ ہوں','مدینہ کی زیارت کریں (مستحب)'],
      'stepsHindi': ['तवाफ़ अल-विदा करें','यह मक्का में आख़िरी अमल होना चाहिए','मुलतज़म पर दुआ करें','ज़मज़म का पानी पिएं','मक़ाम इब्राहीम के पीछे 2 रकात पढ़ें','दुआ करते हुए मक्का से रवाना हों','मदीना की ज़ियारत करें (मुस्तहब)'],
      'stepsArabic': ['أدِّ طواف الوداع','يجب أن يكون هذا آخر عمل لك في مكة','ادعُ عند الملتزم','اشرب ماء زمزم','صلِّ ركعتين خلف مقام إبراهيم','اترك مكة أثناء الدعاء','زر المدينة المنورة (مستحب)'],
    },
  ];

  static List<Map<String, dynamic>> _getHardcodedUmrahSteps() => [
    {'day': 'Step 1', 'dayUrdu': 'مرحلہ 1', 'dayHindi': 'चरण 1', 'dayArabic': 'الخطوة 1', 'title': 'Enter Ihram', 'titleUrdu': 'احرام باندھنا', 'titleHindi': 'इहराम बांधना', 'titleArabic': 'دخول الإحرام', 'icon': 'check_circle', 'color': '#4CAF50',
      'steps': ['Take a bath (Ghusl) before Ihram - Sunnah','Trim nails, remove unwanted hair before Ihram','Wear Ihram clothing (2 white unsewn sheets for men)','Women wear normal modest clothing covering body','Apply non-alcoholic perfume before Ihram (Sunnah)','Pray 2 Rakats of Ihram (optional)','Make intention at Miqat: "Labbayk Allahumma Umrah"','Recite Talbiyah loudly and continuously'],
      'stepsUrdu': ['احرام سے پہلے غسل کریں - سنت','احرام سے پہلے ناخن کٹوائیں، زیر ناف بال صاف کریں','احرام کے کپڑے پہنیں (مردوں کے لیے 2 سفید بغیر سلے چادریں)','خواتین معمول کے پردے والے کپڑے پہنیں جو جسم ڈھانپیں','احرام سے پہلے غیر الکحل خوشبو لگائیں (سنت)','احرام کی 2 رکعت نماز پڑھیں (اختیاری)','میقات پر نیت کریں: لبیک اللہم عمرۃ','تلبیہ بلند آواز سے پڑھتے رہیں'],
      'stepsHindi': ['इहराम से पहले ग़ुस्ल करें - सुन्नत','इहराम से पहले नाखून काटें, ज़ेर-ए-नाफ़ बाल साफ़ करें','इहराम के कपड़े पहनें (मर्दों के लिए 2 सफ़ेद बिना सिली चादरें)','औरतें आम पर्दे वाले कपड़े पहनें जो जिस्म ढांपें','इहराम से पहले ग़ैर-अल्कोहल ख़ुशबू लगाएं (सुन्नत)','इहराम की 2 रकात नमाज़ पढ़ें (इख़्तियारी)','मीक़ात पर नियत करें: लब्बैक अल्लाहुम्मा उमरा','तल्बियह बुलंद आवाज़ से पढ़ते रहें'],
      'stepsArabic': ['اغتسل قبل الإحرام - سنة','قص الأظافر وأزل الشعر غير المرغوب قبل الإحرام','ارتدِ ملابس الإحرام (إزارين أبيضين غير مخيطين للرجال)','ترتدي النساء ملابس عادية محتشمة تغطي الجسم','ضع عطراً غير كحولي قبل الإحرام (سنة)','صلِّ ركعتي الإحرام (اختياري)','اعقد النية عند الميقات: لبيك اللهم عمرة','ردد التلبية بصوت عالٍ باستمرار'],
    },
    {'day': 'Step 2', 'dayUrdu': 'مرحلہ 2', 'dayHindi': 'चरण 2', 'dayArabic': 'الخطوة 2', 'title': 'Tawaf (Circumambulation)', 'titleUrdu': 'طواف', 'titleHindi': 'तवाफ़', 'titleArabic': 'الطواف', 'icon': 'autorenew', 'color': '#2196F3',
      'steps': ['Enter Masjid al-Haram with right foot saying Dua of entry','Stop reciting Talbiyah when seeing the Kaaba','Begin Tawaf from the Black Stone line (green light)','Say "Bismillahi Allahu Akbar" at Black Stone','Kiss, touch or point to Black Stone each round','Men: Raml (brisk walk) in first 3 rounds','Men: Idtiba (expose right shoulder) throughout','Circle Kaaba 7 times counter-clockwise','Make Dua freely - any language is accepted','Recite "Rabbana atina..." between Yemeni corner and Black Stone','After Tawaf, cover both shoulders','Pray 2 Rakats behind Maqam Ibrahim (recite Surah Kafirun & Ikhlas)','Drink Zamzam water and make Dua'],
      'stepsUrdu': ['دائیں پاؤں سے دعا پڑھتے ہوئے مسجد الحرام میں داخل ہو��','کعبہ دیکھتے ہی تلبیہ بند کریں','حجر اسود کی لکیر (سبز روشنی) سے طواف شروع کریں','حجر اسود پر "بسم اللہ اللہ اکبر" کہیں','ہر چکر میں حجر اسود کو بوسہ دیں، چھوئیں یا اشارہ کریں','مرد: پہلے 3 چکروں میں رمل (تیز چال)','مرد: پورے طواف میں اضطباع کریں','کعبہ کے 7 چکر لگائیں (خلاف گھڑی)','آزادانہ دعا کریں - کوئی بھی زبان قبول ہے','رکن یمانی اور حجر اسود کے درمیان "ربنا آتنا..." پڑھیں','طواف کے بعد دونوں کندھے ڈھانپیں','مقام ابراہیم کے پیچھے 2 رکعت پڑھیں (سورہ کافرون و اخلاص)','زمزم کا پانی پئیں اور دعا کریں'],
      'stepsHindi': ['दाएं पैर से दुआ पढ़ते हुए मस्जिद अल-हराम में दाख़िल हों','काबा देखते ही तल्बियह बंद करें','हज्र-ए-अस्वद की लाइन (हरी रौशनी) से तवाफ़ शुरू करें','हज्र-ए-अस्वद पर "बिस्मिल्लाहि अल्लाहु अकबर" कहें','हर चक्कर में हज्र-ए-अस्वद को बोसा दें, छूएं या इशारा करें','मर्द: पहले 3 चक्करों में रमल (तेज़ चाल)','मर्द: पूरे तवाफ़ में इज़तिबा करें','काबा के 7 चक्कर लगाएं (घड़ी के विपरीत)','आज़ादी से दुआ करें - कोई भी ज़बान क़बूल है','रुक्न यमानी और हज्र-ए-अस्वद के बीच "रब्बना आतिना..." पढ़ें','तवाफ़ के बाद दोनों कंधे ढांपें','मक़ाम इब्राहीम के पीछे 2 रकात पढ़ें (सूरह काफ़िरून व इख़्लास)','ज़मज़म का पानी पिएं और दुआ करें'],
      'stepsArabic': ['ادخل المسجد الحرام بالقدم اليمنى مع قراءة دعاء الدخول','توقف عن التلبية عند رؤية الكعبة','ابدأ الطواف من خط الحجر الأسود (الضوء الأخضر)','قل "بسم الله الله أكبر" عند الحجر الأسود','قبّل أو المس أو أشر إلى الحجر الأسود في كل شوط','الرجال: الرمل (المشي السريع) في أول 3 أشواط','الرجال: الاضطباع طوال الطواف','طُف حول الكعبة 7 أشواط عكس عقارب الساعة','ادعُ بحرية - أي لغة مقبولة','اقرأ "ربنا آتنا..." بين الركن اليماني والحجر الأسود','بعد الطواف، غطِّ كلا الكتفين','صلِّ ركعتين خلف مقام إبراهيم (اقرأ سورة الكافرون والإخلاص)','اشرب ماء زمزم وادعُ'],
    },
    {'day': 'Step 3', 'dayUrdu': 'مرحلہ 3', 'dayHindi': 'चरण 3', 'dayArabic': 'الخطوة 3', 'title': "Sa'i (Walking between hills)", 'titleUrdu': 'سعی', 'titleHindi': 'सई', 'titleArabic': 'السعي', 'icon': 'directions_walk', 'color': '#FF9800',
      'steps': ['Proceed to Safa hill (start point)','Climb Safa and face the Kaaba','Recite: "Indeed, Safa and Marwa are from the symbols of Allah"','Say Takbir 3 times and make Dua','Walk towards Marwa (this is lap 1)','Men: Run/jog between green marker lights','Women: Walk normally throughout','Reach Marwa, face Kaaba, make Dua','Walk back to Safa (this is lap 2)','Complete 7 laps total (Safa to Marwa = 1 lap)','Sa\'i ends at Marwa (lap 7)','Make abundant Dua and Dhikr throughout','No specific Dua required - pray in any language'],
      'stepsUrdu': ['کوہ صفا جائیں (شروع کی جگہ)','صفا پر چڑھیں اور کعبہ کی طرف منہ کریں','پڑھیں: "بے شک صفا اور مروہ اللہ کی نشانیوں میں سے ہیں"','3 بار تکبیر کہیں اور دعا کریں','مروہ کی طرف چلیں (یہ 1 چکر ہے)','مرد: سبز بتیوں کے درمیان دوڑیں/تیز چلیں','خواتین: پورے سعی میں معمول سے چلیں','مروہ پہنچیں، کعبہ کی طرف منہ کریں، دعا کریں','واپس صفا جائیں (یہ 2 چکر ہے)','کل 7 چکر مکمل کریں','سعی مروہ پر ختم ہوتی ہے (7 چکر)','پوری سعی میں کثرت سے دعا اور ذکر کریں','کوئی مخصوص دعا ضروری نہیں - کسی بھی زبان میں دعا کریں'],
      'stepsHindi': ['कोह सफ़ा जाएं (शुरू की जगह)','सफ़ा पर चढ़ें और काबा की तरफ़ मुंह करें','पढ़ें: "बेशक सफ़ा और मरवा अल्लाह की निशानियों में से हैं"','3 बार तकबीर कहें और दुआ करें','मरवा की तरफ़ चलें (यह 1 चक्कर है)','मर्द: हरी बत्तियों के बीच दौड़ें/तेज़ चलें','औरतें: पूरी सई में आम तौर पर चलें','मरवा पहुंचें, काबा की तरफ़ मुंह करें, दुआ करें','वापस सफ़ा जाएं (यह 2 चक्कर है)','कुल 7 चक्कर मुकम्मल करें','सई मरवा पर ख़त्म होती है (7 चक्कर)','पूरी सई में कसरत से दुआ और ज़िक्र करें','कोई मख़्सूस दुआ ज़रूरी नहीं - किसी भी ज़बान में दुआ करें'],
      'stepsArabic': ['اذهب إلى جبل الصفا (نقطة البداية)','اصعد الصفا واستقبل الكعبة','اقرأ: "إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ"','كبّر 3 مرات وادعُ','امشِ نحو المروة (هذا هو الشوط 1)','الرجال: اهرول بين العلمين الأخضرين','النساء: امشِ بشكل طبيعي طوال السعي','وصلت إلى المروة، استقبل الكعبة، وادعُ','ارجع إلى الصفا (هذا هو الشوط 2)','أكمل 7 أشواط إجمالاً','ينتهي السعي عند المروة (الشوط 7)','ادعُ واذكر الله بكثرة طوال السعي','لا يوجد دعاء محدد مطلوب - ادعُ بأي لغة'],
    },
    {'day': 'Step 4', 'dayUrdu': 'مرحلہ 4', 'dayHindi': 'चरण 4', 'dayArabic': 'الخطوة 4', 'title': 'Halq or Taqsir', 'titleUrdu': 'حلق یا تقصیر', 'titleHindi': 'हल्क़ या तक़्सीर', 'titleArabic': 'الحلق أو التقصير', 'icon': 'content_cut', 'color': '#9C27B0',
      'steps': ['Go to a barber shop near the Haram','Men: Shave head completely (Halq) - more reward','Or Men: Trim hair all over (Taqsir) - at least 1 inch','Women: Cut only a fingertip length of hair','Women should NOT shave their heads','This marks the official end of Ihram state','All Ihram restrictions are now lifted','You can now wear normal clothes and perfume','Say Alhamdulillah - Your Umrah is complete!','Recommended: Pray 2 Rakats of thanks','Stay in Makkah and pray in Masjid al-Haram'],
      'stepsUrdu': ['حرم کے قریب حجام کی دکان جائیں','مرد: سر مکمل منڈوائیں (حلق) - زیادہ ثواب','یا مرد: سارے بال کٹوائیں (تقصیر) - کم از کم 1 انچ','خواتین: صرف انگلی کے پور کی لمبائی کے بال کاٹیں','خواتین سر نہ منڈوائیں','یہ احرام کی حالت کا باضابطہ اختتام ہے','اب احرام کی تمام پابندیاں ختم ہیں','اب آپ عام کپڑے اور خوشبو استعمال کر سکتے ہیں','الحمد للہ کہیں - آپ کا عمرہ مکمل ہوا!','مستحب: شکرانے کی 2 رکعت پڑھیں','مکہ میں رہیں اور مسجد الحرام میں نماز پڑھیں'],
      'stepsHindi': ['हरम के क़रीब हज्जाम की दुकान जाएं','मर्द: सर पूरा मुंडवाएं (हल्क़) - ज़्यादा सवाब','या मर्द: सारे बाल कटवाएं (तक़्सीर) - कम से कम 1 इंच','औरतें: सिर्फ़ उंगली के पोर की लंबाई के बाल काटें','औरतें सर न मुंडवाएं','यह इहराम की हालत का बाक़ायदा अंत है','अब इहराम की सभी पाबंदियां ख़त्म हैं','अब आप आम कपड़े और ख़ुशबू इस्तेमाल कर सकते हैं','अल्हम्दुलिल्लाह कहें - आपका उमरा मुकम्मल हुआ!','मुस्तहब: शुक्राने की 2 रकात पढ़ें','मक्का में रहें और मस्जिद अल-हराम में नमाज़ पढ़ें'],
      'stepsArabic': ['اذهب إلى محل حلاقة بالقرب من الحرم','الرجال: احلق رأسك بالكامل (الحلق) - أجر أكثر','أو الرجال: قصر شعرك (التقصير) - بوصة واحدة على الأقل','النساء: اقطع قدر أنملة فقط من الشعر','لا ينبغي للنساء حلق رؤوسهن','هذا يمثل النهاية الرسمية لحالة الإحرام','جميع محظورات الإحرام أصبحت مرفوعة الآن','يمكنك الآن ارتداء الملابس العادية والعطر','قل الحمد لله - عمرتك مكتملة!','مستحب: صلِّ ركعتي الشكر','ابقَ في مكة وصلِّ في المسجد الحرام'],
    },
  ];

  /// Migrate Ramadan duas to Firestore
  Future<int> migrateRamadanDuas() async {
    final duas = getHardcodedRamadanDuas();

    final duaData = duas
        .map(
          (d) {
            final title = d['title'] as Map<String, dynamic>?;
            return {
              'title_key': d['titleKey'] ?? '',
              'title': {
                'en': title?['en'] ?? d['titleKey'] ?? '',
                'ur': title?['ur'] ?? '',
                'hi': title?['hi'] ?? '',
                'ar': title?['ar'] ?? '',
              },
              'arabic': d['arabic'] ?? '',
              'transliteration': d['transliteration'] ?? '',
              'translation': {
                'en': d['english'] ?? '',
                'ur': d['urdu'] ?? '',
                'hi': d['hindi'] ?? '',
                'ar': d['ar'] ?? '',
              },
              'color': d['color'] ?? '#000000',
            };
          },
        )
        .toList();

    await _firestore.collection('ramadan_duas').doc('all_duas').set({
      'duas': duaData,
    });

    debugPrint('Migrated ${duas.length} ramadan duas');
    return duas.length;
  }

  /// Migrate Zakat guide to Firestore - now reads from JSON asset file
  Future<int> _migrateZakatGuide() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/zakat_guide_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final sections = jsonData['sections'] as List<dynamic>? ?? [];

    await _firestore.collection('zakat_guide').doc('all_sections').set({
      'sections': sections,
    });

    debugPrint('Migrated ${sections.length} zakat guide sections');
    return sections.length;
  }

  /// Migrate Quran metadata (surah names & para names) to Firestore
  /// Now reads from the JSON asset file instead of hardcoded data
  Future<int> _migrateQuranMetadata() async {
    int count = 0;

    final jsonString =
        await rootBundle.loadString('assets/data/firebase/quran_screen_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    // Migrate surah names
    final surahNames = jsonData['surah_names'] as List<dynamic>? ?? [];
    await _firestore.collection('quran_metadata').doc('surah_names').set({
      'names': surahNames,
    });
    count += surahNames.length;

    // Migrate para names
    final paraNames = jsonData['para_names'] as List<dynamic>? ?? [];
    await _firestore.collection('quran_metadata').doc('para_names').set({
      'names': paraNames,
    });
    count += paraNames.length;

    debugPrint('Migrated $count quran metadata entries');
    return count;
  }

  /// Migrate fasting data (fasting duas) to Firestore
  Future<int> migrateFastingData() async {
    final jsonString = await rootBundle.loadString('assets/data/firebase/fasting_times_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final duas = jsonData['duas'] as List<dynamic>;

    await _firestore.collection('fasting_data').doc('fasting_duas').set({
      'duas': duas,
    });

    debugPrint('Migrated ${duas.length} fasting duas');
    return duas.length;
  }

  /// Migrate fasting virtues to Firestore (from JSON asset)
  Future<int> migrateFastingVirtues() async {
    final jsonString = await rootBundle.loadString('assets/data/firebase/fasting_times_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final virtues = jsonData['virtues'] as Map<String, dynamic>;

    await _firestore.collection('fasting_data').doc('fasting_virtues').set(virtues);

    final items = virtues['items'] as List<dynamic>;
    debugPrint('Migrated ${items.length} fasting virtues');
    return items.length;
  }

  /// Migrate fasting rules to Firestore (from JSON asset)
  Future<int> migrateFastingRules() async {
    final jsonString = await rootBundle.loadString('assets/data/firebase/fasting_times_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final rules = jsonData['rules'] as Map<String, dynamic>;

    await _firestore.collection('fasting_data').doc('fasting_rules').set(rules);

    final count = (rules['breaks_fast'] as List).length + (rules['does_not_break_fast'] as List).length;
    debugPrint('Migrated $count fasting rules');
    return count;
  }

  /// Migrate Islamic months fasting chart to Firestore (from JSON asset)
  Future<int> migrateIslamicMonths() async {
    final jsonString = await rootBundle.loadString('assets/data/firebase/fasting_times_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final islamicMonths = jsonData['islamic_months'] as Map<String, dynamic>;

    await _firestore.collection('fasting_data').doc('islamic_months').set(islamicMonths);

    final count = (islamicMonths['months'] as List).length;
    debugPrint('Migrated $count Islamic months data');
    return count;
  }

  /// Migrate settings translations (city, country, name) to Firestore
  Future<int> _migrateSettingsTranslations() async {
    int count = 0;

    final cities = getHardcodedCityTranslations();
    await _firestore
        .collection('settings_translations')
        .doc('city_translations')
        .set({'translations': cities});
    count += cities.length;

    final countries = getHardcodedCountryTranslations();
    await _firestore
        .collection('settings_translations')
        .doc('country_translations')
        .set({'translations': countries});
    count += countries.length;

    final names = getHardcodedNameTransliterations();
    await _firestore
        .collection('settings_translations')
        .doc('name_transliterations')
        .set({'translations': names});
    count += names.length;

    debugPrint('Migrated $count settings translations');
    return count;
  }

  /// Migrate notification strings to Firestore
  Future<int> _migrateNotificationStrings() async {
    int count = 0;

    final prayerStrings = getHardcodedPrayerNotificationStrings();
    await _firestore
        .collection('notification_strings')
        .doc('prayer_notifications')
        .set(prayerStrings);
    count += prayerStrings.length;

    final reminderStrings = getHardcodedIslamicReminderStrings();
    await _firestore
        .collection('notification_strings')
        .doc('islamic_reminders')
        .set(reminderStrings);
    count += reminderStrings.length;

    debugPrint('Migrated $count notification string groups');
    return count;
  }

  /// Migrate name transliterations to Firestore
  Future<int> _migrateNameTransliterations() async {
    int count = 0;

    // Allah Names transliterations - read from JSON asset
    final allahTranslitString = await rootBundle.loadString(
      'assets/data/firebase/allah_names_transliterations.json',
    );
    final allahTranslitData =
        jsonDecode(allahTranslitString) as Map<String, dynamic>;
    await _firestore
        .collection('name_transliterations')
        .doc('allah_names')
        .set(allahTranslitData);
    count++;

    // Surah Names transliterations - read from JSON asset
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/quran_screen_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final surahTranslit = jsonData['surah_transliterations'] as Map<String, dynamic>? ?? {};
    await _firestore
        .collection('name_transliterations')
        .doc('surah_names')
        .set({'hindi': surahTranslit['hindi'] ?? {}, 'urdu': surahTranslit['urdu'] ?? {}});
    count++;

    // Islamic Names transliterations (from asset JSON)
    final islamicNamesStr = await rootBundle.loadString(
      'assets/data/firebase/islamic_names_transliterations.json',
    );
    final islamicNames = jsonDecode(islamicNamesStr) as Map<String, dynamic>;
    await _firestore
        .collection('name_transliterations')
        .doc('islamic_names')
        .set(islamicNames);
    count++;

    // Biographical translations (from asset JSON)
    final biographicalStr = await rootBundle.loadString(
      'assets/data/firebase/biographical_transliterations.json',
    );
    final biographical = jsonDecode(biographicalStr) as Map<String, dynamic>;
    await _firestore
        .collection('name_transliterations')
        .doc('biographical')
        .set(biographical);
    count++;

    debugPrint('Migrated $count name transliteration types');
    return count;
  }

  /// Migrate calendar strings to Firestore
  Future<int> _migrateCalendarStrings() async {
    final calendarData = AppStrings.getHardcodedCalendarStrings();

    await _firestore
        .collection('calendar_strings')
        .doc('all_strings')
        .set(calendarData);

    debugPrint('Migrated ${calendarData.length} calendar string groups');
    return calendarData.length;
  }

  /// Migrate hadith translations to Firestore
  Future<int> _migrateHadithTranslations() async {
    final translations = getHardcodedHadithTranslations();

    await _firestore
        .collection('hadith_translations')
        .doc('all_translations')
        .set(translations);

    debugPrint('Migrated ${translations.length} hadith translation groups');
    return translations.length;
  }

  /// Migrate language names to Firestore
  Future<int> _migrateLanguageNames() async {
    final languageNames = getHardcodedLanguageNames();

    await _firestore
        .collection('language_names')
        .doc('all_names')
        .set(languageNames);

    debugPrint('Migrated ${languageNames.length} language name entries');
    return languageNames.length;
  }

  /// Check if data already exists in Firestore
  Future<bool> isDataMigrated() async {
    try {
      final doc = await _firestore
          .collection('content_metadata')
          .doc('versions')
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Update version for a specific content type
  Future<void> updateVersion(String contentType, int newVersion) async {
    await _firestore.collection('content_metadata').doc('versions').update({
      '${contentType}_version': newVersion,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  /// Migrate Qibla screen content to Firestore - reads from JSON asset file
  Future<bool> migrateQiblaContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/qibla_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('qibla_content').doc('data').set(jsonData);

    return true;
  }

  /// Migrate Tasbih screen content to Firestore - reads from JSON asset file
  Future<bool> migrateTasbihScreenContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/tasbih_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('tasbih_screen_content').doc('data').set(jsonData);

    return true;
  }

  /// Migrate Calendar screen content to Firestore - reads from JSON asset file
  Future<bool> migrateCalendarScreenContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/calendar_screen_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('calendar_screen_content').doc('data').set(jsonData);

    return true;
  }

  /// Migrate Zakat Calculator screen content to Firestore - reads from JSON asset file
  Future<bool> migrateZakatCalculatorContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/zakat_calculator_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('zakat_calculator_content').doc('data').set(jsonData);

    return true;
  }

  /// Migrate Zakat Guide screen content to Firestore - reads from JSON asset file
  Future<bool> migrateZakatGuideScreenContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/zakat_guide_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('zakat_guide_screen_content').doc('data').set(jsonData);

    return true;
  }

  /// Migrate Quran screen content to Firestore - reads from JSON asset file
  Future<bool> migrateQuranScreenContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/quran_screen_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('quran_screen_content').doc('data').set(jsonData);

    return true;
  }

  /// Migrate Islamic events from JSON asset to Firestore
  Future<bool> migrateIslamicEvents() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/islamic_events.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('app_data').doc('islamic_events').set(jsonData);

    debugPrint('Islamic events migrated successfully');
    return true;
  }

  /// Migrate fasting times screen content from JSON asset to Firestore
  Future<bool> migrateFastingTimesContent() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/fasting_times_content.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('fasting_times_content').doc('data').set(jsonData);

    debugPrint('Fasting times content migrated successfully');
    return true;
  }

  /// Migrate UI translations from JSON asset to Firestore
  Future<bool> migrateUITranslations() async {
    final jsonString =
        await rootBundle.loadString('assets/data/firebase/ui_translations.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    await _firestore.collection('ui_translations').doc('all_translations').set(jsonData);

    debugPrint('UI translations migrated successfully');
    return true;
  }
}

/// Result of migration operation
class MigrationResult {
  bool success = false;
  bool versionsCreated = false;
  int duasMigrated = 0;
  int allahNamesMigrated = 0;
  int kalmasMigrated = 0;
  int islamicNamesMigrated = 0;
  int hadithMigrated = 0;
  int tasbihMigrated = 0;
  int basicAmalMigrated = 0;
  int greetingCardsMigrated = 0;
  int sampleHadithMigrated = 0;
  int hajjGuideMigrated = 0;
  int ramadanDuasMigrated = 0;
  int zakatGuideMigrated = 0;
  int quranMetadataMigrated = 0;
  int fastingDataMigrated = 0;
  int settingsTranslationsMigrated = 0;
  int notificationStringsMigrated = 0;
  int calendarStringsMigrated = 0;
  int nameTransliterationsMigrated = 0;
  int hadithTranslationsMigrated = 0;
  int languageNamesMigrated = 0;
  bool qiblaContentMigrated = false;
  bool tasbihScreenContentMigrated = false;
  bool calendarScreenContentMigrated = false;
  bool zakatCalculatorContentMigrated = false;
  bool zakatGuideScreenContentMigrated = false;
  bool quranScreenContentMigrated = false;
  bool uiTranslationsMigrated = false;
  bool islamicEventsMigrated = false;
  bool fastingTimesContentMigrated = false;
  String? error;

  @override
  String toString() {
    if (!success) return 'Migration failed: $error';
    return '''
Migration completed successfully!
- Versions metadata: ${versionsCreated ? 'Created' : 'Skipped'}
- Duas: $duasMigrated categories
- Allah Names: $allahNamesMigrated names
- Kalmas: $kalmasMigrated
- Islamic Names: $islamicNamesMigrated categories
- Hadith: $hadithMigrated collections
- Tasbih: $tasbihMigrated items
- Basic Amal: $basicAmalMigrated guides
- Greeting Cards: $greetingCardsMigrated months
- Sample Hadiths: $sampleHadithMigrated
- Hajj Guide: $hajjGuideMigrated steps
- Ramadan Duas: $ramadanDuasMigrated
- Zakat Guide: $zakatGuideMigrated sections
- Quran Metadata: $quranMetadataMigrated entries
- Fasting Data: $fastingDataMigrated duas
- Settings Translations: $settingsTranslationsMigrated entries
- Notification Strings: $notificationStringsMigrated groups
- Calendar Strings: $calendarStringsMigrated groups
- Name Transliterations: $nameTransliterationsMigrated types
- Hadith Translations: $hadithTranslationsMigrated groups
- Language Names: $languageNamesMigrated entries
- Qibla Content: ${qiblaContentMigrated ? 'Migrated' : 'Skipped'}
- Tasbih Screen Content: ${tasbihScreenContentMigrated ? 'Migrated' : 'Skipped'}
- Calendar Screen Content: ${calendarScreenContentMigrated ? 'Migrated' : 'Skipped'}
- Zakat Calculator Content: ${zakatCalculatorContentMigrated ? 'Migrated' : 'Skipped'}
- Zakat Guide Screen Content: ${zakatGuideScreenContentMigrated ? 'Migrated' : 'Skipped'}
- Quran Screen Content: ${quranScreenContentMigrated ? 'Migrated' : 'Skipped'}
- UI Translations: ${uiTranslationsMigrated ? 'Migrated' : 'Skipped'}
- Islamic Events: ${islamicEventsMigrated ? 'Migrated' : 'Skipped'}
- Fasting Times Content: ${fastingTimesContentMigrated ? 'Migrated' : 'Skipped'}
''';
  }
}

/// Hardcoded Ramadan duas data for migration to Firestore
List<Map<String, dynamic>> getHardcodedRamadanDuas() => [
    {
      'titleKey': 'duaSeeingNewMoon',
      'title': {
        'en': 'Dua for Seeing New Moon',
        'ur': 'چاند دیکھنے کی دعا',
        'hi': 'चाँद देखने की दुआ',
        'ar': 'دعاء رؤية الهلال',
      },
      'arabic':
          'اللَّهُ أَكْبَرُ، اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْأَمْنِ وَالْإِيمَانِ، وَالسَّلَامَةِ وَالْإِسْلَامِ، وَالتَّوْفِيقِ لِمَا تُحِبُّ وَتَرْضَى، رَبُّنَا وَرَبُّكَ اللَّهُ',
      'transliteration':
          "Allahu Akbar, Allahumma ahillahu 'alayna bil-amni wal-iman, was-salamati wal-islam, wat-tawfiqi lima tuhibbu wa tarda, rabbuna wa rabbuk-Allah",
      'hindi':
          'अल्लाह सबसे बड़ा है। ऐ अल्लाह! इस चाँद को हम पर अमन, ईमान, सलामती, इस्लाम और उस चीज़ की तौफ़ीक़ के साथ निकाल जिसे तू पसंद करता है और जिससे तू राज़ी होता है। हमारा और तेरा रब अल्लाह है।',
      'english':
          'Allah is the Greatest. O Allah, bring this moon upon us with peace, faith, safety, Islam, and success in what You love and are pleased with. Our Lord and your Lord is Allah.',
      'urdu':
          'اللہ سب سے بڑا ہے۔ اے اللہ! اس چاند کو ہم پر امن، ایمان، سلامتی، اسلام اور اس چیز کی توفیق کے ساتھ نکال جسے تو پسند کرتا ہے اور جس سے تو راضی ہوتا ہے۔ ہمارا اور تیرا رب اللہ ہے۔',
      'ar':
          'الله أكبر. اللهم أهلّه علينا بالأمن والإيمان والسلامة والإسلام والتوفيق لما تحب وترضى. ربنا وربك الله.',
      'color': '#1565C0',
    },
    {
      'titleKey': 'duaForSuhoor',
      'title': {
        'en': 'Dua for Suhoor',
        'ur': 'سحری کی دعا',
        'hi': 'सेहरी की दुआ',
        'ar': 'دعاء السحور',
      },
      'arabic':
          'نَوَيْتُ أَنْ أَصُومَ غَدًا مِنْ شَهْرِ رَمَضَانَ هٰذِهِ السَّنَةِ إِيمَانًا وَاحْتِسَابًا لِلَّهِ رَبِّ الْعَالَمِينَ',
      'transliteration':
          "Nawaitu an asooma ghadan min shahri Ramadan hadhihi sanati imanan wahtisaban lillahi rabbil-'aalameen",
      'hindi':
          'मैंने इस साल रमज़ान के महीने का कल रोज़ा रखने की नियत की ईमान और सवाब की उम्मीद में अल्लाह रब्बुल आलमीन के लिए।',
      'english':
          'I intend to observe the fast tomorrow for this year of Ramadan with faith and seeking reward from Allah, Lord of the Worlds.',
      'urdu':
          'میں نے اس سال رمضان کے مہینے کا کل روزہ رکھنے کی نیت کی ایمان اور ثواب کی امید میں اللہ رب العالمین کے لیے۔',
      'ar':
          'نويت أن أصوم غداً من شهر رمضان هذه السنة إيماناً واحتساباً لله رب العالمين.',
      'color': '#3949AB',
    },
    {
      'titleKey': 'duaWhileFasting',
      'title': {
        'en': 'Dua While Fasting',
        'ur': 'روزے کے دوران دعا',
        'hi': 'रोज़े के दौरान दुआ',
        'ar': 'دعاء أثناء الصيام',
      },
      'arabic': 'إِنِّي صَائِمٌ، إِنِّي صَائِمٌ',
      'transliteration': "Inni sa'im, Inni sa'im",
      'hindi':
          'मैं रोज़ेदार हूँ, मैं रोज़ेदार हूँ। (जब कोई गुस्सा दिलाए या झगड़ा करे तो यह दो बार कहें)',
      'english':
          'I am fasting, I am fasting. (Say this twice when someone provokes you or argues during fasting)',
      'urdu':
          'میں روزہ دار ہوں، میں روزہ دار ہوں۔ (جب کوئی غصہ دلائے یا جھگڑا کرے تو یہ دو بار کہیں)',
      'ar':
          'إني صائم، إني صائم. (قلها مرتين عندما يستفزك أحد أو يجادلك أثناء الصيام)',
      'color': '#00897B',
    },

    {
      'titleKey': 'duaForIftar',
      'title': {
        'en': 'Dua for Iftar',
        'ur': 'افطار کی دعا',
        'hi': 'इफ्तार की दुआ',
        'ar': 'دعاء الإفطار',
      },
      'arabic':
          'اللَّهُمَّ لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
      'transliteration':
          "Allahumma laka sumtu wa bika aamantu wa 'alaika tawakkaltu wa 'ala rizqika aftartu",
      'hindi':
          'ऐ अल्लाह! मैंने तेरे लिए रोज़ा रखा, और तुझ पर ईमान लाया, और तुझ पर भरोसा किया और तेरे दिए हुए रिज़्क़ से इफ्तार किया।',
      'english':
          'O Allah! I fasted for You, and I believe in You, and I put my trust in You, and I break my fast with Your provision.',
      'urdu':
          'اے اللہ! میں نے تیرے لیے روزہ رکھا، اور تجھ پر ایمان لایا، اور تجھ پر بھروسہ کیا اور تیرے دیے ہوئے رزق سے افطار کیا۔',
      'ar': 'اللهم لك صمت وبك آمنت وعليك توكلت وعلى رزقك أفطرت.',
      'color': '#E65100',
    },

    {
      'titleKey': 'duaForTaraweeh',
      'title': {
        'en': 'Dua for Taraweeh',
        'ur': 'تراویح کی دعا',
        'hi': 'तरावीह की दुआ',
        'ar': 'دعاء التراويح',
      },
      'arabic':
          '	سُبْحَانَ ذِي الْمُلْكِ وَالْمَلَكُوتِ، سُبْحَانَ ذِي الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ وَالْكِبْرِيَاءِ وَالْجَبَرُوتِ، سُبْحَانَ الْمَلِكِ الْحَيِّ الَّذِي لَا يَنَامُ وَلَا يَمُوتُ سُبُّوحٌ قُدُّوسٌ رَبُّنَا وَرَبُّ الْمَلَائِكَةِ وَالرُّوحِ، اَللّٰهُمَّ اَجِرْنَا مِنَ النَّارِ يَا مُجِيرُ يَا مُجِيرُ يَا مُجِيرُ',
      'transliteration':
          "Subhana dhil-mulki wal-malakoot, subhana dhil-'izzati wal-'azamati wal-haybati wal-qudrati wal-kibriya'i wal-jabaroot, subhanal-malikil-hayyil-ladhi la yanamu wa la yamootu, subboohun quddusun rabbuna wa rabbul-mala'ikati war-rooh. Allahumma ajirna minan-nar, ya mujiru, ya mujiru, ya mujir",
      'hindi':
          '	पाक है वो जो बादशाहत और सल्तनत का मालिक है, पाक है वो जो इज़्ज़त, अज़मत, हैबत, क़ुदरत, बड़ाई और जबरूत वाला है, पाक है बादशाह ज़िंदा जो न सोता है और न मरता है, बहुत पाक बहुत पवित्र है हमारा रब और फ़रिश्तों और रूह का रब। ऐ अल्लाह! हमें जहन्नम की आग से पनाह दे। ऐ पनाह देने वाले, ऐ पनाह देने वाले, ऐ पनाह देने वाले',
      'english':
          'Glory be to the Owner of the Kingdom and Dominion, Glory be to the Owner of Might, Grandeur, Awe, Power, Pride and Majesty. Glory be to the Ever-Living King who neither sleeps nor dies. Most Holy, Most Pure, Our Lord and the Lord of the Angels and the Spirit.',
      'urdu':
          '	پاک ہے وہ جو بادشاہت اور سلطنت کا مالک ہے، پاک ہے وہ جو عزت، عظمت، ہیبت، قدرت، بڑائی اور جبروت والا ہے، پاک ہے بادشاہ زندہ جو نہ سوتا ہے اور نہ مرتا ہے، بہت پاک بہت پاکیزہ ہے ہمارا رب اور فرشتوں اور روح کا رب۔ الٰہی ہم کو دوزخ سے پناہ دے۔ اے پناہ دینے والے! اے پناہ دینے والے! اے پناہ دینے والے!',
      'ar':
          'سبحان ذي الملك والملكوت، سبحان ذي العزة والعظمة والهيبة والقدرة والكبرياء والجبروت، سبحان الملك الحي الذي لا ينام ولا يموت سبوح قدوس ربنا ورب الملائكة والروح، اللهم أجرنا من النار يا مجير يا مجير يا مجير.',
      'color': '#00695C',
    },
    {
      'titleKey': 'duaWhenBreakingFast',
      'title': {
        'en': 'Dua When Breaking Fast',
        'ur': 'روزہ کھولنے کی دعا',
        'hi': 'रोज़ा खोलने की दुआ',
        'ar': 'دعاء عند الإفطار',
      },
      'arabic':
          'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
      'transliteration':
          "Dhahaba al-zama’ wabtallatil-‘urooq wa thabatal-ajru in sha Allah",
      'hindi': 'प्यास बुझ गई, नसें तर हो गईं और इंशा अल्लाह सवाब पक्का हो गया।',
      'english':
          'The thirst has gone, the veins are moistened and the reward is assured, if Allah wills.',
      'urdu': 'پیاس بجھ گئی، رگیں تر ہو گئیں اور ان شاء اللہ ثواب ثابت ہو گیا۔',
      'ar': 'ذهب الظمأ وابتلت العروق وثبت الأجر إن شاء الله.',
      'color': '#2E7D32',
    },
    {
      'titleKey': 'duaSeekingForgiveness',
      'title': {
        'en': 'Dua Seeking Forgiveness',
        'ur': 'استغفار کی دعا',
        'hi': 'इस्तिग़फ़ार की दुआ',
        'ar': 'دعاء الاستغفار',
      },
      'arabic':
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      'transliteration':
          "Rabbighfir li wa tub ‘alayya innaka antat-Tawwabur-Raheem",
      'hindi':
          'ऐ मेरे रब! मुझे माफ़ कर और मेरी तौबा क़बूल फ़रमा, बेशक तू बहुत तौबा क़बूल करने वाला है।',
      'english':
          'My Lord! Forgive me and accept my repentance. Indeed, You are the Accepter of repentance, the Merciful.',
      'urdu':
          'اے میرے رب! مجھے معاف کر اور میری توبہ قبول فرما، بیشک تو بہت توبہ قبول کرنے والا ہے۔',
      'ar': 'رب اغفر لي وتب عليّ إنك أنت التواب الرحيم.',
      'color': '#AD1457',
    },
    {
      'titleKey': 'duaForLaylatulQadr',
      'title': {
        'en': 'Dua for Laylatul Qadr',
        'ur': 'شب قدر کی دعا',
        'hi': 'लैलतुल क़द्र की दुआ',
        'ar': 'دعاء ليلة القدر',
      },
      'arabic':
          'اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      'transliteration':
          "Allahumma innaka 'afuwwun kareemun tuhibbul-'afwa fa'fu 'anni",
      'hindi':
          'ऐ अल्लाह! बेशक तू बहुत माफ़ करने वाला और करीम (सबसे उदार) है, माफ़ी को पसंद करता है, तो मुझे माफ़ कर दे।',
      'english':
          'O Allah, indeed You are Most Forgiving, Most Generous, You love to forgive, so forgive me.',
      'urdu':
          'اے اللہ! بیشک تو بہت معاف کرنے والا اور کریم (سب سے سخی) ہے، معافی کو پسند کرتا ہے، تو مجھے معاف کر دے۔',
      'ar': 'اللهم إنك عفو كريم تحب العفو فاعف عني.',
      'color': '#6A1B9A',
    },
    {
      'titleKey': 'duaEndOfRamadan',
      'title': {
        'en': 'Dua at End of Ramadan',
        'ur': 'رمضان کے اختتام کی دعا',
        'hi': 'रमज़ान के अंत की दुआ',
        'ar': 'دعاء ختم رمضان',
      },
      'arabic':
          'اللَّهُمَّ تَقَبَّلْ مِنَّا صِيَامَنَا وَقِيَامَنَا وَرُكُوعَنَا وَسُجُودَنَا وَتَسْبِيحَنَا وَتَكْبِيرَنَا وَتَهْلِيلَنَا وَتَقَبَّلْ تَوْبَتَنَا وَثَبِّتْ حُجَّتَنَا وَاغْفِرْ لَنَا ذُنُوبَنَا وَاجْعَلْنَا مِنَ الْفَائِزِينَ',
      'transliteration':
          "Allahumma taqabbal minna siyamana wa qiyamana wa rukoo'ana wa sujoodana wa tasbeehana wa takbeerana wa tahleelana wa taqabbal tawbatana wa thabbit hujjatana waghfir lana dhunoobana waj'alna minal-fa'izeen",
      'hindi':
          'ऐ अल्लाह! हमारे रोज़े, क़ियाम, रुकूअ, सजदे, तस्बीह, तकबीर और तहलील क़बूल फ़रमा और हमारी तौबा क़बूल कर, हमारी दलील को मज़बूत कर, हमारे गुनाह माफ़ कर दे और हमें कामयाब लोगों में से बना दे।',
      'english':
          'O Allah! Accept from us our fasting, our standing in prayer, our bowing, prostration, glorification, magnification and declaration of Your Oneness. Accept our repentance, strengthen our proof, forgive our sins and make us among the successful ones.',
      'urdu':
          'اے اللہ! ہمارے روزے، قیام، رکوع، سجدے، تسبیح، تکبیر اور تہلیل قبول فرما اور ہماری توبہ قبول کر، ہماری دلیل کو مضبوط کر، ہمارے گناہ معاف کر دے اور ہمیں کامیاب لوگوں میں سے بنا دے۔',
      'ar':
          'اللهم تقبل منا صيامنا وقيامنا وركوعنا وسجودنا وتسبيحنا وتكبيرنا وتهليلنا وتقبل توبتنا وثبت حجتنا واغفر لنا ذنوبنا واجعلنا من الفائزين.',
      'color': '#5E35B1',
    },
    {
      'titleKey': 'duaForEid',
      'title': {
        'en': 'Dua for Eid',
        'ur': 'عید کی دعا',
        'hi': 'ईद की दुआ',
        'ar': 'دعاء العيد',
      },
      'arabic':
          'اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ لَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ وَلِلَّهِ الْحَمْدُ',
      'transliteration':
          "Allahu Akbar, Allahu Akbar, Allahu Akbar, La ilaha illallah, Wallahu Akbar, Allahu Akbar, Wa lillahil hamd",
      'hindi':
          'अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है, अल्लाह के सिवा कोई माबूद नहीं, अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है और तमाम तारीफ़ अल्लाह के लिए है।',
      'english':
          'Allah is the Greatest, Allah is the Greatest, Allah is the Greatest. There is no deity except Allah. Allah is the Greatest, Allah is the Greatest, and all praise is for Allah.',
      'urdu':
          'اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے اور تمام تعریف اللہ کے لیے ہے۔',
      'ar':
          'الله أكبر الله أكبر الله أكبر لا إله إلا الله والله أكبر الله أكبر ولله الحمد.',
      'color': '#C62828',
    },
    {
      'titleKey': 'Ramadan Day 1',
      'title': {
        'en': 'Ramadan Day 1 Dua',
        'ur': 'رمضان کا پہلا دن',
        'hi': 'रमज़ान दिन 1 दुआ',
        'ar': 'دعاء اليوم الأول من رمضان',
      },
      'arabic': 'اللَّهُمَّ اجْعَلْ صِيَامِي فِيهِ صِيَامَ الصَّائِمِينَ',
      'transliteration': 'Allahumma-j‘al siyami fihi siyamas-sa’imeen',
      'hindi': 'ऐ अल्लाह! मेरे रोज़े को सच्चे रोज़ेदारों जैसा बना दे।',
      'english': 'O Allah! Make my fasting like the fasting of true believers.',
      'urdu': 'اے اللہ! میرے روزے کو سچے روزہ داروں جیسا بنا دے۔',
      'ar': 'اللهم اجعل صيامي فيه صيام الصائمين.',
      'color': '#1E88E5',
    },
    {
      'titleKey': 'Ramadan Day 2',
      'title': {
        'en': 'Ramadan Day 2 Dua',
        'ur': 'رمضان کا دوسرا دن',
        'hi': 'रमज़ान दिन 2 दुआ',
        'ar': 'دعاء اليوم الثاني من رمضان',
      },
      'arabic': 'اللَّهُمَّ قَرِّبْنِي فِيهِ إِلَى مَرْضَاتِكَ',
      'transliteration': 'Allahumma qarribni fihi ila mardatika',
      'hindi': 'ऐ अल्लाह! मुझे अपनी रज़ा के क़रीब कर दे।',
      'english': 'O Allah! Bring me closer to Your pleasure.',
      'urdu': 'اے اللہ! مجھے اپنی رضا کے قریب کر دے۔',
      'ar': 'اللهم قربني فيه إلى مرضاتك.',
      'color': '#43A047',
    },
    {
      'titleKey': 'Ramadan Day 3',
      'title': {
        'en': 'Ramadan Day 3 Dua',
        'ur': 'رمضان کا تیسرا دن',
        'hi': 'रमज़ान दिन 3 दुआ',
        'ar': 'دعاء اليوم الثالث من رمضان',
      },
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ الذِّهْنَ وَالتَّنْبِيهَ',
      'transliteration': 'Allahummar-zuqni fihi adh-dhihna wat-tanbeeh',
      'hindi': 'ऐ अल्लाह! मुझे समझ और होश अता फ़रमा।',
      'english': 'O Allah! Grant me understanding and awareness.',
      'urdu': 'اے اللہ! مجھے سمجھ اور ہوشیاری عطا فرما۔',
      'ar': 'اللهم ارزقني فيه الذهن والتنبيه.',
      'color': '#00897B',
    },
    {
      'titleKey': 'Ramadan Day 4',
      'title': {
        'en': 'Ramadan Day 4 Dua',
        'ur': 'رمضان کا چوتھا دن',
        'hi': 'रमज़ान दिन 4 दुआ',
        'ar': 'دعاء اليوم الرابع من رمضان',
      },
      'arabic': 'اللَّهُمَّ قَوِّنِي فِيهِ عَلَى إِقَامَةِ أَمْرِكَ',
      'transliteration': 'Allahumma qawwīni fihi ‘ala iqamati amrik',
      'hindi': 'ऐ अल्लाह! मुझे तेरे हुक्म पर चलने की ताक़त दे।',
      'english': 'O Allah! Strengthen me to obey Your commands.',
      'urdu': 'اے اللہ! مجھے تیرے احکامات پر عمل کی طاقت دے۔',
      'ar': 'اللهم قوّني فيه على إقامة أمرك.',
      'color': '#5E35B1',
    },
    {
      'titleKey': 'Ramadan Day 5',
      'title': {
        'en': 'Ramadan Day 5 Dua',
        'ur': 'رمضان کا پانچواں دن',
        'hi': 'रमज़ान दिन 5 दुआ',
        'ar': 'دعاء اليوم الخامس من رمضان',
      },
      'arabic': 'اللَّهُمَّ اجْعَلْنِي فِيهِ مِنَ الْمُسْتَغْفِرِينَ',
      'transliteration': 'Allahumma-j‘alni fihi minal-mustaghfireen',
      'hindi': 'ऐ अल्लाह! मुझे तौबा करने वालों में शामिल कर।',
      'english': 'O Allah! Make me among those who seek forgiveness.',
      'urdu': 'اے اللہ! مجھے توبہ کرنے والوں میں شامل فرما۔',
      'ar': 'اللهم اجعلني فيه من المستغفرين.',
      'color': '#6D4C41',
    },

    {
      'titleKey': 'Ramadan Day 6',
      'title': {
        'en': 'Ramadan Day 6 Dua',
        'ur': 'رمضان کا چھٹا دن',
        'hi': 'रमज़ान दिन 6 दुआ',
        'ar': 'دعاء اليوم السادس من رمضان',
      },
      'arabic': 'اللَّهُمَّ لَا تَخْذُلْنِي فِيهِ',
      'transliteration': 'Allahumma la takhdhulni fihi',
      'hindi': 'ऐ अल्लाह! मुझे इस दिन नाकामी न दे।',
      'english': 'O Allah! Do not forsake me in this day.',
      'urdu': 'اے اللہ! مجھے اس دن ناکامی نہ دے۔',
      'ar': 'اللهم لا تخذلني فيه.',
      'color': '#D32F2F',
    },
    {
      'titleKey': 'Ramadan Day 7',
      'title': {
        'en': 'Ramadan Day 7 Dua',
        'ur': 'رمضان کا ساتواں دن',
        'hi': 'रमज़ान दिन 7 दुआ',
        'ar': 'دعاء اليوم السابع من رمضان',
      },
      'arabic': 'اللَّهُمَّ أَعِنِّي فِيهِ عَلَى صِيَامِهِ وَقِيَامِهِ',
      'transliteration': 'Allahumma a\'inni fihi \'ala siyamihi wa qiyamih',
      'hindi': 'ऐ अल्लाह! रोज़े और क़ियाम में मेरी मदद फ़रमा।',
      'english': 'O Allah! Help me with fasting and standing in prayer.',
      'urdu': 'اے اللہ! روزے اور قیام میں میری مدد فرما۔',
      'ar': 'اللهم أعني فيه على صيامه وقيامه.',
      'color': '#7B1FA2',
    },
    {
      'titleKey': 'Ramadan Day 8',
      'title': {
        'en': 'Ramadan Day 8 Dua',
        'ur': 'رمضان کا آٹھواں دن',
        'hi': 'रमज़ान दिन 8 दुआ',
        'ar': 'دعاء اليوم الثامن من رمضان',
      },
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ رَحْمَةَ الْأَيْتَامِ',
      'transliteration': 'Allahummar-zuqni fihi rahmatal-aytam',
      'hindi': 'ऐ अल्लाह! यतीमों पर रहम करने की तौफ़ीक़ दे।',
      'english': 'O Allah! Grant me mercy towards orphans.',
      'urdu': 'اے اللہ! یتیموں پر رحم کرنے کی توفیق دے۔',
      'ar': 'اللهم ارزقني فيه رحمة الأيتام.',
      'color': '#0288D1',
    },
    {
      'titleKey': 'Ramadan Day 9',
      'title': {
        'en': 'Ramadan Day 9 Dua',
        'ur': 'رمضان کا نواں دن',
        'hi': 'रमज़ान दिन 9 दुआ',
        'ar': 'دعاء اليوم التاسع من رمضان',
      },
      'arabic': 'اللَّهُمَّ اجْعَلْ لِي فِيهِ نَصِيبًا مِنْ رَحْمَتِكَ',
      'transliteration': 'Allahumma-j\'al li fihi nasiban min rahmatik',
      'hindi': 'ऐ अल्लाह! अपनी रहमत में मेरा हिस्सा रख।',
      'english': 'O Allah! Make for me a share of Your mercy.',
      'urdu': 'اے اللہ! اپنی رحمت میں میرا حصہ رکھ۔',
      'ar': 'اللهم اجعل لي فيه نصيباً من رحمتك.',
      'color': '#388E3C',
    },
    {
      'titleKey': 'Ramadan Day 10',
      'title': {
        'en': 'Ramadan Day 10 Dua',
        'ur': 'رمضان کا دسواں دن',
        'hi': 'रमज़ान दिन 10 दुआ',
        'ar': 'دعاء اليوم العاشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ اجْعَلْنِي فِيهِ مِنَ الْمُتَوَكِّلِينَ',
      'transliteration': 'Allahumma-j\'alni fihi minal-mutawakkileen',
      'hindi': 'ऐ अल्लाह! मुझे तुझ पर भरोसा करने वाला बना।',
      'english': 'O Allah! Make me among those who trust You.',
      'urdu': 'اے اللہ! مجھے تجھ پر بھروسہ کرنے والا بنا۔',
      'ar': 'اللهم اجعلني فيه من المتوكلين.',
      'color': '#0277BD',
    },
    {
      'titleKey': 'Ramadan Day 11',
      'title': {
        'en': 'Ramadan Day 11 Dua',
        'ur': 'رمضان کا گیارھواں دن',
        'hi': 'रमज़ान दिन 11 दुआ',
        'ar': 'دعاء اليوم الحادي عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ حَبِّبْ إِلَيَّ فِيهِ الْإِحْسَانَ',
      'transliteration': 'Allahumma habbib ilayya fihil-ihsan',
      'hindi': 'ऐ अल्लाह! नेकी को मेरे दिल में प्यारा बना दे।',
      'english': 'O Allah! Make goodness beloved to me.',
      'urdu': 'اے اللہ! نیکی کو میرے دل میں پیارا بنا دے۔',
      'ar': 'اللهم حبّب إليّ فيه الإحسان.',
      'color': '#00796B',
    },
    {
      'titleKey': 'Ramadan Day 12',
      'title': {
        'en': 'Ramadan Day 12 Dua',
        'ur': 'رمضان کا بارھواں دن',
        'hi': 'रमज़ान दिन 12 दुआ',
        'ar': 'دعاء اليوم الثاني عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ اسْتُرْ فِيهِ عَوْرَاتِي',
      'transliteration': 'Allahumma-stur fihi \'awrati',
      'hindi': 'ऐ अल्लाह! मेरी कमियों को छुपा दे।',
      'english': 'O Allah! Cover my faults and weaknesses.',
      'urdu': 'اے اللہ! میری کمیوں کو چھپا دے۔',
      'ar': 'اللهم استر فيه عوراتي.',
      'color': '#5D4037',
    },
    {
      'titleKey': 'Ramadan Day 13',
      'title': {
        'en': 'Ramadan Day 13 Dua',
        'ur': 'رمضان کا تیرھواں دن',
        'hi': 'रमज़ान दिन 13 दुआ',
        'ar': 'دعاء اليوم الثالث عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ طَهِّرْنِي فِيهِ مِنَ الدَّنَسِ',
      'transliteration': 'Allahumma tahhirni fihi minad-danas',
      'hindi': 'ऐ अल्लाह! मुझे गुनाहों से पाक कर दे।',
      'english': 'O Allah! Purify me from sins and impurities.',
      'urdu': 'اے اللہ! مجھے گناہوں سے پاک کر دے۔',
      'ar': 'اللهم طهرني فيه من الدنس.',
      'color': '#1976D2',
    },
    {
      'titleKey': 'Ramadan Day 14',
      'title': {
        'en': 'Ramadan Day 14 Dua',
        'ur': 'رمضان کا چودھواں دن',
        'hi': 'रमज़ान दिन 14 दुआ',
        'ar': 'دعاء اليوم الرابع عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ لَا تُؤَاخِذْنِي فِيهِ بِالْعَثَرَاتِ',
      'transliteration': 'Allahumma la tu\'akhidhni fihi bil-\'atharat',
      'hindi': 'ऐ अल्लाह! मेरी गलतियों पर सज़ा न दे।',
      'english': 'O Allah! Do not punish me for my mistakes.',
      'urdu': 'اے اللہ! میری غلطیوں پر سزا نہ دے۔',
      'ar': 'اللهم لا تؤاخذني فيه بالعثرات.',
      'color': '#689F38',
    },
    {
      'titleKey': 'Ramadan Day 15',
      'title': {
        'en': 'Ramadan Day 15 Dua',
        'ur': 'رمضان کا پندرھواں دن',
        'hi': 'रमज़ान दिन 15 दुआ',
        'ar': 'دعاء اليوم الخامس عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ طَاعَةَ الْخَاشِعِينَ',
      'transliteration': 'Allahummar-zuqni fihi ta\'ata al-khashi\'een',
      'hindi': 'ऐ अल्लाह! मुझे सच्ची इताअत अता फ़रमा।',
      'english': 'O Allah! Grant me obedience with humility.',
      'urdu': 'اے اللہ! مجھے عاجزی کے ساتھ اطاعت عطا فرما۔',
      'ar': 'اللهم ارزقني فيه طاعة الخاشعين.',
      'color': '#2E7D32',
    },
    {
      'titleKey': 'Ramadan Day 16',
      'title': {
        'en': 'Ramadan Day 16 Dua',
        'ur': 'رمضان کا سولھواں دن',
        'hi': 'रमज़ान दिन 16 दुआ',
        'ar': 'دعاء اليوم السادس عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ وَفِّقْنِي فِيهِ لِمُوَافَقَةِ الْأَبْرَارِ',
      'transliteration': 'Allahumma waffiqni fihi limuwafaqatil-abrar',
      'hindi': 'ऐ अल्लाह! नेक लोगों की संगत नसीब कर।',
      'english': 'O Allah! Grant me company of the righteous.',
      'urdu': 'اے اللہ! نیک لوگوں کی صحبت نصیب کر۔',
      'ar': 'اللهم وفقني فيه لموافقة الأبرار.',
      'color': '#AFB42B',
    },
    {
      'titleKey': 'Ramadan Day 17',
      'title': {
        'en': 'Ramadan Day 17 Dua',
        'ur': 'رمضان کا سترھواں دن',
        'hi': 'रमज़ान दिन 17 दुआ',
        'ar': 'دعاء اليوم السابع عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ اهْدِنِي فِيهِ لِصَالِحِ الْأَعْمَالِ',
      'transliteration': 'Allahumma-hdini fihi lisalihil-a\'mal',
      'hindi': 'ऐ अल्लाह! नेक आमाल की हिदायत दे।',
      'english': 'O Allah! Guide me to righteous deeds.',
      'urdu': 'اے اللہ! نیک اعمال کی ہدایت دے۔',
      'ar': 'اللهم اهدني فيه لصالح الأعمال.',
      'color': '#F57C00',
    },
    {
      'titleKey': 'Ramadan Day 18',
      'title': {
        'en': 'Ramadan Day 18 Dua',
        'ur': 'رمضان کا اٹھارھواں دن',
        'hi': 'रमज़ान दिन 18 दुआ',
        'ar': 'دعاء اليوم الثامن عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ نَبِّهْنِي فِيهِ لِبَرَكَاتِ أَسْحَارِهِ',
      'transliteration': 'Allahumma nabbihni fihi libarakati asharihi',
      'hindi': 'ऐ अल्लाह! सेहरी की बरकतों का एहसास करा।',
      'english': 'O Allah! Awaken me to the blessings of its pre-dawn.',
      'urdu': 'اے اللہ! سحری کی برکتوں کا احساس کرا۔',
      'ar': 'اللهم نبهني فيه لبركات أسحاره.',
      'color': '#00838F',
    },
    {
      'titleKey': 'Ramadan Day 19',
      'title': {
        'en': 'Ramadan Day 19 Dua',
        'ur': 'رمضان کا انیسواں دن',
        'hi': 'रमज़ान दिन 19 दुआ',
        'ar': 'دعاء اليوم التاسع عشر من رمضان',
      },
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ مِنَ النَّصِيبِ مِنْ بَرَكَاتِهِ',
      'transliteration': 'Allahummar-zuqni fihi minan-nasib min barakatihi',
      'hindi': 'ऐ अल्लाह! इस दिन की बरकतों में मेरा हिस्सा दे।',
      'english': 'O Allah! Grant me a share of its blessings.',
      'urdu': 'اے اللہ! اس دن کی برکتوں میں میرا حصہ دے۔',
      'ar': 'اللهم ارزقني فيه من النصيب من بركاته.',
      'color': '#558B2F',
    },
    {
      'titleKey': 'Ramadan Day 20',
      'title': {
        'en': 'Ramadan Day 20 Dua',
        'ur': 'رمضان کا بیسواں دن',
        'hi': 'रमज़ान दिन 20 दुआ',
        'ar': 'دعاء اليوم العشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ افْتَحْ لِي فِيهِ أَبْوَابَ الْجِنَانِ',
      'transliteration': 'Allahumma-ftah li fihi abwabal-jinan',
      'hindi': 'ऐ अल्लाह! मेरे लिए जन्नत के दरवाज़े खोल दे।',
      'english': 'O Allah! Open for me the doors of Paradise.',
      'urdu': 'اے اللہ! میرے لیے جنت کے دروازے کھول دے۔',
      'ar': 'اللهم افتح لي فيه أبواب الجنان.',
      'color': '#8E24AA',
    },
    {
      'titleKey': 'Ramadan Day 21',
      'title': {
        'en': 'Ramadan Day 21 Dua',
        'ur': 'رمضان کا اکیسواں دن',
        'hi': 'रमज़ान दिन 21 दुआ',
        'ar': 'دعاء اليوم الحادي والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ اهْدِنِي فِيهِ إِلَى سُبُلِ السَّلَامِ',
      'transliteration': 'Allahumma-hdini fihi ila subulus-salam',
      'hindi': 'ऐ अल्लाह! सलामती के रास्तों की हिदायत दे।',
      'english': 'O Allah! Guide me to the paths of peace.',
      'urdu': 'اے اللہ! سلامتی کے راستوں کی ہدایت دے۔',
      'ar': 'اللهم اهدني فيه إلى سبل السلام.',
      'color': '#512DA8',
    },
    {
      'titleKey': 'Ramadan Day 22',
      'title': {
        'en': 'Ramadan Day 22 Dua',
        'ur': 'رمضان کا بائیسواں دن',
        'hi': 'रमज़ान दिन 22 दुआ',
        'ar': 'دعاء اليوم الثاني والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ افْتَحْ لِي فِيهِ أَبْوَابَ فَضْلِكَ',
      'transliteration': 'Allahumma-ftah li fihi abwaba fadlik',
      'hindi': 'ऐ अल्लाह! अपने फ़ज़्ल के दरवाज़े खोल दे।',
      'english': 'O Allah! Open for me the gates of Your grace.',
      'urdu': 'اے اللہ! اپنے فضل کے دروازے کھول دے۔',
      'ar': 'اللهم افتح لي فيه أبواب فضلك.',
      'color': '#303F9F',
    },
    {
      'titleKey': 'Ramadan Day 23',
      'title': {
        'en': 'Ramadan Day 23 Dua',
        'ur': 'رمضان کا تئیسواں دن',
        'hi': 'रमज़ान दिन 23 दुआ',
        'ar': 'دعاء اليوم الثالث والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ اغْسِلْنِي فِيهِ مِنَ الذُّنُوبِ',
      'transliteration': 'Allahumma-ghsilni fihi minadh-dhunub',
      'hindi': 'ऐ अल्लाह! मुझे गुनाहों से धो दे।',
      'english': 'O Allah! Wash me from sins in this day.',
      'urdu': 'اے اللہ! مجھے گناہوں سے دھو دے۔',
      'ar': 'اللهم اغسلني فيه من الذنوب.',
      'color': '#0097A7',
    },
    {
      'titleKey': 'Ramadan Day 24',
      'title': {
        'en': 'Ramadan Day 24 Dua',
        'ur': 'رمضان کا چوبیسواں دن',
        'hi': 'रमज़ान दिन 24 दुआ',
        'ar': 'دعاء اليوم الرابع والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ فِيهِ مَا يُرْضِيكَ',
      'transliteration': 'Allahumma inni as\'aluka fihi ma yurdika',
      'hindi': 'ऐ अल्लाह! मैं तुझसे वो मांगता हूं जो तुझे पसंद है।',
      'english': 'O Allah! I ask You for what pleases You.',
      'urdu': 'اے اللہ! میں تجھ سے وہ مانگتا ہوں جو تجھے پسند ہے۔',
      'ar': 'اللهم إني أسألك فيه ما يرضيك.',
      'color': '#00796B',
    },
    {
      'titleKey': 'Ramadan Day 25',
      'title': {
        'en': 'Ramadan Day 25 Dua',
        'ur': 'رمضان کا پچیسواں دن',
        'hi': 'रमज़ान दिन 25 दुआ',
        'ar': 'دعاء اليوم الخامس والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ اجْعَلْنِي فِيهِ مُحِبًّا لِأَوْلِيَائِكَ',
      'transliteration': 'Allahumma-j\'alni fihi muhibban li-awliya\'ik',
      'hindi': 'ऐ अल्लाह! मुझे अपने नेक बंदों से मोहब्बत करने वाला बना।',
      'english': 'O Allah! Make me love Your righteous servants.',
      'urdu': 'اے اللہ! مجھے اپنے نیک بندوں سے محبت کرنے والا بنا۔',
      'ar': 'اللهم اجعلني فيه محباً لأوليائك.',
      'color': '#3949AB',
    },
    {
      'titleKey': 'Ramadan Day 26',
      'title': {
        'en': 'Ramadan Day 26 Dua',
        'ur': 'رمضان کا چھبیسواں دن',
        'hi': 'रमज़ान दिन 26 दुआ',
        'ar': 'دعاء اليوم السادس والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ اجْعَلْ سَعْيِي فِيهِ مَشْكُورًا',
      'transliteration': 'Allahumma-j\'al sa\'yi fihi mashkura',
      'hindi': 'ऐ अल्लाह! मेरी कोशिश को क़बूल फ़रमा।',
      'english': 'O Allah! Make my efforts appreciated.',
      'urdu': 'اے اللہ! میری کوشش کو قبول فرما۔',
      'ar': 'اللهم اجعل سعيي فيه مشكوراً.',
      'color': '#C62828',
    },
    {
      'titleKey': 'Ramadan Day 27',
      'title': {
        'en': 'Ramadan Day 27 Dua',
        'ur': 'رمضان کا ستائیسواں دن',
        'hi': 'रमज़ान दिन 27 दुआ',
        'ar': 'دعاء اليوم السابع والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ فَضْلَ لَيْلَةِ الْقَدْرِ',
      'transliteration': 'Allahummar-zuqni fihi fadla laylatil-qadr',
      'hindi': 'ऐ अल्लाह! मुझे शबे क़द्र की फ़ज़ीलत नसीब कर।',
      'english': 'O Allah! Grant me the merit of Laylatul Qadr.',
      'urdu': 'اے اللہ! مجھے شب قدر کی فضیلت نصیب کر۔',
      'ar': 'اللهم ارزقني فيه فضل ليلة القدر.',
      'color': '#6A1B9A',
    },
    {
      'titleKey': 'Ramadan Day 28',
      'title': {
        'en': 'Ramadan Day 28 Dua',
        'ur': 'رمضان کا اٹھائیسواں دن',
        'hi': 'रमज़ान दिन 28 दुआ',
        'ar': 'دعاء اليوم الثامن والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ وَفِّرْ حَظِّي فِيهِ مِنَ النَّوَافِلِ',
      'transliteration': 'Allahumma waffir hazzi fihi minan-nawafil',
      'hindi': 'ऐ अल्लाह! नफ़िल इबादत में मेरा हिस्सा बढ़ा दे।',
      'english': 'O Allah! Increase my share of voluntary worship.',
      'urdu': 'اے اللہ! نفل عبادت میں میرا حصہ بڑھا دے۔',
      'ar': 'اللهم وفّر حظي فيه من النوافل.',
      'color': '#AD1457',
    },
    {
      'titleKey': 'Ramadan Day 29',
      'title': {
        'en': 'Ramadan Day 29 Dua',
        'ur': 'رمضان کا انتیسواں دن',
        'hi': 'रमज़ान दिन 29 दुआ',
        'ar': 'دعاء اليوم التاسع والعشرين من رمضان',
      },
      'arabic': 'اللَّهُمَّ غَشِّنِي فِيهِ بِالرَّحْمَةِ',
      'transliteration': 'Allahumma ghashshini fihi bir-rahmah',
      'hindi': 'ऐ अल्लाह! मुझे अपनी रहमत से ढक दे।',
      'english': 'O Allah! Cover me with Your mercy.',
      'urdu': 'اے اللہ! مجھے اپنی رحمت سے ڈھانپ دے۔',
      'ar': 'اللهم غشني فيه بالرحمة.',
      'color': '#E64A19',
    },
    {
      'titleKey': 'Ramadan Day 30',
      'title': {
        'en': 'Ramadan Day 30 Dua',
        'ur': 'رمضان کا تیسواں دن',
        'hi': 'रमज़ान दिन 30 दुआ',
        'ar': 'دعاء اليوم الثلاثين من رمضان',
      },
      'arabic': 'اللَّهُمَّ تَقَبَّلْ مِنِّي وَاغْفِرْ لِي',
      'transliteration': 'Allahumma taqabbal minni waghfir li',
      'hindi': 'ऐ अल्लाह! मेरी इबादत क़बूल कर और मुझे माफ़ कर दे।',
      'english': 'O Allah! Accept from me and forgive me.',
      'urdu': 'اے اللہ! میری عبادت قبول فرما اور مجھے معاف کر دے۔',
      'ar': 'اللهم تقبل مني واغفر لي.',
      'color': '#C62828',
    },
  ];

/// Hardcoded fasting duas data for migration to Firestore
List<Map<String, dynamic>> getHardcodedFastingDuas() => [
    {
      'titleKey': 'duaForSuhoor',
      'title': {
        'en': 'Dua for Suhoor',
        'ur': 'سحری کی دعا',
        'hi': 'सेहरी की दुआ',
        'ar': 'دعاء السحور',
      },
      'arabic': 'نَوَيْتُ أَنْ أَصُومَ غَدًا مِنْ شَهْرِ رَمَضَانَ هٰذِهِ السَّنَةِ إِيمَانًا وَاحْتِسَابًا لِلَّهِ رَبِّ الْعَالَمِينَ',
      'transliteration': "Nawaitu an asooma ghadan min shahri Ramadan hadhihi sanati imanan wahtisaban lillahi rabbil-'aalameen",
      'hindi': 'मैंने इस साल रमज़ान के महीने का कल रोज़ा रखने की नियत की ईमान और सवाब की उम्मीद में अल्लाह रब्बुल आलमीन के लिए।',
      'english': 'I intend to observe the fast tomorrow for this year of Ramadan with faith and seeking reward from Allah, Lord of the Worlds.',
      'urdu': 'میں نے اس سال رمضان کے مہینے کا کل روزہ رکھنے کی نیت کی ایمان اور ثواب کی امید میں اللہ رب العالمین کے لیے۔',
      'ar': 'نويت أن أصوم غداً من شهر رمضان هذه السنة إيماناً واحتساباً لله رب العالمين.',
      'color': '#3949AB',
    },
    {
      'titleKey': 'duaForIftar',
      'title': {
        'en': 'Dua for Iftar',
        'ur': 'افطار کی دعا',
        'hi': 'इफ्तार की दुआ',
        'ar': 'دعاء الإفطار',
      },
      'arabic': 'اللَّهُمَّ لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
      'transliteration': "Allahumma laka sumtu wa bika aamantu wa 'alaika tawakkaltu wa 'ala rizqika aftartu",
      'hindi': 'ऐ अल्लाह! मैंने तेरे लिए रोज़ा रखा, और तुझ पर ईमान लाया, और तुझ पर भरोसा किया और तेरे दिए हुए रिज़्क़ से इफ्तार किया।',
      'english': 'O Allah! I fasted for You, and I believe in You, and I put my trust in You, and I break my fast with Your provision.',
      'urdu': 'اے اللہ! میں نے تیرے لیے روزہ رکھا، اور تجھ پر ایمان لایا، اور تجھ پر بھروسہ کیا اور تیرے دیے ہوئے رزق سے افطار کیا۔',
      'ar': 'اللهم لك صمت وبك آمنت وعليك توكلت وعلى رزقك أفطرت.',
      'color': '#E65100',
    },
    {
      'titleKey': 'duaWhenBreakingWithDates',
      'title': {
        'en': 'Dua When Breaking Fast with Dates',
        'ur': 'کھجور سے روزہ کھولنے کی دعا',
        'hi': 'खजूर से रोज़ा खोलने की दुआ',
        'ar': 'دعاء الإفطار على التمر',
      },
      'arabic': 'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
      'transliteration': "Dhahaba al-zama'u wa'btallatil-'urooqu wa thabatal-ajru in sha Allah",
      'hindi': 'प्यास चली गई, नसें तर हो गईं, और इन्शाअल्लाह अज्र साबित हो गया।',
      'english': 'The thirst has gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
      'urdu': 'پیاس چلی گئی، رگیں تر ہوگئیں، اور ان شاءاللہ اجر ثابت ہوگیا۔',
      'ar': 'ذهب الظمأ وابتلت العروق وثبت الأجر إن شاء الله.',
      'color': '#00897B',
      'reference': {
        'en': 'Abu Dawud',
        'ur': 'ابو داؤد',
        'hi': 'अबू दाऊद',
        'ar': 'أبو داود',
      },
    },
    {
      'titleKey': 'duaForFastingPerson',
      'title': {
        'en': 'Dua for Fasting Person',
        'ur': 'روزہ دار کے لیے دعا',
        'hi': 'रोज़ेदार के लिए दुआ',
        'ar': 'دعاء للصائم',
      },
      'arabic': 'أَفْطَرَ عِندَكُمُ الصَّائِمُونَ وَأَكَلَ طَعَامَكُمُ الْأَبْرَارُ وَصَلَّتْ عَلَيْكُمُ الْمَلَائِكَةُ',
      'transliteration': "Aftara 'indakumus-saa'imoona wa akala ta'aamakumul-abraaru wa sallat 'alaikumul-malaa'ikah",
      'hindi': 'तुम्हारे यहाँ रोज़ेदारों ने इफ्तार किया, और तुम्हारा खाना नेक लोगों ने खाया, और फ़रिश्तों ने तुम पर दुरूद भेजा।',
      'english': 'May the fasting people break their fast with you, may the righteous eat your food, and may the angels send blessings upon you.',
      'urdu': 'تمہارے یہاں روزہ داروں نے افطار کیا، اور تمہارا کھانا نیک لوگوں نے کھایا، اور فرشتوں نے تم پر درود بھیجا۔',
      'ar': 'أفطر عندكم الصائمون وأكل طعامكم الأبرار وصلت عليكم الملائكة.',
      'color': '#5E35B1',
      'reference': {
        'en': 'Abu Dawud, Ibn Majah',
        'ur': 'ابو داؤد، ابن ماجہ',
        'hi': 'अबू दाऊद, इब्ने माजाह',
        'ar': 'أبو داود، ابن ماجه',
      },
    },
    {
      'titleKey': 'duaAfterCompletingFast',
      'title': {
        'en': 'Dua After Completing Fast',
        'ur': 'روزہ مکمل کرنے کے بعد دعا',
        'hi': 'रोज़ा पूरा करने के बाद दुआ',
        'ar': 'دعاء بعد إتمام الصيام',
      },
      'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ أَنْ تَغْفِرَ لِي',
      'transliteration': "Allahumma inni as'aluka bi rahmatika al-lati wasi'at kulla shay'in an taghfira li",
      'hindi': 'ऐ अल्लाह! मैं तुझसे तेरी उस रहमत के वसीले से जो हर चीज़ को घेरे हुए है, दुआ करता हूँ कि तू मुझे माफ़ कर दे।',
      'english': 'O Allah! I ask You by Your mercy which encompasses all things, that You forgive me.',
      'urdu': 'اے اللہ! میں تجھ سے تیری اس رحمت کے وسیلے سے جو ہر چیز کو گھیرے ہوئے ہے، دعا کرتا ہوں کہ تو مجھے معاف کردے۔',
      'ar': 'اللهم إني أسألك برحمتك التي وسعت كل شيء أن تغفر لي.',
      'color': '#D84315',
      'reference': {
        'en': 'Ibn Majah',
        'ur': 'ابن ماجہ',
        'hi': 'इब्ने माजाह',
        'ar': 'ابن ماجه',
      },
    },
    {
      'titleKey': 'duaForSeeingMoon',
      'title': {
        'en': 'Dua for Seeing Moon',
        'ur': 'چاند دیکھنے کی دعا',
        'hi': 'चाँद देखने की दुआ',
        'ar': 'دعاء رؤية الهلال',
      },
      'arabic': 'اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْيُمْنِ وَالْإِيمَانِ وَالسَّلَامَةِ وَالْإِسْلَامِ رَبِّي وَرَبُّكَ اللَّهُ',
      'transliteration': "Allahumma ahillahu 'alaina bil-yumni wal-imaani was-salaamati wal-Islaam, Rabbi wa Rabbuk Allah",
      'hindi': 'ऐ अल्लाह! इस चाँद को हम पर बरकत, ईमान, सलामती और इस्लाम के साथ निकाल। मेरा और तेरा रब अल्लाह है।',
      'english': 'O Allah! Let this moon appear on us with blessings, faith, safety and Islam. My Lord and your Lord is Allah.',
      'urdu': 'اے اللہ! اس چاند کو ہم پر برکت، ایمان، سلامتی اور اسلام کے ساتھ نکال۔ میرا اور تیرا رب اللہ ہے۔',
      'ar': 'اللهم أهلّه علينا باليمن والإيمان والسلامة والإسلام ربي وربك الله.',
      'color': '#1565C0',
      'reference': {
        'en': 'Tirmidhi',
        'ur': 'ترمذی',
        'hi': 'तिर्मिज़ी',
        'ar': 'الترمذي',
      },
    },
  ];

/// Hardcoded fasting virtues data for migration to Firestore
List<Map<String, dynamic>> getHardcodedFastingVirtues() => [
    {
      'icon': 'door_front_door',
      'title': {
        'en': 'Gate of Rayyan',
        'ur': 'باب الریان',
        'hi': 'बाब अर-रय्यान',
        'ar': 'باب الريان',
      },
      'description': {
        'en': 'There is a gate in Paradise called Ar-Rayyan, through which only those who fast will enter.',
        'ur': 'جنت میں ایک دروازہ ہے جسے ریان کہتے ہیں، اس میں سے صرف روزہ دار داخل ہوں گے۔',
        'hi': 'जन्नत में एक दरवाज़ा है जिसे रय्यान कहते हैं, उससे सिर्फ़ रोज़ेदार दाखिल होंगे।',
        'ar': 'في الجنة باب يقال له الريان، يدخل منه الصائمون.',
      },
      'reference': {
        'en': 'Bukhari & Muslim',
        'ur': 'بخاری و مسلم',
        'hi': 'बुखारी व मुस्लिम',
        'ar': 'البخاري ومسلم',
      },
    },
    {
      'icon': 'shield',
      'title': {
        'en': 'Fasting is a Shield',
        'ur': 'روزہ ڈھال ہے',
        'hi': 'रोज़ा ढाल है',
        'ar': 'الصيام جُنّة',
      },
      'description': {
        'en': 'Fasting is a shield from the Hellfire, just like a shield protects one of you in battle.',
        'ur': 'روزہ جہنم سے بچاؤ کی ڈھال ہے، جیسے جنگ میں ڈھال حفاظت کرتی ہے۔',
        'hi': 'रोज़ा जहन्नम से बचाव की ढाल है, जैसे जंग में ढाल हिफ़ाज़त करती है।',
        'ar': 'الصيام جُنّة من النار، كما يقي أحدكم درعه في القتال.',
      },
      'reference': {
        'en': 'Ahmad, Nasai',
        'ur': 'احمد، نسائی',
        'hi': 'अहमद, नसई',
        'ar': 'أحمد، النسائي',
      },
    },
    {
      'icon': 'favorite',
      'title': {
        'en': 'The Breath of Fasting Person',
        'ur': 'روزہ دار کی سانس',
        'hi': 'रोज़ेदार की सांस',
        'ar': 'خلوف فم الصائم',
      },
      'description': {
        'en': 'The smell from the mouth of a fasting person is better in the sight of Allah than the scent of musk.',
        'ur': 'روزہ دار کے منہ کی بو اللہ کے نزدیک مشک سے زیادہ پاکیزہ ہے۔',
        'hi': 'रोज़ेदार के मुंह की बू अल्लाह के नज़दीक मुश्क से ज़्यादा पाकीज़ा है।',
        'ar': 'لخلوف فم الصائم أطيب عند الله من ريح المسك.',
      },
      'reference': {
        'en': 'Bukhari & Muslim',
        'ur': 'بخاری و مسلم',
        'hi': 'बुखारी व मुस्लिम',
        'ar': 'البخاري ومسلم',
      },
    },
    {
      'icon': 'celebration',
      'title': {
        'en': 'Two Moments of Joy',
        'ur': 'دو خوشیاں',
        'hi': 'दो खुशियां',
        'ar': 'فرحتان',
      },
      'description': {
        'en': 'The fasting person has two moments of joy: when breaking fast and when meeting their Lord.',
        'ur': 'روزہ دار کو دو خوشیاں ہیں: افطار کے وقت اور اپنے رب سے ملاقات کے وقت۔',
        'hi': 'रोज़ेदार को दो खुशियां हैं: इफ़्तार के वक़्त और अपने रब से मिलने के वक़्त।',
        'ar': 'للصائم فرحتان: فرحة عند فطره، وفرحة عند لقاء ربه.',
      },
      'reference': {
        'en': 'Bukhari & Muslim',
        'ur': 'بخاری و مسلم',
        'hi': 'बुखारी व मुस्लिम',
        'ar': 'البخاري ومسلم',
      },
    },
    {
      'icon': 'handshake',
      'title': {
        'en': 'Dua is Accepted',
        'ur': 'دعا قبول ہوتی ہے',
        'hi': 'दुआ क़बूल होती है',
        'ar': 'الدعاء مستجاب',
      },
      'description': {
        'en': 'Three prayers are not rejected: the prayer of a fasting person until they break their fast.',
        'ur': 'تین دعائیں رد نہیں ہوتیں: روزہ دار کی دعا جب تک افطار نہ کرے۔',
        'hi': 'तीन दुआएं रद्द नहीं होतीं: रोज़ेदार की दुआ जब तक इफ़्तार न करे।',
        'ar': 'ثلاث دعوات لا ترد: دعوة الصائم حتى يفطر.',
      },
      'reference': {
        'en': 'Tirmidhi, Ibn Majah',
        'ur': 'ترمذی، ابن ماجہ',
        'hi': 'तिर्मिज़ी, इब्ने माजाह',
        'ar': 'الترمذي، ابن ماجه',
      },
    },
  ];

/// Hardcoded fasting rules data for migration to Firestore
Map<String, dynamic> getHardcodedFastingRules() => {
    'title': {
      'en': 'Fasting Rules',
      'ur': 'روزے کے احکام',
      'hi': 'रोज़े के अहकाम',
      'ar': 'أحكام الصيام',
    },
    'breaks_fast_title': {
      'en': 'What Breaks the Fast',
      'ur': 'روزہ توڑنے والی چیزیں',
      'hi': 'रोज़ा तोड़ने वाली चीज़ें',
      'ar': 'مبطلات الصيام',
    },
    'does_not_break_fast_title': {
      'en': 'What Does Not Break the Fast',
      'ur': 'روزہ نہیں توڑتیں',
      'hi': 'रोज़ा नहीं तोड़तीं',
      'ar': 'ما لا يبطل الصيام',
    },
    'breaks_fast': [
      {
        'en': 'Eating or drinking intentionally',
        'ur': 'جان بوجھ کر کھانا پینا',
        'hi': 'जान-बूझकर खाना-पीना',
        'ar': 'الأكل أو الشرب عمداً',
      },
      {
        'en': 'Intentional vomiting',
        'ur': 'جان بوجھ کر قے کرنا',
        'hi': 'जान-बूझकर उल्टी करना',
        'ar': 'القيء عمداً',
      },
      {
        'en': 'Sexual relations',
        'ur': 'جماع',
        'hi': 'जिमा (संभोग)',
        'ar': 'الجماع',
      },
      {
        'en': 'Menstruation or postnatal bleeding',
        'ur': 'حیض یا نفاس',
        'hi': 'हैज़ या निफ़ास',
        'ar': 'الحيض أو النفاس',
      },
    ],
    'does_not_break_fast': [
      {
        'en': 'Eating/drinking forgetfully',
        'ur': 'بھول کر کھانا پینا',
        'hi': 'भूलकर खाना-पीना',
        'ar': 'الأكل أو الشرب نسياناً',
      },
      {
        'en': 'Swallowing saliva',
        'ur': 'تھوک نگلنا',
        'hi': 'थूक निगलना',
        'ar': 'بلع الريق',
      },
      {
        'en': 'Tasting food without swallowing',
        'ur': 'کھانا چکھنا بغیر نگلے',
        'hi': 'खाना चखना बिना निगले',
        'ar': 'تذوق الطعام دون بلعه',
      },
      {
        'en': 'Using miswak (tooth stick)',
        'ur': 'مسواک کرنا',
        'hi': 'मिसवाक करना',
        'ar': 'استخدام السواك',
      },
      {
        'en': 'Injections not for nutrition',
        'ur': 'غذائی نہیں انجکشن',
        'hi': 'ग़ैर-ग़िज़ाई इंजेक्शन',
        'ar': 'الحقن غير المغذية',
      },
    ],
  };

/// Hardcoded Islamic months fasting chart data for migration to Firestore
Map<String, dynamic> getHardcodedIslamicMonthsData() => {
    'title': {
      'en': 'Islamic 12 Months - Fasting Chart',
      'ur': 'اسلامی 12 مہینے - روزے کا چارٹ',
      'hi': 'इस्लामी 12 महीने - रोज़े का चार्ट',
      'ar': 'الأشهر الإسلامية 12 - جدول الصيام',
    },
    'months': [
      {
        'name': {
          'en': 'Muharram',
          'ur': 'محرم',
          'hi': 'मुहर्रम',
          'ar': 'محرم',
        },
        'icon': 'nights_stay',
        'color': '#6A1B9A',
        'fasting_days': [
          {
            'days': '9, 10, 11',
            'desc': {
              'en': 'Ashura fasts - Sunnah',
              'ur': 'عاشورا کے روزے - سنت',
              'hi': 'आशूरा के रोज़े - सुन्नत',
              'ar': 'صيام عاشوراء - سنة',
            },
            'type': 'sunnah',
          },
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Safar',
          'ur': 'صفر',
          'hi': 'सफ़र',
          'ar': 'صفر',
        },
        'icon': 'wb_twilight',
        'color': '#00695C',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
          {
            'days': {
              'en': 'Any nafil fast',
              'ur': 'کوئی بھی نفل روزہ',
              'hi': 'कोई भी नफ्ल रोज़ा',
              'ar': 'أي صيام نافلة',
            },
            'desc': {
              'en': 'At your will',
              'ur': 'اپنی مرضی سے',
              'hi': 'अपनी मर्ज़ी से',
              'ar': 'حسب رغبتك',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Rabi ul-Awwal',
          'ur': 'ربیع الاول',
          'hi': 'रबी उल-अव्वल',
          'ar': 'ربيع الأول',
        },
        'icon': 'star',
        'color': '#2E7D32',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हر हف़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Rabi ul-Aakhir',
          'ur': 'ربیع الآخر',
          'hi': 'रबी उल-आख़िर',
          'ar': 'ربيع الآخر',
        },
        'icon': 'star_border',
        'color': '#1565C0',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Jumada ul-Ula',
          'ur': 'جمادی الاولیٰ',
          'hi': 'जुमादा उल-ऊला',
          'ar': 'جمادى الأولى',
        },
        'icon': 'brightness_5',
        'color': '#5E35B1',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Jumada ul-Aakhira',
          'ur': 'جمادی الآخرہ',
          'hi': 'जुमादा उल-आख़िरा',
          'ar': 'جمادى الآخرة',
        },
        'icon': 'brightness_6',
        'color': '#00838F',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ته',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Rajab',
          'ur': 'رجب',
          'hi': 'रजब',
          'ar': 'رجب',
        },
        'icon': 'auto_awesome',
        'color': '#7B1FA2',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवار',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ته',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
          {
            'days': {
              'en': 'Any nafil fast',
              'ur': 'کوئی بھی نفل روزہ',
              'hi': 'कोई भी नफ्ल रोज़ा',
              'ar': 'أي صيام نافلة',
            },
            'desc': {
              'en': 'Sacred month',
              'ur': 'مقدس مہینہ',
              'hi': 'पवित्र महीना',
              'ar': 'شهر مقدس',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Shaban',
          'ur': 'شعبان',
          'hi': 'शाबान',
          'ar': 'شعبان',
        },
        'icon': 'brightness_3',
        'color': '#303F9F',
        'fasting_days': [
          {
            'days': {
              'en': 'More fasts',
              'ur': 'زیادہ روزے',
              'hi': 'अधिक रोज़े',
              'ar': 'المزيد من الصيام',
            },
            'desc': {
              'en': 'Keep more in this month',
              'ur': 'اس مہینے میں زیادہ رکھیں',
              'hi': 'इस महीने में अधिक रखें',
              'ar': 'احتفظ بالمزيد في هذا الشهر',
            },
            'type': 'sunnah',
          },
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवار और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
          {
            'days': '29-30',
            'desc': {
              'en': 'Day of doubt - avoid it',
              'ur': 'شک کا دن - بچیں',
              'hi': 'शक का दिन - बचें',
              'ar': 'يوم الشك - تجنبه',
            },
            'type': 'prohibited',
          },
        ],
      },
      {
        'name': {
          'en': 'Ramadan',
          'ur': 'رمضان',
          'hi': 'रमज़ान',
          'ar': 'رمضان',
        },
        'icon': 'mosque',
        'color': '#C62828',
        'fasting_days': [
          {
            'days': '1 se 29/30',
            'desc': {
              'en': 'Compulsory Fasts - Full month',
              'ur': 'فرض روزے - پورا مہینہ',
              'hi': 'फ़र्ज़ रोज़े - पूरा महीना',
              'ar': 'صيام إلزامي - شهر كامل',
            },
            'type': 'farz',
          },
        ],
      },
      {
        'name': {
          'en': 'Shawwal',
          'ur': 'شوال',
          'hi': 'शव्वाल',
          'ar': 'شوال',
        },
        'icon': 'celebration',
        'color': '#EF6C00',
        'fasting_days': [
          {
            'days': '2-7',
            'desc': {
              'en': '6 Shawwal fasts',
              'ur': '6 شوال کے روزے',
              'hi': '6 शव्वाल के रोज़े',
              'ar': '6 صيام شوال',
            },
            'type': 'sunnah',
          },
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और गुरुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
          {
            'days': '1',
            'desc': {
              'en': 'Eid - Fasting PROHIBITED',
              'ur': 'عید - روزہ منع',
              'hi': 'ईद - रोज़ा मना',
              'ar': 'العيد - الصيام محظور',
            },
            'type': 'prohibited',
          },
        ],
      },
      {
        'name': {
          'en': 'Dhul-Qadah',
          'ur': 'ذوالقعدہ',
          'hi': 'ज़िल्क़ादा',
          'ar': 'ذو القعدة',
        },
        'icon': 'terrain',
        'color': '#4E342E',
        'fasting_days': [
          {
            'days': '13, 14, 15',
            'desc': {
              'en': 'Ayyam al-Beedh (White Days)',
              'ur': 'ایام البیض (سفید دن)',
              'hi': 'अय्याम अल-बीद (सफ़ेद दिन)',
              'ar': 'الأيام البيض',
            },
            'type': 'sunnah',
          },
          {
            'days': {
              'en': 'Monday & Thursday',
              'ur': 'پیر اور جمعرات',
              'hi': 'सोमवार और گुرुवार',
              'ar': 'الإثنين والخميس',
            },
            'desc': {
              'en': 'Every week',
              'ur': 'ہر ہفتے',
              'hi': 'हर हफ़्ते',
              'ar': 'كل أسبوع',
            },
            'type': 'nafil',
          },
        ],
      },
      {
        'name': {
          'en': 'Dhul-Hijjah',
          'ur': 'ذوالحجہ',
          'hi': 'ज़िल्हिज्जा',
          'ar': 'ذو الحجة',
        },
        'icon': 'landscape',
        'color': '#827717',
        'fasting_days': [
          {
            'days': '1-9',
            'desc': {
              'en': 'Up to Arafah (if not on Hajj)',
              'ur': 'عرفہ تک (اگر حج پر نہ ہو)',
              'hi': 'अरफा तक (अगर हज पर न हो)',
              'ar': 'حتى عرفة (إذا لم يكن في الحج)',
            },
            'type': 'sunnah',
          },
          {
            'days': '10',
            'desc': {
              'en': 'Eid-ul-Adha - PROHIBITED',
              'ur': 'عید الاضحیٰ - منع',
              'hi': 'ईद-उल-अज़हा - मना',
              'ar': 'عيد الأضحى - محظور',
            },
            'type': 'prohibited',
          },
          {
            'days': '11, 12, 13',
            'desc': {
              'en': 'Ayyam-e-Tashreeq - PROHIBITED',
              'ur': 'ایام تشریق - منع',
              'hi': 'अय्याम-ए-तशरीक़ - मना',
              'ar': 'أيام التشريق - محظور',
            },
            'type': 'prohibited',
          },
        ],
      },
    ],
    'prohibited_days': [
      {
        'en': '1 Shawwal (Eid-ul-Fitr)',
        'ur': '1 شوال (عید الفطر)',
        'hi': '1 शव्वाल (ईद-उल-फ़ित्र)',
        'ar': '1 شوال (عيد الفطر)',
      },
      {
        'en': '10 Dhul-Hijjah (Eid-ul-Adha)',
        'ur': '10 ذوالحجہ (عید الاضحیٰ)',
        'hi': '10 ज़ुलहिज्जा (ईद-उल-अज़हा)',
        'ar': '10 ذو الحجة (عيد الأضحى)',
      },
      {
        'en': '11, 12, 13 Dhul-Hijjah (Ayyam-e-Tashreeq)',
        'ur': '11، 12، 13 ذوالحجہ (ایام تشریق)',
        'hi': '11, 12, 13 ज़ुलहिज्जा (अय्याम-ए-तशरीक़)',
        'ar': '11، 12، 13 ذو الحجة (أيام التشريق)',
      },
    ],
    'quick_rules': [
      {
        'icon': 'calendar_month',
        'label': {
          'en': 'Every Month:',
          'ur': 'ہر مہینے:',
          'hi': 'हर महीने:',
          'ar': 'كل شهر:',
        },
        'value': {
          'en': '13, 14, 15 (Ayyam al-Beedh (White Days))',
          'ur': '13, 14, 15 (ایام البیض (سفید دن))',
          'hi': '13, 14, 15 (अय्याम अल-बीद (सफ़ेद दिन))',
          'ar': '13, 14, 15 (الأيام البيض)',
        },
        'color': '#4CAF50',
      },
      {
        'icon': 'repeat',
        'label': {
          'en': 'Every Week:',
          'ur': 'ہر ہفتے:',
          'hi': 'हर हफ़्ते:',
          'ar': 'كل أسبوع:',
        },
        'value': {
          'en': 'Monday & Thursday',
          'ur': 'پیر اور جمعرات',
          'hi': 'सोमवार और गुरुवार',
          'ar': 'الإثنين والخميس',
        },
        'color': '#2196F3',
      },
      {
        'icon': 'star',
        'label': {
          'en': 'Special:',
          'ur': 'خاص:',
          'hi': 'विशेष:',
          'ar': 'خاص:',
        },
        'value': {
          'en': 'Ashura Fasts, Day of Arafah, 6 Shawwal',
          'ur': 'عاشورہ کے روزے, یوم عرفہ, 6 شوال',
          'hi': 'आशूरा के रोज़े, अरफ़ात का दिन, 6 शव्वाल',
          'ar': 'صيام عاشوراء, يوم عرفة, 6 شوال',
        },
        'color': '#9C27B0',
      },
      {
        'icon': 'mosque',
        'label': {
          'en': 'Compulsory:',
          'ur': 'فرض:',
          'hi': 'फ़र्ज़:',
          'ar': 'إلزامي:',
        },
        'value': {
          'en': 'Full month of Ramadan',
          'ur': 'رمضان کا پورا مہینہ',
          'hi': 'रमज़ान का पूरा महीना',
          'ar': 'شهر رمضان الكامل',
        },
        'color': '#F44336',
      },
      {
        'icon': 'block',
        'label': {
          'en': 'Forbidden:',
          'ur': 'منع:',
          'hi': 'मना:',
          'ar': 'محظور:',
        },
        'value': {
          'en': 'Only on Eid days',
          'ur': 'صرف عید کے دن',
          'hi': 'सिर्फ़ ईद के दिन',
          'ar': 'فقط أيام العيد',
        },
        'color': '#9E9E9E',
      },
    ],
    'section_labels': {
      'fasting_options': {
        'en': 'Fasting options',
        'ur': 'روزہ اختیارات',
        'hi': 'रोज़ा विकल्प',
        'ar': 'خيارات الصيام',
      },
      'fasting_prohibited': {
        'en': 'Fasting PROHIBITED',
        'ur': 'روزہ منع',
        'hi': 'रोज़ा मना',
        'ar': 'الصيام محظور',
      },
      'quick_rules_remember': {
        'en': 'Quick Rules - Remember',
        'ur': 'فوری قواعد - یاد رکھیں',
        'hi': 'त्वरित नियम - याद रखें',
        'ar': 'قواعد سريعة - تذكر',
      },
      'farz': {
        'en': 'Farz',
        'ur': 'فرض',
        'hi': 'फ़र्ज़',
        'ar': 'فرض',
      },
      'sunnah': {
        'en': 'Sunnah',
        'ur': 'سنت',
        'hi': 'सुन्नत',
        'ar': 'سنة',
      },
      'nafil': {
        'en': 'Nafil',
        'ur': 'نفل',
        'hi': 'नफ़्ल',
        'ar': 'نافلة',
      },
      'mana': {
        'en': 'Prohibited',
        'ur': 'منع',
        'hi': 'मना',
        'ar': 'محظور',
      },
    },
  };
