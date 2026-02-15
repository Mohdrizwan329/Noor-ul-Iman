import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/firestore_models.dart';
import '../../data/models/dua_model.dart';
import '../../data/models/allah_name_model.dart';

/// Central service for fetching and caching all Firestore content
class ContentService {
  static final ContentService _instance = ContentService._internal();
  factory ContentService() => _instance;
  ContentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache keys
  static const String _versionsCacheKey = 'content_versions';
  static const String _duasCacheKey = 'duas_cache';
  static const String _allahNamesCacheKey = 'allah_names_cache';
  static const String _kalmasCacheKey = 'kalmas_cache';
  static const String _islamicNamesCacheKey = 'islamic_names_cache';
  static const String _hadithCacheKey = 'hadith_cache';
  static const String _tasbihCacheKey = 'tasbih_cache';
  static const String _basicAmalCacheKey = 'basic_amal_cache';
  static const String _greetingCardsCacheKey = 'greeting_cards_cache';
  static const String _sampleHadithCacheKey = 'sample_hadith_cache';
  static const String _hajjGuideCacheKey = 'hajj_guide_cache';
  static const String _ramadanDuasCacheKey = 'ramadan_duas_cache';
  static const String _zakatGuideCacheKey = 'zakat_guide_cache';
  static const String _quranMetadataCacheKey = 'quran_metadata_cache';
  static const String _fastingDataCacheKey = 'fasting_data_cache';
  static const String _settingsTranslationsCacheKey =
      'settings_translations_cache';
  static const String _notificationStringsCacheKey =
      'notification_strings_cache';
  static const String _calendarStringsCacheKey = 'calendar_strings_cache';
  static const String _nameTransliterationsCacheKey =
      'name_transliterations_cache';
  static const String _hadithTranslationsCacheKey = 'hadith_translations_cache';
  static const String _languageNamesCacheKey = 'language_names_cache';
  static const String _qiblaContentCacheKey = 'qibla_content_cache';
  static const String _tasbihScreenContentCacheKey =
      'tasbih_screen_content_cache';
  static const String _calendarScreenContentCacheKey =
      'calendar_screen_content_cache';
  static const String _zakatCalculatorContentCacheKey =
      'zakat_calculator_content_cache';
  static const String _zakatGuideScreenContentCacheKey =
      'zakat_guide_screen_content_cache';
  static const String _quranScreenContentCacheKey =
      'quran_screen_content_cache';
  static const String _quranSurahCachePrefix = 'quran_surah_cache_';
  static const String _prayerTimesScreenContentCacheKey =
      'prayer_times_screen_content_cache';
  static const String _notificationsScreenContentCacheKey =
      'notifications_screen_content_cache';
  static const String _settingsScreenContentCacheKey =
      'settings_screen_content_cache';
  static const String _aboutScreenContentCacheKey =
      'about_screen_content_cache';
  static const String _privacyPolicyScreenContentCacheKey =
      'privacy_policy_screen_content_cache';
  static const String _uiTranslationsCacheKey = 'ui_translations_cache';
  static const String _homeScreenContentCacheKey =
      'home_screen_content_cache';

  // Hive box for content caching
  Box<String>? _contentBox;
  bool _isInitialized = false;

  // In-memory cache
  ContentVersions? _cachedVersions;
  List<DuaCategoryFirestore>? _cachedDuas;
  List<AllahNameFirestore>? _cachedAllahNames;
  List<KalmaFirestore>? _cachedKalmas;
  Map<String, List<IslamicNameFirestore>>? _cachedIslamicNames;
  Map<String, HadithCollectionFirestore>? _cachedHadith;
  List<DhikrItemFirestore>? _cachedTasbih;
  Map<String, BasicAmalGuideFirestore>? _cachedBasicAmal;
  List<IslamicMonthFirestore>? _cachedGreetingCards;
  Map<String, List<SampleHadithFirestore>>? _cachedSampleHadith;
  Map<String, List<HajjStepFirestore>>? _cachedHajjGuide;
  List<RamadanDuaFirestore>? _cachedRamadanDuas;
  List<ZakatSectionFirestore>? _cachedZakatGuide;
  Map<String, List<QuranNameEntryFirestore>>? _cachedQuranMetadata;
  Map<String, HadithCollectionInfoFirestore>? _cachedHadithInfo;
  List<FastingDuaFirestore>? _cachedFastingDuas;
  Map<String, Map<String, Map<String, String>>>? _cachedSettingsTranslations;
  Map<String, Map<String, dynamic>>? _cachedNotificationStrings;
  Map<String, dynamic>? _cachedCalendarStrings;
  Map<String, Map<String, Map<String, String>>>? _cachedNameTransliterations;
  Map<String, dynamic>? _cachedHadithTranslations;
  Map<String, dynamic>? _cachedLanguageNames;
  QiblaContentFirestore? _cachedQiblaContent;
  PrayerTimesScreenContentFirestore? _cachedPrayerTimesScreenContent;
  NotificationsScreenContentFirestore? _cachedNotificationsScreenContent;
  SettingsScreenContentFirestore? _cachedSettingsScreenContent;
  TasbihScreenContentFirestore? _cachedTasbihScreenContent;
  CalendarScreenContentFirestore? _cachedCalendarScreenContent;
  ZakatCalculatorContentFirestore? _cachedZakatCalculatorContent;
  ZakatGuideContentFirestore? _cachedZakatGuideScreenContent;
  QuranScreenContentFirestore? _cachedQuranScreenContent;
  Map<int, SurahContentFirestore>? _cachedSurahContent;
  AboutScreenContentFirestore? _cachedAboutScreenContent;
  PrivacyPolicyScreenContentFirestore? _cachedPrivacyPolicyScreenContent;
  UITranslationsFirestore? _cachedUITranslations;
  FastingTimesContentFirestore? _cachedFastingTimesContent;
  HomeScreenContentFirestore? _cachedHomeScreenContent;

  // Cache key for fasting times content
  static const String _fastingTimesContentCacheKey =
      'fasting_times_content_cache';

