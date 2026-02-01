import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class ZamzamFazilatScreen extends StatefulWidget {
  const ZamzamFazilatScreen({super.key});

  @override
  State<ZamzamFazilatScreen> createState() => _ZamzamFazilatScreenState();
}

class _ZamzamFazilatScreenState extends State<ZamzamFazilatScreen> {


  final List<Map<String, dynamic>> _zamzamTopics = [
    {
      'number': 1,
      'titleKey': 'zamzam_fazilat_1_origin_of_zamzam',
      'title': 'Origin of Zamzam',
      'titleUrdu': 'زمزم کی ابتداء',
      'titleHindi': 'ज़मज़म की इब्तिदा',
      'titleArabic': 'نشأة ماء زمزم',
      'icon': Icons.water_drop,
      'color': Colors.blue,
      'details': {
        'english': '''The Miraculous Origin of Zamzam

Zamzam is a miraculous well located within the Masjid al-Haram in Makkah, approximately 20 meters east of the Kaaba.

The Story of Its Origin:
• Prophet Ibrahim (AS) left his wife Hajar and infant son Ismail (AS) in the barren valley of Makkah by Allah's command
• When their water ran out, Hajar ran between Safa and Marwa seven times searching for water
• The angel Jibreel (AS) struck the ground (or baby Ismail kicked) and water gushed forth
• This became the blessed well of Zamzam

The Name "Zamzam":
• Comes from the Arabic word "zam" meaning "stop" or "contain"
• Hajar said "Zam! Zam!" (Stop! Stop!) trying to contain the gushing water
• Some say it means "abundant water"

Historical Significance:
• The well has been flowing for approximately 4,000 years
• It has never dried up despite being in a desert
• The tribe of Jurhum settled near it, and Makkah grew around it
• Abdul Muttalib (Prophet's grandfather) rediscovered and restored the well

Scientific Marvel:
• The well is about 30 meters deep
• Water flows from rock cracks at a rate of 11-18.5 liters per second
• Despite millions drinking from it yearly, it never depletes''',
        'urdu': '''زمزم کا معجزاتی آغاز

زمزم مسجد الحرام مکہ میں واقع ایک معجزاتی کنواں ہے، کعبہ سے تقریباً 20 میٹر مشرق میں۔

اس کی ابتداء کی کہانی:
• حضرت ابراہیم علیہ السلام نے اللہ کے حکم سے اپنی بیوی ہاجرہ اور شیر خوار بیٹے اسماعیل علیہ السلام کو مکہ کی خشک وادی میں چھوڑا
• جب ان کا پانی ختم ہوا، ہاجرہ نے پانی کی تلاش میں صفا اور مروہ کے درمیان سات بار دوڑیں
• فرشتہ جبریل علیہ السلام نے زمین پر مارا (یا بچے اسماعیل نے ٹھوکر ماری) اور پانی پھوٹ پڑا
• یہ زمزم کا مبارک کنواں بن گیا

نام "زمزم":
• عربی لفظ "زم" سے آیا ہے جس کا مطلب "رکو" یا "روکو"
• ہاجرہ نے بہتے پانی کو روکنے کی کوشش میں "زم! زم!" کہا
• کچھ کہتے ہیں اس کا مطلب "کثیر پانی" ہے

تاریخی اہمیت:
• یہ کنواں تقریباً 4000 سال سے بہہ رہا ہے
• صحرا میں ہونے کے باوجود کبھی نہیں سوکھا
• قبیلہ جرہم اس کے قریب آباد ہوا اور مکہ اس کے گرد بڑھا
• عبدالمطلب (نبی ﷺ کے دادا) نے کنویں کو دوبارہ دریافت اور بحال کیا

سائنسی حیرت:
• کنواں تقریباً 30 میٹر گہرا ہے
• پانی چٹان کی دراڑوں سے 11-18.5 لیٹر فی سیکنڈ کی رفتار سے بہتا ہے
• لاکھوں لوگ سالانہ پیتے ہیں پھر بھی کبھی ختم نہیں ہوتا''',
        'hindi': '''ज़मज़म का मोजिज़ाती आग़ाज़

ज़मज़म मस्जिदुल हराम मक्का में वाक़े एक मोजिज़ाती कुआं है, काबा से तक़रीबन 20 मीटर मशरिक़ में।

इसकी इब्तिदा की कहानी:
• हज़रत इब्राहीम अलैहिस्सलाम ने अल्लाह के हुक्म से अपनी बीवी हाजरा और शीरख़्वार बेटे इस्माईल अलैहिस्सलाम को मक्का की ख़ुश्क वादी में छोड़ा
• जब उनका पानी ख़त्म हुआ, हाजरा ने पानी की तलाश में सफ़ा और मरवा के दरमियान सात बार दौड़ीं
• फ़रिश्ता जिब्रईल अलैहिस्सलाम ने ज़मीन पर मारा (या बच्चे इस्माईल ने ठोकर मारी) और पानी फूट पड़ा
• यह ज़मज़म का मुबारक कुआं बन गया

नाम "ज़मज़म":
• अरबी लफ़्ज़ "ज़म" से आया है जिसका मतलब "रुको" या "रोको"
• हाजरा ने बहते पानी को रोकने की कोशिश में "ज़म! ज़म!" कहा
• कुछ कहते हैं इसका मतलब "कसीर पानी" है

तारीख़ी अहमियत:
• यह कुआं तक़रीबन 4000 साल से बह रहा है
• सहरा में होने के बावजूद कभी नहीं सूखा
• क़बीला जुरहुम इसके क़रीब आबाद हुआ और मक्का इसके गिर्द बढ़ा
• अब्दुल मुत्तलिब (नबी ﷺ के दादा) ने कुएं को दोबारा दरयाफ़्त और बहाल किया

साइंसी हैरत:
• कुआं तक़रीबन 30 मीटर गहरा है
• पानी चट्टान की दराड़ों से 11-18.5 लीटर प्रति सेकंड की रफ़्तार से बहता है
• लाखों लोग सालाना पीते हैं फिर भी कभी ख़त्म नहीं होता''',
        'arabic': '''نشأة ماء زمزم

قصة ظهور بئر زمزم المباركة.

قصة هاجر وإسماعيل:
• تركهما إبراهيم عليه السلام في مكة
• نفد الماء والطعام
• سعت هاجر بين الصفا والمروة سبع مرات
• فجر الله الماء تحت قدم إسماعيل
• "رَبَّنَا إِنِّي أَسْكَنتُ مِن ذُرِّيَّتِي بِوَادٍ غَيْرِ ذِي زَرْعٍ" (سورة إبراهيم: 37)

تسمية زمزم:
• سميت زمزم لكثرة مائها
• قيل: لزمزمة الماء عند خروجه
• قيل: لجمعها الماء

حفر البئر:
• أول من حفرها إسماعيل عليه السلام
• طمرتها قبيلة جرهم
• أعاد حفرها عبد المطلب جد النبي ﷺ
• رأى في المنام موضعها

بركة زمزم:
• قال النبي ﷺ: "ماء زمزم لما شرب له" (ابن ماجه)
• ماء مبارك
• لا ينضب أبداً
• يشربه ملايين الحجاج والمعتمرين'''
      },
    },
    {
      'number': 2,
      'titleKey': 'zamzam_fazilat_2_virtues_in_hadith',
      'title': 'Virtues in Hadith',
      'titleUrdu': 'حدیث میں فضائل',
      'titleHindi': 'हदीस में फ़ज़ाइल',
      'titleArabic': 'فضائل زمزم في الأحاديث',
      'icon': Icons.menu_book,
      'color': Colors.green,
      'details': {
        'english': '''Virtues of Zamzam in Hadith

The Prophet ﷺ mentioned many virtues of Zamzam water in authentic narrations.

"Best Water on Earth":
• The Prophet ﷺ said: "The best water on the face of the earth is Zamzam water. In it is food for the hungry and healing for the sick." (At-Tabarani)

"For Whatever It Is Drunk For":
• The Prophet ﷺ said: "Zamzam water is for whatever it is drunk for." (Ibn Majah)
• Make sincere dua when drinking, and Allah may grant your need

The Prophet's Practice:
• The Prophet ﷺ used to carry Zamzam water in water-skins
• He would pour it on the sick and give it to them to drink
• He asked for Zamzam when he returned to Madinah from Makkah

Food for the Hungry:
• Abu Dharr (RA) survived for 30 days on nothing but Zamzam
• He said to the Prophet ﷺ: "I have been here for thirty days and nights, and I had no food except Zamzam."
• The Prophet ﷺ said: "It is blessed water. It is food for the hungry." (Sahih Muslim)

Healing Properties:
• The Prophet ﷺ said: "Zamzam water is a cure for whatever (ailment) it is drunk for."
• Many scholars and righteous people have experienced its healing
• Ibn Abbas (RA) said: "We used to call it Shabbaa'ah (satisfying)"''',
        'urdu': '''حدیث میں زمزم کے فضائل

نبی کریم ﷺ نے صحیح روایات میں زمزم پانی کے بہت سے فضائل بیان کیے۔

"زمین پر بہترین پانی":
• نبی کریم ﷺ نے فرمایا: "زمین پر بہترین پانی زمزم کا پانی ہے۔ اس میں بھوکے کے لیے خوراک اور بیمار کے لیے شفا ہے۔" (طبرانی)

"جس لیے پیا جائے":
• نبی کریم ﷺ نے فرمایا: "زمزم کا پانی جس لیے پیا جائے (اسی کے لیے ہے)۔" (ابن ماجہ)
• پیتے وقت مخلصانہ دعا کریں، اللہ آپ کی ضرورت پوری فرما سکتا ہے

نبی کریم ﷺ کا عمل:
• نبی کریم ﷺ زمزم کا پانی مشکیزوں میں لے جاتے
• آپ ﷺ بیماروں پر ڈالتے اور انہیں پلاتے
• مکہ سے مدینہ واپسی پر آپ ﷺ نے زمزم مانگا

بھوکوں کے لیے خوراک:
• ابو ذر رضی اللہ عنہ صرف زمزم پر 30 دن گزارے
• انہوں نے نبی ﷺ سے کہا: "میں یہاں تیس دن رات رہا اور میرے پاس زمزم کے سوا کوئی کھانا نہیں تھا۔"
• نبی کریم ﷺ نے فرمایا: "یہ مبارک پانی ہے۔ یہ بھوکے کے لیے خوراک ہے۔" (صحیح مسلم)

شفائی خصوصیات:
• نبی کریم ﷺ نے فرمایا: "زمزم کا پانی جس (بیماری) کے لیے پیا جائے شفا ہے۔"
• بہت سے علماء اور نیک لوگوں نے اس کی شفا کا تجربہ کیا
• ابن عباس رضی اللہ عنہ نے کہا: "ہم اسے شباعہ (سیر کرنے والا) کہتے تھے"''',
        'hindi': '''हदीस में ज़मज़म की फ़ज़ीलत

नबी करीम ﷺ ने सहीह रिवायात में ज़मज़म पानी की बहुत सी फ़ज़ीलतें बयान कीं।

"ज़मीन पर बेहतरीन पानी":
• नबी करीम ﷺ ने फ़रमाया: "ज़मीन पर बेहतरीन पानी ज़मज़म का पानी है। इसमें भूखे के लिए ख़ुराक और बीमार के लिए शिफ़ा है।" (तबरानी)

"जिसके लिए पिया जाए":
• नबी करीम ﷺ ने फ़रमाया: "ज़मज़म का पानी जिसके लिए पिया जाए (उसी के लिए है)।" (इब्ने माजा)
• पीते वक़्त मुख़्लिसाना दुआ करें, अल्लाह आपकी ज़रूरत पूरी फ़रमा सकता है

नबी करीम ﷺ का अमल:
• नबी करीम ﷺ ज़मज़म का पानी मशकीज़ों में ले जाते
• आप ﷺ बीमारों पर डालते और उन्हें पिलाते
• मक्का से मदीना वापसी पर आप ﷺ ने ज़मज़म मांगा

भूखों के लिए ख़ुराक:
• अबू ज़र रज़ियल्लाहु अन्हु सिर्फ़ ज़मज़म पर 30 दिन गुज़ारे
• उन्होंने नबी ﷺ से कहा: "मैं यहां तीस दिन रात रहा और मेरे पास ज़मज़म के सिवा कोई खाना नहीं था।"
• नबी करीम ﷺ ने फ़रमाया: "यह मुबारक पानी है। यह भूखे के लिए ख़ुराक है।" (सहीह मुस्लिम)

शिफ़ाई ख़ुसूसियात:
• नबी करीम ﷺ ने फ़रमाया: "ज़मज़म का पानी जिस (बीमारी) के लिए पिया जाए शिफ़ा है।"
• बहुत से उलमा और नेक लोगों ने इसकी शिफ़ा का तजुर्बा किया
• इब्ने अब्बास रज़ियल्लाहु अन्हु ने कहा: "हम इसे शब्बाआह (सेर करने वाला) कहते थे"''',
        'arabic': '''فضائل زمزم في الأحاديث

أحاديث النبي ﷺ في فضل ماء زمزم.

ماء زمزم لما شرب له:
• قال النبي ﷺ: "ماء زمزم لما شرب له" (ابن ماجه)
• من شربه للشبع أشبعه الله
• من شربه للشفاء شفاه الله
• من شربه لحاجة قضاها الله

خير ماء على وجه الأرض:
• قال النبي ﷺ: "خير ماء على وجه الأرض ماء زمزم" (الطبراني)
• طعام طعم وشفاء سقم
• بارك الله فيه
• ماء مبارك

شراب النبي ﷺ من زمزم:
• شرب منه النبي ﷺ
• توضأ منه
• صب على رأسه
• دعا عنده

الشرب قائماً:
• شرب النبي ﷺ من زمزم قائماً
• استثناء من النهي عن الشرب قائماً
• لفضله وبركته

الدعاء عند شربه:
• يستحب الدعاء عند شربه
• اللهم إني أسألك علماً ناف��اً ورزقاً واسعاً وشفاءً من كل داء'''
      },
    },
    {
      'number': 3,
      'titleKey': 'zamzam_fazilat_3_how_to_drink_zamzam',
      'title': 'How to Drink Zamzam',
      'titleUrdu': 'زمزم پینے کا طریقہ',
      'titleHindi': 'ज़मज़म पीने का तरीक़ा',
      'titleArabic': 'آداب شرب ماء زمزم',
      'icon': Icons.local_drink,
      'color': Colors.cyan,
      'details': {
        'english': '''The Sunnah Way of Drinking Zamzam

There are specific etiquettes for drinking Zamzam water according to the Sunnah.

Face the Qiblah:
• It is recommended to face the direction of Kaaba while drinking
• This shows respect for the blessed water

Drink in Three Sips:
• Following the Sunnah of drinking any beverage
• Say "Bismillah" before starting
• Pause between sips to breathe

Make Dua:
• The Prophet ﷺ said: "Zamzam is for whatever it is drunk for"
• Make sincere supplication while drinking
• Ask Allah for knowledge, cure from illness, provision, or any need

Ibn Abbas's Dua:
• "O Allah, I ask You for beneficial knowledge, abundant provision, and cure from every disease."
• This is a comprehensive dua to make when drinking Zamzam

Drink to Fullness:
• It is Sunnah to drink your fill of Zamzam
• The Prophet ﷺ drank until satisfied
• One of the signs of a munafiq (hypocrite) was said to be that they don't drink their fill of Zamzam

Say Alhamdulillah:
• After drinking, praise Allah
• Thank Him for this blessed water

Standing vs Sitting:
• The Prophet ﷺ drank Zamzam while standing
• Some scholars say this is specific to Zamzam
• Others say sitting is generally better for other drinks''',
        'urdu': '''زمزم پینے کا سنت طریقہ

سنت کے مطابق زمزم پینے کے مخصوص آداب ہیں۔

قبلہ رخ ہوں:
• پیتے وقت کعبہ کی طرف منہ کرنا مستحب ہے
• یہ مبارک پانی کی عزت ظاہر کرتا ہے

تین گھونٹ میں پئیں:
• کوئی بھی مشروب پینے کی سنت کے مطابق
• شروع میں "بسم اللہ" کہیں
• سانس لینے کے لیے گھونٹوں کے درمیان رکیں

دعا کریں:
• نبی کریم ﷺ نے فرمایا: "زمزم جس لیے پیا جائے (اسی کے لیے ہے)"
• پیتے وقت مخلصانہ دعا کریں
• اللہ سے علم، بیماری سے شفا، رزق یا کوئی ضرورت مانگیں

ابن عباس کی دعا:
• "اے اللہ، میں تجھ سے نفع بخش علم، فراوان رزق اور ہر بیماری سے شفا مانگتا ہوں۔"
• زمزم پیتے وقت یہ جامع دعا ہے

پیٹ بھر کر پئیں:
• زمزم سیر ہو کر پینا سنت ہے
• نبی کریم ﷺ سیر ہونے تک پ��تے
• کہا جاتا ہے کہ منافق کی علامات میں سے ایک یہ ہے کہ وہ زمزم سیر ہو کر نہیں پیتا

الحمد للہ کہیں:
• پینے کے بعد اللہ کی حمد کریں
• اس مبارک پانی کے لیے شکر کریں

کھڑے ہو کر بمقابلہ بیٹھ کر:
• نبی کریم ﷺ نے کھڑے ہو کر زمزم پیا
• بعض علماء کہتے ہیں یہ زمزم کے لیے خاص ہے
• دوسرے کہتے ہیں عام مشروبات کے لیے بیٹھ کر پینا بہتر ہے''',
        'hindi': '''ज़मज़म पीने का सुन्नत तरीक़ा

सुन्नत के मुताबिक़ ज़मज़म पीने के मख़सूस आदाब हैं।

क़िबला रुख़ हों:
• पीते वक़्त काबा की तरफ़ मुंह करना मुस्तहब है
• यह मुबारक पानी की इज़्ज़त ज़ाहिर करता है

तीन घूंट में पिएं:
• कोई भी मशरूब पीने की सुन्नत के मुताबिक़
• शुरू में "बिस्मिल्लाह" कहें
• सांस लेने के लिए घूंटों के दरमियान रुकें

दुआ करें:
• नबी करीम ﷺ ने फ़रमाया: "ज़मज़म जिसके लिए पिया जाए (उसी के लिए है)"
• पीते वक़्त मुख़्लिसाना दुआ करें
• अल्लाह से इल्म, बीमारी से शिफ़ा, रिज़्क़ या कोई ज़रूरत मांगें

इब्ने अब्बास की दुआ:
• "ऐ अल्लाह, मैं तुझसे नफ़ाबख़्श इल्म, फ़रावान रिज़्क़ और हर बीमारी से शिफ़ा मांगता हूं।"
• ज़मज़म पीते वक़्त यह जामेअ दुआ है

पेट भरकर पिएं:
• ज़मज़म सेर होकर पीना सुन्नत है
• नबी करीम ﷺ सेर होने तक पीते
• कहा जाता है कि मुनाफ़िक़ की अलामात में से एक यह है कि वो ज़मज़म सेर होकर नहीं पीता

अलहम्दुलिल्लाह कहें:
• पीने के बाद अल्लाह की हम्द करें
• इस मुबारक पानी के लिए शुक्र करें

खड़े होकर बमुक़ाबला बैठकर:
• नबी करीम ﷺ ने खड़े होकर ज़मज़म पिया
• बाज़ उलमा कहते हैं यह ज़मज़म के लिए ख़ास है
• दूसरे कहते हैं आम मशरूबात के लिए बैठकर पीना बेहतर है''',
        'arabic': '''آداب شرب ماء زمزم

السنن والآداب عند شرب زمزم.

النية:
• استحضار النية عند الشرب
• "ماء زمزم لما شرب له"
• نية الشفاء أو العلم أو الحاجة

الدعاء:
• الدعاء قبل الشرب
• اللهم إني أسألك علماً نافعاً ورزقاً واسعاً
• وشفاءً من كل داء

التسمية:
• البسملة قبل الشرب
• بسم الله الرحمن الرحيم

الشرب على ثلاث مرات:
• كما كان النبي ﷺ يشرب
• التنفس خارج الإناء
• الريّ والإرواء

استقبال القبلة:
• يستحب استقبال القبلة
• الوقوف عند الشرب
• رفع البصر إلى السماء

الإكثار منه:
• الشرب حتى الارتواء
• الري الكامل
• "طعام طعم وشفاء سقم"'''
      },
    },
    {
      'number': 4,
      'titleKey': 'zamzam_fazilat_4_scientific_properties',
      'title': 'Scientific Properties',
      'titleUrdu': 'سائنسی خصوصیات',
      'titleHindi': 'साइंसी ख़ुसूसियात',
      'titleArabic': 'الخصائص العلمية لزمزم',
      'icon': Icons.science,
      'color': Colors.purple,
      'details': {
        'english': '''Scientific Properties of Zamzam Water

Modern scientific analysis has revealed unique properties of Zamzam water.

Chemical Composition:
• Higher mineral content than regular water
• Contains calcium, magnesium, and fluoride
• Rich in bicarbonates
• Optimal pH level (slightly alkaline: 7.5-8)

Unique Characteristics:
• No algae or vegetation grows in it
• Remains pure without treatment
• Never been affected by microbiological contamination
• Stable taste and composition over thousands of years

Research Findings:
• Japanese researcher Dr. Masaru Emoto found Zamzam has a unique crystalline structure
• European laboratory tests confirmed its purity
• Contains natural fluoride beneficial for teeth
• Mineral balance is ideal for human consumption

Comparison with Other Waters:
• More minerals than most bottled waters
• Higher calcium content
• Better absorption by the body
• No harmful bacteria despite no chemical treatment

The Well's Capacity:
• Feeds millions of pilgrims annually
• Pumps operate 24 hours during Hajj
• Can pump up to 8,000 liters per second without depleting
• Water level recovers within 11 minutes when pumping stops

Storage:
• Can be stored for years without change
• Does not develop odor or taste change
• Remains microbiologically stable
• Best stored in clean containers away from sunlight''',
        'urdu': '''زمزم پانی کی سائنسی خصوصیات

جدید سائنسی تجزیے نے زمزم پانی کی منفرد خصوصیات کا انکشاف کیا ہے۔

کیمیائی ساخت:
• عام پانی سے زیادہ معدنیات
• کیلشیم، میگنیشیم اور فلورائیڈ شامل ہے
• بائی کاربونیٹس سے بھرپور
• مناسب پی ایچ لیول (ہلکا الکلائن: 7.5-8)

منفرد خصوصیات:
• اس میں کوئی کائی یا پودے نہیں اگتے
• بغیر ٹریٹمنٹ کے خالص رہتا ہے
• کبھی مائکروبیولوجیکل آلودگی سے متاثر نہیں ہوا
• ہزاروں سالوں سے ذائقہ اور ساخت مستحکم ہے

تحقیقی نتائج:
• جاپانی محقق ڈاکٹر ماسارو ایموٹو نے پایا کہ زمزم کی منفرد کرسٹل ساخت ہے
• یورپی لیبارٹری ٹیسٹ نے اس کی پاکیزگی کی تصدیق کی
• دانتوں کے لیے فائدہ مند قدرتی فلورائیڈ ہے
• معدنیات کا توازن انسانی استعمال کے لیے مثالی ہے

دوسرے پانیوں سے موازنہ:
• زیادہ تر بوتل بند پانیوں سے زیادہ معدنیات
• زیادہ کیلشیم
• جسم میں بہتر جذب ہوتا ہے
• کیمیائی ٹریٹمنٹ کے بغیر کوئی نقصان دہ بیکٹیریا نہیں

کنویں کی گنجائش:
• سالانہ لاکھوں حجاج کو پانی دیتا ہے
• حج کے دوران پمپ 24 گھنٹے چلتے ہیں
• بغیر ختم ہوئے 8000 لیٹر فی سیکنڈ تک پمپ کر سکتے ہیں
• پمپنگ رکنے کے 11 منٹ میں پانی کی سطح بحال ہو جاتی ہے

ذخیرہ:
• بغیر تبدیلی کے سالوں تک رکھا جا سکتا ہے
• بو یا ذائقہ نہیں بدلتا
• مائکروبیولوجیکل طور پر مستحکم رہتا ہے
• صاف برتنوں میں سورج کی روشنی سے دور رکھنا بہتر ہے''',
        'hindi': '''ज़मज़म पानी की साइंसी ख़ुसूसियात

जदीद साइंसी तज्ज़िए ने ज़मज़म पानी की मुनफ़रिद ख़ुसूसियात का इंकिशाफ़ किया है।

केमिकल साख़्त:
• आम पानी से ज़्यादा मअदनियात
• कैल्शियम, मैग्नीशियम और फ़्लोराइड शामिल है
• बाई कार्बोनेट्स से भरपूर
• मुनासिब पी एच लेवल (हल्का अल्कलाइन: 7.5-8)

मुनफ़रिद ख़ुसूसियात:
• इसमें कोई काई या पौधे नहीं उगते
• बग़ैर ट्रीटमेंट के ख़ालिस रहता है
• कभी माइक्रोबायोलॉजिकल आलूदगी से मुतास्सिर नहीं हुआ
• हज़ारों सालों से ज़ायक़ा और साख़्त मुस्तहकम है

तहक़ीक़ी नताइज:
• जापानी मुहक़्क़िक़ डॉ. मासारू इमोतो ने पाया कि ज़मज़म की मुनफ़रिद क्रिस्टल साख़्त है
• यूरोपियन लेबोरेटरी टेस्ट ने इसकी पाकीज़गी की तसदीक़ की
• दांतों के लिए फ़ायदेमंद क़ुदरती फ़्लोराइड है
• मअदनियात का तवाज़ुन इंसानी इस्तेमाल के लिए मिसाली है

दूसरे पानियों से मुवाज़ना:
• ज़्यादातर बोतलबंद पानियों से ज़्यादा मअदनियात
• ज़्यादा कैल्शियम
• जिस्म में बेहतर जज़्ब होता है
• केमिकल ट्रीटमेंट के बग़ैर कोई नुक़सानदेह बैक्टीरिया नहीं

कुएं की गुंजाइश:
• सालाना लाखों हुज्जाज को पानी देता है
• हज के दौरान पंप 24 घंटे चलते हैं
• बग़ैर ख़त्म हुए 8000 लीटर प्रति सेकंड तक पंप कर सकते हैं
• पंपिंग रुकने के 11 मिनट में पानी की सतह बहाल हो जाती है

ज़ख़ीरा:
• बग़ैर तब्दीली के सालों तक रखा जा सकता है
• बू या ज़ायक़ा नहीं बदलता
• माइक्रोबायोलॉजिकल तौर पर मुस्तहकम रहता है
• साफ़ बर्तनों में सूरज की रोशनी से दूर रखना बेहतर है''',
        'arabic': '''الخصائص العلمية لزمزم

الخواص الفريدة لماء زمزم.

التركيب الكيميائي:
• يحتوي على معادن نافعة
• نسبة الأملاح أعلى من الماء العادي
• الكالسيوم والمغنيسيوم
• غني بالفلورايد

خصائص فيزيائية:
• لا يتعفن ولا يتغير طعمه
• لا ينضب مع كثرة الاستخراج
• درجة حرارته ثابتة
• نقاء وصفاء

الفوائد الصحية:
• يقوي جهاز المناعة
• يساعد على الهضم
• ينشط الدورة الدموية
• يعطي طاقة للجسم

الإعجاز العلمي:
• البئر في وادٍ غير ذي زرع
• استمرار تدفقه آلاف السنين
• لا يتأثر بالعوامل الجوية
• معجزة إلهية

الدراسات العلمية:
• أثبتت الأبحاث تميزه
• خلوه من الجراثيم
• صلاحيته للشرب الدائم
• فوائده الصحية المتعددة'''
      },
    },
    {
      'number': 5,
      'titleKey': 'zamzam_fazilat_5_benefits_uses',
      'title': 'Benefits & Uses',
      'titleUrdu': 'فوائد اور استعمال',
      'titleHindi': 'फ़वाइद और इस्तेमाल',
      'titleArabic': 'فوائد واستخدامات زمزم',
      'icon': Icons.health_and_safety,
      'color': Colors.teal,
      'details': {
        'english': '''Benefits and Uses of Zamzam Water

Zamzam water has numerous spiritual and physical benefits.

Spiritual Benefits:
• Blessed water from a miraculous source
• Strengthens faith when consumed with intention
• Answer to prayers when drunk with sincere dua
• Connection to the legacy of Prophet Ibrahim (AS) and Hajar

Health Benefits (as reported):
• General healing properties as stated in hadith
• May help with digestive issues
• Reported benefits for skin conditions
• Energy and vitality boost
• Satisfies both hunger and thirst

Uses of Zamzam:
1. Drinking:
   • For general blessing and health
   • With specific duas for needs
   • When breaking fast

2. Medical Uses:
   • Pouring on sick areas
   • Drinking for cure (with trust in Allah)
   • The Prophet ﷺ poured it on sick companions

3. Spiritual Purposes:
   • Ruqyah (spiritual healing)
   • Seeking blessing for important occasions
   • Gift to family and friends

4. Special Occasions:
   • Upon returning from Hajj/Umrah
   • During illness
   • For newborns (tahnik)

Important Reminder:
• True healing comes from Allah alone
• Zamzam is a means, not the source of cure
• Combine with medical treatment when needed
• Have complete trust in Allah (tawakkul)''',
        'urdu': '''زمزم پانی کے فوائد اور استعمال

زمزم پانی کے متعدد روحانی اور جسمانی فوائد ہیں۔

روحانی فوائد:
• معجزاتی ذریعے سے مبارک پانی
• نیت کے ساتھ پینے سے ایمان مضبوط ہوتا ہے
• مخلصانہ دعا کے ساتھ پینے سے دعا کا جواب
• حضرت ابراہیم علیہ السلام اور ہاجرہ کی وراثت سے تعلق

صحت کے فوائد (جیسا کہ بیان کیا گیا):
• حدیث میں بیان کردہ عمومی شفائی خصوصیات
• ہاضمے کے مسائل میں مددگار
• جلدی امراض کے لیے رپورٹ شدہ فوائد
• توانائی اور جوش میں اضافہ
• بھوک اور پیاس دونوں بجھاتا ہے

زمزم کے استعمال:
1. پینا:
   • عمومی برکت اور صحت کے لیے
   • ضروریات کے لیے مخصوص دعاؤں کے ساتھ
   • افطار کرتے وقت

2. طبی استعمال:
   • بیمار حصوں پر ڈالنا
   • شفا کے لیے پینا (اللہ پر بھروسے کے ساتھ)
   • نبی کریم ﷺ بیمار صحابہ پر ڈالتے

3. روحانی مقاصد:
   • رقیہ (روحانی علاج)
   • اہم مواقع پر برکت کی طلب
   • خاندان اور دوستوں کو تحفہ

4. خاص مواقع:
   • حج/عمرہ سے واپسی پر
   • بیماری کے دوران
   • نومولود کے لیے (تحنیک)

اہم یاد دہانی:
• حقیقی شفا صرف اللہ سے آتی ہے
• زمزم ایک ذریعہ ہے، شفا کا منبع نہیں
• ضرورت ہو تو طبی علاج کے ساتھ ملائیں
• اللہ پر مکمل بھروسہ (توکل) رکھیں''',
        'hindi': '''ज़मज़म पानी के फ़वाइद और इस्तेमाल

ज़मज़म पानी के मुतअद्दिद रूहानी और जिस्मानी फ़वाइद हैं।

रूहानी फ़वाइद:
• मोजिज़ाती ज़रीए से मुबारक पानी
• नीयत के साथ पीने से ईमान मज़बूत होता है
• मुख़्लिसाना दुआ के साथ पीने से दुआ का जवाब
• हज़रत इब्राहीम अलैहिस्सलाम और हाजरा की विरासत से ताल्लुक़

सेहत के फ़वाइद (जैसा कि बयान किया गया):
• हदीस में बयान करदा उमूमी शिफ़ाई ख़ुसूसियात
• हाज़मे के मसाइल में मददगार
• जिल्दी अमराज़ के लिए रिपोर्ट शुदा फ़वाइद
• तवानाई और जोश में इज़ाफ़ा
• भूक और प्यास दोनों बुझाता है

ज़मज़म के इस्तेमाल:
1. पीना:
   • उमूमी बरकत और सेहत के लिए
   • ज़रूरियात के लिए मख़सूस दुआओं के साथ
   • इफ़्तार करते वक़्त

2. तिब्बी इस्तेमाल:
   • बीमार हिस्सों पर डालना
   • शिफ़ा के लिए पीना (अल्लाह पर भरोसे के साथ)
   • नबी करीम ﷺ बीमार सहाबा पर डालते

3. रूहानी मक़ासिद:
   • रुक़्या (रूहानी इलाज)
   • अहम मौक़ों पर बरकत की तलब
   • ख़ानदान और दोस्तों को तोहफ़ा

4. ख़ास मौक़े:
   • हज/उमरा से वापसी पर
   • बीमारी के दौरान
   • नवजात के लिए (तहनीक)

अहम याददिहानी:
• हक़ीक़ी शिफ़ा सिर्फ़ अल्लाह से आती है
• ज़मज़म एक ज़रीआ है, शिफ़ा का मंबा नहीं
• ज़रूरत हो तो तिब्बी इलाज के साथ मिलाएं
• अल्लाह पर मुकम्मल भरोसा (तवक्कुल) रखें''',
        'arabic': '''فوائد واستخدامات زمزم

الاستخدامات المتنوعة لماء زمزم.

للشفاء:
• "ماء زمزم لما شرب له"
• شفاء من الأمراض
• التداوي به
• الاستشفاء بإذن الله

للعلم:
• الشرب بنية طلب العلم
• قصة الإمام ابن حجر
• شربه لحفظ القرآن
• للفهم والحفظ

للحاجات:
• قضاء الحوائج
• تفريج الكربات
• تيسير الأمور
• البركة في الرزق

الوضوء منه:
• التوضؤ به أفضل
• كان النبي ﷺ يتوضأ منه
• طهارة خاصة

الغسل به:
• الاغتسال منه مستحب
• غسل الميت به
• تبريد الجسم في الحر

للضيافة:
• تقديمه للضيوف
• إكرام الزوار
• السقيا منه صدقة'''
      },
    },
    {
      'number': 6,
      'titleKey': 'zamzam_fazilat_6_carrying_zamzam',
      'title': 'Carrying Zamzam',
      'titleUrdu': 'زمزم لے جانا',
      'titleHindi': 'ज़मज़म ले जाना',
      'titleArabic': 'حمل ماء زمزم',
      'icon': Icons.luggage,
      'color': Colors.orange,
      'details': {
        'english': '''Carrying Zamzam Water

It is Sunnah to bring Zamzam water back from Hajj or Umrah.

The Prophet's Example:
• The Prophet ﷺ used to carry Zamzam in water-skins and containers
• He would send it to people who were sick
• This establishes the permissibility and recommendation of carrying it

Guidelines for Transporting:
1. Clean Containers:
   • Use food-grade containers
   • Ensure they are thoroughly clean
   • Seal properly to prevent spillage

2. Airline Regulations:
   • Check airline policies
   • Many allow Zamzam in checked luggage
   • Some airlines provide special Zamzam packaging
   • Usually 5-10 liters per person allowed

3. Storage During Travel:
   • Keep away from strong odors
   • Protect from extreme temperatures
   • Pack securely to prevent damage

Gifting Zamzam:
• Excellent gift for family and friends
• The Prophet ﷺ distributed it to others
• Share the blessing with those who couldn't travel
• Tell recipients about its virtues

Etiquettes of Receiving:
• Accept with gratitude
• Make dua for the giver
• Use it properly with intention
• Don't waste it

Home Storage:
• Store in glass or food-safe plastic
• Keep in cool, dark place
• Can last indefinitely if stored properly
• Use clean utensils when pouring''',
        'urdu': '''زمزم پانی لے جانا

حج یا عمرہ سے زمزم لانا سنت ہے۔

نبی کریم ﷺ کا عمل:
• نبی کریم ﷺ زمزم مشکیزوں اور برتنوں میں لے جاتے
• آپ ﷺ بیماروں کو بھیجتے
• اس سے لے جانے کی اجازت اور استحباب ثابت ہوتا ہے

نقل و حمل کی ہدایات:
1. صاف برتن:
   • فوڈ گریڈ برتن استعمال کریں
   • یقینی بنائیں کہ اچھی طرح صاف ہوں
   • رساؤ روکنے کے لیے اچھی طرح بند کریں

2. ایئرلائن قواعد:
   • ایئرلائن پالیسیاں چیک کریں
   • بہت سی چیکڈ سامان میں زمزم کی اجازت دیتی ہیں
   • کچھ ایئرلائنز خاص زمزم پیکنگ فراہم کرتی ہیں
   • عام طور پر فی شخص 5-10 لیٹر کی اجازت

3. سفر کے دوران ذخیرہ:
   • تیز بو سے دور رکھیں
   • انتہائی درجہ حرارت سے بچائیں
   • نقصان سے بچنے کے لیے محفوظ طریقے سے پیک کریں

زمزم تحفے میں دینا:
• خاندان اور دوستوں کے لیے بہترین تحفہ
• نبی کریم ﷺ دوسروں میں تقسیم کرتے
• جو سفر نہیں کر سکے ان کے ساتھ برکت بانٹیں
• وصول کرنے والوں کو اس کے فضائل بتائیں

وصول کرنے کے آداب:
• شکریے کے ساتھ قبول کریں
• دینے والے کے لیے دعا کریں
• نیت کے ساتھ صحیح استعمال کریں
• ضائع نہ کریں

گھریلو ذخیرہ:
• شیشے یا فوڈ سیف پلاسٹک میں رکھیں
• ٹھنڈی، اندھیری جگہ رکھیں
• صحیح ذخیرہ ہو تو ہمیشہ چل سکتا ہے
• ڈالتے وقت صاف برتن استعمال کریں''',
        'hindi': '''ज़मज़म पानी ले जाना

हज या उमरा से ज़मज़म लाना सुन्नत है।

नबी करीम ﷺ का अमल:
• नबी करीम ﷺ ज़मज़म मशकीज़ों और बर्तनों में ले जाते
• आप ﷺ बीमारों को भेजते
• इससे ले जाने की इजाज़त और इस्तेहबाब साबित होता है

नक़्ल व हम्ल की हिदायात:
1. साफ़ बर्तन:
   • फ़ूड ग्रेड बर्तन इस्तेमाल करें
   • यक़ीनी बनाएं कि अच्छी तरह साफ़ हों
   • रिसाव रोकने के लिए अच्छी तरह बंद करें

2. एयरलाइन क़वाइद:
   • एयरलाइन पॉलिसीज़ चेक करें
   • बहुत सी चेक्ड सामान में ज़मज़म की इजाज़त देती हैं
   • कुछ एयरलाइंस ख़ास ज़मज़म पैकिंग फ़राहम करती हैं
   • आम तौर पर प्रति शख़्स 5-10 लीटर की इजाज़त

3. सफ़र के दौरान ज़ख़ीरा:
   • तेज़ बू से दूर रखें
   • इंतिहाई दर्जा हरारत से बचाएं
   • नुक़सान से बचने के लिए महफ़ूज़ तरीक़े से पैक करें

ज़मज़म तोहफ़े में देना:
• ख़ानदान और दोस्तों के लिए बेहतरीन तोहफ़ा
• नबी करीम ﷺ दूसरों में तक़सीम करते
• जो सफ़र नहीं कर सके उनके साथ बरकत बांटें
• वसूल करने वालों को इसकी फ़ज़ीलत बताएं

वसूल करने के आदाब:
• शुक्रिए के साथ क़बूल करें
• देने वाले के लिए दुआ करें
• नीयत के साथ सही इस्तेमाल करें
• ज़ाया न करें

घरेलू ज़ख़ीरा:
• शीशे या फ़ूड सेफ़ प्लास्टिक में रखें
• ठंडी, अंधेरी जगह रखें
• सही ज़ख़ीरा हो तो हमेशा चल सकता है
• डालते वक़्त साफ़ बर्तन इस्तेमाल करें''',
        'arabic': '''حمل ماء زمزم

أحكام وآداب نقل ماء زمزم.

جواز نقله:
• يجوز نقل ماء زمزم للبلدان
• كان النبي ﷺ يُحمل له
• للتبرك والاستشفاء
• هدية كريمة

آداب النقل:
• حفظه في أوعية نظيفة
• عدم إهانته
• تغطيته وصيانته
• الدعاء عند حمله

الهدية بزمزم:
• من أفضل الهدايا
• هدية أم سليم للنبي ﷺ
• إدخال السرور على المسلمين
• نشر البركة

التوزيع:
• توزيعه على الأهل والأحباب
• إهداؤه للمرضى
• السقيا منه صدقة

الحفاظ عليه:
• عدم الإسراف فيه
• حفظه من التلوث
• استخدامه فيما ينفع
• تقديره وإجلاله

الكمية المسموحة:
• يُسمح بحمل 5 لترات للشخص
• في رحلات الحج والعمرة
• حسب أنظمة المطارات
• التقيد بالأنظمة'''
      },
    },
    {
      'number': 7,
      'titleKey': 'zamzam_fazilat_7_prophet_connection',
      'title': 'Prophet\'s Connection to Zamzam',
      'titleUrdu': 'نبی کریم ﷺ اور زمزم',
      'titleHindi': 'नबी करीम ﷺ और ज़मज़म',
      'titleArabic': 'صلة النبي ﷺ بزمزم',
      'icon': Icons.favorite,
      'color': Colors.red,
      'details': {
        'english': '''The Prophet's ﷺ Connection to Zamzam

The Prophet Muhammad ﷺ had a special and deep connection with Zamzam water.

Washing of the Prophet's Heart:
• The Prophet's ﷺ chest was opened and his heart was washed with Zamzam water
• This happened on four occasions according to authentic narrations:
  - In his childhood while with Halima Sa'diyya
  - Before the Night Journey (Isra and Mi'raj)
  - Before receiving prophethood
  - Before the Battle of Badr
• Al-Hafiz al-'Iraqi said: "The reason was to strengthen him to see the kingdoms of heaven and earth, Paradise and Hell"

The Prophet's Practice with Zamzam:
• He ﷺ used to carry Zamzam in water-skins and containers
• He would pour it on the sick and give it to them to drink
• He wrote to Suhayl ibn 'Amr asking him to send Zamzam urgently
• The letter said: "If my letter reaches you at night, do not wait until morning"

Drinking Zamzam Standing:
• The Prophet ﷺ drank Zamzam while standing near the Kaaba
• This is considered an exception to the general recommendation of sitting while drinking
• Some scholars say it was due to the crowds around the well

The Prophet's Love for Zamzam:
• He ﷺ called it "the best water on earth"
• He said it is "food that nourishes and cure for illness"
• He encouraged Muslims to drink it with sincere intention
• He demonstrated its blessing through his own use''',
        'urdu': '''نبی کریم ﷺ کا زمزم سے تعلق

نبی کریم ﷺ کا زمزم پانی سے خاص اور گہرا تعلق تھا۔

نبی کریم ﷺ کے دل کا دھونا:
• نبی کریم ﷺ کا سینہ کھولا گیا اور دل زمزم سے دھویا گیا
• یہ صحیح روایات کے مطابق چار مواقع پر ہوا:
  - بچپن میں حلیمہ سعدیہ کے پاس
  - شب معراج سے پہلے
  - نبوت ملنے سے پہلے
  - غزوہ بدر سے پہلے
• حافظ عراقی نے کہا: "وجہ یہ تھی کہ آپ کو آسمان و زمین، جنت و جہنم کی بادشاہتیں دیکھنے کی طاقت ملے"

نبی کریم ﷺ کا زمزم کے ساتھ عمل:
• آپ ﷺ زمزم مشکیزوں اور برتنوں میں لے جاتے
• آپ ﷺ بیماروں پر ڈالتے اور پلاتے
• آپ ﷺ نے سہیل بن عمرو کو خط لکھا کہ فوری زمزم بھیجیں
• خط میں لکھا: "اگر میرا خط رات کو پہنچے تو صبح کا انتظار نہ کریں"

کھڑے ہو کر زمزم پینا:
• نبی کریم ﷺ نے کعبہ کے قریب کھڑے ہو کر زمزم پیا
• اسے بیٹھ کر پینے کی عمومی سفارش سے استثناء سمجھا جاتا ہے
• بعض علماء کہتے ہیں یہ کنویں کے گرد ہجوم کی وجہ سے تھا

نبی کریم ﷺ کی زمزم سے محبت:
• آپ ﷺ نے اسے "زمین پر بہترین پانی" کہا
• فرمایا یہ "غذا دینے والی خوراک اور بیماری کی شفا" ہے
• مسلمانوں کو مخلصانہ نیت سے پینے کی ترغیب دی
• اپنے استعمال سے اس کی برکت ظاہر کی''',
        'hindi': '''नबी करीम ﷺ का ज़मज़म से ताल्लुक़

नबी करीम ﷺ का ज़मज़म पानी से ख़ास और गहरा ताल्लुक़ था।

नबी करीम ﷺ के दिल का धोना:
• नबी करीम ﷺ का सीना खोला गया और दिल ज़मज़म से धोया गया
• यह सहीह रिवायात के मुताबिक़ चार मौक़ों पर हुआ:
  - बचपन में हलीमा सादिया के पास
  - शबे मेराज से पहले
  - नबुव्वत मिलने से पहले
  - ग़ज़वा बद्र से पहले
• हाफ़िज़ इराक़ी ने कहा: "वजह यह थी कि आप को आसमान व ज़मीन, जन्नत व जहन्नम की बादशाहतें देखने की ताक़त मिले"

नबी करीम ﷺ का ज़मज़म के साथ अमल:
• आप ﷺ ज़मज़म मशकीज़ों और बर्तनों में ले जाते
• आप ﷺ बीमारों पर डालते और पिलाते
• आप ﷺ ने सुहैल बिन अम्र को ख़त लिखा कि फ़ौरी ज़मज़म भेजें
• ख़त में लिखा: "अगर मेरा ख़त रात को पहुंचे तो सुबह का इंतिज़ार न करें"

खड़े होकर ज़मज़म पीना:
• नबी करीम ﷺ ने काबा के क़रीब खड़े होकर ज़मज़म पिया
• इसे बैठकर पीने की उमूमी सिफ़ारिश से इस्तिसना समझा जाता है
• बाज़ उलमा कहते हैं यह कुएं के गिर्द हुजूम की वजह से था

नबी करीम ﷺ की ज़मज़म से मुहब्बत:
• आप ﷺ ने इसे "ज़मीन पर बेहतरीन पानी" कहा
• फ़रमाया यह "ग़िज़ा देने वाली ख़ुराक और बीमारी की शिफ़ा" है
• मुसलमानों को मुख़्लिसाना नीयत से पीने की तरग़ीब दी
• अपने इस्तेमाल से इसकी बरकत ज़ाहिर की''',
        'arabic': '''صلة النبي ﷺ بزمزم

علاقة النبي محمد ﷺ الخاصة بماء زمزم.

غسل قلب النبي ﷺ:
• شُق صدر النبي ﷺ وغُسل قلبه بماء زمزم
• حدث هذا في أربع مناسبات:
  - في طفولته عند حليمة السعدية
  - قبل الإسراء والمعراج
  - قبل النبوة
  - قبل غزوة بدر
• قال الحافظ العراقي: "لتقوية قلبه لرؤية ملكوت السماوات والأرض"

عادات النبي ﷺ مع زمزم:
• كان يحمل زمزم في القرب والأواني
• كان يصبه على المرضى ويسقيهم
• كتب إلى سهيل بن عمرو يطلب زمزم عاجلاً
• "إن جاءك كتابي ليلاً فلا تصبح، وإن جاءك نهاراً فلا تمسِ"

الشرب قائماً:
• شرب النبي ﷺ زمزم قائماً عند الكعبة
• استثناء من استحباب الشرب جالساً
• قيل: بسبب الزحام حول البئر

حب النبي ﷺ لزمزم:
• قال: "خير ماء على وجه الأرض"
• قال: "طعام طعم وشفاء سقم"
• حث المسلمين على شربه بنية صادقة
• بيّن بركته بفعله'''
      },
    },
    {
      'number': 8,
      'titleKey': 'zamzam_fazilat_8_abu_dharr_story',
      'title': 'Abu Dharr\'s Miraculous Story',
      'titleUrdu': 'ابو ذر کا معجزاتی واقعہ',
      'titleHindi': 'अबू ज़र का मोजिज़ाती वाक़िआ',
      'titleArabic': 'قصة أبي ذر المعجزة',
      'icon': Icons.auto_stories,
      'color': Colors.amber,
      'details': {
        'english': '''Abu Dharr's Miraculous Story with Zamzam

One of the most remarkable proofs of Zamzam's miraculous nature is the story of Abu Dharr al-Ghifari (RA).

The Complete Story (Sahih Muslim):
Abu Dharr (RA) came to Makkah to verify if Muhammad ﷺ was truly a Prophet. He stayed near the Kaaba for forty days and nights, living only on Zamzam water.

The Conversation:
• The Prophet ﷺ asked: "How long have you been here?"
• Abu Dharr replied: "I have been here for thirty days and nights."
• The Prophet ﷺ asked: "Who has been feeding you?"
• Abu Dharr said: "I have had nothing but Zamzam water."

The Miraculous Result:
• Abu Dharr said: "I have gotten so fat that I have folds of fat on my stomach"
• He added: "I do not feel any of the tiredness or weakness of hunger"
• He confirmed: "I have not become thin"

The Prophet's Response:
• The Prophet ﷺ said: "Verily, it is blessed (mubarakah)"
• He added: "It is food that nourishes (tu'mu tu'm)"
• In Abu Dawud's narration: "And a cure for illness (shifa'u suqm)"

Lessons from This Story:
• Zamzam can sustain a person completely without other food
• It provides both nutrition and hydration
• Its blessing is from Allah and is miraculous
• This is proof of Allah's power and the water's special nature

Ibn Abbas's Testimony:
• Ibn Abbas (RA) said: "We used to call it Shabbaa'ah (the satisfying one)"
• He said: "It is the best provision for a journey"''',
        'urdu': '''ابو ذر کا زمزم کے ساتھ معجزاتی واقعہ

زمزم کی معجزاتی فطرت کے سب سے قابل ذکر ثبوتوں میں سے ایک ابو ذر غفاری رضی اللہ عنہ کا واقعہ ہے۔

مکمل واقعہ (صحیح مسلم):
ابو ذر رضی اللہ عنہ مکہ آئے یہ تصدیق کرنے کہ کیا محمد ﷺ واقعی نبی ہیں۔ وہ چالیس دن رات کعبہ کے قریب رہے، صرف زمزم پانی پر گزارہ کرتے ہوئے۔

گفتگو:
• نبی کریم ﷺ نے پوچھا: "تم کتنے دن سے یہاں ہو؟"
• ابو ذر نے کہا: "میں یہاں تیس دن رات سے ہوں۔"
• نبی کریم ﷺ نے پوچھا: "تمہیں کون کھلا رہا تھا؟"
• ابو ذر نے کہا: "میرے پاس زمزم کے سوا کچھ نہیں تھا۔"

معجزاتی نتیجہ:
• ابو ذر نے کہا: "میں اتنا موٹا ہو گیا کہ میرے پیٹ پر چربی کی تہیں ہیں"
• انہوں نے کہا: "مجھے بھوک کی تھکاوٹ یا کمزوری نہیں لگی"
• انہوں نے تصدیق کی: "میں دبلا نہیں ہوا"

نبی کریم ﷺ کا جواب:
• نبی کریم ﷺ نے فرمایا: "بے شک یہ مبارک ہے"
• فرمایا: "یہ غذا دینے والی خوراک ہے"
• ابو داؤد کی روایت میں: "اور بیماری کی شفا ہے"

اس واقعے سے سبق:
• زمزم کسی کو دوسری خوراک کے بغیر مکمل طور پر زندہ رکھ سکتا ہے
• یہ غذائیت اور پانی دونوں فراہم کرتا ہے
• اس کی برکت اللہ کی طرف سے ہے اور معجزاتی ہے
• یہ اللہ کی قدرت اور پانی کی خاص فطرت کا ثبوت ہے

ابن عباس کی گواہی:
• ابن عباس رضی اللہ عنہ نے کہا: "ہم اسے شباعہ (سیر کرنے والا) کہتے تھے"
• انہوں نے کہا: "یہ سفر کا بہترین زادراہ ہے"''',
        'hindi': '''अबू ज़र का ज़मज़म के साथ मोजिज़ाती वाक़िआ

ज़मज़म की मोजिज़ाती फ़ितरत के सबसे क़ाबिले ज़िक्र सुबूतों में से एक अबू ज़र ग़िफ़ारी रज़ियल्लाहु अन्हु का वाक़िआ है।

मुकम्मल वाक़िआ (सहीह मुस्लिम):
अबू ज़र रज़ियल्लाहु अन्हु मक्का आए यह तसदीक़ करने कि क्या मुहम्मद ﷺ वाक़ई नबी हैं। वो चालीस दिन रात काबा के क़रीब रहे, सिर्फ़ ज़मज़म पानी पर गुज़ारा करते हुए।

गुफ़्तगू:
• नबी करीम ﷺ ने पूछा: "तुम कितने दिन से यहां हो?"
• अबू ज़र ने कहा: "मैं यहां तीस दिन रात से हूं।"
• नबी करीम ﷺ ने पूछा: "तुम्हें कौन खिला रहा था?"
• अबू ज़र ने कहा: "मेरे पास ज़मज़म के सिवा कुछ नहीं था।"

मोजिज़ाती नतीजा:
• अबू ज़र ने कहा: "मैं इतना मोटा हो गया कि मेरे पेट पर चर्बी की तहें हैं"
• उन्होंने कहा: "मुझे भूक की थकावट या कमज़ोरी नहीं लगी"
• उन्होंने तसदीक़ की: "मैं दुबला नहीं हुआ"

नबी करीम ﷺ का जवाब:
• नबी करीम ﷺ ने फ़रमाया: "बेशक यह मुबारक है"
• फ़रमाया: "यह ग़िज़ा देने वाली ख़ुराक है"
• अबू दाऊद की रिवायत में: "और बीमारी की शिफ़ा है"

इस वाक़िए से सबक़:
• ज़मज़म किसी को दूसरी ख़ुराक के बग़ैर मुकम्मल तौर पर ज़िंदा रख सकता है
• यह ग़िज़ाइयत और पानी दोनों फ़राहम करता है
• इसकी बरकत अल्लाह की तरफ़ से है और मोजिज़ाती है
• यह अल्लाह की क़ुदरत और पानी की ख़ास फ़ितरत का सुबूत है

इब्ने अब्बास की गवाही:
• इब्ने अब्बास रज़ियल्लाहु अन्हु ने कहा: "हम इसे शब्बाआह (सेर करने वाला) कहते थे"
• उन्होंने कहा: "यह सफ़र का बेहतरीन ज़ादे राह है"''',
        'arabic': '''قصة أبي ذر المعجزة مع زمزم

من أبرز الأدلة على طبيعة زمزم المعجزة قصة أبي ذر الغفاري رضي الله عنه.

القصة الكاملة (صحيح مسلم):
جاء أبو ذر رضي الله عنه إلى مكة ليتحقق من نبوة محمد ﷺ. أقام قرب الكعبة أربعين يوماً وليلة على ماء زمزم فقط.

الحوار:
• سأله النبي ﷺ: "منذ كم أنت هنا؟"
• قال أبو ذر: "منذ ثلاثين يوماً وليلة"
• سأله النبي ﷺ: "من كان يطعمك؟"
• قال: "ما كان لي طعام إلا ماء زمزم"

النتيجة المعجزة:
• قال أبو ذر: "فسمنت حتى تكسرت عُكَن بطني"
• أضاف: "ما أجد على كبدي سَخفة جوع"
• أكد: "ما ضعفت ولا نحلت"

رد النبي ﷺ:
• قال النبي ﷺ: "إنها مباركة"
• وأضاف: "إنها طعام طُعم"
• في رواية أبي داود: "وشفاء سُقم"

الدروس المستفادة:
• زمزم يكفي الإنسان بدون طعام آخر
• يوفر التغذية والترطيب معاً
• بركته من الله وهي معجزة
• دليل على قدرة الله وطبيعة الماء الخاصة

شهادة ابن عباس:
• قال ابن عباس رضي الله عنه: "كنا نسميها شباعة"
• قال: "هي خير زاد المسافر"'''
      },
    },
    {
      'number': 9,
      'titleKey': 'zamzam_fazilat_9_dua_supplication',
      'title': 'Dua When Drinking Zamzam',
      'titleUrdu': 'زمزم پیتے وقت دعا',
      'titleHindi': 'ज़मज़म पीते वक़्त दुआ',
      'titleArabic': 'الدعاء عند شرب زمزم',
      'icon': Icons.volunteer_activism,
      'color': Colors.indigo,
      'details': {
        'english': '''Dua and Supplication When Drinking Zamzam

The Prophet ﷺ said: "Zamzam water is for whatever it is drunk for." This hadith teaches us the importance of making dua when drinking Zamzam.

Ibn Abbas's Famous Dua:
It is reported that Ibn Abbas (RA) used to say when drinking Zamzam:

Arabic: اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ

Translation: "O Allah, I ask You for beneficial knowledge, abundant provision, and cure from every disease."

This comprehensive dua covers:
• Knowledge that benefits in this life and the hereafter
• Ample sustenance and provision
• Complete healing from all illnesses

Other Recommended Duas:
1. For Knowledge and Understanding:
   • Ask for wisdom in religious matters
   • Seek understanding of the Quran
   • Request memory for Islamic knowledge

2. For Health and Healing:
   • Seek cure from specific illnesses
   • Ask for strength and vitality
   • Request protection from diseases

3. For Provision and Success:
   • Ask for halal sustenance
   • Seek success in beneficial endeavors
   • Request blessing in your wealth

4. For Any Need:
   • Marriage and family matters
   • Children and their guidance
   • Resolution of problems
   • Forgiveness of sins

Important Points:
• Make dua with complete sincerity and conviction
• Have trust (tawakkul) that Allah will answer
• Remember that true healing comes only from Allah
• Combine with proper medical treatment when needed''',
        'urdu': '''زمزم پیتے وقت دعا اور مناجات

نبی کریم ﷺ نے فرمایا: "زمزم کا پانی جس لیے پیا جائے۔" یہ حدیث ہمیں زمزم پیتے وقت دعا کی اہمیت سکھاتی ہے۔

ابن عباس کی مشہور دعا:
روایت ہے کہ ابن عباس رضی اللہ عنہ زمزم پیتے وقت کہتے:

عربی: اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ

ترجمہ: "اے اللہ، میں تجھ سے نفع بخش علم، فراوان رزق اور ہر بیماری سے شفا مانگتا ہوں۔"

یہ جامع دعا شامل کرتی ہے:
• علم جو دنیا اور آخرت میں فائدہ مند ہو
• کشادہ رزق اور معاش
• تمام بیماریوں سے مکمل شفا

دیگر مستحب دعائیں:
1. علم اور فہم کے لیے:
   • دینی معاملات میں حکمت مانگیں
   • قرآن کی سمجھ طلب کریں
   • اسلامی علم کی یاداشت مانگیں

2. صحت اور شفا کے لیے:
   • مخصوص بیماریوں سے شفا مانگیں
   • طاقت اور توانائی طلب کریں
   • بیماریوں سے حفاظت مانگیں

3. رزق اور کامیابی کے لیے:
   • حلال رزق مانگیں
   • فائدہ مند کاموں میں کامیابی طلب کریں
   • مال میں برکت مانگیں

4. کسی بھی ضرورت کے لیے:
   • شادی اور خاندانی معاملات
   • اولاد اور ان کی رہنمائی
   • مسائل کا حل
   • گناہوں کی معافی

اہم نکات:
• مکمل اخلاص اور یقین کے ساتھ دعا کریں
• اللہ پر بھروسہ (توکل) رکھیں کہ وہ جواب دے گا
• یاد رکھیں کہ حقیقی شفا صرف اللہ سے آتی ہے
• ضرورت ہو تو مناسب طبی علاج کے ساتھ ملائیں''',
        'hindi': '''ज़मज़म पीते वक़्त दुआ और मुनाजात

नबी करीम ﷺ ने फ़रमाया: "ज़मज़म का पानी जिसके लिए पिया जाए।" यह हदीस हमें ज़मज़म पीते वक़्त दुआ की अहमियत सिखाती है।

इब्ने अब्बास की मशहूर दुआ:
रिवायत है कि इब्ने अब्बास रज़ियल्लाहु अन्हु ज़मज़म पीते वक़्त कहते:

अरबी: اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ

तर्जुमा: "ऐ अल्लाह, मैं तुझसे नफ़ाबख़्श इल्म, फ़रावान रिज़्क़ और हर बीमारी से शिफ़ा मांगता हूं।"

यह जामेअ दुआ शामिल करती है:
• इल्म जो दुनिया और आख़िरत में फ़ायदेमंद हो
• कुशादा रिज़्क़ और मआश
• तमाम बीमारियों से मुकम्मल शिफ़ा

दीगर मुस्तहब दुआएं:
1. इल्म और फ़हम के लिए:
   • दीनी मामलात में हिकमत मांगें
   • क़ुरआन की समझ तलब करें
   • इस्लामी इल्म की यादाश्त मांगें

2. सेहत और शिफ़ा के लिए:
   • मख़सूस बीमारियों से शिफ़ा मांगें
   • ताक़त और तवानाई तलब करें
   • बीमारियों से हिफ़ाज़त मांगें

3. रिज़्क़ और कामयाबी के लिए:
   • हलाल रिज़्क़ मांगें
   • फ़ायदेमंद कामों में कामयाबी तलब करें
   • माल में बरकत मांगें

4. किसी भी ज़रूरत के लिए:
   • शादी और ख़ानदानी मामलात
   • औलाद और उनकी रहनुमाई
   • मसाइल का हल
   • गुनाहों की माफ़ी

अहम नुकात:
• मुकम्मल इख़्लास और यक़ीन के साथ दुआ करें
• अल्लाह पर भरोसा (तवक्कुल) रखें कि वो जवाब देगा
• याद रखें कि हक़ीक़ी शिफ़ा सिर्फ़ अल्लाह से आती है
• ज़रूरत हो तो मुनासिब तिब्बी इलाज के साथ मिलाएं''',
        'arabic': '''الدعاء عند شرب زمزم

قال النبي ﷺ: "ماء زمزم لما شُرب له." هذا الحديث يعلمنا أهمية الدعاء عند شرب زمزم.

دعاء ابن عباس المشهور:
روي أن ابن عباس رضي الله عنه كان يقول عند شرب زمزم:

اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ

هذا الدعاء الجامع يشمل:
• العلم النافع في الدنيا والآخرة
• الرزق الواسع والمعيشة
• الشفاء التام من جميع الأمراض

أدعية مستحبة أخرى:
1. للعلم والفهم:
   • طلب الحكمة في أمور الدين
   • طلب فهم القرآن
   • طلب حفظ العلم الشرعي

2. للصحة والشفاء:
   • طلب الشفاء من أمراض معينة
   • طلب القوة والنشاط
   • طلب الوقاية من الأمراض

3. للرزق والنجاح:
   • طلب الرزق الحلال
   • طلب النجاح في الأعمال النافعة
   • طلب البركة في المال

4. لأي حاجة:
   • الزواج وشؤون الأسرة
   • الأولاد وهدايتهم
   • حل المشاكل
   • مغفرة الذنوب

نقاط مهمة:
• الدعاء بإخلاص ويقين تام
• التوكل على الله في الإجابة
• تذكر أن الشفاء الحقيقي من الله وحده
• الجمع مع العلاج الطبي عند الحاجة'''
      },
    },
    {
      'number': 10,
      'titleKey': 'zamzam_fazilat_10_scholars_testimonies',
      'title': 'Scholars\' Testimonies',
      'titleUrdu': 'علماء کی گواہیاں',
      'titleHindi': 'उलमा की गवाहियां',
      'titleArabic': 'شهادات العلماء',
      'icon': Icons.school,
      'color': Colors.brown,
      'details': {
        'english': '''Scholars' Testimonies About Zamzam

Throughout Islamic history, many great scholars have testified to the miraculous nature of Zamzam water.

Ibn al-Qayyim al-Jawziyyah:
The famous scholar said: "Zamzam water is the best and noblest of all waters, the highest in status, the dearest to people, the most precious and valuable to them. It was dug by Jibreel and is the provision of Ismail."

He also wrote: "Myself and others tried seeking healing with Zamzam water and saw wondrous things. I sought healing with it from a number of illnesses, and I was healed by the permission of Allah."

Ibn al-Qayyim's Personal Experience:
• He drank Zamzam for healing multiple times
• He was cured by Allah's permission each time
• He witnessed someone survive on only Zamzam for half a month
• Another person told him he lived on Zamzam alone for forty days

Ibn Hajar al-Asqalani:
• The great hadith scholar drank Zamzam for knowledge
• He became one of the greatest hadith masters of all time
• He authored Fath al-Bari, the famous commentary on Sahih Bukhari

Imam al-Shafi'i:
• He is reported to have drunk Zamzam for excellence in archery
• He became one of the best archers of his time
• He later regretted not drinking it for religious knowledge instead

Other Scholars' Experiences:
• Many scholars drank Zamzam for memorization of Quran
• Others sought it for understanding of Islamic sciences
• Countless testimonies of healing exist throughout Islamic literature

The Principle:
"Zamzam is for whatever it is drunk for" - this applies to both spiritual and physical needs, and Muslims throughout history have witnessed its blessing.''',
        'urdu': '''زمزم کے بارے میں علماء کی گواہیاں

اسلامی تاریخ میں بہت سے عظیم علماء نے زمزم پانی کی معجزاتی فطرت کی گواہی دی۔

ابن القیم الجوزیہ:
مشہور عالم نے کہا: "زمزم کا پانی تمام پانیوں میں بہترین اور افضل ہے، مرتبے میں بلند ترین، لوگوں کو سب سے پیارا، ان کے لیے سب سے قیمتی اور قدر والا۔ اسے جبریل نے کھودا اور یہ اسماعیل کا زادراہ ہے۔"

انہوں نے لکھا: "میں نے اور دوسروں نے زمزم سے شفا طلب کی اور عجیب چیزیں دیکھیں۔ میں نے کئی بیماریوں سے اس سے شفا چاہی اور اللہ کے اذن سے شفا پائی۔"

ابن القیم کا ذاتی تجربہ:
• انہوں نے کئی بار شفا کے لیے زمزم پیا
• ہر بار اللہ کے اذن سے شفا پائی
• انہوں نے کسی کو دیکھا جو آدھے مہینے صرف زمزم پر رہا
• ایک اور شخص نے بتایا کہ وہ چالیس دن صرف زمزم پر رہا

ابن حجر العسقلانی:
• عظیم محدث نے علم کے لیے زمزم پیا
• وہ ہر زمانے کے عظیم ترین محدثین میں سے ہوئے
• انہوں نے صحیح بخاری کی مشہور شرح فتح الباری لکھی

امام شافعی:
• روایت ہے کہ انہوں نے تیراندازی میں مہارت کے لیے زمزم پیا
• وہ اپنے زمانے کے بہترین تیراندازوں میں سے ہوئے
• بعد میں انہیں افسوس ہوا کہ دینی علم کے لیے نہیں پیا

دیگر علماء کے تجربات:
• بہت سے علماء نے قرآن حفظ کے لیے زمزم پیا
• دوسروں نے اسلامی علوم کی سمجھ کے لیے طلب کیا
• اسلامی لٹریچر میں شفا کی بے شمار گواہیاں موجود ہیں

اصول:
"زمزم جس لیے پیا جائے" - یہ روحانی اور جسمانی ضروریات دونوں پر لاگو ہوتا ہے، اور تاریخ میں مسلمانوں نے اس کی برکت دیکھی ہے۔''',
        'hindi': '''ज़मज़म के बारे में उलमा की गवाहियां

इस्लामी तारीख़ में बहुत से अज़ीम उलमा ने ज़मज़म पानी की मोजिज़ाती फ़ितरत की गवाही दी।

इब्नुल क़य्यिम अल-जौज़िय्या:
मशहूर आलिम ने कहा: "ज़मज़म का पानी तमाम पानियों में बेहतरीन और अफ़ज़ल है, मर्तबे में बलंदतरीन, लोगों को सबसे प्यारा, उनके लिए सबसे क़ीमती और क़द्र वाला। इसे जिब्रईल ने खोदा और यह इस्माईल का ज़ादे राह है।"

उन्होंने लिखा: "मैंने और दूसरों ने ज़मज़म से शिफ़ा तलब की और अजीब चीज़ें देखीं। मैंने कई बीमारियों से इससे शिफ़ा चाही और अल्लाह के इज़्न से शिफ़ा पाई।"

इब्नुल क़य्यिम का ज़ाती तजुर्बा:
• उन्होंने कई बार शिफ़ा के लिए ज़मज़म पिया
• हर बार अल्लाह के इज़्न से शिफ़ा पाई
• उन्होंने किसी को देखा जो आधे महीने सिर्फ़ ज़मज़म पर रहा
• एक और शख़्स ने बताया कि वो चालीस दिन सिर्फ़ ज़मज़म पर रहा

इब्ने हजर अल-अस्क़लानी:
• अज़ीम मुहद्दिस ने इल्म के लिए ज़मज़म पिया
• वो हर ज़माने के अज़ीमतरीन मुहद्दिसीन में से हुए
• उन्होंने सहीह बुख़ारी की मशहूर शरह फ़तहुल बारी लिखी

इमाम शाफ़ेई:
• रिवायत है कि उन्होंने तीरंदाज़ी में महारत के लिए ज़मज़म पिया
• वो अपने ज़माने के बेहतरीन तीरंदाज़ों में से हुए
• बाद में उन्हें अफ़सोस हुआ कि दीनी इल्म के लिए नहीं पिया

दीगर उलमा के तजुर्बात:
• बहुत से उलमा ने क़ुरआन हिफ़्ज़ के लिए ज़मज़म पिया
• दूसरों ने इस्लामी उलूम की समझ के लिए तलब किया
• इस्लामी लिटरेचर में शिफ़ा की बेशुमार गवाहियां मौजूद हैं

उसूल:
"ज़मज़म जिसके लिए पिया जाए" - यह रूहानी और जिस्मानी ज़रूरियात दोनों पर लागू होता है, और तारीख़ में मुसलमानों ने इसकी बरकत देखी है।''',
        'arabic': '''شهادات العلماء عن زمزم

على مر التاريخ الإسلامي، شهد كثير من العلماء العظام بطبيعة زمزم المعجزة.

ابن القيم الجوزية:
قال العالم الشهير: "ماء زمزم سيد المياه وأشرفها وأجلها قدراً وأحبها إلى النفوس وأغلاها ثمناً وأنفسها عند الناس. حفرها جبريل وهي سقيا إسماعيل."

وكتب: "جربت أنا وغيري الاستشفاء بماء زمزم فرأينا العجائب. استشفيت به من عدة أمراض فشُفيت بإذن الله."

تجربة ابن القيم الشخصية:
• شرب زمزم للشفاء مرات عديدة
• شُفي بإذن الله في كل مرة
• شاهد شخصاً عاش على زمزم فقط نصف شهر
• أخبره آخر أنه عاش على زمزم وحده أربعين يوماً

ابن حجر العسقلاني:
• شرب المحدث العظيم زمزم للعلم
• أصبح من أعظم المحدثين على مر العصور
• ألف فتح الباري شرح صحيح البخاري

الإمام الشافعي:
• يُروى أنه شرب زمزم للتفوق في الرماية
• أصبح من أمهر الرماة في زمانه
• ندم لاحقاً أنه لم يشربه للعلم الديني

تجارب علماء آخرين:
• كثير من العلماء شربوا زمزم لحفظ القرآن
• آخرون طلبوه لفهم العلوم الإسلامية
• شهادات لا تحصى عن الشفاء في الأدب الإسلامي

المبدأ:
"ماء زمزم لما شُرب له" - ينطبق على الحاجات الروحية والجسدية، وشهد المسلمون بركته عبر التاريخ.'''
      },
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
          context.tr('zamzam'),
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
              itemCount: _zamzamTopics.length,
              itemBuilder: (context, index) {
                final topic = _zamzamTopics[index];
                return _buildTopicCard(topic, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTopicCard(Map<String, dynamic> topic, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(topic['titleKey'] ?? 'zamzam_fazilat');
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
        onTap: () => _showTopicDetails(topic),
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
                    '${topic['number']}',
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
                            topic['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('zamzam_fazilat'),
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

  void _showTopicDetails(Map<String, dynamic> topic) {
    final details = topic['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: topic['title'] ?? '',
          titleUrdu: topic['titleUrdu'] ?? '',
          titleHindi: topic['titleHindi'] ?? '',
          titleArabic: topic['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: topic['color'] as Color,
          icon: topic['icon'] as IconData,
          categoryKey: 'category_zamzam_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
