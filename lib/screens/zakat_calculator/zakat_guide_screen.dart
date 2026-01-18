import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';

enum ZakatGuideLanguage { hindi, english, urdu }

class ZakatGuideScreen extends StatefulWidget {
  const ZakatGuideScreen({super.key});

  @override
  State<ZakatGuideScreen> createState() => _ZakatGuideScreenState();
}

class _ZakatGuideScreenState extends State<ZakatGuideScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  int? _playingSectionIndex;
  ZakatGuideLanguage _selectedLanguage = ZakatGuideLanguage.hindi;

  static const Map<ZakatGuideLanguage, String> languageNames = {
    ZakatGuideLanguage.hindi: 'Hindi',
    ZakatGuideLanguage.english: 'English',
    ZakatGuideLanguage.urdu: 'Urdu',
  };

  final List<Map<String, dynamic>> _sections = [
    {
      'icon': Icons.help_outline,
      'title': 'ज़कात क्या है?',
      'titleArabic': 'ما هي الزكاة؟',
      'titleEnglish': 'What is Zakat?',
      'contentHindi': '''ज़कात इस्लाम के पांच अरकान में से एक है। यह एक फ़र्ज़ इबादत है जो हर साहिब-ए-निसाब मुसलमान पर वाजिब है।

ज़कात का मतलब है "पाक करना" या "बढ़ना"। अपने माल में से 2.5% (1/40) हिस्सा गरीबों और ज़रूरतमंदों को देना ज़कात कहलाता है।

अल्लाह तआला ने क़ुरआन में फ़रमाया:
"और नमाज़ क़ायम करो और ज़कात दो"
(सूरह अल-बक़रह: 43)

ज़कात माल को पाक करती है और बरकत लाती है। यह दिल से बख़ीली (कंजूसी) दूर करती है और अल्लाह की रज़ा हासिल होती है।''',
      'contentEnglish': '''Zakat is one of the five pillars of Islam. It is an obligatory act of worship for every Muslim who possesses the minimum threshold (nisab).

The word Zakat means "purification" or "growth". Giving 2.5% (1/40) of your wealth to the poor and needy is called Zakat.

Allah says in the Quran:
"And establish prayer and give Zakat"
(Surah Al-Baqarah: 43)

Zakat purifies wealth and brings blessings. It removes greed from the heart and earns Allah's pleasure.''',
      'contentUrdu': '''زکات اسلام کے پانچ ارکان میں سے ایک ہے۔ یہ ہر صاحب نصاب مسلمان پر فرض عبادت ہے۔

زکات کا مطلب ہے "پاک کرنا" یا "بڑھنا"۔ اپنے مال میں سے 2.5% (1/40) حصہ غریبوں اور ضرورت مندوں کو دینا زکات کہلاتا ہے۔

اللہ تعالیٰ نے قرآن میں فرمایا:
"اور نماز قائم کرو اور زکات دو"
(سورۃ البقرۃ: 43)

زکات مال کو پاک کرتی ہے اور برکت لاتی ہے۔ یہ دل سے بخل دور کرتی ہے اور اللہ کی رضا حاصل ہوتی ہے۔''',
    },
    {
      'icon': Icons.star,
      'title': 'ज़कात क्यों ज़रूरी है?',
      'titleArabic': 'لماذا الزكاة مهمة؟',
      'titleEnglish': 'Why is Zakat Important?',
      'contentHindi': '''1. फ़र्ज़ इबादत: ज़कात इस्लाम का तीसरा रुक्न है। इसका इंकार कुफ्र है।

2. माल की सफ़ाई: ज़कात से माल पाक होता है और हलाल कमाई में बरकत आती है।

3. गरीबी का खात्मा: ज़कात से समाज में गरीबी कम होती है और दौलत का बंटवारा होता है।

4. आखिरत की कामयाबी: ज़कात देने वाले को जन्नत की बशारत है।

5. दिल की सफ़ाई: लालच और बख़ीली दूर होती है, और दिल में रहम पैदा होता है।

रसूलुल्लाह ﷺ ने फ़रमाया:
"जो शख्स अपनी ज़कात खुशी से देता है, उसके लिए जन्नत वाजिब हो जाती है।"
(सहीह बुखारी)''',
      'contentEnglish': '''1. Obligatory Worship: Zakat is the third pillar of Islam. Denying it is disbelief.

2. Purification of Wealth: Zakat purifies wealth and brings blessings to lawful earnings.

3. Elimination of Poverty: Zakat reduces poverty in society and distributes wealth.

4. Success in the Hereafter: Those who give Zakat are promised Paradise.

5. Purification of the Heart: It removes greed and stinginess, and creates mercy in the heart.

The Prophet ﷺ said:
"Whoever gives Zakat happily, Paradise becomes obligatory for him."
(Sahih Bukhari)''',
      'contentUrdu': '''1. فرض عبادت: زکات اسلام کا تیسرا رکن ہے۔ اس کا انکار کفر ہے۔

2. مال کی صفائی: زکات سے مال پاک ہوتا ہے اور حلال کمائی میں برکت آتی ہے۔

3. غربت کا خاتمہ: زکات سے معاشرے میں غربت کم ہوتی ہے اور دولت کی تقسیم ہوتی ہے۔

4. آخرت کی کامیابی: زکات دینے والے کو جنت کی بشارت ہے۔

5. دل کی صفائی: لالچ اور بخل دور ہوتی ہے، اور دل میں رحم پیدا ہوتی ہے۔

رسول اللہ ﷺ نے فرمایا:
"جو شخص اپنی زکات خوشی سے دیتا ہے، اس کے لیے جنت واجب ہو جاتی ہے۔"
(صحیح بخاری)''',
    },
    {
      'icon': Icons.person,
      'title': 'ज़कात किस पर फ़र्ज़ है?',
      'titleArabic': 'على من تجب الزكاة؟',
      'titleEnglish': 'Who Must Pay Zakat?',
      'contentHindi': '''ज़कात उन लोगों पर फ़र्ज़ है जिनके पास:

✓ निसाब: ज़कात के लिए कम से कम माल
   - सोना: 87.48 ग्राम (7.5 तोला)
   - चांदी: 612.36 ग्राम (52.5 तोला)

✓ एक साल: निसाब एक क़मरी साल तक रहे

✓ मालिक: माल का पूरा मालिक हो

✓ आक़िल बालिग़: समझदार और बालिग़ हो

✓ आज़ाद: गुलाम न हो

ज़कात वाजिब नहीं:
- बच्चों पर (बालिग़ होने तक)
- पागल पर
- मक़रूज़ (जिस पर क़र्ज़ हो जो निसाब से ज़्यादा हो)''',
      'contentEnglish': '''Zakat is obligatory for those who have:

✓ Nisab: Minimum wealth required for Zakat
   - Gold: 87.48 grams (7.5 tola)
   - Silver: 612.36 grams (52.5 tola)

✓ One Year: Nisab must be held for one lunar year

✓ Ownership: Must be the complete owner of the wealth

✓ Sane and Adult: Must be mentally sound and have reached puberty

✓ Free: Not enslaved

Zakat is Not Obligatory:
- On children (until they reach puberty)
- On the insane
- On those in debt exceeding the nisab''',
      'contentUrdu': '''زکات ان لوگوں پر فرض ہے جن کے پاس:

✓ نصاب: زکات کے لیے کم از کم مال
   - سونا: 87.48 گرام (7.5 تولہ)
   - چاندی: 612.36 گرام (52.5 تولہ)

✓ ایک سال: نصاب ایک قمری سال تک رہے

✓ مالک: مال کا پورا مالک ہو

✓ عاقل بالغ: سمجھدار اور بالغ ہو

✓ آزاد: غلام نہ ہو

زکات واجب نہیں:
- بچوں پر (بالغ ہونے تک)
- پاگل پر
- مقروض (جس پر قرض ہو جو نصاب سے زیادہ ہو)''',
    },
    {
      'icon': Icons.people,
      'title': 'ज़कात किसको दी जाए?',
      'titleArabic': 'مستحقو الزكاة',
      'titleEnglish': 'Who Can Receive Zakat?',
      'contentHindi': '''अल्लाह तआला ने क़ुरआन में 8 किस्म के लोगों का ज़िक्र किया है जिन्हें ज़कात दी जा सकती है:

1. फुक़रा (फ़क़ीर): जो अपनी ज़रूरत पूरी नहीं कर सकते

2. मसाकीन (मिस्कीन): जो बिल्कुल बेसहारा हैं

3. आमिलीन: जो ज़कात जमा करते हैं

4. मुअल्लफ़तुल क़ुलूब: नए मुसलमान जिनके दिल जीतने हैं

5. रिक़ाब: गुलामों को आज़ाद कराने के लिए

6. ग़ारिमीन: जो क़र्ज़ में डूबे हैं

7. फी सबीलिल्लाह: अल्लाह की राह में (जिहाद, तबलीग़)

8. इब्नुस्सबील: मुसाफिर जो सफर में अटक गया हो

(सूरह अत-तौबा: 60)''',
      'contentEnglish': '''Allah mentions 8 categories of people who can receive Zakat in the Quran:

1. Fuqara (The Poor): Those who cannot meet their basic needs

2. Masakeen (The Needy): Those who are completely destitute

3. Aamileen: Those who collect and distribute Zakat

4. Muallafatul Quloob: New Muslims whose hearts need to be reconciled

5. Riqaab: For freeing slaves

6. Ghaarimeen: Those burdened with debt

7. Fi Sabeelillah: In the cause of Allah (defense, preaching)

8. Ibn-us-Sabeel: Travelers stranded on their journey

(Surah At-Tawbah: 60)''',
      'contentUrdu': '''اللہ تعالیٰ نے قرآن میں 8 قسم کے لوگوں کا ذکر کیا ہے جنہیں زکات دی جا سکتی ہے:

1. فقراء (فقیر): جو اپنی ضرورت پوری نہیں کر سکتے

2. مساکین (مسکین): جو بالکل بے سہارا ہیں

3. عاملین: جو زکات جمع کرتے ہیں

4. مؤلفۃ القلوب: نئے مسلمان جن کے دل جیتنے ہیں

5. رقاب: غلاموں کو آزاد کرانے کے لیے

6. غارمین: جو قرض میں ڈوبے ہیں

7. فی سبیل اللہ: اللہ کی راہ میں (جہاد، تبلیغ)

8. ابن السبیل: مسافر جو سفر میں اٹک گیا ہو

(سورۃ التوبۃ: 60)''',
    },
    {
      'icon': Icons.block,
      'title': 'ज़कात किसको नहीं दी जा सकती?',
      'titleArabic': 'من لا يستحق الزكاة',
      'titleEnglish': 'Who Cannot Receive Zakat?',
      'contentHindi': '''इन लोगों को ज़कात देना जायज़ नहीं:

✗ अमीर लोगों को: जो खुद साहिब-ए-निसाब हों

✗ अपने उसूल को: माँ, बाप, दादा, दादी, नाना, नानी

✗ अपनी औलाद को: बेटा, बेटी, पोता, पोती

✗ मियाँ बीवी: शौहर बीवी को या बीवी शौहर को

✗ बनू हाशिम को: रसूलुल्लाह ﷺ की नस्ल (सदक़ा उनके लिए हराम)

✗ गैर मुस्लिम को: काफिर या मुश्रिक को

✗ मस्जिद की तामीर: ज़कात से मस्जिद नहीं बन सकती

ज़कात दे सकते हैं:
- भाई, बहन, चाचा, मामू, खाला, फुफी को (अगर ज़रूरतमंद हों)
- गरीब रिश्तेदारों को देना अफ़ज़ल है (दोगुना सवाब)''',
      'contentEnglish': '''These people cannot receive Zakat:

✗ Wealthy People: Those who possess nisab themselves

✗ Direct Ancestors: Parents, Grandparents

✗ Direct Descendants: Children, Grandchildren

✗ Spouses: Husband to wife or wife to husband

✗ Banu Hashim: Descendants of the Prophet ﷺ (Sadaqa is forbidden for them)

✗ Non-Muslims: Disbelievers or polytheists

✗ Building Mosques: Zakat cannot be used for mosque construction

Zakat Can Be Given To:
- Siblings, Uncles, Aunts (if they are in need)
- Giving to poor relatives is preferable (double reward)''',
      'contentUrdu': '''ان لوگوں کو زکات دینا جائز نہیں:

✗ امیر لوگوں کو: جو خود صاحب نصاب ہوں

✗ اپنے اصول کو: ماں، باپ، دادا، دادی، نانا، نانی

✗ اپنی اولاد کو: بیٹا، بیٹی، پوتا، پوتی

✗ میاں بیوی: شوہر بیوی کو یا بیوی شوہر کو

✗ بنو ہاشم کو: رسول اللہ ﷺ کی نسل (صدقہ ان کے لیے حرام)

✗ غیر مسلم کو: کافر یا مشرک کو

✗ مسجد کی تعمیر: زکات سے مسجد نہیں بن سکتی

زکات دے سکتے ہیں:
- بھائی، بہن، چاچا، ماموں، خالہ، پھوپھی کو (اگر ضرورت مند ہوں)
- غریب رشتہ داروں کو دینا افضل ہے (دوگنا ثواب)''',
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': 'किन चीज़ों पर ज़कात है?',
      'titleArabic': 'الأموال الزكوية',
      'titleEnglish': 'What is Zakat Due On?',
      'contentHindi': '''ज़कात वाजिब है:

💰 नक़दी (कैश): बैंक बैलेंस, कैश, सेविंग्स

🥇 सोना-चांदी: ज़ेवर, सिक्के, बार (पहना हुआ भी)

📈 इन्वेस्टमेंट: शेयर्स, म्यूचुअल फंड्स, बॉन्ड्स

🏪 तिजारत का माल: बिज़नेस इन्वेंट्री, स्टॉक

🌾 फ़सल: फसलें (उश्र - 10% या 5%)

🐪 मवेशी: जानवर (मखसूस निसाब)

ज़कात नहीं है:

🏠 रहने का घर
🚗 पर्सनल गाड़ी
👔 पहनने के कपड़े
📱 पर्सनल इस्तेमाल की चीज़ें
🛠️ काम के टूल्स/मशीनरी''',
      'contentEnglish': '''Zakat is Obligatory On:

💰 Cash: Bank balance, cash, savings

🥇 Gold & Silver: Jewelry, coins, bars (even if worn)

📈 Investments: Shares, mutual funds, bonds

🏪 Business Goods: Business inventory, stock

🌾 Crops: Agricultural produce (Ushr - 10% or 5%)

🐪 Livestock: Animals (specific nisab)

Zakat is Not Due On:

🏠 Personal residence
🚗 Personal vehicle
👔 Personal clothing
📱 Personal use items
🛠️ Work tools/machinery''',
      'contentUrdu': '''زکات واجب ہے:

💰 نقدی (کیش): بینک بیلنس، کیش، بچت

🥇 سونا چاندی: زیور، سکے، بار (پہنا ہوا بھی)

📈 سرمایہ کاری: شیئرز، میوچل فنڈز، بانڈز

🏪 تجارت کا مال: کاروباری ذخیرہ، اسٹاک

🌾 فصل: فصلیں (عشر - 10% یا 5%)

🐪 مویشی: جانور (مخصوص نصاب)

زکات نہیں ہے:

🏠 رہنے کا گھر
🚗 ذاتی گاڑی
👔 پہننے کے کپڑے
📱 ذاتی استعمال کی چیزیں
🛠️ کام کے اوزار/مشینری''',
    },
    {
      'icon': Icons.calculate,
      'title': 'ज़कात कैसे निकालें?',
      'titleArabic': 'كيفية حساب الزكاة',
      'titleEnglish': 'How to Calculate Zakat?',
      'contentHindi': '''स्टेप 1: अपने तमाम एसेट्स जमा करें
- कैश + बैंक बैलेंस
- सोने-चांदी की वैल्यू
- इन्वेस्टमेंट्स
- बिज़नेस स्टॉक

स्टेप 2: अपने क़र्ज़ माइनस करें
- लोन जो आप पर हैं
- बिल जो देने हैं

स्टेप 3: नेट वेल्थ निकालें
नेट वेल्थ = टोटल एसेट्स - टोटल लायबिलिटीज़

स्टेप 4: निसाब चेक करें
अगर नेट वेल्थ ≥ निसाब, तो ज़कात वाजिब है

स्टेप 5: 2.5% कैलकुलेट करें
ज़कात = नेट वेल्थ × 2.5%
या
ज़कात = नेट वेल्थ ÷ 40

उदाहरण:
टोटल एसेट्स: ₹5,00,000
क़र्ज़: ₹50,000
नेट वेल्थ: ₹4,50,000
ज़कात: ₹4,50,000 × 2.5% = ₹11,250''',
      'contentEnglish': '''Step 1: Add all your assets
- Cash + Bank Balance
- Value of Gold & Silver
- Investments
- Business stock

Step 2: Subtract your debts
- Loans you owe
- Bills due

Step 3: Calculate Net Wealth
Net Wealth = Total Assets - Total Liabilities

Step 4: Check Nisab
If Net Wealth ≥ Nisab, then Zakat is obligatory

Step 5: Calculate 2.5%
Zakat = Net Wealth × 2.5%
Or
Zakat = Net Wealth ÷ 40

Example:
Total Assets: ₹5,00,000
Debts: ₹50,000
Net Wealth: ₹4,50,000
Zakat: ₹4,50,000 × 2.5% = ₹11,250''',
      'contentUrdu': '''مرحلہ 1: اپنے تمام اثاثے جمع کریں
- کیش + بینک بیلنس
- سونے چاندی کی قیمت
- سرمایہ کاری
- کاروباری اسٹاک

مرحلہ 2: اپنے قرضے منہا کریں
- قرضے جو آپ پر ہیں
- بل جو دینے ہیں

مرحلہ 3: خالص دولت نکالیں
خالص دولت = کل اثاثے - کل ذمہ داریاں

مرحلہ 4: نصاب چیک کریں
اگر خالص دولت ≥ نصاب، تو زکات واجب ہے

مرحلہ 5: 2.5% حساب کریں
زکات = خالص دولت × 2.5%
یا
زکات = خالص دولت ÷ 40

مثال:
کل اثاثے: ₹5,00,000
قرض: ₹50,000
خالص دولت: ₹4,50,000
زکات: ₹4,50,000 × 2.5% = ₹11,250''',
    },
    {
      'icon': Icons.lightbulb,
      'title': 'अहम बातें',
      'titleArabic': 'نقاط مهمة',
      'titleEnglish': 'Important Points',
      'contentHindi': '''📅 ज़कात का वक़्त: साल पूरा होने पर। रमज़ान में देना अफ़ज़ल है।

🎯 नीयत ज़रूरी: ज़कात देते वक़्त दिल में नीयत होनी चाहिए।

🤫 छुपा कर देना: ज़कात छुपा कर देना बेहतर है (अगर फ़ितना न हो)।

💝 खुशी से देना: एहसान जताए बिना, खुशी से देना चाहिए।

🔄 हवाला जायज़: किसी और से दिलवा सकते हैं।

⏰ ताखीर न करें: वाजिब होने पर जल्दी अदा करें।

🎁 बता कर देना: लेने वाले को बताना ज़रूरी नहीं, लेकिन बता सकते हैं।

📊 रिकॉर्ड रखें: हिसाब किताब रखना बेहतर है।''',
      'contentEnglish': '''📅 Time for Zakat: After completing one year. Giving in Ramadan is preferable.

🎯 Intention Required: There must be intention in the heart when giving Zakat.

🤫 Give Secretly: It's better to give Zakat secretly (if no harm).

💝 Give Happily: Give happily without showing favor.

🔄 Through Agent: You can have someone else give on your behalf.

⏰ Don't Delay: Pay promptly when it becomes obligatory.

🎁 Informing Recipient: Not required to tell the recipient, but you can.

📊 Keep Records: It's better to keep accounts.''',
      'contentUrdu': '''📅 زکات کا وقت: سال پورا ہونے پر۔ رمضان میں دینا افضل ہے۔

🎯 نیت ضروری: زکات دیتے وقت دل میں نیت ہونی چاہیے۔

🤫 چھپا کر دینا: زکات چھپا کر دینا بہتر ہے (اگر فتنہ نہ ہو)۔

💝 خوشی سے دینا: احسان جتائے بغیر، خوشی سے دینا چاہیے۔

🔄 حوالہ جائز: کسی اور سے دلوا سکتے ہیں۔

⏰ تاخیر نہ کریں: واجب ہونے پر جلدی ادا کریں۔

🎁 بتا کر دینا: لینے والے کو بتانا ضروری نہیں، لیکن بتا سکتے ہیں۔

📊 ریکارڈ رکھیں: حساب کتاب رکھنا بہتر ہے۔''',
    },
  ];

  @override
  void initState() {
    super.initState();
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
          _playingSectionIndex = null;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingSectionIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playSection(int sectionIndex) async {
    if (_playingSectionIndex == sectionIndex && _isSpeaking) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    final section = _sections[sectionIndex];
    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    switch (_selectedLanguage) {
      case ZakatGuideLanguage.english:
        textToSpeak = section['contentEnglish'] ?? section['contentHindi'];
        ttsLangCode = 'en-US';
        break;
      case ZakatGuideLanguage.urdu:
        textToSpeak = section['contentUrdu'] ?? section['contentHindi'];
        ttsLangCode = await _getAvailableLanguage(['ur-PK', 'ur-IN', 'ur', 'hi-IN']);
        break;
      case ZakatGuideLanguage.hindi:
        textToSpeak = section['contentHindi'];
        ttsLangCode = await _getAvailableLanguage(['hi-IN', 'hi', 'en-IN', 'en-US']);
        break;
    }

    await _flutterTts.setLanguage(ttsLangCode);

    setState(() {
      _playingSectionIndex = sectionIndex;
      _isSpeaking = true;
    });

    await _flutterTts.speak(textToSpeak);
  }

  Future<String> _getAvailableLanguage(List<String> langCodes) async {
    for (final langCode in langCodes) {
      if (await _isLanguageAvailable(langCode)) {
        return langCode;
      }
    }
    return 'en-US'; // Fallback
  }

  Future<bool> _isLanguageAvailable(String langCode) async {
    try {
      final result = await _flutterTts.isLanguageAvailable(langCode);
      return result == 1 || result == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _stopPlaying() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _playingSectionIndex = null;
    });
  }

  void _copySection(int sectionIndex) {
    final section = _sections[sectionIndex];
    String content = '';

    switch (_selectedLanguage) {
      case ZakatGuideLanguage.english:
        content = '''${section['titleEnglish']}

${section['contentEnglish']}''';
        break;
      case ZakatGuideLanguage.urdu:
        content = '''${section['titleArabic']}

${section['contentUrdu']}''';
        break;
      case ZakatGuideLanguage.hindi:
        content = '''${section['title']}

${section['contentHindi']}''';
        break;
    }

    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _shareSection(int sectionIndex) {
    final section = _sections[sectionIndex];
    String content = '';

    switch (_selectedLanguage) {
      case ZakatGuideLanguage.english:
        content = '''${section['titleEnglish']}

${section['contentEnglish']}

- Shared from Jiyan Islamic Academy App''';
        break;
      case ZakatGuideLanguage.urdu:
        content = '''${section['titleArabic']}

${section['contentUrdu']}

- Shared from Jiyan Islamic Academy App''';
        break;
      case ZakatGuideLanguage.hindi:
        content = '''${section['title']}

${section['contentHindi']}

- Shared from Jiyan Islamic Academy App''';
        break;
    }

    Share.share(content);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Zakat Guide'),
        actions: [
          // Language selector
          PopupMenuButton<ZakatGuideLanguage>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                languageNames[_selectedLanguage]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onSelected: (ZakatGuideLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => ZakatGuideLanguage.values.map((language) {
              final isSelected = _selectedLanguage == language;
              return PopupMenuItem<ZakatGuideLanguage>(
                value: language,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(
                      languageNames[language]!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(isDark),
            const SizedBox(height: 24),

            // Sections
            ...List.generate(_sections.length, (index) {
              return Column(
                children: [
                  _buildSection(
                    isDark: isDark,
                    sectionIndex: index,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),

            // Hadith about Zakat
            _buildHadithCard(isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'الزَّكَاةُ',
            style: TextStyle(
              fontSize: 48,
              fontFamily: 'Amiri',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ZAKAT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedLanguage == ZakatGuideLanguage.english
                ? 'The Third Pillar of Islam'
                : _selectedLanguage == ZakatGuideLanguage.urdu
                    ? 'اسلام کا تیسرا رکن'
                    : 'इस्लाम का तीसरा रुक्न',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '2.5% = 1/40 of Wealth',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required bool isDark,
    required int sectionIndex,
  }) {
    final section = _sections[sectionIndex];
    final isPlaying = _playingSectionIndex == sectionIndex && _isSpeaking;

    String title = section['title'];
    String titleArabic = section['titleArabic'];
    String content = section['contentHindi'];

    switch (_selectedLanguage) {
      case ZakatGuideLanguage.english:
        title = section['titleEnglish'];
        content = section['contentEnglish'];
        break;
      case ZakatGuideLanguage.urdu:
        title = section['titleArabic'];
        content = section['contentUrdu'];
        break;
      case ZakatGuideLanguage.hindi:
        break;
    }

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPlaying
              ? AppColors.primary
              : (isDark ? Colors.grey.shade700 : lightGreenBorder),
          width: isPlaying ? 2 : 1.5,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade800
                  : const Color(0xFFE8F3ED),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(section['icon'], color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          if (_selectedLanguage != ZakatGuideLanguage.urdu)
                            Text(
                              titleArabic,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Amiri',
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Action buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying ? 'Stop' : 'Audio',
                      onTap: () => _playSection(sectionIndex),
                      isActive: isPlaying,
                    ),
                    _buildActionButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      onTap: () => _copySection(sectionIndex),
                      isActive: false,
                    ),
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () => _shareSection(sectionIndex),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content.trim(),
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              textDirection: _selectedLanguage == ZakatGuideLanguage.urdu
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? emeraldGreen : lightGreenChip,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : darkGreen,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? Colors.white : darkGreen,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(bool isDark) {
    String hadithTranslation = '"सदक़ा (ज़कात) से माल कम नहीं होता"';
    if (_selectedLanguage == ZakatGuideLanguage.english) {
      hadithTranslation = '"Charity (Zakat) does not decrease wealth"';
    } else if (_selectedLanguage == ZakatGuideLanguage.urdu) {
      hadithTranslation = '"صدقہ (زکات) سے مال کم نہیں ہوتا"';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text(
            'مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Amiri',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            hadithTranslation,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.95),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
            textDirection: _selectedLanguage == ZakatGuideLanguage.urdu
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
          const SizedBox(height: 8),
          Text(
            '— Sahih Muslim',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
