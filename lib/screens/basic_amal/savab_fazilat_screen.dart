import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class SavabFazilatScreen extends StatefulWidget {
  const SavabFazilatScreen({super.key});

  @override
  State<SavabFazilatScreen> createState() => _SavabFazilatScreenState();
}

class _SavabFazilatScreenState extends State<SavabFazilatScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Savab (Reward) - Good Deeds & Returns',
    'urdu': 'ثواب - نیک اعمال اور بدلے',
    'hindi': 'सवाब - नेक आमाल और बदले',
  };

  final List<Map<String, dynamic>> _savabTopics = [
    {
      'number': 1,
      'title': 'Understanding Savab',
      'titleUrdu': 'ثواب کی تفہیم',
      'titleHindi': 'सवाब की तफ़हीम',
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
      },
    },
    {
      'number': 2,
      'title': 'Daily Acts of Savab',
      'titleUrdu': 'روزمرہ ثواب کے کام',
      'titleHindi': 'रोज़मर्रा सवाब के काम',
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
      },
    },
    {
      'number': 3,
      'title': 'Excellence in Worship',
      'titleUrdu': 'عبادت میں احسان',
      'titleHindi': 'इबादत में एहसान',
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
      },
    },
    {
      'number': 4,
      'title': 'Savab in Special Times',
      'titleUrdu': 'خاص اوقات میں ثواب',
      'titleHindi': 'ख़ास औक़ात में सवाब',
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
      },
    },
    {
      'number': 5,
      'title': 'Words That Earn Savab',
      'titleUrdu': 'ثواب لانے والے الفاظ',
      'titleHindi': 'सवाब लाने वाले अल्फ़ाज़',
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
      },
    },
    {
      'number': 6,
      'title': 'Preserving Your Savab',
      'titleUrdu': 'اپنے ثواب کی حفاظت',
      'titleHindi': 'अपने सवाब की हिफ़ाज़त',
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
              itemCount: _savabTopics.length,
              itemBuilder: (context, index) {
                final topic = _savabTopics[index];
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
          category: 'Savab - Fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
