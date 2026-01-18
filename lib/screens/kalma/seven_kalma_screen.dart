import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';

class SevenKalmaScreen extends StatefulWidget {
  const SevenKalmaScreen({super.key});

  @override
  State<SevenKalmaScreen> createState() => _SevenKalmaScreenState();
}

class _SevenKalmaScreenState extends State<SevenKalmaScreen> {
  String _selectedLanguage = 'urdu';

  final List<Map<String, dynamic>> _kalmas = [
    {
      'number': 1,
      'name': 'Kalma Tayyab (First Kalma)',
      'nameUrdu': 'کلمہ طیب (پہلا کلمہ)',
      'nameHindi': 'कलमा तय्यब (पहला कलमा)',
      'arabic': 'لَا إِلٰهَ إِلَّا اللهُ مُحَمَّدٌ رَسُولُ اللهِ',
      'transliteration': 'La ilaha illallahu Muhammadur Rasulullah',
      'translationUrdu':
          'اللہ کے سوا کوئی معبود نہیں، محمد (ﷺ) اللہ کے رسول ہیں۔',
      'translationHindi':
          'अल्लाह के सिवा कोई माबूद नहीं, मुहम्मद (ﷺ) अल्लाह के रसूल हैं।',
      'translationEnglish':
          'There is no god but Allah, Muhammad (ﷺ) is the Messenger of Allah.',
      'color': Colors.green,
    },
    {
      'number': 2,
      'name': 'Kalma Shahadat (Second Kalma)',
      'nameUrdu': 'کلمہ شہادت (دوسرا کلمہ)',
      'nameHindi': 'कलमा शहादत (दूसरा कलमा)',
      'arabic':
          'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      'transliteration':
          'Ash-hadu an la ilaha illallahu wahdahu la sharika lahu, wa ash-hadu anna Muhammadan \'abduhu wa rasuluhu',
      'translationUrdu':
          'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اور میں گواہی دیتا ہوں کہ محمد (ﷺ) اللہ کے بندے اور رسول ہیں۔',
      'translationHindi':
          'मैं गवाही देता हूं कि अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं, और मैं गवाही देता हूं कि मुहम्मद (ﷺ) अल्लाह के बंदे और रसूल हैं।',
      'translationEnglish':
          'I bear witness that there is no god but Allah, alone without partner, and I bear witness that Muhammad (ﷺ) is His servant and Messenger.',
      'color': Colors.blue,
    },
    {
      'number': 3,
      'name': 'Kalma Tamjeed (Third Kalma)',
      'nameUrdu': 'کلمہ تمجید (تیسرا کلمہ)',
      'nameHindi': 'कलमा तमजीद (तीसरा कलमा)',
      'arabic':
          'سُبْحَانَ اللهِ وَالْحَمْدُ لِلّٰهِ وَلَا إِلٰهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ الْعَلِيِّ الْعَظِيمِ',
      'transliteration':
          'Subhanallahi walhamdu lillahi wa la ilaha illallahu wallahu akbar, wa la hawla wa la quwwata illa billahil-\'aliyyil-\'azeem',
      'translationUrdu':
          'اللہ پاک ہے، تمام تعریف اللہ کے لیے ہے، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے، اور اللہ کے سوا کوئی طاقت اور قوت نہیں جو بلند اور عظیم ہے۔',
      'translationHindi':
          'अल्लाह पाक है, तमाम तारीफ़ अल्लाह के लिए है, अल्लाह के सिवा कोई माबूद नहीं, अल्लाह सबसे बड़ा है, और अल्लाह के सिवा कोई ताक़त और क़ुव्वत नहीं जो बुलंद और अज़ीम है।',
      'translationEnglish':
          'Glory be to Allah, all praise is for Allah, there is no god but Allah, Allah is the Greatest, and there is no power nor might except with Allah, the Most High, the Most Great.',
      'color': Colors.purple,
    },
    {
      'number': 4,
      'name': 'Kalma Tauheed (Fourth Kalma)',
      'nameUrdu': 'کلمہ توحید (چوتھا کلمہ)',
      'nameHindi': 'कलमा तौहीद (चौथा कलमा)',
      'arabic':
          'لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
      'transliteration':
          'La ilaha illallahu wahdahu la sharika lahu, lahul-mulku wa lahul-hamdu, yuhyi wa yumitu, wa huwa \'ala kulli shay\'in qadeer',
      'translationUrdu':
          'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہی ہے، اسی کے لیے تمام تعریف ہے، وہ زندہ کرتا ہے اور مارتا ہے، اور وہ ہر چیز پر قادر ہے۔',
      'translationHindi':
          'अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं, उसी की बादशाही है, उसी के लिए तमाम तारीफ़ है, वो ज़िंदा करता है और मारता है, और वो हर चीज़ पर क़ादिर है।',
      'translationEnglish':
          'There is no god but Allah, alone without partner. His is the dominion and His is the praise. He gives life and causes death, and He has power over all things.',
      'color': Colors.orange,
    },
    {
      'number': 5,
      'name': 'Kalma Astaghfar (Fifth Kalma)',
      'nameUrdu': 'کلمہ استغفار (پانچواں کلمہ)',
      'nameHindi': 'कलमा इस्तिग़फ़ार (पांचवां कलमा)',
      'arabic':
          'أَسْتَغْفِرُ اللهَ رَبِّي مِنْ كُلِّ ذَنْبٍ أَذْنَبْتُهُ عَمَدًا أَوْ خَطَأً، سِرًّا أَوْ عَلَانِيَةً، وَأَتُوبُ إِلَيْهِ مِنَ الذَّنْبِ الَّذِي أَعْلَمُ وَمِنَ الذَّنْبِ الَّذِي لَا أَعْلَمُ، إِنَّكَ أَنْتَ عَلَّامُ الْغُيُوبِ وَسَتَّارُ الْعُيُوبِ وَغَفَّارُ الذُّنُوبِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ الْعَلِيِّ الْعَظِيمِ',
      'transliteration':
          'Astaghfirullaha Rabbi min kulli dhambin adhnabtuhu \'amdan aw khata\'an, sirran aw \'alaniyatan, wa atubu ilayhi minadh-dhambil-ladhi a\'lamu wa minadh-dhambil-ladhi la a\'lamu, innaka anta \'allamul-ghuyubi wa sattarul-\'uyubi wa ghaffarudh-dhunubi, wa la hawla wa la quwwata illa billahil-\'aliyyil-\'azeem',
      'translationUrdu':
          'میں اللہ سے اپنے رب سے معافی مانگتا ہوں ہر اس گناہ سے جو میں نے کیا جان بوجھ کر یا بھول کر، چھپ کر یا کھلے عام، اور میں اس سے توبہ کرتا ہوں اس گناہ سے جو میں جانتا ہوں اور اس گناہ سے جو میں نہیں جانتا، بیشک تو غیب کا جاننے والا، عیبوں کو چھپانے والا، اور گناہوں کو معاف ک��نے والا ہے، اور اللہ کے سوا کوئی طاقت اور قوت نہیں جو بلند اور عظیم ہے۔',
      'translationHindi':
          'मैं अल्लाह से अपने रब से माफ़ी मांगता हूं हर उस गुनाह से जो मैंने किया जान बूझकर या भूल कर, छुपकर या खुले आम, और मैं उससे तौबा करता हूं उस गुनाह से जो मैं जानता हूं और उस गुनाह से जो मैं नहीं जानता, बेशक तू ग़ैब का जानने वाला, ऐबों को छुपाने वाला, और गुनाहों को माफ़ करने वाला है, और अल्लाह के सिवा कोई ताक़त और क़ुव्वत नहीं जो बुलंद और अज़ीम है।',
      'translationEnglish':
          'I seek forgiveness from Allah, my Lord, from every sin I committed knowingly or unknowingly, secretly or openly, and I turn to Him in repentance from the sin which I know and from the sin which I do not know. Verily, You are the Knower of the unseen, the Concealer of faults, and the Forgiver of sins, and there is no power nor might except with Allah, the Most High, the Most Great.',
      'color': Colors.teal,
    },
    {
      'number': 6,
      'name': 'Kalma Radde Kufr (Sixth Kalma)',
      'nameUrdu': 'کلمہ ردِ کفر (چھٹا کلمہ)',
      'nameHindi': 'कलमा रद्दे कुफ़्र (छठा कलमा)',
      'arabic':
          'اَللّٰهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ أَنْ أُشْرِكَ بِكَ شَيْئًا وَأَنَا أَعْلَمُ، وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ، تُبْتُ عَنْهُ وَتَبَرَّأْتُ مِنَ الْكُفْرِ وَالشِّرْكِ وَالْكِذْبِ وَالْغِيبَةِ وَالْبِدْعَةِ وَالنَّمِيمَةِ وَالْفَوَاحِشِ وَالْبُهْتَانِ وَالْمَعَاصِي كُلِّهَا، وَأَسْلَمْتُ وَأَقُولُ لَا إِلٰهَ إِلَّا اللهُ مُحَمَّدٌ رَسُولُ اللهِ',
      'transliteration':
          'Allahumma inni a\'udhu bika min an ushrika bika shay\'an wa ana a\'lamu, wa astaghfiruka lima la a\'lamu, tubtu \'anhu wa tabarra\'tu minal-kufri wash-shirki wal-kidhbi wal-ghibati wal-bid\'ati wan-nameemati wal-fawahishi wal-buhtani wal-ma\'asi kulliha, wa aslamtu wa aqulu la ilaha illallahu Muhammadur Rasulullah',
      'translationUrdu':
          'اے اللہ! میں تیری پناہ مانگتا ہوں کہ میں تیرے ساتھ کسی چیز کو شریک ٹھہراؤں جان بوجھ کر، اور میں تجھ سے معافی مانگتا ہوں جو میں نہیں جانتا، میں نے اس سے توبہ کی اور میں بیزار ہوں کفر، شرک، جھوٹ، غیبت، بدعت، چغلی، بے حیائی، بہتان اور تمام گناہوں سے، اور میں نے اسلام قبول کیا اور میں کہتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، محمد (ﷺ) اللہ کے رسول ہیں۔',
      'translationHindi':
          'ऐ अल्लाह! मैं तेरी पनाह मांगता हूं कि मैं तेरे साथ किसी चीज़ को शरीक ठहराऊं जान बूझकर, और मैं तुझसे माफ़ी मांगता हूं जो मैं नहीं जानता, मैंने उससे तौबा की और मैं बेज़ार हूं कुफ़्र, शिर्क, झूठ, ग़ीबत, बिदअत, चुग़ली, बेहयाई, बोहतान और तमाम गुनाहों से, और मैंने इस्लाम क़बूल किया और मैं कहता हूं कि अल्लाह के सिवा कोई माबूद नहीं, मुहम्मद (ﷺ) अल्लाह के रसूल हैं।',
      'translationEnglish':
          'O Allah! I seek refuge in You from knowingly associating anything with You, and I seek Your forgiveness for what I do not know. I repent from it and I dissociate myself from disbelief, polytheism, lying, backbiting, innovation, slander, indecency, false accusations, and all sins. I have submitted and I say: There is no god but Allah, Muhammad (ﷺ) is the Messenger of Allah.',
      'color': Colors.red,
    },
    {
      'number': 7,
      'name': 'Kalma Iman-e-Mufassal (Seventh Kalma)',
      'nameUrdu': 'کلمہ ایمانِ مفصل (ساتواں کلمہ)',
      'nameHindi': 'कलमा ईमान-ए-मुफ़स्सल (सातवां कलमा)',
      'arabic':
          'آمَنْتُ بِاللهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ وَبِالْقَدَرِ خَيْرِهِ وَشَرِّهِ مِنَ اللهِ تَعَالَىٰ وَالْبَعْثِ بَعْدَ الْمَوْتِ',
      'transliteration':
          'Amantu billahi wa malaikatihi wa kutubihi wa rusulihi wal-yawmil-akhiri wa bil-qadari khayrihi wa sharrihi minallahi ta\'ala wal-ba\'thi ba\'dal-mawt',
      'translationUrdu':
          'میں ایمان لایا اللہ پر، اس کے فرشتوں پر، اس کی کتابوں پر، اس کے رسولوں پر، آخرت کے دن پر، اور تقدیر پر کہ اس کی بھلائی اور برائی اللہ تعالیٰ کی طرف سے ہے، اور موت کے بعد دوبارہ زندہ ہونے پر۔',
      'translationHindi':
          'मैं ईमान लाया अल्लाह पर, उसके फ़रिश्तों पर, उसकी किताबों पर, उसके रसूलों पर, आख़िरत के दिन पर, और तक़दीर पर कि उसकी भलाई और बुराई अल्लाह तआला की तरफ़ से है, और मौत के बाद दोबारा ज़िंदा होने पर।',
      'translationEnglish':
          'I believe in Allah, His Angels, His Books, His Messengers, the Last Day, and in the Divine Decree - that its good and evil are from Allah the Exalted, and in resurrection after death.',
      'color': Colors.indigo,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _selectedLanguage == 'urdu'
              ? 'سات کلمے'
              : _selectedLanguage == 'hindi'
              ? '7 कलमे'
              : '7 Kalmas',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedLanguage == 'urdu'
                    ? 'اردو'
                    : _selectedLanguage == 'hindi'
                    ? 'हिंदी'
                    : 'EN',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onSelected: (value) => setState(() => _selectedLanguage = value),
            itemBuilder: (context) => [
              _buildLanguageMenuItem('english', 'English'),
              _buildLanguageMenuItem('urdu', 'اردو'),
              _buildLanguageMenuItem('hindi', 'हिंदी'),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kalmas List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _kalmas.length,
              itemBuilder: (context, index) {
                final kalma = _kalmas[index];
                return _buildKalmaCard(kalma, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildLanguageMenuItem(String value, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (_selectedLanguage == value)
            Icon(Icons.check, color: AppColors.primary, size: 18)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: _selectedLanguage == value
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: _selectedLanguage == value ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKalmaCard(Map<String, dynamic> kalma, bool isDark) {
    final name = _selectedLanguage == 'english'
        ? kalma['name']
        : _selectedLanguage == 'urdu'
        ? kalma['nameUrdu']
        : kalma['nameHindi'];

    final translation = _selectedLanguage == 'english'
        ? kalma['translationEnglish']
        : _selectedLanguage == 'urdu'
        ? kalma['translationUrdu']
        : kalma['translationHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: (kalma['color'] as Color).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: (kalma['color'] as Color).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
              color: (kalma['color'] as Color).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kalma['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${kalma['number']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: _selectedLanguage == 'urdu'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),

          // Arabic Text
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              kalma['arabic'],
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.primary,
                height: 2.0,
              ),
            ),
          ),

          // Translation
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              translation,
              textAlign: _selectedLanguage == 'urdu'
                  ? TextAlign.right
                  : TextAlign.left,
              textDirection: _selectedLanguage == 'urdu'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
