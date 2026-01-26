import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/dua_model.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';

class FastingTimesScreen extends StatefulWidget {
  const FastingTimesScreen({super.key});

  @override
  State<FastingTimesScreen> createState() => _FastingTimesScreenState();
}

class _FastingTimesScreenState extends State<FastingTimesScreen> {
  Timer? _timer;
  bool _isFastingTime = false;

  // Track which month cards are expanded
  final Set<int> _expandedMonths = {};

  // TTS and language
  final FlutterTts _flutterTts = FlutterTts();
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;
  int? _playingDuaIndex;
  bool _isSpeaking = false;
  final Set<int> _expandedDuas = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initTts();
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
    _timer?.cancel();
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
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final hijriDate = HijriCalendar.now();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('fasting_times'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
        centerTitle: true,
      ),
      body: prayerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prayerTimes == null
          ? _buildNoDataView(isDark, responsive)
          : SingleChildScrollView(
              padding: responsive.paddingRegular,
              child: Column(
                children: [
                  // Current Month Fasting Dates
                  _buildCurrentMonthFastingCard(hijriDate, isDark, responsive),
                  SizedBox(height: responsive.spaceLarge),

                  // Current Status Card
                  _buildStatusCard(isDark, responsive),
                  SizedBox(height: responsive.spaceLarge),

                  // Suhoor & Iftar Times
                  _buildTimesRow(
                    prayerTimes.fajr,
                    prayerTimes.maghrib,
                    isDark,
                    responsive,
                  ),
                  SizedBox(height: responsive.spaceLarge),

                  // Dua Cards
                  _buildDuaSection(isDark, responsive),
                  SizedBox(height: responsive.spaceLarge),

                  // Islamic 12 Months Fasting Chart
                  _buildIslamicMonthsChart(isDark, responsive),
                ],
              ),
            ),
    );
  }

  Widget _buildNoDataView(bool isDark, ResponsiveUtils responsive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: responsive.iconXXLarge,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          SizedBox(height: responsive.spaceRegular),
          Text(
            context.tr('unable_load_prayer_times'),
            style: TextStyle(
              fontSize: responsive.textLarge,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: responsive.spaceSmall),
          Text(
            context.tr('enable_location_services'),
            style: TextStyle(
              fontSize: responsive.textMedium,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark, ResponsiveUtils responsive) {
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
          Text(
            _isFastingTime
                ? context.tr('currently_fasting')
                : context.tr('not_fasting_time'),
            style: TextStyle(
              fontSize: responsive.textXLarge,
              fontWeight: FontWeight.bold,
              color: _isFastingTime ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimesRow(
    String suhoorEnd,
    String iftarTime,
    bool isDark,
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
            isDark,
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
            isDark,
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
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    return Container(
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
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
          Text(
            label,
            style: TextStyle(
              fontSize: responsive.textSmall,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: responsive.spaceXSmall),
          Text(
            time,
            style: TextStyle(
              fontSize: responsive.textTitle,
              fontWeight: FontWeight.bold,
              color: color,
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

  void _copyDua(BuildContext context, Map<String, dynamic> dua) {
    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
      case DuaLanguage.english:
        currentTranslation = dua['english'];
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
      case DuaLanguage.arabic:
        currentTranslation = dua['english'];
    }

    final textToCopy =
        '''
${context.tr(dua['titleKey'])}

${dua['arabic']}

${dua['transliteration']}

$currentTranslation
''';

    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('dua_copied')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareDua(BuildContext context, Map<String, dynamic> dua) {
    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
      case DuaLanguage.english:
        currentTranslation = dua['english'];
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
      case DuaLanguage.arabic:
        currentTranslation = dua['english'];
    }

    final textToShare =
        '''
${context.tr(dua['titleKey'])}

${dua['arabic']}

${dua['transliteration']}

$currentTranslation
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

  List<Map<String, dynamic>> get _fastingDuas => [
    {
      'titleKey': 'dua_for_suhoor',
      'arabic': 'وَبِصَوْمِ غَدٍ نَّوَيْتُ مِنْ شَهْرِ رَمَضَانَ',
      'transliteration': 'Wa bisawmi ghadinn nawaytu min shahri Ramadan',
      'hindi': 'मैं कल रमज़ान के महीने का रोज़ा रखने की नियत करता/करती हूँ।',
      'english':
          'I intend to keep the fast for tomorrow in the month of Ramadan.',
      'urdu': 'میں کل رمضان کے مہینے کا روزہ رکھنے کی نیت کرتا/کرتی ہوں۔',
      'color': const Color(0xFF3949AB),
    },
    {
      'titleKey': 'dua_for_iftar',
      'arabic': 'اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
      'transliteration': "Allahumma laka sumtu wa 'ala rizqika aftartu",
      'hindi':
          'ऐ अल्लाह! मैंने तेरे लिए रोज़ा रखा और तेरी रिज़्क़ से इफ्तार किया।',
      'english':
          'O Allah! I fasted for You and I break my fast with Your sustenance.',
      'urdu': 'اے اللہ! میں نے تیرے لیے روزہ رکھا اور تیرے رزق سے افطار کیا۔',
      'color': const Color(0xFFE65100),
    },
  ];

  Widget _buildDuaSection(bool isDark, ResponsiveUtils responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('duas_for_fasting'),
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: responsive.spaceMedium),
        ..._fastingDuas.asMap().entries.map((entry) {
          final isExpanded = _expandedDuas.contains(entry.key);
          return Padding(
            padding: EdgeInsets.only(bottom: responsive.spaceMedium),
            child: _buildDuaCard(
              entry.key,
              entry.value,
              isExpanded,
              isDark,
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
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    String currentTranslation;
    String languageLabel;

    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
        languageLabel = context.tr('hindi');
      case DuaLanguage.english:
        currentTranslation = dua['english'];
        languageLabel = context.tr('english');
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
        languageLabel = context.tr('urdu');
      case DuaLanguage.arabic:
        currentTranslation = dua['english'];
        languageLabel = context.tr('english');
    }

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
                      child: Text(
                        context.tr(dua['titleKey']),
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                        fontFamily: 'Amiri',
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
                              Text(
                                '${context.tr('translation')} ($languageLabel)',
                                style: TextStyle(
                                  fontSize: responsive.textSmall,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
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
                              fontFamily:
                                  _selectedLanguage == DuaLanguage.arabic
                                  ? 'Amiri'
                                  : null,
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

  // Get current month fasting data
  Map<String, dynamic> _getCurrentMonthFastingData(int hijriMonth) {
    final monthsData = {
      1: {
        'name': context.tr('month_muharram'),
        'icon': Icons.nights_stay,
        'color': const Color(0xFF6A1B9A),
        'fastingDays': [
          {
            'days': '9, 10, 11',
            'desc': context.tr('ashura_fasts'),
            'type': 'sunnah',
          },
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      2: {
        'name': context.tr('month_safar'),
        'icon': Icons.wb_twilight,
        'color': const Color(0xFF00695C),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      3: {
        'name': context.tr('month_rabi_ul_awwal'),
        'icon': Icons.star,
        'color': const Color(0xFF2E7D32),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      4: {
        'name': context.tr('month_rabi_ul_aakhir'),
        'icon': Icons.star_border,
        'color': const Color(0xFF1565C0),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      5: {
        'name': context.tr('month_jumada_ul_ula'),
        'icon': Icons.brightness_5,
        'color': const Color(0xFF5E35B1),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      6: {
        'name': context.tr('month_jumada_ul_aakhira'),
        'icon': Icons.brightness_6,
        'color': const Color(0xFF00838F),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      7: {
        'name': context.tr('month_rajab'),
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF7B1FA2),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
          {
            'days': context.tr('nafil_fasts_optional'),
            'desc': context.tr('sacred_month'),
            'type': 'nafil',
          },
        ],
      },
      8: {
        'name': context.tr('month_shaban'),
        'icon': Icons.brightness_3,
        'color': const Color(0xFF303F9F),
        'fastingDays': [
          {
            'days': context.tr('more_fasts'),
            'desc': context.tr('keep_more_this_month'),
            'type': 'sunnah',
          },
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
          {
            'days': '29-30',
            'desc': context.tr('shakk_day_avoid'),
            'type': 'prohibited',
          },
        ],
      },
      9: {
        'name': context.tr('month_ramadan'),
        'icon': Icons.mosque,
        'color': const Color(0xFFC62828),
        'fastingDays': [
          {
            'days': '1-29/30',
            'desc': context.tr('compulsory_fasts_full_month'),
            'type': 'farz',
          },
        ],
      },
      10: {
        'name': context.tr('month_shawwal'),
        'icon': Icons.celebration,
        'color': const Color(0xFFEF6C00),
        'fastingDays': [
          {
            'days': '2-7',
            'desc': context.tr('six_shawwal_fasts'),
            'type': 'sunnah',
          },
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
          {
            'days': '1',
            'desc': context.tr('eid_fasting_prohibited'),
            'type': 'prohibited',
          },
        ],
      },
      11: {
        'name': context.tr('month_dhul_qadah'),
        'icon': Icons.terrain,
        'color': const Color(0xFF4E342E),
        'fastingDays': [
          {
            'days': '13, 14, 15',
            'desc': context.tr('ayyam_al_beedh'),
            'type': 'sunnah',
          },
          {
            'days': context.tr('monday_thursday'),
            'desc': context.tr('weekly_fasts'),
            'type': 'nafil',
          },
        ],
      },
      12: {
        'name': context.tr('month_dhul_hijjah'),
        'icon': Icons.landscape,
        'color': const Color(0xFF827717),
        'fastingDays': [
          {
            'days': '1-9',
            'desc': context.tr('upto_arafah_if_not_hajj'),
            'type': 'sunnah',
          },
          {
            'days': '10',
            'desc': context.tr('eid_ul_adha_prohibited'),
            'type': 'prohibited',
          },
          {
            'days': '11, 12, 13',
            'desc': context.tr('ayyam_e_tashreeq_prohibited'),
            'type': 'prohibited',
          },
        ],
      },
    };

    return monthsData[hijriMonth] ?? monthsData[1]!;
  }

  Widget _buildCurrentMonthFastingCard(
    HijriCalendar hijriDate,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    final monthData = _getCurrentMonthFastingData(hijriDate.hMonth);
    final monthName = monthData['name'] as String;
    final monthIcon = monthData['icon'] as IconData;
    final monthColor = monthData['color'] as Color;
    final fastingDays = monthData['fastingDays'] as List<Map<String, String>>;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
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
                      Text(
                        context.tr('current_month'),
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: responsive.textXXLarge,
                          fontWeight: FontWeight.bold,
                          color: monthColor,
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
                Icon(Icons.calendar_today, size: 18, color: monthColor),
                const SizedBox(width: 8),
                Text(
                  '${context.tr('today')}: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH',
                  style: TextStyle(
                    fontSize: 16,
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
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.spaceMedium),
                ...fastingDays.map(
                  (day) => _buildCurrentMonthFastingRow(
                    day['days']!,
                    day['desc']!,
                    day['type']!,
                    isDark,
                    responsive,
                  ),
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
    bool isDark,
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: context.responsive.paddingXSmall,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(typeIcon, color: typeColor, size: 16),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: typeColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              days,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: typeColor,
                decoration: type == 'prohibited'
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicMonthsChart(bool isDark, ResponsiveUtils responsive) {
    final months = [
      _IslamicMonth(
        name: context.tr('month_muharram'),
        icon: Icons.nights_stay,
        color: const Color(0xFF6A1B9A),
        fastingDays: [
          _FastingDay(
            '9, 10, 11',
            context.tr('ashura_fasts_sunnah'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_safar'),
        icon: Icons.wb_twilight,
        color: const Color(0xFF00695C),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
          _FastingDay(
            context.tr('any_nafil_fast'),
            context.tr('at_your_will'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_rabi_ul_awwal'),
        icon: Icons.star,
        color: const Color(0xFF2E7D32),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_rabi_ul_aakhir'),
        icon: Icons.star_border,
        color: const Color(0xFF1565C0),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_jumada_ul_ula'),
        icon: Icons.brightness_5,
        color: const Color(0xFF5E35B1),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_jumada_ul_aakhira'),
        icon: Icons.brightness_6,
        color: const Color(0xFF00838F),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_rajab'),
        icon: Icons.auto_awesome,
        color: const Color(0xFF7B1FA2),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
          _FastingDay(
            context.tr('any_nafil_fast'),
            context.tr('sacred_month'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_shaban'),
        icon: Icons.brightness_3,
        color: const Color(0xFF303F9F),
        fastingDays: [
          _FastingDay(
            context.tr('more_fasts'),
            context.tr('keep_more_in_month'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
          _FastingDay(
            '29-30',
            context.tr('shakk_day_avoid'),
            _FastingType.prohibited,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_ramadan'),
        icon: Icons.mosque,
        color: const Color(0xFFC62828),
        fastingDays: [
          _FastingDay(
            '1 se 29/30',
            context.tr('compulsory_fasts_full_month'),
            _FastingType.farz,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_shawwal'),
        icon: Icons.celebration,
        color: const Color(0xFFEF6C00),
        fastingDays: [
          _FastingDay(
            '2-7',
            context.tr('six_shawwal_fasts'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
          _FastingDay(
            '1',
            context.tr('eid_fasting_prohibited'),
            _FastingType.prohibited,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_dhul_qadah'),
        icon: Icons.terrain,
        color: const Color(0xFF4E342E),
        fastingDays: [
          _FastingDay(
            '13, 14, 15',
            context.tr('ayyam_al_beedh'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            context.tr('monday_thursday'),
            context.tr('every_week_optional'),
            _FastingType.nafil,
          ),
        ],
      ),
      _IslamicMonth(
        name: context.tr('month_dhul_hijjah'),
        icon: Icons.landscape,
        color: const Color(0xFF827717),
        fastingDays: [
          _FastingDay(
            '1-9',
            context.tr('upto_arafah_if_not_hajj'),
            _FastingType.sunnah,
          ),
          _FastingDay(
            '10',
            context.tr('eid_ul_adha_prohibited'),
            _FastingType.prohibited,
          ),
          _FastingDay(
            '11, 12, 13',
            context.tr('ayyam_e_tashreeq_prohibited'),
            _FastingType.prohibited,
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('islamic_months_fasting_chart'),
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: responsive.spaceMedium),
        ...months.asMap().entries.map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: responsive.spaceSmall),
            child: _buildMonthCard(entry.key, entry.value, isDark, responsive),
          ),
        ),
        SizedBox(height: responsive.spaceRegular),

        // Prohibited Days Summary
        _buildProhibitedDaysSummary(isDark, responsive),
        SizedBox(height: responsive.spaceRegular),

        // Quick Rules
        _buildQuickRulesSummary(isDark, responsive),
      ],
    );
  }

  Widget _buildMonthCard(
    int index,
    _IslamicMonth month,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    final isExpanded = _expandedMonths.contains(index);

    return GestureDetector(
      onTap: () => _toggleMonth(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(responsive.radiusLarge),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade700
                : (isExpanded
                      ? AppColors.primaryLight
                      : AppColors.lightGreenBorder),
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: isDark
              ? null
              : [
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
                    ? month.color.withValues(alpha: 0.1)
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
                      color: month.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(month.icon, color: month.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          month.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${month.fastingDays.length} ${context.tr('fasting_options')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: month.color,
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
                    ...month.fastingDays.map(
                      (day) => _buildFastingDayRow(day, isDark, responsive),
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
    _FastingDay day,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    Color typeColor;
    IconData typeIcon;
    String typeLabel;

    switch (day.type) {
      case _FastingType.farz:
        typeColor = Colors.red;
        typeIcon = Icons.star;
        typeLabel = context.tr('farz');
        break;
      case _FastingType.sunnah:
        typeColor = Colors.green;
        typeIcon = Icons.check_circle;
        typeLabel = context.tr('sunnah');
        break;
      case _FastingType.nafil:
        typeColor = Colors.blue;
        typeIcon = Icons.favorite;
        typeLabel = context.tr('nafil');
        break;
      case _FastingType.prohibited:
        typeColor = Colors.red.shade900;
        typeIcon = Icons.cancel;
        typeLabel = context.tr('mana');
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: context.responsive.paddingXSmall,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(typeIcon, color: typeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.days,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    decoration: day.type == _FastingType.prohibited
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  day.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: typeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProhibitedDaysSummary(bool isDark, ResponsiveUtils responsive) {
    final prohibitedDays = [
      context.tr('eid_ul_fitr_shawwal_1'),
      context.tr('eid_ul_adha_dhul_hijjah_10'),
      context.tr('ayyam_tashreeq_days'),
    ];

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
              Icon(Icons.cancel, color: Colors.red.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                context.tr('fasting_prohibited'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...prohibitedDays.map(
            (day) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.block, color: Colors.red.shade400, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    day,
                    style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRulesSummary(bool isDark, ResponsiveUtils responsive) {
    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
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
              Icon(Icons.lightbulb, color: AppColors.secondary, size: 24),
              const SizedBox(width: 8),
              Text(
                context.tr('quick_rules_remember'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQuickRuleRow(
            Icons.calendar_month,
            context.tr('every_month'),
            '13, 14, 15 (${context.tr('ayyam_al_beedh')})',
            Colors.green,
            isDark,
            responsive,
          ),
          _buildQuickRuleRow(
            Icons.repeat,
            context.tr('every_week'),
            context.tr('monday_thursday'),
            Colors.blue,
            isDark,
            responsive,
          ),
          _buildQuickRuleRow(
            Icons.star,
            context.tr('special_fasts'),
            '${context.tr('ashura_fasts')}, ${context.tr('day_of_arafah')}, 6 ${context.tr('month_shawwal')}',
            Colors.purple,
            isDark,
            responsive,
          ),
          _buildQuickRuleRow(
            Icons.mosque,
            context.tr('compulsory'),
            context.tr('full_ramadan_month'),
            Colors.red,
            isDark,
            responsive,
          ),
          _buildQuickRuleRow(
            Icons.block,
            context.tr('forbidden'),
            context.tr('only_eid_days'),
            Colors.grey,
            isDark,
            responsive,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRuleRow(
    IconData icon,
    String label,
    String value,
    Color color,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper classes
enum _FastingType { farz, sunnah, nafil, prohibited }

class _FastingDay {
  final String days;
  final String description;
  final _FastingType type;

  _FastingDay(this.days, this.description, this.type);
}

class _IslamicMonth {
  final String name;
  final IconData icon;
  final Color color;
  final List<_FastingDay> fastingDays;

  _IslamicMonth({
    required this.name,
    required this.icon,
    required this.color,
    required this.fastingDays,
  });
}
