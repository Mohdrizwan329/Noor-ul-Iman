import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class ZamzamFazilatScreen extends StatefulWidget {
  const ZamzamFazilatScreen({super.key});

  @override
  State<ZamzamFazilatScreen> createState() => _ZamzamFazilatScreenState();
}

class _ZamzamFazilatScreenState extends State<ZamzamFazilatScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Zamzam Water - Virtues & Benefits',
    'urdu': 'آب زمزم - فضائل اور فوائد',
    'hindi': 'ज़मज़म पानी - फ़ज़ीलत और फ़वाइद',
  };

  final List<Map<String, dynamic>> _zamzamTopics = [
    {
      'number': 1,
      'title': 'Origin of Zamzam',
      'titleUrdu': 'زمزم کی ابتداء',
      'titleHindi': 'ज़मज़म की इब्तिदा',
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
      },
    },
    {
      'number': 2,
      'title': 'Virtues in Hadith',
      'titleUrdu': 'حدیث میں فضائل',
      'titleHindi': 'हदीस में फ़ज़ाइल',
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
      },
    },
    {
      'number': 3,
      'title': 'How to Drink Zamzam',
      'titleUrdu': 'زمزم پینے کا طریقہ',
      'titleHindi': 'ज़मज़म पीने का तरीक़ा',
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
      },
    },
    {
      'number': 4,
      'title': 'Scientific Properties',
      'titleUrdu': 'سائنسی خصوصیات',
      'titleHindi': 'साइंसी ख़ुसूसियात',
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
      },
    },
    {
      'number': 5,
      'title': 'Benefits & Uses',
      'titleUrdu': 'فوائد اور استعمال',
      'titleHindi': 'फ़वाइद और इस्तेमाल',
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
      },
    },
    {
      'number': 6,
      'title': 'Carrying Zamzam',
      'titleUrdu': 'زمزم لے جانا',
      'titleHindi': 'ज़मज़म ले जाना',
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
          _titles[_selectedLanguage]!,
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

  Widget _buildTopicCard(Map<String, dynamic> topic, bool isDark) {
    final title = _selectedLanguage == 'english'
        ? topic['title']
        : _selectedLanguage == 'urdu'
        ? topic['titleUrdu']
        : topic['titleHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTopicDetails(topic),
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${topic['number']}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (topic['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    topic['icon'] as IconData,
                    color: topic['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: _selectedLanguage == 'urdu'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E8F5A),
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

  void _showTopicDetails(Map<String, dynamic> topic) {
    final details = topic['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: topic['title'],
          titleUrdu: topic['titleUrdu'] ?? '',
          titleHindi: topic['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: topic['color'] as Color,
          icon: topic['icon'] as IconData,
          category: 'Zamzam Pani - Fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
