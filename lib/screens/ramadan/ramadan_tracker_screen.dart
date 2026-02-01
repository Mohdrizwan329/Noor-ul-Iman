import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/dua_model.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/language_provider.dart';

class RamadanTrackerScreen extends StatefulWidget {
  const RamadanTrackerScreen({super.key});

  @override
  State<RamadanTrackerScreen> createState() => _RamadanTrackerScreenState();
}

class _RamadanTrackerScreenState extends State<RamadanTrackerScreen>
    with WidgetsBindingObserver {
  Map<int, FastingDay> _fastingDays = {};
  int _currentRamadanYear = HijriCalendar.now().hYear;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFastingDays();
    _checkRamadan();
    _loadFastingData();
    _initTts();

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
        _currentRamadanYear = HijriCalendar.now().hYear;
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
      'titleKey': 'duaSeeingNewMoon',
      'arabic':
          'اللَّهُ أَكْبَرُ، اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْأَمْنِ وَالْإِيمَانِ، وَالسَّلَامَةِ وَالْإِسْلَامِ، وَالتَّوْفِيقِ لِمَا تُحِبُّ وَتَرْضَى، رَبُّنَا وَرَبُّكَ اللَّهُ',
      'transliteration':
          "Allahu Akbar, Allahumma ahillahu 'alayna bil-amni wal-iman, was-salamati wal-islam, wat-tawfiqi lima tuhibbu wa tarda, rabbuna wa rabbuk-Allah",
      'hindi':
          'अल्लाह सबसे बड़ा है। ऐ अल्लाह! इस चाँद को हम पर अमन, ईमान, सलामती, इस्लाम और उस चीज़ की तौफ़ीक़ के साथ निकाल जिसे तू पसंद करता है और जिससे तू राज़ी होता है। हमारा और तेरा रब अल्लाह है।',
      'english':
          'Allah is the Greatest. O Allah, bring this moon upon us with peace, faith, safety, Islam, and success in what You love and are pleased with. Our Lord and your Lord is Allah.',
      'urdu':
          'اللہ سب سے بڑا ہے۔ اے اللہ! اس چاند کو ہم پر امن، ایمان، سلامتی، اسلام اور اس چیز کی توفیق کے ساتھ نکال جسے تو پسند کرتا ہے اور جس سے تو راضی ہوتا ہے۔ ہمارا اور تیرا رب اللہ ہے۔',
      'color': const Color(0xFF1565C0),
    },
    {
      'titleKey': 'duaForSuhoor',
      'arabic':
          'نَوَيْتُ أَنْ أَصُومَ غَدًا مِنْ شَهْرِ رَمَضَانَ هٰذِهِ السَّنَةِ إِيمَانًا وَاحْتِسَابًا لِلَّهِ رَبِّ الْعَالَمِينَ',
      'transliteration':
          "Nawaitu an asooma ghadan min shahri Ramadan hadhihi sanati imanan wahtisaban lillahi rabbil-'aalameen",
      'hindi':
          'मैंने इस साल रमज़ान के महीने का कल रोज़ा रखने की नियत की ईमान और सवाब की उम्मीद में अल्लाह रब्बुल आलमीन के लिए।',
      'english':
          'I intend to observe the fast tomorrow for this year of Ramadan with faith and seeking reward from Allah, Lord of the Worlds.',
      'urdu':
          'میں نے اس سال رمضان کے مہینے کا کل روزہ رکھنے کی نیت کی ایمان اور ثواب کی امید میں اللہ رب العالمین کے لیے۔',
      'color': const Color(0xFF3949AB),
    },
    {
      'titleKey': 'duaWhileFasting',
      'arabic': 'إِنِّي صَائِمٌ، إِنِّي صَائِمٌ',
      'transliteration': "Inni sa'im, Inni sa'im",
      'hindi':
          'मैं रोज़ेदार हूँ, मैं रोज़ेदार हूँ। (जब कोई गुस्सा दिलाए या झगड़ा करे तो यह दो बार कहें)',
      'english':
          'I am fasting, I am fasting. (Say this twice when someone provokes you or argues during fasting)',
      'urdu':
          'میں روزہ دار ہوں، میں روزہ دار ہوں۔ (جب کوئی غصہ دلائے یا جھگڑا کرے تو یہ دو بار کہیں)',
      'color': const Color(0xFF00897B),
    },

    {
      'titleKey': 'duaForIftar',
      'arabic':
          'اللَّهُمَّ لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
      'transliteration':
          "Allahumma laka sumtu wa bika aamantu wa 'alaika tawakkaltu wa 'ala rizqika aftartu",
      'hindi':
          'ऐ अल्लाह! मैंने तेरे लिए रोज़ा रखा, और तुझ पर ईमान लाया, और तुझ पर भरोसा किया और तेरे दिए हुए रिज़्क़ से इफ्तार किया।',
      'english':
          'O Allah! I fasted for You, and I believe in You, and I put my trust in You, and I break my fast with Your provision.',
      'urdu':
          'اے اللہ! میں نے تیرے لیے روزہ رکھا، اور تجھ پر ایمان لایا، اور تجھ پر بھروسہ کیا اور تیرے دیے ہوئے رزق سے افطار کیا۔',
      'color': const Color(0xFFE65100),
    },

    {
      'titleKey': 'duaForTaraweeh',
      'arabic':
          '	سُبْحَانَ ذِي الْمُلْكِ وَالْمَلَكُوتِ، سُبْحَانَ ذِي الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ وَالْكِبْرِيَاءِ وَالْجَبَرُوتِ، سُبْحَانَ الْمَلِكِ الْحَيِّ الَّذِي لَا يَنَامُ وَلَا يَمُوتُ سُبُّوحٌ قُدُّوسٌ رَبُّنَا وَرَبُّ الْمَلَائِكَةِ وَالرُّوحِ، اَللّٰهُمَّ اَجِرْنَا مِنَ النَّارِ يَا مُجِيرُ يَا مُجِيرُ يَا مُجِيرُ',
      'transliteration':
          "Subhana dhil-mulki wal-malakoot, subhana dhil-'izzati wal-'azamati wal-haybati wal-qudrati wal-kibriya'i wal-jabaroot, subhanal-malikil-hayyil-ladhi la yanamu wa la yamootu, subboohun quddusun rabbuna wa rabbul-mala'ikati war-rooh. Allahumma ajirna minan-nar, ya mujiru, ya mujiru, ya mujir",
      'hindi':
          '	पाक है वो जो बादशाहत और सल्तनत का मालिक है, पाक है वो जो इज़्ज़त, अज़मत, हैबत, क़ुदरत, बड़ाई और जबरूत वाला है, पाक है बादशाह ज़िंदा जो न सोता है और न मरता है, बहुत पाक बहुत पवित्र है हमारा रब और फ़रिश्तों और रूह का रब। ऐ अल्लाह! हमें जहन्नम की आग से पनाह दे। ऐ पनाह देने वाले, ऐ पनाह देने वाले, ऐ पनाह देने वाले',
      'english':
          'Glory be to the Owner of the Kingdom and Dominion, Glory be to the Owner of Might, Grandeur, Awe, Power, Pride and Majesty. Glory be to the Ever-Living King who neither sleeps nor dies. Most Holy, Most Pure, Our Lord and the Lord of the Angels and the Spirit.',
      'urdu':
          '	پاک ہے وہ جو بادشاہت اور سلطنت کا مالک ہے، پاک ہے وہ جو عزت، عظمت، ہیبت، قدرت، بڑائی اور جبروت والا ہے، پاک ہے بادشاہ زندہ جو نہ سوتا ہے اور نہ مرتا ہے، بہت پاک بہت پاکیزہ ہے ہمارا رب اور فرشتوں اور روح کا رب۔ الٰہی ہم کو دوزخ سے پناہ دے۔ اے پناہ دینے والے! اے پناہ دینے والے! اے پناہ دینے والے!',
      'color': const Color(0xFF00695C),
    },
    {
      'titleKey': 'duaWhenBreakingFast',
      'arabic':
          'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
      'transliteration':
          "Dhahaba al-zama’ wabtallatil-‘urooq wa thabatal-ajru in sha Allah",
      'hindi': 'प्यास बुझ गई, नसें तर हो गईं और इंशा अल्लाह सवाब पक्का हो गया।',
      'english':
          'The thirst has gone, the veins are moistened and the reward is assured, if Allah wills.',
      'urdu': 'پیاس بجھ گئی، رگیں تر ہو گئیں اور ان شاء اللہ ثواب ثابت ہو گیا۔',
      'color': const Color(0xFF2E7D32),
    },
    {
      'titleKey': 'duaSeekingForgiveness',
      'arabic':
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      'transliteration':
          "Rabbighfir li wa tub ‘alayya innaka antat-Tawwabur-Raheem",
      'hindi':
          'ऐ मेरे रब! मुझे माफ़ कर और मेरी तौबा क़बूल फ़रमा, बेशक तू बहुत तौबा क़बूल करने वाला है।',
      'english':
          'My Lord! Forgive me and accept my repentance. Indeed, You are the Accepter of repentance, the Merciful.',
      'urdu':
          'اے میرے رب! مجھے معاف کر اور میری توبہ قبول فرما، بیشک تو بہت توبہ قبول کرنے والا ہے۔',
      'color': const Color(0xFFAD1457),
    },
    {
      'titleKey': 'duaForLaylatulQadr',
      'arabic':
          'اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      'transliteration':
          "Allahumma innaka 'afuwwun kareemun tuhibbul-'afwa fa'fu 'anni",
      'hindi':
          'ऐ अल्लाह! बेशक तू बहुत माफ़ करने वाला और करीम (सबसे उदार) है, माफ़ी को पसंद करता है, तो मुझे माफ़ कर दे।',
      'english':
          'O Allah, indeed You are Most Forgiving, Most Generous, You love to forgive, so forgive me.',
      'urdu':
          'اے اللہ! بیشک تو بہت معاف کرنے والا اور کریم (سب سے سخی) ہے، معافی کو پسند کرتا ہے، تو مجھے معاف کر دے۔',
      'color': const Color(0xFF6A1B9A),
    },
    {
      'titleKey': 'duaEndOfRamadan',
      'arabic':
          'اللَّهُمَّ تَقَبَّلْ مِنَّا صِيَامَنَا وَقِيَامَنَا وَرُكُوعَنَا وَسُجُودَنَا وَتَسْبِيحَنَا وَتَكْبِيرَنَا وَتَهْلِيلَنَا وَتَقَبَّلْ تَوْبَتَنَا وَثَبِّتْ حُجَّتَنَا وَاغْفِرْ لَنَا ذُنُوبَنَا وَاجْعَلْنَا مِنَ الْفَائِزِينَ',
      'transliteration':
          "Allahumma taqabbal minna siyamana wa qiyamana wa rukoo'ana wa sujoodana wa tasbeehana wa takbeerana wa tahleelana wa taqabbal tawbatana wa thabbit hujjatana waghfir lana dhunoobana waj'alna minal-fa'izeen",
      'hindi':
          'ऐ अल्लाह! हमारे रोज़े, क़ियाम, रुकूअ, सजदे, तस्बीह, तकबीर और तहलील क़बूल फ़रमा और हमारी तौबा क़बूल कर, हमारी दलील को मज़बूत कर, हमारे गुनाह माफ़ कर दे और हमें कामयाब लोगों में से बना दे।',
      'english':
          'O Allah! Accept from us our fasting, our standing in prayer, our bowing, prostration, glorification, magnification and declaration of Your Oneness. Accept our repentance, strengthen our proof, forgive our sins and make us among the successful ones.',
      'urdu':
          'اے اللہ! ہمارے روزے، قیام، رکوع، سجدے، تسبیح، تکبیر اور تہلیل قبول فرما اور ہماری توبہ قبول کر، ہماری دلیل کو مضبوط کر، ہمارے گناہ معاف کر دے اور ہمیں کامیاب لوگوں میں سے بنا دے۔',
      'color': const Color(0xFF5E35B1),
    },
    {
      'titleKey': 'duaForEid',
      'arabic':
          'اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ لَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ وَلِلَّهِ الْحَمْدُ',
      'transliteration':
          "Allahu Akbar, Allahu Akbar, Allahu Akbar, La ilaha illallah, Wallahu Akbar, Allahu Akbar, Wa lillahil hamd",
      'hindi':
          'अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है, अल्लाह के सिवा कोई माबूद नहीं, अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है और तमाम तारीफ़ अल्लाह के लिए है।',
      'english':
          'Allah is the Greatest, Allah is the Greatest, Allah is the Greatest. There is no deity except Allah. Allah is the Greatest, Allah is the Greatest, and all praise is for Allah.',
      'urdu':
          'اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے اور تمام تعریف اللہ کے لیے ہے۔',
      'color': const Color(0xFFC62828),
    },
    {
      'titleKey': 'Ramadan Day 1',
      'arabic': 'اللَّهُمَّ اجْعَلْ صِيَامِي فِيهِ صِيَامَ الصَّائِمِينَ',
      'transliteration': 'Allahumma-j‘al siyami fihi siyamas-sa’imeen',
      'hindi': 'ऐ अल्लाह! मेरे रोज़े को सच्चे रोज़ेदारों जैसा बना दे।',
      'english': 'O Allah! Make my fasting like the fasting of true believers.',
      'urdu': 'اے اللہ! میرے روزے کو سچے روزہ داروں جیسا بنا دے۔',
      'color': const Color(0xFF1E88E5),
    },
    {
      'titleKey': 'Ramadan Day 2',
      'arabic': 'اللَّهُمَّ قَرِّبْنِي فِيهِ إِلَى مَرْضَاتِكَ',
      'transliteration': 'Allahumma qarribni fihi ila mardatika',
      'hindi': 'ऐ अल्लाह! मुझे अपनी रज़ा के क़रीब कर दे।',
      'english': 'O Allah! Bring me closer to Your pleasure.',
      'urdu': 'اے اللہ! مجھے اپنی رضا کے قریب کر دے۔',
      'color': const Color(0xFF43A047),
    },
    {
      'titleKey': 'Ramadan Day 3',
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ الذِّهْنَ وَالتَّنْبِيهَ',
      'transliteration': 'Allahummar-zuqni fihi adh-dhihna wat-tanbeeh',
      'hindi': 'ऐ अल्लाह! मुझे समझ और होश अता फ़रमा।',
      'english': 'O Allah! Grant me understanding and awareness.',
      'urdu': 'اے اللہ! مجھے سمجھ اور ہوشیاری عطا فرما۔',
      'color': const Color(0xFF00897B),
    },
    {
      'titleKey': 'Ramadan Day 4',
      'arabic': 'اللَّهُمَّ قَوِّنِي فِيهِ عَلَى إِقَامَةِ أَمْرِكَ',
      'transliteration': 'Allahumma qawwīni fihi ‘ala iqamati amrik',
      'hindi': 'ऐ अल्लाह! मुझे तेरे हुक्म पर चलने की ताक़त दे।',
      'english': 'O Allah! Strengthen me to obey Your commands.',
      'urdu': 'اے اللہ! مجھے تیرے احکامات پر عمل کی طاقت دے۔',
      'color': const Color(0xFF5E35B1),
    },
    {
      'titleKey': 'Ramadan Day 5',
      'arabic': 'اللَّهُمَّ اجْعَلْنِي فِيهِ مِنَ الْمُسْتَغْفِرِينَ',
      'transliteration': 'Allahumma-j‘alni fihi minal-mustaghfireen',
      'hindi': 'ऐ अल्लाह! मुझे तौबा करने वालों में शामिल कर।',
      'english': 'O Allah! Make me among those who seek forgiveness.',
      'urdu': 'اے اللہ! مجھے توبہ کرنے والوں میں شامل فرما۔',
      'color': const Color(0xFF6D4C41),
    },

    {
      'titleKey': 'Ramadan Day 6',
      'arabic': 'اللَّهُمَّ لَا تَخْذُلْنِي فِيهِ',
      'transliteration': 'Allahumma la takhdhulni fihi',
      'hindi': 'ऐ अल्लाह! मुझे इस दिन नाकामी न दे।',
      'english': 'O Allah! Do not forsake me in this day.',
      'urdu': 'اے اللہ! مجھے اس دن ناکامی نہ دے۔',
      'color': const Color(0xFFD32F2F),
    },
    {
      'titleKey': 'Ramadan Day 7',
      'arabic': 'اللَّهُمَّ أَعِنِّي فِيهِ عَلَى صِيَامِهِ وَقِيَامِهِ',
      'transliteration': 'Allahumma a\'inni fihi \'ala siyamihi wa qiyamih',
      'hindi': 'ऐ अल्लाह! रोज़े और क़ियाम में मेरी मदद फ़रमा।',
      'english': 'O Allah! Help me with fasting and standing in prayer.',
      'urdu': 'اے اللہ! روزے اور قیام میں میری مدد فرما۔',
      'color': const Color(0xFF7B1FA2),
    },
    {
      'titleKey': 'Ramadan Day 8',
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ رَحْمَةَ الْأَيْتَامِ',
      'transliteration': 'Allahummar-zuqni fihi rahmatal-aytam',
      'hindi': 'ऐ अल्लाह! यतीमों पर रहम करने की तौफ़ीक़ दे।',
      'english': 'O Allah! Grant me mercy towards orphans.',
      'urdu': 'اے اللہ! یتیموں پر رحم کرنے کی توفیق دے۔',
      'color': const Color(0xFF0288D1),
    },
    {
      'titleKey': 'Ramadan Day 9',
      'arabic': 'اللَّهُمَّ اجْعَلْ لِي فِيهِ نَصِيبًا مِنْ رَحْمَتِكَ',
      'transliteration': 'Allahumma-j\'al li fihi nasiban min rahmatik',
      'hindi': 'ऐ अल्लाह! अपनी रहमत में मेरा हिस्सा रख।',
      'english': 'O Allah! Make for me a share of Your mercy.',
      'urdu': 'اے اللہ! اپنی رحمت میں میرا حصہ رکھ۔',
      'color': const Color(0xFF388E3C),
    },
    {
      'titleKey': 'Ramadan Day 10',
      'arabic': 'اللَّهُمَّ اجْعَلْنِي فِيهِ مِنَ الْمُتَوَكِّلِينَ',
      'transliteration': 'Allahumma-j\'alni fihi minal-mutawakkileen',
      'hindi': 'ऐ अल्लाह! मुझे तुझ पर भरोसा करने वाला बना।',
      'english': 'O Allah! Make me among those who trust You.',
      'urdu': 'اے اللہ! مجھے تجھ پر بھروسہ کرنے والا بنا۔',
      'color': const Color(0xFF0277BD),
    },
    {
      'titleKey': 'Ramadan Day 11',
      'arabic': 'اللَّهُمَّ حَبِّبْ إِلَيَّ فِيهِ الْإِحْسَانَ',
      'transliteration': 'Allahumma habbib ilayya fihil-ihsan',
      'hindi': 'ऐ अल्लाह! नेकी को मेरे दिल में प्यारा बना दे।',
      'english': 'O Allah! Make goodness beloved to me.',
      'urdu': 'اے اللہ! نیکی کو میرے دل میں پیارا بنا دے۔',
      'color': const Color(0xFF00796B),
    },
    {
      'titleKey': 'Ramadan Day 12',
      'arabic': 'اللَّهُمَّ اسْتُرْ فِيهِ عَوْرَاتِي',
      'transliteration': 'Allahumma-stur fihi \'awrati',
      'hindi': 'ऐ अल्लाह! मेरी कमियों को छुपा दे।',
      'english': 'O Allah! Cover my faults and weaknesses.',
      'urdu': 'اے اللہ! میری کمیوں کو چھپا دے۔',
      'color': const Color(0xFF5D4037),
    },
    {
      'titleKey': 'Ramadan Day 13',
      'arabic': 'اللَّهُمَّ طَهِّرْنِي فِيهِ مِنَ الدَّنَسِ',
      'transliteration': 'Allahumma tahhirni fihi minad-danas',
      'hindi': 'ऐ अल्लाह! मुझे गुनाहों से पाक कर दे।',
      'english': 'O Allah! Purify me from sins and impurities.',
      'urdu': 'اے اللہ! مجھے گناہوں سے پاک کر دے۔',
      'color': const Color(0xFF1976D2),
    },
    {
      'titleKey': 'Ramadan Day 14',
      'arabic': 'اللَّهُمَّ لَا تُؤَاخِذْنِي فِيهِ بِالْعَثَرَاتِ',
      'transliteration': 'Allahumma la tu\'akhidhni fihi bil-\'atharat',
      'hindi': 'ऐ अल्लाह! मेरी गलतियों पर सज़ा न दे।',
      'english': 'O Allah! Do not punish me for my mistakes.',
      'urdu': 'اے اللہ! میری غلطیوں پر سزا نہ دے۔',
      'color': const Color(0xFF689F38),
    },
    {
      'titleKey': 'Ramadan Day 15',
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ طَاعَةَ الْخَاشِعِينَ',
      'transliteration': 'Allahummar-zuqni fihi ta\'ata al-khashi\'een',
      'hindi': 'ऐ अल्लाह! मुझे सच्ची इताअत अता फ़रमा।',
      'english': 'O Allah! Grant me obedience with humility.',
      'urdu': 'اے اللہ! مجھے عاجزی کے ساتھ اطاعت عطا فرما۔',
      'color': const Color(0xFF2E7D32),
    },
    {
      'titleKey': 'Ramadan Day 16',
      'arabic': 'اللَّهُمَّ وَفِّقْنِي فِيهِ لِمُوَافَقَةِ الْأَبْرَارِ',
      'transliteration': 'Allahumma waffiqni fihi limuwafaqatil-abrar',
      'hindi': 'ऐ अल्लाह! नेक लोगों की संगत नसीब कर।',
      'english': 'O Allah! Grant me company of the righteous.',
      'urdu': 'اے اللہ! نیک لوگوں کی صحبت نصیب کر۔',
      'color': const Color(0xFFAFB42B),
    },
    {
      'titleKey': 'Ramadan Day 17',
      'arabic': 'اللَّهُمَّ اهْدِنِي فِيهِ لِصَالِحِ الْأَعْمَالِ',
      'transliteration': 'Allahumma-hdini fihi lisalihil-a\'mal',
      'hindi': 'ऐ अल्लाह! नेक आमाल की हिदायत दे।',
      'english': 'O Allah! Guide me to righteous deeds.',
      'urdu': 'اے اللہ! نیک اعمال کی ہدایت دے۔',
      'color': const Color(0xFFF57C00),
    },
    {
      'titleKey': 'Ramadan Day 18',
      'arabic': 'اللَّهُمَّ نَبِّهْنِي فِيهِ لِبَرَكَاتِ أَسْحَارِهِ',
      'transliteration': 'Allahumma nabbihni fihi libarakati asharihi',
      'hindi': 'ऐ अल्लाह! सेहरी की बरकतों का एहसास करा।',
      'english': 'O Allah! Awaken me to the blessings of its pre-dawn.',
      'urdu': 'اے اللہ! سحری کی برکتوں کا احساس کرا۔',
      'color': const Color(0xFF00838F),
    },
    {
      'titleKey': 'Ramadan Day 19',
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ مِنَ النَّصِيبِ مِنْ بَرَكَاتِهِ',
      'transliteration': 'Allahummar-zuqni fihi minan-nasib min barakatihi',
      'hindi': 'ऐ अल्लाह! इस दिन की बरकतों में मेरा हिस्सा दे।',
      'english': 'O Allah! Grant me a share of its blessings.',
      'urdu': 'اے اللہ! اس دن کی برکتوں میں میرا حصہ دے۔',
      'color': const Color(0xFF558B2F),
    },
    {
      'titleKey': 'Ramadan Day 20',
      'arabic': 'اللَّهُمَّ افْتَحْ لِي فِيهِ أَبْوَابَ الْجِنَانِ',
      'transliteration': 'Allahumma-ftah li fihi abwabal-jinan',
      'hindi': 'ऐ अल्लाह! मेरे लिए जन्नत के दरवाज़े खोल दे।',
      'english': 'O Allah! Open for me the doors of Paradise.',
      'urdu': 'اے اللہ! میرے لیے جنت کے دروازے کھول دے۔',
      'color': const Color(0xFF8E24AA),
    },
    {
      'titleKey': 'Ramadan Day 21',
      'arabic': 'اللَّهُمَّ اهْدِنِي فِيهِ إِلَى سُبُلِ السَّلَامِ',
      'transliteration': 'Allahumma-hdini fihi ila subulus-salam',
      'hindi': 'ऐ अल्लाह! सलामती के रास्तों की हिदायत दे।',
      'english': 'O Allah! Guide me to the paths of peace.',
      'urdu': 'اے اللہ! سلامتی کے راستوں کی ہدایت دے۔',
      'color': const Color(0xFF512DA8),
    },
    {
      'titleKey': 'Ramadan Day 22',
      'arabic': 'اللَّهُمَّ افْتَحْ لِي فِيهِ أَبْوَابَ فَضْلِكَ',
      'transliteration': 'Allahumma-ftah li fihi abwaba fadlik',
      'hindi': 'ऐ अल्लाह! अपने फ़ज़्ल के दरवाज़े खोल दे।',
      'english': 'O Allah! Open for me the gates of Your grace.',
      'urdu': 'اے اللہ! اپنے فضل کے دروازے کھول دے۔',
      'color': const Color(0xFF303F9F),
    },
    {
      'titleKey': 'Ramadan Day 23',
      'arabic': 'اللَّهُمَّ اغْسِلْنِي فِيهِ مِنَ الذُّنُوبِ',
      'transliteration': 'Allahumma-ghsilni fihi minadh-dhunub',
      'hindi': 'ऐ अल्लाह! मुझे गुनाहों से धो दे।',
      'english': 'O Allah! Wash me from sins in this day.',
      'urdu': 'اے اللہ! مجھے گناہوں سے دھو دے۔',
      'color': const Color(0xFF0097A7),
    },
    {
      'titleKey': 'Ramadan Day 24',
      'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ فِيهِ مَا يُرْضِيكَ',
      'transliteration': 'Allahumma inni as\'aluka fihi ma yurdika',
      'hindi': 'ऐ अल्लाह! मैं तुझसे वो मांगता हूं जो तुझे पसंद है।',
      'english': 'O Allah! I ask You for what pleases You.',
      'urdu': 'اے اللہ! میں تجھ سے وہ مانگتا ہوں جو تجھے پسند ہے۔',
      'color': const Color(0xFF00796B),
    },
    {
      'titleKey': 'Ramadan Day 25',
      'arabic': 'اللَّهُمَّ اجْعَلْنِي فِيهِ مُحِبًّا لِأَوْلِيَائِكَ',
      'transliteration': 'Allahumma-j\'alni fihi muhibban li-awliya\'ik',
      'hindi': 'ऐ अल्लाह! मुझे अपने नेक बंदों से मोहब्बत करने वाला बना।',
      'english': 'O Allah! Make me love Your righteous servants.',
      'urdu': 'اے اللہ! مجھے اپنے نیک بندوں سے محبت کرنے والا بنا۔',
      'color': const Color(0xFF3949AB),
    },
    {
      'titleKey': 'Ramadan Day 26',
      'arabic': 'اللَّهُمَّ اجْعَلْ سَعْيِي فِيهِ مَشْكُورًا',
      'transliteration': 'Allahumma-j\'al sa\'yi fihi mashkura',
      'hindi': 'ऐ अल्लाह! मेरी कोशिश को क़बूल फ़रमा।',
      'english': 'O Allah! Make my efforts appreciated.',
      'urdu': 'اے اللہ! میری کوشش کو قبول فرما۔',
      'color': const Color(0xFFC62828),
    },
    {
      'titleKey': 'Ramadan Day 27',
      'arabic': 'اللَّهُمَّ ارْزُقْنِي فِيهِ فَضْلَ لَيْلَةِ الْقَدْرِ',
      'transliteration': 'Allahummar-zuqni fihi fadla laylatil-qadr',
      'hindi': 'ऐ अल्लाह! मुझे शबे क़द्र की फ़ज़ीलत नसीब कर।',
      'english': 'O Allah! Grant me the merit of Laylatul Qadr.',
      'urdu': 'اے اللہ! مجھے شب قدر کی فضیلت نصیب کر۔',
      'color': const Color(0xFF6A1B9A),
    },
    {
      'titleKey': 'Ramadan Day 28',
      'arabic': 'اللَّهُمَّ وَفِّرْ حَظِّي فِيهِ مِنَ النَّوَافِلِ',
      'transliteration': 'Allahumma waffir hazzi fihi minan-nawafil',
      'hindi': 'ऐ अल्लाह! नफ़िल इबादत में मेरा हिस्सा बढ़ा दे।',
      'english': 'O Allah! Increase my share of voluntary worship.',
      'urdu': 'اے اللہ! نفل عبادت میں میرا حصہ بڑھا دے۔',
      'color': const Color(0xFFAD1457),
    },
    {
      'titleKey': 'Ramadan Day 29',
      'arabic': 'اللَّهُمَّ غَشِّنِي فِيهِ بِالرَّحْمَةِ',
      'transliteration': 'Allahumma ghashshini fihi bir-rahmah',
      'hindi': 'ऐ अल्लाह! मुझे अपनी रहमत से ढक दे।',
      'english': 'O Allah! Cover me with Your mercy.',
      'urdu': 'اے اللہ! مجھے اپنی رحمت سے ڈھانپ دے۔',
      'color': const Color(0xFFE64A19),
    },
    {
      'titleKey': 'Ramadan Day 30',
      'arabic': 'اللَّهُمَّ تَقَبَّلْ مِنِّي وَاغْفِرْ لِي',
      'transliteration': 'Allahumma taqabbal minni waghfir li',
      'hindi': 'ऐ अल्लाह! मेरी इबादत क़बूल कर और मुझे माफ़ कर दे।',
      'english': 'O Allah! Accept from me and forgive me.',
      'urdu': 'اے اللہ! میری عبادت قبول فرما اور مجھے معاف کر دے۔',
      'color': const Color(0xFFC62828),
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
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: RefreshIndicator(
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
