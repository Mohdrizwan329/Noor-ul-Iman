import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/utils/app_utils.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';
import '../../data/models/dua_model.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/data_migration_service.dart';
import '../../data/models/firestore_models.dart';

class FastingTimesScreen extends StatefulWidget {
  const FastingTimesScreen({super.key});

  @override
  State<FastingTimesScreen> createState() => _FastingTimesScreenState();
}

class _FastingTimesScreenState extends State<FastingTimesScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  Timer? _midnightTimer;
  bool _isFastingTime = false;
  DateTime _lastCheckedDate = DateTime.now();

  // Track which month cards are expanded
  final Set<int> _expandedMonths = {};

  // TTS and language
  final FlutterTts _flutterTts = FlutterTts();
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;
  int? _playingDuaIndex;
  bool _isSpeaking = false;
  final Set<int> _expandedDuas = {};

  // Firestore
  List<Map<String, dynamic>>? _firestoreFastingDuas;
  List<Map<String, dynamic>>? _firestoreVirtues;
  Map<String, dynamic>? _firestoreRules;
  Map<String, dynamic>? _firestoreMonths;
  bool _isDuasLoading = true;
  bool _isVirtuesLoading = true;
  bool _isRulesLoading = true;
  bool _isMonthsLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
    _startMidnightTimer();
    _initTts();
    _initializePrayerTimes();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    if (mounted) {
      setState(() {
        _isDuasLoading = true;
        _isVirtuesLoading = true;
        _isRulesLoading = true;
        _isMonthsLoading = true;
      });
    }

    final migrationService = DataMigrationService();
    final firestore = FirebaseFirestore.instance;

    // Load all 4 docs in parallel
    try {
      final results = await Future.wait([
        firestore.collection('fasting_data').doc('fasting_duas').get(),
        firestore.collection('fasting_data').doc('fasting_virtues').get(),
        firestore.collection('fasting_data').doc('fasting_rules').get(),
        firestore.collection('fasting_data').doc('islamic_months').get(),
      ]);

      var duasDoc = results[0];
      var virtuesDoc = results[1];
      var rulesDoc = results[2];
      var monthsDoc = results[3];

      // Auto-push any missing data
      bool needsRefetch = false;
      if (!duasDoc.exists || (duasDoc.data()?['duas'] as List?)?.isEmpty != false) {
        await migrationService.migrateFastingData();
        needsRefetch = true;
      }
      if (!virtuesDoc.exists || (virtuesDoc.data()?['virtues'] as List?)?.isEmpty != false) {
        await migrationService.migrateFastingVirtues();
        needsRefetch = true;
      }
      if (!rulesDoc.exists || rulesDoc.data()?['breaks_fast'] == null) {
        await migrationService.migrateFastingRules();
        needsRefetch = true;
      }
      if (!monthsDoc.exists || (monthsDoc.data()?['months'] as List?)?.isEmpty != false) {
        await migrationService.migrateIslamicMonths();
        needsRefetch = true;
      }

      if (needsRefetch) {
        final refreshed = await Future.wait([
          firestore.collection('fasting_data').doc('fasting_duas').get(),
          firestore.collection('fasting_data').doc('fasting_virtues').get(),
          firestore.collection('fasting_data').doc('fasting_rules').get(),
          firestore.collection('fasting_data').doc('islamic_months').get(),
        ]);
        duasDoc = refreshed[0];
        virtuesDoc = refreshed[1];
        rulesDoc = refreshed[2];
        monthsDoc = refreshed[3];
      }

      if (!mounted) return;

      // Parse duas
      if (duasDoc.exists) {
        final firestoreDuas = (duasDoc.data()!['duas'] as List<dynamic>? ?? [])
            .map((d) => FastingDuaFirestore.fromJson(d as Map<String, dynamic>))
            .toList();
        if (firestoreDuas.isNotEmpty) {
          _firestoreFastingDuas = firestoreDuas.map((dua) {
            final colorHex = dua.color;
            Color color = const Color(0xFF1565C0);
            if (colorHex.isNotEmpty) {
              try {
                color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
              } catch (_) {}
            }
            return <String, dynamic>{
              'titleKey': dua.titleKey,
              'title': {
                'en': dua.title.en.isNotEmpty ? dua.title.en : dua.titleKey,
                'ur': dua.title.ur,
                'hi': dua.title.hi,
                'ar': dua.title.ar,
              },
              'arabic': dua.arabic,
              'transliteration': dua.transliteration,
              'hindi': dua.translation.get('hi'),
              'english': dua.translation.get('en'),
              'urdu': dua.translation.get('ur'),
              'ar': dua.translation.get('ar'),
              'color': color,
              if (dua.reference != null) 'reference': dua.reference,
            };
          }).toList();
        }
      }

      // Parse virtues
      if (virtuesDoc.exists) {
        _firestoreVirtues = (virtuesDoc.data()!['virtues'] as List<dynamic>? ?? [])
            .map((v) => v as Map<String, dynamic>)
            .toList();
      }

      // Parse rules
      if (rulesDoc.exists) {
        _firestoreRules = rulesDoc.data();
      }

      // Parse islamic months
      if (monthsDoc.exists) {
        _firestoreMonths = monthsDoc.data();
      }

      setState(() {
        _isDuasLoading = false;
        _isVirtuesLoading = false;
        _isRulesLoading = false;
        _isMonthsLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading fasting data from Firestore: $e');
      if (mounted) {
        setState(() {
          _isDuasLoading = false;
          _isVirtuesLoading = false;
          _isRulesLoading = false;
          _isMonthsLoading = false;
        });
      }
    }
  }

  /// Get translated text from a 4-lang map based on app language
  String _tr(dynamic multiLangMap, {String fallback = ''}) {
    if (multiLangMap is! Map) return fallback;
    final code = context.read<LanguageProvider>().languageCode;
    final val = multiLangMap[code] as String? ?? '';
    return val.isNotEmpty ? val : (multiLangMap['en'] as String? ?? fallback);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkAndRefreshIfNeeded();
    }
  }

  void _checkAndRefreshIfNeeded() {
    final now = DateTime.now();
    if (now.day != _lastCheckedDate.day ||
        now.month != _lastCheckedDate.month ||
        now.year != _lastCheckedDate.year) {
      setState(() {
        _lastCheckedDate = now;
      });
      _refreshPrayerTimes();
    }
  }

  void _initializePrayerTimes() {
    final prayerProvider = context.read<PrayerProvider>();
    if (prayerProvider.todayPrayerTimes == null) {
      prayerProvider.initialize();
    }
  }

  void _startMidnightTimer() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = tomorrow.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      if (mounted) {
        setState(() {
          _lastCheckedDate = DateTime.now();
        });
        _refreshPrayerTimes();
        _startMidnightTimer(); // Restart for next day
      }
    });
  }

  Future<void> _refreshPrayerTimes() async {
    final prayerProvider = context.read<PrayerProvider>();
    await prayerProvider.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLanguageWithApp();
  }

  void _syncLanguageWithApp() {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final appLanguage = languageProvider.languageCode;

    setState(() {
      switch (appLanguage) {
        case 'hi':
          _selectedLanguage = DuaLanguage.hindi;
        case 'en':
          _selectedLanguage = DuaLanguage.english;
        case 'ur':
          _selectedLanguage = DuaLanguage.urdu;
        case 'ar':
          _selectedLanguage = DuaLanguage.arabic;
        default:
          _selectedLanguage = DuaLanguage.hindi;
      }
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingDuaIndex = null;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingDuaIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _midnightTimer?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  void _startTimer() {
    _updateCountdowns();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdowns();
    });
  }

  void _updateCountdowns() {
    final prayerProvider = context.read<PrayerProvider>();
    final prayerTimes = prayerProvider.todayPrayerTimes;

    if (prayerTimes == null) return;

    final now = DateTime.now();
    final fajrTime = _parseTime(prayerTimes.fajr);
    final maghribTime = _parseTime(prayerTimes.maghrib);

    if (fajrTime == null || maghribTime == null) return;

    setState(() {
      if (now.isBefore(fajrTime)) {
        _isFastingTime = false;
      } else if (now.isBefore(maghribTime)) {
        _isFastingTime = true;
      } else {
        _isFastingTime = false;
      }
    });
  }

  DateTime? _parseTime(String timeStr) {
    try {
      // Remove AM/PM and extra spaces
      String cleanTime = timeStr.trim().replaceAll(
        RegExp(r'\s*(AM|PM)\s*', caseSensitive: false),
        '',
      );

      final parts = cleanTime.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0].trim());
        // Extract only numeric part from minute string
        final minuteStr = parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '');
        if (minuteStr.isEmpty) return null;

        final minute = int.parse(minuteStr);
        final now = DateTime.now();

        // Convert to 24-hour format if needed
        int hour24 = hour;
        if (timeStr.toUpperCase().contains('PM') && hour != 12) {
          hour24 = hour + 12;
        } else if (timeStr.toUpperCase().contains('AM') && hour == 12) {
          hour24 = 0;
        }

        return DateTime(now.year, now.month, now.day, hour24, minute);
      }
    } catch (e) {
      debugPrint('Error parsing time "$timeStr": $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final prayerProvider = context.watch<PrayerProvider>();
    final prayerTimes = prayerProvider.todayPrayerTimes;
    final hijriDate = HijriCalendar.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('fasting_times'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: prayerProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : prayerTimes == null
                ? _buildNoDataView(responsive)
                : SingleChildScrollView(
                    padding: responsive.paddingRegular,
                    child: Column(
                      children: [
                        // Location Banner
                        _buildLocationBanner(responsive),
                        SizedBox(height: responsive.spaceMedium),

                        // Current Month Fasting Dates
                        _buildCurrentMonthFastingCard(hijriDate, responsive),
                        SizedBox(height: responsive.spaceLarge),

                        // Current Status Card
                        _buildStatusCard(responsive),
                        SizedBox(height: responsive.spaceLarge),

                        // Suhoor & Iftar Times
                        _buildTimesRow(
                          prayerTimes.fajr,
                          prayerTimes.maghrib,
                          responsive,
                        ),
                        SizedBox(height: responsive.spaceLarge),

                        // Dua Cards
                        _buildDuaSection(responsive),
                        SizedBox(height: responsive.spaceLarge),

                        // Fasting Virtues Section
                        _buildFastingVirtuesSection(responsive),
                        SizedBox(height: responsive.spaceLarge),

                        // Fasting Rules Section
                        _buildFastingRulesSection(responsive),
                        SizedBox(height: responsive.spaceLarge),

                        // Islamic 12 Months Fasting Chart
                        _buildIslamicMonthsChart(responsive),
                      ],
                    ),
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildNoDataView(ResponsiveUtils responsive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: responsive.iconXXLarge,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: responsive.spaceRegular),
          Text(
            context.tr('unable_load_prayer_times'),
            style: TextStyle(
              fontSize: responsive.textLarge,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: responsive.spaceSmall),
          Text(
            context.tr('enable_location_services'),
            style: TextStyle(
              fontSize: responsive.textMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner(ResponsiveUtils responsive) {
    final locationService = LocationService();
    final city = locationService.currentCity;
    final country = locationService.currentCountry;
    final position = locationService.currentPosition;

    String locationText;
    if (city != null && city.isNotEmpty) {
      locationText = country != null && country.isNotEmpty
          ? '$city, $country'
          : city;
    } else if (position != null) {
      locationText = '${position.latitude.toStringAsFixed(2)}°, ${position.longitude.toStringAsFixed(2)}°';
    } else {
      locationText = context.tr('loading');
    }

    return Container(
      width: double.infinity,
      padding: responsive.paddingSymmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight.withValues(alpha: 0.15), AppColors.primary.withValues(alpha: 0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.primaryLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: responsive.paddingAll(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: responsive.iconSize(20),
            ),
          ),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    locationText,
                    style: TextStyle(
                      fontSize: responsive.fontSize(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: responsive.spacing(2)),
                Text(
                  '${context.tr('calculation_method')}: Karachi',
                  style: TextStyle(
                    fontSize: responsive.fontSize(11),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await _refreshPrayerTimes();
              if (mounted) {
                setState(() {});
              }
            },
            icon: Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: responsive.iconSize(22),
            ),
            tooltip: context.tr('refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ResponsiveUtils responsive) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: _isFastingTime
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(responsive.radiusXLarge),
        border: Border.all(
          color: _isFastingTime ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isFastingTime ? Icons.check_circle : Icons.access_time,
            color: _isFastingTime ? Colors.green : Colors.orange,
            size: responsive.iconLarge,
          ),
          SizedBox(width: responsive.spaceMedium),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _isFastingTime
                    ? context.tr('currently_fasting')
                    : context.tr('not_fasting_time'),
                style: TextStyle(
                  fontSize: responsive.textXLarge,
                  fontWeight: FontWeight.bold,
                  color: _isFastingTime ? Colors.green : Colors.orange,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimesRow(
    String suhoorEnd,
    String iftarTime,
    ResponsiveUtils responsive,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeCard(
            context.tr('suhoor_ends'),
            suhoorEnd,
            Icons.wb_twilight,
            const Color(0xFF3949AB),
            responsive,
          ),
        ),
        SizedBox(width: responsive.spaceMedium),
        Expanded(
          child: _buildTimeCard(
            context.tr('iftar_time'),
            iftarTime,
            Icons.nights_stay,
            const Color(0xFFE65100),
            responsive,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(
    String label,
    String time,
    IconData icon,
    Color color,
    ResponsiveUtils responsive,
  ) {
    return Container(
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.spaceMedium),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: responsive.iconLarge),
          ),
          SizedBox(height: responsive.spaceMedium),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.textSmall,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: responsive.spaceXSmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              time,
              style: TextStyle(
                fontSize: responsive.textTitle,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDuaExpanded(int index) {
    setState(() {
      if (_expandedDuas.contains(index)) {
        _expandedDuas.remove(index);
      } else {
        _expandedDuas.add(index);
      }
    });
  }

  String _getDuaTitle(Map<String, dynamic> dua) {
    final title = dua['title'] as Map<String, dynamic>?;
    if (title == null) return context.tr(dua['titleKey'] ?? '');
    final code = context.read<LanguageProvider>().languageCode;
    final val = title[code] as String? ?? '';
    return val.isNotEmpty ? val : (title['en'] as String? ?? dua['titleKey'] ?? '');
  }

  String _getCurrentTranslation(Map<String, dynamic> dua) {
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        return dua['hindi'] ?? '';
      case DuaLanguage.english:
        return dua['english'] ?? '';
      case DuaLanguage.urdu:
        return dua['urdu'] ?? '';
      case DuaLanguage.arabic:
        return dua['ar'] ?? dua['english'] ?? '';
    }
  }

  String _getCurrentLanguageLabel() {
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        return context.tr('hindi');
      case DuaLanguage.english:
        return context.tr('english');
      case DuaLanguage.urdu:
        return context.tr('urdu');
      case DuaLanguage.arabic:
        return context.tr('arabic');
    }
  }

  void _copyDua(BuildContext context, Map<String, dynamic> dua) {
    final textToCopy =
        '''
${_getDuaTitle(dua)}

${dua['arabic']}

${dua['transliteration']}

${_getCurrentTranslation(dua)}
''';

    Clipboard.setData(ClipboardData(text: textToCopy));
  }

  void _shareDua(BuildContext context, Map<String, dynamic> dua) {
    final textToShare =
        '''
${_getDuaTitle(dua)}

${dua['arabic']}

${dua['transliteration']}

${_getCurrentTranslation(dua)}
''';

    Share.share(textToShare);
  }

  Future<void> _stopPlaying() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _playingDuaIndex = null;
    });
  }

  Future<void> _playDua(int index, String text, {bool isArabic = false}) async {
    if (_isSpeaking && _playingDuaIndex == index) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    String langCode;
    if (isArabic) {
      langCode = 'ar-SA';
    } else {
      switch (_selectedLanguage) {
        case DuaLanguage.hindi:
          langCode = 'hi-IN';
          break;
        case DuaLanguage.english:
          langCode = 'en-US';
          break;
        case DuaLanguage.urdu:
          langCode = 'ur-PK';
          break;
        case DuaLanguage.arabic:
          langCode = 'ar-SA';
          break;
      }
    }

    await _flutterTts.setLanguage(langCode);
    setState(() {
      _isSpeaking = true;
      _playingDuaIndex = index;
    });

    await _flutterTts.speak(text);
  }

  Widget _buildDuaSection(ResponsiveUtils responsive) {
    final duasList = _firestoreFastingDuas ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('duas_for_fasting'),
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: responsive.spaceMedium),
        if (_isDuasLoading && _firestoreFastingDuas == null)
          Center(
            child: Padding(
              padding: responsive.paddingLarge,
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else
        ...duasList.asMap().entries.map((entry) {
          final isExpanded = _expandedDuas.contains(entry.key);
          return Padding(
            padding: EdgeInsets.only(bottom: responsive.spaceMedium),
            child: _buildDuaCard(
              entry.key,
              entry.value,
              isExpanded,
              responsive,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDuaCard(
    int duaIndex,
    Map<String, dynamic> dua,
    bool isExpanded,
    ResponsiveUtils responsive,
  ) {
    final currentTranslation = _getCurrentTranslation(dua);
    final languageLabel = _getCurrentLanguageLabel();

    final isPlayingArabic = _playingDuaIndex == (duaIndex * 2) && _isSpeaking;
    final isPlayingTranslation =
        _playingDuaIndex == (duaIndex * 2 + 1) && _isSpeaking;
    final isPlaying = isPlayingArabic || isPlayingTranslation;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying
              ? AppColors.primaryLight
              : AppColors.lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section with Light Green Background
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : AppColors.lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // Number Badge and Title Row
                Row(
                  children: [
                    Container(
                      width: responsive.spacing(40),
                      height: responsive.spacing(40),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: responsive.spacing(6),
                            offset: Offset(0, responsive.spacing(2)),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${duaIndex + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.textMedium,
                          ),
                        ),
                      ),
                    ),
                    responsive.hSpaceMedium,
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: responsive.screenWidth * 0.6,
                          ),
                          child: Text(
                            _getDuaTitle(dua),
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderActionButton(
                      icon: isPlayingArabic ? Icons.stop : Icons.volume_up,
                      label: isPlayingArabic
                          ? context.tr('stop')
                          : context.tr('audio'),
                      onTap: () =>
                          _playDua(duaIndex * 2, dua['arabic'], isArabic: true),
                      isActive: isPlayingArabic,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleDuaExpanded(duaIndex),
                      isActive: isExpanded,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyDua(context, dua),
                      isActive: false,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareDua(context, dua),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arabic Text with Tap to Play
          GestureDetector(
            onTap: () {
              if (isPlayingArabic) {
                _stopPlaying();
              } else {
                _playDua(duaIndex * 2, dua['arabic'], isArabic: true);
              }
            },
            child: Container(
              margin: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
              padding: responsive.paddingAll(12),
              decoration: isPlayingArabic
                  ? BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
                      ),
                    )
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPlayingArabic)
                    Padding(
                      padding: EdgeInsets.only(
                        right: responsive.spaceSmall,
                        top: responsive.spaceSmall,
                      ),
                      child: Icon(
                        Icons.volume_up,
                        size: responsive.iconSmall,
                        color: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      dua['arabic'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: responsive.fontSize(26),
                        height: 2.0,
                        color: isPlayingArabic
                            ? AppColors.primary
                            : AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Translation Section (Shown when expanded)
          if (isExpanded)
            GestureDetector(
              onTap: () {
                if (isPlayingTranslation) {
                  _stopPlaying();
                } else {
                  _playDua(
                    duaIndex * 2 + 1,
                    currentTranslation,
                    isArabic: false,
                  );
                }
              },
              child: Container(
                margin: responsive.paddingSymmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                padding: responsive.paddingAll(12),
                decoration: BoxDecoration(
                  color: isPlayingTranslation
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlayingTranslation)
                      Padding(
                        padding: EdgeInsets.only(
                          right: responsive.spaceSmall,
                          top: responsive.spaceXSmall,
                        ),
                        child: Icon(
                          Icons.volume_up,
                          size: responsive.iconSmall,
                          color: AppColors.primary,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate,
                                size: responsive.iconSmall,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: responsive.spaceSmall),
                              Flexible(
                                child: Text(
                                  '${context.tr('translation')} ($languageLabel)',
                                  style: TextStyle(
                                    fontSize: responsive.textSmall,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsive.spaceMedium),
                          Text(
                            currentTranslation,
                            style: TextStyle(
                              fontSize: responsive.textMedium,
                              height: 1.6,
                              color: isPlayingTranslation
                                  ? AppColors.primary
                                  : Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                            textDirection:
                                (_selectedLanguage == DuaLanguage.urdu ||
                                    _selectedLanguage == DuaLanguage.arabic)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
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

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final responsive = context.responsive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : AppColors.lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.radiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: responsive.iconSize(22),
                color: isActive ? Colors.white : AppColors.primary,
              ),
              SizedBox(height: responsive.spaceXSmall),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive ? Colors.white : AppColors.primary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleMonth(int monthIndex) {
    setState(() {
      if (_expandedMonths.contains(monthIndex)) {
        _expandedMonths.remove(monthIndex);
      } else {
        _expandedMonths.add(monthIndex);
      }
    });
  }

  // Get current month fasting data from Firebase
  Map<String, dynamic>? _getCurrentMonthFastingData(int hijriMonth) {
    final months = _firestoreMonths?['months'] as List<dynamic>?;
    if (months == null || hijriMonth < 1 || hijriMonth > months.length) return null;
    return months[hijriMonth - 1] as Map<String, dynamic>;
  }

  /// Map icon string name to IconData
  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'nights_stay': return Icons.nights_stay;
      case 'wb_twilight': return Icons.wb_twilight;
      case 'star': return Icons.star;
      case 'star_border': return Icons.star_border;
      case 'brightness_5': return Icons.brightness_5;
      case 'brightness_6': return Icons.brightness_6;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'brightness_3': return Icons.brightness_3;
      case 'mosque': return Icons.mosque;
      case 'celebration': return Icons.celebration;
      case 'terrain': return Icons.terrain;
      case 'landscape': return Icons.landscape;
      case 'door_front_door': return Icons.door_front_door;
      case 'shield': return Icons.shield;
      case 'favorite': return Icons.favorite;
      case 'handshake': return Icons.handshake;
      case 'calendar_month': return Icons.calendar_month;
      case 'repeat': return Icons.repeat;
      case 'block': return Icons.block;
      default: return Icons.circle;
    }
  }

  /// Parse hex color string to Color
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF1565C0);
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF1565C0);
    }
  }

  /// Get text from a field that may be a String or a 4-lang Map
  String _getLocalizedText(dynamic field) {
    if (field is String) return field;
    if (field is Map) return _tr(field);
    return '';
  }

  Widget _buildCurrentMonthFastingCard(
    HijriCalendar hijriDate,
    ResponsiveUtils responsive,
  ) {
    final monthData = _getCurrentMonthFastingData(hijriDate.hMonth);
    if (monthData == null) {
      return const SizedBox.shrink();
    }
    final monthName = _tr(monthData['name']);
    final monthIcon = _getIconData(monthData['icon'] as String?);
    final monthColor = _parseColor(monthData['color'] as String?);
    final fastingDays = monthData['fasting_days'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Header with month name
          Container(
            padding: responsive.paddingRegular,
            decoration: BoxDecoration(
              color: monthColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.spaceMedium),
                  decoration: BoxDecoration(
                    color: monthColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      responsive.radiusMedium,
                    ),
                  ),
                  child: Icon(
                    monthIcon,
                    color: monthColor,
                    size: responsive.iconLarge,
                  ),
                ),
                SizedBox(width: responsive.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.tr('current_month'),
                          style: TextStyle(
                            fontSize: responsive.textSmall,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          monthName,
                          style: TextStyle(
                            fontSize: responsive.textXXLarge,
                            fontWeight: FontWeight.bold,
                            color: monthColor,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Current Hijri Date Display
          Container(
            width: double.infinity,
            padding: responsive.paddingSymmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: monthColor.withValues(alpha: 0.08),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: responsive.iconSize(18),
                  color: monthColor,
                ),
                SizedBox(width: responsive.spacing(8)),
                Text(
                  '${context.tr('today')}: ',
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH',
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.bold,
                    color: monthColor,
                  ),
                ),
              ],
            ),
          ),

          // Fasting days list
          Padding(
            padding: responsive.paddingRegular,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('fasting_dates_this_month'),
                  style: TextStyle(
                    fontSize: responsive.textMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.spaceMedium),
                ...fastingDays.map(
                  (day) {
                    final d = day as Map<String, dynamic>;
                    return _buildCurrentMonthFastingRow(
                      _getLocalizedText(d['days']),
                      _tr(d['desc']),
                      d['type'] as String? ?? 'nafil',
                      responsive,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentMonthFastingRow(
    String days,
    String description,
    String type,
    ResponsiveUtils responsive,
  ) {
    Color typeColor;
    IconData typeIcon;

    switch (type) {
      case 'farz':
        typeColor = Colors.red;
        typeIcon = Icons.star;
        break;
      case 'sunnah':
        typeColor = Colors.green;
        typeIcon = Icons.check_circle;
        break;
      case 'nafil':
        typeColor = Colors.blue;
        typeIcon = Icons.favorite;
        break;
      case 'prohibited':
        typeColor = Colors.red.shade900;
        typeIcon = Icons.cancel;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.circle;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spacing(6)),
      child: Row(
        children: [
          Container(
            padding: context.responsive.paddingXSmall,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
            ),
            child: Icon(
              typeIcon,
              color: typeColor,
              size: responsive.iconSize(16),
            ),
          ),
          SizedBox(width: responsive.spacing(10)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.spacing(10),
              vertical: responsive.spacing(4),
            ),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
              border: Border.all(color: typeColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              days,
              style: TextStyle(
                fontSize: responsive.fontSize(13),
                fontWeight: FontWeight.bold,
                color: typeColor,
                decoration: type == 'prohibited'
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          SizedBox(width: responsive.spacing(10)),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: responsive.fontSize(12),
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastingVirtuesSection(ResponsiveUtils responsive) {
    final virtues = _firestoreVirtues ?? [];

    if (_isVirtuesLoading && virtues.isEmpty) {
      return Center(
        child: Padding(
          padding: responsive.paddingLarge,
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (virtues.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
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
              Icon(
                Icons.star,
                color: Colors.amber,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacing(8)),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _tr(_firestoreRules?['title'], fallback: 'Virtues of Fasting'),
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(16)),
          ...virtues.map((virtue) => Padding(
            padding: EdgeInsets.only(bottom: responsive.spacing(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: responsive.paddingAll(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                  ),
                  child: Icon(
                    _getIconData(virtue['icon'] as String?),
                    color: AppColors.primary,
                    size: responsive.iconSize(20),
                  ),
                ),
                SizedBox(width: responsive.spacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tr(virtue['title']),
                        style: TextStyle(
                          fontSize: responsive.fontSize(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(4)),
                      Text(
                        _tr(virtue['description']),
                        style: TextStyle(
                          fontSize: responsive.fontSize(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(2)),
                      Text(
                        '- ${virtue['reference'] ?? ''}',
                        style: TextStyle(
                          fontSize: responsive.fontSize(10),
                          fontStyle: FontStyle.italic,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFastingRulesSection(ResponsiveUtils responsive) {
    if (_isRulesLoading && _firestoreRules == null) {
      return Center(
        child: Padding(
          padding: responsive.paddingLarge,
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (_firestoreRules == null) return const SizedBox.shrink();

    final breaksFast = (_firestoreRules!['breaks_fast'] as List<dynamic>? ?? []);
    final doesNotBreak = (_firestoreRules!['does_not_break_fast'] as List<dynamic>? ?? []);

    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
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
              Icon(
                Icons.rule,
                color: AppColors.primary,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacing(8)),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _tr(_firestoreRules!['title'], fallback: 'Fasting Rules'),
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(16)),

          // What breaks the fast
          Container(
            padding: responsive.paddingAll(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red.shade700, size: responsive.iconSize(18)),
                    SizedBox(width: responsive.spacing(8)),
                    Text(
                      _tr(_firestoreRules!['breaks_fast_title'], fallback: 'What Breaks the Fast'),
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spacing(8)),
                ...breaksFast.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: responsive.spacing(2)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\u2022 ', style: TextStyle(color: Colors.red.shade700, fontSize: responsive.fontSize(12))),
                      Expanded(
                        child: Text(
                          _tr(item),
                          style: TextStyle(
                            fontSize: responsive.fontSize(12),
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: responsive.spacing(12)),

          // What doesn\'t break the fast
          Container(
            padding: responsive.paddingAll(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700, size: responsive.iconSize(18)),
                    SizedBox(width: responsive.spacing(8)),
                    Text(
                      _tr(_firestoreRules!['does_not_break_fast_title'], fallback: 'Does Not Break Fast'),
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spacing(8)),
                ...doesNotBreak.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: responsive.spacing(2)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\u2022 ', style: TextStyle(color: Colors.green.shade700, fontSize: responsive.fontSize(12))),
                      Expanded(
                        child: Text(
                          _tr(item),
                          style: TextStyle(
                            fontSize: responsive.fontSize(12),
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicMonthsChart(ResponsiveUtils responsive) {
    if (_isMonthsLoading && _firestoreMonths == null) {
      return Center(
        child: Padding(
          padding: responsive.paddingLarge,
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (_firestoreMonths == null) return const SizedBox.shrink();

    final months = _firestoreMonths!['months'] as List<dynamic>? ?? [];
    final labels = _firestoreMonths!['section_labels'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tr(_firestoreMonths!['title'], fallback: 'Islamic 12 Months - Fasting Chart'),
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: responsive.spaceMedium),
        ...months.asMap().entries.map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: responsive.spaceSmall),
            child: _buildMonthCard(entry.key, entry.value as Map<String, dynamic>, labels, responsive),
          ),
        ),
        SizedBox(height: responsive.spaceRegular),

        // Prohibited Days Summary
        _buildProhibitedDaysSummary(labels, responsive),
        SizedBox(height: responsive.spaceRegular),

        // Quick Rules
        _buildQuickRulesSummary(labels, responsive),
      ],
    );
  }

  Widget _buildMonthCard(
    int index,
    Map<String, dynamic> month,
    Map<String, dynamic> labels,
    ResponsiveUtils responsive,
  ) {
    final isExpanded = _expandedMonths.contains(index);
    final monthColor = _parseColor(month['color'] as String?);
    final fastingDays = month['fasting_days'] as List<dynamic>? ?? [];

    return GestureDetector(
      onTap: () => _toggleMonth(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radiusLarge),
          border: Border.all(
            color: (isExpanded
                      ? AppColors.primaryLight
                      : AppColors.lightGreenBorder),
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: isExpanded ? 0.12 : 0.08,
                    ),
                    blurRadius: isExpanded ? 12 : 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: isExpanded
                    ? monthColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(15),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: context.responsive.paddingSmall,
                    decoration: BoxDecoration(
                      color: monthColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(month['icon'] as String?),
                      color: monthColor,
                      size: responsive.iconSize(24),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tr(month['name']),
                          style: TextStyle(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${fastingDays.length} ${_tr(labels['fasting_options'], fallback: 'Fasting options')}',
                          style: TextStyle(
                            fontSize: responsive.fontSize(12),
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: monthColor,
                  ),
                ],
              ),
            ),

            // Expanded Content
            if (isExpanded)
              Container(
                padding: responsive.paddingOnly(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  children: [
                    const Divider(),
                    ...fastingDays.map(
                      (day) => _buildFastingDayRow(day as Map<String, dynamic>, labels, responsive),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFastingDayRow(
    Map<String, dynamic> day,
    Map<String, dynamic> labels,
    ResponsiveUtils responsive,
  ) {
    final typeStr = day['type'] as String? ?? 'nafil';
    Color typeColor;
    IconData typeIcon;
    String typeLabel;

    switch (typeStr) {
      case 'farz':
        typeColor = Colors.red;
        typeIcon = Icons.star;
        typeLabel = _tr(labels['farz'], fallback: 'Farz');
      case 'sunnah':
        typeColor = Colors.green;
        typeIcon = Icons.check_circle;
        typeLabel = _tr(labels['sunnah'], fallback: 'Sunnah');
      case 'prohibited':
        typeColor = Colors.red.shade900;
        typeIcon = Icons.cancel;
        typeLabel = _tr(labels['mana'], fallback: 'Prohibited');
      default:
        typeColor = Colors.blue;
        typeIcon = Icons.favorite;
        typeLabel = _tr(labels['nafil'], fallback: 'Nafil');
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spacing(8)),
      child: Row(
        children: [
          Container(
            padding: context.responsive.paddingXSmall,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
            ),
            child: Icon(
              typeIcon,
              color: typeColor,
              size: responsive.iconSize(18),
            ),
          ),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedText(day['days']),
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    decoration: typeStr == 'prohibited'
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  _tr(day['desc']),
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.spacing(8),
              vertical: responsive.spacing(4),
            ),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                fontSize: responsive.fontSize(10),
                fontWeight: FontWeight.bold,
                color: typeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProhibitedDaysSummary(Map<String, dynamic> labels, ResponsiveUtils responsive) {
    final prohibitedDays = _firestoreMonths?['prohibited_days'] as List<dynamic>? ?? [];
    if (prohibitedDays.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(responsive.radiusXLarge),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cancel,
                color: Colors.red.shade700,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacing(8)),
              Text(
                _tr(labels['fasting_prohibited'], fallback: 'Fasting PROHIBITED'),
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(12)),
          ...prohibitedDays.map(
            (day) => Padding(
              padding: EdgeInsets.symmetric(vertical: responsive.spacing(4)),
              child: Row(
                children: [
                  Icon(
                    Icons.block,
                    color: Colors.red.shade400,
                    size: responsive.iconSize(16),
                  ),
                  SizedBox(width: responsive.spacing(8)),
                  Expanded(
                    child: Text(
                      _tr(day),
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        color: Colors.red.shade700,
                      ),
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

  Widget _buildQuickRulesSummary(Map<String, dynamic> labels, ResponsiveUtils responsive) {
    final quickRules = _firestoreMonths?['quick_rules'] as List<dynamic>? ?? [];
    if (quickRules.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
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
              Icon(
                Icons.lightbulb,
                color: AppColors.secondary,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacing(8)),
              Text(
                _tr(labels['quick_rules_remember'], fallback: 'Quick Rules'),
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(16)),
          ...quickRules.map((rule) {
            final r = rule as Map<String, dynamic>;
            final ruleColor = _parseColor(r['color'] as String?);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: responsive.spacing(6)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_getIconData(r['icon'] as String?), color: ruleColor, size: responsive.iconSize(20)),
                  SizedBox(width: responsive.spacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tr(r['label']),
                          style: TextStyle(
                            fontSize: responsive.fontSize(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: responsive.spacing(2)),
                        Text(
                          _tr(r['value']),
                          style: TextStyle(
                            fontSize: responsive.fontSize(13),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
