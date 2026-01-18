import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NazarEBadScreen extends StatefulWidget {
  const NazarEBadScreen({super.key});

  @override
  State<NazarEBadScreen> createState() => _NazarEBadScreenState();
}

class _NazarEBadScreenState extends State<NazarEBadScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Protection from Evil Eye',
    'urdu': 'نظر بد سے حفاظت',
    'hindi': 'नज़र-ए-बद से हिफ़ाज़त',
  };

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Prevention Methods',
      'titleUrdu': 'بچاؤ کے طریقے',
      'titleHindi': 'बचाव के तरीक़े',
      'icon': Icons.shield,
      'color': Colors.blue,
      'details': {
        'english': '''Prevention from Evil Eye

1. Say "MashaAllah" (ما شاء الله):
   • When admiring anything beautiful
   • When seeing blessings in others
   • When looking at your own blessings
   • Say: "MashaAllah, La Quwwata illa Billah"

2. Morning & Evening Adhkar:
   • Recite Ayatul Kursi
   • Recite Surah Al-Falaq (3 times)
   • Recite Surah An-Naas (3 times)
   • Recite Surah Al-Ikhlas (3 times)

3. Before Leaving Home:
   • Say: "Bismillah, Tawakkaltu alallah, La hawla wa la quwwata illa billah"
   • "In the name of Allah, I place my trust in Allah, there is no power or strength except with Allah"

4. Dua for Protection:
"أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ"
"A'udhu bikalimatillahit-tammati min sharri ma khalaq"
"I seek refuge in the perfect words of Allah from the evil of what He has created"

5. For Children:
The Prophet ﷺ used to seek refuge for Hasan and Husain:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"I seek refuge for you both in the perfect words of Allah from every devil, every poisonous creature, and every evil eye"

6. Don't Show Off:
   • Avoid displaying blessings excessively
   • Be humble about achievements
   • Thank Allah quietly''',
        'urdu': '''نظر بد سے بچاؤ

۱۔ "ماشاءاللہ" کہیں:
   • کسی خوبصورت چیز کی تعریف کرتے وقت
   • دوسروں میں نعمتیں دیکھتے وقت
   • اپنی نعمتیں دیکھتے وقت
   • کہیں: "ماشاءاللہ، لا قوۃ الا باللہ"

۲۔ صبح و شام کے اذکار:
   • آیت الکرسی پڑھیں
   • سورۃ الفلق پڑھیں (3 بار)
   • سورۃ الناس پڑھیں (3 بار)
   • سورۃ الاخلاص پڑھیں (3 بار)

۳۔ گھر سے نکلنے سے پہلے:
   • کہیں: "بسم اللہ، توکلت علی اللہ، لا حول ولا قوۃ الا باللہ"
   • "اللہ کے نام سے، میں نے اللہ پر بھروسہ کیا، اللہ کے سوا کوئی طاقت و قوت نہیں"

۴۔ حفاظت کی دعا:
"أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ"
"میں اللہ کے مکمل کلمات کی پناہ میں آتا ہوں اس کی مخلوق کے شر سے"

۵۔ بچوں کے لیے:
نبی کریم ﷺ حسن اور حسین کے لیے پناہ مانگتے تھے:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"میں تم دونوں کو اللہ کے کامل کلمات کی پناہ میں دیتا ہوں ہر شیطان، ہر زہریلے جانور اور ہر بری نظر سے"

۶۔ دکھاوا نہ کریں:
   • نعمتوں کا بے جا اظہار نہ کریں
   • کامیابیوں پر عاجزی رکھیں
   • خاموشی سے اللہ کا شکر ادا کریں''',
        'hindi': '''नज़र-ए-बद से बचाव

१. "माशाअल्लाह" कहें:
   • किसी ख़ूबसूरत चीज़ की तारीफ़ करते वक़्त
   • दूसरों में नेमतें देखते वक़्त
   • अपनी नेमतें देखते वक़्त
   • कहें: "माशाअल्लाह, ला क़ुव्वता इल्ला बिल्लाह"

२. सुबह व शाम के अज़कार:
   • आयतुल कुर्सी पढ़ें
   • सूरह अल-फ़लक़ पढ़ें (3 बार)
   • सूरह अन-नास पढ़ें (3 बार)
   • सूरह अल-इख़्लास पढ़ें (3 बार)

३. घर से निकलने से पहले:
   • कहें: "बिस्मिल्लाह, तवक्कलतु अलल्लाह, ला हौला वला क़ुव्वता इल्ला बिल्लाह"
   • "अल्लाह के नाम से, मैंने अल्लाह पर भरोसा किया, अल्लाह के सिवा कोई ताक़त व क़ुव्वत नहीं"

४. हिफ़ाज़त की दुआ:
"أَع��وذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ"
"मैं अल्लाह के मुकम्मल कलिमात की पनाह में आता हूं उसकी मख़्लूक़ के शर से"

५. बच्चों के लिए:
नबी करीम ﷺ हसन और हुसैन के लिए पनाह मांगते थे:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"मैं तुम दोनों को अल्लाह के कामिल कलिमात की पनाह में देता हूं हर शैतान, हर ज़हरीले जानवर और हर बुरी नज़र से"

६. दिखावा न करें:
   • नेमतों का बेजा इज़हार न करें
   • कामयाबियों पर आजिज़ी रखें
   • ख़ामोशी से अल्लाह का शुक्र अदा करें''',
      },
    },
    {
      'title': 'Ruqyah for Evil Eye',
      'titleUrdu': 'نظر بد کا دم',
      'titleHindi': 'नज़र-ए-बद का दम',
      'icon': Icons.healing,
      'color': Colors.green,
      'details': {
        'english': '''Ruqyah (Islamic Cure) for Evil Eye

Method 1 - Self Ruqyah:

1. Recite with intention of healing:
   • Surah Al-Fatiha (7 times)
   • Ayatul Kursi (7 times)
   • Surah Al-Ikhlas (3 times)
   • Surah Al-Falaq (3 times)
   • Surah An-Naas (3 times)

2. Blow gently on palms after each Surah

3. Wipe hands over the affected area or entire body

Method 2 - Water Ruqyah:

1. Recite over water:
   • Surah Al-Fatiha
   • Ayatul Kursi
   • Last two verses of Surah Al-Baqarah
   • Surah Al-Ikhlas, Al-Falaq, An-Naas

2. Blow into the water

3. Drink some and bathe with the rest

Method 3 - With Olive Oil:

1. Recite Quran over pure olive oil
2. Apply the oil to the body
3. Use regularly

Dua for Healing:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا"
"O Allah, Lord of mankind, remove the hardship. Heal, for You are the Healer. There is no healing except Your healing, a healing that leaves no sickness behind."

Important Notes:
• Have firm belief in Allah's power to heal
• Be consistent in Ruqyah
• Ruqyah can be done on oneself or others
• There is no set number - repeat as needed''',
        'urdu': '''نظر بد کا دم (رقیہ)

پہلا طریقہ - خود پر دم:

۱۔ شفا کی نیت سے پڑھیں:
   • سورۃ الفاتحہ (7 بار)
   • آیت الکرسی (7 بار)
   • سورۃ الاخلاص (3 بار)
   • سورۃ الفلق (3 بار)
   • سورۃ الناس (3 بار)

۲۔ ہر سورہ کے بعد ہتھیلیوں پر آہستہ پھونکیں

۳۔ ہاتھ متاثرہ جگہ یا پورے جسم پر پھیریں

دوسرا طریقہ - پانی پر دم:

۱۔ پانی پر پڑھیں:
   • سورۃ الفاتحہ
   • آیت الکرسی
   • سورۃ البقرہ کی آخری دو آیات
   • سورۃ الاخلاص، الفلق، الناس

۲۔ پانی میں پھونکیں

۳۔ کچھ پئیں اور باقی سے نہائیں

تیسرا طریقہ - زیتون کے تیل سے:

۱۔ خالص زیتون کے تیل پر قرآن پڑھیں
۲۔ تیل جسم پر لگائیں
۳۔ باقاعدگی سے استعمال کریں

شفا کی دعا:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا"
"اے اللہ، لوگوں کے رب، تکلیف دور کر۔ شفا دے، تو ہی شفا دینے والا ہے۔ تیری شفا کے سوا کوئی شفا نہیں، ایسی شفا جو کوئی بیماری نہ چھوڑے۔"

اہم نکات:
• اللہ کی شفا دینے کی قدرت پر پختہ یقین رکھیں
• دم میں مستقل مزاجی رکھیں
• دم خود پر یا دوسروں پر کیا جا سکتا ہے
• کوئی مقررہ تعداد نہیں - ضرورت کے مطابق دہرائیں''',
        'hindi': '''नज़र-ए-बद का दम (रुक़्या)

पहला तरीक़ा - ख़ुद पर दम:

१. शिफ़ा की नीयत से पढ़ें:
   • सूरह अल-फ़ातिहा (7 बार)
   • आयतुल कुर्सी (7 बार)
   • सूरह अल-इख़्लास (3 बार)
   • सूरह अल-फ़लक़ (3 बार)
   • सूरह अन-नास (3 बार)

२. हर सूरह के बाद हथेलियों पर आहिस्ता फूंकें

३. हाथ मुतास्सिर जगह या पूरे जिस्म पर फेरें

दूसरा तरीक़ा - पानी पर दम:

१. पानी पर पढ़ें:
   • सूरह अल-फ़ातिहा
   • आयतुल कुर्सी
   • सूरह अल-बक़रा की आख़िरी दो आयात
   • सूरह अल-इख़्लास, अल-फ़लक़, अन-नास

२. पानी में फूंकें

३. कुछ पिएं और बाक़ी से नहाएं

तीसरा तरीक़ा - ज़ैतून के तेल से:

१. ख़ालिस ज़ैतून के तेल पर क़ुरआन पढ़ें
२. तेल जिस्म पर लगाएं
३. बाक़ायदगी से इस्तेमाल करें

शिफ़ा की दुआ:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا"
"ऐ अल्लाह, लोगों के रब, तकलीफ़ दूर कर। शिफ़ा दे, तू ही शिफ़ा देने वाला है। तेरी शिफ़ा के सिवा कोई शिफ़ा नहीं, ऐसी शिफ़ा जो कोई बीमारी न छोड़े।"

अहम बातें:
• अल्लाह की शिफ़ा देने की क़ुदरत पर पुख़्ता यक़ीन रखें
• दम में मुस्तक़िल मिज़ाजी रखें
• दम ख़ुद पर या दूसरों पर किया जा सकता है
• कोई मुक़र्रर तादाद नहीं - ज़रूरत के मुताबिक़ दोहराएं''',
      },
    },
    {
      'title': 'Signs of Evil Eye',
      'titleUrdu': 'نظر بد کی علامات',
      'titleHindi': 'नज़र-ए-बद की अलामात',
      'icon': Icons.visibility,
      'color': Colors.orange,
      'details': {
        'english': '''Signs of Evil Eye

Physical Signs:
• Sudden unexplained illness
• Fatigue and weakness without cause
• Persistent headaches
• Loss of appetite
• Pale or yellowish complexion
• Sudden pain in body parts

Emotional/Mental Signs:
• Depression or anxiety without reason
• Anger and irritability
• Nightmares and disturbed sleep
• Fear and restlessness
• Loss of interest in activities
• Feeling uncomfortable in one's own home

Signs in Life/Wealth:
• Sudden financial problems
• Business failures without explanation
• Relationship problems
• Academic or career setbacks
• Loss of blessings that were present

Signs in Children:
• Constant crying without reason
• Not sleeping well
• Loss of appetite
• Falling sick frequently
• Behavioral changes

Important Notes:
• These signs can also have natural causes
• Seek medical help alongside spiritual remedies
• Don't assume everything is evil eye
• Trust in Allah and seek His protection
• Don't become paranoid or suspicious of everyone

The Prophet ﷺ said: "There is no disease that Allah has created, except that He also has created its treatment." (Sahih Bukhari)''',
        'urdu': '''نظر بد کی علامات

جسمانی علامات:
• اچانک بلا وجہ بیماری
• بغیر وجہ تھکاوٹ اور کمزوری
• مسلسل سر درد
• بھوک کم ہونا
• پیلا یا زردی مائل رنگ
• جسم کے حصوں میں اچانک درد

جذباتی/ذہنی علامات:
• بلا وجہ ڈپریشن یا پریشانی
• غصہ اور چڑچڑاپن
• ڈراؤنے خواب اور نیند میں خلل
• خوف اور بے چینی
• کاموں میں دلچسپی ختم
• اپنے گھر میں بے چینی محسوس کرنا

زندگی/دولت میں علامات:
• اچانک مالی مشکلات
• بلا وجہ کاروبار میں نقصان
• رشتوں میں مسائل
• تعلیم یا کیریئر میں رکاوٹ
• موجود نعمتوں کا چھن جانا

بچوں میں علامات:
• بلا وجہ مسلسل رونا
• نیند نہ آنا
• بھوک کم ہونا
• بار بار بیمار ہونا
• رویے میں تبدیلی

اہم نکات:
• ان علامات کی قدرتی وجوہات بھی ہو سکتی ہیں
• روحانی علاج کے ساتھ طبی مدد بھی لیں
• ہر چیز کو نظر بد نہ سمجھیں
• اللہ پر بھروسہ رکھیں اور اس کی پناہ مانگیں
• پاگل پن یا ہر کسی پر شک نہ کریں

نبی کریم ﷺ نے فرمایا: "اللہ نے کوئی بیماری نہیں بنائی مگر اس کا علاج بھی بنایا ہے۔" (صحیح بخاری)''',
        'hindi': '''नज़र-ए-बद की अलामात

जिस्मानी अलामात:
• अचानक बिला वजह बीमारी
• बग़ैर वजह थकावट और कमज़ोरी
• मुसलसल सर दर्द
• भूख कम होना
• पीला या ज़र्दी माइल रंग
• जिस्म के हिस्सों में अचानक दर्द

जज़्बाती/ज़ेहनी अलामात:
• बिला वजह डिप्रेशन या परेशानी
• ग़ुस्सा और चिड़चिड़ापन
• डरावने ख़्वाब और नींद में ख़लल
• ख़ौफ़ और बेचैनी
• कामों में दिलचस्पी ख़त्म
• अपने घर में बेचैनी महसूस करना

ज़िंदगी/दौलत में अलामात:
• अचानक माली मुश्किलात
• बिला वजह कारोबार में नुक़सान
• रिश्तों में मसाइल
• तालीम या करियर में रुकावट
• मौजूद नेमतों का छिन जाना

बच्चों में अलामात:
• बिला वजह मुसलसल रोना
• नींद न आना
• भूख कम होना
• बार-बार बीमार होना
• रवय्ये में तब्दीली

अहम बातें:
• इन अलामात की क़ुदरती वुजूहात भी हो सकती हैं
• रूहानी इलाज के साथ तिब्बी मदद भी लें
• हर चीज़ को नज़र-ए-बद न समझें
• अल्लाह पर भरोसा रखें और उसकी पनाह मांगें
• पागलपन या हर किसी पर शक न करें

नबी करीम ﷺ ने फ़रमाया: "अल्लाह ने कोई बीमारी नहीं बनाई मगर उसका इलाज भी बनाया है।" (सहीह बुख़ारी)''',
      },
    },
    {
      'title': 'Protective Duas',
      'titleUrdu': 'حفاظتی دعائیں',
      'titleHindi': 'हिफ़ाज़ती दुआएं',
      'icon': Icons.menu_book,
      'color': Colors.purple,
      'details': {
        'english': '''Protective Duas and Adhkar

1. Morning & Evening Protection:
"بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ"
(Recite 3 times morning and evening)
"In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, All-Knowing."

2. Ayatul Kursi (2:255):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."
Recite after every prayer and before sleep.

3. The Three Quls:
• Surah Al-Ikhlas (112)
• Surah Al-Falaq (113)
• Surah An-Naas (114)
Recite 3 times morning and evening.

4. Last Two Verses of Surah Al-Baqarah:
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ..."
Recite every night before sleep.

5. When Seeing Something Admirable:
"مَا شَاءَ اللَّهُ لَا قُوَّةَ إِلَّا بِاللَّهِ"
"What Allah willed! There is no power except with Allah."

6. Dua When Leaving Home:
"بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
"In the name of Allah, I place my trust in Allah, there is no power or strength except with Allah."

7. For Children Before Sleep:
"أُعِيذُكَ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"I seek refuge for you in the perfect words of Allah from every devil, every poisonous creature, and every evil eye."

8. General Protection:
"أَعُوذُ بِاللَّهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ"
"I seek refuge in Allah, the All-Hearing, All-Knowing, from the accursed Satan."''',
        'urdu': '''حفاظتی دعائیں اور اذکار

۱۔ صبح و شام کی حفاظت:
"بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ"
(صبح و شام 3 بار پڑھیں)
"اللہ کے نام سے، جس کے نام کے ساتھ زمین یا آسمان میں کوئی چیز نقصان نہیں پہنچا سکتی، اور وہ سننے والا، جاننے والا ہے۔"

۲۔ آیت الکرسی (2:255):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."
ہر نماز کے بعد اور سونے سے پہلے پڑھیں۔

۳۔ تین قل:
• سورۃ الاخلاص (112)
• سورۃ الفلق (113)
• سورۃ الناس (114)
صبح و شام 3 بار پڑھیں۔

۴۔ سورۃ البقرہ کی آخری دو آیات:
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ..."
ہر رات سونے سے پہلے پڑھیں۔

۵۔ کوئی قابل تعریف چیز دیکھتے وقت:
"مَا شَاءَ اللَّهُ لَا قُوَّةَ إِلَّا بِاللَّهِ"
"جو اللہ نے چاہا! اللہ کے سوا کوئی طاقت نہیں۔"

۶۔ گھر سے نکلتے وقت دعا:
"بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
"اللہ کے نام سے، میں نے اللہ پر بھروسہ کیا، اللہ کے سوا کوئی طاقت و قوت نہیں۔"

۷۔ بچوں کے لیے سونے سے پہلے:
"أُعِيذُكَ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"میں تمہیں اللہ کے کامل کلمات کی پناہ میں دیتا ہوں ہر شیطان، ہر زہریلے جانور اور ہر بری نظر سے۔"

۸۔ عمومی حفاظت:
"أَعُوذُ بِاللَّهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ"
"میں اللہ سننے والے جاننے والے کی پناہ مانگتا ہوں شیطان مردود سے۔"''',
        'hindi': '''हिफ़ाज़ती दुआएं और अज़कार

१. सुबह व शाम की हिफ़ाज़त:
"بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ"
(सुबह व शाम 3 बार पढ़ें)
"अल्लाह के नाम से, जिसके नाम के साथ ज़मीन या आसमान में कोई चीज़ नुक़सान नहीं पहुंचा सकती, और वो सुनने वाला, जानने वाला है।"

२. आयतुल कुर्सी (2:255):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."
हर नमाज़ के बाद और सोने से पहले पढ़ें।

३. तीन क़ुल:
• सूरह अल-इख़्लास (112)
• सूरह अल-फ़लक़ (113)
• सूरह अन-नास (114)
सुबह व शाम 3 बार पढ़ें।

४. सूरह अल-बक़रा की आख़िरी दो आयात:
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ..."
हर रात सोने से पहले पढ़ें।

५. कोई क़ाबिल-ए-तारीफ़ चीज़ देखते वक़्त:
"مَا شَاءَ اللَّهُ لَا قُوَّةَ إِلَّا بِاللَّهِ"
"जो अल्लाह ने चाहा! अल्लाह के सिवा कोई ताक़त नहीं।"

६. घर से निकलते वक़्त दुआ:
"بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
"अल्लाह के नाम से, मैंने अल्लाह पर भरोसा किया, अल्लाह के सिवा कोई ताक़त व क़ुव्वत नहीं।"

७. बच्चों के लिए सोने से पहले:
"أُعِيذُكَ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"मैं तुम्हें अल्लाह के कामिल कलिमात की पनाह में देता हूं हर शैतान, हर ज़हरीले जानवर और हर बुरी नज़र से।"

८. उमूमी हिफ़ाज़त:
"أَعُوذُ بِاللَّهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ"
"मैं अल्लाह सुनने वाले जानने वाले की पनाह मांगता हूं शैतान मरदूद से।"''',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F9F7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _titles[_selectedLanguage]!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      _selectedLanguage == 'english'
                          ? 'EN'
                          : _selectedLanguage == 'urdu'
                          ? 'UR'
                          : 'HI',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onSelected: (value) => setState(() => _selectedLanguage = value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'english',
                  child: Row(
                    children: [
                      Icon(
                        _selectedLanguage == 'english'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _selectedLanguage == 'english'
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('English'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'urdu',
                  child: Row(
                    children: [
                      Icon(
                        _selectedLanguage == 'urdu'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _selectedLanguage == 'urdu'
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('اردو'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'hindi',
                  child: Row(
                    children: [
                      Icon(
                        _selectedLanguage == 'hindi'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _selectedLanguage == 'hindi'
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('हिंदी'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sections.length,
              itemBuilder: (context, index) => _buildCard(
                _sections[index],
                isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    Map<String, dynamic> item,
    bool isDark,
  ) {
    final title = _selectedLanguage == 'english'
        ? item['title']
        : _selectedLanguage == 'urdu'
        ? item['titleUrdu']
        : item['titleHindi'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetails(item),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.lightGreenBorder.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E8F5A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(Map<String, dynamic> item) {
    final details = item['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: item['title'],
          titleUrdu: item['titleUrdu'] ?? '',
          titleHindi: item['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: item['color'] as Color,
          icon: item['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Nazar-e-Bad',
        ),
      ),
    );
  }
}
