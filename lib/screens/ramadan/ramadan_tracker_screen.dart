import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import '../../data/models/dua_model.dart';
import '../../providers/prayer_provider.dart';

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
      'title': 'Dua for Suhoor (Sehri)',
      'arabic': 'وَبِصَوْمِ غَدٍ نَّوَيْتُ مِنْ شَهْرِ رَمَضَانَ',
      'transliteration': 'Wa bisawmi ghadinn nawaytu min shahri Ramadan',
      'hindi': 'मैं कल रमज़ान के महीने का रोज़ा रखने की नियत करता/करती हूँ।',
      'english': 'I intend to keep the fast for tomorrow in the month of Ramadan.',
      'urdu': 'میں کل رمضان کے مہینے کا روزہ رکھنے کی نیت کرتا/کرتی ہوں۔',
      'color': const Color(0xFF3949AB),
    },
    {
      'title': 'Dua for Iftar',
      'arabic': 'اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
      'transliteration': "Allahumma laka sumtu wa 'ala rizqika aftartu",
      'hindi': 'ऐ अल्लाह! मैंने तेरे लिए रोज़ा रखा और तेरी रिज़्क़ से इफ्तार किया।',
      'english': 'O Allah! I fasted for You and I break my fast with Your sustenance.',
      'urdu': 'اے اللہ! میں نے تیرے لیے روزہ رکھا اور تیرے رزق سے افطار کیا۔',
      'color': const Color(0xFFE65100),
    },
    {
      'title': 'Dua When Breaking Fast',
      'arabic': 'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
      'transliteration': "Dhahaba al-zama' wa abtallatil-'urooq wa thabatal-ajru in sha Allah",
      'hindi': 'प्यास बुझ गई, नसें तर हो गईं और अगर अल्लाह ने चाहा तो सवाब मिल गया।',
      'english': 'The thirst has gone, the veins are moistened and the reward is confirmed, if Allah wills.',
      'urdu': 'پیاس بجھ گئی، رگیں تر ہو گئیں اور اگر اللہ نے چاہا تو ثواب مل گیا۔',
      'color': const Color(0xFF2E7D32),
    },
    {
      'title': 'Dua for Laylatul Qadr',
      'arabic': 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      'transliteration': "Allahumma innaka 'afuwwun tuhibbul-'afwa fa'fu 'anni",
      'hindi': 'ऐ अल्लाह! तू माफ करने वाला है, माफी को पसंद करता है, तो मुझे माफ कर दे।',
      'english': 'O Allah, You are Forgiving and love forgiveness, so forgive me.',
      'urdu': 'اے اللہ! تو معاف کرنے والا ہے، معافی کو پسند کرتا ہے، تو مجھے معاف کر دے۔',
      'color': const Color(0xFF6A1B9A),
    },
    {
      'title': 'Dua for Taraweeh',
      'arabic': 'سُبْحَانَ ذِي الْمُلْكِ وَالْمَلَكُوتِ سُبْحَانَ ذِي الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ',
      'transliteration': "Subhana dhil-mulki wal-malakoot, subhana dhil-'izzati wal-'azamati wal-haybati wal-qudrati",
      'hindi': 'पाक है वो जो बादशाहत और सल्तनत का मालिक है, पाक है वो जो इज़्ज़त, अज़मत, हैबत और क़ुदरत वाला है।',
      'english': 'Glory be to the Owner of the Kingdom and the Dominion, Glory be to the Owner of Might, Grandeur, Awe and Power.',
      'urdu': 'پاک ہے وہ جو بادشاہت اور سلطنت کا مالک ہے، پاک ہے وہ جو عزت، عظمت، ہیبت اور قدرت والا ہے۔',
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

  void _toggleDuaExpanded(int index) {
    setState(() {
      if (_expandedDuas.contains(index)) {
        _expandedDuas.remove(index);
      } else {
        _expandedDuas.add(index);
      }
    });
  }

  void _copyDua(Map<String, dynamic> dua) {
    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
      case DuaLanguage.english:
        currentTranslation = dua['english'];
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
    }

    final textToCopy = '''
${dua['title']}

${dua['arabic']}

${dua['transliteration']}

$currentTranslation
''';

    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dua copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareDua(Map<String, dynamic> dua) {
    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
      case DuaLanguage.english:
        currentTranslation = dua['english'];
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
    }

    final textToShare = '''
${dua['title']}

${dua['arabic']}

${dua['transliteration']}

$currentTranslation

- Shared from Jiyan Islamic Academy App
''';

    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    final prayerProvider = context.watch<PrayerProvider>();
    final prayerTimes = prayerProvider.todayPrayerTimes;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Ramadan Tracker'),
        actions: [
          // Language selector popup
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ramadan Status Card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Suhoor & Iftar Times
            if (prayerTimes != null) ...[
              _buildFastingTimesCard(prayerTimes.fajr, prayerTimes.maghrib),
              const SizedBox(height: 16),
            ],

            // Statistics
            _buildStatisticsCard(),
            const SizedBox(height: 16),

            // Fasting Days Grid
            Text(
              'Fasting Days - Ramadan $_currentRamadanYear',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildFastingGrid(),

            const SizedBox(height: 24),

            // Ramadan Duas Section
            _buildDuasSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            _isRamadan ? Icons.nights_stay : Icons.calendar_month,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            _isRamadan ? 'Ramadan Mubarak!' : 'Ramadan Tracker',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isRamadan
                ? 'Day $_currentDay of Ramadan'
                : 'Track your fasting for Ramadan $_currentRamadanYear',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastingTimesCard(String suhoorEnd, String iftarTime) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildTimeColumn(
                'Suhoor Ends',
                suhoorEnd,
                Icons.wb_twilight,
                Colors.indigo,
              ),
            ),
            Container(height: 60, width: 1, color: AppColors.lightGreenBorder),
            Expanded(
              child: _buildTimeColumn(
                'Iftar Time',
                iftarTime,
                Icons.nights_stay,
                Colors.orange,
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
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard() {
    final remaining = 30 - _totalFasted - _totalMissed;
    final progress = _totalFasted / 30;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Completed', _totalFasted, Colors.green),
                _buildStatItem('Missed', _totalMissed, Colors.red),
                _buildStatItem('Remaining', remaining, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildFastingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        final day = index + 1;
        final fastingDay = _fastingDays[day]!;
        return _buildDayTile(fastingDay);
      },
    );
  }

  Widget _buildDayTile(FastingDay day) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (day.status) {
      case FastingStatus.completed:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        icon = Icons.check;
      case FastingStatus.missed:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.close;
      case FastingStatus.pending:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.black87;
        icon = null;
    }

    return InkWell(
      onTap: () => _showDayOptions(day.day),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: _isRamadan && day.day == _currentDay
              ? Border.all(color: AppColors.secondary, width: 3)
              : null,
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: textColor, size: 20)
              : Text(
                  '${day.day}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  void _showDayOptions(int day) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Day $day', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  'Fasted',
                  Icons.check_circle,
                  Colors.green,
                  () {
                    _updateFastingStatus(day, FastingStatus.completed);
                    Navigator.pop(context);
                  },
                ),
                _buildOptionButton('Missed', Icons.cancel, Colors.red, () {
                  _updateFastingStatus(day, FastingStatus.missed);
                  Navigator.pop(context);
                }),
                _buildOptionButton('Reset', Icons.refresh, Colors.grey, () {
                  _updateFastingStatus(day, FastingStatus.pending);
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Duas Section
  Widget _buildDuasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ramadan Duas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ..._ramadanDuas.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDuaCard(entry.key, entry.value),
              ),
            ),
      ],
    );
  }

  Widget _buildDuaCard(int duaIndex, Map<String, dynamic> dua) {
    final isExpanded = _expandedDuas.contains(duaIndex);
    final color = dua['color'] as Color;
    final isCurrentlyPlaying = _playingDuaIndex == duaIndex && _isSpeaking;

    String currentTranslation;
    switch (_selectedLanguage) {
      case DuaLanguage.hindi:
        currentTranslation = dua['hindi'];
      case DuaLanguage.english:
        currentTranslation = dua['english'];
      case DuaLanguage.urdu:
        currentTranslation = dua['urdu'];
    }

    return GestureDetector(
      onTap: () => _toggleDuaExpanded(duaIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded ? AppColors.primaryLight : AppColors.lightGreenBorder,
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isExpanded ? 0.12 : 0.08),
              blurRadius: isExpanded ? 12 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(15),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.menu_book, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dua['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: color,
                  ),
                ],
              ),
            ),

            // Expanded Content
            if (isExpanded) ...[
              // Arabic text
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Arabic with audio button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            dua['arabic'],
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              height: 1.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _playDua(duaIndex, dua['arabic'], isArabic: true),
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
                                color: isCurrentlyPlaying ? color : Colors.grey.shade300,
                              ),
                            ),
                            child: Icon(
                              isCurrentlyPlaying ? Icons.stop : Icons.volume_up,
                              size: 18,
                              color: isCurrentlyPlaying ? color : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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

                    // Translation with audio
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              currentTranslation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                              textDirection: _selectedLanguage == DuaLanguage.urdu
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _playDua(duaIndex + 100, currentTranslation),
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
                    ),
                    const SizedBox(height: 16),

                    // Action buttons: Copy and Share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Copy button
                        InkWell(
                          onTap: () => _copyDua(dua),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.copy, size: 16, color: Colors.grey.shade700),
                                const SizedBox(width: 6),
                                Text(
                                  'Copy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Share button
                        InkWell(
                          onTap: () => _shareDua(dua),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.share, size: 16, color: color),
                                const SizedBox(width: 6),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum FastingStatus { pending, completed, missed }

class FastingDay {
  final int day;
  final FastingStatus status;
  final String? notes;

  FastingDay({required this.day, required this.status, this.notes});

  FastingDay copyWith({FastingStatus? status, String? notes}) {
    return FastingDay(
      day: day,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'status': status.index,
    'notes': notes,
  };

  factory FastingDay.fromJson(Map<String, dynamic> json) => FastingDay(
    day: json['day'],
    status: FastingStatus.values[json['status']],
    notes: json['notes'],
  );
}