  /// Initialize the service and Hive box
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _contentBox = await Hive.openBox<String>('content_cache');
      await _loadCachedVersions();
      _isInitialized = true;
      debugPrint('ContentService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing ContentService: $e');
    }
  }

  /// Ensure service is initialized before use
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Load cached versions from local storage
  Future<void> _loadCachedVersions() async {
    try {
      final cached = _contentBox?.get(_versionsCacheKey);
      if (cached != null) {
        _cachedVersions = ContentVersions.fromJson(jsonDecode(cached));
      }
    } catch (e) {
      debugPrint('Error loading cached versions: $e');
    }
  }

  /// Check if content needs update by comparing versions
  Future<bool> _needsUpdate(String contentType, int cachedVersion) async {
    try {
      final doc = await _firestore
          .collection('content_metadata')
          .doc('versions')
          .get(const GetOptions(source: Source.server));

      if (!doc.exists) return true;

      final serverVersions = ContentVersions.fromJson(doc.data()!);
      _cachedVersions = serverVersions;

      // Save to local cache (use toJson() to convert Timestamp to ISO string)
      await _contentBox?.put(_versionsCacheKey, jsonEncode(serverVersions.toJson()));

      return serverVersions.getVersionFor(contentType) > cachedVersion;
    } catch (e) {
      debugPrint('Error checking version for $contentType: $e');
      return false; // Use cache on error
    }
  }

  /// Generic fetch with caching pattern
  Future<T> _fetchWithCache<T>({
    required String cacheKey,
    required String contentType,
    required Future<T> Function() fetchFromFirestore,
    required T Function(String) fromCache,
    required String Function(T) toCache,
    required T fallback,
  }) async {
    await _ensureInitialized();

    // Try to get cached data first
    final cachedData = _contentBox?.get(cacheKey);
    final cachedVersion = _cachedVersions?.getVersionFor(contentType) ?? 0;

    // Check if we need to update
    final needsUpdate = await _needsUpdate(contentType, cachedVersion);

    if (!needsUpdate &&
        cachedData != null &&
        cachedData != '{}' &&
        cachedData != '[]') {
      debugPrint('Using cached $contentType');
      try {
        return fromCache(cachedData);
      } catch (e) {
        debugPrint('Error parsing cached $contentType: $e');
      }
    }

    try {
      // Fetch from Firestore
      debugPrint('Fetching $contentType from Firestore');
      final data = await fetchFromFirestore();

      // Only cache non-null/non-fallback data
      if (data != null && data != fallback) {
        await _contentBox?.put(cacheKey, toCache(data));
      }

      return data;
    } catch (e) {
      debugPrint('Error fetching $contentType: $e');

      // Return cached data if available, otherwise fallback
      if (cachedData != null && cachedData != '{}' && cachedData != '[]') {
        try {
          return fromCache(cachedData);
        } catch (_) {}
      }
      return fallback;
    }
  }

  /// Load content from local JSON asset file as fallback when Firestore has no data
  Future<T?> _loadFromAssetFallback<T>({
    required String assetPath,
    required T Function(Map<String, dynamic>) fromJson,
    required String cacheKey,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final content = fromJson(jsonData);
      await _contentBox?.put(cacheKey, jsonString);
      debugPrint('Loaded $assetPath from local asset fallback');
      return content;
    } catch (e) {
      debugPrint('Error loading from asset $assetPath: $e');
      return null;
    }
  }

  // ==================== DUAS ====================

  /// Fetch all dua categories with their duas
  Future<List<DuaCategoryFirestore>> getDuaCategories() async {
    if (_cachedDuas != null) return _cachedDuas!;

    final result = await _fetchWithCache<List<DuaCategoryFirestore>>(
      cacheKey: _duasCacheKey,
      contentType: 'duas',
      fetchFromFirestore: () async {
        final snapshot = await _firestore
            .collection('duas')
            .orderBy('order')
            .get();

        return snapshot.docs
            .map((doc) => DuaCategoryFirestore.fromFirestore(doc))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map(
              (d) => DuaCategoryFirestore.fromJson(d as Map<String, dynamic>),
            )
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((d) => d.toJson()).toList()),
      fallback: [],
    );

    if (result.isNotEmpty) {
      _cachedDuas = result;
      return result;
    }

    // Fallback to local asset JSON
    try {
      final jsonString = await rootBundle.loadString('assets/data/firebase/duas.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final categories = (jsonData['categories'] as List<dynamic>? ?? [])
          .map((d) => DuaCategoryFirestore.fromJson(d as Map<String, dynamic>))
          .toList();
      if (categories.isNotEmpty) {
        _cachedDuas = categories;
        await _contentBox?.put(_duasCacheKey, jsonEncode(categories.map((d) => d.toJson()).toList()));
        debugPrint('Loaded duas from local asset fallback');
        return categories;
      }
    } catch (e) {
      debugPrint('Error loading duas from asset fallback: $e');
    }

    _cachedDuas = result;
    return result;
  }

  /// Get dua categories as legacy DuaCategory objects
  Future<List<DuaCategory>> getDuaCategoriesLegacy() async {
    final categories = await getDuaCategories();
    return categories.map((c) => c.toDuaCategory()).toList();
  }

  /// Get duas for a specific category
  Future<DuaCategoryFirestore?> getDuaCategory(String categoryId) async {
    final categories = await getDuaCategories();
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // ==================== ALLAH NAMES ====================

  /// Fetch all 99 names of Allah
  Future<List<AllahNameFirestore>> getAllahNames() async {
    if (_cachedAllahNames != null) return _cachedAllahNames!;

    final result = await _fetchWithCache<List<AllahNameFirestore>>(
      cacheKey: _allahNamesCacheKey,
      contentType: 'allah_names',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('allah_names')
            .doc('all_names')
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['names'] as List<dynamic>? ?? [])
            .map((n) => AllahNameFirestore.fromJson(n as Map<String, dynamic>))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map((d) => AllahNameFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((n) => n.toJson()).toList()),
      fallback: [],
    );

    _cachedAllahNames = result;
    return result;
  }

  /// Get Allah names as legacy AllahNameModel objects
  Future<List<AllahNameModel>> getAllahNamesLegacy() async {
    final names = await getAllahNames();
    if (names.isEmpty) {
      // Fallback to local asset JSON
      try {
        final jsonString = await rootBundle.loadString(
          'assets/data/firebase/allah_names.json',
        );
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final namesList = (jsonData['names'] as List<dynamic>? ?? [])
            .map((n) => AllahNameFirestore.fromJson(n as Map<String, dynamic>))
            .toList();
        _cachedAllahNames = namesList;
        await _contentBox?.put(
          _allahNamesCacheKey,
          jsonEncode(namesList.map((n) => n.toJson()).toList()),
        );
        debugPrint('Loaded allah_names from local asset fallback');
        return namesList.map((n) => n.toAllahNameModel()).toList();
      } catch (e) {
        debugPrint('Error loading allah_names from asset: $e');
        return [];
      }
    }
    return names.map((n) => n.toAllahNameModel()).toList();
  }

  // ==================== KALMAS ====================

  /// Fetch all seven kalmas
  Future<List<KalmaFirestore>> getKalmas() async {
    if (_cachedKalmas != null) return _cachedKalmas!;

    final result = await _fetchWithCache<List<KalmaFirestore>>(
      cacheKey: _kalmasCacheKey,
      contentType: 'kalmas',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('kalmas')
            .doc('seven_kalmas')
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['kalmas'] as List<dynamic>? ?? [])
            .map((k) => KalmaFirestore.fromJson(k as Map<String, dynamic>))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map((k) => KalmaFirestore.fromJson(k as Map<String, dynamic>))
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((k) => k.toJson()).toList()),
      fallback: [],
    );

    if (result.isNotEmpty) {
      _cachedKalmas = result;
      return result;
    }

    // Fallback to local asset JSON
    try {
      final jsonString = await rootBundle.loadString('assets/data/firebase/kalmas.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final kalmas = (jsonData['kalmas'] as List<dynamic>? ?? [])
          .map((k) => KalmaFirestore.fromJson(k as Map<String, dynamic>))
          .toList();
      if (kalmas.isNotEmpty) {
        _cachedKalmas = kalmas;
        await _contentBox?.put(_kalmasCacheKey, jsonEncode(kalmas.map((k) => k.toJson()).toList()));
        debugPrint('Loaded kalmas from local asset fallback');
        return kalmas;
      }
    } catch (e) {
      debugPrint('Error loading kalmas from asset fallback: $e');
    }

    _cachedKalmas = result;
    return result;
  }

  // ==================== ISLAMIC NAMES ====================

  /// Fetch Islamic names by category (prophets, sahaba, imams, etc.)
  Future<List<IslamicNameFirestore>> getIslamicNames(String category) async {
    _cachedIslamicNames ??= {};

    if (_cachedIslamicNames!.containsKey(category)) {
      return _cachedIslamicNames![category]!;
    }

    final cacheKey = '${_islamicNamesCacheKey}_$category';

    final result = await _fetchWithCache<List<IslamicNameFirestore>>(
      cacheKey: cacheKey,
      contentType: 'islamic_names',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('islamic_names')
            .doc(category)
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['names'] as List<dynamic>? ?? [])
            .map(
              (n) => IslamicNameFirestore.fromJson(n as Map<String, dynamic>),
            )
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map(
              (n) => IslamicNameFirestore.fromJson(n as Map<String, dynamic>),
            )
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((n) => n.toJson()).toList()),
      fallback: [],
    );

    _cachedIslamicNames![category] = result;
    return result;
  }

  // ==================== HADITH ====================

  /// Fetch hadith collection by ID (bukhari, muslim, tirmidhi, etc.)
  Future<HadithCollectionFirestore?> getHadithCollection(
    String collectionId,
  ) async {
    _cachedHadith ??= {};

    if (_cachedHadith!.containsKey(collectionId)) {
      return _cachedHadith![collectionId];
    }

    final cacheKey = '${_hadithCacheKey}_$collectionId';

    final result = await _fetchWithCache<HadithCollectionFirestore?>(
      cacheKey: cacheKey,
      contentType: 'hadith',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('hadith_collections')
            .doc(collectionId)
            .get();

        if (!doc.exists) return null;

        return HadithCollectionFirestore.fromFirestore(doc);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached);
        return HadithCollectionFirestore.fromJson(
          decoded as Map<String, dynamic>,
        );
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result != null) {
      _cachedHadith![collectionId] = result;
      return result;
    }

    // Fallback to local asset file
    final assetMap = {
      'bukhari': 'sahih_bukhari_books.json',
      'muslim': 'sahih_muslim_books.json',
      'tirmidhi': 'jami_tirmidhi_books.json',
      'abudawud': 'sunan_abu_dawud_books.json',
      'nasai': 'sunan_nasai_books.json',
    };
    final assetFile = assetMap[collectionId];
    if (assetFile != null) {
      final fallback = await _loadFromAssetFallback<HadithCollectionFirestore>(
        assetPath: 'assets/data/firebase/$assetFile',
        fromJson: HadithCollectionFirestore.fromJson,
        cacheKey: cacheKey,
      );
      if (fallback != null) {
        _cachedHadith![collectionId] = fallback;
      }
      return fallback;
    }

    return null;
  }

  /// Fetch hadith collections info (metadata with 4-language support)
  Future<Map<String, HadithCollectionInfoFirestore>>
  getHadithCollectionsInfo() async {
    if (_cachedHadithInfo != null) return _cachedHadithInfo!;

    final result =
        await _fetchWithCache<Map<String, HadithCollectionInfoFirestore>>(
          cacheKey: 'hadith_collections_info_cache',
          contentType: 'hadith_info',
          fetchFromFirestore: () async {
            final doc = await _firestore
                .collection('hadith_collections_info')
                .doc('all')
                .get();

            if (!doc.exists) return {};

            final data = doc.data() ?? {};
            final collections =
                data['collections'] as Map<String, dynamic>? ?? {};
            return {
              for (final entry in collections.entries)
                entry.key: HadithCollectionInfoFirestore.fromJson(
                  entry.value as Map<String, dynamic>,
                ),
            };
          },
          fromCache: (cached) {
            final decoded = jsonDecode(cached) as Map<String, dynamic>;
            final collections =
                decoded['collections'] as Map<String, dynamic>? ?? decoded;
            return {
              for (final entry in collections.entries)
                entry.key: HadithCollectionInfoFirestore.fromJson(
                  entry.value as Map<String, dynamic>,
                ),
            };
          },
          toCache: (data) => jsonEncode({
            'collections': {
              for (final entry in data.entries) entry.key: entry.value.toJson(),
            },
          }),
          fallback: {},
        );

    if (result.isEmpty) {
      try {
        final jsonString = await rootBundle.loadString(
          'assets/data/firebase/hadith_collections_info.json',
        );
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final collections =
            jsonData['collections'] as Map<String, dynamic>? ?? {};
        final fallback = {
          for (final entry in collections.entries)
            entry.key: HadithCollectionInfoFirestore.fromJson(
              entry.value as Map<String, dynamic>,
            ),
        };
        _cachedHadithInfo = fallback;
        await _contentBox?.put('hadith_collections_info_cache', jsonString);
        debugPrint('Loaded hadith_collections_info from local asset fallback');
        return fallback;
      } catch (e) {
        debugPrint('Error loading hadith_collections_info from asset: $e');
      }
    }

    _cachedHadithInfo = result;
    return result;
  }

  // ==================== TASBIH ====================

  /// Fetch tasbih dhikr items
  Future<List<DhikrItemFirestore>> getTasbihDhikr() async {
    if (_cachedTasbih != null) return _cachedTasbih!;

    final result = await _fetchWithCache<List<DhikrItemFirestore>>(
      cacheKey: _tasbihCacheKey,
      contentType: 'tasbih',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('tasbih_dhikr')
            .doc('all_dhikr')
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['items'] as List<dynamic>? ?? [])
            .map((d) => DhikrItemFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map((d) => DhikrItemFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((d) => d.toJson()).toList()),
      fallback: [],
    );

    _cachedTasbih = result;
    return result;
  }

  // ==================== BASIC AMAL ====================

  /// Fetch basic amal guide by type (wazu, ghusl, namaz, etc.)
  Future<BasicAmalGuideFirestore?> getBasicAmalGuide(String guideType) async {
    _cachedBasicAmal ??= {};

    if (_cachedBasicAmal!.containsKey(guideType)) {
      return _cachedBasicAmal![guideType];
    }

    final cacheKey = '${_basicAmalCacheKey}_$guideType';

    final result = await _fetchWithCache<BasicAmalGuideFirestore?>(
      cacheKey: cacheKey,
      contentType: 'basic_amal',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('basic_amal')
            .doc(guideType)
            .get();

        if (!doc.exists) return null;

        return BasicAmalGuideFirestore.fromFirestore(doc);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached);
        return BasicAmalGuideFirestore.fromJson(
          decoded as Map<String, dynamic>,
        );
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result != null) {
      _cachedBasicAmal![guideType] = result;
      return result;
    }

    // Fallback to local asset JSON
    final assetMap = {
      'namaz_guide': 'namaz_guide.json',
      'namaz_fazilat': 'namaz_fazilat.json',
    };
    final assetFile = assetMap[guideType];
    if (assetFile != null) {
      final fallback = await _loadFromAssetFallback<BasicAmalGuideFirestore>(
        assetPath: 'assets/data/firebase/$assetFile',
        fromJson: BasicAmalGuideFirestore.fromJson,
        cacheKey: cacheKey,
      );
      if (fallback != null) {
        _cachedBasicAmal![guideType] = fallback;
        return fallback;
      }
    }

    return null;
  }

  // ==================== GREETING CARDS ====================

  /// Fetch all Islamic months with greeting cards
  Future<List<IslamicMonthFirestore>> getIslamicMonths() async {
    if (_cachedGreetingCards != null) return _cachedGreetingCards!;

    final result = await _fetchWithCache<List<IslamicMonthFirestore>>(
      cacheKey: _greetingCardsCacheKey,
      contentType: 'greeting_cards',
      fetchFromFirestore: () async {
        final snapshot = await _firestore
            .collection('greeting_cards')
            .orderBy('number')
            .get();

        return snapshot.docs
            .map((doc) => IslamicMonthFirestore.fromFirestore(doc))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map(
              (m) => IslamicMonthFirestore.fromJson(m as Map<String, dynamic>),
            )
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((m) => m.toJson()).toList()),
      fallback: [],
    );

    _cachedGreetingCards = result;
    return result;
  }

  // ==================== SAMPLE HADITHS ====================

  /// Fetch sample hadiths by collection (bukhari, muslim, abudawud, tirmidhi)
  Future<List<SampleHadithFirestore>> getSampleHadiths(
    String collection,
  ) async {
    _cachedSampleHadith ??= {};

    if (_cachedSampleHadith!.containsKey(collection)) {
      return _cachedSampleHadith![collection]!;
    }

    final cacheKey = '${_sampleHadithCacheKey}_$collection';

    final result = await _fetchWithCache<List<SampleHadithFirestore>>(
      cacheKey: cacheKey,
      contentType: 'sample_hadith',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('sample_hadiths')
            .doc(collection)
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['hadiths'] as List<dynamic>? ?? [])
            .map(
              (h) => SampleHadithFirestore.fromJson(h as Map<String, dynamic>),
            )
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map(
              (h) => SampleHadithFirestore.fromJson(h as Map<String, dynamic>),
            )
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((h) => h.toJson()).toList()),
      fallback: [],
    );

    _cachedSampleHadith![collection] = result;
    return result;
  }

  // ==================== HAJJ GUIDE ====================

  /// Fetch hajj guide by type (hajj or umrah)
  Future<List<HajjStepFirestore>> getHajjGuide(String type) async {
    _cachedHajjGuide ??= {};

    if (_cachedHajjGuide!.containsKey(type)) {
      return _cachedHajjGuide![type]!;
    }

    final cacheKey = '${_hajjGuideCacheKey}_$type';

    final result = await _fetchWithCache<List<HajjStepFirestore>>(
      cacheKey: cacheKey,
      contentType: 'hajj_guide',
      fetchFromFirestore: () async {
        final doc = await _firestore.collection('hajj_guide').doc(type).get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['steps'] as List<dynamic>? ?? [])
            .map((s) => HajjStepFirestore.fromJson(s as Map<String, dynamic>))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map((s) => HajjStepFirestore.fromJson(s as Map<String, dynamic>))
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((s) => s.toJson()).toList()),
      fallback: [],
    );

    _cachedHajjGuide![type] = result;
    return result;
  }

  // ==================== RAMADAN DUAS ====================

  /// Fetch Ramadan duas
  Future<List<RamadanDuaFirestore>> getRamadanDuas() async {
    if (_cachedRamadanDuas != null) return _cachedRamadanDuas!;

    final result = await _fetchWithCache<List<RamadanDuaFirestore>>(
      cacheKey: _ramadanDuasCacheKey,
      contentType: 'ramadan_duas',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('ramadan_duas')
            .doc('all_duas')
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['duas'] as List<dynamic>? ?? [])
            .map((d) => RamadanDuaFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map((d) => RamadanDuaFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((d) => d.toJson()).toList()),
      fallback: [],
    );

    _cachedRamadanDuas = result;
    return result;
  }

  // ==================== ZAKAT GUIDE ====================

  /// Fetch Zakat guide sections
  Future<List<ZakatSectionFirestore>> getZakatGuide() async {
    if (_cachedZakatGuide != null) return _cachedZakatGuide!;

    final result = await _fetchWithCache<List<ZakatSectionFirestore>>(
      cacheKey: _zakatGuideCacheKey,
      contentType: 'zakat_guide',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('zakat_guide')
            .doc('all_sections')
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['sections'] as List<dynamic>? ?? [])
            .map(
              (s) => ZakatSectionFirestore.fromJson(s as Map<String, dynamic>),
            )
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map(
              (s) => ZakatSectionFirestore.fromJson(s as Map<String, dynamic>),
            )
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((s) => s.toJson()).toList()),
      fallback: [],
    );

    _cachedZakatGuide = result;
    return result;
  }

  // ==================== QURAN METADATA ====================

  /// Fetch quran name entries (surah or para names) by type
  Future<List<QuranNameEntryFirestore>> getQuranNames(String type) async {
    _cachedQuranMetadata ??= {};

    if (_cachedQuranMetadata!.containsKey(type)) {
      return _cachedQuranMetadata![type]!;
    }

    final cacheKey = '${_quranMetadataCacheKey}_$type';

    final result = await _fetchWithCache<List<QuranNameEntryFirestore>>(
      cacheKey: cacheKey,
      contentType: 'quran_metadata',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('quran_metadata')
            .doc(type)
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['names'] as List<dynamic>? ?? [])
            .map(
              (n) =>
                  QuranNameEntryFirestore.fromJson(n as Map<String, dynamic>),
            )
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map(
              (n) =>
                  QuranNameEntryFirestore.fromJson(n as Map<String, dynamic>),
            )
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((n) => n.toJson()).toList()),
      fallback: [],
    );

    _cachedQuranMetadata![type] = result;
    return result;
  }

  // ==================== FASTING TIMES CONTENT ====================

  /// Fetch fasting times screen content (all data: duas, virtues, rules, months in 4 languages)
  Future<FastingTimesContentFirestore?> getFastingTimesContent() async {
    if (_cachedFastingTimesContent != null) return _cachedFastingTimesContent;

    final result = await _fetchWithCache<FastingTimesContentFirestore?>(
      cacheKey: _fastingTimesContentCacheKey,
      contentType: 'fasting_times_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('fasting_times_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return FastingTimesContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return FastingTimesContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<FastingTimesContentFirestore>(
        assetPath: 'assets/data/firebase/fasting_times_content.json',
        fromJson: FastingTimesContentFirestore.fromJson,
        cacheKey: _fastingTimesContentCacheKey,
      );
      _cachedFastingTimesContent = fallback;
      return fallback;
    }

    _cachedFastingTimesContent = result;
    return result;
  }

  // ==================== FASTING DATA ====================

  /// Fetch fasting duas
  Future<List<FastingDuaFirestore>> getFastingDuas() async {
    if (_cachedFastingDuas != null) return _cachedFastingDuas!;

    final result = await _fetchWithCache<List<FastingDuaFirestore>>(
      cacheKey: _fastingDataCacheKey,
      contentType: 'fasting_data',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('fasting_data')
            .doc('fasting_duas')
            .get();

        if (!doc.exists) return [];

        final data = doc.data()!;
        return (data['duas'] as List<dynamic>? ?? [])
            .map((d) => FastingDuaFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      fromCache: (cached) {
        final List<dynamic> decoded = jsonDecode(cached);
        return decoded
            .map((d) => FastingDuaFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
      },
      toCache: (data) => jsonEncode(data.map((d) => d.toJson()).toList()),
      fallback: [],
    );

    _cachedFastingDuas = result;
    return result;
  }

  // ==================== SETTINGS TRANSLATIONS ====================

  /// Fetch settings translations (city, country, or name translations) by type
  Future<Map<String, Map<String, String>>> getSettingsTranslations(
    String type,
  ) async {
    _cachedSettingsTranslations ??= {};

    if (_cachedSettingsTranslations!.containsKey(type)) {
      return _cachedSettingsTranslations![type]!;
    }

    final cacheKey = '${_settingsTranslationsCacheKey}_$type';

    final result = await _fetchWithCache<Map<String, Map<String, String>>>(
      cacheKey: cacheKey,
      contentType: 'settings_translations',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('settings_translations')
            .doc(type)
            .get();

        if (!doc.exists) return {};

        final data = doc.data()!;
        final translations =
            data['translations'] as Map<String, dynamic>? ?? {};
        return translations.map(
          (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
        );
      },
      fromCache: (cached) {
        final Map<String, dynamic> decoded = jsonDecode(cached);
        return decoded.map(
          (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
        );
      },
      toCache: (data) => jsonEncode(data),
      fallback: {},
    );

    _cachedSettingsTranslations![type] = result;
    return result;
  }

  // ==================== NOTIFICATION STRINGS ====================

  /// Fetch notification strings (prayer or reminder) by type
  Future<Map<String, dynamic>> getNotificationStrings(String type) async {
    _cachedNotificationStrings ??= {};

    if (_cachedNotificationStrings!.containsKey(type)) {
      return _cachedNotificationStrings![type]!;
    }

    final cacheKey = '${_notificationStringsCacheKey}_$type';

    final result = await _fetchWithCache<Map<String, dynamic>>(
      cacheKey: cacheKey,
      contentType: 'notification_strings',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('notification_strings')
            .doc(type)
            .get();

        if (!doc.exists) return {};
        return doc.data()!;
      },
      fromCache: (cached) => jsonDecode(cached) as Map<String, dynamic>,
      toCache: (data) => jsonEncode(data),
      fallback: {},
    );

    _cachedNotificationStrings![type] = result;
    return result;
  }

  // ==================== CALENDAR STRINGS ====================

  /// Fetch calendar strings (islamic months, days, gregorian months)
  Future<Map<String, dynamic>> getCalendarStrings() async {
    if (_cachedCalendarStrings != null) return _cachedCalendarStrings!;

    final result = await _fetchWithCache<Map<String, dynamic>>(
      cacheKey: _calendarStringsCacheKey,
      contentType: 'calendar_strings',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('calendar_strings')
            .doc('all_strings')
            .get();

        if (!doc.exists) return {};
        return doc.data()!;
      },
      fromCache: (cached) => jsonDecode(cached) as Map<String, dynamic>,
      toCache: (data) => jsonEncode(data),
      fallback: {},
    );

    _cachedCalendarStrings = result;
    return result;
  }

  // ==================== NAME TRANSLITERATIONS ====================

  /// Fetch name transliterations by type (allah_names, surah_names, islamic_names, biographical)
  Future<Map<String, Map<String, String>>> getNameTransliterations(
    String type,
  ) async {
    _cachedNameTransliterations ??= {};

    if (_cachedNameTransliterations!.containsKey(type)) {
      return _cachedNameTransliterations![type]!;
    }

    final cacheKey = '${_nameTransliterationsCacheKey}_$type';

    final result = await _fetchWithCache<Map<String, Map<String, String>>>(
      cacheKey: cacheKey,
      contentType: 'name_transliterations',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('name_transliterations')
            .doc(type)
            .get();

        if (!doc.exists) return {};

        final data = doc.data()!;
        final result = <String, Map<String, String>>{};
        for (final lang in ['hindi', 'urdu']) {
          if (data[lang] is Map) {
            result[lang] = Map<String, String>.from(data[lang] as Map);
          }
        }
        return result;
      },
      fromCache: (cached) {
        final Map<String, dynamic> decoded = jsonDecode(cached);
        final result = <String, Map<String, String>>{};
        for (final lang in ['hindi', 'urdu']) {
          if (decoded[lang] is Map) {
            result[lang] = Map<String, String>.from(decoded[lang] as Map);
          }
        }
        return result;
      },
      toCache: (data) => jsonEncode(data),
      fallback: {},
    );

    if (result.isEmpty) {
      // Fallback to local asset JSON
      final assetMap = {
        'allah_names': 'allah_names_transliterations.json',
        'surah_names': 'surah_names_transliterations.json',
        'islamic_names': 'islamic_names_transliterations.json',
        'biographical': 'biographical_transliterations.json',
      };
      final assetFile = assetMap[type];
      if (assetFile != null) {
        try {
          final jsonString = await rootBundle.loadString(
            'assets/data/firebase/$assetFile',
          );
          final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
          final fallback = <String, Map<String, String>>{};
          for (final lang in ['hindi', 'urdu']) {
            if (decoded[lang] is Map) {
              fallback[lang] = Map<String, String>.from(decoded[lang] as Map);
            }
          }
          if (fallback.isNotEmpty) {
            _cachedNameTransliterations![type] = fallback;
            await _contentBox?.put(cacheKey, jsonString);
            debugPrint('Loaded $type transliterations from local asset fallback');
            return fallback;
          }
        } catch (e) {
          debugPrint('Error loading $type transliterations from asset: $e');
        }
      }
    }

    _cachedNameTransliterations![type] = result;
    return result;
  }

  // ==================== HADITH TRANSLATIONS ====================

  /// Fetch hadith translations (narrator prefixes, grades, book names, reference terms)
  Future<Map<String, dynamic>> getHadithTranslations() async {
    if (_cachedHadithTranslations != null) return _cachedHadithTranslations!;

    final result = await _fetchWithCache<Map<String, dynamic>>(
      cacheKey: _hadithTranslationsCacheKey,
      contentType: 'hadith_translations',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('hadith_translations')
            .doc('translations')
            .get();

        if (!doc.exists) return {};
        return doc.data()!;
      },
      fromCache: (cached) => jsonDecode(cached) as Map<String, dynamic>,
      toCache: (data) => jsonEncode(data),
      fallback: {},
    );

    _cachedHadithTranslations = result;
    return result;
  }

  // ==================== LANGUAGE NAMES ====================

  /// Fetch language name translations
  Future<Map<String, dynamic>> getLanguageNames() async {
    if (_cachedLanguageNames != null) return _cachedLanguageNames!;

    final result = await _fetchWithCache<Map<String, dynamic>>(
      cacheKey: _languageNamesCacheKey,
      contentType: 'language_names',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('language_names')
            .doc('names')
            .get();

        if (!doc.exists) return {};
        return doc.data()!;
      },
      fromCache: (cached) => jsonDecode(cached) as Map<String, dynamic>,
      toCache: (data) => jsonEncode(data),
      fallback: {},
    );

    _cachedLanguageNames = result;
    return result;
  }

  // ==================== CACHE MANAGEMENT ====================

  /// Force refresh all content from Firestore
  Future<void> forceRefreshAll() async {
    _cachedDuas = null;
    _cachedAllahNames = null;
    _cachedKalmas = null;
    _cachedIslamicNames = null;
    _cachedHadith = null;
    _cachedTasbih = null;
    _cachedBasicAmal = null;
    _cachedGreetingCards = null;
    _cachedSampleHadith = null;
    _cachedHajjGuide = null;
    _cachedRamadanDuas = null;
    _cachedZakatGuide = null;
    _cachedQuranMetadata = null;
    _cachedFastingDuas = null;
    _cachedSettingsTranslations = null;
    _cachedNotificationStrings = null;
    _cachedCalendarStrings = null;
    _cachedNameTransliterations = null;
    _cachedHadithTranslations = null;
    _cachedLanguageNames = null;
    _cachedSettingsScreenContent = null;
    _cachedZakatCalculatorContent = null;
    _cachedZakatGuideScreenContent = null;
    _cachedQuranScreenContent = null;
    _cachedSurahContent = null;
    _cachedFastingTimesContent = null;
    _cachedHomeScreenContent = null;

    // Clear Hive cache
    await _contentBox?.clear();

    debugPrint('All content cache cleared');
  }

  /// Invalidate cache for specific content type
  Future<void> invalidateCache(String contentType) async {
    switch (contentType) {
      case 'duas':
        _cachedDuas = null;
        await _contentBox?.delete(_duasCacheKey);
        break;
      case 'allah_names':
        _cachedAllahNames = null;
        await _contentBox?.delete(_allahNamesCacheKey);
        break;
      case 'kalmas':
        _cachedKalmas = null;
        await _contentBox?.delete(_kalmasCacheKey);
        break;
      case 'islamic_names':
        _cachedIslamicNames = null;
        // Clear all islamic names caches
        final keys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_islamicNamesCacheKey),
        );
        for (final key in keys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'hadith':
        _cachedHadith = null;
        final hadithKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_hadithCacheKey),
        );
        for (final key in hadithKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'tasbih':
        _cachedTasbih = null;
        await _contentBox?.delete(_tasbihCacheKey);
        break;
      case 'basic_amal':
        _cachedBasicAmal = null;
        final amalKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_basicAmalCacheKey),
        );
        for (final key in amalKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'greeting_cards':
        _cachedGreetingCards = null;
        await _contentBox?.delete(_greetingCardsCacheKey);
        break;
      case 'sample_hadith':
        _cachedSampleHadith = null;
        final sampleHadithKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_sampleHadithCacheKey),
        );
        for (final key in sampleHadithKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'hajj_guide':
        _cachedHajjGuide = null;
        final hajjKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_hajjGuideCacheKey),
        );
        for (final key in hajjKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'ramadan_duas':
        _cachedRamadanDuas = null;
        await _contentBox?.delete(_ramadanDuasCacheKey);
        break;
      case 'zakat_guide':
        _cachedZakatGuide = null;
        await _contentBox?.delete(_zakatGuideCacheKey);
        break;
      case 'quran_metadata':
        _cachedQuranMetadata = null;
        final quranKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_quranMetadataCacheKey),
        );
        for (final key in quranKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'fasting_data':
        _cachedFastingDuas = null;
        await _contentBox?.delete(_fastingDataCacheKey);
        break;
      case 'settings_translations':
        _cachedSettingsTranslations = null;
        final settingsKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_settingsTranslationsCacheKey),
        );
        for (final key in settingsKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'notification_strings':
        _cachedNotificationStrings = null;
        final notifKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_notificationStringsCacheKey),
        );
        for (final key in notifKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'calendar_strings':
        _cachedCalendarStrings = null;
        await _contentBox?.delete(_calendarStringsCacheKey);
        break;
      case 'name_transliterations':
        _cachedNameTransliterations = null;
        final translitKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_nameTransliterationsCacheKey),
        );
        for (final key in translitKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'hadith_translations':
        _cachedHadithTranslations = null;
        await _contentBox?.delete(_hadithTranslationsCacheKey);
        break;
      case 'language_names':
        _cachedLanguageNames = null;
        await _contentBox?.delete(_languageNamesCacheKey);
        break;
      case 'zakat_calculator_content':
        _cachedZakatCalculatorContent = null;
        await _contentBox?.delete(_zakatCalculatorContentCacheKey);
        break;
      case 'zakat_guide_screen_content':
        _cachedZakatGuideScreenContent = null;
        await _contentBox?.delete(_zakatGuideScreenContentCacheKey);
        break;
      case 'quran_screen_content':
        _cachedQuranScreenContent = null;
        await _contentBox?.delete(_quranScreenContentCacheKey);
        break;
      case 'quran_surahs':
        _cachedSurahContent = null;
        final surahKeys = _contentBox?.keys.where(
          (k) => k.toString().startsWith(_quranSurahCachePrefix),
        );
        for (final key in surahKeys ?? []) {
          await _contentBox?.delete(key);
        }
        break;
      case 'fasting_times_content':
        _cachedFastingTimesContent = null;
        await _contentBox?.delete(_fastingTimesContentCacheKey);
        break;
      case 'home_screen_content':
        _cachedHomeScreenContent = null;
        await _contentBox?.delete(_homeScreenContentCacheKey);
        break;
    }

    debugPrint('Cache invalidated for $contentType');
  }

  // ==================== QIBLA CONTENT ====================

  /// Fetch qibla screen content (all strings in 4 languages)
  Future<QiblaContentFirestore?> getQiblaContent() async {
    if (_cachedQiblaContent != null) return _cachedQiblaContent;

    final result = await _fetchWithCache<QiblaContentFirestore?>(
      cacheKey: _qiblaContentCacheKey,
      contentType: 'qibla_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('qibla_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return QiblaContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return QiblaContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<QiblaContentFirestore>(
        assetPath: 'assets/data/firebase/qibla_content.json',
        fromJson: QiblaContentFirestore.fromJson,
        cacheKey: _qiblaContentCacheKey,
      );
      _cachedQiblaContent = fallback;
      return fallback;
    }

    _cachedQiblaContent = result;
    return result;
  }

  // ==================== PRAYER TIMES SCREEN CONTENT ====================

  /// Fetch prayer times screen content (all strings, prayer items, months in 4 languages)
  Future<PrayerTimesScreenContentFirestore?> getPrayerTimesScreenContent() async {
    if (_cachedPrayerTimesScreenContent != null) return _cachedPrayerTimesScreenContent;

    final result = await _fetchWithCache<PrayerTimesScreenContentFirestore?>(
      cacheKey: _prayerTimesScreenContentCacheKey,
      contentType: 'prayer_times_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('prayer_times_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return PrayerTimesScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return PrayerTimesScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<PrayerTimesScreenContentFirestore>(
        assetPath: 'assets/data/firebase/prayer_times_content.json',
        fromJson: PrayerTimesScreenContentFirestore.fromJson,
        cacheKey: _prayerTimesScreenContentCacheKey,
      );
      _cachedPrayerTimesScreenContent = fallback;
      return fallback;
    }

    _cachedPrayerTimesScreenContent = result;
    return result;
  }

  // ==================== NOTIFICATIONS SCREEN CONTENT ====================

  /// Fetch notifications screen content (all strings, day names, month abbreviations in 4 languages)
  Future<NotificationsScreenContentFirestore?> getNotificationsScreenContent() async {
    if (_cachedNotificationsScreenContent != null) return _cachedNotificationsScreenContent;

    final result = await _fetchWithCache<NotificationsScreenContentFirestore?>(
      cacheKey: _notificationsScreenContentCacheKey,
      contentType: 'notifications_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('notifications_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return NotificationsScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return NotificationsScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<NotificationsScreenContentFirestore>(
        assetPath: 'assets/data/firebase/notifications_screen_content.json',
        fromJson: NotificationsScreenContentFirestore.fromJson,
        cacheKey: _notificationsScreenContentCacheKey,
      );
      _cachedNotificationsScreenContent = fallback;
      return fallback;
    }

    _cachedNotificationsScreenContent = result;
    return result;
  }

  // ==================== SETTINGS SCREEN CONTENT ====================

  /// Fetch settings screen content (all strings, languages, translations in 4 languages)
  Future<SettingsScreenContentFirestore?> getSettingsScreenContent() async {
    if (_cachedSettingsScreenContent != null) return _cachedSettingsScreenContent;

    final result = await _fetchWithCache<SettingsScreenContentFirestore?>(
      cacheKey: _settingsScreenContentCacheKey,
      contentType: 'settings_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('settings_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return SettingsScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return SettingsScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<SettingsScreenContentFirestore>(
        assetPath: 'assets/data/firebase/settings_screen_content.json',
        fromJson: SettingsScreenContentFirestore.fromJson,
        cacheKey: _settingsScreenContentCacheKey,
      );
      _cachedSettingsScreenContent = fallback;
      return fallback;
    }

    _cachedSettingsScreenContent = result;
    return result;
  }

  // ==================== TASBIH SCREEN CONTENT ====================

  /// Fetch tasbih screen content (all strings in 4 languages)
  Future<TasbihScreenContentFirestore?> getTasbihScreenContent() async {
    if (_cachedTasbihScreenContent != null) return _cachedTasbihScreenContent;

    final result = await _fetchWithCache<TasbihScreenContentFirestore?>(
      cacheKey: _tasbihScreenContentCacheKey,
      contentType: 'tasbih_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('tasbih_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return TasbihScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return TasbihScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback =
          await _loadFromAssetFallback<TasbihScreenContentFirestore>(
            assetPath: 'assets/data/firebase/tasbih_content.json',
            fromJson: TasbihScreenContentFirestore.fromJson,
            cacheKey: _tasbihScreenContentCacheKey,
          );
      _cachedTasbihScreenContent = fallback;
      return fallback;
    }

    _cachedTasbihScreenContent = result;
    return result;
  }

  // ==================== CALENDAR SCREEN CONTENT ====================

  /// Fetch calendar screen content (all strings, months, days in 4 languages)
  Future<CalendarScreenContentFirestore?> getCalendarScreenContent() async {
    if (_cachedCalendarScreenContent != null) {
      return _cachedCalendarScreenContent;
    }

    final result = await _fetchWithCache<CalendarScreenContentFirestore?>(
      cacheKey: _calendarScreenContentCacheKey,
      contentType: 'calendar_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('calendar_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return CalendarScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return CalendarScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback =
          await _loadFromAssetFallback<CalendarScreenContentFirestore>(
            assetPath: 'assets/data/firebase/calendar_screen_content.json',
            fromJson: CalendarScreenContentFirestore.fromJson,
            cacheKey: _calendarScreenContentCacheKey,
          );
      _cachedCalendarScreenContent = fallback;
      return fallback;
    }

    _cachedCalendarScreenContent = result;
    return result;
  }

  // ==================== ZAKAT CALCULATOR CONTENT ====================

  /// Fetch zakat calculator screen content (all strings + countries in 4 languages)
  Future<ZakatCalculatorContentFirestore?> getZakatCalculatorContent() async {
    if (_cachedZakatCalculatorContent != null) {
      return _cachedZakatCalculatorContent;
    }

    final result = await _fetchWithCache<ZakatCalculatorContentFirestore?>(
      cacheKey: _zakatCalculatorContentCacheKey,
      contentType: 'zakat_calculator_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('zakat_calculator_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return ZakatCalculatorContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return ZakatCalculatorContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback =
          await _loadFromAssetFallback<ZakatCalculatorContentFirestore>(
            assetPath: 'assets/data/firebase/zakat_calculator_content.json',
            fromJson: ZakatCalculatorContentFirestore.fromJson,
            cacheKey: _zakatCalculatorContentCacheKey,
          );
      _cachedZakatCalculatorContent = fallback;
      return fallback;
    }

    _cachedZakatCalculatorContent = result;
    return result;
  }

  // ==================== ZAKAT GUIDE SCREEN CONTENT ====================

  /// Fetch zakat guide screen content (all strings + sections in 4 languages)
  Future<ZakatGuideContentFirestore?> getZakatGuideScreenContent() async {
    if (_cachedZakatGuideScreenContent != null) {
      return _cachedZakatGuideScreenContent;
    }

    final result = await _fetchWithCache<ZakatGuideContentFirestore?>(
      cacheKey: _zakatGuideScreenContentCacheKey,
      contentType: 'zakat_guide_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('zakat_guide_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return ZakatGuideContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return ZakatGuideContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<ZakatGuideContentFirestore>(
        assetPath: 'assets/data/firebase/zakat_guide_content.json',
        fromJson: ZakatGuideContentFirestore.fromJson,
        cacheKey: _zakatGuideScreenContentCacheKey,
      );
      _cachedZakatGuideScreenContent = fallback;
      return fallback;
    }

    _cachedZakatGuideScreenContent = result;
    return result;
  }

  // ==================== QURAN SCREEN CONTENT ====================

  /// Fetch quran screen content (surah names, para names, transliterations, juz data)
  Future<QuranScreenContentFirestore?> getQuranScreenContent() async {
    if (_cachedQuranScreenContent != null) return _cachedQuranScreenContent;

    final result = await _fetchWithCache<QuranScreenContentFirestore?>(
      cacheKey: _quranScreenContentCacheKey,
      contentType: 'quran_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('quran_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return QuranScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return QuranScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback =
          await _loadFromAssetFallback<QuranScreenContentFirestore>(
            assetPath: 'assets/data/firebase/quran_screen_content.json',
            fromJson: QuranScreenContentFirestore.fromJson,
            cacheKey: _quranScreenContentCacheKey,
          );
      _cachedQuranScreenContent = fallback;
      return fallback;
    }

    _cachedQuranScreenContent = result;
    return result;
  }

  // ==================== QURAN SURAH CONTENT ====================

  /// Fetch individual surah content (all ayahs with 4-language translations)
  Future<SurahContentFirestore?> getSurahContent(int surahNumber) async {
    _cachedSurahContent ??= {};

    if (_cachedSurahContent!.containsKey(surahNumber)) {
      return _cachedSurahContent![surahNumber];
    }

    final cacheKey = '$_quranSurahCachePrefix$surahNumber';

    final result = await _fetchWithCache<SurahContentFirestore?>(
      cacheKey: cacheKey,
      contentType: 'quran_surahs',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('quran_surahs')
            .doc('surah_$surahNumber')
            .get();

        if (!doc.exists) return null;
        return SurahContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return SurahContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      // Fallback to local asset JSON
      final fallback = await _loadFromAssetFallback<SurahContentFirestore>(
        assetPath: 'assets/data/firebase/quran_surahs/surah_$surahNumber.json',
        fromJson: SurahContentFirestore.fromJson,
        cacheKey: cacheKey,
      );
      if (fallback != null) {
        _cachedSurahContent![surahNumber] = fallback;
      }
      return fallback;
    }

    _cachedSurahContent![surahNumber] = result;
    return result;
  }

  // ==================== ABOUT SCREEN CONTENT ====================

  /// Fetch about screen content (all strings, features in 4 languages)
  Future<AboutScreenContentFirestore?> getAboutScreenContent() async {
    if (_cachedAboutScreenContent != null) return _cachedAboutScreenContent;

    final result = await _fetchWithCache<AboutScreenContentFirestore?>(
      cacheKey: _aboutScreenContentCacheKey,
      contentType: 'about_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('about_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return AboutScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return AboutScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<AboutScreenContentFirestore>(
        assetPath: 'assets/data/firebase/about_screen_content.json',
        fromJson: AboutScreenContentFirestore.fromJson,
        cacheKey: _aboutScreenContentCacheKey,
      );
      _cachedAboutScreenContent = fallback;
      return fallback;
    }

    _cachedAboutScreenContent = result;
    return result;
  }

  // ==================== PRIVACY POLICY SCREEN CONTENT ====================

  /// Fetch privacy policy screen content (all strings, sections in 4 languages)
  Future<PrivacyPolicyScreenContentFirestore?> getPrivacyPolicyScreenContent() async {
    if (_cachedPrivacyPolicyScreenContent != null) return _cachedPrivacyPolicyScreenContent;

    final result = await _fetchWithCache<PrivacyPolicyScreenContentFirestore?>(
      cacheKey: _privacyPolicyScreenContentCacheKey,
      contentType: 'privacy_policy_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('privacy_policy_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return PrivacyPolicyScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return PrivacyPolicyScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<PrivacyPolicyScreenContentFirestore>(
        assetPath: 'assets/data/firebase/privacy_policy_screen_content.json',
        fromJson: PrivacyPolicyScreenContentFirestore.fromJson,
        cacheKey: _privacyPolicyScreenContentCacheKey,
      );
      _cachedPrivacyPolicyScreenContent = fallback;
      return fallback;
    }

    _cachedPrivacyPolicyScreenContent = result;
    return result;
  }

  // ==================== UI TRANSLATIONS ====================

  /// Fetch all UI translations (used by LanguageProvider)
  Future<Map<String, Map<String, String>>> getUITranslations() async {
    if (_cachedUITranslations != null) return _cachedUITranslations!.translations;

    final result = await _fetchWithCache<UITranslationsFirestore?>(
      cacheKey: _uiTranslationsCacheKey,
      contentType: 'ui_translations',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('ui_translations')
            .doc('all_translations')
            .get();

        if (!doc.exists) return null;
        return UITranslationsFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return UITranslationsFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<UITranslationsFirestore>(
        assetPath: 'assets/data/firebase/ui_translations.json',
        fromJson: UITranslationsFirestore.fromJson,
        cacheKey: _uiTranslationsCacheKey,
      );
      _cachedUITranslations = fallback;
      return fallback?.translations ?? {};
    }

    _cachedUITranslations = result;
    return result.translations;
  }

  /// Preload UI translations during app startup
  Future<void> preloadTranslations() async {
    await getUITranslations();
  }

  // ==================== HOME SCREEN CONTENT ====================

  /// Fetch home screen content (sections, features, maps in 4 languages)
  Future<HomeScreenContentFirestore?> getHomeScreenContent() async {
    if (_cachedHomeScreenContent != null) return _cachedHomeScreenContent;

    final result = await _fetchWithCache<HomeScreenContentFirestore?>(
      cacheKey: _homeScreenContentCacheKey,
      contentType: 'home_screen_content',
      fetchFromFirestore: () async {
        final doc = await _firestore
            .collection('home_screen_content')
            .doc('data')
            .get();

        if (!doc.exists) return null;
        return HomeScreenContentFirestore.fromJson(doc.data()!);
      },
      fromCache: (cached) {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return HomeScreenContentFirestore.fromJson(decoded);
      },
      toCache: (data) => data != null ? jsonEncode(data.toJson()) : '{}',
      fallback: null,
    );

    if (result == null) {
      final fallback = await _loadFromAssetFallback<HomeScreenContentFirestore>(
        assetPath: 'assets/data/firebase/home_screen_content.json',
        fromJson: HomeScreenContentFirestore.fromJson,
        cacheKey: _homeScreenContentCacheKey,
      );
      _cachedHomeScreenContent = fallback;
      return fallback;
    }

    _cachedHomeScreenContent = result;
    return result;
  }

  // ==================== ISLAMIC EVENTS ====================

  List<Map<String, dynamic>>? _cachedIslamicEvents;

  /// Fetch Islamic events from Firestore, falling back to local JSON asset
  Future<List<Map<String, dynamic>>> getIslamicEvents() async {
    if (_cachedIslamicEvents != null) return _cachedIslamicEvents!;

    try {
      final doc = await _firestore
          .collection('app_data')
          .doc('islamic_events')
          .get();

      if (doc.exists && doc.data() != null) {
        final events = (doc.data()!['events'] as List<dynamic>? ?? [])
            .map((e) => e as Map<String, dynamic>)
            .toList();
        if (events.isNotEmpty) {
          _cachedIslamicEvents = events;
          return events;
        }
      }
    } catch (e) {
      debugPrint('Error fetching Islamic events from Firestore: $e');
    }

    // Fallback to local JSON asset
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/islamic_events.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final events = (jsonData['events'] as List<dynamic>? ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList();
      _cachedIslamicEvents = events;
      return events;
    } catch (e) {
      debugPrint('Error loading local Islamic events: $e');
    }

    return [];
  }

  /// Clear all cached data
  void clearRamadanDuasCache() {
    _cachedRamadanDuas = null;
    _contentBox?.delete(_ramadanDuasCacheKey);
  }

  Future<void> clearCache() async {
    _cachedDuas = null;
    _cachedAllahNames = null;
    _cachedKalmas = null;
    _cachedIslamicNames = null;
    _cachedHadith = null;
    _cachedTasbih = null;
    _cachedBasicAmal = null;
    _cachedGreetingCards = null;
    _cachedSampleHadith = null;
    _cachedHajjGuide = null;
    _cachedRamadanDuas = null;
    _cachedZakatGuide = null;
    _cachedQuranMetadata = null;
    _cachedFastingDuas = null;
    _cachedSettingsTranslations = null;
    _cachedNotificationStrings = null;
    _cachedCalendarStrings = null;
    _cachedNameTransliterations = null;
    _cachedHadithTranslations = null;
    _cachedLanguageNames = null;
    _cachedQiblaContent = null;
    _cachedPrayerTimesScreenContent = null;
    _cachedNotificationsScreenContent = null;
    _cachedSettingsScreenContent = null;
    _cachedTasbihScreenContent = null;
    _cachedCalendarScreenContent = null;
    _cachedZakatCalculatorContent = null;
    _cachedZakatGuideScreenContent = null;
    _cachedQuranScreenContent = null;
    _cachedSurahContent = null;
    _cachedAboutScreenContent = null;
    _cachedPrivacyPolicyScreenContent = null;
    _cachedUITranslations = null;
    _cachedFastingTimesContent = null;
    _cachedHomeScreenContent = null;
    _cachedVersions = null;
    await _contentBox?.clear();
    debugPrint('All cache cleared');
  }

  /// Get cache size in bytes (approximate)
  int getCacheSize() {
    int size = 0;
    for (var key in _contentBox?.keys ?? []) {
      final value = _contentBox?.get(key);
      if (value != null) {
        size += value.length;
      }
    }
    return size;
  }

  /// Get formatted cache size string
  String getFormattedCacheSize() {
    final bytes = getCacheSize();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
