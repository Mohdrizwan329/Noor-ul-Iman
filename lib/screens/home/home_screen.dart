import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/theme_extensions.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/common/common_widgets.dart';
import '../quran/quran_screen.dart';
import '../quran/surah_list_screen.dart';
import '../qibla/qibla_screen.dart';
import '../tasbih/tasbih_screen.dart';
import '../dua/dua_category_screen.dart';
import '../calendar/calendar_screen.dart';
import '../names_of_allah/names_of_allah_screen.dart';
import '../hadith/sahih_bukhari_screen.dart';
import '../hadith/sahih_muslim_screen.dart';
import '../hadith/sunan_nasai_screen.dart';
import '../hadith/sunan_abu_dawud_screen.dart';
import '../hadith/jami_tirmidhi_screen.dart';
import '../zakat_calculator/zakat_calculator_screen.dart';
// New feature imports
import '../mosque_finder/mosque_finder_screen.dart';
import '../halal_finder/halal_finder_screen.dart';
import '../ramadan/ramadan_tracker_screen.dart';
import '../hajj_guide/hajj_guide_screen.dart';
import '../notifications/notifications_screen.dart';
import '../fasting_times/fasting_times_screen.dart';
import '../greeting_cards/greeting_cards_screen.dart';
// Islamic Names imports
import '../islamic_names/nabi_names_screen.dart';
import '../islamic_names/sahaba_names_screen.dart';
import '../islamic_names/khalifa_names_screen.dart';
import '../islamic_names/twelve_imams_screen.dart';
import '../islamic_names/panjatan_screen.dart';
import '../islamic_names/ahlebait_screen.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerProvider>().initialize();
    });
    _initSpeech();
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
  List<FeatureGridItem> _filterFeatures(List<FeatureGridItem> features) {
    if (_searchQuery.isEmpty) {
      return features;
    }

    final query = _searchQuery.toLowerCase();
    final matchingFeatures = <FeatureGridItem>[];
    final nonMatchingFeatures = <FeatureGridItem>[];

    for (final feature in features) {
      if (feature.title.toLowerCase().contains(query)) {
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

    final query = _searchQuery.toLowerCase();
    final allMatchedFeatures = <FeatureGridItem>[];

    // Collect all features from all sections
    final allFeatureLists = [
      _getMainFeaturesList(context),
      _getMoreFeaturesList(context),
      _getIslamicNamesList(context),
      _getBasicAmalList(context),
      _getIslamicBooksList(context),
    ];

    // Filter and collect matched items
    for (final featureList in allFeatureLists) {
      for (final feature in featureList) {
        if (feature.title.toLowerCase().contains(query)) {
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
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SurahListScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.volunteer_activism,
        title: context.tr('duas'),
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
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RamadanTrackerScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.wb_twilight,
        title: context.tr('fasting'),
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FastingTimesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.mosque,
        title: context.tr('mosques'),
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MosqueFinderScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.restaurant,
        title: context.tr('halal'),
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalalFinderScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.card_giftcard,
        title: context.tr('status'),
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
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HajjGuideScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.explore,
        title: context.tr('qibla'),
        color: AppColors.compassNeedle,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QiblaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.radio_button_checked,
        title: context.tr('tasbih'),
        color: AppColors.secondary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TasbihScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calendar_month,
        title: context.tr('calendar'),
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calculate,
        title: context.tr('zakat'),
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ZakatCalculatorScreen(),
          ),
        ),
      ),
    ];
  }


  List<FeatureGridItem> _getIslamicNamesList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.star,
        title: context.tr('names_of_allah'),
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamesOfAllahScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.person,
        title: context.tr('nabi_names'),
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NabiNamesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.people,
        title: context.tr('sahaba_names'),
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SahabaNamesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.account_balance,
        title: context.tr('khalifa_names'),
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KhalifaNamesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.stars,
        title: context.tr('twelve_imams'),
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TwelveImamsScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.favorite,
        title: context.tr('panjatan'),
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PanjatanScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.family_restroom,
        title: context.tr('ahlebait'),
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AhlebaitScreen()),
        ),
      ),
    ];
  }

  List<FeatureGridItem> _getBasicAmalList(BuildContext context) {
    return [
      FeatureGridItem(
        icon: Icons.mosque,
        title: context.tr('sabhi_namaz'),
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamazGuideScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.handshake,
        title: context.tr('nazar_karika'),
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NazarKarikaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.menu_book,
        title: context.tr('fatiha'),
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FatihaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.water_drop,
        title: context.tr('wazu'),
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WazuScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.shower,
        title: context.tr('ghusl'),
        color: Colors.cyan,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GhuslScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.record_voice_over,
        title: context.tr('khutba'),
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KhutbaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.remove_red_eye,
        title: context.tr('nazar_e_bad'),
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NazarEBadScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.campaign,
        title: context.tr('azan'),
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AzanScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.local_fire_department,
        title: context.tr('jahannam'),
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
        color: Colors.pink,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FamilyFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.connect_without_contact,
        title: context.tr('relative_fazilat'),
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
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JannatFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.warning,
        title: context.tr('gunha'),
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GunhaFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.star,
        title: context.tr('savab'),
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavabFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.mosque,
        title: context.tr('namaz_fazilat'),
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamazFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.water,
        title: context.tr('zamzam'),
        color: Colors.lightBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZamzamFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calendar_today,
        title: context.tr('month_fazilat'),
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
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuranScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sahih_bukhari'),
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SahihBukhariScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sahih_muslim'),
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SahihMuslimScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sunan_nasai'),
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SunanNasaiScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('sunan_abu_dawud'),
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SunanAbuDawudScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: context.tr('jami_tirmidhi'),
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JamiTirmidhiScreen()),
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

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr('error')}: ${error.errorMsg}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );

    if (available) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              _searchController.text = result.recognizedWords;
              _searchQuery = result.recognizedWords;
              _isListening = false;
            });
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('speech_recognition_not_available')),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalendar.now();
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
            ),
            const SizedBox(width: 8),
            Text(context.tr('app_name')),
          ],
        ),
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(isDark),
            const SizedBox(height: 16),

            // Header with greeting
            _buildHeader(hijriDate, isDark),
            const SizedBox(height: 20),

            // Search Results Section (only shown when searching)
            if (_searchQuery.isNotEmpty) ...[
              _buildSectionTitle(context.tr('search_results'), isDark),
              const SizedBox(height: 12),
              _buildSearchResultsGrid(context, isDark),
              const SizedBox(height: 20),
            ],

            // Islamic Services & Tools
            _buildSectionTitle(context.tr('islamic_fast_halal'), isDark),
            const SizedBox(height: 12),
            _buildMoreFeaturesGrid(context, isDark),
            const SizedBox(height: 20),

            // Islamic Books Section
            _buildSectionTitle(context.tr('islamic_books'), isDark),
            const SizedBox(height: 12),
            _buildIslamicBooksGrid(context, isDark),
            const SizedBox(height: 20),

            // Islamic Names Section
            _buildSectionTitle(context.tr('islamic_names'), isDark),
            const SizedBox(height: 12),
            _buildIslamicNamesGrid(context, isDark),
            const SizedBox(height: 20),

            // Islamic Ibadaat & Farz Section
            _buildSectionTitle(context.tr('islamic_ibadat_farz'), isDark),
            const SizedBox(height: 12),
            _buildIslamicIbadatFarzGrid(context, isDark),
            const SizedBox(height: 20),

            // Deen Ki Buniyadi Amal Section
            _buildSectionTitle(context.tr('deen_buniyadi_amal'), isDark),
            const SizedBox(height: 12),
            _buildBasicAmalGrid(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
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
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: _isListening
                  ? context.tr('listening')
                  : context.tr('search_quran_duas_hadith'),
              hintStyle: TextStyle(
                color: _isListening
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textHint),
                fontSize: 14,
              ),
              prefixIcon: _isListening
                  ? _buildWaveformAnimation()
                  : Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
              suffixIcon: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _isListening ? Colors.red : AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: _onMicPressed,
                  icon: Icon(
                    _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkCard : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
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
    return SizedBox(
      width: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeInOut,
            width: 3,
            height: _isListening ? (12 + (index % 2) * 8) : 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(HijriCalendar hijriDate, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('assalamu_alaikum'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.primary,
                      ),
                    ),
                    Text(
                      _getGreeting(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  '${hijriDate.hDay} ${_getTranslatedHijriMonth(context, hijriDate.longMonthName)} ${hijriDate.hYear} ${context.tr('ah')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsGrid(BuildContext context, bool isDark) {
    final matchedFeatures = _getAllMatchedFeatures(context);
    return FeatureGridBuilder(items: matchedFeatures);
  }

  Widget _buildMoreFeaturesGrid(BuildContext context, bool isDark) {
    final features = _getMoreFeaturesList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildIslamicNamesGrid(BuildContext context, bool isDark) {
    final features = _getIslamicNamesList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildBasicAmalGrid(BuildContext context, bool isDark) {
    final features = _getBasicAmalList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildIslamicBooksGrid(BuildContext context, bool isDark) {
    final features = _getIslamicBooksList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }

  Widget _buildIslamicIbadatFarzGrid(BuildContext context, bool isDark) {
    final features = _getMainFeaturesList(context);
    final filteredFeatures = _filterFeatures(features);
    return FeatureGridBuilder(items: filteredFeatures);
  }
}
