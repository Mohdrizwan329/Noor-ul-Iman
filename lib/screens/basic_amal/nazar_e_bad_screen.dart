import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NazarEBadScreen extends StatefulWidget {
  const NazarEBadScreen({super.key});

  @override
  State<NazarEBadScreen> createState() => _NazarEBadScreenState();
}

class _NazarEBadScreenState extends State<NazarEBadScreen> {
  String _selectedLanguage = 'english';

  final List<Map<String, dynamic>> _sections = [
    {
      'titleKey': 'nazar_e_bad_1_prevention_methods',
      'title': 'Prevention Methods',
      'titleUrdu': 'بچاؤ کے طریقے',
      'titleHindi': 'बचाव के तरीक़े',
      'titleArabic': 'طرق الوقاية من العين',
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
        'arabic': '''طرق الوقاية من العين (الحسد)

العين حق، والوقاية منها واجب على كل مسلم.

الحديث:
قال النبي ﷺ: "العين حق، ولو كان شيء سابق القدر سبقته العين" (صحيح مسلم)

طرق الوقاية:

١. قول "ما شاء الله" (ما شاء الله):
• عند رؤية أي شيء جميل
• عند رؤية النعم في الآخرين
• عند النظر إلى نعمك الخاصة
• قل: "ما شاء الله، لا قوة إلا بالله"

٢. أذكار الصباح والمساء:
• اقرأ آية الكرسي
• اقرأ سورة الفلق (3 مرات)
• اقرأ سورة الناس (3 مرات)
• اقرأ سورة الإخلاص (3 مرات)

٣. قبل الخروج من المنزل:
قل: "بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
"بسم الله، توكلت على الله، لا حول ولا قوة إلا بالله"

٤. دعاء الحماية:
"أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ"
"أعوذ بكلمات الله التامات من شر ما خلق"

٥. للأطفال:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
(كان النبي ﷺ يعوذ الحسن والحسين بهذا)

٦. إخفاء النعم:
• لا تتفاخر بالنعم
• احمد الله سراً
• لا تنشر كل شيء على وسائل التواصل

٧. الصدقة:
• الصدقة تدفع البلاء
• تصدق بانتظام

٨. المحافظة على الصلوات:
• الصلاة حصن من الشرور
• صلِّ الفجر والعصر في جماعة

٩. قراءة القرآن في البيت:
• اقرأ سورة البقرة في البيت
• لا يدخله الشيطان 3 أيام

١٠. الوضوء الدائم:
• كن على وضوء دائماً
• الملائكة تحيط بالمتوضئ'''
      },
    },
    {
      'titleKey': 'nazar_e_bad_2_ruqyah_for_evil_eye',
      'title': 'Ruqyah for Evil Eye',
      'titleUrdu': 'نظر بد کا دم',
      'titleHindi': 'नज़र-ए-बद का दम',
      'titleArabic': 'الرقية الشرعية للعين',
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
        'arabic': '''الرقية الشرعية للعين (الحسد)

الطريقة الأولى - الرقية الذاتية:

١. اقرأ بنية الشفاء:
   • سورة الفاتحة (7 مرات)
   • آية الكرسي (7 مرات)
   • سورة الإخلاص (3 مرات)
   • سورة الفلق (3 مرات)
   • سورة الناس (3 مرات)

٢. انفث بلطف على راحتيك بعد كل سورة

٣. امسح بيديك على المكان المصاب أو على الجسم كاملاً

الطريقة الثانية - الرقية على الماء:

١. اقرأ على الماء:
   • سورة الفاتحة
   • آية الكرسي
   • آخر آيتين من سورة البقرة
   • سورة الإخلاص والفلق والناس

٢. انفث في الماء

٣. اشرب بعضه واغتسل بالباقي

الطريقة الثالثة - بزيت الزيتون:

١. اقرأ القرآن على زيت زيتون نقي
٢. ادهن الجسم بالزيت
٣. استخدمه بانتظام

دعاء الشفاء:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا"
"اللهم رب الناس أذهب البأس، اشفه وأنت الشافي، لا شفاء إلا شفاؤك، شفاءً لا يغادر سقماً"

نقاط مهمة:
• احرص على اليقين الكامل بقدرة الله على الشفاء
• كن مستمراً في الرقية
• يمكن إجراء الرقية على النفس أو الآخرين
• لا يوجد عدد محدد - كرر حسب الحاجة''',
      },
    },
    {
      'titleKey': 'nazar_e_bad_3_signs_of_evil_eye',
      'title': 'Signs of Evil Eye',
      'titleUrdu': 'نظر بد کی علامات',
      'titleHindi': 'नज़र-ए-बद की अलामात',
      'titleArabic': 'علامات العين',
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
        'arabic': '''علامات العين (الحسد)

العلامات الجسدية:
• مرض مفاجئ بدون سبب واضح
• تعب وضعف بدون سبب
• صداع مستمر
• فقدان الشهية
• اصفرار أو شحوب في الوجه
• آلام مفاجئة في أجزاء من الجسم

العلامات النفسية/العاطفية:
• اكتئاب أو قلق بدون سبب
• غضب وتهيج
• كوابيس واضطراب في النوم
• خوف وقلق دائم
• فقدان الاهتمام بالأنشطة
• الشعور بعدم الراحة في المنزل

علامات في الحياة/المال:
• مشاكل مالية مفاجئة
• فشل في العمل بدون تفسير
• مشاكل في العلاقات
• عقبات في الدراسة أو المهنة
• فقدان النعم الموجودة

علامات عند الأطفال:
• بكاء مستمر بدون سبب
• اضطراب في النوم
• فقدان الشهية
• المرض المتكرر
• تغيرات في السلوك

ملاحظات مهمة:
• قد تكون لهذه العلامات أسباب طبيعية أيضاً
• اطلب المساعدة الطبية إلى جانب العلاج الروحاني
• لا تفترض أن كل شيء هو عين
• توكل على الله واطلب حمايته
• لا تكن مصاباً بالوسواس أو تشك في الجميع

قال النبي ﷺ: "ما أنزل الله داء إلا أنزل له شفاء." (صحيح البخاري)''',
      },
    },
    {
      'titleKey': 'nazar_e_bad_4_protective_duas',
      'title': 'Protective Duas',
      'titleUrdu': 'حفاظتی دعائیں',
      'titleHindi': 'हिफ़ाज़ती दुआएं',
      'titleArabic': 'أدعية الحماية',
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
        'arabic': '''الأدعية والأذكار الواقية من العين

١. حماية الصباح والمساء:
"بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ"
(تُقرأ 3 مرات صباحاً ومساءً)
"بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم"

٢. آية الكرسي (2:255):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."
تُقرأ بعد كل صلاة وقبل النوم.

٣. المعوذات الثلاث:
• سورة الإخلاص (112)
• سورة الفلق (113)
• سورة الناس (114)
تُقرأ 3 مرات صباحاً ومساءً.

٤. آخر آيتين من سورة البقرة:
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ..."
تُقرأ كل ليلة قبل النوم.

٥. عند رؤية شيء يُعجب:
"مَا شَاءَ اللَّهُ لَا قُوَّةَ إِلَّا بِاللَّهِ"
"ما شاء الله، لا قوة إلا بالله"

٦. دعاء الخروج من المنزل:
"بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَ��هِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
"بسم الله، توكلت على الله، لا حول ولا قوة إلا بالله"

٧. للأطفال قبل النوم:
"أُعِيذُكَ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"
"أعيذك بكلمات الله التامة من كل شيطان وهامة ومن كل عين لامة"

٨. للحماية العامة:
"أَعُوذُ بِاللَّهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ"
"أعوذ بالله السميع العليم من الشيطان الرجيم"''',
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
          context.tr('nazar_e_bad'),
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.responsive.paddingRegular,
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

  Widget _buildCard(Map<String, dynamic> item, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(item['titleKey'] ?? 'nazar_e_bad');
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
return Container(
      margin: responsive.paddingOnly(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showDetails(item),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${item['number']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Title and Icon chip
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                      ),
                      textDirection: langCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Icon chip
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          SizedBox(width: responsive.spacing(4)),
                          Text(
                            context.tr('nazar'),
                            style: TextStyle(
                              fontSize: responsive.textXSmall,
                              fontWeight: FontWeight.w600,
                              color: emeraldGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E8F5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.textXSmall + 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(Map<String, dynamic> item) {
    final details = item['details'] as Map<String, String>;
    final titleKey = item['titleKey'] ?? 'nazar_e_bad';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: item['title'] ?? '',
          titleUrdu: item['titleUrdu'] ?? '',
          titleHindi: item['titleHindi'] ?? '',
          titleArabic: item['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: item['color'] as Color,
          icon: item['icon'] as IconData,
          categoryKey: 'category_nazar',
        ),
      ),
    );
  }
}
