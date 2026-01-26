import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'basic_amal_detail_screen.dart';

class MonthNameFazilatScreen extends StatefulWidget {
  const MonthNameFazilatScreen({super.key});

  @override
  State<MonthNameFazilatScreen> createState() => _MonthNameFazilatScreenState();
}

class _MonthNameFazilatScreenState extends State<MonthNameFazilatScreen> {
  String _selectedLanguage = 'english';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _islamicMonths = [
    {
      'number': 1,
      'titleKey': 'month_name_fazilat_1_muharram',
      'title': 'Muharram',
      'titleUrdu': 'محرم',
      'titleHindi': 'मुहर्रम',
      'titleArabic': 'محرم',
      'icon': Icons.calendar_month,
      'color': Colors.red,
      'details': {
        'english': '''Muharram - The Sacred Month

Muharram is the first month of the Islamic calendar and one of the four sacred months in which fighting is prohibited.

Virtues of Muharram:
• It is called "The Month of Allah" (Shahrul-lah)
• Fasting in this month is highly rewarded
• The Prophet ﷺ said: "The best fasting after Ramadan is fasting in the month of Allah, Muharram." (Sahih Muslim)

Day of Ashura (10th Muharram):
• Fasting on this day expiates sins of the previous year
• The Prophet ﷺ said: "Fasting the Day of Ashura, I hope Allah will expiate thereby the year that came before it." (Sahih Muslim)
• It is Sunnah to fast on the 9th and 10th, or 10th and 11th

Historical Significance:
• Allah saved Prophet Musa (AS) and the Children of Israel from Pharaoh on this day
• The martyrdom of Imam Hussain (RA) at Karbala occurred on 10th Muharram

Acts of Worship:
• Fasting, especially on Ashura
• Increased prayers and remembrance
• Charity and good deeds
• Reciting Quran''',
        'urdu': '''محرم - حرمت والا مہینہ

محرم اسلامی تقویم کا پہلا مہینہ ہے اور چار حرام مہینوں میں سے ایک ہے جن میں جنگ کرنا منع ہے۔

محرم کے فضائل:
• اسے "اللہ کا مہینہ" (شہر اللہ) کہا جاتا ہے
• اس مہینے میں روزہ رکھنا بہت ثواب والا ہے
• نبی کریم ﷺ نے فرمایا: "رمضان کے بعد سب سے بہتر روزہ اللہ کے مہینے محرم کا روزہ ہے۔" (صحیح مسلم)

یوم عاشورہ (10 محرم):
• اس دن روزہ رکھنا پچھلے سال کے گناہوں کا کفارہ ہے
• نبی کریم ﷺ نے فرمایا: "عاشورہ کا روزہ، مجھے امید ہے اللہ اس سے پچھلے سال کے گناہ معاف فرما دے گا۔" (صحیح مسلم)
• 9 اور 10 یا 10 اور 11 کو روزہ رکھنا سنت ہے

تاریخی اہمیت:
• اللہ نے اس دن حضرت موسیٰ علیہ السلام اور بنی اسرائیل کو فرعون سے بچایا
• امام حسین رضی اللہ عنہ کی شہادت کربلا میں 10 محرم کو ہوئی

عبادات:
• روزہ، خاص طور پر عاشورہ کا
• زیادہ نمازیں اور ذکر
• صدقہ اور نیک اعمال
• قرآن کی تلاوت''',
        'hindi': '''मुहर्रम - हुर्मत वाला महीना

मुहर्रम इस्लामी कैलेंडर का पहला महीना है और चार हराम महीनों में से एक है जिनमें जंग करना मना है।

मुहर्रम की फ़ज़ीलत:
• इसे "अल्लाह का महीना" (शहरुल्लाह) कहा जाता है
• इस महीने में रोज़ा रखना बहुत सवाब वाला है
• नबी करीम ﷺ ने फ़रमाया: "रमज़ान के बाद सबसे बेहतर रोज़ा अल्लाह के महीने मुहर्रम का रोज़ा है।" (सहीह मुस्लिम)

यौम-ए-आशूरा (10 मुहर्रम):
• इस दिन रोज़ा रखना पिछले साल के गुनाहों का कफ़्फ़ारा है
• नबी करीम ﷺ ने फ़रमाया: "आशूरा का रोज़ा, मुझे उम्मीद है अल्लाह इससे पिछले साल के गुनाह माफ़ फ़रमा देगा।" (सहीह मुस्लिम)
• 9 और 10 या 10 और 11 को रोज़ा रखना सुन्नत है

तारीख़ी अहमियत:
• अल्लाह ने इस दिन हज़रत मूसा अलैहिस्सलाम और बनी इसराईल को फ़िरऔन से बचाया
• इमाम हुसैन रज़ियल्लाहु अन्हु की शहादत करबला में 10 मुहर्रम को हुई

इबादात:
• रोज़ा, ख़ास तौर पर आशूरा का
• ज़्यादा नमाज़ें और ज़िक्र
• सदक़ा और नेक आमाल
• क़ुरआन की तिलावत''',
        'arabic': '''شهر محرم

أول شهور السنة الهجرية وأحد الأشهر الحرم.

فضل شهر محرم:
• من الأشهر الحرم الأربعة
• "إِنَّ عِدَّةَ الشُّهُورِ عِندَ اللَّهِ اثْنَا عَشَرَ شَهْرًا" (سورة التوبة: 36)
• "مِنْهَا أَرْبَعَةٌ حُرُمٌ" الأشهر الحرم
• يحرم فيه القتال إلا دفاعاً

صيام المحرم:
• قال النبي ﷺ: "أفضل الصيام بعد رمضان شهر الله المحرم" (مسلم)
• صيام يوم عاشوراء مكفر لسنة ماضية
• يستحب صيام تاسوعاء مع عاشوراء
• صيام النافلة فيه أفضل

يوم عاشوراء:
• العاشر من محرم
• يوم نجى الله فيه موسى وقومه
• صامه النبي ﷺ وأمر بصيامه
• قال ﷺ: "صيام يوم عاشوراء أحتسب على الله أن يكفر السنة التي قبله" (مسلم)

سنة صيام عاشوراء:
• صيام يوم تاسوعاء (9 محرم)
• ثم يوم عاشوراء (10 محرم)
• مخالفة لليهود
• صيام يوم قبله أو بعده

أحداث في محرم:
• نجاة موسى من فرعون
• استشهاد الحسين بن علي رضي الله عنهما
• بداية السنة الهجرية
• مناسبة للتوبة والاستغفار''',
      },
    },
    {
      'number': 2,
      'titleKey': 'month_name_fazilat_2_safar',
      'title': 'Safar',
      'titleUrdu': 'صفر',
      'titleHindi': 'सफ़र',
      'titleArabic': 'صفر',
      'icon': Icons.calendar_month,
      'color': Colors.orange,
      'details': {
        'english': '''Safar - The Second Month

Safar is the second month of the Islamic calendar. It was called Safar because the Arabs used to leave their homes empty (sifr) to go on expeditions.

Clarifying Misconceptions:
• There is NO basis in Islam for considering Safar an unlucky month
• The Prophet ﷺ said: "There is no bad omen in Safar." (Sahih Bukhari)
• All superstitions about Safar being unlucky are baseless in Islam

What the Prophet ﷺ Said:
• "No contagion, no bad omen, no owl (as bad omen), and no Safar (superstition)." (Sahih Bukhari)
• This month is like any other month - neither blessed nor cursed specifically

Historical Events:
• The Prophet ﷺ's migration to Madinah continued into this month
• Many battles and expeditions took place during Safar

What to Do:
• Treat this month like any other month
• Perform regular acts of worship
• Reject superstitions and innovations
• Trust in Allah's decree
• Marry, travel, and conduct business normally

The Last Wednesday:
• There is NO evidence for the innovation of celebrating "Akhri Chahar Shamba" (last Wednesday of Safar)''',
        'urdu': '''صفر - دوسرا مہینہ

صفر اسلامی تقویم کا دوسرا مہینہ ہے۔ اسے صفر اس لیے کہا گیا کیونکہ عرب اپنے گھر خالی (صفر) چھوڑ کر مہمات پر جاتے تھے۔

غلط فہمیوں کا ازالہ:
• صفر کو منحوس سمجھنے کی اسلام میں کوئی بنیاد نہیں
• نبی کریم ﷺ نے فرمایا: "صفر میں کوئی منحوسی نہیں۔" (صحیح بخاری)
• صفر کے منحوس ہونے کے تمام توہمات اسلام میں بے بنیاد ہیں

نبی کریم ﷺ کا فرمان:
• "کوئی چھوت نہیں، کوئی بد شگونی نہیں، کوئی الو (بطور بد شگون) نہیں، اور کوئی صفر (توہم) نہیں۔" (صحیح بخاری)
• یہ مہینہ دوسرے مہینوں کی طرح ہے - نہ خاص طور پر مبارک نہ لعنت زدہ

تاریخی واقعات:
• نبی کریم ﷺ کی مدینہ ہجرت اس مہینے میں جاری رہی
• صفر میں کئی جنگیں اور مہمات ہوئیں

کیا کریں:
• اس مہینے کو دوسرے مہینوں کی طرح سمجھیں
• عام عبادات کریں
• توہمات اور بدعات کو رد کریں
• اللہ کی تقدیر پر بھروسہ کریں
• عام طور پر شادی، سفر اور کاروبار کریں

آخری بدھ:
• "آخری چہار شنبہ" منانے کی بدعت کا کوئی ثبوت نہیں''',
        'hindi': '''सफ़र - दूसरा महीना

सफ़र इस्लामी कैलेंडर का दूसरा महीना है। इसे सफ़र इसलिए कहा गया क्योंकि अरब अपने घर ख़ाली (सिफ़्र) छोड़कर मुहिमों पर जाते थे।

ग़लतफ़हमियों का इज़ाला:
• सफ़र को मनहूस समझने की इस्लाम में कोई बुनियाद नहीं
• नबी करीम ﷺ ने फ़रमाया: "सफ़र में कोई मनहूसियत नहीं।" (सहीह बुख़ारी)
• सफ़र के मनहूस होने के तमाम तौहमात इस्लाम में बेबुनियाद हैं

नबी करीम ﷺ का फ़रमान:
• "कोई छूत नहीं, कोई बदशगूनी नहीं, कोई उल्लू (बतौर बदशगून) नहीं, और कोई सफ़र (तौहम) नहीं।" (सहीह बुख़ारी)
• यह महीना दूसरे महीनों की तरह है - न ख़ास तौर पर मुबारक न लानत ज़दा

तारीख़ी वाक़िआत:
• नबी करीम ﷺ की मदीना हिजरत इस महीने में जारी रही
• सफ़र में कई जंगें और मुहिमात हुईं

क्या करें:
• इस महीने को दूसरे महीनों की तरह समझें
• आम इबादात करें
• तौहमात और बिदअतों को रद्द करें
• अल्लाह की तक़दीर पर भरोसा करें
• आम तौर पर शादी, सफ़र और कारोबार करें

आख़िरी बुध:
• "आख़िरी चहार शंबा" मनाने की बिदअत का कोई सुबूत नहीं''',
        'arabic': '''شهر صفر

الشهر الثاني من السنة الهجرية.

حقيقة شهر صفر:
• ليس شهراً منحوساً
• لا تشاؤم فيه
• قال النبي ﷺ: "لا عدوى ولا طيرة ولا هامة ولا صفر" (البخاري)
• الخير والشر بيد الله وحده

الخرافات المرفوضة:
• التشاؤم من صفر من الجاهلية
• لا تأثير للشهر على الحظ
• الإسلام أبطل هذه المعتقدات
• "قُل لَّن يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا" (سورة التوبة: 51)

الأعمال المستحبة:
• الإكثار من العبادة
• الصيام النافلة
• قراءة القرآن
• الصدقة والإحسان

التوكل على الله:
• الاعتماد على الله وحده
• عدم التعلق بالخرافات
• "وَعَلَى اللَّهِ فَتَوَكَّلُوا إِن كُنتُم مُّؤْمِنِينَ" (سورة المائدة: 23)

دروس من صفر:
• بطلان الخرافات
• التوكل على الله
• الإيمان بالقضاء والقدر
• عدم التطير''',
      },
    },
    {
      'number': 3,
      'titleKey': 'month_name_fazilat_3_rabi_alawwal',
      'title': 'Rabi al-Awwal',
      'titleUrdu': 'ربیع الاول',
      'titleHindi': 'रबीउल अव्वल',
      'titleArabic': 'ربيع الأول',
      'icon': Icons.calendar_month,
      'color': Colors.green,
      'details': {
        'english': '''Rabi al-Awwal - The Month of the Prophet's Birth

Rabi al-Awwal is the third month of the Islamic calendar. It holds special significance as the birth month of Prophet Muhammad ﷺ.

Birth of the Prophet ﷺ:
• The Prophet ﷺ was born on Monday, 12th Rabi al-Awwal (most common view)
• This was approximately 570 CE, known as the Year of the Elephant
• His birth brought light to humanity

Virtues of This Month:
• The arrival of the best of creation
• A time to increase love for the Prophet ﷺ
• Opportunity to learn about his life and teachings

How to Honor the Prophet ﷺ:
• Learn about his Seerah (biography)
• Follow his Sunnah
• Send salutations (Durood) upon him
• The Prophet ﷺ said: "Whoever sends blessings upon me once, Allah will send blessings upon him tenfold." (Sahih Muslim)

Recommended Acts:
• Increase Durood/Salawat
• Study the Prophet's life
• Implement his teachings
• Share his stories with family
• Fast on Mondays (Sunnah)

Note: The manner of celebration should be in accordance with authentic Islamic teachings, avoiding innovations (bid'ah).''',
        'urdu': '''ربیع الاول - نبی کریم ﷺ کی ولادت کا مہینہ

ربیع الاول اسلامی تقویم کا تیسرا مہینہ ہے۔ یہ نبی کریم ﷺ کی ولادت کے مہینے کے طور پر خاص اہمیت رکھتا ہے۔

نبی کریم ﷺ کی ولادت:
• نبی کریم ﷺ پیر کو 12 ربیع الاول کو پیدا ہوئے (سب سے عام رائے)
• یہ تقریباً 570 عیسوی تھا، جسے عام الفیل کہا جاتا ہے
• آپ ﷺ کی ولادت نے انسانیت کو روشنی دی

اس مہینے کے فضائل:
• بہترین مخلوق کی آمد
• نبی کریم ﷺ سے محبت بڑھانے کا وقت
• آپ ﷺ کی زندگی اور تعلیمات جاننے کا موقع

نبی کریم ﷺ کی تعظیم کیسے کریں:
• آپ ﷺ کی سیرت سیکھیں
• آپ ﷺ کی سنت پر عمل کریں
• آپ ﷺ پر درود بھیجیں
• نبی کریم ﷺ نے فرمایا: "جو مجھ پر ایک بار درود بھیجے، اللہ اس پر دس بار رحمت بھیجتا ہے۔" (صحیح مسلم)

مستحب اعمال:
• درود/صلوات زیادہ پڑھیں
• نبی کریم ﷺ کی زندگی کا مطالعہ کریں
• آپ ﷺ کی تعلیمات پر عمل کریں
• خاندان کے ساتھ آپ ﷺ کے قصے شیئر کریں
• پیر کو روزہ رکھیں (سنت)

نوٹ: جشن کا طریقہ مستند اسلامی تعلیمات کے مطابق ہونا چاہیے، بدعات سے بچتے ہوئے۔''',
        'hindi': '''रबीउल अव्वल - नबी करीम ﷺ की विलादत का महीना

रबीउल अव्वल इस्लामी कैलेंडर का तीसरा महीना है। यह नबी करीम ﷺ की विलादत के महीने के तौर पर ख़ास अहमियत रखता है।

नबी करीम ﷺ की विलादत:
• नबी करीम ﷺ सोमवार को 12 रबीउल अव्वल को पैदा हुए (सबसे आम राय)
• यह तक़रीबन 570 ईसवी थी, जिसे आमुल फ़ील कहा जाता है
• आप ﷺ की विलादत ने इंसानियत को रोशनी दी

इस महीने की फ़ज़ीलत:
• बेहतरीन मख़्लूक़ की आमद
• नबी करीम ﷺ से मुहब्बत बढ़ाने का वक़्त
• आप ﷺ की ज़िंदगी और तालीमात जानने का मौक़ा

नबी करीम ﷺ की ताज़ीम कैसे करें:
• आप ﷺ की सीरत सीखें
• आप ﷺ की सुन्नत पर अमल करें
• आप ﷺ पर दुरूद भेजें
• नबी करीम ﷺ ने फ़रमाया: "जो मुझ पर एक बार दुरूद भेजे, अल्लाह उस पर दस बार रहमत भेजता है।" (सहीह मुस्लिम)

मुस्तहब आमाल:
• दुरूद/सलवात ज़्यादा पढ़ें
• नबी करीम ﷺ की ज़िंद��ी का मुताला करें
• आप ﷺ की तालीमात पर अमल करें
• ख़ानदान के साथ आप ﷺ के क़िस्से शेयर करें
• सोमवार को रोज़ा रखें (सुन्नत)

नोट: जश्न का तरीक़ा मुस्तनद इस्लामी तालीमात के मुताबिक़ होना चाहिए, बिदअतों से बचते हुए।''',
        'arabic': '''ربيع الأول

الشهر الثالث من السنة الهجرية وفيه مولد النبي ﷺ.

شهر المولد النبوي:
• ولد النبي ﷺ في 12 ربيع الأول
• عام الفيل
• يوم الاثنين
• "لَقَدْ جَاءَكُمْ رَسُولٌ مِّنْ أَنفُسِكُمْ" (سورة التوبة: 128)

الاحتفال بالمولد:
• ليس من السنة الاحتفال بيوم محدد
• ولكن محبة النبي ﷺ واجبة
• إحياء سيرته طوال العام
• الصلاة عليه في كل وقت

إحياء سيرة النبي:
• دراسة السيرة النبوية
• الاقتداء بأخلاقه
• نشر سنته
• الدفاع عن النبي ﷺ

الصلاة على النبي:
• "إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ" (سورة الأحزاب: 56)
• الإكثار منها في هذا الشهر
• اللهم صل على محمد وعلى آل محمد

أحداث في ربيع الأول:
• مولد النبي ﷺ
• وفاة النبي ﷺ (في نفس الشهر)
• الهجرة إلى المدينة''',
      },
    },
    {
      'number': 4,
      'titleKey': 'month_name_fazilat_4_rabi_althani',
      'title': 'Rabi al-Thani',
      'titleUrdu': 'ربیع الثانی',
      'titleHindi': 'रबीउस्सानी',
      'titleArabic': 'ربيع الآخر',
      'icon': Icons.calendar_month,
      'color': Colors.teal,
      'details': {
        'english': '''Rabi al-Thani - The Fourth Month

Rabi al-Thani (also called Rabi al-Akhir) is the fourth month of the Islamic calendar. It means "The Second Spring."

Significance:
• No specific religious events are associated with this month in authentic sources
• It is a month like other regular months
• Continue regular worship and good deeds

Historical Events:
• Various Islamic events took place during this month throughout history
• The death of Sheikh Abdul Qadir Jilani (RA) is commemorated by some (11th Rabi al-Thani)

Recommended Acts:
• Regular five daily prayers
• Recitation of Quran
• Voluntary fasting (Mondays and Thursdays)
• Charity and helping others
• Seeking knowledge

Important Reminder:
• Every day is an opportunity for worship
• Don't wait for special months to do good
• The Prophet ﷺ said: "The most beloved deeds to Allah are those done consistently, even if small." (Sahih Bukhari)

General Islamic Guidance:
• Maintain regular worship throughout the year
• Avoid innovations not established in Sunnah
• Focus on authentic Islamic practices''',
        'urdu': '''ربیع الثانی - چوتھا مہینہ

ربیع الثانی (جسے ربیع الآخر بھی کہتے ہیں) اسلامی تقویم کا چوتھا مہینہ ہے۔ اس کا مطلب ہے "دوسرا بہار"۔

اہمیت:
• مستند ذرائع میں اس مہینے سے کوئی خاص مذہبی واقعہ منسوب نہیں
• یہ دوسرے عام مہینوں کی طرح ایک مہینہ ہے
• باقاعدہ عبادت اور نیک اعمال جاری رکھیں

تاریخی واقعات:
• تاریخ میں اس مہینے مختلف اسلامی واقعات پیش آئے
• شیخ عبدالقادر جیلانی رحمۃ اللہ علیہ کی وفات کچھ لوگ یاد کرتے ہیں (11 ربیع الثانی)

مستحب اعمال:
• باقاعدہ پانچ وقت کی نمازیں
• قرآن کی تلاوت
• نفلی روزے (پیر اور جمعرات)
• صدقہ اور دوسروں کی مدد
• علم حاصل کرنا

اہم یاد دہانی:
• ہر دن عبادت کا موقع ہے
• نیکی کرنے کے لیے خاص مہینوں کا انتظار نہ کریں
• نبی کریم ﷺ نے فرمایا: "اللہ کو سب سے محبوب عمل وہ ہے جو مسلسل کیا جائے، چاہے چھوٹا ہو۔" (صحیح بخاری)

عمومی اسلامی رہنمائی:
• سال بھر باقاعدہ عبادت جاری رکھیں
• سنت میں ثابت نہ ہونے والی بدعات سے بچیں
• مستند اسلامی اعمال پر توجہ دیں''',
        'hindi': '''रबीउस्सानी - चौथा महीना

रबीउस्सानी (जिसे रबीउल आख़िर भी कहते हैं) इस्लामी कैलेंडर का चौथा महीना है। इसका मतलब है "दूसरा बहार"।

अहमियत:
• मुस्तनद ज़राए में इस महीने से कोई ख़ास मज़हबी वाक़िआ मंसूब नहीं
• यह दूसरे आम महीनों की तरह एक महीना है
• बाक़ायदा इबादत और नेक आमाल जारी रखें

तारीख़ी वाक़िआत:
• तारीख़ में इस महीने मुख़्तलिफ़ इस्लामी वाक़िआत पेश आए
• शेख़ अब्दुल क़ादिर जीलानी रहमतुल्लाह अलैह की वफ़ात कुछ लोग याद करते हैं (11 रबीउस्सानी)

मुस्तहब आमाल:
• बाक़ायदा पांच वक़्त की नमाज़ें
• क़ुरआन की तिलावत
• नफ़्ली रोज़े (सोमवार और जुमेरात)
• सदक़ा और दूसरों की मदद
• इल्म हासिल करना

अहम याददिहानी:
• हर दिन इबादत का मौक़ा है
• नेकी करने के लिए ख़ास महीनों का इंतज़ार न करें
• नबी करीम ﷺ ने फ़रमाया: "अल्लाह को सबसे महबूब अमल वो है जो मुसलसल किया जाए, चाहे छोटा हो।" (सहीह बुख़ारी)

उमूमी इस्लामी रहनुमाई:
• साल भर बाक़ायदा इबादत जारी रखें
• सुन्नत में साबित न होने वाली बिदअतों से बचें
• मुस्तनद इस्लामी आमाल पर तवज्जोह दें''',
        'arabic': '''ربيع الآخر (ربيع الثاني)

الشهر الرابع من السنة الهجرية.

شهر مبارك:
• من أشهر السنة الهجرية
• لا تخصيص له بعبادة معينة
• العبادة فيه كسائر الشهور

الأعمال المستحبة:
• المحافظة على الفرائض
• الإكثار من النوافل
• الصيام التطوع
• قراءة القرآن وتدبره

التقرب إلى الله:
• الذكر والدعاء
• الصدقة والإحسان
• صلة الرحم
• الأمر بالمعروف والنهي عن المنكر

عمارة الأوقات:
• استغلال الوقت في الطاعة
• "وَالْعَصْرِ * إِنَّ الْإِنسَانَ لَفِي خُسْرٍ" (سورة العصر: 1-2)
• المحافظة على الأذكار
• قيام الليل

دروس من الشهر:
• كل وقت فرصة للطاعة
• لا تخصيص بدون دليل
• الاستمرار على العبادة''',
      },
    },
    {
      'number': 5,
      'titleKey': 'month_name_fazilat_5_jumada_alawwal',
      'title': 'Jumada al-Awwal',
      'titleUrdu': 'جمادی الاول',
      'titleHindi': 'जमादिउल अव्वल',
      'titleArabic': 'جمادى الأولى',
      'icon': Icons.calendar_month,
      'color': Colors.blue,
      'details': {
        'english': '''Jumada al-Awwal - The Fifth Month

Jumada al-Awwal is the fifth month of the Islamic calendar. The name comes from "Jamad" meaning dry or frozen, as it originally fell during winter.

Meaning of the Name:
• Jumada means "dry" or "parched"
• Named because water would freeze during this time when the calendar was first established
• Also called Jumada al-Ula (First Jumada)

Historical Events:
• Various significant events in Islamic history
• Birth of Sayyidah Zainab bint Ali (RA) according to some sources

Virtues of Regular Worship:
• This month has no specific additional virtues
• It emphasizes the importance of consistent worship year-round
• The Prophet ﷺ said: "Take up good deeds only as much as you are able, for the best deeds are those done consistently even if they are few." (Ibn Majah)

Recommended Acts:
• Maintain the five daily prayers
• Read Quran regularly
• Fast on Mondays and Thursdays (Sunnah)
• Give charity
• Make abundant dhikr (remembrance of Allah)
• Seek forgiveness (Istighfar)

Lesson:
• True faith is shown in consistency, not just in special occasions
• Every moment is an opportunity for reward''',
        'urdu': '''جمادی الاول - پانچواں مہینہ

جمادی الاول اسلامی تقویم کا پانچواں مہینہ ہے۔ نام "جمد" سے آیا ہے جس کا مطلب خشک یا جما ہوا ہے، کیونکہ یہ اصل میں سردیوں میں آتا تھا۔

نام کا مطلب:
• جمادی کا مطلب "خشک" یا "سوکھا"
• اس لیے نام رکھا گیا کیونکہ جب تقویم بنائی گئی تب اس وقت پانی جم جاتا تھا
• جمادی الاولیٰ بھی کہتے ہیں

تاریخی واقعات:
• اسلامی تاریخ ک�� مختلف اہم واقعات
• بعض ذرائع کے مطابق سیدہ زینب بنت علی رضی اللہ عنہا کی ولادت

باقاعدہ عبادت کے فضائل:
• اس مہینے کے کوئی خاص اضافی فضائل نہیں
• یہ سال بھر مسلسل عبادت کی اہمیت پر زور دیتا ہے
• نبی کریم ﷺ نے فرمایا: "اتنے نیک اعمال کرو جتنے کر سکتے ہو، کیونکہ بہترین اعمال وہ ہیں جو مسلسل کیے جائیں چاہے کم ہوں۔" (ابن ماجہ)

مستحب اعمال:
• پانچ وقت کی نمازیں برقرار رکھیں
• باقاعدگی سے قرآن پڑھیں
• پیر اور جمعرات کو روزہ رکھیں (سنت)
• صدقہ دیں
• کثرت سے ذکر کریں
• استغفار کریں

سبق:
• سچا ایمان مسلسل عمل سے ظاہر ہوتا ہے، صرف خاص مواقع پر نہیں
• ہر لمحہ ثواب کا موقع ہے''',
        'hindi': '''जमादिउल अव्वल - पांचवां महीना

जमादिउल अव्वल इस्लामी कैलेंडर का पांचवां महीना है। नाम "जमद" से आया है जिसका मतलब ख़ुश्क या जमा हुआ है, क्योंकि यह असल में सर्दियों में आता था।

नाम का मतलब:
• जमादी का मतलब "ख़ुश्क" या "सूखा"
• इसलिए नाम रखा गया क्योंकि जब कैलेंडर बनाई गई तब उस वक़्त पानी जम जाता था
• जमादिउल ऊला भी कहते हैं

तारीख़ी वाक़िआत:
• इस्लामी तारीख़ के मुख़्तलिफ़ अहम वाक़िआत
• बाज़ ज़राए के मुताबिक़ सय्यिदा ज़ैनब बिंत अली रज़ियल्लाहु अन्हा की विलादत

बाक़ायदा इबादत की फ़ज़ीलत:
• इस महीने के कोई ख़ास इज़ाफ़ी फ़ज़ाइल नहीं
• यह साल भर मुसलसल इबादत की अहमियत पर ज़ोर देता है
• नबी करीम ﷺ ने फ़रमाया: "इतने नेक आमाल करो जितने कर सकते हो, क्योंकि बेहतरीन आमाल वो हैं जो मुसलसल किए जाएं चाहे कम हों।" (इब्ने माजा)

मुस्तहब आमाल:
• पांच वक़्त की नमाज़ें बरक़रार रखें
• बाक़ायदगी से क़ुरआन पढ़ें
• सोमवार और जुमेरात को रोज़ा रखें (सुन्नत)
• सदक़ा दें
• कसरत से ज़िक्र करें
• इस्तिग़फ़ार करें

सबक़:
• सच्चा ईमान मुसलसल अमल से ज़ाहिर होता है, सिर्फ़ ख़ास मौक़ों पर नहीं
• हर लम्हा सवाब का मौक़ा है''',
        'arabic': '''جمادى الأولى

الشهر الخامس من السنة الهجرية.

معنى الاسم:
• سمي جمادى لوقوعه في الشتاء عند التسمية
• جمد الماء من البرد
• الجمادى: البرد والتجمد

شهر العبادة:
• لا يختلف عن سائر الشهور
• المحافظة على الطاعات
• استمرار العمل الصالح
• "وَاعْبُدْ رَبَّكَ حَتَّىٰ يَأْتِيَكَ الْيَقِينُ" (سورة الحجر: 99)

الأعمال المستحبة:
• صيام الإثنين والخميس
• صيام الأيام البيض (13، 14، 15)
• قيام الليل
• الصدقة والإنفاق

الحكمة من الشهور:
• تنظيم العبادات
• معرفة الأوقات
• حساب الأعمار
• التاريخ والتوثيق

استثمار الوقت:
• كل يوم فرصة جديدة
• المبادرة إلى الخيرات
• ترك التسويف
• "فَإِذَا فَرَغْتَ فَانصَبْ" (سورة الشرح: 7)''',
      },
    },
    {
      'number': 6,
      'titleKey': 'month_name_fazilat_6_jumada_althani',
      'title': 'Jumada al-Thani',
      'titleUrdu': 'جمادی الثانی',
      'titleHindi': 'जमादिउस्सानी',
      'titleArabic': 'جمادى الآخرة',
      'icon': Icons.calendar_month,
      'color': Colors.indigo,
      'details': {
        'english': '''Jumada al-Thani - The Sixth Month

Jumada al-Thani (also called Jumada al-Akhirah) is the sixth month of the Islamic calendar. It means "The Second Jumada."

About This Month:
• Second of the two Jumada months
• Named similarly due to its proximity to Jumada al-Awwal
• The name indicates the original winter/dry season

Historical Events:
• Birth of Sayyidah Fatimah (RA), daughter of Prophet ﷺ (according to some opinions)
• Various battles and expeditions in Islamic history

Important Dates (according to some sources):
• 20th - Death of Sayyidah Fatimah (RA) (other opinions exist)
• Various scholarly deaths and births throughout history

Spiritual Guidance:
• Continue regular worship without innovation
• Focus on improving character and deeds
• The Prophet ﷺ said: "The most perfect of believers in faith are those with the best character." (Tirmidhi)

Recommended Acts:
• Regular Salah (prayers)
• Quran recitation
• Dhikr and Istighfar
• Learning Islamic knowledge
• Serving parents and family
• Helping the needy

Remember:
• Every month is an opportunity for spiritual growth
• Consistency in worship is more beloved to Allah than occasional bursts''',
        'urdu': '''جمادی الثانی - چھٹا مہینہ

جمادی الثانی (جسے جمادی الآخرہ بھی کہتے ہیں) اسلامی تقویم کا چھٹا مہینہ ہے۔ اس کا مطلب ہے "دوسرا جمادی"۔

اس مہینے کے بارے میں:
• دو جمادی مہینوں میں دوسرا
• جمادی الاول سے قربت کی وجہ سے اسی طرح نام
• نام اصل سردی/خشک موسم کی نشاندہی کرتا ہے

تاریخی واقعات:
• سیدہ فاطمہ رضی اللہ عنہا کی ولادت، نبی کریم ﷺ کی بیٹی (بعض آراء کے مطابق)
• اسلامی تاریخ میں مختلف جنگیں اور مہمات

اہم تاریخیں (بعض ذرائع کے مطابق):
• 20 - سیدہ فاطمہ رضی اللہ عنہا کی وفات (دوسری آراء بھی ہیں)
• تاریخ میں مختلف علماء کی وفات اور ولادت

روحانی رہنمائی:
• بدعت کے بغیر باقاعدہ عبادت جاری رکھیں
• اخلاق اور اعمال بہتر کرنے پر توجہ دیں
• نبی کریم ﷺ نے فرمایا: "ایمان میں سب سے کامل وہ مومن ہے جس کا اخلاق سب سے بہتر ہو۔" (ترمذی)

مستحب اعمال:
• باقاعدہ نماز
• قرآن کی تلاوت
• ذکر اور استغفار
• اسلامی علم سیکھنا
• والدین اور خاندان کی خدمت
• ضرورت مندوں کی مدد

یاد رکھیں:
• ہر مہینہ روحانی ترقی کا موقع ہے
• عبادت میں مسلسل رہنا اللہ کو کبھی کبھار کی عبادت سے زیادہ محبوب ہے''',
        'hindi': '''जमादिउस्सानी - छठा महीना

जमादिउस्सानी (जिसे जमादिउल आख़िरा भी कहते हैं) इस्लामी कैलेंडर का छठा महीना है। इसका मतलब है "दूसरा जमादी"।

इस महीने के बारे में:
• दो जमादी महीनों में दूसरा
• जमादिउल अव्वल से क़ुर्बत की वजह से इसी तरह नाम
• नाम असल सर्दी/ख़ुश्क मौसम की निशानदेही करता है

तारीख़ी वाक़िआत:
• सय्यिदा फ़ातिमा रज़ियल्लाहु अन्हा की विलादत, नबी करीम ﷺ की बेटी (बाज़ आराअ के मुताबिक़)
• इस्लामी तारीख़ में मुख़्तलिफ़ जंगें और मुहिमात

अहम ता���ीख़ें (बाज़ ज़राए के मुताबिक़):
• 20 - सय्यिदा फ़ातिमा रज़ियल्लाहु अन्हा की वफ़ात (दूसरी आराअ भी हैं)
• तारीख़ में मुख़्तलिफ़ उलमा की वफ़ात और विलादत

रूहानी रहनुमाई:
• बिदअत के बग़ैर बाक़ायदा इबादत जारी रखें
• अख़्लाक़ और आमाल बेहतर करने पर तवज्जोह दें
• नबी करीम ﷺ ने फ़रमाया: "ईमान में सबसे कामिल वो मोमिन है जिसका अख़्लाक़ सबसे बेहतर हो।" (तिर्मिज़ी)

मुस्तहब आमाल:
• बाक़ायदा नमाज़
• क़ुरआन की तिलावत
• ज़िक्र और इस्तिग़फ़ार
• इस्लामी इल्म सीखना
• वालिदैन और ख़ानदान की ख़िदमत
• ज़रूरतमंदों की मदद

याद रखें:
• हर महीना रूहानी तरक़्क़ी का मौक़ा है
• इबादत में मुसलसल रहना अल्लाह को कभी कभार की इबादत से ज़्यादा महबूब है''',
        'arabic': '''جمادى الآخرة (جمادى الثانية)

الشهر السادس من السنة الهجرية.

شهر الاستمرار:
• منتصف العام الهجري
• فرصة للمراجعة والتقويم
• محاسبة النفس
• "يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَلْتَنظُرْ نَفْسٌ مَّا قَدَّمَتْ لِغَدٍ" (سورة الحشر: 18)

المحاسبة:
• مراجعة الأعمال
• التوبة من التقصير
• تجديد النية
• العزم على الاستمرار

الأعمال الصالحة:
• المداومة على الطاعات
• عدم الملل والفتور
• "وَاعْبُدْ رَبَّكَ حَتَّىٰ يَأْتِيَكَ الْيَقِينُ" (سورة الحجر: 99)

الاستعداد لرجب:
• قرب شهر رجب المبارك
• التهيؤ للأشهر الفاضلة
• زيادة العمل الصالح

دروس الشهر:
• الاستمرار في الطاعة
• عدم الانقطاع
• المحاسبة الدورية''',
      },
    },
    {
      'number': 7,
      'titleKey': 'month_name_fazilat_7_rajab',
      'title': 'Rajab',
      'titleUrdu': 'رجب',
      'titleHindi': 'रजब',
      'titleArabic': 'رجب',
      'icon': Icons.calendar_month,
      'color': Colors.purple,
      'details': {
        'english': '''Rajab - The Sacred Month

Rajab is the seventh month of the Islamic calendar and one of the four sacred months (Al-Ashhur Al-Hurum).

Meaning of the Name:
• "Rajab" comes from "Tarjeeb" meaning to honor/respect
• Called "Rajab al-Fard" (the Separate One) as it stands alone among the sacred months
• Also known as "Rajab Mudar" after the Arab tribe that greatly respected it

Sacred Status:
• One of four sacred months (Dhul-Qa'dah, Dhul-Hijjah, Muharram, Rajab)
• Fighting was prohibited during these months
• Allah says: "Indeed, the number of months with Allah is twelve months... of these, four are sacred." (Quran 9:36)

The Night Journey (Isra wal Mi'raj):
• The Prophet ﷺ's miraculous night journey occurred in this month (according to most opinions)
• Journey from Makkah to Jerusalem, then to the heavens
• Five daily prayers were prescribed during this journey

Misconceptions to Avoid:
• No specific fasting for entire Rajab is established in Sunnah
• No specific prayers like "Salat al-Raghaib" are authentic
• Avoid innovations not proven from Prophet ﷺ

Recommended Acts:
• Increased Istighfar (seeking forgiveness)
• The Prophet ﷺ would say: "Allahumma barik lana fi Rajab wa Sha'ban wa ballighna Ramadan" (O Allah, bless us in Rajab and Sha'ban, and let us reach Ramadan)
• Prepare spiritually for Ramadan''',
        'urdu': '''رجب - حرمت والا مہینہ

رجب اسلامی تقویم کا ساتواں مہینہ ہے اور چار حرام مہینوں میں سے ایک ہے۔

نام کا مطلب:
• "رجب" "ترجیب" سے آیا ہے جس کا مطلب عزت کرنا ہے
• "رجب الفرد" (اکیلا) کہلاتا ہے کیونکہ یہ حرام مہینوں میں اکیلا کھڑا ہے
• "رجب مضر" بھی کہتے ہیں عرب قبیلے کے نام پر جو اس کی بہت عزت کرتا تھا

حرمت کی حیثیت:
• چار حرام مہینوں میں سے ایک (ذوالقعدہ، ذوالحجہ، محرم، رجب)
• ان مہینوں میں جنگ منع تھی
• اللہ فرماتا ہے: "بیشک اللہ کے نزدیک مہینوں کی تعداد بارہ ہے... ان میں چار حرمت والے ہیں۔" (قرآن 9:36)

اسراء و معراج:
• نبی کریم ﷺ کا معجزاتی رات کا سفر اس مہینے میں ہوا (اکثر آراء کے مطابق)
• مکہ سے بیت المقدس اور پھر آسمانوں تک سفر
• پانچ وقت کی نمازیں اس سفر میں فرض ہوئیں

غلط فہمیوں سے بچیں:
• پورے رجب کے خاص روزے سنت سے ثابت نہیں
• "صلاۃ الرغائب" جیسی خاص نمازیں مستند نہیں
• نبی کریم ﷺ سے ثابت نہ ہونے والی بدعات سے بچیں

مستحب اعمال:
• زیادہ استغفار
• نبی کریم ﷺ فرماتے: "اللھم بارک لنا فی رجب و شعبان و بلغنا رمضان" (اے اللہ، رجب اور شعبان میں ہمیں برکت دے اور رمضان تک پہنچا)
• رمضان کے لیے روحانی طور پر تیاری کریں''',
        'hindi': '''रजब - हुर्मत वाला महीना

रजब इस्लामी कैलेंडर का सातवां महीना है और चार हराम महीनों में से एक है।

नाम का मतलब:
• "रजब" "तर्जीब" से आया है जिसका मतलब इज़्ज़त करना है
• "रजब अल-फ़र्द" (अकेला) कहलाता है क्योंकि यह हराम महीनों में अकेला खड़ा है
• "रजब मुज़र" भी कहते हैं अरब क़बीले के नाम पर जो इसकी बहुत इज़्ज़त करता था

हुर्मत की हैसियत:
• चार हराम महीनों में से एक (ज़ुलक़ादा, ज़ुलहिज्जा, मुहर्रम, रजब)
• इन महीनों में जंग मना थी
• अल्लाह फ़रमाता है: "बेशक अल्लाह के नज़दीक महीनों की तादाद बारह है... इनमें चार हुर्मत वाले हैं।" (क़ुरआन 9:36)

इसरा व मेराज:
• नबी करीम ﷺ का मोजिज़ाती रात का सफ़र इस महीने में हुआ (अक्सर आराअ के मुताबिक़)
• मक्का से बैतुल मक़दिस और फिर आसमानों तक सफ़र
• पांच वक़्त की नमाज़ें इस सफ़र में फ़र्ज़ हुईं

ग़लतफ़हमियों से बचें:
• पूरे रजब के ख़ास रोज़े सुन्नत से साबित नहीं
• "सलातुर रग़ाइब" जैसी ख़ास नमाज़ें मुस्तनद नहीं
• नबी करीम ﷺ से साबित न होने वाली बिदअतों से बचें

मुस्तहब आमाल:
• ज़्यादा इस्तिग़फ़ार
• नबी करीम ﷺ फ़रमाते: "अल्लाहुम्मा बारिक लना फ़ी रजब व शाबान व बल्लिग़ना रमज़ान" (ऐ अल्लाह, रजब और शाबान में हमें बरकत दे और रमज़ान तक पहुंचा)
• रमज़ान के लिए रूहानी तौर पर तैयारी करें''',
        'arabic': '''شهر رجب

السابع من شهور السنة الهجرية وأحد الأشهر الحرم.

فضل شهر رجب:
• من الأشهر الحرم
• "إِنَّ عِدَّةَ الشُّهُورِ عِندَ اللَّهِ اثْنَا عَشَرَ شَهْرًا" (سورة التوبة: 36)
• يحرم فيه القتال
• شهر مبارك

معنى الاسم:
• رجب: أي عظّم وهيّب
• كانت العرب تعظمه
• الرجب: الترجيب والتعظيم

صيام رجب:
• يجوز صيامه
• لكن دون تخصيص
• كصيام سائر الشهور
• لا يفرد بصيام كامل

البدع في رجب:
• لا صلاة الرغائب
• لا عمرة خاصة برجب
• لا ذبح في رجب (العتيرة)
• الالتزام بالسنة

الأعمال المستحبة:
• صيام التطوع
• قيام الليل
• الصدقة والإحسان
• قراءة القرآن

الاستعداد لرمضان:
• رجب مقدمة لرمضان
• التهيؤ والاستعداد
• زيادة الطاعات
• ترك المعاصي''',
      },
    },
    {
      'number': 8,
      'titleKey': 'month_name_fazilat_8_ramadan',
      'title': 'Sha\'ban',
      'titleUrdu': 'شعبان',
      'titleHindi': 'शाबान',
      'titleArabic': 'رمضان',
      'icon': Icons.calendar_month,
      'color': Colors.pink,
      'details': {
        'english': '''Sha'ban - The Month Before Ramadan

Sha'ban is the eighth month of the Islamic calendar, directly preceding the blessed month of Ramadan.

Meaning of the Name:
• "Sha'ban" comes from "sha'b" meaning to spread/scatter
• Arabs would scatter to find water during this month
• Also interpreted as branches spreading from Rajab toward Ramadan

Virtues of Sha'ban:
• The Prophet ﷺ fasted most of this month
• Aisha (RA) said: "I never saw the Prophet ﷺ fast a complete month except Ramadan, and I never saw him fast more in any month than in Sha'ban." (Bukhari & Muslim)

The Night of Mid-Sha'ban (15th):
• Some hadiths mention its virtue, though scholars differ on their authenticity
• It's good to worship on this night, but without considering it obligatory
• Avoid innovations and extreme practices

Preparation for Ramadan:
• Best time to train for Ramadan fasting
• Increase Quran recitation
• The Prophet ﷺ said: "That is a month people neglect between Rajab and Ramadan." (Nasai)

Recommended Acts:
• Voluntary fasting (especially first half of month)
• The Prophet ﷺ prohibited fasting in the second half unless one has a habit
• Increase good deeds
• Review and memorize Quran
• Make up missed fasts from previous Ramadan

Important:
• Stop fasting a day or two before Ramadan
• The Prophet ﷺ said: "Do not precede Ramadan by fasting a day or two before it." (Bukhari)''',
        'urdu': '''شعبان - رمضان سے پہلے کا مہینہ

شعبان اسلامی تقویم کا آٹھواں مہینہ ہے، براہ راست مبارک رمضان سے پہلے آتا ہے۔

نام کا مطلب:
• "شعبان" "شعب" سے آیا ہے جس کا مطلب پھیلنا ہے
• عرب اس مہینے پانی تلاش کرنے کے لیے بکھر جاتے تھے
• یہ بھی تفسیر ہے کہ رجب سے رمضان کی طرف شاخیں پھیلتی ہیں

شعبان کے فضائل:
• نبی کریم ﷺ اس مہینے کا زیادہ تر حصہ روزے رکھتے
• عائشہ رضی اللہ عنہا فرماتی ہیں: "میں نے نبی ﷺ کو رمضان کے سوا کبھی پورا مہینہ روزے رکھتے نہیں دیکھا، اور کسی مہینے میں شعبان سے زیادہ روزے رکھتے نہیں دیکھا۔" (بخاری و مسلم)

شب برات (15 شعبان):
• بعض احادیث اس کی فضیلت بیان کرتی ہیں، حالانکہ علماء ان کی صحت میں اختلاف کرتے ہیں
• اس رات عبادت کرنا اچھا ہے، لیکن اسے واجب نہ سمجھیں
• بدعات اور حد سے زیادہ اعمال سے بچیں

رمضان کی تیاری:
• رمضان کے روزوں کی تربیت کا بہترین وقت
• قرآن کی تلاوت بڑھائیں
• نبی کریم ﷺ نے فرمایا: "یہ وہ مہینہ ہے جسے لوگ رجب اور رمضان کے درمیان نظرانداز کرتے ہیں۔" (نسائی)

مستحب اعمال:
• نفلی روزے (خاص طور پر پہلا نصف)
• نبی کریم ﷺ نے دوسرے نصف میں روزے سے منع کیا جب تک عادت نہ ہو
• نیک اعمال بڑھائیں
• قرآن کا مطالعہ اور حفظ کریں
• پچھلے رمضان کے چھوٹے روزے پورے کریں

اہم:
• رمضان سے ایک یا دو دن پہلے روزہ رکھنا بند کریں
• نبی کریم ﷺ نے فرمایا: "رمضان سے ایک یا دو دن پہلے روزہ رکھ کر اس سے آگے نہ بڑھو۔" (بخاری)''',
        'hindi': '''शाबान - रमज़ान से पहले का महीना

शाबान इस्लामी कैलेंडर का आठवां महीना है, बराहेरास्त मुबारक रमज़ान से पहले आता है।

नाम का मतलब:
• "शाबान" "शअब" से आया है जिसका मतलब फैलना है
• अरब इस महीने पानी तलाश करने के लिए बिखर जाते थे
• यह भी तफ़सीर है कि रजब से रमज़ान की तरफ़ शाख़ें फैलती हैं

शाबान की फ़ज़ीलत:
• नबी करीम ﷺ इस महीने का ज़्यादातर हिस्सा रोज़े रखते
• आइशा रज़ियल्लाहु अन्हा फ़रमाती हैं: "मैंने नबी ﷺ को रमज़ान के सिवा कभी पूरा महीना रोज़े रखते नहीं देखा, और किसी महीने में शाबान से ज़्यादा रोज़े रखते नहीं देखा।" (बुख़ारी व मुस्लिम)

शब-ए-बरात (15 शाबान):
• बाज़ अहादीस इसकी फ़ज़ीलत बयान करती हैं, हालांकि उलमा उनकी सेहत में इख़्तिलाफ़ करते हैं
• इस रात इबादत करना अच्छा है, लेकिन इसे वाजिब न समझें
• बिदअतों और हद से ज़्यादा आमाल से बचें

रमज़ान की तैयारी:
• रमज़ान के रोज़ों की तर्बियत का बेहतरीन वक़्त
• क़ुरआन की तिलावत बढ़ाएं
• नबी करीम ﷺ ने फ़रमाया: "यह वो महीना है जिसे लोग रजब और रमज़ान के दरमियान नज़रअंदाज़ करते हैं।" (नसाई)

मुस्तहब आमाल:
• नफ़्ली रोज़े (ख़ास तौर पर पहला निस्फ़)
• नबी करीम ﷺ ने दूसरे निस्फ़ में रोज़े से मना किया जब तक आदत न हो
• नेक आमाल बढ़ाएं
• क़ुरआन का मुताला और हिफ़्ज़ करें
• पिछले रमज़ान के छूटे रोज़े पूरे करें

अहम:
• रमज़ान से एक या दो दिन पहले रोज़ा रखना बंद करें
• नबी करीम ﷺ ने फ़रमाया: "रमज़ान से एक या दो दिन पहले रोज़ा रखकर उससे आगे न बढ़ो।" (बुख़ारी)''',
        'arabic': '''شهر رمضان

أفضل شهور السنة وشهر الصيام المفروض.

فضل شهر رمضان:
• "شَهْرُ رَمَضَانَ الَّذِي أُنزِلَ فِيهِ الْقُرْآنُ" (سورة البقرة: 185)
• فيه ليلة القدر خير من ألف شهر
• تفتح فيه أبواب الجنة
• تغلق فيه أبواب النار
• تصفد فيه الشياطين

الصيام:
• ركن من أركان الإسلام
• واجب على كل مسلم بالغ عاقل
• من الفجر إلى المغرب
• "كُتِبَ عَلَيْكُمُ الصِّيَامُ" (سورة البقرة: 183)

القيام:
• قيام رمضان سنة مؤكدة
• صلاة التراويح
• قال النبي ﷺ: "من قام رمضان إيماناً واحتساباً غفر له ما تقدم من ذنبه" (البخاري)

ليلة القدر:
• خير من ألف شهر
• "إِنَّا أَنزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ" (سورة القدر: 1)
• في العشر الأواخر من رمضان
• الأرجح في الوتر منها

زكاة الفطر:
• واجبة على كل مسلم
• تطهير للصائم
• طعمة للمساكين
• قبل صلاة العيد''',
      },
    },
    {
      'number': 9,
      'titleKey': 'month_name_fazilat_9_shawwal',
      'title': 'Ramadan',
      'titleUrdu': 'رمضان',
      'titleHindi': 'रमज़ान',
      'titleArabic': 'شوال',
      'icon': Icons.calendar_month,
      'color': Colors.amber,
      'details': {
        'english': '''Ramadan - The Month of Blessings

Ramadan is the ninth month of the Islamic calendar and the holiest month for Muslims worldwide.

The Quran Was Revealed:
• "The month of Ramadan in which the Quran was revealed, a guidance for mankind." (Quran 2:185)
• Laylatul Qadr (Night of Decree) is in this month - better than a thousand months

Obligation of Fasting:
• Fasting is one of the Five Pillars of Islam
• "O you who believe, fasting is prescribed for you as it was prescribed for those before you, that you may become righteous." (Quran 2:183)
• Fast from dawn (Fajr) until sunset (Maghrib)

Virtues of Ramadan:
• Gates of Paradise are opened
• Gates of Hell are closed
• Devils are chained
��� The Prophet ﷺ said: "Whoever fasts Ramadan with faith and seeking reward, his past sins will be forgiven." (Bukhari & Muslim)

Special Acts of Worship:
• Taraweeh prayers at night
• Reciting and completing the Quran
• Increased charity (Zakat and Sadaqah)
• I'tikaf (seclusion in mosque, especially last 10 days)
• Seeking Laylatul Qadr in odd nights of last 10 days

Breaking the Fast (Iftar):
• The Prophet ﷺ would break his fast with dates and water
• Dua at Iftar time is accepted
• "Dhahaba al-zama' wa abtalat al-'urooq wa thabata al-ajru in sha Allah"

Suhoor (Pre-dawn meal):
• The Prophet ﷺ said: "Take Suhoor, for there is blessing in it." (Bukhari)''',
        'urdu': '''رمضان - برکتوں کا مہینہ

رمضان اسلامی تقویم کا نواں مہینہ ہے اور دنیا بھر کے مسلمانوں کے لیے سب سے مقدس مہینہ ہے۔

قرآن کا نزول:
• "رمضان کا مہینہ جس میں قرآن نازل ہوا، لوگوں کے لیے ہدایت۔" (قرآن 2:185)
• لیلۃ القدر (شب قدر) اس مہینے میں ہے - ہزار مہینوں سے بہتر

روزے کی فرضیت:
• روزہ اسلام کے پانچ ارکان میں سے ایک ہے
• "اے ایمان والو، تم پر روزے فرض کیے گئے جیسے تم سے پہلے لوگوں پر فرض کیے گئے، تاکہ تم متقی بنو۔" (قرآن 2:183)
• فجر سے مغرب تک روزہ

رمضان کے فضائل:
• جنت کے دروازے کھول دیے جاتے ہیں
• جہنم کے دروازے بند کر دیے جاتے ہیں
• شیاطین بند کر دیے جاتے ہیں
• نبی کریم ﷺ نے فرمایا: "جو رمضان ایمان اور ثواب کی امید سے روزہ رکھے، اس کے پچھلے گناہ معاف کر دیے جائیں گے۔" (بخاری و مسلم)

خاص عبادات:
• رات کو تراویح کی نماز
• قرآن کی تلاوت اور ختم
• زیادہ صدقہ (زکوٰۃ اور صدقات)
• اعتکاف (مسجد میں گوشہ نشینی، خاص طور پر آخری 10 دن)
• آخری 10 راتوں کی طاق راتوں میں لیلۃ القدر کی تلاش

افطار:
• نبی کریم ﷺ کھجور اور پانی سے روزہ کھولتے
• افطار کے وقت دعا قبول ہوتی ہے
• "ذہب الظمأ و ابتلت العروق و ثبت الأجر إن شاء اللہ"

سحری:
• نبی کریم ﷺ نے فرمایا: "سحری کھاؤ، اس میں برکت ہے۔" (بخاری)''',
        'hindi': '''रमज़ान - बरकतों का महीना

रमज़ान इस्लामी कैलेंडर का नौवां महीना है और दुनिया भर के मुसलमानों के लिए सबसे मुक़द्दस महीना है।

क़ुरआन का नुज़ूल:
• "रमज़ान का महीना जिसमें क़ुरआन नाज़िल हुआ, लोगों के लिए हिदायत।" (क़ुरआन 2:185)
• लैलतुल क़द्र (शब-ए-क़द्र) इस महीने में है - हज़ार महीनों से बेहतर

रोज़े की फ़र्ज़ियत:
• रोज़ा इस्लाम के पांच अरकान में से एक है
• "ऐ ईमान वालो, तुम पर रोज़े फ़र्ज़ किए गए जैसे तुमसे पहले लोगों पर फ़र्ज़ किए गए, ताकि तुम मुत्तक़ी बनो।" (क़ुरआन 2:183)
• फ़ज्र से मग़रिब तक रोज़ा

रमज़ान की फ़ज़ीलत:
• जन्नत के दरवाज़े खोल दिए जाते हैं
• जहन्नम के दरवाज़े बंद कर दिए जाते हैं
• शयातीन बंद कर दिए जाते हैं
• नबी करीम ﷺ ने फ़रमाया: "जो रमज़ान ईमान और सवाब की उम्मीद से रोज़ा रखे, उसके पिछले गुनाह माफ़ कर दिए जाएंगे।" (बुख़ारी व मुस्लिम)

ख़ास इबादात:
• रात को तरावीह की नमाज़
• क़ुरआन की तिलावत और ख़त्म
• ज़्यादा सदक़ा (ज़कात और सदक़ात)
• एतेकाफ़ (मस्जिद में गोशानशीनी, ख़ास तौर पर आख़िरी 10 दिन)
• आख़िरी 10 रातों की ताक़ रातों में लैलतुल क़द्र की तलाश

इफ़्तार:
• नबी करीम ﷺ खजूर और पानी से रोज़ा खोलते
• इफ़्तार के वक़्त दुआ क़बूल होती है
• "ज़हबज़्ज़मा व अब्तलतिल उरूक़ व सबतल अज्रु इन शा अल्लाह"

सहरी:
• नबी करीम ﷺ ने फ़रमाया: "सहरी खाओ, इसमें बरकत है।" (बुख़ारी)''',
        'arabic': '''شهر شوال

العاشر من شهور السنة وفيه عيد الفطر.

عيد الفطر:
• أول أيام شوال
• عيد المسلمين بعد رمضان
• صلاة العيد سنة مؤكدة
• "فَصَلِّ لِرَبِّكَ وَانْحَرْ" (سورة الكوثر: 2)

صيام ستة من شوال:
• قال النبي ﷺ: "من صام رمضان ثم أتبعه ستاً من شوال كان كصيام الدهر" (مسلم)
• تصام متتابعة أو متفرقة
• بعد عيد الفطر
• أجر عظيم

فضل الصيام بعد رمضان:
• دليل على قبول رمضان
• الحسنة بعشر أمثالها
• رمضان (30 × 10 = 300) + شوال (6 × 10 = 60) = 360 يوماً

آداب العيد:
• الاغتسال والتطيب
• لبس أحسن الثياب
• التكبير من الفجر
• الفطر قبل الصلاة
• الذهاب من طريق والعودة من آخر

صلة الرحم:
• زيارة الأقارب
• التهنئة بالعيد
• التسامح والمودة
• إدخال السرور

شكر النعمة:
• شكر الله على إتمام رمضان
• الاستمرار على الطاعة
• عدم العودة للمعاصي''',
      },
    },
    {
      'number': 10,
      'titleKey': 'month_name_fazilat_10_dhulhijjah',
      'title': 'Shawwal',
      'titleUrdu': 'شوال',
      'titleHindi': 'शव्वाल',
      'titleArabic': 'ذو الحجة',
      'icon': Icons.calendar_month,
      'color': Colors.lime,
      'details': {
        'english': '''Shawwal - The Month of Eid

Shawwal is the tenth month of the Islamic calendar, beginning with the celebration of Eid al-Fitr.

Eid al-Fitr (1st Shawwal):
• Day of celebration after completing Ramadan
• The Prophet ﷺ said: "For every people there is a feast and this is our feast." (Bukhari)
• Fasting on Eid day is prohibited
• Pay Zakat al-Fitr before Eid prayer

Six Fasts of Shawwal:
• Highly recommended to fast six days in Shawwal
• The Prophet ﷺ said: "Whoever fasts Ramadan and follows it with six days of Shawwal, it is as if he fasted for a lifetime." (Sahih Muslim)
• Can be fasted consecutively or separately
• Should be done after making up missed Ramadan fasts (according to majority opinion)

Calculation of Reward:
• Ramadan = 10 months (each good deed multiplied by 10)
• 6 days of Shawwal = 2 months
• Total = 12 months (full year of fasting)

Historical Events:
• Battle of Hunayn took place in Shawwal
• Marriage of the Prophet ﷺ to Aisha (RA) was in Shawwal

Acts of Worship:
• Eid prayer and celebration
• Visiting family and friends
• Giving gifts and spreading joy
• Six days of fasting
• Making up missed Ramadan fasts
• Continuing good habits from Ramadan''',
        'urdu': '''شوال - عید کا مہینہ

شوال اسلامی تقویم کا دسواں مہینہ ہے، جو عید الفطر کی خوشی سے شروع ہوتا ہے۔

عید الفطر (یکم شوال):
• رمضان مکمل کرنے کے بعد خوشی کا دن
• نبی کریم ﷺ نے فرمایا: "ہر قوم کی عید ہے اور یہ ہماری عید ہے۔" (بخاری)
• عید کے دن روزہ رکھنا منع ہے
• عید کی نماز سے پہلے زکوٰۃ الفطر دیں

شوال کے چھ روزے:
• شوال میں چھ دن روزے رکھنا بہت مستحب ہے
• نبی کریم ﷺ نے فرمایا: "جس نے رمضان کے روزے رکھے اور اس کے بعد شوال کے چھ دن روزے رکھے، گویا اس نے ہمیشہ روزے رکھے۔" (صحیح مسلم)
• لگاتار یا الگ الگ رکھ سکتے ہیں
• رمضان کے چھوٹے روزے پورے کرنے کے بعد رکھیں (جمہور کی رائے کے مطابق)

ثواب کا حساب:
• رمضان = 10 مہینے (ہر نیکی کا ثواب دس گنا)
• شوال کے 6 دن = 2 مہینے
• کل = 12 مہینے (پورے سال کے روزے)

تاریخی واقعات:
• غزوہ حنین شوال میں ہوئی
• نبی کریم ﷺ کی عائشہ رضی اللہ عنہا سے شادی شوال میں ہوئی

عبادات:
• عید کی نماز اور خوشی
• خاندان اور دوستوں سے ملاقات
• تحائف دینا اور خوشی پھیلانا
• چھ دن کے روزے
• رمضان کے چھوٹے روزے پورے کرنا
• رمضان کی اچھی عادات جاری رکھنا''',
        'hindi': '''शव्वाल - ईद का महीना

शव्वाल इस्लामी कैलेंडर का दसवां महीना है, जो ईदुल फ़ित्र की ख़ुशी से शुरू होता है।

ईदुल फ़ित्र (1 शव्वाल):
• रमज़ान मुकम्मल करने के बाद ख़ुशी का दिन
• नबी करीम ﷺ ने फ़रमाया: "हर क़ौम की ईद है और यह हमारी ईद है।" (बुख़ारी)
• ईद के दिन रोज़ा रखना मना है
• ईद की नमाज़ से पहले ज़कातुल फ़ित्र दें

शव्वाल के छह रोज़े:
• शव्वाल में छह दिन रोज़े रखना बहुत मुस्तहब है
• नबी करीम ﷺ ने फ़रमाया: "जिसने रमज़ान के रोज़े रखे और उसके बाद शव्वाल के छह दिन रोज़े रखे, गोया उसने हमेशा रोज़े रखे।" (सहीह मुस्लिम)
• लगातार या अलग अलग रख सकते हैं
• रमज़ान के छूटे रोज़े पूरे करने के बाद रखें (जमहूर की राय के मुताबिक़)

सवाब का हिसाब:
• रमज़ान = 10 महीने (हर नेकी का सवाब दस गुना)
• शव्वाल के 6 दिन = 2 महीने
• कुल = 12 महीने (पूरे साल के रोज़े)

तारीख़ी वाक़िआत:
• ग़ज़वा हुनैन शव्वाल में हुई
• नबी करीम ﷺ की आइशा रज़ियल्लाहु अन्हा से शादी शव्वाल में हुई

इबादात:
• ईद की नमाज़ और ख़ुशी
• ख़ानदान और दोस्तों से मुलाक़ात
• तोहफ़े देना और ख़ुशी फैलाना
• छह दिन के रोज़े
• रमज़ान के छूटे रोज़े पूरे करना
• रमज़ान की अच्छी आदतें जारी रखना''',
        'arabic': '''ذو الحجة

الثاني عشر من شهور السنة وفيه الحج وعيد الأضحى.

فضل شهر ذي الحجة:
• من الأشهر الحرم
• فيه أفضل أيام الدنيا
• "وَالْفَجْرِ * وَلَيَالٍ عَشْرٍ" (سورة الفجر: 1-2)
• العشر الأوائل منه أفضل أيام العام

العشر الأوائل:
• قال النبي ﷺ: "ما من أيام العمل الصالح فيهن أحب إلى الله من هذه الأيام" (البخاري)
• يستحب الإكثار من العمل الصالح
• التكبير والتهليل والتحميد
• الصيام والصدقة

يوم عرفة:
• التاسع من ذي الحجة
• أعظم أيام السنة
• قال النبي ﷺ: "صيام يوم عرفة أحتسب على الله أن يكفر السنة التي قبله والسنة التي بعده" (مسلم)
• ركن الحج الأعظم

يوم النحر:
• العاشر من ذي الحجة
• عيد الأضحى
• أعظم الأيام عند الله
• "إِنَّ أَوَّلَ بَيْتٍ وُضِعَ لِلنَّاسِ" (سورة آل عمران: 96)

الأضحية:
• سنة مؤكدة
• ذبح الأنعام تقرباً إلى الله
• "فَصَلِّ لِرَبِّكَ وَانْحَرْ" (سورة الكوثر: 2)
• توزيع اللحم على الفقراء

الحج:
• الركن الخامس من أركان الإسلام
• واجب على المستطيع مرة في العمر
• "وَلِلَّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ" (سورة آل عمران: 97)''',
      },
    },
    {
      'number': 11,
      'title': 'Dhul-Qa\'dah',
      'titleUrdu': 'ذوالقعدہ',
      'titleHindi': 'ज़ुलक़ादा',
      'titleArabic': 'النص العربي',
      'icon': Icons.calendar_month,
      'color': Colors.brown,
      'details': {
        'english': '''Dhul-Qa'dah - The Month of Sitting

Dhul-Qa'dah is the eleventh month and one of the four sacred months in Islam.

Meaning of the Name:
• "Dhul-Qa'dah" means "The Month of Sitting"
• Arabs would sit and refrain from traveling and fighting
• Named because people would settle after returning from journeys

Sacred Month Status:
• One of four sacred months (Dhul-Qa'dah, Dhul-Hijjah, Muharram, Rajab)
• Fighting and warfare were prohibited
• "Indeed, the number of months with Allah is twelve... of these, four are sacred." (Quran 9:36)

Preparation for Hajj:
• Pilgrims begin preparing for Hajj
• Those intending Hajj often depart in this month
• The Prophet ﷺ's farewell pilgrimage began in this month

Historical Events:
• Treaty of Hudaybiyyah was signed in this month (6 AH)
• This treaty was called "A Clear Victory" by Allah
• The Prophet ﷺ performed Umrah in this month

Acts of Worship:
• Increased acts of worship as in all sacred months
• Avoid sins (sins are more severe in sacred months)
• Prepare spiritually for Dhul-Hijjah
• Make intention for Hajj or Umrah if possible
• Continue regular prayers and good deeds

Reminder:
• Sacred months demand extra vigilance in avoiding sins
• Increase in worship and seeking forgiveness''',
        'urdu': '''ذوالقعدہ - بیٹھنے کا مہینہ

ذوالقعدہ گیارہواں مہینہ ہے اور اسلام میں چار حرام مہینوں میں سے ایک ہے۔

نام کا مطلب:
• "ذوالقعدہ" کا مطلب ہے "بیٹھنے کا مہینہ"
• عرب بیٹھ جاتے اور سفر اور جنگ سے رک جاتے
• اس لیے نام رکھا گیا کیونکہ لوگ سفر سے واپسی کے بعد ٹھہر جاتے

حرام مہینے کی حیثیت:
• چار حرام مہینوں میں سے ایک (ذوالقعدہ، ذوالحجہ، محرم، رجب)
• جنگ اور لڑائی منع تھی
• "بیشک اللہ کے نزدیک مہینوں کی تعداد بارہ ہے... ان میں چار حرمت والے ہیں۔" (قرآن 9:36)

حج کی تیاری:
• حجاج حج کی تیاری شروع کرتے ہیں
• حج کا ارادہ رکھنے والے اکثر اس مہینے روانہ ہوتے ہیں
• نبی کریم ﷺ کا حجۃ الوداع اس مہینے شروع ہوا

تاریخی واقعات:
• صلح حدیبیہ اس مہینے میں ہوئی (6 ہجری)
• اس معاہدے کو اللہ نے "فتح مبین" کہا
• نبی کریم ﷺ نے اس مہینے عمرہ کیا

عبادات:
• تمام حرام مہینوں کی طرح زیادہ عبادت
• گناہوں سے بچیں (حرام مہینوں میں گناہ زیادہ سنگین ہیں)
• ذوالحجہ کے لیے روحانی تیاری کریں
• اگر ممکن ہو تو حج یا عمرہ کی نیت کریں
• باقاعدہ نمازیں اور نیک اعمال جاری رکھیں

یاد دہانی:
• حرام مہینے گناہوں سے بچنے میں زیادہ ہوشیاری کا تقاضا کرتے ہیں
• عبادت اور مغفرت طلب کرنے میں اضافہ کریں''',
        'hindi': '''ज़ुलक़ादा - बैठने का महीना

ज़ुलक़ादा ग्यारहवां महीना है और इस्लाम में चार हराम महीनों में से एक है।

नाम का मतलब:
• "ज़ुलक़ादा" का मतलब है "बैठने का महीना"
• अरब बैठ जाते और सफ़र और जंग से रुक जाते
• इसलिए नाम रखा गया क्योंकि लोग सफ़र से वापसी के बाद ठहर जाते

हराम महीने की हैसियत:
• चार हराम महीनों में से एक (ज़ुलक़ादा, ज़ुलहिज्जा, मुहर्रम, रजब)
• जंग और लड़ाई मना थी
• "बेशक अल्लाह के नज़दीक महीनों की तादाद बारह है... इनमें च��र हुर्मत वाले हैं।" (क़ुरआन 9:36)

हज की तैयारी:
• हुज्जाज हज की तैयारी शुरू करते हैं
• हज का इरादा रखने वाले अक्सर इस महीने रवाना होते हैं
• नबी करीम ﷺ का हज्जतुल वदा इस महीने शुरू हुआ

तारीख़ी वाक़िआत:
• सुलह हुदैबिया इस महीने में हुई (6 हिजरी)
• इस मुआहदे को अल्लाह ने "फ़तह मुबीन" कहा
• नबी करीम ﷺ ने इस महीने उमरा किया

इबादात:
• तमाम हराम महीनों की तरह ज़्यादा इबादत
• गुनाहों से बचें (हराम महीनों में गुनाह ज़्यादा संगीन हैं)
• ज़ुलहिज्जा के लिए रूहानी तैयारी करें
• अगर मुमकिन हो तो हज या उमरा की नीयत करें
• बाक़ायदा नमाज़ें और नेक आमाल जारी रखें

याददिहानी:
• हराम महीने गुनाहों से बचने में ज़्यादा होशियारी का तक़ाज़ा करते हैं
• इबादत और मग़फ़िरत तलब करने में इज़ाफ़ा करें''',
        'arabic': '''ذو القعدة - شهر القعود

ذو القعدة هو الشهر الحادي عشر وأحد الأشهر الحرم الأربعة في الإسلام.

معنى الاسم:
• "ذو القعدة" تعني "شهر القعود"
• كان العرب يقعدون ويمتنعون عن السفر والقتال
• سمي بذلك لأن الناس كانوا يستقرون بعد العودة من رحلاتهم

مكانة الشهر الحرام:
• أحد الأشهر الحرم الأربعة (ذو القعدة، ذو الحجة، المحرم، رجب)
• كان القتال والحرب محرمين
• "إِنَّ عِدَّةَ الشُّهُورِ عِندَ اللَّهِ اثْنَا عَشَرَ شَهْرًا... مِنْهَا أَرْبَعَةٌ حُرُمٌ" (القرآن 9:36)

الاستعداد للحج:
• يبدأ الحجاج في الاستعداد للحج
• غالباً ما يغادر من ينوي الحج في هذا الشهر
• بدأت حجة الوداع للنبي ﷺ في هذا الشهر

الأحداث التاريخية:
• تم توقيع صلح الحديبية في هذا الشهر (6 هـ)
• سماها الله "فتحاً مبيناً"
• أدى النبي ﷺ العمرة في هذا الشهر

الأعمال الصالحة:
• زيادة الطاعات كما في جميع الأشهر الحرم
• تجنب الذنوب (الذنوب أشد في الأشهر الحرم)
• الاستعداد الروحي لشهر ذي الحجة
• النية للحج أو العمرة إن أمكن
• الاستمرار في الصلوات المنتظمة والأعمال الصالحة

تذكير:
• تتطلب الأشهر الحرم يقظة إضافية لتجنب الذنوب
• الزيادة في العبادة وطلب المغفرة''',
      },
    },
    {
      'number': 12,
      'title': 'Dhul-Hijjah',
      'titleUrdu': 'ذوالحجہ',
      'titleHindi': 'ज़ुलहिज्जा',
      'titleArabic': 'النص العربي',
      'icon': Icons.calendar_month,
      'color': Colors.deepOrange,
      'details': {
        'english': '''Dhul-Hijjah - The Month of Hajj

Dhul-Hijjah is the twelfth and final month of the Islamic calendar, containing the sacred pilgrimage of Hajj.

Meaning of the Name:
• "Dhul-Hijjah" means "The Month of Pilgrimage"
• Named for the Hajj which takes place during this month
• One of the four sacred months

The First Ten Days:
• The Prophet ﷺ said: "There are no days in which righteous deeds are more beloved to Allah than these ten days." (Bukhari)
• These days are better than any other days of the year
• Even jihad is not superior except for one who goes out risking himself and his wealth and does not return with anything

Day of Arafah (9th Dhul-Hijjah):
• The best day of the year
• Fasting on this day expiates sins of two years (previous and coming year)
• The Prophet ﷺ said: "Fasting on the Day of Arafah, I hope Allah will expiate the year before it and the year after it." (Sahih Muslim)
• Pilgrims stand at Arafah - the main pillar of Hajj

Eid al-Adha (10th Dhul-Hijjah):
• Day of Sacrifice
• Commemorates Prophet Ibrahim's (AS) willingness to sacrifice his son
• Qurbani (sacrifice) is performed
• Three days of celebration (Days of Tashreeq: 11th, 12th, 13th)

Recommended Acts:
• Fasting the first 9 days (especially Day of Arafah)
• Abundant Takbeer, Tahleel, and Tahmeed
• Qurbani for those who can afford it
• Increase in all good deeds
• Avoid cutting hair/nails if offering Qurbani''',
        'urdu': '''ذوالحجہ - حج کا مہینہ

ذوالحجہ اسلامی تقویم کا بارہواں اور آخری مہینہ ہے، جس میں حج کا مقدس فریضہ ادا ہوتا ہے۔

نام کا مطلب:
• "ذوالحجہ" کا مطلب ہے "حج کا مہینہ"
• حج کی وجہ سے نام رکھا گیا جو اس مہینے ہوتا ہے
• چار حرام مہینوں میں سے ایک

پہلے دس دن:
• نبی کریم ﷺ نے فرمایا: "ان دس دنوں سے زیادہ کوئی دن نہیں جن میں نیک اعمال اللہ کو زیادہ محبوب ہوں۔" (بخاری)
• یہ دن سال کے کسی بھی دن سے بہتر ہیں
• جہاد بھی ان سے افضل نہیں سوائے اس کے جو جان و مال لے کر نکلے اور واپس نہ آئے

یوم عرفہ (9 ذوالحجہ):
• سال کا بہترین دن
• اس دن روزہ رکھنا دو سال کے گناہوں کا کفارہ ہے (پچھلا اور آنے والا سال)
• نبی کریم ﷺ نے فرمایا: "عرفہ کا روزہ، مجھے امید ہے اللہ پچھلے اور آنے والے سال کے گناہ معاف فرمائے گا۔" (صحیح مسلم)
• حجاج عرفات میں کھڑے ہوتے ہیں - حج کا اہم ترین رکن

عید الاضحی (10 ذوالحجہ):
• قربانی کا دن
• حضرت ابراہیم علیہ السلام کی اپنے بیٹے کو قربان کرنے کی آمادگی کی یاد
• قربانی کی جاتی ہے
• تین دن کی خوشی (ایام تشریق: 11، 12، 13)

مستحب اعمال:
• پہلے 9 دن روزے رکھنا (خاص طور پر یوم عرفہ)
• کثرت سے تکبیر، تہلیل اور تحمید
• جو استطاعت رکھتے ہیں ان کے لیے قربانی
• تمام نیک اعمال میں اضافہ
• قربانی کرنے والے بال/ناخن نہ کاٹیں''',
        'hindi': '''ज़ुलहिज्जा - हज का महीना

ज़ुलहिज्जा इस्लामी कैलेंडर का बारहवां और आख़िरी महीना है, जिसमें हज का मुक़द्दस फ़रीज़ा अदा होता है।

नाम का मतलब:
• "ज़ुलहिज्जा" का मतलब है "हज का महीना"
• हज की वजह से नाम रखा गया जो इस महीने होता है
• चार हराम महीनों में से एक

पहले दस दिन:
• नबी करीम ﷺ ने फ़रमाया: "इन दस दिनों से ज़्यादा कोई दिन नहीं जिनमें नेक आमाल अल्लाह को ज़्यादा महबूब हों।" (बुख़ारी)
• यह दिन साल के किसी भी दिन से बेहतर हैं
• जिहाद भी इनसे अफ़ज़ल नहीं सिवाए उसके जो जान व माल लेकर निकले और वापस न आए

यौम-ए-अरफ़ा (9 ज़ुलहिज्जा):
• साल का बेहतरीन दिन
• इस दिन रोज़ा रखना दो साल के गुनाहों का कफ़्फ़ारा है (पिछला और आने वाला साल)
• नबी करीम ﷺ ने फ़रमाया: "अरफ़ा का रोज़ा, मुझे उम्मीद है अल्लाह पिछले और आने वाले साल के गुनाह माफ़ फ़रमाएगा।" (सहीह मुस्लिम)
• हुज्जाज अरफ़ात में खड़े होते हैं - हज का अहमतरीन रुक्न

ईदुल अज़्हा (10 ज़ुलहिज्जा):
• क़ुर्बानी का दिन
• हज़रत इब्राहीम अलैहिस्सलाम की अपने बेटे को क़ुर्बान करने की आमादगी की याद
• क़ुर्बानी की जाती है
• तीन दिन की ख़ुशी (अय्याम तशरीक़: 11, 12, 13)

मुस्तहब आमाल:
• पहले 9 दिन रोज़े रखना (ख़ास तौर पर यौम-ए-अरफ़ा)
• कसरत से तकबीर, तहलील और तहमीद
• जो इस्तिताअत रखते हैं उनके लिए क़ुर्बानी
• तमाम नेक आमाल में इज़ाफ़ा
• क़ुर्बानी करने वाले बाल/नाख़ून न काटें''',
        'arabic': '''ذو الحجة

الثاني عشر من شهور السنة وفيه الحج وعيد الأضحى.

فضل شهر ذي الحجة:
• من الأشهر الحرم
• فيه أفضل أيام الدنيا
• "وَالْفَجْرِ * وَلَيَالٍ عَشْرٍ" (سورة الفجر: 1-2)
• العشر الأوائل منه أفضل أيام العام

العشر الأوائل:
• قال النبي ﷺ: "ما من أيام العمل الصالح فيهن أحب إلى الله من هذه الأيام" (البخاري)
• يستحب الإكثار من العمل الصالح
• التكبير والتهليل والتحميد
• الصيام والصدقة

يوم عرفة:
• التاسع من ذي الحجة
• أعظم أيام السنة
• قال النبي ﷺ: "صيام يوم عرفة أحتسب على الله أن يكفر السنة التي قبله والسنة التي بعده" (مسلم)
• ركن الحج الأعظم

يوم النحر:
• العاشر من ذي الحجة
• عيد الأضحى
• أعظم الأيام عند الله
• تذكار لاستعداد إبراهيم عليه السلام لذبح ابنه

الأضحية:
• سنة مؤكدة
• ذبح الأنعام تقرباً إلى الله
• "فَصَلِّ لِرَبِّكَ وَانْحَرْ" (سورة الكوثر: 2)
• توزيع اللحم على الفقراء

الحج:
• الركن الخامس من أركان الإسلام
• واجب على المستطيع مرة في العمر
• "وَلِلَّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ" (سورة آل عمران: 97)

الأعمال المستحبة:
• صيام التسع الأوائل (خاصة يوم عرفة)
• كثرة التكبير والتهليل والتحميد
• الأضحية لمن استطاع
• الإكثار من الأعمال الصالحة
• من أراد الأضحية لا يأخذ من شعره وأظافره''',
      },
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredMonths {
    if (_searchQuery.isEmpty) {
      return _islamicMonths;
    }
    final query = _searchQuery.toLowerCase();
    return _islamicMonths.where((month) {
      final title = context
          .tr(month['titleKey'] ?? 'month_name_fazilat_1_muharram')
          .toString()
          .toLowerCase();
      final monthNumber = month['number'].toString();
      return title.contains(query) || monthNumber.contains(query);
    }).toList();
  }

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
          context.tr('month_fazilat'),
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: context.tr('search_month_fazilat'),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onClear: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                enableVoiceSearch: true,
              ),
            ),

