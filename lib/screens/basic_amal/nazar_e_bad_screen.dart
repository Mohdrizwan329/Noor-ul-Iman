import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NazarEBadScreen extends StatefulWidget {
  const NazarEBadScreen({super.key});

  @override
  State<NazarEBadScreen> createState() => _NazarEBadScreenState();
}

class _NazarEBadScreenState extends State<NazarEBadScreen> {
  final List<Map<String, dynamic>> _sections = [
    {
      'number': 1,
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
      'number': 2,
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
      'number': 3,
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
      'number': 4,
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
    {
      'number': 5,
      'titleKey': 'nazar_e_bad_5_hadith_references',
      'title': 'Hadith About Evil Eye',
      'titleUrdu': 'نظر بد کے بارے میں احادیث',
      'titleHindi': 'नज़र-ए-बद के बारे में हदीसें',
      'titleArabic': 'أحاديث عن العين',
      'icon': Icons.book,
      'color': Colors.teal,
      'details': {
        'english': '''Authentic Hadith About Evil Eye

1. The Prophet ﷺ said:
"The evil eye is real, and if anything were to overtake the divine decree, it would be the evil eye."
(Sahih Muslim 2188)

2. The Prophet ﷺ said:
"The influence of an evil eye is a fact. If anything would precede the destiny, it would be the influence of an evil eye."
(Sahih Muslim)

3. Abu Hurairah (RA) reported:
The Prophet ﷺ said: "The evil eye is real and he commanded that one should take a bath because of it."
(Sunan Abu Dawud)

4. The Prophet ﷺ said:
"Most of those who die among my Ummah die because of the evil eye."
(Sahih Bukhari)

5. Asma bint Umais (RA) said:
"O Messenger of Allah, the children of Ja'far have been afflicted by the evil eye, shall we recite something for them?"
He said: "Yes, for if anything were to overtake the divine decree, it would be the evil eye."
(Jami at-Tirmidhi 2059)

6. The Prophet ﷺ said:
"When you see something you like, say: 'Ma sha Allah, la quwwata illa billah' (What Allah wills! There is no power except with Allah)."

Important Points:
• Evil eye is real and confirmed by authentic Hadith
• It can affect health, wealth, and life
• Protection through Quran and Dua is essential
• Saying MashaAllah prevents giving evil eye
• Seeking Allah's protection is the best remedy''',
        'urdu': '''نظر بد کے بارے میں صحیح احادیث

۱۔ نبی کریم ﷺ نے فرمایا:
"نظر بد حق ہے، اور اگر کوئی چیز تقدیر سے آگے نکل سکتی تو وہ نظر بد ہوتی۔"
(صحیح مسلم 2188)

۲۔ نبی کریم ﷺ نے فرمایا:
"نظر بد کا اثر حقیقت ہے۔ اگر کوئی چیز تقدیر سے پہلے آ سکتی تو وہ نظر بد کا اثر ہوتا۔"
(صحیح مسلم)

۳۔ ابو ہریرہ رضی اللہ عنہ سے روایت ہے:
نبی کریم ﷺ نے فرمایا: "نظر بد حق ہے اور آپ ﷺ نے حکم دیا کہ اس کی وجہ سے غسل کیا جائے۔"
(سنن ابو داؤد)

۴۔ نبی کریم ﷺ نے فرمایا:
"میری امت میں سے اکثر لوگ نظر بد کی وجہ سے مرتے ہیں۔"
(صحیح بخاری)

۵۔ اسماء بنت عمیس رضی اللہ عنہا نے کہا:
"اے اللہ کے رسول! جعفر کے بچوں کو نظر لگ گئی ہے، کیا ہم ان پر دم کریں؟"
آپ ﷺ نے فرمایا: "ہاں، کیونکہ اگر کوئی چیز تقدیر سے آگے نکل سکتی تو وہ نظر بد ہوتی۔"
(جامع ترمذی 2059)

۶۔ نبی کریم ﷺ نے فرمایا:
"جب تم کوئی پسندیدہ چیز دیکھو تو کہو: 'ماشاءاللہ، لا قوۃ الا باللہ' (جو اللہ نے چاہا! اللہ کے سوا کوئی طاقت نہیں)۔"

اہم نکات:
• نظر بد حقیقت ہے اور صحیح احادیث سے ثابت ہے
• یہ صحت، دولت اور زندگی کو متاثر کر سکتی ہے
• قرآن اور دعا سے حفاظت ضروری ہے
• ماشاءاللہ کہنے سے نظر لگنے سے بچتے ہیں
• اللہ کی پناہ مانگنا بہترین علاج ہے''',
        'hindi': '''नज़र-ए-बद के बारे में सहीह हदीसें

१. नबी करीम ﷺ ने फ़रमाया:
"नज़र-ए-बद हक़ है, और अगर कोई चीज़ तक़दीर से आगे निकल सकती तो वो नज़र-ए-बद होती।"
(सहीह मुस्लिम 2188)

२. नबी करीम ﷺ ने फ़रमाया:
"नज़र-ए-बद का असर हक़ीक़त है। अगर कोई चीज़ तक़दीर से पहले आ सकती तो वो नज़र-ए-बद का असर होता।"
(सहीह मुस्लिम)

३. अबू हुरैरा रज़ियल्लाहु अन्हु से रिवायत है:
नबी करीम ﷺ ने फ़रमाया: "नज़र-ए-बद हक़ है और आप ﷺ ने हुक्म दिया कि इसकी वजह से ग़ुस्ल किया जाए।"
(सुनन अबू दाऊद)

४. नबी करीम ﷺ ने फ़रमाया:
"मेरी उम्मत में से अकसर लोग नज़र-ए-बद की वजह से मरते हैं।"
(सहीह बुख़ारी)

५. असमा बिन्त उमैस रज़ियल्लाहु अन्हा ने कहा:
"ऐ अल्लाह के रसूल! जाफ़र के बच्चों को नज़र लग गई है, क्या हम उन पर दम करें?"
आप ﷺ ने फ़रमाया: "हां, क्योंकि अगर कोई चीज़ तक़दीर से आगे निकल सकती तो वो नज़र-ए-बद होती।"
(जामे तिर्मिज़ी 2059)

६. नबी करीम ﷺ ने फ़रमाया:
"जब तुम कोई पसंदीदा चीज़ देखो तो कहो: 'माशाअल्लाह, ला क़ुव्वता इल्ला बिल्लाह' (जो अल्लाह ने चाहा! अल्लाह के सिवा कोई ताक़त नहीं)।"

अहम बातें:
• नज़र-ए-बद हक़ीक़त है और सहीह हदीसों से साबित है
• ये सेहत, दौलत और ज़िंदगी को मुतास्सिर कर सकती है
• क़ुरआन और दुआ से हिफ़ाज़त ज़रूरी है
• माशाअल्लाह कहने से नज़र लगने से बचते हैं
• अल्लाह की पनाह मांगना बेहतरीन इलाज है''',
        'arabic': '''أحاديث صحيحة عن العين

١. قال النبي ﷺ:
"العين حق، ولو كان شيء سابق القدر لسبقته العين"
(صحيح مسلم 2188)

٢. قال النبي ﷺ:
"العين حق، تستنزل الفارس عن فرسه"
(صحيح مسلم)

٣. عن أبي هريرة رضي الله عنه:
قال النبي ﷺ: "العين حق وأمر بالاغتسال منها"
(سنن أبي داود)

٤. قال النبي ﷺ:
"أكثر من يموت من أمتي بعد قضاء الله وقدره بالعين"
(صحيح البخاري)

٥. عن أسماء بنت عميس رضي الله عنها قالت:
"يا رسول الله، إن ولد جعفر تصيبهم العين أفأسترقي لهم؟"
قال: "نعم، فلو كان شيء سابق القدر لسبقته العين"
(جامع الترمذي 2059)

٦. قال النبي ﷺ:
"إذا رأى أحدكم من نفسه أو ماله أو من أخيه ما يعجبه فليدع بالبركة"

الفوائد المهمة:
• العين حق وثابتة ب��لأحاديث الصحيحة
• تؤثر على الصحة والمال والحياة
• الحماية بالقرآن والدعاء ضرورية
• قول "ما شاء الله" يمنع الإصابة بالعين
• الاستعاذة بالله خير علاج''',
      },
    },
    {
      'number': 6,
      'titleKey': 'nazar_e_bad_6_treatment_methods',
      'title': 'Treatment & Removal',
      'titleUrdu': 'علاج اور دور کرنا',
      'titleHindi': 'इलाज और दूर करना',
      'titleArabic': 'العلاج والإزالة',
      'icon': Icons.medical_services,
      'color': Colors.red,
      'details': {
        'english': '''How to Remove Evil Eye

Method 1 - Bath from the One Who Gave Evil Eye:
If you know who gave the evil eye:
1. Ask them to perform Wudu
2. Collect the water from their Wudu
3. Pour this water over the affected person
4. Make dua for healing

The Prophet ﷺ said: "If you are asked to wash, then wash."

Method 2 - Complete Ruqyah Treatment:
1. Recite these verses over the person:
   • Surah Al-Fatiha (7 times)
   • Ayatul Kursi (7 times)
   • Surah Al-Ikhlas (11 times)
   • Surah Al-Falaq (11 times)
   • Surah An-Naas (11 times)
   • Last 2 verses of Surah Al-Baqarah

2. After recitation:
   • Blow on the person
   • Place hand on their head
   • Make dua for healing

Method 3 - Water Treatment:
1. Fill a large container with water
2. Recite Quran over it
3. Add a few drops of olive oil
4. Drink 3 sips
5. Bathe with the rest

Method 4 - Olive Oil Massage:
1. Recite Quran over pure olive oil
2. Massage the body with this oil
3. Focus on head, chest, and back
4. Do this daily for 7 days

Method 5 - Seven Leaves Treatment:
1. Take 7 fresh green Sidr (lote) leaves
2. Crush them in water
3. Recite Quran over this water
4. Drink some and bathe with rest

Important Notes:
• Have complete faith in Allah's healing
• Be consistent with treatment
• Combine with medical treatment if needed
• Evil eye can be removed with Allah's permission
• Maintain daily Adhkar for protection''',
        'urdu': '''نظر بد کا علاج اور دور کرنا

پہلا طریقہ - نظر لگانے والے کے وضو کا پانی:
اگر آپ کو معلوم ہو کہ کس نے نظر لگائی:
۱۔ ان سے وضو کرنے کو کہیں
۲۔ ان کے وضو کا پانی جمع کریں
۳۔ یہ پانی متاثرہ شخص پر ڈالیں
۴۔ شفا کی دعا کریں

نبی کریم ﷺ نے فرمایا: "اگر تم سے دھونے کو کہا جائے تو دھو دو۔"

دوسرا طریقہ - مکمل دم کا علاج:
۱۔ یہ آیات شخص پر پڑھیں:
   • سورۃ الفاتحہ (7 بار)
   • آیت الکرسی (7 بار)
   • سورۃ الاخلاص (11 بار)
   • سورۃ الفلق (11 بار)
   • سورۃ الناس (11 بار)
   • سورۃ البقرہ کی آخری 2 آیات

۲۔ تلاوت کے بعد:
   • شخص پر پھونکیں
   • ہاتھ ان کے سر پر رکھیں
   • شفا کی دعا کریں

تیسرا طریقہ - پانی سے علاج:
۱۔ ایک بڑے برتن میں پانی بھریں
۲۔ اس پر قرآن پڑھیں
۳۔ زیتون کے تیل کی چند بوندیں ڈالیں
۴۔ 3 گھونٹ پئیں
۵۔ باقی سے نہائیں

چوتھا طریقہ - زیتون کے تیل سے مالش:
۱۔ خالص زیتون کے تیل پر قرآن پڑھیں
۲۔ اس تیل سے جسم پر مالش کریں
۳۔ سر، سینے اور پیٹھ پر توجہ دیں
۴۔ یہ روزانہ 7 دن تک کریں

پانچواں طریقہ - سات پتوں کا علاج:
۱۔ 7 تازہ ہرے بیری (سدر) کے پتے لیں
۲۔ انہیں پانی میں پیس لیں
۳۔ اس پانی پر قرآن پڑھیں
۴۔ کچھ پئیں اور باقی سے نہائیں

اہم نکات:
• اللہ کی شفا پر مکمل یقین رکھیں
• علاج میں مستقل مزاجی رکھیں
• ضرورت ہو تو طبی علاج کے ساتھ ملائیں
• اللہ کی اجازت سے نظر بد دور ہو سکتی ہے
• روزانہ اذکار سے حفاظت برقرار رکھیں''',
        'hindi': '''नज़र-ए-बद का इलाज और दूर करना

पहला तरीक़ा - नज़र लगाने वाले के वुज़ू का पानी:
अगर आपको मालूम हो कि किसने नज़र लगाई:
१. उनसे वुज़ू करने को कहें
२. उनके वुज़ू का पानी जमा करें
३. यह पानी मुतास्सिर शख़्स पर डालें
४. शिफ़ा की दुआ करें

नबी करीम ﷺ ने फ़रमाया: "अगर तुमसे धोने को कहा जाए तो धो दो।"

दूसरा तरीक़ा - मुकम्मल दम का इलाज:
१. ये आयात शख़्स पर पढ़ें:
   • सूरह अल-फ़ातिहा (7 बार)
   • आयतुल कुर्सी (7 बार)
   • सूरह अल-इख़्लास (11 बार)
   • सूरह अल-फ़लक़ (11 बार)
   • सूरह अन-नास (11 बार)
   • सूरह अल-बक़रा की आख़िरी 2 आयात

२. तिलावत के बाद:
   • शख़्स पर फूंकें
   • हाथ उनके सर पर रखें
   • शिफ़ा की दुआ करें

तीसरा तरीक़ा - पानी से इलाज:
१. एक बड़े बर्तन में पानी भरें
२. उस पर क़ुरआन पढ़ें
३. ज़ैतून के तेल की कुछ बूंदें डालें
४. 3 घूंट पिएं
५. बाक़ी से नहाएं

चौथा तरीक़ा - ज़ैतून के तेल से मालिश:
१. ख़ालिस ज़ैतून के तेल पर क़ुरआन पढ़ें
२. इस तेल से जिस्म पर मालिश करें
३. सर, सीने और पीठ पर तवज्जो दें
४. यह रोज़ाना 7 दिन तक करें

पांचवां तरीक़ा - सात पत्तों का इलाज:
१. 7 ताज़ा हरे बेर (सिदर) के पत्ते लें
२. उन्हें पानी में पीस लें
३. इस पानी पर क़ुरआन पढ़ें
४. कुछ पिएं और बाक़ी से नहाएं

अहम बातें:
• अल्लाह की शिफ़ा पर मुकम्मल यक़ीन रखें
• इलाज में मुस्तक़िल मिज़ाजी रखें
• ज़रूरत हो तो तिब्बी इलाज के साथ मिलाएं
• अल्लाह की इजाज़त से नज़र-ए-बद दूर हो सकती है
• रोज़ाना अज़कार से हिफ़ाज़त बरक़रार रखें''',
        'arabic': '''كيفية إزالة العين

الطريقة الأولى - الاغتسال بماء وضوء العائن:
إذا علمت من أعانك:
١. اطلب منه أن يتوضأ
٢. اجمع ماء وضوئه
٣. صب هذا الماء على المعيون
٤. ادع بالشفاء

قال النبي ﷺ: "إذا استُغْسِلْتُمْ فَاغْسِلُوا"

الطريقة الثانية - الرقية الكاملة:
١. اقرأ هذه الآيات على الشخص:
   �� سورة الفاتحة (7 مرات)
   • آية الكرسي (7 مرات)
   • سورة الإخلاص (11 مرة)
   • سورة الفلق (11 مرة)
   • سورة الناس (11 مرة)
   • آخر آيتين من سورة البقرة

٢. بعد القراءة:
   • انفث على الشخص
   • ضع يدك على رأسه
   • ادع بالشفاء

الطريقة الثالثة - العلاج بالماء:
١. املأ وعاء كبير بالماء
٢. اقرأ القرآن عليه
٣. أضف بضع قطرات من زيت الزيتون
٤. اشرب 3 جرعات
٥. اغتسل بالباقي

الطريقة الرابعة - التدليك بزيت الزيتون:
١. اقرأ القرآن على زيت زيتون نقي
٢. دلك الجسم بهذا الزيت
٣. ركز على الرأس والصدر والظهر
٤. افعل ذلك يومياً لمدة 7 أيام

الطريقة الخامسة - علاج السبع ورقات:
١. خذ 7 ورقات سدر خضراء طازجة
٢. اطحنها في الماء
٣. اقرأ القرآن على هذا الماء
٤. اشرب بعضه واغتسل بالباقي

ملاحظات مهمة:
• احرص على الإيمان الكامل بشفاء الله
• كن مستمراً في العلاج
• اجمع مع العلاج الطبي إن لزم
• العين تزول بإذن الله
• حافظ على الأذكار اليومية للحماية''',
      },
    },
    {
      'number': 7,
      'titleKey': 'nazar_e_bad_7_if_you_give_evil_eye',
      'title': 'If You Give Evil Eye',
      'titleUrdu': 'اگر آپ نظر لگا دیں',
      'titleHindi': 'अगर आप नज़र लगा दें',
      'titleArabic': 'إذا أصبت أحداً بالعين',
      'icon': Icons.warning,
      'color': Colors.deepOrange,
      'details': {
        'english': '''What to Do If You Give Someone Evil Eye

If you realize that you admired something/someone and they became affected:

Immediate Action:
1. Say "Allahumma barik" (O Allah, bless it)
2. Say "MashaAllah la quwwata illa billah"
3. Make dua for their well-being

The Prophet ﷺ said:
"Why does one of you not make dua for blessing when he sees something he likes?"

How to Help Remove Your Evil Eye:
1. Perform Wudu properly
2. Let the affected person collect your Wudu water
3. They should pour it over themselves
4. Make sincere dua for their healing

Proper Etiquette When Admiring:
1. Always say "MashaAllah" first
2. Then praise if needed
3. Make dua for blessing
4. Don't stare excessively
5. Lower your gaze after admiring

Prevention for Future:
• Train yourself to say MashaAllah automatically
• When you see something beautiful, thank Allah
• Make dua for the person/thing you admire
• Remember that all blessings are from Allah
• Don't be envious or jealous

Dua to Say When You See Something You Like:
"اللَّهُمَّ بَارِكْ فِيهِ/فِيهَا"
"Allahumma barik fihi/fiha"
"O Allah, bless him/her/it"

Important Reminder:
• Evil eye can happen unintentionally
• Even with good intentions, you can give evil eye
• Saying MashaAllah protects both you and others
• If someone asks you to wash, don't refuse
• It's not sinful if done unintentionally
• Always seek Allah's forgiveness''',
        'urdu': '''اگر آپ کسی کو نظر لگا دیں تو کیا کریں

اگر آپ کو احساس ہو کہ آپ نے کسی چیز/شخص کی تعریف کی اور وہ متاثر ہو گئے:

فوری اقدام:
۱۔ "اللہم بارک" کہیں (اے اللہ، اس میں برکت دے)
۲۔ "ماشاءاللہ لا قوۃ الا باللہ" کہیں
۳۔ ان کی بہتری کی دعا کریں

نبی کریم ﷺ نے فرمایا:
"تم میں سے کوئی جب کسی پسندیدہ چیز کو دیکھے تو برکت کی دعا کیوں نہیں کرتا؟"

اپنی نظر بد دور کرنے میں مدد کیسے کریں:
۱۔ صحیح طریقے سے وضو کریں
۲۔ متاثرہ شخص کو اپنے وضو کا پانی جمع کرنے دیں
۳۔ انہیں چاہیے کہ یہ پانی اپنے اوپر ڈالیں
۴۔ ان کی شفا کے لیے خلوص دل سے دعا کریں

تعریف کرتے وقت صحیح آداب:
۱۔ ہمیشہ پہلے "ماشاءاللہ" کہیں
۲۔ پھر ضرورت ہو تو تعریف کریں
۳۔ برکت کی دعا کریں
۴۔ ضرورت سے زیادہ نہ گھوریں
۵۔ تعریف کے بعد نظر نیچی کریں

مستقبل کے لیے احتیاط:
• اپنے آپ کو ماشاءاللہ خود بخود کہنے کی تربیت دیں
• جب کوئی خوبصورت چیز دیکھیں تو اللہ کا شکر ادا کریں
• جس چیز/شخص کی تعریف کریں اس کے لیے دعا کریں
• یاد رکھیں کہ تمام نعمتیں اللہ کی طرف سے ہیں
• حسد یا رشک نہ کریں

جب آپ کوئی پسندیدہ چیز دیکھیں تو یہ دعا پڑھیں:
"اللَّهُمَّ بَارِكْ فِيهِ/فِيهَا"
"اللہم بارک فیہ/فیہا"
"اے اللہ، اس میں برکت دے"

اہم یاد دہانی:
• نظر بد غیر ارادی طور پر لگ سکتی ہے
• اچھی نیت کے ساتھ بھی نظر لگ سکتی ہے
• ماشاءاللہ کہنا آپ اور دوسروں دونوں کی حفاظت کرتا ہے
• اگر کوئی آپ سے دھونے کو کہے تو انکار نہ کریں
• اگر غیر ارادی ہو تو گناہ نہیں
• ہمیشہ اللہ سے معافی مانگیں''',
        'hindi': '''अगर आप किसी को नज़र लगा दें तो क्या करें

अगर आपको अहसास हो कि आपने किसी चीज़/शख़्स की तारीफ़ की और वो मुतास्सिर हो गए:

फ़ौरी इक़दाम:
१. "अल्लाहुम्म बारिक" कहें (ऐ अल्लाह, इसमें बरकत दे)
२. "माशाअल्लाह ला क़ुव्वता इल्ला बिल्लाह" कहें
३. उनकी बेहतरी की दुआ करें

नबी करीम ﷺ ने फ़रमाया:
"तुम में से कोई जब किसी पसंदीदा चीज़ को देखे तो बरकत की दुआ क्यों नहीं करता?"

अपनी नज़र-ए-बद दूर करने में मदद कैसे करें:
१. सही तरीक़े से वुज़ू करें
२. मुतास्सिर शख़्स को अपने वुज़ू का पानी जमा करने दें
३. उन्हें चाहिए कि यह पानी अपने ऊपर डालें
४. उनकी शिफ़ा के लिए ख़ुलूस दिल से दुआ करें

तारीफ़ करते वक़्त सही आदाब:
१. हमेशा पहले "माशाअल्लाह" कहें
२. फिर ज़रूरत हो तो तारीफ़ करें
३. बरकत की दुआ करें
४. ज़रूरत से ज़्यादा न घूरें
५. तारीफ़ के बाद नज़र नीची करें

मुस्तक़बिल के लिए एहतियात:
• अपने आप को माशाअल्लाह ख़ुद-ब-ख़ुद कहने की तरबियत दें
• जब कोई ख़ूबसूरत चीज़ देखें तो अल्लाह का शुक्र अदा करें
• जिस चीज़/शख़्स की तारीफ़ करें उसके लिए दुआ करें
• याद रखें कि तमाम नेमतें अल्लाह की तरफ़ से हैं
• हसद या रश्क न करें

जब आप कोई पसंदीदा चीज़ देखें तो यह दुआ पढ़ें:
"اللَّهُمَّ بَارِكْ فِيهِ/فِيهَا"
"अल्लाहुम्म बारिक फ़ीहि/फ़ीहा"
"ऐ अल्लाह, इसमें बरकत दे"

अहम याद दिहानी:
• नज़र-ए-बद ग़ैर-इरादी तौर पर लग सकती है
• अच्छी नीयत के साथ भी नज़र लग सकती है
• माशाअल्लाह कहना आप और दूसरों दोनों की हिफ़ाज़त करता है
• अगर कोई आपसे धोने को कहे तो इनकार न करें
• अगर ग़ैर-इरादी हो तो गुनाह नहीं
• हमेशा अल्लाह से माफ़ी मांगें''',
        'arabic': '''ماذا تفعل إذا أصبت أحداً بالعين

إذا أدركت أنك أعجبت بشيء/شخص وتأثر:

الإجراء الفوري:
١. قل "اللهم بارك" (اللهم بارك فيه)
٢. قل "ما شاء الله لا قوة إلا بالله"
٣. ادع له بالخير

قال النبي ﷺ:
"هَلَّا إِذَا رَأَيْتَ مَا يُعْجِبُكَ بَرَّكْتَ"

كيف تساعد في إزالة عينك:
١. توضأ وضوءاً صحيحاً
٢. دع المعيون يجمع ماء وضوئك
٣. يجب أن يصب هذا الماء على نفسه
٤. ادع له بالشفاء بإخلاص

الآداب الصحيحة عند الإعجاب:
١. قل دائماً "ما شاء الله" أولاً
٢. ثم امدح إن لزم
٣. ادع بالبركة
٤. لا تحدق كثيراً
٥. اغضض بصرك بعد الإعجاب

الوقاية للمستقبل:
• درب نفسك على قول ما شاء الله تلقائياً
• عندما ترى شيئاً جميلاً احمد الله
• ادع للشخص/الشيء الذي أعجبك
• تذكر أن جميع النعم من الله
• لا تحسد أو تغار

الدعاء عند رؤية ما يعجبك:
"اللَّهُمَّ بَارِكْ فِيهِ/فِيهَا"
"اللهم بارك فيه/فيها"
"اللهم بارك فيه/فيها"

تذكير مهم:
• العين قد تحدث دون قصد
• حتى مع النية الحسنة، يمكن أن تصيب بالعين
• قول ما شاء الله يحميك ويحمي الآخرين
• إذا طُلب منك أن تغتسل فلا ترفض
• ليس إثماً إذا كان غير مقصود
• استغفر الله دائماً''',
      },
    },
    {
      'number': 8,
      'titleKey': 'nazar_e_bad_8_protecting_children',
      'title': 'Protecting Children & Newborns',
      'titleUrdu': 'بچوں اور نوزائیدہ کی حفاظت',
      'titleHindi': 'बच्चों और नवजात की हिफ़ाज़त',
      'titleArabic': 'حماية الأطفال والمواليد',
      'icon': Icons.child_care,
      'color': Colors.pink,
      'details': {
        'english': '''Protecting Children and Newborns from Evil Eye

Children, especially newborns, are particularly vulnerable to evil eye. The Prophet ﷺ took special care to protect Hassan and Hussain (RA).

Daily Protection for Children:

1. Morning & Evening Recitation:
Recite over your child and blow:
• Surah Al-Fatiha (1 time)
• Ayatul Kursi (1 time)
• Surah Al-Ikhlas, Al-Falaq, An-Naas (3 times each)

2. Prophet's Dua for Children:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"

"I seek refuge for you both in the perfect words of Allah from every devil, every poisonous creature, and every evil eye."

The Prophet ﷺ would recite this for Hassan and Hussain (RA) saying: "Your father Ibrahim used to seek refuge with these words for Ismail and Ishaq."

3. Before Sleep:
• Place hand on child's head
• Recite the three Quls
• Blow gently on them
• Make dua for their protection

4. When Going Out:
• Recite protection duas before leaving
• Avoid showing off your child excessively
• Say MashaAllah when others praise them
• Dress them modestly, not extravagantly

5. For Newborns (First 40 Days):
• Limit visitors in early days
• Ask visitors to say MashaAllah
• Keep baby's photos private initially
• Recite Quran in the house regularly
• Give Adhan in right ear, Iqama in left ear

6. Protection at School:
• Teach child to recite morning/evening adhkar
• Put protection duas in school bag
• Recite Ayatul Kursi before they leave
• Make dua for them daily

7. Using Taweez (Amulet):
• Only permissible if contains Quran/Duas
• Must understand what's written inside
• Not to be worn in bathroom
• Quran recitation is better than taweez
• Don't rely on taweez alone, rely on Allah

Signs Your Child May Have Evil Eye:
• Sudden unexplained crying
• Refusing to eat
• Sleeping problems
• Fever without medical cause
• Behavioral changes
• Becoming unusually quiet

Treatment for Children:

1. Water Ruqyah:
• Recite Quran over water
• Give child to drink
• Wipe their body with it

2. Olive Oil:
• Recite Quran over olive oil
• Gently massage child's body
• Focus on head and chest

3. Bath with Sidr Leaves:
• Use 7 Sidr leaves in bath water
• Recite Quran over the water
• Bathe the child gently

Important Reminders:

• Don't become paranoid about every illness
• Seek medical help alongside spiritual care
• Evil eye is real but not everything is evil eye
• Trust in Allah's protection above all
• Regular Quran recitation in home protects all
• A home where Surah Al-Baqarah is recited, Shaytan doesn't enter for 3 days

Special Dua for Sick Child:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي"
"O Allah, Lord of mankind, remove the hardship, heal him/her, for You are the Healer."

(Place hand on child's body and recite 7 times)''',
        'urdu': '''بچوں اور نوزائیدہ کو نظر بد سے بچانا

بچے، خاص طور پر نوزائیدہ، نظر بد کے لیے خاص طور پر کمزور ہوتے ہیں۔ نبی کریم ﷺ نے حسن اور حسین رضی اللہ عنہما کی حفاظت کے لیے خاص خیال رکھا۔

بچوں کے لیے روزانہ کی حفاظت:

۱۔ صبح و شام کی تلاوت:
اپنے بچے پر پڑھیں اور پھونکیں:
• سورۃ الفاتحہ (1 بار)
• آیت الکرسی (1 بار)
• سورۃ الاخلاص، الفلق، الناس (ہر ایک 3 بار)

۲۔ بچوں کے لیے نبی کریم ﷺ کی دعا:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"

"میں تم دونوں کو اللہ کے کامل کلمات کی پناہ میں دیتا ہوں ہر شیطان، ہر زہریلے جانور اور ہر بری نظر سے۔"

نبی کریم ﷺ حسن اور حسین رضی اللہ عنہما کے لیے یہ پڑھتے تھے اور فرماتے: "تمہارے باپ ابراہیم علیہ السلام اسماعیل اور اسحاق کے لیے ان کلمات سے پناہ مانگتے تھے۔"

۳۔ سونے سے پہلے:
• بچے کے سر پر ہاتھ رکھیں
• تین قل پڑھیں
• ان پر آہستہ پھونکیں
• ان کی حفاظت کی دعا کریں

۴۔ باہر جاتے وقت:
• نکلنے سے پہلے حفاظتی دعائیں پڑھیں
• اپنے بچے کا بے جا اظہار نہ کریں
• جب دوسرے تعریف کریں تو ماشاءاللہ کہیں
• انہیں شائستہ، نہ کہ شاندار کپڑے پہنائیں

۵۔ نوزائیدہ کے لیے (پہلے 40 دن):
• ابتدائی دنوں میں ملاقاتیوں کو محدود کریں
• ملاقاتیوں سے ماشاءاللہ کہنے کو کہیں
• ابتدا میں بچے کی تصاویر نجی رکھیں
• گھر میں باقاعدگی سے قرآن پڑھیں
• دائیں کان میں اذان، بائیں میں اقامت دیں

۶۔ سکول میں حفاظت:
• بچے کو صبح و شام کے اذکار پڑھنا سکھائیں
• سکول بیگ میں حفاظتی دعائیں رکھیں
• جانے سے پہلے آیت الکرسی پڑھیں
• روزانہ ان کے لیے دعا کریں

۷۔ تعویذ استعمال کرنا:
• صرف اسی صورت میں جائز ہے اگر اس میں قرآن/دعائیں ہوں
• اندر کیا لکھا ہے سمجھنا ضروری ہے
• باتھ روم میں نہ پہنیں
• قرآن کی تلاوت تعویذ سے بہتر ہے
• صرف تعویذ پر انحصار نہ کریں، اللہ پر بھروسہ کریں

بچے میں نظر بد کی علامات:
• اچانک بلا وجہ رونا
• کھانے سے انکار
• نیند کے مسائل
• طبی وجہ کے بغیر بخار
• رویے میں تبدیلیاں
• غیر معمولی طور پر خاموش ہونا

بچوں کا علاج:

۱۔ پانی پر دم:
• پانی پر قرآن پڑھیں
• بچے کو پلائیں
• اس سے ان کا جسم پونچھیں

۲۔ زیتون کا تیل:
• زیتون کے تیل پر قرآن پڑھیں
• بچے کے جسم پر آہستگی سے مالش کریں
• سر اور سینے پر توجہ دیں

۳۔ سدر کے پتوں سے غسل:
• نہانے کے پانی میں 7 سدر کے پتے استعمال کریں
• پانی پر قرآن پڑھیں
• بچے کو آہستگی سے نہلائیں

اہم یاد دہانی:

• ہر بیماری کے بارے میں پاگل نہ ہوں
• روحانی دیکھ بھال کے ساتھ طبی مدد لیں
• نظر بد حقیقت ہے لیکن ہر چیز نظر بد نہیں
• سب سے بڑھ کر اللہ کی حفاظت پر بھروسہ کریں
• گھر میں باقاعدہ قرآن کی تلاوت سب کی حفاظت کرتی ہے
• جس گھر میں سورۃ البقرہ پڑھی جائے شیطان 3 دن داخل نہیں ہوتا

بیمار بچے کے لیے خاص دعا:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي"
"اے اللہ، لوگوں کے رب، تکلیف دور کر، شفا دے، تو ہی شفا دینے والا ہے۔"

(بچے کے جسم پر ہاتھ رکھیں اور 7 بار پڑھیں)''',
        'hindi': '''बच्चों और नवजात को नज़र-ए-बद से बचाना

बच्चे, ख़ासतौर पर नवजात, नज़र-ए-बद के लिए ख़ास तौर पर कमज़ोर होते हैं। नबी करीम ﷺ ने हसन और हुसैन रज़ियल्लाहु अन्हुमा की हिफ़ाज़त के लिए ख़ास ख़याल रखा।

बच्चों के लिए रोज़ाना की हिफ़ाज़त:

१. सुबह व शाम की तिलावत:
अपने बच्चे पर पढ़ें और फूंकें:
• सूरह अल-फ़ातिहा (1 बार)
• आयतुल कुर्सी (1 बार)
• सूरह अल-इख़्लास, अल-फ़लक़, अन-नास (हर एक 3 बार)

२. बच्चों के लिए नबी करीम ﷺ की दुआ:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"

"मैं तुम दोनों को अल्लाह के कामिल कलिमात की पनाह में देता हूं हर शैतान, हर ज़हरीले जानवर और हर बुरी नज़र से।"

नबी करीम ﷺ हसन और हुसैन रज़ियल्लाहु अन्हुमा के लिए यह पढ़ते थे और फ़रमाते: "तुम्हारे बाप इब्राहीम अलैहिस्सलाम इस्माइल और इसहाक़ के लिए इन कलिमात से पनाह मांगते थे।"

३. सोने से पहले:
• बच्चे के सर पर हाथ रखें
• तीन क़ुल पढ़ें
• उन पर आहिस्ता फूंकें
• उनकी हिफ़ाज़त की दुआ करें

४. बाहर जाते वक़्त:
• निकलने से पहले हिफ़ाज़ती दुआएं पढ़ें
• अपने बच्चे का बेजा इज़हार न करें
• जब दूसरे तारीफ़ करें तो माशाअल्लाह कहें
• उन्हें शाइस्ता, न कि शानदार कपड़े पहनाएं

५. नवजात के लिए (पहले 40 दिन):
• इब्तिदाई दिनों में मुलाक़ातियों को महदूद करें
• मुलाक़ातियों से माशाअल्लाह कहने को कहें
• इब्तिदा में बच्चे की तस्वीरें निजी रखें
• घर में बाक़ायदगी से क़ुरआन पढ़ें
• दाएं कान में अज़ान, बाएं में इक़ामत दें

६. स्कूल में हिफ़ाज़त:
• बच्चे को सुबह व शाम के अज़कार पढ़ना सिखाएं
• स्कूल बैग में हिफ़ाज़ती दुआएं रखें
• जाने से पहले आयतुल कुर्सी पढ़ें
• रोज़ाना उनके लिए दुआ करें

७. तावीज़ इस्तेमाल करना:
• सिर्फ़ उसी सूरत में जायज़ है अगर उसमें क़ुरआन/दुआएं हों
• अंदर क्या लिखा है समझना ज़रूरी है
• बाथरूम में न पहनें
• क़ुरआन की तिलावत तावीज़ से बेहतर है
• सिर्फ़ तावीज़ पर इन्हेसार न करें, अल्लाह पर भरोसा करें

बच्चे में नज़र-ए-बद की अलामात:
• अचानक बिला वजह रोना
• खाने से इनकार
• नींद के मसाइल
• तिब्बी वजह के बग़ैर बुख़ार
• रवय्ये में तब्दीली
• ग़ैर-मामूली तौर पर ख़ामोश होना

बच्चों का इलाज:

१. पानी पर दम:
• पानी पर क़ुरआन पढ़ें
• बच्चे को पिलाएं
• उससे उनका जिस्म पोंछें

२. ज़ैतून का तेल:
• ज़ैतून के तेल पर क़ुरआन पढ़ें
• बच्चे के जिस्म पर आहिस्तगी से मालिश करें
• सर और सीने पर तवज्जो दें

३. सिदर के पत्तों से ग़ुस्ल:
• नहाने के पानी में 7 सिदर के पत्ते इस्तेमाल करें
• पानी पर क़ुरआन पढ़ें
• बच्चे को आहिस्तगी से नहलाएं

अहम याद दिहानी:

• हर बीमारी के बारे में पागल न हों
• रूहानी देखभाल के साथ तिब्बी मदद लें
• नज़र-ए-बद हक़ीक़त है लेकिन हर चीज़ नज़र-ए-बद नहीं
• सब से बढ़कर अल्लाह की हिफ़ाज़त पर भरोसा करें
• घर में बाक़ायदा क़ुरआन की तिलावत सब की हिफ़ाज़त करती है
• जिस घर में सूरह अल-बक़रा पढ़ी जाए शैतान 3 दिन दाख़िल नहीं होता

बीमार बच्चे के लिए ख़ास दुआ:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي"
"ऐ अल्लाह, लोगों के रब, तकलीफ़ दूर कर, शिफ़ा दे, तू ही शिफ़ा देने वाला है।"

(बच्चे के जिस्म पर हाथ रखें और 7 बार पढ़ें)''',
        'arabic': '''حماية الأطفال والمواليد من العين

الأطفال، وخاصة المواليد، معرضون بشكل خاص للعين. كان النبي ﷺ يحرص على حماية الحسن والحسين رضي الله عنهما.

الحماية اليومية للأطفال:

١. التلاوة صباحاً ومساءً:
اقرأ على طفلك وانفث:
• سورة الفاتحة (مرة واحدة)
• آية الكرسي (مرة واحدة)
• سورة الإخلاص والفلق والناس (3 مرات لكل منها)

٢. دعاء النبي ﷺ للأطفال:
"أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ"

"أعيذكما بكلمات الله التامة من كل شيطان وهامة ومن كل عين لامة"

كان النبي ﷺ يقرأها للحسن والحسين ويقول: "إن أباكما إبراهيم كان يعوذ بها إسماعيل وإسحاق."

٣. قبل النوم:
• ضع يدك على رأس الطفل
• اقرأ المعوذات الثلاث
• انفث عليه برفق
• ادع له بالحماية

٤. عند الخروج:
• اقرأ أدعية الحماية قبل الخروج
• تجنب التفاخر بطفلك بشكل مفرط
• قل ما شاء الله عندما يثني عليه الآخرون
• ألبسه ملابس متواضعة، ليست فخمة

٥. للمواليد (أول 40 يوماً):
• قلل الزوار في الأيام الأولى
• اطلب من الزوار قول ما شاء الله
• احتفظ بصور الطفل خاصة في البداية
• اقرأ القرآن في البيت بانتظام
• أذّن في الأذن اليمنى، وأقم في اليسرى

٦. الحماية في المدرسة:
• علّم الطفل قراءة أذكار الصباح والمساء
• ضع أدعية الحماية في حقيبة المدرسة
• اقرأ آية الكرسي قبل خروجه
• ادع له يومياً

٧. استخدام التميمة (الحرز):
• جائز فقط إذا كان يحتوي على قرآن/أدعية
• يجب فهم ما هو مكتوب بداخله
• لا يُرتدى في الحمام
• تلاوة القرآن أفضل من التميمة
• لا تعتمد على التميمة وحدها، اعتمد على الله

علامات العين عند الطفل:
• بكاء مفاجئ بدون سبب
• رفض الأكل
• مشاكل في النوم
• حمى بدون سبب طبي
• تغيرات سلوكية
• أن يصبح هادئاً بشكل غير عادي

علاج الأطفال:

١. الرقية بالماء:
• اقرأ القرآن على الماء
• أعط الطفل ليشرب
• امسح جسمه به

٢. زيت الزيتون:
• اقرأ القرآن على زيت الزيتون
• دلك جسم الطفل برفق
• ركز على الرأس والصدر

٣. الاستحمام بأوراق السدر:
• استخدم 7 أوراق سدر في ماء الاستحمام
• اقرأ القرآن على الماء
• حمّم الطفل برفق

تذكيرات مهمة:

• لا تكن مصاباً بالوسواس تجاه كل مرض
• اطلب المساعدة الطبية إلى جانب الرعاية الروحانية
• العين حق لكن ليس كل شيء عين
• توكل على حماية الله قبل كل شيء
• تلاوة القرآن المنتظمة في البيت تحمي الجميع
• البيت الذي تُقرأ فيه سورة البقرة لا يدخله الشيطان 3 أيام

دعاء خاص للطفل المريض:
"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِهِ وَأَنْتَ الشَّافِي"
"اللهم رب الناس أذهب البأس، اشفه وأنت الشافي"

(ضع يدك على جسم الطفل واقرأ 7 مرات)''',
      },
    },
    {
      'number': 9,
      'titleKey': 'nazar_e_bad_9_social_media_era',
      'title': 'Protection in Social Media Era',
      'titleUrdu': 'سوشل میڈیا کے دور میں حفاظت',
      'titleHindi': 'सोशल मीडिया के दौर में हिफ़ाज़त',
      'titleArabic': 'الحماية في عصر وسائل التواصل',
      'icon': Icons.phone_android,
      'color': Colors.cyan,
      'details': {
        'english': '''Protection from Evil Eye in Social Media Era

In today's digital age, social media has made us more vulnerable to evil eye than ever before. When you share your blessings online, thousands can see them.

Guidelines for Social Media:

1. Think Before You Post:
• Ask yourself: "Am I showing off or sharing for benefit?"
• Is this necessary to post?
• Can this cause envy in others?
• Would I say MashaAllah if I saw this?

2. What NOT to Share Frequently:
• Every achievement immediately
• Expensive purchases
• Constant vacation photos
• Children's photos excessively
• Wealth and luxuries
• Relationship happiness constantly
• Success before it's fully established

3. What's Better to Keep Private:
• New relationships (first few months)
• Pregnancy (first trimester)
• Business deals (until finalized)
• Exam results (until verified)
• Job offers (until confirmed)
• Major purchases (cars, houses) immediately
• Personal duas and worship

4. How to Share Safely:
• Always write "MashaAllah" with your posts
• Give credit to Allah in caption
• Share with intention to inspire, not impress
• Limit your audience (close friends only)
• Don't share every blessing
• Delay sharing until blessing is established
• Thank Allah publicly

5. For Parents Posting Children:
• Limit children's photos
• Don't share daily updates
• Keep baby's face private first 40 days
• Don't share illness or vulnerable moments
• Enable privacy settings
• Be mindful of what you're exposing
• Remember: Your child can't consent

6. Signs You're Sharing Too Much:
• You feel anxious if you don't get likes
• You share every meal, every outfit
• You update status multiple times daily
• You feel need to prove your happiness
• You share immediately after buying something
• You compare your life to others online

7. Protection After Posting:
If you've shared something:
• Recite protective duas
• Say "MashaAllah la quwwata illa billah"
• Make dua for Allah's protection
• Don't obsessively check engagement
• Remember that likes aren't blessings

8. The Wise Approach:
• Share to benefit others, not to boast
• Be grateful privately more than publicly
• Remember Allah can see even without posts
• Your real life matters more than online life
• Blessings grow with gratitude, not display

Prophetic Wisdom:
The Prophet ﷺ said: "Seek help in fulfilling your needs by being discreet, for everyone who is blessed is envied."

Modern Dua for Social Media:
"اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْحَسَدِ وَالْعَيْنِ"
"O Allah, I seek refuge in You from envy and evil eye"

(Recite after posting anything online)

Remember:
• Not everything needs to be shared
• Privacy is a blessing
• The more you display, the more exposed you are
• True contentment doesn't need validation
• Allah's pleasure matters more than people's likes

Practical Tips:
1. Use "Close Friends" feature
2. Disable tagging without permission
3. Regularly review who can see your posts
4. Don't announce plans before they happen
5. Celebrate privately first, share later
6. If you feel hesitation, don't post
7. Remember: Once posted, it's public forever

The Balance:
• It's not haram to share blessings
• But wisdom lies in moderation
• Islam teaches us to be grateful, not boastful
• Share to inspire and help, not to show off
• When in doubt, keep it private''',
        'urdu': '''سوشل میڈیا کے دور میں نظر بد سے بچاؤ

آج کے ڈیجیٹل دور میں، سوشل میڈیا نے ہمیں پہلے سے کہیں زیادہ نظر بد کے لیے کمزور بنا دیا ہے۔ جب آپ اپنی نعمتیں آن لائن شیئر کرتے ہیں تو ہزاروں انہیں دیکھ سکتے ہیں۔

سوشل میڈیا کے لیے رہنما اصول:

۱۔ پوسٹ کرنے سے پہلے سوچیں:
• اپنے آپ سے پوچھیں: "کیا میں دکھاوا کر رہا ہوں یا فائدے کے لیے شیئر کر رہا ہوں؟"
• کیا یہ پوسٹ کرنا ضروری ہے؟
• کیا یہ دوسروں میں حسد پیدا کر سکتا ہے؟
• کیا میں یہ دیکھ کر ماشاءاللہ کہوں گا؟

۲۔ کیا کثرت سے شیئر نہ کریں:
• ہر کامیابی فوری طور پر
• مہنگی خریداری
• مسلسل چھٹیوں کی تصاویر
• بچوں کی تصاویر بہت زیادہ
• دولت اور عیش و آرام
• رشتے کی خوشی مسلسل
• کامیابی مکمل طور پر قائم ہونے سے پہلے

۳۔ کیا نجی رکھنا بہتر ہے:
• نئے رشتے (پہلے کچھ ماہ)
• حمل (پہلی سہ ماہی)
• کاروباری معاملات (حتمی ہونے تک)
• امتحان کے نتائج (تصدیق تک)
• نوکری کی پیشکش (تصدیق تک)
• بڑی خریداری (کاریں، مکانات) فوری طور پر
• ذاتی دعائیں اور عبادت

۴۔ محفوظ طریقے سے کیسے شیئر کریں:
• ہمیشہ اپنی پوسٹس کے ساتھ "ماشاءاللہ" لکھیں
• کیپشن میں اللہ کا شکر ادا کریں
• متاثر کرنے کے لیے نہیں بلکہ حوصلہ افزائی کے لیے شیئر کریں
• اپنے سامعین کو محدود کریں (صرف قریبی دوست)
• ہر نعمت شیئر نہ کریں
• نعمت قائم ہونے تک شیئر میں تاخیر کریں
• اللہ کا شکر عوامی طور پر ادا کریں

۵۔ والدین کے لیے بچوں کی پوسٹنگ:
• بچوں کی تصاویر محدود کریں
• روزانہ کی تازہ کاریاں شیئر نہ کریں
• پہلے 40 دن بچے کا چہرہ نجی رکھیں
• بیماری یا کمزور لمحات شیئر نہ کریں
• پرائیویسی کی ترتیبات فعال کریں
• جو آپ ظاہر کر رہے ہیں اس کا خیال رکھیں
• یاد رکھیں: آپ کا بچہ رضامندی نہیں دے سکتا

۶۔ علامات کہ آپ بہت زیادہ شیئر کر رہے ہیں:
• اگر لائکس نہ ملیں تو پریشان ہوتے ہیں
• آپ ہر کھانا، ہر لباس شیئر کرتے ہیں
• آپ دن میں کئی بار سٹیٹس اپ ڈیٹ کرتے ہیں
• آپ کو اپنی خوشی ثابت کرنے کی ضرورت محسوس ہوتی ہے
• کچھ خریدنے کے فوری بعد شیئر کرتے ہیں
• آن لائن دوسروں سے اپنی زندگی کا موازنہ کرتے ہیں

۷۔ پوسٹ کرنے کے بعد حفاظت:
اگر آپ نے کچھ شیئر کیا ہے:
• حفاظتی دعائیں پڑھیں
• "ماشاءاللہ لا قوۃ الا باللہ" کہیں
• اللہ کی حفاظت کی دعا کریں
• مشغولیت کو جنونی طور پر چیک نہ کریں
• یاد رکھیں کہ لائکس برکتیں نہیں ہیں

۸۔ دانشمندانہ نقطہ نظر:
• دوسروں کو فائدہ پہنچانے کے لیے شیئر کریں، فخر کے لیے نہیں
• عوامی طور پر سے زیادہ نجی طور پر شکر گزار رہیں
• یاد رکھیں اللہ پوسٹس کے بغیر بھی دیکھ سکتا ہے
• آپ کی حقیقی زندگی آن لائن زندگی سے زیادہ اہم ہے
• نعمتیں شکر سے بڑھتی ہیں، اظہار سے نہیں

نبوی حکمت:
نبی کریم ﷺ نے فرمایا: "اپنی ضرورتوں کو پورا کرنے میں رازداری سے مدد حاصل کرو، کیونکہ ہر نعمت والے پر حسد کیا جاتا ہے۔"

سوشل میڈیا کے لیے جدید دعا:
"اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْحَسَدِ وَالْعَيْنِ"
"اے اللہ، میں تیری پناہ مانگتا ہوں حسد اور نظر بد سے"

(آن لائن کچھ بھی پوسٹ کرنے کے بعد پڑھیں)

یاد رکھیں:
• ہر چیز شیئر کرنے کی ضرورت نہیں
• رازداری ایک نعمت ہے
• جتنا زیادہ اظہار کریں گے، اتنے زیادہ بے نقاب ہوں گے
• حقیقی اطمینان کو توثیق کی ضرورت نہیں
• اللہ کی رضا لوگوں کی لائکس سے زیادہ اہم ہے

عملی تجاویز:
۱۔ "Close Friends" فیچر استعمال کریں
۲۔ اجازت کے بغیر ٹیگنگ غیر فعال کریں
۳۔ باقاعدگی سے جائزہ لیں کہ آپ کی پوسٹس کون دیکھ سکتا ہے
۴۔ منصوبے ہونے سے پہلے ان کا اعلان نہ کریں
۵۔ پہلے نجی طور پر جشن منائیں، بعد میں شیئر کریں
۶۔ اگر آپ ہچکچاہٹ محسوس کریں تو پوسٹ نہ کریں
۷۔ یاد رکھیں: ایک بار پوسٹ کرنے کے بعد، یہ ہمیشہ کے لیے عوامی ہے

توازن:
• نعمتیں شیئر کرنا حرام نہیں
• لیکن حکمت اعتدال میں ہے
• اسلام ہمیں شکر گزار ہونا سکھاتا ہے، فخر نہیں
• حوصلہ افزائی اور مدد کے لیے شیئر کریں، دکھاوے کے لیے نہیں
• جب شک ہو تو نجی رکھیں''',
        'hindi': '''सोशल मीडिया के दौर में नज़र-ए-बद से बचाव

आज के डिजिटल दौर में, सोशल मीडिया ने हमें पहले से कहीं ज़्यादा नज़र-ए-बद के लिए कमज़ोर बना दिया है। जब आप अपनी नेमतें ऑनलाइन शेयर करते हैं तो हज़ारों उन्हें देख सकते हैं।

सोशल मीडिया के लिए रहनुमा उसूल:

१. पोस्ट करने से पहले सोचें:
• अपने आप से पूछें: "क्या मैं दिखावा कर रहा हूं या फ़ायदे के लिए शेयर कर रहा हूं?"
• क्या यह पोस्ट करना ज़रूरी है?
• क्या यह दूसरों में हसद पैदा कर सकता है?
• क्या मैं यह देखकर माशाअल्लाह कहूंगा?

२. क्या कसरत से शेयर न करें:
• हर कामयाबी फ़ौरन
• महंगी ख़रीदारी
• मुसलसल छुट्टियों की तस्वीरें
• बच्चों की तस्वीरें बहुत ज़्यादा
• दौलत और ऐश व आराम
• रिश्ते की ख़ुशी मुसलसल
• कामयाबी मुकम्मल तौर पर क़ायम होने से पहले

३. क्या निजी रखना बेहतर है:
• नए रिश्ते (पहले कुछ माह)
• हमल (पहली सह-माही)
• कारोबारी मुआमलात (हत्मी होने तक)
• इम्तेहान के नतीजे (तस्दीक़ तक)
• नौकरी की पेशकश (तस्दीक़ तक)
• बड़ी ख़रीदारी (कारें, मकान) फ़ौरी तौर पर
• ज़ाती दुआएं और इबादत

४. महफ़ूज़ तरीक़े से कैसे शेयर करें:
��� हमेशा अपनी पोस्ट्स के साथ "माशाअल्लाह" लिखें
• कैप्शन में अल्लाह का शुक्र अदा करें
• मुतास्सिर करने के लिए नहीं बल्कि हौसला अफ़ज़ाई के लिए शेयर करें
• अपने समईन को महदूद करें (सिर्फ़ क़रीबी दोस्त)
• हर नेमत शेयर न करें
• नेमत क़ायम होने तक शेयर में ताख़ीर करें
• अल्लाह का शुक्र अवामी तौर पर अदा करें

५. वालिदैन के लिए बच्चों की पोस्टिंग:
• बच्चों की तस्वीरें महदूद करें
• रोज़ाना की ताज़ा कारियां शेयर न करें
• पहले 40 दिन बच्चे का चेहरा निजी रखें
• बीमारी या कमज़ोर लम्हात शेयर न करें
• प्राइवेसी की तरतीबात फ़ेअल करें
• जो आप ज़ाहिर कर रहे हैं उसका ख़याल रखें
• याद रखें: आपका बच्चा रज़ामंदी नहीं दे सकता

६. अलामात कि आप बहुत ज़्यादा शेयर कर रहे हैं:
• अगर लाइक्स न मिलें तो परेशान होते हैं
• आप हर खाना, हर लिबास शेयर करते हैं
• आप दिन में कई बार स्टेटस अपडेट करते हैं
• आपको अपनी ख़ुशी साबित करने की ज़रूरत महसूस होती है
• कुछ ख़रीदने के फ़ौरी बाद शेयर करते हैं
• ऑनलाइन दूसरों से अपनी ज़िंदगी का मुवाज़ना करते हैं

७. पोस्ट करने के बाद हिफ़ाज़त:
अगर आपने कुछ शेयर किया है:
• हिफ़ाज़ती दुआएं पढ़ें
• "माशाअल्लाह ला क़ुव्वता इल्ला बिल्लाह" कहें
• अल्लाह की हिफ़ाज़त की दुआ करें
• मश्ग़ूलियत को जुनूनी तौर पर चेक न करें
• याद रखें कि लाइक्स बरकतें नहीं हैं

८. दानिशमंदाना नुक़्ता-ए-नज़र:
• दूसरों को फ़ायदा पहुंचाने के लिए शेयर करें, फ़ख़्र के लिए नहीं
• अवामी तौर पर से ज़्यादा निजी तौर पर शुक्रगुज़ार रहें
• याद रखें अल्लाह पोस्ट्स के बग़ैर भी देख सकता है
• आपकी हक़ीक़ी ज़िंदगी ऑनलाइन ज़िंदगी से ज़्यादा अहम है
• नेमतें शुक्र से बढ़ती हैं, इज़हार से नहीं

नबवी हिक्मत:
नबी करीम ﷺ ने फ़रमाया: "अपनी ज़रूरतों को पूरा करने में राज़दारी से मदद हासिल करो, क्योंकि हर नेमत वाले पर हसद किया जाता है।"

सोशल मीडिया के लिए जदीद दुआ:
"اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْحَسَدِ وَالْعَيْنِ"
"ऐ अल्लाह, मैं तेरी पनाह मांगता हूं हसद और नज़र-ए-बद से"

(ऑनलाइन कुछ भी पोस्ट करने के बाद पढ़ें)

याद रखें:
• हर चीज़ शेयर करने की ज़रूरत नहीं
• राज़दारी एक नेमत है
• जितना ज़्यादा इज़हार करेंगे, उतने ज़्यादा बे-नक़ाब होंगे
• हक़ीक़ी इत्मेनान को तस्दीक़ की ज़रूरत नहीं
• अल्लाह की रिज़ा लोगों की लाइक्स से ज़्यादा अहम है

अमली तजवीज़:
१. "Close Friends" फ़ीचर इस्तेमाल करें
२. इजाज़त के बग़ैर टैगिंग ग़ैर-फ़ेअल करें
३. बाक़ायदगी से जायज़ा लें कि आपकी पोस्ट्स कौन देख सकता है
४. मंसूबे होने से पहले उनका एलान न करें
५. पहले निजी तौर पर जशन मनाएं, बाद में शेयर करें
६. अगर आप हिचकिचाहट महसूस करें तो पोस्ट न करें
७. याद रखें: एक बार पोस्ट करने के बाद, यह हमेशा के लिए अवामी है

तवाज़ुन:
• नेमतें शेयर करना हराम नहीं
• लेकिन हिक्मत एतेदाल में है
• इस्लाम हमें शुक्रगुज़ार होना सिखाता है, फ़ख़्र नहीं
• हौसला अफ़ज़ाई और मदद के लिए शेयर करें, दिखावे के लिए नहीं
• जब शक हो तो निजी रखें''',
        'arabic': '''الحماية من العين في عصر وسائل التواصل الاجتماعي

في العصر الرقمي اليوم، جعلتنا وسائل التواصل الاجتماعي أكثر عرضة للعين من أي وقت مضى. عندما تشارك نعمك عبر الإنترنت، يمكن للآلاف رؤيتها.

إرشادات لوسائل التواصل:

١. فكّر قبل النشر:
• اسأل نفسك: "هل أتفاخر أم أشارك للفائدة؟"
• هل من الضروري نشر هذا؟
• هل يمكن أن يسبب هذا الحسد في الآخرين؟
• هل سأقول ما شاء الله إذا رأيت هذا؟

٢. ما لا يجب مشاركته بكثرة:
• كل إنجاز فوراً
• المشتريات الباهظة
• صور العطلات المستمرة
• صور الأطفال بكثرة
• الثروة والرفاهيات
• سعادة العلاقة باستمرار
• النجاح قبل ترسيخه بالكامل

٣. ما الأفضل إبقاؤه خاصاً:
• العلاقات الجديدة (أول أشهر قليلة)
• الحمل (الفصل الأول)
• صفقات العمل (حتى الانتهاء)
• نتائج الامتحانات (حتى التحقق)
• عروض العمل (حتى التأكيد)
• المشتريات الكبرى (السيارات، المنازل) فوراً
• الأدعية الشخصية والعبادة

٤. كيفية المشاركة بأمان:
• اكتب دائماً "ما شاء الله" مع من��وراتك
• أشكر الله في التعليق
• شارك بنية الإلهام، ليس الإبهار
• حدد جمهورك (أصدقاء مقربون فقط)
• لا تشارك كل نعمة
• أخّر المشاركة حتى تثبت النعمة
• اشكر الله علناً

٥. للآباء الذين ينشرون عن الأطفال:
• حدد صور الأطفال
• لا تشارك التحديثات اليومية
• أبقِ وجه الطفل خاصاً أول 40 يوماً
• لا تشارك المرض أو اللحظات الضعيفة
• فعّل إعدادات الخصوصية
• كن واعياً لما تكشفه
• تذكر: طفلك لا يستطيع الموافقة

٦. علامات أنك تشارك كثيراً:
• تشعر بالقلق إن لم تحصل على إعجابات
• تشارك كل وجبة، كل لباس
• تحدّث الحالة عدة مرات يومياً
• تشعر بالحاجة لإثبات سعادتك
• تشارك فوراً بعد شراء شيء
• تقارن حياتك بالآخرين عبر الإنترنت

٧. الحماية بعد النشر:
إذا شاركت شيئاً:
• اقرأ أدعية الحماية
• قل "ما شاء الله لا قوة إلا بالله"
• ادع لحماية الله
• لا تفحص التفاعل بهوس
• تذكر أن الإعجابات ليست بركات

٨. النهج الحكيم:
• شارك لإفادة الآخرين، ليس للتفاخر
• كن ممتناً خصوصياً أكثر من علناً
• تذكر أن الله يرى حتى بدون منشورات
• حياتك الحقيقية أهم من حياتك على الإنترنت
• النعم تزداد بالشكر، ليس بالعرض

الحكمة النبوية:
قال النبي ﷺ: "استعينوا على إنجاح الحوائج بالكتمان، فإن كل ذي نعمة محسود"

دعاء حديث لوسائل التواصل:
"اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْحَسَدِ وَالْعَيْنِ"
"اللهم إني أعوذ بك من الحسد والعين"

(اقرأه بعد نشر أي شيء عبر الإنترنت)

تذكر:
• ليس كل شيء يحتاج للمشاركة
• الخصوصية نعمة
• كلما أظهرت أكثر، كلما كنت أكثر عرضة
• القناعة الحقيقية لا تحتاج تأكيداً
• رضا الله أهم من إعجابات الناس

نصائح عملية:
١. استخدم ميزة "الأصدقاء المقربين"
٢. عطّل الوسم بدون إذن
٣. راجع بانتظام من يمكنه رؤية منشوراتك
٤. لا تعلن عن الخطط قبل حدوثها
٥. احتفل خصوصياً أولاً، شارك لاحقاً
٦. إذا شعرت بالتردد، لا تنشر
٧. تذكر: بمجرد النشر، إنه عام إلى الأبد

التوازن:
• ليس حراماً مشاركة النعم
• لكن الحكمة في الاعتدال
• الإسلام يعلمنا أن نكون ممتنين، ليس متفاخرين
• شارك لتلهم وتساعد، ليس للتباهي
• عند الشك، أبقه خاصاً''',
      },
    },
    {
      'number': 10,
      'titleKey': 'nazar_e_bad_10_myths_vs_facts',
      'title': 'Myths vs Islamic Facts',
      'titleUrdu': 'توہمات بمقابلہ اسلامی حقائق',
      'titleHindi': 'तवह्हुमात बनाम इस्लामी हक़ाइक़',
      'titleArabic': 'الخرافات مقابل الحقائق الإسلامية',
      'icon': Icons.fact_check,
      'color': Colors.deepPurple,
      'details': {
        'english': '''Evil Eye: Myths vs Islamic Facts

Let's separate cultural myths from authentic Islamic teachings:

MYTH 1: Blue eye charms protect from evil eye
FACT: Only Allah protects. Wearing blue eye charms is shirk (associating partners with Allah). The Prophet ﷺ said: "Whoever wears an amulet has committed shirk." Protection comes from Quran, Dua, and trust in Allah alone.

MYTH 2: Burning chilies or alum removes evil eye
FACT: These are cultural superstitions with no basis in Islam. Treatment is through Ruqyah (Quranic recitation), Dua, and Wudu water of the one who gave evil eye.

MYTH 3: Only jealous people give evil eye
FACT: Even loving people can give evil eye unintentionally. The Prophet ﷺ said evil eye is real and can happen even from those who love you. That's why we say MashaAllah.

MYTH 4: Evil eye only affects beautiful people
FACT: Evil eye can affect anyone with any blessing - health, wealth, children, job, home, car, relationships. Any blessing can be subject to evil eye.

MYTH 5: Putting black dot on babies prevents evil eye
FACT: This is a Hindu cultural practice, not Islamic. Islamic protection is through Quranic recitation and duas taught by the Prophet ﷺ.

MYTH 6: Taking someone's name and burning it removes their evil eye
FACT: These black magic practices are completely haram. Islam teaches pure methods: Quran, Dua, and if needed, Wudu water from the person.

MYTH 7: Animals (like peacock feathers) can ward off evil eye
FACT: Only Allah can protect. Relying on objects for protection is shirk. The Prophet ﷺ taught us specific duas and Quranic verses for protection.

MYTH 8: If you don't know who gave evil eye, you can't remove it
FACT: You can perform Ruqyah on yourself or have someone recite for you. Allah's help is not dependent on knowing the source.

MYTH 9: Reading backwards or upside down removes evil eye
FACT: These are innovations (bid'ah) and have no basis in Islam. Follow only the Sunnah way: Quranic recitation in the proper manner.

MYTH 10: You need a special sheikh or pir to remove evil eye
FACT: Anyone can recite Ruqyah. You can do it yourself. The Quran is for everyone, not just special people. The Prophet ﷺ taught Ruqyah to all companions.

MYTH 11: Evil eye cannot be prevented, only cured
FACT: Prevention is very much possible and emphasized. Daily morning/evening adhkar, MashaAllah when admiring, protective duas, and humility prevent evil eye.

MYTH 12: If someone praises you, they definitely gave you evil eye
FACT: Not every praise results in evil eye. People can genuinely appreciate without harming. Say MashaAllah and don't be paranoid.

MYTH 13: Evil eye is just psychological
FACT: Evil eye is REAL as confirmed by authentic Hadith. The Prophet ﷺ said: "The evil eye is real and if anything were to overtake divine decree, it would be evil eye."

MYTH 14: You need to confront the person who gave evil eye
FACT: Islam teaches better manners. If you know who it is, politely ask them to perform Wudu and use that water. No need for confrontation.

MYTH 15: Hanging horseshoes or evil eye beads protect homes
FACT: These are shirk. Protect your home through: Surah Al-Baqarah recitation, morning/evening adhkar, avoiding display of blessings, and regular Quran recitation.

AUTHENTIC ISLAMIC PROTECTION:
1. Daily Adhkar (Morning & Evening)
2. Saying "MashaAllah la quwwata illa billah"
3. Ayatul Kursi after every prayer
4. Three Quls (Ikhlas, Falaq, Naas) 3 times morning/evening
5. Last two verses of Surah Al-Baqarah before sleep
6. Trusting in Allah alone
7. Being humble about blessings
8. Teaching children protective duas
9. Reciting over water and drinking
10. Regular Quran recitation in home

Remember:
• Islam provides complete protection
• No need for cultural additions
• Stick to Quran and Sunnah
• Don't mix truth with falsehood
• Beware of innovations in religion
• Allah's protection is the best protection

The Prophet ﷺ said: "Whoever among you sees something in himself or his wealth or his brother that he likes, let him invoke blessings for it, for the evil eye is real."''',
        'urdu': '''نظر بد: توہمات بمقابلہ اسلامی حقائق

آئیے ثقافتی توہمات کو مستند اسلامی تعلیما�� سے الگ کریں:

توہم 1: نیلی آنکھ کی تعویذات نظر بد سے بچاتی ہیں
حقیقت: صرف اللہ ہی حفاظت کرتا ہے۔ نیلی آنکھ کی تعویذات پہننا شرک ہے۔ نبی کریم ﷺ نے فرمایا: "جس نے تعویذ پہنا اس نے شرک کیا۔" حفاظت قرآن، دعا اور صرف اللہ پر بھروسے سے آتی ہے۔

توہم 2: مرچیں یا پھٹکڑی جلانے سے نظر بد دور ہوتی ہے
حقیقت: یہ ثقافتی توہمات ہیں جن کی اسلام میں کوئی بنیاد نہیں۔ علاج رقیہ (قرآنی تلاوت)، دعا، اور نظر لگانے والے کے وضو کے پانی سے ہے۔

توہم 3: صرف حاسد لوگ نظر لگاتے ہیں
حقیقت: محبت کرنے والے بھی غیر ارادی طور پر نظر لگا سکتے ہیں۔ نبی کریم ﷺ نے فرمایا نظر بد حقیقت ہے اور یہ ان لوگوں سے بھی ہو سکتی ہے جو آپ سے محبت کرتے ہیں۔ اسی لیے ہم ماشاءاللہ کہتے ہیں۔

توہم 4: نظر بد صرف خوبصورت لوگوں کو متاثر کرتی ہے
حقیقت: نظر بد کسی بھی نعمت کے ساتھ کسی کو بھی متاثر کر سکتی ہے - صحت، دولت، بچے، نوکری، گھر، کار، رشتے۔ کوئی بھی نعمت نظر بد کا موضوع ہو سکتی ہے۔

توہم 5: بچوں پر کالا ٹیکہ لگانا نظر بد سے بچاتا ہے
حقیقت: یہ ہندو ثقافتی رواج ہے، اسلامی نہیں۔ اسلامی حفاظت قرآنی تلاوت اور نبی کریم ﷺ کی سکھائی ہوئی دعاؤں سے ہے۔

توہم 6: کسی کا نام لے کر جلانے سے ان کی نظر دور ہوتی ہے
حقیقت: یہ کالے جادو کی حرام حرکات ہیں۔ اسلام خالص طریقے سکھاتا ہے: قرآن، دعا، اور اگر ضرورت ہو تو شخص کے وضو کا پانی۔

توہم 7: جانور (جیسے مور کے پر) نظر بد دور کر سکتے ہیں
حقیقت: صرف اللہ ہی حفاظت کر سکتا ہے۔ اشیاء پر حفاظت کے لیے بھروسہ کرنا شرک ہے۔ نبی کریم ﷺ نے ہمیں حفاظت کے لیے مخصوص دعائیں اور قرآنی آیات سکھائیں۔

توہم 8: اگر آپ کو نہیں معلوم کس نے نظر لگائی تو اسے دور نہیں کر سکتے
حقیقت: آپ خود پر رقیہ کر سکتے ہیں یا کسی سے پڑھوا سکتے ہیں۔ اللہ کی مدد ماخذ جاننے پر منحصر نہیں۔

توہم 9: الٹا یا اوندھا پڑھنا نظر بد دور کرتا ہے
حقیقت: یہ بدعات ہیں اور اسلام میں ان کی کوئی بنیاد نہیں۔ صرف سنت کے طریقے پر عمل کریں: صحیح طریقے سے قرآنی تلاوت۔

توہم 10: نظر بد دور کرنے کے لیے خاص شیخ یا پیر کی ضرورت ہے
حقیقت: کوئی بھی رقیہ پڑھ سکتا ہے۔ آپ خود کر سکتے ہیں۔ قرآن سب کے لیے ہے، صرف خاص لوگوں کے لیے نہیں۔ نبی کریم ﷺ نے تمام صحابہ کو رقیہ سکھایا۔

توہم 11: نظر بد سے بچاؤ ممکن نہیں، صرف علاج
حقیقت: بچاؤ بہت ممکن ہے اور زور دیا گیا ہے۔ روزانہ صبح و شام کے اذکار، تعریف کرتے وقت ماشاءاللہ، حفاظتی دعائیں، اور عاجزی نظر بد سے بچاتی ہے۔

توہم 12: اگر کوئی آپ کی تعریف کرے تو ضرور نظر لگائی
حقیقت: ہر تعریف نظر بد کا نتیجہ نہیں۔ لوگ بغیر نقصان کے حقیقی تعریف کر سکتے ہیں۔ ماشاءاللہ کہیں اور پاگل نہ ہوں۔

توہم 13: نظر بد صرف نفسیاتی ہے
حقیقت: نظر بد حقیقی ہے جیسا کہ صحیح احادیث سے ثابت ہے۔ نبی کریم ﷺ نے فرمایا: "نظر بد حق ہے اور اگر کوئی چیز تقدیر سے آگے نکل سکتی تو نظر بد ہوتی۔"

توہم 14: نظر لگانے والے شخص سے مقابلہ کرنا ضروری ہے
حقیقت: اسلام بہتر آداب سکھاتا ہے۔ اگر آپ کو معلوم ہو تو شائستگی سے ان سے وضو کرنے کو کہیں اور وہ پانی استعمال کریں۔ مقابلے کی ضرورت نہیں۔

توہم 15: گھوڑے کی نال یا نظر بد کے موتی گھروں کی حفاظت کرتے ہیں
حقیقت: یہ شرک ہے۔ اپنے گھر کی حفاظت یوں کریں: سورۃ البقرہ کی تلاوت، صبح و شام کے اذکار، نعمتوں کے اظہار سے بچنا، اور باقاعدہ قرآن کی تلاوت۔

مستند اسلامی حفاظت:
۱۔ روزانہ اذکار (صبح و شام)
۲۔ "ماشاءاللہ لا قوۃ الا باللہ" کہنا
۳۔ ہر نماز کے بعد آیت الکرسی
۴۔ تین قل (اخلاص، فلق، ناس) صبح/شام 3 بار
۵۔ سونے سے پہلے سورۃ البقرہ کی آخری دو آیات
۶۔ صرف اللہ پر بھروسہ
۷۔ نعمتوں کے بارے میں عاجز ہونا
۸۔ بچوں کو حفاظتی دعائیں سکھانا
۹۔ پانی پر پڑھ کر پینا
۱۰۔ گھر میں باقاعدہ قرآن کی تلاوت

یاد رکھیں:
• اسلام مکمل حفاظت فراہم کرتا ہے
• ثقافتی اضافوں کی ضرورت نہیں
• قرآن اور سنت پر قائم رہیں
• سچ کو جھوٹ سے نہ ملائیں
• دین میں بدعات سے بچیں
• اللہ کی حفاظت بہترین حفاظت ہے

نبی کریم ﷺ نے فرمایا: "تم میں سے جو شخص اپنے یا اپنے مال یا اپنے بھائی میں کوئی پسندیدہ چیز دیکھے تو اس کے لیے برکت کی دعا کرے، کیونکہ نظر بد حقیقت ہے۔"''',
        'hindi': '''नज़र-ए-बद: तवह्हुमात बनाम इस्लामी हक़ाइक़

आइए सक़ाफ़ती तवह्हुमात को मुस्तनद इस्लामी तालीमात से अलग करें:

तवह्हुम 1: नीली आंख की तावीज़ात नज़र-ए-बद से बचाती हैं
हक़ीक़त: सिर्फ़ अल्लाह ही हिफ़ाज़त करता है। नीली आंख की तावीज़ात पहनना शिर्क है। नबी करीम ﷺ ने फ़रमाया: "जिसने तावीज़ पहना उसने शिर्क किया।" हिफ़ाज़त क़ुरआन, दुआ और सिर्फ़ अल्लाह पर भरोसे से आती है।

तवह्हुम 2: मिर्चें या फ़िटकरी जलाने से नज़र-ए-बद दूर होती है
हक़ीक़त: यह सक़ाफ़ती तवह्हुमात हैं जिनकी इस्लाम में कोई बुनियाद नहीं। इलाज रुक़्या (क़ुरआनी तिलावत), दुआ, और नज़र लगाने वाले के वुज़ू के पानी से है।

तवह्हुम 3: सिर्फ़ हासिद लोग नज़र लगाते हैं
हक़ीक़त: मुहब्बत करने वाले भी ग़ैर-इरादी तौर पर नज़र लगा सकते हैं। नबी करीम ﷺ ने फ़रमाया नज़र-ए-बद हक़ीक़त है और यह उन लोगों से भी हो सकती है जो आपसे मुहब्बत करते हैं। इसी लिए हम माशाअल्लाह कहते हैं।

तवह्हुम 4: नज़र-ए-बद सिर्फ़ ख़ूबसूरत लोगों को मुतास्सिर करती है
हक़ीक़त: नज़र-ए-बद किसी भी नेमत के साथ किसी को भी मुतास्सिर कर सकती है - सेहत, दौलत, बच्चे, नौकरी, घर, कार, रिश्ते। कोई भी नेमत नज़र-ए-बद का मौज़ू हो सकती है।

तवह्हुम 5: बच्चों पर काला टीका लगाना नज़र-ए-बद से बचाता है
हक़ीक़त: यह हिंदू सक़ाफ़ती रिवाज है, इस्लामी नहीं। इस्लामी हिफ़ाज़त क़ुरआनी तिलावत और नबी करीम ﷺ की सिखाई हुई दुआओं से है।

तवह्हुम 6: किसी का नाम लेकर जलाने से उनकी नज़र दूर होती है
हक़ीक़त: यह काले जादू की हराम हरकतें हैं। इस्लाम ख़ालिस तरीक़े सिखाता है: क़ुरआन, दुआ, और अगर ज़रूरत हो तो शख़्स के वुज़ू का पानी।

तवह्हुम 7: जानवर (जैसे मोर के पर) नज़र-ए-बद दूर कर सकते हैं
हक़ीक़त: सिर्फ़ अल्लाह ही हिफ़ाज़त कर सकता है। अश्या पर हिफ़ाज़त के लिए भरोसा करना शिर्क है। नबी करीम ﷺ ने हमें हिफ़ाज़त के लिए मख़सूस दुआएं और क़ुरआनी आयात सिखाईं।

तवह्हुम 8: अगर आपको नहीं मालूम किसने नज़र लगाई तो उसे दूर नहीं कर सकते
हक़ीक़त: आप ख़ुद पर रुक़्या कर सकते हैं या किसी से पढ़वा सकते हैं। अल्लाह की मदद माख़ज़ जानने पर मुन्हसिर नहीं।

तवह्हुम 9: उल्टा या औंधा पढ़ना नज़र-ए-बद दूर करता है
हक़ीक़त: यह बिदआत हैं और इस्लाम में इनकी कोई बुनियाद नहीं। सिर्फ़ सुन्नत के तरीक़े पर अमल करें: सही तरीक़े से क़ुरआनी तिलावत।

तवह्हुम 10: नज़र-ए-बद दूर करने के लिए ख़ास शैख़ या पीर की ज़रूरत है
हक़ीक़त: कोई भी रुक़्या पढ़ सकता है। आप ख़ुद कर सकते हैं। क़ुरआन सब के लिए है, सिर्फ़ ख़ास लोगों के लिए नहीं। नबी करीम ﷺ ने तमाम सहाबा को रुक़्या सिखाया।

तवह्हुम 11: नज़र-ए-बद से बचाव मुमकिन नहीं, सिर्फ़ इलाज
हक़ीक़त: बचाव बहुत मुमकिन है और ज़ोर दिया गया है। रोज़ाना सुबह व शाम के अज़कार, तारीफ़ करते वक़्त माशाअल्लाह, हिफ़ाज़ती दुआएं, और आजिज़ी नज़र-ए-बद से बचाती है।

तवह्हुम 12: अगर कोई आपकी तारीफ़ करे तो ज़रूर नज़र लगाई
हक़ीक़त: हर तारीफ़ नज़र-ए-बद का नतीजा नहीं। लोग बग़ैर नुक़सान के हक़ीक़ी तारीफ़ कर सकते हैं। माशाअल्लाह कहें और पागल न हों।

तवह्हुम 13: नज़र-ए-बद सिर्फ़ नफ़्सियाती है
हक़ीक़त: नज़र-ए-बद हक़ीक़ी है जैसा कि सहीह हदीसों से साबित है। नबी करीम ﷺ ने फ़रमाया: "नज़र-ए-बद हक़ है और अगर कोई चीज़ तक़दीर से आगे निकल सकती तो नज़र-ए-बद होती।"

तवह्हुम 14: नज़र लगाने वाले शख़्स से मुक़ाबला करना ज़रूरी है
हक़ीक़त: इस्लाम बेहतर आदाब सिखाता है। अगर आपको मालूम हो तो शाइस्तगी से उनसे वुज़ू करने को कहें और वो पानी इस्तेमाल करें। मुक़ाबले की ज़रूरत नहीं।

तवह्हुम 15: घोड़े की नाल या नज़र-ए-बद के मोती घरों की हिफ़ाज़त करते हैं
हक़ीक़त: यह शिर्क है। अपने घर की हिफ़ाज़त यूं करें: सूरह अल-बक़रा की तिलावत, सुबह व शाम के अज़कार, नेमतों के इज़हार से बचना, और बाक़ायदा क़ुरआन की तिलावत।

मुस्तनद इस्लामी हिफ़ाज़त:
१. रोज़ाना अज़कार (सुबह व शाम)
२. "माशाअल्लाह ला क़ुव्वता इल्ला बिल्लाह" कहना
३. हर नमाज़ के बाद आयतुल कुर्सी
४. तीन क़ुल (इख़्लास, फ़लक़, नास) सुबह/शाम 3 बार
५. सोने से पहले सूरह अल-बक़रा की आख़िरी दो आयात
६. सिर्फ़ अल्लाह पर भरोसा
७. नेमतों के बारे में आजिज़ होना
८. बच्चों को हिफ़ाज़ती दुआएं सिखाना
९. पानी पर पढ़कर पीना
१०. घर में बाक़ायदा क़ुरआन की तिलावत

याद रखें:
• इस्लाम मुकम्मल हिफ़ाज़त फ़राहम करता है
• सक़ाफ़ती इज़ाफ़ों की ज़रूरत नहीं
• क़ुरआन और सुन्नत पर क़ायम रहें
• सच को झूठ से न मिलाएं
• दीन में बिदआत से बचें
• अल्लाह की हिफ़ाज़त बेहतरीन हिफ़ाज़त है

नबी करीम ﷺ ने फ़रमाया: "तुम में से जो शख़्स अपने या अपने माल या अपने भाई मे�� कोई पसंदीदा चीज़ देखे तो उसके लिए बरकत की दुआ करे, क्योंकि नज़र-ए-बद हक़ीक़त है।"''',
        'arabic': '''العين: الخرافات مقابل الحقائق الإسلامية

لنفصل بين الخرافات الثقافية والتعاليم الإسلامية الصحيحة:

خرافة 1: تمائم العين الزرقاء تحمي من العين
حقيقة: الله وحده يحمي. ارتداء تمائم العين الزرقاء شرك. قال النبي ﷺ: "من علق تميمة فقد أشرك." الحماية تأتي من القرآن والدعاء والتوكل على الله وحده.

خرافة 2: حرق الفلفل أو الشبة يزيل العين
حقيقة: هذه خرافات ثقافية لا أساس لها في الإسلام. العلاج يكون بالرقية الشرعية (تلاوة القرآن)، والدعاء، وماء وضوء من أصاب بالعين.

خرافة 3: فقط الحاسدون يصيبون بالعين
حقيقة: حتى المحبون يمكنهم الإصابة بالعين بدون قصد. قال النبي ﷺ إن العين حق ويمكن أن تحدث حتى من الذين يحبونك. لذلك نقول ما شاء الله.

خرافة 4: العين تصيب فقط الجميلين
حقيقة: العين يمكن أن تصيب أي شخص بأي نعمة - الصحة، المال، الأطفال، العمل، المنزل، السيارة، العلاقات. أي نعمة يمكن أن تكون موضوعاً للعين.

خرافة 5: وضع نقطة سوداء على الأطفال يمنع العين
حقيقة: هذه ممارسة ثقافية هندوسية، ليست إسلامية. الحماية الإسلامية من خلال تلاوة القرآن والأدعية التي علمها النبي ﷺ.

خرافة 6: أخذ اسم شخص وحرقه يزيل عينه
حقيقة: هذه ممارسات سحر أسود حرام تماماً. الإسلام يعلم الطرق النقية: القرآن، الدعاء، وإن لزم ماء وضوء الشخص.

خرافة 7: الحيوانات (مثل ريش الطاووس) يمكنها درء العين
حقيقة: الله وحده يمكنه الحماية. الاعتماد على الأشياء للحماية شرك. علمنا النبي ﷺ أدعية محددة وآيات قرآنية للحماية.

خرافة 8: إذا لم تعرف من أصابك بالعين، لا يمكنك إزالتها
حقيقة: يمكنك أداء الرقية على نفسك أو جعل شخص يقرأ عليك. مساعدة الله لا تعتمد على معرفة المصدر.

خرافة 9: القراءة بالمقلوب أو رأساً على عقب تزيل العين
حقيقة: هذه بدع ولا أساس لها في الإسلام. اتبع طريقة السنة فقط: تلاوة القرآن بالطريقة الصحيحة.

خرافة 10: تحتاج إلى شيخ أو ولي خاص لإزالة العين
حقيقة: أي شخص يمكنه قراءة الرقية. يمكنك القيام بها بنفسك. القرآن للجميع، ليس فقط للأشخاص الخاصين. علم النبي ﷺ الرقية لجميع الصحابة.

خرافة 11: لا يمكن منع العين، فقط علاجها
حقيقة: الوقاية ممكنة جداً ومؤكدة. أذكار الصباح والمساء اليومية، ما شاء الله عند الإعجاب، الأدعية الواقية، والتواضع تمنع العين.

خرافة 12: إذا مدحك أحد، فقد أصابك بالعين بالتأكيد
حقيقة: ليس كل مدح ينتج عنه عين. يمكن للناس التقدير الحقيقي دون أذى. قل ما شاء الله ولا تكن مصاباً بالوسواس.

خرافة 13: العين فقط نفسية
حقيقة: العين حقيقية كما أكدت الأحاديث الصحيحة. قال النبي ﷺ: "العين حق ولو كان شيء سابق القدر لسبقته العين."

خرافة 14: يجب مواجهة الشخص الذي أصاب بالعين
حقيقة: الإسلام يعلم آداباً أفضل. إذا كنت تعرف من هو، اطلب منه بأدب أن يتوضأ واستخدم ذلك الماء. لا حاجة للمواجهة.

خرافة 15: تعليق حدوات الخيل أو خرز العين يحمي المنازل
حقيقة: هذا شرك. احمِ منزلك من خلال: تلاوة سورة البقرة، أذكار الصباح والمساء، تجنب عرض النعم، وتلاوة القرآن المنتظمة.

الحماية الإسلامية الصحيحة:
١. الأذكار اليومية (صباحاً ومساءً)
٢. قول "ما شاء الله لا قوة إلا بالله"
٣. آية الكرسي بعد كل صلاة
٤. المعوذات الثلاث (الإخلاص، الفلق، الناس) 3 مرات صباحاً/مساءً
٥. آخر آيتين من سورة البقرة قبل النوم
٦. التوكل على الله وحده
٧. التواضع بشأن النعم
٨. تعليم الأطفال الأدعية الواقية
٩. القراءة على الماء وشربه
١٠. تلاوة القرآن المنتظمة في المنزل

تذكر:
• الإسلام يوفر حماية كاملة
• لا حاجة للإضافات الثقافية
• التزم بالقرآن والسنة
• لا تخلط الحق بالباطل
• احذر البدع في الدين
• حماية الله هي أفضل حماية

قال النبي ﷺ: "إذا رأى أحدكم من نفسه أو ماله أو من أخيه ما يعجبه فليدع بالبركة، فإن العين حق."''',
      },
    },
    {
      'number': 11,
      'titleKey': 'nazar_e_bad_11_quranic_verses',
      'title': 'Quranic Verses About Evil Eye',
      'titleUrdu': 'نظر بد کے بارے میں قرآنی آیات',
      'titleHindi': 'नज़र-ए-बद के बारे में क़ुरआनी आयात',
      'titleArabic': 'آيات قرآنية عن العين',
      'icon': Icons.menu_book_outlined,
      'color': Colors.indigo,
      'details': {
        'english': '''Quranic Verses About Evil Eye

The Quran addresses the evil eye in several verses, providing guidance and protection:

1. SURAH AL-FALAQ (113:5):
"وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ"
"And from the evil of an envier when he envies."

Explanation:
This verse is a direct reference to the evil eye. Allah commands us to seek refuge from the harm caused by the envious person. This shows that Hasad (envy) is the source of the evil eye. When someone envies another's blessings, it can result in harmful energy through their gaze.

Protection: Recite this Surah 3 times in morning and evening.

2. SURAH AL-QALAM (68:51):
"وَإِن يَكَادُ ٱلَّذِينَ كَفَرُوا۟ لَيُزۡلِقُونَكَ بِأَبۡصَـٰرِهِمۡ"
"And indeed, those who disbelieve would almost make you slip with their eyes."

Explanation:
This verse reveals that the disbelievers cast angry looks at the Prophet ﷺ to frighten him or intimidate him. The Arabic word "ليزلقونك" (to make you slip) indicates the power of harmful gazes. This verse is usually recited for protection from the evil eye.

3. SURAH YUSUF (12:67):
"وَقَالَ يَـٰبَنِىَّ لَا تَدْخُلُوا۟ مِن بَابٍۢ وَٰحِدٍۢ وَٱدْخُلُوا۟ مِنْ أَبْوَٰبٍۢ مُّتَفَرِّقَةٍۢ"
"And he said, 'O my sons, do not enter from one gate but enter from different gates.'"

Explanation:
Prophet Yaqub (Jacob) AS advised his sons to enter Egypt from different gates to avoid attracting the evil eye. His sons were handsome and strong, and he feared they would attract envy if they all entered together. This shows that taking precautions against evil eye is from the Sunnah of Prophets.

4. AYATUL KURSI (2:255):
"ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ..."
"Allah! There is no deity except Him, the Ever-Living, the Sustainer..."

Explanation:
While not specifically about evil eye, Ayatul Kursi is one of the most powerful verses for all-round protection. The Prophet ﷺ said whoever recites it after each prayer, nothing prevents them from entering Paradise except death.

Protection: Recite after every Salah and before sleep.

5. LAST TWO VERSES OF SURAH AL-BAQARAH (2:285-286):
"ءَامَنَ ٱلرَّسُولُ بِمَآ أُنزِلَ إِلَيْهِ مِن رَّبِّهِۦ..."
"The Messenger has believed in what was revealed to him from his Lord..."

Explanation:
These verses provide comprehensive protection. The Prophet ﷺ said: "Whoever recites the last two verses of Surah Al-Baqarah at night, they will suffice him."

SURAH AN-NAAS (114) - Complete Protection:
Seek refuge from all evil including evil eye by reciting this Surah.

How to Use These Verses:
1. Recite Al-Falaq, An-Naas, Al-Ikhlas 3 times after Fajr and Maghrib
2. Recite Ayatul Kursi after every prayer
3. Recite last 2 verses of Al-Baqarah before sleep
4. Blow into your hands after recitation and wipe over body
5. Recite over water and drink
6. Teach children to memorize these verses

Benefits:
• Complete protection from evil eye
• Spiritual strength and connection with Allah
• Peace of mind and tranquility
• Removal of anxiety and fear
• Barakah in daily life

Remember:
The Quran is our greatest weapon. Regular recitation creates a spiritual shield around us that no evil can penetrate.''',
        'urdu': '''نظر بد کے بارے میں قرآنی آیات

قرآن کئی آیات میں نظر بد کا ذکر کرتا ہے اور رہنمائی اور حفاظت فراہم کرتا ہے:

۱۔ سورۃ الفلق (113:5):
"وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ"
"اور حسد کرنے والے کے شر سے جب وہ حسد کرے۔"

تشریح:
یہ آیت نظر بد کا براہ راست حوالہ ہے۔ اللہ ہمیں حکم دیتا ہے کہ حاسد شخص کے نقصان سے پناہ مانگیں۔ یہ ظاہر کرتا ہے کہ حسد نظر بد کا منبع ہے۔ جب کوئی دوسرے کی نعمتوں پر حسد کرتا ہے تو یہ ان کی نظر کے ذریعے نقصان دہ توانائی کا نتیجہ بن سکتا ہے۔

حفاظت: صبح و شام اس سورہ کو 3 بار پڑھیں۔

۲۔ سورۃ القلم (68:51):
"وَإِن يَكَادُ ٱلَّذِينَ كَفَرُوا۟ لَيُزۡلِقُونَكَ بِأَبۡصَـٰرِهِمۡ"
"اور بے شک کافر آپ کو اپنی نگاہوں سے پھسلا دینے کے قریب تھے۔"

تشریح:
یہ آیت بتاتی ہے کہ کافروں نے نبی کریم ﷺ پر غصے کی نظریں ڈالیں تاکہ آپ کو ڈرائیں یا دھمکائیں۔ عربی لفظ "ليزلقونك" (آپ کو پھسلانا) نقصان دہ نظروں کی طاقت کی نشاندہی کرتا ہے۔ یہ آیت عام طور پر نظر بد سے حفاظت کے لیے پڑھی جاتی ہے۔

۳۔ سورۃ یوسف (12:67):
"وَقَالَ يَـٰبَنِىَّ لَا تَدْخُلُوا۟ مِن بَابٍۢ وَٰحِدٍۢ وَٱدْخُلُوا۟ مِنْ أَبْوَٰبٍۢ مُّتَفَرِّقَةٍۢ"
"اور انہوں نے کہا: اے میرے بیٹو! ایک دروازے سے داخل نہ ہونا بلکہ مختلف دروازوں سے داخل ہونا۔"

تشریح:
نبی یعقوب علیہ السلام نے اپنے بیٹوں کو مشورہ دیا کہ مصر میں مختلف دروازوں سے داخل ہوں تاکہ نظر بد سے بچیں۔ ان کے بیٹے خوبصورت اور طاقتور تھے اور انہیں خدشہ تھا کہ اگر سب ایک ساتھ داخل ہوئے تو حسد کا نشانہ بنیں گے۔ یہ ظاہر کرتا ہے کہ نظر بد سے احتیاط انبیاء کی سنت سے ہے۔

۴۔ آیت الکرسی (2:255):
"ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ..."
"اللہ، اس کے سوا کوئی معبود نہیں، وہ زندہ ہے، سب کا تھامنے والا..."

تشریح:
اگرچہ خاص طور پر نظر بد کے بارے میں نہیں، لیکن آیت الکرسی تمام قسم کی حفاظت کے لیے سب سے طاقتور آیات میں سے ایک ہے۔ نبی کریم ﷺ نے فرمایا جو اسے ہر نماز کے بعد پڑھے، موت کے علاوہ کوئی چیز اسے جنت میں داخل ہونے سے نہیں روکتی۔

حفاظت: ہر نماز کے بعد اور سونے سے پہلے پڑھیں۔

۵۔ سورۃ البقرہ کی آخری دو آیات (2:285-286):
"ءَامَنَ ٱلرَّسُولُ بِمَآ أُنزِلَ إِلَيْهِ مِن رَّبِّهِۦ..."
"رسول ایمان لائے اس پر جو ان کی طرف ان کے رب کی جانب سے نازل کیا گیا..."

تشریح:
یہ آیات جامع حفاظت فراہم کرتی ہیں۔ نبی کریم ﷺ نے فرمایا: "جو شخص رات کو سورۃ البقرہ کی آخری دو آیات پڑھے، وہ اس کے لیے کافی ہیں۔"

سورۃ الناس (114) - مکمل حفاظت:
اس سورہ کو پڑھ کر نظر بد سمیت تمام برائیوں سے پناہ مانگیں۔

ان آیات کو کیسے استعمال کریں:
۱۔ فجر اور مغرب کے بعد الفلق، الناس، الاخلاص 3 بار پڑھیں
۲۔ ہر نماز کے بعد آیت الکرسی پڑھیں
۳۔ سونے سے پہلے البقرہ کی آخری 2 آیات پڑھیں
۴۔ تلاوت کے بعد ہتھیلیوں میں پھونکیں اور جسم پر پھیریں
۵۔ پانی پر پڑھیں اور پئیں
۶۔ بچوں کو یہ آیات حفظ کرنا سکھائیں

فوائد:
• نظر بد سے مکمل حفاظت
• روحانی طاقت اور اللہ سے تعلق
• ذہنی سکون اور اطمینان
• پریشانی اور خوف کا خاتمہ
• روزمرہ زندگی میں برکت

یاد رکھیں:
قرآن ہمارا سب سے بڑا ہتھیار ہے۔ باقاعدہ تلاوت ہمارے گرد ایک روحانی ڈھال بناتی ہے جسے کوئی برائی نہیں توڑ سکتی۔''',
        'hindi': '''नज़र-ए-बद के बारे में क़ुरआनी आयात

क़ुरआन कई आयात में नज़र-ए-बद का ज़िक्र करता है और रहनुमाई और हिफ़ाज़त फ़राहम करता है:

१. सूरह अल-फ़लक़ (113:5):
"وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ"
"और हसद करने वाले के शर से जब वो हसद करे।"

तशरीह:
यह आयत नज़र-ए-बद का बराहे रास्त हवाला है। अल्लाह हमें हुक्म देता है कि हासिद शख़्स के नुक़सान से पनाह मांगें। यह ज़ाहिर करता है कि हसद नज़र-ए-बद का मंबा है। जब कोई दूसरे की नेमतों पर हसद करता है तो यह उनकी नज़र के ज़रिए नुक़सान देह तवानाई का नतीजा बन सकता है।

हिफ़ाज़त: सुबह व शाम इस सूरह को 3 बार पढ़ें।

२. सूरह अल-क़लम (68:51):
"وَإِن يَكَادُ ٱلَّذِينَ كَفَرُوا۟ لَيُزۡلِقُونَكَ بِأَبۡصَـٰرِهِمۡ"
"और बेशक काफ़िर आपको अपनी निगाहों से फिसला देने के क़रीब थे।"

तशरीह:
यह आयत बताती है कि काफ़िरों ने नबी करीम ﷺ पर ग़ुस्से की नज़रें डालीं ताकि आपको डराएं या धमकाएं। अरबी लफ़्ज़ "ليزلقونك" (आपको फिसलाना) नुक़सान देह नज़रों की ताक़त की निशानदेही करता है। यह आयत आम तौर पर नज़र-ए-बद से हिफ़ाज़त के लिए पढ़ी जाती है।

३. सूरह यूसुफ़ (12:67):
"وَقَالَ يَـٰبَنِىَّ لَا تَدْخُلُوا۟ مِن بَابٍۢ وَٰحِدٍۢ وَٱدْخُلُوا۟ مِنْ أَبْوَٰبٍۢ مُّتَفَرِّقَةٍۢ"
"और उन्होंने कहा: ऐ मेरे बेटो! एक दरवाज़े से दाख़िल न होना बल्कि मुख़्तलिफ़ दरवाज़ों से दाख़िल होना।"

तशरीह:
नबी याक़ूब अलैहिस्सलाम ने अपने बेटों को मशवरा दिया कि मिस्र में मुख़्तलिफ़ दरवाज़ों से दाख़िल हों ताकि नज़र-ए-बद से बचें। उनके बेटे ख़ूबसूरत और ताक़तवर थे और उन्हें अंदेशा था कि अगर सब एक साथ दाख़िल हुए तो हसद का निशाना बनेंगे। यह ज़ाहिर करता है कि नज़र-ए-बद से एहतियात अंबिया की सुन्नत से है।

४. आयतुल कुर्सी (2:255):
"ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ..."
"अल्लाह, उसके सिवा कोई माबूद नहीं, वो ज़िंदा है, सब का थामने वाला..."

तशरीह:
अगरचे ख़ास तौर पर नज़र-ए-बद के बारे में नहीं, लेकिन आयतुल कुर्सी तमाम क़िस्म की हिफ़ाज़त के लिए सब से ताक़तवर आयात में से एक है। नबी करीम ﷺ ने फ़रमाया जो इसे हर नमाज़ के बाद पढ़े, मौत के अलावा कोई चीज़ उसे जन्नत में दाख़िल होने से नहीं रोकती।

हिफ़ाज़त: हर नमाज़ के बाद और सोने से पहले पढ़ें।

५. सूरह अल-बक़रा की आख़िरी दो आयात (2:285-286):
"ءَامَنَ ٱلرَّسُولُ بِمَآ أُنزِلَ إِلَيْهِ مِن رَّبِّهِۦ..."
"रसूल ईमान लाए उस पर जो उनकी तरफ़ उनके रब की जानिब से नाज़िल किया गया..."

तशरीह:
यह आयात जामे हिफ़ाज़त फ़राहम करती हैं। नबी करीम ﷺ ने फ़रमाया: "जो शख़्स रात को सूरह अल-बक़रा की आख़िरी दो आयात पढ़े, वो उसके लिए काफ़ी हैं।"

सूरह अन-नास (114) - मुकम्मल हिफ़ाज़त:
इस सूरह को पढ़कर नज़र-ए-बद समेत तमाम बुराइयों से पनाह मांगें।

इन आयात को कैसे इस्तेमाल करें:
१. फ़ज्र और मग़रिब के बाद अल-फ़लक़, अन-नास, अल-इख़्लास 3 बार पढ़ें
२. हर नमाज़ के बाद आयतुल कुर्सी पढ़ें
३. सोने से पहले अल-बक़रा की आख़िरी 2 आयात पढ़ें
४. तिलावत के बाद हथेलियों में फूंकें और जिस्म पर फेरें
५. पानी पर पढ़ें और पिएं
६. बच्चों को यह आयात हिफ़्ज़ करना सिखाएं

फ़वाइद:
• नज़र-ए-बद से मुकम्मल हिफ़ाज़त
• रूहानी ताक़त और अल्लाह से ताल्लुक़
• ज़ेहनी सुकून और इत्मेनान
• परेशानी और ख़ौफ़ का ख़ात्मा
• रोज़मर्रा ज़िंदगी में बरकत

याद रखें:
क़ुरआन हमारा सब से बड़ा हथियार है। बाक़ायदा तिलावत हमारे गिर्द एक रूहानी ढाल बनाती है जिसे कोई बुराई नहीं तोड़ सकती।''',
        'arabic': '''آيات قرآنية عن العين (الحسد)

يتناول القرآن العين في عدة آيات، موفراً التوجيه والحماية:

١. سورة الفلق (113:5):
"وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ"
"ومن شر حاسد إذا حسد"

التفسير:
هذه الآية إشارة مباشرة للعين. يأمرنا الله أن نستعيذ من أذى الحاسد. هذا يُظهر أن الحسد هو مصدر العين. عندما يحسد شخص نعم الآخرين، يمكن أن ينتج عنه طاقة ضارة من خلال نظرته.

الحماية: اقرأ هذه السورة 3 مرات صباحاً ومساءً.

٢. سورة القلم (68:51):
"وَإِن يَكَادُ ٱلَّذِينَ كَفَرُوا۟ لَيُزۡلِقُونَكَ بِأَبۡصَـٰرِهِمۡ"
"وإن يكاد الذين كفروا ليزلقونك بأبصارهم"

التفسير:
تكشف هذه الآية أن الكفار ألقوا نظرات غاضبة على النبي ﷺ لتخويفه أو تهديده. الكلمة العربية "ليزلقونك" (ليجعلوك تزل) تشير إلى قوة النظرات الضارة. عادة ما تُقرأ هذه الآية للحماية من العين.

٣. سورة يوسف (12:67):
"وَقَالَ يَـٰبَنِىَّ لَا تَدْخُلُوا۟ مِن بَابٍۢ وَٰحِدٍۢ وَٱدْخُلُوا۟ مِنْ أَبْوَٰبٍۢ مُّتَفَرِّقَةٍۢ"
"وقال يا بني لا تدخلوا من باب واحد وادخلوا من أبواب متفرقة"

التفسير:
نصح النبي يعقوب عليه السلام أبناءه بدخول مصر من أبواب مختلفة لتجنب جذب العين. كان أبناؤه وسيمين وأقوياء، وخشي أن يجذبوا الحسد إذا دخلوا جميعاً معاً. هذا يُظهر أن اتخاذ الاحتياطات ضد العين من سنة الأنبياء.

٤. آية الكرسي (2:255):
"ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ..."
"الله لا إله إلا هو الحي القيوم..."

التفسير:
رغم أنها ليست عن العين تحديداً، آية الكرسي من أقوى الآيات للحماية الشاملة. قال النبي ﷺ من قرأها بعد كل صلاة، لا يمنعه من دخول الجنة إلا الموت.

الحماية: اقرأها بعد كل صلاة وقبل النوم.

٥. آخر آيتين من سورة البقرة (2:285-286):
"ءَامَنَ ٱلرَّسُولُ بِمَآ أُنزِلَ إِلَيْهِ مِن رَّبِّهِۦ..."
"آمن الرسول بما أنزل إليه من ربه..."

التفسير:
توفر هذه الآيات حماية شاملة. قال النبي ﷺ: "من قرأ الآيتين الأخيرتين من سورة البقرة في ليلة كفتاه."

سورة الناس (114) - الحماية الكاملة:
استعذ من كل شر بما فيه العين بقراءة هذه السورة.

كيفية استخدام هذه الآيات:
١. اقرأ الفلق والناس والإخلاص 3 مرات بعد الفجر والمغرب
٢. اقرأ آية الكرسي بعد كل صلاة
٣. اقرأ آخر آيتين من البقرة قبل النوم
٤. انفث في يديك بعد القراءة وامسح جسمك
٥. اقرأ على الماء واشرب
٦. علّم الأطفال حفظ هذه الآيات

الفوائد:
• حماية كاملة من العين
• قوة روحية واتصال بالله
• سلام نفسي وطمأنينة
• إزالة القلق والخوف
• بركة في الحياة اليومية

تذكر:
القرآن سلاحنا الأعظم. التلاوة المنتظمة تخلق درعاً روحانياً حولنا لا يمكن لأي شر اختراقه.''',
      },
    },
    {
      'number': 12,
      'titleKey': 'nazar_e_bad_12_hasad_vs_nazar',
      'title': 'Hasad vs Nazar: The Difference',
      'titleUrdu': 'حسد بمقابلہ نظر: فرق',
      'titleHindi': 'हसद बनाम नज़र: फ़र्क़',
      'titleArabic': 'الحسد مقابل العين: الفرق',
      'icon': Icons.compare_arrows,
      'color': Colors.deepOrange,
      'details': {
        'english': '''Hasad vs Nazar: Understanding the Difference

Many people confuse Hasad (envy) and Nazar (evil eye), but they are distinct concepts in Islam:

HASAD (الحسد) - ENVY:

Definition:
Hasad is the internal feeling of jealousy and envy. It's wishing for the removal of a blessing from someone else, whether you want it for yourself or not.

Characteristics:
• It's a feeling in the heart
• It may or may not be expressed outwardly
• The person consciously wishes harm
• It's a major sin in Islam
• Can exist without manifestation

Islamic Ruling:
Hasad is HARAM (forbidden). The Prophet ﷺ said: "Beware of envy, for envy consumes good deeds just as fire consumes wood."

Quranic Reference:
"And from the evil of an envier when he envies." (Surah Al-Falaq 113:5)

Types of Hasad:
1. Harmful Hasad: Wishing blessing to be removed from others
2. Ghibtah (Good Envy): Wishing for similar blessings without wanting removal from others - This is permissible

NAZAR (النظر) - EVIL EYE:

Definition:
Nazar is the actual harm that occurs through a gaze, whether intentional or unintentional. It's the manifestation of envy or excessive admiration through the eyes.

Characteristics:
• It's an external action
• Can happen unintentionally
• Can come from loving people too
• Can even affect yourself
• Requires no conscious ill-will
• It's a reality, not a sin

Islamic Ruling:
Having evil eye is NOT a sin if unintentional. The sin is in the Hasad (envy) that may cause it.

Hadith Reference:
The Prophet ﷺ said: "The evil eye is real and if anything were to overtake divine decree, it would be the evil eye."

THE RELATIONSHIP:

Scholarly Opinion:
"Everyone who gives evil eye is envious, but not every envious person gives evil eye."

This means:
• Hasad is broader than Nazar
• Nazar can come from Hasad
• But Nazar can also come without Hasad (from admiration)
• Hasad is the internal emotion
• Nazar is the external effect

KEY DIFFERENCES:

1. Nature:
   Hasad = Internal feeling
   Nazar = External harm

2. Intentionality:
   Hasad = Always conscious
   Nazar = Can be unconscious

3. Sin:
   Hasad = Sinful
   Nazar = Not sinful if unintentional

4. Source:
   Hasad = Only from jealousy
   Nazar = From jealousy OR admiration

5. Scope:
   Hasad = Can remain hidden
   Nazar = Manifests as actual harm

6. Self-Effect:
   Hasad = Cannot harm yourself
   Nazar = Can affect yourself

EXAMPLES:

Example 1 - Hasad Only:
Someone sees your new car and feels jealous inside but doesn't look at it or say anything. This is Hasad without Nazar.

Example 2 - Nazar without Hasad:
A mother looks at her baby lovingly and says "So beautiful!" without saying MashaAllah. The baby gets sick. This is Nazar without Hasad.

Example 3 - Both Hasad and Nazar:
Someone sees your success, feels jealous, stares at you with envy, and you face problems. This is both Hasad and Nazar.

PROTECTION FROM BOTH:

From Hasad:
• Regular Adhkar
• Seeking refuge in Allah
• Good character
• Forgiving envious people
• Not displaying blessings

From Nazar:
• Saying MashaAllah
• Protective duas
• Ayatul Kursi
• Three Quls
• Ruqyah

TREATMENT:

For Hasad (The Envier):
• Seek forgiveness from Allah
• Increase in gratitude
• Remind yourself all is from Allah
• Be happy for others
• Work on self-improvement

For Nazar (The Affected):
• Perform Ruqyah
• Bath with Wudu water (if source known)
• Recite protective verses
• Have faith in Allah's protection

Remember:
Both Hasad and Nazar are real, but understanding the difference helps us protect ourselves and purify our hearts.''',
        'urdu': '''حسد بمقابلہ نظر: فرق کو سمجھنا

بہت سے لوگ حسد اور نظر میں غلط فہمی کرتے ہیں، لیکن یہ اسلام میں الگ تصورات ہیں:

حسد (الحسد) - رشک:

تعریف:
حسد رشک اور حسد کا اندرونی احساس ہے۔ یہ کسی اور سے نعمت کے ختم ہونے کی خواہش ہے، چاہے آپ اسے اپنے لیے چاہتے ہوں یا نہیں۔

خصوصیات:
• یہ دل میں احساس ہے
• یہ ظاہر ہو سکتا ہے یا نہیں
• شخص شعوری طور پر نقصان چاہتا ہے
• اسلام میں یہ کبیرہ گناہ ہے
• ظاہر ہوئے بغیر موجود ہو سکتا ہے

اسلامی حکم:
حسد حرام ہے۔ نبی کریم ﷺ نے فرمایا: "حسد سے بچو کیونکہ حسد نیکیوں کو ایسے کھا جاتا ہے جیسے آگ لکڑی کو۔"

قرآنی حوالہ:
"اور حسد کرنے والے کے شر سے جب وہ حسد کرے۔" (سورۃ الفلق 113:5)

حسد کی اقسام:
۱۔ نقصان دہ حسد: دوسروں سے نعمت ختم ہونے کی خواہش
۲۔ غبطہ (اچھا حسد): دوسروں سے ختم کرنے کی خواہش کے بغیر اسی طرح کی نعمتوں کی خواہش - یہ جائز ہے

نظر (النظر) - نظر بد:

تعریف:
نظر وہ حقیقی نقصان ہے جو نظر کے ذریعے ہوتا ہے، چاہے جان بوجھ کر ہو یا غیر ارادی۔ یہ آنکھوں کے ذریعے حسد یا زیادہ تعریف کا اظہار ہے۔

خصوصیات:
• یہ بیرونی عمل ہے
• غیر ارادی طور پر ہو سکتا ہے
• محبت کرنے والوں سے بھی آ سکتا ہے
• خود کو بھی متاثر کر سکتا ہے
• شعوری بدخواہی کی ضرورت نہیں
• یہ حقیقت ہے، گناہ نہیں

اسلامی حکم:
اگر غیر ارادی ہو تو نظر بد لگانا گناہ نہیں۔ گناہ حسد میں ہے جو اس کا سبب بن سکتا ہے۔

حدیث کا حوالہ:
نبی کریم ﷺ نے فرمایا: "نظر بد حق ہے اور اگر کوئی چیز تقدیر سے آگے نکل سکتی تو نظر بد ہوتی۔"

تعلق:

علمائے کرام کی رائے:
"ہر نظر لگانے والا حاسد ہے، لیکن ہر حاسد نظر نہیں لگاتا۔"

اس کا مطلب:
• حسد نظر سے وسیع تر ہے
• نظر حسد سے آ سکتی ہے
• لیکن نظر حسد کے بغیر بھی آ سکتی ہے (تعریف سے)
• حسد اندرونی جذبہ ہے
• نظر بیرونی اثر ہے

اہم فرق:

۱۔ نوعیت:
   حسد = اندرونی احساس
   نظر = بیرونی نقصان

۲۔ ارادیت:
   حسد = ہمیشہ شعوری
   نظر = غیر شعوری ہو سکتی ہے

۳۔ گناہ:
   حسد = گناہ
   نظر = غیر ارادی ہو تو گناہ نہیں

۴۔ ماخذ:
   حسد = صرف رشک سے
   نظر = رشک یا تعریف سے

۵۔ دائرہ کار:
   حسد = چھپا رہ سکتا ہے
   نظر = حقیقی نقصان کے طور پر ظاہر ہوتا ہے

۶۔ خود اثر:
   حسد = خود کو نقصان نہیں پہنچا سکتا
   نظر = خود کو متاثر کر سکتی ہے

مثالیں:

مثال ۱ - صرف حسد:
کوئی آپ کی نئی گاڑی دیکھتا ہے اور اندر سے حسد محسوس کرتا ہے لیکن نہ دیکھتا ہے نہ کچھ کہتا ہے۔ یہ نظر کے بغیر حسد ہے۔

مثال ۲ - حسد کے بغیر نظر:
ایک ماں اپنے بچے کو پیار سے دیکھتی ہے اور ماشاءاللہ کہے بغیر کہتی ہے "بہت خوبصورت!" بچہ بیمار ہو جاتا ہے۔ یہ حسد کے بغیر نظر ہے۔

مثال ۳ - حسد اور نظر دونوں:
کوئی آپ کی کامیابی دیکھتا ہے، حسد محسوس کرتا ہے، حسد کی نظر سے گھورتا ہے، اور آپ کو مسائل کا سامنا ہوتا ہے۔ یہ حسد اور نظر دونوں ہے۔

دونوں سے حفاظت:

حسد سے:
• باقاعدہ اذکار
• اللہ کی پناہ مانگنا
• اچھا کردار
• حاسدوں کو معاف کرنا
• نعمتوں کا اظہار نہ کرنا

نظر سے:
• ماشاءاللہ کہنا
• حفاظتی دعائیں
• آیت الکرسی
• تین قل
• رقیہ

علاج:

حسد کے لیے (حاسد):
• اللہ سے معافی مانگیں
• شکر میں اضافہ کریں
• یاد رکھیں سب کچھ اللہ کی طرف سے ہے
• دوسروں کے لیے خوش ہوں
• خود بہتری پر کام کریں

نظر کے لیے (متاثرہ):
• رقیہ کریں
• وضو کے پانی سے نہائیں (اگر ماخذ معلوم ہو)
• حفاظتی آیات پڑھیں
• اللہ کی حفاظت پر ایمان رکھیں

یاد رکھیں:
حسد اور نظر دونوں حقیقی ہیں، لیکن فرق کو سمجھنا ہمیں اپنی حفاظت اور دلوں کی پاکیزگی میں مدد کرتا ہے۔''',
        'hindi': '''हसद बनाम नज़र: फ़र्क़ को समझना

बहुत से लोग हसद और नज़र में ग़लत फ़हमी करते हैं, लेकिन यह इस्लाम में अलग तसव्वुरात हैं:

हसद (الحسد) - रश्क:

तारीफ़:
हसद रश्क और हसद का अंदरूनी अहसास है। यह किसी और से नेमत के ख़त्म होने की ख़्वाहिश है, चाहे आप उसे अपने लिए चाहते हों या नहीं।

ख़ुसूसियात:
• यह दिल में अहसास है
• यह ज़ाहिर हो सकता है या नहीं
• शख़्स शऊरी तौर पर नुक़सान चाहता है
• इस्लाम में यह कबीरा गुनाह है
• ज़ाहिर हुए बग़ैर मौजूद हो सकता है

इस्लामी हुक्म:
हसद हराम है। नबी करीम ﷺ ने फ़रमाया: "हसद से बचो क्योंकि हसद नेकियों को ऐसे खा जाता है जैसे आग लकड़ी को।"

क़ुरआनी हवाला:
"और हसद करने वाले के शर से जब वो हसद करे।" (सूरह अल-फ़लक़ 113:5)

हसद की क़िस्में:
१. नुक़सान देह हसद: दूसरों से नेमत ख़त्म होने की ख़्वाहिश
२. ग़िबता (अच्छा हसद): दूसरों से ख़त्म करने की ख़्वाहिश के बग़ैर इसी तरह की नेमतों की ख़्वाहिश - यह जायज़ है

नज़र (النظر) - नज़र-ए-बद:

तारीफ़:
नज़र वो हक़ीक़ी नुक़सान है जो नज़र के ज़रिए होता है, चाहे जान-बूझकर ��ो या ग़ैर-इरादी। यह आंखों के ज़रिए हसद या ज़्यादा तारीफ़ का इज़हार है।

ख़ुसूसियात:
• यह बैरूनी अमल है
• ग़ैर-इरादी तौर पर हो सकता है
• मुहब्बत करने वालों से भी आ सकता है
• ख़ुद को भी मुतास्सिर कर सकता है
• शऊरी बदख़्वाही की ज़रूरत नहीं
• यह हक़ीक़त है, गुनाह नहीं

इस्लामी हुक्म:
अगर ग़ैर-इरादी हो तो नज़र-ए-बद लगाना गुनाह नहीं। गुनाह हसद में है जो इसका सबब बन सकता है।

हदीस का हवाला:
नबी करीम ﷺ ने फ़रमाया: "नज़र-ए-बद हक़ है और अगर कोई चीज़ तक़दीर से आगे निकल सकती तो नज़र-ए-बद होती।"

ताल्लुक़:

उलेमा-ए-किराम की राय:
"हर नज़र लगाने वाला हासिद है, लेकिन हर हासिद नज़र नहीं लगाता।"

इसका मतलब:
• हसद नज़र से वसीअ तर है
• नज़र हसद से आ सकती है
• लेकिन नज़र हसद के बग़ैर भी आ सकती है (तारीफ़ से)
• हसद अंदरूनी जज़्बा है
• नज़र बैरूनी असर है

अहम फ़र्क़:

१. नौइयत:
   हसद = अंदरूनी अहसास
   नज़र = बैरूनी नुक़सान

२. इरादियत:
   हसद = हमेशा शऊरी
   नज़र = ग़ैर-शऊरी हो सकती है

३. गुनाह:
   हसद = गुनाह
   नज़र = ग़ैर-इरादी हो तो गुनाह नहीं

४. माख़ज़:
   हसद = सिर्फ़ रश्क से
   नज़र = रश्क या तारीफ़ से

५. दायरा-ए-कार:
   हसद = छुपा रह सकता है
   नज़र = हक़ीक़ी नुक़सान के तौर पर ज़ाहिर होता है

६. ख़ुद असर:
   हसद = ख़ुद को नुक़सान नहीं पहुंचा सकता
   नज़र = ख़ुद को मुतास्सिर कर सकती है

मिसालें:

मिसाल १ - सिर्फ़ हसद:
कोई आपकी नई गाड़ी देखता है और अंदर से हसद महसूस करता है लेकिन न देखता है न कुछ कहता है। यह नज़र के बग़ैर हसद है।

मिसाल २ - हसद के बग़ैर नज़र:
एक मां अपने बच्चे को प्यार से देखती है और माशाअल्लाह कहे बग़ैर कहती है "बहुत ख़ूबसूरत!" बच्चा बीमार हो जाता है। यह हसद के बग़ैर नज़र है।

मिसाल ३ - हसद और नज़र दोनों:
कोई आपकी कामयाबी देखता है, हसद महसूस करता है, हसद की नज़र से घूरता है, और आपको मसाइल का सामना होता है। यह हसद और नज़र दोनों है।

दोनों से हिफ़ाज़त:

हसद से:
• बाक़ायदा अज़कार
• अल्लाह की पनाह मांगना
• अच्छा किरदार
• हासिदों को माफ़ करना
• नेमतों का इज़हार न करना

नज़र से:
• माशाअल्लाह कहना
• हिफ़ाज़ती दुआएं
• आयतुल कुर्सी
• तीन क़ुल
• रुक़्या

इलाज:

हसद के लिए (हासिद):
• अल्लाह से माफ़ी मांगें
• शुक्र में इज़ाफ़ा करें
• याद रखें सब कुछ अल्लाह की तरफ़ से है
• दूसरों के लिए ख़ुश हों
• ख़ुद बेहतरी पर काम करें

नज़र के लिए (मुतास्सिर):
• रुक़्या करें
• वुज़ू के पानी से नहाएं (अगर माख़ज़ मालूम हो)
• हिफ़ाज़ती आयात पढ़ें
• अल्लाह की हिफ़ाज़त पर ईमान रखें

याद रखें:
हसद और नज़र दोनों हक़ीक़ी हैं, लेकिन फ़र्क़ को समझना हमें अपनी हिफ़ाज़त और दिलों की पाकीज़गी में मदद करता है।''',
        'arabic': '''الحسد مقابل العين: فهم الفرق

يخلط كثير من الناس بين الحسد والعين، لكنهما مفهومان مختلفان في الإسلام:

الحسد (الحسد) - الغيرة:

التعريف:
الحسد هو الشعور الداخلي بالغيرة والحسد. إنه تمني زوال النعمة عن شخص آخر، سواء أردتها لنفسك أم لا.

الخصائص:
• إنه شعور في القلب
• قد يُعبر عنه خارجياً أو لا
• الشخص يتمنى الضرر بوعي
• إنه ذنب كبير في الإسلام
• يمكن أن يوجد بدون ظهور

الحكم الشرعي:
الحسد حرام. قال النبي ﷺ: "إياكم والحسد فإن الحسد يأكل الحسنات كما تأكل النار الحطب."

المرجع القرآني:
"ومن شر حاسد إذا حسد." (سورة الفلق 113:5)

أنواع الحسد:
١. الحسد الضار: تمني زوال النعمة عن الآخرين
٢. الغبطة (الحسد الحسن): تمني نعم مماثلة بدون الرغبة في زوالها عن الآخرين - هذا جائز

العين (النظر) - العين الحاسدة:

التعريف:
العين هي الضرر الفعلي الذي يحدث من خلال النظرة، سواء كانت مقصودة أو غير مقصودة. إنها تجلي الحسد أو الإعجاب المفرط من خلال العينين.

الخصائص:
• إنها فعل خارجي
• يمكن أن تحدث بدون قصد
• يمكن أن تأتي من أشخاص محبين أيضاً
• يمكن أن تؤثر عليك نفسك
• لا تتطلب سوء نية واعية
• إنها حقيقة، ليست خطيئة

الحكم الشرعي:
الإصابة بالعين ليست خطيئة إذا كانت غير مقصودة. الخطيئة في الحسد الذي قد يسببها.

مرجع الحديث:
قال النبي ﷺ: "العين حق ولو كان شيء سابق القدر لسبقته العين."

العلاقة:

رأي العلماء:
"كل من يصيب بالعين حاسد، لكن ليس كل حاسد يصيب بالعين."

هذا يعني:
• الحسد أوسع من العين
• العين يمكن أن تأتي من الحسد
• لكن العين يمكن أن تأتي بدون حسد (من الإعجاب)
• الحسد هو العاطفة الداخلية
• العين هي التأثير الخارجي

الفروق الرئيسية:

١. الطبيعة:
   الحسد = شعور داخلي
   العين = ضرر خارجي

٢. القصدية:
   الحسد = دائماً واعي
   العين = يمكن أن تكون غير واعية

٣. الخطيئة:
   الحسد = خطيئة
   العين = ليست خطيئة إذا كانت غير مقصودة

٤. المصدر:
   الحسد = فقط من الغيرة
   العين = من الغيرة أو الإعجاب

٥. النطاق:
   الحسد = يمكن أن يبقى مخفياً
   العين = تظهر كضرر فعلي

٦. التأثير الذاتي:
   الحسد = لا يمكن أن يؤذيك نفسك
   العين = يمكن أن تؤثر عليك نفسك

أمثلة:

مثال ١ - الحسد فقط:
شخص يرى سيارتك الجديدة ويشعر بالغيرة داخلياً لكنه لا ينظر إليها أو يقول شيئاً. هذا حسد بدون عين.

مثال ٢ - العين بدون حسد:
أم تنظر إلى طفلها بمحبة وتقول "جميل جداً!" بدون قول ما شاء الله. يمرض الطفل. هذه عين بدون حسد.

مثال ٣ - الحسد والعين معاً:
شخص يرى نجاحك، يشعر بالغيرة، يحدق فيك بحسد، وتواجه مشاكل. هذا حسد وعين معاً.

الحماية من كليهما:

من الحسد:
• الأذكار المنتظمة
• الاستعاذة بالله
• الخلق الحسن
• مسامحة الحاسدين
• عدم إظهار النعم

من العين:
• قول ما شاء الله
• الأدعية الواقية
• آية الكرسي
• المعوذات الثلاث
• الرقية

العلاج:

للحسد (الحاسد):
• استغفر الله
• زد في الشكر
• تذكر أن كل شيء من الله
• كن سعيداً للآخرين
• اعمل على تحسين نفسك

للعين (المصاب):
• قم بالرقية
• اغتسل بماء الوضوء (إن عرفت المصدر)
• اقرأ الآيات الواقية
• آمن بحماية الله

تذكر:
الحسد والعين كلاهما حقيقيان، لكن فهم الفرق يساعدنا على حماية أنفسنا وتطهير قلوبنا.''',
      },
    },
    {
      'number': 13,
      'titleKey': 'nazar_e_bad_13_historical_perspective',
      'title': 'Historical Perspective in Islam',
      'titleUrdu': 'اسلام میں تاریخی تناظر',
      'titleHindi': 'इस्लाम में तारीख़ी तनाज़ुर',
      'titleArabic': 'المنظور التاريخي في الإسلام',
      'icon': Icons.history_edu,
      'color': Colors.brown,
      'details': {
        'english': '''Historical Perspective of Evil Eye in Islam

The concept of evil eye has deep historical roots in Islamic tradition and pre-Islamic cultures.

PRE-ISLAMIC ERA:

Ancient Belief:
The belief in evil eye dates back almost 5,000 years to Ancient Greece and Rome. Amulets to protect against evil eye have been found from these ancient civilizations.

Arabian Peninsula:
• Arabs in the Age of Ignorance (Jahiliyyah) believed in evil eye
• They thought some animals could also have evil eyes
• Blue-hued Eyes of Horus from Egypt evolved into nazar amulets
• Spread through Phoenicians, Assyrians, Greeks, Romans, and Ottomans

Jewish Tradition:
Followers of pre-Islamic religions, including Jews, believed in evil eye. It is said that Jews considered 99% of deaths to be caused by evil eye.

Semitic and Indo-Aryan People:
Before Arabs, Semitic and Indo-Aryan people held similar beliefs about evil eye.

ISLAMIC REVELATION:

Quranic Confirmation:
When Islam came, it confirmed the reality of evil eye as mentioned in:
• Surah Al-Falaq (113:5): "And from the evil of an envier when he envies"
• Surah Al-Qalam (68:51): About disbelievers trying to harm with their eyes

The Prophet's Teachings:
The Prophet Muhammad ﷺ clarified and purified the concept:
• Confirmed evil eye is real and powerful
• Removed superstitious practices
• Taught authentic Islamic protection methods
• Emphasized reliance on Allah alone

Prophet Ibrahim's Practice:
The Prophet ﷺ mentioned that Ibrahim (AS) used the same dua for protecting his sons Ismail and Ishaq, showing this protection has been from the time of early prophets.

Prophet Yaqub's Wisdom:
In Surah Yusuf, Allah mentions how Prophet Yaqub (AS) advised his sons to enter Egypt from different gates to avoid evil eye, showing Prophetic awareness and precaution.

HISTORICAL INCIDENTS:

The Prophet's Family:
The Prophet ﷺ regularly recited protective duas over his grandsons Hassan and Hussain (RA), teaching us the importance of protecting children.

Asma bint Umais (RA):
She came to the Prophet ﷺ saying the children of Ja'far were afflicted by evil eye and asked if she could recite Ruqyah. The Prophet ﷺ approved, confirming the treatment method.

The Tribe of Banu Amir:
There was a man from this tribe known for giving strong evil eye. The Prophet ﷺ dealt with this situation, establishing rules for treatment.

EVOLUTION OF UNDERSTANDING:

From Superstition to Faith:
Islam transformed the concept from:
• Pagan superstitions → Pure Tawhid (Monotheism)
• Charms and amulets → Quran and Dua
• Fear of creation → Trust in Creator
• Cultural practices → Sunnah methods

Scholarly Development:
Over centuries, Islamic scholars have:
• Written extensively on evil eye
• Classified types and effects
• Distinguished authentic from weak narrations
• Developed comprehensive treatment methods
• Separated cultural myths from Islamic facts

THE OTTOMAN ERA:

Nazar Boncuğu:
The blue eye amulet (nazar boncuğu) became widespread in Turkish culture. However, in 2021, Turkey's religious authority (Diyanet) clarified these amulets are not permissible in Islam.

MODERN UNDERSTANDING:

Contemporary Scholarship:
Modern Islamic scholars emphasize:
• Evil eye is real as per authentic Hadith
• Only Allah can protect
• Quranic protection is sufficient
• Avoid all forms of shirk (associating partners with Allah)
• Balance between belief and paranoia

Scientific Interest:
Some researchers have studied psychological and energy-related aspects, though Islamic position remains that it's a spiritual reality proven by revelation.

KEY HISTORICAL LESSONS:

1. Universal Phenomenon:
Evil eye was recognized across ancient civilizations, and Islam confirmed its reality.

2. Purification of Concept:
Islam removed superstitious elements and established authentic protection methods.

3. Prophetic Precedent:
Protection against evil eye has been practiced by Prophets throughout history.

4. Continuous Guidance:
The Islamic understanding has remained consistent from the Prophet's time to today.

5. Clear Distinction:
Islam clearly separates authentic practices from cultural innovations.

TIMELINE:

~3000 BCE: Ancient Greek and Roman evil eye beliefs
~1500 BCE: Eyes of Horus amulets in Egypt
Pre-610 CE: Arab Jahiliyyah practices
610-632 CE: Islamic revelation purifies the concept
7th Century: Prophet's teachings establish methods
8th-15th Century: Islamic scholars document extensively
Ottoman Era: Cultural practices spread
Modern Era: Scholarly clarification continues

CONCLUSION:

The historical perspective shows that:
• Evil eye is an ancient, universal belief
• Islam acknowledged its reality but purified the practice
• True protection comes only from Allah
• We have authentic methods from the Prophet ﷺ
• Cultural additions must be rejected

The continuity from prophets Ibrahim and Yaqub to Prophet Muhammad ﷺ shows this is not a new concept but an ancient truth clarified by Islamic revelation.

Remember: While evil eye is historically and islamically established, our protection lies in following authentic Quranic and Prophetic guidance, not cultural superstitions.''',
        'urdu': '''اسلام میں نظر بد کا تاریخی تناظر

نظر بد کا تصور اسلامی روایت اور قبل از اسلام ثقافتوں میں گہری تاریخی جڑیں رکھتا ہے۔

قبل از اسلام کا دور:

قدیم عقیدہ:
نظر بد کا عقیدہ تقریباً 5000 سال پرانا ہے جو قدیم یونان اور روم سے ملتا ہے۔ ان قدیم تہذیبوں سے نظر بد سے بچاؤ کے تعویذات ملے ہیں۔

جزیرہ نما عرب:
• جاہلیت کے دور میں عرب نظر بد پر یقین رکھتے تھے
• وہ سوچتے تھے کہ کچھ جانوروں میں بھی نظر بد ہو سکتی ہے
• مصر سے آنکھوں کے نیلے نشانات نظر کے تعویذات میں تبدیل ہوئے
• فونیقیوں، آشوریوں، یونانیوں، رومیوں اور عثمانیوں کے ذریعے پھیلے

یہودی روایت:
قبل از اسلام مذاہب کے پیروکار، بشمول یہود، نظر بد پر یقین رکھتے تھے۔ کہا جاتا ہے کہ یہودی 99% اموات کو نظر بد کا سبب سمجھتے تھے۔

سامی اور ہند آریائی لوگ:
عربوں سے پہلے، سامی اور ہند آریائی لوگ نظر بد کے بارے میں اسی طرح کے عقائد رکھتے تھے۔

اسلامی وحی:

قرآنی تصدیق:
جب اسلام آیا تو اس نے نظر بد کی حقیقت کی تصدیق کی جیسا کہ ذکر ہے:
• سورۃ الفلق (113:5): "اور حسد کرنے والے کے شر سے جب وہ حسد کرے"
• سورۃ القلم (68:51): کافروں کے اپنی نظروں سے نقصان پہنچانے کی کوشش کے بارے میں

نبی کریم ﷺ کی تعلیمات:
نبی کریم ﷺ نے اس تصور کو واضح اور پاک کیا:
• نظر بد کی حقیقت اور طاقت کی تصدیق کی
• توہم پرستی کے طریقے ختم کیے
• مستند اسلامی حفاظتی طریقے سکھائے
• صرف اللہ پر بھروسے پر زور دیا

نبی ابراہیم علیہ السلام کا طریقہ:
نبی کریم ﷺ نے بتایا کہ ابراہیم علیہ السلام اپنے بیٹوں اسماعیل اور اسحاق کی حفاظت کے لیے وہی دعا استعمال کرتے تھے، جو ظاہر کرتا ہے کہ یہ حفاظت ابتدائی انبیاء کے وقت سے ہے۔

نبی یعقوب علیہ السلام کی حکمت:
سورۃ یوسف میں اللہ نے ذکر کیا کہ نبی یعقوب علیہ السلام نے اپنے بیٹوں کو مشورہ دیا کہ مصر میں مختلف دروازوں سے داخل ہوں تاکہ نظر بد سے بچیں، جو نبوی شعور اور احتیاط کو ظاہر کرتا ہے۔

تاریخی واقعات:

نبی کریم ﷺ کا خاندان:
نبی کریم ﷺ باقاعدگی سے اپنے نواسوں حسن اور حسین رضی اللہ عنہما پر حفاظتی دعائیں پڑھتے تھے، جو ہمیں بچوں کی حفاظت کی اہمیت سکھاتا ہے۔

اسماء بنت عمیس رضی اللہ عنہا:
وہ نبی کریم ﷺ کے پاس آئیں اور کہا کہ جعفر کے بچوں کو نظر لگ گئی ہے اور پوچھا کہ کیا وہ دم کر سکتی ہیں۔ نبی کریم ﷺ نے منظوری دی، علاج کے طریقے کی تصدیق کرتے ہوئے۔

قبیلہ بنو عامر:
اس قبیلے میں ایک شخص تھا جو شدید نظر لگانے کے لیے مشہور تھا۔ نبی کریم ﷺ نے اس صورتحال سے نمٹا، علاج کے قوانین قائم کرتے ہوئے۔

فہم کا ارتقاء:

توہم سے ایمان تک:
اسلام نے تصور کو تبدیل کیا:
• کافرانہ توہمات → خالص توحید
• تعویذات → قرآن اور دعا
• مخلوق کا خوف → خالق پر بھروسہ
• ثقافتی طریقے → سنت کے طریقے

علمی ترقی:
صدیوں میں، اسلامی علماء نے:
• نظر بد پر وسیع پیمانے پر لکھا
• اقسام اور اثرات کی درجہ بندی کی
• مستند اور کمزور روایات کو الگ کیا
• جامع علاج کے طریقے تیار کیے
• ثقافتی افسانوں کو اسلامی حقائق سے الگ کیا

عثمانی دور:

نظر بونجوغو:
نیلی آنکھ کا تعویذ (نظر بونجوغو) ترکی ثقافت میں وسیع پیمانے پر پھیل گیا۔ تاہم، 2021 میں، ترکی کے مذہبی اتھارٹی (دیانت) نے واضح کیا کہ یہ تعویذات اسلام میں جائز نہیں۔

جدید فہم:

عصری علماء:
جدید اسلامی علماء زور دیتے ہیں:
• نظر بد صحیح احادیث کے مطابق حقیقی ہے
• صرف اللہ ہی حفاظت کر سکتا ہے
• قرآنی حفاظت کافی ہے
• شرک کی تمام شکلوں سے بچیں
• یقین اور پاگل پن میں توازن

سائنسی دلچسپی:
کچھ محققین نے نفسیاتی اور توانائی سے متعلق پہلوؤں کا مطالعہ کیا ہے، اگرچہ اسلامی موقف یہ ہے کہ یہ روحانی حقیقت ہے جو وحی سے ثابت ہے۔

اہم تاریخی اسباق:

۱۔ عالمگیر مظہر:
نظر بد کو قدیم تہذیبوں میں تسلیم کیا گیا، اور اسلام نے اس کی حقیقت کی تصدیق کی۔

۲۔ تصور کی پاکیزگی:
اسلام نے توہماتی عناصر کو ہٹایا اور مستند حفاظتی طریقے قائم کیے۔

۳۔ نبوی مثال:
نظر بد سے حفاظت پوری تاریخ میں انبیاء کے ذریعے کی گئی ہے۔

۴۔ مسلسل رہنمائی:
اسلامی فہم نبی کریم ﷺ کے وقت سے آج تک مستقل رہا ہے۔

۵۔ واضح فرق:
اسلام واضح طور پر مستند طریقوں کو ثقافتی بدعات سے الگ کرتا ہے۔

ٹائم لائن:

~3000 قبل مسیح: قدیم یونانی اور رومی نظر بد کے عقائد
~1500 قبل مسیح: مصر میں ہورس کی آنکھوں کے تعویذات
610 عیسوی سے پہلے: عرب جاہلیت کے طریقے
610-632 عیسوی: اسلامی وحی تصور کو پاک کرتی ہے
ساتویں صدی: نبی کریم ﷺ کی تعلیمات طریقے قائم کرتی ہیں
8-15ویں صدی: اسلامی علماء وسیع پیمانے پر دستاویز کرتے ہیں
عثمانی دور: ثقافتی طریقے پھیلتے ہیں
جدید دور: علمی وضاحت جاری ہے

نتیجہ:

تاریخی تناظر ظاہر کرتا ہے کہ:
• نظر بد ایک قدیم، عالمگیر عقیدہ ہے
• اسلام نے اس کی حقیقت کو تسلیم کیا لیکن عمل کو پاک کیا
• حقیقی حفاظت صرف اللہ سے آتی ہے
• ہمارے پاس نبی کریم ﷺ سے مستند طریقے ہیں
• ثقافتی اضافوں کو مسترد کرنا چاہیے

انبیاء ابراہیم اور یعقوب سے نبی محمد ﷺ تک کا تسلسل ظاہر کرتا ہے کہ یہ نیا تصور نہیں بلکہ ایک قدیم سچائی ہے جسے اسلامی وحی نے واضح کیا۔

یاد رکھیں: اگرچہ نظر بد تاریخی اور اسلامی طور پر قائم ہے، ہماری حفاظت مستند قرآنی اور نبوی رہنمائی کی پیروی میں ہے، نہ کہ ثقافتی توہ��ات میں۔''',
        'hindi': '''इस्लाम में नज़र-ए-बद का तारीख़ी तनाज़ुर

नज़र-ए-बद का तसव्वुर इस्लामी रिवायत और क़ब्ल अज़ इस्लाम सक़ाफ़तों में गहरी तारीख़ी जड़ें रखता है।

क़ब्ल अज़ इस्लाम का दौर:

क़दीम अक़ीदा:
नज़र-ए-बद का अक़ीदा तक़रीबन 5000 साल पुराना है जो क़दीम यूनान और रोम से मिलता है। इन क़दीम तहज़ीबों से नज़र-ए-बद से बचाव के तावीज़ मिले हैं।

जज़ीरा नुमा अरब:
• जाहिलियत के दौर में अरब नज़र-ए-बद पर यक़ीन रखते थे
• वो सोचते थे कि कुछ जानवरों में भी नज़र-ए-बद हो सकती है
• मिस्र से आंखों के नीले निशानात नज़र के तावीज़ात में तब्दील हुए
• फ़ोनिशियों, आशूरियों, यूनानियों, रोमियों और उस्मानियों के ज़रिए फैले

यहूदी रिवायत:
क़ब्ल अज़ इस्लाम मज़ाहिब के पैरोकार, बशमूल यहूद, नज़र-ए-बद पर यक़ीन रखते थे। कहा जाता है कि यहूदी 99% मौतों को नज़र-ए-बद का सबब समझते थे।

सामी और हिंद आर्य लोग:
अरबों से पहले, सामी और हिंद आर्य लोग नज़र-ए-बद के बारे में इसी तरह के अक़ाइद रखते थे।

इस्लामी वही:

क़ुरआनी तस्दीक़:
जब इस्लाम आया तो उसने नज़र-ए-बद की हक़ीक़त की तस्दीक़ की जैसा कि ज़िक्र है:
• सूरह अल-फ़लक़ (113:5): "और हसद करने वाले के शर से जब वो हसद करे"
• सूरह अल-क़लम (68:51): काफ़िरों के अपनी नज़रों से नुक़सान पहुंचाने की कोशिश के बारे में

नबी करीम ﷺ की तालीमात:
नबी करीम ﷺ ने इस तसव्वुर को वाज़ेह और पाक किया:
• नज़र-ए-बद की हक़ीक़त और ताक़त की तस्दीक़ की
• तवह्हुम परस्ती के तरीक़े ख़त्म किए
• मुस्तनद इस्लामी हिफ़ाज़ती तरीक़े सिखाए
• सिर्फ़ अल्लाह पर भरोसे पर ज़ोर दिया

नबी इब्राहीम अलैहिस्सलाम का तरीक़ा:
नबी करीम ﷺ ने बताया कि इब्राहीम अलैहिस्सलाम अपने बेटों इस्माइल और इसहाक़ की हिफ़ाज़त के लिए वही दुआ इस्तेमाल करते थे, जो ज़ाहिर करता है कि यह हिफ़ाज़त इब्तिदाई अंबिया के वक़्त से है।

नबी याक़ूब अलैहिस्सलाम की हिक्मत:
सूरह यूसुफ़ में अल्लाह ने ज़िक्र किया कि नबी याक़ूब अलैहिस्सलाम ने अपने बेटों को मशवरा दिया कि मिस्र में मुख़्तलिफ़ दरवाज़ों से दाख़िल हों ताकि नज़र-ए-बद से बचें, जो नबवी शऊर और एहतियात को ज़ाहिर करता है।

तारीख़ी वाक़ेआत:

नबी करीम ﷺ का ख़ानदान:
नबी करीम ﷺ बाक़ायदगी से अपने नवासों हसन और हुसैन रज़ियल्लाहु अन्हुमा पर हिफ़ाज़ती दुआएं पढ़ते थे, जो हमें बच्चों की हिफ़ाज़त की अहमियत सिखाता है।

असमा बिन्त उमैस रज़ियल्लाहु अन्हा:
वो नबी करीम ﷺ के पास आईं और कहा कि जाफ़र के बच्चों को नज़र लग गई है और पूछा कि क्या वो दम कर सकती हैं। नबी करीम ﷺ ने मंज़ूरी दी, इलाज के तरीक़े की तस्दीक़ करते हुए।

क़बीला बनू आमिर:
इस क़बीले में एक शख़्स था जो शदीद नज़र लगाने के लिए मशहूर था। नबी करीम ﷺ ने इस सूरतहाल से निपटा, इलाज के क़वानीन क़ायम करते हुए।

फ़हम का इर्तेक़ा:

तवह्हुम से ईमान तक:
इस्लाम ने तसव्वुर को तब्दील किया:
• काफ़िराना तवह्हुमात → ख़ालिस तौहीद
• तावीज़ात → क़ुरआन और दुआ
• मख़्लूक़ का ख़ौफ़ → ख़ालिक़ पर भरोसा
• सक़ाफ़ती तरीक़े → सुन्नत के तरीक़े

इल्मी तरक़्क़ी:
सदियों में, इस्लामी उलेमा ने:
• नज़र-ए-बद पर वसी पैमाने पर लिखा
• क़िस्मों और असरात की दर्जा बंदी की
• मुस्तनद और कमज़ोर रिवायात को अलग किया
• जामे इलाज के तरीक़े तैयार किए
• सक़ाफ़ती अफ़सानों को इस्लामी हक़ाइक़ से अलग किया

उस्मानी दौर:

नज़र बोंजुग़ो:
नीली आंख का तावीज़ (नज़र बोंजुग़ो) तुर्की सक़ाफ़त में वसी पैमाने पर फैल गया। ताहम, 2021 में, तुर्की के मज़हबी अथॉरिटी (दियानत) ने वाज़ेह किया कि यह तावीज़ात इस्लाम में जायज़ नहीं।

जदीद फ़हम:

असरी उलेमा:
जदीद इस्लामी उलेमा ज़ोर देते हैं:
• नज़र-ए-बद सहीह हदीसों के मुताबिक़ हक़ीक़ी है
• सिर्फ़ अल्लाह ही हिफ़ाज़त कर सकता है
• क़ुरआनी हिफ़ाज़त काफ़ी है
• शिर्क की तमाम शक्लों से बचें
• यक़ीन और पागलपन में तवाज़ुन

साइंसी दिलचस्पी:
कुछ मुहक़्क़िक़ीन ने नफ़्सियाती और तवानाई से मुताल्लिक़ पहलुओं का मुतालआ किया है, अगरचे इस्लामी मौक़िफ़ यह है कि यह रूहानी हक़ीक़त है जो वही से साबित है।

अहम तारीख़ी सबक़:

१. आलमगीर मज़हर:
नज़र-ए-बद को क़दीम तहज़ीबों में तस्लीम किया गया, और इस्लाम ने इसकी हक़ीक़त की तस्दीक़ की।

२. तसव्वुर की पाकीज़गी:
इस्लाम ने तवह्हुमाती अनासिर को हटाया और मुस्तनद हिफ़ाज़ती तरीक़े क़ायम किए।

३. नबवी मिसाल:
नज़र-ए-बद से हिफ़ाज़त पूरी तारीख़ में अंबिया के ज़रिए की गई है।

४. मुसलसल रहनुमाई:
इस्लामी फ़हम नबी करीम ﷺ के वक़्त से आज तक मुस्तक़िल रहा है।

५. वाज़ेह फ़र्क़:
इस्लाम वाज़ेह तौर पर मुस्तनद तरीक़ों को सक़ाफ़ती बिदआत से अलग करता है।

टाइम लाइन:

~3000 क़ब्ल मसीह: क़दीम यूनानी और रोमी नज़र-ए-बद के अक़ाइद
~1500 क़ब्ल मसीह: मिस्र में हूरस की आंखों के तावीज़ात
610 ईसवी से पहले: अरब जाहिलियत के तरीक़े
610-632 ईसवी: इस्लामी वही तसव्वुर को पाक करती है
सातवीं सदी: नबी करीम ﷺ की तालीमात तरीक़े क़ायम करती हैं
8-15वीं सदी: इस्लामी उलेमा वसी पैमाने पर दस्तावेज़ करते हैं
उस्मानी दौर: सक़ाफ़ती तरीक़े फैलते हैं
जदीद दौर: इल्मी वज़ाहत जारी है

नतीजा:

तारीख़ी तनाज़ुर ज़ाहिर करता है कि:
• नज़र-ए-बद एक क़दीम, आलमगीर अक़ीदा है
• इस्लाम ने इसकी हक़ीक़त को तस्लीम किया लेकिन अमल को पाक किया
• हक़ीक़ी हिफ़ाज़त सिर्फ़ अल्लाह से आती है
• हमारे पास नबी करीम ﷺ से मुस्तनद तरीक़े हैं
• सक़ाफ़ती इज़ाफ़ों को मुस्तरद करना चाहिए

अंबिया इब्राहीम और याक़ूब से नबी मुहम्मद ﷺ तक का तसलसुल ज़ाहिर करता है कि यह नया तसव्वुर नहीं बल्कि एक क़दीम सच्चाई है जिसे इस्लामी वही ने वाज़ेह किया।

याद रखें: अगरचे नज़र-ए-बद तारीख़ी और इस्लामी तौर पर क़ायम है, हमारी हिफ़ाज़त मुस्तनद क़ुरआनी और नबवी रहनुमाई की पैरवी में है, न कि सक़ाफ़ती तवह्हुमात में۔''',
        'arabic': '''المنظور التاريخي للعين (الحسد) في الإسلام

مفهوم العين له جذور تاريخية عميقة في التقليد الإسلامي والثقافات السابقة للإسلام۔

الحقبة السابقة للإسلام:

الاعتقاد القديم:
الاعتقاد في العين يعود تقريباً 5000 سنة إلى اليونان القديمة وروما۔ تم العثور على تمائم للحماية من العين من هذه الحضارات القديمة۔

شبه الجزيرة العربية:
• العرب في عصر الجاهلية آمنوا بالعين
• اعتقدوا أن بعض الحيوانات يمكن أن يكون لها عيون شريرة أيضاً
• عيون حورس الزرقاء من مصر تطورت إلى تمائم نظر
• انتشرت عبر الفينيقيين والآشوريين واليونانيين والرومان والعثمانيين

التقليد اليهودي:
أتباع الأديان السابقة للإسلام، بما في ذلك اليهود، آمنوا بالعين۔ يُقال إن اليهود اعتبروا 99% من الوفيات ناتجة عن العين۔

الشعوب السامية والهندو-آرية:
قبل العرب، الشعوب السامية والهندو-آرية كانت لديهم معتقدات مماثلة حول العين۔

الوحي الإسلامي:

التأكيد القرآني:
عندما جاء الإسلام، أكد حقيقة العين كما ورد في:
• سورة الفلق (113:5): "ومن شر حاسد إذا حسد"
• سورة القلم (68:51): عن الكفار الذين يحاولون الأذى بأعينهم

تعاليم النبي:
النبي محمد ﷺ أوضح ونقّى المفهوم:
• أكد أن العين حقيقية وقوية
• أزال الممارسات الخرافية
• علّم طرق الحماية الإسلامية الأصيلة
• أكد على الاعتماد على الله وحده

ممارسة النبي إبراهيم:
ذكر النبي ﷺ أن إبراهيم عليه السلام استخدم نفس الدعاء لحماية ابنيه إسماعيل وإسحاق، مما يُظهر أن هذه الحماية كانت منذ زمن الأنبياء الأوائل۔

حكمة النبي يعقوب:
في سورة يوسف، يذكر الله كيف نصح النبي يعقوب عليه السلام أبناءه بدخول مصر من أبواب مختلفة لتجنب العين، مما يُظهر الوعي والحذر النبوي۔

الأحداث التاريخية:

عائلة النبي:
النبي ﷺ كان يقرأ بانتظام الأدعية الواقية على حفيديه الحسن والحسين رضي الله عنهما، مما يعلمنا أهمية حماية الأطفال۔

أسماء بنت عميس رضي الله عنها:
جاءت إلى النبي ﷺ قائلة إن أطفال جعفر أصيبوا بالعين وسألت إن كانت تستطيع قراءة الرقية۔ النبي ﷺ وافق، مؤكداً طريقة العلاج۔

قبيلة بني عامر:
كان هناك رجل من هذه القبيلة معروف بإصابته بالعين القوية۔ النبي ﷺ تعامل مع هذا الموقف، مؤسساً قواعد العلاج۔

تطور الفهم:

من الخرافة إلى الإيمان:
الإسلام حوّل المفهوم من:
• الخرافات الوثنية ← التوحيد النقي
• التمائم والأحجبة ← القرآن والدعاء
• الخوف من المخلوقات ← الثقة في الخالق
• المما��سات الثقافية ← طرق السنة

التطور العلمي:
على مر القرون، العلماء الإسلاميون:
• كتبوا بإسهاب عن العين
• صنفوا الأنواع والآثار
• ميزوا بين الروايات الصحيحة والضعيفة
• طوروا طرق علاج شاملة
• فصلوا بين الخرافات الثقافية والحقائق الإسلامية

العصر العثماني:

نظر بونجوغو:
تميمة العين الزرقاء (نظر بونجوغو) انتشرت على نطاق واسع في الثقافة التركية۔ ومع ذلك، في 2021، أوضحت السلطة الدينية التركية (ديانت) أن هذه التمائم غير جائزة في الإسلام۔

الفهم الحديث:

العلماء المعاصرون:
العلماء الإسلاميون المعاصرون يؤكدون:
• العين حقيقية وفقاً للأحاديث الصحيحة
• الله وحده يمكنه الحماية
• الحماية القرآنية كافية
• تجنب جميع أشكال الشرك
• التوازن بين الإيمان والوسواس

الاهتمام العلمي:
بعض الباحثين درسوا الجوانب النفسية والطاقية، رغم أن الموقف الإسلامي يبقى أنها حقيقة روحية مثبتة بالوحي۔

الدروس التاريخية الرئيسية:

١. ظاهرة عالمية:
العين كانت معترف بها عبر الحضارات القديمة، والإسلام أكد حقيقتها۔

٢. تنقية المفهوم:
الإسلام أزال العناصر الخرافية وأسس طرق حماية أصيلة۔

٣. السابقة النبوية:
الحماية من العين كانت تمارس من قبل الأنبياء عبر التاريخ۔

٤. التوجيه المستمر:
الفهم الإسلامي ظل ثابتاً من زمن النبي إلى اليوم۔

٥. التمييز الواضح:
الإسلام يفصل بوضوح بين الممارسات الأصيلة والابتداعات الثقافية۔

الجدول الزمني:

~3000 قبل الميلاد: معتقدات العين اليونانية والرومانية القديمة
~1500 قبل الميلاد: تمائم عيون حورس في مصر
قبل 610 م: ممارسات الجاهلية العربية
610-632 م: الوحي الإسلامي ينقي المفهوم
القرن السابع: تعاليم النبي تؤسس الطرق
القرن 8-15: العلماء الإسلاميون يوثقون بإسهاب
العصر العثماني: الممارسات الثقافية تنتشر
العصر الحديث: التوضيح العلمي مستمر

الخلاصة:

المنظور التاريخي يُظهر أن:
• العين اعتقاد قديم عالمي
• الإسلام اعترف بحقيقتها لكن نقّى الممارسة
• الحماية الحقيقية تأتي فقط من الله
• لدينا طرق أصيلة من النبي ﷺ
• الإضافات الثقافية يجب رفضها

الاستمرارية من الأنبياء إبراهيم ويعقوب إلى النبي محمد ﷺ تُظهر أن هذا ليس مفهوماً جديداً بل حقيقة قديمة أوضحها الوحي الإسلامي۔

تذكر: بينما العين مؤسسة تاريخياً وإسلامياً، حمايتنا تكمن في اتباع التوجيه القرآني والنبوي الأصيل، وليس الخرافات الثقافية۔''',
      },
    },
    {
      'number': 14,
      'titleKey': 'nazar_e_bad_14_scientific_understanding',
      'title': 'Scientific & Psychological View',
      'titleUrdu': 'سائنسی اور نفسیاتی نقطہ نظر',
      'titleHindi': 'साइंसी और नफ़्सियाती नुक़्ता-ए-नज़र',
      'titleArabic': 'المنظور العلمي والنفسي',
      'icon': Icons.psychology,
      'color': Colors.blueGrey,
      'details': {
        'english': '''Scientific & Psychological Understanding of Evil Eye

While evil eye is primarily a spiritual concept proven by Islamic revelation, modern science and psychology offer interesting perspectives:

ISLAMIC POSITION FIRST:

Fundamental Belief:
• Evil eye is REAL as confirmed by authentic Hadith
• It's a spiritual reality, not merely psychological
• The Prophet ﷺ said: "The evil eye is real"
• Our protection is through Allah and Quran
• Science cannot fully explain spiritual realities

PSYCHOLOGICAL PERSPECTIVES:

1. Psychosomatic Effects:
Modern psychology recognizes that mental states affect physical health:
• Stress from negative attention can cause illness
• Belief in being "cursed" creates anxiety
• Anxiety manifests in physical symptoms
• Mind-body connection is scientifically proven

However, Islam teaches evil eye goes beyond mere psychology—it's a real spiritual phenomenon.

2. Energy and Intention:
Some researchers study:
• Human bio-electromagnetic fields
• Effect of negative emotions on energy
• Impact of focused attention
• Quantum entanglement and consciousness

While interesting, Muslims believe in evil eye based on revelation, not scientific theories.

3. Self-Fulfilling Prophecy:
Psychology notes that:
• Believing you're affected can cause problems
• Paranoia creates stress and illness
• Expectations influence outcomes

Islam's Balance:
• Evil eye is real (not just psychology)
• But avoid paranoia and suspicion
• Trust in Allah, not fear of people
• Take authentic precautions

NEUROSCIENCE INSIGHTS:

Mirror Neurons:
• Humans have neurons that mirror others' states
• Seeing someone's success can trigger envy
• Brain's reward system activates
• Negative emotions can be intensified by focus

Islamic View: This explains the mechanism of Hasad (envy) but doesn't negate the spiritual reality of Nazar.

Attention and Focus:
• Prolonged staring affects both observer and observed
• Intense focus creates psychological impact
• Eyes communicate emotions powerfully

Islam teaches: Eyes are indeed powerful, as Allah mentioned in Quran about eyes that can harm.

SOCIAL PSYCHOLOGY:

Envy Studies:
Research shows:
• Envy is universal across cultures
• Upward social comparison triggers it
• Can lead to destructive behavior
• Social media amplifies envy

Islamic Wisdom: Prophet ﷺ warned about envy 1400 years ago, and taught how to control it.

Social Comparison Theory:
• People constantly compare themselves
• Comparison leads to dissatisfaction
• Can trigger harmful intentions

Islam's Solution: Gratitude (Shukr), contentment (Qana'ah), and happiness for others.

MEDICAL OBSERVATIONS:

Documented Cases:
Some physicians have documented:
• Sudden illnesses after praise without blessings
• Unexplained symptoms with no medical cause
• Recovery after spiritual treatment
• Psychogenic illness from negative attention

Important: Islam teaches to seek medical help AND spiritual protection—both are compatible.

Placebo and Nocebo:
• Placebo: Positive belief causes healing
• Nocebo: Negative belief causes harm
• Mind influences body significantly

Islamic Balance: Ruqyah works not just through belief, but through Allah's healing power in His Words.

ENERGY FIELD THEORIES:

Some Alternative Views:
• Humans emit energy fields
• Negative emotions create harmful frequencies
• Eyes can transmit energy
• Auras can be affected

Islamic Stance:
• We don't need these theories to believe
• Quran and Hadith are sufficient proof
• Science may discover mechanisms later
• Spiritual realities exist beyond current science

BEHAVIORAL OBSERVATIONS:

Universal Practices:
Anthropologists note that protection from evil eye exists in:
• Over 40 cultures worldwide
• Ancient and modern societies
• Different religions and beliefs
• Indicates a fundamental human experience

Islamic View: This universal recognition doesn't prove it's just cultural—Islam confirms it's a real spiritual phenomenon that affects all humanity.

LIMITATIONS OF SCIENCE:

What Science Can't Fully Explain:
• Spiritual dimensions
• Jinn and their effects
• Power of Quranic verses
• Divine decree and protection
• Unseen realm (Ghaib)

The Prophet ﷺ said: "There is no disease that Allah has created, except that He also has created its treatment."

PRACTICAL INTEGRATION:

Islamic Approach Combines:
1. Spiritual Protection:
   • Daily Adhkar
   • Quranic recitation
   • Duas and Ruqyah

2. Psychological Health:
   • Avoid paranoia
   • Maintain positive mindset
   • Don't obsess over symptoms

3. Physical Care:
   • Seek medical treatment
   • Maintain health
   • Use practical precautions

4. Social Wisdom:
   • Don't display blessings excessively
   • Practice humility
   • Avoid triggering envy

MODERN RESEARCH AREAS:

Current Studies:
• Psychoneuroimmunology (mind-body connection)
• Effects of stress on immune system
• Social contagion of emotions
• Epigenetics and belief systems

Muslim Scientists' View:
• Science is discovering what Quran revealed
• Both spiritual and material causes exist
• Don't reduce spiritual to material
• Holistic understanding is best

CONCLUSION:

Islamic Balanced View:
1. Evil eye is REAL (spiritual reality)
2. Has psychological components
3. Can have physical manifestations
4. Science may explain some mechanisms
5. But spiritual essence is beyond science
6. Quran and Sunnah provide complete protection
7. Use both spiritual and material means

Remember: We believe in evil eye because Allah and His Prophet ﷺ told us, not because science proves it. Science may help understand some aspects, but our foundation is revelation.

The best approach is:
• Strong faith in Allah
• Regular Quranic protection
• Psychological balance
• Medical care when needed
• Avoid both denial and paranoia

As believers, we recognize evil eye as a spiritual reality that can have psychological and physical effects, and we protect ourselves through authentic Islamic methods combined with practical wisdom.''',
        'urdu': '''نظر بد کی سائنسی اور نفسیاتی تفہیم

اگرچہ نظر بد بنیادی طور پر ایک روحانی تصور ہے جو اسلامی وحی سے ثابت ہے، جدید سائنس اور نفسیات دلچسپ نقطہ نظر پیش کرتے ہیں:

پہلے اسلامی موقف:

بنیادی عقیدہ:
• نظر بد حقیقی ہے جیسا کہ صحیح احادیث سے تصدیق ہوتی ہے
• یہ روحانی حقیقت ہے، محض نفسیاتی نہیں
• نبی کریم ﷺ نے فرمایا: "نظر بد حق ہے"
• ہماری حفاظت اللہ اور قرآن سے ہے
• سائنس روحانی حقائق کی مکمل وضاحت نہیں کر سکتی

نفسیاتی نقطہ نظر:

۱۔ نفسیاتی جسمانی اثرات:
جدید نفسیات تسلیم کرتی ہے کہ ذہنی کیفیات جسمانی صحت کو متاثر کرتی ہیں:
• منفی توجہ سے تناؤ بیماری کا سبب بن سکتا ہے
• "لعنت زدہ" ہونے کا یقین پریشانی پیدا کرتا ہے
• پریشانی جسمانی علامات میں ظاہر ہوتی ہے
• دماغ اور جسم کا تعلق سائنسی طور پر ثابت ہے

تاہم، اسلام سکھاتا ہے کہ نظر بد محض نفسیات سے آگے ہے—یہ حقیقی روحانی مظہر ہے۔

۲۔ توانائی اور ارادہ:
کچھ محققین مطالعہ کرتے ہیں:
• انسانی حیاتیاتی برقی مقناطیسی میدان
• منفی جذبات کا توانائی پر اثر
• مرکوز توجہ کا اثر
• کوانٹم الجھاؤ اور شعور

اگرچہ دلچسپ ہے، مسلمان وحی کی بنیاد پر نظر بد پر یقین رکھتے ہیں، سائنسی نظریات پر نہیں۔

۳۔ خود پورا ہونے والی پیشین گوئی:
نفسیات نوٹ کرتی ہے کہ:
• متاثر ہونے کا یقین مسائل کا سبب بن سکتا ہے
• پاگل پن تناؤ اور بیماری پیدا کرتا ہے
• توقعات نتائج کو متاثر کرتی ہیں

اسلام کا توازن:
• نظر بد حقیقی ہے (صرف نفسیات نہیں)
• لیکن پاگل پن اور شک سے بچیں
• لوگوں کے خوف کے بجائے اللہ پر بھروسہ کریں
• مستند احتیاطیں اختیار کریں

نیورو سائنس کی بصیرت:

مرر نیورونز:
• انسانوں میں نیورونز ہیں جو دوسروں کی کیفیات کی عکاسی کرتے ہیں
• کسی کی کامیابی دیکھنا حسد کو متحرک کر سکتا ہے
• دماغ کا انعامی نظام فعال ہوتا ہے
• منفی جذبات توجہ سے تیز ہو سکتے ہیں

اسلامی نقطہ نظر: یہ حسد کے طریقہ کار کی وضاحت کرتا ہے لیکن نظر کی روحانی حقیقت کو مسترد نہیں کرتا۔

توجہ اور تمرکز:
• طویل گھورنا دونوں مشاہدہ کار اور مشاہدہ شدہ کو متاثر کرتا ہے
• شدید تمرکز نفسیاتی اثر پیدا کرتا ہے
• آنکھیں جذبات کو طاقتور طریقے سے بتاتی ہیں

اسلام سکھاتا ہے: آنکھیں واقعی طاقتور ہیں، جیسا کہ اللہ نے قرآن میں ایسی آنکھوں کا ذکر کیا جو نقصان پہنچا سکتی ہیں۔

سماجی نفسیات:

حسد کے مطالعات:
تحقیق ظاہر کرتی ہے:
• حسد تمام ثقافتوں میں عالمگیر ہے
• اوپر کی سماجی موازنہ اسے متحرک کرتا ہے
• تباہ کن رویے کی طرف لے جا سکتا ہے
• سوشل میڈیا حسد کو بڑھاتا ہے

اسلامی حکمت: نبی کریم ﷺ نے 1400 سال پہلے حسد کے بارے میں خبردار کیا، اور اسے کنٹرول کرنا سکھایا۔

سماجی موازنہ کا نظریہ:
• لوگ مسلسل اپنا موازنہ کرتے ہیں
• موازنہ عدم اطمینان کی طرف لے جاتا ہے
• نقصان دہ ارادے کو متحرک کر سکتا ہے

اسلام کا حل: شکر، قناعت، اور دوسروں کے لیے خوشی۔

طبی مشاہدات:

دستاویزی کیسز:
کچھ معالجین نے دستاویز کیا ہے:
• برکت کے بغیر تعریف کے بعد اچانک بیماری
• طبی وجہ کے بغیر غیر واضح علامات
• روحانی علاج کے بعد بحالی
• منفی توجہ سے نفسیاتی بیماری

اہم: اسلام طبی مدد اور روحانی حفاظت دونوں حاصل کرنا سکھاتا ہے—دونوں مطابقت رکھتے ہیں۔

پلیسیبو اور نوسیبو:
• پلیسیبو: مثبت یقین شفا کا سبب بنتا ہے
• نوسیبو: منفی یقین نقصان کا سبب بنتا ہے
• دماغ جسم کو نمایاں طور پر متاثر کرتا ہے

اسلامی توازن: رقیہ صرف یقین سے کام نہیں کرتا، بلکہ اللہ کے کلمات میں اس کی شفا کی طاقت سے۔

توانائی میدان کے نظریات:

کچھ متبادل خیالات:
• انسان توانائی کے میدان خارج کرتے ہیں
• منفی جذبات نقصان دہ تعدد پیدا کرتے ہیں
• آنکھیں توانائی منتقل کر سکتی ہیں
• آواز متاثر ہو سکتے ہیں

اسلامی موقف:
• ہمیں یقین کرنے کے لیے ان نظریات کی ضرورت نہیں
• قرآن اور حدیث کافی ثبوت ہیں
• سائنس بعد میں طریقہ کار دریافت کر سکتی ہے
• روحانی حقائق موجودہ سائنس سے آگے موجود ہیں

رویے کے مشاہدات:

عالمگیر طریقے:
ماہرین بشریات نوٹ کرتے ہیں کہ نظر بد سے حفاظت موجود ہے:
• دنیا بھر میں 40 سے زیادہ ثقافتوں میں
• قدیم اور جدید معاشروں میں
• مختلف مذاہب اور عقائد میں
• ایک بنیادی انسانی تجربے کی نشاندہی کرتا ہے

اسلامی نقطہ نظر: یہ عالمگیر پہچان یہ ثابت نہیں کرتی کہ یہ صرف ثقافتی ہے—اسلام تصدیق کرتا ہے کہ یہ حقیقی روحانی مظہر ہے جو تمام انسانیت کو متاثر کرتا ہے۔

سائنس کی حدود:

جو سائنس مکمل طور پر وضاحت نہیں کر سکتی:
• روحانی جہت
• جن اور ان کے اثرات
• قرآنی آیات کی طاقت
• الٰہی فیصلے اور حفاظت
• غیب کا عالم

نبی کریم ﷺ نے فرمایا: "اللہ نے کوئی بیماری نہیں بنائی مگر اس کا علاج بھی بنایا ہے۔"

عملی انضمام:

اسلامی نقطہ نظر جمع کرتا ہے:
۱۔ روحانی حفاظت:
   • روزانہ اذکار
   • قرآنی تلاوت
   • دعائیں اور رقیہ

۲۔ نفسیاتی صحت:
   • پاگل پن سے بچیں
   • مثبت ذہنیت برقرار رکھیں
   • علامات پر جنون نہ کریں

۳۔ جسمانی دیکھ بھال:
   • طبی علاج حاصل کریں
   • صحت برقرار رکھیں
   • عملی احتیاطیں استعمال کریں

۴۔ سماجی حکمت:
   • نعمتوں کا ضرورت سے زیادہ اظہار نہ کریں
   • عاجزی کی مشق کریں
   • حسد کو متحرک کرنے سے بچیں

جدید تحقیق کے شعبے:

موجودہ مطالعات:
• سائیکونیورو امیونولوجی (دماغ اور جسم کا تعلق)
• مدافعتی نظام پر تناؤ کے اثرات
• جذبات کی سماجی منتقلی
• ایپی جینیٹکس اور عقیدہ کے نظام

مسلمان سائنسدانوں کا نقطہ نظر:
• سائنس دریافت کر رہی ہے جو قرآن نے بیان کیا
• روحانی اور مادی دونوں اسباب موجود ہیں
• روحانی کو مادی میں کم نہ کریں
• جامع فہم بہترین ہے

نتیجہ:

اسلامی متوازن نقطہ نظر:
۱۔ نظر بد حقیقی ہے (روحانی حقیقت)
۲۔ نفسیاتی اجزاء رکھتی ہے
۳۔ جسمانی مظاہر ہو سکتے ہیں
۴۔ سائنس کچھ طریقہ کار کی وضاحت کر سکتی ہے
۵۔ لیکن روحانی جوہر سائنس سے آگے ہے
۶۔ قرآن اور سنت مکمل حفاظت فراہم کرتے ہیں
۷۔ روحانی اور مادی دونوں ذرائع استعمال کریں

یاد رکھیں: ہم نظر بد پر یقین رک��تے ہیں کیونکہ اللہ اور اس کے رسول ﷺ نے ہمیں بتایا، نہ کہ سائنس اسے ثابت کرتی ہے۔ سائنس کچھ پہلوؤں کو سمجھنے میں مدد کر سکتی ہے، لیکن ہماری بنیاد وحی ہے۔

بہترین نقطہ نظر ہے:
• اللہ پر مضبوط ایمان
• باقاعدہ قرآنی حفاظت
• نفسیاتی توازن
• ضرورت پڑنے پر طبی دیکھ بھال
• انکار اور پاگل پن دونوں سے بچیں

مومنین کے طور پر، ہم نظر بد کو روحانی حقیقت کے طور پر تسلیم کرتے ہیں جس کے نفسیاتی اور جسمانی اثرات ہو سکتے ہیں، اور ہم مستند اسلامی طریقوں کے ساتھ عملی حکمت کے امتزاج سے اپنی حفاظت کرتے ہیں۔''',
        'hindi': '''नज़र-ए-बद की साइंसी और नफ़्सियाती तफ़हीम

अगरचे नज़र-ए-बद बुनियादी तौर पर एक रूहानी तसव्वुर है जो इस्लामी वही से साबित है, जदीद साइंस और नफ़्सियात दिलचस्प नुक़्ता-ए-नज़र पेश करते हैं:

पहले इस्लामी मौक़िफ़:

बुनियादी अक़ीदा:
• नज़र-ए-बद हक़ीक़ी है जैसा कि सहीह हदीसों से तस्दीक़ होती है
• यह रूहानी हक़ीक़त है, महज़ नफ़्सियाती नहीं
• नबी करीम ﷺ ने फ़रमाया: "नज़र-ए-बद हक़ है"
• हमारी हिफ़ाज़त अल्लाह और क़ुरआन से है
• साइंस रूहानी हक़ाइक़ की मुकम्मल वज़ाहत नहीं कर सकती

नफ़्सियाती नुक़्ता-ए-नज़र:

१. नफ़्सियाती जिस्मानी असरात:
जदीद नफ़्सियात तस्लीम करती है कि ज़ेहनी कैफ़ियात जिस्मानी सेहत को मुतास्सिर करती हैं:
• मनफ़ी तवज्जो से तनाव बीमारी का सबब बन सकता है
• "लानत ज़दा" होने का यक़ीन परेशानी पैदा करता है
• परेशानी जिस्मानी अलामात में ज़ाहिर होती है
• दिमाग़ और जिस्म का ताल्लुक़ साइंसी तौर पर साबित है

ताहम, इस्लाम सिखाता है कि नज़र-ए-बद महज़ नफ़्सियात से आगे है—यह हक़ीक़ी रूहानी मज़हर है।

२. तवानाई और इरादा:
कुछ मुहक़्क़िक़ीन मुतालआ करते हैं:
• इंसानी हयातियाती बर्क़ी मिक़नातीसी मैदान
• मनफ़ी जज़्बात का तवानाई पर असर
• मरकूज़ तवज्जो का असर
• क्वांटम उलझाव और शऊर

अगरचे दिलचस्प है, मुसलमान वही की बुनियाद पर नज़र-ए-बद पर यक़ीन रखते हैं, साइंसी नज़रियात पर नहीं।

३. ख़ुद पूरा होने वाली पेशीनगोई:
नफ़्सियात नोट करती है कि:
• मुतास्सिर होने का यक़ीन मसाइल का सबब बन सकता है
• पागलपन तनाव और बीमारी पैदा करता है
• तवक़्क़ोआत नताइज को मुतास्सिर करती हैं

इस्लाम का तवाज़ुन:
• नज़र-ए-बद हक़ीक़ी है (सिर्फ़ नफ़्सियात नहीं)
• लेकिन पागलपन और शक से बचें
• लोगों के ख़ौफ़ के बजाए अल्लाह पर भरोसा करें
• मुस्तनद एहतियातें इख़्तियार करें

न्यूरो साइंस की बसीरत:

मिरर न्यूरॉन्ज़:
• इंसानों में न्यूरॉन्ज़ हैं जो दूसरों की कैफ़ियात की अक्कासी करते हैं
• किसी की कामयाबी देखना हसद को मुतहर्रिक कर सकता है
• दिमाग़ का इनआमी निज़ाम फ़ेअल होता है
• मनफ़ी जज़्बात तवज्जो से तेज़ हो सकते हैं

इस्लामी नुक़्ता-ए-नज़र: यह हसद के तरीक़ा-ए-कार की वज़ाहत करता है लेकिन नज़र की रूहानी हक़ीक़त को मुस्तरद नहीं करता।

तवज्जो और तमर्कुज़:
• तवील घूरना दोनों मुशाहिदा कार और मुशाहिदा शुदा को मुतास्सिर करता है
• शदीद तमर्कुज़ नफ़्सियाती असर पैदा करता है
• आंखें जज़्बात को ताक़तवर तरीक़े से बताती हैं

इस्लाम सिखाता है: आंखें वाक़ई ताक़तवर हैं, जैसा कि अल्लाह ने क़ुरआन में ऐसी आंखों का ज़िक्र किया जो नुक़सान पहुंचा सकती हैं।

सामाजी नफ़्सियात:

हसद के मुताल्आत:
तहक़ीक़ ज़ाहिर करती है:
• हसद तमाम सक़ाफ़तों में आलमगीर है
• ऊपर की सामाजी मुवाज़ना उसे मुतहर्रिक करता है
• तबाह कुन रवय्ये की तरफ़ ले जा सकता है
• सोशल मीडिया हसद को बढ़ाता है

इस्लामी हिक्मत: नबी करीम ﷺ ने 1400 साल पहले हसद के बारे में ख़बरदार किया, और उसे कंट्रोल करना सिखाया।

सामाजी मुवाज़ना का नज़रिया:
• लोग मुसलसल अपना मुवाज़ना करते हैं
• मुवाज़ना अदम-ए-इत्मेनान की तरफ़ ले जाता है
• नुक़सान देह इरादे को मुतहर्रिक कर सकता है

इस्लाम का हल: शुक्र, क़नाअत, और दूसरों के लिए ख़ुशी।

तिब्बी मुशाहिदात:

दस्तावेज़ी केसेज़:
कुछ मुआलिजीन ने दस्तावेज़ किया है:
• बरकत के बग़ैर तारीफ़ के बाद अचानक बीमारी
• तिब्बी वजह के बग़ैर ग़ैर-वाज़ेह अलामात
• रूहानी इलाज के बाद बहाली
• मनफ़ी तवज्जो से नफ़्सियाती बीमारी

अहम: इस्लाम तिब्बी मदद और रूहानी हिफ़ाज़त दोनों हासिल करना सिखाता है—दोनों मुताबिक़त रखते हैं।

प्लेसीबो और नोसीबो:
• प्लेसीबो: मुसबत यक़ीन शिफ़ा का सबब बनता है
• नोसीबो: मनफ़ी यक़ीन नुक़सान का सबब बनता है
• दिमाग़ जिस्म को नुमायां तौर पर मुतास्सिर करता है

इस्लामी तवाज़ुन: रुक़्या सिर्फ़ यक़ीन से काम नहीं करता, बल्कि अल्लाह के कलिमात में उसकी शिफ़ा की ताक़त से।

तवानाई मैदान के नज़रियात:

कुछ मुतबादिल ख़यालात:
• इंसान तवानाई के मैदान ख़ारिज करते हैं
• मनफ़ी जज़्बात नुक़सान देह तादाद पैदा करते हैं
• आंखें तवानाई मुंतक़िल कर सकती हैं
• आवाज़ें मुतास्सिर हो सकती हैं

इस्लामी मौक़िफ़:
• हमें यक़ीन करने के लिए इन नज़रियात की ज़रूरत नहीं
• क़ुरआन और हदीस काफ़ी सबूत हैं
• साइंस बाद में तरीक़ा-ए-कार दरयाफ़्त कर सकती है
• रूहानी हक़ाइक़ मौजूदा साइंस से आगे मौजूद हैं

रवय्ये के मुशाहिदात:

आलमगीर तरीक़े:
माहिरीन-ए-बशरियात नोट करते हैं कि नज़र-ए-बद से हिफ़ाज़त मौजूद है:
• दुनिया भर में 40 से ज़्यादा सक़ाफ़तों में
• क़दीम और जदीद मुआशरों में
• मुख़्तलिफ़ मज़ाहिब और अक़ाइद में
• एक बुनियादी इंसानी तजुर्बे की निशानदेही करता है

इस्लामी नुक़्ता-ए-नज़र: यह आलमगीर पहचान यह साबित नहीं करती कि यह सिर्फ़ सक़ाफ़ती है—इस्लाम तस्दीक़ करता है कि यह हक़ीक़ी रूहानी मज़हर है जो तमाम इंसानियत को मुतास्सिर करता है।

साइंस की हुदूद:

जो साइंस मुकम्मल तौर पर वज़ाहत नहीं कर सकती:
• रूहानी जहात
• जिन्न और उनके असरात
• क़ुरआनी आयात की ताक़त
• इलाही फ़ैसले और हिफ़ाज़त
• ग़ैब का आलम

नबी करीम ﷺ ने फ़रमाया: "अल्लाह ने कोई बीमारी नहीं बनाई मगर उसका इलाज भी बनाया है।"

अमली इन्ज़ेमाम:

इस्लामी नुक़्ता-ए-नज़र जमा करता है:
१. रूहानी हिफ़ाज़त:
   • रोज़ाना अज़कार
   • क़ुरआनी तिलावत
   • दुआएं और रुक़्या

२. नफ़्सियाती सेहत:
   • पागलपन से बचें
   • मुसबत ज़ेहनियत बरक़रार रखें
   • अलामात पर जुनून न करें

३. जिस्मानी देखभाल:
   • तिब्बी इलाज हासिल करें
   • सेहत बरक़रार रखें
   • अमली एहतियातें इस्तेमाल करें

४. सामाजी हिक्मत:
   • नेमतों का ज़रूरत से ज़्यादा इज़हार न करें
   • आजिज़ी की मश्क़ करें
   • हसद को मुतहर्रिक करने से बचें

जदीद तहक़ीक़ के शोबे:

मौजूदा मुताल्आत:
• साइकोन्यूरो इम्यूनोलॉजी (दिमाग़ और जिस्म का ताल्लुक़)
• मुदाफ़ेआती निज़ाम पर तनाव के असरात
• जज़्बात की सामाजी मुंतक़ली
• एपी जेनेटिक्स और अक़ीदे के निज़ाम

मुसलमान साइंसदानों का नुक़्ता-ए-नज़र:
• साइंस दरयाफ़्त कर रही है जो क़ुरआन ने बयान किया
• रूहानी और मादी दोनों असबाब मौजूद हैं
• रूहानी को मादी में कम न करें
• जामे फ़हम बेहतरीन है

नतीजा:

इस्लामी मुतवाज़िन नुक़्ता-ए-नज़र:
१. नज़र-ए-बद हक़ीक़ी है (रूहानी हक़ीक़त)
२. नफ़्सियाती अजज़ा रखती है
३. जिस्मानी मज़ाहिर हो सकते हैं
४. साइंस कुछ तरीक़ा-ए-कार की वज़ाहत कर सकती है
५. लेकिन रूहानी जौहर साइंस से आगे है
६. क़ुरआन और सुन्नत मुकम्मल हिफ़ाज़त फ़राहम करते हैं
७. रूहानी और मादी दोनों ज़राए इस्तेमाल करें

याद रखें: हम नज़र-ए-बद पर यक़ीन रखते हैं क्योंकि अल्लाह और उसके रसूल ﷺ ने हमें बताया, न कि साइंस उसे साबित करती है। साइंस कुछ पहलुओं को समझने में मदद कर सकती है, लेकिन हमारी बुनियाद वही है।

बेहतरीन नुक़्ता-ए-नज़र है:
• अल्लाह पर मज़बूत ईमान
• बाक़ायदा क़ुरआनी हिफ़ाज़त
• नफ़्सियाती तवाज़ुन
• ज़रूरत पड़ने पर तिब्बी देखभाल
• इनकार और पागलपन दोनों से बचें

मोमिनीन के तौर पर, हम नज़र-ए-बद को रूहानी हक़ीक़त के तौर पर तस्लीम करते हैं जिसके नफ़्सियाती और जिस्मानी असरात हो सकते हैं, और हम मुस्तनद इस्लामी तरीक़ों के साथ अमली हिक्मत के इम्तेज़ाज से अपनी हिफ़ाज़त करते हैं।''',
        'arabic': '''المنظور العلمي والنفسي للعين (الحسد)

بينما العين في المقام الأول مفهوم روحي مثبت بالوحي الإسلامي، يقدم العلم الحديث وعلم النفس وجهات نظر مثيرة للاهتمام:

الموقف الإسلامي أولاً:

الاعتقاد الأساسي:
• العين حقيقية كما تؤكد الأحاديث الصحيحة
• إنها حقيقة روحية، وليست نفسية فحسب
• قال النبي ﷺ: "العين حق"
• حمايتنا من خلال الله والقرآن
• العلم لا يستطيع تفسير الحقائق الروحية بالكامل

المنظورات النفسية:

١. التأثيرات النفسية الجسدية:
علم النفس الحديث يعترف أن الحالات العقلية تؤثر على الصحة الجسدية:
• الإجهاد من الاهتمام السلبي يمكن أن يسبب المرض
• الاعتقاد في "اللعنة" يخلق القلق
• القلق يتجلى في أعراض جسدية
• الاتصال بين العقل والجسم مثبت علمياً

ومع ذلك، يعلّم الإسلام أن العين تتجاوز مجرد علم النفس—إنها ظاهرة روحية حقيقية۔

٢. الطاقة والنية:
بعض الباحثين يدرسون:
• المجالات الكهرومغناطيسية الحيوية البشرية
• تأثير المشاعر السلبية على الطاقة
• تأثير الانتباه المركز
• التشابك الكمي والوعي

بينما مثير للاهتمام، المسلمون يؤمنون بالعين بناءً على الوحي، وليس النظريات العلمية۔

٣. النبوءة التي تحقق ذاتها:
علم النفس يلاحظ أن:
• الاعتقاد بأنك متأثر يمكن أن يسبب مشاكل
• الوسواس يخلق الإجهاد والمرض
• التوقعات تؤثر على النتائج

التوازن الإسلامي:
• العين حقيقية (ليست مجرد علم نفس)
• لكن تجنب الوسواس والشك
• ثق في الله، لا تخف من الناس
• اتخذ احتياطات أصيلة

رؤى علم الأعصاب:

الخلايا العصبية المرآة:
• البشر لديهم خلايا عصبية تعكس حالات الآخرين
• رؤية نجاح شخص ما يمكن أن يثير الحسد
• نظام المكافأة في الدماغ يتم تنشيطه
• المشاعر السلبية يمكن أن تتكثف بالتركيز

الرأي الإسلامي: هذا يفسر آلية الحسد لكنه لا ينفي الحقيقة الروحية للعين۔

الانتباه والتركيز:
• التحديق المطول يؤثر على كل من المراقب والمراقَب
• التركيز المكثف يخلق تأثيراً نفسياً
• العيون تتواصل مع المشاعر بقوة

الإسلام يعلّم: العيون قوية حقاً، كما ذكر الله في القرآن عن العيون التي يمكن أن تؤذي۔

علم النفس الاجتماعي:

دراسات الحسد:
تظهر الأبحاث:
• الحسد عالمي عبر الثقافات
• المقارنة الاجتماعية التصاعدية تثيره
• يمكن أن يؤدي إلى سلوك مدمر
• وسائل التواصل الاجتماعي تضخم الحسد

الحكمة الإسلامية: النبي ﷺ حذر من الحسد قبل 1400 سنة، وعلّم كيفية السيطرة عليه۔

نظرية المقارنة الاجتماعية:
• الناس يقارنون أنفسهم باستمرار
• المقارنة تؤدي إلى عدم الرضا
• يمكن أن تثير نوايا ضارة

حل الإسلام: الشكر (الشكر)، القناعة (القناعة)، والسعادة للآخرين۔

الملاحظات الطبية:

حالات موثقة:
بعض الأطباء وثقوا:
• أمراض مفاجئة بعد المديح بدون بركة
• أعراض غير مفسرة بدون سبب طبي
• التعافي بعد العلاج الروحاني
• مرض نفسي من الاهتمام السلبي

مهم: الإسلام يعلّم طلب المساعدة الطبية والحماية الروحانية—كلاهما متوافق۔

الوهمي والضار:
• الوهمي: الاعتقاد الإيجابي يسبب الشفاء
• الضار: الاعتقاد السلبي يسبب الأذى
• العقل يؤثر على الجسم بشكل كبير

التوازن الإسلامي: الرقية لا تعمل فقط من خلال الإيمان، بل من خلال قوة الشفاء في كلمات الله۔

نظريات مجال الطاقة:

بعض الآراء البديلة:
• البشر يبعثون مجالات طاقة
• المشاعر السلبية تخلق ترددات ضارة
• العيون يمكن أن تنقل الطاقة
• الهالات يمكن أن تتأثر

الموقف الإسلامي:
• لا نحتاج هذه النظريات للإيمان
• القرآن والحديث دليل كافٍ
• العلم قد يكتشف الآليات لاحقاً
• الحقائق الروحية موجودة خارج العلم الحالي

الملاحظات السلوكية:

الممارسات العالمية:
علماء الأنثروبولوجيا يلاحظون أن الحماية من العين موجودة في:
• أكثر من 40 ثقافة حول العالم
• المجتمعات القديمة والحديثة
• الأديان والمعتقدات المختلفة
• يشير إلى تجربة إنسانية أساسية

الرأي الإسلامي: هذا الاعتراف العالمي لا يثبت أنه ثقافي فقط—الإسلام يؤكد أنها ظاهرة روحية حقيقية تؤثر على البشرية جمعاء۔

حدود العلم:

ما لا يستطيع العلم تفسيره بالكامل:
• الأبعاد الروحانية
• الجن وآثارهم
• قوة الآيات القرآنية
• القدر الإلهي والحماية
• عالم الغيب

قال النبي ﷺ: "ما أنزل الله داء إلا أنزل له شفاء۔"

التكامل العملي:

النهج الإسلامي يجمع:
١. الحماية الروحانية:
   • الأذكار اليومية
   • تلاوة القرآن
   • الأدعية والرقية

٢. الصحة النفسية:
   • تجنب الوسواس
   • حافظ على عقلية إيجابية
   • لا تهووس بالأعراض

٣. الرعاية الجسدية:
   • اطلب العلاج الطبي
   • حافظ على الصحة
   • استخدم احتياطات عملية

٤. الحكمة الاجتماعية:
   • لا تعرض النعم بشكل مفرط
   • مارس التواضع
   • تجنب إثارة الحسد

مجالات البحث الحديثة:

الدراسات الحالية:
• علم المناعة النفسية العصبية (العلاقة بين العقل والجسم)
• آثار الإجهاد على الجهاز المناعي
• العدوى الاجتماعية للمشاعر
• علم الوراثة اللاجينية وأنظمة المعتقدات

رأي العلماء المسلمين:
• العلم يكتشف ما كشفه القرآن
• الأسباب الروحية والمادية كلاهما موجود
• لا تختزل الروحاني إلى المادي
• الفهم الشامل هو الأفضل

الخلاصة:

الرأي الإسلامي المتوازن:
١. العين حقيقية (حقيقة روحية)
٢. لها مكونات نفسية
٣. يمكن أن يكون لها مظاهر جسدية
٤. العلم قد يفسر بعض الآليات
٥. لكن الجوهر الروحاني خارج العلم
٦. القرآن والسنة توفران حماية كاملة
٧. استخدم كلاً من الوسائل الروحية والمادية

تذكر: نؤمن بالعين لأن الله ورسوله ﷺ أخبرونا، وليس لأن العلم يثبتها۔ العلم قد يساعد في فهم بعض الجوانب، لكن أساسنا هو الوحي۔

أفضل نهج هو:
• إيمان قوي بالله
• حماية قرآنية منتظمة
• توازن نفسي
• رعاية طبية عند الحاجة
• تجنب كل من الإنكار والوسواس

كمؤمنين، نعترف بالعين كحقيقة روحية يمكن أن يكون لها آثار نفسية وجسدية، ونحمي أنفسنا من خلال الطرق الإسلامية الأصيلة مع الحكمة العملية۔''',
      },
    },
    {
      'number': 15,
      'titleKey': 'nazar_e_bad_15_faqs',
      'title': 'Frequently Asked Questions',
      'titleUrdu': 'اکثر پوچھے جانے والے سوالات',
      'titleHindi': 'अकसर पूछे जाने वाले सवालात',
      'titleArabic': 'الأسئلة الشائعة',
      'icon': Icons.help_outline,
      'color': Colors.amber,
      'details': {
        'english': '''Frequently Asked Questions About Evil Eye

Q1: Is evil eye real in Islam?
A: Yes, evil eye is absolutely real according to authentic Islamic sources. The Prophet ﷺ said: "The evil eye is real, and if anything were to overtake divine decree, it would be the evil eye." (Sahih Muslim)

Q2: Can a Muslim give evil eye?
A: Yes, unfortunately even Muslims can give evil eye, whether intentionally or unintentionally. That's why we're taught to say "MashaAllah" when admiring something.

Q3: Can parents give evil eye to their own children?
A: Yes, even loving parents can unintentionally affect their children with evil eye if they don't say "MashaAllah" when admiring them. This shows evil eye doesn't require evil intention.

Q4: Can I give myself evil eye?
A: Yes, you can affect yourself by admiring your own blessings excessively without gratitude and without saying "MashaAllah".

Q5: Is wearing blue eye charm allowed in Islam?
A: No, it is shirk (associating partners with Allah). The Prophet ﷺ said: "Whoever wears an amulet has committed shirk." Protection comes from Allah alone through Quran and Dua, not objects.

Q6: Can evil eye kill someone?
A: The Prophet ﷺ said: "Most of those who die among my Ummah die because of the evil eye." (Sahih Bukhari). Yes, it can be very serious and even fatal, but death only occurs by Allah's permission.

Q7: How do I know if I have evil eye?
A: Common signs include sudden unexplained illness, persistent headaches, depression, anxiety, nightmares, financial problems, or loss of blessings. However, these could also have natural causes, so consult both doctors and perform Ruqyah.

Q8: What should I do immediately if I suspect evil eye?
A:
• Perform Ruqyah (recite Quran over yourself)
• Recite protective duas
• Seek Allah's protection
• If you know who gave it, politely ask for their Wudu water
• Consult a doctor to rule out medical causes
• Have faith in Allah's healing

Q9: Can Ruqyah be done on non-Muslims?
A: Yes, the Prophet ﷺ and Companions performed Ruqyah on non-Muslims. However, they must be willing and the Ruqyah must be performed with Islamic methods only.

Q10: Do I need a special sheikh to remove evil eye?
A: No, anyone can perform Ruqyah. You can even do it yourself. The Quran is for everyone, not just special people. The Prophet ﷺ taught Ruqyah to all Companions.

Q11: Can I listen to Ruqyah audio online?
A: Yes, listening to Ruqyah recitations can be beneficial. However, performing it yourself or having someone recite directly over you is more effective.

Q12: How long does it take to remove evil eye?
A: It varies. Some people feel relief immediately, others may need days or weeks of consistent Ruqyah. The key is consistency and faith in Allah.

Q13: Can evil eye affect my business or studies?
A: Yes, evil eye can affect any blessing - health, wealth, business, studies, relationships, children, or possessions.

Q14: Is it okay to share my achievements on social media?
A: It's not haram, but be wise. Always write "MashaAllah" with posts, give credit to Allah, share to inspire not to boast, and consider privacy settings.

Q15: Should I hide all my blessings?
A: No need to hide everything, but avoid excessive display. The Prophet ﷺ said: "Seek help in fulfilling your needs by being discreet, for everyone who is blessed is envied."

Q16: Can non-Muslims give evil eye to Muslims?
A: Yes, evil eye can come from anyone - Muslim or non-Muslim, friend or enemy, family or stranger.

Q17: Is saying "Tabarakallah" same as "MashaAllah"?
A: Both are good. "MashaAllah" means "What Allah has willed" and is more common for protection. "Tabarakallah" means "May Allah bless you" and is also beneficial.

Q18: Can evil eye be prevented completely?
A: Yes, consistent morning/evening Adhkar, regular Quran recitation, saying MashaAllah, maintaining humility, and trusting in Allah provide strong protection.

Q19: Is evil eye the same as black magic?
A: No, they are different. Evil eye (Ayn) is harm through a gaze, often unintentional. Black magic (Sihr) is deliberate use of jinn and spells to harm, which is a major sin and kufr.

Q20: Can animals have evil eye?
A: Some Arabs in Jahiliyyah believed this, but there's no authentic Islamic evidence. Protection is still the same - Quran and Dua.

Q21: What if I don't know who gave me evil eye?
A: You don't need to know. You can perform Ruqyah on yourself or have someone recite for you. Allah's help doesn't depend on identifying the source.

Q22: Can Quranic taweez (amulet) protect from evil eye?
A: Scholars differ. Some allow Quranic taweez with conditions, but many prohibit it. The strongest view is to avoid all amulets and rely on active recitation of Quran and Duas.

Q23: Should I confront someone who gave me evil eye?
A: No, Islam teaches better manners. If you know who it is, politely ask them to perform Wudu and use that water for treatment. No need for confrontation or accusations.

Q24: Is evil eye more powerful than dua?
A: No, nothing is more powerful than Allah's decree. The Prophet ﷺ said evil eye is powerful, but also taught us protection through Quran and Dua which are sufficient.

Q25: Can evil eye be given through photos?
A: Yes, seeing someone's photo and admiring or envying them can potentially affect them, which is why scholars advise caution with sharing photos, especially of children.

Q26: What's the difference between Ayn, Hasad, and Nazar?
A:
• Hasad = Internal envy (the feeling)
• Ayn/Nazar = Evil eye (the effect)
• Hasad can lead to Ayn, but Ayn can also come from admiration without envy

Q27: Can Jinns give evil eye?
A: Islamic texts mention that harm can come from Jinn, but evil eye specifically refers to human gaze. Jinn have their own ways of harming, which Ruqyah also treats.

Q28: Is it evil eye or just bad luck?
A: There's no "luck" in Islam - everything is by Allah's decree. What some call "bad luck" could be evil eye, test from Allah, or consequence of our actions. Seek protection and stay patient.

Q29: Can I do Ruqyah while menstruating?
A: Yes, women can recite Quran for Ruqyah during menstruation as it's for healing. There's a difference between recitation for worship (not allowed) and for healing (allowed).

Q30: How often should I perform protective Ruqyah?
A: Daily morning and evening Adhkar should be regular. If you feel symptoms, perform Ruqyah as needed. Prevention is better than cure, so maintain daily protection.

FINAL REMINDER:
• Evil eye is real but don't be paranoid
• Protection is through Allah alone
• Use authentic Islamic methods
• Seek medical help alongside spiritual care
• Have strong faith and trust in Allah
• Regular Adhkar is your best defense
• Live with gratitude and humility

May Allah protect us all from evil eye and every harm. Ameen.''',
        'urdu': '''نظر بد کے بارے میں اکثر پوچھے جانے والے سوالات

س1: کیا نظر بد اسلام میں حقیقی ہے؟
ج: جی ہاں، نظر بد مستند اسلامی ذرائع کے مطابق بالکل حقیقی ہے۔ نبی کریم ﷺ نے فرمایا: "نظر بد حق ہے، اور اگر کوئی چیز تقدیر سے آگے نکل سکتی تو نظر بد ہوتی۔" (صحیح مسلم)

س2: کیا مسلمان نظر لگا سکتا ہے؟
ج: جی ہاں، بدقسمتی سے مسلمان بھی نظر لگا سکتے ہیں، جان بوجھ کر یا غیر ارادی۔ اسی لیے ہمیں سکھایا گیا کہ کسی چیز کی تعریف کرتے وقت "ماشاءاللہ" کہیں۔

س3: کیا والدین اپنے بچوں کو نظر لگا سکتے ہیں؟
ج: جی ہاں، محبت کرنے والے والدین بھی غیر ارادی طور پر اپنے بچوں کو نظر لگا سکتے ہیں اگر وہ تعریف کرتے وقت "ماشاءاللہ" نہ کہیں۔ یہ ظاہر کرتا ہے کہ نظر بد کے لیے بری نیت کی ضرورت نہیں۔

س4: کیا میں خود کو نظر لگا سکتا ہوں؟
ج: جی ہاں، آپ شکر اور "ماشاءاللہ" کہے بغیر اپنی نعمتوں کی ضرورت سے زیادہ تعریف کر کے خود کو متاثر کر سکتے ہیں۔

س5: کیا نیلی آنکھ کا تعویذ پہننا اسلام میں جائز ہے؟
ج: نہیں، یہ شرک ہے۔ نبی کریم ﷺ نے فرمایا: "جس نے تعویذ پہنا اس نے شرک کیا۔" حفاظت صرف اللہ سے قرآن اور دعا کے ذریعے آتی ہے، اشیاء سے نہیں۔

س6: کیا نظر بد کسی کو مار سکتی ہے؟
ج: نبی کریم ﷺ نے فرمایا: "میری امت میں سے اکثر لوگ نظر بد کی وجہ سے مرتے ہیں۔" (صحیح بخاری)۔ جی ہاں، یہ بہت سنجیدہ اور مہلک بھی ہو سکتی ہے، لیکن موت صرف اللہ کی اجازت سے ہوتی ہے۔

س7: میں کیسے جانوں کہ مجھے نظر لگی ہے؟
ج: عام علامات میں اچانک بلا وجہ بیماری، مسلسل سر درد، ڈپریشن، پریشانی، ڈراؤنے خواب، مالی مسائل، یا نعمتوں کا نقصان شامل ہیں۔ تاہم، ان کی قدرتی وجوہات بھی ہو سکتی ہیں، لہذا ڈاکٹر سے مشورہ کریں اور رقیہ بھی کریں۔

س8: اگر مجھے نظر بد کا شبہ ہو تو فوری طور پر کیا کروں؟
ج:
• رقیہ کریں (اپنے اوپر قرآن پڑھیں)
• حفاظتی دعائیں پڑھیں
• اللہ کی پناہ مانگیں
• اگر آپ کو معلوم ہو کس نے لگائی تو شائستگی سے ان کے وضو کا پانی مانگیں
• طبی وجوہات کو مسترد کرنے کے لیے ڈاکٹر سے مشورہ کریں
• اللہ کی شفا پر یقین رکھیں

س9: کیا غیر مسلموں پر رقیہ کیا جا سکتا ہے؟
ج: جی ہاں، نبی کریم ﷺ اور صحابہ کرام نے غیر مسلموں پر رقیہ کیا۔ تاہم، انہیں راضی ہونا چاہیے اور رقیہ صرف اسلامی طریقوں سے کیا جانا چاہیے۔

س10: کیا نظر بد دور کرنے کے لیے خاص شیخ کی ضرورت ہے؟
ج: نہیں، کوئی بھی رقیہ کر سکتا ہے۔ آپ خود بھی کر سکتے ہیں۔ قرآن سب کے لیے ہے، صرف خاص لوگوں کے لیے نہیں۔ نبی کریم ﷺ نے تمام صحابہ کو رقیہ سکھایا۔

س11: کیا میں آن لائن رقیہ آڈیو سن سکتا ہوں؟
ج: جی ہاں، رقیہ کی تلاوتیں سننا فائدہ مند ہو سکتا ہے۔ تاہم، خود کرنا یا کسی سے براہ راست اپنے اوپر پڑھوانا زیادہ موثر ہے۔

س12: نظر بد دور ہونے میں کتنا وقت لگتا ہے؟
ج: یہ مختلف ہوتا ہے۔ کچھ لوگوں کو فوری ریلیف محسوس ہوتا ہے، دوسروں کو دنوں یا ہفتوں تک مسلسل رقیہ کی ضرورت ہو سکتی ہے۔ کلید مستقل مزاجی اور اللہ پر ایمان ہے۔

س13: کیا نظر بد میرے کاروبار یا تعلیم کو متاثر کر سکتی ہے؟
ج: جی ہاں، نظر بد کسی بھی نعمت کو متاثر کر سکتی ہے - صحت، دولت، کاروبار، تعلیم، رشتے، بچے، یا اثاثے۔

س14: کیا سوشل میڈیا پر اپنی کامیابیاں شیئر کرنا ٹھیک ہے؟
ج: حرام نہیں، لیکن دانشمند بنیں۔ ہمیشہ پوسٹس کے ساتھ "ماشاءاللہ" لکھیں، اللہ کا شکر ادا کریں، حوصلہ افزائی کے لیے شیئر کریں نہ کہ فخر کے لیے، اور رازداری کی ترتیبات پر غور کریں۔

س15: کیا مجھے اپنی تمام نعمتیں چھپانی چاہئیں؟
ج: ہر چیز چھپانے کی ضرورت نہیں، لیکن ضرورت سے زیادہ اظہار سے بچیں۔ نبی کریم ﷺ نے فرمایا: "اپنی ضرورتوں کو پورا کرنے میں رازداری سے مدد حاصل کرو، کیونکہ ہر نعمت والے پر حسد کیا جاتا ہے۔"

س16: کیا غیر مسلم مسلمانوں کو نظر لگا سکتے ہیں؟
ج: جی ہاں، نظر بد کسی سے بھی آ سکتی ہے - مسلمان یا غیر مسلم، دوست یا دشمن، خاندان یا اجنبی۔

س17: کیا "تبارک اللہ" کہنا "ماشاءاللہ" جیسا ہے؟
ج: دونوں اچھے ہیں۔ "ماشاءاللہ" کا مطلب ہے "جو اللہ نے چاہا" اور حفاظت کے لیے زیادہ عام ہے۔ "تبارک اللہ" کا مطلب ہے "اللہ آپ کو برکت دے" اور یہ بھی فائدہ مند ہے۔

س18: کیا نظر بد کو مکمل طور پر روکا جا سکتا ہے؟
ج: جی ہاں، مسلسل صبح و شام کے اذکار، باقاعدہ قرآن کی تلاوت، ماشاءاللہ کہنا، عاجزی برقرار رکھنا، اور اللہ پر بھروسہ مضبوط حفاظت فراہم کرتے ہیں۔

س19: کیا نظر بد اور کالا جادو ایک ہی چیز ہے؟
ج: نہیں، یہ مختلف ہیں۔ نظر بد (عین) نظر کے ذریعے نقصان ہے، اکثر غیر ارادی۔ کالا جادو (سحر) جان بوجھ کر جن اور منتر استعمال کر کے نقصان پہنچانا ہے، جو کبیرہ گناہ اور کفر ہے۔

س20: کیا جانوروں میں نظر بد ہو سکتی ہے؟
ج: جاہلیت میں کچھ عرب یہ مانتے تھے، لیکن کوئی مستند اسلامی ثبوت نہیں۔ حفاظت پھر بھی وہی ہے - قرآن اور دعا۔

س21: اگر مجھے نہیں معلوم کس نے نظر لگائی تو کیا کروں؟
ج: آپ کو جاننے کی ضرورت نہیں۔ آپ خود پر رقیہ کر سکتے ہیں یا کسی سے پڑھوا سکتے ہیں۔ اللہ کی مدد ماخذ کی شناخت پر منحصر نہیں۔

س22: کیا قرآنی تعویذ نظر بد سے بچا سکتا ہے؟
ج: علماء میں اختلاف ہے۔ کچھ شرائط کے ساتھ قرآنی تعویذ کی اجازت دیتے ہیں، لیکن بہت سے اسے منع کرتے ہیں۔ مضبوط ترین رائے ہے کہ تمام تعویذات سے بچیں اور قرآن اور دعاؤں کی فعال تلاوت پر انحصار کریں۔

س23: کیا مجھے اس شخص سے مقابلہ کرنا چاہیے جس نے نظر لگائی؟
ج: نہیں، اسلام بہتر آداب سکھاتا ہے۔ اگر آپ کو معلوم ہو کہ کون ہے تو شائستگی سے ان سے وضو کرنے کو کہیں اور علاج کے لیے وہ پانی استعمال کریں۔ مقابلے یا الزامات کی ضرورت نہیں۔

س24: کیا نظر بد دعا سے زیادہ طاقتور ہے؟
ج: نہیں، اللہ کے فیصلے سے زیادہ طاقتور کچھ نہیں۔ نبی کریم ﷺ نے فرمایا نظر بد طاقتور ہے، لیکن قرآن اور دعا کے ذریعے حفاظت بھی سکھائی جو کافی ہے۔

س25: کیا تصاویر کے ذریعے نظر لگ سکتی ہے؟
ج: جی ہاں، کسی کی تصویر دیکھنا اور ان کی تعریف یا حسد کرنا ممکنہ طور پر انہیں متاثر کر سکتا ہے، یہی وجہ ہے کہ علماء تصاویر شیئر کرنے میں احتیاط کا مشورہ دیتے ہیں، خاص طور پر بچوں کی۔

س26: عین، حسد اور نظر میں کیا فرق ہے؟
ج:
• حسد = اندرونی رشک (احساس)
• عین/نظر = نظر بد (اثر)
• حسد عین کی طرف لے جا سکتا ہے، لیکن عین حسد کے بغیر تعریف سے بھی آ سکتا ہے

س27: کیا جن نظر لگا سکتے ہیں؟
ج: اسلامی متون میں ذکر ہے کہ جن سے نقصان آ سکتا ہے، لیکن نظر بد خاص طور پر انسانی نظر کی طرف اشارہ کرتی ہے۔ جن کے نقصان پہنچانے کے اپنے طریقے ہیں، جن کا رقیہ بھی علاج کرتا ہے۔

س28: کیا یہ نظر بد ہے یا صرف بد قسمتی؟
ج: اسلام میں "قسمت" نہیں - سب کچھ اللہ کے فیصلے سے ہے۔ جسے کچھ لوگ "بد قسمتی" کہتے ہیں وہ نظر بد، اللہ کی طرف سے آزمائش، یا ہمارے اعمال کا نتیجہ ہو سکتا ہے۔ حفاظت مانگیں اور صبر کریں۔

س29: کیا میں حیض کے دوران رقیہ کر سکتی ہوں؟
ج: جی ہاں، خواتین حیض کے دوران شفا کے لیے قرآن پڑھ سکتی ہیں کیونکہ یہ علاج کے لیے ہے۔ عبادت کے لیے تلاوت (اجازت نہیں) اور شفا کے لیے (اجازت ہے) میں فرق ہے۔

س30: مجھے کتنی بار حفاظتی رقیہ کرنا چاہیے؟
ج: روزانہ صبح و شام کے اذکار باقاعدہ ہونے چاہئیں۔ اگر آپ کو علامات محسوس ہوں تو ضرورت کے مطابق رقیہ کریں۔ علاج سے بہتر احتیاط ہے، لہذا روزانہ حفاظت برقرار رکھیں۔

آخری یاد دہانی:
• نظر بد حقیقی ہے لیکن پاگل نہ بنیں
• حفاظت صرف اللہ سے ہے
• مستند اسلامی طریقے استعمال کریں
• روحانی دیکھ بھال کے ساتھ طبی مدد لیں
• مضبوط ایمان اور اللہ پر بھروسہ رکھیں
• باقاعدہ اذکار آپ کا بہترین دفاع ہے
• شکر اور عاجزی کے ساتھ زندگی گزاریں

اللہ ہم سب کو نظر بد اور ہر نقصان سے محفوظ رکھے۔ آمین۔''',
        'hindi': '''नज़र-ए-बद के बारे में अकसर पूछे जाने वाले सवालात

स1: क्या नज़र-ए-बद इस्लाम में हक़ीक़ी है?
ज: जी हां, नज़र-ए-बद मुस्तनद इस्लामी ज़राए के मुताबिक़ बिलकुल हक़ीक़ी है। नबी करीम ﷺ ने फ़रमाया: "नज़र-ए-बद हक़ है, और अगर कोई चीज़ तक़दीर से आगे निकल सकती तो नज़र-ए-बद होती।" (सहीह मुस्लिम)

स2: क्या मुसलमान नज़र लगा सकता है?
ज: जी हां, बदक़िस्मती से मुसलमान भी नज़र लगा सकते हैं, जान-बूझकर या ग़ैर-इरादी। इसी लिए हमें सिखाया गया कि किसी चीज़ की तारीफ़ करते वक़्त "माशाअल्लाह" कहें।

स3: क्या वालिदैन अपने बच्चों को नज़र लगा सकते हैं?
ज: जी हां, मुहब्बत करने वाले वालिदैन भी ग़ैर-इरादी तौर पर अपने बच्चों को नज़र लगा सकते हैं अगर वो तारीफ़ करते वक़्त "माशाअल्लाह" न कहें। यह ज़ाहिर करता है कि नज़र-ए-बद के लिए बुरी नीयत की ज़रूरत नहीं।

स4: क्या मैं ख़ुद को नज़र लगा सकता हूं?
ज: जी हां, आप शुक्र और "माशाअल्लाह" कहे बग़ैर अपनी नेमतों की ज़रूरत से ज़्यादा तारीफ़ करके ख़ुद को मुतास्सिर कर सकते हैं।

स5: क्या नीली आंख का तावीज़ पहनना इस्लाम में जायज़ है?
ज: नहीं, यह शिर्क है। नबी करीम ﷺ ने फ़रमाया: "जिसने तावीज़ पहना उसने शिर्क किया।" हिफ़ाज़त सिर्फ़ अल्लाह से क़ुरआन और दुआ के ज़रिए आती है, अश्या से नहीं।

स6: क्या नज़र-ए-बद किसी को मार सकती है?
ज: नबी करीम ﷺ ने फ़रमाया: "मेरी उम्मत में से अकसर लोग नज़र-ए-बद की वजह से मरते हैं।" (सहीह बुख़ारी)। जी हां, यह बहुत संजीदा और मोहलिक भी हो सकती है, लेकिन मौत सिर्फ़ अल्लाह की इजाज़त से होती है।

स7: मैं कैसे जानूं कि मुझे नज़र लगी है?
ज: आम अलामात में अचानक बिला वजह बीमारी, मुसलसल सर दर्द, डिप्रेशन, परेशानी, डरावने ख़्वाब, माली मसाइल, या नेमतों का नुक़सान शामिल हैं। ताहम, इनकी क़ुदरती वुजूहात भी हो सकती हैं, लिहाज़ा डॉक्टर से मशवरा करें और रुक़्या भी करें।

स8: अगर मुझे नज़र-ए-बद का शुब्हा हो तो फ़ौरी तौर पर क्��ा करूं?
ज:
• रुक़्या करें (अपने ऊपर क़ुरआन पढ़ें)
• हिफ़ाज़ती दुआएं पढ़ें
• अल्लाह की पनाह मांगें
• अगर आपको मालूम हो किसने लगाई तो शाइस्तगी से उनके वुज़ू का पानी मांगें
• तिब्बी वुजूहात को मुस्तरद करने के लिए डॉक्टर से मशवरा करें
• अल्लाह की शिफ़ा पर यक़ीन रखें

स9: क्या ग़ैर-मुस्लिमों पर रुक़्या किया जा सकता है?
ज: जी हां, नबी करीम ﷺ और सहाबा किराम ने ग़ैर-मुस्लिमों पर रुक़्या किया। ताहम, उन्हें राज़ी होना चाहिए और रुक़्या सिर्फ़ इस्लामी तरीक़ों से किया जाना चाहिए।

स10: क्या नज़र-ए-बद दूर करने के लिए ख़ास शैख़ की ज़रूरत है?
ज: नहीं, कोई भी रुक़्या कर सकता है। आप ख़ुद भी कर सकते हैं। क़ुरआन सब के लिए है, सिर्फ़ ख़ास लोगों के लिए नहीं। नबी करीम ﷺ ने तमाम सहाबा को रुक़्या सिखाया।

स11: क्या मैं ऑनलाइन रुक़्या ऑडियो सुन सकता हूं?
ज: जी हां, रुक़्या की तिलावतें सुनना फ़ायदेमंद हो सकता है। ताहम, ख़ुद करना या किसी से बराहे रास्त अपने ऊपर पढ़वाना ज़्यादा मुअस्सिर है।

स12: नज़र-ए-बद दूर होने में कितना वक़्त लगता है?
ज: यह मुख़्तलिफ़ होता है। कुछ लोगों को फ़ौरी रिलीफ़ महसूस होता है, दूसरों को दिनों या हफ़्तों तक मुसलसल रुक़्या की ज़रूरत हो सकती है। कुंजी मुस्तक़िल मिज़ाजी और अल्लाह पर ईमान है।

स13: क्या नज़र-ए-बद मेरे कारोबार या तालीम को मुतास्सिर कर सकती है?
ज: जी हां, नज़र-ए-बद किसी भी नेमत को मुतास्सिर कर सकती है - सेहत, दौलत, कारोबार, तालीम, रिश्ते, बच्चे, या असासे।

स14: क्या सोशल मीडिया पर अपनी कामयाबियां शेयर करना ठीक है?
ज: हराम नहीं, लेकिन दानिशमंद बनें। हमेशा पोस्ट्स के साथ "माशाअल्लाह" लिखें, अल्लाह का शुक्र अदा करें, हौसला अफ़ज़ाई के लिए शेयर करें न कि फ़ख़्र के लिए, और राज़दारी की तरतीबात पर ग़ौर करें।

स15: क्या मुझे अपनी तमाम नेमतें छुपानी चाहिए?
ज: हर चीज़ छुपाने की ज़रूरत नहीं, लेकिन ज़रूरत से ज़्यादा इज़हार से बचें। नबी करीम ﷺ ने फ़रमाया: "अपनी ज़रूरतों को पूरा करने में राज़दारी से मदद हासिल करो, क्योंकि हर नेमत वाले पर हसद किया जाता है।"

स16: क्या ग़ैर-मुस्लिम मुसलमानों को नज़र लगा सकते हैं?
ज: जी हां, नज़र-ए-बद किसी से भी आ सकती है - मुसलमान या ग़ैर-मुस्लिम, दोस्त या दुश्मन, ख़ानदान या अजनबी।

स17: क्या "तबारकल्लाह" कहना "माशाअल्लाह" जैसा है?
ज: दोनों अच्छे हैं। "माशाअल्लाह" का मतलब है "जो अल्लाह ने चाहा" और हिफ़ाज़त के लिए ज़्यादा आम है। "तबारकल्लाह" का मतलब है "अल्लाह आपको बरकत दे" और यह भी फ़ायदेमंद है।

स18: क्या नज़र-ए-बद को मुकम्मल तौर पर रोका जा सकता है?
ज: जी हां, मुसलसल सुबह व शाम के अज़कार, बाक़ायदा क़ुरआन की तिलावत, माशाअल्लाह कहना, आजिज़ी बरक़रार रखना, और अल्लाह पर भरोसा मज़बूत हिफ़ाज़त फ़राहम करते हैं।

स19: क्या नज़र-ए-बद और काला जादू एक ही चीज़ है?
ज: नहीं, यह मुख़्तलिफ़ हैं। नज़र-ए-बद (ऐन) नज़र के ज़रिए नुक़सान है, अकसर ग़ैर-इरादी। काला जादू (सिहर) जान-बूझकर जिन्न और मंतर इस्तेमाल करके नुक़सान पहुंचाना है, जो कबीरा गुनाह और कुफ़्र है।

स20: क्या जानवरों में नज़र-ए-बद हो सकती है?
ज: जाहिलियत में कुछ अरब यह मानते थे, लेकिन कोई मुस्तनद इस्लामी सबूत नहीं। हिफ़ाज़त फिर भी वही है - क़ुरआन और दुआ।

स21: अगर मुझे नहीं मालूम किसने नज़र लगाई तो क्या करूं?
ज: आपको जानने की ज़रूरत नहीं। आप ख़ुद पर रुक़्या कर सकते हैं या किसी से पढ़वा सकते हैं। अल्लाह की मदद माख़ज़ की शिनाख़्त पर मुन्हसिर नहीं।

स22: क्या क़ुरआनी तावीज़ नज़र-ए-बद से बचा सकता है?
ज: उलेमा में इख़्तिलाफ़ है। कुछ शराइत के साथ क़ुरआनी तावीज़ की इजाज़त देते हैं, लेकिन बहुत से उसे मना करते हैं। मज़बूत तरीन राय है कि तमाम तावीज़ात से बचें और क़ुरआन और दुआओं की फ़ेअल तिलावत पर इन्हेसार करें।

स23: क्या मुझे उस शख़्स से मुक़ाबला करना चाहिए जिसने नज़र लगाई?
ज: नहीं, इस्लाम बेहतर आदाब सिखाता है। अगर आपको मालूम हो कि कौन है तो शाइस्तगी से उनसे वुज़ू करने को कहें और इलाज के लिए वो पानी इस्तेमाल करें। मुक़ाबले या इलज़ामात की ज़रूरत नहीं।

स24: क्या नज़र-ए-बद दुआ से ज़्यादा ताक़तवर है?
ज: नहीं, अल्लाह के फ़ैसले से ज़्यादा ताक़तवर कुछ नहीं। नबी करीम ﷺ ने फ़रमाया नज़र-ए-बद ताक़तवर है, लेकिन क़ुरआन और दुआ के ज़रिए हिफ़ाज़त भी सिखाई जो काफ़ी है।

स25: क्या तस्वीरों के ज़रिए नज़र लग सकती है?
ज: जी हां, किसी की तस्वीर देखना और उनकी तारीफ़ या हसद करना मुमकिना तौर पर उन्हें मुतास्सिर कर सकता है, यही वजह है कि उलेमा तस्वीरें शेयर करने में एहतियात का मशवरा देते हैं, ख़ासतौर पर बच्चों की।

स26: ऐन, हसद और नज़र में क्या फ़र्क़ है?
ज:
• हसद = अंदरूनी रश्क (अहसास)
• ऐन/नज़र = नज़र-ए-बद (असर)
• हसद ऐन की तरफ़ ले जा सकता है, लेकिन ऐन हसद के बग़ैर तारीफ़ से भी आ सकता है

स27: क्या जिन्न नज़र लगा सकते हैं?
ज: इस्लामी मतून में ज़िक्र है कि जिन्न से नुक़सान आ सकता है, लेकिन नज़र-ए-बद ख़ास तौर पर इंसानी नज़र की तरफ़ इशारा करती है। जिन्न के नुक़सान पहुंचाने के अपने तरीक़े हैं, जिनका रुक़्या भी इलाज करता है।

स28: क्या यह नज़र-ए-बद है या सिर्फ़ बदक़िस्मती?
ज: इस्लाम में "क़िस्मत" नहीं - सब कुछ अल्लाह के फ़ैसले से है। जिसे कुछ लोग "बदक़िस्मती" कहते हैं वो नज़र-ए-बद, अल्लाह की तरफ़ से आज़माइश, या हमारे आमाल का नतीजा हो सकता है। हिफ़ाज़त मांगें और सब्र करें।

स29: क्या मैं हैज़ के दौरान रुक़्या कर सकती हूं?
ज: जी हां, ख़वातीन हैज़ के दौरान शिफ़ा के लिए क़ुरआन पढ़ सकती हैं क्योंकि यह इलाज के लिए है। इबादत के लिए तिलावत (इजाज़त नहीं) और शिफ़ा के लिए (इजाज़त है) में फ़र्क़ है।

स30: मुझे कितनी बार हिफ़ाज़ती रुक़्या करनी चाहिए?
ज: रोज़ाना सुबह व शाम के अज़कार बाक़ायदा होने चाहिए। अगर आपको अलामात महसूस हों तो ज़रूरत के मुताबिक़ रुक़्या करें। इलाज से बेहतर एहतियात है, लिहाज़ा रोज़ाना हिफ़ाज़त बरक़रार रखें।

आख़िरी याद दिहानी:
• नज़र-ए-बद हक़ीक़ी है लेकिन पागल न बनें
• हिफ़ाज़त सिर्फ़ अल्लाह से है
• मुस्तनद इस्लामी तरीक़े इस्तेमाल करें
• रूहानी देखभाल के साथ तिब्बी मदद लें
• मज़बूत ईमान और अल्लाह पर भरोसा रखें
• बाक़ायदा अज़कार आपका बेहतरीन दिफ़ा है
• शुक्र और आजिज़ी के साथ ज़िंदगी गुज़ारें

अल्लाह हम सब को नज़र-ए-बद और हर नुक़सान से महफ़ूज़ रखे। आमीन।''',
        'arabic': '''الأسئلة الشائعة عن العين (الحسد)

س1: هل العين حقيقية في الإسلام؟
ج: نعم، العين حقيقية بالتأكيد وفقاً للمصادر الإسلامية الصحيحة۔ قال النبي ﷺ: "العين حق، ولو كان شيء سابق القدر لسبقته العين۔" (صحيح مسلم)

س2: هل يمكن للمسلم أن يصيب بالعين؟
ج: نعم، للأسف حتى المسلمون يمكنهم الإصابة بالعين، سواء عن قصد أو بدون قصد۔ لذلك نُعلَّم قول "ما شاء الله" عند الإعجاب بشيء۔

س3: هل يمكن للوالدين أن يصيبوا أطفالهم بالعين؟
ج: نعم، حتى الآباء المحبون يمكنهم التأثير على أطفالهم بالعين بدون قصد إذا لم يقولوا "ما شاء الله" عند الإعجاب بهم۔ هذا يُظهر أن العين لا تتطلب نية شريرة۔

س4: هل يمكنني أن أصيب نفسي بالعين؟
ج: نعم، يمكنك التأثير على نفسك بالإعجاب المفرط بنعمك بدون شكر وبدون قول "ما شاء الله"۔

س5: هل يُسمح بارتداء تميمة العين الزرقاء في الإسلام؟
ج: لا، إنه شرك۔ قال النبي ﷺ: "من علق تميمة فقد أشرك۔" الحماية تأتي من الله وحده من خلال القرآن والدعاء، وليس من الأشياء۔

س6: هل يمكن للعين أن تقتل شخصاً؟
ج: قال النبي ﷺ: "أكثر من يموت من أمتي بعد قضاء الله وقدره بالعين۔" (صحيح البخاري)۔ نعم، يمكن أن تكون خطيرة جداً وحتى مميتة، لكن الموت يحدث فقط بإذن الله۔

س7: كيف أعرف إذا كنت مصاباً بالعين؟
ج: العلامات الشائعة تشمل مرض مفاجئ غير مفسر، صداع مستمر، اكتئاب، قلق، كوابيس، مشاكل مالية، أو فقدان النعم۔ ومع ذلك، يمكن أن يكون لهذه أسباب طبيعية أيضاً، لذا استشر الأطباء واقرأ الرقية۔

س8: ماذا يجب أن أفعل فوراً إذا اشتبهت بالعين؟
ج:
• اقرأ الرقية (اقرأ القرآن على نفسك)
• اقرأ الأدعية الواقية
• اطلب حماية الله
• إذا كنت تعرف من أصابك، اطلب منه بأدب ماء وضوئه
• استشر طبيباً لاستبعاد الأسباب الطبية
• ثق بشفاء الله

س9: هل يمكن قراءة الرقية على غير المسلمين؟
ج: نعم، النبي ﷺ والصحابة قرأوا الرقية على غير المسلمين۔ ومع ذلك، يجب أن يكونوا راغبين ويجب أن تُقرأ الرقية بالطرق الإسلامية فقط۔

س10: هل أحتاج إلى شيخ خاص لإزالة العين؟
ج: لا، يمكن لأي شخص قراءة الرقية۔ يمكنك حتى القيام بها بنفسك۔ القرآن للجميع، وليس فقط للأشخاص الخاصين۔ النبي ﷺ علّم الرقية لجميع الصحابة۔

س11: هل يمكنني الاستماع إلى صوتيات الرقية عبر الإنترنت؟
ج: نعم، الاستماع إلى تلاوات الرقية يمكن أن يكون مفيداً۔ ومع ذلك، القيام بها بنفسك أو جعل شخص يقرأ عليك مباشرة أكثر فعالية۔

س12: كم من الوقت يستغرق إزالة العين؟
ج: يختلف۔ بعض الناس يشعرون بالراحة على الفور، والبعض الآخر قد يحتاج أياماً أو أسابيع من الرقية المستمرة۔ المفتاح هو الاستمرارية والإيمان بالله۔

س13: هل يمكن للعين أن تؤثر على عملي أو دراستي؟
ج: نعم، يمكن للعين أن تؤثر على أي نعمة - الصحة، المال، العمل، الدراسة، العلاقات، الأطفال، أو الممتلكات۔

س14: هل يجوز مشاركة إنجازاتي على وسائل التواصل؟
ج: ليس حراماً، لكن كن حكيماً۔ اكتب دائماً "ما شاء الله" مع المنشورات، اشكر الله، شارك للإلهام وليس للتباهي، وفكر في إعدادات الخصوصية۔

س15: هل يجب أن أخفي جميع نعمي؟
ج: لا حاجة لإخفاء كل شيء، لكن تجنب العرض المفرط۔ قال النبي ﷺ: "استعينوا على إنجاح الحوائج بالكتمان، فإن كل ذي نعمة محسود۔"

س16: هل يمكن لغير المسلمين أن يصيبوا المسلمين بالعين؟
ج: نعم، يمكن أن تأتي العين من أي شخص - مسلم أو غير مسلم، صديق أو عدو، عائلة أو غريب۔

س17: هل قول "تبارك الله" نفس "ما شاء الله"؟
ج: كلاهما جيد۔ "ما شاء الله" تعني "ما شاء الله" وأكثر شيوعاً للحماية۔ "تبارك الله" تعني "بارك الله فيك" وهي مفيدة أيضاً۔

س18: هل يمكن منع العين تماماً؟
ج: نعم، أذكار الصباح والمساء المستمرة، تلاوة القرآن المنتظمة، قول ما شاء الله، الحفاظ على التواضع، والثقة في الله توفر حماية قوية۔

س19: هل العين نفس السحر الأسود؟
ج: لا، هما مختلفان۔ العين (العين) هي ضرر من خلال النظرة، غالباً غير مقصودة۔ السحر الأسود (السحر) هو استخدام متعمد للجن والتعاويذ للأذى، وهو خطيئة كبيرة وكفر۔

س20: هل يمكن للحيوانات أن يكون لها عين؟
ج: بعض العرب في الجاهلية اعتقدوا ذلك، لكن لا يوجد دليل إسلامي صحيح۔ الحماية لا تزال نفسها - القرآن والدعاء۔

س21: ماذا لو لم أعرف من أصابني بالعين؟
ج: لا تحتاج إلى المعرفة۔ يمكنك قراءة الرقية على نفسك أو جعل شخص يقرأ لك۔ مساعدة الله لا تعتمد على تحديد المصدر۔

س22: هل يمكن للتميمة القرآنية أن تحمي من العين؟
ج: العلماء يختلفون۔ البعض يسمح بالتميمة القرآنية بشروط، لكن الكثيرين يمنعونها۔ الرأي الأقوى هو تجنب جميع التمائم والاعتماد على التلاوة الفعلية للقرآن والأدعية۔

س23: هل يجب أن أواجه من أصابني بالعين؟
ج: لا، الإسلام يعلّم آداباً أفضل۔ إذا كنت تعرف من هو، اطلب منه بأدب أن يتوضأ واستخدم ذلك الماء للعلاج۔ لا حاجة للمواجهة أو الاتهامات۔

س24: هل العين أقوى من الدعاء؟
ج: لا، لا شيء أقوى من قدر الله۔ قال النبي ﷺ إن العين قوية، لكنه أيضاً علّمنا الحماية من خلال القرآن والدعاء التي كافية۔

س25: هل يمكن أن تُصيب العين من خلال الصور؟
ج: نعم، رؤية صورة شخص والإعجاب به أو حسده يمكن أن يؤثر عليه محتملاً، ولهذا ينصح العلماء بالحذر في مشاركة الصور، خاصة للأطفال۔

س26: ما الفرق بين العين والحسد والنظر؟
ج:
• الحسد = الحسد الداخلي (الشعور)
• العين/النظر = العين الشريرة (التأثير)
• الحسد يمكن أن يؤدي إلى العين، لكن العين يمكن أن تأتي أيضاً من الإعجاب بدون حسد

س27: هل يمكن للجن أن يصيبوا بالعين؟
ج: النصوص الإسلامية تذكر أن الضرر يمكن أن يأتي من الجن، لكن العين تشير تحديداً إلى النظرة البشرية۔ للجن طرقهم الخاصة في الأذى، والتي تعالجها الرقية أيضاً۔

س28: هل هذه عين أم مجرد حظ سيئ؟
ج: لا يوجد "حظ" في الإسلام - كل شيء بقدر الله۔ ما يسميه البعض "الحظ السيئ" يمكن أن يكون عيناً، أو اختباراً من الله، أو نتيجة لأفعالنا۔ اطلب الحماية واصبر۔

س29: هل يمكنني قراءة الرقية أثناء الحيض؟
ج: نعم، يمكن للنساء قراءة القرآن للرقية أثناء الحيض لأنه للشفاء۔ هناك فرق بين التلاوة للعبادة (غير مسموح) وللشفاء (مسموح)۔

س30: كم مرة يجب أن أقرأ الرقية الواقية؟
ج: يجب أن تكون أذكار الصباح والمساء اليومية منتظمة۔ إذا شعرت بأعراض، اقرأ الرقية حسب الحاجة۔ الوقاية خير من العلاج، لذا حافظ على الحماية اليومية۔

التذكير الأخير:
• العين حقيقية لكن لا تكن مصاباً بالوسواس
• الحماية من الله وحده
• استخدم الطرق الإسلامية الصحيحة
• اطلب المساعدة الطبية إلى جانب الرعاية الروحانية
• كن قوي الإيمان وثق في الله
• الأذكار المنتظمة أفضل دفاع لك
• عش بالشكر والتواضع

اللهم احفظنا جميعاً من العين وكل شر۔ آمين۔''',
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
      body: Builder(
        builder: (context) {
          final langCode = context.languageProvider.languageCode;
          final isRtl = langCode == 'ur' || langCode == 'ar';
          return SingleChildScrollView(
            padding: context.responsive.paddingRegular,
            child: Column(
              crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          );
        },
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
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
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
                width: responsive.iconLarge * 1.5,
                height: responsive.iconLarge * 1.5,
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2.0),
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
              responsive.hSpaceSmall,

              // Title and Icon chip
              Expanded(
                child: Column(
                  crossAxisAlignment: (langCode == 'ur' || langCode == 'ar')
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                      ),
                      textDirection: (langCode == 'ur' || langCode == 'ar') ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    responsive.vSpaceXSmall,
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
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('nazar'),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
