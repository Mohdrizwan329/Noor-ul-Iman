import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class GunhaFazilatScreen extends StatefulWidget {
  const GunhaFazilatScreen({super.key});

  @override
  State<GunhaFazilatScreen> createState() => _GunhaFazilatScreenState();
}

class _GunhaFazilatScreenState extends State<GunhaFazilatScreen> {
  String _selectedLanguage = 'english';

  final List<Map<String, dynamic>> _gunhaTopics = [
    {
      'number': 1,
      'titleKey': 'gunha_fazilat_1_understanding_sins',
      'title': 'Understanding Sins',
      'titleUrdu': 'گناہوں کی سمجھ',
      'titleHindi': 'गुनाहों की समझ',
      'titleArabic': 'فهم الذنوب',
      'icon': Icons.warning,
      'color': Colors.red,
      'details': {
        'english': '''Understanding Sins (Gunha)

Sin is any action, word, or thought that disobeys Allah's commands or exceeds His limits.

What is a Sin:
• Anything prohibited by Allah in the Quran
• Anything forbidden by the Prophet ﷺ in authentic Hadith
• "And whoever transgresses the limits of Allah has certainly wronged himself." (Quran 65:1)
• Sins damage the relationship between servant and Lord

Categories of Sins:
1. Major Sins (Kaba'ir):
   • Shirk (associating partners with Allah) - the only unforgivable sin if one dies upon it
   • Murder of an innocent person
   • Adultery and fornication
   • Consuming alcohol and intoxicants
   • Theft and robbery
   • False testimony and lying
   • Abandoning prayer
   • Disobeying parents
   • Consuming interest (riba)
   • Black magic and sorcery

2. Minor Sins (Sagha'ir):
   • Looking at what is forbidden
   • Lying in general speech
   • Backbiting and gossip
   • Showing off in worship
   • Breaking promises
   • Not fulfilling trusts

Effects of Sins:
• Darkness in the heart
• Distance from Allah
• Hardness of heart
• Weakness in worship
• Depression and anxiety
• Loss of blessings (barakah)
• Bad ending (may Allah protect us)

The Prophet's Warning:
• "Beware of the minor sins, for they will pile up until they destroy a person." (Ahmad)
• Even small sins accumulate
• Persistence in minor sins can lead to major sins''',
        'urdu': '''گناہوں کی سمجھ

گناہ ہر وہ عمل، بات یا خیال ہے جو اللہ کے حکم کی نافرمانی یا اس کی حدود سے تجاوز کرے۔

گناہ کیا ہے:
• قرآن میں اللہ کی طرف سے منع کردہ ہر چیز
• صحیح حدیث میں نبی ﷺ کی طرف سے منع کردہ ہر چیز
• "اور جو اللہ کی حدود سے تجاوز کرے اس نے اپنے آپ پر ظلم کیا۔" (قرآن 65:1)
• گناہ بندے اور رب کے تعلق کو نقصان پہنچاتے ہیں

گناہوں کی اقسام:
1. کبیرہ گناہ:
   • شرک (اللہ کے ساتھ شریک ٹھہرانا) - واحد ناقابل معافی گناہ اگر اسی پر موت آئے
   • بے گناہ کا قتل
   • زنا
   • شراب اور نشہ آور چیزیں
   • چوری اور ڈکیتی
   • جھوٹی گواہی اور جھوٹ
   • نماز چھوڑنا
   • والدین کی نافرمانی
   • سود کھانا
   • کالا جادو اور جادوگری

2. صغیرہ گناہ:
   • حرام چیزوں کی طرف دیکھنا
   • عام بات میں جھوٹ
   • غیبت اور چغلی
   • عبادت میں دکھاوا
   • وعدے توڑنا
   • امانت میں خیانت

گناہوں کے اثرات:
• دل میں تاریکی
• اللہ سے دوری
• دل کی سختی
• عبادت میں کمزوری
• ڈپریشن اور پریشانی
• برکت کا ختم ہونا
• بُرا انجام (اللہ ہماری حفاظت فرمائے)

نبی کریم ﷺ کی تنبیہ:
• "چھوٹے گناہوں سے بچو، کیونکہ وہ جمع ہو کر انسان کو تباہ کر دیتے ہیں۔" (احمد)
• چھوٹے گناہ بھی جمع ہوتے ہیں
• چھوٹے گناہوں پر اصرار بڑے گناہوں کی طرف لے جا سکتا ہے''',
        'hindi': '''गुनाहों की समझ

गुनाह हर वो अमल, बात या ख़याल है जो अल्लाह के हुक्म की नाफ़रमानी या उसकी हुदूद से तजावुज़ करे।

गुनाह क्या है:
• क़ुरआन में अल्लाह की तरफ़ से मना करदा हर चीज़
• सहीह हदीस में नबी ﷺ की तरफ़ से मना करदा हर चीज़
• "और जो अल्लाह की हुदूद से तजावुज़ करे उसने अपने आप पर ज़ुल्म किया।" (क़ुरआन 65:1)
• गुनाह बंदे और रब के ताल्लुक़ को नुक़सान पहुंचाते हैं

गुनाहों की अक़सां:
1. कबीरा गुनाह:
   • शिर्क (अल्लाह के साथ शरीक ठहराना) - वाहिद नाक़ाबिले माफ़ी गुनाह अगर उसी पर मौत आए
   • बेगुनाह का क़त्ल
   • ज़िना
   • शराब और नशा आवर चीज़ें
   • चोरी और डकैती
   • झूठी गवाही और झूठ
   • नमाज़ छोड़ना
   • वालिदैन की नाफ़रमानी
   • सूद खाना
   • काला जादू और जादूगरी

2. सग़ीरा गुनाह:
   • हराम चीज़ों की तरफ़ देखना
   • आम बात में झूठ
   • ग़ीबत और चुग़ली
   • इबादत में दिखावा
   • वादे तोड़ना
   • अमानत में ख़यानत

गुनाहों के असरात:
• दिल में तारीकी
• अल्लाह से दूरी
• दिल की सख़्ती
• इबादत में कमज़ोरी
• डिप्रेशन और परेशानी
• बरकत का ख़त्म होना
• बुरा अंजाम (अल्लाह हमारी हिफ़ाज़त फ़रमाए)

नबी करीम ﷺ की तंबीह:
• "छोटे गुनाहों से बचो, क्योंकि वो जमा होकर इंसान को तबाह कर देते हैं।" (अहमद)
• छोटे गुनाह भी जमा होते हैं
• छोटे गुनाहों पर इसरार बड़े गुनाहों की तरफ़ ले जा सकता है''',
        'arabic': '''فهم الذنوب

الذنوب هي المعاصي والخطايا التي نهى الله عنها.

تعريف الذنب:
• كل ما نهى الله عنه أو أمر باجتنابه
• مخالفة أوامر الله ورسوله ﷺ
• ترك الواجبات أو فعل المحرمات
• "وَمَن يَعْصِ اللَّهَ وَرَسُولَهُ فَقَدْ ضَلَّ ضَلَالًا مُّبِينًا" (سورة الأحزاب: 36)

أنواع الذنوب:
• الكبائر: الذنوب العظيمة التي توعد الله عليها بالنار
• الصغائر: الذنوب الصغيرة التي تكفرها الصلوات والأعمال الصالحة
• ذنوب القلب: كالكبر والحسد والرياء
• ذنوب اللسان: كالكذب والغيبة والنميمة
• ذنوب الجوارح: كالزنا والسرقة والقتل

خطورة الذنوب:
• تبعد العبد عن الله
• تظلم القلب وتقسيه
• تمحق البركة من الرزق والعمر
• تجلب المصائب والبلاء
• قال النبي ﷺ: "إن العبد إذا أخطأ خطيئة نكتت في قلبه نكتة سوداء" (الترمذي)

الفرق بين الكبائر والصغائر:
• الكبيرة: ما فيها حد في الدنيا أو وعيد في الآخرة
• قال النبي ﷺ: "اجتنبوا السبع الموبقات" (البخاري)
• الصغيرة: ما دون ذلك من المعاصي
• الإصرار على الصغائر يجعلها كبائر

أثر الذنوب على المجتمع:
• انتشار الفساد
• زوال الأمن والاستقرار
• ضعف المسلمين وذلهم
• قلة البركة في الأرض
• "ظَهَرَ الْفَسَادُ فِي الْبَرِّ وَالْبَحْرِ بِمَا كَسَبَتْ أَيْدِي النَّاسِ" (سورة الروم: 41)

الحذر من الذنوب:
• استشعار مراقبة الله
• تذكر الموت والحساب
• الخوف من عذاب الله
• الرجاء في رحمة الله
• المسارعة إلى التوبة'''
      },
    },
    {
      'number': 2,
      'titleKey': 'gunha_fazilat_2_major_sins_to_avoid',
      'title': 'Major Sins to Avoid',
      'titleUrdu': 'بچنے کے کبیرہ گناہ',
      'titleHindi': 'बचने के कबीरा गुनाह',
      'titleArabic': 'الكبائر التي يجب اجتنابها',
      'icon': Icons.block,
      'color': Colors.orange,
      'details': {
        'english': '''Major Sins to Avoid (Kaba'ir)

The major sins carry severe punishments and must be completely avoided.

The Seven Deadly Sins:
The Prophet ﷺ said: "Avoid the seven destructive sins":
1. Shirk (associating partners with Allah)
2. Magic and sorcery
3. Killing a soul whom Allah has forbidden except by right
4. Consuming riba (interest/usury)
5. Consuming the property of orphans
6. Fleeing from the battlefield
7. Slandering chaste, believing women (Sahih Bukhari)

Other Major Sins:
• Abandoning obligatory prayers
• Not paying Zakat when due
• Breaking fast in Ramadan without excuse
• Not performing Hajj despite ability
• Disobeying and disrespecting parents
• Cutting family ties
• Adultery and fornication
• Homosexuality
• Theft and stealing
• Drinking alcohol
• Gambling
• Lying and false testimony
• Backbiting and slander
• Arrogance and pride
• Oppression and injustice

Sins of the Tongue:
• The Prophet ﷺ said: "Most of people's sins come from their tongues." (Tabarani)
• Backbiting (speaking ill of someone in their absence)
• Slander and false accusations
• Lying - especially about the Prophet ﷺ
• Cursing and using foul language
• Mocking and ridiculing others

Sins of the Heart:
• Showing off in worship (riya)
• Envy and jealousy
• Hatred for fellow Muslims
• Thinking bad of Allah
• Arrogance and self-amazement

Consequences:
• Punishment in this life
• Punishment in the grave
• Punishment on Day of Judgment
• May lead to Hellfire if not repented from''',
        'urdu': '''بچنے کے کبیرہ گناہ

کبیرہ گناہوں کی سخت سزا ہے اور ان سے مکمل پرہیز ضروری ہے۔

سات مہلک گناہ:
نبی کریم ﷺ نے فرمایا: "سات تباہ کن گناہوں سے بچو":
1. شرک (اللہ کے ساتھ شریک ٹھہرانا)
2. جادو اور جادوگری
3. اللہ کی حرام کردہ جان کو ناحق قتل کرنا
4. سود کھانا
5. یتیم کا مال کھانا
6. میدان جنگ سے بھاگنا
7. پاکدامن مومن عورتوں پر تہمت (صحیح بخاری)

دیگر کبیرہ گناہ:
• فرض نمازیں چھوڑنا
• واجب ہونے پر زکوٰۃ نہ دینا
• بغیر عذر رمضان کا روزہ توڑنا
• طاقت کے باوجود حج نہ کرنا
• والدین کی نافرمانی اور بے ادبی
• رشتے توڑنا
• زنا
• ہم جنس پرستی
• چوری
• شراب پینا
• جوا
• جھوٹ اور جھوٹی گواہی
• غیبت اور بہتان
• تکبر اور غرور
• ظلم اور ناانصافی

زبان کے گناہ:
• نبی کریم ﷺ نے فرمایا: "زیادہ تر لوگوں کے گناہ ان کی زبانوں سے ہوتے ہیں۔" (طبرانی)
• غیبت (کسی کی غیر موجودگی میں برائی کرنا)
• بہتان اور جھوٹے الزام
• جھوٹ - خاص طور پر نبی ﷺ کے بارے میں
• لعنت اور گندی زبان
• دوسروں کا مذاق اڑانا

دل کے گناہ:
• عبادت میں دکھاوا (ریا)
• حسد
• مسلمان بھائیوں سے نفرت
• اللہ کے بارے میں بُرا گمان
• تکبر اور خود پسندی

نتائج:
• اس دنیا میں سزا
• قبر میں سزا
• قیامت کے دن سزا
• توبہ نہ کرنے پر جہنم کا باعث بن سکتے ہیں''',
        'hindi': '''बचने के कबीरा गुनाह

कबीरा गुनाहों की सख़्त सज़ा है और उनसे मुकम्मल परहेज़ ज़रूरी है।

सात मोहलिक गुनाह:
नबी करीम ﷺ ने फ़रमाया: "सात तबाहकुन गुनाहों से बचो":
1. शिर्क (अल्लाह के साथ शरीक ठहराना)
2. जादू और जादूगरी
3. अल्लाह की हराम करदा जान को नाहक़ क़त्ल करना
4. सूद खाना
5. यतीम का माल खाना
6. मैदान जंग से भागना
7. पाकदामन मोमिन औरतों पर तोहमत (सहीह बुख़ारी)

दीगर कबीरा गुनाह:
• फ़र्ज़ नमाज़ें छोड़ना
• वाजिब होने पर ज़कात न देना
• बग़ैर उज़्र रमज़ान का रोज़ा तोड़ना
• ताक़त के बावजूद हज न करना
• वालिदैन की नाफ़रमानी और बेअदबी
• रिश्ते तोड़ना
• ज़िना
• हम जिन्स परस्ती
• चोरी
• शराब पीना
• जुआ
• झूठ और झूठी गवाही
• ग़ीबत और बोहतान
• तकब्बुर और ग़ुरूर
• ज़ुल्म और नाइंसाफ़ी

ज़बान के गुनाह:
• नबी करीम ﷺ ने फ़रमाया: "ज़्यादातर लोगों के गुनाह उनकी ज़बानों से होते हैं।" (तबरानी)
• ग़ीबत (किसी की ग़ैर मौजूदगी में बुराई करना)
• बोहतान और झूठे इल्ज़ाम
• झूठ - ख़ास तौर पर नबी ﷺ के बारे में
• लानत और गंदी ज़बान
• दूसरों का मज़ाक़ उड़ाना

दिल के गुनाह:
• इबादत में दिखावा (रिया)
• हसद
• मुसलमान भाइयों से नफ़रत
• अल्लाह के बारे में बुरा गुमान
• तकब्बुर और ख़ुद पसंदी

नताइज:
• इस दुनिया में सज़ा
• क़ब्र में सज़ा
• क़यामत के दिन सज़ा
• तौबा न करने पर जहन्नम का बाइस बन सकते हैं''',
        'arabic': '''الكبائر التي يجب اجتنابها

السبع الموبقات والذنوب العظيمة.

السبع الموبقات:
• قال النبي ﷺ: "اجتنبوا السبع الموبقات" قالوا: يا رسول الله وما هن؟
• الشرك بالله
• السحر
• قتل النفس التي حرم الله إلا بالحق
• أكل الربا
• أكل مال اليتيم
• التولي يوم الزحف
• قذف المحصنات الغافلات المؤمنات

الشرك بالله:
• أعظم الذنوب على الإطلاق
• "إِنَّ اللَّهَ لَا يَغْفِرُ أَن يُشْرَكَ بِهِ وَيَغْفِرُ مَا دُونَ ذَٰلِكَ لِمَن يَشَاءُ" (سورة النساء: 48)
• الشرك الأكبر: صرف العبادة لغير الله
• الشرك الأصغر: الرياء والحلف بغير الله

عقوق الوالدين:
• من أكبر الكبائر
• قال النبي ﷺ: "ألا أنبئكم بأكبر الكبائر؟ الشرك بالله، وعقوق الوالدين" (البخاري)
• عدم برهما والإحسان إليهما
• قول "أف" لهما أو التضجر منهما
• التسبب في أذاهما

الزنا واللواط:
• من أعظم الفواحش
• "وَلَا تَقْرَبُوا الزِّنَا إِنَّهُ كَانَ فَاحِشَةً وَسَاءَ سَبِيلًا" (سورة الإسراء: 32)
• حد الزنا في الإسلام رجم المحصن وجلد غير المحصن
• اللواط أشد من الزنا

أكل الربا:
• "الَّذِينَ يَأْكُلُونَ الرِّبَا لَا يَقُومُونَ إِلَّا كَمَا يَقُومُ الَّذِي يَتَخَبَّطُهُ الشَّيْطَانُ" (سورة البقرة: 275)
• محاربة لله ورسوله
• محق البركة من المال
• التعامل بالربا كبيرة عظيمة

شرب الخمر:
• أم الخبائث
• تذهب العقل وتجلب الفواحش
• قال النبي ﷺ: "كل مسكر خمر، وكل خمر حرام" (مسلم)
• شارب الخمر كعابد وثن

الغيبة والنميمة:
• الغيبة: ذكر أخاك بما يكره
• النميمة: نقل الكلام بين الناس للإفساد
• قال الله: "وَلَا يَغْتَب بَّعْضُكُم بَعْضًا" (سورة الحجرات: 12)
• النمام لا يدخل الجنة'''
      },
    },
    {
      'number': 3,
      'titleKey': 'gunha_fazilat_3_true_repentance_tawbah',
      'title': 'True Repentance (Tawbah)',
      'titleUrdu': 'سچی توبہ',
      'titleHindi': 'सच्ची तौबा',
      'titleArabic': 'التوبة النصوح',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'details': {
        'english': '''True Repentance (Tawbah)

Allah loves those who repent and turn to Him in sincere repentance.

Allah's Mercy:
• "Say, 'O My servants who have transgressed against themselves, do not despair of the mercy of Allah. Indeed, Allah forgives all sins. Indeed, it is He who is the Forgiving, the Merciful.'" (Quran 39:53)
• Allah's mercy encompasses everything
• No sin is too great for Allah to forgive (except shirk if one dies upon it)

Conditions of Valid Tawbah:
1. Stop the sin immediately
2. Feel sincere remorse for committing it
3. Make firm intention never to return to it
4. If sin involved rights of others, make amends
5. Repent before death approaches

The Prophet's Teaching:
• "All children of Adam are sinners, and the best of sinners are those who repent." (Tirmidhi)
• "The one who repents from sin is like one who has no sin." (Ibn Majah)
• Repentance wipes the slate clean

Times When Repentance is Accepted:
• Any time before death
• Before the sun rises from the west (sign of Day of Judgment)
• The Prophet ﷺ said: "Allah extends His Hand at night to accept the repentance of those who sinned during the day, and extends His Hand during the day to accept the repentance of those who sinned at night."

How to Repent:
• Make sincere dua asking forgiveness
• Pray two rak'ah Salat at-Tawbah
• Increase good deeds to replace bad ones
• Avoid the places and people that led to sin
• Make amends with those you wronged

After Repentance:
• Don't return to the sin
• Don't feel hopeless if you slip again - repent immediately
• Replace bad habits with good ones
• Strengthen your relationship with Allah
• Be grateful for Allah's forgiveness''',
        'urdu': '''سچی توبہ

اللہ ان لوگوں سے محبت کرتا ہے جو توبہ کرتے اور اس کی طرف مخلصانہ رجوع کرتے ہیں۔

اللہ کی رحمت:
• "کہہ دو: 'اے میرے بندو جنہوں نے اپنے اوپر زیادتی کی، اللہ کی رحمت سے مایوس نہ ہو۔ بیشک اللہ تمام گناہ معاف کر دیتا ہے۔ بیشک وہی بخشنے والا مہربان ہے۔'" (قرآن 39:53)
• اللہ کی رحمت ہر چیز کو گھیرے ہوئے ہے
• کوئی گناہ اتنا بڑا نہیں جو اللہ معاف نہ کر سکے (سوائے شرک کے اگر اسی پر موت آئے)

صحیح توبہ کی شرطیں:
1. گناہ فوری طور پر چھوڑ دینا
2. کرنے پر سچی ندامت محسوس کرنا
3. دوبارہ نہ کرنے کا پختہ ارادہ کرنا
4. اگر گناہ میں دوسروں کے حقوق شامل ہوں تو ان کی تلافی کرنا
5. موت آنے سے پہلے توبہ کرنا

نبی کریم ﷺ کی تعلیم:
• "تمام بنی آدم خطاکار ہیں اور بہترین خطاکار وہ ہیں جو توبہ کرتے ہیں۔" (ترمذی)
• "جو گناہ سے توبہ کرے وہ ایسے ہے جیسے اس نے گناہ ہی نہ کیا۔" (ابن ماجہ)
• توبہ سلیٹ کو صاف کر دیتی ہے

جب توبہ قبول ہوتی ہے:
• موت سے پہلے کسی بھی وقت
• مغرب سے سورج نکلنے سے پہلے (قیامت کی علامت)
• نبی کریم ﷺ نے فرمایا: "اللہ رات کو اپنا ہاتھ بڑھاتا ہے تاکہ دن کے گنہگاروں کی توبہ قبول کرے، اور دن کو ہاتھ بڑھاتا ہے تاکہ رات کے گنہگاروں کی توبہ قبول کرے۔"

توبہ کیسے کریں:
• مخلصانہ دعا کر کے معافی مانگیں
• دو رکعت صلاۃ التوبہ پڑھیں
• نیک اعمال بڑھائیں تاکہ برے اعمال کی جگہ لیں
• ان جگہوں اور لوگوں سے بچیں جو گناہ کا باعث بنے
• جن کا حق مارا ہے ان سے معافی مانگیں

توبہ کے بعد:
• گناہ کی طرف نہ لوٹیں
• اگر پھر سے پھسل جائیں تو ناامید نہ ہوں - فوری توبہ کریں
• بُری عادات کو اچھی عادات سے بدلیں
• اللہ کے ساتھ اپنا تعلق مضبوط کریں
• اللہ کی معافی پر شکر ادا کریں''',
        'hindi': '''सच्ची तौबा

अल्लाह उन लोगों से मोहब्बत करता है जो तौबा करते और उसकी तरफ़ मुख़्लिसाना रुजू करते हैं।

अल्लाह की रहमत:
• "कह दो: 'ऐ मेरे बंदो जिन्होंने अपने ऊपर ज़्यादती की, अल्लाह की रहमत से मायूस न हो। बेशक अल्लाह तमाम गुनाह माफ़ कर देता है। बेशक वही बख़्शने वाला मेहरबान है।'" (क़ुरआन 39:53)
• अल्लाह की रहमत हर चीज़ को घेरे हुए है
• कोई गुनाह इतना बड़ा नहीं जो अल्लाह माफ़ न कर सके (सिवाए शिर्क के अगर उसी पर मौत आए)

सही तौबा की शर्तें:
1. गुनाह फ़ौरन छोड़ देना
2. करने पर सच्ची नदामत महसूस करना
3. दोबारा न करने का पुख़्ता इरादा करना
4. अगर गुनाह में दूसरों के हुक़ूक़ शामिल हों तो उनकी तलाफ़ी करना
5. मौत आने से पहले तौबा करना

नबी करीम ﷺ की तालीम:
• "तमाम बनी आदम ख़ताकार हैं और बेहतरीन ख़ताकार वो हैं जो तौबा करते हैं।" (तिर्मिज़ी)
• "जो गुनाह से तौबा करे वो ऐसे है जैसे उसने गुनाह ही न किया।" (इब्ने माजा)
• तौबा स्लेट को साफ़ कर देती है

जब तौबा क़बूल होती है:
• मौत से पहले किसी भी वक़्त
• मग़रिब से सूरज निकलने से पहले (क़यामत की अलामत)
• नबी करीम ﷺ ने फ़रमाया: "अल्लाह रात को अपना हाथ बढ़ाता है ताकि दिन के गुनहगारों की तौबा क़बूल करे, और दिन को हाथ बढ़ाता है ताकि रात के गुनहगारों की तौबा क़बूल करे।"

तौबा कैसे करें:
• मुख़्लिसाना दुआ करके माफ़ी मांगें
• दो रकअत सलातुत तौबा पढ़ें
• नेक आमाल बढ़ाएं ताकि बुरे आमाल की जगह लें
• उन जगहों और लोगों से बचें जो गुनाह का बाइस बने
• जिनका हक़ मारा है उनसे माफ़ी मांगें

तौबा के बाद:
• गुनाह की तरफ़ न लौटें
• अगर फिर से फिसल जाएं तो नाउम्मीद न हों - फ़ौरन तौबा करें
• बुरी आदतों को अच्छी आदतों से बदलें
• अल्लाह के साथ अपना ताल्लुक़ मज़बूत करें
• अल्लाह की माफ़ी पर शुक्र अदा करें''',
        'arabic': '''التوبة النصوح

كيفية التوبة الصادقة من الذنوب.

معنى التوبة:
• الرجوع إلى الله من المعصية
• الندم على ما فات والعزم على عدم العودة
• "وَتُوبُوا إِلَى اللَّهِ جَمِيعًا أَيُّهَ الْمُؤْمِنُونَ لَعَلَّكُمْ تُفْلِحُونَ" (سورة النور: 31)
• باب الرجوع إلى الله مفتوح دائماً

شروط التوبة الصحيحة:
• الإقلاع عن الذنب فوراً
• الندم على ما فات من المعصية
• العزم الصادق على عدم العودة
• رد الحقوق إلى أصحابها (في حقوق العباد)
• أن تكون في وقت قبول التوبة

وقت قبول التوبة:
• قبل طلوع الشمس من مغربها
• قبل الغرغرة (سكرات الموت)
• قال النبي ﷺ: "إن الله يقبل توبة العبد ما لم يغرغر" (الترمذي)
• التوبة قبل معاينة الموت

فضل التوبة:
• "إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ وَيُحِبُّ الْمُتَطَهِّرِينَ" (سورة البقرة: 222)
• التائب من الذنب كمن لا ذنب له
• الله يفرح بتوبة عبده
• تمحو الذنوب والسيئات
• تحول السيئات إلى حسنات

التوبة من حقوق العباد:
• لا بد من رد الحقوق أولاً
• الاستحلال من صاحب الحق
• إن لم يمكن فالاستغفار له
• التصدق عنه إن كان ميتاً

الإصرار على التوبة:
• عدم اليأس من رحمة الله
• "قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ" (سورة الزمر: 53)
• المداومة على الاستغفار
• إذا عاد للذنب يتوب مرة أخرى

علامات قبول التوبة:
• انشراح الصدر وطمأنينة القلب
• حب الطاعات وكره المعاصي
• الإقبال على الله بالعبادة
• الإحسان إلى الخلق
• الشعور بالخوف من الله والرجاء في رحمته'''
      },
    },
    {
      'number': 4,
      'titleKey': 'gunha_fazilat_4_protection_from_sins',
      'title': 'Protection from Sins',
      'titleUrdu': 'گناہوں سے بچاؤ',
      'titleHindi': 'गुनाहों से बचाव',
      'titleArabic': 'الحماية من الذنوب',
      'icon': Icons.security,
      'color': Colors.blue,
      'details': {
        'english': '''Protection from Sins

Preventing sins is easier than repenting from them.

Strengthening Your Faith:
• Regular recitation of Quran
• Consistent prayer with concentration
• Increasing knowledge of Islam
• Remembrance of Allah (dhikr)
• "Indeed, in the remembrance of Allah do hearts find rest." (Quran 13:28)

Avoiding Temptations:
• Lower your gaze from forbidden things
• Avoid bad company
• Stay away from places of sin
• Fill your time with beneficial activities
• The Prophet ﷺ said: "Leave what makes you doubt for what does not make you doubt."

Building Good Habits:
• Wake up for Fajr prayer
• Regular Quran recitation
• Daily adhkar (morning and evening)
• Frequent charity
• Seeking knowledge
• Good companionship

Seeking Allah's Protection:
• "O Allah, I seek refuge in You from knowingly committing shirk, and I seek Your forgiveness for what I do not know."
• Recite morning and evening adhkar for protection
• Regular istighfar (seeking forgiveness)
• Dua before leaving home

Remembering Death:
• "Remember often the destroyer of pleasures - death." (Tirmidhi)
• Visiting graves as reminder
• Thinking about the Day of Judgment
• Knowing this life is temporary

Accountability:
• Self-reflection before sleep
• Keeping good friends who remind you of Allah
• Having a mentor or teacher
• Remembering Allah sees everything''',
        'urdu': '''گناہوں سے بچاؤ

گناہوں سے بچنا ان سے توبہ کرنے سے آسان ہے۔

اپنے ایمان کو مضبوط کرنا:
• باقاعدہ قرآن کی تلاوت
• توجہ کے ساتھ مسلسل نماز
• اسلامی علم بڑھانا
• اللہ کا ذکر
• "بیشک اللہ کے ذکر سے دل سکون پاتے ہیں۔" (قرآن 13:28)

فتنوں سے بچنا:
• حرام چیزوں سے نظریں نیچی رکھنا
• بری صحبت سے بچنا
• گناہ کی جگہوں سے دور رہنا
• اپنا وقت فائدہ مند سرگرمیوں میں لگانا
• نبی کریم ﷺ نے فرمایا: "جو چیز شک میں ڈالے اسے چھوڑ دو اور جو شک میں نہ ڈالے اسے اختیار کرو۔"

اچھی عادات بنانا:
• فجر کی نماز کے لیے اٹھنا
• باقاعدہ قرآن کی تلاوت
• روزانہ اذکار (صبح و شام)
• کثرت سے صدقہ
• علم حاصل کرنا
• اچھی صحبت

اللہ کی پناہ مانگنا:
• "اے اللہ، میں تجھ سے جان بوجھ کر شرک سے پناہ مانگتا ہوں، اور جو نہیں جانتا اس کے لیے تجھ سے معافی مانگتا ہوں۔"
• حفاظت کے لیے صبح شام کے اذکار پڑھنا
• باقاعدہ استغفار
• گھر سے نکلنے سے پہلے دعا

موت کو یاد رکھنا:
• "لذتوں کو ختم کرنے والی چیز - موت - کو کثرت سے یاد کرو۔" (ترمذی)
• یاد دہانی کے لیے قبروں کی زیارت
• قیامت کے دن کے بارے میں سوچنا
• جاننا کہ یہ زندگی عارضی ہے

احتساب:
• سونے سے پہلے خود جائزہ
• اچھے دوست رکھنا جو اللہ کی یاد دلائیں
• استاد یا رہنما رکھنا
• یاد رکھنا کہ اللہ سب کچھ دیکھتا ہے''',
        'hindi': '''गुनाहों से बचाव

गुनाहों से बचना उनसे तौबा करने से आसान है।

अपने ईमान को मज़बूत करना:
• बाक़ायदा क़ुरआन की तिलावत
• तवज्जोह के साथ मुसलसल नमाज़
• इस्लामी इल्म बढ़ाना
• अल्लाह का ज़िक्र
• "बेशक अल्लाह के ज़िक्र से दिल सुकून पाते हैं।" (क़ुरआन 13:28)

फ़ितनों से बचना:
• हराम चीज़ों से निगाहें नीची रखना
• बुरी सोहबत से बचना
• गुनाह की जगहों से दूर रहना
• अपना वक़्त फ़ायदेमंद सरगर्मियों में लगाना
• नबी करीम ﷺ ने फ़रमाया: "जो चीज़ शक में डाले उसे छोड़ दो और जो शक में न डाले उसे इख़्तियार करो।"

अच्छी आदतें बनाना:
• फ़ज्र की नमाज़ के लिए उठना
• बाक़ायदा क़ुरआन की तिलावत
• रोज़ाना अज़कार (सुबह व शाम)
• कसरत से सदक़ा
• इल्म हासिल करना
• अच्छी सोहबत

अल्लाह की पनाह मांगना:
• "ऐ अल्लाह, मैं तुझसे जानबूझकर शिर्क से पनाह मांगता हूं, और जो नहीं जानता उसके लिए तुझसे माफ़ी मांगता हूं।"
• हिफ़ाज़त के लिए सुबह शाम के अज़कार पढ़ना
• बाक़ायदा इस्तिग़फ़ार
• घर से निकलने से पहले दुआ

मौत को याद रखना:
• "लज़्ज़तों को ख़त्म करने वाली चीज़ - मौत - को कसरत से याद करो।" (तिर्मिज़ी)
• याददिहानी के लिए क़ब्रों की ज़ियारत
• क़यामत के दिन के बारे में सोचना
• जानना कि यह ज़िंदगी अरज़ी है

एहतेसाब:
• सोने से पहले ख़ुद जायज़ा
• अच्छे दोस्त रखना जो अल्लाह की याद दिलाएं
• उस्ताद या रहनुमा रखना
• याद रखना कि अल्लाह सब कुछ देखता है''',
        'arabic': '''الحماية من الذنوب

كيفية الوقاية من الوقوع في المعاصي.

تقوى الله:
• "يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ" (سورة آل عمران: 102)
• استشعار مراقبة الله في السر والعلن
• الخوف من عقاب الله
• الرجاء في ثواب الله
• التقوى درع يحمي من المعاصي

ذكر الله:
• "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ" (سورة الرعد: 28)
• المداومة على الأذكار الصباحية والمسائية
• قراءة القرآن يومياً
• التسبيح والتحميد والتهليل
• الذكر يطرد الشيطان

الصحبة الصالحة:
• قال النبي ﷺ: "المرء على دين خليله، فلينظر أحدكم من يخالل" (أبو داود)
• مجالسة الصالحين تعين على الطاعة
• البعد عن رفقاء السوء
• الصاحب الصالح ينصح ويذكر بالله

غض البصر:
• "قُل لِّلْمُؤْمِنِينَ يَغُضُّوا مِنْ أَبْصَارِهِمْ" (سورة النور: 30)
• النظر سهم مسموم من سهام إبليس
• غض البصر يحفظ القلب من الشهوات
• ينور القلب والبصيرة

حفظ اللسان:
• قال النبي ﷺ: "من كان يؤمن بالله واليوم الآخر فليقل خيراً أو ليصمت" (البخاري)
• الصمت عن الباطل
• عدم الخوض في ما لا يعني
• ذكر الله بدل الغيبة والنميمة

الدعاء والاستعاذة:
• "رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا" (سورة آل عمران: 8)
• الاستعاذة بالله من الشيطان
• دعاء: "اللهم إني أعوذ بك من شر نفسي"
• طلب العصمة من الله

تذكر الموت:
• قال النبي ﷺ: "أكثروا ذكر هاذم اللذات" (الترمذي)
• تذكر الموت يزهد في الدنيا
• استحضار القبر والحساب
• تذكر الجنة والنار'''
      },
    },
    {
      'number': 5,
      'titleKey': 'gunha_fazilat_5_sins_of_the_tongue',
      'title': 'Sins of the Tongue',
      'titleUrdu': 'زبان کے گناہ',
      'titleHindi': 'ज़बान के गुनाह',
      'titleArabic': 'ذنوب اللسان',
      'icon': Icons.speaker_notes_off,
      'color': Colors.deepOrange,
      'details': {
        'english': '''Sins of the Tongue

The tongue is a small organ but causes the greatest harm.

The Danger of the Tongue:
• The Prophet ﷺ said: "Whoever can guarantee me what is between his jaws and what is between his legs, I can guarantee him Paradise." (Bukhari)
• Most people enter Hell because of their tongues
• The tongue can destroy years of good deeds

Types of Tongue Sins:

1. Backbiting (Gheebah):
• Speaking about someone in their absence in a way they would dislike
• Even if what you say is true
• The Prophet ﷺ said: "Do you know what backbiting is?" They said: "Allah and His Messenger know best." He said: "Mentioning about your brother what he dislikes."

2. Slander (Buhtan):
• Saying false things about someone
• Even worse than backbiting
• Destroys reputations unjustly

3. Tale-bearing (Nameemah):
• Carrying tales between people to cause harm
• "A tale-bearer will not enter Paradise." (Bukhari)
• Spreading rumors and gossip

4. Lying:
• Major sin in Islam
• The Prophet ﷺ said: "Truthfulness leads to righteousness and righteousness leads to Paradise... Lying leads to wickedness and wickedness leads to Hell."
• Lying about the Prophet ﷺ is even worse

5. Cursing and Foul Language:
• Using bad words
• Cursing others
• The Prophet ﷺ said: "The believer does not curse."

6. Mockery and Ridicule:
• Making fun of others
• "O you who believe, let not a people ridicule another people." (Quran 49:11)
• Hurts feelings and destroys relationships

How to Guard Your Tongue:
• Think before you speak
• Speak only good or remain silent
• Remember Allah is recording everything
• Ask yourself: Is it true? Is it necessary? Is it kind?''',
        'urdu': '''زبان کے گناہ

زبان ایک چھوٹا عضو ہے لیکن سب سے بڑا نقصان پہنچاتا ہے۔

زبان کا خطرہ:
• نبی کریم ﷺ نے فرمایا: "جو مجھے اپنے دو جبڑوں اور دو ��انگوں کے درمیان کی چیز کی ضمانت دے، میں اسے جنت کی ضمانت دیتا ہوں۔" (بخاری)
• زیادہ تر لوگ اپنی زبانوں کی وجہ سے جہنم میں جاتے ہیں
• زبان سالوں کے نیک اعمال تباہ کر سکتی ہے

زبان کے گناہوں کی اقسام:

1. غیبت:
• کسی کی غیر موجودگی میں ایسی بات کرنا جو اسے ناپسند ہو
• خواہ جو کہو سچ ہو
• نبی کریم ﷺ نے فرمایا: "کیا تم جانتے ہو غیبت کیا ہے؟" انہوں نے کہا: "اللہ اور اس کے رسول ﷺ بہتر جانتے ہیں۔" آپ ﷺ نے فرمایا: "اپنے بھائی کا ذکر اس طرح کرنا جو اسے ناپسند ہو۔"

2. بہتان:
• کسی کے بارے میں جھوٹی باتیں کرنا
• غیبت سے بھی زیادہ بُرا
• ناحق نام خراب کرتا ہے

3. چغلی:
• لوگوں کے درمیان نقصان کے لیے باتیں لے جانا
• "چغل خور جنت میں نہیں جائے گا۔" (بخاری)
• افواہیں اور گپ شپ پھیلانا

4. جھوٹ:
• اسلام میں بڑا گناہ
• نبی کریم ﷺ نے فرمایا: "سچائی نیکی کی طرف لے جاتی ہے اور نیکی جنت کی طرف... جھوٹ بدی کی طرف لے جاتا ہے اور بدی جہنم کی طرف۔"
• نبی ﷺ کے بارے میں جھوٹ اور بھی بُرا ہے

5. لعنت اور گندی زبان:
• بُرے الفاظ استعمال کرنا
• دوسروں کو لعنت کرنا
• نبی کریم ﷺ نے فرمایا: "مومن لعنت نہیں کرتا۔"

6. مذاق اور تضحیک:
• دوسروں کا مذاق اڑانا
• "اے ایمان والو! کوئی قوم دوسری قوم کا مذاق نہ اڑائے۔" (قرآن 49:11)
• جذبات کو ٹھیس پہنچاتا اور رشتے تباہ کرتا ہے

اپنی زبان کی حفاظت کیسے کریں:
• بولنے سے پہلے سوچیں
• صرف اچھا بولیں یا خاموش رہیں
• یاد رکھیں اللہ سب کچھ لکھ رہا ہے
• اپنے آپ سے پوچھیں: کیا یہ سچ ہے؟ کیا ضروری ہے؟ کیا مہربان ہے؟''',
        'hindi': '''ज़बान के गुनाह

ज़बान एक छोटा उज़्व है लेकिन सबसे बड़ा नुक़सान पहुंचाता है।

ज़बान का ख़तरा:
• नबी करीम ﷺ ने फ़रमाया: "जो मुझे अपने दो जबड़ों और दो टांगों के दरमियान की चीज़ की ज़मानत दे, मैं उसे जन्नत की ज़मानत देता हूं।" (बुख़ारी)
• ज़्यादातर लोग अपनी ज़बानों की वजह से जहन्नम में जाते हैं
• ज़बान सालों के नेक आमाल तबाह कर सकती है

ज़बान के गुनाहों की अक़सां:

1. ग़ीबत:
• किसी की ग़ैर मौजूदगी में ऐसी बात करना जो उसे नापसंद हो
• ख़्वाह जो कहो सच हो
• नबी करीम ﷺ ने फ़रमाया: "क्या तुम जानते हो ग़ीबत क्या है?" उन्होंने कहा: "अल्लाह और उसके रसूल ﷺ बेहतर जानते हैं।" आप ﷺ ने फ़रमाया: "अपने भाई का ज़िक्र इस तरह करना जो उसे नापसंद हो।"

2. बोहतान:
• किसी के बारे में झूठी बातें करना
• ग़ीबत से भी ज़्यादा बुरा
• नाहक़ नाम ख़राब करता है

3. चुग़ली:
• लोगों के दरमियान नुक़सान के लिए बातें ले जाना
• "चुग़लख़ोर जन्नत में नहीं जाएगा।" (बुख़ारी)
• अफ़वाहें और गपशप फैलाना

4. झूठ:
• इस्लाम में बड़ा गुनाह
• नबी करीम ﷺ ने फ़रमाया: "सच्चाई नेकी की तरफ़ ले जाती है और नेकी जन्नत की तरफ़... झूठ बदी की तरफ़ ले जाता है और बदी जहन्नम की तरफ़।"
• नबी ﷺ के बारे में झूठ और भी बुरा है

5. लानत और गंदी ज़बान:
• बुरे अल्फ़ाज़ इस्तेमाल करना
• दूसरों को लानत करना
• नबी करीम ﷺ ने फ़रमाया: "मोमिन लानत नहीं करता।"

6. मज़ाक़ और तज़हीक:
• दूसरों का मज़ाक़ उड़ाना
• "ऐ ईमान वालो! कोई क़ौम दूसरी क़ौम का मज़ाक़ न उड़ाए।" (क़ुरआन 49:11)
• जज़्बात को ठेस पहुंचाता और रिश्ते तबाह करता है

अपनी ज़बान की हिफ़ाज़त कैसे करें:
• बोलने से पहले सोचें
• सिर्फ़ अच्छा बोलें या ख़ामोश रहें
• याद रखें अल्लाह सब कुछ लिख रहा है
• अपने आप से पूछें: क्या यह सच है? क्या ज़रूरी है? क्या मेहरबान है?''',
        'arabic': '''ذنوب اللسان

خطورة اللسان وآفاته.

خطورة اللسان:
• قال النبي ﷺ: "إن العبد ليتكلم بالكلمة ما يتبين فيها يزل بها في النار أبعد مما بين المشرق والمغرب" (مسلم)
• اللسان أخطر الجوارح
• معظم خطايا ابن آدم من لسانه
• سبب دخول أكثر الناس النار

الكذب:
• من أقبح الذنوب
• قال النبي ﷺ: "إن الكذب يهدي إلى الفجور، وإن الفجور يهدي إلى النار" (البخاري)
• الكذب على الله ورسوله من أعظم الكبائر
• شهادة الزور من أكبر الكبائر

الغيبة:
• ذكر أخاك بما يكره في غيابه
• "أَيُحِبُّ أَحَدُكُمْ أَن يَأْكُلَ لَحْمَ أَخِيهِ مَيْتًا فَكَرِهْتُمُوهُ" (سورة الحجرات: 12)
• تأكل الحسنات كما تأكل النار الحطب
• كفارتها: الاستغفار للمغتاب والاستحلال منه

النميمة:
• نقل الكلام بين الناس للإفساد
• قال النبي ﷺ: "لا يدخل الجنة نمام" (البخاري)
• تفرق بين الأحبة
• تزرع العداوة والبغضاء

السب والشتم:
• "سِبَابُ الْمُسْلِمِ فُسُوقٌ وَقِتَالُهُ كُفْرٌ" (البخاري)
• سب المسلم معصية كبيرة
• لعن المؤمن كقتله
• السخرية والاستهزاء من الكبائر

اللغو والباطل:
• الكلام فيما لا يفيد
• "وَإِذَا مَرُّوا بِاللَّغْوِ مَرُّوا كِرَامًا" (سورة الفرقان: 72)
• الخوض في الباطل
• كثرة الكلام بغير ذكر الله تقسي القلب

حفظ اللسان:
• الصمت إلا من خير
• التفكر قبل الكلام
• ذكر الله كثيراً
• قال النبي ﷺ: "من صمت نجا" (الترمذي)'''
      },
    },
    {
      'number': 6,
      'titleKey': 'gunha_fazilat_6_consequences_of_sins',
      'title': 'Consequences of Sins',
      'titleUrdu': 'گناہوں کے نتائج',
      'titleHindi': 'गुनाहों के नताइज',
      'titleArabic': 'عواقب الذنوب',
      'icon': Icons.error,
      'color': Colors.deepPurple,
      'details': {
        'english': '''Consequences of Sins

Sins have severe consequences in this life and the Hereafter.

In This World:
• Darkness in the heart - "No, rather their hearts have become stained by what they were earning." (Quran 83:14)
• Hardness of heart - inability to cry or feel remorse
• Difficulty in worship - prayers feel heavy
• Loss of blessings (barakah) in time, wealth, and health
• Anxiety and depression
• Bad reputation
• Difficulty in repentance
• One sin leads to another

In the Grave:
• Punishment of the grave for major sins
• The grave either becomes a garden from Paradise or a pit from Hell
• Questions of the angels become difficult
• Loneliness and fear
• The Prophet ﷺ said: "The grave is the first stage of the Hereafter."

On the Day of Judgment:
• Accountability for every deed
• "So whoever does an atom's weight of good will see it, and whoever does an atom's weight of evil will see it." (Quran 99:7-8)
• Walking in darkness while believers have light
• Waiting in difficulty
• Fear and regret

In the Hellfire:
• Severe punishment according to the sin
• "Those who consume interest will stand on the Day of Resurrection like one who is beaten by Satan." (Quran 2:275)
• Different levels of punishment
• May Allah protect us all

Social Consequences:
• Loss of trust from people
• Broken relationships
• Bad influence on children
• Setting bad example for others
• Community degradation

The Way Out:
• Sincere repentance immediately
• Increase good deeds
• Seek forgiveness constantly
• Make amends with those you wronged
• Remember Allah's infinite mercy''',
        'urdu': '''گناہوں کے نتائج

گناہوں کے اس دنیا اور آخرت میں سخت نتائج ہیں۔

اس دنیا میں:
• دل میں تاریکی - "نہیں بلکہ ان کے دلوں پر زنگ چڑھ گیا ہے جو وہ کماتے تھے۔" (قرآن 83:14)
• دل کی سختی - رونے یا ندامت محسوس کرنے میں ناکامی
• عبادت میں مشکل - نمازیں بھاری محسوس ہوتی ہیں
• وقت، دولت اور صحت میں برکت کا ختم ہونا
• پریشانی اور ڈپریشن
• بُری شہرت
• توبہ میں مشکل
• ایک گناہ دوسرے گناہ کی طرف لے جاتا ہے

قبر میں:
• کبیرہ گناہوں پر قبر کا عذاب
• قبر یا تو جنت کا باغ بن جاتی ہے یا جہنم کا گڑھا
• فرشتوں کے سوالات مشکل ہو جاتے ہیں
• تنہائی اور خوف
• نبی کریم ﷺ نے فرمایا: "قبر آخرت کا پہلا مرحلہ ہے۔"

قیامت کے دن:
• ہر عمل کا حساب
• "تو جو ذرہ برابر نیکی کرے گا وہ دیکھے گا اور جو ذرہ برابر برائی کرے گا وہ دیکھے گا۔" (قرآن 99:7-8)
• اندھیرے میں چلنا جبکہ مومنوں کو نور ملے گا
• مشکل میں انتظار کرنا
• خوف اور ندامت

جہنم میں:
• گناہ کے مطابق سخت سزا
• "جو سود کھاتے ہیں وہ قیامت کے دن ایسے کھڑے ہوں گے جیسے شیطان نے مار مار کر پاگل کر دیا ہو۔" (قرآن 2:275)
• سزا کے مختلف درجے
• اللہ ہم سب کی حفاظت فرمائے

معاشرتی نتائج:
• لوگوں کا اعتماد کھونا
• ٹوٹے ہوئے رشتے
• بچوں پر بُرا اثر
• دوسروں کے لیے بُری مثال قائم کرنا
• معاشرے کی تنزلی

راستہ:
• فوری مخلصانہ توبہ
• نیک اعمال بڑھائیں
• مسلسل معافی مانگیں
• جن کا حق مارا ہے ان سے معافی مانگیں
• اللہ کی لامحدود رحمت یاد رکھیں''',
        'hindi': '''गुनाहों के नताइज

गुनाहों के इस दुनिया और आख़िरत में सख़्त नताइज हैं।

इस दुनिया में:
• दिल में तारीकी - "नहीं बल्कि उनके दिलों पर ज़ंग चढ़ गया है जो वो कमाते थे।" (क़ुरआन 83:14)
• दिल की सख़्ती - रोने या नदामत महसूस करने में नाकामी
• इबादत में मुश्किल - नमाज़ें भारी महसूस होती हैं
• वक़्त, दौलत और सेहत में बरकत का ख़त्म होना
• परेशानी और डिप्रेशन
• बुरी शोहरत
• तौबा में मुश्किल
• एक गुनाह दूसरे गुनाह की तरफ़ ले जाता है

क़ब्र में:
• कबीरा गुनाहों पर क़ब्र का अज़ाब
• क़ब्र या तो जन्नत का बाग़ बन जाती है या जहन्नम का गड्ढा
• फ़रिश्तों के सवालात मुश्किल हो जाते हैं
• तन्हाई और ख़ौफ़
• नबी करीम ﷺ ने फ़रमाया: "क़ब्र आख़िरत का पहला मरहला है।"

क़यामत के दिन:
• हर अमल का हिसाब
• "तो जो ज़र्रा बराबर नेकी करेगा वो देखेगा और जो ज़र्रा बराबर बुराई करेगा वो देखेगा।" (क़ुरआन 99:7-8)
• अंधेरे में चलना जबकि मोमिनों को नूर मिलेगा
• मुश्किल में इंतिज़ार करना
• ख़ौफ़ और नदामत

जहन्नम में:
• गुनाह के मुताबिक़ सख़्त सज़ा
• "जो सूद खाते हैं वो क़यामत के दिन ऐसे खड़े होंगे जैसे शैतान ने मार मारकर पागल कर दिया हो।" (क़ुरआन 2:275)
• सज़ा के मुख़्तलिफ़ दर्जे
• अल्लाह हम सबकी हिफ़ाज़त फ़रमाए

मुआशरती नताइज:
• लोगों का एतमाद खोना
• टूटे हुए रिश्ते
• बच्चों पर बुरा असर
• दूसरों के लिए बुरी मिसाल क़ायम करना
• मुआशरे की तनज़्ज़ुली

रास्ता:
• फ़ौरन मुख़्लिसाना तौबा
• नेक आमाल बढ़ाएं
• मुसलसल माफ़ी मांगें
• जिनका हक़ मारा है उनसे माफ़ी मांगें
• अल्लाह की लामहदूद रहमत याद रखें''',
        'arabic': '''عواقب الذنوب

آثار المعاصي في الدنيا والآخرة.

العواقب في الدنيا:
• محق البركة من الرزق والعمر
• قسوة القلب وظلمته
• ضيق الصدر والهم والغم
• "وَمَنْ أَعْرَضَ عَن ذِكْرِي فَإِنَّ لَهُ مَعِيشَةً ضَنكًا" (سورة طه: 124)
• الوحشة بين العبد وربه

قسوة القلب:
• قال النبي ﷺ: "إن العبد إذا أخطأ خطيئة نكتت في قلبه نكتة سوداء" (الترمذي)
• الذنوب تطفئ نور القلب
• تمنع من فهم القرآن
• تبعد عن الطاعات
• تجعل القلب ميتاً لا يتأثر بالمواعظ

الفقر والحرمان:
• قال النبي ﷺ: "إن الرجل ليحرم الرزق بالذنب يصيبه" (أحمد)
• الذنوب تمنع الرزق
• تذهب البركة من المال
• تجلب الفقر والحاجة

ضعف الإرادة:
• عدم القدرة على ترك المعاصي
• الوقوع في ذنب يقود إلى ذنب آخر
• صعوبة التوبة والرجوع
• سهولة الانقياد للشيطان

المصائب والبلايا:
• "وَمَا أَصَابَكُم مِّن مُّصِيبَةٍ فَبِمَا كَسَبَتْ أَيْدِيكُمْ" (سورة الشورى: 30)
• الذنوب سبب المصائب
• قلة الأمن والاستقرار
• انتشار الأمراض والأوبئة

العواقب في الآخرة:
• عذاب القبر
• الحساب العسير يوم القيامة
• عذاب النار
• الحرمان من رؤية الله
• الندم الشديد

البعد عن الله:
• "كَلَّا إِنَّهُمْ عَن رَّبِّهِمْ يَوْمَئِذٍ لَّمَحْجُوبُونَ" (سورة المطففين: 15)
• حجاب بين العبد وربه
• عدم إجابة الدعاء
• الخذلان وعدم التوفيق

العلاج:
• التوبة النصوحة
• كثرة الاستغفار
• الإكثار من الأعمال الصالحة
• الصدقة تطفئ الخطيئة
• المداومة على الطاعات'''
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
          context.tr('gunha'),
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
              itemCount: _gunhaTopics.length,
              itemBuilder: (context, index) {
                final topic = _gunhaTopics[index];
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
    final title = context.tr(topic['titleKey'] ?? 'gunha_fazilat');
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
        onTap: () => _showTopicDetails(topic),
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
                    '${topic['number']}',
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
                            topic['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          SizedBox(width: responsive.spacing(4)),
                          Text(
                            context.tr('gunha_fazilat'),
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

  void _showTopicDetails(Map<String, dynamic> topic) {
    final details = topic['details'] as Map<String, String>;
    final titleKey = topic['titleKey'] ?? 'gunha_fazilat';
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
          categoryKey: 'category_gunha_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