            // Islamic Months List
            filteredMonths.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.tr('no_months_found'),
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredMonths.length,
                    itemBuilder: (context, index) {
                      final month = filteredMonths[index];
                      return _buildMonthCard(month, isDark);
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
          Icon(
            _selectedLanguage == value
                ? Icons.check_circle
                : Icons.circle_outlined,
            color: _selectedLanguage == value ? AppColors.primary : Colors.grey,
            size: context.responsive.iconSmall,
          ),
          SizedBox(width: context.responsive.spaceSmall),
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

  Widget _buildMonthCard(Map<String, dynamic> month, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(month['titleKey'] ?? 'month_name');
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
        onTap: () => _showMonthDetails(month),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Month Number Badge
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
                    '${month['number']}',
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
                      textDirection: langCode == 'ur'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Icon chip
                    Container(
                      padding: responsive.paddingSymmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusSmall,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            month['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          SizedBox(width: responsive.spacing(4)),
                          Text(
                            '${context.tr('islamic_month')} ${month['number']}',
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

  void _showMonthDetails(Map<String, dynamic> month) {
    final details = month['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: month['title'] ?? '',
          titleUrdu: month['titleUrdu'] ?? '',
          titleHindi: month['titleHindi'] ?? '',
          titleArabic: month['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: month['color'] as Color,
          icon: month['icon'] as IconData,
          categoryKey: 'category_month_fazilat',
          number: month['number'] as int?,
        ),
      ),
    );
  }
}
