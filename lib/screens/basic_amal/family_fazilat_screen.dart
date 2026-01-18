import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class FamilyFazilatScreen extends StatefulWidget {
  const FamilyFazilatScreen({super.key});

  @override
  State<FamilyFazilatScreen> createState() => _FamilyFazilatScreenState();
}

class _FamilyFazilatScreenState extends State<FamilyFazilatScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Family - Rights & Duties',
    'urdu': 'خاندان - حقوق اور فرائض',
    'hindi': 'ख़ानदान - हुक़ूक़ और फ़राइज़',
  };

  final List<Map<String, dynamic>> _familyTopics = [
    {
      'number': 1,
      'title': 'Rights of Parents',
      'titleUrdu': 'والدین کے حقوق',
      'titleHindi': 'वालिदैन के हुक़ूक़',
      'icon': Icons.elderly,
      'color': Colors.orange,
      'details': {
        'english': '''Rights of Parents

Parents hold the most honored position after Allah and His Messenger.

Their Status in Islam:
• "And your Lord has decreed that you not worship except Him, and to parents, good treatment." (Quran 17:23)
• Obedience to parents is next to obedience to Allah
• Being good to parents is among the best deeds
• The Prophet ﷺ said: "The pleasure of the Lord is in the pleasure of the parents, and the anger of the Lord is in the anger of the parents." (Tirmidhi)

Rights and Duties:
• Speak to them with respect and kindness
• Never say "Uff" (any word of disrespect) to them
• Serve them with humility and love
• Pray for them: "My Lord, have mercy upon them as they brought me up when I was small." (Quran 17:24)
• Provide for their needs in old age
• Seek their permission before major decisions

Special Status of Mother:
• A man asked the Prophet ﷺ: "Who is most deserving of my good companionship?" He said: "Your mother." The man asked: "Then who?" He said: "Your mother." The man asked again: "Then who?" He said: "Your mother." The man asked again: "Then who?" He said: "Your father." (Bukhari & Muslim)
• Paradise lies under the feet of mothers
• Three times more right than the father

Consequences of Disobedience:
• Among the major sins in Islam
• "And fear Allah through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer." (Quran 4:1)
• Dua of an oppressed parent is accepted
• Punishment in this life and the hereafter

When Obedience is Not Required:
• Only if they command you to commit shirk (associate partners with Allah)
• "But if they endeavor to make you associate with Me that of which you have no knowledge, do not obey them but accompany them in this world with appropriate kindness." (Quran 31:15)
• Even then, treat them with kindness and respect''',
        'urdu': '''والدین کے حقوق

والدین کو اللہ اور اس کے رسول کے بعد سب سے معزز مقام حاصل ہے۔

اسلام میں ان کی حیثیت:
• "اور تمہارے رب نے فیصلہ کر دیا ہے کہ اس کے سوا کسی کی عبادت نہ کرو اور والدین کے ساتھ اچھا سلوک کرو۔" (قرآن 17:23)
• والدین کی اطاعت اللہ کی اطاعت کے بعد ہے
• والدین کے ساتھ اچھا سلوک بہترین اعمال میں سے ہے
• نبی کریم ﷺ نے فرمایا: "رب کی رضا والدین کی رضا میں ہے اور رب کی ناراضگی والدین کی ناراضگی میں ہے۔" (ترمذی)

حقوق اور فرائض:
• ان سے احترام اور مہربانی سے بات کریں
• کبھی "اف" (کوئی بھی ناپسندیدہ لفظ) نہ کہیں
• عاجزی اور محبت سے ان کی خدمت کریں
• ان کے لیے دعا کریں: "اے رب، ان پر رحم فرما جیسے انہوں نے مجھے بچپن میں پالا۔" (قرآن 17:24)
• بڑھاپے میں ان کی ضروریات پوری کریں
• بڑے فیصلوں سے پہلے ان کی اجازت لیں

ماں کا خاص مقام:
• ایک آدمی نے نبی ﷺ سے پوچھا: "میرے اچھے سلوک کا سب سے زیادہ حقدار کون ہے؟" آپ نے فرمایا: "تمہاری ماں۔" اس نے پوچھا: "پھر کون؟" فرمایا: "تمہاری ماں۔" اس نے پھر پوچھا: "پھر کون؟" فرمایا: "تمہاری ماں۔" اس نے پھر پوچھا: "پھر کون؟" فرمایا: "تمہارا باپ۔" (بخاری و مسلم)
• جنت ماؤں کے قدموں تلے ہے
• باپ سے تین گنا زیادہ حق

نافرمانی کے نتائج:
• اسلام میں کبیرہ گناہوں میں سے
• "اور اللہ سے ڈرو جس کے نام پر تم ایک دوسرے سے مانگتے ہو اور رحموں سے۔ بیشک اللہ تم پر نگران ہے۔" (قرآن 4:1)
• مظلوم والدین کی دعا قبول ہوتی ہے
• دنیا اور آخرت میں سزا

جب اطاعت ضروری نہیں:
• صرف اگر وہ شرک (اللہ کے ساتھ شریک ٹھہرانے) کا حکم دیں
• "لیکن اگر وہ تمہیں کوشش کریں کہ میرے ساتھ شرک کرو جس کا تمہیں علم نہیں، تو ان کی اطاعت نہ کرو لیکن دنیا میں ان کے ساتھ بھلائی سے رہو۔" (قرآن 31:15)
• پھر بھی ان کے ساتھ مہربانی اور احترام سے پیش آئیں''',
        'hindi': '''वालिदैन के हुक़ूक़

वालिदैन को अल्लाह और उसके रसूल के बाद सबसे मुअज़्ज़ज़ मक़ाम हासिल है।

इस्लाम में उनकी हैसियत:
• "और तुम्हारे रब ने फ़ैसला कर दिया है कि उसके सिवा किसी की इबादत न करो और वालिदैन के साथ अच्छा सुलूक करो।" (क़ुरआन 17:23)
• वालिदैन की इताअत अल्लाह की इताअत के बाद है
• वालिदैन के साथ अच्छा सुलूक बेहतरीन आमाल में से है
• नबी करीम ﷺ ने फ़रमाया: "रब की रज़ा वालिदैन की रज़ा में है और रब की नाराज़गी वालिदैन की नाराज़गी में है।" (तिर्मिज़ी)

हुक़ूक़ और फ़राइज़:
• उनसे एहतराम और मेहरबानी से बात करें
• कभी "उफ़" (कोई भी नापसंदीदा लफ़्ज़) न कहें
• आजिज़ी और मोहब्बत से उनकी ख़िदमत करें
• उनके लिए दुआ करें: "ऐ रब, उन पर रहम फ़रमा जैसे उन्होंने मुझे बचपन में पाला।" (क़ुरआन 17:24)
• बुढ़ापे में उनकी ज़रूरतें पूरी करें
• बड़े फ़ैसलों से पहले उनकी इजाज़त लें

मां का ख़ास मक़ाम:
• एक आदमी ने न���ी ﷺ से पूछा: "मेरे अच्छे सुलूक का सबसे ज़्यादा हक़दार कौन है?" आपने फ़रमाया: "तुम्हारी मां।" उसने पूछा: "फिर कौन?" फ़रमाया: "तुम्हारी मां।" उसने फिर पूछा: "फिर कौन?" फ़रमाया: "तुम्हारी मां।" उसने फिर पूछा: "फिर कौन?" फ़रमाया: "तुम्हारा बाप।" (बुख़ारी व मुस्लिम)
• जन्नत माओं के क़दमों तले है
• बाप से तीन गुना ज़्यादा हक़

नाफ़रमानी के नतीजे:
• इस्लाम में कबीरा गुनाहों में से
• "और अल्लाह से डरो जिसके नाम पर तुम एक दूसरे से मांगते हो और रहमों से। बेशक अल्लाह तुम पर निगरान है।" (क़ुरआन 4:1)
• मज़लूम वालिदैन की दुआ क़बूल होती है
• दुनिया और आख़िरत में सज़ा

जब इताअत ज़रूरी नहीं:
• सिर्फ़ अगर वो शिर्क (अल्लाह के साथ शरीक ठहराने) का हुक्म दें
• "लेकिन अगर वो तुम्हें कोशिश करें कि मेरे साथ शिर्क करो जिसका तुम्हें इल्म नहीं, तो उनकी इताअत न करो लेकिन दुनिया में उनके साथ भलाई से रहो।" (क़ुरआन 31:15)
• फिर भी उनके साथ मेहरबानी और एहतराम से पेश आएं''',
      },
    },
    {
      'number': 2,
      'title': 'Rights of Spouse',
      'titleUrdu': 'شریک حیات کے حقوق',
      'titleHindi': 'शरीक हयात के हुक़ूक़',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'details': {
        'english': '''Rights of Spouse (Husband & Wife)

Marriage is a sacred bond with mutual rights and responsibilities.

Rights of Wife:
• Financial support - husband must provide food, clothing, and shelter
• Kind treatment: "Live with them in kindness" (Quran 4:19)
• The Prophet ﷺ said: "The best of you are those who are best to their wives." (Tirmidhi)
• Respect and honor her in public and private
• Help with household tasks (as the Prophet ﷺ did)
• Spend quality time together
• Protect her dignity and honor
• Be patient with her shortcomings

Rights of Husband:
• Obedience in matters that are not sinful
• Guard his wealth and property in his absence
• Maintain the home and create a peaceful environment
• The Prophet ﷺ said: "If a woman prays her five prayers, fasts her month, guards her chastity and obeys her husband, it will be said to her: 'Enter Paradise from whichever of its gates you wish.'" (Ahmad)
• Respect and honor him
• Be grateful for his efforts

Mutual Rights:
• Love, mercy, and compassion
• "And of His signs is that He created for you from yourselves mates that you may find tranquility in them; and He placed between you affection and mercy." (Quran 30:21)
• Fulfilling each other's needs
• Consulting each other in family matters
• Protecting each other's secrets
• Forgiving each other's mistakes
• Supporting during difficult times

Good Character in Marriage:
• The Prophet ﷺ said: "The believers with the most complete faith are those with the best character, and the best of you are those who are best to their wives." (Tirmidhi)
• Be playful and joyful together
• Express appreciation regularly
• Make dua for each other
• Work as a team for the family

Conflict Resolution:
• Resolve disputes with wisdom and patience
• Avoid raising voice or harsh words
• "And live with them honorably. But if you dislike them - perhaps you dislike a thing and Allah makes therein much good." (Quran 4:19)
• Seek counseling if needed
• Never go to bed angry with each other''',
        'urdu': '''شریک حیات کے حقوق (خاوند اور بیوی)

نکاح ایک مقدس رشتہ ہے جس میں باہمی حقوق اور ذمہ داریاں ہیں۔

بیوی کے حقوق:
• مالی کفالت - خاوند کو کھانا، کپڑا اور رہائش فراہم کرنی چاہیے
• مہربانی سے پیش آنا: "ان کے ساتھ بھلائی سے رہو" (قرآن 4:19)
• نبی کریم ﷺ نے فرمایا: "تم میں سے بہترین وہ ہیں جو اپنی بیویوں کے لیے بہترین ہیں۔" (ترمذی)
• عوام اور خلوت میں ان کا احترام کریں
• گھر کے کاموں میں مدد کریں (جیسے نبی ﷺ کرتے تھے)
• معیاری وقت ساتھ گزاریں
• ان کی عزت اور آبرو کی حفاظت کریں
• ان کی کمزوریوں پر صبر کریں

خاوند کے حقوق:
• جائز معاملات میں اطاعت
• ان کی غیر موجودگی میں ان کے مال اور جائیداد کی حفاظت
• گھر کو سنبھالنا اور پرامن ماحول بنانا
• نبی کریم ﷺ نے فرمایا: "اگر کوئی عورت اپنی پانچ نمازیں پڑھے، اپنے مہینے کے روزے رکھے، اپنی عفت کی حفاظت کرے اور اپنے خاوند کی اطاعت کرے، اسے کہا جائے گا: 'جنت کے جس دروازے سے چاہو داخل ہو جاؤ۔'" (احمد)
• ان کا احترام اور عزت کریں
• ان کی محنت کا شکریہ ادا کریں

باہمی حقوق:
• محبت، رحمت اور شفقت
• "اور اس کی نشانیوں میں سے ہے کہ اس نے تمہارے لیے تم میں سے جوڑے پیدا کیے تاکہ تم ان سے سکون پاؤ؛ اور اس نے تمہارے درمیان محبت اور رحمت رکھی۔" (قرآن 30:21)
• ایک دوسرے کی ضروریات پوری کرنا
• خاندانی معاملات میں مشورہ کرنا
• ایک دوسرے کے رازوں کی حفاظت کرنا
• ایک دوسرے کی غلطیوں کو معاف کرنا
• مشکل وقت میں ایک دوسرے کا ساتھ دینا

شادی میں اچھا کردار:
• نبی کریم ﷺ نے فرمایا: "کامل ترین ایمان والے مومن وہ ہیں جن کا کردار بہترین ہے، اور تم میں سے بہترین وہ ہیں جو اپنی بیویوں کے لیے بہترین ہیں۔" (ترمذی)
• ایک دوسرے کے ساتھ خوش مزاج اور خوش رہیں
• باقاعدگی سے تعریف کا اظہار کریں
• ایک دوسرے کے لیے دعا کریں
• خاندان کے لیے ٹیم کی طرح کام کریں

تنازعات کا حل:
• حکمت اور صبر سے جھگڑے حل کریں
• آواز بلند کرنے یا سخت الفاظ سے بچیں
• "اور ان کے ساتھ بھلائی سے رہو۔ لیکن اگر تم انہیں ناپسند کرتے ہو - شاید تم کسی چیز کو ناپسند کرو اور اللہ اس میں بہت بھلائی رکھے۔" (قرآن 4:19)
• ضرورت ہو تو مشورہ لیں
• کبھی ایک دوسرے سے ناراض ہو کر نہ سوئیں''',
        'hindi': '''शरीक हयात के हुक़ूक़ (ख़ाविंद और बीवी)

निकाह एक मुक़द्दस रिश्ता है जिसमें ��ाहमी हुक़ूक़ और ज़िम्मेदारियां हैं।

बीवी के हुक़ूक़:
• माली किफ़ालत - ख़ाविंद को खाना, कपड़ा और रिहाइश फ़राहम करनी चाहिए
• मेहरबानी से पेश आना: "उनके साथ भलाई से रहो" (क़ुरआन 4:19)
• नबी करीम ﷺ ने फ़रमाया: "तुम में से बेहतरीन वो हैं जो अपनी बीवियों के लिए बेहतरीन हैं।" (तिर्मिज़ी)
• आम और ख़लवत में उनका एहतराम करें
• घर के कामों में मदद करें (जैसे नबी ﷺ करते थे)
• मेयारी वक़्त साथ गुज़ारें
• उनकी इज़्ज़त और आबरू की हिफ़ाज़त करें
• उनकी कमज़ोरियों पर सब्र करें

ख़ाविंद के हुक़ूक़:
• जाइज़ मुआमलात में इताअत
• उनकी ग़ैर मौजूदगी में उनके माल और जायदाद की हिफ़ाज़त
• घर को संभालना और पुरअमन माहौल बनाना
• नबी करीम ﷺ ने फ़रमाया: "अगर कोई औरत अपनी पांच नमाज़ें पढ़े, अपने महीने के रोज़े रखे, अपनी इफ़्फ़त की हिफ़ाज़त करे और अपने ख़ाविंद की इताअत करे, उसे कहा जाएगा: 'जन्नत के जिस दरवाज़े से चाहो दाख़िल हो जाओ।'" (अहमद)
• उनका एहतराम और इज़्ज़त करें
• उनकी मेहनत का शुक्रिया अदा करें

बाहमी हुक़ूक़:
• मोहब्बत, रहमत और शफ़क़त
• "और उसकी निशानियों में से है कि उसने तुम्हारे लिए तुममें से जोड़े पैदा किए ताकि तुम उनसे सुकून पाओ; और उसने तुम्हारे दरमियान मोहब्बत और रहमत रखी।" (क़ुरआन 30:21)
• एक दूसरे की ज़रूरतें पूरी करना
• ख़ानदानी मुआमलात में मशवरा करना
• एक दूसरे के राज़ों की हिफ़ाज़त करना
• एक दूसरे की ग़लतियों को माफ़ करना
• मुश्किल वक़्त में एक दूसरे का साथ देना

शादी में अच्छा किरदार:
• नबी करीम ﷺ ने फ़रमाया: "कामिल तरीन ईमान वाले मोमिन वो हैं जिनका किरदार बेहतरीन है, और तुम में से बेहतरीन वो हैं जो अपनी बीवियों के लिए बेहतरीन हैं।" (तिर्मिज़ी)
• एक दूसरे के साथ ख़ुशमिज़ाज और ख़ुश रहें
• बाक़ायदगी से तारीफ़ का इज़हार करें
• एक दूसरे के लिए दुआ करें
• ख़ानदान के लिए टीम की तरह काम करें

तनाज़ुआत का हल:
• हिकमत और सब्र से झगड़े हल करें
• आवाज़ बुलंद करने या सख़्त अल्फ़ाज़ से बचें
• "और उनके साथ भलाई से रहो। लेकिन अगर तुम उन्हें नापसंद करते हो - शायद तुम किसी चीज़ को नापसंद करो और अल्लाह उसमें बहुत भलाई रखे।" (क़ुरआन 4:19)
• ज़रूरत हो तो मशवरा लें
• कभी एक दूसरे से नाराज़ होकर न सोएं''',
      },
    },
    {
      'number': 3,
      'title': 'Rights of Children',
      'titleUrdu': 'بچوں کے حقوق',
      'titleHindi': 'बच्चों के हुक़ूक़',
      'icon': Icons.child_care,
      'color': Colors.blue,
      'details': {
        'english': '''Rights of Children

Children are a trust and blessing from Allah.

Basic Rights:
• Good upbringing and education
• The Prophet ﷺ said: "Every child is born on fitrah (natural disposition)." (Bukhari)
• Teach them Islamic values and manners
• Provide proper nutrition, clothing, and shelter
• Love and affection equally among all children
• Protect them from harm

Educational Rights:
• Teach Quran and Islamic knowledge
• "Command your children to pray when they become seven years old." (Abu Dawud)
• Provide worldly education for their future
• Teach good manners and character
• Develop their talents and abilities

Equal Treatment:
• The Prophet ﷺ said: "Fear Allah and treat your children fairly." (Bukhari & Muslim)
• Give gifts equally to all children
• Show equal love and attention
• Avoid favoritism
• Be just in all matters concerning them

Emotional Rights:
• Show love and affection openly
• The Prophet ﷺ would kiss and hug his grandchildren
• Spend quality time with them
• Listen to their concerns
• Encourage and support them
• Never abuse or humiliate them

Moral Training:
• Be a role model - children learn by example
• Teach honesty, kindness, and respect
• Instill love for Allah and His Messenger
• Correct them with gentleness
• "O you who have believed, protect yourselves and your families from a Fire." (Quran 66:6)

Special Care for Daughters:
• The Prophet ﷺ said: "Whoever has three daughters or sisters, or two daughters or sisters, and treats them well and fears Allah regarding them, will enter Paradise." (Tirmidhi)
• Raise them with honor and respect
• Protect their dignity
• Educate them properly''',
        'urdu': '''بچوں کے حقوق

بچے اللہ کی امانت اور نعمت ہیں۔

بنیادی حقوق:
• اچھی پرورش اور تعلیم
• نبی کریم ﷺ نے فرمایا: "ہر بچہ فطرت پر پیدا ہوتا ہے۔" (بخاری)
• انہیں اسلامی اقدار اور آداب سکھائیں
• مناسب غذا، کپڑے اور رہائش فراہم کریں
• تمام بچوں سے یکساں محبت اور شفقت
• انہیں نقصان سے بچائیں

تعلیمی حقوق:
• قرآن اور اسلامی علم سکھائیں
• "جب تمہارے بچے سات سال کے ہو جائیں تو انہیں نماز کا حکم دو۔" (ابو داؤد)
• ان کے مستقبل کے لیے دنیاوی تعلیم فراہم کریں
• اچھے آداب اور کردار سکھائیں
• ان کی صلاحیتوں کو نکھاریں

برابر سلوک:
• نبی کریم ﷺ نے فرمایا: "اللہ سے ڈرو اور اپنے بچوں کے ساتھ انصاف کرو۔" (بخاری و مسلم)
• تمام بچوں کو برابر تحائف دیں
• برابر محبت اور توجہ دیں
• کسی کو ترجی�� نہ دیں
• ان کے معاملات میں منصف رہیں

جذباتی حقوق:
• کھلے عام محبت اور شفقت کا اظہار کریں
• نبی کریم ﷺ اپنے نواسوں کو بوسہ دیتے اور گلے لگاتے تھے
• ان کے ساتھ معیاری وقت گزاریں
• ان کی پریشانیاں سنیں
• ان کی حوصلہ افزائی اور حمایت کریں
• کبھی ان کے ساتھ بدسلوکی یا تذلیل نہ کریں

اخلاقی تربیت:
• نمونہ بنیں - بچے مثال سے سیکھتے ہیں
• ایمانداری، مہربانی اور احترام سکھائیں
• اللہ اور اس کے رسول سے محبت پیدا کریں
• نرمی سے ان کی اصلاح کریں
• "اے ایمان والو! اپنے آپ کو اور اپنے گھر والوں کو آگ سے بچاؤ۔" (قرآن 66:6)

بیٹیوں کی خاص دیکھ بھال:
• نبی کریم ﷺ نے فرمایا: "جس کی تین بیٹیاں یا بہنیں ہوں، یا دو بیٹیاں یا بہنیں ہوں، اور وہ ان کے ساتھ اچھا سلوک کرے اور ان کے بارے میں اللہ سے ڈرے، وہ جنت میں داخل ہوگا۔" (ترمذی)
• انہیں عزت اور احترام سے پالیں
• ان کی عزت کی حفاظت کریں
• انہیں مناسب تعلیم دیں''',
        'hindi': '''बच्चों के हुक़ूक़

बच्चे अल्लाह की अमानत और नेमत हैं।

बुनियादी हुक़ूक़:
• अच्छी परवरिश और तालीम
• नबी करीम ﷺ ने फ़रमाया: "हर बच्चा फ़ित्रत पर पैदा होता है।" (बुख़ारी)
• उन्हें इस्लामी अक़ीदे और आदाब सिखाएं
• मुनासिब ग़िज़ा, कपड़े और रिहाइश फ़राहम करें
• तमाम बच्चों से यकसां मोहब्बत और शफ़क़त
• उन्हें नुक़सान से बचाएं

तालीमी हुक़ूक़:
• क़ुरआन और इस्लामी इल्म सिखाएं
• "जब तुम्हारे बच्चे सात साल के हो जाएं तो उन्हें नमाज़ का हुक्म दो।" (अबू दाऊद)
• उनके मुस्तक़बिल के लिए दुनियावी तालीम फ़राहम करें
• अच्छे आदाब और किरदार सिखाएं
• उनकी सलाहियतों को निखारें

बराबर सुलूक:
• नबी करीम ﷺ ने फ़रमाया: "अल्लाह से डरो और अपने बच्चों के साथ इंसाफ़ करो।" (बुख़ारी व मुस्लिम)
• तमाम बच्चों को बराबर तोहफ़े दें
• बराबर मोहब्बत और तवज्जोह दें
• किसी को तरजीह न दें
• उनके मुआमलात में मुंसिफ़ रहें

जज़्बाती हुक़ूक़:
• खुले आम मोहब्बत और शफ़क़त का इज़हार करें
• नबी करीम ﷺ अपने नवासों को बोसा देते और गले लगाते थे
• उनके साथ मेयारी वक़्त गुज़ारें
• उनकी परेशानियां सुनें
• उनकी हौसलाअफ़ज़ाई और हिमायत करें
• कभी उनके साथ बदसुलूकी या तज़लील न करें

अख़्लाक़ी तरबियत:
• नमूना बनें - बच्चे मिसाल से सीखते हैं
• ईमानदारी, मेहरबानी और एहतराम सिखाएं
• अल्लाह और उसके रसूल से मोहब्बत पैदा करें
• नरमी से उनकी इस्लाह करें
• "ऐ ईमान वालो! अपने आपको और अपने घर वालों को आग से बचाओ।" (क़ुरआन 66:6)

बेटियों की ख़ास देखभाल:
• नबी करीम ﷺ ने फ़रमाया: "जिसकी तीन बेटियां या बहनें हों, या दो बेटियां या बहनें हों, और वो उनके साथ अच्छा सुलूक करे और उनके बारे में अल्लाह से डरे, वो जन्नत में दाख़िल होगा।" (तिर्मिज़ी)
• उन्हें इज़्ज़त और एहतराम से पालें
• उनकी इज़्ज़त की हिफ़ाज़त करें
• उन्हें मुनासिब तालीम दें''',
      },
    },
    {
      'number': 4,
      'title': 'Rights of Siblings',
      'titleUrdu': 'بہن بھائیوں کے حقوق',
      'titleHindi': 'बहन भाइयों के हुक़ूक़',
      'icon': Icons.people,
      'color': Colors.purple,
      'details': {
        'english': '''Rights of Siblings

Siblings share a special bond of love and mutual support.

Brotherhood in Islam:
• "The believers are but brothers, so make settlement between your brothers." (Quran 49:10)
• Help each other in righteousness
• Support in times of need
• Protect each other's honor
• Maintain strong ties throughout life

Mutual Rights:
• Love and compassion for each other
• Respect each other's privacy
• Give sincere advice when needed
• Share resources generously
• Forgive mistakes and shortcomings
• Avoid jealousy and competition
• Celebrate each other's success

Supporting Siblings:
• The Prophet ﷺ said: "Help your brother whether he is an oppressor or oppressed." When asked how to help an oppressor, he said: "Prevent him from oppressing." (Bukhari)
• Stand up for them when they are wronged
• Give them honest counsel
• Assist in their legitimate needs
• Make dua for them regularly

Resolving Conflicts:
• Address issues with wisdom and kindness
• Seek forgiveness when you err
• Don't hold grudges
• Remember the bond of blood
• Involve parents if needed for mediation
• "And We have enjoined upon man to his parents good treatment." (Quran 31:14)

Elder Siblings:
• Guide younger siblings with love
• Set good example
• Be patient with their mistakes
• Share knowledge and experience
• Protect and care for them

Younger Siblings:
• Respect elder siblings
• Seek their advice
• Learn from their experience
• Support them as they age
• Maintain connection throughout life

Special Bond:
• Sibling relationship is lifelong
• The Prophet ﷺ maintained close ties with his foster siblings
• Remember childhood memories with fondness
• Keep communication regular
• Gather family together when possible''',
        'urdu': '''بہن بھائیوں کے حقوق

بہن بھائیوں میں محبت اور باہمی مدد کا خاص رشتہ ہے۔

اسلام میں بھائی چارہ:
• "مومن آپس میں بھائی ہیں، تو اپنے بھائیوں میں صلح کراؤ۔" (قرآن 49:10)
• نیکی میں ایک دوسرے کی مدد کرو
• ضرورت کے وقت ساتھ دو
• ایک دوسرے کی عزت کی حفاظت کرو
• زندگی بھر مضبوط تعلقات برقرار رکھو

باہمی حقوق:
• ایک دوسرے کے لیے محبت اور شفقت
• ایک دوسرے کی رازداری کا احترام
• ضرورت پڑنے پر مخلصانہ مشورہ دیں
• فیاضی سے وسائل بانٹیں
• غلطیوں اور کمیوں کو معاف کریں
• حسد اور مقابلے سے بچیں
• ایک دوسرے کی کامیابی پر خوشی منائیں

بہن بھائیوں کی مدد:
• نبی کریم ﷺ نے فرمایا: "اپنے بھائی کی مدد کرو خواہ وہ ظالم ہو یا مظلوم۔" جب پوچھا گیا کہ ظالم کی کیسے مدد کریں؟ آپ نے فرمایا: "اسے ظلم سے روکو۔" (بخاری)
• جب ان پر ظلم ہو تو ان کے لیے کھڑے ہو
• انہیں ایمانداری سے مشورہ دیں
• ان کی جائز ضروریات میں مدد کریں
• ان کے لیے باقاعدگی سے دعا کریں

تنازعات کا حل:
• حکمت اور مہربانی سے مسائل حل کریں
• غلطی پر معافی مانگیں
• کینہ نہ رکھیں
• خون کے رشتے کو یاد رکھیں
• ضرورت ہو تو والدین کو بیچ میں لائیں
• "اور ہم نے انسان کو اپنے والدین کے ساتھ اچھا سلوک کرنے کا حکم دیا ہے۔" (قرآن 31:14)

بڑے بہن بھائی:
• چھوٹے بہن بھائیوں کی محبت سے رہنمائی کریں
• اچھی مثال قائم کریں
• ان کی غلطیوں پر صبر کریں
• علم اور تجربہ بانٹیں
• ان کی حفاظت اور دیکھ بھال کریں

چھوٹے بہن بھائی:
• بڑے بہن بھائیوں کا احترام کریں
• ان سے مشورہ لیں
• ان کے تجربے سے سیکھیں
• بڑھاپے میں ان کی مدد کریں
• زندگی بھر رابطہ برقرار رکھیں

خاص رشتہ:
• بہن بھائیوں کا رشتہ تاحیات ہے
• نبی کریم ﷺ اپنے رضاعی بہن بھائیوں سے قریبی تعلقات رکھتے تھے
• بچپن کی یادوں کو پیار سے یاد رکھیں
• باقاعدہ رابطے میں رہیں
• ممکن ہو تو خاندان کو اکٹھا کریں''',
        'hindi': '''बहन भाइयों के हुक़ूक़

बहन भाइयों में मोहब्बत और बाहमी मदद का ख़ास रिश्ता है।

इस्लाम में भाईचारा:
• "मोमिन आपस में भाई हैं, तो अपने भाइयों में सुलह कराओ।" (क़ुरआन 49:10)
• नेकी में एक दूसरे की मदद करो
• ज़रूरत के वक़्त साथ दो
• एक दूसरे की इज़्ज़त की हिफ़ाज़त करो
• ज़िंदगी भर मज़बूत तअल्लुक़ात बरक़रार रखो

बाहमी हुक़ूक़:
• एक दूसरे के लिए मोहब्बत और शफ़क़त
• एक दूसरे की राज़दारी का एहतराम
• ज़रूरत पड़ने पर मुख़्लिसाना मशवरा दें
• फ़य्याज़ी से वसाइल बांटें
• ग़लतियों और कमियों को माफ़ करें
• हसद और मुक़ाबले से बचें
• एक दूसरे की कामयाबी पर ख़ुशी मनाएं

बहन भाइयों की मदद:
• नबी करीम ﷺ ने फ़रमाया: "अपने भाई की मदद करो ख़्वाह वो ज़ालिम हो या मज़लूम।" जब पूछा गया कि ज़ालिम की कैसे मदद करें? आपने फ़रमाया: "उसे ज़ुल्म से रोको।" (बुख़ारी)
• जब उन पर ज़ुल्म हो तो उनके लिए खड़े हो
• उन्हें ईमानदारी से मशवरा दें
• उनकी जाइज़ ज़रूरतों में मदद करें
• उनके लिए बाक़ायदगी से दुआ करें

तनाज़ुआत का हल:
• हिकमत और मेहरबानी से मसाइल हल करें
• ग़लती पर माफ़ी मांगें
• कीना न रखें
• ख़ून के रिश्ते को याद रखें
• ज़रूरत हो तो वालिदैन को बीच में लाएं
• "और हमने इंसान को अपने वालिदैन के साथ अच्छा सुलूक करने का हुक्म दिया है।" (क़ुरआन 31:14)

बड़े बहन भाई:
• छोटे बहन भाइयों की मोहब्बत से रहनुमाई करें
• अच्छी मिसाल क़ायम करें
• उनकी ग़लतियों पर सब्र करें
• इल्म और तजुर्बा बांटें
• उनकी हिफ़ाज़त और देखभाल करें

छोटे बहन भाई:
• बड़े बहन भाइयों का एहतराम करें
• उनसे मशवरा लें
• उनके तजुर्बे से सीखें
• बुढ़ापे में उनकी मदद करें
• ज़िंदगी भर राबिता बरक़रार रखें

ख़ास रिश्ता:
• बहन भाइयों का रिश्ता ताहयात है
• नबी करीम ﷺ अपने रिज़ाई बहन भाइयों से क़रीबी तअल्लुक़ात रखते थे
• बचपन की यादों को प्यार से याद रखें
• बाक़ायदा राबिते में रहें
• मुमकिन हो तो ख़ानदान को इकट्ठा करें''',
      },
    },
    {
      'number': 5,
      'title': 'Extended Family Rights',
      'titleUrdu': 'وسیع خاندان کے حقوق',
      'titleHindi': 'वसी ख़ानदान के हुक़ूक़',
      'icon': Icons.family_restroom,
      'color': Colors.teal,
      'details': {
        'english': '''Extended Family Rights

Maintaining ties with extended family is a religious duty.

Importance of Family Ties:
• "And fear Allah through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer." (Quran 4:1)
• Silat ar-Rahm (maintaining family ties) increases lifespan and provision
• The Prophet ﷺ said: "Whoever would like his provision to be increased and his lifespan to be extended should maintain family ties." (Bukhari)
• Breaking family ties is a major sin

Rights of Grandparents:
• Honor and respect like parents
• Visit them regularly
• Care for them in old age
• Seek their blessings and prayers
• Learn from their wisdom and experience
• The Prophet ﷺ gave special care to his grandfather Abdul Muttalib

Rights of Uncles and Aunts:
• Maternal uncle has status close to father
• The Prophet ﷺ said: "The maternal aunt is like the mother." (Bukhari)
• Paternal uncle represents father in his absence
• Show them respect and honor
• Maintain regular contact
• Help them in times of need

Rights of Cousins:
• They are like siblings
• Support each other
• Maintain good relations
• Share in joys and sorrows
• Help in difficult times
• Avoid disputes over inheritance

Visiting Family:
• Regular visits strengthen bonds
• Especially important during illness
• Attend family gatherings
• Share meals together
• Remember them on special occasions
• Use modern technology to stay connected if far

Financial Support:
• Help poor relatives before others
• Charity to relatives has double reward
• The Prophet ﷺ said: "Charity to the poor is charity, and charity to a relative is two things: charity and upholding family ties." (Tirmidhi)
• Share wealth during times of hardship

Resolving Family Disputes:
• Act as peacemaker
• Don't take sides based on bias
• Seek justice and fairness
• Forgive and overlook mistakes
• Remember the importance of family unity
• "So fear Allah and amend that which is between you." (Quran 8:1)''',
        'urdu': '''وسیع خاندان کے حقوق

وسیع خاندان کے ساتھ تعلقات برقرار رکھنا دینی فریضہ ہے۔

خاندانی تعلقات کی اہمیت:
• "اور اللہ سے ڈرو جس کے نام پر تم ایک دوسرے سے مانگتے ہو، اور رحموں سے۔ بیشک اللہ تم پر نگران ہے۔" (قرآن 4:1)
• صلہ رحمی عمر اور رزق میں اضافہ کرتی ہے
• نبی کریم ﷺ نے فرمایا: "جو چاہے کہ اس کا رزق بڑھے اور عمر دراز ہو، وہ صلہ رحمی کرے۔" (بخاری)
• خاندانی تعلقات توڑنا کبیرہ گناہ ہے

دادا دادی، نانا نانی کے حقوق:
• والدین کی طرح عزت اور احترام
• باقاعدگی سے ملاقات
• بڑھاپے میں ان کی دیکھ بھال
• ان کی دعاؤں اور برکتوں کی طلب
• ان کی حکمت اور تجربے سے سیکھنا
• نبی کریم ﷺ نے اپنے دادا عبدالمطلب کا خاص خیال رکھا

چچا، خالہ، پھوپھی، ماموں کے حقوق:
• ماموں کا مقام باپ کے قریب ہے
• نبی کریم ﷺ نے فرمایا: "خالہ ماں کی طرح ہے۔" (بخاری)
• چچا باپ کی غیر موجودگی میں اس کی نمائندگی کرتا ہے
• ان کا احترام اور عزت کریں
• باقاعدہ رابطہ رکھیں
• ضرورت کے وقت مدد کریں

کزنز کے حقوق:
• وہ بہن بھائیوں کی طرح ہیں
• ایک دوسرے کی مدد کریں
• اچھے تعلقات برقرار رکھیں
• خوشیوں اور غموں میں شریک ہوں
• مشکل وقت میں مدد کریں
• وراثت پر جھگڑوں سے بچیں

خاندان سے ملاقات:
• باقاعدہ ملاقاتیں تعلقات مضبوط کرتی ہیں
• بیماری میں خاص طور پر اہم
• خاندانی اجتماعات میں شرکت
• ساتھ کھانا کھائیں
• خاص مواقع پر یاد رکھیں
• دور ہونے کی صورت میں جدید ٹیکنالوجی استعمال کریں

مالی مدد:
• غریب رشتہ داروں کی پہلے مدد کریں
• رشتہ داروں کو صدقہ دوہرا ثواب ہے
• نبی کریم ﷺ نے فرمایا: "غریب کو صدقہ صرف صدقہ ہے، اور رشتہ دار کو صدقہ دو چیزیں ہیں: صدقہ اور صلہ رحمی۔" (ترمذی)
• مشکل وقت میں مال بانٹیں

خاندانی جھگڑوں کا حل:
• صلح کرانے والے بنیں
• تعصب کی بنیاد پر کسی کا ساتھ نہ دیں
• انصاف اور منصفی تلاش کریں
• معاف کریں اور غلطیوں کو نظرانداز کریں
• خاندانی اتحاد کی اہمیت یاد رکھیں
• "تو اللہ سے ڈرو اور اپنے درمیان کی چیزوں کو درست کرو۔" (قرآن 8:1)''',
        'hindi': '''वसी ख़ानदान के हुक़ूक़

वसी ख़ानदान के साथ तअल्लुक़ात बरक़रार रखना दीनी फ़रीज़ा है।

ख़ानदानी तअल्लुक़ात की अहमियत:
• "और अल्लाह से डरो जिसके नाम पर तुम एक दूसरे से मांगते हो, और रहमों से। बेशक अल्लाह तुम पर निगरान है।" (क़ुरआन 4:1)
• सिला रहमी उम्र और रिज़्क़ में इज़ाफ़ा करती है
• नबी करीम ﷺ ने फ़रमाया: "जो चाहे कि उसका रिज़्क़ बढ़े और उम्र दराज़ हो, वो सिला रहमी करे।" (बुख़ारी)
• ख़ानदानी तअल्लुक़ात तोड़ना कबीरा गुनाह है

दादा दादी, नाना नानी के हुक़ूक़:
• वालिदैन की तरह इज़्ज़त और एहतराम
• बाक़ायदगी से मुलाक़ात
• बुढ़ापे में उनकी देखभाल
• उनकी दुआओं और बरकतों की तलब
• उनकी हिकमत और तजुर्बे से सीखना
• नबी करीम ﷺ ने अपने दादा अब्दुल मुत्तलिब का ख़ास ख़याल रखा

चाचा, ख़ाला, फूफी, मामूं के हुक़ूक़:
• मामूं का मक़ाम बाप के क़रीब है
• नबी करीम ﷺ ने फ़रमाया: "ख़ाला मां की तरह है।" (बुख़ारी)
• चाचा बाप की ग़ैर मौजूदगी में उसकी नुमाइंदगी करता है
• उनका एहतराम और इज़्ज़त करें
• बाक़ायदा राबिता रखें
• ज़रूरत के वक़्त मदद करें

कज़िन्स के हुक़ूक़:
• वो बहन भाइयों की तरह हैं
• एक दूसरे की मदद करें
• अच्छे तअल्लुक़ात बरक़रार रखें
• ख़ुशियों और ग़मों में शरीक हों
• मुश्किल वक़्त में मदद करें
• विरासत पर झगड़ों से बचें

ख़ानदान से मुलाक़ात:
• बाक़ायदा मुलाक़ातें तअल्लुक़ात मज़बूत करती हैं
• बीमारी में ख़ास तौर पर अहम
• ख़ानदानी इजतिमाआत में शिरकत
• साथ खाना खाएं
• ख़ास मवाक़े पर याद रखें
• दूर होने की सूरत में जदीद टेक्नॉलॉजी इस्तेमाल करें

माली मदद:
• ग़रीब रिश्तेदारों की पहले मदद करें
• रिश्तेदारों को सदक़ा दोहरा सवाब है
• नबी करीम ﷺ ने फ़रमाया: "ग़रीब को सदक़ा सिर्फ़ सदक़ा है, और रिश्तेदार को सदक़ा दो चीज़���ं हैं: सदक़ा और सिला रहमी।" (तिर्मिज़ी)
• मुश्किल वक़्त में माल बांटें

ख़ानदानी झगड़ों का हल:
• सुलह कराने वाले बनें
• तअस्सुब की बुनियाद पर किसी का साथ न दें
• इंसाफ़ और मुंसिफ़ी तलाश करें
• माफ़ करें और ग़लतियों को नज़रअंदाज़ करें
• ख़ानदानी इत्तेहाद की अहमियत याद रखें
• "तो अल्लाह से डरो और अपने दरमियान की चीज़ों को दुरुस्त करो।" (क़ुरआन 8:1)''',
      },
    },
    {
      'number': 6,
      'title': 'Building Strong Families',
      'titleUrdu': 'مضبوط خاندان بنانا',
      'titleHindi': 'मज़बूत ख़ानदान बनाना',
      'icon': Icons.home,
      'color': Colors.green,
      'details': {
        'english': '''Building Strong Families

A strong family is the foundation of a strong society.

Islamic Home Environment:
• Start with Bismillah and Salam
• Regular family prayers together
• Recitation of Quran in the home
• Islamic decorations and reminders
• Avoid haram entertainment
• Create atmosphere of peace and tranquility

Family Time:
• Eat at least one meal together daily
• Family meetings to discuss issues
• Game nights and fun activities
• The Prophet ﷺ would race with Aisha (RA)
• Create family traditions
• Technology-free quality time

Teaching Islamic Values:
• Lead by example - children watch parents
• Daily Quran lessons
• Discuss Islamic stories and history
• Teach through everyday situations
• Encourage questions and discussions
• Make Islam attractive and joyful

Communication:
• Listen actively to each family member
• Express feelings openly but respectfully
• Weekly family meetings
• One-on-one time with each child
• Share accomplishments and concerns
• Create safe space for discussion

Financial Planning:
• Avoid debt and interest
• Live within means
• Save for future needs
• Teach children about money management
• Regular charity as a family
• Trust in Allah's provision

Supporting Each Other:
• Celebrate achievements together
• Comfort in times of difficulty
• Make dua for each family member daily
• Be patient with each other's flaws
• Forgive quickly and sincerely
• Work as a team

Extended Family Involvement:
• Regular gatherings with grandparents
• Cousin relationships
• Family reunions
• Sharing responsibilities
• Preserving family history
• Passing down traditions

Legacy Building:
• "When a person dies, his deeds come to an end except for three: ongoing charity, beneficial knowledge, or a righteous child who prays for him." (Muslim)
• Raise children who will remember you in dua
• Create traditions that continue
• Record family Islamic history
• Establish family endowments''',
        'urdu': '''مضبوط خاندان بنانا

مضبوط خاندان مضبوط معاشرے کی بنیاد ہے۔

اسلامی گھر کا ماحول:
• بسم اللہ اور سلام سے شروع کریں
• باقاعدہ خاندانی نماز ساتھ
• گھر میں قرآن کی تلاوت
• اسلامی سجاوٹ اور یاد دہانیاں
• حرام تفریح سے بچیں
• امن اور سکون کا ماحول بنائیں

خاندانی وقت:
• روزانہ کم از کم ایک کھانا ساتھ کھائیں
• مسائل پر بات چیت کے لیے خاندانی اجلاس
• گیم نائٹ اور تفریحی سرگرمیاں
• نبی کریم ﷺ عائشہ (رض) کے ساتھ دوڑ لگاتے تھے
• خاندانی روایات بنائیں
• ٹیکنالوجی سے پاک معیاری وقت

اسلامی اقدار کی تعلیم:
• مثال سے رہنمائی - بچے والدین کو دیکھتے ہیں
• روزانہ قرآن کے اسباق
• اسلامی کہانیوں اور تاریخ پر بات چیت
• روزمرہ حالات سے سکھائیں
• سوالات اور بات چیت کی حوصلہ افزائی
• اسلام کو پرکشش اور خوشگوار بنائیں

بات چیت:
• ہر خاندانی رکن کو فعال طور پر سنیں
• احساسات کو کھل کر لیکن احترام سے بیان کریں
• ہفتہ وار خاندانی اجلاس
• ہر بچے کے ساتھ انفرادی وقت
• کامیابیاں اور پریشانیاں شیئر کریں
• بات چیت کے لیے محفوظ جگہ بنائیں

مالی منصوبہ بندی:
• قرض اور سود سے بچیں
• اپنی استطاعت کے اندر رہیں
• مستقبل کی ضروریات کے لیے بچت کریں
• بچوں کو پیسے کے انتظام کے بارے میں سکھائیں
• خاندان کے ساتھ باقاعدہ صدقہ
• اللہ کے رزق پر بھروسہ

ایک دوسرے کی مدد:
• کامیابیاں ساتھ منائیں
• مشکل وقت میں تسلی دیں
• ہر خاندانی رکن کے لیے روزانہ دعا کریں
• ایک دوسرے کی کمزوریوں پر صبر کریں
• جلدی اور خلوص سے معاف کریں
• ٹیم کی طرح کام کریں

وسیع خاندان کی شمولیت:
• دادا دادی کے ساتھ باقاعدہ اجتماعات
• کزنز کے تعلقات
• خاندانی اتحاد
• ذمہ داریاں بانٹنا
• خاندانی تاریخ محفوظ کرنا
• روایات منتقل کرنا

میراث کی تعمیر:
• "جب آدمی مر جاتا ہے تو اس کے اعمال ختم ہو جاتے ہیں سوائے تین کے: جاری صدقہ، نفع بخش علم، یا نیک اولاد جو اس کے لیے دعا کرے۔" (مسلم)
• ایسے بچے پالیں جو آپ کو دعا میں یاد رکھیں
• روایات بنائیں جو جاری رہیں
• خاندانی اسلامی تاریخ ریکارڈ کریں
• خاندانی وقف قائم کریں''',
        'hindi': '''मज़बूत ख़ानदान बनाना

मज़बूत ख़ानदान मज़बूत मुआशरे की बुनियाद है।

इस्लामी घर का माहौल:
• बिस्मिल्लाह और सलाम से शुरू करें
• बाक़ायदा ख़ानदानी नमाज़ साथ
• घर में क़ुरआन की तिलावत
• इस्लामी सजावट और यादिहानियां
• हराम तफ़रीह से बचें
• अमन और सुकून का माहौल बनाएं

ख़ानदानी वक़्त:
• रोज़ाना कम अज़ कम एक खाना साथ खाएं
• मसाइल पर बातचीत के लिए ख़ानदानी इजलास
• गेम नाइट और तफ़रीही सरगर्मियां
• नबी करीम ﷺ आइशा (रज़ि) के साथ दौड़ लगाते थे
• ख़ानदानी रिवायतें बनाएं
• टेक्नॉलॉजी से पाक मेयारी वक़्त

इस्लामी अक़ीदे की तालीम:
• मिसाल से रहनुमाई - बच्चे वालिदैन को देखते हैं
• रोज़ाना क़ुरआन के सबक़
• इस्लामी कहा���ियों और तारीख़ पर बातचीत
• रोज़मर्रा हालात से सिखाएं
• सवालात और बातचीत की हौसलाअफ़ज़ाई
• इस्लाम को परकशिश और ख़ुशगवार बनाएं

बातचीत:
• हर ख़ानदानी रुक्न को फ़ेअल तौर पर सुनें
• एहसासात को खुलकर लेकिन एहतराम से बयान करें
• हफ़्तावार ख़ानदानी इजलास
• हर बच्चे के साथ इनफ़िरादी वक़्त
• कामयाबियां और परेशानियां शेयर करें
• बातचीत के लिए महफ़ूज़ जगह बनाएं

माली मंसूबाबंदी:
• क़र्ज़ और सूद से बचें
• अपनी इस्तिताअत के अंदर रहें
• मुस्तक़बिल की ज़रूरतों के लिए बचत करें
• बच्चों को पैसे के इंतिज़ाम के बारे में सिखाएं
• ख़ानदान के साथ बाक़ायदा सदक़ा
• अल्लाह के रिज़्क़ पर भरोसा

एक दूसरे की मदद:
• कामयाबियां साथ मनाएं
• मुश्किल वक़्त में तसल्ली दें
• हर ख़ानदानी रुक्न के लिए रोज़ाना दुआ करें
• एक दूसरे की कमज़ोरियों पर सब्र करें
• जल्दी और ख़ुलूस से माफ़ करें
• टीम की तरह काम करें

वसी ख़ानदान की शुमूलियत:
• दादा दादी के साथ बाक़ायदा इजतिमाआत
• कज़िन्स के तअल्लुक़ात
• ख़ानदानी इत्तेहाद
• ज़िम्मेदारियां बांटना
• ख़ानदानी तारीख़ महफ़ूज़ करना
• रिवायतें मुंतक़िल करना

मीरास की तामीर:
• "जब आदमी मर जाता है तो उसके आमाल ख़त्म हो जाते हैं सिवाए तीन के: जारी सदक़ा, नफ़ाबख़्श इल्म, या नेक औलाद जो उसके लिए दुआ करे।" (मुस्लिम)
• ऐसे बच्चे पालें जो आपको दुआ में याद रखें
• रिवायतें बनाएं जो जारी रहें
• ख़ानदानी इस्लामी तारीख़ रिकॉर्ड करें
• ख़ानदानी वक़्फ़ क़ायम करें''',
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
              itemCount: _familyTopics.length,
              itemBuilder: (context, index) {
                final topic = _familyTopics[index];
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
          category: 'Family - Fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
