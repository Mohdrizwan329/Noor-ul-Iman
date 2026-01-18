import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/theme_extensions.dart';
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
import '../greeting_cards/greeting_cards_screen.dart';
import '../prayer_requests/prayer_requests_screen.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../hajj_guide/hajj_guide_screen.dart';
import '../notifications/notifications_screen.dart';
import '../fasting_times/fasting_times_screen.dart';
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;

    // Navigate to AI Chat with the search query
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiChatScreen()),
    );
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
            content: Text('Error: ${error.errorMsg}'),
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
      _showListeningDialog();
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            Navigator.of(context).pop(); // Close dialog
            setState(() {
              _searchController.text = result.recognizedWords;
              _isListening = false;
            });
            if (result.recognizedWords.isNotEmpty) {
              _onSearch(result.recognizedWords);
            }
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
            content: const Text(
              'Speech recognition not available. Please enable microphone permission.',
            ),
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

  void _showListeningDialog() {
    ListeningDialog.show(
      context,
      onCancel: () {
        _speech.stop();
        setState(() => _isListening = false);
      },
    ).then((_) {
      if (_isListening) {
        _speech.stop();
        setState(() => _isListening = false);
      }
    });
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
            const Text('Jiyan Islamic Academy'),
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

            // Islamic Services & Tools
            _buildSectionTitle('Islamic Fast & Halal', isDark),
            const SizedBox(height: 12),
            _buildMoreFeaturesGrid(context, isDark),
            const SizedBox(height: 20),

            // Islamic Books Section
            _buildSectionTitle('Islamic Books', isDark),
            const SizedBox(height: 12),
            _buildIslamicBooksGrid(context, isDark),
            const SizedBox(height: 20),

            // Islamic Names Section
            _buildSectionTitle('Islamic Names', isDark),
            const SizedBox(height: 12),
            _buildIslamicNamesGrid(context, isDark),
            const SizedBox(height: 20),

            // Main Features
            _buildSectionTitle('Islamic Ibadat aur Farz', isDark),
            const SizedBox(height: 12),
            _buildMainFeaturesGrid(context, isDark),
            const SizedBox(height: 20),

            // Deen Ki Buniyadi Amal Section
            _buildSectionTitle('Deen Ki Buniyadi Amal', isDark),
            const SizedBox(height: 12),
            _buildBasicAmalGrid(context, isDark),
            const SizedBox(height: 20),

            // Tools & Utilities
            _buildSectionTitle('Tools & Utilities', isDark),
            const SizedBox(height: 12),
            _buildToolsGrid(context, isDark),
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
      child: TextField(
        controller: _searchController,
        onSubmitted: _onSearch,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search Quran, Duas, Hadith...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textHint,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: _onMicPressed,
              icon: const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
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
                      'Assalamu Alaikum',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.primary,
                      ),
                    ),
                    Text(
                      _getGreeting(),
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
                  '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH',
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

  Widget _buildMainFeaturesGrid(BuildContext context, bool isDark) {
    final features = [
      FeatureGridItem(
        icon: Icons.library_books,
        title: 'Surah',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SurahListScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.explore,
        title: 'Qibla',
        color: AppColors.compassNeedle,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QiblaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.radio_button_checked,
        title: 'Tasbih',
        color: AppColors.secondary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TasbihScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.volunteer_activism,
        title: 'Duas',
        color: Colors.pink,
        emoji: '🤲',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DuaCategoryScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calendar_month,
        title: 'Calendar',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calculate,
        title: 'Zakat',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ZakatCalculatorScreen(),
          ),
        ),
      ),
      FeatureGridItem(
        icon: Icons.menu_book,
        title: '7 Kalma',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SevenKalmaScreen()),
        ),
      ),
    ];

    return FeatureGridBuilder(items: features);
  }

  Widget _buildMoreFeaturesGrid(BuildContext context, bool isDark) {
    final features = [
      FeatureGridItem(
        icon: Icons.nights_stay,
        title: 'Ramadan',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RamadanTrackerScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.wb_twilight,
        title: 'Fasting',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FastingTimesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.mosque,
        title: 'Mosques',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MosqueFinderScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.restaurant,
        title: 'Halal',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalalFinderScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.flight_takeoff,
        title: 'Hajj Guide',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HajjGuideScreen()),
        ),
      ),
    ];

    return FeatureGridBuilder(items: features);
  }

  Widget _buildToolsGrid(BuildContext context, bool isDark) {
    final features = [
      FeatureGridItem(
        icon: Icons.card_giftcard,
        title: 'Cards',
        color: Colors.pink,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GreetingCardsScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.volunteer_activism,
        title: 'Prayers',
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrayerRequestsScreen()),
        ),
      ),
    ];

    return FeatureGridBuilder(items: features);
  }

  Widget _buildIslamicNamesGrid(BuildContext context, bool isDark) {
    final features = [
      FeatureGridItem(
        icon: Icons.star,
        title: 'Allah Names',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamesOfAllahScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.person,
        title: 'Nabi Names',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NabiNamesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.people,
        title: 'Sahaba Names',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SahabaNamesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.account_balance,
        title: 'Khalifa Names',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KhalifaNamesScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.stars,
        title: '12 Imamam',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TwelveImamsScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.favorite,
        title: 'Panjatan',
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PanjatanScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.family_restroom,
        title: 'Ahlebait',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AhlebaitScreen()),
        ),
      ),
    ];

    return FeatureGridBuilder(items: features);
  }

  Widget _buildBasicAmalGrid(BuildContext context, bool isDark) {
    final features = [
      FeatureGridItem(
        icon: Icons.mosque,
        title: 'Sabhi Namaz',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamazGuideScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.handshake,
        title: 'Nazar Karika',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NazarKarikaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.menu_book,
        title: 'Fatiha',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FatihaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.water_drop,
        title: 'Wazu',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WazuScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.shower,
        title: 'Ghusl',
        color: Colors.cyan,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GhuslScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.record_voice_over,
        title: 'Khutba',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KhutbaScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.remove_red_eye,
        title: 'Nazar-e-Bad',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NazarEBadScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.campaign,
        title: 'Azan',
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AzanScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.local_fire_department,
        title: 'Jahannam',
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
        title: 'Family',
        color: Colors.pink,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FamilyFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.connect_without_contact,
        title: 'Relatives',
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
        title: 'Jannat',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JannatFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.warning,
        title: 'Gunha',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GunhaFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.star,
        title: 'Savab',
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavabFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.mosque,
        title: 'Namaz Fazilat',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NamazFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.water,
        title: 'Zamzam',
        color: Colors.lightBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZamzamFazilatScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.calendar_today,
        title: 'Month Fazilat',
        color: Colors.deepOrange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MonthNameFazilatScreen(),
          ),
        ),
      ),
    ];

    return FeatureGridBuilder(items: features);
  }

  Widget _buildIslamicBooksGrid(BuildContext context, bool isDark) {
    final features = [
      FeatureGridItem(
        icon: Icons.menu_book,
        title: 'Quran',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuranScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: 'Bukhari',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SahihBukhariScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: 'Muslim',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SahihMuslimScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: 'Nasai',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SunanNasaiScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: 'Abu Dawud',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SunanAbuDawudScreen()),
        ),
      ),
      FeatureGridItem(
        icon: Icons.auto_stories,
        title: 'Tirmidhi',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JamiTirmidhiScreen()),
        ),
      ),
    ];

    return FeatureGridBuilder(items: features);
  }
}
