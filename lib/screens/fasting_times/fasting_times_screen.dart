import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/dua_model.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/settings_provider.dart';

class FastingTimesScreen extends StatefulWidget {
  const FastingTimesScreen({super.key});

  @override
  State<FastingTimesScreen> createState() => _FastingTimesScreenState();
}

class _FastingTimesScreenState extends State<FastingTimesScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  bool _isFastingTime = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Track which dua cards have translation visible
  final Set<int> _duasWithTranslation = {};

  // Track which month cards are expanded
  final Set<int> _expandedMonths = {};

  // TTS and language
  final FlutterTts _flutterTts = FlutterTts();
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;
  int? _playingDuaIndex;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _startTimer();
    _initTts();
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
    _pulseController.dispose();
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
      String cleanTime = timeStr.trim().replaceAll(RegExp(r'\s*(AM|PM)\s*', caseSensitive: false), '');

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
    final prayerProvider = context.watch<PrayerProvider>();
    final prayerTimes = prayerProvider.todayPrayerTimes;
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final hijriDate = HijriCalendar.now();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Fasting'),
        centerTitle: true,
        actions: [
          PopupMenuButton<DuaLanguage>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _selectedLanguage == DuaLanguage.hindi
                        ? 'HI'
                        : _selectedLanguage == DuaLanguage.english
                        ? 'EN'
                        : 'UR',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onSelected: _changeLanguage,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: DuaLanguage.hindi,
                child: Row(
                  children: [
                    Icon(
                      _selectedLanguage == DuaLanguage.hindi
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedLanguage == DuaLanguage.hindi
                          ? AppColors.primary
                          : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Hindi (हिंदी)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: DuaLanguage.english,
                child: Row(
                  children: [
                    Icon(
                      _selectedLanguage == DuaLanguage.english
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedLanguage == DuaLanguage.english
                          ? AppColors.primary
                          : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: DuaLanguage.urdu,
                child: Row(
                  children: [
                    Icon(
                      _selectedLanguage == DuaLanguage.urdu
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedLanguage == DuaLanguage.urdu
                          ? AppColors.primary
                          : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Urdu (اردو)'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: prayerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prayerTimes == null
          ? _buildNoDataView(isDark)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Current Month Fasting Dates
                  _buildCurrentMonthFastingCard(hijriDate, isDark),
                  const SizedBox(height: 20),

                  // Current Status Card
                  _buildStatusCard(isDark),
                  const SizedBox(height: 20),

                  // Suhoor & Iftar Times
                  _buildTimesRow(prayerTimes.fajr, prayerTimes.maghrib, isDark),
                  const SizedBox(height: 20),

                  // Dua Cards
                  _buildDuaSection(isDark),
                  const SizedBox(height: 20),

                  // Islamic 12 Months Fasting Chart
                  _buildIslamicMonthsChart(isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildNoDataView(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load prayer times',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please enable location services',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isFastingTime ? _pulseAnimation.value : 1.0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isFastingTime
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
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
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  _isFastingTime ? 'Currently Fasting' : 'Not Fasting Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isFastingTime ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimesRow(String suhoorEnd, String iftarTime, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeCard(
            'Suhoor Ends',
            suhoorEnd,
            Icons.wb_twilight,
            const Color(0xFF3949AB),
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeCard(
            'Iftar Time',
            iftarTime,
            Icons.nights_stay,
            const Color(0xFFE65100),
            isDark,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: isDark ? null : [
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDuaTranslation(int duaIndex) {
    setState(() {
      if (_duasWithTranslation.contains(duaIndex)) {
        _duasWithTranslation.remove(duaIndex);
      } else {
        _duasWithTranslation.add(duaIndex);
      }
    });
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
      }
    }

    await _flutterTts.setLanguage(langCode);
    setState(() {
      _isSpeaking = true;
      _playingDuaIndex = index;
    });

    await _flutterTts.speak(text);
  }

  void _changeLanguage(DuaLanguage language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  List<Map<String, dynamic>> get _fastingDuas => [
    {
      'title': 'Dua for Suhoor (Intention)',
      'arabic': 'وَبِصَوْمِ غَدٍ نَّوَيْتُ مِنْ شَهْرِ رَمَضَانَ',
      'transliteration': 'Wa bisawmi ghadinn nawaytu min shahri Ramadan',
      'hindi': 'मैं कल रमज़ान के महीने का रोज़ा रखने की नियत करता/करती हूँ।',
      'english':
          'I intend to keep the fast for tomorrow in the month of Ramadan.',
      'urdu': 'میں کل رمضان کے مہینے کا روزہ رکھنے کی نیت کرتا/کرتی ہوں۔',
      'color': const Color(0xFF3949AB),
    },
    {
      'title': 'Dua for Breaking Fast (Iftar)',
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

  Widget _buildDuaSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duas for Fasting',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._fastingDuas.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDuaCard(entry.key, entry.value, isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildDuaCard(int duaIndex, Map<String, dynamic> dua, bool isDark) {
    final showTranslation = _duasWithTranslation.contains(duaIndex);
    final color = dua['color'] as Color;
    final isCurrentlyPlaying = _playingDuaIndex == duaIndex && _isSpeaking;

    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
        break;
      case DuaLanguage.english:
        currentTranslation = dua['english'];
        break;
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : (showTranslation ? AppColors.primaryLight : AppColors.lightGreenBorder),
          width: showTranslation ? 2 : 1.5,
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with title and buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dua['title'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Audio play button for Arabic
                InkWell(
                  onTap: () =>
                      _playDua(duaIndex, dua['arabic'], isArabic: true),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCurrentlyPlaying
                          ? color.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrentlyPlaying
                            ? color
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Icon(
                      isCurrentlyPlaying ? Icons.stop : Icons.volume_up,
                      size: 18,
                      color: isCurrentlyPlaying ? color : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Translate button
                InkWell(
                  onTap: () => _toggleDuaTranslation(duaIndex),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: showTranslation
                          ? color.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: showTranslation ? color : Colors.grey.shade300,
                      ),
                    ),
                    child: Icon(
                      Icons.translate,
                      size: 18,
                      color: showTranslation ? color : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Arabic text
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              dua['arabic'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.arabicText,
                height: 1.8,
              ),
            ),
          ),

          // Translation section (visible when toggled)
          if (showTranslation)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transliteration
                  Text(
                    dua['transliteration'],
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Translation with audio button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          currentTranslation,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textDirection: _selectedLanguage == DuaLanguage.urdu
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Audio button for translation
                      InkWell(
                        onTap: () =>
                            _playDua(duaIndex + 100, currentTranslation),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _playingDuaIndex == duaIndex + 100 && _isSpeaking
                                ? Icons.stop
                                : Icons.play_arrow,
                            size: 16,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
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
        'name': 'Muharram',
        'icon': Icons.nights_stay,
        'color': const Color(0xFF6A1B9A),
        'fastingDays': [
          {'days': '9, 10, 11', 'desc': 'Ashura ke roze', 'type': 'sunnah'},
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      2: {
        'name': 'Safar',
        'icon': Icons.wb_twilight,
        'color': const Color(0xFF00695C),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      3: {
        'name': "Rabi'ul-Awwal",
        'icon': Icons.star,
        'color': const Color(0xFF2E7D32),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      4: {
        'name': "Rabi'ul-Aakhir",
        'icon': Icons.star_border,
        'color': const Color(0xFF1565C0),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      5: {
        'name': 'Jumada-ul-Ula',
        'icon': Icons.brightness_5,
        'color': const Color(0xFF5E35B1),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      6: {
        'name': 'Jumada-ul-Aakhira',
        'icon': Icons.brightness_6,
        'color': const Color(0xFF00838F),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      7: {
        'name': 'Rajab',
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF7B1FA2),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
          {'days': 'Nafil roze', 'desc': 'Muqaddas mahina', 'type': 'nafil'},
        ],
      },
      8: {
        'name': "Sha'ban",
        'icon': Icons.brightness_3,
        'color': const Color(0xFF303F9F),
        'fastingDays': [
          {
            'days': 'Zyada roze',
            'desc': 'Is mahine mein zyada rakhein',
            'type': 'sunnah',
          },
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
          {
            'days': '29-30',
            'desc': 'Shakk ka din - avoid',
            'type': 'prohibited',
          },
        ],
      },
      9: {
        'name': 'Ramadan',
        'icon': Icons.mosque,
        'color': const Color(0xFFC62828),
        'fastingDays': [
          {
            'days': '1-29/30',
            'desc': 'Farz Roze - Poora mahina',
            'type': 'farz',
          },
        ],
      },
      10: {
        'name': 'Shawwal',
        'icon': Icons.celebration,
        'color': const Color(0xFFEF6C00),
        'fastingDays': [
          {'days': '2-7', 'desc': '6 Shawwal ke roze', 'type': 'sunnah'},
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
          {
            'days': '1 Shawwal',
            'desc': 'Eid - Roza MANA',
            'type': 'prohibited',
          },
        ],
      },
      11: {
        'name': "Dhul-Qa'dah",
        'icon': Icons.terrain,
        'color': const Color(0xFF4E342E),
        'fastingDays': [
          {'days': '13, 14, 15', 'desc': 'Ayyam al-Beedh', 'type': 'sunnah'},
          {'days': 'Mon & Thu', 'desc': 'Har hafte', 'type': 'nafil'},
        ],
      },
      12: {
        'name': 'Dhul-Hijjah',
        'icon': Icons.landscape,
        'color': const Color(0xFF827717),
        'fastingDays': [
          {
            'days': '1-9',
            'desc': 'Arafah tak (Hajj par na ho)',
            'type': 'sunnah',
          },
          {'days': '10', 'desc': 'Eid-ul-Adha - MANA', 'type': 'prohibited'},
          {
            'days': '11, 12, 13',
            'desc': 'Ayyam-e-Tashreeq - MANA',
            'type': 'prohibited',
          },
        ],
      },
    };

    return monthsData[hijriMonth] ?? monthsData[1]!;
  }

  Widget _buildCurrentMonthFastingCard(HijriCalendar hijriDate, bool isDark) {
    final monthData = _getCurrentMonthFastingData(hijriDate.hMonth);
    final monthName = monthData['name'] as String;
    final monthIcon = monthData['icon'] as IconData;
    final monthColor = monthData['color'] as Color;
    final fastingDays = monthData['fastingDays'] as List<Map<String, String>>;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            monthColor.withValues(alpha: 0.15),
            monthColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: monthColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: monthColor.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with month name
          Container(
            padding: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: monthColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(monthIcon, color: monthColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Month',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 22,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: monthColor.withValues(alpha: 0.08),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18, color: monthColor),
                const SizedBox(width: 8),
                Text(
                  'Today: ',
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fasting Dates This Month',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...fastingDays.map(
                  (day) => _buildCurrentMonthFastingRow(
                    day['days']!,
                    day['desc']!,
                    day['type']!,
                    isDark,
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
            padding: const EdgeInsets.all(6),
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

  Widget _buildIslamicMonthsChart(bool isDark) {
    final months = [
      _IslamicMonth(
        name: 'Muharram',
        icon: Icons.nights_stay,
        color: const Color(0xFF6A1B9A),
        fastingDays: [
          _FastingDay(
            '9, 10, 11 Muharram',
            'Ashura ke roze - Sunnah',
            _FastingType.sunnah,
          ),
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: 'Safar',
        icon: Icons.wb_twilight,
        color: const Color(0xFF00695C),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
          _FastingDay('Any nafil roza', 'Apni marzi se', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: "Rabi'ul-Awwal",
        icon: Icons.star,
        color: const Color(0xFF2E7D32),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: "Rabi'ul-Aakhir",
        icon: Icons.star_border,
        color: const Color(0xFF1565C0),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: 'Jumada-ul-Ula',
        icon: Icons.brightness_5,
        color: const Color(0xFF5E35B1),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: 'Jumada-ul-Aakhira',
        icon: Icons.brightness_6,
        color: const Color(0xFF00838F),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: 'Rajab',
        icon: Icons.auto_awesome,
        color: const Color(0xFF7B1FA2),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
          _FastingDay('Any nafil roza', 'Muqaddas mahina', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: "Sha'ban",
        icon: Icons.brightness_3,
        color: const Color(0xFF303F9F),
        fastingDays: [
          _FastingDay(
            'Zyada nafil roze',
            'Is mahine mein zyada rakhein',
            _FastingType.sunnah,
          ),
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
          _FastingDay(
            '29-30 Sha\'ban',
            'Shakk ka din - avoid karein',
            _FastingType.prohibited,
          ),
        ],
      ),
      _IslamicMonth(
        name: 'Ramadan',
        icon: Icons.mosque,
        color: const Color(0xFFC62828),
        fastingDays: [
          _FastingDay(
            '1 se 29/30',
            'Farz Roze - Poora mahina',
            _FastingType.farz,
          ),
        ],
      ),
      _IslamicMonth(
        name: 'Shawwal',
        icon: Icons.celebration,
        color: const Color(0xFFEF6C00),
        fastingDays: [
          _FastingDay(
            '2-7 Shawwal',
            '6 Shawwal ke roze - Sunnah',
            _FastingType.sunnah,
          ),
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
          _FastingDay(
            '1 Shawwal (Eid)',
            'Roza MANA hai',
            _FastingType.prohibited,
          ),
        ],
      ),
      _IslamicMonth(
        name: "Dhul-Qa'dah",
        icon: Icons.terrain,
        color: const Color(0xFF4E342E),
        fastingDays: [
          _FastingDay('13, 14, 15', 'Ayyam al-Beedh', _FastingType.sunnah),
          _FastingDay('Monday & Thursday', 'Har hafte', _FastingType.nafil),
        ],
      ),
      _IslamicMonth(
        name: 'Dhul-Hijjah',
        icon: Icons.landscape,
        color: const Color(0xFF827717),
        fastingDays: [
          _FastingDay(
            '1-9 Dhul-Hijjah',
            'Arafah tak (agar Hajj par na ho)',
            _FastingType.sunnah,
          ),
          _FastingDay(
            '10 Dhul-Hijjah',
            'Eid-ul-Adha - MANA',
            _FastingType.prohibited,
          ),
          _FastingDay(
            '11, 12, 13',
            'Ayyam-e-Tashreeq - MANA',
            _FastingType.prohibited,
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Islamic 12 Months - Fasting Chart',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...months.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildMonthCard(entry.key, entry.value, isDark),
          ),
        ),
        const SizedBox(height: 16),

        // Prohibited Days Summary
        _buildProhibitedDaysSummary(isDark),
        const SizedBox(height: 16),

        // Quick Rules
        _buildQuickRulesSummary(isDark),
      ],
    );
  }

  Widget _buildMonthCard(int index, _IslamicMonth month, bool isDark) {
    final isExpanded = _expandedMonths.contains(index);

    return GestureDetector(
      onTap: () => _toggleMonth(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade700
                : (isExpanded ? AppColors.primaryLight : AppColors.lightGreenBorder),
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isExpanded ? 0.12 : 0.08),
              blurRadius: isExpanded ? 12 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.all(10),
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
                          '${month.fastingDays.length} fasting options',
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const Divider(),
                    ...month.fastingDays.map(
                      (day) => _buildFastingDayRow(day, isDark),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFastingDayRow(_FastingDay day, bool isDark) {
    Color typeColor;
    IconData typeIcon;
    String typeLabel;

    switch (day.type) {
      case _FastingType.farz:
        typeColor = Colors.red;
        typeIcon = Icons.star;
        typeLabel = 'Farz';
        break;
      case _FastingType.sunnah:
        typeColor = Colors.green;
        typeIcon = Icons.check_circle;
        typeLabel = 'Sunnah';
        break;
      case _FastingType.nafil:
        typeColor = Colors.blue;
        typeIcon = Icons.favorite;
        typeLabel = 'Nafil';
        break;
      case _FastingType.prohibited:
        typeColor = Colors.red.shade900;
        typeIcon = Icons.cancel;
        typeLabel = 'Mana';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
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

  Widget _buildProhibitedDaysSummary(bool isDark) {
    final prohibitedDays = [
      '1 Shawwal (Eid-ul-Fitr)',
      '10 Dhul-Hijjah (Eid-ul-Adha)',
      '11, 12, 13 Dhul-Hijjah (Ayyam-e-Tashreeq)',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
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
                'Roza MANA Hai (Prohibited)',
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

  Widget _buildQuickRulesSummary(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: isDark ? null : [
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
                'Quick Rules - Yaad Rakhein',
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
            'Har Mahine:',
            '13, 14, 15 (Ayyam al-Beedh)',
            Colors.green,
            isDark,
          ),
          _buildQuickRuleRow(
            Icons.repeat,
            'Har Hafte:',
            'Monday & Thursday',
            Colors.blue,
            isDark,
          ),
          _buildQuickRuleRow(
            Icons.star,
            'Special:',
            'Ashura, Arafah, 6 Shawwal',
            Colors.purple,
            isDark,
          ),
          _buildQuickRuleRow(
            Icons.mosque,
            'Farz:',
            'Ramadan ka poora mahina',
            Colors.red,
            isDark,
          ),
          _buildQuickRuleRow(
            Icons.block,
            'Mana:',
            'Sirf Eid ke din',
            Colors.grey,
            isDark,
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
