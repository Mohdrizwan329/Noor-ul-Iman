import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../data/models/dua_model.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/language_provider.dart';

class RamadanTrackerScreen extends StatefulWidget {
  const RamadanTrackerScreen({super.key});

  @override
  State<RamadanTrackerScreen> createState() => _RamadanTrackerScreenState();
}

class _RamadanTrackerScreenState extends State<RamadanTrackerScreen> {
  Map<int, FastingDay> _fastingDays = {};
  final int _currentRamadanYear = HijriCalendar.now().hYear;
  bool _isRamadan = false;
  int _currentDay = 0;
  int _totalFasted = 0;
  int _totalMissed = 0;

  // Dua related state
  final FlutterTts _flutterTts = FlutterTts();
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;
  int? _playingDuaIndex;
  bool _isSpeaking = false;
  final Set<int> _expandedDuas = {};

  @override
  void initState() {
    super.initState();
    _initializeFastingDays();
    _checkRamadan();
    _loadFastingData();
    _initTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLanguageWithApp();
  }

  void _syncLanguageWithApp() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
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
    final hijri = HijriCalendar.now();
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

  // Ramadan Duas Data
  List<Map<String, dynamic>> get _ramadanDuas => [
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
    {
      'titleKey': 'dua_when_breaking_fast',
      'arabic':
          'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
      'transliteration':
          "Dhahaba al-zama' wa abtallatil-'urooq wa thabatal-ajru in sha Allah",
      'hindi':
          'प्यास बुझ गई, नसें तर हो गईं और अगर अल्लाह ने चाहा तो सवाब मिल गया।',
      'english':
          'The thirst has gone, the veins are moistened and the reward is confirmed, if Allah wills.',
      'urdu':
          'پیاس بجھ گئی، رگیں تر ہو گئیں اور اگر اللہ نے چاہا تو ثواب مل گیا۔',
      'color': const Color(0xFF2E7D32),
    },
    {
      'titleKey': 'dua_for_laylatul_qadr',
      'arabic': 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      'transliteration': "Allahumma innaka 'afuwwun tuhibbul-'afwa fa'fu 'anni",
      'hindi':
          'ऐ अल्लाह! तू माफ करने वाला है, माफी को पसंद करता है, तो मुझे माफ कर दे।',
      'english':
          'O Allah, You are Forgiving and love forgiveness, so forgive me.',
      'urdu':
          'اے اللہ! تو معاف کرنے والا ہے، معافی کو پسند کرتا ہے، تو مجھے معاف کر دے۔',
      'color': const Color(0xFF6A1B9A),
    },
    {
      'titleKey': 'dua_for_taraweeh',
      'arabic':
          'سُبْحَانَ ذِي الْمُلْكِ وَالْمَلَكُوتِ سُبْحَانَ ذِي الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ',
      'transliteration':
          "Subhana dhil-mulki wal-malakoot, subhana dhil-'izzati wal-'azamati wal-haybati wal-qudrati",
      'hindi':
          'पाक है वो जो बादशाहत और सल्तनत का मालिक है, पाक है वो जो इज़्ज़त, अज़मत, हैबत और क़ुदरत वाला है।',
      'english':
          'Glory be to the Owner of the Kingdom and the Dominion, Glory be to the Owner of Might, Grandeur, Awe and Power.',
      'urdu':
          'پاک ہے وہ جو بادشاہت اور سلطنت کا مالک ہے، پاک ہے وہ جو عزت، عظمت، ہیبت اور قدرت والا ہے۔',
      'color': const Color(0xFF00695C),
    },
  ];

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
    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
      case DuaLanguage.english:
        currentTranslation = dua['english'];
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
      case DuaLanguage.arabic:
        currentTranslation =
            dua['english']; // Arabic users see English translation
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
        currentTranslation =
            dua['english']; // Arabic users see English translation
    }

    final textToShare =
        '''
${context.tr(dua['titleKey'])}

${dua['arabic']}

${dua['transliteration']}

$currentTranslation

${context.tr('shared_from_app')}
''';

    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final prayerProvider = context.watch<PrayerProvider>();
    final prayerTimes = prayerProvider.todayPrayerTimes;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('ramadan_tracker_title'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: SingleChildScrollView(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ramadan Status Card
            _buildStatusCard(responsive),
            SizedBox(height: responsive.spaceRegular),

            // Suhoor & Iftar Times
            if (prayerTimes != null) ...[
              _buildFastingTimesCard(
                prayerTimes.fajr,
                prayerTimes.maghrib,
                responsive,
              ),
              SizedBox(height: responsive.spaceRegular),
            ],

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
            ),
            SizedBox(height: responsive.spaceMedium),
            _buildFastingGridCard(responsive),

            SizedBox(height: responsive.spaceXXLarge),

            // Ramadan Duas Section
            _buildDuasSection(responsive),
          ],
        ),
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
            Container(height: 60, width: 1, color: AppColors.lightGreenBorder),
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
    return Column(
      children: [
        Icon(icon, color: color, size: responsive.iconMedium),
        SizedBox(height: responsive.spaceSmall),
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.textSmall,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: responsive.spaceXSmall),
        Text(
          time,
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(ResponsiveUtils responsive) {
    return Container(
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
              SizedBox(width: responsive.spaceMedium),
              Expanded(
                child: _buildStatItem(
                  context.tr('missed'),
                  _totalMissed,
                  Colors.red,
                  Icons.cancel,
                  responsive,
                ),
              ),
              SizedBox(width: responsive.spaceMedium),
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
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: responsive.iconMedium),
          SizedBox(height: responsive.spaceXSmall),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: responsive.textXLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: responsive.spaceXSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: responsive.textXSmall,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFastingGridCard(ResponsiveUtils responsive) {
    return Container(
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
            child: Text(
              context.tr(day),
              style: TextStyle(
                fontSize: responsive.textXSmall,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
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
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: responsive.textRegular,
              fontWeight: FontWeight.bold,
              color: textColor,
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
          style: TextStyle(fontSize: responsive.textRegular),
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
              children: [
                Icon(icon, color: color, size: responsive.iconMedium),
                SizedBox(width: responsive.spaceSmall),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: responsive.textRegular,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDuasSection(ResponsiveUtils responsive) {
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

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _ramadanDuas.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: responsive.spaceRegular),
          itemBuilder: (context, index) {
            final dua = _ramadanDuas[index];
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

    final isPlayingArabic = _playingDuaIndex == (index * 2) && _isSpeaking;
    final isPlayingTranslation =
        _playingDuaIndex == (index * 2 + 1) && _isSpeaking;
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
                          '${index + 1}',
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
                          _playDua(index * 2, dua['arabic'], isArabic: true),
                      isActive: isPlayingArabic,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleDuaExpanded(index),
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
                _playDua(index * 2, dua['arabic'], isArabic: true);
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
