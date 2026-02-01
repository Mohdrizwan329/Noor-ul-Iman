import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class JannatFazilatScreen extends StatefulWidget {
  const JannatFazilatScreen({super.key});

  @override
  State<JannatFazilatScreen> createState() => _JannatFazilatScreenState();
}

class _JannatFazilatScreenState extends State<JannatFazilatScreen> {
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

Paradise is the eternal abode of bliss that Allah has prepared for the believers. It is a place of unimaginable beauty, endless pleasure, and eternal happiness.

What No Eye Has Seen - The Unimaginable Beauty:
• The Prophet Muhammad ﷺ said: "Allah says: 'I have prepared for My righteous servants what no eye has seen, no ear has heard, and no human heart has ever conceived.'" (Sahih Bukhari 3244)
• This is recited from Quran: "No soul knows what has been hidden for them of comfort for eyes as reward for what they used to do." (Quran 32:17)
• The beauty and blessings of Paradise are beyond human comprehension and imagination
• Even the smallest space in Paradise is better than the entire world and everything in it
• The Prophet ﷺ said: "A space in Paradise equivalent to the size of a foot would be better than the world and what is in it." (Sahih Bukhari 3250)
• The lowest person in Paradise will have a kingdom ten times the size of this world
• The Prophet ﷺ said about the least person in Paradise: "He will be given ten times as much as this world." (Sahih Muslim 189)

The Eight Gates of Paradise - Bab al-Jannah:
Paradise has eight magnificent gates, each designated for those who excelled in specific deeds:

1. Bab al-Salat (Gate of Prayer):
• For those who were consistent in their five daily prayers
• Those who prayed with humility and devotion

2. Bab al-Rayyan (Gate of Fasting):
• Exclusively for those who fasted regularly
• The Prophet ﷺ said: "There is a gate in Paradise called Ar-Rayyan, through which those who used to observe fasting will enter on the Day of Resurrection, and none except them will enter through it." (Sahih Bukhari 1896)
• Once they enter, it will be closed and no one else will enter through it

3. Bab al-Sadaqah (Gate of Charity):
• For those who gave charity generously
• Abu Bakr (RA) was told he would be called from all gates

4. Bab al-Jihad (Gate of Struggle):
• For those who strove in Allah's path
• The martyrs and those who struggled for righteousness

5. Bab al-Hajj (Gate of Pilgrimage):
• For those who performed Hajj and Umrah

6. Bab al-Kadhimeen al-Ghaiz (Gate of Those Who Restrain Anger):
• For those who controlled their anger and forgave others

7. Bab al-Iman (Gate of Faith):
• For those with strong faith and conviction

8. Bab al-Dhikr (Gate of Remembrance):
• For those who remembered Allah abundantly

The Prophet ﷺ said: "Whoever spends two things in pairs from his wealth in the way of Allah will be called from the gates of Paradise." (Sahih Bukhari 1897)

Physical Description of Each Gate:
• The distance between two gate-posts is equivalent to forty years of travel
• Or as some narrations state: "The distance between the two gate-posts is a distance of forty years' walking." (Sahih Muslim 194)
• The gates are made of magnificent materials that dazzle the eyes
• Angels stand as gatekeepers greeting the believers

The Rivers of Paradise - Anhar al-Jannah:
The Quran describes four main types of rivers:

"The description of Paradise which the righteous have been promised is that in it are rivers of water, the taste and smell of which are not changed; rivers of milk of which the taste never changes; rivers of wine delicious to those who drink; and rivers of clarified honey." (Quran 47:15)

1. Rivers of Pure Water (Ma' Ghayr Asin):
• Crystal clear, never stagnant
• More refreshing than any water in this world
• Never causes any discomfort

2. Rivers of Milk (Laban Lam Yataghayyar Ta'muhu):
• Pure white milk that never spoils
• Taste never changes or sours
• Perfectly delicious forever

3. Rivers of Wine (Khamr Ladhdhatin Lil-Sharibeen):
• Delightful drink for those who consume it
• Causes no intoxication, headache, or harm
• "They will be given to drink pure wine sealed." (Quran 83:25)
• "Wherein is no headache nor are they made drunken." (Quran 37:47)

4. Rivers of Purified Honey (Asal Musaffa):
• Clarified, pure honey
• Perfect sweetness
• No impurities whatsoever

The River of Al-Kawthar:
• The main river granted specifically to Prophet Muhammad ﷺ
• "Indeed, We have granted you, [O Muhammad], al-Kawthar." (Quran 108:1)
• The Prophet ﷺ described it: "Its water is whiter than milk, sweeter than honey, and its vessels are more numerous than the stars." (Sahih Bukhari 6579)
• Its banks are made of gold and pearls
• Its pebbles are of pearls and precious gems
• Its soil is of fragrant musk
• The blessed will drink from it and never thirst again

Other Rivers:
• River Bariqi (Lightning)
• River Tasnim - the highest spring in Paradise
• "And they will be given to drink a cup of wine whose mixture is of Kafur, a spring of which the servants of Allah will drink." (Quran 76:5-6)

The Soil and Construction of Paradise:
Every element of Paradise is made of the finest materials:

The Soil:
• The soil of Paradise is of musk - the finest fragrance
• Some narrations mention saffron
• Extremely soft and pleasant to walk upon
• The Prophet ﷺ said: "Its soil is of musk." (Sahih Muslim 2834)

The Bricks and Buildings:
• Bricks alternate between gold and silver
• "A brick of gold and a brick of silver" (Tirmidhi 2527)
• The mortar between the bricks is fragrant musk
• Buildings constructed with such materials radiate light

The Pebbles:
• Pebbles and gravel are made of pearls and precious gems
• Rubies, emeralds, and jewels cover the ground
• What is most precious in this world is common ground in Paradise

The Palaces and Mansions:
• Magnificent palaces made of gold, silver, pearls, and jewels
• "And they will have therein purified spouses, and they will abide therein eternally." (Quran 2:25)
• Some palaces are so transparent that inside can be seen from outside
• The Prophet ﷺ said: "In Paradise there are rooms whose outside can be seen from the inside and the inside can be seen from the outside." (Tirmidhi 2527)

Width and Vastness of Paradise:
Paradise is immeasurably vast:

The Quranic Description:
• "Race toward forgiveness from your Lord and a Garden whose width is like the width of the heavens and earth." (Quran 57:21)
• "And hasten to forgiveness from your Lord and a garden as wide as the heavens and earth." (Quran 3:133)
• It is as wide as the heavens and the earth combined

Levels and Expanse:
• Paradise has 100 levels
• Each level is as vast as the distance between heaven and earth
• The vastness is beyond human comprehension
• Prepared specifically for the believers and the righteous

The Trees of Paradise:
Paradise contains magnificent trees:

Tree of Tuba:
• A massive tree providing shade
• The Prophet ﷺ said: "In Paradise there is a tree under whose shade a rider can travel for a hundred years without crossing it." (Sahih Bukhari 3251)
• Some say this tree is so vast its shade covers all of Paradise
• Its trunk is made of gold
• The clothing of Paradise comes from its fruits

Sidrat al-Muntaha (The Lote Tree):
• Located at the seventh heaven
• "Near it is the Garden of Refuge." (Quran 53:15)
• The furthest boundary that angels and prophets can reach
• Its fruits are like the jars of Hajar (large vessels)
• Its leaves are like elephant ears

Other Blessed Trees:
• Trees with fruits hanging low within easy reach
• "Its fruit is hanging low within reach." (Quran 69:23)
• No thorns, no harm, only beauty and nourishment
• Fruits of all kinds, always available

The Perpetual Blessings:
Unlike worldly pleasures, Paradise offers eternal constancy:

Never-Ending Fruits:
• "Its fruit is lasting and its shade." (Quran 13:35)
• Fruits never go out of season
• Always fresh and available
• More varieties than can be counted

Eternal Comfort:
• No heat or cold to cause discomfort
• Perfect temperature always
• "They will not feel therein any burning heat or cold." (Quran 76:13)

No Hardship:
• No fatigue or tiredness
• "No fatigue will touch them therein." (Quran 15:48)
• No sickness, pain, or suffering
• No sadness, worry, or grief
• Perfect peace and tranquility forever

Eternal Dwelling:
• "And they will never be removed from it." (Quran 15:48)
• "Wherein they abide eternally." (Quran 2:25)
• No fear of death or departure
• Permanent residence forever

The Light of Paradise:
Paradise is filled with divine light:

Radiant Illumination:
• No need for sun or moon
• The light comes from the Throne of Allah
• Everything radiates its own beautiful light
• The faces of believers shine like the full moon

The Scent of Paradise:
• Fragrance can be detected from enormous distances
• The Prophet ﷺ said: "The fragrance of Paradise can be smelled from a distance of forty years' travel." (Sahih Bukhari 3826)
• Everything is perfumed with musk and fragrances

The Size and Scale:
To emphasize its vastness, the Prophet ﷺ said:

• "If all of Paradise that exists were to be brought forward, the foot of one of you would be better than the world and what is in it." (Sahih Bukhari 6568)
• This shows how even the smallest portion exceeds our world's entirety

This is Paradise - a place prepared by Allah for those who believe, do righteous deeds, and fear Him. May Allah grant us all entry into His magnificent Paradise. Ameen.''',
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
• نعيم دائم إلى الأبد''',
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
        'english': '''Levels of Paradise (Darajat al-Jannah)

Paradise is not a single uniform place, but rather has multiple levels and ranks. Each believer will be placed according to their faith and deeds in this world.

The One Hundred Levels of Paradise:
The Prophet Muhammad ﷺ gave us precise information about Paradise's structure:

Number and Distance:
• The Prophet ﷺ said: "In Paradise there are one hundred levels which Allah has prepared for those who fight in jihad for His sake. The distance between each two levels is like the distance between the heaven and the earth." (Sahih Bukhari 2790)
• Another narration states: "Paradise has one hundred grades, and between each two grades is the distance that is between the heavens and the earth." (Tirmidhi 1649)
• This immense distance shows the vast difference in rewards
• Each level represents different degrees of faith and righteousness

Who Are They Prepared For:
• Initially mentioned for those who strive in Allah's cause (mujahideen)
• Extended to all believers who strive in faith and good deeds
• The higher the level, the greater the rewards and proximity to Allah
• "And for all are degrees from what they have done." (Quran 6:132)

The Highest Level - Firdaus al-A'la:
• The topmost and most excellent level
• Located directly beneath the Throne of Allah (Arsh ar-Rahman)
• The Prophet ﷺ said: "When you ask Allah for Paradise, ask Him for Al-Firdaus, for it is the highest part of Paradise, in the middle of Paradise, and from it spring the rivers of Paradise, and above it is the Throne of the Most Merciful." (Sahih Bukhari 2790, 7423)
• The four rivers of Paradise originate from Firdaus
• The most blessed and honored position

Differences Between the Levels:
The variation between levels is profound:

Visible Distinction:
• The Prophet ﷺ said: "The people of the highest levels will be seen by those who are below them as you see a star shining in the distant horizon in the east or the west, due to the great differences between their levels." (Sahih Bukhari 3256, Sahih Muslim 2831)
• Just as we see stars twinkling in the sky, those in lower Paradise will see those above
• This demonstrates the immense gap in blessings and honor

Basis of Differentiation:
• "And for all are degrees from what they have done, and [it is] so that He may fully compensate them for their deeds." (Quran 46:19)
• Faith (Iman) - the stronger the faith, the higher the level
• Righteous deeds - consistency and quality matter
• Sincerity and purity of intention
• Patience in trials and tribulations
• Knowledge and wisdom
• Character and manners

The Categories of Paradise's Inhabitants:

1. As-Sabiqun (The Forerunners - The First and Foremost):
These are the elite of Paradise:

Who Are They:
• "And the forerunners, the forerunners - Those are the ones brought near [to Allah]. They will be in the Gardens of Pleasure." (Quran 56:10-12)
• Those who raced ahead in doing good deeds
• First to embrace Islam in each era
• First to perform righteous actions
• Compete with each other in worship and service

Their Reward:
• Closest to Allah's Throne
• In the highest levels of Firdaus
• Greater and more abundant blessings
• "A [large] company of the former peoples and a few of the later peoples." (Quran 56:13-14)
• Most of them from earlier generations, fewer from later ones

2. Ashab al-Yameen (Companions of the Right):
The righteous believers:

Who Are They:
• "And the companions of the right - what are the companions of the right? [They will be] among lote trees with thorns removed." (Quran 56:27-28)
• The general body of believers who did good
• Those who followed the straight path
• Consistent in faith and practice

Their Reward:
• Gardens of delight and pleasure
• Beautiful blessings and comforts
• Peace and satisfaction
• "And [banana] trees layered [with fruit] and shade extended and water poured out and fruit, abundant [and varied], neither limited [to season] nor forbidden." (Quran 56:28-33)

3. The Prophets and Messengers:
The highest rank among all creation:

Their Special Position:
• "And whoever obeys Allah and the Messenger - those will be with the ones upon whom Allah has bestowed favor of the prophets, the steadfast affirmers of truth, the martyrs and the righteous. And excellent are those as companions." (Quran 4:69)
• Prophets are in the most exalted positions
• The Prophet Muhammad ﷺ will be in the highest place

Al-Wasilah - The Prophet's Special Station:
• The Prophet ﷺ said: "When you hear the Muezzin, repeat what he says, then send blessings upon me, for whoever sends blessings upon me once, Allah will send blessings upon him tenfold. Then ask Allah to grant me Al-Wasilah, which is a rank in Paradise befitting only one of Allah's servants, and I hope that I will be that one." (Sahih Muslim 384)
• The highest station in Paradise
• Reserved for Prophet Muhammad ﷺ alone

4. As-Siddiqun (The Truthful):
Those who perfected their truthfulness:

Who Are They:
• Mentioned alongside prophets in rank
• "Then those are the ones with the prophets, the steadfast affirmers of truth, the martyrs, and the righteous." (Quran 4:69)
• Abu Bakr as-Siddiq (RA) exemplifies this rank
• Those whose faith and truthfulness never wavered

Their Characteristics:
• Perfect honesty in speech and action
• Unwavering faith in all circumstances
• Complete devotion to truth
• Immediate acceptance and submission to Allah's commands

5. Ash-Shuhada (The Martyrs):
Those who sacrificed their lives:

Their Special Status:
• The Prophet ﷺ said: "No one who enters Paradise will wish to come back to this world even if he were given everything on earth - except the martyr who, on seeing the superiority of martyrdom, will wish to come back to the world and be killed again." (Sahih Bukhari 2817)
• They are alive with their Lord
• "And never think of those who have been killed in the cause of Allah as dead. Rather, they are alive with their Lord, receiving provision." (Quran 3:169)

Their Privileges:
• Instant entry into Paradise
• Forgiveness of all sins with the first drop of blood
• See their place in Paradise while dying
• Seventy family members can intercede for
• Special honor and proximity to Allah

6. As-Salihun (The Righteous):
The consistently good:

Who Are They:
• Those who maintained righteousness throughout life
• Consistent in worship and good character
• Avoided major sins and repented from minor ones
• Served Allah with dedication

The Elevated Rooms (Ghurfah):
Special chambers for the elite:

Description:
• "But those who have feared their Lord - for them are chambers, above them chambers built high, beneath which rivers flow. [This is] the promise of Allah. Allah does not fail in [His] promise." (Quran 39:20)
• Multi-story palatial rooms
• One chamber built above another
• Rivers flowing underneath

Who Will Receive Them:
• The Prophet ﷺ said: "In Paradise there are rooms whose outside can be seen from the inside and the inside can be seen from the outside. Allah has prepared them for those who feed the poor, speak gently, fast regularly, and pray at night when people are asleep." (Tirmidhi 1984, Ahmad)
• Those who feed the hungry
• Those with gentle speech
• Those who pray voluntary night prayers (Tahajjud)
• Those who fast voluntary fasts

Transparency and Beauty:
• Made of pearls and precious stones
• So transparent that inside is visible from outside
• Radiating beautiful light
• More magnificent than anything imaginable

How to Reach Higher Levels:

1. Through Extra Worship (Nawafil):
• Voluntary prayers beyond the obligatory
• Additional fasting beyond Ramadan
• Extra charity and good deeds
• The Prophet ﷺ said in a Hadith Qudsi: "My servant continues to draw near to Me with voluntary acts of worship until I love him." (Sahih Bukhari 6502)

2. Through Recitation of Quran:
• The Prophet ﷺ said: "It will be said to the companion of the Quran: Recite and rise in status, recite as you used to recite in the world, for your status will be at the last verse that you recite." (Abu Dawud 1464, Tirmidhi 2914)
• Each verse raises the reciter one level
• The hafiz (one who memorized Quran) will rise level by level

3. Through Good Character:
• The Prophet ﷺ said: "The dearest and nearest among you to me on the Day of Resurrection will be the one who is the best of you in manners." (Tirmidhi 2018)
• Beautiful character elevates status
• Patience, kindness, forgiveness raise ranks

4. Through Seeking Knowledge:
• The Prophet ﷺ said: "Whoever follows a path in pursuit of knowledge, Allah will make easy for him a path to Paradise." (Sahih Muslim 2699)
• Learning and teaching Islamic knowledge
• Acting upon knowledge gained

5. Through Patience in Trials:
• "Indeed, the patient will be given their reward without account." (Quran 39:10)
• Bearing hardships with patience
• Accepting Allah's decree with satisfaction
• Not complaining during difficulties

6. Through Maintaining Family Ties:
• Upholding kinship bonds
• Supporting family members
• Reconciling between relatives
• The Prophet ﷺ said: "Whoever would like his provision to be increased and his lifespan to be extended, let him uphold the ties of kinship." (Sahih Bukhari 5986)

7. Through Calling Others to Good:
• Dawah and spreading Islamic knowledge
• Enjoining good and forbidding evil
• Whoever guides someone to good gets reward equal to the one who does it

8. Through Raising Righteous Children:
• Teaching children Quran and Islam
• Providing proper Islamic upbringing
• Children will raise their parents' ranks in Paradise

The Perfect Justice of Allah:
• No one will be treated unfairly
• Each person receives exactly what they deserve
• "And your Lord is not ever unjust to [His] servants." (Quran 41:46)
• Those in lower levels will still be infinitely happy
• No jealousy or sadness exists in Paradise at any level

This system of levels shows Allah's perfect wisdom - rewarding each according to their deeds while maintaining perfect happiness for all. May Allah grant us the highest levels of Firdaus. Ameen.''',
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
• الصدقة والإحسان إلى الخلق''',
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

Allah in His infinite mercy has shown us clear and specific paths to enter Paradise. These paths are mentioned throughout the Quran and authentic Hadith.

The Foundation - The Five Pillars of Islam:

1. Shahadah (Declaration of Faith):
• The key that opens the gates of Paradise
• "There is no god but Allah, and Muhammad is the Messenger of Allah"
• The Prophet ﷺ said: "Whoever testifies that there is no god but Allah alone with no partner, and that Muhammad is His servant and Messenger, and that Isa (Jesus) is the servant of Allah and His Messenger, and His word which He bestowed upon Maryam and a spirit from Him, and that Paradise is true and Hell is true, Allah will admit him into Paradise regardless of what deeds he did." (Sahih Bukhari 3435, Sahih Muslim 28)
• Must be said with conviction, understanding, and sincerity
• Actions must confirm the testimony

2. Salah (Prayer):
• The cornerstone of the religion
• The Prophet ﷺ said: "Between a man and disbelief and polytheism is the abandonment of prayer." (Sahih Muslim 82)
• Five daily prayers are obligatory
• "Whoever maintains the prayer, it will be light, proof, and salvation for him on the Day of Resurrection." (Musnad Ahmad 6576)
• The Prophet ﷺ said: "The five daily prayers, and from one Friday prayer to the next, and from Ramadan to Ramadan are expiation for whatever sins come in between, so long as one avoids major sins." (Sahih Muslim 233)

Additional Prayer Rewards:
• 12 Rak'ahs of Sunnah daily: The Prophet ﷺ said: "Whoever prays twelve rak'ahs in a day and night, a house will be built for him in Paradise." (Sahih Muslim 728)
• Night Prayer (Tahajjud): A means to elevated ranks
• Praying in congregation: 27 times more reward than praying alone

3. Zakah (Charity):
• Purification of wealth and soul
• "And establish prayer and give zakah and bow with those who bow." (Quran 2:43)
• 2.5% of savings annually for those who meet the nisab
• The Prophet ﷺ said: "Charity extinguishes sins just as water extinguishes fire." (Tirmidhi 2616)
• Protects from Hell and guarantees Paradise

4. Sawm (Fasting):
• Fasting in Ramadan is obligatory
• Has a special gate in Paradise called Ar-Rayyan
• The Prophet ﷺ said: "There is a gate in Paradise called Ar-Rayyan, through which those who fasted will enter on the Day of Resurrection. No one will enter it except them. It will be said: 'Where are those who fasted?' They will stand up, and no one will enter it except them. When they have entered, it will be closed and no one else will enter through it." (Sahih Bukhari 1896, Sahih Muslim 1152)
• Fasting Ramadan with faith and seeking reward: "Whoever fasts Ramadan with faith and seeking reward, his previous sins will be forgiven." (Sahih Bukhari 38)

Voluntary Fasting:
• Mondays and Thursdays
• Three days each month (white days - 13th, 14th, 15th)
• Day of Arafah (for non-pilgrims): expiates two years of sins
• Six days of Shawwal: Reward of fasting the entire year

5. Hajj (Pilgrimage):
• Obligatory once in a lifetime for those who are able
• The Prophet ﷺ said: "An accepted Hajj has no reward except Paradise." (Sahih Bukhari 1773, Sahih Muslim 1349)
• Performing Hajj properly: "Whoever performs Hajj for the sake of Allah and does not commit any obscenity or sin, he will come back as pure as on the day his mother gave birth to him." (Sahih Bukhari 1521, Sahih Muslim 1350)
• Umrah between two Ramadans expiates sins in between

The Guarantee of Paradise - Comprehensive Hadith:
The Prophet ﷺ said: "Whoever believes in Allah and His Messenger, establishes prayer, pays zakah, and fasts Ramadan, it is a right upon Allah to admit him into Paradise, whether he fights in the cause of Allah or remains in the land where he was born." They said: "O Messenger of Allah, shall we not give people the good news?" He said: "Paradise has one hundred levels that Allah has prepared for those who strive in jihad for His sake, and the distance between each two levels is like the distance between the heaven and earth. So when you ask Allah, ask Him for Al-Firdaus, for it is the middle of Paradise and the highest part of Paradise, and above it is the Throne of the Most Merciful, and from it spring the rivers of Paradise." (Sahih Bukhari 2790, 7423)

Specific Deeds That Guarantee Paradise:

1. Sincere Faith and Testimony:
• The Prophet ﷺ said: "Whoever says 'There is no god but Allah' sincerely from his heart will enter Paradise." (Sahih Bukhari 128, Sahih Muslim 33)
• Sincerity is essential - not just lip service
• The heart must believe what the tongue speaks

2. Excellence in Character (Husn al-Khuluq):
• The Prophet ﷺ said: "The most beloved of you to me and the nearest to me on the Day of Resurrection are those with the best character." (Tirmidhi 2018)
• Good manners guarantee high levels: "I guarantee a house in the middle of Paradise for one who abandons lying even when joking, and a house in the upper part of Paradise for one who has good character." (Abu Dawud 4800)
• Being easy-going, forgiving, and kind
• Controlling anger and forgiving others

3. Truthfulness (Sidq):
• The Prophet ﷺ said: "Truthfulness leads to righteousness and righteousness leads to Paradise. A man continues to tell the truth and endeavor to be truthful until he is recorded with Allah as a truthful person (siddiq)." (Sahih Bukhari 6094, Sahih Muslim 2607)
• Consistency in truthfulness
• Honesty in speech and actions

4. Kindness to Parents (Birr al-Walidayn):
• One of the greatest causes of entering Paradise
• A man asked: "O Messenger of Allah, what deed is most beloved to Allah?" He said: "Prayer at its appointed time." He asked: "Then what?" He said: "Kindness to parents." (Sahih Bukhari 527, Sahih Muslim 85)
• The Prophet ﷺ said: "The pleasure of the Lord is in the pleasure of the parent, and the anger of the Lord is in the anger of the parent." (Tirmidhi 1899)
• Taking care of parents in old age leads to Paradise

5. Raising Daughters Properly:
• The Prophet ﷺ said: "Whoever has three daughters or three sisters, or two daughters or two sisters, and treats them well and fears Allah regarding them, Paradise will be guaranteed for him." (Tirmidhi 1912, Abu Dawud 5147)
• Patience with them and providing proper upbringing
• Treating them with love and respect

6. Caring for Orphans:
• The Prophet ﷺ said: "I and the one who takes care of an orphan will be in Paradise like this," and he held his two fingers together. (Sahih Bukhari 5304)
• Providing for orphans' needs
• Showing them love and compassion

7. Building Mosques:
• The Prophet ﷺ said: "Whoever builds a mosque for the sake of Allah, Allah will build for him a house like it in Paradise." (Sahih Bukhari 450, Sahih Muslim 533)
• Even a small mosque or contributing to one
• Done purely for Allah's sake

8. Maintaining Family Ties (Silat ar-Rahm):
• The Prophet ﷺ said: "Whoever would like his provision to be increased and his lifespan to be extended, let him uphold the ties of kinship." (Sahih Bukhari 5986, Sahih Muslim 2557)
• Visiting relatives regularly
• Helping family members in need
• Reconciling between relatives

9. Visiting the Sick:
• The Prophet ﷺ said: "When a Muslim visits his sick brother in the morning, seventy thousand angels pray for him until evening, and when he visits him in the evening, seventy thousand angels pray for him until morning, and he will have a garden in Paradise." (Tirmidhi 969)
• Providing comfort and support to the ill
• Making dua for their recovery

10. Patience in Trials and Hardships (Sabr):
• "Indeed, the patient will be given their reward without account [i.e., limit]." (Quran 39:10)
• The Prophet ﷺ said: "No fatigue, illness, anxiety, sorrow, harm or sadness afflicts any Muslim, even to the extent of a thorn pricking him, without Allah expiating his sins by it." (Sahih Bukhari 5641, Sahih Muslim 2573)
• Accepting Allah's decree with satisfaction
• Not complaining about trials

11. Seeking Knowledge:
• The Prophet ﷺ said: "Whoever follows a path in the pursuit of knowledge, Allah will make easy for him a path to Paradise." (Sahih Muslim 2699)
• Learning and teaching Quran
• Studying Islamic sciences
• Sharing beneficial knowledge

12. Remembrance of Allah (Dhikr):
• The Prophet ﷺ was asked: "What are the gardens of Paradise?" He said: "Circles of dhikr." (Tirmidhi 3510)
• SubhanAllah, Alhamdulillah, La ilaha illallah, Allahu Akbar
• The Prophet ﷺ said: "Two phrases are light on the tongue, heavy on the Scale, and beloved to the Most Merciful: SubhanAllah wa bihamdihi, SubhanAllahi al-Azeem." (Sahih Bukhari 6406, Sahih Muslim 2694)

13. Recitation of the Quran:
• The Prophet ﷺ said: "Whoever recites a letter from the Book of Allah will receive a good deed, and the good deed is multiplied by ten. I do not say that Alif-Lam-Meem is one letter, rather Alif is a letter, Lam is a letter, and Meem is a letter." (Tirmidhi 2910)
• The companion of Quran will be told: "Recite and rise in status, recite as you used to recite in the world, for your status will be at the last verse that you recite." (Abu Dawud 1464, Tirmidhi 2914)

14. Jihad and Martyrdom:
• The Prophet ﷺ said: "Paradise is under the shade of swords." (Sahih Bukhari 2818, Sahih Muslim 1902)
• Striving in Allah's cause with wealth, life, and effort
• Jihad an-Nafs (struggling against one's desires) is also included
• The martyr gets special privileges and immediate entry

15. Making Wudu Perfectly:
• The Prophet ﷺ said: "Whoever performs wudu and does it well, then says: 'Ash-hadu an la ilaha illallah wahdahu la shareeka lah, wa ash-hadu anna Muhammadan abduhu wa rasooluhu (I bear witness that there is no god but Allah alone with no partner, and I bear witness that Muhammad is His slave and Messenger),' the eight gates of Paradise will be opened for him and he may enter through whichever one he wishes." (Sahih Muslim 234)

16. Feeding the Hungry:
• The Prophet ﷺ said: "Whoever feeds a hungry person, Allah will feed him from the fruits of Paradise." (Tirmidhi 2449)
• Providing food during Ramadan for those fasting
• Feeding the poor and needy

17. Forgiving Others:
• The Prophet ﷺ said: "Charity does not decrease wealth, and Allah increases the honor of one who forgives, and no one humbles himself for the sake of Allah except that Allah raises him." (Sahih Muslim 2588)
• Pardoning those who wrong you
• Letting go of grudges

18. Controlling Anger:
• The Prophet ﷺ said: "The strong man is not the one who can overpower others, rather the strong man is the one who controls himself when angry." (Sahih Bukhari 6114, Sahih Muslim 2609)
• Restraining anger for Allah's sake
• Not retaliating when able to

19. Being Generous:
• The Prophet ﷺ said: "The generous person is close to Allah, close to Paradise, close to people, and far from Hell. The stingy person is far from Allah, far from Paradise, far from people, and close to Hell." (Tirmidhi 1961)
• Giving freely for Allah's sake
• Helping others without expecting return

20. Praying at Night (Qiyam al-Layl):
• "Their sides forsake their beds to invoke their Lord in fear and aspiration, and from what We have provided them, they spend. And no soul knows what has been hidden for them of comfort for eyes as reward for what they used to do." (Quran 32:16-17)
• Waking up for Tahajjud prayer
• The last third of the night is most blessed

Small Deeds with Great Rewards:

The Prophet ﷺ taught us that even small actions can lead to Paradise:

• Smiling at your brother is charity (Tirmidhi 1956)
• Removing harmful objects from the road (Sahih Muslim 1914)
• A good word is charity (Sahih Bukhari 2989, Sahih Muslim 1009)
• Giving even half a date in charity (Sahih Bukhari 1417, Sahih Muslim 1016)
• Saying "SubhanAllah wa bihamdihi" 100 times daily - sins forgiven even if like sea foam (Sahih Bukhari 6405, Sahih Muslim 2691)
• Planting a tree or growing crops that people or animals eat from (Sahih Bukhari 2320, Sahih Muslim 1553)

The Path is Clear:
Allah has made the path to Paradise abundantly clear. Combine faith with action, sincerity with consistency, and fear of Allah with hope in His mercy. Every good deed, no matter how small, brings you closer to Paradise.

May Allah guide us all to these blessed deeds and grant us entry into His Paradise. Ameen.''',
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
• العفو والمسامحة''',
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

Allah has described in detail who will enter Paradise and what their characteristics, appearance, and blessings will be.

Characteristics of the Righteous Who Enter Paradise:

Their Qualities in This World:
• "Indeed, the righteous will be among gardens and springs, accepting what their Lord has given them. Indeed, they were before that doers of good. They used to sleep but little of the night. And in the hours before dawn they would ask forgiveness. And from their properties was [given] a right to the petitioner and the deprived." (Quran 51:15-19)
• They feared Allah in private and public
• They spent in charity during ease and hardship
• They controlled their anger and forgave people
• They were humble despite their achievements
• They remembered death frequently
• They turned to Allah in repentance

Believers Who Qualify:
• "And whoever does righteous deeds, whether male or female, while being a believer - those will enter Paradise and will not be wronged, [even as much as] the speck on a date seed." (Quran 4:124)
• Both men and women equally
• Based on faith and righteous deeds
• No injustice in the slightest degree

The First People to Enter Paradise:

The Prophet Muhammad ﷺ:
• The Prophet ﷺ said: "I will be the first one for whom the earth will split open on the Day of Resurrection, and I will be the first to intercede and the first whose intercession will be accepted. I will take hold of the handle of the gate of Paradise and shake it, and Allah will say: 'Who is this?' I will say: 'Muhammad.' He will say: 'Open for him.' And I will enter and find the All-Merciful on the right side." (Sahih Muslim 196)
• He will be the first to knock at Paradise's gate
• First to enter and lead his Ummah in
• Will stand at the Hawd (Pool of Kawthar) receiving his followers

The Poor and Destitute Muslims:
• The Prophet ﷺ said: "The poor Muslims will enter Paradise before the rich by five hundred years." (Tirmidhi 2354, Ibn Majah 4122)
• Half a day in the Hereafter
• Their accountability is easier - they had little worldly wealth to account for
• The Prophet ﷺ said: "I looked into Paradise and I saw that the majority of its people were the poor." (Sahih Bukhari 5196, Sahih Muslim 2737)

The Seventy Thousand Without Reckoning:
• The Prophet ﷺ said: "Seventy thousand of my Ummah will enter Paradise without reckoning." They asked: "Who are they, O Messenger of Allah?" He said: "Those who do not seek ruqyah (treatment through incantations), nor believe in bad omens, nor cauterize themselves, but put their trust in their Lord." (Sahih Bukhari 5705, Sahih Muslim 218)
• With each one, another seventy thousand will enter
• They bypass the reckoning entirely
• Enter Paradise immediately

Bilal ibn Rabah (RA):
• The Prophet ﷺ heard Bilal's footsteps in Paradise
• "O Bilal, what deed did you do in Islam that I heard the sound of your footsteps ahead of me in Paradise?" He said: "I did not do any deed that I consider greater than the fact that I never performed ablution, day or night, but I prayed after that ablution whatever Allah decreed for me to pray." (Sahih Bukhari 1149, Sahih Muslim 2458)
• His consistent worship after every wudu

Categories of People Guaranteed Paradise:

1. The Prophets and Messengers (peace be upon them all):
• The highest rank among all creation
• Led by Prophet Muhammad ﷺ in the highest level
• All 124,000 prophets sent throughout history
• Special stations and honors

2. The Ten Companions Promised Paradise (Al-Asharah al-Mubashsharah):
• Abu Bakr as-Siddiq (RA)
• Umar ibn al-Khattab (RA)
• Uthman ibn Affan (RA)
• Ali ibn Abi Talib (RA)
• Talhah ibn Ubaydullah (RA)
• Az-Zubayr ibn al-Awwam (RA)
• Sa'd ibn Abi Waqqas (RA)
• Sa'id ibn Zayd (RA)
• Abdur-Rahman ibn Awf (RA)
• Abu Ubaydah ibn al-Jarrah (RA)
• Given the glad tidings while still alive

3. The Martyrs (Shuhada):
• Those killed in the path of Allah
• The Prophet ﷺ said: "By Him in Whose Hand is my soul, I would love to be killed in the way of Allah and then be brought back to life so that I could be killed again, and then be brought back to life so that I could be killed again." (Sahih Bukhari 2797, Sahih Muslim 1876)
• Instant entry without reckoning
• Special privileges and stations
• "And never think of those who have been killed in the cause of Allah as dead. Rather, they are alive with their Lord, receiving provision." (Quran 3:169)

4. Those Who Die While Performing Hajj or Umrah:
• Die in a state of Ihram
• Raised on the Day of Resurrection saying "Labbayk Allahumma Labbayk"
• Guaranteed Paradise

5. Those Who Raise Daughters Properly:
• The Prophet ﷺ said: "Whoever takes care of two girls until they reach puberty, he and I will come on the Day of Resurrection like this - and he joined his fingers." (Sahih Muslim 2631)
• Treating them well with patience
• Providing proper Islamic upbringing

6. Those Who Care for Orphans:
• The Prophet ﷺ said: "I and the one who takes care of an orphan will be in Paradise like this," and he gestured with his index and middle fingers. (Sahih Bukhari 5304)
• Among the closest to the Prophet in Paradise
• Providing for their needs with love

7. Those Who Die on Friday or Friday Night:
• The Prophet ﷺ said: "There is no Muslim who dies on Friday or Friday night but Allah will protect him from the trial of the grave." (Tirmidhi 1074)
• Special blessing of this day

Physical Appearance in Paradise:

Age and Height:
• The Prophet ﷺ said: "The people of Paradise will enter Paradise hairless, beardless, with their eyes anointed with kohl, thirty years of age or thirty-three years old." (Tirmidhi 2545)
• Age 33 - the age of perfect youth and strength
• Some narrations mention 30 years
• The age of Prophet Isa (AS) when raised to heaven
• The Prophet ﷺ said: "Allah created Adam sixty cubits tall." (Sahih Bukhari 3326, Sahih Muslim 2841)
• People of Paradise will be in Adam's original form - 60 cubits (approximately 30 meters or 90 feet tall)

Beauty and Appearance:
• Beautiful appearance like Prophet Yusuf (AS)
• The Prophet ﷺ said: "The first group to enter Paradise will be like the full moon on the night of the full moon." (Sahih Bukhari 3246, Sahih Muslim 2834)
• Faces shining with radiant light
• The second group will be like the brightest shining star

Physical Perfection:
• No hair on their bodies except their heads
• No facial hair that needs grooming
• Eyes naturally lined with kohl (antimony)
• Perfect health - no illness whatsoever
• No aging - eternal youth
• No defects or disabilities
• No bodily functions that cause discomfort
• No sleep needed but can sleep if desired
• No fatigue or tiredness

Clothing and Adornment:
• "Upon them will be green garments of fine silk and brocade. And they will be adorned with bracelets of silver, and their Lord will give them a purifying drink." (Quran 76:21)
• Garments of silk - forbidden for men in this world, permitted in Paradise
• Green, gold, and various beautiful colors
• Adorned with gold and silver jewelry
• Crowns of pearls and precious stones
• Never need washing or replacement

Strength and Vitality:
• The Prophet ﷺ said: "The believer in Paradise will be given such and such strength for sexual intercourse." It was said: "O Messenger of Allah, will he be able to do that?" He said: "He will be given the strength of one hundred men." (Tirmidhi 2536)
• Perfect physical capability
• Endless energy and vitality

The Last Person to Enter Paradise:

His Struggle:
• The Prophet ﷺ described: "The last one to enter Paradise will be a man who will walk once and stumble once, and the Fire will scorch him once. Then, when he has got past it, he will turn and say: 'Blessed is He Who has saved me from you. Allah has given me something that He has not given to anyone among the earlier and later generations.'" (Sahih Bukhari 6571, Sahih Muslim 186)
• Will crawl on hands and knees to escape Hell
• Burned and scorched but eventually saved

His Blessings:
• Will be given ten times the size of this world
• The Prophet ﷺ said: "Allah will say to the last of the people of Paradise to enter it: 'Enter Paradise.' He will say: 'O Lord, how can I when all the people have taken their places and taken what they have taken?' Allah will say: 'Would it please you if you had the equivalent of the kingdom of one of the kings of the world?' He will say: 'I would be pleased, O Lord.' Allah will say: 'You have that, and the same again, and the same again, and the same again, and the same again.' On the fifth time he will say: 'I am pleased, O Lord.' Allah will say: 'This is for you and ten times as much.'" (Sahih Muslim 186)
• Even the lowest will have unimaginable blessings
• Whatever he wishes will appear instantly

Women of Paradise:

Believing Women:
• The righteous women of this world will be in Paradise
• "And whoever does righteous deeds, whether male or female, while being a believer - those will enter Paradise." (Quran 4:124)
• Will be far more beautiful than the Houris (Hoor al-Ayn)
• The Prophet ﷺ said: "The superiority of Aisha over other women is like the superiority of Tharid over other foods." (Sahih Bukhari 3770, Sahih Muslim 2431)
• Will be reunited with righteous husbands
• Eternal youth and beauty
• Perfect in every way

The Leaders of Women in Paradise:
• The Prophet ﷺ said: "The best of the women of Paradise are Khadijah bint Khuwaylid, Fatimah bint Muhammad, Maryam bint Imran, and Asiyah the wife of Pharaoh." (Sahih Bukhari 3815, Tirmidhi 3878)
• Khadijah (RA) - the Prophet's first wife
• Fatimah (RA) - the Prophet's daughter
• Maryam (Mary) - mother of Prophet Isa (AS)
• Asiyah - the righteous wife of Pharaoh

What About Widows:
• A woman will be with her last husband in this world
• If she had multiple marriages, she chooses whom to be with
• All will be happy and satisfied with Allah's decision

Children in Paradise:

Children Who Died Young:
• All children who die before puberty go to Paradise
• The Prophet ﷺ said: "The children of the Muslims are in Paradise." (Sahih Bukhari 1358)
• The Prophet ﷺ said: "There is no Muslim whose three children die before reaching puberty but Allah will admit him into Paradise by virtue of His mercy to them." (Sahih Bukhari 1248, Sahih Muslim 2632)

Their Status:
• Prophet Ibrahim (AS) takes care of them
• The Prophet ﷺ said during Mi'raj: "I saw Ibrahim, and he said: 'Welcome, O righteous Prophet and righteous son.' I asked: 'Who are these people with you, O Ibrahim?' He said: 'These are the children of the Muslims.'" (Sahih Bukhari 1386)
• They will intercede for their parents
• Will be reunited with believing parents

Social Life in Paradise:

Perfect Brotherhood:
• "And We will have removed whatever is within their breasts of resentment, [so they will be] brothers, on thrones facing each other." (Quran 15:47)
• No jealousy, envy, or hatred
• Perfect love and harmony among all
• Gathering with loved ones and family

Meeting the Prophets:
• Believers will meet and speak with prophets
• Learn from them directly
• Share in their company
• The greatest of honors

No Negative Emotions:
• No sadness, grief, or sorrow
• No anger or frustration
• No boredom or dissatisfaction
• Perfect contentment always
• "No fear will there be concerning them, nor will they grieve." (Quran 2:62)

The Ultimate Blessing:
While all these descriptions are magnificent, the greatest blessing will be seeing Allah, the Creator. The inhabitants of Paradise will see their Lord, and that moment will surpass every other pleasure.

May Allah make us among the people of Paradise and grant us the highest stations in Firdaus. Ameen.''',
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
• "وَالَّذِينَ آمَنُوا وَاتَّبَعَتْهُمْ ذُرِّيَّتُهُم" (سورة الطور: 21)''',
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

The blessings of Paradise are beyond human imagination, unlimited in variety, perfect in quality, and eternal in duration. Every desire will be fulfilled instantly, and happiness will be complete.

The Greatest Blessing - Seeing Allah (An-Nazhar ila Wajhillah):

The Supreme Joy:
• "Some faces, that Day, will be radiant, looking at their Lord." (Quran 75:22-23)
• This is the greatest blessing that surpasses all others
• The ultimate reward that makes everything else pale in comparison
• The Prophet ﷺ said: "When the people of Paradise enter Paradise, Allah will say: 'Do you want anything more?' They will say: 'Have You not made our faces white? Have You not admitted us into Paradise and saved us from the Fire?' Then He will remove the veil and they will not have been given anything more dear to them than looking at their Lord." (Sahih Muslim 181)

How They Will See Him:
• The Prophet ﷺ said: "You will see your Lord as you see the moon on the night when it is full, and you will not have any trouble in seeing Him." (Sahih Bukhari 554, Sahih Muslim 633)
• As clearly as seeing the full moon on a cloudless night
• No crowding or difficulty in seeing
• Each person will feel Allah is addressing them directly

When They Will See Him:
• Every Friday in the Hereafter
• Special gatherings in the presence of Allah
• The people of Paradise will visit the Valley of Peace
• Allah will manifest Himself to them

The Joy of This Vision:
• No pleasure compares to seeing the Creator
• Surpasses all other blessings combined
• Eternal happiness from this vision
• They will forget every other delight when seeing Him

Eternal Life - No Death or End:

The Promise of Immortality:
• "But those who have believed and done righteous deeds - We will admit them to gardens beneath which rivers flow, wherein they abide forever. [It is] the promise of Allah, [which is] truth, and who is more truthful than Allah in statement." (Quran 4:122)
• Life without end
• No fear of death ever again
• The Prophet ﷺ said: "Death will be brought forward in the shape of a black and white ram. It will be said: 'O people of Paradise, do you recognize this?' They will raise their heads and look, and will say: 'Yes, this is death.' Then it will be slaughtered and it will be said: 'O people of Paradise, it is eternal life and no death.'" (Sahih Bukhari 4730, Sahih Muslim 2849)

Perfect Health - No Illness or Pain:

Complete Wellbeing:
• No sickness of any kind
• No pain or discomfort
• No disabilities or deficiencies
• The Prophet ﷺ said: "The people of Paradise will enter Paradise hairless, beardless, with their eyes anointed with kohl, aged thirty years or thirty-three years." (Tirmidhi 2545)
• Perfect health forever

No Bodily Discomfort:
• No need for toilets - food converts to fragrant sweat
• The Prophet ﷺ said: "The people of Paradise will eat and drink but they will not spit, or urinate, or defecate. Their food will be digested and will come out as fragrant sweat like musk. They will glorify and praise Allah as naturally as you breathe." (Sahih Muslim 2835)
• No hunger unless desired
• No thirst unless wanted
• Perfect comfort always

Eternal Youth - Never Aging:

Forever Young:
• Age 33 - the prime of life
• Never growing old or weak
• Always at peak beauty and strength
• "Indeed, the companions of Paradise, that Day, will be amused in [joyful] occupation." (Quran 36:55)
• Eternal youthfulness and vitality

Food and Drink Beyond Imagination:

Varieties of Food:
• "And fruit of what they select." (Quran 56:20)
• Whatever they desire instantly appears
• "And the flesh of fowl, from whatever they desire." (Quran 56:21)
• Bird meat of every type
• Fruits of unlimited varieties
• Foods that don't exist in this world
• Everything perfectly delicious

Special Foods:
• The Prophet ﷺ said: "The people of Paradise will be served the extra lobe of fish liver." (Sahih Bukhari 6578, Sahih Muslim 2835)
• Considered the most delicious part
• First meal in Paradise

Drinks of Paradise:
• "A circulated cup [of wine] from a flowing spring, white and delicious to the drinkers; no bad effect is there in it, nor from it will they be intoxicated." (Quran 37:45-47)
• Rivers of milk, honey, wine, and pure water
• Wine that causes no intoxication or headache
• "They will be given to drink purified wine, sealed. The last of it is musk." (Quran 83:25-26)
• Drinks from springs of Kafur, Tasnim, and Salsabil

Palaces and Mansions:

Magnificent Structures:
• "But those who have feared their Lord - for them are chambers, above them chambers built [high], beneath which rivers flow." (Quran 39:20)
• Multi-story palaces
• Made of gold, silver, pearls, and precious stones
• The Prophet ﷺ said: "In Paradise there is a tent made of a single hollowed pearl, sixty miles wide." (Sahih Bukhari 3244, Sahih Muslim 2838)

Transparent Palaces:
• The Prophet ﷺ said: "In Paradise there are rooms whose outside can be seen from the inside and the inside from the outside. Allah has prepared them for those who feed the hungry, speak gently, fast regularly, and pray at night when people are sleeping." (Tirmidhi 1984)
• Made of precious gems
• Radiating beautiful light

Gardens and Landscapes:

Beautiful Gardens:
• "For them will be gardens beneath which rivers flow." (Quran 2:25)
• Lush greenery everywhere
• Perfectly landscaped
• "Gardens of perpetual residence." (Quran 98:8)

The Blessed Trees:
• Tree of Tuba: The Prophet ﷺ said: "Tuba is a tree in Paradise. It takes a hundred years for a rider to cross its shade." (Tirmidhi 2526)
• Its trunk is made of gold
• Provides clothing for Paradise's people
• Sidrat al-Muntaha at the boundary
• Fruits hanging low, within easy reach
• "And fruit, abundant [and varied], neither limited nor forbidden." (Quran 56:32-33)

The Spouses - Hoor al-Ayn (Maidens of Paradise):

Description of the Houris:
• "Fair ones reserved in pavilions." (Quran 55:72)
• "Full-breasted [companions] of equal age." (Quran 78:33)
• "And [they will have] fair women with large, [beautiful] eyes, the likenesses of pearls well-protected." (Quran 56:22-23)
• "As if they were rubies and coral." (Quran 55:58)
• The Prophet ﷺ said: "If a woman from the people of Paradise were to appear to the people of the earth, she would light up everything between them and fill it with fragrance." (Sahih Bukhari 3254)

Their Purity:
• "Therein are good and beautiful women - Fair ones reserved in pavilions - untouched before them by man or jinn." (Quran 55:70-74)
• Created specifically for Paradise
• Perfect in every way
• Pure in character and body

Number for Each Man:
• The Prophet ﷺ said: "The smallest reward for the people of Paradise is an abode with eighty thousand servants and seventy-two wives." (Tirmidhi 2562)
• Seventy-two Houris mentioned in authentic hadith
• Plus the believing women from this world who will be even more beautiful

Servants and Attendants:

Youthful Servants:
• "There will circulate among them young boys made eternal. When you see them, you would think them [as beautiful as] scattered pearls." (Quran 76:19)
• Eternally young servants
• Beautiful like scattered pearls
• Serving with perfect grace

Their Service:
• "There will circulate among them [servant] boys [especially] for them, as if they were pearls well-protected." (Quran 52:24)
• Bringing food and drink
• Attending to every need
• Beautiful and pleasing to look at

Clothing and Adornments:

Garments of Silk:
• "Upon them will be green garments of fine silk and brocade." (Quran 76:21)
• "Wearing silk and brocade." (Quran 44:53)
• Finest silk forbidden to men in this world
• Permitted and abundant in Paradise
• Various beautiful colors

Jewelry and Ornaments:
• "And they will be adorned with bracelets of silver, and their Lord will give them a purifying drink." (Quran 76:21)
• "Adorned therein with bracelets of gold and pearl, and their garments therein will be silk." (Quran 35:33)
• Crowns, bracelets, and necklaces
• Gold, silver, pearls, and precious gems
• Perfect beauty and adornment

Perfect Relationships and Social Life:

Family Reunion:
• "And those who believed and whose descendants followed them in faith - We will join with them their descendants, and We will not deprive them of anything of their deeds." (Quran 52:21)
• Reunited with righteous family members
• Parents with children
• Spouses together
• Extended family gathered

Pure Hearts:
• "And We will have removed whatever is within their breasts of resentment, [so they will be] brothers, on thrones facing each other." (Quran 15:47)
• No jealousy or envy
• No hatred or grudges
• Perfect love and brotherhood
• Pure hearts forever

Friendly Gatherings:
• "In gardens they will ask each other about the criminals." (Quran 74:40-41)
• Conversations and discussions
• Sharing stories and memories
• Perfect companionship

Meeting the Prophets and Companions:
• Opportunity to meet all the prophets
• Learn from them directly
• See the Prophet Muhammad ﷺ
• Meet the great companions
• The greatest honor and blessing

No Hardship, Pain, or Difficulty:

Freedom from All Suffering:
• "They will not hear therein ill speech or commission of sin - only a saying: 'Peace, peace.'" (Quran 56:25-26)
• No hurtful words
• No arguments or conflicts
• Only peace and greetings

No Fatigue:
• "No fatigue will touch them therein, nor from it will they be evicted." (Quran 15:48)
• Never tired or weary
• Endless energy
• Perfect rest when desired

No Heat or Cold:
• "They will not feel therein any [burning] sun or [freezing] cold." (Quran 76:13)
• Perfect temperature always
• Ultimate comfort

No Negative Emotions:
• No sadness or grief
• No worry or anxiety
• No fear of the future
• "No fear will there be concerning them, nor will they grieve." (Quran 2:62)
• Perfect happiness and contentment

Entertainment and Enjoyment:

Music and Beautiful Sounds:
• Angels will sing praises
• Beautiful melodies
• The Prophet ﷺ said: "In Paradise there is a marketplace where there is no buying or selling, only forms of men and women. When a man desires a form, he will enter into it." (Tirmidhi 2548)
• Perfect entertainment

Recreation:
• Whatever activities they enjoy
• Riding on special mounts
• Visiting different parts of Paradise
• Everything they desire

Instant Fulfillment of Desires:

Whatever They Wish:
• "They will have whatever they wish therein, and with Us is more." (Quran 50:35)
• Instant manifestation of desires
• No waiting or delay
• "For them is whatever they wish, and with Us is more." (Quran 50:35)

Divine Favor and Additional Gifts:
• Beyond what they ask for
• Surprises from Allah
• Continuous new blessings
• Ever-increasing joy

The Market of Paradise:

Special Gatherings:
• The Prophet ﷺ said: "In Paradise there is a marketplace to which they will come every Friday. The north wind will blow and scatter fragrance on their faces and clothes, and they will increase in beauty. They will return to their families who have also increased in beauty, and their families will say: 'By Allah, you have increased in beauty since you left us.' And they will say: 'By Allah, you have also increased in beauty since we left you.'" (Sahih Muslim 2833)
• Weekly gatherings
• Increase in beauty
• Perfect social interaction

The Ultimate Declaration of Allah:

Divine Satisfaction:
• The Prophet ﷺ said: "When the people of Paradise enter Paradise, Allah will say: 'Do you want Me to give you anything more?' They will say: 'Have You not brightened our faces? Have You not admitted us into Paradise and saved us from the Fire?' Then Allah will remove the veil and they will not be given anything more beloved to them than looking at their Lord." (Sahih Muslim 181)

Allah's Promise to Never Be Angry:
• The Prophet ﷺ said: "Allah will say to the people of Paradise: 'O people of Paradise!' They will reply: 'O our Lord, here we are! All good is in Your Hands!' Allah will ask: 'Are you pleased?' They will say: 'Why should we not be pleased, O Lord, when You have given us what You have not given to anyone else in creation?' Allah will say: 'Shall I not give you something better than that?' They will say: 'O Lord, what could be better than that?' Allah will say: 'I will bestow My pleasure upon you and will never be angry with you after this.'" (Sahih Bukhari 6549, Sahih Muslim 2829)
• The ultimate blessing
• Divine pleasure forever
• No fear of Allah's anger ever

This is Paradise - a place of endless blessings, perfect happiness, and eternal pleasure. A place where every desire is fulfilled, every wish granted, and every moment is bliss. And above all, the joy of being near Allah and seeing Him.

May Allah grant us all entry into His magnificent Paradise and allow us to enjoy all these blessings. Ameen.''',
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
• "سَلَامٌ قَوْلًا مِّن رَّبٍّ رَّحِيمٍ" (سورة يس: 58)''',
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

Firdaus (الفردوس) is the pinnacle of Paradise, the most exalted level, and the ultimate destination that every believer should aspire to reach.

The Meaning of Firdaus:

Etymology and Significance:
• The word "Firdaus" comes from an ancient language meaning "garden" or "orchard"
• In Islamic terminology, it refers to the highest level of Paradise
• It is the most noble and blessed part of Jannah
• The dwelling place of the elite among believers

The Quranic Mention:
• "Indeed, those who have believed and done righteous deeds - their refuge is the Gardens of Paradise. Wherein they abide eternally. They will not desire therefrom any transfer." (Quran 18:107-108)
• "Indeed, those who have believed and done righteous deeds - they will have the Gardens of Paradise as a lodging, wherein they abide eternally. They will not desire therefrom any transfer." (Quran 18:107-108)
• "The believers who do good works, for them are the Gardens of Paradise for hospitality." (Quran 18:107)

Location and Description of Firdaus:

The Highest Level:
• The Prophet Muhammad ﷺ said: "When you ask Allah for Paradise, ask Him for Al-Firdaus, for it is the highest part of Paradise and the middle of Paradise, and from it spring the rivers of Paradise, and above it is the Throne of the Most Merciful." (Sahih Bukhari 2790, 7423)
• The topmost level of all Paradise
• The central location from which everything flows
• Directly beneath the Throne of Allah (Al-Arsh)

The Center of Paradise:
• It is described as "the middle of Paradise" (awsatu al-Jannah)
• Not in terms of position, but in terms of excellence
• The best and most central part
• The heart of Paradise

Above it is the Throne:
• The ceiling of Firdaus is the Throne of the Most Merciful
• The closest level to Allah's Throne
• Maximum proximity to the divine presence
• The most honored position in all creation

The Source of Paradise's Rivers:
• All four main rivers of Paradise originate from Firdaus
• Rivers of water, milk, wine, and honey flow from here
• They descend to lower levels of Paradise
• The source of all blessings in Jannah

Who Will Enter Firdaus:

The Prophets and Messengers:
• All prophets will be in Firdaus
• Led by Prophet Muhammad ﷺ in the highest station
• Prophet Ibrahim (AS), Musa (AS), Isa (AS), and all others
• The most honored among Allah's creation

The Truthful (As-Siddiqun):
• "And whoever obeys Allah and the Messenger - those will be with the ones upon whom Allah has bestowed favor of the prophets, the steadfast affirmers of truth, the martyrs and the righteous. And excellent are those as companions." (Quran 4:69)
• Those who perfected truthfulness in faith and action
• Abu Bakr as-Siddiq (RA) as the prime example
• Those whose faith never wavered

The Martyrs (Ash-Shuhada):
• Those who died in the path of Allah
• Given the highest honors
• Special stations in Firdaus
• Immediate entry without reckoning

The Righteous (As-Salihun):
• Those who consistently did good deeds
• Maintained righteousness throughout life
• Avoided major sins and repented from minor ones
• "Those are the inheritors who will inherit al-Firdaus. They will abide therein eternally." (Quran 23:10-11)

Specific Categories Mentioned:

Those Who Perfect the Following:
• "Successful indeed are the believers: those who humble themselves in prayer, who shun idle talk, who pay the prescribed alms, who guard their chastity except with their spouses or their slaves - with these they are not to blame, but anyone who seeks more than this is exceeding the limits - who are faithful to their trusts and pledges and who keep up their prayers: these are the heirs to Paradise; they will remain there." (Quran 23:1-11)

1. Humility in Prayer (Khushu):
• Praying with full concentration
• Heart present during Salah
• Not distracted or mechanical

2. Avoiding Idle Talk (Laghw):
• Avoiding useless speech
• No backbiting or gossip
• Meaningful conversations

3. Giving Zakah:
• Purifying wealth
• Helping the needy
• Fulfilling this obligation

4. Guarding Chastity:
• Protecting private parts from unlawful relations
• Maintaining purity
• Only lawful intimacy with spouses

5. Keeping Trusts:
• Fulfilling promises
• Being reliable
• Maintaining integrity

6. Maintaining Prayers:
• Consistency in five daily prayers
• Praying on time
• Never abandoning Salah

The Prophet's Special Station - Al-Wasilah:

The Highest Position:
• The Prophet ﷺ said: "Ask Allah to grant me Al-Wasilah, which is a station in Paradise that befits only one of Allah's servants, and I hope that I will be that one." (Sahih Muslim 384)
• The absolute highest rank in Paradise
• Reserved for Prophet Muhammad ﷺ alone
• Above all other stations in Firdaus

Al-Maqam al-Mahmud (The Praised Station):
• The station of intercession on the Day of Judgment
• "It is expected that your Lord will raise you to a praised station." (Quran 17:79)
• All of creation will praise him for this
• The ultimate honor

How to Attain Firdaus:

1. Sincere Faith and Belief (Iman):
• Complete faith in Allah
• Belief in all pillars of faith
• Unwavering conviction
• "Those who believe and do righteous deeds - they are the best of creatures. Their reward with their Lord will be gardens of perpetual residence beneath which rivers flow, wherein they will abide forever, Allah being pleased with them and they with Him. That is for whoever has feared his Lord." (Quran 98:7-8)

2. Righteous Deeds Consistently:
• Not just occasional good deeds
• Consistent lifelong practice
• Quality and quantity both matter
• "And whoever does good works, whether male or female, and has faith, will enter Paradise and will not be wronged by as much as the speck on a date stone." (Quran 4:124)

3. Excellence in Worship (Ihsan):
• The Prophet ﷺ defined Ihsan: "To worship Allah as if you see Him, for if you do not see Him, then indeed He sees you." (Sahih Bukhari 50, Sahih Muslim 8)
• Perfecting worship
• Doing good for Allah's sake alone
• The highest level of consciousness

4. Striving in Allah's Path (Jihad):
• The 100 levels of Paradise were prepared for the Mujahideen
• Jihad includes physical struggle and inner struggle
• Fighting desires and Satan
• Standing up for truth

5. Patience in Trials (Sabr):
• Enduring hardships with patience
• Not complaining about Allah's decree
• Accepting what Allah wills
• "And We will surely test you with something of fear and hunger and a loss of wealth and lives and fruits, but give good tidings to the patient." (Quran 2:155)

6. Seeking Knowledge:
• "Allah will raise those who have believed among you and those who were given knowledge, by degrees." (Quran 58:11)
• Learning and teaching Islam
• Acting upon knowledge
• Spreading beneficial knowledge

7. Good Character (Akhlaq):
• The Prophet ﷺ said: "The dearest and nearest among you to me on the Day of Resurrection will be the one who is best in manners." (Tirmidhi 2018)
• Beautiful character elevates ranks
• Treatment of others matters
• Following the Prophet's example

8. Dhikr and Quran Recitation:
• Constant remembrance of Allah
• Regular Quran recitation
• The one who memorizes Quran: "It will be said to the companion of the Quran: Recite and rise in status." (Abu Dawud 1464, Tirmidhi 2914)

9. Night Prayer (Qiyam al-Layl):
• "Their sides forsake their beds." (Quran 32:16)
• Waking for Tahajjud
• Special connection with Allah
• Sign of the elite

10. Charity and Generosity:
• Spending in Allah's path
• Helping the poor and needy
• Building hospitals, schools, mosques
• Every act of kindness

The Prophet's Direct Command:

Ask for Firdaus Specifically:
• The Prophet ﷺ instructed: "When you ask Allah for Paradise, ask Him for Al-Firdaus." (Sahih Bukhari 2790, 7423)
• Don't just ask for "Paradise" in general
• Be specific and aim high
• Ask for the best

Why Ask for the Highest:
• Shows ambition in faith
• Demonstrates high aspirations
• Allah loves when His servants ask for the best
• Even if you fall short, you'll be in high levels

The Dua for Firdaus:

Recommended Supplications:
• "Allahumma inni as'aluka al-Jannah wa as'aluka al-Firdaus al-A'la" (O Allah, I ask You for Paradise and I ask You for Al-Firdaus al-A'la - the Highest Paradise)
• "Allahumma adkhilni al-Firdaus al-A'la min ghayri hisab wa la adhab" (O Allah, admit me into the Highest Firdaus without reckoning or punishment)
• "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhaban-nar" (Our Lord, give us good in this world and good in the Hereafter and save us from the punishment of the Fire)

When to Make This Dua:
• After every Salah
• In Sujud (prostration)
• During the last third of the night
• On Friday
• In Ramadan
• Between Adhan and Iqamah
• When it rains
• At any time with sincerity

The Special Features of Firdaus:

Greatest Proximity to Allah:
• Nearest to the Divine Throne
• More frequent visions of Allah
• Greater blessings than all other levels
• The ultimate honor

The Best Blessings:
• Whatever exists in lower Paradise exists here in perfection
• Additional blessings unique to Firdaus
• The best of everything
• Unlimited and unimaginable delights

The Best Company:
• With the prophets
• With the greatest companions
• With the elite of every generation
• The most righteous souls

Peace and Perfect Satisfaction:
• Complete contentment
• No desire for anything more
• Perfect happiness
• Eternal bliss

The Inheritance of Firdaus:

The Quranic Promise:
• "Those are the inheritors who will inherit al-Firdaus. They will abide therein eternally." (Quran 23:10-11)
• It is an inheritance, not just a reward
• Guaranteed for those who meet the criteria
• Eternal residence without end

No Desire to Leave:
• "Wherein they abide eternally. They will not desire therefrom any transfer." (Quran 18:108)
• Perfect satisfaction
• No wish for anything different
• Complete and eternal contentment

Practical Steps to Reach Firdaus:

1. Make it Your Goal:
• Set your sights on the highest
• Let it motivate your actions
• Remember it in trials
• Work towards it daily

2. Follow the Quran and Sunnah:
• The path is clearly outlined
• Follow the Prophet's example
• Implement Islamic teachings
• Live by Allah's commands

3. Be Consistent:
• Daily good deeds
• Regular worship
• Continuous improvement
• Never give up

4. Increase Good Deeds:
• Don't be satisfied with minimum
• Do extra (nawafil)
• Compete in goodness
• Race toward Paradise

5. Make Dua Constantly:
• Ask Allah for Firdaus
• Be specific in requests
• Have hope in His mercy
• Never stop asking

6. Help Others Reach It:
• Teach and guide
• Support good causes
• Encourage righteousness
• Share knowledge

7. Maintain Hope and Fear:
• Hope in Allah's mercy
• Fear His punishment
• Balance both emotions
• Trust in His justice

The Ultimate Success:

This is the ultimate goal of a believer's life - to reach Firdaus, the highest level of Paradise, where they will dwell forever in the presence of their Lord, enjoying blessings beyond imagination, in the company of the best of creation.

May Allah grant us all Firdaus al-A'la and make us neighbors of the Prophet Muhammad ﷺ. May He allow us to see His Noble Face and grant us His eternal pleasure. Ameen, Ya Rabbal Alameen.''',
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
• حسن الخلق والإحسان إلى الخلق''',
      },
    },
    {
      'number': 7,
      'titleKey': 'jannat_fazilat_7_gates_of_paradise',
      'title': 'The 8 Gates of Paradise',
      'titleUrdu': 'جنت کے آٹھ دروازے',
      'titleHindi': 'जन्नत के आठ दरवाज़े',
      'titleArabic': 'أبواب الجنة الثمانية',
      'icon': Icons.door_front_door,
      'color': Color(0xFF2E7D32),
      'details': {
        'english': '''The 8 Gates of Paradise

Paradise has eight magnificent gates, each designated for different acts of worship and righteousness.

Number of Gates:
According to authentic hadith from Sahih Bukhari and Muslim:
• "In Paradise, there are eight gates, among which is a gate called Ar-Rayyan which only those who fast will enter."
• Prophet Muhammad ﷺ said: "Whoever performs ablution (wudu) thoroughly, saying sincerely from the heart 'I testify that there is no god but Allah alone with no partner, and I testify that Muhammad is His servant and Messenger,' eight gates of Paradise will be opened for him on the Day of Resurrection, and he may enter through whichever he wishes."

The Names of the 8 Gates:

1. **Baab As-Salaat (Gate of Prayer)**
• For those who were punctual and focused on their prayers
• Those who maintained the five daily prayers consistently
• Hadith: "Whoever prays the two cool prayers (Fajr and Asr) will enter Paradise" (Bukhari)

2. **Baab Ar-Rayyan (Gate of Fasting)**
• Specifically reserved for those who fasted regularly
• Prophet ﷺ said: "In Paradise there is a gate called Ar-Rayyan, through which those who used to fast will enter on the Day of Resurrection, and no one but they will enter it. It will be said, 'Where are those who fasted?' They will get up, and none will enter it but them. When they have entered, it will be locked, and no one else will enter." (Bukhari & Muslim)
• This gate will be locked after all fasters enter

3. **Baab Al-Jihad (Gate of Jihad)**
• For those who participated in Jihad and strived in the path of Allah
• For those who died as martyrs (Shuhadaa)
• For those who struggled against their own nafs (lower desires)

4. **Baab As-Sadaqah (Gate of Charity)**
• Opened to those who frequently gave charity
• For the generous who spent in Allah's way
• Prophet ﷺ said: "Whoever spends a pair in the cause of Allah will be called from the gates of Paradise" (Bukhari)

5. **Baab Al-Hajj (Gate of Pilgrimage)**
• Reserved for those who performed Hajj
• For those who observed the pilgrimage with sincerity
• Especially for those who performed Hajj Mabroor (accepted Hajj)

6. **Baab Al-Kadhimin Al-Ghaiz (Gate of Restraining Anger)**
• For people who controlled their anger
• For those who were forgiving towards others
• For those who suppressed rage and pardoned people
• Quranic reference: "And those who restrain anger and who pardon the people - and Allah loves the doers of good" (3:134)

7. **Baab Al-Iman (Gate of Faith)**
• For those who had steadfast faith in Allah
• For people who trusted Allah's decisions
• For those who lived according to Allah's commands
• For the believers who never associated partners with Allah

8. **Baab Al-Dhikr (Gate of Remembrance)**
• For believers who constantly remembered Allah
• For those who regularly engaged in Dhikr
• For those whose tongues were always moist with Allah's remembrance
• Prophet ﷺ said: "The people of Paradise will be called from all these gates" (Bukhari)

Entry Through Multiple Gates:
When Abu Bakr As-Siddiq (RA) asked the Prophet Muhammad ﷺ:
"Will there be anyone who will be called from all these gates?"
The Prophet ﷺ answered: "Yes. And I hope you will be one of them, O Abu Bakr."

This shows that the most righteous believers may be honored to enter through any gate they choose, having excelled in all forms of worship.

Physical Description of the Gates:
• Made of precious metals and jewels
• Extremely vast - the distance between the two door posts is equivalent to a journey of 40 years
• Guarded by angels
• Each gate leads to Paradise's specific sections
• They will be wide open for the righteous

Who Will Be Called:
The gates will call out to those who excelled in specific acts of worship:
• Those who pray five times daily → Baab As-Salaat
• Those who fast Ramadan and other days → Baab Ar-Rayyan
• Those who give charity regularly → Baab As-Sadaqah
• Those who performed Hajj → Baab Al-Hajj
• And so on for each gate

The Ultimate Goal:
• Strive to be called from all eight gates like Abu Bakr (RA)
• Excel in all forms of worship, not just one
• Balance your acts of righteousness
• Seek Allah's pleasure in every deed

Practical Steps:
1. Maintain all five daily prayers
2. Fast regularly (Ramadan + voluntary fasts)
3. Give charity consistently
4. Control your anger and forgive others
5. Remember Allah frequently
6. Strive for Hajj if able
7. Uphold strong faith (Iman)
8. Struggle against your ego and desires

"Those are the Gates of Paradise prepared for the believers, so let them strive to enter through as many as they can by their good deeds."''',
        'urdu': '''جنت کے آٹھ دروازے

جنت میں آٹھ عظیم دروازے ہیں، ہر ایک مختلف عبادات اور نیک اعمال کے لیے مخصوص ہے۔

دروازوں کی تعداد:
صحیح بخاری اور مسلم کی حدیث کے مطابق:
• "جنت میں آٹھ دروازے ہیں، جن میں سے ایک دروازہ ریان کہلاتا ہے جس سے صرف روزہ دار داخل ہوں گے۔"
• نبی کریم ﷺ نے فرمایا: "جس نے اچھی طرح وضو کیا اور دل سے خلوص کے ساتھ کہا 'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اور میں گواہی دیتا ہوں کہ محمد ﷺ اللہ کے بندے اور رسول ہیں'، قیامت کے دن اس کے لیے جنت کے آٹھ دروازے کھول دیے جائیں گے، اور وہ جس سے چاہے داخل ہو سکتا ہے۔"

آٹھ دروازوں کے نام:

1. **باب الصلاۃ (نماز کا دروازہ)**
• ان لوگوں کے لیے جو اپنی نمازوں میں پابند اور متوجہ تھے
• جنہوں نے پانچ وقت کی نمازیں مسلسل ادا کیں
• حدیث: "جس نے دو ٹھنڈی نمازیں (فجر اور عصر) پڑھیں وہ جنت میں داخل ہوگا" (بخاری)

2. **باب الریان (روزے کا دروازہ)**
• خاص طور پر ان لوگوں کے لیے مخصوص جو باقاعدگی سے روزے رکھتے تھے
• نبی کریم ﷺ نے فرمایا: "جنت میں ایک دروازہ ہے جسے ریان کہا جاتا ہے، جس سے قیامت کے دن صرف روزہ دار داخل ہوں گے، ان کے علاوہ کوئی اور داخل نہیں ہوگا۔ کہا جائے گا، 'روزہ دار کہاں ہیں؟' وہ کھڑے ہوں گے، اور ان کے علاوہ کوئی اس سے داخل نہیں ہوگا۔ جب وہ داخل ہو جائیں گے، تو اسے بند کر دیا جائے گا، اور کوئی اور داخل نہیں ہوگا۔" (بخاری و مسلم)
• یہ دروازہ تمام روزہ داروں کے داخل ہونے کے بعد بند کر دیا جائے گا

3. **باب الجہاد (جہاد کا دروازہ)**
• ان لوگوں کے لیے جنہوں نے جہاد میں حصہ لیا اور اللہ کی راہ میں کوشش کی
• ان لوگوں کے لیے جو شہید ہوئے
• ان لوگوں کے لیے جنہوں نے اپنے نفس کے خلاف جدوجہد کی

4. **باب الصدقہ (خیرات کا دروازہ)**
• ان لوگوں کے لیے کھولا جائے گا جو اکثر خیرات کرتے تھے
• سخی لوگوں کے لیے جنہوں نے اللہ کی راہ میں خرچ کیا
• نبی کریم ﷺ نے فرمایا: "جس نے اللہ کی راہ میں ایک جوڑا خرچ کیا، اسے جنت کے دروازوں سے بلایا جائے گا" (بخاری)

5. **باب الحج (حج کا دروازہ)**
• ان لوگوں کے لیے مخصوص جنہوں نے حج ادا کیا
• ان لوگوں کے لیے جنہوں نے خلوص کے ساتھ حج کیا
• خاص طور پر ان لوگوں کے لیے جنہوں نے حج مبرور ادا کیا

6. **باب الکاظمین الغیظ (غصے پر قابو کا دروازہ)**
• ان لوگوں کے لیے جنہوں نے اپنے غصے کو قابو میں رکھا
• ان لوگوں کے لیے جو دوسروں کو معاف کرنے والے تھے
• ان لوگوں کے لیے جنہوں نے غصے کو دبایا اور لوگوں کو معاف کیا
• قرآنی حوالہ: "اور وہ لوگ جو غصے کو روکتے ہیں اور لوگوں کو معاف کرتے ہیں - اور اللہ نیکی کرنے والوں سے محبت کرتا ہے" (3:134)

7. **باب الایمان (ایمان کا دروازہ)**
• ان لوگوں کے لیے جن کا اللہ پر پختہ ایمان تھا
• ان لوگوں کے لیے جنہوں نے اللہ کے فیصلوں پر بھروسہ کیا
• ان لوگوں کے لیے جنہوں نے اللہ کے احکام کے مطابق زندگی گزاری
• مومنین کے لیے جنہوں نے کبھی اللہ کے ساتھ شریک نہیں کیا

8. **باب الذکر (ذکر کا دروازہ)**
• ان مومنین کے لیے جو مسلسل اللہ کو یاد کرتے تھے
• ان لوگوں کے لیے جو باقاعدگی سے ذکر میں مشغول رہتے تھے
• ان لوگوں کے لیے جن کی زبانیں ہمیشہ اللہ کے ذکر سے تر رہتی تھیں
• نبی کریم ﷺ نے فرمایا: "جنت والوں کو ان تمام دروازوں سے بلایا جائے گا" (بخاری)

متعدد دروازوں سے داخلہ:
جب ابوبکر صدیق (رض) نے نبی کریم ﷺ سے پوچھا:
"کیا کوئی ایسا ہوگا جسے ان تمام دروازوں سے بلایا جائے گا؟"
نبی کریم ﷺ نے جواب دیا: "ہاں۔ اور مجھے امید ہے کہ تم ان میں سے ایک ہوگے، اے ابوبکر۔"

یہ ظاہر کرتا ہے کہ سب سے زیادہ نیک مومنین کو یہ اعزاز حاصل ہو سکتا ہے کہ وہ کسی بھی دروازے سے داخل ہو سکیں، کیونکہ انہوں نے تمام قسم کی عبادات میں کمال حاصل کیا۔

دروازوں کی جسمانی تفصیل:
• قیمتی دھاتوں اور جواہرات سے بنے ہوئے
• انتہائی وسیع - دو چوکھٹوں کے درمیان فاصلہ 40 سال کے سفر کے برابر ہے
• فرشتوں کی حفاظت میں
• ہر دروازہ جنت کے مخصوص حصوں کی طرف لے جاتا ہے
• نیک لوگوں کے لیے کھلے رہیں گے

کسے بلایا جائے گا:
دروازے ان لوگوں کو پکاریں گے جنہوں نے مخصوص عبادات میں کمال حاصل کیا:
• جو پانچ وقت نماز پڑھتے ہیں → باب الصلاۃ
• جو رمضان اور دوسرے دنوں میں روزے رکھتے ہیں → باب الریان
• جو باقاعدگی سے خیرات کرتے ہیں → باب الصدقہ
• جنہوں نے حج ادا کیا → باب الحج
• اور اسی طرح ہر دروازے کے لیے

حتمی مقصد:
• ابوبکر (رض) کی طرح تمام آٹھ دروازوں سے بلائے جانے کی کوشش کریں
• تمام قسم کی عبادات میں کمال حاصل کریں، صرف ایک میں نہیں
• اپنے نیک اعمال میں توازن رکھیں
• ہر عمل میں اللہ کی رضا تلاش کریں

عملی اقدامات:
1. تمام پانچ وقت کی نمازیں برقرار رکھیں
2. باقاعدگی سے روزے رکھیں (رمضان + نفلی روزے)
3. مسلسل خیرات کریں
4. اپنے غصے کو قابو میں رکھیں اور دوسروں کو معاف کریں
5. اللہ کو کثرت سے یاد کریں
6. اگر قدرت ہو تو حج کی کوشش کریں
7. مضبوط ایمان برقرار رکھیں
8. اپنے نفس اور خواہشات کے خلاف جدوجہد کریں

"یہ جنت کے دروازے مومنین کے لیے تیار ہیں، تو انہیں چاہیے کہ اپنے نیک اعمال سے زیادہ سے زیادہ دروازوں سے داخل ہونے کی کوشش کریں۔"''',
        'hindi': '''जन्नत के आठ दरवाज़े

जन्नत में आठ शानदार दरवाज़े हैं, हर एक मुख्तलिफ़ इबादतों और नेकियों के लिए मख़्सूस है।

दरवाज़ों की तादाद:
सहीह बुख़ारी और मुस्लिम की हदीस के मुताबिक़:
• "जन्नत में आठ दरवाज़े हैं, जिनमें से एक दरवाज़ा रय्यान कहलाता है जिससे सिर्फ़ रोज़ेदार दाख़िल होंगे।"
• नबी करीम ﷺ ने फ़रमाया: "जिसने अच्छी तरह वुज़ू किया और दिल से ख़ुलूस के साथ कहा 'मैं गवाही देता हूं कि अल्लाह के सिवा कोई मा'बूद नहीं, वो अकेला है, उसका कोई शरीक नहीं, और मैं गवाही देता हूं कि मुहम्मद ﷺ अल्लाह के बंदे और रसूल हैं', क़यामत के दिन उसके लिए जन्नत के आठ दरवाज़े खोल दिए जाएंगे, और वो जिससे चाहे दाख़िल हो सकता है।"

आठ दरवाज़ों के नाम:

1. **बाब अस-सलात (नमाज़ का दरवाज़ा)**
• उन लोगों के लिए जो अपनी नमाज़ों में पाबंद और मुतवज्जो थे
• जिन्होंने पांच वक़्त की नमाज़ें मुसलसल अदा कीं
• हदीस: "जिसने दो ठंडी नमाज़ें (फ़ज्र और असर) पढ़ीं वो जन्नत में दाख़िल होगा" (बुख़ारी)

2. **बाब अर-रय्यान (रोज़े का दरवाज़ा)**
• ख़ास तौर पर उन लोगों के लिए मख़्सूस जो बाक़ायदगी से रोज़े रखते थे
• नबी करीम ﷺ ने फ़रमाया: "जन्नत में एक दरवाज़ा है जिसे रय्यान कहा जाता है, जिससे क़यामत के दिन सिर्फ़ रोज़ेदार दाख़िल होंगे, उनके अलावा कोई और दाख़िल नहीं होगा। कहा जाएगा, 'रोज़ेदार कहां हैं?' ���ो खड़े होंगे, और उनके अलावा कोई इससे दाख़िल नहीं होगा। जब वो दाख़िल हो जाएंगे, तो उसे बंद कर दिया जाएगा, और कोई और दाख़िल नहीं होगा।" (बुख़ारी व मुस्लिम)
• यह दरवाज़ा तमाम रोज़ेदारों के दाख़िल होने के बाद बंद कर दिया जाएगा

3. **बाब अल-जिहाद (जिहाद का दरवाज़ा)**
• उन लोगों के लिए जिन्होंने जिहाद में हिस्सा लिया और अल्लाह की राह में कोशिश की
• उन लोगों के लिए जो शहीद हुए
• उन लोगों के लिए जिन्होंने अपने नफ़्स के ख़िलाफ़ जद्दोजहद की

4. **बाब अस-सदक़ा (ख़ैरात का दरवाज़ा)**
• उन लोगों के लिए खोला जाएगा जो अक्सर ख़ैरात करते थे
• सख़ी लोगों के लिए जिन्होंने अल्लाह की राह में ख़र्च किया
• नबी करीम ﷺ ने फ़रमाया: "जिसने अल्लाह की राह में एक जोड़ा ख़र्च किया, उसे जन्नत के दरवाज़ों से बुलाया जाएगा" (बुख़ारी)

5. **बाब अल-हज्ज (हज का दरवाज़ा)**
• उन लोगों के लिए मख़्सूस जिन्होंने हज अदा किया
• उन लोगों के लिए जिन्होंने ख़ुलूस के साथ हज किया
• ख़ास तौर पर उन लोगों के लिए जिन्होंने हज मबरूर अदा किया

6. **बाब अल-काज़िमीन अल-ग़ैज़ (ग़ुस्से पर क़ाबू का दरवाज़ा)**
• उन लोगों के लिए जिन्होंने अपने ग़ुस्से को क़ाबू में रखा
• उन लोगों के लिए जो दूसरों को माफ़ करने वाले थे
• उन लोगों के लिए जिन्होंने ग़ुस्से को दबाया और लोगों को माफ़ किया
• क़ुरआनी हवाला: "और वो लोग जो ग़ुस्से को रोकते हैं और लोगों को माफ़ करते हैं - और अल्लाह नेकी करने वालों से मुहब्बत करता है" (3:134)

7. **बाब अल-ईमान (ईमान का दरवाज़ा)**
• उन लोगों के लिए जिनका अल्लाह पर पुख़्ता ईमान था
• उन लोगों के लिए जिन्होंने अल्लाह के फ़ैसलों पर भरोसा किया
• उन लोगों के लिए जिन्होंने अल्लाह के अहकाम के मुताबिक़ ज़िंदगी गुज़ारी
• मोमिनीन के लिए जिन्होंने कभी अल्लाह के साथ शरीक नहीं किया

8. **बाब अज़-ज़िक्र (ज़िक्र का दरवाज़ा)**
• उन मोमिनीन के लिए जो मुसलसल अल्लाह को याद करते थे
• उन लोगों के लिए जो बाक़ायदगी से ज़िक्र में मशग़ूल रहते थे
• उन लोगों के लिए जिनकी ज़बानें हमेशा अल्लाह के ज़िक्र से तर रहती थीं
• नबी करीम ﷺ ने फ़रमाया: "जन्नत वालों को इन तमाम दरवाज़ों से बुलाया जाएगा" (बुख़ारी)

मुतअद्दिद दरवाज़ों से दाख़िला:
जब अबू बकर सिद्दीक़ (रज़ि०) ने नबी करीम ﷺ से पूछा:
"क्या कोई ऐसा होगा जिसे इन तमाम दरवाज़ों से बुलाया जाएगा?"
नबी करीम ﷺ ने जवाब दिया: "हां। और मुझे उम्मीद है कि तुम उनमें से एक होगे, ऐ अबू बकर।"

यह ज़ाहिर करता है कि सबसे ज़्यादा नेक मोमिनीन को यह इज़्ज़त हासिल हो सकती है कि वो किसी भी दरवाज़े से दाख़िल हो सकें, क्योंकि उन्होंने तमाम क़िस्म की इबादतों में कमाल हासिल किया।

दरवाज़ों की जिस्मानी तफ़सील:
• क़ीमती धातुओं और जवाहिरात से बने हुए
• इंतिहाई वसी' - दो चौखटों के दरमियान फ़ासला 40 साल के सफ़र के बराबर है
• फ़रिश्तों की हिफ़ाज़त में
• हर दरवाज़ा जन्नत के मख़्सूस हिस्सों की तरफ़ ले जाता है
• नेक लोगों के लिए खुले रहेंगे

किसे बुलाया जाएगा:
दरवाज़े उन लोगों को पुकारेंगे जिन्होंने मख़्सूस इबादतों में कमाल हासिल किया:
• जो पांच वक़्त नमाज़ पढ़ते हैं → बाब अस-सलात
• जो रमज़ान और दूसरे दिनों में रोज़े रखते हैं → बाब अर-रय्यान
• जो बाक़ायदगी से ख़ैरात करते हैं → बाब अस-सदक़ा
• जिन्होंने हज अदा किया → बाब अल-हज्ज
• और इसी तरह हर दरवाज़े के लिए

हतमी मक़सद:
• अबू बकर (रज़ि०) की तरह तमाम आठ दरवाज़ों से बुलाए जाने की कोशिश करें
• तमाम क़िस्म की इबादतों में कमाल हासिल करें, सिर्फ़ एक में नहीं
• अपने नेक आमाल में तवाज़ुन रखें
• हर अमल में अल्लाह की रिज़ा तलाश करें

अमली इक़दामात:
1. तमाम पांच वक़्त की नमाज़ें बरक़रार रखें
2. बाक़ायदगी से रोज़े रखें (रमज़ान + नफ़्ल रोज़े)
3. मुसलसल ख़ैरात करें
4. अपने ग़ुस्से को क़ाबू में रखें और दूसरों को माफ़ करें
5. अल्लाह को कसरत से याद करें
6. अगर क़ुदरत हो तो हज की कोशिश करें
7. मज़बूत ईमान बरक़रार रखें
8. अपने नफ़्स और ख़्वाहिशात के ख़िलाफ़ जद्दोजहद करें

"यह जन्नत के दरवाज़े मोमिनीन के लिए तैयार हैं, तो उन्हें चाहिए कि अपने नेक आमाल से ज़्यादा से ज़्यादा दरवाज़ों से दाख़िल होने की कोशिश करें।"''',
        'arabic': '''الأبواب الثمانية للجنة

للجنة ثمانية أبواب عظيمة، كل منها مخصص لأعمال مختلفة من العبادة والصلاح.

عدد الأبواب:
حسب الحديث الصحيح من البخاري ومسلم:
• "في الجنة ثمانية أبواب، من بينها باب يسمى الريان لا يدخله إلا الصائمون."
• قال النبي ﷺ: "من توضأ فأحسن الوضوء ثم قال بإخلاص من قلبه: أشهد أن لا إله إلا الله وحده لا شريك له، وأشهد أن محمداً عبده ورسوله، فتحت له أبواب الجنة الثمانية يوم القيامة، يدخل من أيها شاء."

أسماء الأبواب الثمانية:

1. **باب الصلاة**
• للذين كانوا مواظبين ومتوجهين في صلواتهم
• الذين حافظوا على الصلوات الخمس بانتظام
• الحديث: "من صلى البردين (الفجر والعصر) دخل الجنة" (البخاري)

2. **باب الريان**
• مخصص للذين صاموا بانتظام
• قال النبي ﷺ: "إن في الجنة باباً يقال له الريان، يدخل منه الصائمون يوم القيامة، لا يدخل منه أحد غيرهم، يقال: أين الصائمون؟ فيقومون، لا يدخل منه أحد غيرهم، فإذا دخلوا أُغلق، فلم يدخل منه أحد." (البخاري ومسلم)
• يُغلق هذا الباب بعد دخول جميع الصائمين

3. **باب الجهاد**
• للذين شاركوا في الجهاد وجاهدوا في سبيل الله
• للذين استشهدوا (الشهداء)
• للذين جاهدوا ضد أنفسهم (النفس الأمارة)

4. **باب الصدقة**
• يُفتح للذين كانوا يتصدقون كثيراً
• للكرماء الذين أنفقوا في سبيل الله
• قال النبي ﷺ: "من أنفق زوجين في سبيل الله، نودي من أبواب الجنة" (البخاري)

5. **باب الحج**
• مخصص للذين أدوا فريضة الحج
• للذين حجوا بإخلاص
• خاصة للذين أدوا حجاً مبروراً

6. **باب الكاظمين الغيظ**
• للذين كظموا غيظهم
• للذين كانوا يعفون عن الآخرين
• للذين كبتوا الغضب وعفوا عن الناس
• المرجع القرآني: "والكاظمين الغيظ والعافين عن الناس والله يحب المحسنين" (3:134)

7. **باب الإيمان**
• للذين كان لديهم إيمان راسخ بالله
• للذين توكلوا على قرارات الله
• للذين عاشوا وفقاً لأوامر الله
• للمؤمنين الذين لم يشركوا بالله أبداً

8. **باب الذكر**
• للمؤمنين الذين ذكروا الله دائماً
• للذين انشغلوا بانتظام بالذكر
• للذين كانت ألسنتهم رطبة دائماً بذكر الله
• قال النبي ﷺ: "أهل الجنة يُنادون من جميع هذه الأبواب" (البخاري)

الدخول من أبواب متعددة:
عندما سأل أبو بكر الصديق (رضي الله عنه) النبي محمد ﷺ:
"هل يكون أحد يُدعى من جميع هذه الأبواب؟"
أجاب النبي ﷺ: "نعم. وأرجو أن تكون منهم يا أبا بكر."

هذا يُظهر أن أكثر المؤمنين صلاحاً قد ينالون شرف الدخول من أي باب يختارونه، لأنهم برعوا في جميع أنواع العبادة.

الوصف المادي للأبواب:
• مصنوعة من المعادن والجواهر الثمينة
• واسعة للغاية - المسافة بين القائمين تعادل رحلة 40 عاماً
• تحت حراسة الملائكة
• كل باب يؤدي إلى أقسام محددة من الجنة
• ستكون مفتوحة على مصراعيها للصالحين

من سيُدعى:
ستنادي الأبواب على أولئك الذين برعوا في أعمال عبادة محددة:
• الذين يصلون الصلوات الخمس → باب الصلاة
• الذين يصومون رمضان وأيام أخرى → باب الريان
• الذين يتصدقون بانتظام → باب الصدقة
• الذين أدوا الحج → باب الحج
• وهكذا لكل باب

الهدف النهائي:
• اسعَ لأن تُدعى من جميع الأبواب الثمانية مثل أبي بكر (رضي الله عنه)
• تفوق في جميع أنواع العبادة، وليس في واحدة فقط
• وازن بين أعمالك الصالحة
• اطلب رضا الله في كل عمل

الخطوات العملية:
1. حافظ على الصلوات الخمس كلها
2. صُم بانتظام (رمضان + صيام النوافل)
3. تصدق باستمرار
4. اكظم غيظك واعف عن الآخرين
5. اذكر الله كثيراً
6. اسعَ للحج إن استطعت
7. حافظ على إيمان قوي
8. جاهد ضد نفسك ورغباتها

"تلك أبواب الجنة المعدة للمؤمنين، فليسعوا للدخول من أكبر عدد منها بأعمالهم الصالحة."''',
      },
    },
    {
      'number': 8,
      'titleKey': 'jannat_fazilat_8_rivers_of_paradise',
      'title': 'Rivers and Springs of Paradise',
      'titleUrdu': 'جنت کی نہریں اور چشمے',
      'titleHindi': 'जन्नत की नहरें और चश्मे',
      'titleArabic': 'أنهار الجنة وعيونها',
      'icon': Icons.water,
      'color': Color(0xFF0288D1),
      'details': {
        'english': '''Rivers and Springs of Paradise

Paradise is filled with magnificent rivers and springs, as described in the Quran and authentic Hadith.

The Four Main Rivers of Paradise:
Allah says in the Quran (47:15):
"The description of Paradise which the righteous are promised: In it are rivers of water, the taste of which never changes; rivers of milk, the taste of which never changes; rivers of wine delicious to those who drink; and rivers of pure honey."

1. **Rivers of Fresh Water**
• Water that never becomes stale or changes taste
• Always fresh and pure
• Crystal clear and refreshing
• Free from all impurities

2. **Rivers of Pure Milk**
• Milk that never sours or changes
• Always fresh and delicious
• Whiter than snow
• More nourishing than any worldly milk

3. **Rivers of Wine (Khamr)**
• Wine that is delicious and pure
• Not intoxicating (unlike worldly wine)
• No headache, no loss of reason
• Pure enjoyment without harmful effects
• Allah says: "They will be given to drink pure wine sealed" (83:25)
• "A white wine, delicious to those who drink it, wherein there is neither intoxication nor will they suffer from headache" (37:46-47)

4. **Rivers of Purified Honey**
• Honey that is perfectly pure
• No impurities whatsoever
• Perfectly sweet and nourishing
• Never crystallizes or changes

Source of the Rivers:
Prophet Muhammad ﷺ said:
"Paradise has one hundred grades... The Throne is above Firdaus and from it spring forth the rivers of Paradise." (Tirmidhi)

The rivers of Paradise flow from beneath the Throne of Allah, originating in Firdaus Al-A'la (the highest Paradise), and then flow downward through the various levels of Paradise.

The River Al-Kawthar:
Prophet Muhammad ﷺ has been granted a special river called Al-Kawthar.

Description of Al-Kawthar:
• "We have granted you Al-Kawthar" (Quran 108:1)
• Prophet ﷺ said: "Al-Kawthar is a river in Paradise, its banks are of gold, and it flows over pearls and rubies. Its soil is more fragrant than musk, its water is whiter than milk and sweeter than honey."
• "Whoever drinks from it will never feel thirst again"
• The cups around it number as many as the stars in the sky

Width of Al-Kawthar:
• Prophet ﷺ said: "Its width is like the distance of a month's journey"
• Extremely vast and magnificent

Special Features:
• The Prophet's nation (Ummah) will drink from it on the Day of Judgment
• It will be the first thing the believers taste in Paradise
• Drinking from it removes all thirst forever

Other Named Springs and Rivers:

**Salsabil** (سلسبيل)
• Mentioned in Quran (76:18): "A spring there, called Salsabil"
• Extremely smooth and easy to swallow
• Mixed with other drinks for perfect taste
• The righteous will drink from it

**Tasnim** (تسنيم)
• Mentioned in Quran (83:27-28): "And its mixture is of Tasnim. A spring from which those near [to Allah] drink."
• The highest and purest spring in Paradise
• Reserved for the closest servants of Allah
• Those brought nearest to Allah will drink it pure
• Others will have it mixed with their drinks

**Ma'in** (معين)
• "Flowing springs" mentioned in multiple verses
• Visible, flowing water
• Available to all inhabitants

**Camphor Spring** (كافور)
• Quran (76:5): "The righteous drink from a cup mixed with camphor"
• Gives a refreshing, cooling sensation
• Perfect mixture for the believers

Earthly Rivers from Paradise:
Prophet Muhammad ﷺ said:
"Saihan, Jaihan, Euphrates (Furat), and Nile are all among the rivers of Paradise." (Sahih Muslim)

These four rivers on Earth have their origin from Paradise, showing the connection between this world and the Hereafter.

The River Al-Baydakh:
According to some narrations:
• There is a river called Al-Baydakh in Paradise
• Domes made of rubies are built over it
• The Hoor al-Ayn (maidens of Paradise) grow/emerge from beneath these domes

Characteristics of All Rivers in Paradise:

**1. Endless Supply**
• Never run dry
• Flow eternally
• Always abundant

**2. Perfect Temperature**
• Neither too cold nor too hot
• Perfectly pleasant

**3. Perfect Clarity**
• Can see the bottom clearly
• Transparent and pure

**4. No Impurities**
• Absolutely pure
• No contamination
• No harmful substances

**5. Beautiful Channels**
• Flow through gardens
• Surrounded by trees and fruits
• Banks made of precious materials

**6. Customizable**
• Flow where the inhabitants desire
• Can be directed by their will

**7. Healing Properties**
• Remove all ailments
• Grant eternal health
• Purify completely

How the Believers Will Enjoy These Rivers:

• Drink directly from them
• Bathe in them for pleasure
• Sail on them in boats
• Walk alongside them
• Recline near their banks
• The rivers will flow beneath their palaces and gardens

Quranic Descriptions:
• "Gardens beneath which rivers flow" - mentioned over 30 times in the Quran
• "They will have whatever they wish therein" (16:31)
• Rivers flowing at their command
• Different rivers for different levels and ranks

The Meaning Behind the Rivers:
These rivers represent:
• Allah's infinite generosity
• Pure, unending pleasure
• Perfect fulfillment of desires
• Reward for patience and faith in this world
• Eternal joy without any suffering

Practical Reflection:
When we feel thirst in this world, remember the rivers of Paradise and:
• Thank Allah for the water He provides us now
• Remember that all worldly pleasures are temporary
• Strive for the eternal rivers that never run dry
• Perform righteous deeds to earn them
• Share water with others (a great charity)

The Ultimate Promise:
Allah promises: "But as for those who believed and did righteous deeds, We will admit them to gardens beneath which rivers flow, wherein they abide forever" (4:57)

May Allah grant us all drinks from Al-Kawthar and allow us to enjoy the rivers of Paradise for eternity. Ameen.''',
        'urdu': '''جنت کی نہریں اور چشمے

جنت شاندار نہروں اور چشموں سے بھری ہوئی ہے، جیسا کہ قرآن اور صحیح احادیث میں بیان کیا گیا ہے۔

جنت کی چار اہم نہریں:
اللہ تعالیٰ قرآن میں فرماتا ہے (47:15):
"جنت کی صفت جس کا وعدہ پرہیزگاروں سے کیا گیا ہے: اس میں پانی کی نہریں ہیں جن کا ذائقہ کبھی نہیں بدلتا؛ دودھ کی نہریں ہیں جن کا ذائقہ کبھی نہیں بدلتا؛ شراب کی نہریں ہیں جو پینے والوں کے لیے لذیذ ہیں؛ اور خالص شہد کی نہریں ہیں۔"

1. **تازہ پانی کی نہریں**
• پانی جو کبھی باسی یا ذائقہ تبدیل نہیں ہوتا
• ہمیشہ تازہ اور صاف
• بالکل شفاف اور تازہ
• تمام نجاستوں سے پاک

2. **خالص دودھ کی نہریں**
• دودھ جو کبھی کھٹا یا تبدیل نہیں ہوتا
• ہمیشہ تازہ اور لذیذ
• برف سے زیادہ سفید
• دنیا کے کسی بھی دودھ سے زیادہ غذائیت بخش

3. **شراب کی نہریں (خمر)**
• شراب جو لذیذ اور خالص ہے
• نشہ آور نہیں (دنیاوی شراب کے برعکس)
• نہ سر درد، نہ عقل کا نقصان
• بغیر کسی نقصان دہ اثرات کے خالص لذت
• اللہ فرماتا ہے: "انہیں خالص شراب پلائی جائے گی جو مہر بند ہے" (83:25)
• "ایک سفید شراب، پینے والوں کے لیے لذیذ، جس میں نہ نشہ ہے اور نہ ہی سر درد ہوگا" (37:46-47)

4. **صاف شہد کی نہریں**
• شہد جو بالکل خالص ہے
• کوئی نجاست نہیں
• بالکل میٹھا اور غذائیت بخش
• کبھی جم یا تبدیل نہیں ہوتا

نہروں کا منبع:
نبی کریم ﷺ نے فرمایا:
"جنت کے ایک سو درجے ہیں... عرش فردوس کے اوپر ہے اور اس سے جنت کی نہریں پھوٹتی ہیں۔" (ترمذی)

جنت کی نہریں اللہ کے عرش کے نیچے سے بہتی ہیں، فردوس الاعلیٰ (سب سے اونچی جنت) میں نکلتی ہیں، اور پھر جنت کے مختلف درجوں میں نیچے کی طرف بہتی ہیں۔

نہر کوثر:
نبی کریم ﷺ کو ایک خاص نہر عطا کی گئی ہے جسے کوثر کہا جاتا ہے۔

کوثر کی تفصیل:
• "ہم نے آپ کو کوثر عطا کیا ہے" (قرآن 108:1)
• نبی کریم ﷺ نے فرمایا: "کوثر جنت میں ایک نہر ہے، اس کے کنارے سونے کے ہیں، اور یہ موتیوں اور یاقوتوں پر بہتی ہے۔ اس کی مٹی مشک سے زیادہ خوشبودار ہے، اس کا پانی دودھ سے زیادہ سفید اور شہد سے زیادہ میٹھا ہے۔"
• "جس نے اس سے پیا وہ پھر کبھی پیاسا نہیں ہوگا"
• اس کے اردگرد کے پیالوں کی تعداد آسمان کے ستاروں جتنی ہے

کوثر کی چوڑائی:
• نبی کریم ﷺ نے فرمایا: "اس کی چوڑائی ایک ماہ کے سفر کی مسافت کی طرح ہے"
• انتہائی وسیع اور شاندار

خاص خصوصیات:
• نبی کی امت قیامت کے دن اس سے پئے گی
• یہ پہلی چیز ہوگی جو مومنین جنت میں چکھیں گے
• اس سے پینے سے ہمیشہ کے لیے پیاس ختم ہو جاتی ہے

دیگر نامزد چشمے اور نہریں:

**سلسبیل**
• قرآن (76:18) میں مذکور: "ایک چشمہ، جسے سلسبیل کہا جاتا ہے"
• انتہائی ہموار اور نگلنے میں آسان
• کامل ذائقے کے لیے دوسرے مشروبات کے ساتھ ملایا جاتا ہے
• نیک لوگ اس سے پئیں گے

**تسنیم**
• قرآن (83:27-28) میں مذکور: "اور اس کی آمیزش تسنیم کی ہے۔ ایک چشمہ جس سے اللہ کے قریبی بندے پیتے ہیں۔"
• جنت میں سب سے اونچا اور خالص ترین چشمہ
• اللہ کے قریب ترین بندوں کے لیے مخصوص
• اللہ کے قریب ترین لوگ اسے خالص پئیں گے
• دوسرے لوگ اسے اپنے مشروبات کے ساتھ ملا کر پئیں گے

**معین**
• متعدد آیات میں "بہتے ہوئے چشمے" کا ذکر
• نظر آنے والا، بہتا ہوا پانی
• تمام باشندوں کے لیے دستیاب

**کافور کا چشمہ**
• قرآن (76:5): "نیک لوگ کافور ملے ہوئے پیالے سے پئیں گے"
• تازگی اور ٹھنڈک کا احساس دیتا ہے
• مومنین کے لیے کامل آمیزش

دنیا میں جنت کی نہریں:
نبی کریم ﷺ نے فرمایا:
"سیحان، جیحان، فرات اور نیل سب جنت کی نہروں میں سے ہیں۔" (صحیح مسلم)

زمین پر یہ چار نہریں جنت سے نکلی ہیں، جو اس دنیا اور آخرت کے درمیان تعلق کو ظاہر کرتا ہے۔

نہر بیضاء:
کچھ روایات کے مطابق:
• جنت میں بیضاء نامی ایک نہر ہے
• اس پر یاقوت کے گنبد بنے ہوئے ہیں
• حور العین ان گنبدوں کے نیچے سے نمودار ہوتی ہیں

جنت کی تمام نہروں کی خصوصیات:

**1. لامحدود سپلائی**
• کبھی خشک نہیں ہوتیں
• ہمیشہ کے لیے بہتی رہتی ہیں
• ہمیشہ کافی مقدار میں

**2. کامل درجہ حرارت**
• نہ بہت ٹھنڈا نہ بہت گرم
• بالکل خوشگوار

**3. کامل صفائی**
• نیچے تک صاف نظر آتا ہے
• شفاف اور خالص

**4. کوئی نجاست نہیں**
• بالکل خالص
• کوئی آلودگی نہیں
• کوئی نقصان دہ مادہ نہیں

**5. خوبصورت راستے**
• باغات میں سے بہتی ہیں
• درختوں اور پھلوں سے گھری ہوئی
• قیمتی مواد سے بنے کنارے

**6. حسب منشا**
• جہاں باشندے چاہیں بہتی ہیں
• ان کی مرضی سے رخ موڑ سکتے ہیں

**7. شفا بخش خصوصیات**
• تمام بیماریاں دور کرتی ہیں
• ہمیشہ کی صحت عطا کرتی ہیں
• مکمل طور پر پاک کرتی ہیں

مومنین ان نہروں سے کیسے لطف اندوز ہوں گے:

• براہ راست ان سے پئیں گے
• خوشی کے لیے ان میں نہائیں گے
• کشتیوں میں ان پر سفر کریں گے
• ان کے ساتھ ساتھ چلیں گے
• ان کے کناروں پر آرام کریں گے
• نہریں ان کے محلات اور باغات کے نیچے بہیں گی

قرآنی تفصیلات:
• "باغات جن کے نیچے نہریں بہتی ہیں" - قرآن میں 30 سے زیادہ بار ذکر
• "ان کے لیے وہاں جو چاہیں گے" (16:31)
• نہریں ان کے حکم سے بہتی ہیں
• مختلف درجات اور رتبوں کے لیے مختلف نہریں

نہروں کے پیچھے معنی:
یہ نہریں ظاہر کرتی ہیں:
• اللہ کی لامحدود سخاوت
• خالص، لامتناہی خوشی
• خواہشات کی کامل تکمیل
• اس دنیا میں صبر اور ایمان کا بدلہ
• بغیر کسی تکلیف کے ابدی خوشی

عملی غور و فکر:
جب ہم اس دنیا میں پیاس محسوس کریں، جنت کی نہروں کو یاد کریں اور:
• اللہ کا شکر ادا کریں جو ہمیں اب پانی فراہم کرتا ہے
• یاد رکھیں کہ تمام دنیاوی لذتیں عارضی ہیں
• ابدی نہروں کے لیے کوشش کریں جو کبھی خشک نہیں ہوتیں
• ان کو حاصل کرنے کے لیے نیک اعمال کریں
• دوسروں کے ساتھ پانی بانٹیں (ایک عظیم صدقہ)

حتمی وعدہ:
اللہ وعدہ کرتا ہے: "لیکن جو لوگ ایمان لائے اور نیک عمل کیے، ہم انہیں ایسے باغات میں داخل کریں گے جن کے نیچے نہریں بہتی ہیں، جہاں وہ ہمیشہ رہیں گے" (4:57)

اللہ ہم سب کو کوثر سے پانی عطا فرمائے اور ہمیں ہمیشہ کے لیے جنت کی نہروں سے لطف اندوز ہونے کی توفیق دے۔ آمین۔''',
        'hindi': '''जन्नत की नहरें और चश्मे

जन्नत शानदार नहरों और चश्मों से भरी हुई है, जैसा कि क़ुरआन और सहीह अहादीस में बयान किया गया है।

जन��नत की चार अहम नहरें:
अल्लाह तआला क़ुरआन में फ़रमाता है (47:15):
"जन्नत की सिफ़त जिसका वादा परहेज़गारों से किया गया है: इसमें पानी की नहरें हैं जिनका ज़ायक़ा कभी नहीं बदलता; दूध की नहरें हैं जिनका ज़ायक़ा कभी नहीं बदलता; शराब की नहरें हैं जो पीने वालों के लिए लज़ीज़ हैं; और ख़ालिस शहद की नहरें हैं।"

1. **ताज़ा पानी की नहरें**
• पानी जो कभी बासी या ज़ायक़ा तब्दील नहीं होता
• हमेशा ताज़ा और साफ़
• बिल्कुल शफ़्फ़ाफ़ और ताज़ा
• तमाम नजासतों से पाक

2. **ख़ालिस दूध की नहरें**
• दूध जो कभी खट्टा या तब्दील नहीं होता
• हमेशा ताज़ा और लज़ीज़
• बर्फ़ से ज़्यादा सफ़ेद
• दुनिया के किसी भी दूध से ज़्यादा ग़िज़ाइयत बख़्श

3. **शराब की नहरें (ख़म्र)**
• शराब जो लज़ीज़ और ख़ालिस है
• नशा आवर नहीं (दुनियावी शराब के बरअक्स)
• न सर दर्द, न अक़्ल का नुक़्सान
• बग़ैर किसी नुक़्सानदेह असरात के ख़ालिस लज़्ज़त
• अल्लाह फ़रमाता है: "उन्हें ख़ालिस शराब पिलाई जाएगी जो मोहर बंद है" (83:25)
• "एक सफ़ेद शराब, पीने वालों के लिए लज़ीज़, जिसमें न नशा है और न ही सर दर्द होगा" (37:46-47)

4. **साफ़ शहद की नहरें**
• शहद जो बिल्कुल ख़ालिस है
• कोई नजासत नहीं
• बिल्कुल मीठा और ग़िज़ाइयत बख़्श
• कभी जम या तब्दील नहीं होता

नहरों का मंबअ:
नबी करीम ﷺ ने फ़रमाया:
"जन्नत के एक सौ दर्जे हैं... अर्श फ़िरदौस के ऊपर है और उससे जन्नत की नहरें फूटती हैं।" (तिरमिज़ी)

जन्नत की नहरें अल्लाह के अर्श के नीचे से बहती हैं, फ़िरदौस अल-आला (सबसे ऊंची जन्नत) में निकलती हैं, और फिर जन्नत के मुख़्तलिफ़ दर्जों में नीचे की तरफ़ बहती हैं।

नहर कौसर:
नबी करीम ﷺ को एक ख़ास नहर अता की गई है जिसे कौसर कहा जाता है।

कौसर की तफ़सील:
• "हमने आपको कौसर अता किया है" (क़ुरआन 108:1)
• नबी करीम ﷺ ने फ़रमाया: "कौसर जन्नत में एक नहर है, इसके किनारे सोने के हैं, और यह मोतियों और याक़ूतों पर बहती है। इसकी मिट्टी मुश्क से ज़्यादा ख़ुशबूदार है, इसका पानी दूध से ज़्यादा सफ़ेद और शहद से ज़्यादा मीठा है।"
• "जिसने इससे पिया वो फिर कभी प्यासा नहीं होगा"
• इसके इर्दगिर्द के प्यालों की तादाद आसमान के सितारों जितनी है

कौसर की चौड़ाई:
• नबी करीम ﷺ ने फ़रमाया: "इसकी चौड़ाई एक माह के सफ़र की मसाफ़त की तरह है"
• इंतिहाई वसी' और शानदार

ख़ास ख़ुसूसियात:
• नबी की उम्मत क़यामत के दिन इससे पिएगी
• यह पहली चीज़ होगी जो मोमिनीन जन्नत में चखेंगे
• इससे पीने से हमेशा के लिए प्यास ख़त्म हो जाती है

दीगर नामज़द चश्मे और नहरें:

**सलसबील**
• क़ुरआन (76:18) में मज़कूर: "एक चश्मा, जिसे सलसबील कहा जाता है"
• इंतिहाई हमवार और निगलने में आसान
• कामिल ज़ायक़े के लिए दूसरे मशरूबात के साथ मिलाया जाता है
• नेक लोग इससे पिएंगे

**तस्नीम**
• क़ुरआन (83:27-28) में मज़कूर: "और इसकी आमेज़िश तस्नीम की है। एक चश्मा जिससे अल्लाह के क़रीबी बंदे पीते हैं।"
• जन्नत में सबसे ऊंचा और ख़ालिस तरीन चश्मा
• अल्लाह के क़रीब तरीन बंदों के लिए मख़्सूस
• अल्लाह के क़रीब तरीन लोग इसे ख़ालिस पिएंगे
• दूसरे लोग इसे अपने मशरूबात के साथ मिलाकर पिएंगे

**माईन**
• मुतअद्दिद आयात में "बहते हुए चश्मे" का ज़िक्र
• नज़र आने वाला, बहता हुआ पानी
• तमाम बाशिंदों के लिए दस्तयाब

**काफ़ूर का चश्मा**
• क़ुरआन (76:5): "नेक लोग काफ़ूर मिले हुए प्याले से पिएंगे"
• ताज़गी और ठंडक का एहसास देता है
• मोमिनीन के लिए कामिल आमेज़िश

दुनिया में जन्नत की नहरें:
नबी करीम ﷺ ने फ़रमाया:
"सैहान, जैहान, फ़ुरात और नील सब जन्नत की नहरों में से हैं।" (सहीह मुस्लिम)

ज़मीन पर ये चार नहरें जन्नत से निकली हैं, जो इस दुनिया और आख़िरत के दरमियान ताल्लुक़ को ज़ाहिर करता है।

नहर बैज़ा:
कुछ रिवायात के मुताबिक़:
• जन्नत में बैज़ा नामी एक नहर है
• इस पर याक़ूत के ��ुंबद बने हुए हैं
• हूर अल-ऐन इन गुंबदों के नीचे से नुमूदार होती हैं

जन्नत की तमाम नहरों की ख़ुसूसियात:

**1. लामहदूद सप्लाई**
• कभी ख़ुश्क नहीं होतीं
• हमेशा के लिए बहती रहती हैं
• हमेशा काफ़ी मिक़्दार में

**2. कामिल दर्जा हरारत**
• न बहुत ठंडा न बहुत गर्म
• बिल्कुल ख़ुशगवार

**3. कामिल सफ़ाई**
• नीचे तक साफ़ नज़र आता है
• शफ़्फ़ाफ़ और ख़ालिस

**4. कोई नजासत नहीं**
• बिल्कुल ख़ालिस
• कोई आलूदगी नहीं
• कोई नुक़्सानदेह माद्दा नहीं

**5. ख़ूबसूरत रास्ते**
• बाग़ात में से बहती हैं
• दरख़्तों और फलों से घिरी हुई
• क़ीमती मवाद से बने किनारे

**6. हसबे मंशा**
• जहां बाशिंदे चाहें बहती हैं
• उनकी मर्ज़ी से रुख़ मोड़ सकते हैं

**7. शिफ़ा बख़्श ख़ुसूसियात**
• तमाम बीमारियां दूर करती हैं
• हमेशा की सेहत अता करती हैं
• मुकम्मल तौर पर पाक करती हैं

मोमिनीन इन नहरों से कैसे लुत्फ़ अंदोज़ होंगे:

• बराहेरास्त इनसे पिएंगे
• ख़ुशी के लिए इनमें नहाएंगे
• कश्तियों में इन पर सफ़र करेंगे
• इनके साथ साथ चलेंगे
• इनके किनारों पर आराम करेंगे
• नहरें उनके महलात और बाग़ात के नीचे बहेंगी

क़ुरआनी तफ़सीलात:
• "बाग़ात जिनके नीचे नहरें बहती हैं" - क़ुरआन में 30 से ज़्यादा बार ज़िक्र
• "उनके लिए वहां जो चाहेंगे" (16:31)
• नहरें उनके हुक्म से बहती हैं
• मुख़्तलिफ़ दर्जात और रुतबों के लिए मुख़्तलिफ़ नहरें

नहरों के पीछे मअनी:
यह नहरें ज़ाहिर करती हैं:
• अल्लाह की लामहदूद सख़ावत
• ख़ालिस, लामुतनाही ख़ुशी
• ख़्वाहिशात की कामिल तकमील
• इस दुनिया में सब्र और ईमान का बदला
• बग़ैर किसी तकलीफ़ के अबदी ख़ुशी

अमली ग़ौर व फ़िक्र:
जब हम इस दुनिया में प्यास महसूस करें, जन्नत की नहरों को याद करें और:
• अल्लाह का शुक्र अदा करें जो हमें अब पानी फ़राहम करता है
• याद रखें कि तमाम दुनियावी लज़्ज़तें आरिज़ी हैं
• अबदी नहरों के लिए कोशिश करें जो कभी ख़ुश्क नहीं होतीं
• उनको हासिल करने के लिए नेक आमाल करें
• दूसरों के साथ पानी बांटें (एक अज़ीम सदक़ा)

हतमी वादा:
अल्लाह वादा करता है: "लेकिन जो लोग ईमान लाए और नेक अमल किए, हम उन्हें ऐसे बाग़ात में दाख़िल करेंगे जिनके नीचे नहरें बहती हैं, जहां वो हमेशा रहेंगे" (4:57)

अल्लाह हम सबको कौसर से पानी अता फ़रमाए और हमें हमेशा के लिए जन्नत की नहरों से लुत्फ़ अंदोज़ होने की तौफ़ीक़ दे। आमीन।''',
        'arabic': '''أنهار الجنة وعيونها

الجنة مليئة بالأنهار والعيون الرائعة، كما ورد في القرآن والحديث الصحيح.

الأنهار الأربعة الرئيسية في الجنة:
يقول الله في القرآن (47:15):
"مَثَلُ الْجَنَّةِ الَّتِي وُعِدَ الْمُتَّقُونَ فِيهَا أَنْهَارٌ مِّن مَّاءٍ غَيْرِ آسِنٍ وَأَنْهَارٌ مِّن لَّبَنٍ لَّمْ يَتَغَيَّرْ طَعْمُهُ وَأَنْهَارٌ مِّنْ خَمْرٍ لَّذَّةٍ لِّلشَّارِبِينَ وَأَنْهَارٌ مِّنْ عَسَلٍ مُّصَفًّى"

1. **أنهار الماء العذب**
• ماء لا يتغير طعمه أبداً
• دائماً عذب ونقي
• صافٍ كالبلور ومنعش
• خالٍ من جميع الشوائب

2. **أنهار اللبن النقي**
• لبن لا يتحمض أو يتغير أبداً
• دائماً طازج ولذيذ
• أبيض من الثلج
• أكثر تغذية من أي لبن دنيوي

3. **أنهار الخمر**
• خمر لذيذ ونقي
• غير مسكر (خلافاً للخمر الدنيوي)
• لا صداع، لا فقدان للعقل
• متعة خالصة بدون آثار ضارة
• يقول الله: "يُسْقَوْنَ مِن رَّحِيقٍ مَّخْتُومٍ" (83:25)
• "بَيْضَاءَ لَذَّةٍ لِّلشَّارِبِينَ * لَا فِيهَا غَوْلٌ وَلَا هُمْ عَنْهَا يُنزَفُونَ" (37:46-47)

4. **أنهار العسل المصفى**
• عسل نقي تماماً
• لا شوائب فيه على الإطلاق
• حلو ومغذٍ تماماً
• لا يتبلور أو يتغير أبداً

مصدر الأنهار:
قال النبي ﷺ:
"الجنة مائة درجة... والعرش فوق الفردوس ومنه تتفجر أنهار الجنة." (الترمذي)

أنهار الجنة تنبع من تحت عرش الله، وتبدأ في الفردوس الأعلى (أعلى الجنة)، ثم تتدفق نزولاً عبر مستويات الجنة المختلفة.

نهر الكوثر:
أُعطي النبي محمد ﷺ نهراً خاصاً يُسمى الكوثر.

وصف الكوثر:
• "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ" (القرآن 108:1)
• قال النبي ﷺ: "الكوثر نهر في الجنة، حافتاه من ذهب، ومجراه على الدر والياقوت، تربته أطيب من المسك، وماؤه أبيض من اللبن، وأحلى من العسل."
• "من شرب منه لم يظمأ بعده أبداً"
• الأكواب حوله بعدد نجوم السماء

عرض الكوثر:
• قال النبي ﷺ: "عرضه مسيرة شهر"
• واسع جداً وعظيم

مميزات خاصة:
• أمة النبي ستشرب منه يوم القيامة
• سيكون أول ما يتذوقه المؤمنون في الجنة
• الشرب منه يزيل العطش إلى الأبد

عيون وأنهار أخرى مسماة:

**سلسبيل**
• مذكور في القرآن (76:18): "عَيْناً فِيهَا تُسَمَّى سَلْسَبِيلاً"
• سلس جداً وسهل البلع
• يُمزج بمشروبات أخرى للطعم المثالي
• الصالحون سيشربون منه

**تسنيم**
• مذكور في القرآن (83:27-28): "وَمِزَاجُهُ مِن تَسْنِيمٍ * عَيْناً يَشْرَبُ بِهَا الْمُقَرَّبُونَ"
• أعلى وأنقى عين في الجنة
• مخصصة لأقرب عباد الله
• الأقربون إلى الله سيشربونه نقياً
• الآخرون سيُمزج بمشروباتهم

**معين**
• "عيون جارية" مذكورة في آيات متعددة
• ماء مرئي جارٍ
• متاح لجميع السكان

**عين الكافور**
• القرآن (76:5): "إِنَّ الْأَبْرَارَ يَشْرَبُونَ مِن كَأْسٍ كَانَ مِزَاجُهَا كَافُوراً"
• يعطي إحساساً منعشاً ومبرداً
• مزيج مثالي للمؤمنين

أنهار أرضية من الجنة:
قال النبي محمد ﷺ:
"سيحان وجيحان والفرات والنيل كل من أنهار الجنة." (صحيح مسلم)

هذه الأنهار الأربعة على الأرض لها أصلها من الجنة، مما يُظهر الارتباط بين هذا العالم والآخرة.

نهر البيضاء:
حسب بعض الروايات:
• يوجد نهر يُسمى البيضاء في الجنة
• قباب من الياقوت مبنية فوقه
• الحور العين ينشأن من تحت هذه القباب

خصائص جميع أنهار الجنة:

**1. إمداد لا نهائي**
• لا تجف أبداً
• تجري إلى الأبد
• دائماً وفيرة

**2. درجة حرارة مثالية**
• لا باردة جداً ولا حارة جداً
• لطيفة تماماً

**3. صفاء مثالي**
• يمكن رؤية القاع بوضوح
• شفافة ونقية

**4. لا شوائب**
• نقية تماماً
• لا تلوث
• لا مواد ضارة

**5. مجاري جميلة**
• تجري عبر الجنان
• محاطة بالأشجار والثمار
• ضفاف من مواد ثمينة

**6. قابلة للتخصيص**
• تجري حيث يريد السكان
• يمكن توجيهها بإرادتهم

**7. خصائص شفائية**
• تزيل جميع الأمراض
• تمنح صحة أبدية
• تطهر تماماً

كيف سيستمتع المؤمنون بهذه الأنهار:

• يشربون منها مباشرة
• يستحمون فيها للمتعة
• يبحرون عليها في القوارب
• يمشون بجانبها
• يتكئون بالقرب من ضفافها
• ستجري الأنهار تحت قصورهم وجناتهم

الأوصاف القرآنية:
• "جَنَّاتٍ تَجْرِي مِن تَحْتِهَا الْأَنْهَارُ" - مذكورة أكثر من 30 مرة في القرآن
• "لَهُم مَّا يَشَاءُونَ فِيهَا" (16:31)
• أنهار تجري بأمرهم
• أنهار مختلفة لمستويات ودرجات مختلفة

المعنى وراء الأنهار:
تمثل هذه الأنهار:
• كرم الله اللامحدود
• متعة نقية لا نهائية
• إرضاء كامل للرغبات
• جزاء الصبر والإيمان في هذا العالم
• فرح أبدي بدون أي معاناة

تأمل عملي:
عندما نشعر بالعطش في هذا العالم، نتذكر أنهار الجنة و:
• نشكر الله على الماء الذي يوفره لنا الآن
• نتذكر أن جميع الملذات الدنيوية مؤقتة
• نسعى للأنهار الأبدية التي لا تجف أبداً
• نؤدي الأعمال الصالحة لكسبها
• نشارك الماء مع الآخرين (صدقة عظيمة)

الوعد النهائي:
يَعِد الله: "وَالَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ سَنُدْخِلُهُمْ جَنَّاتٍ تَجْرِي مِن تَحْتِهَا الْأَنْهَارُ خَالِدِينَ فِيهَا أَبَداً" (4:57)

اللهم ارزقنا جميعاً الشرب من الكوثر وامنحنا التمتع بأنهار الجنة إلى الأبد. آمين.''',
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
                  itemCount: _jannatTopics.length,
                  itemBuilder: (context, index) {
                    final topic = _jannatTopics[index];
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
    final title = context.tr(topic['titleKey'] ?? 'jannat_fazilat');
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    final isRTL = (langCode == 'ur' || langCode == 'ar');

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
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showTopicDetails(topic),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                      offset: const Offset(0, 2.0),
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
                  crossAxisAlignment: isRTL
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
                        height: 1.3,
                      ),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      textDirection: isRTL
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    responsive.vSpaceXSmall,
                    // Icon chip
                    Directionality(
                      textDirection: isRTL
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Container(
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
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                topic['icon'] as IconData,
                                size: responsive.textXSmall + 2,
                                color: emeraldGreen,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  context.tr('jannat_fazilat'),
                                  style: TextStyle(
                                    fontSize: responsive.textXSmall,
                                    fontWeight: FontWeight.w600,
                                    color: emeraldGreen,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              responsive.hSpaceXSmall,

              // Arrow Icon
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E8F5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
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
          categoryKey: 'category_jannat_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
