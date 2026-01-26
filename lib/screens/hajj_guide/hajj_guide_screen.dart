import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/language_provider.dart';

enum HajjLanguage { english, urdu, hindi, arabic }

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
  final Set<String> _expandedDuas = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync with app's language provider
    final languageProvider = Provider.of<LanguageProvider>(context);
    final langCode = languageProvider.languageCode;

    HajjLanguage newLanguage;
    if (langCode == 'ur') {
      newLanguage = HajjLanguage.urdu;
    } else if (langCode == 'hi') {
      newLanguage = HajjLanguage.hindi;
    } else if (langCode == 'ar') {
      newLanguage = HajjLanguage.arabic;
    } else {
      newLanguage = HajjLanguage.english;
    }

    if (_selectedLanguage != newLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
      });
    }
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

  @override
  void dispose() {
    _tabController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: responsive.value(mobile: 50, tablet: 60, desktop: 70),
        title: Text(
          context.tr('hajj_guide'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: context.tr('hajj_rituals')),
            Tab(text: context.tr('umrah')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildHajjGuide(), _buildUmrahGuide()],
      ),
    );
  }

  Widget _buildHajjGuide() {
    final hajjSteps = [
      HajjStep(
        day: 'Before Hajj',
        dayUrdu: 'حج سے پہلے',
        dayHindi: 'हज से पहले',
        dayArabic: 'قبل الحج',
        title: 'Preparation',
        titleUrdu: 'تیاری',
        titleHindi: 'तैयारी',
        titleArabic: 'التحضير',
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
        stepsArabic: [
          'قم بعمل نية خالصة للحج',
          'تب من جميع الذنوب واطلب المغفرة',
          'سدد جميع الديون وحل النزاعات',
          'اكتب وصية',
          'تعلم مناسك الحج',
          'احزم ملابس الإحرام المناسبة',
          'احصل على التطعيمات اللازمة',
          'استعد جسديًا للرحلة',
        ],
      ),
      HajjStep(
        day: '8th Dhul Hijjah',
        dayUrdu: '8 ذو الحجہ',
        dayHindi: '8 ज़िल्हिज्जा',
        dayArabic: '8 ذو الحجة',
        title: 'Day of Tarwiyah',
        titleUrdu: 'یوم الترویہ',
        titleHindi: 'यौम अल-तरवियह',
        titleArabic: 'يوم الترويه',
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
        stepsArabic: [
          'ادخل حالة الإحرام من الميقات',
          'اعقد النية للحج: لبيك اللهم حج',
          'ردد التلبية باستمرار',
          'سافر إلى منى',
          'صلِّ الظهر والعصر والمغرب والعشاء والفجر في منى',
          'كل صلاة في وقتها، مقصورة',
          'اقضِ الليل في منى',
        ],
      ),
      HajjStep(
        day: '9th Dhul Hijjah',
        dayUrdu: '9 ذو الحجہ',
        dayHindi: '9 ज़िल्हिज्जा',
        dayArabic: '9 ذو الحجة',
        title: 'Day of Arafah',
        titleUrdu: 'یوم عرفہ',
        titleHindi: 'यौम अरफ़ा',
        titleArabic: 'يوم عرفة',
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
        stepsArabic: [
          'هذا هو أهم يوم في الحج',
          'سافر إلى عرفة بعد شروق الشمس',
          'قف في عرفة (الوقوف) - هذا هو ركن الحج',
          'اجمع وقصر صلاتي الظهر والعصر',
          'أكثر من الدعاء والذكر',
          'بعد غروب الشمس، سافر إلى مزدلفة',
          'صلِّ المغرب والعشاء جمعًا في مزدلفة',
          'اجمع 49-70 حصاة للجمرات',
        ],
      ),
      HajjStep(
        day: '10th Dhul Hijjah',
        dayUrdu: '10 ذو الحجہ',
        dayHindi: '10 ज़िल्हिज्जा',
        dayArabic: '10 ذو الحجة',
        title: 'Eid Day (Yawm al-Nahr)',
        titleUrdu: 'عید کا دن (یوم النحر)',
        titleHindi: 'ईद का दिन (यौम अल-नहर)',
        titleArabic: 'يوم العيد (يوم النحر)',
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
        stepsArabic: [
          'صلِّ الفجر في مزدلفة',
          'اذهب إلى منى قبل شروق الشمس',
          'ارمِ جمرة العقبة (7 حصيات)',
          'قم بالأضحية (القربان/الهدي)',
          'احلق رأسك (الحلق) أو قصر شعرك (التقصير)',
          'اذهب إلى مكة لطواف الإفاضة',
          'أدِّ السعي بين الصفا والمروة',
          'ارجع إلى منى لقضاء الليل',
        ],
      ),
      HajjStep(
        day: '11th-13th Dhul Hijjah',
        dayUrdu: '11-13 ذو الحجہ',
        dayHindi: '11-13 ज़िल्हिज्जा',
        dayArabic: '11-13 ذو الحجة',
        title: 'Days of Tashreeq',
        titleUrdu: 'ایام تشریق',
        titleHindi: 'अय्याम अल-तशरीक़',
        titleArabic: 'أيام التشريق',
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
        stepsArabic: [
          'ابقَ في منى خلال هذه الأيام',
          'ارمِ الجمرات الثلاث يوميًا (بعد الظهر)',
          'ابدأ بالجمرة الصغرى',
          'ثم الجمرة الوسطى',
          'وأخيرًا جمرة العقبة (الكبرى)',
          '7 حصيات لكل جمرة',
          'يمكن المغادرة في الـ12 بعد الرمي (إذا كان قبل الغروب)',
        ],
      ),
      HajjStep(
        day: 'Before Leaving',
        dayUrdu: 'روانگی سے پہلے',
        dayHindi: 'रवानगी से पहले',
        dayArabic: 'قبل المغادرة',
        title: 'Farewell Tawaf',
        titleUrdu: 'طواف الوداع',
        titleHindi: 'तवाफ़ अल-विदा',
        titleArabic: 'طواف الوداع',
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
        stepsArabic: [
          'أدِّ طواف الوداع',
          'يجب أن يكون هذا آخر عمل لك في مكة',
          'ادعُ عند الملتزم',
          'اشرب ماء زمزم',
          'صلِّ ركعتين خلف مقام إبراهيم',
          'اترك مكة أثناء الدعاء',
          'زر المدينة المنورة (مستحب)',
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
        dayArabic: 'الخطوة 1',
        title: 'Enter Ihram',
        titleUrdu: 'احرام باندھنا',
        titleHindi: 'इहराम बांधना',
        titleArabic: 'دخول الإحرام',
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
        stepsArabic: [
          'اغتسل قبل الإحرام',
          'ارتدِ ملابس الإحرام (إزارين أبيضين للرجال)',
          'ترتدي النساء ملابس عادية محتشمة',
          'اعقد النية عند الميقات: لبيك اللهم عمرة',
          'ردد التلبية باستمرار',
        ],
      ),
      HajjStep(
        day: 'Step 2',
        dayUrdu: 'مرحلہ 2',
        dayHindi: 'चरण 2',
        dayArabic: 'الخطوة 2',
        title: 'Tawaf (Circumambulation)',
        titleUrdu: 'طواف',
        titleHindi: 'तवाफ़',
        titleArabic: 'الطواف',
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
        stepsArabic: [
          'ادخل المسجد الحرام بالقدم اليمنى',
          'ابدأ الطواف من الحجر الأسود',
          'طُف حول الكعبة 7 أشواط عكس عقارب الساعة',
          'الرجال: الاضطباع (كشف الكتف الأيمن) في أول 3 أشواط',
          'بعد الطواف، صلِّ ركعتين خلف مقام إبراهيم',
          'اشرب ماء زمزم',
        ],
      ),
      HajjStep(
        day: 'Step 3',
        dayUrdu: 'مرحلہ 3',
        dayHindi: 'चरण 3',
        dayArabic: 'الخطوة 3',
        title: 'Sa\'i (Walking between hills)',
        titleUrdu: 'سعی',
        titleHindi: 'सई',
        titleArabic: 'السعي',
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
        stepsArabic: [
          'اذهب إلى جبل الصفا',
          'استقبل الكعبة وادعُ',
          'امشِ نحو المروة',
          'الرجال: اهرول بين العلمين الأخضرين',
          'أكمل 7 أشواط (تنتهي عند المروة)',
          'ادعُ واذكر الله طوال السعي',
        ],
      ),
      HajjStep(
        day: 'Step 4',
        dayUrdu: 'مرحلہ 4',
        dayHindi: 'चरण 4',
        dayArabic: 'الخطوة 4',
        title: 'Halq or Taqsir',
        titleUrdu: 'حلق یا تقصیر',
        titleHindi: 'हल्क़ या तक़्सीर',
        titleArabic: 'الحلق أو التقصير',
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
        stepsArabic: [
          'الرجال: احلق رأسك بالكامل (الحلق) - الأفضل',
          'أو قصر شعرك على الأقل (التقصير)',
          'النساء: اقطع قدر أنملة من الشعر',
          'هذا يمثل نهاية الإحرام',
          'جميع محظورات الإحرام أصبحت مرفوعة الآن',
          'عمرتك مكتملة! الحمد لله',
        ],
      ),
    ];

    return _buildGuideList(umrahSteps, 'Umrah');
  }

  Widget _buildGuideList(List<HajjStep> steps, String type) {
    final responsive = ResponsiveUtils(context);

    return SingleChildScrollView(
      padding: responsive.paddingRegular,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(type),
          SizedBox(height: responsive.spaceRegular),
          ...steps.map((step) => _buildStepCard(step)),
          SizedBox(height: responsive.spaceRegular),
          _buildDuasCard(type),
          SizedBox(height: responsive.spaceRegular),
          _buildProhibitionsCard(),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String type) {
    final responsive = ResponsiveUtils(context);
    final title = type == 'Hajj'
        ? context.tr('guide_to_hajj')
        : context.tr('guide_to_umrah');

    String subtitle;

    switch (_selectedLanguage) {
      case HajjLanguage.urdu:
        subtitle = type == 'Hajj'
            ? 'اسلام کا پانچواں رکن - زندگی میں ایک بار فرض'
            : 'چھوٹا حج - سال میں کسی بھی وقت ادا کیا جا سکتا ہے';
        break;
      case HajjLanguage.hindi:
        subtitle = type == 'Hajj'
            ? 'इस्लाम का पांचवां रुक्न - ज़िंदगी में एक बार फ़र्ज़'
            : 'छोटा हज - साल में कभी भी अदा किया जा सकता है';
        break;
      case HajjLanguage.arabic:
        subtitle = type == 'Hajj'
            ? 'الركن الخامس من أركان الإسلام - واجب مرة واحدة في العمر'
            : 'الحج الأصغر - يمكن أداؤها في أي وقت من السنة';
        break;
      default:
        subtitle = type == 'Hajj'
            ? 'The fifth pillar of Islam - obligatory once in a lifetime'
            : context.tr('umrah_description');
    }

    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.radiusXLarge),
      ),
      child: Column(
        children: [
          Icon(Icons.mosque, color: Colors.white, size: responsive.iconXXLarge),
          SizedBox(height: responsive.spaceMedium),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.textXXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.spaceSmall),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: responsive.textMedium,
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
    final responsive = ResponsiveUtils(context);

    final title = _selectedLanguage == HajjLanguage.urdu
        ? step.titleUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? step.titleHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? step.titleArabic
        : step.title;

    final day = _selectedLanguage == HajjLanguage.urdu
        ? step.dayUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? step.dayHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? step.dayArabic
        : step.day;

    final steps = _selectedLanguage == HajjLanguage.urdu
        ? step.stepsUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? step.stepsHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? step.stepsArabic
        : step.steps;

    return Container(
      margin: EdgeInsets.only(bottom: responsive.spaceMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(responsive.spaceSmall),
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              color: step.color,
              size: responsive.iconMedium,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.textRegular,
            ),
          ),
          subtitle: Text(
            day,
            style: TextStyle(color: step.color, fontSize: responsive.textSmall),
          ),
          children: [
            Padding(
              padding: responsive.paddingRegular,
              child: Column(
                children: steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: responsive.spaceSmall),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: responsive.iconMedium,
                          height: responsive.iconMedium,
                          decoration: BoxDecoration(
                            color: step.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                color: step.color,
                                fontSize: responsive.textSmall,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.spaceMedium),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              height: 1.4,
                              fontSize: responsive.textMedium,
                            ),
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
    final responsive = ResponsiveUtils(context);
    final duas = [
      HajjDua(
        id: '1',
        title: 'Talbiyah',
        titleUrdu: 'تلبیہ',
        titleHindi: 'तल्बियह',
        titleArabic: 'التلبية',
        arabic:
            'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
        translationEn:
            'Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Verily all praise, grace and sovereignty belong to You. You have no partner.',
        translationUrdu:
            'حاضر ہوں اے اللہ حاضر ہوں۔ حاضر ہوں، تیرا کوئی شریک نہیں، حاضر ہوں۔ بے شک تمام تعریف، نعمت اور بادشاہی تیری ہے۔ تیرا کوئی شریک نہیں۔',
        translationHindi:
            'हाज़िर हूं ऐ अल्लाह हाज़िर हूं। हाज़िर हूं, तेरा कोई शरीक नहीं, हाज़िर हूं। बेशक सारी तारीफ़, नेमत और बादशाही तेरी है। तेरा कोई शरीक नहीं।',
        translationArabic:
            'ها أنا ذا يا الله ها أنا ذا، ها أنا ذا لا شريك لك ها أنا ذا، إن الحمد والنعمة لك والملك، لا شريك لك.',
      ),
      HajjDua(
        id: '2',
        title: 'Dua between Yemeni Corner and Black Stone',
        titleUrdu: 'رکن یمانی اور حجر اسود کے درمیان کی دعا',
        titleHindi: 'रुक्न यमानी और हज्र-ए-अस्वद के बीच की दुआ',
        titleArabic: 'الدعاء بين الركن اليماني والحجر الأسود',
        arabic:
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        translationEn:
            'Our Lord, give us good in this world and good in the Hereafter, and save us from the punishment of the Fire.',
        translationUrdu:
            'اے ہمارے رب! ہمیں دنیا میں بھی بھلائی دے اور آخرت میں بھی بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔',
        translationHindi:
            'ऐ हमारे रब! हमें दुनिया में भी भलाई दे और आख़िरत में भी भलाई दे और हमें आग के अज़ाब से बचा।',
        translationArabic:
            'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار.',
      ),
      HajjDua(
        id: '3',
        title: 'Dua on Mount Safa/Marwa',
        titleUrdu: 'صفا/مروہ پر دعا',
        titleHindi: 'सफ़ा/मरवा पर दुआ',
        titleArabic: 'الدعاء على جبل الصفا/المروة',
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        translationEn:
            'There is no god but Allah alone, with no partner. His is the dominion, and His is the praise, and He is able to do all things.',
        translationUrdu:
            'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہی اسی کی ہے اور تعریف اسی کے لیے ہے اور وہ ہر چیز پر قادر ہے۔',
        translationHindi:
            'अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं। बादशाही उसी की है और तारीफ़ उसी के लिए है और वो हर चीज़ पर क़ादिर है।',
        translationArabic:
            'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
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
      case HajjLanguage.arabic:
        sectionTitle = 'أدعية مهمة';
        break;
      default:
        sectionTitle = 'Important Duas';
    }

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: darkGreen,
                  size: responsive.iconMedium,
                ),
                SizedBox(width: responsive.spaceSmall),
                Text(
                  sectionTitle,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spaceRegular),
            ...duas.map((dua) => _buildDuaItem(dua)),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaItem(HajjDua dua) {
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);
    final responsive = ResponsiveUtils(context);

    final title = _selectedLanguage == HajjLanguage.urdu
        ? dua.titleUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? dua.titleHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? dua.titleArabic
        : dua.title;

    final translation = _selectedLanguage == HajjLanguage.urdu
        ? dua.translationUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? dua.translationHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? dua.translationArabic
        : dua.translationEn;

    final isExpanded = _expandedDuas.contains(dua.id);
    final isPlayingArabic = _isPlaying && _currentPlayingId == '${dua.id}_arabic';
    final isPlayingTranslation = _isPlaying && _currentPlayingId == '${dua.id}_translation';
    final isPlaying = isPlayingArabic || isPlayingTranslation;

    String languageLabel;
    switch (_selectedLanguage) {
      case HajjLanguage.hindi:
        languageLabel = context.tr('hindi');
        break;
      case HajjLanguage.urdu:
        languageLabel = context.tr('urdu');
        break;
      case HajjLanguage.arabic:
        languageLabel = context.tr('arabic');
        break;
      default:
        languageLabel = context.tr('english');
    }

    return Container(
      margin: EdgeInsets.only(bottom: responsive.spaceRegular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying ? AppColors.primaryLight : lightGreenBorder,
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
                  : lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // Title Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
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
                      onTap: () => _speakDua(dua.arabic, '${dua.id}_arabic'),
                      isActive: isPlayingArabic,
                      responsive: responsive,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleDuaExpanded(dua.id),
                      isActive: isExpanded,
                      responsive: responsive,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyDua(dua, title, translation),
                      isActive: false,
                      responsive: responsive,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareDua(dua, title, translation),
                      isActive: false,
                      responsive: responsive,
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
                _speakDua(dua.arabic, '${dua.id}_arabic');
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
                      dua.arabic,
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
                  _speakDua(translation, '${dua.id}_translation');
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
                            translation,
                            style: TextStyle(
                              fontSize: responsive.textMedium,
                              height: 1.6,
                              color: isPlayingTranslation
                                  ? AppColors.primary
                                  : Colors.black87,
                              fontFamily:
                                  _selectedLanguage == HajjLanguage.arabic
                                  ? 'Amiri'
                                  : null,
                            ),
                            textDirection:
                                (_selectedLanguage == HajjLanguage.urdu ||
                                    _selectedLanguage == HajjLanguage.arabic)
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
    required ResponsiveUtils responsive,
  }) {
    const lightGreenChip = Color(0xFFE8F3ED);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : lightGreenChip,
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

  void _toggleDuaExpanded(String duaId) {
    setState(() {
      if (_expandedDuas.contains(duaId)) {
        _expandedDuas.remove(duaId);
      } else {
        _expandedDuas.add(duaId);
      }
    });
  }

  void _speakDua(String text, String id) async {
    if (_isPlaying && _currentPlayingId == id) {
      _stopPlaying();
    } else {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = true;
        _currentPlayingId = id;
      });
      await _flutterTts.speak(text);
    }
  }

  void _stopPlaying() async {
    await _flutterTts.stop();
    setState(() {
      _isPlaying = false;
      _currentPlayingId = null;
    });
  }

  void _copyDua(HajjDua dua, String title, String translation) {
    Clipboard.setData(
      ClipboardData(text: '$title\n\n${dua.arabic}\n\n$translation'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('copied')),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareDua(HajjDua dua, String title, String translation) {
    Share.share('$title\n\n${dua.arabic}\n\n$translation');
  }

  Widget _buildProhibitionsCard() {
    final responsive = ResponsiveUtils(context);
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
      case HajjLanguage.arabic:
        sectionTitle = 'محظورات الإحرام';
        prohibitions = [
          'قص الشعر أو الأظافر',
          'استخدام العطر',
          'تغطية الرأس (الرجال)',
          'الملابس المخيطة (الرجال)',
          'صيد الحيوانات',
          'عقد النكاح',
          'العلاقات الزوجية',
          'الجدال والقتال',
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
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.block,
                  color: Colors.red,
                  size: responsive.iconMedium,
                ),
                SizedBox(width: responsive.spaceSmall),
                Text(
                  sectionTitle,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spaceRegular),
            Wrap(
              spacing: responsive.spaceSmall,
              runSpacing: responsive.spaceSmall,
              children: prohibitions
                  .map(
                    (p) => Chip(
                      label: Text(
                        p,
                        style: TextStyle(fontSize: responsive.textSmall),
                      ),
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      side: BorderSide.none,
                    ),
                  )
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
  final String dayArabic;
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final IconData icon;
  final Color color;
  final List<String> steps;
  final List<String> stepsUrdu;
  final List<String> stepsHindi;
  final List<String> stepsArabic;

  HajjStep({
    required this.day,
    required this.dayUrdu,
    required this.dayHindi,
    required this.dayArabic,
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.titleArabic,
    required this.icon,
    required this.color,
    required this.steps,
    required this.stepsUrdu,
    required this.stepsHindi,
    required this.stepsArabic,
  });
}

class HajjDua {
  final String id;
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final String arabic;
  final String translationEn;
  final String translationUrdu;
  final String translationHindi;
  final String translationArabic;

  HajjDua({
    required this.id,
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.titleArabic,
    required this.arabic,
    required this.translationEn,
    required this.translationUrdu,
    required this.translationHindi,
    required this.translationArabic,
  });
}
