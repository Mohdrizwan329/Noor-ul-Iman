import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class SavabFazilatScreen extends StatefulWidget {
  const SavabFazilatScreen({super.key});

  @override
  State<SavabFazilatScreen> createState() => _SavabFazilatScreenState();
}

class _SavabFazilatScreenState extends State<SavabFazilatScreen> {


  final List<Map<String, dynamic>> _savabTopics = [
    {
      'number': 1,
      'titleKey': 'savab_fazilat_1_understanding_savab',
      'title': 'Understanding Savab',
      'titleUrdu': 'ثواب کی تفہیم',
      'titleHindi': 'सवाब की तफ़हीम',
      'titleArabic': 'فهم الثواب',
      'icon': Icons.star,
      'color': Colors.amber,
      'details': {
        'english': '''Understanding Savab (Reward)

Savab (reward) is the spiritual credit and benefit earned for good deeds done with sincere intention.

What is Savab:
• Savab is the reward from Allah for righteous actions
• It increases one's good deeds on the scale (Mizan) on the Day of Judgment
• The Prophet ﷺ said: "Actions are judged by intentions." (Sahih Bukhari)
• Intention (niyyah) is crucial - deeds without sincere intention have no reward

Multiplying of Rewards:
• "Whoever brings a good deed will have ten times the like thereof." (Quran 6:160)
• Allah can multiply rewards up to 700 times or even more
• Good deeds during special times (Ramadan, first ten days of Dhul Hijjah) are multiplied
• Charity given secretly receives more reward than public charity

Types of Continuous Rewards (Sadaqah Jariyah):
• Building a mosque or well
• Teaching beneficial knowledge
• Raising righteous children
• Planting trees or beneficial plants
• The Prophet ﷺ said: "When a person dies, his deeds come to an end except for three: ongoing charity, beneficial knowledge, or a righteous child who prays for him."

Small Deeds, Great Rewards:
• Saying SubhanAllah 100 times - 1000 good deeds
• Removing obstacles from the road - charity
• A smile to your Muslim brother - charity
• Every step towards the mosque - reward and sin erased
• Saying "Bismillah" before eating - blessing and reward''',
        'urdu': '''ثواب کی تفہیم

ثواب وہ روحانی کریڈٹ اور فائدہ ہے جو مخلصانہ نیت سے نیک کام کرنے پر ملتا ہے۔

ثواب کیا ہے:
• ثواب نیک کاموں پر اللہ کا انعام ہے
• قیامت کے دن میزان میں نیک اعمال بڑھاتا ہے
• نبی کریم ﷺ نے فرمایا: "اعمال کا دارومدار نیتوں پر ہے۔" (صحیح بخاری)
• نیت بہت اہم ہے - مخلص نیت کے بغیر عمل کا کوئی ثواب نہیں

ثواب کی کثرت:
• "جو ایک نیکی لائے اسے اس جیسی دس نیکیاں ملیں گی۔" (قرآن 6:160)
• اللہ ثواب کو 700 گنا یا اس سے بھی زیادہ بڑھا سکتا ہے
• خاص اوقات (رمضان، ذوالحجہ کے پہلے دس دن) میں نیکیاں کئی گنا ہو جاتی ہیں
• خفیہ صدقہ علانیہ صدقے سے زیادہ ثواب رکھتا ہے

جاری ثواب کی اقسام (صدقہ جاریہ):
• مسجد یا کنواں بنانا
• نفع بخش علم سکھانا
• نیک اولاد کی تربیت کرنا
• درخت یا مفید پودے لگانا
• نبی کریم ﷺ نے فرمایا: "جب آدمی مر جاتا ہے تو اس کے اعمال ختم ہو جاتے ہیں سوائے تین چیزوں کے: جاری صدقہ، نفع بخش علم، یا نیک اولاد جو اس کے لیے دعا کرے۔"

چھوٹے عمل، بڑا ثواب:
• سبحان اللہ 100 بار کہنا - 1000 نیکیاں
• راستے سے رکاوٹ ہٹانا - صدقہ
• مسلمان بھائی کو دیکھ کر مسکرانا - صدقہ
• مسجد کی طرف ہر قدم - ثواب اور گناہ مٹنا
• کھانے سے پہلے "بسم اللہ" کہنا - برکت اور ثواب''',
        'hindi': '''सवाब की तफ़हीम

सवाब वो रूहानी क्रेडिट और फ़ायदा है जो मुख़्लिसाना नीयत से नेक काम करने पर मिलता है।

सवाब क्या है:
• सवाब नेक कामों पर अल्लाह का इनाम है
• क़यामत के दिन मीज़ान में नेक आमाल बढ़ाता है
• नबी करीम ﷺ ने फ़रमाया: "आमाल का दारोमदार नीयतों पर है।" (सहीह बुख़ारी)
• नीयत बहुत अहम है - मुख़्लिस नीयत के बग़ैर अमल का कोई सवाब नहीं

सवाब की कसरत:
• "जो एक नेकी लाए उसे उस जैसी दस नेकियां मिलें गी।" (क़ुरआन 6:160)
• अल्लाह सवाब को 700 गुना या उससे भी ज़्यादा बढ़ा सकता है
• ख़ास औक़ात (रमज़ान, ज़ुलहिज्जा के पहले दस दिन) में नेकियां कई गुना हो जाती हैं
• ख़ुफ़िया सदक़ा अलानिया सदक़े से ज़्यादा सवाब रखता है

जारी सवाब की अक़सां (सदक़ा जारिया):
• मस्जिद या कुआं बनाना
• नफ़ाबख़्श इल्म सिखाना
• नेक औलाद की तरबियत करना
• दरख़्त या मुफ़ीद पौधे लगाना
• नबी करीम ﷺ ने फ़रमाया: "जब आदमी मर जाता है तो उसके आमाल ख़त्म हो जाते हैं सिवाए तीन चीज़ों के: जारी सदक़ा, नफ़ाबख़्श इल्म, या नेक औलाद जो उसके लिए दुआ करे।"

छोटे अमल, बड़ा सवाब:
• सुब्हानल्लाह 100 बार कहना - 1000 नेकियां
• रास्ते से रुकावट हटाना - सदक़ा
• मुसलमान भाई को देखकर मुस्कुराना - सदक़ा
• मस्जिद की तरफ़ हर क़दम - सवाब और गुनाह मिटना
• खाने से पहले "बिस्मिल्लाह" कहना - बरकत और सवाब''',
        'arabic': '''فهم الثواب

الثواب هو الجزاء الحسن من الله على الأعمال الصالحة.

تعريف الثواب:
• الجزاء والأجر من الله على الطاعات
• "مَن جَاءَ بِالْحَسَنَةِ فَلَهُ عَشْرُ أَمْثَالِهَا" (سورة الأنعام: 160)
• مضاعفة الحسنات من فضل الله
• الثواب في الدنيا والآخرة

أنواع الثواب:
• ثواب عاجل في الدنيا: كالسعادة وانشراح الصدر
• ثواب آجل في الآخرة: كدخول الجنة
• ثواب القلب: كالطمأنينة والسكينة
• ثواب البدن: كالصحة والعافية
• ثواب المال: كالبركة والزيادة

مضاعفة الحسنات:
• الحسنة بعشر أمثالها إلى سبعمائة ضعف
• قال الله في الحديث القدسي: "من تقرب إلي شبراً تقربت إليه ذراعاً" (البخاري)
• الصدقة تضاعف في رمضان
• العمرة في رمضان كحجة
• الصلاة في المسجد الحرام بمائة ألف صلاة

فضل الأعمال الصالحة:
• "فَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ" (سورة الزلزلة: 7)
• لا يضيع عمل صالح مهما صغر
• الأعمال بالنيات
• الإخلاص شرط قبول العمل

أفضل الأعمال:
• الإيمان بالله ورسوله
• الصلاة في وقتها
• بر الوالدين
• الجهاد في سبيل الله
• قال النبي ﷺ: "أحب الأعمال إلى الله أدومها وإن قل" (البخاري)

الحفاظ على الثواب:
• الإخلاص لله في العمل
• عدم المن والأذى
• البعد عن الرياء
• الاستمرار على الطاعات
• الحذر من المحبطات'''
      },
    },
    {
      'number': 2,
      'titleKey': 'savab_fazilat_2_daily_acts_of_savab',
      'title': 'Daily Acts of Savab',
      'titleUrdu': 'روزمرہ ثواب کے کام',
      'titleHindi': 'रोज़मर्रा सवाब के काम',
      'titleArabic': 'أعمال الثواب اليومية',
      'icon': Icons.today,
      'color': Colors.blue,
      'details': {
        'english': '''Daily Acts That Earn Savab

Simple daily actions can accumulate tremendous rewards.

Morning & Evening:
• Reciting morning and evening adhkar (remembrance)
• Ayat al-Kursi after every prayer - protection and reward
• Last two verses of Surah Al-Baqarah at night
• Saying "Bismillah" - 21 times protects from harm
• Reading Surah Al-Mulk before sleep - protection from grave punishment

Prayer Related:
• Praying Fajr in congregation - guarantee of Paradise
• Praying 12 rak'ah Sunnah daily - house in Paradise
• Making wudu perfectly - sins fall away
• Walking to mosque - every step removes sin and raises rank
• Staying in the mosque after Fajr until Ishraq - reward of Hajj and Umrah

Family & Social:
• Providing for family - counted as charity
• Teaching Quran to children - continuous reward
• Visiting the sick - angels pray for you
• Greeting with Salam - 10 to 30 rewards
• Helping others - equals charity

Food & Sustenance:
• Saying Bismillah before eating
• Eating with right hand
• Eating what is in front of you
• Sharing food with others - great reward
• Not wasting food

Financial Worship:
• Giving charity, even half a date
• Feeding the hungry - tremendous reward
• Giving water to the thirsty
• Helping debtor pay off debt
• Supporting orphans and widows''',
        'urdu': '''روزمرہ ثواب کے کام

آسان روزمرہ کے کام بے شمار ثواب جمع کر سکتے ہیں۔

صبح و شام:
• صبح شام کے اذکار پڑھنا
• ہر نماز کے بعد آیت الکرسی - حفاظت اور ثواب
• رات کو سورہ بقرہ کی آخری دو آیات
• "بسم اللہ" 21 بار کہنا - نقصان سے حفاظت
• سونے سے پہلے سورہ الملک پڑھنا - قبر کے عذاب سے حفاظت

نماز سے متعلق:
• جماعت سے فجر پڑھنا - جنت کی ضمانت
• روزانہ 12 رکعت سنت پڑھنا - جنت میں گھر
• مکمل وضو کرنا - گناہ جھڑ جاتے ہیں
• مسجد کی طرف چلنا - ہر قدم گناہ مٹاتا اور درجہ بلند کرتا ہے
• فجر کے بعد مسجد میں اشراق تک رہنا - حج و عمرہ کا ثواب

خاندان اور معاشرہ:
• خاندان کی کفالت - صدقہ شمار ہوتی ہے
• بچوں کو قرآن سکھانا - جاری ثواب
• بیمار کی عیادت - فرشتے دعا کرتے ہیں
• سلام کرنا - 10 سے 30 نیکیاں
• دوسروں کی مدد - صدقہ کے برابر

کھانا اور رزق:
• کھانے سے پہلے بسم اللہ کہنا
• دائیں ہاتھ سے کھانا
• سامنے سے کھانا
• دوسروں کے ساتھ کھانا بانٹنا - بڑا ثواب
• کھانا ضائع نہ کرنا

مالی عبادت:
• صدقہ دینا، آدھی کھجور بھی
• بھوکوں کو کھانا کھلانا - زبردست ثواب
• پیاسوں کو پانی پلانا
• مقروض کے قرض میں مدد کرنا
• یتیموں اور بیواؤں کی مدد کرنا''',
        'hindi': '''रोज़मर्रा सवाब के काम

आसान रोज़मर्रा के काम बेशुमार सवाब जमा कर सकते हैं।

सुबह व शाम:
• सुबह शाम के अज़कार पढ़ना
• हर नमाज़ के बाद आयतुल कुर्सी - हिफ़ाज़त और सवाब
• रात को सूरा बक़रा की आख़िरी दो आयतें
• "बिस्मिल्लाह" 21 बार कहना - नुक़सान से हिफ़ाज़त
• सोने से पहले सूरा अल-मुल्क पढ़ना - क़ब्र के अज़ाब से हिफ़ाज़त

नमाज़ से मुतअल्लिक़:
• जमाअत से फ़ज्र पढ़ना - जन्नत की ज़मानत
• रोज़ाना 12 रकअत सुन्नत पढ़ना - जन्नत में घर
• मुकम्मल वुज़ू करना - गुनाह झड़ जाते हैं
• मस्जिद की तरफ़ चलना - हर क़दम गुनाह मिटाता और दर्जा बुलंद करता है
• फ़ज्र के बाद मस्जिद में इशराक़ तक रहना - हज व उमरा का सवाब

ख़ानदान और मुआशरा:
• ख़ानदान की किफ़ालत - सदक़ा शुमार होती है
• बच्चों को क़ुरआन सिखाना - जारी सवाब
• बीमार की इयादत - फ़रिश्ते दुआ करते हैं
• सलाम करना - 10 से 30 नेकियां
• दूसरों की मदद - सदक़े के बराबर

खाना और रिज़्क़:
• खाने से पहले बिस्मिल्लाह कहना
• दाएं हाथ से खाना
• सामने से खाना
• दूसरों के साथ खाना बांटना - बड़ा सवाब
• खाना ज़ाया न करना

माली इबादत:
• सदक़ा देना, आधी खजूर भी
• भूखों को खाना खिलाना - ज़बरदस्त सवाब
• प्यासों को पानी पिलाना
• मक़रूज़ के क़र्ज़ में मदद करना
• यतीमों और बेवाओं की मदद करना''',
        'arabic': '''أعمال الثواب اليومية

الأعمال الصالحة التي يمكن فعلها كل يوم.

الصلوات الخمس:
• أعظم الأعمال بعد الشهادتين
• "إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا" (سورة النساء: 103)
• الصلاة في وقتها من أحب الأعمال إلى الله
• صلاة الجماعة تفضل صلاة الفذ بسبع وعشرين درجة

قراءة القرآن:
• "إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ" (سورة الإسراء: 9)
• كل حرف بعشر حسنات
• قراءة سورة الإخلاص تعدل ثلث القرآن
• المواظبة على قراءة صفحة يومياً

الأذكار اليومية:
• أذكار الصباح والمساء
• "الَّذِينَ يَذْكُرُونَ اللَّهَ قِيَامًا وَقُعُودًا" (سورة آل عمران: 191)
• سبحان الله وبحمده مائة مرة: تحط الخطايا
• لا إله إلا الله وحده لا شريك له: أجر عظيم
• الاستغفار سبعين مرة

الصدقة:
• ولو بشق تمرة
• "مَّن ذَا الَّذِي يُقْرِضُ اللَّهَ قَرْضًا حَسَنًا" (سورة البقرة: 245)
• الصدقة تطفئ الخطيئة
• تزيد المال ولا تنقصه
• الكلمة الطيبة صدقة

بر الوالدين:
• من أعظم القربات
• الإحسان إليهما بالقول والفعل
• الدعاء لهما
• طاعتهما في المعروف
• قضاء حوائجهما

صلة الرحم:
• زيارة الأقارب والسؤال عنهم
• مساعدتهم في حاجاتهم
• قال النبي ﷺ: "من سره أن يبسط له في رزقه فليصل رحمه" (البخاري)

إفشاء السلام:
• السلام على من عرفت ومن لم تعرف
• رد السلام واجب
• قال النبي ﷺ: "أفشوا السلام بينكم" (مسلم)

الأمر بالمعروف:
• النصيحة للمسلمين
• إرشاد الضال
• تعليم الجاهل
• إعانة المحتاج'''
      },
    },
    {
      'number': 3,
      'titleKey': 'savab_fazilat_3_excellence_in_worship',
      'title': 'Excellence in Worship',
      'titleUrdu': 'عبادت میں احسان',
      'titleHindi': 'इबादत में एहसान',
      'titleArabic': 'الإحسان في العبادة',
      'icon': Icons.volunteer_activism,
      'color': Colors.green,
      'details': {
        'english': '''Excellence in Worship (Ihsan)

Performing worship with excellence multiplies the reward tremendously.

What is Ihsan:
• The Prophet ﷺ explained: "Ihsan is to worship Allah as if you see Him, and if you cannot see Him, then indeed He sees you." (Sahih Muslim)
• It means perfecting your worship as if Allah is watching
• Bringing consciousness and presence to every act

In Prayer:
• Perfecting your posture and movements
• Understanding what you recite
• Concentration and khushu (humility)
• Praying as if it's your last prayer
• The Prophet ﷺ said: "Pray the prayer of a person who is bidding farewell."

In Charity:
• Giving the best of what you have
• Giving secretly without showing off
• Giving cheerfully and promptly
• "You will never attain righteousness until you spend from that which you love." (Quran 3:92)

In Fasting:
• Guarding the tongue and eyes
• Avoiding idle talk and arguments
• Using time for worship and Quran
• Breaking fast with dates and water (Sunnah)

In Character:
• Treating people with excellence
• Forgiving when you have the power to punish
• Speaking kind words
• The Prophet ﷺ said: "The best of you are those with the best character."

In Work:
• "Indeed, Allah loves that when anyone of you does a job, he does it with proficiency." (Bayhaqi)
• Excellence in your profession earns reward
• Earning halal income with effort

The Reward:
• "Is the reward for excellence anything but excellence?" (Quran 55:60)
• Those who practice Ihsan will receive excellent treatment from Allah''',
        'urdu': '''عبادت میں احسان

احسان کے ساتھ عبادت کرنا ثواب کو بے حد بڑھا دیتا ہے۔

احسان کیا ہے:
• نبی کریم ﷺ نے وضاحت فرمائی: "احسان یہ ہے کہ تم اللہ کی عبادت ایسے کرو جیسے تم اسے دیکھ رہے ہو، اور اگر تم اسے نہیں دیکھ سکتے تو وہ تمہیں دیکھ رہا ہے۔" (صحیح مسلم)
• اس کا مطلب اپنی عبادت کو ایسے کامل کرنا جیسے اللہ دیکھ رہا ہے
• ہر عمل میں شعور اور حضوری لانا

نماز میں:
• اپنی شکل اور حرکات کو کامل کرنا
• جو پڑھو سمجھنا
• توجہ اور خشوع
• نماز ایسے پڑھنا جیسے آخری نماز ہے
• نبی کریم ﷺ نے فرمایا: "الوداعی شخص کی نماز پڑھو۔"

صدقہ میں:
• جو بہترین چیز ہے وہ دینا
• خفیہ دینا بغیر دکھاوے کے
• خوشی اور فوری طور پر دینا
• "تم کبھی نیکی نہیں پاؤ گے جب تک اپنی پسندیدہ چیز خرچ نہ کرو۔" (قرآن 3:92)

روزے میں:
• زبان اور آنکھوں کی حفاظت
• فضول بات اور جھگڑے سے بچنا
• وقت کو عبادت اور قرآن میں استعمال کرنا
• کھجور اور پانی سے افطار کرنا (سنت)

اخلاق میں:
• لوگوں کے ساتھ احسان سے پیش آنا
• سزا دینے کی طاقت ہونے کے باوجود معاف کرنا
• نرم بات کرنا
• نبی کریم ﷺ نے فرمایا: "تم میں سے بہترین وہ ہیں جن کے اخلاق بہترین ہیں۔"

کام میں:
• "بیشک اللہ پسند کرتا ہے کہ جب تم میں سے کوئی کام کرے تو اسے مہارت سے کرے۔" (بیہقی)
• اپنے پیشے میں بہتری ثواب لاتی ہے
• حلال آمدنی محنت سے کمانا

ثواب:
• "کیا احسان کا بدلہ احسان کے سوا کچھ اور ہے؟" (قرآن 55:60)
• جو احسان کرتے ہیں انہیں اللہ کی طرف سے بہترین سلوک ملے گا''',
        'hindi': '''इबादत में एहसान

एहसान के साथ इबादत करना सवाब को बेहद बढ़ा देता है।

एहसान क्या है:
• नबी करीम ﷺ ने वज़ाहत फ़रमाई: "एहसान यह है कि तुम अल्लाह की इबादत ऐसे करो जैसे तुम उसे देख रहे हो, और अगर तुम उसे नहीं देख सकते तो वो तुम्हें देख रहा है।" (सहीह मुस्लिम)
• इसका मतलब अपनी इबादत को ऐसे कामिल करना जैसे अल्लाह देख रहा है
• हर अमल में शऊर और हुज़ूरी लाना

नमाज़ में:
• अपनी शक्ल और हरकात को कामिल करना
• जो पढ़ो समझना
• तवज्जोह और ख़ुशू
• नमाज़ ऐसे पढ़ना जैसे आख़िरी नमाज़ है
• नबी करीम ﷺ ने फ़रमाया: "अलविदाई शख़्स की नमाज़ पढ़ो।"

सदक़े में:
• जो बेहतरीन चीज़ है वो देना
• ख़ुफ़िया देना बग़ैर दिखावे के
• ख़ुशी और फ़ौरन देना
• "तुम कभी नेकी नहीं पाओगे जब तक अपनी पसंदीदा चीज़ ख़र्च न करो।" (क़ुरआन 3:92)

रोज़े में:
• ज़बान और आंखों की हिफ़ाज़त
• फ़ुज़ूल बात और झगड़े से बचना
• वक़्त को इबादत और क़ुरआन में इस्तेमाल करना
• खजूर और पानी से इफ़्तार करना (सुन्नत)

अख़्लाक़ में:
• लोगों के साथ एहसान से पेश आना
• सज़ा देने की ताक़त होने के बावजूद माफ़ करना
• नरम बात करना
• नबी करीम ﷺ ने फ़रमाया: "तुम में से बेहतरीन वो हैं जिनके अख़्लाक़ बेहतरीन हैं।"

काम में:
• "बेशक अल्लाह पसंद करता है कि जब तुम में से कोई काम करे तो उसे महारत से करे।" (बैहक़ी)
• अपने पेशे में बेहतरी सवाब लाती है
• हलाल आमदनी मेहनत से कमाना

सवाब:
• "क्या एहसान का बदला एहसान के सिवा कुछ और है?" (क़ुरआन 55:60)
• जो एहसान करते हैं उन्हें अल्लाह की तरफ़ से बेहतरीन सुलूक मिलेगा''',
        'arabic': '''الإحسان في العبادة

كيفية تحسين العبادات لنيل الثواب العظيم.

معنى الإحسان:
• "أَن تَعْبُدَ اللَّهَ كَأَنَّكَ تَرَاهُ فَإِن لَّمْ تَكُن تَرَاهُ فَإِنَّهُ يَرَاكَ" (حديث جبريل)
• استحضار عظمة الله
• مراقبة الله في كل عمل
• الإتقان في العبادة

الإخلاص في العبادة:
• "وَمَا أُمِرُوا إِلَّا لِيَعْبُدُوا اللَّهَ مُخْلِصِينَ لَهُ الدِّينَ" (سورة البينة: 5)
• النية الخالصة لله
• البعد عن الرياء والسمعة
• طلب الأجر من الله وحده

الخشوع في الصلاة:
• "قَدْ أَفْلَحَ الْمُؤْمِنُونَ * الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ" (سورة المؤمنون: 1-2)
• حضور القلب
• التدبر في القراءة
• الطمأنينة في الركوع والسجود
• الخوف والرجاء

إتقان الوضوء:
• إسباغ الوضوء على المكاره
• غسل الأعضاء ثلاثاً
• التسمية والدعاء
• قال النبي ﷺ: "من توضأ فأحسن الوضوء خرجت خطاياه من جسده" (مسلم)

التدبر في القرآن:
• "أَفَلَا يَتَدَبَّرُونَ الْقُرْآنَ" (سورة النساء: 82)
• فهم معاني الآيات
• التأثر بالمواعظ
• العمل بما في القرآن
• الترتيل في القراءة

الإحسان في الصدقة:
• "الَّذِينَ يُنفِقُونَ أَمْوَالَهُم بِاللَّيْلِ وَالنَّهَارِ سِرًّا وَعَلَانِيَةً" (سورة البقرة: 274)
• الإنفاق من أحب المال
• السرية أفضل إلا إذا كان فيها قدوة
• عدم المن والأذى

المداومة على العمل الصالح:
• قال النبي ﷺ: "أحب الأعمال إلى الله أدومها وإن قل" (البخاري)
• الاستمرار على الطاعة
• عدم الملل والفتور
• المحافظة على النوافل'''
      },
    },
    {
      'number': 4,
      'titleKey': 'savab_fazilat_4_savab_in_special_times',
      'title': 'Savab in Special Times',
      'titleUrdu': 'خاص اوقات میں ثواب',
      'titleHindi': 'ख़ास औक़ात में सवाब',
      'titleArabic': 'الثواب في الأوقات الخاصة',
      'icon': Icons.access_time,
      'color': Colors.purple,
      'details': {
        'english': '''Savab in Special Times

Certain times have multiplied rewards for good deeds.

The Month of Ramadan:
• One good deed equals 70 normal rewards
• Laylat al-Qadr (Night of Power) equals 1000 months
• Umrah in Ramadan equals Hajj in reward
• Feeding a fasting person - full reward without decrease
• Tahajjud and Taraweeh - special night prayers

First Ten Days of Dhul Hijjah:
• "There are no days in which righteous deeds are more beloved to Allah than these ten days." (Bukhari)
• Fasting on Day of Arafah expiates two years of sins
• Day of Sacrifice - greatest day of the year
• Saying Takbir and Tahleel earns immense reward

Friday (Jumu'ah):
• Best day of the week
• Hour when dua is accepted (often believed to be last hour before Maghrib)
• Reciting Surah Al-Kahf - light between two Fridays
• Sending blessings on Prophet ﷺ
• Ghusl and going early to mosque - reward

Last Third of Night:
• "Our Lord descends to the lowest heaven and says: 'Who will call upon Me that I may answer?'" (Bukhari)
• Best time for dua acceptance
• Tahajjud prayer - sign of the righteous
• Seeking forgiveness in pre-dawn time

Day of Ashura:
• 10th of Muharram
• Fasting expiates one year of sins
• Increased charity and worship

Night and Day of Jumu'ah:
• Thursday night and Friday
• Special time for blessings on Prophet ﷺ
• Forgiveness and mercy descend

After Obligatory Prayers:
• Dua is readily accepted
• Adhkar bring protection and reward
• Staying in place until next prayer - continuous reward''',
        'urdu': '''خاص اوقات میں ثواب

کچھ اوقات میں نیک اعمال کا ثواب کئی گنا ہو جاتا ہے۔

رمضان کا مہینہ:
• ایک نیکی 70 عام نیکیوں کے برابر
• لیلۃ القدر 1000 مہینوں کے برابر
• رمضان میں عمرہ حج کے ثواب کے برابر
• روزہ دار کو افطار کرانا - پورا ثواب بغیر کمی
• تہجد اور تراویح - خاص رات کی نمازیں

ذوالحجہ کے پہلے دس دن:
• "کوئی دن نہیں جن میں نیک اعمال اللہ کو ان دس دنوں سے زیادہ محبوب ہوں۔" (بخاری)
• عرفہ کے دن روزہ دو سال کے گناہ مٹاتا ہے
�� قربانی کا دن - سال کا سب سے بڑا دن
• تکبیر اور تہلیل کہنا بے حد ثواب لاتا ہے

جمعہ:
• ہفتے کا بہترین دن
• گھڑی جب دعا قبول ہوتی ہے (اکثر مغرب سے پہلے آخری گھڑی)
• سورہ کہف پڑھنا - دو جمعوں کے درمیان نور
• نبی ﷺ پر درود بھیجنا
• غسل اور جلدی مسجد جانا - ثواب

رات کا آخری تہائی:
• "ہمارا رب آسمان دنیا پر اترتا ہے اور فرماتا ہے: 'کون مجھے پکارے گا کہ میں جواب دوں؟'" (بخاری)
• دعا قبولیت کا بہترین وقت
• تہجد کی نماز - صالحین کی علامت
• فجر سے پہلے معافی مانگنا

عاشورہ کا دن:
• محرم کی 10 تاریخ
• روزہ ایک سال کے گناہ مٹاتا ہے
• صدقہ اور عبادت میں اضافہ

جمعہ کی رات اور دن:
• جمعرات کی رات اور جمعہ
• نبی ﷺ پر درود کا خاص وقت
• مغفرت اور رحمت اترتی ہے

فرض نمازوں کے بعد:
• دعا فوری قبول ہوتی ہے
• اذکار حفاظت اور ثواب لاتے ہیں
• اگلی نماز تک جگہ پر رہنا - جاری ثواب''',
        'hindi': '''ख़ास औक़ात में सवाब

कुछ औक़ात में नेक आमाल का सवाब कई गुना हो जाता है।

रमज़ान का महीना:
• एक नेकी 70 आम नेकियों के बराबर
• लैलतुल क़द्र 1000 महीनों के बराबर
• रमज़ान में उमरा हज के सवाब के बराबर
• रोज़ादार को इफ़्तार कराना - पूरा सवाब बग़ैर कमी
• तहज्जुद और तरावीह - ख़ास रात की नमाज़ें

ज़ुलहिज्जा के पहले दस दिन:
• "कोई दिन नहीं जिनमें नेक आमाल अल्लाह को इन दस दिनों से ज़्यादा महबूब हों।" (बुख़ारी)
• अरफ़ा के दिन रोज़ा दो साल के गुनाह मिटाता है
• क़ुर्बानी का दिन - साल का सबसे बड़ा दिन
• तकबीर और तहलील कहना बेहद सवाब लाता है

जुमा:
• हफ़्ते का बेहतरीन दिन
• घड़ी जब दुआ क़बूल होती है (अक्सर मग़रिब से पहले आख़िरी घड़ी)
• सूरा कह्फ़ पढ़ना - दो जुमों के दरमियान नूर
• नबी ﷺ पर दरूद भेजना
• ग़ुस्ल और जल्दी मस्जिद जाना - सवाब

रात का आख़िरी तिहाई:
• "हमारा रब आसमान दुनिया पर उतरता है और फ़रमाता है: 'कौन मुझे पुकारेगा कि मैं जवाब दूं?'" (बुख़ारी)
• दुआ क़बूलियत का बेहतरीन वक़्त
• तहज्जुद की नमाज़ - सालिहीन की अलामत
• फ़ज्र से पहले माफ़ी मांगना

आशूरा का दिन:
• मुहर्रम की 10 तारीख़
• रोज़ा एक साल के गुनाह मिटाता है
• सदक़ा और इबादत में इज़ाफ़ा

जुमा की रात और दिन:
• जुमेरात की रात और जुमा
• नबी ﷺ पर दरूद का ख़ास वक़्त
• मग़फ़िरत और रहमत उतरती है

फ़र्ज़ नमाज़ों के बाद:
• दुआ फ़ौरन क़बूल होती है
• अज़कार हिफ़ाज़त और सवाब लाते हैं
• अगली नमाज़ तक जगह पर रहना - जारी सवाब''',
        'arabic': '''الثواب في الأوقات الخاصة

الأوقات الفاضلة التي يضاعف فيها الأجر.

شهر رمضان:
• "شَهْرُ رَمَضَانَ الَّذِي أُنزِلَ فِيهِ الْقُرْآنُ" (سورة البقرة: 185)
• العمرة في رمضان كحجة
• ليلة القدر خير من ألف شهر
• الصدقة فيه مضاعفة
• قيام رمضان يكفر الذنوب

عشر ذي الحجة:
• أفضل أيام الدنيا
• قال النبي ﷺ: "ما من أيام العمل الصالح فيهن أحب إلى الله من هذه الأيام" (البخاري)
• يوم عرفة: صيامه يكفر سنتين
• يوم النحر: أعظم الأيام عند الله

يوم الجمعة:
• سيد الأيام
• فيه ساعة إجابة
• قراءة سورة الكهف فيه نور
• كثرة الصلاة على النبي ﷺ
• الغسل والتطيب والتبكير

الثلث الأخير من الليل:
• "يَنزِلُ رَبُّنَا تَبَارَكَ وَتَعَالَىٰ كُلَّ لَيْلَةٍ" (البخاري)
• وقت إجابة الدعاء
• قيام الليل من أفضل النوافل
• التهجد والاستغفار بالأسحار

بين الأذان والإقامة:
• الدعاء لا يرد
• انتظار الصلاة في المسجد
• الذكر والاستغفار
• الصلاة على النبي ﷺ

في السجود:
• أقرب ما يكون العبد من ربه
• قال النبي ﷺ: "أقرب ما يكون العبد من ربه وهو ساجد" (مسلم)
• الدعاء في السجود مستجاب
• الإكثار من الدعاء

عند نزول المطر:
• وقت إجابة الدعاء
• رحمة من الله
• الاستغفار والذكر
• طلب الخير والبركة

في السفر:
• دعوة المسافر مستجابة
• قصر الصلاة رخصة
• الذكر في السفر
• التقرب إلى الله بالطاعات'''
      },
    },
    {
      'number': 5,
      'titleKey': 'savab_fazilat_5_words_that_earn_savab',
      'title': 'Words That Earn Savab',
      'titleUrdu': 'ثواب لانے والے الفاظ',
      'titleHindi': 'सवाब लाने वाले अल्फ़ाज़',
      'titleArabic': 'كلمات تكسب الثواب',
      'icon': Icons.record_voice_over,
      'color': Colors.teal,
      'details': {
        'english': '''Words That Earn Great Savab

Simple words of remembrance bring tremendous rewards.

The Best Words:
• "SubhanAllah" (Glory be to Allah)
• "Alhamdulillah" (All praise is for Allah)
• "La ilaha illallah" (There is no god but Allah)
• "Allahu Akbar" (Allah is the Greatest)
• The Prophet ﷺ said these are the most beloved words to Allah

Specific Rewards:
• "SubhanAllahi wa bihamdihi" 100 times - sins forgiven even if like sea foam (Bukhari)
• "La ilaha illallah wahdahu la sharika lah..." 10 times - reward of freeing 4 slaves
• "SubhanAllah wa bihamdihi, SubhanAllahil-Azeem" - two light words, heavy on the scale
• Ayat al-Kursi after prayer - nothing prevents entry to Paradise except death

Sending Blessings on Prophet:
• One salawat (blessing) - Allah sends 10 blessings
• "Allahumma salli ala Muhammad wa ala ali Muhammad"
• Special emphasis on Fridays
• Saying it 10 times in morning and evening - Prophet's intercession guaranteed

Words of Gratitude:
• "Alhamdulillah alaa kulli haal" - Praise Allah in all situations
• Being thankful increases blessings
• "If you are grateful, I will surely increase you." (Quran 14:7)

Seeking Forgiveness:
• "Astaghfirullah" - asking Allah's forgiveness
• Sayyid al-Istighfar (Master of seeking forgiveness) - erases sins
• The Prophet ﷺ sought forgiveness 70-100 times daily

Morning & Evening Adhkar:
• Comprehensive protection and rewards
• "Whoever says 'Bismillahi alladhi la yadurru...' three times, nothing will harm him" (Abu Dawud)
• Regular recitation brings barakah''',
        'urdu': '''ثواب لانے والے الفاظ

ذکر کے آسان الفاظ بے حد ثواب لاتے ہیں۔

بہترین الفاظ:
• "سبحان اللہ" (اللہ پاک ہے)
• "الحمد للہ" (تمام تعریف اللہ کے لیے)
• "لا الہ الا اللہ" (اللہ کے سوا کوئی معبود نہیں)
• "اللہ اکبر" (اللہ سب سے بڑا ہے)
• نبی کریم ﷺ نے فرمایا یہ اللہ کو سب سے زیادہ محبوب الفاظ ہیں

مخصوص ثواب:
• "سبحان اللہ وبحمدہ" 100 بار - گناہ معاف ہو جاتے ہیں خواہ سمندر کی جھاگ جتنے ہوں (بخاری)
• "لا الہ الا اللہ وحدہ لا شریک لہ..." 10 بار - 4 غلام آزاد کرنے کا ثواب
• "سبحان اللہ وبحمدہ، سبحان اللہ العظیم" - دو ہلکے الفاظ، میزان میں بھاری
• نماز کے بعد آیت الکرسی - موت کے سوا جنت میں داخلے میں کچھ نہیں روکتا

نبی ﷺ پر درود:
• ایک درود - اللہ 10 رحمتیں بھیجتا ہے
• "اللھم صل علی محمد وعلی آل محمد"
• جمعہ کو خاص زور
• صبح شام 10 بار کہنا - نبی ﷺ کی شفاعت کی ضمانت

شکر گزاری کے الفاظ:
• "الحمد للہ علی کل حال" - ہر حال میں اللہ کی حمد
• شکر کرنے سے نعم��یں بڑھتی ہیں
• "اگر تم شکر کرو تو میں تمہیں بڑھاؤں گا۔" (قرآن 14:7)

معافی مانگنا:
• "استغفر اللہ" - اللہ سے معافی مانگنا
• سید الاستغفار (معافی مانگنے کا سردار) - گناہ مٹاتا ہے
• نبی کریم ﷺ روزانہ 70-100 بار معافی مانگتے

صبح شام کے اذکار:
• جامع حفاظت اور ثواب
• "جو تین بار 'بسم اللہ الذی لا یضر...' کہے، کچھ نقصان نہیں پہنچائے گا" (ابو داؤد)
• باقاعدہ پڑھنے سے برکت آتی ہے''',
        'hindi': '''सवाब लाने वाले अल्फ़ाज़

ज़िक्र के आसान अल्फ़ाज़ बेहद सवाब लाते हैं।

बेहतरीन अल्फ़ाज़:
• "सुब्हानल्लाह" (अल्लाह पाक है)
• "अलहम्दुलिल्लाह" (तमाम तारीफ़ अल्लाह के लिए)
• "ला इलाहा इल्लल्लाह" (अल्लाह के सिवा कोई माबूद नहीं)
• "अल्लाहु अकबर" (अल्लाह सबसे बड़ा है)
• नबी करीम ﷺ ने फ़रमाया यह अल्लाह को सबसे ज़्यादा महबूब अल्फ़ाज़ हैं

मख़सूस सवाब:
• "सुब्हानल्लाहि व बिहम्दिही" 100 बार - गुनाह माफ़ हो जाते हैं ख़्वाह समुंदर की झाग जितने हों (बुख़ारी)
• "ला इलाहा इल्लल्लाहु वहदहु ला शरीका लह..." 10 बार - 4 ग़ुलाम आज़ाद करने का सवाब
• "सुब्हानल्लाहि व बिहम्दिही, सुब्हानल्लाहिल अज़ीम" - दो हल्के अल्फ़ाज़, मीज़ान में भारी
• नमाज़ के बाद आयतुल कुर्सी - मौत के सिवा जन्नत में दाख़िले में कुछ नहीं रोकता

नबी ﷺ पर दरूद:
• एक दरूद - अल्लाह 10 रहमतें भेजता है
• "अल्लाहुम्म सल्लि अला मुहम्मद व अला आलि मुहम्मद"
• जुमा को ख़ास ज़ोर
• सुबह शाम 10 बार कहना - नबी ﷺ की शफ़ाअत की ज़मानत

शुक्रगुज़ारी के अल्फ़ाज़:
• "अलहम्दुलिल्लाहि अला कुल्लि हाल" - हर हाल में अल्लाह की हम्द
• शुक्र करने से नेमतें बढ़ती हैं
• "अगर तुम शुक्र करो तो मैं तुम्हें बढ़ाऊंगा।" (क़ुरआन 14:7)

माफ़ी मांगना:
• "अस्तग़फ़िरुल्लाह" - अल्लाह से माफ़ी मांगना
• सय्यिदुल इस्तिग़फ़ार (माफ़ी मांगने का सरदार) - गुनाह मिटाता है
• नबी करीम ﷺ रोज़ाना 70-100 बार माफ़ी मांगते

सुबह शाम के अज़कार:
• जामेअ हिफ़ाज़त और सवाब
• "जो तीन बार 'बिस्मिल्लाहिल्लज़ी ला यज़ुर्रु...' कहे, कुछ नुक़सान नहीं पहुंचाएगा" (अबू दाऊद)
• बाक़ायदा पढ़ने से बरकत आती है''',
        'arabic': '''كلمات تكسب الثواب

الأذكار والكلمات الجامعة للخير.

التسبيح:
• سبحان الله وبحمده: تحط الخطايا
• سبحان الله العظيم وبحمده: غرس نخلة في الجنة
• سبحان الله والحمد لله: تملأ ما بين السماء والأرض
• ثلاث وثلاثون بعد كل صلاة

التهليل:
• لا إله إلا الله وحده لا شريك له: أفضل الذكر
• "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير" مائة مرة
• كعتق عشر رقاب
• تحرز من الشيطان

الحمد:
• الحمد لله: تملأ الميزان
• الحمد لله على كل حال
• الحمد لله رب العالمين
• شكر النعم يزيدها

الصلاة على النبي:
• "إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ" (سورة الأحزاب: 56)
• من صلى عليه مرة صلى الله عليه عشراً
• يوم الجمعة أفضل الأوقات
• اللهم صل على محمد وعلى آل محمد

الاستغفار:
• أستغفر الله العظيم
• سيد الاستغفار: "اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك"
• من قاله موقناً به حين يمسي فمات دخل الجنة
• الاستغفار سبعين مرة في اليوم

الباقيات الصالحات:
• سبحان الله والحمد لله ولا إله إلا الله والله أكبر
• خير ما تركه النبي ﷺ
• "خَيْرٌ وَأَبْقَىٰ" (سورة مريم: 76)
• ثقيلة في الميزان

كلمات جامعة:
• لا حول ولا قوة إلا بالله: كنز من كنوز الجنة
• حسبي الله ونعم الوكيل
• رضيت بالله رباً وبالإسلام ديناً وبمحمد نبياً
• اللهم إني أسألك الجنة وأعوذ بك من النار'''
      },
    },
    {
      'number': 6,
      'titleKey': 'savab_fazilat_6_preserving_your_savab',
      'title': 'Preserving Your Savab',
      'titleUrdu': 'اپنے ثواب کی حفاظت',
      'titleHindi': 'अपने सवाब की हिफ़ाज़त',
      'titleArabic': 'حفظ الثواب',
      'icon': Icons.shield,
      'color': Colors.orange,
      'details': {
        'english': '''Preserving Your Savab (Rewards)

Protecting good deeds is as important as performing them.

Avoiding Riya (Showing Off):
• "So whoever hopes to meet his Lord, let him do righteous work and not associate anyone in the worship of his Lord." (Quran 18:110)
• Doing good deeds to impress people nullifies reward
• Keep good deeds secret when possible
• The Prophet ﷺ warned riya is subtle shirk

Avoiding Backbiting (Gheebah):
• "Would one of you like to eat the flesh of his dead brother?" (Quran 49:12)
• Backbiting gives your good deeds to the person you spoke about
• On Day of Judgment, your rewards transfer to them
• Guard your tongue always

Avoiding Pride and Arrogance:
• Pride in good deeds destroys their reward
• "Do not consider any good deed insignificant, even meeting your brother with a cheerful face." (Muslim)
• Remain humble despite good actions
• Remember all ability to do good is from Allah

Not Reminding Others of Favors:
• "O you who believe, do not invalidate your charities with reminders or injury." (Quran 2:264)
• Mentioning your favors to someone cancels the reward
• Give and forget
• True charity is done for Allah's sake alone

Following Good with Bad:
• Avoid sinning after acts of worship
• The Prophet ﷺ said: "Follow up a bad deed with a good deed and it will wipe it out."
• Maintain consistency in worship
• Don't waste rewards earned in Ramadan by sinning after

Protecting Through Dua:
• "O Allah, accept from me and make it sincerely for Your sake"
• Ask Allah to protect your deeds from being wasted
• Seek refuge from ostentation
• End every good deed with istighfar (seeking forgiveness) for any deficiency''',
        'urdu': '''اپنے ثواب کی حفاظت

نیک اعمال کرنے جتنی ان کی حفاظت بھی اہم ہے۔

ریا (دکھاوا) سے بچنا:
• "تو جو اپنے رب سے ملنے کی امید رکھے اسے چاہیے کہ نیک عمل کرے اور اپنے رب کی عبادت میں کسی کو شریک نہ کرے۔" (قرآن 18:110)
• لوگوں کو متاثر کرنے کے لیے نیک کام کرنا ثواب ختم کر دیتا ہے
• جب ممکن ہو نیک کام خفیہ رکھیں
• نبی کریم ﷺ نے خبردار کیا کہ ریا چھوٹا شرک ہے

غیبت سے بچنا:
• "کیا تم میں سے کوئی پسند کرے گا کہ اپنے مردہ بھائی کا گوشت کھائے؟" (قرآن 49:12)
• غیبت آپ کی نیکیاں اس شخص کو دے دیتی ہے جس کے بارے میں بات کی
• قیامت کے دن آپ کے ثواب ان کو منتقل ہو جاتے ہیں
• ہمیشہ اپنی زبان کی حفاظت کریں

تکبر اور غرور سے بچنا:
• نیک کاموں پر تکبر ان کا ثواب ختم کر دیتا ہے
• "کوئی بھی نیک کام چھوٹا نہ سمجھو، حتیٰ کہ اپنے بھائی سے خوش چہرے سے ملنا۔" (مسلم)
• نیک کاموں کے باوجود عاجز رہیں
• یاد رکھیں نیک کام کرنے کی تمام طاقت اللہ سے ہے

احسان جتانے سے بچنا:
• "اے ایمان والو! اپنے صدقات کو احسان جتا کر اور تکلیف دے کر برباد نہ کرو۔" (قرآن 2:264)
• کسی کو اپنے احسان یاد دلانا ثواب ختم کر دیتا ہے
• دیں اور بھول جائیں
• اصل صدقہ صرف اللہ کی رضا کے لیے ہوتا ہے

نیکی کے بعد برائی:
• عبادت کے بعد گناہ سے بچیں
• نبی کریم ﷺ نے فرمایا: "برے عمل کے بعد نیک عمل کرو تو وہ اسے مٹا دے گا۔"
• عبادت میں مستقل مزاجی برقرار رکھیں
• رمضان میں کمایا ہوا ثواب بعد میں گناہ کر کے ضائع نہ کریں

دعا سے حفاظت:
• "اے اللہ، مجھ سے قبول فرما اور اسے صرف تیری رضا کے لیے کر دے"
• اللہ سے دعا کریں کہ آپ کے اعمال ضائع نہ ہوں
• دکھاوے سے پناہ مانگیں
• ہر نیک کام کو استغفار کے ساتھ ختم کریں کسی کمی کے لیے''',
        'hindi': '''अपने सवाब की हिफ़ाज़त

नेक आमाल करने जितनी उनकी हिफ़ाज़त भी अहम है।

रिया (दिखावा) से बचना:
• "तो जो अपने रब से मिलने की उम्मीद रखे उसे चाहिए कि नेक अमल करे और अपने रब की इबादत में किसी को शरीक न करे।" (क़ुरआन 18:110)
• लोगों को मुतास्सिर करने के लिए नेक काम करना सवाब ख़त्म कर देता है
• जब मुमकिन हो नेक काम ख़ुफ़िया रखें
• नबी करीम ﷺ ने ख़बरदार किया कि रिया छोटा शिर्क है

ग़ीबत से बचना:
• "क्या तुम में से कोई पसंद करेगा कि अपने मुर्दा भाई का गोश्त खाए?" (क़ुरआन 49:12)
• ग़ीबत आपकी नेकियां उस शख़्स को दे देती है जिसके बारे में बात की
• क़यामत के दिन आपके सवाब उनको मुंतक़िल हो जाते हैं
• हमेशा अपनी ज़बान की हिफ़ाज़त करें

तकब्बुर और ग़ुरूर से बचना:
• नेक कामों पर तकब्बुर उनका सवाब ख़त्म कर देता है
• "कोई भी नेक काम छोटा न समझो, हत्ता कि अपने भाई से ख़ुश चेहरे से मिलना।" (मुस्लिम)
• नेक कामों के बावजूद आजिज़ रहें
• याद रखें नेक काम करने की तमाम ताक़त अल्लाह से है

एहसान जताने से बचना:
• "ऐ ईमान वालो! अपने सदक़ात को एहसान जताकर और तकलीफ़ देकर बर्बाद न करो।" (क़ुरआन 2:264)
• किसी को अपने एहसान याद दिलाना सवाब ख़त्म कर देता है
• दें और भूल जाएं
• असल सदक़ा सिर्फ़ अल्लाह की रज़ा के लिए होता है

नेकी के बाद बुराई:
• इबादत के बाद गुनाह से बचें
• नबी करीम ﷺ ने फ़रमाया: "बुरे अमल के बाद नेक अमल करो तो वो उसे मिटा देगा।"
• इबादत में मुस्तक़िल मिज़ाजी बरक़रार रखें
• रमज़ान में कमाया हुआ सवाब बाद में गुनाह करके ज़ाया न करें

दुआ से हिफ़ाज़त:
• "ऐ अल्लाह, मुझसे क़बूल फ़रमा और इसे सिर्फ़ तेरी रज़ा के लिए कर दे"
• अल्लाह से दुआ करें कि आपके आमाल ज़ाया न हों
• दिखावे से पनाह मांगें
• हर नेक काम को इस्तिग़फ़ार के साथ ख़त्म करें किसी कमी के लिए''',
        'arabic': '''حفظ الثواب

كيفية المحافظة على الحسنات وعدم إحباطها.

محبطات الأعمال:
• الشرك بالله: يحبط جميع الأعمال
• "لَئِنْ أَشْرَكْتَ لَيَحْبَطَنَّ عَمَلُكَ" (سورة الزمر: 65)
• الرياء والسمعة
• المن والأذى في الصدقة
• الردة عن الإسلام - والعياذ بالله

الرياء:
• الشرك الأصغر
• يحبط العمل
• قال النبي ﷺ: "أخوف ما أخاف عليكم الشرك الأصغر: الرياء" (أحمد)
• الإخلاص لله في كل عمل

المن والأذى:
• "لَا تُبْطِلُوا صَدَقَاتِكُم بِالْمَنِّ وَالْأَذَىٰ" (سورة البقرة: 264)
• المن على المتصدق عليه يبطل الصدقة
• إيذاء الفقير بالكلام
• التفاخر بالعطاء

الغيبة والنميمة:
• تأكل الحسنات كما تأكل النار الحطب
• تنقل حسنات المغتاب للمغتاب
• قال النبي ﷺ: "أتدرون ما الغيبة؟ ذكرك أخاك بما يكره" (مسلم)

الظلم:
• "إِنَّ الظُّلْمَ ظُلُمَاتٌ يَوْمَ الْقِيَامَةِ" (مسلم)
• ظلم العباد يوجب القصاص
• تؤخذ حسنات الظالم وتعطى للمظلوم
• رد الحقوق قبل يوم القيامة

الكبر والعجب:
• احتقار الناس واستصغارهم
• الإعجاب بالنفس والعمل
• قال النبي ﷺ: "لا يدخل الجنة من كان في قلبه مثقال ذرة من كبر" (مسلم)

طرق الحفاظ على الحسنات:
• الإخلاص لله في كل عمل
• إخفاء الأعمال الصالحة
• الاستمرار على الطاعات
• الحذر من المعاصي
• التوبة عند الوقوع في الذنب
• كثرة الاستغفار

الدعاء بحفظ الأعمال:
• اللهم تقبل مني واجعله خالصاً لوجهك
• اللهم لا تجعل الدنيا أكبر همنا
• اللهم احفظ علينا ديننا
• ربنا تقبل منا إنك أنت السميع العليم'''
      },
    },
    {
      'number': 7,
      'titleKey': 'savab_fazilat_7_quran_recitation',
      'title': 'Savab of Quran Recitation',
      'titleUrdu': 'قرآن پڑھنے کا ثواب',
      'titleHindi': 'क़ुरआन पढ़ने का सवाब',
      'titleArabic': 'ثواب تلاوة القرآن',
      'icon': Icons.menu_book,
      'color': Colors.indigo,
      'details': {
        'english': '''Savab of Quran Recitation

The Quran is the word of Allah, and its recitation carries immense rewards.

Ten Rewards Per Letter:
• The Prophet ﷺ said: "Whoever recites a letter from Allah's Book, he receives the reward from it, and the reward is multiplied by ten."
• "I am not saying that 'Alif, Laam, Meem' is one letter, but 'Alif' is a letter, 'Laam' is a letter, and 'Meem' is a letter." (Tirmidhi)
• This means reading "Bismillah" alone gives 190 rewards!

Double Reward for Struggling Readers:
• "The one who is proficient in the Quran will be with the noble and obedient angels."
• "And the one who recites with difficulty, stammering or struggling through its verses, will have TWICE that reward." (Bukhari & Muslim)
• Don't be discouraged if reading is difficult - you get even more reward!

Reward of Night Recitation:
• "Whoever recites ten verses in night prayer will not be recorded among the forgetful."
• "Whoever recites a hundred verses will be recorded among the devout."
• "Whoever recites a thousand verses will be recorded among those who pile up good deeds." (Abu Dawud)

Best of People:
• The Prophet ﷺ said: "The best of you are those who learn the Quran and teach it to others." (Bukhari)
• Teaching Quran is Sadaqah Jariyah - continuous reward even after death

Specific Surahs and Their Virtues:
• Surah Al-Fatihah: Greatest Surah in the Quran
• Ayat al-Kursi after every prayer: Nothing prevents entry to Paradise except death
• Surah Al-Ikhlas: Equal to one-third of the Quran
• Surah Al-Mulk before sleep: Protection from grave punishment
• Last two verses of Al-Baqarah at night: Sufficient protection

Reward for Listening:
• "Whoever listens to a verse from the Book of Allah will have a multiplied reward, and whoever recites it, it will serve as light for him on Day of Judgment." (Ahmad)

Completing the Quran:
• Angels make dua for the one who completes recitation
• The Prophet ﷺ said: "Recite the Quran, for it will come as an intercessor for its people on Day of Resurrection." (Muslim)''',
        'urdu': '''قرآن پڑھنے کا ثواب

قرآن اللہ کا کلام ہے، اور اس کی تلاوت میں بے حد ثواب ہے۔

ہر حرف پر دس نیکیاں:
• نبی کریم ﷺ نے فرمایا: "جو اللہ کی کتاب سے ایک حرف پڑھے، اسے اس پر ثواب ملتا ہے، اور ثواب دس گنا ہو جاتا ہے۔"
• "میں یہ نہیں کہتا کہ 'الم' ایک حرف ہے، بلکہ 'الف' ایک حرف ہے، 'لام' ایک حرف ہے، اور 'میم' ایک حرف ہے۔" (ترمذی)
• اس کا مطلب صرف "بسم اللہ" پڑھنے سے 190 نیکیاں ملتی ہیں!

مشکل سے پڑھنے والوں کو دگنا ثواب:
• "جو قرآن میں ماہر ہے وہ معزز اور فرمانبردار فرشتوں کے ساتھ ہوگا۔"
• "اور جو مشکل سے پڑھتا ہے، اٹکتے ہوئے، اسے دگنا ثواب ملے گا۔" (بخاری و مسلم)
• اگر پڑھنا مشکل ہے تو حوصلہ شکنی نہ کریں - آپ کو زیادہ ثواب ملتا ہے!

رات کی تلاوت کا ثواب:
• "جو رات کی نماز میں دس آیات پڑھے، غافلوں میں نہیں لکھا جائے گا۔"
• "جو سو آیات پڑھے، عبادت گزاروں میں لکھا جائے گا۔"
• "جو ہزار آیات پڑھے، نیکیوں کے ڈھیر لگانے والوں میں لکھا جائے گا۔" (ابو داؤد)

بہترین لوگ:
• نبی کریم ﷺ نے فرمایا: "تم میں سے بہترین وہ ہیں جو قرآن سیکھیں اور دوسروں کو سکھائیں۔" (بخاری)
• قرآن سکھانا صدقہ جاریہ ہے - موت کے بعد بھی جاری ثواب

مخصوص سورتوں کی فضیلت:
• سورہ الفاتحہ: قرآن کی سب سے عظیم سورت
• ہر نماز کے بعد آیت الکرسی: موت کے سوا جنت میں داخلے میں کچھ نہیں روکتا
• سورہ الاخلاص: قرآن کے ایک تہائی کے برابر
• سونے سے پہلے سورہ الملک: قبر کے عذاب سے حفاظت
• سورہ البقرہ کی آخری دو آیات رات کو: کافی حفاظت

سننے کا ثواب:
• "جو اللہ کی کتاب سے ایک آیت سنے اسے کئی گنا ثواب ملے گا، اور جو پڑھے، قیامت کے دن اس کے لیے روشنی ہوگی۔" (احمد)

قرآن مکمل کرنا:
• فرشتے ختم قرآن کرنے والے کے لیے دعا کرتے ہیں
• نبی کریم ﷺ نے فرمایا: "قرآن پڑھو، کیونکہ یہ قیامت کے دن اپنے پڑھنے والوں کی سفارش کرے گا۔" (مسلم)''',
        'hindi': '''क़ुरआन पढ़ने का सवाब

क़ुरआन अल्लाह का कलाम है, और इसकी तिलावत में बेहद सवाब है।

हर हर्फ़ पर दस नेकियां:
• नबी करीम ﷺ ने फ़रमाया: "जो अल्लाह की किताब से एक हर्फ़ पढ़े, उसे उस पर सवाब मिलता है, और सवाब दस गुना हो जाता है।"
• "मैं यह नहीं कहता कि 'अलिफ़ लाम मीम' एक हर्फ़ है, बल्कि 'अलिफ़' एक हर्फ़ है, 'लाम' एक हर्फ़ है, और 'मीम' एक हर्फ़ है।" (तिर्मिज़ी)
• इसका मतलब सिर्फ़ "बिस्मिल्लाह" पढ़ने से 190 नेकियां मिलती हैं!

मुश्किल से पढ़ने वालों को दोगुना सवाब:
• "जो क़ुरआन में माहिर है वो मुअज़्ज़ज़ और फ़रमांबरदार फ़रिश्तों के साथ होगा।"
• "और जो मुश्किल से पढ़ता है, अटकते हुए, उसे दोगुना सवाब मिलेगा।" (बुख़ारी व मुस्लिम)
• अगर पढ़ना मुश्किल है तो हौसला शिकनी न करें - आपको ज़्यादा सवाब मिलता है!

रात की तिलावत का सवाब:
• "जो रात की नमाज़ में दस आयात पढ़े, ग़ाफ़िलों में नहीं लिखा जाएगा।"
• "जो सौ आयात पढ़े, इबादतगुज़ारों में लिखा जाएगा।"
• "जो हज़ार आयात पढ़े, नेकियों के ढेर लगाने वालों में लिखा जाएगा।" (अबू दाऊद)

बेहतरीन लोग:
• नबी करीम ﷺ ने फ़रमाया: "तुम में से बेहतरीन वो हैं जो क़ुरआन सीखें और दूसरों को सिखाएं।" (बुख़ारी)
• क़ुरआन सिखाना सदक़ा जारिया है - मौत के बाद भी जारी सवाब

मख़सूस सूरतों की फ़ज़ीलत:
• सूरा अल-फ़ातिहा: क़ुरआन की सबसे अज़ीम सूरत
• हर नमाज़ के बाद आयतुल कुर्सी: मौत के सिवा जन्नत में दाख़िले में कुछ नहीं रोकता
• सूरा अल-इख़्लास: क़ुरआन के एक तिहाई के बराबर
• सोने से पहले सूरा अल-मुल्क: क़ब्र के अज़ाब से हिफ़ाज़त
• सूरा अल-बक़रा की आख़िरी दो आयात रात को: काफ़ी हिफ़ाज़त

सुनने का सवाब:
• "जो अल्लाह की किताब से एक आयत सुने उसे कई गुना सवाब मिलेगा, और जो पढ़े, क़यामत के दिन उसके लिए रोशनी होगी।" (अहमद)

क़ुरआन मुकम्मल करना:
• फ़रिश्ते ख़त्म क़ुरआन करने वाले के लिए दुआ करते हैं
• नबी करीम ﷺ ने फ़रमाया: "क़ुरआन पढ़ो, क्योंकि यह क़यामत के दिन अपने पढ़ने वालों की सिफ़ारिश करेगा।" (मुस्लिम)''',
        'arabic': '''ثواب تلاوة القرآن

القرآن كلام الله، وتلاوته فيها أجر عظيم.

عشر حسنات بكل حرف:
• قال النبي ﷺ: "من قرأ حرفاً من كتاب الله فله حسنة، والحسنة بعشر أمثالها."
• "لا أقول ألم حرف، ولكن ألف حرف، ولام حرف، وميم حرف." (الترمذي)
• أي أن قراءة "بسم الله" وحدها تعطي 190 حسنة!

مضاعفة الأجر للمتعسر:
• "الماهر بالقرآن مع السفرة الكرام البررة."
• "والذي يقرأ القرآن ويتتعتع فيه وهو عليه شاق له أجران." (البخاري ومسلم)
• لا تيأس إن كانت القراءة صعبة - لك أجر مضاعف!

ثواب القراءة ليلاً:
• "من قرأ بعشر آيات في قيام الليل لم يكتب من الغافلين."
• "ومن قرأ بمائة آية كتب من القانتين."
• "ومن قرأ بألف آية كتب من المقنطرين." (أبو داود)

خير الناس:
• قال النبي ﷺ: "خيركم من تعلم القرآن وعلمه." (البخاري)
• تعليم القرآن صدقة جارية - أجر مستمر بعد الموت

فضائل السور:
• سورة الفاتحة: أعظم سورة في القرآن
• آية الكرسي بعد كل صلاة: لم يمنعه من دخول الجنة إلا الموت
• سورة الإخلاص: تعدل ثلث القرآن
• سورة الملك قبل النوم: تحمي من عذاب القبر
• آخر آيتين من البقرة ليلاً: تكفيان

ثواب الاستماع:
• "من استمع إلى آية من كتاب الله كتب له حسنة مضاعفة، ومن تلاها كانت له نوراً يوم القيامة." (أحمد)

ختم القرآن:
• الملائكة تدعو لمن يختم القرآن
• قال النبي ﷺ: "اقرؤوا القرآن فإنه يأتي يوم القيامة شفيعاً لأصحابه." (مسلم)'''
      },
    },
    {
      'number': 8,
      'titleKey': 'savab_fazilat_8_prayer_rewards',
      'title': 'Savab of Prayer (Namaz)',
      'titleUrdu': 'نماز کا ثواب',
      'titleHindi': 'नमाज़ का सवाब',
      'titleArabic': 'ثواب الصلاة',
      'icon': Icons.mosque,
      'color': Colors.brown,
      'details': {
        'english': '''Savab of Prayer (Namaz)

Prayer is the greatest act of worship and the most beloved deed to Allah.

Five Daily Prayers:
• "The five daily prayers and Jumu'ah to Jumu'ah is an expiation of sins committed between them, as long as one avoids major sins." (Muslim)
• Prayer was given as 5 in place of 50 - each prayer has tenfold reward
• It is the first thing a person will be questioned about on Day of Judgment

Congregation Prayer (Jama'at):
• "Prayer in congregation is twenty-seven times better than prayer alone." (Bukhari & Muslim)
• Walking to the mosque - every step removes a sin and raises a rank
• Waiting in the mosque for prayer - like being in prayer
• Angels make dua for those sitting in the mosque

Tahajjud (Night Prayer):
• "The best prayer after the obligatory prayers is prayer in the depths of night." (Muslim)
• Allah descends to the lowest heaven in the last third of night and says: "Who will call upon Me that I may answer? Who will ask of Me that I may give?"
• Sign of the righteous - they sleep little and seek forgiveness at dawn

Fajr Prayer:
• "Whoever prays Fajr in congregation, then sits remembering Allah until sunrise, then prays two rak'ah, receives reward of complete Hajj and Umrah." (Tirmidhi)
• "Whoever prays Fajr is under Allah's protection."
• Two rak'ah before Fajr are better than the world and everything in it

12 Rak'ah Sunnah Daily:
• "Whoever prays 12 rak'ah during the day and night, a house will be built for him in Paradise."
• 2 before Fajr, 4 before Zuhr, 2 after Zuhr, 2 after Maghrib, 2 after Isha

Friday Prayer (Jumu'ah):
• Master of all days - reward of Hajj for complete observance
• Going early to Jumu'ah: first hour like sacrificing a camel, second hour a cow, third a ram...
• Hour of accepted dua on Friday

Other Nafl Prayers:
• Ishraaq after sunrise - reward of Hajj and Umrah
• Duha (Chaasht) - fulfills charity for every joint
• Awwabin after Maghrib (6 rak'ah) - reward of 12 years worship
• Tahiyyat al-Masjid when entering mosque
• Tahiyyat al-Wudu after ablution''',
        'urdu': '''نماز کا ثواب

نماز سب سے بڑی عبادت اور اللہ کو سب سے محبوب عمل ہے۔

پانچ وقت کی نمازیں:
• "پانچ وقت کی نمازیں اور جمعہ سے جمعہ تک درمیان کے گناہوں کا کفارہ ہیں، جب تک کبیرہ گناہوں سے بچا جائے۔" (مسلم)
• نماز 50 کی جگہ 5 دی گئی - ہر نماز کا دس گنا ثواب
• قیامت کے دن سب سے پہلے نماز کا حساب ہوگا

جماعت کی نماز:
• "جماعت کی نماز اکیلے نماز سے ستائیس گنا افضل ہے۔" (بخاری و مسلم)
• مسجد کی طرف چلنا - ہر قدم گناہ مٹاتا اور درجہ بلند کرتا ہے
• مسجد میں نماز کا انتظار - نماز میں ہونے کے برابر
• فرشتے مسجد میں بیٹھنے والوں کے لیے دعا کرتے ہیں

تہجد (رات کی نماز):
• "فرض نمازوں کے بعد سب سے افضل نماز رات کے اندھیرے میں ہے۔" (مسلم)
• اللہ رات کے آخری تہائی میں آسمان دنیا پر اترتا ہے اور فرماتا ہے: "کون مجھے پکارے گا کہ میں جواب دوں؟ کون مجھ سے مانگے گا کہ میں دوں؟"
• صالحین کی نشانی - کم سوتے ہیں اور فجر سے پہلے معافی مانگتے ہیں

فجر کی نماز:
• "جو فجر جماعت سے پڑھے، پھر طلوع آفتاب تک اللہ کا ذکر کرتا رہے، پھر دو رکعت پڑھے، اسے مکمل حج و عمرہ کا ثواب ملتا ہے۔" (ترمذی)
• "جو فجر پڑھے وہ اللہ کی پناہ میں ہے۔"
• فجر سے پہلے دو رکعت دنیا اور جو کچھ اس میں ہے سب سے بہتر ہیں

روزانہ 12 رکعت سنت:
• "جو دن رات میں 12 رکعت پڑھے، اس کے لیے جنت میں گھر بنایا جائے گا۔"
• فجر سے پہلے 2، ظہر سے پہلے 4، ظہر کے بعد 2، مغرب کے بعد 2، عشاء کے بعد 2

جمعہ کی نماز:
• تمام دنوں کا سردار - مکمل ادائیگی پر حج کا ثواب
• جمعہ میں جلدی آنا: پہلے گھنٹے اونٹ کی قربانی، دوسرے گھنٹے گائے، تیسرے مینڈھا...
• جمعہ کو قبولیت دعا کی گھڑی

دیگر نفل نمازیں:
• طلوع آفتاب کے بعد اشراق - حج و عمرہ کا ثواب
• چاشت (ضحی) - ہر جوڑ کا صدقہ ادا کرتی ہے
• مغرب کے بعد اوابین (6 رکعت) - 12 سال عبادت کا ثواب
• مسجد میں داخل ہونے پر تحیۃ المسجد
• وضو کے بعد تحیۃ الوضو''',
        'hindi': '''नमाज़ का सवाब

नमाज़ सबसे बड़ी इबादत और अल्लाह को सबसे महबूब अमल है।

पांच वक़्त की नमाज़ें:
• "पांच वक़्त की नमाज़ें और जुमा से जुमा तक दरमियान के गुनाहों का कफ़्फ़ारा हैं, जब तक कबीरा गुनाहों से बचा जाए।" (मुस्लिम)
• नमाज़ 50 की जगह 5 दी गई - हर नमाज़ का दस गुना सवाब
• क़यामत के दिन सबसे पहले नमाज़ का हिसाब होगा

जमाअत की नमाज़:
• "जमाअत की नमाज़ अकेले नमाज़ से सत्ताईस गुना अफ़ज़ल है।" (बुख़ारी व मुस्लिम)
• मस्जिद की तरफ़ चलना - हर क़दम गुनाह मिटाता और दर्जा बुलंद करता है
• मस्जिद में नमाज़ का इंतिज़ार - नमाज़ में होने के बराबर
• फ़रिश्ते मस्जिद में बैठने वालों के लिए दुआ करते हैं

तहज्जुद (रात की नमाज़):
• "फ़र्ज़ नमाज़ों के बाद सबसे अफ़ज़ल नमाज़ रात के अंधेरे में है।" (मुस्लिम)
• अल्लाह रात के आख़िरी तिहाई में आसमान दुनिया पर उतरता है और फ़रमाता है: "कौन मुझे पुकारेगा कि मैं जवाब दूं? कौन मुझसे मांगेगा कि मैं दूं?"
• सालिहीन की निशानी - कम सोते हैं और फ़ज्र से पहले माफ़ी मांगते हैं

फ़ज्र की नमाज़:
• "जो फ़ज्र जमाअत से पढ़े, फिर तुलूए आफ़्ताब तक अल्लाह का ज़िक्र करता रहे, फिर दो रकअत पढ़े, उसे मुकम्मल हज व उमरा का सवाब मिलता है।" (तिर्मिज़ी)
• "जो फ़ज्र पढ़े वो अल्लाह की पनाह में है।"
• फ़ज्र से पहले दो रकअत दुनिया और जो कुछ उसमें है सबसे बेहतर हैं

रोज़ाना 12 रकअत सुन्नत:
• "जो दिन रात में 12 रकअत पढ़े, उसके लिए जन्नत में घर बनाया जाएगा।"
• फ़ज्र से पहले 2, ज़ुहर से पहले 4, ज़ुहर के बाद 2, मग़रिब के बाद 2, इशा के बाद 2

जुमा की नमाज़:
• तमाम दिनों का सरदार - मुकम्मल अदायगी पर हज का सवाब
• जुमा में जल्दी आना: पहले घंटे ऊंट की क़ुर्बानी, दूसरे घंटे गाय, तीसरे मेंढ़ा...
• जुमा को क़बूलियत दुआ की घड़ी

दीगर नफ़्ल नमाज़ें:
• तुलूए आफ़्ताब के बाद इशराक़ - हज व उमरा का सवाब
• चाश्त (ज़ुहा) - हर जोड़ का सदक़ा अदा करती है
• मग़रिब के बाद अव्वाबीन (6 रकअत) - 12 साल इबादत का सवाब
• मस्जिद में दाख़िल होने पर तहिय्यतुल मस्जिद
• वुज़ू के बाद तहिय्यतुल वुज़ू''',
        'arabic': '''ثواب الصلاة

الصلاة أعظم العبادات وأحب الأعمال إلى الله.

الصلوات الخمس:
• "الصلوات الخمس والجمعة إلى الجمعة كفارة لما بينهن ما اجتنبت الكبائر." (مسلم)
• الصلاة فُرضت خمسين ثم خُففت إلى خمس - كل صلاة بعشر أمثالها
• أول ما يحاسب عليه العبد يوم القيامة

صلاة الجماعة:
• "صلاة الجماعة أفضل من صلاة الفذ بسبع وعشرين درجة." (البخاري ومسلم)
• المشي إلى المسجد - كل خطوة تحط خطيئة وترفع درجة
• انتظار الصلاة في المسجد - كالصلاة
• الملائكة تدعو للجالس في المسجد

صلاة التهجد:
• "أفضل الصلاة بعد المكتوبة صلاة الليل." (مسلم)
• ينزل الله في الثلث الأخير ويقول: "من يدعوني فأستجيب له؟ من يسألني فأعطيه؟"
• علامة الصالحين - قليلو النوم يستغفرون بالأسحار

صلاة الفجر:
• "من صلى الفجر في جماعة ثم قعد يذكر الله حتى تطلع الشمس ثم صلى ركعتين كان له أجر حجة وعمرة تامة." (الترمذي)
• "من صلى الفجر فهو في ذمة الله."
• ركعتا الفجر خير من الدنيا وما فيها

12 ركعة سنة يومياً:
• "من صلى اثنتي عشرة ركعة في يوم وليلة بُني له بيت في الجنة."
• ركعتان قبل الفجر، وأربع قبل الظهر وركعتان بعدها، وركعتان بعد المغرب، وركعتان بعد العشاء

صلاة الجمعة:
• سيد الأيام - أجر حجة للمحافظة عليها
• التبكير للجمعة: الساعة الأولى كأنه قرب بدنة، والثانية بقرة، والثالثة كبش...
• ساعة الإجابة يوم الجمعة

صلوات نافلة أخرى:
• الإشراق بعد طلوع الشمس - أجر حجة وعمرة
• صلاة الضحى - تجزئ عن صدقة كل سلامى
• الأوابين بعد المغرب (6 ركعات) - ثواب 12 سنة عبادة
• تحية المسجد عند الدخول
• تحية الوضوء بعد الوضوء'''
      },
    },
    {
      'number': 9,
      'titleKey': 'savab_fazilat_9_charity_rewards',
      'title': 'Savab of Charity (Sadaqah)',
      'titleUrdu': 'صدقہ کا ثواب',
      'titleHindi': 'सदक़े का सवाब',
      'titleArabic': 'ثواب الصدقة',
      'icon': Icons.favorite,
      'color': Colors.red,
      'details': {
        'english': '''Savab of Charity (Sadaqah & Zakat)

Charity is one of the most rewarding deeds in Islam.

Multiplied Rewards:
• "The example of those who spend in the way of Allah is like a seed that sprouts seven ears; in each ear is a hundred grains. Allah multiplies for whom He wills." (Quran 2:261)
• One dirham of charity can become 700 or more in reward
• "Those who give charity, men and women, and lend to Allah a goodly loan—it will be multiplied for them." (Quran 57:18)

Allah's Promise:
• The Prophet ﷺ said: "Allah says: 'Spend, O son of Adam, and I shall spend on you.'" (Bukhari & Muslim)
• Charity does not decrease wealth - it increases it
• Protection from calamities and hardship

Charity Extinguishes Sins:
• The Prophet ﷺ said: "Charity extinguishes sins just as water extinguishes fire." (Tirmidhi)
• Even small charity removes sins
• Regular charity purifies the heart and wealth

Shade on Day of Judgment:
• "Seven will be shaded by Allah on the Day when there is no shade except His shade... a man who gives charity so secretly that his left hand does not know what his right hand has given." (Bukhari)
• Secret charity is 70 times more rewarding than public charity

Best Forms of Charity:
• "The best charity is giving water to drink." (Ahmad)
• Feeding the hungry - especially during fasting
• Helping the orphan and widow
• Building wells, mosques, or hospitals (Sadaqah Jariyah)

Continuous Reward (Sadaqah Jariyah):
• "When a person dies, his deeds end except for three: ongoing charity, beneficial knowledge, or a righteous child who prays for him." (Muslim)
• Examples: building a well, planting trees, teaching Quran

Special Times for Charity:
• Ramadan - rewards multiplied by thousands
• Fridays - blessed day for giving
• Days of hardship for others
• When you have abundance

Feeding a Fasting Person:
• "Whoever gives iftar to a fasting person will have a reward like his, without reducing the fasting person's reward at all." (Tirmidhi)

A Smile is Charity:
• "Your smile to your brother is charity."
• "Removing harm from the road is charity."
• "A good word is charity."
• Even intention to give charity when unable earns reward''',
        'urdu': '''صدقہ کا ثواب

صدقہ اسلام میں سب سے زیادہ ثواب والے اعمال میں سے ہے۔

کئی گنا ثواب:
• "جو لوگ اللہ کی راہ میں خرچ کرتے ہیں ان کی مثال اس دانے جیسی ہے جس سے سات بالیں نکلیں؛ ہر بالی میں سو دانے۔ اللہ جسے چاہے کئی گنا بڑھا دیتا ہے۔" (قرآن 2:261)
• صدقے کا ایک درہم 700 یا اس سے زیادہ ثواب بن سکتا ہے
• "جو مرد و عورت صدقہ دیتے ہیں اور اللہ کو اچھا قرض دیتے ہیں، ان کے لیے کئی گنا بڑھایا جائے گا۔" (قرآن 57:18)

اللہ کا وعدہ:
• نبی کریم ﷺ نے فرمایا: "اللہ فرماتا ہے: 'خرچ کرو اے ابن آدم، میں تم پر خرچ کروں گا۔'" (بخاری و مسلم)
• صدقہ مال نہیں گھٹاتا - بلکہ بڑھاتا ہے
• مصیبتوں اور تکلیف سے حفاظت

صدقہ گناہ مٹاتا ہے:
• نبی کریم ﷺ نے فرمایا: "صدقہ گناہوں کو ایسے بجھاتا ہے جیسے پانی آگ کو بجھاتا ہے۔" (ترمذی)
• چھوٹا صدقہ بھی گناہ مٹاتا ہے
• باقاعدہ صدقہ دل اور مال کو پاک کرتا ہے

قیامت کے دن سایہ:
• "سات لوگوں کو اللہ اس دن سایہ دے گا جب اس کے سائے کے سوا کوئی سایہ نہ ہوگا... وہ شخص جو اتنی خفیہ صدقہ دے کہ بائیں ہاتھ کو پتا نہ چلے دائیں ہاتھ نے کیا دیا۔" (بخاری)
• خفیہ صدقہ علانیہ سے 70 گنا زیادہ ثواب رکھتا ہے

صدقے کی بہترین شکلیں:
• "سب سے بہترین صدقہ پانی پلانا ہے۔" (احمد)
• بھوکوں کو کھانا کھلانا - خاص کر روزے میں
• یتیم اور بیوہ کی مدد
• کنواں، مسجد، یا ہسپتال بنانا (صدقہ جاریہ)

جاری ثواب (صدقہ جاریہ):
• "جب آدمی مر جاتا ہے تو اس کے اعمال ختم ہو جاتے ہیں سوائے تین کے: جاری صدقہ، نفع بخش علم، یا نیک اولاد جو اس کے لیے دعا کرے۔" (مسلم)
• مثالیں: کنواں بنانا، درخت لگانا، قرآن سکھانا

صدقے کے خاص اوقات:
• رمضان - ہزاروں گنا ثواب
• جمعہ - صدقے کا بابرکت دن
• دوسروں کی تکلیف کے دن
• جب آپ کے پاس فراوانی ہو

روزہ دار کو افطار:
• "جو روزہ دار کو افطار کرائے اسے اس جیسا ثواب ملے گا، روزہ دار کے ثواب میں کوئی کمی نہیں ہوگی۔" (ترمذی)

مسکراہٹ صدقہ ہے:
• "اپنے بھائی کو دیکھ کر مسکرانا صدقہ ہے۔"
• "راستے سے تکلیف دہ چیز ہٹانا صدقہ ہے۔"
• "اچھی بات صدقہ ہے۔"
• صدقہ نہ دے سکنے کی صورت میں نیت کرنا بھی ثواب لاتا ہے''',
        'hindi': '''सदक़े का सवाब

सदक़ा इस्लाम में सबसे ज़्यादा सवाब वाले आमाल में से है।

कई गुना सवाब:
• "जो लोग अल्लाह की राह में ख़र्च करते हैं उनकी मिसाल उस दाने जैसी है जिससे सात बालियां निकलीं; हर बाली में सौ दाने। अल्लाह जिसे चाहे कई गुना बढ़ा देता है।" (क़ुरआन 2:261)
• सदक़े का एक दिरहम 700 या उससे ज़्यादा सवाब बन सकता है
• "जो मर्द व औरत सदक़ा देते हैं और अल्लाह को अच्छा क़र्ज़ देते हैं, उनके लिए कई गुना बढ़ाया जाएगा।" (क़ुरआन 57:18)

अल्लाह का वादा:
• नबी करीम ﷺ ने फ़रमाया: "अल्लाह फ़रमाता है: 'ख़र्च करो ऐ इब्ने आदम, मैं तुम पर ख़र्च करूंगा।'" (बुख़ारी व मुस्लिम)
• सदक़ा माल नहीं घटाता - बल्कि बढ़ाता है
• मुसीबतों और तकलीफ़ से हिफ़ाज़त

सदक़ा गुनाह मिटाता है:
• नबी करीम ﷺ ने फ़रमाया: "सदक़ा गुनाहों को ऐसे बुझाता है जैसे पानी आग को बुझाता है।" (तिर्मिज़ी)
• छोटा सदक़ा भी गुनाह मिटाता है
• बाक़ायदा सदक़ा दिल और माल को पाक करता है

क़यामत के दिन साया:
• "सात लोगों को अल्लाह उस दिन साया देगा जब उसके साये के सिवा कोई साया न होगा... वो शख़्स जो इतना ख़ुफ़िया सदक़ा दे कि बाएं हाथ को पता न चले दाएं हाथ ने क्या दिया।" (बुख़ारी)
• ख़ुफ़िया सदक़ा अलानिया से 70 गुना ज़्यादा सवाब रखता है

सदक़े की बेहतरीन शक्लें:
• "सबसे बेहतरीन सदक़ा पानी पिलाना है।" (अहमद)
• भूखों को खाना खिलाना - ख़ास कर रोज़े में
• यतीम और बेवा की मदद
• कुआं, मस्जिद, या हस्पताल बनाना (सदक़ा जारिया)

जारी सवाब (सदक़ा जारिया):
• "जब आदमी मर जाता है तो उसके आमाल ख़त्म हो जाते हैं सिवाए तीन के: जारी सदक़ा, नफ़ाबख़्श इल्म, या नेक औलाद जो उसके लिए दुआ करे।" (मुस्लिम)
• मिसालें: कुआं बनाना, दरख़्त लगाना, क़ुरआन सिखाना

सदक़े के ख़ास औक़ात:
• रमज़ान - हज़ारों गुना सवाब
• जुमा - सदक़े का बाबरकत दिन
• दूसरों की तकलीफ़ के दिन
• जब आपके पास फ़रावानी हो

रोज़ादार को इफ़्तार:
• "जो रोज़ादार को इफ़्तार कराए उसे उस जैसा सवाब मिलेगा, रोज़ादार के सवाब में कोई कमी नहीं होगी।" (तिर्मिज़ी)

मुस्कुराहट सदक़ा है:
• "अपने भाई को देखकर मुस्कुराना सदक़ा है।"
• "रास्ते से तकलीफ़देह चीज़ हटाना सदक़ा है।"
• "अच्छी बात सदक़ा है।"
• सदक़ा न दे सकने की सूरत में नीयत करना भी सवाब लाता है''',
        'arabic': '''ثواب الصدقة

الصدقة من أعظم الأعمال ثواباً في الإسلام.

مضاعفة الأجر:
• "مَّثَلُ الَّذِينَ يُنفِقُونَ أَمْوَالَهُمْ فِي سَبِيلِ اللَّهِ كَمَثَلِ حَبَّةٍ أَنبَتَتْ سَبْعَ سَنَابِلَ فِي كُلِّ سُنبُلَةٍ مِّائَةُ حَبَّةٍ وَاللَّهُ يُضَاعِفُ لِمَن يَشَاءُ" (البقرة: 261)
• الدرهم الواحد يصبح 700 أو أكثر في الأجر
• "إِنَّ الْمُصَّدِّقِينَ وَالْمُصَّدِّقَاتِ وَأَقْرَضُوا اللَّهَ قَرْضًا حَسَنًا يُضَاعَفُ لَهُمْ" (الحديد: 18)

وعد الله:
• قال النبي ﷺ: "قال الله: أنفق يا ابن آدم أُنفق عليك." (البخاري ومسلم)
• الصدقة لا تنقص المال بل تزيده
• حماية من المصائب والشدائد

الصدقة تطفئ الخطايا:
• قال النبي ﷺ: "الصدقة تطفئ الخطيئة كما يطفئ الماء النار." (الترمذي)
• حتى الصدقة القليلة تمحو الذنوب
• الصدقة المنتظمة تطهر القلب والمال

الظل يوم القيامة:
• "سبعة يظلهم الله في ظله يوم لا ظل إلا ظله... ورجل تصدق بصدقة فأخفاها حتى لا تعلم شماله ما تنفق يمينه." (البخاري)
• صدقة السر أفضل من العلانية بسبعين ضعفاً

أفضل أنواع الصدقة:
• "أفضل الصدقة سقي الماء." (أحمد)
• إطعام الجائع - خاصة في الصيام
• كفالة اليتيم والأرملة
• بناء الآبار والمساجد والمستشفيات (صدقة جارية)

الأجر المستمر (الصدقة الجارية):
• "إذا مات الإنسان انقطع عمله إلا من ثلاثة: صدقة جارية، أو علم ينتفع به، أو ولد صالح يدعو له." (مسلم)
• مثل: حفر بئر، غرس شجر، تعليم قرآن

أوقات خاصة للصدقة:
• رمضان - الأجر مضاعف بآلاف المرات
• الجمعة - يوم مبارك للعطاء
• أيام الشدة على الآخرين
• عند الغنى والسعة

تفطير الصائم:
• "من فطّر صائماً كان له مثل أجره غير أنه لا ينقص من أجر الصائم شيء." (الترمذي)

التبسم صدقة:
• "تبسمك في وجه أخيك صدقة."
• "إماطة الأذى عن الطريق صدقة."
• "الكلمة الطيبة صدقة."
• حتى نية الصدقة عند العجز لها أجر'''
      },
    },
    {
      'number': 10,
      'titleKey': 'savab_fazilat_10_hajj_umrah_rewards',
      'title': 'Savab of Hajj & Umrah',
      'titleUrdu': 'حج و عمرہ کا ثواب',
      'titleHindi': 'हज व उमरा का सवाब',
      'titleArabic': 'ثواب الحج والعمرة',
      'icon': Icons.location_city,
      'color': Colors.deepPurple,
      'details': {
        'english': '''Savab of Hajj & Umrah

Hajj and Umrah are among the greatest acts of worship with immense rewards.

Hajj - The Fifth Pillar:
• "Whoever performs Hajj for Allah's sake and does not commit any obscenity or wickedness, he returns (free from sins) as on the day his mother gave birth to him." (Bukhari & Muslim)
• Complete forgiveness of all previous sins
• Obligatory once in a lifetime for those who can afford it

The Reward of Accepted Hajj:
• "The reward for an accepted Hajj is nothing but Paradise." (Bukhari & Muslim)
• Hajj Mabroor (accepted Hajj) has no reward except Jannah
• Signs of acceptance: returning a better person, avoiding sins

Day of Arafah:
• "There is no day on which Allah frees more people from Hellfire than the Day of Arafah." (Muslim)
• Allah boasts to the angels about the pilgrims
• Dua on Arafah is readily accepted
• Fasting on Arafah (for non-pilgrims) expiates sins of two years

Tawaf Around the Kaaba:
• Every step in Tawaf removes a sin and records a good deed
• Like praying - be in state of purity
• Seven circuits around the Kaaba carry immense reward
• Touching or kissing the Black Stone forgives sins

Sa'i Between Safa and Marwa:
• Walking between these mountains is worship
• Commemorating Hajar's (AS) search for water
• Every step is rewarded

Rewards of Umrah:
• "Umrah is an expiation for the sins committed between it and the previous Umrah." (Bukhari & Muslim)
• Umrah in Ramadan equals the reward of Hajj
• Can be performed any time of year
• Recommended to perform repeatedly

Zamzam Water:
• "The water of Zamzam is for whatever it is drunk for." (Ibn Majah)
• Blessed water from the well of Ismail (AS)
• Drinking with intention for healing, knowledge, or needs

Prayer in Masjid al-Haram:
• One prayer in Masjid al-Haram equals 100,000 prayers elsewhere
• Staying in the Haram area multiplies all good deeds

Visiting Madinah:
• Prayer in Masjid al-Nabawi equals 1,000 prayers elsewhere
• Visiting the Prophet's ﷺ grave - blessed journey
• Praying in Rawdah - a garden from the gardens of Paradise
• "Whoever visits my grave, my intercession becomes due for him." (Daraqutni)''',
        'urdu': '''حج و عمرہ کا ثواب

حج و عمرہ سب سے بڑی عبادات میں سے ہیں جن کا بے حد ثواب ہے۔

حج - پانچواں رکن:
• "جو اللہ کی رضا کے لیے حج کرے اور کوئی فحش یا برا کام نہ کرے، وہ ایسے لوٹتا ہے جیسے اس کی ماں نے اسے جنم دیا تھا۔" (بخاری و مسلم)
• تمام پچھلے گناہوں کی مکمل معافی
• زندگی میں ایک بار فرض ہے جو استطاعت رکھتے ہوں

حج مقبول کا ثواب:
• "حج مقبول کا ثواب جنت کے سوا کچھ نہیں۔" (بخاری و مسلم)
• حج مبرور کا بدلہ صرف جنت ہے
• قبولیت کی علامات: بہتر انسان بن کر لوٹنا، گناہوں سے بچنا

عرفہ کا دن:
• "کوئی دن ایسا نہیں جس میں اللہ عرفہ کے دن سے زیادہ لوگوں کو جہنم سے آزاد کرے۔" (مسلم)
• اللہ فرشتوں کے سامنے حاجیوں پر فخر کرتا ہے
• عرفہ کی دعا فوری قبول ہوتی ہے
• عرفہ کا روزہ (غیر حاجیوں کے لیے) دو سال کے گناہ مٹاتا ہے

کعبہ کا طواف:
• طواف کا ہر قدم گناہ مٹاتا اور نیکی لکھتا ہے
• نماز کی طرح - با وضو ہونا ضروری ہے
• کعبہ کے سات چکروں کا بے حد ثواب ہے
• حجر اسود کو چھونا یا چومنا گناہ معاف کرتا ہے

صفا و مروہ کی سعی:
• ان پہاڑوں کے درمیان چلنا عبادت ہے
• حضرت ہاجرہ علیہا السلام کی پانی کی تلاش کی یاد
• ہر قدم کا ثواب ہے

عمرہ کا ثواب:
• "عمرہ پچھلے عمرہ سے لے کر درمیان کے گناہوں کا کفارہ ہے۔" (بخاری و مسلم)
• رمضان میں عمرہ حج کے ثواب کے برابر ہے
• سال کے کسی بھی وقت کیا جا سکتا ہے
• بار بار کرنا مستحب ہے

زمزم کا پانی:
• "زمزم کا پانی جس نیت سے پیا جائے اسی کے لیے ہے۔" (ابن ماجہ)
• حضرت اسماعیل علیہ السلام کے کنویں کا بابرکت پانی
• شفا، علم، یا ضرورت کی نیت سے پینا

مسجد الحرام میں نماز:
• مسجد الحرام میں ایک نماز دوسری جگہ ایک لاکھ نمازوں کے برابر ہے
• حرم میں رہنا تمام نیکیوں کو کئی گنا کر دیتا ہے

مدینہ کی زیارت:
• مسجد نبوی میں نماز دوسری جگہ ہزار نمازوں کے برابر ہے
• نبی کریم ﷺ کی قبر مبارک کی زیارت - بابرکت سفر
• روضہ میں نماز - جنت کے باغوں میں سے ایک باغ
• "جو میری قبر کی زیارت کرے، اس کے لیے میری شفاعت واجب ہو جاتی ہے۔" (دارقطنی)''',
        'hindi': '''हज व उमरा का सवाब

हज व उमरा सबसे बड़ी इबादात में से हैं जिनका बेहद सवाब है।

हज - पांचवां रुक्न:
• "जो अल्लाह की रज़ा के लिए हज करे और कोई फ़हश या बुरा काम न करे, वो ऐसे लौटता है जैसे उसकी मां ने उसे जन्म दिया था।" (बुख़ारी व मुस्लिम)
• तमाम पिछले गुनाहों की मुकम्मल माफ़ी
• ज़िंदगी में एक बार फ़र्ज़ है जो इस्तिताअत रखते हों

हज मक़बूल का सवाब:
• "हज मक़बूल का सवाब जन्नत के सिवा कुछ नहीं।" (बुख़ारी व मुस्लिम)
• हज मबरूर का बदला सिर्फ़ जन्नत है
• क़बूलियत की अलामात: बेहतर इंसान बनकर लौटना, गुनाहों से बचना

अरफ़ा का दिन:
• "कोई दिन ऐसा नहीं जिसमें अल्लाह अरफ़ा के दिन से ज़्यादा लोगों को जहन्नम से आज़ाद करे।" (मुस्लिम)
• अल्लाह फ़रिश्तों के सामने हाजियों पर फ़ख़्र करता है
• अरफ़ा की दुआ फ़ौरन क़बूल होती है
• अरफ़ा का रोज़ा (ग़ैर हाजियों के लिए) दो साल के गुनाह मिटाता है

काबा का तवाफ़:
• तवाफ़ का हर क़दम गुनाह मिटाता और नेकी लिखता है
• नमाज़ की तरह - बा वुज़ू होना ज़रूरी है
• काबा के सात चक्करों का बेहद सवाब है
• हजर असवद को छूना या चूमना गुनाह माफ़ करता है

सफ़ा व मरवा की सई:
• इन पहाड़ों के दरमियान चलना इबादत है
• हज़रत हाजरा अलैहस्सलाम की पानी की तलाश की याद
• हर क़दम का सवाब है

उमरा का सवाब:
• "उमरा पिछले उमरा से लेकर दरमियान के गुनाहों का कफ़्फ़ारा है।" (बुख़ारी व मुस्लिम)
• रमज़ान में उमरा हज के सवाब के बराबर है
• साल के किसी भी वक़्त किया जा सकता है
• बार बार करना मुस्तहब है

ज़मज़म का पानी:
• "ज़मज़म का पानी जिस नीयत से पिया जाए उसी के लिए है।" (इब्न माजा)
• हज़रत इस्माईल अलैहिस्सलाम के कुएं का बाबरकत पानी
• शिफ़ा, इल्म, या ज़रूरत की नीयत से पीना

मस्जिद अल-हराम में नमाज़:
• मस्जिद अल-हराम में एक नमाज़ दूसरी जगह एक लाख नमाज़ों के बराबर है
• हरम में रहना तमाम नेकियों को कई गुना कर देता है

मदीना की ज़ियारत:
• मस्जिद नबवी में नमाज़ दूसरी जगह हज़ार नमाज़ों के बराबर है
• नबी करीम ﷺ की क़ब्र मुबारक की ज़ियारत - बाबरकत सफ़र
• रौज़ा में नम��ज़ - जन्नत के बाग़ों में से एक बाग़
• "जो मेरी क़ब्र की ज़ियारत करे, उसके लिए मेरी शफ़ाअत वाजिब हो जाती है।" (दारक़ुतनी)''',
        'arabic': '''ثواب الحج والعمرة

الحج والعمرة من أعظم العبادات ذات الأجر العظيم.

الحج - الركن الخامس:
• "من حج لله فلم يرفث ولم يفسق رجع كيوم ولدته أمه." (البخاري ومسلم)
• مغفرة كاملة لجميع الذنوب السابقة
• واجب مرة في العمر لمن استطاع

ثواب الحج المبرور:
• "الحج المبرور ليس له جزاء إلا الجنة." (البخاري ومسلم)
• الحج المبرور جزاؤه الجنة فقط
• علامات القبول: العودة إنساناً أفضل، اجتناب الذنوب

يوم عرفة:
• "ما من يوم أكثر من أن يعتق الله فيه عبداً من النار من يوم عرفة." (مسلم)
• الله يباهي بالحجاج أمام الملائكة
• الدعاء في عرفة مستجاب
• صيام عرفة (لغير الحجاج) يكفر سنتين

الطواف حول الكعبة:
• كل خطوة في الطواف تحط خطيئة وتكتب حسنة
• كالصلاة - يجب أن تكون على طهارة
• سبعة أشواط حول الكعبة لها أجر عظيم
• استلام الحجر الأسود أو تقبيله يغفر الذنوب

السعي بين الصفا والمروة:
• المشي بين الجبلين عبادة
• إحياء ذكرى بحث هاجر عليها السلام عن الماء
• كل خطوة لها أجر

ثواب العمرة:
• "العمرة إلى العمرة كفارة لما بينهما." (البخاري ومسلم)
• العمرة في رمضان تعدل حجة
• يمكن أداؤها في أي وقت من السنة
• يستحب تكرارها

ماء زمزم:
• "ماء زمزم لما شرب له." (ابن ماجه)
• ماء مبارك من بئر إسماعيل عليه السلام
• الشرب بنية الشفاء أو العلم أو الحاجة

الصلاة في المسجد الحرام:
• صلاة في المسجد الحرام تعدل مائة ألف صلاة
• المكث في الحرم يضاعف الحسنات

زيارة المدينة:
• الصلاة في المسجد النبوي تعدل ألف صلاة
• زيارة قبر النبي ﷺ - رحلة مباركة
• الصلاة في الروضة - روضة من رياض الجنة
• "من زار قبري وجبت له شفاعتي." (الدارقطني)'''
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
          context.tr('savab'),
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
              itemCount: _savabTopics.length,
              itemBuilder: (context, index) {
                final topic = _savabTopics[index];
                return _buildTopicCard(topic, isDark);
              },
            ),
          ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildTopicCard(Map<String, dynamic> topic, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(topic['titleKey'] ?? 'savab_fazilat');
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
                              context.tr('savab_fazilat'),
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
          categoryKey: 'category_savab_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
