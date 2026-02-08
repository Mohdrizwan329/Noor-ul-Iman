import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../core/services/hijri_date_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/adhan_provider.dart';
import '../../core/services/weather_service.dart';
import '../../core/services/location_service.dart';
import '../../widgets/common/common_widgets.dart';
import '../../data/models/firestore_models.dart';
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
import '../mosque_finder/mosque_finder_screen.dart';
import '../halal_finder/halal_finder_screen.dart';
import '../ramadan/ramadan_tracker_screen.dart';
import '../hajj_guide/hajj_guide_screen.dart';
import '../notifications/notifications_screen.dart';
import '../fasting_times/fasting_times_screen.dart';
import '../greeting_cards/greeting_cards_screen.dart';
import '../islamic_names/islamic_names_list_screen.dart';
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
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  WeatherData? _weatherData;
  bool _isLoadingWeather = true;
  final ContentService _contentService = ContentService();

  // Home screen content loaded from Firebase
  HomeScreenContentFirestore? _homeContent;

  // Islamic events loaded from Firebase
  List<Map<String, dynamic>> _islamicEvents = [];

  // PageView carousel state
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  static const int _totalPages = 3;

  /// Map icon string name to Flutter IconData
  static IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'library_books':
        return Icons.library_books;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      case 'menu_book':
        return Icons.menu_book;
      case 'menu_book_rounded':
        return Icons.menu_book_rounded;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'wb_twilight':
        return Icons.wb_twilight;
      case 'mosque':
        return Icons.mosque;
      case 'restaurant':
        return Icons.restaurant;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'flight_takeoff':
        return Icons.flight_takeoff;
      case 'explore':
        return Icons.explore;
      case 'radio_button_checked':
        return Icons.radio_button_checked;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'calculate':
        return Icons.calculate;
      case 'star':
        return Icons.star;
      case 'stars':
        return Icons.stars;
      case 'person':
        return Icons.person;
      case 'people':
        return Icons.people;
      case 'account_balance':
        return Icons.account_balance;
      case 'favorite':
        return Icons.favorite;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'handshake':
        return Icons.handshake;
      case 'water_drop':
        return Icons.water_drop;
      case 'shower':
        return Icons.shower;
      case 'record_voice_over':
        return Icons.record_voice_over;
      case 'remove_red_eye':
        return Icons.remove_red_eye;
      case 'campaign':
        return Icons.campaign;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'connect_without_contact':
        return Icons.connect_without_contact;
      case 'landscape':
        return Icons.landscape;
      case 'warning':
        return Icons.warning;
      case 'water':
        return Icons.water;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'sunny_snowing':
        return Icons.sunny_snowing;
      case 'nightlight_round':
        return Icons.nightlight_round;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'brightness_2':
        return Icons.brightness_2;
      case 'celebration':
        return Icons.celebration;
      default:
        return Icons.circle;
    }
  }

  /// Parse hex color string to Color
  static Color _parseColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  /// Navigate to a feature screen using Firebase nav_params
  void _navigateToFeature(HomeFeatureItemFirestore feature) {
    final params = feature.navParams;
    final screenType = params?['screen_type'] as String?;

    Widget? screen;

    if (screenType == 'islamic_names') {
      screen = IslamicNamesListScreen(
        collectionKey: params!['collection_key'] as String,
        assetFileName: params['asset_file_name'] as String,
        titleKey: params['title_key'] as String,
        hasSearch: params['has_search'] as bool? ?? false,
        emptyStateKey: params['empty_state_key'] as String? ?? '',
        showPeriodInMeaning: params['show_period_in_meaning'] as bool? ?? false,
        showKunya: params['show_kunya'] as bool? ?? false,
        detailCategory: context.tr(params['detail_category_key'] as String),
        detailIcon: _mapIcon(params['detail_icon'] as String? ?? ''),
        detailColor: _parseColor(
          params['detail_color'] as String? ?? '#000000',
        ),
      );
    } else if (screenType == 'hadith') {
      final collectionStr = params!['hadith_collection'] as String;
      final collection = HadithCollection.values.firstWhere(
        (e) => e.name == collectionStr,
        orElse: () => HadithCollection.bukhari,
      );
      screen = HadithBooksScreen(
        collection: collection,
        collectionKey: params['collection_key'] as String,
        titleKey: params['title_key'] as String,
      );
    } else {
      screen = _getSimpleRouteScreen(feature.route);
    }

    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    }
  }

  /// Map simple route keys to screen widgets
  Widget? _getSimpleRouteScreen(String route) {
    switch (route) {
      case 'surah_list':
        return const SurahListScreen();
      case 'dua_category':
        return const DuaCategoryScreen();
      case 'seven_kalma':
        return const SevenKalmaScreen();
      case 'ramadan_tracker':
        return const RamadanTrackerScreen();
      case 'fasting_times':
        return const FastingTimesScreen();
      case 'mosque_finder':
        return const MosqueFinderScreen();
      case 'halal_finder':
        return const HalalFinderScreen();
      case 'greeting_cards':
        return const GreetingCardsScreen();
      case 'hajj_guide':
        return const HajjGuideScreen();
      case 'qibla':
        return const QiblaScreen();
      case 'tasbih':
        return const TasbihScreen();
      case 'calendar':
        return const CalendarScreen();
      case 'zakat_calculator':
        return const ZakatCalculatorScreen();
      case 'zakat_guide':
        return const ZakatGuideScreen();
      case 'names_of_allah':
        return const NamesOfAllahScreen();
      case 'quran':
        return const QuranScreen();
      case 'namaz_guide':
        return const NamazGuideScreen();
      case 'nazar_karika':
        return const NazarKarikaScreen();
      case 'fatiha':
        return const FatihaScreen();
      case 'wazu':
        return const WazuScreen();
      case 'ghusl':
        return const GhuslScreen();
      case 'khutba':
        return const KhutbaScreen();
      case 'nazar_e_bad':
        return const NazarEBadScreen();
      case 'azan':
        return const AzanScreen();
      case 'jahannam_fazilat':
        return const JahannamFazilatScreen();
      case 'family_fazilat':
        return const FamilyFazilatScreen();
      case 'relative_fazilat':
        return const RelativeFazilatScreen();
      case 'jannat_fazilat':
        return const JannatFazilatScreen();
      case 'gunha_fazilat':
        return const GunhaFazilatScreen();
      case 'savab_fazilat':
        return const SavabFazilatScreen();
      case 'namaz_fazilat':
        return const NamazFazilatScreen();
      case 'zamzam_fazilat':
        return const ZamzamFazilatScreen();
      case 'month_name_fazilat':
        return const MonthNameFazilatScreen();
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHomeContent();
    _loadLanguageNames();
    _loadNotificationStrings();
    _loadIslamicEvents();
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
    _fetchWeather();
    _startAutoScroll();
  }

  Future<void> _loadHomeContent() async {
    try {
      final content = await _contentService.getHomeScreenContent();
      if (content != null && mounted) {
        setState(() {
          _homeContent = content;
        });
      }
    } catch (e) {
      debugPrint('Home: Error loading home screen content: $e');
    }
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
      final reminderData = await _contentService.getNotificationStrings(
        'reminders',
      );
      if (reminderData.isNotEmpty) {
        IslamicReminderStrings.loadFromFirestore(reminderData);
      }
    } catch (e) {
      debugPrint('Home: Error loading notification strings: $e');
    }
  }

  Future<void> _loadIslamicEvents() async {
    try {
      final doc = await _contentService.getIslamicEvents();
      if (doc.isNotEmpty && mounted) {
        setState(() {
          _islamicEvents = doc;
        });
      }
    } catch (e) {
      debugPrint('Home: Error loading Islamic events: $e');
    }
  }

  /// Request all permissions required for background Azan
  Future<void> _requestAzanPermissions() async {
    final status = await AzanPermissionService.checkAllPermissions();
    debugPrint('Azan Permissions: $status');

    if (!status.notification && status.androidVersion >= 33) {
      await AzanPermissionService.requestNotificationPermission();
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    if (!status.exactAlarm && status.androidVersion >= 31) {
      await AzanPermissionService.requestExactAlarmPermission();
    }

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
      debugPrint('Starting weather fetch...');
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();

      if (position != null && mounted) {
        final weather = await WeatherService.getWeather(
          lat: position.latitude,
          lon: position.longitude,
        );

        if (mounted) {
          setState(() {
            _weatherData = weather;
            _isLoadingWeather = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingWeather = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
        });
      }
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

  String _getUserName() {
    final settings = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    // Check custom profile name (skip default 'User')
    final profileName = settings.profileName;
    if (profileName.isNotEmpty && profileName != 'User') {
      return profileName;
    }
    // Check auth display name (from Firestore/Firebase)
    final name = authProvider.displayName;
    if (name.isNotEmpty && name != 'User') {
      return name;
    }
    return context.tr('user');
  }

  String _getTranslatedDay(BuildContext context) {
    final now = DateTime.now();
    final content = _homeContent;
    if (content != null && content.dayKeys.length >= 7) {
      return context.tr(content.dayKeys[now.weekday - 1]);
    }
    return '';
  }

  String _getTranslatedMonth(BuildContext context) {
    final now = DateTime.now();
    final content = _homeContent;
    if (content != null && content.gregorianMonthKeys.length >= 12) {
      return context.tr(content.gregorianMonthKeys[now.month - 1]);
    }
    return '';
  }

  String _getTranslatedWeatherDescription(
    BuildContext context,
    String description,
  ) {
    final lowerDesc = description.toLowerCase().trim();
    final content = _homeContent;

    if (content != null && content.weatherMap.isNotEmpty) {
      final key = content.weatherMap[lowerDesc];
      if (key != null) {
        return context.tr(key);
      }
    }

    // Return capitalized description if not found
    return description
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }

  String _getTranslatedAQILevel(BuildContext context, String aqiLevel) {
    final content = _homeContent;

    if (content != null && content.aqiMap.isNotEmpty) {
      final key = content.aqiMap[aqiLevel];
      if (key != null) {
        return context.tr(key);
      }
    }

    return aqiLevel;
  }

  String _getTranslatedHijriMonth(BuildContext context, String monthName) {
    final content = _homeContent;

    if (content != null && content.hijriMonthMap.isNotEmpty) {
      final key = content.hijriMonthMap[monthName];
      if (key != null) {
        return context.tr(key);
      }
    }

    debugPrint('Hijri month not mapped: "$monthName"');
    return monthName;
  }

  void _onSearch(String query) {
    // Search happens via onChanged callback
  }

  /// Build FeatureGridItem list from a Firebase section
  List<FeatureGridItem> _buildSectionFeatures(String sectionKey) {
    final content = _homeContent;
    if (content == null) return [];

    final section = content.getSection(sectionKey);
    if (section == null) return [];

    return section.features.map((feature) {
      return FeatureGridItem(
        icon: _mapIcon(feature.icon),
        title: context.tr(feature.titleKey),
        translationKey: feature.titleKey,
        color: _parseColor(feature.color),
        emoji: feature.emoji,
        onTap: () => _navigateToFeature(feature),
      );
    }).toList();
  }

  // Sort features based on search query - matched items on top, rest below
  List<FeatureGridItem> _filterFeatures(List<FeatureGridItem> features) {
    if (_searchQuery.isEmpty) {
      return features;
    }

    final matchingFeatures = <FeatureGridItem>[];
    final nonMatchingFeatures = <FeatureGridItem>[];

    for (final feature in features) {
      bool matches = false;

      if (feature.translationKey != null) {
        matches = LanguageHelpers.matchesInAnyLanguage(
          context,
          feature.translationKey!,
          _searchQuery,
        );
      } else {
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
  List<FeatureGridItem> _getAllMatchedFeatures(BuildContext context) {
    if (_searchQuery.isEmpty) {
      return [];
    }

    final allMatchedFeatures = <FeatureGridItem>[];
    final content = _homeContent;
    if (content == null) return [];

    // Collect features from all sections loaded from Firebase
    for (final section in content.sections) {
      final features = _buildSectionFeatures(section.key);
      for (final feature in features) {
        bool matches = false;

        if (feature.translationKey != null) {
          matches = LanguageHelpers.matchesInAnyLanguage(
            context,
            feature.translationKey!,
            _searchQuery,
          );
        } else {
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

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriDateService.instance.getHijriNow();
    final content = _homeContent;

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

            // Sections from Firebase
            if (content != null)
              ...content.sections.expand(
                (section) => [
                  AppDecorations.sectionTitle(
                    context,
                    title: context.tr(section.titleKey),
                  ),
                  context.responsive.vSpaceMedium,
                  _buildSectionGrid(section.key),
                  context.responsive.vSpaceLarge,
                ],
              ),

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
              hintText: context.tr('search_quran_duas_hadith'),
              hintStyle: AppTextStyles.bodyMedium(context),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: responsive.iconSize(24),
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

  Widget _buildHeaderCarousel(HijriCalendar hijriDate) {
    final responsive = context.responsive;
    final double cardHeight = _weatherData != null ? 255.0 : 150.0;

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
                  return _buildUpcomingEventCard(hijriDate);
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
                      '${_getGreeting(context)}, ${_getUserName()}',
                      style: AppTextStyles.bodySmall(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          if (_weatherData != null)
            Expanded(
              child: Column(
                children: [
                  responsive.vSpaceSmall,
                  const Divider(height: 1),
                  responsive.vSpaceSmall,
                  Expanded(
                    child: Row(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      WeatherService.getWeatherIcon(
                                        _weatherData!.icon,
                                      ),
                                      color: AppColors.primary,
                                      size: responsive.iconSize(24),
                                    ),
                                    responsive.hSpaceXSmall,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_weatherData!.temperature.round()}${context.tr('C')}',
                                            style: AppTextStyles.heading3(
                                              context,
                                            ),
                                          ),
                                          Text(
                                            _getTranslatedWeatherDescription(
                                              context,
                                              _weatherData!.description,
                                            ),
                                            style: AppTextStyles.caption(
                                              context,
                                            ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          '${_weatherData!.windSpeed.toStringAsFixed(1)} ${context.tr('wind_speed_unit')}',
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  '${context.tr('aqi_label')}: ${_weatherData!.aqi}',
                                  style: AppTextStyles.caption(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (_isLoadingWeather)
            Expanded(
              child: Center(
                child: SizedBox(
                  height: responsive.spacing(20),
                  width: responsive.spacing(20),
                  child: CircularProgressIndicator(
                    strokeWidth: responsive.spacing(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNextNamazCard() {
    final responsive = context.responsive;
    final content = _homeContent;

    return Consumer<PrayerProvider>(
      builder: (context, prayerProvider, _) {
        final nextPrayerName = prayerProvider.nextPrayer.toLowerCase();
        final prayerTimes = prayerProvider.todayPrayerTimes;

        final isFriday = DateTime.now().weekday == 5;

        // Build prayer list from Firebase data
        final prayers = (content != null && content.prayers.isNotEmpty)
            ? content.prayers
                  .where((p) {
                    if (isFriday && p.key == 'dhuhr') return false;
                    if (!isFriday && p.key == 'jummah') return false;
                    return true;
                  })
                  .map((p) => {'name': p.key, 'icon': _mapIcon(p.icon)})
                  .toList()
            : <Map<String, dynamic>>[];

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
                            Icon(
                              icon,
                              size: responsive.iconSize(isNext ? 24 : 20),
                              color: isNext ? Colors.white : AppColors.primary,
                            ),
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

  /// Map icon string name from Firebase to Flutter IconData
  IconData _mapEventIcon(String? iconName) {
    final content = _homeContent;
    if (content != null && content.eventIconMap.containsKey(iconName)) {
      return _mapIcon(content.eventIconMap[iconName]!);
    }
    return _mapIcon(iconName ?? '');
  }

  Map<String, dynamic>? _getNextUpcomingEvent(HijriCalendar hijriDate) {
    final currentMonth = hijriDate.hMonth;
    final currentDay = hijriDate.hDay;

    for (final event in _islamicEvents) {
      final eMonth = event['month'] as int;
      final eDay = event['day'] as int;
      if (eMonth > currentMonth ||
          (eMonth == currentMonth && eDay >= currentDay)) {
        final daysLeft = _daysUntilEvent(
          currentMonth,
          currentDay,
          eMonth,
          eDay,
        );
        return {...event, 'daysLeft': daysLeft};
      }
    }
    if (_islamicEvents.isEmpty) return null;
    final first = _islamicEvents.first;
    final daysLeft = _daysUntilEvent(
      currentMonth,
      currentDay,
      (first['month'] as int) + 12,
      first['day'] as int,
    );
    return {...first, 'daysLeft': daysLeft};
  }

  int _daysUntilEvent(int fromMonth, int fromDay, int toMonth, int toDay) {
    int days = 0;
    if (fromMonth == toMonth) return toDay - fromDay;
    days += (30 - fromDay);
    for (int m = fromMonth + 1; m < toMonth; m++) {
      days += 30;
    }
    days += toDay;
    return days;
  }

  Widget _buildUpcomingEventCard(HijriCalendar hijriDate) {
    final responsive = context.responsive;
    final event = _getNextUpcomingEvent(hijriDate);
    final content = _homeContent;

    final eventKey = event?['key'] as String? ?? '';
    final eventName = context.tr('event_$eventKey');
    final eventIcon = event?['icon'] is IconData
        ? event!['icon'] as IconData
        : _mapEventIcon(event?['icon'] as String?);
    final daysLeft = event?['daysLeft'] as int? ?? 0;
    final eventMonth = event?['month'] as int? ?? 1;
    final eventDay = event?['day'] as int? ?? 1;

    // Use hijri month keys from Firebase
    String monthName = '';
    if (content != null &&
        content.hijriMonthKeys.length >= 12 &&
        eventMonth >= 1 &&
        eventMonth <= 12) {
      monthName = context.tr(content.hijriMonthKeys[eventMonth - 1]);
    }

    return Container(
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Icon(
                  Icons.event,
                  color: Colors.white,
                  size: responsive.iconSize(20),
                ),
              ),
              responsive.hSpaceSmall,
              Expanded(
                child: Text(
                  context.tr('upcoming_event'),
                  style: AppTextStyles.heading3(context),
                ),
              ),
              if (daysLeft > 0)
                Container(
                  padding: responsive.paddingSymmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$daysLeft ${context.tr('days_left')}',
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSize(11),
                    ),
                  ),
                )
              else
                Container(
                  padding: responsive.paddingSymmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.tr('today_event'),
                    style: AppTextStyles.caption(context).copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSize(11),
                    ),
                  ),
                ),
            ],
          ),
          responsive.vSpaceSmall,
          // Event details
          Expanded(
            child: Container(
              width: double.infinity,
              padding: responsive.paddingAll(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(
                    eventIcon,
                    size: responsive.iconSize(36),
                    color: const Color(0xFF6A1B9A),
                  ),
                  responsive.hSpaceMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          eventName,
                          style: AppTextStyles.heading3(context).copyWith(
                            color: const Color(0xFF6A1B9A),
                            fontSize: responsive.fontSize(16),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$eventDay $monthName',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: AppColors.textSecondary,
                            fontSize: responsive.fontSize(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsGrid(BuildContext context) {
    final matchedFeatures = _getAllMatchedFeatures(context);

    if (matchedFeatures.isEmpty) {
      return EmptyStateWidget(
        message: context.tr('no_results_found'),
        icon: Icons.search_off,
      );
    }

    return FeatureGridBuilder(items: matchedFeatures);
  }

  Widget _buildSectionGrid(String sectionKey) {
    final features = _buildSectionFeatures(sectionKey);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }
}
