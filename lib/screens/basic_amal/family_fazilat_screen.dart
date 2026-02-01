import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class FamilyFazilatScreen extends StatefulWidget {
  const FamilyFazilatScreen({super.key});

  @override
  State<FamilyFazilatScreen> createState() => _FamilyFazilatScreenState();
}

class _FamilyFazilatScreenState extends State<FamilyFazilatScreen> {
  final List<Map<String, dynamic>> _familyTopics = [
    {
      'number': 1,
      'titleKey': 'family_fazilat_1_rights_of_parents',
      'title': 'Rights of Parents',
      'titleUrdu': 'والدین کے حقوق',
      'titleHindi': 'वालिदैन के हुक़ूक़',
      'titleArabic': 'فضائل الوالدين',
      'icon': Icons.elderly,
      'color': Colors.orange,
      'details': {
        'english': '''The Rights of Parents in Islam

Parents hold the highest and most honored position in Islam after Allah and His Messenger Muhammad ﷺ. The Quran mentions parents and their rights at least 15 times, emphasizing their supreme importance in a Muslim's life.

THE SUPREME STATUS OF PARENTS:

**Mentioned With Allah's Worship:**
• "And your Lord has decreed that you not worship except Him, and to parents, good treatment. Whether one or both of them reach old age [while] with you, say not to them [so much as], 'uff,' and do not repel them but speak to them a noble word." (Quran 17:23)
• Allah has placed obedience to parents immediately after His worship - the highest honor
• This demonstrates that after fulfilling our duties to Allah, our primary obligation is to our parents
• The commandment to honor parents is mentioned alongside Tawheed (Oneness of Allah)

**Gratitude to Parents Equals Gratitude to Allah:**
• "And We have enjoined upon man [care] for his parents. His mother carried him, [increasing her] in weakness upon weakness, and his weaning is in two years. Be grateful to Me and to your parents; to Me is the [final] destination." (Quran 31:14)
• Gratitude to Allah is incomplete without showing gratitude to parents
• Being thankful to parents is being thankful to Allah
• Both mentioned together - showing their equal importance

**Among the Most Beloved Deeds:**
• A man asked: "O Messenger of Allah, which deed is most beloved to Allah?" The Prophet ﷺ replied: "Prayer at its proper time." He asked: "Then what?" He said: "Kindness and respect toward parents." He asked: "Then what?" He said: "Jihad in the path of Allah." (Sahih Bukhari & Muslim)
• Honoring parents ranks second only to timely prayer
• Above jihad and all other good deeds
• Shows the immense reward for those who serve their parents

THE TEN ESSENTIAL RIGHTS OF PARENTS:

**1. OBEDIENCE IN LAWFUL MATTERS:**
• Children must obey parents in all matters that do not contradict Islamic law
• The Prophet ﷺ said: "The pleasure of the Lord is in the pleasure of the parents, and the anger of the Lord is in the anger of the parents." (Tirmidhi)
• Obeying parents brings Allah's pleasure and blessings
• Their satisfaction is a key to Paradise
• However, if they command something against Islam, politely refuse but remain respectful

**2. RESPECTFUL AND KIND TREATMENT:**
• Never raise your voice to them
• Never show anger or irritation
• Do not say even "Uff" - the smallest expression of annoyance
• "Whether one or both of them reach old age [while] with you, say not to them [so much as], 'uff'..." (Quran 17:23)
• The word "Uff" represents any expression of disrespect, however small
• Speak to them with a noble, gentle, and loving tone
• Look at them with eyes full of mercy and compassion

**3. HUMILITY AND MERCY:**
• "And lower to them the wing of humility out of mercy and say, 'My Lord, have mercy upon them as they brought me up [when I was] small.'" (Quran 17:24)
• Show complete humility before them
• Remember their sacrifices in raising you
• Never be arrogant or proud in front of them
• Treat them as gently as they treated you in childhood
• Walk humbly, talk softly, and serve willingly

**4. GRATITUDE AND APPRECIATION:**
• Be constantly thankful for everything they have done
• Recognize their countless sacrifices
• Express your gratitude through words and actions
• Remember: your mother carried you for nine months in pain
• She nursed you, changed you, stayed awake nights for you
• Your father worked tirelessly to provide for you
• No amount of service can repay them for even one night of their care

**5. FINANCIAL SUPPORT AND CARE:**
• Provide for their needs, especially in old age
• Ensure they have food, clothing, shelter, and medical care
• Spend on them gladly and generously
• The Prophet ﷺ said: "You and your wealth belong to your father." (Ibn Majah)
• Never consider spending on them as a burden
• It is a privilege and honor to support them
• Allah will bless your wealth for caring for your parents

**6. MAINTAINING FAMILY TIES:**
• Visit them regularly - don't let distance separate you
• Call them frequently if you live far away
• Keep them in your thoughts and prayers always
• The Prophet ﷺ said: "Whosoever believes in Allah and the Last Day, let him keep the ties of relationship." (Sahih Bukhari)
• Visiting parents is among the most beloved acts to Allah
• Their company is more valuable than any worldly pursuit

**7. CONTINUOUS PRAYERS (DUAS):**
• Prayer for parents is not optional - it is a divine command
• "My Lord, have mercy upon them as they brought me up [when I was] small." (Quran 17:24)
• Make dua for them in every prayer
• Ask Allah to forgive their sins
• Pray for their health, happiness, and long life
• These duas are accepted and bring immense blessings
• Continue making dua even after they pass away

**8. CARE IN OLD AGE AND ILLNESS:**
• This is the most critical time to serve them
• When they grow weak, be their strength
• When they forget, be patient and remind them gently
• Never show frustration at their weakness
• Serve them as they served you when you were helpless
• Clean them, feed them, care for them with your own hands
• The Prophet ﷺ said: "May he be disgraced! May he be disgraced! May he be disgraced!" It was asked: "Who, O Messenger of Allah?" He said: "The one who finds his parents in old age, one or both of them, and does not enter Paradise (by serving them)." (Sahih Muslim)
• Allah has made serving elderly parents a direct ticket to Paradise

**9. HONORING AFTER DEATH:**
• The rights of parents continue even after their death
• Make continuous dua and seek forgiveness for them
• Give charity on their behalf (Sadaqah Jariyah)
• Perform Hajj and Umrah for them
• Pay off any debts they left
• Fulfill their unfulfilled wishes
• Maintain ties with their friends and relatives
• The Prophet ﷺ said: "When a person dies, all their deeds end except three: ongoing charity, beneficial knowledge, or a righteous child who prays for them." (Sahih Muslim)
• Your prayers can raise their ranks in Paradise

**10. PATIENCE AND TOLERANCE:**
• Be extremely patient with them, especially in old age
• They may become forgetful, cranky, or difficult
• Remember: they were patient with you during your childhood
• Never complain about caring for them
• This is your test from Allah
• Endure with beautiful patience (Sabr Jameel)

THE SUPREME STATUS OF THE MOTHER:

**Three Times Greater Right Than the Father:**
• A man came to the Prophet ﷺ and asked: "O Messenger of Allah, who among people is most deserving of my good companionship?" He said: "Your mother." The man asked: "Then who?" He said: "Your mother." He asked again: "Then who?" He said: "Your mother." He asked yet again: "Then who?" He said: "Your father." (Sahih Bukhari & Sahih Muslim)
• Mother mentioned three times - father once
• This shows mother has three times more rights
• Due to her immense sacrifices during pregnancy, childbirth, and nursing

**Why Mother Has Superior Rights:**
• "His mother carried him, [increasing her] in weakness upon weakness, and his weaning is in two years." (Quran 31:14)
• She carried you for nine difficult months
• She endured the pain of childbirth
• She nursed you and stayed awake countless nights
• She sacrificed her health, comfort, and youth for you
• Her body underwent permanent changes for your sake
• No human being suffers more for another than a mother for her child

**Paradise Under Her Feet:**
• The Prophet ﷺ said: "Paradise lies under the feet of mothers." (Ahmad, Nasai)
• Serving your mother is the path to Paradise
• Her satisfaction opens the gates of Jannah
• Her displeasure can close them
• Every step you take to serve her brings you closer to Paradise

THE FATHER'S HONORED STATUS:

**Guardian and Provider:**
• The father works tirelessly to provide for his family
• He protects, guides, and teaches
• "You and your wealth belong to your father." (Ibn Majah)
• The father has the right to be served and honored
• His pleasure is essential for success in both worlds

**The Middle Door of Paradise:**
• The Prophet ﷺ said: "The father is the middle gate of Paradise. So it is up to you whether you will protect this gate or destroy it." (Tirmidhi)
• Serving your father is serving Allah
• His prayers for you are answered
• His blessings bring success

SEVERE CONSEQUENCES OF DISOBEDIENCE:

**Among the Greatest Sins:**
• Disobedience to parents (Uquq al-Walidayn) is one of the major sins
• The Prophet ﷺ said: "Shall I not inform you of the gravest of the grave sins?" We said: "Yes, O Messenger of Allah!" He said: "Associating partners with Allah and disobedience to parents." (Sahih Bukhari)
• It is ranked just after shirk - the worst of all sins
• This shows how serious this matter is in Allah's sight

**Exclusion from Paradise:**
• The Prophet ﷺ said: "Three people will not enter Paradise: One who is disobedient to parents, one who drinks alcohol habitually, and one who reminds others of his favors." (Ahmad)
• Allah will not accept the deeds of one who is disobedient to parents
• Their prayers may not be answered
• Their good deeds may be rejected

**Dua of Parents is Always Answered:**
• Both the blessing (dua) and curse (baddua) of parents are accepted
• "And fear Allah through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer." (Quran 4:1)
• If a parent makes dua for you, Allah will grant it
• If a parent curses you out of genuine pain, that curse is accepted
• Never hurt your parents to the point where they make dua against you

**Punishment in This World and the Hereafter:**
• Disobedient children often face hardship in this life
• Their own children may treat them the same way
• "As you sow, so shall you reap"
• In the Hereafter, severe punishment awaits
• They will regret every moment they caused their parents pain

LIMITS OF OBEDIENCE:

**When Obedience is Not Required:**
• Only ONE exception: if they command you to commit shirk (associate partners with Allah)
• "But if they endeavor to make you associate with Me that of which you have no knowledge, do not obey them but accompany them in [this] world with appropriate kindness and follow the way of those who turn back to Me [in repentance]." (Quran 31:15)
• Even if they ask you to do something against Islam, DO NOT obey in that matter
• However, still treat them with utmost kindness and respect
• Explain gently why you cannot obey in that particular matter
• Never be harsh or rude, even when refusing

**Balanced Approach:**
• Obey them in all lawful matters
• If they command something forbidden, politely decline
• Continue to serve them, care for them, and love them
• Separate the command from the person
• You reject the command (if it's against Islam), not the parent

IMMENSE REWARDS FOR HONORING PARENTS:

**Entry to Paradise:**
• The Prophet ﷺ said: "Shall I not tell you of the greatest of the great sins?" The companions said: "Certainly, O Messenger of Allah!" He said: "Associating partners with Allah, and being undutiful to parents."
• Serving parents is a guaranteed path to Paradise
• It is easier to please Allah through parents than through any other deed

**Long Life and Increased Rizq (Sustenance):**
• The Prophet ﷺ said: "Whoever wishes that his life be prolonged and his provision increased, let him maintain good ties with his kinship." (Sahih Bukhari)
• Allah increases blessings in life and wealth for those who honor their parents
• Their duas bring barakah (blessings) in everything

**Companionship of the Prophet ﷺ in Paradise:**
• By serving your parents in this life, you earn the companionship of the Prophet ﷺ in the next life
• What greater reward could there be?

**Forgiveness of Sins:**
• Serving parents earns such immense reward that Allah forgives many sins
• One act of kindness to parents can erase years of wrongdoing

PRACTICAL WAYS TO HONOR PARENTS:

• Greet them with a smile and kind words
• Stand up when they enter the room (out of respect)
• Help them with daily tasks without being asked
• Listen to their stories and advice, even if repeated
• Include them in family decisions
• Never walk ahead of them - walk beside or behind them respectfully
• Feed them with your own hands
• Wash their clothes, clean their room
• Massage their feet when they are tired
• Take them for medical check-ups
• Buy them gifts and make them happy
• Introduce them with pride and honor to your friends
• Never criticize them in front of others
• Defend their honor if anyone speaks ill of them
• Make their old age the best years of their life

REMEMBER: Your parents are your Jannah (Paradise). Whoever has them, has everything. Whoever loses them, has lost the easiest path to Allah's pleasure. Serve them while you still have the chance, for once they are gone, you can never repay them.

May Allah grant us all the ability to serve our parents with the best of character, and may He have mercy on them as they raised us when we were small. Ameen.''',
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
        'arabic': '''حقوق الوالدين

الوالدان لهما أعظم مكانة بعد الله ورسوله.

مكانتهم في الإسلام:
• "وَقَضَىٰ رَبُّكَ أَلَّا تَعْبُدُوا إِلَّا إِيَّاهُ وَبِالْوَالِدَيْنِ إِحْسَانًا" (سورة الإسراء: 23)
• طاعة الوالدين بعد طاعة الله
• الإحسان إلى الوالدين من أعظم الأعمال
• قال النبي ﷺ: "رضا الرب في رضا الوالدين، وسخط الرب في سخط الوالدين" (الترمذي)

الحقوق والواجبات:
• الحديث معهما بكل احترام وإكرام
• عدم قول "أف" أو أي كلمة غير لائقة
• خدمتهما بكل تواضع ومحبة
• الدعاء لهما: "رَّبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا" (سورة الإسراء: 24)
• رعايتهما في الكبر
• استئذانهما في القرارات المهمة

المكانة الخاصة للأم:
• جاء رجل للنبي ﷺ فقال: "من أحق الناس بحسن صحابتي؟" قال: "أمك" قال: "ثم من؟" قال: "أمك" قال: "ثم من؟" قال: "أمك" قال: "ثم من؟" قال: "أبوك" (البخاري ومسلم)
• الجنة تحت أقدام الأمهات
• حق الأم ثلاثة أضعاف حق الأب

عواقب العقوق:
• من كبائر الذنوب في الإسلام
• "وَاتَّقُوا اللَّهَ الَّذِي تَسَاءَلُونَ بِهِ وَالْأَرْحَامَ إِنَّ اللَّهَ كَانَ عَلَيْكُمْ رَقِيبًا" (سورة النساء: 1)
• دعوة الوالد المظلوم مستجابة
• العقوبة في الدنيا والآخرة

متى لا تجب الطاعة:
• فقط إذا أمرا بالشرك بالله
• "وَإِن جَاهَدَاكَ عَلَىٰ أَن تُشْرِكَ بِي مَا لَيْسَ لَكَ بِهِ عِلْمٌ فَلَا تُطِعْهُمَا وَصَاحِبْهُمَا فِي الدُّنْيَا مَعْرُوفًا" (سورة لقمان: 15)
• حتى في هذه الحالة، يجب معاملتهما بالإحسان والاحترام''',
      },
    },
    {
      'number': 2,
      'titleKey': 'family_fazilat_2_rights_of_spouse',
      'title': 'Rights of Spouse',
      'titleUrdu': 'شریک حیات کے حقوق',
      'titleHindi': 'शरीक हयात के हुक़ूक़',
      'titleArabic': 'فضائل الأم',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'details': {
        'english': '''The Rights of Husband and Wife in Islam

Marriage (Nikah) in Islam is a sacred covenant blessed by Allah, designed to foster mutual love, respect, and understanding. It is the foundation of society and a path to Paradise.

THE SACRED NATURE OF MARRIAGE:
• "And of His signs is that He created for you from yourselves mates that you may find tranquility in them; and He placed between you affection and mercy." (Quran 30:21)
• Marriage brings tranquility, love, and mercy
• "They are clothing for you and you are clothing for them." (Quran 2:187) - They protect, beautify, and complete each other
• The Prophet ﷺ said: "Marriage is part of my Sunnah." (Ibn Majah)

RIGHTS OF THE WIFE UPON HER HUSBAND:

1. MAHR (DOWRY):
• "And give the women their gifts graciously." (Quran 4:4)
• Mandatory gift, wife's exclusive property
• Symbolizes respect and commitment

2. COMPLETE FINANCIAL MAINTENANCE:
• "Men are the protectors and maintainers of women, because they support them from their means." (Quran 4:34)
• Must provide food, clothing, shelter, medical care
• Wife's own wealth remains hers alone
• Even if she's wealthier, he must still provide

3. KIND & RESPECTFUL TREATMENT:
• "And live with them in kindness." (Quran 4:19)
• The Prophet ﷺ said: "The best of you are those who are best to their wives." (Tirmidhi)
• Speak gently, show appreciation, express love
• Never be harsh, cruel, or abusive

4. HELP WITH HOUSEHOLD TASKS:
• The Prophet ﷺ helped his wives at home
• Aisha (RA) said: "He would be in the service of his family." (Bukhari)
• Helping at home is Sunnah and sign of good character

5. QUALITY TIME TOGETHER:
• Give her your time and attention
• The Prophet ﷺ raced with Aisha, joked with her
• Do not neglect her emotionally

6. PROTECTION OF DIGNITY:
• Guard her privacy and secrets
• Never humiliate her publicly
• Defend her honor
• The Prophet ﷺ said spreading wife's secrets is among worst sins (Muslim)

7. PHYSICAL INTIMACY WITH KINDNESS:
• Fulfill her needs with gentleness
• Be caring and considerate
• The Prophet ﷺ taught kindness in intimate relations

8. FAIRNESS IN POLYGAMY:
• If multiple wives, MUST be absolutely fair
• Equal time, spending, treatment
• "And you will never be able to be equal between wives..." (Quran 4:129) - Strive for fairness

9. PATIENCE WITH SHORTCOMINGS:
• Everyone has flaws - be forgiving
• The Prophet ﷺ said: "If he dislikes one characteristic, he will be pleased with another." (Muslim)

10. RESPECTING HER FAMILY:
• Be kind to her parents and relatives
• Allow her to visit them
• Help maintain those relationships

RIGHTS OF THE HUSBAND UPON HIS WIFE:

1. OBEDIENCE IN LAWFUL MATTERS:
• Obey in matters not contradicting Islam
• The Prophet ﷺ said: "If a woman prays her five prayers, fasts, guards her chastity and obeys her husband, enter Paradise from any gate you wish." (Ahmad)
• No obedience in sin

2. GUARDING HIS WEALTH:
• Protect his possessions in his absence
• Be responsible with resources
• Do not waste or squander

3. PEACEFUL HOME ENVIRONMENT:
• Make home a place of comfort
• Manage household efficiently
• Welcome him warmly
• Be cheerful and positive

4. RESPECTING HIM:
• Acknowledge his authority as head of household
• Do not undermine him, especially publicly
• Consult him in family matters

5. GRATITUDE FOR HIS EFFORTS:
• Appreciate what he does
• The Prophet ﷺ warned against ingratitude to husbands (Bukhari)
• Express thanks regularly

6. GUARDING CHASTITY:
• Maintain hijab and modesty
• Do not allow non-mahram men when he's absent
• Guard his honor and her own

7. SEEKING PERMISSION TO LEAVE:
• Ask permission for going out
• For protection and coordination
• He should be reasonable

8. BEAUTIFYING FOR HIM:
• Take care of appearance at home
• Personal grooming matters
• Wear nice clothes and fragrance

9. RESPONDING TO INTIMACY:
• Do not refuse without valid reason
• The Prophet ﷺ said angels curse wife who refuses unreasonably (Bukhari & Muslim)
• Unless valid excuse (illness, etc.)

10. RESPECTING HIS FAMILY:
• Be kind to his parents and family
• Serve them with good character

MUTUAL RIGHTS:

• Love, mercy, compassion
• Consultation in major decisions
• Protecting each other's secrets
• Forgiving mistakes
• Supporting in good and bad times
• Making dua for each other
• Working as a team

EXCELLENCE IN CHARACTER:
• The Prophet ﷺ: "The best of you are best to their wives." (Tirmidhi)
• Be playful and joyful together
• Express love and appreciation
• Control anger, speak softly

CONFLICT RESOLUTION:
• Handle disagreements maturely
• Avoid harsh words and raised voices
• Don't let anger control you
• Seek counseling if needed
• Never go to bed angry
• "And live with them in kindness." (Quran 4:19)

FORBIDDEN IN MARRIAGE:
• Physical/emotional abuse
• Forcing spouse into sin
• Withholding rights
• Betrayal and infidelity
• Revealing private matters

May Allah bless all marriages with love, mercy, and barakah. Ameen.''',
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
        'arabic': '''حقوق الزوجين

الزواج رباط مقدس له حقوق وواجبات متبادلة.

حقوق الزوجة:
• النفقة - على الزوج توفير الطعام والكسوة والسكن
• المعاملة الحسنة: "وَعَاشِرُوهُنَّ بِالْمَعْرُوفِ" (سورة النساء: 19)
• قال النبي ﷺ: "خيركم خيركم لأهله، وأنا خيركم لأهلي" (الترمذي)
• احترامها وإكرامها في السر والعلن
• المساعدة في أعمال المنزل (كما كان يفعل النبي ﷺ)
• قضاء الوقت معها
• حماية كرامتها وشرفها
• الصبر على عيوبها

حقوق الزوج:
• الطاعة في غير المعصية
• حفظ ماله وممتلكاته في غيابه
• رعاية البيت وتوفير بيئة هادئة
• قال النبي ﷺ: "إذا صلت المرأة خمسها، وصامت شهرها، وحفظت فرجها، وأطاعت زوجها، قيل لها: ادخلي الجنة من أي أبواب الجنة شئت" (أحمد)
• احترامه وإكرامه
• الشكر على جهوده

الحقوق المشتركة:
• الأمانة والإخلاص
• حسن الخلق والمعاملة
• التعاون في تربية الأولاد
• المشورة في القرارات المهمة
• الحفاظ على الأسرار الزوجية
• التسامح والعفو

نصائح للحياة الزوجية السعيدة:
• الاحترام المتبادل
• التواصل الفعال
• الصبر والتفاهم
• تجنب المقارنة مع الآخرين
• قضاء وقت ممتع معاً
• الدعاء لبعضكما البعض''',
      },
    },
    {
      'number': 3,
      'titleKey': 'family_fazilat_3_rights_of_children',
      'title': 'Rights of Children',
      'titleUrdu': 'بچوں کے حقوق',
      'titleHindi': 'बच्चों के हुक़ूक़',
      'titleArabic': 'فضائل الأب',
      'icon': Icons.child_care,
      'color': Colors.blue,
      'details': {
        'english': '''The Rights of Children in Islam

Children are a precious trust from Allah - a blessing and test. Islam gave children comprehensive rights 1400 years ago that protect, nurture, and honor them.

CHILDREN AS BLESSING:
• "Wealth and children are adornment of worldly life." (Quran 18:46)
• They are Amanah - you will be questioned about how you raised them
• "Your wealth and children are only a trial." (Quran 64:15)
• Properly raised children are ongoing charity after death (Sahih Muslim)

THE 15 ESSENTIAL RIGHTS:

1. RIGHT TO LIFE - No infanticide, every child deserves to be born
2. RIGHT TO PROPER LINEAGE - Know their parents and family name
3. RIGHT TO GOOD NAME - Meaningful names that don't mock
4. RIGHT TO BASIC NEEDS - Food, shelter, clothing, medical care MUST be provided
5. RIGHT TO LOVE & AFFECTION - The GREATEST right! Show love openly
   • The Prophet ﷺ kissed his grandchildren
   • "He who is not merciful will not be treated mercifully." (Bukhari)
6. RIGHT TO EQUAL TREATMENT - "Fear Allah and treat children fairly." (Bukhari & Muslim)
   • No favoritism! Equal gifts, time, love to ALL children
7. RIGHT TO RELIGIOUS EDUCATION:
   • Teach correct belief (Aqeedah) first
   • "Command children to pray at seven years." (Abu Dawud)
   • Teach Quran, Islamic manners, Halal/Haram
8. RIGHT TO WORLDLY EDUCATION:
   • Quality secular education for their future
   • Develop intellect, talents, abilities
   • "Seeking knowledge is obligatory." (Prophet ﷺ)
9. RIGHT TO MORAL TRAINING:
   • "Protect yourselves and families from Fire." (Quran 66:6)
   • Teach honesty, kindness, respect, compassion
10. RIGHT TO FITRAH:
    • "Every child born on fitrah, parents make them Jew/Christian/Magian." (Bukhari)
    • Raise in Islamic environment, protect pure nature
11. RIGHT TO PROTECTION:
    • Physical & emotional protection from harm
    • Islam PROHIBITS child abuse - never hit, scold harshly
    • Prophet ﷺ NEVER hit a child
    • Protect from bad influences, inappropriate content
12. RIGHT TO PLAY:
    • Let children be children!
    • Prophet's ﷺ three stages: Play (0-7), Discipline (7-14), Befriend (14-21)
    • Allow age-appropriate fun and recreation
13. RIGHT TO RESPECT:
    • Never humiliate or embarrass
    • Correct with gentleness
    • Listen when they speak
    • Prophet ﷺ greeted children with Salam
14. RIGHT TO INHERITANCE:
    • Boys and girls have Quranic right to inherit
    • "For men is a share... for women is a share." (Quran 4:7)
15. SPECIAL RIGHTS OF DAUGHTERS:
    • "Whoever raises daughters well, they shield from Hellfire." (Bukhari & Muslim)
    • "Whoever has 2-3 daughters and treats them well enters Paradise." (Tirmidhi)
    • Raise with honor, education, dignity
    • Do not consider them burden
    • Prophet ﷺ loved his daughter Fatimah immensely

PARENTAL DUTIES:

BE A ROLE MODEL - Children learn by watching you
SPEND QUALITY TIME - Most precious gift
MAKE DUA - Pray for their guidance constantly
COMMUNICATE WITH LOVE - Speak gently, encourage
DISCIPLINE WITH WISDOM - Age-appropriate, never in anger
PROTECT INNOCENCE - Monitor media, teach boundaries
PREPARE FOR LIFE - Teach life skills, guide career/spouse choices

CONSEQUENCES OF NEGLECT:
• Allah will question you on Judgment Day
• "Every one is a shepherd responsible for their flock." (Bukhari & Muslim)
• Children may rebel or leave Islam
• No barakah in life
• Punishment in both worlds

REWARDS FOR FULFILLING RIGHTS:
• Children become ongoing charity (Sadaqah Jariyah)
• They make dua after your death
• Shield from Hellfire (especially daughters)
• High ranks in Paradise
• Joy in old age

REMEMBER: Your children are Allah's creation entrusted to you. Raise them with love, teach with wisdom, guide with patience, make constant dua.

May Allah make our children coolness of our eyes and sources of ongoing charity. Ameen.''',
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
        'arabic': '''حقوق الأولاد

للأولاد حقوق عديدة على والديهم في الإسلام.

الحقوق الأساسية:
• اختيار اسم حسن
• الرضاعة والرعاية الصحية
• التربية الإسلامية الصحيحة
• التعليم والتهذيب
• العدل بين الأولاد
• قال النبي ﷺ: "اتقوا الله واعدلوا بين أولادكم" (البخاري)

التربية الإسلامية:
• تعليم القرآن والصلاة
• قال النبي ﷺ: "مروا أولادكم بالصلاة وهم أبناء سبع سنين" (أبو داود)
• تعليم الأخلاق الحميدة
• غرس القيم الإسلامية
• القدوة الحسنة

العدل والمساواة:
• المساواة في العطايا والهدايا
• عدم التمييز بين الذكور والإناث
• معاملة جميع الأولاد بالعدل
• تجنب التفضيل الظاهر

التوجيه والإرشاد:
• الصبر على تربيتهم
• الاستماع لهم وفهم مشاكلهم
• توجيههم بالحكمة والموعظة الحسنة
• تشجيعهم على الخير
• تحذيرهم من السوء بلطف

المسؤوليات المالية:
• توفير المأكل والمسكن
• توفير التعليم المناسب
• الرعاية الصحية
• تأمين مستقبلهم

الدعاء للأولاد:
• "رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ" (سورة الفرقان: 74)
• الدعاء لهم بالصلاح والهداية''',
      },
    },
    {
      'number': 4,
      'titleKey': 'family_fazilat_4_rights_of_siblings',
      'title': 'Rights of Siblings',
      'titleUrdu': 'بہن بھائیوں کے حقوق',
      'titleHindi': 'बहन भाइयों के हुक़ूक़',
      'titleArabic': 'فضائل الأخوة',
      'icon': Icons.people,
      'color': Colors.purple,
      'details': {
        'english': '''Rights of Siblings

In Islam, the bond between siblings is sacred and blessed, built on a foundation of mutual love, respect, and lifelong support. Sibling relationships are among the most enduring connections in life, and Islam emphasizes maintaining these ties with compassion and righteousness.

Quranic Foundation of Brotherhood:

Allah says: "The believers are but brothers, so make settlement between your brothers. And fear Allah that you may receive mercy." (Quran 49:10)

This verse establishes the fundamental principle that all believers are brothers and sisters in faith, with the biological sibling bond being even stronger. Allah commands us to maintain peace, unity, and mutual support among siblings.

"And hold firmly to the rope of Allah all together and do not become divided. And remember the favor of Allah upon you - when you were enemies and He brought your hearts together and you became, by His favor, brothers." (Quran 3:103)

10 Essential Mutual Rights of Siblings:

1. Love and Compassion:
Siblings must genuinely love each other for the sake of Allah. The Prophet ﷺ said: "None of you truly believes until he loves for his brother what he loves for himself." (Bukhari & Muslim)

2. Respect and Honor:
• Maintain dignity and honor in all interactions
• Speak kindly and respectfully
• Avoid mockery, ridicule, or belittling
• Protect each other's reputation
• "O you who have believed, let not a people ridicule [another] people." (Quran 49:11)

3. Sincere Advice (Nasiha):
• Give honest counsel when needed
• Guide towards righteousness
• Warn against harmful paths
• Speak with wisdom and kindness
• The Prophet ﷺ said: "Religion is sincerity." (Muslim)

4. Material Support:
• Share resources generously
• Assist during financial difficulties
• Help in times of need without expectation
• The Prophet ﷺ said: "The believer's shade on the Day of Resurrection will be his charity." (Tirmidhi)

5. Emotional Support:
• Be present during hardships
• Console in times of grief
• Celebrate successes together
• Listen with empathy
• Share joys and sorrows

6. Privacy and Confidentiality:
• Respect personal boundaries
• Keep secrets and private matters confidential
• Don't spy or intrude without permission
• Maintain trust at all times

7. Forgiveness and Patience:
• Overlook minor faults
• Forgive mistakes quickly
• Be patient with shortcomings
• Don't hold grudges
• "And let them pardon and overlook. Would you not like that Allah should forgive you?" (Quran 24:22)

8. Avoiding Envy and Competition:
• Celebrate each other's achievements
• Avoid jealousy over blessings
• Compete only in goodness
• Support each other's growth
• The Prophet ﷺ said: "Do not hate one another, and do not be jealous of one another, and do not turn away from each other, and be servants of Allah as brothers." (Bukhari)

9. Making Dua (Supplication):
• Pray for each other's wellbeing
• Supplicate for their success
• Ask Allah's protection for them
• The Prophet ﷺ said: "The supplication of a Muslim for his brother in his absence will certainly be answered." (Muslim)

10. Standing Up for Justice:
The Prophet ﷺ said: "Help your brother whether he is an oppressor or oppressed." When asked how to help an oppressor, he said: "Prevent him from oppressing, for that is how you help him." (Bukhari)

Special Responsibilities of Elder Siblings:

Elder siblings hold a position of responsibility and should:

1. Be Role Models:
• Demonstrate good Islamic character
• Practice what you preach
• Show excellence in worship and conduct
• Lead by example in all matters

2. Guide with Wisdom:
• Share knowledge and experience
• Advise younger siblings with love
• Teach Islamic values and manners
• Be patient with their learning process

3. Protect and Defend:
• Guard younger siblings from harm
• Stand up for them when needed
• Provide a sense of security
• Shield them from negative influences

4. Share and Care:
• Be generous with possessions
• Help with their needs
• Sacrifice for their wellbeing
• Show compassion in difficult times

5. Mediate and Unite:
• Resolve conflicts among siblings
• Maintain family harmony
• Bridge gaps between family members
• Foster unity and togetherness

Responsibilities of Younger Siblings:

Younger siblings should:

1. Show Respect and Honor:
• Speak respectfully to elder siblings
• Value their advice and guidance
• Acknowledge their sacrifices
• Maintain proper conduct

2. Seek Guidance:
• Learn from their experience
• Ask for advice in matters
• Benefit from their wisdom
• Follow good examples they set

3. Provide Support:
• Help when they need assistance
• Support them as they age
• Care for them in difficult times
• Maintain connection throughout life

4. Express Gratitude:
• Appreciate their efforts
• Thank them for their sacrifices
• Recognize their contributions
• Show love and affection

Special Brother-Sister Relationship:

The relationship between brothers and sisters has unique qualities in Islam:

1. Brothers' Duties Toward Sisters:
• Protect their honor and dignity
• Support them financially if needed
• Guide them with respect and love
• Be their guardian and supporter
• The Prophet ﷺ said: "Whoever has three daughters or sisters, or two daughters or sisters, and lives with them in a good manner and has patience with them, and fears Allah with regard to them, will enter Paradise." (Tirmidhi)

2. Sisters' Duties Toward Brothers:
• Respect and honor them
• Support their righteous endeavors
• Maintain family ties
• Make dua for their success
• Be a source of comfort and strength

Conflict Resolution Among Siblings:

When conflicts arise, Islam teaches:

1. Address Issues Immediately:
• Don't let resentment build
• Communicate openly and honestly
• "And if two factions among the believers should fight, then make settlement between the two." (Quran 49:9)

2. Seek Forgiveness Quickly:
• Apologize when you're wrong
• Accept apologies graciously
• The Prophet ﷺ said: "It is not permissible for a Muslim to forsake his brother for more than three days." (Bukhari & Muslim)

3. Involve Mediation:
• Seek parents' guidance if needed
• Ask respected family members to mediate
• Focus on reconciliation, not winning
• Remember the bond of blood and faith

4. Focus on Solutions:
• Look for win-win outcomes
• Compromise when appropriate
• Prioritize the relationship over ego
• Keep the long-term bond in mind

Severe Consequences of Breaking Sibling Ties:

The Prophet ﷺ warned: "Whoever severs the ties of kinship will not enter Paradise." (Bukhari & Muslim)

Breaking sibling relationships leads to:
• Loss of barakah (blessings) in life
• Prayers not being answered
• Hardship and difficulties
• Distance from Allah's mercy
• Regret in this life and the Hereafter

Immense Rewards for Maintaining Sibling Bonds:

The Prophet ﷺ said: "Whoever would like his rizq (provision) to be increased and his life to be extended, should uphold the ties of kinship." (Bukhari & Muslim)

Benefits include:
• Increased provision and blessings
• Extension of life
• Entry into Paradise
• Allah's pleasure and mercy
• Happiness and peace in family
• Strength and support network
• Good reputation and honor
• Protection from difficulties

Practical Guidelines for Strengthening Sibling Bonds:

1. Regular Communication:
• Call or visit frequently
• Check on their wellbeing
• Share important life updates
• Stay connected despite distances

2. Quality Time Together:
• Spend meaningful time together
• Create positive memories
• Gather for family occasions
• Maintain childhood connections

3. Express Love:
• Say "I love you" regularly
• Show affection appropriately
• Acknowledge their importance
• The Prophet ﷺ said: "When a man loves his brother, let him tell him that he loves him." (Abu Dawud)

4. Participate in Each Other's Lives:
• Attend important events
• Celebrate milestones together
• Support during challenges
• Be present in good times and bad

5. Avoid Harmful Behaviors:
• No backbiting or gossip
• No tale-bearing between siblings
• No favoritism among children
• No comparison or competition

The Prophetic Example:

The Prophet Muhammad ﷺ maintained beautiful relationships with his siblings and foster siblings:
• He loved and honored his foster siblings
• He visited and cared for his relatives
• He taught the importance of family bonds
• He reconciled between disputing brothers
• He showed equal love and justice to all

Remember: The sibling bond is one of Allah's greatest blessings. It's a relationship that should be nurtured with love, maintained with care, and preserved through thick and thin. Your siblings are gifts from Allah - companions in this journey of life and potential companions in Paradise.

May Allah bless all sibling relationships with love, harmony, and righteousness. Ameen.''',
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
        'arabic': '''حقوق الإخوة

للإخوة والأخوات حقوق خاصة في الإسلام.

��لمحبة والود:
• المحبة والمودة بينهم
• التعاون في الخير
• قال النبي ﷺ: "المؤمن للمؤمن كالبنيان يشد بعضه بعضاً" (البخاري)
• نصرة الأخ في الحق

حقوق الأخ الأكبر:
• احترام الأخ الأكبر
• استشارته في الأمور المهمة
• طاعته في المعروف (خاصة بعد وفاة الوالدين)
• الاستفادة من خبرته

حقوق الأخ الأصغر:
• الرحمة به والعطف عليه
• توجيهه وإرشاده
• مساعدته في حاجاته
• حمايته ورعايته

حقوق الأخوات:
• حماية شرفهن وكرامتهن
• الإنفاق عليهن عند الحاجة
• قال النبي ﷺ: "من كان له ثلاث بنات أو ثلاث أخوات، فأحسن إليهن، كن له ستراً من النار" (الترمذي)
• مساعدتهن في الزواج والحياة

تجنب الخلافات:
• العدل بينهم
• عدم الحسد والغيرة
• تجنب الخصومات
• الصلح عند الخلاف
• التنازل عن الحقوق الشخصية للمصلحة العامة

صلة الرحم:
• التواصل المستمر
• الزيارات المنتظمة
• المساعدة المالية عند الحاجة
• الدعاء لبعضهم البعض''',
      },
    },
    {
      'number': 5,
      'titleKey': 'family_fazilat_5_extended_family_rights',
      'title': 'Extended Family Rights',
      'titleUrdu': 'وسیع خاندان کے حقوق',
      'titleHindi': 'वसी ख़ानदान के हुक़ूक़',
      'titleArabic': 'حقوق الأقارب الموسعة',
      'icon': Icons.family_restroom,
      'color': Colors.teal,
      'details': {
        'english': '''Extended Family Rights (Silat ar-Rahm)

In Islam, maintaining ties with extended family (Silat ar-Rahm) is not merely recommended but obligatory. The Arabic term "Rahm" literally means "womb," signifying that all relatives connected through blood deserve honor, care, and continuous relationship. Breaking these ties is among the major sins in Islam.

The Supreme Importance of Family Ties in Islam:

Allah commands: "And fear Allah through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer." (Quran 4:1)

This verse establishes that maintaining family ties is so important that Allah joins it with Taqwa (fear of Allah). He watches how we treat our relatives.

"And those who break the covenant of Allah after contracting it and sever that which Allah has ordered to be joined and cause corruption on earth. It is those who are the losers." (Quran 2:27)

The Prophet ﷺ said: "Whoever would like his provision to be increased and his lifespan to be extended should maintain family ties." (Bukhari & Muslim)

He also warned: "The one who severs the ties of kinship will not enter Paradise." (Bukhari & Muslim)

Rights of Grandparents (Dada, Dadi, Nana, Nani):

Grandparents hold a status nearly equal to parents and deserve immense respect:

1. Honor and Deep Respect:
• Treat them with utmost reverence
• Never speak harshly or raise your voice
• Stand when they enter the room
• Seek their blessings regularly
• The Prophet ﷺ showed great love and respect to his grandfather Abdul Muttalib

2. Regular Visits and Companionship:
• Visit them frequently, not just on occasions
• Spend quality time listening to their stories
• Include them in family activities
• Don't leave them feeling lonely or abandoned
• The Prophet ﷺ said: "He who does not show mercy to our young ones, or acknowledge the rights of our elders, is not one of us." (Tirmidhi)

3. Comprehensive Care in Old Age:
• Attend to their physical needs
• Ensure proper medical care
• Help with daily tasks they can't manage
• Make them feel valued and needed
• Never show frustration or annoyance
• "Your Lord has decreed that you not worship except Him, and to parents, good treatment. Whether one or both of them reach old age [while] with you, say not to them [so much as], 'uff,' and do not repel them but speak to them a noble word." (Quran 17:23)

4. Seek Their Wisdom:
• Learn from their life experiences
• Ask for their advice in matters
• Preserve family history through their stories
• Benefit from their knowledge and insights

5. Make Dua for Them:
• Supplicate for their health and wellbeing
• Pray for their forgiveness
• Ask Allah to grant them Jannah
• Continue making dua even after they pass

Rights of Uncles and Aunts (Chacha, Phupho, Mama, Khala):

1. Paternal Uncle (Chacha) - Father's Brother:
• Represents father in his absence
• Has authority and respect close to father
• The Prophet ﷺ said: "The paternal uncle is equivalent to one's father." (Tirmidhi)
• Obey and respect them like father
• Seek their guidance in important matters
• Support them financially if needed

2. Paternal Aunt (Phupho) - Father's Sister:
• Holds high status as father's closest relative
• The Prophet ﷺ treated his paternal aunt Safiyyah with great honor
• Maintain close ties and show affection
• Visit her and check on her wellbeing
• Include her in family decisions

3. Maternal Uncle (Mama) - Mother's Brother:
• Has special status in Islam
• The Prophet ﷺ said: "The maternal uncle is the father." (Bukhari)
• The Prophet ﷺ honored his uncle Abu Talib greatly
• Show deep respect and love
• Maintain strong relationship
• Value his role in the family

4. Maternal Aunt (Khala) - Mother's Sister:
• The Prophet ﷺ said: "The maternal aunt is like the mother." (Bukhari)
• Should be treated with motherly affection
• Visit her regularly
• Care for her needs
• Seek her blessings and prayers

General Rights of All Uncles and Aunts:
• Speak respectfully and politely
• Visit them regularly
• Help in times of difficulty
• Invite them to family gatherings
• Remember them on special occasions
• Support them financially if they're in need
• Make dua for them
• Maintain contact even if they live far

Rights of Cousins (Family Bonds):

Cousins are like extended siblings and deserve:

1. Mutual Love and Support:
• Treat them like brothers and sisters
• The Prophet ﷺ maintained close bonds with his cousins
• Support each other in righteous endeavors
• Share in joys and sorrows
• Help during difficult times

2. Avoid Family Rivalries:
• Don't compete negatively
• Avoid jealousy over worldly matters
• Don't dispute over inheritance unfairly
• Remember blood bonds are more important than wealth
• "Wealth and children are [but] adornment of the worldly life. But the enduring good deeds are better to your Lord for reward." (Quran 18:46)

3. Maintain Communication:
• Stay in regular contact
• Attend family gatherings together
• Celebrate achievements together
• Console during losses
• Bridge gaps in the family

4. Unite the Family:
• Be a force for family unity
• Reconcile disputes between relatives
• Encourage family gatherings
• Preserve family traditions and bonds

Rights of Nephews and Nieces:

1. Show Love and Affection:
• The Prophet ﷺ showed great love to his grandsons and nephews
• Play with them and make them feel valued
• Give them gifts and treats
• Be a positive role model

2. Guide and Educate:
• Teach them Islamic values
• Share knowledge and wisdom
• Correct them with kindness
• Support their education and growth

3. Support Their Parents:
• Help their parents in raising them
• Assist financially if needed
• Babysit or help when parents need support
• Be a reliable family support system

Comprehensive Guidelines for Maintaining Extended Family Ties:

1. Regular Visits (Ziyarat):
The Prophet ﷺ said: "Whoever believes in Allah and the Last Day, let him maintain the ties of kinship." (Bukhari & Muslim)

• Visit relatives regularly, not just during Eid or weddings
• Don't wait for them to visit first
• Visit especially during illness or hardship
• Attend family gatherings and celebrations
• Make time despite busy schedules

2. Communication:
• Call or message regularly to check on them
• Use modern technology (video calls, WhatsApp) if distance is a barrier
• Remember birthdays and special occasions
• Share good news and seek advice
• Don't let distance or time weaken bonds

3. Financial Support (Sadaqah):
The Prophet ﷺ said: "Charity to the poor is charity, and charity to a relative is two things: charity and upholding the ties of kinship." (Tirmidhi)

• Help poor relatives before helping strangers
• Charity to family has double reward
• Don't make them feel obligated
• Give with dignity and respect
• Support them in times of crisis

4. Emotional Support:
• Be present during difficult times
• Console during grief and loss
• Celebrate during happy occasions
• Listen to their concerns
• Offer encouragement and positive words

5. Mediation and Reconciliation:
"So fear Allah and amend that which is between you and obey Allah and His Messenger, if you should be believers." (Quran 8:1)

• Act as a peacemaker in family disputes
• Don't fuel conflicts or take sides based on bias
• Seek justice and fairness for all
• Forgive mistakes and overlook faults
• Remember unity is more important than winning arguments

6. Respect and Honor:
• Address elders with respectful titles
• Speak politely to all relatives
• Never gossip about family members
• Protect family honor and reputation
• Defend relatives when they're wronged

Severe Consequences of Severing Family Ties:

Allah warns: "Would you then, if you were given authority, cause corruption in the land and sever your ties of kinship? Those are the ones that Allah has cursed, so He deafened them and blinded their vision." (Quran 47:22-23)

The Prophet ﷺ warned: "No one who severs the ties of kinship will enter Paradise." (Bukhari & Muslim)

Consequences include:
• Removal from Allah's mercy
• Prayers not being answered
• Decrease in provision and blessings
• Shortened lifespan
• Family conflicts and problems
• Hardship in this life
• Punishment in the Hereafter
• Entry to Paradise is denied until repentance

Immense Rewards for Maintaining Family Ties:

The Prophet ﷺ said: "Ar-Rahm (the womb/family ties) is suspended from the Throne and says: 'Whoever keeps me, Allah will keep him, and whoever severs me, Allah will sever him.'" (Bukhari & Muslim)

Rewards include:
• Increased provision (rizq)
• Extended lifespan
• Barakah in wealth and time
• Allah's mercy and pleasure
• Protection from difficulties
• Answered prayers
• Happy, harmonious family life
• High status in Paradise
• Ease at the time of death

Special Cases - What If Relatives Are Difficult?

1. If They Wrong You:
• Still maintain ties from your side
• The Prophet ﷺ said: "The one who maintains ties is not the one who reciprocates, but the one who maintains ties with those who sever them." (Bukhari)
• Don't cut ties in response to their cutting
• Keep visiting even if they don't
• Forgive their mistakes

2. If They Are Sinful:
• Maintain ties while disapproving of sin
• Advise them with wisdom and kindness
• Don't support their wrongdoing
• Make dua for their guidance
• Never sever ties due to their sins

3. If Distance Separates You:
• Modern technology makes it easy to connect
• Call, message, or video call regularly
• Visit when possible during holidays
• Send gifts and financial support if needed
• Distance is not an excuse to cut ties

Practical Action Plan:

1. Make a list of all your extended family members
2. Reconnect with those you haven't contacted recently
3. Set reminders to call or visit relatives regularly
4. Attend family gatherings and organize some yourself
5. Help relatives in need
6. Reconcile any disputes within the family
7. Make sincere dua for all your relatives
8. Teach your children the importance of family ties
9. Be the one who initiates contact, don't wait
10. Make intention to please Allah through maintaining ties

Remember: Every phone call, every visit, every act of kindness toward relatives is an act of worship that brings you closer to Allah and increases your blessings in this life and the next.

May Allah help us all maintain strong, loving bonds with our extended families and grant us the reward of Jannah through upholding Silat ar-Rahm. Ameen.''',
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
        'arabic': '''حقوق الأقارب الموسعة

الحفاظ على الروابط الأسرية واجب ديني.

أهمية الروابط الأسرية:
• "وَاتَّقُوا اللَّهَ الَّذِي تَسَاءَلُونَ بِهِ وَالْأَرْحَامَ إِنَّ اللَّهَ كَانَ عَلَيْكُمْ رَقِيبًا" (سورة النساء: 1)
• صلة الرحم تزيد في العمر والرزق
• قال النبي ﷺ: "من سره أن يبسط له في رزقه، وينسأ له في أثره، فليصل رحمه" (البخاري)
• قطع الروابط الأسرية من كبائر الذنوب

حقوق الأجداد:
• إكرامهم واحترامهم كالوالدين
• زيارتهم بانتظام
• رعايتهم في الكبر
• طلب بركاتهم ودعائهم
• التعلم من حكمتهم وخبراتهم
• النبي ﷺ اعتنى بجده عبد المطلب عناية خاصة

حقوق الأعمام والعمات والأخوال والخالات:
• الخال بمنزلة قريبة من الأب
• قال النبي ﷺ: "الخالة بمنزلة الأم" (البخاري)
• العم يمثل الأب في غيابه
• إظهار الاحترام والتقدير لهم
• المحافظة على التواصل المنتظم
• المساعدة في أوقات الحاجة

حقوق أبناء العم والخال:
• هم كالإخوة
• دعم بعضهم البعض
• الحفاظ على علاقات جيدة
• المشاركة في الأفراح والأحزان
• المساعدة في الأوقات الصعبة
• تجنب النزاعات على الميراث

زيارة العائلة:
• الزيارات المنتظمة تقوي الروابط
• مهمة بشكل خاص أثناء المرض
• حضور التجمعات العائلية
• مشاركة الوجبات معاً
• تذكرهم في المناسبات الخاصة
• استخدام التكنولوجيا الحديثة للبقاء على اتصال

الدعم المالي:
• مساعدة الأقارب الفقراء أولاً
• الصدقة على الأقارب لها أجر مضاعف
• قال النبي ﷺ: "الصدقة على المسكين صدقة، وعلى ذي الرحم اثنتان: صدقة وصلة" (الترمذي)
• مشاركة المال في أوقات الشدة

حل النزاعات العائلية:
• العمل كوسيط للصلح
• عدم الانحياز بناء على التحيز
• السعي للعدل والإنصاف
• المسامحة والتغاضي عن الأخطاء
• تذكر أهمية وحدة الأسرة
• "فَاتَّقُوا اللَّهَ وَأَصْلِحُوا ذَاتَ بَيْنِكُمْ" (سورة الأنفال: 1)''',
      },
    },
    {
      'number': 6,
      'titleKey': 'family_fazilat_6_building_strong_families',
      'title': 'Building Strong Families',
      'titleUrdu': 'مضبوط خاندان بنانا',
      'titleHindi': 'मज़बूत ख़ानदान बनाना',
      'titleArabic': 'فضائل الأقارب',
      'icon': Icons.home,
      'color': Colors.green,
      'details': {
        'english': '''Building Strong Families: A Comprehensive Islamic Guide

In Islam, the family is the cornerstone of society and the primary unit through which faith, values, and culture are transmitted from one generation to the next. A strong, righteous family is not just beneficial for its members but is essential for building a healthy Muslim community and pleasing Allah.

The Quranic Vision of Family:

Allah says: "And among His Signs is this, that He created for you mates from among yourselves, that you may dwell in tranquility with them, and He has put love and mercy between your hearts. Verily in that are Signs for those who reflect." (Quran 30:21)

This verse highlights that family is built on three divine foundations:
1. Sakina (Tranquility and Peace)
2. Mawadda (Love and Affection)
3. Rahma (Mercy and Compassion)

The Prophet ﷺ said: "The best of you are those who are best to their families, and I am the best among you to my family." (Tirmidhi)

1. Creating an Islamic Home Environment:

Transform Your House into a Sanctuary:

Starting the Day Right:
• Begin every day with Bismillah and morning adhkar
• Greet family members with "Assalamu Alaikum"
• The Prophet ﷺ said: "When a man enters his house and mentions Allah's name on entering and on his food, Satan says: 'You have no place to spend the night and no supper.'" (Muslim)
• Pray Fajr together as a family when possible
• Make dua for family before leaving for work/school

Physical Environment:
• Keep your home clean and organized - cleanliness is half of faith
• Display Quranic verses and Islamic calligraphy
• Have a dedicated prayer area (Musalla)
• Keep copies of Quran accessible
• Islamic books for different age groups
• Remove or avoid haram images and decorations

Spiritual Atmosphere:
• Recite Quran daily in the home - even if just a few verses
• The Prophet ﷺ said: "The house in which Quran is recited, the angels attend it, devils leave it, and it appears to the inhabitants of heaven like a star." (Tirmidhi)
• Play Quran recitation regularly
• Establish family prayers together
• Make dhikr audible so children learn
• Avoid music and entertainment that contradicts Islamic values

Evening Routine:
• Gather for Maghrib prayer
• Recite evening adhkar as a family
• The Prophet ﷺ would make dua for protection before sleep
• Sleep with wudu when possible
• Teach children bedtime duas

2. Quality Family Time - The Prophetic Way:

Daily Togetherness:
• Eat at least one meal together daily without distractions
• The Prophet ﷺ ate with his family and made it a time of bonding
• Turn off TV, phones, and tablets during meals
• Share stories of the day
• Discuss Islamic teachings during meals

Weekly Family Activities:
• Friday family gatherings after Jummah
• Weekend outings to halal places (parks, museums, nature)
• Game nights with permissible games
• The Prophet ﷺ would race with Aisha (RA) and play with children
• Cooking together
• Quranic memorization competitions
• Family sports activities

Creating Meaningful Traditions:
• Special Ramadan family rituals
• Eid celebrations with unique family customs
• Monthly family meetings
• Birthday celebrations (halal manner)
• Seasonal traditions (Hajj time gatherings, etc.)
• Document family memories through photos and videos

3. Effective Communication - The Heart of Family:

The Prophetic Communication Model:

Active Listening:
• The Prophet ﷺ gave full attention when someone spoke to him
• Put away distractions when family members talk
• Make eye contact and show genuine interest
• Don't interrupt or dismiss feelings
• Listen to understand, not to respond

Respectful Expression:
• Speak with kindness even in disagreement
• "And speak to people good [words]" (Quran 2:83)
• Avoid harsh words, mockery, or sarcasm
• Use "I feel" statements instead of "You always"
• The Prophet ﷺ never spoke harshly to his family

Weekly Family Meetings:
• Designated time for all to share openly
• Discuss plans, concerns, and achievements
• Make decisions together
• Resolve conflicts
• Assign responsibilities fairly
• Celebrate successes

One-on-One Time:
• Each parent should spend individual time with each child
• The Prophet ﷺ gave special attention to each family member
• Understand each child's unique needs
• Build individual bonds
• Create safe space for personal concerns

Encouraging Questions:
• Welcome children's questions about Islam and life
• Answer honestly and age-appropriately
• "Ask the people of knowledge if you do not know" (Quran 16:43)
• Never dismiss or ridicule questions
• Research together if you don't know the answer

4. Teaching Islamic Values - Practical Methods:

Lead by Example:
• Children learn most from what they see
• The Prophet ﷺ said: "Every child is born in a state of fitrah (natural disposition), then his parents make him into a Jew, Christian, or Magian." (Bukhari)
• Practice what you preach
• Your actions speak louder than lectures
• Model prayer, kindness, honesty, and patience

Daily Islamic Education:
• Short daily Quran lessons (even 5-10 minutes)
• Teach one Hadith per week
• Stories of Prophets and Sahaba
• Age-appropriate Islamic books
• Videos of Islamic content (verified sources)
• Tafsir discussions at family level

Make Islam Attractive:
• Present Islam as a mercy and blessing
• Focus on love of Allah, not just fear
• Celebrate Islamic achievements and history
• Make worship enjoyable, not burdensome
• Reward good behavior Islamically
• The Prophet ﷺ made religion easy and encouraged gentleness

Practical Application:
• Discuss Islamic values in daily situations
• When shopping: talk about halal earnings
• When seeing poor: discuss charity and empathy
• During conflicts: apply Islamic conflict resolution
• In success: teach gratitude to Allah
• In hardship: teach patience and trust in Allah

5. Financial Planning - The Islamic Way:

Halal Income:
• Ensure all earnings are from halal sources
• "O you who have believed, eat from the good things which We have provided for you and be grateful to Allah." (Quran 2:172)
• Avoid interest (riba) completely
• Don't work in haram industries
• The Prophet ﷺ said: "Allah is Pure and accepts only what is pure." (Muslim)

Living Within Means:
• Don't try to match others' lifestyles
• Be content with Allah's provision
• "And whoever fears Allah - He will make for him a way out and will provide for him from where he does not expect." (Quran 65:2-3)
• Avoid debt and loans when possible
• Save for emergencies and future

Teaching Children Money Management:
• Give age-appropriate allowances
• Teach saving, spending, and giving
• Involve children in family budgeting
• Explain difference between needs and wants
• Practice delayed gratification
• Teach them to earn through halal means

Regular Family Charity:
• The Prophet ﷺ said: "Charity does not decrease wealth." (Muslim)
• Involve children in sadaqah decisions
• Support orphans and poor together
• Contribute to Islamic causes as a family
• Make charity a joyful family activity

Trust in Allah's Provision:
• "And whoever relies upon Allah - then He is sufficient for him." (Quran 65:3)
• Teach children that Allah is the Provider
• Don't obsess over wealth accumulation
• Be generous and Allah will increase you
• Make dua for halal provision

6. Mutual Support - Building Unbreakable Bonds:

Celebrating Together:
• Acknowledge and celebrate achievements
• Graduations, memorization milestones, etc.
• Islamic achievements (learning prayer, hijab, etc.)
• Make them feel valued and important
• The Prophet ﷺ praised and encouraged his companions

Comforting in Hardship:
• Be present during difficult times
• Listen without judging
• Help practically and emotionally
• Make dua together during trials
• "And seek help through patience and prayer" (Quran 2:45)
• Share burdens as a family unit

Daily Duas:
• Make dua for each family member by name
• Morning and evening protection duas
• Duas before sleep for family safety
• Specific duas for each person's needs
• The Prophet ﷺ constantly made dua for his family

Patience and Forgiveness:
• Accept that everyone makes mistakes
• The Prophet ﷺ said: "All children of Adam are sinners, and the best of sinners are those who repent." (Tirmidhi)
• Forgive quickly and sincerely
• Don't hold grudges within family
• Overlook minor faults
• Focus on good qualities

Teamwork:
• Work together on family projects
• Share household responsibilities fairly
• Support each other's goals
• Make decisions together
• "And cooperate in righteousness and piety" (Quran 5:2)

7. Extended Family Integration:

Regular Gatherings:
• The Prophet ﷺ emphasized maintaining family ties
• Weekly or monthly visits to grandparents
• Organize family reunions annually
• Include extended family in celebrations
• Bridge generational gaps

Cousin Relationships:
• Encourage children to bond with cousins
• Group activities with extended family
• Preserve sibling bonds from next generation
• Create cousin group chats and connections

Preserving Family Legacy:
• Record family Islamic history
• Interview elders about their experiences
• Document family tree
• Share stories of righteous ancestors
• Teach children their heritage

Sharing Responsibilities:
• Help elderly relatives together as a family
• Collective support for family members in need
• Rotate hosting family gatherings
• Care for sick relatives as a team

8. Building Lasting Legacy:

The Prophetic Hadith:
"When a person dies, his deeds come to an end except for three: ongoing charity (Sadaqah Jariyah), beneficial knowledge, or a righteous child who prays for him." (Muslim)

These three represent your eternal investment:

Sadaqah Jariyah:
• Build wells, mosques, Islamic schools as a family
• Plant trees together
• Establish family endowments (waqf)
• Support orphans long-term
• Create Islamic content that benefits others

Beneficial Knowledge:
• Teach Quran and Islamic knowledge
• Write beneficial books or articles
• Support Islamic education initiatives
• Share knowledge through social media
• Mentor others in your profession with Islamic ethics

Righteous Children:
• This is the primary family legacy
• Raise children who will remember you in dua
• The Prophet ﷺ said: "The best of what a man leaves behind are three: a righteous child who supplicates for him, ongoing charity, and knowledge that is benefited from after him." (Ibn Majah)
• Focus on their spiritual development
• Teach them to make dua for parents
• Model righteousness yourself

Practical Legacy Building:
• Create family constitution based on Islamic values
• Establish family traditions of worship
• Start family charitable projects
• Record your Islamic advice for future generations
• Make annual family goals for spiritual growth
• Document your Islamic journey for children to learn from

9. Overcoming Modern Challenges:

Technology Balance:
• Set clear boundaries for screen time
• No devices during family meals or prayer times
• Monitor children's online activities
• Use parental controls wisely
• Model healthy technology use
• Designate "tech-free" family time

Peer Pressure:
• Build children's Islamic identity strongly
• Teach them to be proud Muslims
• Equip them with knowledge to answer questions
• Create Muslim friend circles
• Support them when they face challenges
• The Prophet ﷺ said: "A person is upon the religion of his friend, so let one of you look at whom he befriends." (Tirmidhi)

Maintaining Islamic Values in Non-Muslim Society:
• Make home a strong Islamic haven
• Regular connection with Muslim community
• Islamic schools or weekend classes
• Honest conversations about challenges
• Balance integration without assimilation

10. Daily Action Plan for Strong Families:

Morning:
✓ Wake up for Fajr together
✓ Morning adhkar as a family
✓ Breakfast together when possible
✓ Bismillah and dua before leaving home

During Day:
✓ Check in with family members
✓ Make dua for them
✓ Stay connected through messages
✓ Earn halal and work honestly

Evening:
✓ Maghrib prayer together
✓ Quality family dinner
✓ Quran recitation
✓ Family conversation time
✓ Help with homework/responsibilities

Before Sleep:
✓ Evening adhkar together
✓ Bedtime stories (Islamic)
✓ Individual time with each child
✓ Family dua
✓ Sleep with wudu

Weekly:
✓ Friday Jummah together
✓ Weekend family activity
✓ Visit relatives
✓ Family meeting
✓ Charity activity

Monthly:
✓ Extended family gathering
✓ Review family goals
✓ Special outing
✓ Islamic education assessment
✓ Financial review

Conclusion:

Building a strong Islamic family is the most important project of your life. It requires:
• Sincere intention to please Allah
• Consistent effort and patience
• Following the Prophetic example
• Mutual love and respect
• Continuous learning and improvement

Remember: Your family is your first responsibility and your pathway to Jannah. Invest in them with your time, love, knowledge, and dua.

The Prophet ﷺ said: "The best of you are those who are best to their families, and I am the best among you to my family." (Tirmidhi)

May Allah bless our families with faith, love, health, and righteousness. May He make our homes filled with His remembrance and our children the coolness of our eyes. May He unite us with our families in Jannatul Firdaus. Ameen.''',
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
        'arabic': '''بناء أسر قوية

الأسرة القوية هي أساس المجتمع الإسلامي.

أساسيات الأسرة القوية:
• "وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً" (سورة الروم: 21)
• المحبة والمودة
• الاحترام المتبادل
• التواصل المفتوح
• القيم الإسلامية المشتركة

دور الوالدين في بناء الأسرة:
• القدوة الحسنة في العبادة والأخلاق
• توفير بيئة آمنة ومحبة
• التربية الإسلامية السليمة
• التوازن بين الحزم والرحمة
• قضاء وقت ممتع مع الأولاد
• التواصل الفعال والاستماع

بناء القيم الإسلامية:
• تعليم القرآن والحديث
• الصلاة الجماعية في البيت
• قص القصص النبوية
• المشاركة في الأعمال الخيرية
• الاحتفال بالمناسبات الإسلامية
• زيارة المساجد والمراكز الإسلامية

التربية المتوازنة:
• تعليم العلوم الدينية والدنيوية
• تطوير المهارات والمواهب
• تشجيع الاستقلالية المسؤولة
• تعليم حل المشكلات
• غرس الثقة بالنفس
• تنمية الذكاء العاطفي

وقت العائلة:
• وجبات مشتركة يومية
• ليلة عائلية أسبوعية
• رحلات ونزهات
• قراءة القرآن معاً
• المشاريع المشتركة
• المناقشات الهادفة

حل المشكلات الأسرية:
• الحوار المفتوح والصريح
• الاستماع بدون حكم مسبق
• البحث عن حلول مشتركة
• الاستعانة بالعلماء عند الحاجة
• الصبر والتسامح
• الدعاء والاستغفار

حماية الأسرة:
• الحذر من التأثيرات السلبية
• مراقبة محتوى الإعلام
• اختيار الصحبة الصالحة
• تعليم القيم الأخلاقية
• تعزيز الهوية الإسلامية
• الحفاظ على الخصوصية العائلية

البركة في البيت:
• ذكر الله وقراءة القرآن
• الصلاة في أوقاتها
• الصدقة والإنفاق
• حسن الخلق والتعامل
• الدعاء للأسرة
• الشكر على النعم''',
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
          context.tr('family_fazilat'),
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
                  itemCount: _familyTopics.length,
                  itemBuilder: (context, index) {
                    final topic = _familyTopics[index];
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
    final title = context.tr(topic['titleKey'] ?? 'family_fazilat');
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
                      textDirection: (langCode == 'ur' || langCode == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    responsive.vSpaceXSmall,
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
                            topic['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('family_fazilat'),
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
          categoryKey: 'category_family_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
