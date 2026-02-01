import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class JahannamFazilatScreen extends StatefulWidget {
  const JahannamFazilatScreen({super.key});

  @override
  State<JahannamFazilatScreen> createState() => _JahannamFazilatScreenState();
}

class _JahannamFazilatScreenState extends State<JahannamFazilatScreen> {
  final List<Map<String, dynamic>> _jahannamTopics = [
    {
      'number': 1,
      'titleKey': 'jahannam_fazilat_1_description_of_jahannam',
      'title': 'Description of Jahannam',
      'titleUrdu': 'جہنم کی تفصیل',
      'titleHindi': 'जहन्नम की तफ़सील',
      'titleArabic': 'وصف جهنم',
      'icon': Icons.local_fire_department,
      'color': Colors.red,
      'details': {
        'english': '''Description of Jahannam (Hellfire)

Jahannam is the abode of eternal punishment prepared by Allah Almighty for disbelievers, polytheists, hypocrites, and unrepentant sinners. It is a place of unimaginable torment and suffering.

MEANING AND REALITY:
• The Arabic word "Jahannam" means "a dark storm" or "a stern expression"
• It is a real, physical place that exists now and will exist forever
• "Indeed, Hell is lying in wait, a destination for the transgressors. They will remain therein for ages [unending]." (Quran 78:21-23)
• Created by Allah as a manifestation of His perfect justice
• It serves as the ultimate consequence for those who reject faith and commit grave injustices

THE CREATION OF HELLFIRE:
• When Hell was created, Allah kept it burning for one thousand years until it became red
• Then it was heated for another thousand years until it turned bright white
• Finally heated again for another thousand years until the flames became pitch black
• This pitch-black fire is what exists today - the most intense form of fire
• Real fire that is 70 times hotter than worldly fire
• The Prophet ﷺ said: "The fire you kindle is one of 70 parts of the fire of Hell." (Sahih Bukhari)
• The fire never extinguishes, never decreases, and never requires fuel to maintain

ITS SIZE AND VASTNESS:
• Jahannam is extremely vast and bottomless - beyond human comprehension
• "On the Day when We will say to Hell: 'Are you filled?' It will say: 'Are there any more?'" (Quran 50:30)
• The Prophet ﷺ said: "A stone as big as seven khalifat (huge camels) thrown from the edge of Hell would fall for seventy years before reaching its bottom." (Sahih Muslim)
• So enormous that it needs 70,000 angels to pull each of its seven gates on the Day of Judgment
• The Messenger ﷺ described it: "Jahannam is built inside like a well with side posts, and beside each post there is an angel carrying an iron mace"
• Has a width that would take years to traverse
• Contains valleys, mountains, and endless depths of torment

FUEL OF HELLFIRE:
• Primary fuel: People and stones (idols)
• "O you who have believed, protect yourselves and your families from a Fire whose fuel is people and stones, over which are [appointed] angels, harsh and severe; they do not disobey Allah in what He commands them but do what they are commanded." (Quran 66:6)
• The disbelievers themselves become fuel, continuously burning
• Never needs additional fuel - self-sustaining by Allah's command
• "And they will have no food except from a poisonous, thorny plant" (Quran 88:6)

STRUCTURE AND PHYSICAL FEATURES:
• Seven distinct levels/gates, each deeper and more severe than the last
• "It has seven gates; for every gate is of them a portion designated." (Quran 15:43-44)
• Made of walls of fire, floors of fire, and ceilings of fire
• Contains mountains of fire and valleys of fire
• Rivers of boiling water, pus, and blood flow through it
• Extreme darkness within darkness despite the intense flames
• The fire gives off no light - only burning heat
• Filled with scorching winds and black smoke
• Foul, unbearable smells that suffocate

THE INTENSITY OF ITS HEAT:
• Heat so intense it melts everything - skin, flesh, bones, and organs
• The Prophet ﷺ said: "The mildest punishment for a person in Hell will be that burning coals will be placed under the arch of his feet which will cause his brain to boil." (Sahih Bukhari)
• "And what can make you know what is Hell-Fire? It spares not, nor does it leave [anything]. It scorches the skin." (Quran 74:27-29)
• If even one drop of Jahannam's fire fell on earth, it would destroy all life
• The Prophet ﷺ said: "If one drop from Az-Zaqqum were to land in this world, the people of earth and all their means of sustenance would be destroyed. So how must it be for the one who must eat it?" (Tirmidhi)

THE TREE OF ZAQQUM:
• A cursed tree that springs from the bottom of Hellfire
• "Indeed, the tree of Zaqqum is food for the sinful. Like murky oil, it boils within bellies, like the boiling of scalding water." (Quran 44:43-46)
• "Verily, the tree of Zaqqum will be the food of the sinners. It is like boiling oil, it will boil in the bellies, like the boiling of scalding water." (Quran 44:43-46)
• Its fruits are described as resembling the heads of devils (Quran 37:62-65)
• Extremely bitter and causes immense internal pain
• Does not satisfy hunger but increases suffering

SOUNDS OF HELL:
• Hell has a terrifying roar and fury
• "When they are thrown into it, they hear from it a [dreadful] inhaling while it boils up. It almost bursts with rage." (Quran 67:7-8)
• Continuous screaming, wailing, and crying of its inhabitants
• The sound of chains being dragged
• The crackling and roaring of the flames
• So terrifying that even the angels fear it

THE ETERNAL NATURE:
• For disbelievers and polytheists: ETERNAL punishment with no end
• "And they will cry out therein, 'Our Lord, remove us; we will do righteousness - other than what we were doing!' But did We not grant you life enough for whoever would remember therein to remember? And the warner had come to you. So taste [the punishment], for there is not for the wrongdoers any helper." (Quran 35:37)
• "They will wish to get out of the Fire, but never are they to emerge from it, and for them is an enduring punishment." (Quran 5:37)
• Time in Hell: "Abiding therein for ages [unending]" (Quran 78:23)
• No death, no relief, no escape - only continuous suffering
• "Indeed, whoever comes to his Lord as a criminal - indeed, for him is Hell; he will neither die therein nor live." (Quran 20:74)

THE HORROR BEYOND IMAGINATION:
• If a bucket of Hellfire were revealed to earth, everything would burn instantly
• Its roar and fury frighten even the angels of Allah
• The Prophet ﷺ heard Hell's breathing and became deeply concerned for his Ummah
• He ﷺ said: "If you knew what I know, you would laugh little and weep much." (Sahih Bukhari)
• No eye has seen, no ear has heard such punishment
• The Prophet ﷺ would often cry when thinking about Hellfire
• He said: "Hell is surrounded by desires, and Paradise is surrounded by hardships"

PURPOSE AND WISDOM:
• Demonstrates Allah's perfect justice - every sin has its consequence
• Warning and deterrent for humanity to choose righteousness
• Purification for sinful believers before entering Paradise
• Eternal abode for those who rejected Allah's mercy and guidance
• "And whoever disobeys Allah and His Messenger and transgresses His limits - He will put him into the Fire to abide eternally therein, and he will have a humiliating punishment." (Quran 4:14)

CONVERSATION BETWEEN PARADISE AND HELL:
• The Prophet ﷺ narrated that Paradise and Hell argued before Allah
• Hell said: "I have been favored with the arrogant and tyrants"
• Paradise said: "What is the matter with me? Only the weak and humble enter me"
• Allah said to Paradise: "You are My Mercy which I bestow on whom I wish"
• And to Hell: "You are My punishment with which I punish whom I wish"
• (Sahih Bukhari & Muslim)

May Allah protect us all from the punishment of Hellfire and grant us entry into Paradise. Ameen.''',
        'urdu': '''جہنم کی تفصیل

جہنم ابدی عذاب کی جگہ ہے جسے اللہ نے کافروں اور گنہگاروں کے لیے تیار کیا ہے۔

دوزخ کی حقیقت:
• "بیشک جہنم گھات میں ہے، حد سے بڑھنے والوں کا ٹھکانا۔" (قرآن 78:21-22)
• اللہ نے انصاف اور سزا کی جگہ کے طور پر بنائی
• حقیقی آگ جو دنیاوی آگ سے 70 گنا زیادہ گرم ہے
• نبی کریم ﷺ نے فرمایا: "تم جو آگ جلاتے ہو وہ جہنم کی آگ کے 70 حصوں میں سے ایک ہے۔" (بخاری)

اس کا سائز اور وسعت:
• انتہائی وسیع اور لامحدود
• "جس دن ہم جہنم سے کہیں گے: 'کیا تو بھر گئی؟' وہ کہے گی: 'کیا اور بھی ہیں؟'" (قرآن 50:30)
• نبی کریم ﷺ نے فرمایا: "جہنم میں پھینکا گیا پتھر 70 سال گرتا رہے گا اس کی تہہ تک پہنچنے سے پہلے۔"
• اتنی بڑی کہ قیامت کے دن اسے کھینچنے کے لیے 70,000 فرشتوں کی ضرورت ہے

جہنم کی آگ:
• کبھی نہیں بجھتی اور نہ کم ہوتی ہے
• "ان کا رب انہیں اپنی رحمت اور رضامندی کی خوشخبری دیتا ہے اور باغات کی جن میں ان کے لیے دائمی نعمت ہے۔" (قرآن 9:21)
• ایندھن: لوگ اور پتھر
• "اے ایمان والو! اپنے آپ کو اور اپنے خاندانوں کو اس آگ سے بچاؤ جس کا ایندھن لوگ اور پتھر ہیں۔" (قرآن 66:6)

جسمانی تفصیل:
• شدید گرمی جو سب کچھ پگھلا دیتی ہے
• تاریکی کے اندر تاریکی
• بدبو اور دھواں
• پینے کے لیے کھولتا پانی اور پیپ
• تلخ پھل والا زقوم کا درخت
• زنجیریں، بیڑیاں اور لوہے کے طوق

جہنم کے دروازے:
• سات دروازے، ہر ایک مختلف قسم کے گنہگاروں کے لیے
• "اور بیشک جہنم ان سب کے لیے وعدہ گاہ ہے۔ اس کے سات دروازے ہیں؛ ہر دروازے کے لیے ان میں سے ایک مقررہ حصہ ہے۔" (قرآن 15:43-44)

خوفناکی:
• اگر جہنم کی ایک بالٹی زمین پر ظاہر کر دی جائے تو سب کچھ جل جائے
• اس کی گرج اور غصہ فرشتوں کو بھی خوفزدہ کرتا ہے
• نبی کریم ﷺ نے اس کی سانس سنی اور اپنی امت کے لیے پریشان ہوئے''',
        'hindi': '''जहन्नम की तफ़सील

जहन्नम अबदी अज़ाब की जगह है जिसे अल्लाह ने काफ़िरों और गुनहगारों के लिए तैयार किया है।

दोज़ख़ की हक़ीक़त:
• "बेशक जहन्नम घात में है, हद से बढ़ने वालों का ठिकाना।" (क़ुरआन 78:21-22)
• अल्लाह ने इंसाफ़ और सज़ा की जगह के तौर पर बनाई
• हक़ीक़ी आग जो दुनियावी आग से 70 गुना ज़्यादा गरम है
• नबी करीम ﷺ ने फ़रमाया: "तुम जो आग जलाते हो वो जहन्नम की आग के 70 हिस्सों में से एक है।" (बुख़ारी)

इसका साइज़ और वुसअत:
• इंतिहाई वसीअ और लामहदूद
• "जिस दिन हम जहन्नम से कहेंगे: 'क्या तू भर गई?' वो कहेगी: 'क्या और भी हैं?'" (क़ुरआन 50:30)
• नबी करीम ﷺ ने फ़रमाया: "जहन्नम में फेंका गया पत्थर 70 साल गिरता रहेगा उसकी तह तक पहुंचने से पहले।"
• इतनी बड़ी कि क़यामत के दिन उसे खींचने के लिए 70,000 फ़रिश्तों की ज़रूरत है

जहन्नम की आग:
• कभी नहीं बुझती और न कम होती है
• "उनका रब उन्हें अपनी रहमत और रज़ामंदी की ख़ुशख़बरी देता है और बाग़ात की जिनमें उनके लिए दाइमी नेमत है।" (क़ुरआन 9:21)
• ईंधन: लोग और पत्थर
• "ऐ ईमान वालो! अपने आपको और अपने ख़ानदानों को उस आग से बचाओ जिसका ईंधन लोग और पत्थर हैं।" (क़ुरआन 66:6)

जिस्मानी तफ़सील:
• शदीद गर्मी जो सब कुछ पिघला देती है
• तारीकी के अंदर तारीकी
• बदबू और धुआं
• पीने के लिए खौलता पानी और पीप
• तल्ख़ फल वाला ज़क़्क़ूम का दरख़्त
• ज़ंजीरें, बेड़ियां और लोहे के तौक़

जहन्नम के दरवाज़े:
• सात दरवाज़े, हर एक मुख़्तलिफ़ क़िस्म के गुनहगारों के लिए
• "और बेशक जहन्नम उन सबके लिए वादागाह है। इसके सात दरवाज़े हैं; हर दरवाज़े के लिए उनमें से एक मुक़र्ररा हिस्सा है।" (क़ुरआन 15:43-44)

ख़ौफ़नाकी:
• अगर जहन्नम की एक बाल्टी ज़मीन पर ज़ाहिर कर दी जाए तो सब कुछ जल जाए
• इसकी गर्ज और ग़ुस्सा फ़रिश्तों को भी ख़ौफ़ज़दा करता है
• नबी करीम ﷺ ने इसकी सांस सुनी और अपनी उम्मत के लिए परेशान हुए''',
        'arabic': '''وصف جهنم

جهنم دار العذاب الأليم التي أعدها الله للكافرين.

عظم جهنم:
• "إِذَا رَأَتْهُم مِّن مَّكَانٍ بَعِيدٍ سَمِعُوا لَهَا تَغَيُّظًا وَزَفِيرًا" (سورة الفرقان: 12)
• نارها أشد من نار الدنيا بسبعين مرة
• "نَارُ اللَّهِ الْمُوقَدَةُ * الَّتِي تَطَّلِعُ عَلَى الْأَفْئِدَةِ" (سورة الهمزة: 6-7)
• حرها شديد لا يطاق

بناء جهنم:
• سوداء مظلمة
• لها سبعة أبواب
• "لَهَا سَبْعَةُ أَبْوَابٍ لِّكُلِّ بَابٍ مِّنْهُمْ جُزْءٌ مَّقْسُومٌ" (سورة الحجر: 44)
• أودية وجبال من نار
• لا راحة ولا نجاة منها

شدة حرها:
• قال النبي ﷺ: "نار ابن آدم التي توقدون جزء من سبعين جزءاً من نار جهنم" (البخاري)
• تأكل اللحم والعظم
• تصهر ما في البطون والجلود
• "كُلَّمَا نَضِجَتْ جُلُودُهُم بَدَّلْنَاهُمْ جُلُودًا غَيْرَهَا" (سورة النساء: 56)

طعام أهل النار:
• الزقوم: شجرة تخرج في أصل الجحيم
• "إِنَّ شَجَرَتَ الزَّقُّومِ * طَعَامُ الْأَثِيمِ" (سورة الدخان: 43-44)
• كالمهل يغلي في البطون
• الضريع: طعام لا يسمن ولا يغني من جوع

شراب أهل النار:
• الحميم: الماء الحار المغلي
• "وَسُقُوا مَاءً حَمِيمًا فَقَطَّعَ أَمْعَاءَهُمْ" (سورة محمد: 15)
• الغساق: صديد أهل النار
• يشوي الوجوه

الخلود في النار:
• "خَالِدِينَ فِيهَا أَبَدًا" (سورة الجن: 23)
• لا يموتون فيها ولا يحيون
• "لَا يُقْضَىٰ عَلَيْهِمْ فَيَمُوتُوا" (سورة فاطر: 36)
• عذاب دائم لا ينقطع''',
      },
    },
    {
      'number': 2,
      'titleKey': 'jahannam_fazilat_2_levels_of_hellfire',
      'title': 'Levels of Hellfire',
      'titleUrdu': 'جہنم کے درجات',
      'titleHindi': 'जहन्नम के दर्जात',
      'titleArabic': 'دركات جهنم',
      'icon': Icons.layers,
      'color': Colors.deepOrange,
      'details': {
        'english': '''The Seven Levels of Hellfire

Jahannam is not a single uniform place of punishment, but rather consists of seven distinct levels or gates, each with varying degrees of torment. The deeper the level, the more severe the punishment.

QURANIC FOUNDATION:
• "It has seven gates; for every gate is of them a portion designated." (Quran 15:43-44)
• "And indeed, Hell is the promised place for them all." (Quran 15:43)
• The seven levels were mentioned in authentic Hadith and became widely accepted in Islamic teachings
• Each level corresponds to one of the seven names of Hell mentioned in the Quran
• Assignment to levels is based on the severity and type of sins committed

THE SEVEN LEVELS IN ORDER (FROM TOP TO BOTTOM):

**1. JAHANNAM (جَهَنَّم) - The First Level:**
• The uppermost and least severe level (though still extremely painful)
• Primarily for sinful Muslims who died without repenting from major sins
• Those who committed sins like abandoning prayer, consuming interest (riba), breaking family ties
• NOT eternal for Muslims - they may eventually be cleansed and forgiven
• The Prophet ﷺ said: "People will come out of Hell after having been therein. They will be called the Jahannamiyyun (people of Hell)." (Sahih Bukhari)
• Punishment here includes: Burning flames, chains, and torment
• Duration: Until their sins are purified, then Allah's mercy may save them
• Those who had even an atom's weight of faith will eventually leave

**2. LADHAA/LAZA (لَظَىٰ) - The Second Level:**
• Mentioned in Quran 70:15: "No! Indeed, it is the Flame [of Hell], A remover of exteriors"
• For those who denied Allah and His prophets but didn't commit shirk (polytheism)
• Includes those who knew the truth but deliberately rejected it
• Polytheists and those who associated partners with Allah
• The fire here removes and burns external layers of skin repeatedly
• Intense flames that peel away flesh layer by layer
• Punishment includes: Continuous burning, renewal of skin for repeated torment
• "As often as their skins are roasted through, We will replace them with other skins so they may taste the punishment." (Quran 4:56)

**3. SAQAR (سَقَر) - The Third Level:**
• "I will drive him into Saqar. And what can make you know what is Saqar? It lets nothing remain and leaves nothing [unburned], altering the skins." (Quran 74:26-29)
• For those who neglected prayer (one of the greatest sins)
• For those who didn't give charity and refused to help the poor
• For those who denied the Day of Judgment
• For the Magians (fire-worshippers) and Zoroastrians
• This fire scorches the skin completely - "It spares not, nor does it leave"
• Extreme heat that burns continuously without pause
• The Prophet ﷺ said: "A person neglecting his Salah shall remain in Jahannam for one Huqb (80 years, each day equivalent to 1000 years)"

**4. AL-HUTAMAH (ٱلْحُطَمَة) - The Fourth Level:**
• "No! He will surely be thrown into the Crusher. And what can make you know what is the Crusher? It is the fire of Allah, [eternally] fueled, which mounts directed at the hearts." (Quran 104:4-7)
• The "Crusher" or "Breaker" - crushes and breaks everything
• For those who consumed wealth in falsehood and hoarded money
• For greedy tyrants, usurers, and those who withheld Zakat
• For slanderers and those who caused division in communities
• For the Jews who distorted their scriptures and rejected prophets
• Fire that reaches the hearts and internal organs
• Punishment: Being crushed repeatedly, fire burning from inside out
• "It mounts directed at the hearts" - most painful internal burning

**5. JAHEEM (جَحِيم) - The Fifth Level:**
• "And those who disbelieved will be driven to Hell in groups." (Quran 39:71)
• For idol worshippers and those who worshipped false gods
• For those who led others astray from the path of Allah
• For major disbelievers who openly denied Allah
• Extremely intense blazing fire
• Name means "blazing fire" or "fierce blaze"
• Continuous torture with no moment of rest
• Inhabitants are driven in groups and thrown in
• Fire so intense it can be heard roaring from far away

**6. SA'EER (سَعِير) - The Sixth Level:**
• "Soon I will drive him into Hellfire. And what can make you know what is Hellfire?" (Quran 74:26-27)
• For satanic forces and devils (Shayateen)
• For their human followers who obeyed Satan over Allah
• For tyrants, dictators, and corrupt rulers who abused authority
• For those who spread misguidance through media, influence, or policy
• For religious hypocrites who used Islam for worldly gain
• Extremely fierce blazing fire
• Punishment includes: Being bound with devils, continuous torment
• "And when they are thrown into it at a narrow place therein bound in chains, they will cry out thereupon for destruction." (Quran 25:13)

**7. AL-HAWIYAH (ٱلْهَاوِيَة) - The Seventh and Lowest Level:**
• "And what can make you know what that is? It is a Fire, intensely hot." (Quran 101:9-11)
• The deepest, darkest, and most painful level of Hell
• The "Bottomless Pit" or "Abyss" - no end to its depth
• Primarily for HYPOCRITES (Munafiqun) - the worst of all people
• "Indeed, the hypocrites will be in the lowest depths of the Fire - and never will you find for them a helper." (Quran 4:145)
• For those who pretended to be Muslims but disbelieved inside
• For backbiters and those who destroyed others' reputations
• For non-believers who died in a state of disbelief
• Heat so intense it cannot be imagined
• Darkest level with no light, only burning torment
• NO ESCAPE - eternal punishment with no relief
• Distance to fall: The Prophet ﷺ said a stone would fall for 70 years to reach the bottom

THE INTENSITY INCREASES WITH DEPTH:
• Each level is progressively hotter, darker, and more painful than the one above
• The punishment becomes more severe as one descends
• The distance between each level is tremendous
• Heat multiplies as you go deeper
• The lowest levels have unimaginable, indescribable torment
• Some people will have fire only at their ankles (lightest), while others will be completely submerged (most severe)
• The Prophet ﷺ said: "The person who will have the least punishment among the people of Hell on the Day of Resurrection will be a man under whose arch of the feet will be placed two smoldering embers, and his brain will boil because of them." (Sahih Muslim)

PRINCIPLES OF DIVINE JUSTICE:
• "For all there are degrees from what they have done, and [it is] so that He may fully compensate them for their deeds, and they will not be wronged." (Quran 6:132)
• Each person receives punishment exactly matching their sins
• No one is wronged - perfect justice from Allah
• Greater sins = deeper levels = more severe punishment
• The punishment fits the crime perfectly

TEMPORARY vs ETERNAL PUNISHMENT:

**For Sinful Muslims (Believers with Major Sins):**
• May enter the first level (Jahannam) if they died without repentance
• Punishment is temporary, not eternal
• Duration depends on the severity of sins and Allah's wisdom
• Intercession of Prophet Muhammad ﷺ may save them
• Allah's mercy may forgive them at any time
• "Allah does not forgive association with Him, but He forgives what is less than that for whom He wills." (Quran 4:48)
• Eventually will leave Hell and enter Paradise
• Will be called "Al-Jahannamiyyun" (the people who were in Jahannam)

**For Disbelievers, Polytheists, and Hypocrites:**
• Eternal punishment with absolutely no escape
• "They will wish to get out of the Fire, but never are they to emerge from it, and for them is an enduring punishment." (Quran 5:37)
• No intercession will benefit them
• No reduction in punishment - only increase
• "Abiding therein eternally" (Quran 98:6)
• Will remain "ages upon ages" without end (Quran 78:23)

SPECIAL PUNISHMENT FOR HYPOCRITES:
• Hypocrites receive the worst punishment - lowest level
• Worse than open disbelievers because they deceived Muslims
• The Prophet ﷺ said: "The hypocrite is more dangerous to the Ummah than open disbelievers"
• They will have no helpers, no supporters
• Their punishment will be the most severe and humiliating
• "And never will you find for them any protector or helper" (Quran 4:145)

THE VARIOUS DEGREES OF HEAT:
• Each level has progressively more intense heat
• Bottom levels (Hawiyah, Sa'eer, Jaheem) have heat beyond comprehension
• Some will be punished with fire at ankles only
• Some up to knees, some up to waist
• Some completely immersed in fire
• The Prophet ﷺ saw in a vision: "Some up to their ankles, some up to their knees, some up to their waists, and some up to their necks" (Sahih Muslim)

WHO ASSIGNS PEOPLE TO LEVELS:
• Allah Almighty in His perfect justice
• Based on the complete record of deeds (Book of Deeds)
• Nothing is hidden - every deed is accounted for
• "So whoever does an atom's weight of good shall see it, and whoever does an atom's weight of evil shall see it." (Quran 99:7-8)
• Angels present the record, Allah judges with perfect fairness

HOPE AND WARNING FOR BELIEVERS:
• Avoid all major sins, especially: Shirk, murder, adultery, theft, lying, backbiting
• Pray five times daily without fail
• Give Zakat and charity regularly
• Be kind to parents and maintain family ties
• Seek Allah's forgiveness constantly through repentance
• Perform good deeds to outweigh bad ones
• Remember: "Indeed, good deeds do away with misdeeds." (Quran 11:114)
• The Prophet ﷺ warned: "Paradise is surrounded by hardships, and Hell is surrounded by desires"
• Control desires, resist temptations, and fear Allah

May Allah protect us from all levels of Hellfire and grant us the highest levels of Paradise. Ameen.''',
        'urdu': '''جہنم کے درجات

جہنم کے مختلف درجات ہیں، ہر ایک میں گناہوں کی شدت کے مطابق مختلف سزائیں ہیں۔

جہنم کے سات درجات:
1. جہنم - پہلا درجہ گنہگار مسلمانوں کے لیے جو بالآخر معاف ہو جائیں گے
2. لظیٰ - عیسائیوں کے لیے
3. الحطمہ - یہودیوں کے لیے
4. سعیر - صابیوں کے لیے
5. سقر - آتش پرستوں کے لیے
6. الجحیم - بت پرستوں کے لیے
7. ہاویہ - منافقوں کے لیے سب سے گہرا درجہ

سب سے نچلا درجہ - منافقوں کے لیے:
• "بیشک منافق جہنم کے سب سے نچلے درجے میں ہوں گے۔" (قرآن 4:145)
• ان لوگوں کے لیے سب سے بُری سزا جو مسلمان ہونے کا دکھاوا کرتے تھے
• نبی کریم ﷺ نے فرمایا نفاق کھلے کفر سے بدتر ہے
• اس درجے سے کوئی فرار نہیں

گناہوں کی بنیاد پر درجات:
• ہر شخص اپنے اعمال کے مطابق
• "سب کے لیے ان کے اعمال کے مطابق درجات ہیں۔" (قرآن 6:132)
• کبیرہ گناہ گہرے درجات کی طرف لے جاتے ہیں
• ظالم اور جابر سخت سزا میں
• جو فساد پھیلاتے ہیں انہیں شدید عذاب

عارضی بمقابلہ مستقل:
• گنہگار مسلمان: سزا کے بعد معاف ہو کر جنت میں جا سکتے ہیں
• کافر اور منافق: ابدی سزا، کبھی نہیں نکلیں گے
• "وہ چاہیں گے کہ آگ سے نکل جائیں، لیکن وہ کبھی نہیں نکلیں گے۔" (قرآن 5:37)

درجات کے درمیان حرکت:
• اللہ اپنی حکمت سے سزا بڑھا یا کم کر سکتا ہے
• نبی کریم ﷺ کی شفاعت کچھ مسلمانوں کو بچا سکتی ہے
• کافروں کے لیے کوئی شفاعت نہیں
• اللہ کی طرف سے حتمی انصاف

گرمی کے درجات:
• ہر درجہ اوپر والے سے زیادہ گرم
• نچلے درجات میں ناقابل تصور گرمی
• الہاویہ (اتھاہ گڑھا) میں سب سے شدید آگ
• نبی کریم ﷺ نے فرمایا کچھ لوگوں کے ٹخنوں تک آگ ہوگی جبکہ دوسرے مکمل طور پر ڈوبے ہوں گے

مومنوں کے لیے تنبیہ:
• مومن بھی اپنے گناہوں کے لیے جہنم چکھ سکتے ہیں
• مسلسل معافی مانگیں
• خاص طور پر کبیرہ گناہوں سے بچیں
• نبی کریم ﷺ نے خبردار کیا: "جنت مشکلات سے گھری ہے اور جہنم خواہشات سے گھری ہے۔"''',
        'hindi': '''जहन्नम के दर्जात

जहन्नम के मुख़्तलिफ़ दर्जात हैं, हर एक में गुनाहों की शिद्दत के मुताबिक़ मुख़्तलिफ़ सज़ाएं हैं।

जहन्नम के सात दर्जात:
1. जहन्नम - पहला दर्जा गुनहगार मुसलमानों के लिए जो बिलआख़िर माफ़ हो जाएंगे
2. लज़ा - ईसाइयों के लिए
3. अल-हुतमा - यहूदियों के लिए
4. सईर - साबियों के लिए
5. सक़र - आतिश परस्तों के लिए
6. अल-जहीम - बुत परस्तों के लिए
7. हाविया - मुनाफ़िक़ों के लिए सबसे गहरा दर्जा

सबसे निचला दर्जा - मुनाफ़िक़ों के लिए:
• "बेशक मुनाफ़िक़ जहन्नम के सबसे निचले दर्जे में होंगे।" (क़ुरआन 4:145)
• उन लोगों के लिए सबसे बुरी सज़ा जो मुसलमान होने का दिखावा करते थे
• नबी करीम ﷺ ने फ़रमाया निफ़ाक़ खुले कुफ़्र से बदतर है
• इस दर्जे से कोई फ़रार नहीं

गुनाहों की बुनियाद पर दर्जात:
• हर शख़्स अपने आमाल के मुताबिक़
• "सबके लिए उनके आमाल के मुताबिक़ दर्जात हैं।" (क़ुरआन 6:132)
• कबीरा गुनाह गहरे दर्जात की तरफ़ ले जाते हैं
• ज़ालिम और जाबिर सख़्त सज़ा में
• जो फ़साद फैलाते हैं उन्हें शदीद अज़ाब

अरज़ी बमुक़ाबला मुस्तक़िल:
• गुनहगार मुसलमान: सज़ा के बाद माफ़ होकर जन्नत में जा सकते हैं
• काफ़िर और मुनाफ़िक़: अबदी सज़ा, कभी नहीं निकलेंगे
• "वो चाहेंगे कि आग से निकल जाएं, लेकिन वो कभी नहीं निकलेंगे।" (क़ुरआन 5:37)

दर्जात के दरमियान हरकत:
• अल्लाह अपनी हिकमत से सज़ा बढ़ा या कम कर सकता है
• नबी करीम ﷺ की शफ़ाअत कुछ मुसलमानों को बचा सकती है
• काफ़िरों के लिए कोई शफ़ाअत नहीं
• अल्लाह की तरफ़ से हतमी इंसाफ़

गर्मी के दर्जात:
• हर दर्जा ऊपर वाले से ज़्यादा गरम
• निचले दर्जात में नाक़ाबिले तसव्वुर गर्मी
• अल-हाविया (अथाह गड्ढा) में सबसे शदीद आग
• नबी करीम ﷺ ने फ़रमाया कुछ लोगों के टखनों तक आग होगी जबकि दूसरे मुकम्मल तौर पर डूबे होंगे

मोमिनों के लिए तंबीह:
• मोमिन भी अपने गुनाहों के लिए जहन्नम चख सकते हैं
• मुसलसल माफ़ी मांगें
• ख़ास तौर पर कबीरा गुनाहों से बचें
• नबी करीम ﷺ ने ख़बरदार किया: "जन्नत मुश्किलात से घिरी है और जहन्नम ख़्वाहिशात से घिरी है।"''',
        'arabic': '''دركات جهنم

لجهنم دركات ومنازل متفاوتة في العذاب.

الدركات السبع:
• جهنم: أعلاها
• لظى: دركة شديدة الحرارة
• الحطمة: تحطم كل شيء
• السعير: نار مستعرة
• سقر: شديدة السواد
• الجحيم: نار ملتهبة
• الهاوية: أسفل دركات النار

أهل كل دركة:
• "إِنَّ الْمُنَافِقِينَ فِي الدَّرْكِ الْأَسْفَلِ مِنَ النَّارِ" (سورة النساء: 145)
• المنافقون في الدرك الأسفل
• الكفار في دركات حسب كفرهم
• العصاة من المؤمنين في الدركات العليا

شدة العذاب:
• كلما نزل الدرك زاد العذاب
• الدرك الأسفل أشد عذاباً
• "لَهُمْ مِن فَوْقِهِمْ ظُلَلٌ مِّنَ النَّارِ وَمِن تَحْتِهِمْ ظُلَلٌ" (سورة الزمر: 16)

خزنة جهنم:
• ملائكة غلاظ شداد
• "عَلَيْهَا تِسْعَةَ عَشَرَ" (سورة المدثر: 30)
• "لَّا يَعْصُونَ اللَّهَ مَا أَمَرَهُمْ" (سورة التحريم: 6)
• يزيدون في عذاب أهل النار

مالك خازن النار:
• رئيس خزنة جهنم
• "وَنَادَوْا يَا مَالِكُ لِيَقْضِ عَلَيْنَا رَبُّكَ" (سورة الزخرف: 77)
• لا يجيبهم إلا بعد ألف عام
• يقول لهم: إنكم ماكثون

التفاوت في العذاب:
• "لِكُلٍّ دَرَجَاتٌ مِّمَّا عَمِلُوا" (سورة الأنعام: 132)
• يتفاوت العذاب بحسب الذنوب
• أخف أهل النار عذاباً من له نعلان من نار
• أشدهم عذاباً المنافقون والمشركون''',
      },
    },
    {
      'number': 3,
      'titleKey': 'jahannam_fazilat_3_people_of_hellfire',
      'title': 'People of Hellfire',
      'titleUrdu': 'جہنم کے لوگ',
      'titleHindi': 'जहन्नम के लोग',
      'titleArabic': 'أهل النار',
      'icon': Icons.groups,
      'color': Colors.brown,
      'details': {
        'english': '''People of Hellfire

Certain categories of people are warned of severe punishment in Hellfire.

Disbelievers and Polytheists:
• "Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills." (Quran 4:48)
• Those who deny Allah and His messengers
• Those who worship idols or associate partners with Allah
• Those who reject the truth after it came to them
• Eternal punishment with no escape

Hypocrites (Munafiqun):
• Worst punishment in the lowest level of Hell
• Those who pretend to be Muslims but disbelieve inside
• "Indeed, the hypocrites will be in the lowest depths of the Fire - and never will you find for them a helper." (Quran 4:145)
• They deceived the believers in this world

Major Sinners Among Muslims:
• Those who persist in major sins without repentance
• Murderers: "Whoever kills a believer intentionally, his recompense is Hell." (Quran 4:93)
• Those who consume riba (interest)
• Those who consume orphans' wealth
• Those who abandon prayer deliberately
• Those who disobey parents severely
• Those who break family ties

Oppressors and Tyrants:
• Those who oppress and harm others
• Unjust rulers and leaders
• Those who spread corruption on earth
• The Prophet ﷺ said: "The oppressor and the one who helps him and the one who is pleased with it are all partners in sin."

Specific Categories Mentioned:
• Those who are arrogant and prideful
• Backbiters and slanderers
• Liars and false witnesses
• Those who consume alcohol
• Adulterers and fornicators
• Those who practice black magic
• Fortune tellers and astrologers
• Those who break trusts

Women Warned Specifically:
• The Prophet ﷺ saw most inhabitants of Hell were women
• Due to: being ungrateful to husbands, cursing frequently, and ingratitude to kindness
• Not an eternal punishment for Muslim women who repent

Men Warned Specifically:
• Those who are unjust to their wives
• Those who don't provide for their families
• Those who don't lower their gaze
• Those who are miserly and don't give charity

The Way to Avoid:
• Sincere faith in Allah alone
• Following the Prophet Muhammad ﷺ
• Avoiding all major sins
• Repenting sincerely from all sins
• Seeking Allah's forgiveness constantly''',
        'urdu': '''جہنم کے لوگ

کچھ خاص قسم کے لوگوں کو جہنم میں سخت سزا کی تنبیہ ہے۔

کافر اور مشرک:
• "بیشک اللہ شرک کو معاف نہیں کرتا، لیکن اس سے کم جو چاہے معاف کر دیتا ہے۔" (قرآن 4:48)
• جو اللہ اور اس کے رسولوں کا انکار کرتے ہیں
• جو بتوں کی پوجا کرتے ہیں یا اللہ کے ساتھ شریک ٹھہراتے ہیں
• جو حق آنے کے بعد اسے رد کرتے ہیں
• ابدی سزا بغیر کسی فرار کے

منافق:
• جہنم کے سب سے نچلے درجے میں سب سے بُری سزا
• جو مسلمان ہونے کا دکھاوا کرتے ہیں لیکن اندر سے کافر ہیں
• "بیشک منافق جہنم کی سب سے نچلی تہہ میں ہوں گے - اور تم ان کے لیے کوئی مددگار نہیں پاؤ گے۔" (قرآن 4:145)
• انہوں نے اس دنیا میں مومنوں کو دھوکہ دیا

مسلمانوں میں کبیرہ گنہگار:
• جو توبہ کیے بغیر کبیرہ گناہوں پر اصرار کرتے ہیں
• قاتل: "جو کسی مومن کو جان بوجھ کر قتل کرے، اس کی سزا جہنم ہے۔" (قرآن 4:93)
• جو سود کھاتے ہیں
• جو یتیموں کا مال کھاتے ہیں
• جو جان بوجھ کر نماز چھوڑتے ہیں
• جو والدین کی سخت نافرمانی کرتے ہیں
• جو رشتے توڑتے ہیں

ظالم اور جابر:
• جو دوسروں پر ظلم کرتے اور نقصان پہنچاتے ہیں
• ناانصاف حکمران اور لیڈر
• جو زمین پر فساد پھیلاتے ہیں
• نبی کریم ﷺ نے فرمایا: "ظالم اور جو اس کی مدد کرے اور جو اس سے خوش ہو سب گناہ میں شریک ��یں۔"

مخصوص زمرے:
• جو مغرور اور متکبر ہیں
• غیبت کرنے والے اور بہتان لگانے والے
• جھوٹے اور جھوٹے گواہ
• جو شراب پیتے ہیں
• زنا کار
• جو کالا جادو کرتے ہیں
• نجومی اور فال گیر
• جو امانت میں خیانت کرتے ہیں

خواتین کو خاص تنبیہ:
• نبی کریم ﷺ نے دیکھا جہنم کے زیادہ تر باشندے خواتین تھیں
• وجوہات: شوہر کی ناشکری، کثرت سے لعنت کرنا، اور احسان کی ناشکری
• توبہ کرنے والی مسلمان خواتین کے لیے ابدی سزا نہیں

مردوں کو خاص تنبیہ:
• جو اپنی بیویوں پر ظلم کرتے ہیں
• جو اپنے خاندانوں کی کفالت نہیں کرتے
• جو نظریں نیچی نہیں کرتے
• جو بخیل ہیں اور صدقہ نہیں دیتے

بچنے کا راستہ:
• صرف اللہ پر مخلص ایمان
• نبی محمد ﷺ کی پیروی
• تمام کبیرہ گناہوں سے پرہیز
• تمام گناہوں سے مخلصانہ توبہ
• مسلسل اللہ سے معافی مانگنا''',
        'hindi': '''जहन्नम के लोग

कुछ ख़ास क़िस्म के लोगों को जहन्नम में सख़्त सज़ा की तंबीह है।

काफ़िर और मुशरिक:
• "बेशक अल्लाह शिर्क को माफ़ नहीं करता, लेकिन उससे कम जो चाहे माफ़ कर देता है।" (क़ुरआन 4:48)
• जो अल्लाह और उसके रसूलों का इंकार करते हैं
• जो बुतों की पूजा करते हैं या अल्लाह के साथ शरीक ठहराते हैं
• जो हक़ आने के बाद उसे रद करते हैं
• अबदी सज़ा बग़ैर किसी फ़रार के

मुनाफ़िक़:
• जहन्नम के सबसे निचले दर्जे में सबसे बुरी सज़ा
• जो मुसलमान होने का दिखावा करते हैं लेकिन अंदर से काफ़िर हैं
• "बेशक मुनाफ़िक़ जहन्नम की सबसे निचली तह में होंगे - और तुम उनके लिए कोई मददगार नहीं पाओगे।" (क़ुरआन 4:145)
• उन्होंने इस दुनिया में मोमिनों को धोका दिया

मुसलमानों में कबीरा गुनहगार:
• जो तौबा किए बग़ैर कबीरा गुनाहों पर इसरार करते हैं
• क़ातिल: "जो किसी मोमिन को जानबूझकर क़त्ल करे, उसकी सज़ा जहन्नम है।" (क़ुरआन 4:93)
• जो सूद खाते हैं
• जो यतीमों का माल खाते हैं
• जो जानबूझकर नमाज़ छोड़ते हैं
• जो वालिदैन की सख़्त नाफ़रमानी करते हैं
• जो रिश्ते तोड़ते हैं

ज़ालिम और जाबिर:
• जो दूसरों पर ज़ुल्म करते और नुक़सान पहुंचाते हैं
• नाइंसाफ़ हुक्मरान और लीडर
• जो ज़मीन पर फ़साद फैलाते हैं
• नबी करीम ﷺ ने फ़रमाया: "ज़ालिम और जो उसकी मदद करे और जो उससे ख़ुश हो सब गुनाह में शरीक हैं।"

मख़सूस ज़ुमरे:
• जो मग़रूर और मुतकब्बिर हैं
• ग़ीबत करने वाले और बोहतान लगाने वाले
• झूठे और झूठे गवाह
• जो शराब पीते हैं
• ज़िनाकार
• जो काला जादू करते हैं
• नजूमी और फ़ाल गीर
• जो अमानत में ख़यानत करते हैं

ख़वातीन को ख़ास तंबीह:
• नबी करीम ﷺ ने देखा जहन्नम के ज़्यादातर बाशिंदे ख़वातीन थीं
• वजूहात: शौहर की नाशुक्री, कसरत से लानत करना, और एहसान की नाशुक्री
• तौबा करने वाली मुसलमान ख़वातीन के लिए अबदी सज़ा नहीं

मर्दों को ख़ास तंबीह:
• जो अपनी बीवियों पर ज़ुल्म करते हैं
• जो अपने ख़ानदानों की किफ़ालत नहीं करते
• जो निगाहें नीची नहीं करते
• जो बख़ील हैं और सदक़ा नहीं देते

बचने का रास्ता:
• सिर्फ़ अल्लाह पर मुख़्लिस ईमान
• नबी मुहम्मद ﷺ की पैरवी
• तमाम कबीरा गुनाहों से परहेज़
• तमाम गुनाहों से मुख़्लिसाना तौबा
• मुसलसल अल्लाह से माफ़ी मांगना''',
        'arabic': '''أهل النار

من هم أهل النار وأعمالهم.

الكفار والمشركون:
• "إِنَّ اللَّهَ لَا يَغْفِرُ أَن يُشْرَكَ بِهِ" (سورة النساء: 48)
• الذين كفروا بالله ورسله
• المشركون الذين عبدوا غير الله
• "إِنَّهُ مَن يُشْرِكْ بِاللَّهِ فَقَدْ حَرَّمَ اللَّهُ عَلَيْهِ الْجَنَّةَ" (سورة المائدة: 72)
• خالدون فيها أبداً

المنافقون:
• "إِنَّ الْمُنَافِقِينَ فِي الدَّرْكِ الْأَسْفَلِ مِنَ النَّارِ" (سورة النساء: 145)
• الذين يظهرون الإيمان ويبطنون الكفر
• عذابهم أشد من الكفار
• في الدرك الأسفل من النار

أصحاب الكبائر:
• من مات على كبيرة دون توبة
• قد يدخل النار بذنوبه
• ثم يخرج بالشفاعة أو فضل الله
• "مَن كَانَ فِي قَلْبِهِ مِثْقَالُ ذَرَّةٍ مِّنْ إِيمَانٍ" يخرج

الظالمون:
• "أَلَا لَعْنَةُ اللَّهِ عَلَى الظَّالِمِينَ" (سورة هود: 18)
• الذين ظلموا أنفسهم بالمعاصي
• ظلموا الناس في حقوقهم
• منعوا الزكاة واغتصبوا الأموال

قتلة الأنفس:
• "وَمَن يَقْتُلْ مُؤْمِنًا مُّتَعَمِّدًا فَجَزَاؤُهُ جَهَنَّمُ" (سورة النساء: 93)
• القاتل المتعمد في النار
• خالداً فيها إلا أن يتوب

آكلو الربا:
• "الَّذِينَ يَأْكُلُونَ الرِّبَا لَا يَقُومُونَ" (سورة البقرة: 275)
• محاربون لله ورسوله
• عذابهم شديد في النار

العاقون للوالدين:
• من أكبر الكبائر
• قال النبي ﷺ: "ألا أنبئكم بأكبر الكبائر؟" قالوا: بلى، قال: "الإشراك بالله، وعقوق الوالدين" (البخاري)''',
      },
    },
    {
      'number': 4,
      'titleKey': 'jahannam_fazilat_4_punishments_in_hellfire',
      'title': 'Punishments in Hellfire',
      'titleUrdu': 'جہنم میں سزائیں',
      'titleHindi': 'जहन्नम में सज़ाएं',
      'titleArabic': 'عذاب النار',
      'icon': Icons.dangerous,
      'color': Colors.red.shade900,
      'details': {
        'english': '''Punishments in Hellfire

The punishments of Hell are severe and varied according to the sins committed.

Physical Torments:
• Burning in eternal fire that never extinguishes
• "As often as their skins are roasted through, We will replace them with other skins so they may taste the punishment." (Quran 4:56)
• Skin continuously renewed for endless torment
• Boiling water poured over heads, melting internal organs
• "Over their heads will be poured boiling water, by which is melted that within their bellies and their skins." (Quran 22:19-20)

Food and Drink:
• Tree of Zaqqum with bitter, thorny fruit
• "Indeed, the tree of zaqqum is food for the sinful, like murky oil, it boils within bellies, like the boiling of scalding water." (Quran 44:43-46)
• Boiling water and pus (ghislin) to drink
• Food that neither nourishes nor satisfies hunger
• Thorny plants that choke

Chains and Shackles:
• Iron chains around necks and feet
• "When the shackles are around their necks and the chains; they will be dragged." (Quran 40:71)
• Heavy iron collars that burn
• Unable to escape or move freely
• Dragged through fire

Garments of Fire:
• "For them are cut out garments of fire." (Quran 22:19)
• Clothing made of molten copper
• Burns skin continuously
• No relief or escape

Emotional and Psychological Torment:
• Eternal regret and remorse
• "And they will cry out therein, 'Our Lord, remove us; we will do righteousness.'" (Quran 35:37)
• Seeing Paradise and knowing they can never enter
• Blamed by companions and family members
• Despair and hopelessness

Different Punishments for Different Sins:
• Backbiters: Eating the flesh of their brothers
• Liars: Lips and tongues cut with scissors of fire
• Those who consumed riba: Standing like one beaten by Satan
• Adulterers: In a furnace resembling an oven
• Those who didn't pay Zakat: Wealth turned into snakes
• Oppressors: Drinking boiling water
• Arrogant: In the form of small ants being trampled

Special Punishments:
• Pharaoh and his followers in the worst punishment
• Abu Lahab and his wife - specific torment mentioned in Quran
• Hypocrites in the lowest level with severest punishment

The Angels of Hell (Zabaniyah):
• 19 mighty angels guard Hell
• Extremely stern and severe
• Never disobey Allah's commands
• "O you who have believed, protect yourselves and your families from a Fire whose fuel is people and stones, over which are appointed angels, harsh and severe." (Quran 66:6)

No Relief or Escape:
• "They will wish to get out of the Fire, but never are they to emerge from it, and for them is an enduring punishment." (Quran 5:37)
• Punishment never decreases for disbelievers
• No death or sleep to provide relief
• Eternal suffering''',
        'urdu': '''جہنم میں سزائیں

جہنم کی سزائیں سخت اور کیے گئے گناہوں کے مطابق مختلف ہیں۔

جسمانی عذاب:
• ابدی آگ میں جلنا جو کبھی نہیں بجھتی
• "جب ان کی کھالیں پک جائیں گی تو ہم انہیں دوسری کھالوں سے بدل دیں گے تاکہ وہ عذاب کا مزہ چکھیں۔" (قرآن 4:56)
• کھال مسلسل تجدید ہوتی رہتی ہے لامتناہی عذاب کے لیے
• سروں پر کھولتا پانی ڈالا جاتا ہے، اندرونی اعضاء پگھل جاتے ہیں
• "ان کے سروں پر کھولتا پانی ڈالا جائے گا جس سے ان کے پیٹوں اور کھالوں کے اندر کی چیزیں پگھل جائیں گی۔" (قرآن 22:19-20)

کھانا اور پینا:
• زقوم کا درخت تلخ، کانٹے دار پھل کے ساتھ
• "بیشک زقوم کا درخت گنہگاروں کا کھانا ہے، گدلے تیل کی طرح، پیٹوں میں کھولتا ہے، کھولتے پانی کی طرح۔" (قرآن 44:43-46)
• پینے کے لیے کھولتا پانی اور پیپ (غسلین)
• کھانا جو نہ غذا دے نہ بھوک مٹائے
• کانٹے دار پودے جو گلا گھونٹ دیں

زنجیریں اور بیڑیاں:
• گردنوں اور پیروں میں لوہے کی زنجیریں
• "جب ان کی گردنوں میں طوق اور زنجیریں ہوں گی؛ انہیں گھسیٹا جائے گا۔" (قرآن 40:71)
• بھاری لوہے کے طوق جو جلاتے ہیں
• فرار یا آزادی سے حرکت نہیں کر سکتے
• آگ میں گھسیٹے جاتے ہیں

آگ کے لباس:
• "ان کے لیے آگ کے لباس کاٹے گئے ہیں۔" (قرآن 22:19)
• پگھلے ہوئے تانبے کے کپڑے
• کھال مسلسل جلتی رہتی ہے
• کوئی راحت یا فرار نہیں

جذباتی اور نفسیاتی عذاب:
• ابدی افسوس اور ندامت
• "اور وہ اس میں چیخیں گے، 'اے ہمارے رب، ہمیں نکال دے؛ ہم نیک عمل کریں گے۔'" (قرآن 35:37)
• جنت کو دیکھنا اور جاننا کہ وہ کبھی داخل نہیں ہو سکتے
• ساتھیوں اور خاندان کے افراد کی طرف سے ملامت
• مایوسی اور ناامیدی

مختلف گناہوں کے لیے مختلف سزائیں:
• غیبت کرنے والے: اپنے بھائیوں کا گوشت کھانا
• جھوٹے: آگ کی قینچیوں سے ہونٹ اور زبان کاٹنا
• سود کھانے والے: شیطان کی ماری ہوئی حالت میں کھڑے ہونا
• زنا کار: تندور جیسی بھٹی میں
• زکوٰۃ نہ دینے والے: دولت سانپوں میں بدل جاتی ہے
• ظالم: کھولتا پانی پینا
• متکبر: چھوٹی چیونٹیوں کی شکل میں روندے جانا

خاص سزائیں:
• فرعون اور اس کے پیروکار سب سے بُری سزا میں
• ابو لہب اور اس کی بیوی - قرآن میں مخصوص عذاب کا ذکر
• منافق سب سے نچلے درجے میں سخت ترین سزا کے ساتھ

جہنم کے فرشتے (زبانیہ):
• 19 طاقتور فرشتے جہنم کی حفاظت کرتے ہیں
• انتہائی سخت اور شدید
• کبھی اللہ کے حکموں کی نافرمانی نہیں کرتے
• "اے ایمان والو! اپنے آپ کو اور اپنے خاندانوں کو اس آگ سے بچاؤ جس کا ایندھن لوگ اور پتھر ہیں، جس پر سخت اور شدید فرشتے مقرر ہیں۔" (قرآن 66:6)

کوئی راحت یا فرار نہیں:
• "وہ چاہیں گے کہ آگ سے نکل جائیں، لیکن وہ کبھی نہیں نکلیں گے، اور ان کے لیے دائمی عذاب ہے۔" (قرآن 5:37)
• کافروں کے لیے سزا کبھی کم نہیں ہوتی
• راحت کے لیے کوئی موت یا نیند نہیں
• ابدی تکلیف''',
        'hindi': '''जहन्नम में सज़ाएं

जहन्नम की सज़ाएं सख़्त और किए गए गुनाहों के मुताबिक़ मुख़्तलिफ़ हैं।

जिस्मानी अज़ाब:
• अबदी आग में जलना जो कभी नहीं बुझती
• "जब उनकी खालें पक जाएंगी तो हम उन्हें दूसरी खालों से बदल देंगे ताकि वो अज़ाब का मज़ा चखें।" (क़ुरआन 4:56)
• खाल मुसलसल तजदीद होती रहती है लामुतनाही अज़ाब के लिए
• सरों पर खौलता पानी डाला जाता है, अंदरूनी आज़ा पिघल जाते हैं
• "उनके सरों पर खौलता पानी डाला जाएगा जिससे उनके पेटों और खालों के अंदर की चीज़ें पिघल जाएंगी।" (क़ुरआन 22:19-20)

खाना और पीना:
• ज़क़्क़ूम का दरख़्त तल्ख़, कांटेदार फल के साथ
• "बेशक ज़क़्क़ूम का दरख़्त गुनहगारों का खाना है, गदले तेल की तरह, पेटों में खौलता है, खौलते पानी की तरह।" (क़ुरआन 44:43-46)
• पीने के लिए खौलता पानी और पीप (ग़स्लीन)
• खाना जो न ग़िज़ा दे न भूक मिटाए
• कांटेदार पौधे जो गला घोंट दें

ज़ंजीरें और बेड़ियां:
• गर्दनों और पैरों में लोहे की ज़ंजीरें
• "जब उनकी गर्दनों में तौक़ और ज़ंजीरें होंगी; उन्हें घसीटा जाएगा।" (क़ुरआन 40:71)
• भारी लोहे के तौक़ जो जलाते हैं
• फ़रार या आज़ादी से हरकत नहीं कर सकते
• आग में घसीटे जाते हैं

आग के लिबास:
• "उनके लिए आग के लिबास काटे गए हैं।" (क़ुरआन 22:19)
• पिघले हुए तांबे के कपड़े
• खाल मुसलसल जलती रहती है
• कोई राहत या फ़रार नहीं

जज़्बाती और नफ़सियाती अज़ाब:
• अबदी अफ़सोस और नदामत
• "और वो उसमें चीखेंगे, 'ऐ हमारे रब, हमें निकाल दे; हम नेक अमल करेंगे।'" (क़ुरआन 35:37)
• जन्नत को देखना और जानना कि वो कभी दाख़िल नहीं हो सकते
• साथियों और ख़ानदान के अफ़राद की तरफ़ से मलामत
• मायूसी और नाउम्मीदी

मुख़्तलिफ़ गुनाहों के लिए मुख़्तलिफ़ सज़ाएं:
• ग़ीबत करने वाले: अपने भाइयों का गोश्त खाना
• झूठे: आग की क़ैंचियों से होंठ और ज़बान काटना
• सूद खाने वाले: शैतान की मारी हुई हालत में खड़े होना
• ज़िनाकार: तंदूर जैसी भट्टी में
• ज़कात न देने वाले: दौलत सांपों में बदल जाती है
• ज़ालिम: खौलता पानी पीना
• मुतकब्बिर: छोटी चींटियों की शक्ल में रौंदे जाना

ख़ास सज़ाएं:
• फ़िरऔन और उसके पैरोकार सबसे बुरी सज़ा में
• अबू लहब और उसकी बीवी - क़ुरआन में मख़सूस अज़ाब का ज़िक्र
• मुनाफ़िक़ सबसे निचले दर्जे में सख़्त तरीन सज़ा के साथ

जहन्नम के फ़रिश्ते (ज़बानिया):
• 19 ताक़तवर फ़रिश्ते जहन्नम की हिफ़ाज़त करते हैं
• इंतिहाई सख़्त और शदीद
• कभी अल्लाह के हुक्मों की नाफ़रमानी नहीं करते
• "ऐ ईमान वालो! अपने आपको और अपने ख़ानदानों को उस आग से बचाओ जिसका ईंधन लोग और पत्थर हैं, जिस पर सख़्त और शदीद फ़रिश्ते मुक़र्रर हैं।" (क़ुरआन 66:6)

कोई राहत या फ़रार नहीं:
• "वो चाहेंगे कि आग से निकल जाएं, लेकिन वो कभी नहीं निकलेंगे, और उनके लिए दाइमी अज़ाब है।" (क़ुरआन 5:37)
• काफ़िरों के लिए सज़ा कभी कम नहीं होती
• राहत के लिए कोई मौत या नींद नहीं
• अबदी तकलीफ़''',
        'arabic': '''عذاب النار

أنواع العذاب في جهنم.

العذاب الجسدي:
• "كُلَّمَا نَضِجَتْ جُلُودُهُم بَدَّلْنَاهُمْ جُلُودًا غَيْرَهَا" (سورة النساء: 56)
• النار تحرق الجلود
• تبديل الجلود لاستمرار العذاب
• تأكل اللحم والعظام

السلاسل والأغلال:
• "إِنَّا أَعْتَدْنَا لِلْكَافِرِينَ سَلَاسِلَ وَأَغْلَالًا وَسَعِيرًا" (سورة الإنسان: 4)
• يقيدون بالسلاسل والأغلال
• سلسلة طولها سبعون ذراعاً
• "ثُمَّ فِي سِلْسِلَةٍ ذَرْعُهَا سَبْعُونَ ذِرَاعًا فَاسْلُكُوهُ" (سورة الحاقة: 32)

الحميم والغساق:
• "وَسُقُوا مَاءً حَمِيمًا فَقَطَّعَ أَمْعَاءَهُمْ" (سورة محمد: 15)
• الماء المغلي يقطع الأمعاء
• الغساق: صديد أهل النار
• يشوي الوجوه ويصهر البطون

طعام الزقوم:
• "إِنَّ شَجَرَتَ الزَّقُّومِ * طَعَامُ الْأَثِيمِ" (سورة الدخان: 43-44)
• شجرة خبيثة في أصل الجحيم
• طلعها كأنه رؤوس الشياطين
• كالمهل يغلي في البطون

العذاب المعنوي:
• الخزي والهوان
• "فَذُوقُوا فَلَن نَّزِيدَكُمْ إِلَّا عَذَابًا" (سورة النبأ: 30)
• الندم الشديد على ما فات
• الحسرة واليأس
• سماع الزفير والشهيق

استمرار العذاب:
• "وَالَّذِينَ كَفَرُوا لَهُمْ نَارُ جَهَنَّمَ" (سورة فاطر: 36)
• لا راحة ولا نوم
• لا يموتون ولا يحيون
• "كُلَّمَا خَبَتْ زِدْنَاهُمْ سَعِيرًا" (سورة الإسراء: 97)''',
      },
    },
    {
      'number': 5,
      'titleKey': 'jahannam_fazilat_5_protection_from_hellfire',
      'title': 'Protection from Hellfire',
      'titleUrdu': 'جہنم سے حفاظت',
      'titleHindi': 'जहन्नम से हिफ़ाज़त',
      'titleArabic': 'الحماية من النار',
      'icon': Icons.shield_outlined,
      'color': Colors.green,
      'details': {
        'english': '''Protection from Hellfire

Allah has provided numerous ways to protect ourselves from the punishment of Hell.

Fundamentals of Protection:
• Sincere belief in Allah alone (Tawheed)
• Belief in all prophets and the Last Prophet Muhammad ﷺ
• Belief in the Day of Judgment
• Following the teachings of Quran and Sunnah
• The Prophet ﷺ said: "Whoever says 'La ilaha illallah' sincerely from the heart will enter Paradise."

Through Prayer and Worship:
• Establishing the five daily prayers on time
• Praying with concentration (khushu)
• Fasting in Ramadan properly
• Giving Zakat and charity regularly
• Performing Hajj when able
• "Indeed, good deeds do away with misdeeds." (Quran 11:114)

Through Dhikr and Duas:
• Morning and evening adhkar for daily protection
• Frequent seeking of forgiveness (Istighfar)
• Saying "SubhanAllah, Alhamdulillah, La ilaha illallah, Allahu Akbar"
• Dua: "Allahumma ajirni min an-nar" (O Allah, protect me from the Fire) - say 7 times after Fajr and Maghrib

Specific Protective Actions:
• Praying Fajr and Asr in congregation - guarantee from Hellfire
• Fasting on Day of Arafah - protection for two years
• Fasting Mondays and Thursdays regularly
• Reciting Ayat al-Kursi after every prayer
• Last two verses of Surah Al-Baqarah at night
• Teaching Quran to children

Through Good Character:
• Being just and fair with everyone
• Controlling anger and forgiving others
• Being kind to parents - door to Paradise
• Maintaining family ties
• The Prophet ﷺ said: "Good character is the heaviest thing on the scale."

Avoiding Major Sins:
• Stay away from shirk (associating partners with Allah)
• Avoid interest/usury (riba)
• Don't consume alcohol or drugs
• Stay away from adultery and fornication
• Don't oppress or harm others
• Guard your tongue from backbiting and lying
• Respect parents and maintain family ties

Sincere Repentance:
• Repent immediately after any sin
• Feel genuine remorse
• Firm intention not to return to sin
• Make amends if you wronged someone
• Allah loves those who repent sincerely

Seeking Knowledge:
• Learn about Islam properly
• Understand what pleases and displeases Allah
• Know the major sins to avoid them
• "Whoever takes a path upon which to obtain knowledge, Allah makes the path to Paradise easy for him." (Muslim)

Protection for Children:
• Teach them Tawheed from young age
• Make them love Allah and the Prophet ﷺ
• Teach them to pray properly
• Recite Quran to them and teach them
• Make dua for their guidance
• Be a good example

The Prophet's Guarantee:
• The Prophet ﷺ said: "Guarantee me six things and I will guarantee you Paradise: speak the truth, fulfill promises, return trusts, guard your chastity, lower your gaze, and restrain your hands from harm."

Constant Dua:
• "Our Lord, give us in this world good and in the Hereafter good and protect us from the punishment of the Fire." (Quran 2:201)
• Always ask Allah for protection from Hellfire in your daily duas''',
        'urdu': '''جہنم سے حفاظت

اللہ نے جہنم کی سزا سے اپنے آپ کو بچانے کے متعدد طریقے فراہم کیے ہیں۔

حفاظت کی بنیادیں:
• صرف اللہ پر مخلص عقیدہ (توحید)
• تمام نبیوں اور آخری نبی محمد ﷺ پر ایمان
• قیامت کے دن پر ایمان
• قرآن اور سنت کی تعلیمات کی پیروی
• نبی کریم ﷺ نے فرمایا: "جو دل سے مخلصانہ 'لا الہ الا اللہ' کہے وہ جنت میں داخل ہوگا۔"

نماز اور عبادت کے ذریعے:
• پانچ وقت کی نمازیں وقت پر قائم کرنا
• خشوع کے ساتھ نماز پڑھنا
• رمضان میں صحیح طریقے سے روزہ رکھنا
• زکوٰۃ اور صدقہ باقاعدگی سے دینا
• طاقت ہونے پر حج کرنا
• "بیشک نیکیاں برائیوں کو مٹا دیتی ہیں۔" (قرآن 11:114)

ذکر اور دعاؤں کے ذریعے:
• روزانہ حفاظت کے لیے صبح شام کے اذکار
• کثرت سے استغفار
• "سبحان اللہ، الحمد للہ، لا الہ الا اللہ، اللہ اکبر" کہنا
• دعا: "اللھم اجرنی من النار" (اے اللہ، مجھے آگ سے بچا) - فجر اور مغرب کے بعد 7 بار کہیں

مخصوص حفاظتی اعمال:
• جماعت سے فجر اور عصر کی نماز - جہنم سے ضمانت
• عرفہ کے دن روزہ - دو سال کی حفاظت
• پیر اور جمعرات کو باقاعدگی سے روزہ
• ہر نماز کے بعد آیت الکرسی پڑھنا
• رات کو سورہ بقرہ کی آخری دو آیات
• بچوں کو قرآن سکھانا

اچھے اخلاق کے ذریعے:
• سب کے ساتھ منصفانہ اور عادلانہ ہونا
• غصے پر قابو اور دوسروں کو معاف کرنا
• والدین کے ساتھ نیک سلوک - جنت کا دروازہ
• رشتے برقرار رکھنا
• نبی کریم ﷺ نے فرمایا: "اچھا اخلاق میزان میں سب سے بھاری چیز ہے۔"

کبیرہ گناہوں سے بچنا:
• شرک (اللہ کے ساتھ شریک ٹھہرانا) سے دور رہنا
• سود سے بچنا
• شراب یا منشیات استعمال نہ کرنا
• زنا سے دور رہنا
• دوسروں پر ظلم یا نقصان نہ پہنچانا
• غیبت اور جھوٹ سے اپنی زبان کی حفاظت کرنا
• والدین کا احترام اور رشتے برقرار رکھنا

مخلصانہ توبہ:
• کسی بھی گناہ کے بعد فوری توبہ کریں
• حقیقی ندامت محسوس کریں
• گناہ کی طرف نہ لوٹنے کا پختہ ارادہ
• اگر کسی کا حق مارا ہو تو تلافی کریں
• اللہ ان سے محبت کرتا ہے جو مخلصانہ توبہ کرتے ہیں

علم حاصل کرنا:
• اسلام کو صحیح طریقے سے سیکھیں
• جانیں کہ اللہ کو کیا پسند اور ناپسند ہے
• کبیرہ گناہوں کو جانیں تاکہ ان سے بچ سکیں
• "جو علم حاصل کرنے کے لیے راستہ اختیار کرتا ہے، اللہ اس کے لیے جنت کا راستہ آسان کر دیتا ہے۔" (مسلم)

بچوں کی حفاظت:
• انہیں چھوٹی عمر سے توحید سکھائیں
• انہیں اللہ اور نبی ﷺ سے محبت کریں
• انہیں صحیح طریقے سے نماز سکھائیں
• انہیں قرآن سنائیں اور سکھائیں
• ان کی ہدایت کے لیے دعا کریں
• اچھی مثال بنیں

نبی کریم ﷺ کی ضمانت:
• نبی کریم ﷺ نے فرمایا: "مجھے چھ چیزوں کی ضمانت دو اور میں تمہیں جنت کی ضمانت دوں گا: سچ بولو، وعدے پورے کرو، امانتیں لوٹاؤ، اپنی عفت کی حفاظت کرو، نظریں نیچی رکھو، اور اپنے ہاتھوں کو نقصان سے روکو۔"

مسلسل دعا:
• "اے ہمارے رب، ہمیں اس دنیا میں بھلائی دے اور آخرت میں بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔" (قرآن 2:201)
• ہمیشہ اپنی روزانہ کی دعاؤں میں اللہ سے جہنم سے حفاظت مانگیں''',
        'hindi': '''जहन्नम से हिफ़ाज़त

अल्लाह ने जहन्नम की सज़ा से अपने आपको बचाने के मुतअद्दिद तरीक़े फ़राहम किए हैं।

हिफ़ाज़त की बुनियादें:
• सिर्फ़ अल्लाह पर मुख़्लिस अक़ीदा (तौहीद)
• तमाम नबियों और आख़िरी नबी मुहम्मद ﷺ पर ईमान
• क़यामत के दिन पर ईमान
• क़ुरआन और सुन्नत की तालीमात की पैरवी
• नबी करीम ﷺ ने फ़रमाया: "जो दिल से मुख़्लिसाना 'ला इलाहा इल्लल्लाह' कहे वो जन्नत में दाख़िल होगा।"

नमाज़ और इबादत के ज़रिए:
• पांच वक़्त की नमाज़ें वक़्त पर क़ायम करना
• ख़ुशू के साथ नमाज़ पढ़ना
• रमज़ान में सही तरीक़े से रोज़ा रखना
• ज़कात और सदक़ा बाक़ायदगी से देना
• ताक़त होने पर हज करना
• "बेशक नेकियां बुराइयों को मिटा देती हैं।" (क़ुरआन 11:114)

ज़िक्र और दुआओं के ज़रिए:
• रोज़ाना हिफ़ाज़त के लिए सुबह शाम के अज़कार
• कसरत से इस्तिग़फ़ार
• "सुब्हानल्लाह, अलहम्दुलिल्लाह, ला इलाहा इल्लल्लाह, अल्लाहु अकबर" कहना
• दुआ: "अल्लाहुम्म अजिरनी मिनन्नार" (ऐ अल्लाह, मुझे आग से बचा) - फ़ज्र और मग़रिब के बाद 7 बार कहें

मख़सूस हिफ़ाज़ती आमाल:
• जमाअत से फ़ज्र और अस्र की नमाज़ - जहन्नम से ज़मानत
• अरफ़ा के दिन रोज़ा - दो साल की हिफ़ाज़त
• पीर और जुमेरात को बाक़ायदगी से रोज़ा
• हर नमाज़ के बाद आयतुल कुर्सी पढ़ना
• रात को सूरा बक़रा की आख़िरी दो आयतें
• बच्चों को क़ुरआन सिखाना

अच्छे अख़्लाक़ के ज़रिए:
• सबके साथ मुंसिफ़ाना और आदिलाना होना
• ग़ुस्से पर क़ाबू और दूसरों को माफ़ करना
• वालिदैन के साथ नेक सुलूक - जन्नत का दरवाज़ा
• रिश्ते बरक़रार रखना
• नबी करीम ﷺ ने फ़रमाया: "अच्छा अख़्लाक़ मीज़ान में सबसे भारी चीज़ है।"

कबीरा गुनाहों से बचना:
• शिर्क (अल्लाह के साथ शरीक ठहराना) से दूर रहना
• सूद से बचना
• शराब या मुनश्शियात इस्तेमाल न करना
• ज़िना से दूर रहना
• दूसरों पर ज़ुल्म या नुक़सान न पहुंचाना
• ग़ीबत और झूठ से अपनी ज़बान की हिफ़ाज़त करना
• वालिदैन का एहतेराम और रिश्ते बरक़रार रखना

मुख़्लिसाना तौबा:
• किसी भी गुनाह के बाद फ़ौरन तौबा करें
• हक़ीक़ी नदामत महसूस करें
• गुनाह की तरफ़ न लौटने का पुख़्ता इरादा
• अगर किसी का हक़ मारा हो तो तलाफ़ी करें
• अल्लाह उनसे मोहब्बत करता है जो मुख़्लिसाना तौबा करते हैं

इल्म हासिल करना:
• इस्लाम को सही तरीक़े से सीखें
• जानें कि अल्लाह को क्या पसंद और नापसंद है
• कबीरा गुनाहों को जानें ताकि उनसे बच सकें
• "जो इल्म हासिल करने के लिए रास्ता इख़्तियार करता है, अल्लाह उसके लिए जन्नत का रास्ता आसान कर देता है।" (मुस्लिम)

बच्चों की हिफ़ाज़त:
• उन्हें छोटी उम्र से तौहीद सिखाएं
• उन्हें अल्लाह और नबी ﷺ से मोहब्बत करें
• उन्हें सही तरीक़े से नमाज़ सिखाएं
• उन्हें क़ुरआन सुनाएं और सिखाएं
• उनकी हिदायत के लिए दुआ करें
• अच्छी मिसाल बनें

नबी करीम ﷺ की ज़मानत:
• नबी करीम ﷺ ने फ़रमाया: "मुझे छह चीज़ों की ज़मानत दो और मैं तुम्हें जन्नत की ज़मानत दूंगा: सच बोलो, वादे पूरे करो, अमानतें लौटाओ, अपनी इफ़्फ़त की हिफ़ाज़त करो, निगाहें नीची रखो, और अपने हाथों को नुक़सान से रोको।"

मुसलसल दुआ:
• "ऐ हमारे रब, हमें इस दुनिया में भलाई दे और आख़िरत में भलाई दे और हमें आग के अज़ाब से बचा।" (क़ुरआन 2:201)
• हमेशा अपनी रोज़ाना की दुआओं में अल्लाह से जहन्नम से हिफ़ाज़त मांगें''',
        'arabic': '''الحماية من النار

كيفية الوقاية من عذاب جهنم.

التوحيد والإيمان:
• "إِنَّ اللَّهَ لَا يَغْفِرُ أَن يُشْرَكَ بِهِ وَيَغْفِرُ مَا دُونَ ذَٰلِكَ" (سورة النساء: 48)
• الإيمان بالله ورسوله
• إخلاص العبادة لله وحده
• البعد عن الشرك بجميع أنواعه

التقوى:
• "يَا أَيُّهَا الَّذِينَ آمَنُوا قُوا أَنفُسَكُمْ وَأَهْلِيكُمْ نَارًا" (سورة التحريم: 6)
• اتقاء الله في السر والعلن
• المحافظة على الصلوات
• اجتناب الكبائر

الأعمال الصالحة:
• قال النبي ﷺ: "اتقوا النار ولو بشق تمرة" (البخاري)
• الصدقة تطفئ الخطيئة
• الصيام جنة من النار
• قيام الليل والاستغفار بالأسحار

التوبة والاستغفار:
• "وَتُوبُوا إِلَى اللَّهِ جَمِيعًا أَيُّهَ الْمُؤْمِنُونَ" (سورة النور: 31)
• التوبة النصوح من الذنوب
• كثرة الاستغفار
• الندم على المعاصي والعزم على عدم العودة

بر الوالدين:
• من أعظم أسباب النجاة من النار
• الإحسان إليهما في حياتهما
• الدعاء لهما بعد موتهما
• طاعتهما في المعروف

صلة الرحم:
• قال النبي ﷺ: "من سره أن يبسط له في رزقه فليصل رحمه" (البخاري)
• زيارة الأقارب والإحسان إليهم
• تجنب القطيعة والخصام

الدعاء:
• "رَبَّنَا اصْرِفْ عَنَّا عَذَابَ جَهَنَّمَ" (سورة الفرقان: 65)
• اللهم أجرني من النار
• اللهم إني أعوذ بك من النار
• الإكثار من الدعاء والتضرع''',
      },
    },
    {
      'number': 6,
      'titleKey': 'jahannam_fazilat_6_warnings_in_quran_hadith',
      'title': 'Warnings in Quran & Hadith',
      'titleUrdu': 'قرآن و حدیث میں تنبیہات',
      'titleHindi': 'क़ुरआन व हदीस में तंबीहात',
      'titleArabic': 'التحذيرات من النار',
      'icon': Icons.warning_amber,
      'color': Colors.amber,
      'details': {
        'english': '''Warnings in Quran & Hadith

Allah and His Messenger ﷺ have given us clear warnings about Hellfire.

Direct Quranic Warnings:
• "O you who have believed, protect yourselves and your families from a Fire whose fuel is people and stones." (Quran 66:6)
• "And fear the Fire, which has been prepared for the disbelievers." (Quran 3:131)
• "So fear the Fire, whose fuel is men and stones, prepared for the disbelievers." (Quran 2:24)
• "Indeed, those who disbelieve in Our verses - We will drive them into a Fire." (Quran 4:56)

About Its Eternal Nature:
• "They will wish to get out of the Fire, but never are they to emerge from it, and for them is an enduring punishment." (Quran 5:37)
• "Abiding eternally therein. They will not find a protector or a helper." (Quran 33:65)
• "Indeed, whoever comes to his Lord as a criminal - indeed, for him is Hell; he will neither die therein nor live." (Quran 20:74)

The Prophet's Tears:
• The Prophet ﷺ wept when thinking about Hellfire
• He ﷺ said: "If you knew what I know, you would laugh little and weep much." (Bukhari)
• He used to seek refuge from Hellfire frequently
• His concern for his Ummah to be saved from it

Warning About Small Sins:
• "So whoever does an atom's weight of evil shall see it." (Quran 99:8)
• The Prophet ﷺ said: "Beware of the minor sins, for they will pile up until they destroy a person."
• Small sins accumulate like drops filling a bucket

Warning Against Arrogance:
• "Indeed, those who dispute concerning the signs of Allah without authority having come to them - there is not within their breasts except pride." (Quran 40:56)
• The Prophet ﷺ said: "No one who has an atom's worth of pride in his heart will enter Paradise." (Muslim)

Warning About Wealth:
• "And let not those who withhold what Allah has given them think it is better for them. Rather, it is worse for them. Their necks will be encircled by what they withheld on the Day of Resurrection." (Quran 3:180)
• Hoarding wealth and not giving rights leads to punishment

Warning About the Tongue:
• The Prophet ﷺ said: "Indeed a servant might speak a word that he thinks is harmless, but he will fall into the Fire because of it as far as the Pleiades." (Bukhari)
• Most people enter Hell because of their tongues

Warning to Those Who Wrong Others:
• The Prophet ﷺ said: "Whoever has wronged his brother with regard to his honor or anything else, let him seek his forgiveness today, before there will be no dirham and no dinar." (Bukhari)
• On Day of Judgment, good deeds will transfer to the wronged

Warning About Hypocrisy:
• "Indeed, the hypocrites will be in the lowest depths of the Fire - and never will you find for them a helper." (Quran 4:145)
• Showing off in worship nullifies it
• Pretending to be Muslim while disbelieving inside

The Prophet's Concern:
• The Prophet ﷺ saw Hell and it terrified him
• He saw the majority of its inhabitants were women (for specific sins)
• He warned against specific sins that lead to Hell
• He ﷺ said: "I am to you like a father warning his son from fire."

Warning About Following Desires:
• "Have you seen he who has taken as his god his own desire?" (Quran 25:43)
• Following desires without restraint leads to destruction
• The Prophet ﷺ said: "Paradise is surrounded by hardships and Hell is surrounded by desires."

Final Warnings:
• "So today We will forget them just as they forgot the meeting of this Day of theirs and for having rejected Our verses." (Quran 7:51)
• No excuse will be accepted on the Day of Judgment
• Every soul is responsible for its own deeds
• Death can come suddenly - repent now

The Wise Take Heed:
• These warnings are out of Allah's mercy
• They give us opportunity to change and repent
• "Indeed, in that is a reminder for whoever has a heart." (Quran 50:37)
• Take action today before it's too late''',
        'urdu': '''قرآن و حدیث میں تنبیہات

اللہ اور اس کے رسول ﷺ نے ہمیں جہنم کے بارے میں واضح تنبیہات دی ہیں۔

براہ راست قرآنی تنبیہات:
• "اے ایمان والو! اپنے آپ کو اور اپنے خاندانوں کو اس آگ سے بچاؤ جس کا ایندھن لوگ اور پتھر ہیں۔" (قرآن 66:6)
• "اور اس آگ سے ڈرو جو کافروں کے لیے تیار کی گئی ہے۔" (قرآن 3:131)
• "تو اس آگ سے ڈرو جس کا ایندھن آدمی اور پتھر ہیں، کافروں کے لیے تیار کی گئی ہے۔" (قرآن 2:24)
• "بیشک جو ہماری آیات کا انکار کرتے ہیں - ہم انہیں آگ میں داخل کریں گے۔" (قرآن 4:56)

اس کی ابدی نوعیت کے بارے میں:
• "وہ چاہیں گے کہ آگ سے نکل جائیں، لیکن وہ کبھی نہیں نکلیں گے، اور ان کے لیے دائمی عذاب ہے۔" (قرآن 5:37)
• "اس میں ہمیشہ رہنے والے۔ وہ نہ کوئی مح��فظ پائیں گے نہ کوئی مددگار۔" (قرآن 33:65)
• "بیشک جو اپنے رب کے پاس مجرم ہو کر آئے گا - اس کے لیے جہنم ہے؛ وہ اس میں نہ مرے گا نہ جیے گا۔" (قرآن 20:74)

نبی کریم ﷺ کے آنسو:
• نبی کریم ﷺ جہنم کے بارے میں سوچتے ہوئے روتے تھے
• آپ ﷺ نے فرمایا: "اگر تم جانتے ہو جو میں جانتا ہوں، تو تم کم ہنستے اور زیادہ روتے۔" (بخاری)
• آپ کثرت سے جہنم سے پناہ مانگتے تھے
• اپنی امت کو اس سے بچانے کی فکر

چھوٹے گناہوں کی تنبیہ:
• "تو جو ذرہ برابر برائی کرے گا وہ دیکھے گا۔" (قرآن 99:8)
• نبی کریم ﷺ نے فرمایا: "چھوٹے گناہوں سے بچو، کیونکہ وہ جمع ہو کر انسان کو تباہ کر دیتے ہیں۔"
• چھوٹے گناہ جمع ہوتے ہیں جیسے قطرے بالٹی بھرتے ہیں

تکبر کے خلاف تنبیہ:
• "بیشک جو اللہ کی آیات کے بارے میں بغیر کسی دلیل کے جھگڑتے ہیں - ان کے سینوں میں تکبر کے سوا کچھ نہیں۔" (قرآن 40:56)
• نبی کریم ﷺ نے فرمایا: "جس کے دل میں ذرہ برابر تکبر ہو وہ جنت میں داخل نہیں ہوگا۔" (مسلم)

دولت کے بارے میں تنبیہ:
• "اور جو لوگ اللہ نے انہیں دیا ہے اس میں بخل کرتے ہیں یہ نہ سمجھیں کہ یہ ان کے لیے بہتر ہے۔ بلکہ یہ ان کے لیے بُرا ہے۔ قیامت کے دن جس میں انہوں نے بخل کیا وہ ان کی گردنوں میں طوق بن جائے گا۔" (قرآن 3:180)
• دولت جمع کرنا اور حقوق نہ دینا سزا کا باعث ہے

زبان کے بارے میں تنبیہ:
• نبی کریم ﷺ نے فرمایا: "بیشک ایک بندہ ایک لفظ بولتا ہے جسے وہ بے ضرر سمجھتا ہے، لیکن اس کی وجہ سے وہ آگ میں ثریا جتنا گرے گا۔" (بخاری)
• زیادہ تر لوگ اپنی زبانوں کی وجہ سے جہنم میں جاتے ہیں

دوسروں پر ظلم کرنے والوں کو تنبیہ:
• نبی کریم ﷺ نے فرمایا: "جس نے اپنے بھائی پر اس کی عزت یا کسی اور چیز میں ظلم کیا ہو، وہ آج اس سے معافی مانگ لے، اس سے پہلے کہ کوئی درہم یا دینار نہ ہو۔" (بخاری)
• قیامت کے دن نیکیاں مظلوم کو منتقل ہو جائیں گی

نفاق کے بارے میں تنبیہ:
• "بیشک منافق جہنم کی سب سے نچلی تہہ میں ہوں گے - اور تم ان کے لیے کوئی مددگار نہیں پاؤ گے۔" (قرآن 4:145)
• عبادت میں دکھاوا اسے ختم کر دیتا ہے
• اندر سے کافر ہوتے ہوئے مسلمان ہونے کا دکھاوا کرنا

نبی کریم ﷺ کی فکر:
• نبی کریم ﷺ نے جہنم دیکھی اور یہ آپ کو خوفزدہ کر گئی
• آپ نے دیکھا اس کے زیادہ تر باشندے خواتین تھیں (مخصوص گناہوں کے لیے)
• آپ نے ان مخصوص گناہوں سے خبردار کیا جو جہنم کی طرف لے جاتے ہیں
• آپ ﷺ نے فرمایا: "میں تمہارے لیے ایسے باپ کی طرح ہوں جو اپنے بیٹے کو آگ سے خبردار کرتا ہے۔"

خواہشات کی پیروی کے بارے میں تنبیہ:
• "کیا تم نے اسے دیکھا جس نے اپنی خواہش کو اپنا معبود بنا لیا؟" (قرآن 25:43)
• بغیر روک ٹوک خواہشات کی پیروی تباہی کی طرف لے جاتی ہے
• نبی کریم ﷺ نے فرمایا: "جنت مشکلات سے گھری ہے اور جہنم خواہشات سے گھری ہے۔"

آخری تنبیہات:
• "تو آج ہم انہیں بھول جائیں گے جیسے انہوں نے اپنے اس دن کی ملاقات کو بھلا دیا تھا اور ہماری آیات کو جھٹلایا تھا۔" (قرآن 7:51)
• قیامت کے دن کوئی عذر قبول نہیں ہوگا
• ہر جان اپنے اعمال کی ذمہ دار ہے
• موت اچانک آ سکتی ہے - ابھی توبہ کریں

عقلمند نصیحت لیتے ہیں:
• یہ تنبیہات اللہ کی رحمت سے ہیں
• یہ ہمیں بدلنے اور توبہ کرنے کا موقع دیتی ہیں
• "بیشک اس میں یاد دہانی ہے ہر اس شخص کے لیے جس کے پاس دل ہو۔" (قرآن 50:37)
• بہت دیر ہونے سے پہلے آج عمل کریں''',
        'hindi': '''क़ुरआन व हदीस में तंबीहात

अल्लाह और उसके रसूल ﷺ ने हमें जहन्नम के बारे में वाज़ेह तंबीहात दी हैं।

बराहे रास्त क़ुरआनी तंबीहात:
• "ऐ ईमान वालो! अपने आपको और अपने ख़ानदानों को उस आग से बचाओ जिसका ईंधन लोग और पत्थर हैं।" (क़ुरआन 66:6)
• "और उस आग से डरो जो काफ़िरों के लिए तैयार की गई है।" (क़ुरआन 3:131)
• "तो उस आग से डरो जिसका ईंधन आदमी और पत्थर हैं, काफ़िरों के लिए तैयार की गई है।" (क़ुरआन 2:24)
• "बेशक जो हमारी आयात का इंकार करते हैं - हम उन्हें आग में दाख़िल करेंगे।" (क़ुरआन 4:56)

इसकी अबदी नौइयत के बारे में:
• "वो चाहेंगे कि आग से निकल जाएं, लेकिन वो कभी नहीं निकलेंगे, और उनके लिए दाइमी अज़ाब है।" (क़ुरआन 5:37)
• "उसमें हमेशा रहने वाले। वो न कोई मुहाफ़िज़ पाएंगे न कोई मददगार।" (क़ुरआन 33:65)
• "बेशक जो अपने रब के पास मुजरिम होकर आएगा - उसके लिए जहन्नम है; वो उसमें न मरेगा न जिएगा।" (क़ुरआन 20:74)

नबी करीम ﷺ के आंसू:
• नबी करीम ﷺ जहन्नम के बारे में सोचते हुए रोते थे
• आप ﷺ ने फ़रमाया: "अगर तुम जानते हो जो मैं जानता हूं, तो तुम कम हंसते और ज़्यादा रोते।" (बुख़ारी)
• आप कसरत से जहन्नम से पनाह मांगते थे
• अपनी उम्मत को इससे बचाने की फ़िक्र

छोटे गुनाहों की तंबीह:
• "तो जो ज़र्रा बराबर बुराई करेगा वो देखेगा।" (क़ुरआन 99:8)
• नबी करीम ﷺ ने फ़रमाया: "छोटे गुनाहों से बचो, क्योंकि वो जमा होकर इंसान को तबाह कर देते हैं।"
• छोटे गुनाह जमा होते हैं जैसे क़तरे बाल्टी भर���े हैं

तकब्बुर के ख़िलाफ़ तंबीह:
• "बेशक जो अल्लाह की आयात के बारे में बग़ैर किसी दलील के झगड़ते हैं - उनके सीनों में तकब्बुर के सिवा कुछ नहीं।" (क़ुरआन 40:56)
• नबी करीम ﷺ ने फ़रमाया: "जिसके दिल में ज़र्रा बराबर तकब्बुर हो वो जन्नत में दाख़िल नहीं होगा।" (मुस्लिम)

दौलत के बारे में तंबीह:
• "और जो लोग अल्लाह ने उन्हें दिया है उसमें बुख़्ल करते हैं यह न समझें कि यह उनके लिए बेहतर है। बल्कि यह उनके लिए बुरा है। क़यामत के दिन जिसमें उन्होंने बुख़्ल किया वो उनकी गर्दनों में तौक़ बन जाएगा।" (क़ुरआन 3:180)
• दौलत जमा करना और हुक़ूक़ न देना सज़ा का बाइस है

ज़बान के बारे में तंबीह:
• नबी करीम ﷺ ने फ़रमाया: "बेशक एक बंदा एक लफ़्ज़ बोलता है जिसे वो बेज़रर समझता है, लेकिन उसकी वजह से वो आग में सुरय्या जितना गिरेगा।" (बुख़ारी)
• ज़्यादातर लोग अपनी ज़बानों की वजह से जहन्नम में जाते हैं

दूसरों पर ज़ुल्म करने वालों को तंबीह:
• नबी करीम ﷺ ने फ़रमाया: "जिसने अपने भाई पर उसकी इज़्ज़त या किसी और चीज़ में ज़ुल्म किया हो, वो आज उससे माफ़ी मांग ले, इससे पहले कि कोई दिरहम या दीनार न हो।" (बुख़ारी)
• क़यामत के दिन नेकियां मज़लूम को मुंतक़िल हो जाएंगी

निफ़ाक़ के बारे में तंबीह:
• "बेशक मुनाफ़िक़ जहन्नम की सबसे निचली तह में होंगे - और तुम उनके लिए कोई मददगार नहीं पाओगे।" (क़ुरआन 4:145)
• इबादत में दिखावा उसे ख़त्म कर देता है
• अंदर से काफ़िर होते हुए मुसलमान होने का दिखावा करना

नबी करीम ﷺ की फ़िक्र:
• नबी करीम ﷺ ने जहन्नम देखी और यह आपको ख़ौफ़ज़दा कर गई
• आपने देखा इसके ज़्यादातर बाशिंदे ख़वातीन थीं (मख़सूस गुनाहों के लिए)
• आपने उन मख़सूस गुनाहों से ख़बरदार किया जो जहन्नम की तरफ़ ले जाते हैं
• आप ﷺ ने फ़रमाया: "मैं तुम्हारे लिए ऐसे बाप की तरह हूं जो अपने बेटे को आग से ख़बरदार करता है।"

ख़्वाहिशात की पैरवी के बारे में तंबीह:
• "क्या तुमने उसे देखा जिसने अपनी ख़्वाहिश को अपना माबूद बना लिया?" (क़ुरआन 25:43)
• बग़ैर रोक टोक ख़्वाहिशात की पैरवी तबाही की तरफ़ ले जाती है
• नबी करीम ﷺ ने फ़रमाया: "जन्नत मुश्किलात से घिरी है और जहन्नम ख़्वाहिशात से घिरी है।"

आख़िरी तंबीहात:
• "तो आज हम उन्हें भूल जाएंगे जैसे उन्होंने अपने इस दिन की मुलाक़ात को भुला दिया था और हमारी आयात को झुठलाया था।" (क़ुरआन 7:51)
• क़यामत के दिन कोई उज़्र क़बूल नहीं होगा
• हर जान अपने आमाल की ज़िम्मेदार है
• मौत अचानक आ सकती है - अभी तौबा करें

अक़्लमंद नसीहत लेते हैं:
• यह तंबीहात अल्लाह की रहमत से हैं
• यह हमें बदलने और तौबा करने का मौक़ा देती हैं
• "बेशक इसमें याददिहानी है हर उस शख़्स के लिए जिसके पास दिल हो।" (क़ुरआन 50:37)
• बहुत देर होने से पहले आज अमल करें''',
        'arabic': '''التحذيرات من النار

تحذيرات القرآن والسنة من جهنم.

تحذيرات القرآن:
• "فَاتَّقُوا النَّارَ الَّتِي وَقُودُهَا النَّاسُ وَالْحِجَارَةُ" (سورة البقرة: 24)
• "إِنَّ جَهَنَّمَ كَانَتْ مِرْصَادًا" (سورة النبأ: 21)
• "وَإِن مِّنكُمْ إِلَّا وَارِدُهَا" (سورة مريم: 71)
• "كُلُّ نَفْسٍ ذَائِقَةُ الْمَوْتِ" (سورة آل عمران: 185)

تحذير النبي ﷺ:
• قال ﷺ: "اتقوا النار ولو بشق تمرة" (البخاري)
• "بعثت أنا والساعة كهاتين" (البخاري)
• "النار النار" خطب بها النبي وأحمرت وجنتاه
• حذر من الذنوب الموبقات

وصف عذاب القبر:
• القبر أول منازل الآخرة
• "إِنَّا بَلَوْنَاهُمْ كَمَا بَلَوْنَا أَصْحَابَ الْجَنَّةِ" (سورة القلم: 17)
• فتنة القبر وعذابه
• ضمة القبر للمؤمن والكافر

أهوال يوم القيامة:
• "يَوْمَ تَرَوْنَهَا تَذْهَلُ كُلُّ مُرْضِعَةٍ عَمَّا أَرْضَعَتْ" (سورة الحج: 2)
• الحساب والميزان
• الصراط فوق جهنم
• "وَتَرَى الْمُجْرِمِينَ يَوْمَئِذٍ مُّقَرَّنِينَ فِي الْأَصْفَادِ" (سورة إبراهيم: 49)

الاعتبار بحال الأمم:
• "أَلَمْ يَأْتِهِمْ نَبَأُ الَّذِينَ مِن قَبْلِهِمْ" (سورة التوبة: 70)
• قوم نوح وعاد وثمود
• قوم لوط وأصحاب الأيكة
• فرعون وقارون

الندم يوم القيامة:
• "وَيَوْمَ يَعَضُّ الظَّالِمُ عَلَىٰ يَدَيْهِ" (سورة الفرقان: 27)
• "يَا وَيْلَتَىٰ لَيْتَنِي لَمْ أَتَّخِذْ فُلَانًا خَلِيلًا" (سورة الفرقان: 28)
• لا ينفع الندم حينئذ
• الحسرة على ما فات

العمل قبل الموت:
• "مِن قَبْلِ أَن يَأْتِيَ أَحَدَكُمُ الْمَوْتُ" (سورة المنافقون: 10)
• المبادرة إلى التوبة
• الإكثار من الأعمال الصالحة
• تذكر الموت والآخرة''',
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
          context.tr('jahannam'),
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
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _jahannamTopics.length,
                  itemBuilder: (context, index) {
                    final topic = _jahannamTopics[index];
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
    final title = context.tr(topic['titleKey'] ?? 'jahannam_fazilat');
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
                              context.tr('jahannam_fazilat'),
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
          categoryKey: 'category_jahannam_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
