import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/adhan_provider.dart';
import '../../core/services/weather_service.dart';
import '../../core/services/location_service.dart';
import '../../widgets/common/common_widgets.dart';
import '../quran/quran_screen.dart';
import '../quran/surah_list_screen.dart';
import '../qibla/qibla_screen.dart';
import '../tasbih/tasbih_screen.dart';
import '../dua/dua_category_screen.dart';
import '../calendar/calendar_screen.dart';
import '../names_of_allah/names_of_allah_screen.dart';
import '../hadith/hadith_books_screen.dart';
import '../../providers/hadith_provider.dart';
import '../zakat_calculator/zakat_calculator_screen.dart';
import '../zakat_calculator/zakat_guide_screen.dart';
// New feature imports
import '../mosque_finder/mosque_finder_screen.dart';
import '../halal_finder/halal_finder_screen.dart';
import '../ramadan/ramadan_tracker_screen.dart';
import '../hajj_guide/hajj_guide_screen.dart';
import '../notifications/notifications_screen.dart';
import '../fasting_times/fasting_times_screen.dart';
import '../greeting_cards/greeting_cards_screen.dart';
// Islamic Names
import '../islamic_names/islamic_names_list_screen.dart';
// Basic Amal imports
import '../basic_amal/namaz_guide_screen.dart';
import '../basic_amal/nazar_karika_screen.dart';
import '../basic_amal/fatiha_screen.dart';
import '../basic_amal/wazu_screen.dart';
import '../basic_amal/ghusl_screen.dart';
import '../basic_amal/khutba_screen.dart';
import '../basic_amal/nazar_e_bad_screen.dart';
import '../basic_amal/azan_screen.dart';
import '../basic_amal/jahannam_fazilat_screen.dart';
import '../basic_amal/family_fazilat_screen.dart';
import '../basic_amal/relative_fazilat_screen.dart';
import '../basic_amal/gunha_fazilat_screen.dart';
import '../basic_amal/jannat_fazilat_screen.dart';
import '../basic_amal/month_name_fazilat_screen.dart';
import '../basic_amal/namaz_fazilat_screen.dart';
import '../basic_amal/savab_fazilat_screen.dart';
import '../basic_amal/zamzam_fazilat_screen.dart';
import '../kalma/seven_kalma_screen.dart';
import '../../core/services/azan_permission_service.dart';
import '../../core/services/content_service.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _searchQuery = '';
  bool _isListening = false;
  WeatherData? _weatherData;
  bool _isLoadingWeather = true;
  final ContentService _contentService = ContentService();

  // PageView carousel state
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  static const int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _loadLanguageNames();
    _loadNotificationStrings();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Request all required permissions for Azan on Android
      if (Platform.isAndroid) {
        await _requestAzanPermissions();
      }

      if (!mounted) return;

      // Initialize prayer times
      final prayerProvider = context.read<PrayerProvider>();
      await prayerProvider.initialize();

      // Schedule Azan notifications after prayer times are loaded
      if (mounted && prayerProvider.todayPrayerTimes != null) {
        final adhanProvider = context.read<AdhanProvider>();

        // Update AdhanProvider with current location for location-aware notifications
        final locationService = LocationService();
        final position = prayerProvider.currentPosition;
        if (position != null) {
          final city = locationService.currentCity ?? '';
          adhanProvider.updateLocation(
            city: city,
            latitude: position.latitude,
            longitude: position.longitude,
          );
        }

        await adhanProvider.schedulePrayerNotifications(
          prayerProvider.todayPrayerTimes!,
        );

        // Schedule daily Islamic reminders and festival notifications
        await adhanProvider.scheduleAllIslamicNotifications();
      }
    });
    _initSpeech();
    _fetchWeather();
    _startAutoScroll();
  }

  Future<void> _loadLanguageNames() async {
    try {
      final data = await _contentService.getLanguageNames();
      if (data.isNotEmpty) {
        LanguageHelpers.loadFromFirestore(data);
      }
    } catch (e) {
      debugPrint('Home: Error loading language names: $e');
    }
  }

  Future<void> _loadNotificationStrings() async {
    try {
      final prayerData = await _contentService.getNotificationStrings('prayer');
      if (prayerData.isNotEmpty) {
        PrayerNotificationStrings.loadFromFirestore(prayerData);
      }
      final reminderData = await _contentService.getNotificationStrings('reminders');
      if (reminderData.isNotEmpty) {
        IslamicReminderStrings.loadFromFirestore(reminderData);
      }
    } catch (e) {
      debugPrint('Home: Error loading notification strings: $e');
    }
  }

  /// Request all permissions required for background Azan
  Future<void> _requestAzanPermissions() async {
    // Check current permission status
    final status = await AzanPermissionService.checkAllPermissions();
    debugPrint('Azan Permissions: $status');

    // Request notification permission first (Android 13+)
    if (!status.notification && status.androidVersion >= 33) {
      await AzanPermissionService.requestNotificationPermission();
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    // Request exact alarm permission (Android 12+)
    if (!status.exactAlarm && status.androidVersion >= 31) {
      await AzanPermissionService.requestExactAlarmPermission();
    }

    // Request battery optimization disable
    if (!status.batteryOptimization) {
      await Future.delayed(const Duration(milliseconds: 500));
      await AzanPermissionService.requestDisableBatteryOptimization();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _totalPages;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchWeather() async {
    try {
      debugPrint('🌤️ Starting weather fetch...');
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();

      if (position != null && mounted) {
        debugPrint(
          '🌤️ Location found: ${position.latitude}, ${position.longitude}',
        );
        final weather = await WeatherService.getWeather(
          lat: position.latitude,
          lon: position.longitude,
        );

        debugPrint(
          '🌤️ Weather data received: ${weather != null ? "Success" : "Failed"}',
        );
        if (weather != null) {
          debugPrint('🌤️ Temperature: ${weather.temperature}°C');
          debugPrint('🌤️ AQI: ${weather.aqi} - ${weather.aqiLevel}');
        }

        if (mounted) {
          setState(() {
            _weatherData = weather;
            _isLoadingWeather = false;
          });
        }
      } else {
        debugPrint('🌤️ Location is null or widget not mounted');
        setState(() {
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      debugPrint('🌤️ Error fetching weather: $e');
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
        });
      }
    }
  }

  Future<void> _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      debugPrint('Speech init error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.tr('good_morning');
    } else if (hour < 17) {
      return context.tr('good_afternoon');
    } else {
      return context.tr('good_evening');
    }
  }

  String _getTranslatedDay(BuildContext context) {
    final now = DateTime.now();
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    // DateTime.weekday returns 1 for Monday, 7 for Sunday
    return context.tr(days[now.weekday - 1]);
  }

  String _getTranslatedMonth(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    return context.tr(months[now.month - 1]);
  }

  String _getTranslatedWeatherDescription(
    BuildContext context,
    String description,
  ) {
    final lowerDesc = description.toLowerCase().trim();

    // Map weather descriptions to translation keys
    final weatherMap = {
      'clear sky': 'weather_clear_sky',
      'few clouds': 'weather_few_clouds',
      'scattered clouds': 'weather_scattered_clouds',
      'broken clouds': 'weather_broken_clouds',
      'overcast clouds': 'weather_overcast_clouds',
      'shower rain': 'weather_shower_rain',
      'rain': 'weather_rain',
      'light rain': 'weather_light_rain',
      'moderate rain': 'weather_moderate_rain',
      'heavy intensity rain': 'weather_heavy_rain',
      'heavy rain': 'weather_heavy_rain',
      'thunderstorm': 'weather_thunderstorm',
      'snow': 'weather_snow',
      'mist': 'weather_mist',
      'haze': 'weather_haze',
      'fog': 'weather_fog',
      'dust': 'weather_dust',
      'smoke': 'weather_smoke',
    };

    final key = weatherMap[lowerDesc];
    if (key != null) {
      return context.tr(key);
    }

    // Return capitalized description if not found
    return description
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getTranslatedAQILevel(BuildContext context, String aqiLevel) {
    final aqiMap = {
      'Good': 'aqi_good',
      'Fair': 'aqi_fair',
      'Moderate': 'aqi_moderate',
      'Poor': 'aqi_poor',
      'Very Poor': 'aqi_very_poor',
      'Unknown': 'aqi_unknown',
    };

    final key = aqiMap[aqiLevel];
    if (key != null) {
      return context.tr(key);
    }

    return aqiLevel;
  }

  String _getTranslatedHijriMonth(BuildContext context, String monthName) {
    // Map all possible variations of Hijri month names
    final monthMap = {
      'Muharram': 'month_muharram',
      'Safar': 'month_safar',
      'Rabi\' al-awwal': 'month_rabi_ul_awwal',
      'Rabi\' al-Awwal': 'month_rabi_ul_awwal',
      'Rabi\' al-thani': 'month_rabi_ul_aakhir',
      'Rabi\' al-Thani': 'month_rabi_ul_aakhir',
      'Rabi\' al-akhir': 'month_rabi_ul_aakhir',
      'Rabi\' al-Akhir': 'month_rabi_ul_aakhir',
      'Jumada al-awwal': 'month_jumada_ul_ula',
      'Jumada al-Awwal': 'month_jumada_ul_ula',
      'Jumada al-ula': 'month_jumada_ul_ula',
      'Jumada al-Ula': 'month_jumada_ul_ula',
      'Jumada al-thani': 'month_jumada_ul_aakhira',
      'Jumada al-Thani': 'month_jumada_ul_aakhira',
      'Jumada al-akhirah': 'month_jumada_ul_aakhira',
      'Jumada al-Akhirah': 'month_jumada_ul_aakhira',
      'Rajab': 'month_rajab',
      'Sha\'ban': 'month_shaban',
      'Sha\'aban': 'month_shaban',
      'Shaban': 'month_shaban',
      'Shaaban': 'month_shaban',
      'Ramadan': 'month_ramadan',
      'Ramadhan': 'month_ramadan',
      'Shawwal': 'month_shawwal',
      'Shawwāl': 'month_shawwal',
      'Dhu al-Qi\'dah': 'month_dhul_qadah',
      'Dhu al-Qidah': 'month_dhul_qadah',
      'Dhul-Qadah': 'month_dhul_qadah',
      'Dhul Qadah': 'month_dhul_qadah',
      'Dhu al-Hijjah': 'month_dhul_hijjah',
      'Dhu al-Hijja': 'month_dhul_hijjah',
      'Dhul-Hijjah': 'month_dhul_hijjah',
      'Dhul Hijjah': 'month_dhul_hijjah',
    };

    // Try to find the month in the map
    final key = monthMap[monthName];
    if (key != null) {
      return context.tr(key);
    }

    // If not found, log the actual month name and return as-is
    debugPrint('Hijri month not mapped: "$monthName"');
    return monthName;
  }

  void _onSearch(String query) {
    // Search happens via onChanged callback
    // No navigation needed
  }

  // Sort features based on search query - matched items on top, rest below
  // Searches across all 4 languages (English, Urdu, Arabic, Hindi)
  List<FeatureGridItem> _filterFeatures(List<FeatureGridItem> features) {
    if (_searchQuery.isEmpty) {
      return features;
    }

    final matchingFeatures = <FeatureGridItem>[];
    final nonMatchingFeatures = <FeatureGridItem>[];

    for (final feature in features) {
      bool matches = false;

      // If translation key is provided, search in all languages
      if (feature.translationKey != null) {
        matches = LanguageHelpers.matchesInAnyLanguage(
          context,
          feature.translationKey!,
          _searchQuery,
        );
      } else {
        // Fallback to current language title
        matches = feature.title.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
      }

      if (matches) {
        matchingFeatures.add(feature);
      } else {
        nonMatchingFeatures.add(feature);
      }
    }

    return [...matchingFeatures, ...nonMatchingFeatures];
  }

  // Get all matched features from all sections for consolidated search results
  // Searches across all 4 languages (English, Urdu, Arabic, Hindi)
  List<FeatureGridItem> _getAllMatchedFeatures(BuildContext context) {
    if (_searchQuery.isEmpty) {
      return [];
    }

    final allMatchedFeatures = <FeatureGridItem>[];

    // Collect all features from all sections
    final allFeatureLists = [
      _getMainFeaturesList(context),
      _getMoreFeaturesList(context),
      _getIslamicNamesList(context),
      _getBasicAmalList(context),
      _getIslamicBooksList(context),
    ];

    // Filter and collect matched items using multi-language search
    for (final featureList in allFeatureLists) {
      for (final feature in featureList) {
        bool matches = false;

        // If translation key is provided, search in all languages
        if (feature.translationKey != null) {
          matches = LanguageHelpers.matchesInAnyLanguage(
            context,
            feature.translationKey!,
            _searchQuery,
          );
        } else {
          // Fallback to current language title
          matches = feature.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
        }

        if (matches) {
          allMatchedFeatures.add(feature);
        }
      }
    }

    return allMatchedFeatures;
  }

  List<FeatureGridItem> _getMainFeaturesList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.library_books,
        title: context.tr('surah'),
        translationKey: 'surah',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SurahListScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.volunteer_activism,
        title: context.tr('duas'),
        translationKey: 'duas',
        color: Colors.pink,
        emoji: '🤲',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DuaCategoryScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.menu_book,
        title: context.tr('seven_kalma'),
        translationKey: 'seven_kalma',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SevenKalmaScreen()),
        ),
      ),
    ];
  }

  List<FeatureGridItem> _getMoreFeaturesList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.nights_stay,
        title: context.tr('ramadan'),
        translationKey: 'ramadan',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RamadanTrackerScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.wb_twilight,
        title: context.tr('fasting'),
        translationKey: 'fasting',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FastingTimesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.mosque,
        title: context.tr('mosques'),
        translationKey: 'mosques',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MosqueFinderScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.restaurant,
        title: context.tr('halal'),
        translationKey: 'halal',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalalFinderScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.card_giftcard,
        title: context.tr('status'),
        translationKey: 'status',
        color: Colors.deepPurple,
        emoji: '🎴',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GreetingCardsScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.flight_takeoff,
        title: context.tr('hajj_guide'),
        translationKey: 'hajj_guide',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HajjGuideScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.explore,
        title: context.tr('qibla'),
        translationKey: 'qibla',
        color: AppColors.compassNeedle,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QiblaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.radio_button_checked,
        title: context.tr('tasbih'),
        translationKey: 'tasbih',
        color: AppColors.secondary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TasbihScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calendar_month,
        title: context.tr('calendar'),
        translationKey: 'calendar',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calculate,
        title: context.tr('zakat'),
        translationKey: 'zakat',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ZakatCalculatorScreen(),
          ),
        ),
      ),
      FeatureGridItem(
        icon: Icons.menu_book_rounded,
        title: context.tr('zakat_guide'),
        translationKey: 'zakat_guide',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZakatGuideScreen()),
        ),
      ),
    ];
  }

  List<FeatureGridItem> _getIslamicNamesList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.star,
        title: context.tr('names_of_allah'),
        translationKey: 'names_of_allah',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamesOfAllahScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.person,
        title: context.tr('nabi_names'),
        translationKey: 'nabi_names',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IslamicNamesListScreen(collectionKey: 'prophets', assetFileName: 'prophets_names.json', titleKey: 'nabi_names', hasSearch: true, emptyStateKey: 'no_prophets_found', detailCategory: 'Prophet of Allah', detailIcon: Icons.person, detailColor: Colors.green)),
        ),
      ),
      FeatureGridItem(
        icon: Icons.people,
        title: context.tr('sahaba_names'),
        translationKey: 'sahaba_names',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IslamicNamesListScreen(collectionKey: 'sahaba', assetFileName: 'sahaba_names.json', titleKey: 'sahaba_names', hasSearch: true, emptyStateKey: 'no_companions_found', detailCategory: 'Companion of Prophet ﷺ', detailIcon: Icons.people, detailColor: Colors.blue)),
        ),
      ),
      FeatureGridItem(
        icon: Icons.account_balance,
        title: context.tr('khalifa_names'),
        translationKey: 'khalifa_names',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IslamicNamesListScreen(collectionKey: 'khalifas', assetFileName: 'khalifa_names.json', titleKey: 'khalifa_names', showPeriodInMeaning: true, detailCategory: 'Rightly Guided Caliph', detailIcon: Icons.account_balance, detailColor: Colors.orange)),
        ),
      ),
      FeatureGridItem(
        icon: Icons.stars,
        title: context.tr('twelve_imams'),
        translationKey: 'twelve_imams',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IslamicNamesListScreen(collectionKey: 'twelve_imams', assetFileName: 'twelve_imams_names.json', titleKey: 'twelve_imams', hasSearch: true, emptyStateKey: 'no_imams_found', showKunya: true, detailCategory: 'Imam of Ahlul Bayt', detailIcon: Icons.stars, detailColor: Colors.purple)),
        ),
      ),
      FeatureGridItem(
        icon: Icons.favorite,
        title: context.tr('panjatan'),
        translationKey: 'panjatan',
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IslamicNamesListScreen(collectionKey: 'panjatan', assetFileName: 'panjatan_names.json', titleKey: 'panjatan', detailCategory: 'Panjatan Pak', detailIcon: Icons.favorite, detailColor: Colors.red)),
        ),
      ),
      FeatureGridItem(
        icon: Icons.family_restroom,
        title: context.tr('ahlebait'),
        translationKey: 'ahlebait',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IslamicNamesListScreen(collectionKey: 'ahlebait', assetFileName: 'ahlebait_names.json', titleKey: 'ahlebait', hasSearch: true, emptyStateKey: 'no_members_found', detailCategory: 'Ahlul Bayt', detailIcon: Icons.family_restroom, detailColor: Colors.teal)),
        ),
      ),
    ];
  }

  List<FeatureGridItem> _getBasicAmalList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.mosque,
        title: context.tr('sabhi_namaz'),
        translationKey: 'sabhi_namaz',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamazGuideScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.handshake,
        title: context.tr('nazar_karika'),
        translationKey: 'nazar_karika',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NazarKarikaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.menu_book,
        title: context.tr('fatiha'),
        translationKey: 'fatiha',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FatihaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.water_drop,
        title: context.tr('wazu'),
        translationKey: 'wazu',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WazuScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.shower,
        title: context.tr('ghusl'),
        translationKey: 'ghusl',
        color: Colors.cyan,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GhuslScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.record_voice_over,
        title: context.tr('khutba'),
        translationKey: 'khutba',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KhutbaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.remove_red_eye,
        title: context.tr('nazar_e_bad'),
        translationKey: 'nazar_e_bad',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NazarEBadScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.campaign,
        title: context.tr('azan'),
        translationKey: 'azan',
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AzanScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.local_fire_department,
        title: context.tr('jahannam'),
        translationKey: 'jahannam',
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const JahannamFazilatScreen(),
          ),
        ),
      ),
      FeatureGridItem(
        icon: Icons.family_restroom,
        title: context.tr('family_fazilat'),
        translationKey: 'family_fazilat',
        color: Colors.pink,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FamilyFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.connect_without_contact,
        title: context.tr('relative_fazilat'),
        translationKey: 'relative_fazilat',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RelativeFazilatScreen(),
          ),
        ),
      ),
      FeatureGridItem(
        icon: Icons.landscape,
        title: context.tr('jannat'),
        translationKey: 'jannat',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JannatFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.warning,
        title: context.tr('gunha'),
        translationKey: 'gunha',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GunhaFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.star,
        title: context.tr('savab'),
        translationKey: 'savab',
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavabFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.mosque,
        title: context.tr('namaz_fazilat'),
        translationKey: 'namaz_fazilat',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamazFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.water,
        title: context.tr('zamzam'),
        translationKey: 'zamzam',
        color: Colors.lightBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZamzamFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calendar_today,
        title: context.tr('month_fazilat'),
        translationKey: 'month_fazilat',
        color: Colors.deepOrange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MonthNameFazilatScreen(),
          ),
        ),
      ),
    ];
  }

  List<FeatureGridItem> _getIslamicBooksList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.menu_book,
        title: context.tr('quran'),
        translationKey: 'quran',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuranScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sahih_bukhari'),
        translationKey: 'sahih_bukhari',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HadithBooksScreen(collection: HadithCollection.bukhari, collectionKey: 'bukhari', titleKey: 'sahih_bukhari')),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sahih_muslim'),
        translationKey: 'sahih_muslim',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HadithBooksScreen(collection: HadithCollection.muslim, collectionKey: 'muslim', titleKey: 'sahih_muslim')),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sunan_nasai'),
        translationKey: 'sunan_nasai',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HadithBooksScreen(collection: HadithCollection.nasai, collectionKey: 'nasai', titleKey: 'sunan_nasai')),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sunan_abu_dawud'),
        translationKey: 'sunan_abu_dawud',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HadithBooksScreen(collection: HadithCollection.abudawud, collectionKey: 'abudawud', titleKey: 'sunan_abu_dawud')),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('jami_tirmidhi'),
        translationKey: 'jami_tirmidhi',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HadithBooksScreen(collection: HadithCollection.tirmidhi, collectionKey: 'tirmidhi', titleKey: 'jami_tirmidhi')),
        ),
      ),
    ];
  }

  void _onMicPressed() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    // Get current language before async operations
    final currentLang = context.read<LanguageProvider>().languageCode;
    String localeId;

    switch (currentLang) {
      case 'ur':
        localeId = 'ur_PK'; // Urdu (Pakistan)
        break;
      case 'ar':
        localeId = 'ar_SA'; // Arabic (Saudi Arabia)
        break;
      case 'hi':
        localeId = 'hi_IN'; // Hindi (India)
        break;
      case 'en':
      default:
        localeId = 'en_US'; // English (US)
        break;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) {
            setState(() => _isListening = false);
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _isListening = false);
        }
      },
    );

    if (available && mounted) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult && mounted) {
            setState(() {
              _searchController.text = result.recognizedWords;
              _searchQuery = result.recognizedWords;
              _isListening = false;
            });
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: localeId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalendar.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  context.responsive.radiusSmall,
                ),
              ),
              padding: context.responsive.paddingAll(4),
              child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
            ),
            SizedBox(width: context.responsive.spaceSmall),
            Text(context.tr('app_name')),
          ],
        ),
        actions: [
          Consumer<AdhanProvider>(
            builder: (context, adhanProvider, _) {
              final unreadCount = adhanProvider.unreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.responsive.paddingAll(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            context.responsive.vSpaceMedium,

            // Header carousel with greeting cards
            _buildHeaderCarousel(hijriDate),
            context.responsive.vSpaceLarge,

            // Search Results Section (only shown when searching)
            if (_searchQuery.isNotEmpty) ...[
              AppDecorations.sectionTitle(
                context,
                title: context.tr('search_results'),
              ),
              context.responsive.vSpaceMedium,
              _buildSearchResultsGrid(context),
              context.responsive.vSpaceLarge,
            ],

            // Islamic Services & Tools
            AppDecorations.sectionTitle(
              context,
              title: context.tr('islamic_fast_halal'),
            ),
            context.responsive.vSpaceMedium,
            _buildMoreFeaturesGrid(context),
            context.responsive.vSpaceLarge,

            // Islamic Books Section
            AppDecorations.sectionTitle(
              context,
              title: context.tr('islamic_books'),
            ),
            context.responsive.vSpaceMedium,
            _buildIslamicBooksGrid(context),
            context.responsive.vSpaceLarge,

            // Islamic Names Section
            AppDecorations.sectionTitle(
              context,
              title: context.tr('islamic_names'),
            ),
            context.responsive.vSpaceMedium,
            _buildIslamicNamesGrid(context),
            context.responsive.vSpaceLarge,

            // Islamic Ibadaat & Farz Section
            AppDecorations.sectionTitle(
              context,
              title: context.tr('islamic_ibadat_farz'),
            ),
            context.responsive.vSpaceMedium,
            _buildIslamicIbadatFarzGrid(context),
            context.responsive.vSpaceLarge,

            // Deen Ki Buniyadi Amal Section
            AppDecorations.sectionTitle(
              context,
              title: context.tr('deen_buniyadi_amal'),
            ),
            context.responsive.vSpaceMedium,
            _buildBasicAmalGrid(context),
            context.responsive.vSpaceLarge,

            // Banner Ad at the end of content
            const BannerAdWidget(),
            context.responsive.vSpaceMedium,
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final responsive = context.responsive;
    return Container(
      decoration: AppDecorations.searchBar(context),
      child: Stack(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onSubmitted: _onSearch,
            textInputAction: TextInputAction.search,
            style: AppTextStyles.bodyLarge(context),
            decoration: InputDecoration(
              hintText: _isListening
                  ? context.tr('listening')
                  : context.tr('search_quran_duas_hadith'),
              hintStyle: AppTextStyles.bodyMedium(
                context,
                color: _isListening ? AppColors.primary : null,
              ),
              prefixIcon: _isListening
                  ? _buildWaveformAnimation()
                  : Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: responsive.iconSize(24),
                    ),
              suffixIcon: Container(
                margin: responsive.paddingAll(6),
                decoration: BoxDecoration(
                  color: _isListening ? Colors.red : AppColors.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  onPressed: _onMicPressed,
                  icon: Icon(
                    _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: responsive.iconSize(20),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: responsive.paddingSymmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformAnimation() {
    final responsive = context.responsive;
    return SizedBox(
      width: responsive.spacing(44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeInOut,
            width: responsive.spacing(3),
            height: _isListening
                ? responsive.spacing(12 + (index % 2) * 8)
                : responsive.spacing(4),
            margin: responsive.paddingSymmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(responsive.spacing(2)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeaderCarousel(HijriCalendar hijriDate) {
    final responsive = context.responsive;
    // Calculate card height based on weather data availability
    final double cardHeight = _weatherData != null ? 220.0 : 155.0;

    return Column(
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildGreetingCard(hijriDate);
                case 1:
                  return _buildNextNamazCard();
                case 2:
                  return _buildAdCard(isActive: _currentPage == 2);
                default:
                  return _buildGreetingCard(hijriDate);
              }
            },
          ),
        ),
        responsive.vSpaceSmall,
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_totalPages, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: responsive.paddingSymmetric(horizontal: 4),
              width: _currentPage == index ? 24.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildGreetingCard(HijriCalendar hijriDate) {
    final responsive = context.responsive;
    return Container(
      padding: responsive.paddingAll(16),
      decoration: AppDecorations.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: responsive.paddingAll(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.white,
                  size: responsive.iconSize(24),
                ),
              ),
              responsive.hSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('assalamu_alaikum'),
                      style: AppTextStyles.heading3(context),
                    ),
                    Text(
                      _getGreeting(context),
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          responsive.vSpaceMedium,
          Row(
            children: [
              // Regular Date (Left)
              Expanded(
                child: Container(
                  padding: responsive.paddingSymmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: AppDecorations.primaryContainer(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.primary,
                        size: responsive.fontSize(12),
                      ),
                      responsive.hSpaceXSmall,
                      Flexible(
                        child: Text(
                          '${_getTranslatedDay(context)}, ${DateTime.now().day} ${_getTranslatedMonth(context)}',
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              responsive.hSpaceSmall,
              // Hijri Date (Right)
              Expanded(
                child: Container(
                  padding: responsive.paddingSymmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: AppDecorations.primaryContainer(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mosque_rounded,
                        color: AppColors.primary,
                        size: responsive.fontSize(12),
                      ),
                      responsive.hSpaceXSmall,
                      Flexible(
                        child: Text(
                          '${hijriDate.hDay} ${_getTranslatedHijriMonth(context, hijriDate.longMonthName)}',
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Weather and Air Quality Section
          if (_weatherData != null) ...[
            responsive.vSpaceSmall,
            const Divider(height: 1),
            responsive.vSpaceSmall,
            Row(
              children: [
                // Weather Info
                Expanded(
                  child: Container(
                    padding: responsive.paddingAll(8),
                    decoration: AppDecorations.chip(
                      context,
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: responsive.radiusMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              WeatherService.getWeatherIcon(_weatherData!.icon),
                              color: AppColors.primary,
                              size: responsive.iconSize(24),
                            ),
                            responsive.hSpaceXSmall,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_weatherData!.temperature.round()}°C',
                                    style: AppTextStyles.heading3(context),
                                  ),
                                  Text(
                                    _getTranslatedWeatherDescription(
                                      context,
                                      _weatherData!.description,
                                    ),
                                    style: AppTextStyles.caption(context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        responsive.vSpaceXSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: responsive.fontSize(12),
                                  color: AppColors.textSecondary,
                                ),
                                responsive.hSpaceXSmall,
                                Text(
                                  '${_weatherData!.humidity}%',
                                  style: AppTextStyles.caption(context),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.air,
                                  size: responsive.fontSize(12),
                                  color: AppColors.textSecondary,
                                ),
                                responsive.hSpaceXSmall,
                                Text(
                                  '${_weatherData!.windSpeed.toStringAsFixed(1)} m/s',
                                  style: AppTextStyles.caption(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                responsive.hSpaceSmall,
                // Air Quality Info
                Expanded(
                  child: Container(
                    padding: responsive.paddingAll(8),
                    decoration: AppDecorations.chip(
                      context,
                      color: WeatherService.getAQIColor(
                        _weatherData!.aqi,
                      ).withValues(alpha: 0.1),
                      borderRadius: responsive.radiusMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.air_outlined,
                              color: WeatherService.getAQIColor(
                                _weatherData!.aqi,
                              ),
                              size: responsive.iconSize(20),
                            ),
                            responsive.hSpaceXSmall,
                            Expanded(
                              child: Text(
                                context.tr('air_quality'),
                                style: AppTextStyles.caption(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        responsive.vSpaceXSmall,
                        Text(
                          _getTranslatedAQILevel(
                            context,
                            _weatherData!.aqiLevel,
                          ),
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: WeatherService.getAQIColor(
                              _weatherData!.aqi,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'AQI: ${_weatherData!.aqi}',
                          style: AppTextStyles.caption(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else if (_isLoadingWeather) ...[
            responsive.vSpaceMedium,
            Center(
              child: SizedBox(
                height: responsive.spacing(20),
                width: responsive.spacing(20),
                child: CircularProgressIndicator(
                  strokeWidth: responsive.spacing(2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNextNamazCard() {
    final responsive = context.responsive;
    final double cardHeight = _weatherData != null ? 220.0 : 155.0;

    return Consumer<PrayerProvider>(
      builder: (context, prayerProvider, _) {
        final nextPrayerName = prayerProvider.nextPrayer.toLowerCase();
        final prayerTimes = prayerProvider.todayPrayerTimes;

        // All 5 prayers with their names and icons
        // On Friday, show Jummah instead of Dhuhr
        final isFriday = DateTime.now().weekday == 5;
        final prayers = [
          {'name': 'fajr', 'icon': Icons.wb_twilight},
          {
            'name': isFriday ? 'jummah' : 'dhuhr',
            'icon': isFriday ? Icons.mosque : Icons.wb_sunny,
          },
          {'name': 'asr', 'icon': Icons.sunny_snowing},
          {'name': 'maghrib', 'icon': Icons.nightlight_round},
          {'name': 'isha', 'icon': Icons.nights_stay},
        ];

        String getPrayerTime(String name) {
          if (prayerTimes == null) return '--:--';
          switch (name) {
            case 'fajr':
              return prayerTimes.fajr;
            case 'dhuhr':
            case 'jummah':
              return prayerTimes.dhuhr;
            case 'asr':
              return prayerTimes.asr;
            case 'maghrib':
              return prayerTimes.maghrib;
            case 'isha':
              return prayerTimes.isha;
            default:
              return '--:--';
          }
        }

        return Container(
          height: cardHeight,
          padding: responsive.paddingAll(12),
          decoration: AppDecorations.card(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: responsive.paddingAll(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.orange.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
                      ),
                    ),
                    child: Icon(
                      Icons.mosque_rounded,
                      color: Colors.white,
                      size: responsive.iconSize(20),
                    ),
                  ),
                  responsive.hSpaceSmall,
                  Text(
                    context.tr('prayer_times'),
                    style: AppTextStyles.heading3(context),
                  ),
                ],
              ),
              responsive.vSpaceSmall,
              // Prayer times list
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: prayers.map((prayer) {
                    final name = prayer['name'] as String;
                    final icon = prayer['icon'] as IconData;
                    // On Friday, if next prayer is dhuhr, highlight jummah instead
                    final isNext =
                        name == nextPrayerName ||
                        (isFriday &&
                            name == 'jummah' &&
                            nextPrayerName == 'dhuhr');
                    final time = getPrayerTime(name);

                    return Expanded(
                      child: Container(
                        margin: responsive.paddingSymmetric(horizontal: 2),
                        padding: responsive.paddingSymmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isNext
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(
                            responsive.radiusMedium,
                          ),
                          border: isNext
                              ? null
                              : Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon at top
                            Icon(
                              icon,
                              size: responsive.iconSize(isNext ? 24 : 20),
                              color: isNext ? Colors.white : AppColors.primary,
                            ),
                            // Name in center
                            Text(
                              context.tr(name),
                              style: AppTextStyles.caption(context).copyWith(
                                color: isNext
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isNext
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: responsive.fontSize(11),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Time at bottom
                            Text(
                              time,
                              style: AppTextStyles.bodySmall(context).copyWith(
                                color: isNext
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isNext
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: responsive.fontSize(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdCard({required bool isActive}) {
    final double cardHeight = _weatherData != null ? 220.0 : 155.0;

    // Full height/width ad card without header
    return isActive
        ? BannerAdWidget(key: const ValueKey('carousel_ad'), height: cardHeight)
        : Container(
            height: cardHeight,
            decoration: AppDecorations.card(context),
            child: Center(
              child: Icon(
                Icons.ads_click,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          );
  }

  Widget _buildSearchResultsGrid(BuildContext context) {
    final matchedFeatures = _getAllMatchedFeatures(context);

    // Show "no results found" message if search returns empty
    if (matchedFeatures.isEmpty) {
      return EmptyStateWidget(
        message: context.tr('no_results_found'),
        icon: Icons.search_off,
      );
    }

    return FeatureGridBuilder(items: matchedFeatures);
  }

  Widget _buildMoreFeaturesGrid(BuildContext context) {
    final features = _getMoreFeaturesList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildIslamicNamesGrid(BuildContext context) {
    final features = _getIslamicNamesList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildBasicAmalGrid(BuildContext context) {
    final features = _getBasicAmalList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildIslamicBooksGrid(BuildContext context) {
    final features = _getIslamicBooksList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildIslamicIbadatFarzGrid(BuildContext context) {
    final features = _getMainFeaturesList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }
}
