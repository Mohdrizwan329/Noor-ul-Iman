import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class JannatFazilatScreen extends StatefulWidget {
  const JannatFazilatScreen({super.key});

  @override
  State<JannatFazilatScreen> createState() => _JannatFazilatScreenState();
}

class _JannatFazilatScreenState extends State<JannatFazilatScreen> {
  String _selectedLanguage = 'english';

  final List<Map<String, dynamic>> _jannatTopics = [
    {
      'number': 1,
      'titleKey': 'jannat_fazilat_1_description_of_paradise',
      'title': 'Description of Paradise',
      'titleUrdu': 'جنت کا وصف',
      'titleHindi': 'जन्नत का वस्फ़',
      'titleArabic': 'وصف الجنة',
      'icon': Icons.landscape,
      'color': Colors.green,
      'details': {
        'english': '''Description of Paradise (Jannat)

Paradise is the eternal abode of bliss that Allah has prepared for the believers.

What No Eye Has Seen:
• The Prophet ﷺ said: "Allah says: 'I have prepared for My righteous servants what no eye has seen, no ear has heard, and no human heart has ever conceived.'" (Sahih Bukhari)
• The beauty of Paradise is beyond human imagination
• Even the lowest person in Paradise will have ten times the world

The Gates of Paradise:
• Paradise has eight gates
• "And those who feared their Lord will be led to Paradise in groups until, when they reach it while its gates have been opened and its keepers say: Peace be upon you." (Quran 39:73)
• Each gate is for specific deeds (prayer, fasting, charity, jihad, etc.)
• The distance between two gates is like 40 years of travel

Rivers of Paradise:
• "In it are rivers of water unaltered, rivers of milk the taste of which never changes, rivers of wine delicious to those who drink, and rivers of purified honey." (Quran 47:15)
• The main river is Al-Kawthar, given to Prophet Muhammad ﷺ
• Its banks are of gold and pearls, its soil is musk

The Soil and Buildings:
• The soil of Paradise is musk
• Its bricks are of gold and silver
• Its mortar is fragrant musk
• Its pebbles are pearls and gems

Width and Expanse:
• "Race toward forgiveness from your Lord and a Garden whose width is like the width of the heavens and earth." (Quran 57:21)
• It encompasses the heavens and earth in width
• Prepared for the righteous believers''',
        'urdu': '''جنت کا وصف

جنت ابدی سکون کا گھر ہے جو اللہ نے مومنین کے لیے تیار کیا ہے۔

جو کسی آنکھ نے نہیں دیکھا:
• نبی کریم ﷺ نے فرمایا: "اللہ فرماتا ہے: 'میں نے اپنے نیک بندوں کے لیے وہ تیار کیا ہے جو کسی آنکھ نے نہیں دیکھا، کسی کان نے نہیں سنا، اور کسی دل نے تصور نہیں کیا۔'" (صحیح بخاری)
• جنت کی خوبصورتی انسانی تصور سے باہر ہے
• جنت کا سب سے کم درجے والا بھی دنیا سے دس گنا پائے گا

جنت کے دروازے:
• جنت کے آٹھ دروازے ہیں
• "اور جو لوگ اپنے رب سے ڈرتے تھے وہ گروہوں میں جنت کی طرف لے جائے جائیں گے یہاں تک کہ جب وہ پہنچیں گے اور اس کے دروازے کھلے ہوں گے اور اس کے داروغہ کہیں گے: تم پر سلام۔" (قرآن 39:73)
• ہر دروازہ مخصوص عمل کے لیے ہے (نماز، روزہ، صدقہ، جہاد وغیرہ)
• دو دروازوں کے درمیان فاصلہ 40 سال کے سفر جتنا ہے

جنت کی نہریں:
• "اس میں صاف پانی کی نہریں ہیں، دودھ کی نہریں جن کا ذائقہ نہیں بدلتا، شراب کی نہریں جو پینے والوں کے لیے لذیذ ہیں، اور صاف شہد کی نہریں۔" (قرآن 47:15)
• سب سے بڑی نہر الکوثر ہے جو نبی کریم ﷺ کو دی گئی
• اس کے کنارے سونے اور موتیوں کے ہیں، اس کی مٹی مشک ہے

مٹی اور عمارتیں:
• جنت کی مٹی مشک ہے
• اس کی اینٹیں سونے اور چاندی کی ہیں
• اس کا گارا خوشبودار مشک ہے
• اس کے کنکر موتی اور جواہر ہیں

چوڑائی اور وسعت:
• "اپنے رب کی مغفرت اور جنت کی طرف دوڑو جس کی چوڑائی آسمانوں اور زمین جتنی ہے۔" (قرآن 57:21)
• یہ آسمانوں اور زمین کو چوڑائی میں گھیرتی ہے
• نیک مومنین کے لیے تیار کی گئی ہے''',
        'hindi': '''जन्नत का वस्फ़

जन्नत अबदी सुकून का घर है जो अल्लाह ने मोमिनीन के लिए तैयार किया है।

जो किसी आंख ने नहीं देखा:
• नबी करीम ﷺ ने फ़रमाया: "अल्लाह फ़रमाता है: 'मैंने अपने नेक बंदों के लिए वो तैयार किया है जो किसी आंख ने नहीं देखा, किसी कान ने नहीं सुना, और किसी दिल ने तसव्वुर नहीं किया।'" (सहीह बुख़ारी)
• जन्नत की ख़ूबसूरती इंसानी तसव्वुर से बाहर है
• जन्नत का सबसे कम दर्जे वाला भी दुनिया से दस गुना पाएगा

जन्नत के दरवाज़े:
• जन्नत के आठ दरवाज़े हैं
• "और जो लोग अपने रब से डरते थे वो गुरोहों में जन्नत की तरफ़ ले जाए जाएंगे यहां तक कि जब वो पहुंचेंगे और उसके दरवाज़े खुले होंगे और उसके दारोग़ा कहेंगे: तुम पर सलाम।" (क़ुरआन 39:73)
• हर दरवाज़ा मख़सूस अमल के लिए है (नमाज़, रोज़ा, सदक़ा, जिहाद वग़ैरह)
• दो दरवाज़ों के दरमियान फ़ासला 40 साल के सफ़र जितना है

जन्नत की नहरें:
• "इसमें साफ़ पानी की नहरें हैं, दूध की नहरें जिनका ज़ायक़ा नहीं बदलता, शराब की नहरें जो पीने वालों के लिए लज़ीज़ हैं, और साफ़ शहद की नहरें।" (क़ुरआन 47:15)
• सबसे बड़ी नहर अल-कौसर है जो नबी करीम ﷺ को दी गई
• इसके किनारे सोने और मोतियों के हैं, इसकी मिट्टी मुश्क है

मिट्टी और इमारतें:
• जन्नत की मिट्टी मुश्क है
• इसकी ईंटें सोने और चांदी की हैं
• इसका गा��ा ख़ुशबूदार मुश्क है
• इसके कंकर मोती और जवाहिर हैं

चौड़ाई और वुसअत:
• "अपने रब की मग़फ़िरत और जन्नत की तरफ़ दौड़ो जिसकी चौड़ाई आसमानों और ज़मीन जितनी है।" (क़ुरआन 57:21)
• यह आसमानों और ज़मीन को चौड़ाई में घेरती है
• नेक मोमिनीन के लिए तैयार की गई है''',
        'arabic': '''وصف الجنة

الجنة دار النعيم الأبدي التي أعدها الله للمتقين.

عظمة الجنة:
• "فَلَا تَعْلَمُ نَفْسٌ مَّا أُخْفِيَ لَهُم مِّن قُرَّةِ أَعْيُنٍ" (سورة السجدة: 17)
• عرضها السموات والأرض
• لا عين رأت ولا أذن سمعت ولا خطر على قلب بشر
• نعيم دائم لا ينفد ولا يزول
• "وَفِيهَا مَا تَشْتَهِيهِ الْأَنفُسُ وَتَلَذُّ الْأَعْيُنُ" (سورة الزخرف: 71)

بناء الجنة:
• لبنة من ذهب ولبنة من فضة
• ملاطها المسك الأذفر
• حصباؤها اللؤلؤ والياقوت
• ترابها الزعفران
• قصور من الذهب والفضة

أنهار الجنة:
• أنهار من ماء غير آسن
• أنهار من لبن لم يتغير طعمه
• أنهار من خمر لذة للشاربين
• أنهار من عسل مصفى
• "مَّثَلُ الْجَنَّةِ الَّتِي وُعِدَ الْمُتَّقُونَ" (سورة محمد: 15)

أشجار الجنة:
• شجرة طوبى: يسير الراكب في ظلها مائة عام
• سدرة المنتهى: في السماء السابعة
• ثمارها دانية قريبة
• لا شوك فيها ولا ضر

نعيم لا ينقطع:
• "أُكُلُهَا دَائِمٌ وَظِلُّهَا" (سورة الرعد: 35)
• لا مرض ولا موت
• لا حزن ولا هم
• لا نصب ولا تعب
• "وَمَا هُم مِّنْهَا بِمُخْرَجِينَ" (سورة الحجر: 48)

الخلود الأبدي:
• "خَالِدِينَ فِيهَا أَبَدًا" (سورة التوبة: 100)
• لا يخرج منها أحد
• لا يموت أهلها
• نعيم دائم إلى الأبد'''
      },
    },
    {
      'number': 2,
      'titleKey': 'jannat_fazilat_2_levels_of_paradise',
      'title': 'Levels of Paradise',
      'titleUrdu': 'جنت کے درجات',
      'titleHindi': 'जन्नत के दर्जात',
      'titleArabic': 'درجات الجنة',
      'icon': Icons.stairs,
      'color': Colors.blue,
      'details': {
        'english': '''Levels of Paradise (Darajat)

Paradise has various levels, and believers will be placed according to their deeds.

One Hundred Levels:
• The Prophet ﷺ said: "Paradise has one hundred levels, and the distance between each two levels is like the distance between the heavens and the earth." (Sahih Bukhari)
• These levels were prepared by Allah for those who strive in His cause
• The highest level is Firdaus, directly beneath the Throne of Allah

Difference Between Levels:
• "They will have degrees according to what they did, and your Lord is not unaware of what they do." (Quran 6:132)
• The people of the higher levels will be seen by those below like a bright star
• The difference in reward is based on faith and righteous deeds

Categories of People:
1. As-Sabiqun (The Forerunners):
   • Those who competed in doing good
   • They will be in the highest levels
   • "And the forerunners, the forerunners - those are the ones brought near." (Quran 56:10-11)

2. Ashab al-Yameen (Companions of the Right):
   • The righteous believers
   • They will be in gardens of delight
   • Blessed with the bounties of Paradise

3. The Prophets and Martyrs:
   • Special elevated ranks
   • Prophets in the highest positions
   • Martyrs honored with special status

Rooms and Mansions:
• "But those who feared their Lord will have rooms, above them rooms built high." (Quran 39:20)
• Transparent rooms where inside can be seen from outside
• The Prophet ﷺ described seeing rooms in Paradise

Increasing in Levels:
• Through extra worship (nawafil)
• Through patience in trials
• Through good character
• Through beneficial knowledge''',
        'urdu': '''جنت کے درجات

جنت کے مختلف درجات ہیں اور مومنین کو ان کے اعمال کے مطابق رکھا جائے گا۔

سو درجات:
• نبی کریم ﷺ نے فرمایا: "جنت کے سو درجات ہیں اور ہر دو درجوں کے درمیان فاصلہ آسمان اور زمین کے درمیان فاصلے جتنا ہے۔" (صحیح بخاری)
• یہ درجات اللہ نے اپنی راہ میں جدوجہد کرنے والوں کے لیے تیار کیے
• سب سے اونچا درجہ فردوس ہے جو عرش کے نیچے ہے

درجوں میں فرق:
• "ان کے درجات ہوں گے ان کے اعمال کے مطابق اور تمہارا رب ان کے کاموں سے بے خبر نہیں۔" (قرآن 6:132)
• اونچے درجوں والے نیچے والوں کو چمکتے ستارے کی طرح دکھائی دیں گے
• اجر میں فرق ایمان اور نیک اعمال پر مبنی ہے

لوگوں کی قسمیں:
1. السابقون (آگے بڑھنے والے):
   • جنہوں نے نیکی میں سبقت کی
   • وہ سب سے اونچے درجوں میں ہوں گے
   • "اور سبقت لے جانے والے سبقت لے جانے والے۔ یہی ہیں جو قریب کیے گئے۔" (قرآن 56:10-11)

2. اصحاب الیمین (دائیں ہاتھ والے):
   • نیک مومنین
   • وہ نعمتوں کے باغوں میں ہوں گے
   • جنت کی نعمتوں سے نوازے گئے

3. انبیاء اور شہداء:
   • خاص بلند مرتبے
   • انبیاء سب سے اونچے مقامات پر
   • شہداء خاص مقام سے نوازے گئے

کمرے اور محل:
• "لیکن جو اپنے رب سے ڈرے ان کے لیے کمرے ہوں گے جن کے اوپر کمرے بنائے گئے ہیں۔" (قرآن 39:20)
• شفاف کمرے جن کا اندر باہر سے دکھائی دیتا ہے
• نبی کریم ﷺ نے جنت میں کمرے دیکھنے کا ذکر فرمایا

درجات میں اضافہ:
• نفل عبادت سے
• آزمائشوں میں صبر سے
• اچھے اخلاق سے
• نفع بخش علم سے''',
        'hindi': '''जन्नत के दर्जात

जन्नत के मुख़्तलिफ़ दर्जात हैं और मोमिनीन को उनके आमाल के मुताबिक़ रखा जाएगा।

सौ दर्जात:
• नबी करीम ﷺ ने फ़रमाया: "जन्नत के सौ दर्जात हैं और हर दो दर्जों के दरमियान फ़ासला आसमान और ज़मीन के दरमियान फ़ासले जितना है।" (सहीह बुख़ारी)
• यह दर्जात अल्लाह ने अपनी राह में जिद्दोजहद करने वालों के लिए तैयार किए
• सबसे ऊंचा दर्जा फ़िरदौस है जो अर्श के नीचे है

दर्जों में फ़र्क़:
• "उनके दर्जात होंगे उनके आमाल के मुताबिक़ और तुम्हारा रब उनके कामों से बेख़बर नहीं।" (क़ुरआन 6:132)
• ऊंचे दर्जों वाले नीचे वालों को चमकते सितारे की तरह दिखाई देंगे
• अज्र में फ़र्क़ ईमान और नेक आमाल पर मबनी है

लोगों की क़िस्में:
1. अस-साबिक़ून (आगे बढ़ने वाले):
   • जिन्होंने नेकी में सबक़त की
   • वो सबसे ऊंचे दर्जों में होंगे
   • "और सबक़त ले जाने वाले सबक़त ले जाने वाले। यही हैं जो क़रीब किए गए।" (क़ुरआन 56:10-11)

2. असहाबुल यमीन (दाएं हाथ वाले):
   • नेक मोमिनीन
   • वो नेमतों के बाग़ों में होंगे
   • जन्नत की नेमतों से नवाज़े गए

3. अंबिया और शुहदा:
   • ख़ास बुलंद मर्तबे
   • अंबिया सबसे ऊंचे मक़ामात पर
   • शुहदा ख़ास मक़ाम से नवाज़े गए

कमरे और महल:
• "लेकिन जो अपने रब से डरे उनके लिए कमरे होंगे जिनके ऊपर कमरे बनाए गए हैं।" (क़ुरआन 39:20)
• शफ़्फ़ाफ़ कमरे जिनका अंदर बाहर से दिखाई देता है
• नबी करीम ﷺ ने जन्नत में कमरे देखने का ज़िक्र फ़रमाया

दर्जात में इज़ाफ��ा:
• नफ़्ल इबादत से
• आज़माइशों में सब्र से
• अच्छे अख़्लाक़ से
• नफ़ाबख़्श इल्म से''',
        'arabic': '''درجات الجنة

للجنة درجات ومنازل متفاوتة.

عدد درجات الجنة:
• مائة درجة
• ما بين كل درجتين كما بين السماء والأرض
• "وَلِكُلٍّ دَرَجَاتٌ مِّمَّا عَمِلُوا" (سورة الأنعام: 132)
• أعدها الله للمجاهدين في سبيله

الفردوس الأعلى:
• أعلى درجات الجنة
• "أُولَٰئِكَ هُمُ الْوَارِثُونَ * الَّذِينَ يَرِثُونَ الْفِرْدَوْسَ" (سورة المؤمنون: 10-11)
• سقفها عرش الرحمن
• منها تفجر أنهار الجنة الأربعة
• قال النبي ﷺ: "إذا سألتم الله فسألوه الفردوس" (البخاري)

درجة الوسيلة:
• أعلى منزلة في الجنة
• لا تنبغي إلا لعبد واحد
• هي للنبي محمد ﷺ
• من سأل له الوسيلة حلت له الشفاعة

جنات عدن:
• "جَنَّاتُ عَدْنٍ يَدْخُلُونَهَا" (سورة فاطر: 33)
• جنات الإقامة الدائمة
• تفتح لهم أبوابها
• يحلون فيها من أساور من ذهب

الغرف العالية:
• "لَٰكِنِ الَّذِينَ اتَّقَوْا رَبَّهُمْ لَهُمْ غُرَفٌ" (سورة الزمر: 20)
• غرف مبنية فوق غرف
• تجري من تحتها الأنهار
• للذين اتقوا ربهم

التفاضل في الجنة:
• يتفاضل أهل الجنة بحسب أعمالهم
• "وَلِكُلٍّ دَرَجَاتٌ مِّمَّا عَمِلُوا" (سورة الأحقاف: 19)
• الأنبياء في أعلى الدرجات
• ثم الصديقون والشهداء والصالحون

طريق الوصول للدرجات العليا:
• الإيمان الكامل والعمل الصالح
• الجهاد في سبيل الله
• بر الوالدين وصلة الرحم
• كثرة الصلاة والصيام
• الصدقة والإحسان إلى الخلق'''
      },
    },
    {
      'number': 3,
      'titleKey': 'jannat_fazilat_3_deeds_leading_to_jannat',
      'title': 'Deeds Leading to Jannat',
      'titleUrdu': 'جنت میں لے جانے والے اعمال',
      'titleHindi': 'जन्नत में ले जाने वाले आमाल',
      'titleArabic': 'أعمال توصل للجنة',
      'icon': Icons.checklist,
      'color': Colors.amber,
      'details': {
        'english': '''Deeds That Lead to Paradise

Allah has shown us clear paths to Paradise through His Book and the Sunnah.

The Five Pillars:
• Shahadah (Declaration of Faith) - The key to Paradise
• Salah (Prayer) - "Between a man and disbelief is abandoning prayer"
• Zakah (Charity) - Purifies wealth and soul
• Sawm (Fasting) - Has a special gate called Ar-Rayyan
• Hajj (Pilgrimage) - "An accepted Hajj has no reward except Paradise"

From the Hadith:
• The Prophet ﷺ said: "Whoever believes in Allah and His Messenger, establishes prayer, and fasts Ramadan, it is a right upon Allah to admit him into Paradise." (Sahih Bukhari)

Good Character:
• "The most beloved of you to me and the closest to me on the Day of Resurrection are those with the best character." (Tirmidhi)
• Truthfulness leads to Paradise
• Kindness to parents is a cause for entering Jannah

Specific Deeds Mentioned:
1. Saying "La ilaha illallah" sincerely from the heart
2. Praying 12 rak'ahs of Sunnah daily (house in Paradise)
3. Building a mosque (house in Paradise)
4. Visiting the sick
5. Maintaining family ties
6. Caring for orphans
7. Being patient in trials

Remembrance of Allah:
• "Gardens of Paradise, so graze therein." (When asked about them, Prophet ﷺ said: "Circles of dhikr")
• SubhanAllah, Alhamdulillah, La ilaha illallah, Allahu Akbar
• Recitation of Quran - Each letter brings rewards

Jihad in the Path of Allah:
• "Paradise is under the shades of swords"
• Striving with wealth, time, and effort
• Fighting one's own desires (jihad an-nafs)

Small Deeds with Great Rewards:
• Smiling at a brother
• Removing harm from the road
• A good word is charity
• Even half a date given in charity''',
        'urdu': '''جنت میں لے جانے والے اعمال

اللہ نے اپنی کتاب اور سنت کے ذریعے جنت کے واضح راستے دکھائے ہیں۔

پانچ ستون:
• شہادت (ایمان کا اقرار) - جنت کی کنجی
• نماز - "آدمی اور کفر کے درمیان نماز چھوڑنا ہے"
• زکوٰۃ - مال اور روح کو پاک کرتی ہے
• روزہ - اس کا خاص دروازہ ریان ہے
• حج - "مقبول حج کا ثواب صرف جنت ہے"

حدیث سے:
• نبی کریم ﷺ نے فرمایا: "جو اللہ اور اس کے رسول پر ایمان لائے، نماز قائم کرے اور رمضان کے روزے رکھے، اللہ پر حق ہے کہ اسے جنت میں داخل کرے۔" (صحیح بخاری)

اچھے اخلاق:
• "تم میں سے مجھے سب سے زیادہ محبوب اور قیامت کے دن سب سے قریب وہ ہیں جن کے اخلاق سب سے اچھے ہیں۔" (ترمذی)
• سچائی جنت کی طرف لے جاتی ہے
• والدین سے حسن سلوک جنت میں داخلے کا سبب ہے

مخصوص اعمال:
1. دل سے خالصانہ "لا الہ الا اللہ" کہنا
2. روزانہ 12 رکعت سنت پڑھنا (جنت میں گھر)
3. مسجد بنانا (جنت میں گھر)
4. بیمار کی عیادت کرنا
5. رشتے داری نبھانا
6. یتیموں کی کفالت کرنا
7. آزمائشوں میں صبر کرنا

اللہ کا ذکر:
• "جنت کے باغات میں چراؤ۔" (جب پوچھا گیا تو نبی ﷺ نے فرمایا: "ذکر کی مجالس")
• سبحان اللہ، الحمد للہ، لا الہ الا اللہ، اللہ اکبر
• قرآن کی تلاوت - ہر حرف پر ثواب

اللہ کی راہ میں جہاد:
• "جنت تلواروں کے سائے میں ہے"
• مال، وقت اور محنت سے جدوجہد
• اپنی خواہشات سے لڑنا (جہاد النفس)

چھوٹے اعمال بڑے ثواب:
• بھائی کو دیکھ کر مسکرانا
• راستے سے تکلیف دہ چیز ہٹانا
• اچھا بول صدقہ ہے
• آدھی کھجور کا صدقہ بھی''',
        'hindi': '''जन्नत में ले जाने वाले आमाल

अल्लाह ने अपनी किताब और सुन्नत के ज़रीए जन्नत के वाज़ेह रास्ते दिखाए हैं।

पांच सुतून:
• शहादत (ईमान का इक़रार) - जन्नत की कुंजी
• नमाज़ - "आदमी और कुफ़्र के दरमियान नमाज़ छोड़ना है"
• ज़कात - माल और रूह को पाक करती है
• रोज़ा - इसका ख़ास दरवाज़ा रय्यान है
• हज - "मक़बूल हज का सवाब सिर्फ़ जन्नत है"

हदीस से:
• नबी करीम ﷺ ने फ़रमाया: "जो अल्लाह और उसके रसूल पर ईमान लाए, नमाज़ क़ायम करे और रमज़ान के रोज़े रखे, अल्लाह पर हक़ है कि उसे जन्नत में दाख़िल करे।" (सहीह बुख़ारी)

अच्छे अख़्लाक़:
• "तुम में से मुझे सबसे ज़्यादा महबूब और क़यामत के दिन सबसे क़रीब वो हैं जिनके अख़्लाक़ सबसे अच्छे हैं।" (तिर्मिज़ी)
• सच्चाई जन्नत की तरफ़ ले जाती है
• वालिदैन से हुस्न सुलूक जन्नत में दाख़िले का सबब है

मख़सूस आमाल:
1. दिल से ख़ालिसाना "ला इलाहा इल्लल्लाह" कहना
2. रोज़ाना 12 रकअत सुन्नत पढ़ना (जन्नत में घर)
3. मस्जिद बनाना (जन्नत में घर)
4. बीमार की इयादत करना
5. रिश्तेदारी निभाना
6. यतीमों की किफ़ालत करना
7. आज़माइशों में सब्र करना

अल्लाह का ज़िक्र:
• "जन्नत के बाग़ों में चराओ।" (जब पूछा गया तो नबी ﷺ ने फ़रमाया: "ज़िक्र की मजलिसें")
• सुब्हानल्लाह, अलहम्दुलिल्लाह, ला इलाहा इल्लल्लाह, अल्लाहु अकबर
• क़ुरआन की तिलावत - हर हर्फ़ पर सवाब

अल्लाह की राह में जिहाद:
• "जन्नत तलवारों के साए में है"
• माल, वक़्त और मेहनत से जिद्दोजहद
• अपनी ख़्वाहिशात से लड़ना (जिहाद अन-नफ़्स)

छोटे आमाल बड़े सवाब:
• भाई को देखकर मुस्कुराना
• रास्ते से तकलीफ़द��ह चीज़ हटाना
• अच्छा बोल सदक़ा है
• आधी खजूर का सदक़ा भी''',
        'arabic': '''أعمال توصل للجنة

الأعمال الصالحة التي تدخل الجنة.

الإيمان والتوحيد:
• "مَن كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ" (البخاري)
• لا إله إلا الله محمد رسول الله
• قال النبي ﷺ: "من قال لا إله إلا الله دخل الجنة" (مسلم)
• الإخلاص في التوحيد

الصلوات الخمس:
• "مَا مِنْ مُسْلِمٍ يُصَلِّي لِلَّهِ كُلَّ يَوْمٍ" (مسلم)
• المحافظة عليها في أوقاتها
• صلاة الجماعة في المسجد
• الخشوع فيها

الصيام:
• "الصِّيَامُ جُنَّةٌ" (البخاري)
• صيام رمضان إيماناً واحتساباً
• صيام التطوع: الاثنين والخميس
• صيام ستة من شوال

الزكاة والصدقة:
• "وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ" (سورة البقرة: 43)
• إخراج الزكاة من المال
• الصدقة على الفقراء والمساكين
• الإنفاق في سبيل الله

الحج والعمرة:
• "الْحَجُّ الْمَبْرُورُ لَيْسَ لَهُ جَزَاءٌ إِلَّا الْجَنَّةُ" (البخاري)
• أداء فريضة الحج
• كثرة العمرة
• الطواف والسعي

بر الوالدين:
• "رِضَا الرَّبِّ فِي رِضَا الْوَالِدِ" (الترمذي)
• الإحسان إليهما
• طاعتهما في المعروف
• الدعاء لهما

الجهاد في سبيل الله:
• "إِنَّ اللَّهَ اشْتَرَىٰ مِنَ الْمُؤْمِنِينَ أَنفُسَهُمْ" (سورة التوبة: 111)
• القتال لتكون كلمة الله هي العليا
• الشهادة في سبيل الله
• حراسة الثغور

حسن الخلق:
• قال النبي ﷺ: "أنا زعيم ببيت في ربض الجنة لمن حسن خلقه" (أبو داود)
• الصدق والأمانة
• الحلم والصبر
• العفو والمسامحة'''
      },
    },
    {
      'number': 4,
      'titleKey': 'jannat_fazilat_4_people_of_paradise',
      'title': 'People of Paradise',
      'titleUrdu': 'جنتی لوگ',
      'titleHindi': 'जन्नती लोग',
      'titleArabic': 'أهل الجنة',
      'icon': Icons.groups,
      'color': Colors.purple,
      'details': {
        'english': '''The People of Paradise (Ahl al-Jannah)

Allah has described those who will enter Paradise in the Quran and Hadith.

Characteristics of Jannah's People:
• "Indeed, the righteous will be among gardens and springs, accepting what their Lord has given them. Indeed, they were before that doers of good." (Quran 51:15-16)
• They feared Allah in private and public
• They spent in charity during ease and hardship
• They controlled their anger and forgave people

The First to Enter:
• The Prophet ﷺ said: "I will be the first to knock at the gate of Paradise."
• The poor Muslims will enter 500 years before the rich
• The martyrs will enter with special honor

Categories of People Guaranteed Paradise:
1. The Prophets (peace be upon them all)
2. The Ten Companions promised Paradise
3. The martyrs (shuhada)
4. Those who die while performing Hajj
5. Those who raise daughters properly
6. Those who care for orphans

Physical Description:
• They will enter at age 33 (the age of Prophet Isa AS)
• They will be in the form of their father Adam - 60 cubits tall
• Beautiful appearance like Prophet Yusuf (AS)
• No hair on their bodies, no illness, no aging

The Last to Enter:
• The Prophet ﷺ described a man who will be the last to enter Paradise
• He will crawl out of Hellfire and be given ten times the world
• Even he will think he is the most blessed

Women of Paradise:
• Righteous believing women will be queens of Paradise
• Superior even to the Houris
• Will be reunited with their righteous husbands
• Khadijah, Fatimah, Maryam, Asiyah - leaders of women in Paradise

Children:
• Children who died young will be in Paradise
• They will intercede for their parents
• Prophet Ibrahim (AS) cares for the children''',
        'urdu': '''جنتی لوگ

اللہ نے قرآن اور حدیث میں ان لوگوں کا ذکر کیا ہے جو جنت میں داخل ہوں گے۔

جنت والوں کی خصوصیات:
• "بیشک متقی باغوں اور چشموں میں ہوں گے، اپنے رب کی دی ہوئی چیزیں لیتے ہوئے۔ بیشک وہ اس سے پہلے نیکی کرنے والے تھے۔" (قرآن 51:15-16)
• وہ خلوت اور جلوت میں اللہ سے ڈرتے تھے
• انہوں نے خوشحالی اور تنگی میں خرچ کیا
• وہ غصے کو قابو کرتے اور لوگوں کو معاف کرتے تھے

سب سے پہلے داخل ہونے والے:
• نبی کریم ﷺ نے فرمایا: "میں سب سے پہلے جنت کے دروازے پر دستک دوں گا۔"
• غریب مسلمان امیروں سے 500 سال پہلے داخل ہوں گے
• شہداء خاص عزت کے ساتھ داخل ہوں گے

جنت کی ضمانت والے لوگ:
1. انبیاء (علیہم السلام)
2. عشرہ مبشرہ صحابہ
3. شہداء
4. حج کرتے ہوئے وفات پانے والے
5. بیٹیوں کی اچھی پرورش کرنے والے
6. یتیموں کی کفالت کرنے والے

جسمانی حلیہ:
• وہ 33 سال کی عمر میں داخل ہوں گے (عیسیٰ علیہ السلام کی عمر)
• وہ اپنے باپ آدم کی شکل میں ہوں گے - 60 ہاتھ لمبے
• یوسف علیہ السلام جیسی خوبصورت شکل
• جسم پر بال نہیں، بیماری نہیں، بڑھاپا نہیں

آخری داخل ہونے والا:
• نبی کریم ﷺ نے ایک آدمی کا ذکر کیا جو آخر میں جنت میں داخل ہوگا
• وہ جہنم سے رینگتا ہوا نکلے گا اور دنیا سے دس گنا پائے گا
• وہ بھی سمجھے گا کہ وہ سب سے زیادہ نعمت والا ہے

جنت کی عورتیں:
• نیک مومن عورتیں جنت کی ملکائیں ہوں گی
• حوروں سے بھی افضل
• اپنے نیک شوہروں سے ملیں گی
• خدیجہ، فاطمہ، مریم، آسیہ - جنت میں عورتوں کی سردار''',
        'hindi': '''जन्नती लोग

अल्लाह ने क़ुरआन और हदीस में उन लोगों का ज़िक्र किया है जो जन्नत में दाख़िल होंगे।

जन्नत वालों की ख़ुसूसियात:
• "बेशक मुत्तक़ी बाग़ों और चश्मों में होंगे, अपने रब की दी हुई चीज़ें लेते हुए। बेशक वो इससे पहले नेकी करने वाले थे।" (क़ुरआन 51:15-16)
• वो ख़लवत और जलवत में अल्लाह से डरते थे
• उन्होंने ख़ुशहाली और तंगी में ख़र्च किया
• वो ग़ुस्से को क़ाबू करते और लोगों को माफ़ करते थे

सबसे पहले दाख़िल होने वाले:
• नबी करीम ﷺ ने फ़रमाया: "मैं सबसे पहले जन्नत के दरवाज़े पर दस्तक दूंगा।"
• ग़रीब मुसलमान अमीरों से 500 साल पहले दाख़िल होंगे
• शुहदा ख़ास इज़्ज़त के साथ दाख़िल होंगे

जन्नत की ज़मानत वाले लोग:
1. अंबिया (अलैहिमुस्सलाम)
2. अशरा मुबश्शरा सहाबा
3. शुहदा
4. हज करते हुए वफ़ात पाने वाले
5. बेटियों की अच्छी परवरिश करने वाले
6. यतीमों की किफ़ालत करने वाले

जिस्मानी हुलिया:
• वो 33 साल की उम्र में दाख़िल होंगे (ईसा अलैहिस्सलाम की उम्र)
• वो अपने बाप आदम की शक्ल में होंगे - 60 हाथ लंबे
• यूसुफ़ अलैहिस्सलाम जैसी ख़ूबसूरत शक्ल
• जिस्म पर बाल नहीं, बीमारी नहीं, बुढ़ापा नहीं

आख़िरी दाख़िल होने वाला:
• नबी करीम ﷺ ने एक आदमी का ज़िक्र किया जो आख़िर में जन्नत में दाख़िल होगा
• वो जहन्नम से रेंगता हुआ निकलेगा और दुनिया से दस गुना पाएगा
• वो भी समझेगा कि वो सबसे ज़्यादा नेमत वाला है

जन्नत की औरतें:
• नेक मोमिन औरतें जन्नत की मलिकाएं होंगी
• हूरों से भी अफ़ज़ल
• अपने नेक शौहरों से मिलेंगी
• ख़दीजा, फ़ातिमा, मरयम, आसिया - जन्नत में औरतों की सरदार''',
        'arabic': '''أهل الجنة

صفات أهل الجنة ومن يدخلونها.

المؤمنون الموحدون:
• "إِنَّ الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ" (سورة البقرة: 82)
• الذين وحدوا الله ولم يشركوا به شيئاً
• آمنوا بالله ورسله واليوم الآخر
• عملوا الصالحات

المتقون:
• "تِلْكَ الْجَنَّةُ الَّتِي نُورِثُ مِنْ عِبَادِنَا مَن كَانَ تَقِيًّا" (سورة مريم: 63)
• الذين اتقوا الله في السر والعلن
• حافظوا على الصلوات
• اجتنبوا الكبائر

السبعون ألفاً:
• يدخلون الجنة بغير حساب ولا عذاب
• "هُمُ الَّذِينَ لَا يَسْتَرْقُونَ وَلَا يَتَطَيَّرُونَ" (البخاري)
• على ربهم يتوكلون
• مع كل واحد سبعون ألفاً

الصديقون والشهداء:
• "مَعَ الَّذِينَ أَنْعَمَ اللَّهُ عَلَيْهِم مِّنَ النَّبِيِّينَ وَالصِّدِّيقِينَ" (سورة النساء: 69)
• أبو بكر الصديق رضي الله عنه
• الشهداء في سبيل الله
• في أعلى الدرجات

الفقراء المهاجرون:
• يدخلون الجنة قبل الأغنياء بخمسمائة عام
• الفقراء الصابرون المحتسبون
• "فُقَرَاءُ الْمُهَاجِرِينَ" (سورة الحشر: 8)

المحسنون:
• "لِّلَّذِينَ أَحْسَنُوا الْحُسْنَىٰ وَزِيَادَةٌ" (سورة يونس: 26)
• الذين أحسنوا العبادة
• أحسنوا إلى الخلق
• الحسنى: الجنة، الزيادة: النظر إلى وجه الله

النساء الصالحات:
• "وَمَن يَعْمَلْ مِنَ الصَّالِحَاتِ مِن ذَكَرٍ أَوْ أُنثَىٰ" (سورة النحل: 97)
• المؤمنات القانتات
• الحافظات للغيب
• المطيعات لأزواجهن

الأطفال:
• أطفال المؤمنين في الجنة
• يكونون مع آبائهم
• "وَالَّذِينَ آمَنُوا وَاتَّبَعَتْهُمْ ذُرِّيَّتُهُم" (سورة الطور: 21)'''
      },
    },
    {
      'number': 5,
      'titleKey': 'jannat_fazilat_5_blessings_in_paradise',
      'title': 'Blessings in Paradise',
      'titleUrdu': 'جنت کی نعمتیں',
      'titleHindi': 'जन्नत की नेमतें',
      'titleArabic': 'نعيم الجنة',
      'icon': Icons.card_giftcard,
      'color': Colors.teal,
      'details': {
        'english': '''Blessings and Rewards in Paradise

The blessings of Paradise are unimaginable and eternal.

Seeing Allah:
• "Some faces that Day will be radiant, looking at their Lord." (Quran 75:22-23)
• This is the greatest blessing of Paradise
• The people of Paradise will see Allah every Friday
• No blessing compares to the joy of seeing the Creator

Physical Pleasures:
• Food: Whatever they desire, instantly available
• Drink: Pure drinks that cause no intoxication or headache
• Clothing: Garments of silk, adorned with gold and pearls
• Housing: Magnificent palaces and gardens

The Houris (Hur al-Ayn):
• "And with them will be women limiting their glances, with large eyes." (Quran 37:48)
• Beautiful companions created for the believers
• Pure and devoted spouses

Servants and Comfort:
• "There will circulate among them young boys made eternal." (Quran 56:17)
• Servants who serve with grace and beauty
• No fatigue, no boredom, no discomfort

Eternal Youth:
• No aging, no sickness, no death
• "They will not hear therein ill speech or commission of sin - only a saying: Peace, peace." (Quran 56:25-26)
• Eternal happiness without any sorrow

Social Blessings:
• Reunion with family members who were righteous
• Meeting the Prophets and the Companions
• No jealousy, no hatred, no negative feelings
• Brotherhood and love among all residents

The Tree of Tuba:
• A massive tree that provides shade for all of Paradise
• Its trunk is made of gold
• Clothing of Paradise comes from its fruits

Ultimate Satisfaction:
• Allah will ask: "Are you satisfied?" They will say: "How could we not be satisfied?"
• Allah will say: "I give you My pleasure and will never be angry with you after this."
• This is the ultimate success mentioned in the Quran''',
        'urdu': '''جنت کی نعمتیں اور انعامات

جنت کی نعمتیں ناقابل تصور اور ابدی ہیں۔

اللہ کا دیدار:
• "کچھ چہرے اس دن تازہ ہوں گے، اپنے رب کو دیکھتے ہوئے۔" (قرآن 75:22-23)
• یہ جنت کی سب سے بڑی نعمت ہے
• جنتی ہر جمعہ اللہ کو دیکھیں گے
• خالق کو دیکھنے کی خوشی سے کوئی نعمت موازنہ نہیں کر سکتی

جسمانی لذتیں:
• کھانا: جو چاہیں فوری دستیاب
• پینا: پاک مشروبات جو نشہ یا سر درد نہیں کرتے
• لباس: ریشم کے لباس سونے اور موتیوں سے مزین
• رہائش: شاندار محلات اور باغات

حوریں (حور العین):
• "اور ان کے ساتھ نگاہیں جھکائے بڑی آنکھوں والیاں ہوں گی۔" (قرآن 37:48)
• مومنوں کے لیے پیدا کی گئی خوبصورت ساتھی
• پاک اور وفادار بیویاں

خادم اور آرام:
• "ان کے گرد ہمیشہ جوان لڑکے چکر لگائیں گے۔" (قرآن 56:17)
• خادم جو خوبصورتی سے خدمت کریں
• نہ تھکاوٹ، نہ بوریت، نہ تکلیف

ابدی جوانی:
• نہ بڑھاپا، نہ بیماری، نہ موت
• "وہ وہاں نہ بیہودہ باتیں سنیں گے نہ گناہ - صرف سلام سلام کہا جائے گا۔" (قرآن 56:25-26)
• بغیر کسی غم کے ابدی خوشی

معاشرتی نعمتیں:
• نیک خاندان والوں سے ملاقات
• انبیاء اور صحابہ سے ملاقات
• نہ حسد، نہ نفرت، نہ منفی جذبات
• تمام رہائشیوں میں بھائی چارہ اور محبت

طوبیٰ کا درخت:
• ایک بہت بڑا درخت جو پوری جنت کو سایہ دیتا ہے
• اس کا تنا سونے کا ہے
• جنت کے کپڑے اس کے پھلوں سے آتے ہیں

آخری سکون:
• اللہ پوچھے گا: "کیا تم راضی ہو؟" وہ کہیں گے: "ہم کیسے راضی نہ ہوں؟"
• اللہ فرمائے گا: "میں تمہیں اپنی رضا دیتا ہوں اور اس کے بعد کبھی ناراض نہیں ہوں گا۔"
• یہ قرآن میں ذکر کردہ آخری کامیابی ہے''',
        'hindi': '''जन्नत की नेमतें और इनामात

जन्नत की नेमतें नाक़ाबिले तसव्वुर और अबदी हैं।

अल्लाह का दीदार:
• "कुछ चेहरे उस दिन ताज़ा होंगे, अपने रब को देखते हुए।" (क़ुरआन 75:22-23)
• यह जन्नत की सबसे बड़ी नेमत है
• जन्नती हर जुमा अल्लाह को देखेंगे
• ख़ालिक़ को देखने की ख़ुशी से कोई नेमत मुवाज़ना नहीं कर सकती

जिस्मानी लज़्ज़तें:
• खाना: जो चाहें फ़ौरी दस्तयाब
• पीना: पाक मशरूबात जो नशा या सर दर्द नहीं करते
• लिबास: रेशम के लिबास सोने और मोतियों से मुज़य्यन
• रिहाइश: शानदार महलात और बाग़ात

हूरें (हूर अल-ऐन):
• "और उनके साथ निगाहें झुकाए बड़ी आंखों वालियां होंगी।" (क़ुरआन 37:48)
• मोमिनों के लिए पैदा की गई ख़ूबसूरत साथी
• पाक और वफ़ादार बीवियां

ख़ादिम और आराम:
• "उनके गिर्द हमेशा जवान लड़के चक्कर लगाएंगे।" (क़ुरआन 56:17)
• ख़ादिम जो ख़ूबसूरती से ख़िदमत करें
• न थकावट, न बोरियत, न तकलीफ़

अबदी जवानी:
• न बुढ़ापा, न बीमारी, न मौत
• "वो वहां न बेहूदा बातें सुनेंगे न गुनाह - सिर्फ़ सलाम सलाम कहा जाएगा।" (क़ुरआन 56:25-26)
• बग़ैर किसी ग़म के अबदी ख़ुशी

मुआशरती नेमतें:
• नेक ख़ानदान वालों से मुलाक़ात
• अंबिया और सहाबा से मुलाक़ात
• न हसद, न नफ़रत, न मनफ़ी जज़्बात
• तमाम रिहाइशियों में भाईचारा और मोहब्बत

तूबा का दरख़्त:
• एक बहुत बड़ा दरख़्त जो पूरी जन्नत को साया देता है
• इसका तना सोने का है
• जन्नत के कपड़े इसके फलों से आते हैं

आख़िरी सुकून:
• अल्लाह पूछेगा: "क्या तुम राज़ी हो?" वो कहेंगे: "हम कैसे राज़ी न हों?"
• अल्लाह फ़रमाएगा: "मैं तुम्हें अपनी रज़ा देता हूं और इसके बाद कभी नाराज़ नहीं होऊंगा।"
• यह क़ुरआन में ज़िक्र करदा आख़ि��ी कामयाबी है''',
        'arabic': '''نعيم الجنة

النعم والملذات في الجنة.

الطعام في الجنة:
• "وَفَاكِهَةٍ مِّمَّا يَتَخَيَّرُونَ * وَلَحْمِ طَيْرٍ مِّمَّا يَشْتَهُونَ" (سورة الواقعة: 20-21)
• فواكه كثيرة لا تنقطع ولا تمنع
• لحوم الطير وما يشتهون
• طعام لذيذ لا يشبع منه

الشراب في الجنة:
• أنهار من خمر لذة للشاربين
• لا فيها غول ولا هم عنها ينزفون
• "يُسْقَوْنَ مِن رَّحِيقٍ مَّخْتُومٍ" (سورة المطففين: 25)
• ماء من تسنيم ومن كافور
• ماء من زنجبيل

اللباس والزينة:
• "يُحَلَّوْنَ فِيهَا مِنْ أَسَاوِرَ مِن ذَهَبٍ وَلُؤْلُؤًا" (سورة الحج: 23)
• ثياب من سندس وإستبرق
• أساور من ذهب وفضة
• لباسهم فيها حرير

الحور العين:
• "كَأَنَّهُنَّ الْيَاقُوتُ وَالْمَرْجَانُ" (سورة الرحمن: 58)
• واسعات العيون
• "حُورٌ مَّقْصُورَاتٌ فِي الْخِيَامِ" (سورة الرحمن: 72)
• لم يطمثهن إنس قبلهم ولا جان

القصور والخيام:
• قصور من ذهب وفضة
• خيمة من لؤلؤة مجوفة
• "لَهُم مَّا يَشَاءُونَ فِيهَا" (سورة النحل: 31)
• غرف يجري من تحتها الأنهار

الخدم والولدان:
• "يَطُوفُ عَلَيْهِمْ وِلْدَانٌ مُّخَلَّدُونَ" (سورة الواقعة: 17)
• كأنهم لؤلؤ منثور
• يخدمون أهل الجنة

الأمن والسلام:
• "لَا يَمَسُّهُمْ فِيهَا نَصَبٌ" (سورة الحجر: 48)
• لا مرض ولا موت
• لا حزن ولا هم
• "سَلَامٌ قَوْلًا مِّن رَّبٍّ رَّحِيمٍ" (سورة يس: 58)'''
      },
    },
    {
      'number': 6,
      'titleKey': 'jannat_fazilat_6_highest_paradise_firdaus',
      'title': 'Highest Paradise - Firdaus',
      'titleUrdu': 'جنت الفردوس',
      'titleHindi': 'जन्नत अल-फ़िरदौस',
      'titleArabic': 'أعلى الجنة: الفردوس',
      'icon': Icons.stars,
      'color': Colors.orange,
      'details': {
        'english': '''Jannat al-Firdaus - The Highest Paradise

Firdaus is the highest and most noble level of Paradise.

Location and Status:
• The Prophet ﷺ said: "When you ask Allah for Paradise, ask Him for Firdaus, for it is the highest part of Paradise, in the middle of Paradise, and from it spring the rivers of Paradise, and above it is the Throne of the Most Merciful." (Sahih Bukhari)
• It is directly beneath Allah's Throne
• The most honored and blessed location

Who Will Be in Firdaus:
• The Prophets (peace be upon them)
• The truthful (siddiqeen)
• The martyrs (shuhada)
• The righteous (saliheen)
• "And whoever obeys Allah and the Messenger - those will be with the ones upon whom Allah has bestowed favor of the prophets, the steadfast affirmers of truth, the martyrs and the righteous." (Quran 4:69)

Special Features:
• Rivers originate from Firdaus and flow to lower levels
• The closest proximity to Allah
• The greatest blessings and rewards
• Home of the elite of believers

How to Achieve Firdaus:
• Sincere faith (iman) with righteous deeds
• Excellence in worship (ihsan)
• Striving in the path of Allah
• Patience in trials and hardships
• Competing in good deeds

The Prophet's Instruction:
• When making dua for Paradise, specifically ask for Firdaus
• Don't settle for asking for just "Paradise"
• Aim for the highest level
• "Ask Allah for Firdaus" - direct command of the Prophet ﷺ

Dua for Firdaus:
• "O Allah, I ask You for Paradise (Jannah) and I ask You for Firdaus, the highest level of Paradise."
• "O Allah, make me among those who inherit Firdaus, where they will abide eternally."
• Make this dua regularly, especially in prostration

The Ultimate Goal:
• Firdaus should be the aim of every believer
• Work for it through consistent worship
• Never give up hope in Allah's mercy
• The path is clear - follow the Quran and Sunnah''',
        'urdu': '''جنت الفردوس - سب سے اونچی جنت

فردوس جنت کا سب سے اونچا اور معزز درجہ ہے۔

مقام اور حیثیت:
• نبی کریم ﷺ نے فرمایا: "جب تم اللہ سے جنت مانگو تو فردوس مانگو، کیونکہ یہ جنت کا سب سے اونچا حصہ ہے، جنت کے درمیان میں ہے، اس سے جنت کی نہریں نکلتی ہیں، اور اس کے اوپر رحمان کا عرش ہے۔" (صحیح بخاری)
• یہ اللہ کے عرش کے عین نیچے ہے
• سب سے معزز اور بابرکت مقام

فردوس میں کون ہوگا:
• انبیاء (علیہم السلام)
• صدیقین
• شہداء
• صالحین
• "اور جو اللہ اور رسول کی اطاعت کرے وہ ان لوگوں کے ساتھ ہوں گے جن پر اللہ نے انعام کیا انبیاء، صدیقین، شہداء اور صالحین سے۔" (قرآن 4:69)

خاص خصوصیات:
• نہریں فردوس سے نکلتی ہیں اور نیچے کے درجوں میں بہتی ہیں
• اللہ سے سب سے قریب
• سب سے بڑی نعمتیں اور انعامات
• مومنوں کے چنیدہ لوگوں کا گھر

فردوس کیسے حاصل کریں:
• نیک اعمال کے ساتھ مخلصانہ ایمان
• عبادت میں احسان
• اللہ کی راہ میں جدوجہد
• آزمائشوں اور مشکلات میں صبر
• نیک کاموں میں مقابلہ

نبی کریم ﷺ کی ہدایت:
• جنت کے لیے دعا کرتے وقت خاص طور پر فردوس مانگیں
• صرف "جنت" مانگنے پر اکتفا نہ کریں
• سب سے اونچے درجے کی نیت کریں
• "فردوس مانگو" - نبی ﷺ کا براہ راست حکم

فردوس کے لیے دعا:
• "اے اللہ، میں تجھ سے جنت مانگتا ہوں اور فردوس مانگتا ہوں، جنت کا سب سے اونچا درجہ۔"
• "اے اللہ، مجھے ان میں سے بنا جو فردوس کے وارث ہوں، جہاں وہ ہمیشہ رہیں گے۔"
• یہ دعا باقاعدگی سے کریں، خاص طور پر سجدے میں

آخری مقصد:
• فردوس ہر مومن کا ہدف ہونا چاہیے
• مسلسل عبادت سے اس کے لیے کام کریں
• اللہ کی رحمت سے کبھی مایوس نہ ہوں
• راستہ واضح ہے - قرآن اور سنت کی پیروی کریں''',
        'hindi': '''जन्नत अल-फ़िरदौस - सबसे ऊंची जन्नत

फ़िरदौस जन्नत का सबसे ऊंचा और मुअज़्ज़ज़ दर्जा है।

मक़ाम और हैसियत:
• नबी करीम ﷺ ने फ़रमाया: "जब तुम अल्लाह से जन्नत मांगो तो फ़िरदौस मांगो, क्योंकि यह जन्नत का सबसे ऊंचा हिस्सा है, जन्नत के दरमियान में है, इससे जन्नत की नहरें निकलती हैं, और इसके ऊपर रहमान का अर्श है।" (सहीह बुख़ारी)
• यह अल्लाह के अर्श के ऐन नीचे है
• सबसे मुअज़्ज़ज़ और बाबरकत मक़ाम

फ़िरदौस में कौन होगा:
• अंबिया (अलैहिमुस्सलाम)
• सिद्दीक़ीन
• शुहदा
• सालिहीन
• "और जो अल्लाह और रसूल की इताअत करे वो उन लोगों के साथ होंगे जिन पर अल्लाह ने इनाम किया अंबिया, सिद्दीक़ीन, शुहदा और सालिहीन से।" (क़ुरआन 4:69)

ख़ास ख़ुसूसियात:
• नहरें फ़िरदौस से निकलती हैं और नीचे के दर्जों में बहती हैं
• अल्लाह से सबसे क़रीब
• सबसे बड़ी नेमतें और इनामात
• मोमिनों के चुनिंदा लोगों का घर

फ़िरदौस कैसे हासिल करें:
• नेक आमाल के साथ मुख़्लिसाना ईमान
• इबादत में एहसान
• अल्लाह की राह में जिद्दोजहद
• आज़माइशों और मुश्किलात में सब्र
• नेक कामों में मुक़ाबला

नबी करीम ﷺ की हिदायत:
• जन्नत के लिए दुआ करते वक़्त ख़ास तौर पर फ़िरदौस मांगें
• सिर्फ़ "जन्नत" मांगने पर इक्तिफ़ा न करें
• सबसे ऊंचे दर्जे की नीयत करें
• "फ़िरदौस मांगो" - नबी ﷺ का बराहेरास्त हुक्म

फ़िरदौस के लिए दुआ:
• "ऐ अल्लाह, मैं तुझसे जन्नत मांगता हूं और फ़िरदौस मांगता हूं, जन्नत का सबसे ऊंचा दर्ज��।"
• "ऐ अल्लाह, मुझे उनमें से बना जो फ़िरदौस के वारिस हों, जहां वो हमेशा रहेंगे।"
• यह दुआ बाक़ायदगी से करें, ख़ास तौर पर सज्दे में

आख़िरी मक़सद:
• फ़िरदौस हर मोमिन का हदफ़ होना चाहिए
• मुसलसल इबादत से इसके लिए काम करें
• अल्लाह की रहमत से कभी मायूस न हों
• रास्ता वाज़ेह है - क़ुरआन और सुन्नत की पैरवी करें''',
        'arabic': '''أعلى الجنة: الفردوس

جنة الفردوس أعلى منازل الجنة.

فضل الفردوس:
• أعلى الجنة وأوسطها
• "أُولَٰئِكَ هُمُ الْوَارِثُونَ * الَّذِينَ يَرِثُونَ الْفِرْدَوْسَ" (سورة المؤمنون: 10-11)
• قال النبي ﷺ: "إذا سألتم الله فسألوه الفردوس، فإنه أوسط الجنة وأعلى الجنة" (البخاري)
• سقفها عرش الرحمن

مميزات الفردوس:
• منها تفجر أنهار الجنة الأربعة
• فوقها عرش الرحمن
• أهلها يرون ربهم أكثر من غيرهم
• نعيمها أعظم من سائر الجنة

من يدخل الفردوس:
• المؤمنون الكاملون
• أصحاب الأعمال العظيمة
• "الَّذِينَ هُمْ لِأَمَانَاتِهِمْ وَعَهْدِهِمْ رَاعُونَ" (سورة المؤمنون: 8)
• المحافظون على الصلوات

صفات أهل الفردوس:
• الخاشعون في صلاتهم
• المعرضون عن اللغو
• المؤدون للزكاة
• الحافظون لفروجهم
• الراعون للأمانات والعهود

النظر إلى وجه الله:
• أعظم نعيم في الفردوس
• "وُجُوهٌ يَوْمَئِذٍ نَّاضِرَةٌ * إِلَىٰ رَبِّهَا نَاظِرَةٌ" (سورة القيامة: 22-23)
• يرون ربهم كما يرون القمر ليلة البدر
• لا يضامون في رؤيته

الدعاء لدخول الفردوس:
• اللهم إني أسألك الفردوس الأعلى
• ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة
• اللهم اجعلني من أهل الفردوس الأعلى
• الإكثار من الأعمال الصالحة

طريق الفردوس:
• الإيمان الكامل واليقين
• العمل الصالح والإخلاص
• المحافظة على الصلوات
• بر الوالدين وصلة الرحم
• الجهاد في سبيل الله
• حسن الخلق والإحسان إلى الخلق'''
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
          context.tr('jannat'),
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
              itemCount: _jannatTopics.length,
              itemBuilder: (context, index) {
                final topic = _jannatTopics[index];
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
    final title = context.tr(topic['titleKey'] ?? 'jannat_fazilat');
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
                            context.tr('jannat_fazilat'),
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
    final titleKey = topic['titleKey'] ?? 'jannat_fazilat';
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
          categoryKey: 'category_jannat_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
