import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/services/hijri_date_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/data_migration_service.dart';
import '../../data/models/dua_model.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class RamadanTrackerScreen extends StatefulWidget {
  const RamadanTrackerScreen({super.key});

  @override
  State<RamadanTrackerScreen> createState() => _RamadanTrackerScreenState();
}

class _RamadanTrackerScreenState extends State<RamadanTrackerScreen>
    with WidgetsBindingObserver {
  Map<int, FastingDay> _fastingDays = {};
  int _currentRamadanYear = HijriDateService.instance.getHijriNow().hYear;
  bool _isRamadan = false;
  int _currentDay = 0;
  int _totalFasted = 0;
  int _totalMissed = 0;
  DateTime _lastCheckedDate = DateTime.now();

  // Dua related state
  final FlutterTts _flutterTts = FlutterTts();
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;
  int? _playingDuaIndex;
  bool _isSpeaking = false;
  final Set<int> _expandedDuas = {};

  // Firestore
  List<Map<String, dynamic>>? _firestoreDuas;
  bool _isDuasLoading = true;

  Future<void> _loadFromFirestore() async {
    if (mounted) {
      setState(() => _isDuasLoading = true);
    }
    try {
      // Fetch directly from Firebase (bypass ContentService cache)
      var doc = await FirebaseFirestore.instance
          .collection('ramadan_duas')
          .doc('all_duas')
          .get();

      // If Firebase is empty, auto-push hardcoded data first
      if (!doc.exists || (doc.data()?['duas'] as List?)?.isEmpty != false) {
        debugPrint('Firebase ramadan_duas empty - auto-pushing data...');
        await DataMigrationService().migrateRamadanDuas();
        // Re-fetch after push
        doc = await FirebaseFirestore.instance
            .collection('ramadan_duas')
            .doc('all_duas')
            .get();
      }

      if (doc.exists && mounted) {
        final data = doc.data()!;
        final firestoreDuas = (data['duas'] as List<dynamic>? ?? [])
            .map((d) => RamadanDuaFirestore.fromJson(d as Map<String, dynamic>))
            .toList();

        debugPrint('Loaded ${firestoreDuas.length} ramadan duas from Firebase');

        if (firestoreDuas.isNotEmpty) {
          final converted = firestoreDuas.map((dua) {
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
            };
          }).toList();
          setState(() {
            _firestoreDuas = converted;
            _isDuasLoading = false;
          });
          return;
        }
      }

      if (mounted) {
        setState(() => _isDuasLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading ramadan duas from Firestore: $e');
      if (mounted) {
        setState(() => _isDuasLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFastingDays();
    _checkRamadan();
    _loadFastingData();
    _initTts();
    _loadFromFirestore();

    // Initialize prayer provider to get location-based times
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProvider = context.read<PrayerProvider>();
      if (prayerProvider.todayPrayerTimes == null) {
        prayerProvider.initialize();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app resumes, check if date changed and refresh data
    if (state == AppLifecycleState.resumed) {
      _checkAndRefreshIfNeeded();
    }
  }

  void _checkAndRefreshIfNeeded() {
    final now = DateTime.now();

    // Check if date has changed (new day)
    if (now.day != _lastCheckedDate.day ||
        now.month != _lastCheckedDate.month ||
        now.year != _lastCheckedDate.year) {
      if (!mounted) return;

      setState(() {
        _lastCheckedDate = now;
        _currentRamadanYear = HijriDateService.instance.getHijriNow().hYear;
      });

      // Refresh all data
      _checkRamadan();
      _loadFastingData();

      // Refresh prayer times
      if (mounted) {
        final prayerProvider = context.read<PrayerProvider>();
        prayerProvider.initialize();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLanguageWithApp();
    _checkAndRefreshIfNeeded();
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
    _flutterTts.stop();
    super.dispose();
  }

  void _initializeFastingDays() {
    // Initialize 30 days with pending status
    _fastingDays = {
      for (int i = 1; i <= 30; i++)
        i: FastingDay(day: i, status: FastingStatus.pending),
    };
  }

  void _checkRamadan() {
    final hijri = HijriDateService.instance.getHijriNow();
    _isRamadan = hijri.hMonth == 9; // Ramadan is the 9th month
    if (_isRamadan) {
      _currentDay = hijri.hDay;
    }
  }

  Future<void> _loadFastingData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ramadan_$_currentRamadanYear';
    final data = prefs.getString(key);

    if (data != null) {
      final decoded = json.decode(data) as Map<String, dynamic>;
      _fastingDays = decoded.map(
        (key, value) => MapEntry(int.parse(key), FastingDay.fromJson(value)),
      );
    } else {
      // Initialize 30 days
      _fastingDays = {
        for (int i = 1; i <= 30; i++)
          i: FastingDay(day: i, status: FastingStatus.pending),
      };
    }

    _calculateStats();
    setState(() {});
  }

  Future<void> _saveFastingData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ramadan_$_currentRamadanYear';
    final data = _fastingDays.map(
      (key, value) => MapEntry(key.toString(), value.toJson()),
    );
    await prefs.setString(key, json.encode(data));
  }

  void _calculateStats() {
    _totalFasted = _fastingDays.values
        .where((d) => d.status == FastingStatus.completed)
        .length;
    _totalMissed = _fastingDays.values
        .where((d) => d.status == FastingStatus.missed)
        .length;
  }

  void _updateFastingStatus(int day, FastingStatus status) {
    setState(() {
      _fastingDays[day] = _fastingDays[day]!.copyWith(status: status);
      _calculateStats();
    });
    _saveFastingData();
  }

  // TTS Methods
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
        case DuaLanguage.english:
          langCode = 'en-US';
        case DuaLanguage.urdu:
          langCode = 'ur-PK';
        case DuaLanguage.arabic:
          langCode = 'ar-SA';
      }
    }

    await _flutterTts.setLanguage(langCode);
    setState(() {
      _isSpeaking = true;
      _playingDuaIndex = index;
    });

    await _flutterTts.speak(text);
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

  void _copyDua(BuildContext context, Map<String, dynamic> dua) {
    final currentTranslation = _getCurrentTranslation(dua);
    final title = _getDuaTitle(dua);

    final textToCopy =
        '''
$title

${dua['arabic']}

${dua['transliteration']}

$currentTranslation
''';

    Clipboard.setData(ClipboardData(text: textToCopy));
  }

  void _shareDua(BuildContext context, Map<String, dynamic> dua) {
    final currentTranslation = _getCurrentTranslation(dua);
    final title = _getDuaTitle(dua);

    final textToShare =
        '''
$title

${dua['arabic']}

${dua['transliteration']}

$currentTranslation

${context.tr('shared_from_app')}
''';

    Share.share(textToShare);
  }

  Future<void> _refreshPrayerTimes() async {
    final prayerProvider = context.read<PrayerProvider>();
    await prayerProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final prayerProvider = context.watch<PrayerProvider>();
    final prayerTimes = prayerProvider.todayPrayerTimes;
    final isLoading = prayerProvider.isLoading;
    final hasError = prayerProvider.error != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('ramadan_tracker_title'),
          style: TextStyle(color: Colors.white, fontSize: responsive.textLarge),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPrayerTimes,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: responsive.paddingRegular,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ramadan Status Card
                    _buildStatusCard(responsive),
                    SizedBox(height: responsive.spaceRegular),

                    // Suhoor & Iftar Times
                    if (isLoading)
                      _buildLoadingCard(responsive)
                    else if (hasError)
                      _buildErrorCard(responsive, prayerProvider.error!)
                    else if (prayerTimes != null)
                      _buildFastingTimesCard(
                        prayerTimes.fajr,
                        prayerTimes.maghrib,
                        responsive,
                      )
                    else
                      _buildNoDataCard(responsive),
                    SizedBox(height: responsive.spaceRegular),

                    // Statistics
                    _buildStatisticsCard(responsive),
                    SizedBox(height: responsive.spaceRegular),

                    // Fasting Days Grid Card
                    Text(
                      context
                          .tr('fasting_days_ramadan')
                          .replaceAll('{year}', _currentRamadanYear.toString()),
                      style: TextStyle(
                        fontSize: responsive.textRegular,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.spaceMedium),
                    _buildFastingGridCard(responsive),

                    SizedBox(height: responsive.spaceXXLarge),

                    // Ramadan Duas Section
                    _buildDuasSection(responsive),
                  ],
                ),
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ResponsiveUtils responsive) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
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
          Icon(
            _isRamadan ? Icons.nights_stay : Icons.calendar_month,
            color: AppColors.primary,
            size: responsive.iconXXLarge,
          ),
          SizedBox(height: responsive.spaceMedium),
          Text(
            _isRamadan
                ? context.tr('ramadan_mubarak')
                : context.tr('ramadan_tracker_title'),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: responsive.textXXLarge,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.spaceSmall),
          Text(
            _isRamadan
                ? context
                      .tr('day_of_ramadan')
                      .replaceAll('{day}', _currentDay.toString())
                : '${context.tr('track_your_fasting')} $_currentRamadanYear',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: responsive.textRegular,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(ResponsiveUtils responsive) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
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
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: responsive.spaceMedium),
          Text(
            context.tr('loading'),
            style: TextStyle(
              fontSize: responsive.textRegular,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(ResponsiveUtils responsive, String error) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: Colors.red.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: responsive.iconXLarge,
          ),
          SizedBox(height: responsive.spaceMedium),
          Text(
            context.tr('error'),
            style: TextStyle(
              fontSize: responsive.textLarge,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.spaceSmall),
          Text(
            error,
            style: TextStyle(
              fontSize: responsive.textSmall,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.spaceMedium),
          ElevatedButton.icon(
            onPressed: () {
              final prayerProvider = context.read<PrayerProvider>();
              prayerProvider.initialize();
            },
            icon: Icon(Icons.refresh, size: responsive.iconSmall),
            label: Text(context.tr('retry')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: responsive.paddingSymmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(ResponsiveUtils responsive) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
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
          Icon(
            Icons.location_off,
            color: AppColors.textSecondary,
            size: responsive.iconXLarge,
          ),
          SizedBox(height: responsive.spaceMedium),
          Text(
            context.tr('no_location_data'),
            style: TextStyle(
              fontSize: responsive.textRegular,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFastingTimesCard(
    String suhoorEnd,
    String iftarTime,
    ResponsiveUtils responsive,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: responsive.paddingRegular,
        child: Row(
          children: [
            Expanded(
              child: _buildTimeColumn(
                context.tr('suhoor_ends'),
                suhoorEnd,
                Icons.wb_twilight,
                Colors.indigo,
                responsive,
              ),
            ),
            Container(
              height: 80,
              width: 1.5,
              color: AppColors.lightGreenBorder,
              margin: responsive.paddingSymmetric(horizontal: 8, vertical: 0),
            ),
            Expanded(
              child: _buildTimeColumn(
                context.tr('iftar_time'),
                iftarTime,
                Icons.nights_stay,
                Colors.orange,
                responsive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(
    String label,
    String time,
    IconData icon,
    Color color,
    ResponsiveUtils responsive,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.spacing(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: responsive.iconMedium),
          SizedBox(height: responsive.spaceSmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.textSmall,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          SizedBox(height: responsive.spaceXSmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              time,
              style: TextStyle(
                fontSize: responsive.textLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(ResponsiveUtils responsive) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
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
          Text(
            context.tr('statistics'),
            style: TextStyle(
              fontSize: responsive.textRegular,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.spaceMedium),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context.tr('completed'),
                  _totalFasted,
                  Colors.green,
                  Icons.check_circle,
                  responsive,
                ),
              ),
              SizedBox(width: responsive.spaceSmall),
              Expanded(
                child: _buildStatItem(
                  context.tr('missed'),
                  _totalMissed,
                  Colors.red,
                  Icons.cancel,
                  responsive,
                ),
              ),
              SizedBox(width: responsive.spaceSmall),
              Expanded(
                child: _buildStatItem(
                  context.tr('pending'),
                  30 - _totalFasted - _totalMissed,
                  Colors.orange,
                  Icons.pending,
                  responsive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    int count,
    Color color,
    IconData icon,
    ResponsiveUtils responsive,
  ) {
    return Container(
      padding: responsive.paddingSmall,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: responsive.iconMedium),
          SizedBox(height: responsive.spaceXSmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: responsive.textXLarge,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
          SizedBox(height: responsive.spaceXSmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.textXSmall,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastingGridCard(ResponsiveUtils responsive) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weekday Header
          _buildWeekDaysHeader(responsive),
          SizedBox(height: responsive.spaceSmall),
          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: responsive.spaceSmall,
              mainAxisSpacing: responsive.spaceSmall,
              childAspectRatio: 1,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              final day = index + 1;
              final fastingDay = _fastingDays[day]!;
              return _buildDayCell(day, fastingDay, responsive);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader(ResponsiveUtils responsive) {
    final weekDays = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

    return Container(
      padding: responsive.paddingSymmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGreenChip,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1),
      ),
      child: Row(
        children: weekDays.map((day) {
          return Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                context.tr(day),
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayCell(
    int day,
    FastingDay fastingDay,
    ResponsiveUtils responsive,
  ) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    switch (fastingDay.status) {
      case FastingStatus.completed:
        backgroundColor = Colors.green.withValues(alpha: 0.15);
        borderColor = Colors.green;
        textColor = Colors.green.shade700;
        break;
      case FastingStatus.missed:
        backgroundColor = Colors.red.withValues(alpha: 0.15);
        borderColor = Colors.red;
        textColor = Colors.red.shade700;
        break;
      case FastingStatus.pending:
        backgroundColor = AppColors.lightGreenChip;
        borderColor = AppColors.lightGreenBorder;
        textColor = AppColors.primary;
        break;
    }

    return GestureDetector(
      onTap: () => _showStatusDialog(day),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              day.toString(),
              style: TextStyle(
                fontSize: responsive.textRegular,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusDialog(int day) {
    final responsive = ResponsiveUtils(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.radiusLarge),
        ),
        title: Text(
          '${context.tr('day')} $day',
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          context.tr('select_fasting_status'),
          style: TextStyle(color: AppColors.primary, fontSize: responsive.textRegular),
        ),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDialogButton(
                label: context.tr('completed'),
                icon: Icons.check_circle,
                color: Colors.green,
                onPressed: () {
                  _updateFastingStatus(day, FastingStatus.completed);
                  Navigator.pop(context);
                },
                responsive: responsive,
              ),
              SizedBox(height: responsive.spaceSmall),
              _buildDialogButton(
                label: context.tr('missed'),
                icon: Icons.cancel,
                color: Colors.red,
                onPressed: () {
                  _updateFastingStatus(day, FastingStatus.missed);
                  Navigator.pop(context);
                },
                responsive: responsive,
              ),
              SizedBox(height: responsive.spaceSmall),
              _buildDialogButton(
                label: context.tr('pending'),
                icon: Icons.pending,
                color: Colors.orange,
                onPressed: () {
                  _updateFastingStatus(day, FastingStatus.pending);
                  Navigator.pop(context);
                },
                responsive: responsive,
              ),
              SizedBox(height: responsive.spaceSmall),
              _buildDialogButton(
                label: context.tr('cancel'),
                icon: Icons.close,
                color: Colors.grey,
                onPressed: () => Navigator.pop(context),
                responsive: responsive,
              ),
            ],
          ),
        ],
        actionsPadding: responsive.paddingAll(16),
      ),
    );
  }

  Widget _buildDialogButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required ResponsiveUtils responsive,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        color: color.withValues(alpha: 0.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          child: Padding(
            padding: responsive.paddingSymmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: responsive.iconMedium),
                SizedBox(width: responsive.spaceSmall),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get the dua title - prefer Firebase multilingual title, fallback to context.tr()
  String _getDuaTitle(Map<String, dynamic> dua) {
    final title = dua['title'];
    if (title is Map<String, dynamic>) {
      final langCode = _selectedLanguage == DuaLanguage.hindi
          ? 'hi'
          : _selectedLanguage == DuaLanguage.english
          ? 'en'
          : _selectedLanguage == DuaLanguage.urdu
          ? 'ur'
          : 'ar';
      final localizedTitle = title[langCode] as String? ?? '';
      if (localizedTitle.isNotEmpty) return localizedTitle;
      // Fallback to English if localized title is empty
      final enTitle = title['en'] as String? ?? '';
      if (enTitle.isNotEmpty) return enTitle;
    }
    // Final fallback to translation key
    return context.tr(dua['titleKey'] ?? '');
  }

  /// Get the current translation text based on selected language
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

  Widget _buildDuasSection(ResponsiveUtils responsive) {
    final duasList = _firestoreDuas ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('ramadan_duas'),
          style: TextStyle(
            fontSize: responsive.textXLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: responsive.spaceMedium),

        if (_isDuasLoading && _firestoreDuas == null)
          Center(
            child: Padding(
              padding: responsive.paddingLarge,
              child: Column(
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: responsive.spaceMedium),
                  Text(
                    context.tr('loading'),
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: duasList.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: responsive.spaceRegular),
            itemBuilder: (context, index) {
              final dua = duasList[index];
              final isExpanded = _expandedDuas.contains(index);
              return _buildDuaCard(dua, index, isExpanded, responsive);
            },
          ),
      ],
    );
  }

  Widget _buildDuaCard(
    Map<String, dynamic> dua,
    int index,
    bool isExpanded,
    ResponsiveUtils responsive,
  ) {
    final currentTranslation = _getCurrentTranslation(dua);
    String languageLabel;

    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        languageLabel = context.tr('hindi');
      case DuaLanguage.english:
        languageLabel = context.tr('english');
      case DuaLanguage.urdu:
        languageLabel = context.tr('urdu');
      case DuaLanguage.arabic:
        languageLabel = context.tr('arabic');
    }

    final isPlayingArabic = _playingDuaIndex == (index * 2) && _isSpeaking;
    final isPlayingTranslation =
        _playingDuaIndex == (index * 2 + 1) && _isSpeaking;
    final isPlaying = isPlayingArabic || isPlayingTranslation;

    return Container(
      width: double.infinity,
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
            blurRadius: 10.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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
              mainAxisSize: MainAxisSize.min,
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.textMedium,
                            ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildHeaderActionButton(
                        icon: isPlayingArabic ? Icons.stop : Icons.volume_up,
                        label: isPlayingArabic
                            ? context.tr('stop')
                            : context.tr('audio'),
                        onTap: () =>
                            _playDua(index * 2, dua['arabic'], isArabic: true),
                        isActive: isPlayingArabic,
                      ),
                      SizedBox(width: responsive.spaceXSmall),
                      _buildHeaderActionButton(
                        icon: Icons.translate,
                        label: context.tr('translate'),
                        onTap: () => _toggleDuaExpanded(index),
                        isActive: isExpanded,
                      ),
                      SizedBox(width: responsive.spaceXSmall),
                      _buildHeaderActionButton(
                        icon: Icons.copy,
                        label: context.tr('copy'),
                        onTap: () => _copyDua(context, dua),
                        isActive: false,
                      ),
                      SizedBox(width: responsive.spaceXSmall),
                      _buildHeaderActionButton(
                        icon: Icons.share,
                        label: context.tr('share'),
                        onTap: () => _shareDua(context, dua),
                        isActive: false,
                      ),
                    ],
                  ),
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
                _playDua(index * 2, dua['arabic'], isArabic: true);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.spacing(12),
                vertical: responsive.spacing(8),
              ),
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
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.visible,
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
                  _playDua(index * 2 + 1, currentTranslation, isArabic: false);
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate,
                                size: responsive.iconSmall,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: responsive.spaceSmall),
                              Expanded(
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
                            overflow: TextOverflow.visible,
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
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacing(10),
            vertical: responsive.spacing(6),
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : AppColors.lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.radiusMedium),
            border: Border.all(
              color: isActive
                  ? AppColors.primaryLight
                  : AppColors.lightGreenBorder,
              width: 1,
            ),
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: responsive.textXSmall,
                    color: isActive ? Colors.white : AppColors.primary,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum FastingStatus { pending, completed, missed }

class FastingDay {
  final int day;
  final FastingStatus status;

  FastingDay({required this.day, required this.status});

  FastingDay copyWith({FastingStatus? status}) {
    return FastingDay(day: day, status: status ?? this.status);
  }

  Map<String, dynamic> toJson() => {'day': day, 'status': status.index};

  factory FastingDay.fromJson(Map<String, dynamic> json) {
    return FastingDay(
      day: json['day'],
      status: FastingStatus.values[json['status']],
    );
  }
}
