import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/constants/app_colors.dart';

enum HajjLanguage { english, urdu, hindi }

class HajjGuideScreen extends StatefulWidget {
  const HajjGuideScreen({super.key});

  @override
  State<HajjGuideScreen> createState() => _HajjGuideScreenState();
}

class _HajjGuideScreenState extends State<HajjGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HajjLanguage _selectedLanguage = HajjLanguage.english;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  String? _currentPlayingId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ar-SA');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
        _currentPlayingId = null;
      });
    });
  }

  Future<void> _speak(String text, String id) async {
    if (_isPlaying && _currentPlayingId == id) {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = false;
        _currentPlayingId = null;
      });
    } else {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = true;
        _currentPlayingId = id;
      });
      await _flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  String _getLanguageLabel() {
    switch (_selectedLanguage) {
      case HajjLanguage.english:
        return 'EN';
      case HajjLanguage.urdu:
        return 'UR';
      case HajjLanguage.hindi:
        return 'HI';
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption(HajjLanguage.english, 'English', 'EN'),
            _buildLanguageOption(HajjLanguage.urdu, 'اردو', 'UR'),
            _buildLanguageOption(HajjLanguage.hindi, 'हिंदी', 'HI'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(HajjLanguage language, String name, String code) {
    final isSelected = _selectedLanguage == language;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            code,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(name),
      trailing: isSelected ? Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 50,
        title: const Text('Hajj & Umrah Guide'),
        actions: [
          // Language selector
          GestureDetector(
            onTap: _showLanguageSelector,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate, size: 18, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    _getLanguageLabel(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Hajj'),
            Tab(text: 'Umrah'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHajjGuide(),
          _buildUmrahGuide(),
        ],
      ),
    );
  }

  Widget _buildHajjGuide() {
    final hajjSteps = [
      HajjStep(
        day: 'Before Hajj',
        dayUrdu: 'حج سے پہلے',
        dayHindi: 'हज से पहले',
        title: 'Preparation',
        titleUrdu: 'تیاری',
        titleHindi: 'तैयारी',
        icon: Icons.checklist,
        color: Colors.blue,
        steps: [
          'Make sincere intention (Niyyah) for Hajj',
          'Repent from all sins and seek forgiveness',
          'Pay off all debts and resolve disputes',
          'Write a will (Wasiyyah)',
          'Learn the rituals of Hajj',
          'Pack appropriate Ihram clothing',
          'Get necessary vaccinations',
          'Prepare physically for the journey',
        ],
        stepsUrdu: [
          'حج کی نیت خالص کریں',
          'تمام گناہوں سے توبہ کریں',
          'تمام قرضے ادا کریں',
          'وصیت لکھیں',
          'حج کے مناسک سیکھیں',
          'احرام کے کپڑے پیک کریں',
          'ضروری ویکسینیشن لیں',
          'جسمانی طور پر تیاری کریں',
        ],
        stepsHindi: [
          'हज की नियत सच्चे दिल से करें',
          'सभी गुनाहों से तौबा करें',
          'सभी कर्ज चुकाएं',
          'वसीयत लिखें',
          'हज के मनासिक सीखें',
          'इहराम के कपड़े पैक करें',
          'जरूरी वैक्सीनेशन लें',
          'शारीरिक रूप से तैयारी करें',
        ],
      ),
      HajjStep(
        day: '8th Dhul Hijjah',
        dayUrdu: '8 ذو الحجہ',
        dayHindi: '8 ज़िल्हिज्जा',
        title: 'Day of Tarwiyah',
        titleUrdu: 'یوم الترویہ',
        titleHindi: 'यौम अल-तरवियह',
        icon: Icons.flag,
        color: Colors.green,
        steps: [
          'Enter state of Ihram from Miqat',
          'Make intention for Hajj: "Labbayk Allahumma Hajj"',
          'Recite Talbiyah continuously',
          'Travel to Mina',
          'Pray Dhuhr, Asr, Maghrib, Isha and Fajr at Mina',
          'Each prayer at its own time, shortened (Qasr)',
          'Spend the night in Mina',
        ],
        stepsUrdu: [
          'میقات سے احرام باندھیں',
          'حج کی نیت کریں: لبیک اللہم حج',
          'تلبیہ پڑھتے رہیں',
          'منیٰ کی طرف روانہ ہوں',
          'منیٰ میں تمام نمازیں پڑھیں',
          'ہر نماز اپنے وقت پر قصر کریں',
          'رات منیٰ میں گزاریں',
        ],
        stepsHindi: [
          'मीक़ात से इहराम बांधें',
          'हज की नियत करें: लब्बैक अल्लाहुम्मा हज',
          'तल्बियह पढ़ते रहें',
          'मिना की ओर रवाना हों',
          'मिना में सभी नमाज़ें पढ़ें',
          'हर नमाज़ अपने वक़्त पर क़स्र करें',
          'रात मिना में गुज़ारें',
        ],
      ),
      HajjStep(
        day: '9th Dhul Hijjah',
        dayUrdu: '9 ذو الحجہ',
        dayHindi: '9 ज़िल्हिज्जा',
        title: 'Day of Arafah',
        titleUrdu: 'یوم عرفہ',
        titleHindi: 'यौम अरफ़ा',
        icon: Icons.terrain,
        color: Colors.orange,
        steps: [
          'This is the most important day of Hajj',
          'Travel to Arafah after sunrise',
          'Stand at Arafah (Wuquf) - this is the pillar of Hajj',
          'Combine and shorten Dhuhr and Asr prayers',
          'Make abundant Dua and Dhikr',
          'After sunset, travel to Muzdalifah',
          'Pray Maghrib and Isha combined at Muzdalifah',
          'Collect 49-70 pebbles for Jamarat',
        ],
        stepsUrdu: [
          'یہ حج کا سب سے اہم دن ہے',
          'طلوع آفتاب کے بعد عرفات جائیں',
          'عرفات میں وقوف کریں - یہ حج کا رکن ہے',
          'ظہر اور عصر جمع اور قصر کریں',
          'کثرت سے دعا اور ذکر کریں',
          'غروب آفتاب کے بعد مزدلفہ جائیں',
          'مغرب اور عشاء جمع کریں',
          'جمرات کے لیے 49-70 کنکریاں جمع کریں',
        ],
        stepsHindi: [
          'यह हज का सबसे अहम दिन है',
          'सूर्योदय के बाद अरफ़ात जाएं',
          'अरफ़ात में वुक़ूफ़ करें - यह हज का रुक्न है',
          'ज़ुहर और अस्र जमा और क़स्र करें',
          'बहुत ज़्यादा दुआ और ज़िक्र करें',
          'सूर्यास्त के बाद मुज़दलिफ़ा जाएं',
          'मग़रिब और इशा जमा करें',
          'जमरात के लिए 49-70 कंकरियां जमा करें',
        ],
      ),
      HajjStep(
        day: '10th Dhul Hijjah',
        dayUrdu: '10 ذو الحجہ',
        dayHindi: '10 ज़िल्हिज्जा',
        title: 'Eid Day (Yawm al-Nahr)',
        titleUrdu: 'عید کا دن (یوم النحر)',
        titleHindi: 'ईद का दिन (यौम अल-नहर)',
        icon: Icons.celebration,
        color: Colors.red,
        steps: [
          'Pray Fajr at Muzdalifah',
          'Leave for Mina before sunrise',
          'Stone Jamrat al-Aqabah (7 pebbles)',
          'Perform sacrifice (Qurbani/Hady)',
          'Shave head (Halq) or trim hair (Taqsir)',
          'Go to Makkah for Tawaf al-Ifadah',
          'Perform Sa\'i between Safa and Marwa',
          'Return to Mina to spend the night',
        ],
        stepsUrdu: [
          'مزدلفہ میں فجر پڑھیں',
          'طلوع آفتاب سے پہلے منیٰ روانہ ہوں',
          'جمرۃ العقبہ کو 7 کنکریاں ماریں',
          'قربانی دیں',
          'سر منڈوائیں یا بال کٹوائیں',
          'طواف افاضہ کے لیے مکہ جائیں',
          'صفا اور مروہ کے درمیان سعی کریں',
          'رات گزارنے کے لیے منیٰ واپس آئیں',
        ],
        stepsHindi: [
          'मुज़दलिफ़ा में फज्र पढ़ें',
          'सूर्योदय से पहले मिना रवाना हों',
          'जमरतुल अक़बा को 7 कंकरियां मारें',
          'क़ुर्बानी दें',
          'सर मुंडवाएं या बाल कटवाएं',
          'तवाफ़ इफ़ाज़ा के लिए मक्का जाएं',
          'सफ़ा और मरवा के बीच सई करें',
          'रात गुज़ारने के लिए मिना वापस आएं',
        ],
      ),
      HajjStep(
        day: '11th-13th Dhul Hijjah',
        dayUrdu: '11-13 ذو الحجہ',
        dayHindi: '11-13 ज़िल्हिज्जा',
        title: 'Days of Tashreeq',
        titleUrdu: 'ایام تشریق',
        titleHindi: 'अय्याम अल-तशरीक़',
        icon: Icons.replay,
        color: Colors.purple,
        steps: [
          'Stay in Mina for these days',
          'Stone all three Jamarat daily (after Dhuhr)',
          'Start with Jamrat al-Sughra (small)',
          'Then Jamrat al-Wusta (middle)',
          'Finally Jamrat al-Aqabah (big)',
          '7 pebbles at each Jamrah',
          'Can leave on 12th after stoning (if before sunset)',
        ],
        stepsUrdu: [
          'ان دنوں منیٰ میں رہیں',
          'روزانہ تینوں جمرات کو کنکریاں ماریں',
          'جمرۃ الصغریٰ سے شروع کریں',
          'پھر جمرۃ الوسطیٰ',
          'آخر میں جمرۃ العقبہ',
          'ہر جمرہ پر 7 کنکریاں',
          '12 تاریخ کو غروب سے پہلے جا سکتے ہیں',
        ],
        stepsHindi: [
          'इन दिनों मिना में रहें',
          'रोज़ाना तीनों जमरात को कंकरियां मारें',
          'जमरतुल सुग़रा से शुरू करें',
          'फिर जमरतुल वुस्ता',
          'आख़िर में जमरतुल अक़बा',
          'हर जमरा पर 7 कंकरियां',
          '12 तारीख़ को सूर्यास्त से पहले जा सकते हैं',
        ],
      ),
      HajjStep(
        day: 'Before Leaving',
        dayUrdu: 'روانگی سے پہلے',
        dayHindi: 'रवानगी से पहले',
        title: 'Farewell Tawaf',
        titleUrdu: 'طواف الوداع',
        titleHindi: 'तवाफ़ अल-विदा',
        icon: Icons.mosque,
        color: Colors.teal,
        steps: [
          'Perform Tawaf al-Wida (Farewell Tawaf)',
          'This should be your last act in Makkah',
          'Make Dua at Multazam',
          'Drink Zamzam water',
          'Pray 2 Rakats behind Maqam Ibrahim',
          'Leave Makkah while making Dua',
          'Visit Madinah (recommended)',
        ],
        stepsUrdu: [
          'طواف الوداع کریں',
          'یہ مکہ میں آخری عمل ہونا چاہیے',
          'ملتزم پر دعا کریں',
          'زمزم کا پانی پئیں',
          'مقام ابراہیم کے پیچھے 2 رکعت پڑھیں',
          'دعا کرتے ہوئے مکہ سے روانہ ہوں',
          'مدینہ کی زیارت کریں (مستحب)',
        ],
        stepsHindi: [
          'तवाफ़ अल-विदा करें',
          'यह मक्का में आख़िरी अमल होना चाहिए',
          'मुलतज़म पर दुआ करें',
          'ज़मज़म का पानी पिएं',
          'मक़ाम इब्राहीम के पीछे 2 रकात पढ़ें',
          'दुआ करते हुए मक्का से रवाना हों',
          'मदीना की ज़ियारत करें (मुस्तहब)',
        ],
      ),
    ];

    return _buildGuideList(hajjSteps, 'Hajj');
  }

  Widget _buildUmrahGuide() {
    final umrahSteps = [
      HajjStep(
        day: 'Step 1',
        dayUrdu: 'مرحلہ 1',
        dayHindi: 'चरण 1',
        title: 'Enter Ihram',
        titleUrdu: 'احرام باندھنا',
        titleHindi: 'इहराम बांधना',
        icon: Icons.check_circle,
        color: Colors.green,
        steps: [
          'Take a bath (Ghusl) before Ihram',
          'Wear Ihram clothing (2 white sheets for men)',
          'Women wear normal modest clothing',
          'Make intention at Miqat: "Labbayk Allahumma Umrah"',
          'Recite Talbiyah continuously',
        ],
        stepsUrdu: [
          'احرام سے پہلے غسل کریں',
          'احرام کے کپڑے پہنیں (مردوں کے لیے 2 سفید چادریں)',
          'خواتین معمول کے پردے والے کپڑے پہنیں',
          'میقات پر نیت کریں: لبیک اللہم عمرۃ',
          'تلبیہ پڑھتے رہیں',
        ],
        stepsHindi: [
          'इहराम से पहले ग़ुस्ल करें',
          'इहराम के कपड़े पहनें (मर्दों के लिए 2 सफ़ेद चादरें)',
          'औरतें आम पर्दे वाले कपड़े पहनें',
          'मीक़ात पर नियत करें: लब्बैक अल्लाहुम्मा उमरा',
          'तल्बियह पढ़ते रहें',
        ],
      ),
      HajjStep(
        day: 'Step 2',
        dayUrdu: 'مرحلہ 2',
        dayHindi: 'चरण 2',
        title: 'Tawaf (Circumambulation)',
        titleUrdu: 'طواف',
        titleHindi: 'तवाफ़',
        icon: Icons.autorenew,
        color: Colors.blue,
        steps: [
          'Enter Masjid al-Haram with right foot',
          'Begin Tawaf from the Black Stone',
          'Circle Kaaba 7 times counter-clockwise',
          'Men: Idtiba (expose right shoulder) in first 3 rounds',
          'After Tawaf, pray 2 Rakats behind Maqam Ibrahim',
          'Drink Zamzam water',
        ],
        stepsUrdu: [
          'دائیں پاؤں سے مسجد الحرام میں داخل ہوں',
          'حجر اسود سے طواف شروع کریں',
          'کعبہ کے 7 چکر لگائیں (خلاف گھڑی)',
          'مرد: پہلے 3 چکروں میں اضطباع کریں',
          'طواف کے بعد مقام ابراہیم کے پیچھے 2 رکعت پڑھیں',
          'زمزم کا پانی پئیں',
        ],
        stepsHindi: [
          'दाएं पैर से मस्जिद अल-हराम में दाख़िल हों',
          'हज्र-ए-अस्वद से तवाफ़ शुरू करें',
          'काबा के 7 चक्कर लगाएं (घड़ी के विपरीत)',
          'मर्द: पहले 3 चक्करों में इज़तिबा करें',
          'तवाफ़ के बाद मक़ाम इब्राहीम के पीछे 2 रकात पढ़ें',
          'ज़मज़म का पानी पिएं',
        ],
      ),
      HajjStep(
        day: 'Step 3',
        dayUrdu: 'مرحلہ 3',
        dayHindi: 'चरण 3',
        title: 'Sa\'i (Walking between hills)',
        titleUrdu: 'سعی',
        titleHindi: 'सई',
        icon: Icons.directions_walk,
        color: Colors.orange,
        steps: [
          'Go to Mount Safa',
          'Face Kaaba and make Dua',
          'Walk towards Marwa',
          'Men: Run between green lights',
          'Complete 7 laps (ending at Marwa)',
          'Make Dua and Dhikr throughout',
        ],
        stepsUrdu: [
          'کوہ صفا جائیں',
          'کعبہ کی طرف منہ کریں اور دعا کریں',
          'مروہ کی طرف چلیں',
          'مرد: سبز بتیوں کے درمیان دوڑیں',
          '7 چکر مکمل کریں (مروہ پر ختم)',
          'دوران سعی دعا اور ذکر کرتے رہیں',
        ],
        stepsHindi: [
          'कोह सफ़ा जाएं',
          'काबा की तरफ़ मुंह करें और दुआ करें',
          'मरवा की तरफ़ चलें',
          'मर्द: हरी बत्तियों के बीच दौड़ें',
          '7 चक्कर पूरे करें (मरवा पर ख़त्म)',
          'सई के दौरान दुआ और ज़िक्र करते रहें',
        ],
      ),
      HajjStep(
        day: 'Step 4',
        dayUrdu: 'مرحلہ 4',
        dayHindi: 'चरण 4',
        title: 'Halq or Taqsir',
        titleUrdu: 'حلق یا تقصیر',
        titleHindi: 'हल्क़ या तक़्सीर',
        icon: Icons.content_cut,
        color: Colors.purple,
        steps: [
          'Men: Shave head completely (Halq) - preferred',
          'Or trim hair at least (Taqsir)',
          'Women: Cut a fingertip length of hair',
          'This marks the end of Ihram',
          'All Ihram restrictions are now lifted',
          'Your Umrah is complete! Alhamdulillah',
        ],
        stepsUrdu: [
          'مرد: سر مکمل منڈوائیں (حلق) - افضل',
          'یا بال کٹوائیں (تقصیر)',
          'خواتین: انگلی کے پور کی لمبائی کے بال کاٹیں',
          'یہ احرام کا اختتام ہے',
          'اب احرام کی تمام پابندیاں ختم ہیں',
          'آپ کا عمرہ مکمل ہوا! الحمد للہ',
        ],
        stepsHindi: [
          'मर्द: सर पूरा मुंडवाएं (हल्क़) - अफ़ज़ल',
          'या बाल कटवाएं (तक़्सीर)',
          'औरतें: उंगली के पोर की लंबाई के बाल काटें',
          'यह इहराम का अंत है',
          'अब इहराम की सभी पाबंदियां ख़त्म हैं',
          'आपका उमरा मुकम्मल हुआ! अल्हम्दुलिल्लाह',
        ],
      ),
    ];

    return _buildGuideList(umrahSteps, 'Umrah');
  }

  Widget _buildGuideList(List<HajjStep> steps, String type) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(type),
          const SizedBox(height: 16),
          ...steps.map((step) => _buildStepCard(step)),
          const SizedBox(height: 16),
          _buildDuasCard(type),
          const SizedBox(height: 16),
          _buildProhibitionsCard(),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String type) {
    String title;
    String subtitle;

    switch (_selectedLanguage) {
      case HajjLanguage.urdu:
        title = type == 'Hajj' ? 'حج کا رہنما' : 'عمرہ کا رہنما';
        subtitle = type == 'Hajj'
            ? 'اسلام کا پانچواں رکن - زندگی میں ایک بار فرض'
            : 'چھوٹا حج - سال میں کسی بھی وقت ادا کیا جا سکتا ہے';
        break;
      case HajjLanguage.hindi:
        title = type == 'Hajj' ? 'हज गाइड' : 'उमरा गाइड';
        subtitle = type == 'Hajj'
            ? 'इस्लाम का पांचवां रुक्न - ज़िंदगी में एक बार फ़र्ज़'
            : 'छोटा हज - साल में कभी भी अदा किया जा सकता है';
        break;
      default:
        title = type == 'Hajj' ? 'Guide to Hajj' : 'Guide to Umrah';
        subtitle = type == 'Hajj'
            ? 'The fifth pillar of Islam - obligatory once in a lifetime'
            : 'The minor pilgrimage - can be performed any time of the year';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.mosque, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(HajjStep step) {
    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    final title = _selectedLanguage == HajjLanguage.urdu
        ? step.titleUrdu
        : _selectedLanguage == HajjLanguage.hindi
            ? step.titleHindi
            : step.title;

    final day = _selectedLanguage == HajjLanguage.urdu
        ? step.dayUrdu
        : _selectedLanguage == HajjLanguage.hindi
            ? step.dayHindi
            : step.day;

    final steps = _selectedLanguage == HajjLanguage.urdu
        ? step.stepsUrdu
        : _selectedLanguage == HajjLanguage.hindi
            ? step.stepsHindi
            : step.steps;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: step.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(step.icon, color: step.color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          day,
          style: TextStyle(color: step.color, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: steps.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: step.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: step.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildDuasCard(String type) {
    final duas = [
      HajjDua(
        id: '1',
        title: 'Talbiyah',
        titleUrdu: 'تلبیہ',
        titleHindi: 'तल्बियह',
        arabic: 'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
        translationEn: 'Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Verily all praise, grace and sovereignty belong to You. You have no partner.',
        translationUrdu: 'حاضر ہوں اے اللہ حاضر ہوں۔ حاضر ہوں، تیرا کوئی شریک نہیں، حاضر ہوں۔ بے شک تمام تعریف، نعمت اور بادشاہی تیری ہے۔ تیرا کوئی شریک نہیں۔',
        translationHindi: 'हाज़िर हूं ऐ अल्लाह हाज़िर हूं। हाज़िर हूं, तेरा कोई शरीक नहीं, हाज़िर हूं। बेशक सारी तारीफ़, नेमत और बादशाही तेरी है। तेरा कोई शरीक नहीं।',
      ),
      HajjDua(
        id: '2',
        title: 'Dua between Yemeni Corner and Black Stone',
        titleUrdu: 'رکن یمانی اور حجر اسود کے درمیان کی دعا',
        titleHindi: 'रुक्न यमानी और हज्र-ए-अस्वद के बीच की दुआ',
        arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        translationEn: 'Our Lord, give us good in this world and good in the Hereafter, and save us from the punishment of the Fire.',
        translationUrdu: 'اے ہمارے رب! ہمیں دنیا میں بھی بھلائی دے اور آخرت میں بھی بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔',
        translationHindi: 'ऐ हमारे रब! हमें दुनिया में भी भलाई दे और आख़िरत में भी भलाई दे और हमें आग के अज़ाब से बचा।',
      ),
      HajjDua(
        id: '3',
        title: 'Dua on Mount Safa/Marwa',
        titleUrdu: 'صفا/مروہ پر دعا',
        titleHindi: 'सफ़ा/मरवा पर दुआ',
        arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        translationEn: 'There is no god but Allah alone, with no partner. His is the dominion, and His is the praise, and He is able to do all things.',
        translationUrdu: 'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہی اسی کی ہے اور تعریف اسی کے لیے ہے اور وہ ہر چیز پر قادر ہے۔',
        translationHindi: 'अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं। बादशाही उसी की है और तारीफ़ उसी के लिए है और वो हर चीज़ पर क़ादिर है।',
      ),
    ];

    String sectionTitle;
    switch (_selectedLanguage) {
      case HajjLanguage.urdu:
        sectionTitle = 'اہم دعائیں';
        break;
      case HajjLanguage.hindi:
        sectionTitle = 'अहम दुआएं';
        break;
      default:
        sectionTitle = 'Important Duas';
    }

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
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
            Row(
              children: [
                Icon(Icons.menu_book, color: darkGreen),
                const SizedBox(width: 8),
                Text(
                  sectionTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...duas.map((dua) => _buildDuaItem(dua)),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaItem(HajjDua dua) {
    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenChip = Color(0xFFE8F3ED);

    final title = _selectedLanguage == HajjLanguage.urdu
        ? dua.titleUrdu
        : _selectedLanguage == HajjLanguage.hindi
            ? dua.titleHindi
            : dua.title;

    final translation = _selectedLanguage == HajjLanguage.urdu
        ? dua.translationUrdu
        : _selectedLanguage == HajjLanguage.hindi
            ? dua.translationHindi
            : dua.translationEn;

    final isPlaying = _isPlaying && _currentPlayingId == dua.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGreenChip,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Text(
            dua.arabic,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              height: 2,
              color: AppColors.arabicText,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          Text(
            translation,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Action buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Audio button
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.stop_circle : Icons.play_circle,
                    color: isPlaying ? Colors.red : AppColors.primary,
                  ),
                  onPressed: () => _speak(dua.arabic, dua.id),
                  tooltip: isPlaying ? 'Stop' : 'Listen',
                ),
                // Copy button
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: '${dua.arabic}\n\n$translation',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  tooltip: 'Copy',
                ),
                // Share button
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () {
                    Share.share(
                      '$title\n\n${dua.arabic}\n\n$translation',
                    );
                  },
                  tooltip: 'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProhibitionsCard() {
    List<String> prohibitions;
    String sectionTitle;

    switch (_selectedLanguage) {
      case HajjLanguage.urdu:
        sectionTitle = 'احرام کی پابندیاں';
        prohibitions = [
          'بال یا ناخن کاٹنا',
          'خوشبو لگانا',
          'سر ڈھانپنا (مرد)',
          'سلے ہوئے کپڑے (مرد)',
          'شکار کرنا',
          'نکاح یا پیغام',
          'ازدواجی تعلقات',
          'لڑائی جھگڑا',
        ];
        break;
      case HajjLanguage.hindi:
        sectionTitle = 'इहराम की पाबंदियां';
        prohibitions = [
          'बाल या नाख़ून काटना',
          'ख़ुशबू लगाना',
          'सर ढांकना (मर्द)',
          'सिले हुए कपड़े (मर्द)',
          'शिकार करना',
          'निकाह या पैग़ाम',
          'इज़्दिवाजी ताल्लुक़ात',
          'लड़ाई झगड़ा',
        ];
        break;
      default:
        sectionTitle = 'Ihram Prohibitions';
        prohibitions = [
          'Cutting hair or nails',
          'Using perfume',
          'Covering head (men)',
          'Sewn clothes (men)',
          'Hunting animals',
          'Marriage proposals',
          'Sexual relations',
          'Arguing or fighting',
        ];
    }

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
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
            Row(
              children: [
                const Icon(Icons.block, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  sectionTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prohibitions
                  .map((p) => Chip(
                        label: Text(p, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class HajjStep {
  final String day;
  final String dayUrdu;
  final String dayHindi;
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final IconData icon;
  final Color color;
  final List<String> steps;
  final List<String> stepsUrdu;
  final List<String> stepsHindi;

  HajjStep({
    required this.day,
    required this.dayUrdu,
    required this.dayHindi,
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.icon,
    required this.color,
    required this.steps,
    required this.stepsUrdu,
    required this.stepsHindi,
  });
}

class HajjDua {
  final String id;
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String arabic;
  final String translationEn;
  final String translationUrdu;
  final String translationHindi;

  HajjDua({
    required this.id,
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.arabic,
    required this.translationEn,
    required this.translationUrdu,
    required this.translationHindi,
  });
}
