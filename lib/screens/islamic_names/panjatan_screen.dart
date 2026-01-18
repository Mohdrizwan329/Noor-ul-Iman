import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'islamic_name_detail_screen.dart';

class PanjatanScreen extends StatefulWidget {
  const PanjatanScreen({super.key});

  @override
  State<PanjatanScreen> createState() => _PanjatanScreenState();
}

class _PanjatanScreenState extends State<PanjatanScreen> {
  final List<Map<String, dynamic>> _panjatanNames = [
    {
      'name': 'محمد ﷺ',
      'transliteration': 'Muhammad ﷺ',
      'title': 'Prophet of Allah',
      'titleUrdu': 'اللہ کے نبی',
      'titleHindi': 'अल्लाह के नबी',
      'description':
          'Prophet Muhammad ﷺ (570-632 CE) is the final messenger of Allah, sent as a mercy to all worlds. He received the Holy Quran through Angel Jibreel over 23 years. Born in Makkah, he was known as Al-Amin (The Trustworthy) and As-Sadiq (The Truthful) even before prophethood. He migrated to Madinah, established the first Muslim community, and united Arabia under Islam. His character, teachings, and example (Sunnah) serve as a complete guide for humanity. He is the leader of all prophets and the best of creation. His night journey (Isra and Mi\'raj) and many miracles are documented. He left behind two weighty things: the Quran and his Ahlul Bayt (family).',
      'descriptionUrdu':
          'نبی محمد ﷺ (570-632 عیسوی) اللہ کے آخری رسول ہیں، تمام جہانوں کے لیے رحمت بن کر بھیجے گئے۔ انہوں نے 23 سال میں فرشتہ جبرائیل کے ذریعے قرآن مجید حاصل کیا۔ مکہ میں پیدا ہوئے، نبوت سے پہلے بھی الامین (قابل اعتماد) اور الصادق (سچے) کے نام سے مشہور تھے۔ انہوں نے مدینہ ہجرت کی، پہلی مسلم کمیونٹی قائم کی، اور عرب کو اسلام کے تحت متحد کیا۔ ان کا کردار، تعلیمات اور مثال (سنت) انسانیت کے لیے مکمل رہنما ہے۔ وہ تمام انبیاء کے سردار اور مخلوق میں سب سے افضل ہیں۔ ان کا شب معراج (اسراء و معراج) اور بہت سے معجزات مستند ہیں۔ انہوں نے دو بھاری چیزیں چھوڑیں: قرآن اور ان کے اہل بیت (خاندان)۔',
      'descriptionHindi':
          'नबी मुहम्मद ﷺ (570-632 ई.) अल्लाह के आख़िरी रसूल हैं, तमाम जहानों के लिए रहमत बनकर भेजे गए। उन्होंने 23 साल में फ़रिश्ता जिब्राईल के ज़रिए क़ुरआन मजीद हासिल किया। मक्का में पैदा हुए, नबुव्वत से पहले भी अल-अमीन (क़ाबिल-ए-एतिमाद) और अस-सादिक़ (सच्चे) के नाम से मशहूर थे। उन्होंने मदीना हिजरत की, पहली मुस्लिम कम्युनिटी क़ायम की, और अरब को इस्लाम के तहत मुत्तहिद किया। उनका किरदार, तालीमात और मिसाल (सुन्नत) इंसानियत के लिए मुकम्मल रहनुमा है। वे तमाम अंबिया के सरदार और मख़लूक़ात में सबसे अफ़ज़ल हैं। उनका शब-ए-मेराज (इसरा व मेराज) और बहुत से मोजिज़े मुस्तनद हैं। उन्होंने दो भारी चीज़ें छोड़ीं: क़ुरआन और उनके अहले-बैत (ख़ानदान)।',
      'fatherName': 'Abdullah ibn Abd al-Muttalib',
      'motherName': 'Aminah bint Wahb',
      'birthDate': '12 Rabi al-Awwal, 53 BH (570 CE)',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '12 Rabi al-Awwal, 11 AH (632 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse':
          'Khadijah, Sawda, Aisha, Hafsa, Zaynab, Umm Salama, Zaynab bint Jahsh, Juwayriya, Safiyya, Umm Habiba, Maymuna, Maria',
      'children':
          'Qasim, Abdullah, Ibrahim, Zaynab, Ruqayyah, Umm Kulthum, Fatimah',
      'tribe': 'Banu Hashim, Quraysh',
      'knownFor': 'Final Prophet, Founder of Islam, Received Quran',
    },
    {
      'name': 'علي',
      'transliteration': 'Ali ibn Abi Talib',
      'title': 'Amir al-Mu\'minin',
      'titleUrdu': 'امیر المومنین',
      'titleHindi': 'अमीरुल मोमिनीन',
      'description':
          'Imam Ali (AS) was the cousin and son-in-law of Prophet Muhammad ﷺ, born inside the Kaaba - a unique honor. He was the first male to accept Islam at age 10 and was raised in the Prophet\'s household. He married Fatimah (AS) and fathered Hasan and Husayn. Known as Asadullah (Lion of Allah) for his bravery, he never fled from battle. The Prophet said: "I am the city of knowledge and Ali is its gate" and "Whoever I am master of, Ali is his master." He was known for his justice, wisdom, eloquence, and worship. He served as the fourth Caliph and his sermons are preserved in Nahj al-Balagha.',
      'descriptionUrdu':
          'امام علی علیہ السلام نبی محمد ﷺ کے چچا زاد بھائی اور داماد تھے، کعبہ کے اندر پیدا ہوئے - ایک منفرد اعزاز۔ وہ 10 سال کی عمر میں اسلام قبول کرنے والے پہلے مرد تھے اور نبی کے گھر میں پرورش پائی۔ انہوں نے فاطمہ (ع) سے شادی کی اور حسن و حسین کے والد بنے۔ اپنی بہادری کے لیے اسد اللہ (اللہ کا شیر) کے نام سے مشہور تھے، کبھی میدان جنگ سے نہیں بھاگے۔ نبی ﷺ نے فرمایا: "میں علم کا شہر ہوں اور علی اس کا دروازہ ہے" اور "جس کا میں مولا ہوں علی اس کے مولا ہیں۔" وہ اپنے انصاف، حکمت، فصاحت اور عبادت کے لیے مشہور تھے۔ وہ چوتھے خلیفہ تھے اور ان کے خطبات نہج البلاغہ میں محفوظ ہیں۔',
      'descriptionHindi':
          'इमाम अली (अ.स.) नबी मुहम्मद ﷺ के चचाज़ाद भाई और दामाद थे, काबा के अंदर पैदा हुए - एक मुनफ़रिद एज़ाज़। वे 10 साल की उम्र में इस्लाम क़बूल करने वाले पहले मर्द थे और नबी के घर में परवरिश पाई। उन्होंने फ़ातिमा (अ.स.) से शादी की और हसन व हुसैन के वालिद बने। अपनी बहादुरी के लिए असदुल्लाह (अल्लाह का शेर) के नाम से मशहूर थे, कभी मैदान-ए-जंग से नहीं भागे। नबी ﷺ ने फ़रमाया: "मैं इल्म का शहर हूं और अली इसका दरवाज़ा है" और "जिसका मैं मौला हूं अली उसके मौला हैं।" वे अपने इंसाफ़, हिकमत, फ़साहत और इबादत के लिए मशहूर थे। वे चौथे ख़लीफ़ा थे और उनके ख़ुत्बात नहजुल बलाग़ा में महफ़ूज़ हैं।',
      'fatherName': 'Abu Talib ibn Abd al-Muttalib',
      'motherName': 'Fatimah bint Asad',
      'birthDate': '13 Rajab, 30 BH (600 CE)',
      'birthPlace': 'Inside the Kaaba, Makkah',
      'deathDate': '21 Ramadan, 40 AH (661 CE)',
      'deathPlace': 'Kufa, Iraq (Martyred)',
      'spouse': 'Fatimah bint Muhammad, Umm al-Banin, Layla, Asma, Umama',
      'children':
          'Hasan, Husayn, Zaynab, Umm Kulthum, Abbas, Muhammad ibn Hanafiyyah',
      'tribe': 'Banu Hashim, Quraysh',
      'knownFor': 'First Imam, Fourth Caliph, Lion of Allah, Gate of Knowledge',
    },
    {
      'name': 'فاطمة',
      'transliteration': 'Fatimah Az-Zahra',
      'title': 'Sayyidatun Nisa (Leader of Women)',
      'titleUrdu': 'سیدۃ النساء (خواتین کی سردار)',
      'titleHindi': 'सय्यिदतुन निसा (ख़वातीन की सरदार)',
      'description':
          'Fatimah Az-Zahra (AS) was the beloved daughter of Prophet Muhammad ﷺ and Khadijah. She is called "part of me" by the Prophet, who said "whoever angers her angers me." She is the leader of the women of Paradise and one of the four perfect women in history. Known for her worship, she would pray until her feet swelled. She was extremely generous despite living simply. She married Ali and was the mother of Hasan, Husayn, Zaynab, and Umm Kulthum. The verse of purification (33:33) was revealed about her and her family. She passed away shortly after her father, grief-stricken by his loss.',
      'descriptionUrdu':
          'فاطمہ الزہرا (ع) نبی محمد ﷺ اور خدیجہ کی محبوب بیٹی تھیں۔ نبی ﷺ نے انہیں "میرا ٹکڑا" کہا اور فرمایا "جس نے انہیں ناراض کیا اس نے مجھے ناراض کیا۔" وہ جنت کی خواتین کی سردار اور تاریخ کی چار کامل خواتین میں سے ایک ہیں۔ اپنی عبادت کے لیے مشہور تھیں، اتنی نماز پڑھتیں کہ پاؤں سوج جاتے۔ سادگی سے رہنے کے باوجود انتہائی سخی تھیں۔ انہوں نے علی سے شادی کی اور حسن، حسین، زینب اور ام کلثوم کی ماں تھیں۔ آیت تطہیر (33:33) ان اور ان کے خاندان کے بارے میں نازل ہوئی۔ وہ اپنے والد کے انتقال کے فوراً بعد ان کے غم میں وفات پا گئیں۔',
      'descriptionHindi':
          'फ़ातिमा ज़हरा (अ.स.) नबी मुहम्मद ﷺ और ख़दीजा की महबूब बेटी थीं। नबी ﷺ ने उन्हें "मेरा टुकड़ा" कहा और फ़रमाया "जिसने उन्हें नाराज़ किया उसने मुझे नाराज़ किया।" वे जन्नत की ख़वातीन की सरदार और तारीख़ की चार कामिल ख़वातीन में से एक हैं। अपनी इबादत के लिए मशहूर थीं, इतनी नमाज़ पढ़तीं कि पैर सूज जाते। सादगी से रहने के बावजूद बेहद सख़ी थीं। उन्होंने अली से शादी की और हसन, हुसैन, ज़ैनब और उम्मे कुलसूम की माँ थीं। आयत-ए-तत्हीर (33:33) उन और उनके ख़ानदान के बारे में नाज़िल हुई। वे अपने वालिद के इंतिक़ाल के फ़ौरन बाद उनके ग़म में वफ़ात पा गईं।',
      'fatherName': 'Prophet Muhammad ﷺ',
      'motherName': 'Khadijah bint Khuwaylid',
      'birthDate': '20 Jumada al-Thani, 5 BH (615 CE)',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '3 Jumada al-Thani, 11 AH (632 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Ali ibn Abi Talib',
      'children': 'Hasan, Husayn, Zaynab, Umm Kulthum, Muhsin',
      'tribe': 'Banu Hashim, Quraysh',
      'knownFor':
          'Leader of Women of Paradise, Mother of Imams, Part of Prophet',
    },
    {
      'name': 'الحسن',
      'transliteration': 'Hasan ibn Ali',
      'title': 'Al-Mujtaba (The Chosen)',
      'titleUrdu': 'المجتبیٰ (منتخب)',
      'titleHindi': 'अल-मुजतबा (चुना हुआ)',
      'description':
          'Imam Hasan (AS) was the elder grandson of Prophet Muhammad ﷺ, born in 3 AH. The Prophet loved him deeply and said he and his brother are "leaders of the youth of Paradise." He resembled the Prophet in appearance and character. He was known for his generosity, dignity, patience, and piety. He made peace with Muawiyah to prevent bloodshed among Muslims, fulfilling the Prophet\'s prediction that through him Allah would make peace between two great groups. He was extremely charitable, making pilgrimage on foot 25 times while camels walked beside him. He was poisoned and is buried in Jannat al-Baqi in Madinah.',
      'descriptionUrdu':
          'امام حسن علیہ السلام نبی محمد ﷺ کے بڑے نواسے تھے، 3 ہجری میں پیدا ہوئے۔ نبی ﷺ انہیں بہت پیار کرتے تھے اور فرمایا وہ اور ان کے بھائی "جنت کے نوجوانوں کے سردار" ہیں۔ وہ شکل و صورت اور کردار میں نبی ﷺ سے ملتے تھے۔ اپنی سخاوت، وقار، صبر اور تقویٰ کے لیے مشہور تھے۔ انہوں نے مسلمانوں میں خونریزی روکنے کے لیے معاویہ سے صلح کی، جو نبی ﷺ کی پیشگوئی کی تکمیل تھی کہ ان کے ذریعے اللہ دو بڑے گروہوں میں صلح کرائے گا۔ انتہائی خیرات کرتے تھے، 25 مرتبہ پیدل حج کیا جبکہ اونٹ ساتھ چلتے تھے۔ انہیں زہر دیا گیا اور جنت البقیع مدینہ میں مدفون ہیں۔',
      'descriptionHindi':
          'इमाम हसन (अ.स.) नबी मुहम्मद ﷺ के बड़े नवासे थे, 3 हिजरी में पैदा हुए। नबी ﷺ उन्हें बहुत प्यार करते थे और फ़रमाया वे और उनके भाई "जन्नत के नौजवानों के सरदार" हैं। वे शक्ल व सूरत और किरदार में नबी ﷺ से मिलते थे। अपनी सख़ावत, वक़ार, सब्र और तक़वा के लिए मशहूर थे। उन्होंने मुसलमानों में ख़ूंरेज़ी रोकने के लिए मुआविया से सुलह की, जो नबी ﷺ की पेशगोई की तकमील थी कि उनके ज़रिए अल्लाह दो बड़े गिरोहों में सुलह कराएगा। बेहद ख़ैरात करते थे, 25 मर्तबा पैदल हज किया जबकि ऊंट साथ चलते थे। उन्हें ज़हर दिया गया और जन्नतुल बक़ी मदीना में मदफ़ून हैं।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '15 Ramadan, 3 AH (625 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '28 Safar, 50 AH (670 CE)',
      'deathPlace': 'Madinah, Arabia (Poisoned)',
      'spouse':
          'Multiple wives including Umm Ishaq, Hafsa, Hind, Ja\'da bint al-Ash\'ath',
      'children': 'Zayd, Hasan, Qasim, Abdullah, Amr, Abdur Rahman',
      'tribe': 'Banu Hashim, Quraysh',
      'knownFor': 'Second Imam, Leader of Youth of Paradise, Peace Maker',
    },
    {
      'name': 'الحسين',
      'transliteration': 'Husayn ibn Ali',
      'title': 'Sayyid al-Shuhada (Master of Martyrs)',
      'titleUrdu': 'سید الشہداء',
      'titleHindi': 'सय्यिदुश्शुहदा',
      'description':
          'Imam Husayn (AS) was the younger grandson of Prophet Muhammad ﷺ, born in 4 AH. The Prophet said "Husayn is from me and I am from Husayn" and called him the "leader of the youth of Paradise." He stood against the tyranny of Yazid, refusing to give allegiance to corruption. In 680 CE at Karbala, he and 72 companions, including family members, were martyred on the 10th of Muharram (Ashura). His sacrifice symbolizes the eternal struggle of truth against falsehood, justice against tyranny. The Prophet cried when Jibreel told him of Husayn\'s future martyrdom. His shrine in Karbala is visited by millions. His sister Zaynab carried his message to the world.',
      'descriptionUrdu':
          'امام حسین علیہ السلام نبی محمد ﷺ کے چھوٹے نواسے تھے، 4 ہجری میں پیدا ہوئے۔ نبی ﷺ نے فرمایا "حسین مجھ سے ہے اور میں حسین سے ہوں" اور انہیں "جنت کے نوجوانوں کا سردار" کہا۔ انہوں نے یزید کے ظلم کے خلاف کھڑے ہوکر فساد کی بیعت سے انکار کیا۔ 680 عیسوی میں کربلا میں وہ اور 72 ساتھی بشمول خاندان کے افراد 10 محرم (عاشورہ) کو شہید ہوئے۔ ان کی قربانی حق کی باطل کے خلاف، انصاف کی ظلم کے خلاف ابدی جدوجہد کی علامت ہے۔ نبی ﷺ روئے جب جبرائیل نے انہیں حسین کی آئندہ شہادت کی خبر دی۔ کربلا میں ان کے مزار کی لاکھوں زیارت کرتے ہیں۔ ان کی بہن زینب نے ان کا پیغام دنیا تک پہنچایا۔',
      'descriptionHindi':
          'इमाम हुसैन (अ.स.) नबी मुहम्मद ﷺ के छोटे नवासे थे, 4 हिजरी में पैदा हुए। नबी ﷺ ने फ़रमाया "हुसैन मुझसे है और मैं हुसैन से हूं" और उन्हें "जन्नत के नौजवानों का सरदार" कहा। उन्होंने यज़ीद के ज़ुल्म के ख़िलाफ़ खड़े होकर फ़साद की बैअत से इनकार किया। 680 ई. में कर्बला में वे और 72 साथी बशमूल ख़ानदान के अफ़राद 10 मुहर्रम (आशूरा) को शहीद हुए। उनकी क़ुर्बानी हक़ की बातिल के ख़िलाफ़, इंसाफ़ की ज़ुल्म के ख़िलाफ़ अबदी जद्दोजहद की निशानी है। नबी ﷺ रोए जब जिब्राईल ने उन्हें हुसैन की आइंदा शहादत की ख़बर दी। कर्बला में उनके मज़ार की लाखों ज़ियारत करते हैं। उनकी बहन ज़ैनब ने उनका पैग़ाम दुनिया तक पहुंचाया।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '3 Sha\'ban, 4 AH (626 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '10 Muharram, 61 AH (680 CE)',
      'deathPlace': 'Karbala, Iraq (Martyred)',
      'spouse': 'Shahrbanu, Rabab, Layla, Umm Ishaq',
      'children':
          'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah, Ruqayyah',
      'tribe': 'Banu Hashim, Quraysh',
      'knownFor': 'Third Imam, Master of Martyrs, Hero of Karbala',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Panjatan Pak'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _panjatanNames.length,
              itemBuilder: (context, index) {
                return _buildNameCard(_panjatanNames[index], index + 1, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard(Map<String, dynamic> name, int index, bool isDark) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const softGold = Color(0xFFC9A24D);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IslamicNameDetailScreen(
              arabicName: name['name'],
              transliteration: name['transliteration'],
              meaning: name['title'],
              meaningUrdu: name['titleUrdu'] ?? '',
              meaningHindi: name['titleHindi'] ?? '',
              description: name['description'],
              descriptionUrdu: name['descriptionUrdu'] ?? '',
              descriptionHindi: name['descriptionHindi'] ?? '',
              category: 'Panjatan Pak',
              number: index,
              icon: Icons.favorite,
              color: Colors.red,
              fatherName: name['fatherName'],
              motherName: name['motherName'],
              birthDate: name['birthDate'],
              birthPlace: name['birthPlace'],
              deathDate: name['deathDate'],
              deathPlace: name['deathPlace'],
              spouse: name['spouse'],
              children: name['children'],
              tribe: name['tribe'],
              knownFor: name['knownFor'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : lightGreenBorder,
            width: 1.5,
          ),
          boxShadow: isDark
              ? null
              : [
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
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? emeraldGreen : darkGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? emeraldGreen : darkGreen).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name['transliteration']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name['title']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.secondary : softGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name['name']!,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Amiri',
                          color: isDark ? AppColors.secondary : softGold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : emeraldGreen,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade800
                      : const Color(0xFFE8F3ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 16,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : emeraldGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tap to read full biography',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : emeraldGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
