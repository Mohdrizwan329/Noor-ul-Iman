import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class GunhaFazilatScreen extends StatefulWidget {
  const GunhaFazilatScreen({super.key});

  @override
  State<GunhaFazilatScreen> createState() => _GunhaFazilatScreenState();
}

class _GunhaFazilatScreenState extends State<GunhaFazilatScreen> {
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
    {
      'number': 7,
      'titleKey': 'gunha_fazilat_7_70_major_sins',
      'title': '70 Major Sins List',
      'titleUrdu': '70 کبیرہ گناہوں کی فہرست',
      'titleHindi': '70 कबीरा गुनाहों की सूची',
      'titleArabic': 'قائمة السبعين كبيرة',
      'icon': Icons.format_list_numbered,
      'color': Colors.indigo,
      'details': {
        'english': '''70 Major Sins (Al-Kaba'ir) - Complete List

Imam Dhahabi compiled this comprehensive list in his famous book "Kitab al-Kaba'ir".

The 70 Major Sins:

1. Shirk - Associating partners with Allah (the greatest sin)
2. Murder - Killing an innocent soul
3. Sorcery/Magic - Black magic and witchcraft
4. Abandoning Prayer - Not performing obligatory prayers
5. Withholding Zakat - Refusing to give obligatory charity
6. Breaking Ramadan Fast - Without valid excuse
7. Not performing Hajj - Despite having ability
8. Disobeying Parents - Being disrespectful to them
9. Cutting Family Ties - Breaking relations with relatives
10. Adultery/Fornication (Zina)

11. Sodomy - Homosexual acts
12. Usury/Interest (Riba) - Consuming or paying interest
13. Consuming Orphan's Wealth - Taking their property unjustly
14. Lying about Allah or Prophet ﷺ
15. Fleeing from Battlefield - Deserting in jihad
16. Corrupt Leadership - Leaders betraying their trust
17. Arrogance/Pride - Looking down on others
18. False Testimony - Lying in court
19. Drinking Alcohol - All intoxicants
20. Gambling

21. Slandering Chaste Women - False accusations
22. Embezzlement - Stealing from public funds
23. Theft - Stealing property
24. Highway Robbery
25. Perjury - False oath that harms others
26. Chronic Lying - Frequent dishonesty
27. Suicide - Taking one's own life
28. Unjust Judgment - Corrupt judiciary
29. Accepting Spouse's Infidelity (Dayyuth)
30. Men Imitating Women (and vice versa)

31. Marrying to make wife halal for ex-husband (Tahleel)
32. Consuming Haram Food - Carrion, blood, pork
33. Not purifying from urine
34. Showing off in worship (Riya)
35. Betraying a trust
36. Learning religion for worldly gain
37. Reminding others of favors done
38. Denying Divine Decree (Qadar)
39. Spying on others
40. Cursing frequently

41. Betraying the leader
42. Believing fortunetellers/astrologers
43. Wife's disobedience to husband (Nushuz)
44. Making pictures of living beings
45. Loud wailing at funerals
46. Tale-bearing/spreading rumors
47. Attacking someone's lineage
48. Oppression and transgression
49. Armed rebellion against Muslim rulers
50. Harming and insulting Muslims

51. Harming the pious servants of Allah
52. Trailing garment out of pride
53. Men wearing silk and gold
54. Slave running away from master
55. Sacrificing to other than Allah
56. Changing land boundary markers
57. Cursing the Sahabah (Companions)
58. Cursing the Ansar (Helpers of Madinah)
59. Calling people to misguidance
60. Women wearing hair extensions, tattoos

61. Pointing weapons at a Muslim
62. Claiming false paternity
63. Believing in bad omens
64. Drinking from gold/silver vessels
65. Excessive arguing and disputing
66. Mutilating slaves
67. Cheating in measurements/weights
68. Feeling safe from Allah's punishment
69. Despairing of Allah's mercy
70. Being ungrateful to benefactors

Reference: Imam Dhahabi's "Kitab al-Kaba'ir"''',
        'urdu': '''70 کبیرہ گناہوں کی فہرست

امام ذہبی نے اپنی مشہور کتاب "کتاب الکبائر" میں یہ فہرست مرتب کی۔

70 کبیرہ گناہ:

1. شرک - اللہ کے ساتھ شریک ٹھہرانا (سب سے بڑا گناہ)
2. قتل - بے گناہ کو مارنا
3. جادو - کالا جادو اور ٹونا
4. نماز چھوڑنا - فرض نماز ادا نہ کرنا
5. زکوٰۃ نہ دینا
6. رمضان کا روزہ توڑنا - بغیر عذر کے
7. حج نہ کرنا - طاقت کے باوجود
8. والدین کی نافرمانی
9. رشتے توڑنا
10. زنا

11. لواطت
12. سود کھانا یا دینا
13. یتیم کا مال کھانا
14. اللہ یا نبی ﷺ کے بارے میں جھوٹ
15. میدان جنگ سے بھاگنا
16. بدعنوان قیادت
17. تکبر اور غرور
18. جھوٹی گواہی
19. شراب پینا
20. جوا کھیلنا

21. پاکدامن عورتوں پر تہمت
22. بیت المال میں خیانت
23. چوری کرنا
24. ڈکیتی
25. جھوٹی قسم جو دوسروں کو نقصان پہنچائے
26. بہت جھوٹ بولنا
27. خودکشی
28. ناانصافی سے فیصلہ کرنا
29. بیوی کی بے حیائی برداشت کرنا
30. مردوں کا عورتوں کی نقل کرنا

31. حلالہ
32. حرام کھانا - مردار، خون، سور
33. پیشاب سے پاکی نہ کرنا
34. دکھاوے کی عبادت
35. امانت میں خیانت
36. دنیا کے لیے دین سیکھنا
37. احسان جتانا
38. تقدیر کا انکار
39. جاسوسی کرنا
40. بہت لعنت کرنا

41. حکمران کی دغابازی
42. نجومیوں پر یقین
43. بیوی کی نافرمانی
44. جاندار کی تصویر بنانا
45. جنازے پر نوحہ کرنا
46. چغلی کھانا
47. نسب پر حملہ
48. ظلم و زیادتی
49. مسلمان حکمرانوں کے خلاف بغاوت
50. مسلمانوں کو تکلیف دینا

51. اللہ کے نیک بندوں کو نقصان
52. غرور سے کپڑے گھسیٹنا
53. مردوں کا ریشم اور سونا پہننا
54. غلام کا بھاگنا
55. غیر اللہ کے نام پر ذبح
56. زمین کی حدیں بدلنا
57. صحابہ کو گالی دینا
58. انصار کو گالی دینا
59. گمراہی کی طرف بلانا
60. عورتوں کا مصنوعی بال لگانا

61. مسلمان پر ہتھیار اٹھانا
62. جھوٹا نسب دعویٰ
63. بد شگونی پر یقین
64. سونے چاندی کے برتن سے پینا
65. بہت جھگڑا کرنا
66. غلاموں کو اذیت دینا
67. ناپ تول میں کمی
68. اللہ کے عذاب سے بے خوف
69. اللہ کی رحمت سے مایوس
70. احسان فراموشی

حوالہ: امام ذہبی کی "کتاب الکبائر"''',
        'hindi': '''70 कबीरा गुनाहों की सूची

इमाम ज़हबी ने अपनी मशहूर किताब "किताब अल-कबाइर" में यह सूची मुरत्तब की।

70 कबीरा गुनाह:

1. शिर्क - अल्लाह के साथ शरीक ठहराना (सबसे बड़ा गुनाह)
2. क़त्ल - बेगुनाह को मारना
3. जादू - काला जादू और टोना
4. नमाज़ छोड़ना - फ़र्ज़ नमाज़ अदा न करना
5. ज़कात न देना
6. रमज़ान का रोज़ा तोड़ना - बग़ैर उज़्र के
7. हज न करना - ताक़त के बावजूद
8. वालिदैन की नाफ़रमानी
9. रिश्ते तोड़ना
10. ज़िना

11. लवातत
12. सूद खाना या देना
13. यतीम का माल खाना
14. अल्लाह या नबी ﷺ के बारे म��ं झूठ
15. मैदान-ए-जंग से भागना
16. बदअनवान क़यादत
17. तकब्बुर और ग़ुरूर
18. झूठी गवाही
19. शराब पीना
20. जुआ खेलना

21. पाकदामन औरतों पर तोहमत
22. बैतुल माल में ख़यानत
23. चोरी करना
24. डकैती
25. झूठी क़सम जो दूसरों को नुक़सान पहुंचाए
26. बहुत झूठ बोलना
27. ख़ुदकुशी
28. नाइंसाफ़ी से फ़ैसला करना
29. बीवी की बेहयाई बर्दाश्त करना
30. मर्दों का औरतों की नक़ल करना

31. हलाला
32. हराम खाना - मुर्दार, ख़ून, सूअर
33. पेशाब से पाकी न करना
34. दिखावे की इबादत
35. अमानत में ख़यानत
36. दुनिया के लिए दीन सीखना
37. एहसान जताना
38. तक़दीर का इंकार
39. जासूसी करना
40. बहुत लानत करना

41. हुक्मरान की दग़ाबाज़ी
42. नजूमियों पर यक़ीन
43. बीवी की नाफ़रमानी
44. जानदार की तस्वीर बनाना
45. जनाज़े पर नौहा करना
46. चुग़ली खाना
47. नसब पर हमला
48. ज़ुल्म व ज़यादती
49. मुसलमान हुक्मरानों के ख़िलाफ़ बग़ावत
50. मुसलमानों को तकलीफ़ देना

51. अल्लाह के नेक बंदों को नुक़सान
52. ग़ुरूर से कपड़े घसीटना
53. मर्दों का रेशम और सोना पहनना
54. ग़ुलाम का भागना
55. ग़ैर अल्लाह के नाम पर ज़बह
56. ज़मीन की हदें बदलना
57. सहाबा को गाली देना
58. अंसार को गाली देना
59. गुमराही की तरफ़ बुलाना
60. औरतों का मस्नूई बाल लगाना

61. मुसलमान पर हथियार उठाना
62. झूठा नसब दावा
63. बद शुगूनी पर यक़ीन
64. सोने चांदी के बर्तन से पीना
65. बहुत झगड़ा करना
66. ग़ुलामों को अज़ीयत देना
67. नाप तौल में कमी
68. अल्लाह के अज़ाब से बेख़ौफ़
69. अल्लाह की रहमत से मायूस
70. एहसान फ़रामोशी

हवाला: इमाम ज़हबी की "किताब अल-कबाइर"''',
        'arabic': '''قائمة السبعين كبيرة

جمع الإمام الذهبي هذه القائمة في كتابه الشهير "الكبائر".

السبعون كبيرة:

١. الشرك بالله (أعظم الذنوب)
٢. قتل النفس التي حرم الله
٣. السحر
٤. ترك الصلاة المفروضة
٥. منع الزكاة
٦. إفطار رمضان بلا عذر
٧. ترك الحج مع الاستطاعة
٨. عقوق الوالدين
٩. قطيعة الرحم
١٠. الزنا

١١. اللواط
١٢. أكل الربا
١٣. أكل مال اليتيم
١٤. الكذب على الله ورسوله ﷺ
١٥. الفرار من الزحف
١٦. خيانة الإمام للرعية
١٧. الكبر والفخر
١٨. شهادة الزور
١٩. شرب الخمر
٢٠. القمار

٢١. قذف المحصنات
٢٢. الغلول من الغنيمة
٢٣. السرقة
٢٤. قطع الطريق
٢٥. اليمين الغموس
٢٦. كثرة الكذب
٢٧. قتل النفس (الانتحار)
٢٨. القاضي الجائر
٢٩. الديوث
٣٠. تشبه الرجال بالنساء والعكس

٣١. المحلل والمحلل له
٣٢. أكل الميتة والدم ولحم الخنزير
٣٣. عدم التنزه من البول
٣٤. الرياء
٣٥. الغدر والخيانة
٣٦. التعلم للدنيا
٣٧. المن بالعطاء
٣٨. التكذيب بالقدر
٣٩. التجسس
٤٠. اللعان

٤١. الغدر بالإمام
٤٢. تصديق العراف والمنجم
٤٣. نشوز المرأة على زوجها
٤٤. التصوير
٤٥. النياحة على الميت
٤٦. النميمة
٤٧. الطعن في الأنساب
٤٨. البغي والظلم
٤٩. الخروج على ولي الأمر
٥٠. إيذاء المسلمين

٥١. إيذاء أولياء الله
٥٢. إسبال الإزار خيلاء
٥٣. لبس الحرير والذهب للرجال
٥٤. إباق العبد
٥٥. الذبح لغير الله
٥٦. تغيير منار الأرض
٥٧. سب الصحابة
٥٨. سب الأنصار
٥٩. الدعوة إلى الضلالة
٦٠. الوصل والوشم

٦١. الإشارة بالسلاح إلى مسلم
٦٢. انتساب لغير أبيه
٦٣. الطيرة
٦٤. الشرب في آنية الذهب والفضة
٦٥. كثرة المراء والجدل
٦٦. الخصاء
٦٧. التطفيف في الكيل والميزان
٦٨. الأمن من مكر الله
٦٩. القنوط من رحمة الله
٧٠. كفران النعم

المرجع: كتاب الإمام الذهبي "الكبائر"'''
      },
    },
    {
      'number': 8,
      'titleKey': 'gunha_fazilat_8_sins_of_the_heart',
      'title': 'Sins of the Heart',
      'titleUrdu': 'دل کے گناہ',
      'titleHindi': 'दिल के गुनाह',
      'titleArabic': 'ذنوب القلب',
      'icon': Icons.favorite_border,
      'color': Colors.pink,
      'details': {
        'english': '''Sins of the Heart

The heart is the king of all organs. If it is corrupt, the whole body becomes corrupt.

The Prophet ﷺ said: "In the body there is a piece of flesh. If it is sound, the whole body is sound. If it is corrupt, the whole body is corrupt. Indeed it is the heart." (Bukhari & Muslim)

Major Sins of the Heart:

1. Shirk (Associating Partners with Allah):
   • The greatest sin
   • Hidden shirk includes showing off in worship
   • "Indeed, Allah does not forgive association with Him" (Quran 4:48)

2. Kibr (Arrogance/Pride):
   • Looking down on others
   • Refusing to accept the truth
   • The Prophet ﷺ said: "No one who has an atom's weight of arrogance will enter Paradise" (Muslim)

3. Hasad (Envy):
   • Wishing evil for others
   • Being unhappy at others' blessings
   • "Envy consumes good deeds as fire consumes wood" (Abu Dawud)

4. Riya (Showing Off):
   • Worshipping to be seen by people
   • Hidden polytheism
   • Nullifies rewards of good deeds

5. Ujb (Self-Amazement):
   • Being impressed with oneself
   • Attributing success to oneself, not Allah
   • Leads to arrogance

6. Sum'ah (Seeking Fame):
   • Doing good deeds to be heard about
   • Similar to Riya but through speech
   • "Whoever seeks fame, Allah will expose him" (Bukhari)

7. Ghurur (Self-Deception):
   • False security about Allah's punishment
   • Taking forgiveness for granted
   • Delaying repentance

8. Bad Opinion of Allah:
   • Thinking Allah won't forgive
   • Despairing of His mercy
   • Or feeling safe from His punishment

9. Love of Dunya (Worldly Attachments):
   • When love of world exceeds love of Akhirah
   • "Love of dunya is the head of all sins" (Bayhaqi)

10. Hatred for Fellow Muslims:
    • Holding grudges
    • Wishing harm upon them
    • "The gates of Paradise are opened on Monday and Thursday, and every servant who does not associate anything with Allah is forgiven except for a man who has enmity with his brother" (Muslim)

How to Purify the Heart:
• Sincere repentance
• Constant remembrance of Allah (Dhikr)
• Self-reflection (Muhasabah)
• Seeking knowledge
• Good companionship
• Reciting Quran with reflection''',
        'urdu': '''دل کے گناہ

دل تمام اعضاء کا بادشاہ ہے۔ اگر یہ خراب ہو تو سارا جسم خراب ہو جاتا ہے۔

نبی کریم ﷺ نے فرمایا: "جسم میں گوشت کا ایک ٹکڑا ہے۔ اگر وہ درست ہو تو سارا جسم درست ہے۔ اگر وہ خراب ہو تو سارا جسم خراب ہے۔ سنو! وہ دل ہے۔" (بخاری و مسلم)

دل کے بڑے گناہ:

1. شرک:
   • سب سے بڑا گناہ
   • چھپا ہوا شرک میں دکھاوے کی عبادت شامل ہے
   • "بے شک اللہ شرک کو معاف نہیں کرتا" (قرآن 4:48)

2. کبر (تکبر/غرور):
   • دوسروں کو حقیر سمجھنا
   • حق ماننے سے انکار
   • نبی ﷺ نے فرمایا: "جس کے دل میں ذرہ بھر تکبر ہے وہ جنت میں نہیں جائے گا" (مسلم)

3. حسد:
   • دوسروں کا برا چاہنا
   • دوسروں کی نعمت پر دکھی ہونا
   • "حسد نیکیوں کو ایسے کھا جاتا ہے جیسے آگ لکڑی کو" (ابو داؤد)

4. ریا (دکھاوا):
   • لوگوں کو دکھانے کے لیے عبادت کرنا
   • چھپا ہوا شرک
   • نیک اعمال کا ثواب ختم کر دیتا ہے

5. عجب (خود پسندی):
   • اپنے آپ سے متاثر ہونا
   • کامیابی خود کو منسوب کرنا، اللہ کو نہیں
   • تکبر کی طرف لے جاتا ہے

6. سمعہ (شہرت کی چاہت):
   • نیک اعمال کرنا تاکہ لوگ سنیں
   • ریا کی طرح لیکن بات کے ذریعے
   • "جو شہرت چاہے، اللہ اسے رسوا کر دے گا" (بخاری)

7. غرور (خود فریبی):
   • اللہ کے عذاب سے جھوٹا اطمینان
   • معافی کو یقینی سمجھنا
   • توبہ میں تاخیر

8. اللہ کے بارے میں بدگمانی:
   • سوچنا کہ اللہ معاف نہیں کرے گا
   • اس کی رحمت سے مایوسی
   • یا اس کے عذاب سے بے خوف ہونا

9. دنیا کی محبت:
   • جب دنیا کی محبت آخرت سے زیادہ ہو
   • "دنیا کی محبت تمام گناہوں کی جڑ ہے" (بیہقی)

10. مسلمانوں سے نفرت:
    • دل میں کینہ رکھنا
    • ان کا برا چاہنا
    • "جنت کے دروازے پیر اور جمعرات کو کھولے جاتے ہیں۔۔۔" (مسلم)

دل کی پاکیزگی کیسے کریں:
• مخلصانہ توبہ
• مسلسل ذکر اللہ
• خود احتسابی
• علم حاصل کرنا
• اچھی صحبت
• تدبر سے قرآن پڑھنا''',
        'hindi': '''दिल के गुनाह

दिल तमाम आज़ा का बादशाह है। अगर यह ख़राब हो तो सारा जिस्म ख़राब हो जाता है।

नबी करीम ﷺ ने फ़रमाया: "जिस्म में गोश्त का एक टुकड़ा है। अगर वो दुरुस्त हो तो सारा जिस्म दुरुस्त है। अगर वो ख़राब हो तो सारा जिस्म ख़राब है। सुनो! वो दिल है।" (बुख़ारी व मुस्लिम)

दिल के बड़े गुनाह:

1. शिर्क:
   • सबसे बड़ा गुनाह
   • छुपा हुआ शिर्क में दिखावे की इबादत शामिल है
   • "बेशक अल्लाह शिर्क को माफ़ नहीं करता" (क़ुरआन 4:48)

2. किब्र (तकब्बुर/ग़ुरूर):
   • दूसरों को हक़ीर समझना
   • हक़ मानने से इंकार
   • नबी ﷺ ने फ़रमाया: "जिसके दिल में ज़र्रा भर तकब्बुर है वो जन्नत में नहीं जाएगा" (मुस्लिम)

3. हसद:
   • दूसरों का बुरा चाहना
   • दूसरों की नेमत पर दुखी होना
   • "हसद नेकियों को ऐसे खा जाता है जैसे आग लकड़ी को" (अबू दाऊद)

4. रिया (दिखावा):
   • लोगों को दिखाने के लिए इबादत करना
   • छुपा हुआ शिर्क
   • नेक आमाल का सवाब ख़त्म कर देता है

5. उज्ब (ख़ुदपसंदी):
   • अपने आप से मुतास्सिर होना
   • कामयाबी ख़ुद को मंसूब करना, अल्लाह को नहीं
   • तकब्बुर की तरफ़ ले जाता है

6. सुमअह (शोहरत की चाहत):
   • नेक आमाल करना ताकि लोग सुनें
   • रिया की तरह लेकिन बात के ज़रिए
   • "जो शोहरत चाहे, अल्लाह उसे रुसवा कर देगा" (बुख़ारी)

7. ग़ुरूर (ख़ुद फ़रेबी):
   • अल्लाह के अज़ाब से झूठा इतमीनान
   • माफ़ी को यक़ीनी समझना
   • तौबा में ताख़ीर

8. अल्लाह के बारे में बदगुमानी:
   • सोचना कि अल्लाह माफ़ नहीं करेगा
   • उसकी रहमत से मायूसी
   • या उसके अज़ाब से बेख़ौफ़ होना

9. दुनिया की मुहब्बत:
   • जब दुनिया की मुहब्बत आख़िरत से ज़्यादा हो
   • "दुनिया की मुहब्बत तमाम गुनाहों की जड़ है" (बैहक़ी)

10. मुसलमानों से नफ़रत:
    • दिल में कीना रखना
    • उनका बुरा चाहना

दिल की पाकीज़गी कैसे करें:
• मुख़्लिसाना तौबा
• मुसलसल ज़िक्र अल्लाह
• ख़ुद एहतिसाबी
• इल्म हासिल करना
• अच्छी सोहबत
• तदब्बुर से क़ुरआन पढ़ना''',
        'arabic': '''ذنوب القلب

القلب ملك الجوارح. إذا فسد فسد الجسد كله.

قال النبي ﷺ: "ألا وإن في الجسد مضغة إذا صلحت صلح الجسد كله وإذا فسدت فسد الجسد كله ألا وهي القلب" (البخاري ومسلم)

كبائر القلب:

١. الشرك:
   • أعظم الذنوب
   • الشرك الخفي يشمل الرياء
   • "إِنَّ اللَّهَ لَا يَغْفِرُ أَن يُشْرَكَ بِهِ" (النساء: ٤٨)

٢. الكبر:
   • احتقار الناس
   • رد الحق
   • قال النبي ﷺ: "لا يدخل الجنة من كان في قلبه مثقال ذرة من كبر" (مسلم)

٣. الحسد:
   • تمني زوال النعمة عن الغير
   • الحزن لفرح الآخرين
   • "الحسد يأكل الحسنات كما تأكل النار الحطب" (أبو داود)

٤. الرياء:
   • العبادة لأجل الناس
   • الشرك الخفي
   • يبطل ثواب الأعمال

٥. العُجب:
   • الإعجاب بالنفس
   • نسبة الفضل للنفس لا لله
   • يؤدي إلى الكبر

٦. السمعة:
   • العمل ليسمع الناس به
   • كالرياء لكن بالقول
   • "من سمّع سمّع الله به" (البخاري)

٧. الغرور:
   • الأمن من مكر الله
   • الاتكال على المغفرة
   • تأخير التوبة

٨. سوء الظن بالله:
   • اليأس من رحمة الله
   • أو الأمن من عذابه

٩. حب الدنيا:
   • تقديم الدنيا على الآخرة
   • "حب الدنيا رأس كل خطيئة" (البيهقي)

١٠. بغض المسلمين:
    • الحقد والضغينة
    • تمني الشر لهم

تزكية القلب:
• التوبة الصادقة
• ذكر الله الدائم
• محاسبة النفس
• طلب العلم
• الصحبة الصالحة
• تلاوة القرآن بتدبر'''
      },
    },
    {
      'number': 9,
      'titleKey': 'gunha_fazilat_9_financial_sins',
      'title': 'Financial Sins',
      'titleUrdu': 'مالی گناہ',
      'titleHindi': 'माली गुनाह',
      'titleArabic': 'الذنوب المالية',
      'icon': Icons.money_off,
      'color': Colors.brown,
      'details': {
        'english': '''Financial Sins in Islam

Islam places great emphasis on earning halal wealth and spending it properly.

1. Riba (Interest/Usury):
   The Prophet ﷺ said: "Allah has cursed the one who consumes riba, the one who pays it, the one who writes it, and the two witnesses. They are all equal in sin." (Muslim)

   Types of Riba:
   • Bank interest (giving or taking)
   • Loan with added interest
   • Credit card interest
   • Late payment penalties

   "Allah will destroy riba and will give increase for charity." (Quran 2:276)

2. Consuming Orphan's Wealth:
   "Indeed, those who devour the property of orphans unjustly are only consuming fire into their bellies." (Quran 4:10)

   • Taking their inheritance
   • Mismanaging their property
   • Not returning their rights

3. Theft and Robbery:
   • Stealing others' property
   • Shoplifting
   • Embezzlement
   • Wage theft (not paying workers)

4. Bribery:
   The Prophet ﷺ cursed the one who gives bribes and the one who takes them. (Tirmidhi)
   • Bribing for contracts
   • Bribing officials
   • Accepting bribes

5. Cheating in Business:
   • Hiding defects in products
   • False advertising
   • Price manipulation
   • Cheating in weights and measures
   "Woe to those who give less [than due]" (Quran 83:1)

6. Gambling:
   "O you who believe! Intoxicants, gambling, stone altars, and divining arrows are abominations of Satan's doing." (Quran 5:90)
   • All forms of gambling
   • Lottery
   • Betting
   • Stock market gambling

7. Consuming Haram Income:
   • Income from haram businesses (alcohol, gambling, etc.)
   • Income from deception
   • Money obtained through lies

8. Extortion and Oppression:
   • Taking money by force
   • Unjust taxation
   • Forcing unfair contracts

9. Not Paying Zakat:
   A major sin that has severe punishment in the Hereafter.
   "Those who hoard gold and silver and spend it not in the way of Allah - give them tidings of a painful punishment." (Quran 9:34)

10. Wasting Wealth:
    "And do not spend wastefully. Indeed, the wasteful are brothers of the devils." (Quran 17:26-27)

How to Earn Halal:
• Verify income sources are halal
• Avoid doubtful transactions
• Pay dues and debts on time
• Give zakat and charity
• Be honest in all dealings''',
        'urdu': '''مالی گناہ

اسلام حلال کمائی اور صحیح خرچ پر بہت زور دیتا ہے۔

1. سود (ربا):
   نبی ﷺ نے فرمایا: "اللہ نے سود کھانے والے، دینے والے، لکھنے والے اور گواہوں پر لعنت فرمائی۔ سب گناہ میں برابر ہیں۔" (مسلم)

   سود کی اقسام:
   • بینک سود (لینا یا دینا)
   • سود پر قرض
   • کریڈٹ کارڈ سود
   • تاخیر کے جرمانے

   "اللہ سود کو مٹاتا ہے اور صدقے کو بڑھاتا ہے۔" (قرآن 2:276)

2. یتیم کا مال کھانا:
   "جو لوگ یتیموں کا مال ظلم سے کھاتے ہیں وہ اپنے پیٹوں میں آگ بھرتے ہیں۔" (قرآن 4:10)

3. چوری اور ڈکیتی:
   • دوسروں کا مال چرانا
   • دکان سے چوری
   • بیت المال میں خیانت
   • مزدوروں کی اجرت نہ دینا

4. رشوت:
   نبی ﷺ نے رشوت دینے والے اور لینے والے دونوں پر لعنت فرمائی۔ (ترمذی)

5. کاروبار میں دھوکا:
   • سامان کی خرابی چھپانا
   • جھوٹا اشتہار
   • قیمتوں میں دھوکا
   • ناپ تول میں کمی
   "ناپ میں کمی کرنے والوں کے لیے ہلاکت ہے" (قرآن 83:1)

6. جوا:
   "اے ایمان والو! شراب، جوا، بت اور فال کے تیر شیطانی کام ہیں۔" (قرآن 5:90)
   • ہر قسم کا جوا
   • لاٹری
   • شرط لگانا

7. حرام آمدنی:
   • حرام کاروبار سے کمائی
   • دھوکے سے کمائی
   • جھوٹ سے حاصل کردہ رقم

8. زبردستی اور ظلم:
   • زبردستی مال لینا
   • ناجائز ٹیکس
   • ناجائز معاہدے

9. زکوٰۃ نہ دینا:
   بڑا گناہ جس کی آخرت میں سخت سزا ہے۔

10. مال ضائع کرنا:
    "فضول خرچی نہ کرو۔ بے شک فضول خرچ شیطان کے بھائی ہیں۔" (قرآن 17:26-27)

حلال کیسے کمائیں:
• آمدنی کے ذرائع کی تصدیق کریں
• مشکوک لین دین سے بچیں
• قرض اور واجبات وقت پر ادا کریں
• زکوٰۃ اور صدقہ دیں
• تمام معاملات میں ایمانداری''',
        'hindi': '''माली गुनाह

इस्लाम हलाल कमाई और सही ख़र्च पर बहुत ज़ोर देता है।

1. सूद (रिबा):
   नबी ﷺ ने फ़रमाया: "अल्लाह ने सूद खाने वाले, देने वाले, लिखने वाले और गवाहों पर लानत फ़रमाई। सब गुनाह में बराबर हैं।" (मुस्लिम)

   सूद की क़िस्में:
   • बैंक सूद (लेना या देना)
   • सूद पर क़र्ज़
   • क्रेडिट कार्ड सूद
   • देरी के जुर्माने

   "अल्लाह सूद को मिटाता है और सदक़े को बढ़ाता है।" (क़ुरआन 2:276)

2. यतीम का माल खाना:
   "जो लोग यतीमों का माल ज़ुल्म से खाते हैं वो अपने पेटों में आग भरते हैं।" (क़ुरआन 4:10)

3. चोरी और डकैती:
   • दूसरों का माल चुराना
   • दुकान से चोरी
   • बैतुल माल में ख़यानत
   • मज़दूरों की उजरत न देना

4. रिश्वत:
   नबी ﷺ ने रिश्वत देने वाले और लेने वाले दोनों पर लानत फ़रमाई। (तिर्मिज़ी)

5. कारोबार में धोखा:
   • सामान की ख़राबी छुपाना
   • झूठा इश्तेहार
   • क़ीमतों में धोखा
   • नाप तौल में कमी
   "नाप में कमी करने वालों के लिए हलाकत है" (क़ुरआन 83:1)

6. जुआ:
   "ऐ ईमान वालो! शराब, जुआ, बुत और फ़ाल के तीर शैतानी काम हैं।" (क़ुरआन 5:90)
   • हर क़िस्म का जुआ
   • लॉटरी
   • शर्त लगाना

7. हराम आमदनी:
   • हराम कारोबार से कमाई
   • धोखे से कमाई
   • झूठ से हासिल करदा रक़म

8. ज़बरदस्ती और ज़ुल्म:
   • ज़बरदस्ती माल लेना
   • नाजाइज़ टैक्स
   • नाजाइज़ मुआहिदे

9. ज़कात न देना:
   बड़ा गुनाह जिसकी आख़िरत में सख़्त सज़ा है।

10. माल ज़ाया करना:
    "फ़ुज़ूल ख़र्ची न करो। बेशक फ़ुज़ूल ख़र्च शैतान के भाई हैं।" (क़ुरआन 17:26-27)

हलाल कैसे कमाएं:
• आमदनी के ज़राए की तस्दीक़ करें
• मशकूक लेन-देन से बचें
• क़र्ज़ और वाजिबात वक़्त पर अदा करें
• ज़कात और सदक़ा दें
• तमाम मुआमलात में ईमानदारी''',
        'arabic': '''الذنوب المالية

يؤكد الإسلام على كسب المال الحلال وإنفاقه بشكل صحيح.

١. الربا:
   قال النبي ﷺ: "لعن الله آكل الربا ومؤكله وكاتبه وشاهديه" (مسلم)

   أنواع الربا:
   • الفوائد البنكية
   • القرض بفائدة
   • فوائد البطاقات الائتمانية
   • غرامات التأخير

   "يَمْحَقُ اللَّهُ الرِّبَا وَيُرْبِي الصَّدَقَاتِ" (البقرة: ٢٧٦)

٢. أكل مال اليتيم:
   "إِنَّ الَّذِينَ يَأْكُلُونَ أَمْوَالَ الْيَتَامَىٰ ظُلْمًا إِنَّمَا يَأْكُلُونَ فِي بُطُونِهِمْ نَارًا" (النساء: ١٠)

٣. السرقة والسلب:
   • سرقة أموال الغير
   • الاختلاس
   • أكل أجور العمال

٤. الرشوة:
   لعن النبي ﷺ الراشي والمرتشي. (الترمذي)

٥. الغش في التجارة:
   • إخفاء عيوب السلع
   • الإعلانات الكاذبة
   • التلاعب بالأسعار
   • التطفيف في الكيل والميزان
   "وَيْلٌ لِّلْمُطَفِّفِينَ" (المطففين: ١)

٦. القمار:
   "إِنَّمَا الْخَمْرُ وَالْمَيْسِرُ وَالْأَنصَابُ وَالْأَزْلَامُ رِجْسٌ مِّنْ عَمَلِ الشَّيْطَانِ" (المائدة: ٩٠)

٧. الكسب الحرام:
   • الدخل من التجارة الحرام
   • المال المكتسب بالخداع

٨. الظلم والابتزاز:
   • أخذ المال بالقوة
   • الضرائب الظالمة

٩. منع الزكاة:
   كبيرة لها عقوبة شديدة في الآخرة.

١٠. تبذير المال:
    "وَلَا تُبَذِّرْ تَبْذِيرًا • إِنَّ الْمُبَذِّرِينَ كَانُوا إِخْوَانَ الشَّيَاطِينِ" (الإسراء: ٢٦-٢٧)

الكسب الحلال:
• التحقق من مصادر الدخل
• تجنب المعاملات المشبوهة
• سداد الديون في وقتها
• إخراج الزكاة والصدقة
• الصدق في كل المعاملات'''
      },
    },
    {
      'number': 10,
      'titleKey': 'gunha_fazilat_10_seeking_forgiveness',
      'title': 'Seeking Forgiveness',
      'titleUrdu': 'معافی مانگنا',
      'titleHindi': 'माफ़ी मांगना',
      'titleArabic': 'طلب المغفرة',
      'icon': Icons.healing,
      'color': Colors.teal,
      'details': {
        'english': '''Seeking Forgiveness (Istighfar)

Allah loves those who seek His forgiveness and repent sincerely.

"Say, 'O My servants who have transgressed against themselves, do not despair of the mercy of Allah. Indeed, Allah forgives all sins.'" (Quran 39:53)

Benefits of Istighfar:

1. Erasure of Sins:
   • Good deeds erase bad deeds
   • "Follow a bad deed with a good one and it will erase it" (Tirmidhi)

2. Relief from Difficulties:
   The Prophet ﷺ said: "Whoever makes istighfar constantly, Allah will provide for him relief from every difficulty." (Abu Dawud)

3. Increase in Sustenance:
   "Seek forgiveness of your Lord. Indeed, He is ever a Perpetual Forgiver. He will send [rain from] the sky upon you in showers and give you increase in wealth and children." (Quran 71:10-12)

4. Peace of Mind:
   • Removes guilt and anxiety
   • Brings inner peace
   • Strengthens connection with Allah

Best Duas for Forgiveness:

1. Sayyid al-Istighfar (Master of Seeking Forgiveness):
   "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ"

2. Simple Istighfar:
   "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ"
   "I seek Allah's forgiveness and repent to Him"

3. The Prophet's Istighfar:
   The Prophet ﷺ said: "By Allah, I seek forgiveness from Allah and repent to Him more than seventy times a day." (Bukhari)

Best Times for Istighfar:
• Last third of the night
• After obligatory prayers
• During prostration (sujud)
• Before sleeping
• After waking up

Conditions for Accepted Repentance:
1. Stop the sin immediately
2. Feel genuine regret
3. Firm intention never to return
4. If it involves others' rights, return them or seek their forgiveness

Allah's Mercy:
"Allah extends His Hand at night to accept the repentance of those who sinned during the day, and He extends His Hand during the day to accept the repentance of those who sinned at night." (Muslim)

Never despair of Allah's mercy!''',
        'urdu': '''معافی مانگنا (استغفار)

اللہ ان لوگوں سے محبت کرتا ہے جو اس سے معافی مانگتے اور سچی توبہ کرتے ہیں۔

"کہہ دو، اے میرے بندو جنہوں نے اپنی جانوں پر ظلم کیا، اللہ کی رحمت سے مایوس نہ ہو۔ بے شک اللہ سب گناہ معاف کر دیتا ہے۔" (قرآن 39:53)

استغفار کے فوائد:

1. گناہوں کا مٹنا:
   • نیکیاں برائیوں کو مٹا دیتی ہیں
   • "برائی کے بعد نیکی کرو وہ اسے مٹا دے گی" (ترمذی)

2. مشکلات سے نجات:
   نبی ﷺ نے فرمایا: "جو مسلسل استغفار کرے، اللہ اسے ہر مشکل سے نکال دے گا۔" (ابو داؤد)

3. رزق میں اضافہ:
   "اپنے رب سے معافی مانگو۔ بے شک وہ بہت معاف کرنے والا ہے۔ وہ تم پر موسلادھار بارش برسائے گا اور مال اور اولاد میں اضافہ کرے گا۔" (قرآن 71:10-12)

4. ذہنی سکون:
   • جرم اور پریشانی دور ہوتی ہے
   • اندرونی سکون آتا ہے
   • اللہ سے تعلق مضبوط ہوتا ہے

معافی کی بہترین دعائیں:

1. سید الاستغفار:
   "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ..."

2. آسان استغفار:
   "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ"
   "میں اللہ سے معافی مانگتا ہوں اور اس کی طرف رجوع کرتا ہوں"

3. نبی ﷺ کا استغفار:
   نبی ﷺ نے فرمایا: "اللہ کی قسم، میں روزانہ ستر سے زیادہ بار اللہ سے استغفار کرتا ہوں۔" (بخاری)

استغفار کے بہترین اوقات:
• رات کا آخری تہائی حصہ
• فرض نمازوں کے بعد
• سجدے میں
• سونے سے پہلے
• اٹھنے کے بعد

توبہ کی شرائط:
1. فوری گناہ چھوڑنا
2. سچی ندامت
3. دوبارہ نہ کرنے کا پختہ ارادہ
4. اگر کسی کا حق مارا ہے تو واپس کرنا

اللہ کی رحمت:
"اللہ رات کو ہاتھ پھیلاتا ہے تاکہ دن کے گناہگار توبہ کریں، اور دن کو ہاتھ پھیلاتا ہے تاکہ رات کے گناہگار توبہ کریں۔" (مسلم)

اللہ کی رحمت سے کبھی مایوس نہ ہوں!''',
        'hindi': '''माफ़ी मांगना (इस्तिग़फ़ार)

अल्लाह उन लोगों से मुहब्बत करता है जो उससे माफ़ी मांगते और सच्ची तौबा करते हैं।

"कह दो, ऐ मेरे बंदो जिन्होंने अपनी जानों पर ज़ुल्म किया, अल्लाह की रहमत से मायूस न हो। बेशक अल्लाह सब गुनाह माफ़ कर देता है।" (क़ुरआन 39:53)

इस्तिग़फ़ार के फ़वाइद:

1. गुनाहों का मिटना:
   • नेकियां बुराइयों को मिटा देती हैं
   • "बुराई के बाद नेकी करो वो उसे मिटा देगी" (तिर्मिज़ी)

2. मुश्किलात से निजात:
   नबी ﷺ ने फ़रमाया: "जो मुसलसल इस्तिग़फ़ार करे, अल्लाह उसे हर मुश्किल से निकाल देगा।" (अबू दाऊद)

3. रिज़्क़ में इज़ाफ़ा:
   "अपने रब से माफ़ी मांगो। बेशक वो बहुत माफ़ करने वाला है। वो तुम पर मूसलाधार बारिश बरसाएगा और माल और औलाद में इज़ाफ़ा करेगा।" (क़ुरआन 71:10-12)

4. ज़हनी सुकून:
   • जुर्म और परेशानी दूर होती है
   • अंदरूनी सुकून आता है
   • अल्लाह से ताल्लुक़ मज़बूत होता है

माफ़ी की बेहतरीन दुआएं:

1. सय्यिद अल-इस्तिग़फ़ार:
   "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ..."

2. आसान इस्तिग़फ़ार:
   "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ"
   "मैं अल्लाह से माफ़ी मांगता हूं और उसकी तरफ़ रुजू करता हूं"

3. नबी ﷺ का इस्तिग़फ़ार:
   नबी ﷺ ने फ़रमाया: "अल्लाह की क़सम, मैं रोज़ाना सत्तर से ज़्यादा बार अल्लाह से इस्तिग़फ़ार करता हूं।" (बुख़ारी)

इस्तिग़फ़ार के बेहतरीन औक़ात:
• रात का आख़िरी तिहाई हिस्सा
• फ़र्ज़ नमाज़ों के बाद
• सज्दे में
• सोने से पहले
• उठने के बाद

तौबा की शराइत:
1. फ़ौरन गुनाह छोड़ना
2. सच्ची नदामत
3. दोबारा न करने का पुख़्ता इरादा
4. अगर किसी का हक़ मारा है तो वापस करना

अल्लाह की रहमत:
"अल्लाह रात को हाथ फैलाता है ताकि दिन के गुनाहगार तौबा करें, और दिन को हाथ फैलाता है ताकि रात के गुनाहगार तौबा करें।" (मुस्लिम)

अल्लाह की रहमत से कभी मायूस न हों!''',
        'arabic': '''طلب المغفرة (الاستغفار)

الله يحب من يستغفره ويتوب إليه توبة نصوحاً.

"قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا" (الزمر: ٥٣)

فوائد الاستغفار:

١. محو الذنوب:
   • الحسنات يذهبن السيئات
   • "أتبع السيئة الحسنة تمحها" (الترمذي)

٢. الفرج من الكروب:
   قال النبي ﷺ: "من لزم الاستغفار جعل الله له من كل هم فرجاً" (أبو داود)

٣. زيادة الرزق:
   "اسْتَغْفِرُوا رَبَّكُمْ إِنَّهُ كَانَ غَفَّارًا • يُرْسِلِ السَّمَاءَ عَلَيْكُم مِّدْرَارًا • وَيُمْدِدْكُم بِأَمْوَالٍ وَبَنِينَ" (نوح: ١٠-١٢)

٤. السكينة والطمأنينة:
   • زوال الهم والقلق
   • راحة النفس
   • قوة الصلة بالله

أفضل أدعية الاستغفار:

١. سيد الاستغفار:
   "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ..."

٢. الاستغفار البسيط:
   "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ"

٣. استغفار النبي ﷺ:
   قال النبي ﷺ: "والله إني لأستغفر الله وأتوب إليه في اليوم أكثر من سبعين مرة" (البخاري)

أفضل أوقات الاستغفار:
• الثلث الأخير من الليل
• بع�� الصلوات المفروضة
• في السجود
• قبل النوم
• بعد الاستيقاظ

شروط التوبة المقبولة:
١. الإقلاع عن الذنب فوراً
٢. الندم الصادق
٣. العزم على عدم العودة
٤. رد المظالم إلى أهلها

رحمة الله:
"إن الله يبسط يده بالليل ليتوب مسيء النهار ويبسط يده بالنهار ليتوب مسيء الليل" (مسلم)

لا تيأسوا من رحمة الله!'''
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
                  itemCount: _gunhaTopics.length,
                  itemBuilder: (context, index) {
                    final topic = _gunhaTopics[index];
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
                              context.tr('gunha_fazilat'),
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
          categoryKey: 'category_gunha_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
