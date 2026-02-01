import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'islamic_name_detail_screen.dart';

class NabiNamesScreen extends StatefulWidget {
  const NabiNamesScreen({super.key});

  @override
  State<NabiNamesScreen> createState() => _NabiNamesScreenState();
}

class _NabiNamesScreenState extends State<NabiNamesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredNames = [];

  final List<Map<String, dynamic>> _nabiNames = [
    {
      'name': 'آدم',
      'transliteration': 'Adam',
      'meaning': 'Father of Mankind',
      'meaningUrdu': 'ابو البشر',
      'meaningHindi': 'मानवजाति के पिता',
      'description':
          'Prophet Adam (AS) was the first human being created by Allah from clay. He was also the first Prophet sent to guide humanity. Allah taught him the names of all things and honored him by commanding the angels to prostrate before him. He lived in Jannah with his wife Hawwa (Eve) before descending to Earth.',
      'descriptionUrdu':
          'حضرت آدم علیہ السلام اللہ تعالیٰ کے پیدا کردہ پہلے انسان تھے جنہیں مٹی سے بنایا گیا۔ وہ انسانیت کی رہنمائی کے لیے بھیجے گئے پہلے نبی بھی تھے۔ اللہ تعالیٰ نے انہیں تمام چیزوں کے نام سکھائے اور فرشتوں کو ان کے سامنے سجدہ کرنے کا حکم دے کر انہیں عزت بخشی۔ وہ زمین پر اترنے سے پہلے اپنی بیوی حضرت حوا کے ساتھ جنت میں رہے۔',
      'descriptionHindi':
          'हज़रत आदम (अ.स.) अल्लाह द्वारा मिट्टी से बनाए गए पहले इंसान थे। वे मानवता का मार्गदर्शन करने के लिए भेजे गए पहले नबी भी थे। अल्लाह ने उन्हें सभी चीज़ों के नाम सिखाए और फ़रिश्तों को उनके सामने सजदा करने का हुक्म देकर उन्हें सम्मानित किया। वे ज़मीन पर आने से पहले अपनी पत्नी हव्वा के साथ जन्नत में रहे।',
      'birthPlace': 'Created in Paradise (Jannah)',
      'deathPlace': 'Earth (location varies in traditions)',
      'spouse': 'Hawwa (Eve)',
      'children': 'Qabil (Cain), Habil (Abel), Shith (Seth), and many others',
      'era': 'Beginning of Humanity',
      'knownFor': 'First human, First Prophet, Father of Mankind',
    },
    {
      'name': 'إدريس',
      'transliteration': 'Idris',
      'meaning': 'The one who studies',
      'meaningUrdu': 'پڑھنے والا',
      'meaningHindi': 'अध्ययन करने वाला',
      'description':
          'Prophet Idris (AS) was known for his wisdom and knowledge. He was the first to write with a pen and was given 30 scriptures. He was raised to a high station by Allah and is mentioned in the Quran as a truthful prophet. He taught people the basics of civilization and sciences.',
      'descriptionUrdu':
          'حضرت ادریس علیہ السلام اپنی حکمت اور علم کے لیے مشہور تھے۔ وہ پہلے شخص تھے جنہوں نے قلم سے لکھا اور انہیں 30 صحیفے دیے گئے۔ اللہ تعالیٰ نے انہیں بلند مقام پر اٹھایا اور قرآن میں انہیں سچے نبی کے طور پر ذکر کیا گیا ہے۔ انہوں نے لوگوں کو تہذیب اور علوم کی بنیادی باتیں سکھائیں۔',
      'descriptionHindi':
          'हज़रत इदरीस (अ.स.) अपनी हिकमत और ज्ञान के लिए प्रसिद्ध थे। वे पहले व्यक्ति थे जिन्होंने कलम से लिखा और उन्हें 30 सहीफे दिए गए। अल्लाह ने उन्हें ऊंचे मक़ाम पर उठाया और क़ुरान में उन्हें सच्चे नबी के रूप में ज़िक्र किया गया है। उन्होंने लोगों को सभ्यता और विज्ञान की बुनियादी बातें सिखाईं।',
      'fatherName': 'Yarid (Jared)',
      'birthPlace': 'Babylon, Mesopotamia',
      'deathPlace': 'Raised to the heavens',
      'era': 'After Adam, before Nuh',
      'knownFor':
          'First to write with pen, Received 30 scriptures, Raised to high station',
    },
    {
      'name': 'نوح',
      'transliteration': 'Nuh (Noah)',
      'meaning': 'Comfort, Rest',
      'meaningUrdu': 'آرام، سکون',
      'meaningHindi': 'आराम, शांति',
      'description':
          'Prophet Nuh (AS) is known as one of the five greatest prophets (Ulul Azm). He preached to his people for 950 years. When they rejected his message, Allah commanded him to build an ark. He survived the great flood with believers and pairs of every animal species. He is called the second father of humanity.',
      'descriptionUrdu':
          'حضرت نوح علیہ السلام پانچ عظیم ترین انبیاء (اولوالعزم) میں سے ایک ہیں۔ انہوں نے 950 سال تک اپنی قوم کو تبلیغ کی۔ جب انہوں نے ان کے پیغام کو رد کیا تو اللہ تعالیٰ نے انہیں کشتی بنانے کا حکم دیا۔ وہ مومنین اور ہر جانور کے جوڑے کے ساتھ عظیم طوفان سے بچ گئے۔ انہیں انسانیت کا دوسرا باپ کہا جاتا ہے۔',
      'descriptionHindi':
          'हज़रत नूह (अ.स.) पांच महान नबियों (उलुल अज़्म) में से एक हैं। उन्होंने 950 साल तक अपनी क़ौम को तब्लीग़ की। जब उन्होंने उनके पैग़ाम को रद्द किया तो अल्लाह ने उन्हें कश्ती बनाने का हुक्म दिया। वे मोमिनों और हर जानवर की जोड़ी के साथ महान तूफ़ान से बच गए। उन्हें इंसानियत का दूसरा बाप कहा जाता है।',
      'fatherName': 'Lamech',
      'birthPlace': 'Mesopotamia',
      'spouse': 'Naamah (traditions vary)',
      'children': 'Shem, Ham, Japheth, Yam (drowned)',
      'era': 'Preached for 950 years',
      'knownFor': 'Ulul Azm Prophet, Built the Ark, Second Father of Humanity',
    },
    {
      'name': 'هود',
      'transliteration': 'Hud',
      'meaning': 'The Guide',
      'meaningUrdu': 'ہدایت دینے والا',
      'meaningHindi': 'मार्गदर्शक',
      'description':
          'Prophet Hud (AS) was sent to the people of Ad who lived in the Ahqaf region of Arabia. They were powerful and built great structures but were arrogant. When they rejected his message, Allah destroyed them with a violent windstorm that lasted seven nights and eight days.',
      'descriptionUrdu':
          'حضرت ہود علیہ السلام قوم عاد کی طرف بھیجے گئے جو عرب کے علاقے احقاف میں رہتے تھے۔ وہ طاقتور تھے اور عظیم عمارتیں بناتے تھے لیکن متکبر تھے۔ جب انہوں نے ان کے پیغام کو رد کیا تو اللہ تعالیٰ نے انہیں سات راتوں اور آٹھ دنوں تک چلنے والے شدید طوفان سے تباہ کر دیا۔',
      'descriptionHindi':
          'हज़रत हूद (अ.स.) क़ौम-ए-आद की तरफ़ भेजे गए जो अरब के इलाक़े अहक़ाफ़ में रहते थे। वे ताक़तवर थे और बड़ी इमारतें बनाते थे लेकिन घमंडी थे। जब उन्होंने उनके पैग़ाम को रद्द किया तो अल्लाह ने उन्हें सात रातों और आठ दिनों तक चलने वाले शदीद तूफ़ान से तबाह कर दिया।',
      'birthPlace': 'Ahqaf region, Southern Arabia',
      'deathPlace': 'Hadramawt, Yemen (traditional)',
      'tribe': 'Descendant of Prophet Nuh through Shem',
      'era': 'After Nuh, sent to People of Ad',
      'knownFor': 'Sent to People of Ad, Warned against arrogance',
    },
    {
      'name': 'صالح',
      'transliteration': 'Salih',
      'meaning': 'Righteous',
      'meaningUrdu': 'نیک',
      'meaningHindi': 'नेक',
      'description':
          'Prophet Salih (AS) was sent to the people of Thamud who carved homes out of mountains. Allah gave him the miracle of a she-camel that emerged from a rock. When his people killed the camel despite warnings, they were destroyed by a mighty blast (earthquake and thunderbolt).',
      'descriptionUrdu':
          'حضرت صالح علیہ السلام قوم ثمود کی طرف بھیجے گئے جو پہاڑوں میں گھر تراشتے تھے۔ اللہ تعالیٰ نے انہیں ایک اونٹنی کا معجزہ دیا جو چٹان سے نکلی۔ جب ان کی قوم نے وارننگ کے باوجود اونٹنی کو مار ڈالا تو وہ ایک زبردست دھماکے (زلزلے اور بجلی) سے تباہ ہو گئے۔',
      'descriptionHindi':
          'हज़रत सालेह (अ.स.) क़ौम-ए-समूद की तरफ़ भेजे गए जो पहाड़ों में घर तराशते थे। अल्लाह ने उन्हें एक ऊंटनी का मोजज़ा दिया जो चट्टान से निकली। जब उनकी क़ौम ने चेतावनी के बावजूद ऊंटनी को मार डाला तो वे एक ज़बरदस्त धमाके (भूकंप और बिजली) से तबाह हो गए।',
      'birthPlace': 'Hijr (Mada\'in Salih), Arabia',
      'deathPlace': 'Palestine or Makkah (traditions vary)',
      'tribe': 'Thamud',
      'era': 'After Hud, sent to People of Thamud',
      'knownFor': 'Miracle of the She-Camel, Sent to Thamud',
    },
    {
      'name': 'إبراهيم',
      'transliteration': 'Ibrahim (Abraham)',
      'meaning': 'Father of Nations',
      'meaningUrdu': 'قوموں کے باپ',
      'meaningHindi': 'क़ौमों के पिता',
      'description':
          'Prophet Ibrahim (AS) is called Khalilullah (Friend of Allah) and is one of the five greatest prophets. He broke the idols of his people, was thrown into fire but Allah made it cool for him. He built the Kaaba with his son Ismail. He is the father of both the Arab and Jewish nations through his sons.',
      'descriptionUrdu':
          'حضرت ابراہیم علیہ السلام کو خلیل اللہ (اللہ کا دوست) کہا جاتا ہے اور وہ پانچ عظیم ترین انبیاء میں سے ایک ہیں۔ انہوں نے اپنی قوم کے بتوں کو توڑا، انہیں آگ میں پھینکا گیا لیکن اللہ نے آگ کو ان کے لیے ٹھنڈا کر دیا۔ انہوں نے اپنے بیٹے اسماعیل کے ساتھ کعبہ تعمیر کیا۔ وہ اپنے بیٹوں کے ذریعے عرب اور یہودی دونوں قوموں کے باپ ہیں۔',
      'descriptionHindi':
          'हज़रत इब्राहीम (अ.स.) को ख़लीलुल्लाह (अल्लाह के दोस्त) कहा जाता है और वे पांच महान नबियों में से एक हैं। उन्होंने अपनी क़ौम के बुतों को तोड़ा, उन्हें आग में फेंका गया लेकिन अल्लाह ने आग को उनके लिए ठंडा कर दिया। उन्होंने अपने बेटे इस्माईल के साथ काबा बनाया। वे अपने बेटों के ज़रिए अरब और यहूदी दोनों क़ौमों के पिता हैं।',
      'fatherName': 'Azar (Terah)',
      'birthPlace': 'Ur, Mesopotamia (modern Iraq)',
      'deathPlace': 'Hebron, Palestine',
      'spouse': 'Sarah, Hajar (Hagar)',
      'children': 'Ismail (from Hajar), Ishaq (from Sarah)',
      'era': 'Approximately 1800 BCE',
      'knownFor': 'Khalilullah, Built the Kaaba, Ulul Azm Prophet',
    },
    {
      'name': 'لوط',
      'transliteration': 'Lut (Lot)',
      'meaning': 'Veiled, Hidden',
      'meaningUrdu': 'پوشیدہ',
      'meaningHindi': 'छुपा हुआ',
      'description':
          'Prophet Lut (AS) was the nephew of Prophet Ibrahim. He was sent to the people of Sodom and Gomorrah who practiced immoral acts. Despite his warnings, they refused to repent. Allah destroyed their cities by turning them upside down and raining stones upon them.',
      'descriptionUrdu':
          'حضرت لوط علیہ السلام حضرت ابراہیم کے بھتیجے تھے۔ انہیں سدوم اور عمورہ کے لوگوں کی طرف بھیجا گیا جو غیر اخلاقی کام کرتے تھے۔ ان کی تنبیہات کے باوجود انہوں نے توبہ کرنے سے انکار کیا۔ اللہ تعالیٰ نے ان کے شہروں کو الٹ کر اور ان پر پتھر برسا کر تباہ کر دیا۔',
      'descriptionHindi':
          'हज़रत लूत (अ.स.) हज़रत इब्राहीम के भतीजे थे। उन्हें सदोम और अमूराह के लोगों की तरफ़ भेजा गया जो ग़ैर-अख़लाक़ी काम करते थे। उनकी चेतावनियों के बावजूद उन्होंने तौबा करने से इनकार किया। अल्लाह ने उनके शहरों को उलट कर और उन पर पत्थर बरसा कर तबाह कर दिया।',
      'fatherName': 'Haran (brother of Ibrahim)',
      'birthPlace': 'Ur, Mesopotamia',
      'deathPlace': 'Near the Dead Sea region',
      'children': 'Two daughters (who survived)',
      'era': 'Contemporary of Ibrahim',
      'knownFor': 'Sent to Sodom and Gomorrah, Warned against immorality',
    },
    {
      'name': 'إسماعيل',
      'transliteration': 'Ismail (Ishmael)',
      'meaning': 'God Hears',
      'meaningUrdu': 'اللہ سنتا ہے',
      'meaningHindi': 'अल्लाह सुनता है',
      'description':
          'Prophet Ismail (AS) was the first son of Ibrahim from Hajar. As a baby, he was left in the desert of Makkah where the well of Zamzam sprang forth. He helped his father build the Kaaba. He willingly submitted when Allah commanded Ibrahim to sacrifice him, but was ransomed with a ram. He is the ancestor of Prophet Muhammad ﷺ.',
      'descriptionUrdu':
          'حضرت اسماعیل علیہ السلام حضرت ابراہیم کے حاجرہ سے پہلے بیٹے تھے۔ بچپن میں انہیں مکہ کے صحرا میں چھوڑ دیا گیا جہاں زمزم کا کنواں پھوٹ پڑا۔ انہوں نے اپنے والد کی کعبہ بنانے میں مدد کی۔ جب اللہ نے ابراہیم کو ان کی قربانی کا حکم دیا تو انہوں نے خوشی سے قبول کیا، لیکن انہیں ایک مینڈھے سے بدل دیا گیا۔ وہ نبی محمد ﷺ کے جد امجد ہیں۔',
      'descriptionHindi':
          'हज़रत इस्माईल (अ.स.) हज़रत इब्राहीम के हाजरा से पहले बेटे थे। बचपन में उन्हें मक्का के रेगिस्तान में छोड़ दिया गया जहां ज़मज़म का कुआं फूट पड़ा। उन्होंने अपने वालिद की काबा बनाने में मदद की। जब अल्लाह ने इब्राहीम को उनकी क़ुर्बानी का हुक्म दिया तो उन्होंने ख़ुशी से क़बूल किया, लेकिन उन्हें एक मेंढे से बदल दिया गया। वे नबी मुहम्मद ﷺ के पूर्वज हैं।',
      'fatherName': 'Ibrahim',
      'motherName': 'Hajar (Hagar)',
      'birthPlace': 'Canaan (Palestine)',
      'deathPlace': 'Makkah, Arabia',
      'spouse': 'Ra\'la (or others in traditions)',
      'children': '12 sons including Kedar, Nebaioth',
      'era': 'Son of Ibrahim',
      'knownFor':
          'Built Kaaba, Ancestor of Prophet Muhammad ﷺ, Willingly submitted to sacrifice',
    },
    {
      'name': 'إسحاق',
      'transliteration': 'Ishaq (Isaac)',
      'meaning': 'He Laughs',
      'meaningUrdu': 'ہنسنے والا',
      'meaningHindi': 'हंसने वाला',
      'description':
          'Prophet Ishaq (AS) was the second son of Ibrahim, born to Sarah in her old age. His birth was announced by angels. He continued his father\'s mission of calling people to worship Allah alone. He is the father of Prophet Yaqub and the ancestor of many prophets of Bani Israel.',
      'descriptionUrdu':
          'حضرت اسحاق علیہ السلام حضرت ابراہیم کے دوسرے بیٹے تھے، جو بڑھاپے میں سارہ سے پیدا ہوئے۔ ان کی پیدائش کا اعلان فرشتوں نے کیا۔ انہوں نے اپنے والد کی دعوت جاری رکھی کہ ل��گ صرف اللہ کی عبادت کریں۔ وہ حضرت یعقوب کے والد اور بنی اسرائیل کے بہت سے انبیاء کے جد امجد ہیں۔',
      'descriptionHindi':
          'हज़रत इसहाक़ (अ.स.) हज़रत इब्राहीम के दूसरे बेटे थे, जो बुढ़ापे में सारा से पैदा हुए। उनकी पैदाइश का एलान फ़रिश्तों ने किया। उन्होंने अपने वालिद की दावत जारी रखी कि लोग सिर्फ़ अल्लाह की इबादत करें। वे हज़रत याक़ूब के वालिद और बनी इसराईल के बहुत से नबियों के पूर्वज हैं।',
      'fatherName': 'Ibrahim',
      'motherName': 'Sarah',
      'birthPlace': 'Canaan (Palestine)',
      'deathPlace': 'Hebron, Palestine',
      'spouse': 'Rifqa (Rebecca)',
      'children': 'Yaqub (Jacob), Esau',
      'era': 'Son of Ibrahim',
      'knownFor': 'Miracle birth, Ancestor of Bani Israel prophets',
    },
    {
      'name': 'يعقوب',
      'transliteration': 'Yaqub (Jacob)',
      'meaning': 'Supplanter',
      'meaningUrdu': 'جانشین',
      'meaningHindi': 'उत्तराधिकारी',
      'description':
          'Prophet Yaqub (AS), also known as Israel, was the son of Ishaq. He had twelve sons who became the twelve tribes of Israel. He endured great patience when his beloved son Yusuf was taken from him. He lost his sight from weeping but was healed when Yusuf\'s shirt was placed on his eyes.',
      'descriptionUrdu':
          'حضرت یعقوب علیہ السلام، جنہیں اسرائیل بھی کہا جاتا ہے، حضرت اسحاق کے بیٹے تھے۔ ان کے بارہ بیٹے تھے جو اسرائیل کے بارہ قبیلے بنے۔ جب ان کے پیارے بیٹے یوسف کو ان سے جدا کیا گیا تو انہوں نے بڑا صبر کیا۔ روتے روتے ان کی بینائی جاتی رہی لیکن جب یوسف کی قمیص ان کی آنکھوں پر رکھی گئی تو وہ ٹھیک ہو گئے۔',
      'descriptionHindi':
          'हज़रत याक़ूब (अ.स.), जिन्हें इसराईल भी कहा जाता है, हज़रत इसहाक़ के बेटे थे। उनके बारह बेटे थे जो इसराईल के बारह क़बीले बने। जब उनके प्यारे बेटे यूसुफ़ को उनसे जुदा किया गया तो उन्होंने बड़ा सब्र किया। रोते-रोते उनकी आंखों की रोशनी चली गई लेकिन जब यूसुफ़ की क़मीस उनकी आंखों पर रखी गई तो वे ठीक हो गए।',
      'fatherName': 'Ishaq (Isaac)',
      'motherName': 'Rifqa (Rebecca)',
      'birthPlace': 'Canaan (Palestine)',
      'deathPlace': 'Egypt',
      'spouse': 'Leah, Rachel, Bilhah, Zilpah',
      'children':
          '12 sons including Yusuf, Binyamin; progenitors of 12 tribes of Israel',
      'title': 'Israel (Servant of God)',
      'knownFor':
          'Father of 12 Tribes of Israel, Patience during separation from Yusuf',
    },
    {
      'name': 'يوسف',
      'transliteration': 'Yusuf (Joseph)',
      'meaning': 'God Increases',
      'meaningUrdu': 'اللہ بڑھاتا ہے',
      'meaningHindi': 'अल्लाह बढ़ाता है',
      'description':
          'Prophet Yusuf (AS) was blessed with exceptional beauty and wisdom. His jealous brothers threw him in a well, and he was sold as a slave in Egypt. He was imprisoned unjustly but rose to become the treasurer of Egypt. His story in the Quran is called "the best of stories." He reunited with his family and forgave his brothers.',
      'descriptionUrdu':
          'حضرت یوسف علیہ السلام کو غیر معمولی حسن اور حکمت سے نوازا گیا تھا۔ ان کے حسد کرنے والے بھائیوں نے انہیں کنویں میں پھینک دیا اور وہ مصر میں غلام کے طور پر بیچ دیے گئے۔ انہیں ناحق قید کیا گیا لیکن وہ مصر کے خزانچی بن گئے۔ قرآن میں ان کی کہانی کو "بہترین کہانی" کہا گیا ہے۔ انہوں نے اپنے خاندان سے ملاقات کی اور اپنے بھائیوں کو معاف کر دیا۔',
      'descriptionHindi':
          'हज़रत यूसुफ़ (अ.स.) को ग़ैर-मामूली हुस्न और हिकमत से नवाज़ा गया था। उनके हसद करने वाले भाइयों ने उन्हें कुएं में फेंक दिया और वे मिस्र में ग़ुलाम के तौर पर बेच दिए गए। उन्हें नाहक़ क़ैद किया गया लेकिन वे मिस्र के ख़ज़ांची बन गए। क़ुरान में उनकी कहानी को "बेहतरीन कहानी" कहा गया है। उन्होंने अपने ख़ानदान से मुलाक़ात की और अपने भाइयों को माफ़ कर दिया।',
      'fatherName': 'Yaqub (Jacob/Israel)',
      'motherName': 'Rahil (Rachel)',
      'birthPlace': 'Canaan (Palestine)',
      'deathPlace': 'Egypt',
      'spouse': 'Zulaikha (Asenath)',
      'children': 'Manasseh, Ephraim',
      'title': 'Al-Siddiq (The Truthful)',
      'knownFor':
          'Best of Stories in Quran, Treasurer of Egypt, Exceptional beauty',
    },
    {
      'name': 'أيوب',
      'transliteration': 'Ayyub (Job)',
      'meaning': 'Repentant',
      'meaningUrdu': 'توبہ کرنے والا',
      'meaningHindi': 'तौबा करने वाला',
      'description':
          'Prophet Ayyub (AS) is famous for his extraordinary patience during severe trials. He lost his wealth, children, and health but never complained or lost faith. After years of suffering, he called upon Allah, who restored his health, blessed him with new children, and doubled his wealth. He is a symbol of patience in adversity.',
      'descriptionUrdu':
          'حضرت ایوب علیہ السلام شدید آزمائشوں میں اپنے غیر معمولی صبر کے لیے مشہور ہیں۔ انہوں نے اپنا مال، بچے اور صحت کھو دی لیکن کبھی شکایت نہیں کی یا ایمان نہیں کھویا۔ سالوں کی تکلیف کے بعد انہوں نے اللہ کو پکارا، جس نے ان کی صحت بحال کی، نئے بچے عطا کیے اور ان کا مال دوگنا کر دیا۔ وہ مصیبت میں صبر کی علامت ہیں۔',
      'descriptionHindi':
          'हज़रत अय्यूब (अ.स.) शदीद आज़माइशों में अपने ग़ैर-मामूली सब्र के लिए मशहूर हैं। उन्होंने अपना माल, बच्चे और सेहत खो दी लेकिन कभी शिकायत नहीं की या ईमान नहीं खोया। सालों की तकलीफ़ के बाद उन्होंने अल्लाह को पुकारा, जिसने उनकी सेहत बहाल की, नए बच्चे अता किए और उनका माल दोगुना कर दिया। वे मुसीबत में सब्र की निशानी हैं।',
      'birthPlace': 'Hauran, Syria (traditions vary)',
      'deathPlace': 'Syria or Palestine',
      'spouse': 'Rahmat (or Leya in some traditions)',
      'children': 'Allah blessed him with new children after trial',
      'era': 'After Yusuf',
      'knownFor':
          'Symbol of patience, Tested with severe trials, Restored by Allah',
    },
    {
      'name': 'شعيب',
      'transliteration': 'Shuaib',
      'meaning': 'One who shows the right path',
      'meaningUrdu': 'سیدھا راستہ دکھانے والا',
      'meaningHindi': 'सीधा रास्ता दिखाने वाला',
      'description':
          'Prophet Shuaib (AS) was sent to the people of Madyan who cheated in business and trade. He is called "Khatib al-Anbiya" (the Orator of the Prophets) for his eloquent speech. His daughter married Prophet Musa. His people were destroyed by an earthquake and a burning cloud when they rejected his message.',
      'descriptionUrdu':
          'حضرت شعیب علیہ السلام مدین کے لوگوں کی طرف بھیجے گئے جو کاروبار اور تجارت میں دھوکہ دیتے تھے۔ انہیں ان کی فصیح تقریر کی وجہ سے "خطیب الانبیاء" کہا جاتا ہے۔ ان کی بیٹی نے حضرت موسیٰ سے شادی کی۔ جب ان کی قوم نے ان کے پیغام کو رد کیا تو وہ زلزلے اور جلتے بادل سے تباہ ہو گئے۔',
      'descriptionHindi':
          'हज़रत शुऐब (अ.स.) मदयन के लोगों की तरफ़ भेजे गए जो कारोबार और तिजारत में धोखा देते थे। उन्हें उनकी फ़सीह तक़रीर की वजह से "ख़तीबुल-अंबिया" कहा जाता है। उनकी बेटी ने हज़रत मूसा से शादी की। जब उनकी क़ौम ने उनके पैग़ाम को रद्द किया तो वे भूकंप और जलते बादल से तबाह हो गए।',
      'birthPlace': 'Madyan, near Gulf of Aqaba',
      'deathPlace': 'Madyan',
      'children': 'Daughters including wife of Musa',
      'era': 'Before Musa, sent to Madyan',
      'title': 'Khatib al-Anbiya (Orator of the Prophets)',
      'knownFor':
          'Eloquent speech, Father-in-law of Musa, Warned against cheating',
    },
    {
      'name': 'موسى',
      'transliteration': 'Musa (Moses)',
      'meaning': 'Drawn from Water',
      'meaningUrdu': 'پانی سے نکالا گیا',
      'meaningHindi': 'पानी से निकाला गया',
      'description':
          'Prophet Musa (AS) is the most frequently mentioned prophet in the Quran. He is one of the five greatest prophets. He was raised in Pharaoh\'s palace, received the Torah, and led the Israelites out of Egypt. Allah spoke to him directly (Kalimullah). He performed many miracles including splitting the sea and his staff turning into a serpent.',
      'descriptionUrdu':
          'حضرت موسیٰ علیہ السلام قرآن میں سب سے زیادہ ذکر کیے جانے والے نبی ہیں۔ وہ پانچ عظیم ترین انبیاء میں سے ایک ہیں۔ انہیں فرعون کے محل میں پالا گیا، توریت دی گئی اور بنی اسرائیل کو مصر سے باہر لے گئے۔ اللہ نے ان سے براہ راست بات کی (کلیم اللہ)۔ انہوں نے سمندر چیرنے اور اپنے عصا کو سانپ میں بدلنے سمیت بہت سے معجزے دکھائے۔',
      'descriptionHindi':
          'हज़रत मूसा (अ.स.) क़ुरान में सबसे ज़्यादा ज़िक्र किए जाने वाले नबी हैं। वे पांच महान नबियों में से एक हैं। उन्हें फ़िरऔन के महल में पाला गया, तौरात दी गई और बनी इसराईल को मिस्र से बाहर ले गए। अल्लाह ने उनसे बराह-ए-रास्त बात की (कलीमुल्लाह)। उन्होंने समंदर चीरने और अपने असा को सांप में बदलने समेत बहुत से मोजज़े दिखाए।',
      'fatherName': 'Imran',
      'motherName': 'Yukhabed (Jochebed)',
      'birthPlace': 'Egypt',
      'deathPlace': 'Mount Nebo, near Jordan',
      'spouse': 'Saffurah (daughter of Shuaib)',
      'children': 'Gershom, Eliezer',
      'era': 'Approximately 1400-1300 BCE',
      'title': 'Kalimullah (One who spoke with Allah)',
      'knownFor': 'Ulul Azm Prophet, Torah, Parted the Red Sea, Led Exodus',
    },
    {
      'name': 'هارون',
      'transliteration': 'Harun (Aaron)',
      'meaning': 'High Mountain',
      'meaningUrdu': 'اونچا پہاڑ',
      'meaningHindi': 'ऊंचा पहाड़',
      'description':
          'Prophet Harun (AS) was the elder brother of Musa and was appointed as his helper and spokesman. He was known for his eloquence and gentle nature. He served as a prophet to the Israelites alongside Musa and helped lead them. He was beloved by his people for his kindness and approachability.',
      'descriptionUrdu':
          'حضرت ہارون علیہ السلام حضرت موسیٰ کے بڑے بھائی تھے اور انہیں ان کے مددگار اور ترجمان کے طور پر مقرر کیا گیا۔ وہ اپنی فصاحت اور نرم مزاجی کے لیے مشہور تھے۔ انہوں نے موسیٰ کے ساتھ بنی اسرائیل کے نبی کے طور پر خدمت کی اور ان کی رہنمائی میں مدد کی۔ وہ اپنی مہربانی اور قابل رسائی ہونے کی وجہ سے اپنی قوم میں محبوب تھے۔',
      'descriptionHindi':
          'हज़रत हारून (अ.स.) हज़रत मूसा के बड़े भाई थे और उन्हें उनके मददगार और तर्जुमान के तौर पर मुक़र्रर किया गया। वे अपनी फ़साहत और नर्म मिज़ाजी के लिए मशहूर थे। उन्होंने मूसा के साथ बनी इसराईल के नबी के तौर पर ख़िदमत की और उनकी रहनुमाई में मदद की। वे अपनी मेहरबानी और क़ाबिल-ए-रसाई होने की वजह से अपनी क़ौम में महबूब थे।',
      'fatherName': 'Imran',
      'motherName': 'Yukhabed (Jochebed)',
      'birthPlace': 'Egypt',
      'deathPlace': 'Mount Hor (near Petra)',
      'spouse': 'Elisheba',
      'children': 'Nadab, Abihu, Eleazar, Ithamar',
      'era': 'Contemporary of Musa',
      'knownFor':
          'Helper and spokesman of Musa, Eloquent, Beloved by his people',
    },
    {
      'name': 'ذو الكفل',
      'transliteration': 'Dhul-Kifl',
      'meaning': 'The One with a Portion',
      'meaningUrdu': 'حصے والا',
      'meaningHindi': 'हिस्से वाला',
      'description':
          'Prophet Dhul-Kifl (AS) is mentioned twice in the Quran as being among the patient and righteous. His name means "the one with a portion" or "the one who guaranteed." Some scholars identify him with the Biblical Ezekiel. He fulfilled his responsibilities perfectly and was rewarded with prophethood.',
      'descriptionUrdu':
          'حضرت ذوالکفل علیہ السلام کا قرآن میں دو بار ذکر کیا گیا ہے کہ وہ صابرین اور نیکوکاروں میں سے تھے۔ ان کے نام کا مطلب ہے "حصے والا" یا "ضمانت دینے والا۔" کچھ علماء انہیں بائبل کے حزقیل سے شناخت کرتے ہیں۔ انہوں نے اپنی ذمہ داریاں بخوبی نبھائیں اور انہیں نبوت سے نوازا گیا۔',
      'descriptionHindi':
          'हज़रत ज़ुल-किफ़्ल (अ.स.) का क़ुरान में दो बार ज़िक्र किया गया है कि वे साबिरीन और नेकोकारों में से थे। उनके नाम का मतलब है "हिस्से वाला" या "ज़मानत देने वाला।" कुछ उलेमा उन्हें बाइबल के हिज़्क़ीएल से पहचानते हैं। उन्होंने अपनी ज़िम्मेदारियां बख़ूबी निभाईं और उन्हें नुबूव्वत से नवाज़ा गया।',
      'birthPlace': 'Among Bani Israel',
      'era': 'After Musa',
      'title': 'The Guarantor',
      'knownFor': 'Patience and righteousness, Fulfilled his responsibilities',
    },
    {
      'name': 'داود',
      'transliteration': 'Dawud (David)',
      'meaning': 'Beloved',
      'meaningUrdu': 'محبوب',
      'meaningHindi': 'महबूब',
      'description':
          'Prophet Dawud (AS) was given the Zabur (Psalms) and blessed with a beautiful voice. He killed the giant Jalut (Goliath) as a young man and later became king of Israel. Allah made iron soft for him to make armor. He is known for his devotion, fasting alternate days, and his psalms of praise to Allah.',
      'descriptionUrdu':
          'حضرت داؤد علیہ السلام کو زبور دی گئی اور خوبصورت آواز سے نوازا گیا۔ انہوں نے نوجوانی میں دیو جالوت کو قتل کیا اور بعد میں اسرائیل کے بادشاہ بنے۔ اللہ نے ان کے لیے لوہے کو نرم کیا تاکہ وہ زرہ بنا سکیں۔ وہ اپنی عبادت، ایک دن روزہ ایک دن افطار اور اللہ کی حمد کے زبور کے لیے مشہور ہیں۔',
      'descriptionHindi':
          'हज़रत दाऊद (अ.स.) को ज़बूर दी गई और ख़ूबसूरत आवाज़ से नवाज़ा गया। उन्होंने नौजवानी में दैत्य जालूत को क़त्ल किया और बाद में इसराईल के बादशाह बने। अल्लाह ने उनके लिए लोहे को नर्म किया ताकि वे ज़िरह बना सकें। वे अपनी इबादत, एक दिन रोज़ा एक दिन इफ़्तार और अल्लाह की हम्द के ज़बूर के लिए मशहूर हैं।',
      'fatherName': 'Yishai (Jesse)',
      'birthPlace': 'Bethlehem, Palestine',
      'deathPlace': 'Jerusalem',
      'spouse': 'Multiple wives',
      'children': 'Sulaiman (Solomon) and others',
      'era': 'Approximately 1000 BCE, King of Israel',
      'knownFor':
          'Zabur (Psalms), Killed Goliath, Beautiful voice, Iron softened for him',
    },
    {
      'name': 'سليمان',
      'transliteration': 'Sulaiman (Solomon)',
      'meaning': 'Man of Peace',
      'meaningUrdu': 'امن والا',
      'meaningHindi': 'अमन वाला',
      'description':
          'Prophet Sulaiman (AS) was the son of Dawud and was granted a kingdom like no other. He could command the wind, understand the speech of animals and birds, and control the jinn. He built a magnificent palace and the famous Temple in Jerusalem. Despite his power, he remained humble and grateful to Allah.',
      'descriptionUrdu':
          'حضرت سلیمان علیہ السلام حضرت داؤد کے بیٹے تھے اور انہیں بے مثال سلطنت عطا کی گئی۔ وہ ہوا کو حکم دے سکتے تھے، جانوروں اور پرندوں کی زبان سمجھتے تھے اور جنوں پر کنٹرول رکھتے تھے۔ انہوں نے ایک شاندار محل اور یروشلم میں مشہور ہیکل تعمیر کی۔ اپنی طاقت کے باوجود وہ عاجز اور اللہ کے شکرگزار رہے۔',
      'descriptionHindi':
          'हज़रत सुलेमान (अ.स.) हज़रत दाऊद के बेटे थे और उन्हें बेमिसाल सल्तनत अता की गई। वे हवा को हुक्म दे सकते थे, जानवरों और परिंदों की ज़बान समझते थे और जिन्नों पर कंट्रोल रखते थे। उन्होंने एक शानदार महल और येरुशलम में मशहूर हैकल तामीर की। अपनी ताक़त के बावजूद वे आजिज़ और अल्लाह के शुक्रगुज़ार रहे।',
      'fatherName': 'Dawud (David)',
      'birthPlace': 'Jerusalem',
      'deathPlace': 'Jerusalem',
      'spouse': 'Queen of Sheba (Bilqis), and others',
      'children': 'Rehoboam and others',
      'era': 'Approximately 970-930 BCE, King of Israel',
      'knownFor':
          'Greatest kingdom, Controlled wind/jinn/animals, Built Solomon\'s Temple',
    },
    {
      'name': 'إلياس',
      'transliteration': 'Ilyas (Elijah)',
      'meaning': 'My God is Yahweh',
      'meaningUrdu': 'میرا رب اللہ ہے',
      'meaningHindi': 'मेरा रब अल्लाह है',
      'description':
          'Prophet Ilyas (AS) was sent to the people of Baalbek in Lebanon who worshipped an idol called Baal. He called them to worship Allah alone but they rejected him. He is mentioned in the Quran as one of the righteous and was given peace. Some traditions say he was raised to heaven alive.',
      'descriptionUrdu':
          'حضرت الیاس علیہ السلام لبنان کے بعلبک کے لوگوں کی طرف بھیجے گئے جو بعل نامی بت کی پوجا کرتے تھے۔ انہوں نے انہیں صرف اللہ کی عبادت کرنے کی دعوت دی لیکن انہوں نے رد کر دیا۔ قرآن میں انہیں نیکوکاروں میں سے بتایا گیا ہے اور انہیں سلام دیا گیا۔ کچھ روایات کے مطابق انہیں زندہ آسمان پر اٹھا لیا گیا۔',
      'descriptionHindi':
          'हज़रत इलयास (अ.स.) लेबनान के बालबक के लोगों की तरफ़ भेजे गए जो बाल नामी बुत की पूजा करते थे। उन्होंने उन्हें सिर्फ़ अल्लाह की इबादत करने की दावत दी लेकिन उन्होंने रद्द कर दिया। क़ुरान में उन्हें नेकोकारों में से बताया गया है और उन्हें सलाम दिया गया। कुछ रिवायतों के मुताबिक़ उन्हें ज़िंदा आसमान पर उठा लिया गया।',
      'birthPlace': 'Baalbek, Lebanon (traditions vary)',
      'deathPlace': 'Raised to heavens (traditions)',
      'era': 'After Sulaiman, Kingdom of Israel',
      'knownFor': 'Fought against Baal worship, Raised to heaven alive',
    },
    {
      'name': 'اليسع',
      'transliteration': 'Al-Yasa (Elisha)',
      'meaning': 'God is Salvation',
      'meaningUrdu': 'اللہ نجات ہے',
      'meaningHindi': 'अल्लाह निजात है',
      'description':
          'Prophet Al-Yasa (AS) was the successor of Prophet Ilyas. He continued calling the people of Israel to worship Allah alone. He is mentioned in the Quran among those preferred above all people. He performed many miracles and guided his people with wisdom and patience.',
      'descriptionUrdu':
          'حضرت الیسع علیہ السلام حضرت الیاس کے جانشین تھے۔ انہوں نے بنی اسرائیل کو صرف اللہ کی عبادت کی دعوت جاری رکھی۔ قرآن میں انہیں تمام لوگوں پر فضیلت دیے گئے لوگوں میں شمار کیا گیا ہے۔ انہوں نے بہت سے معجزے دکھائے اور اپنی قوم کی حکمت اور صبر سے رہنمائی کی۔',
      'descriptionHindi':
          'हज़रत अल-यसअ (अ.स.) हज़रत इलयास के जानशीन थे। उन्होंने बनी इसराईल को सिर्फ़ अल्लाह की इबादत की दावत जारी रखी। क़ुरान में उन्हें तमाम लोगों पर फ़ज़ीलत दिए गए लोगों में शुमार किया गया है। उन्होंने बहुत से मोजज़े दिखाए और अपनी क़ौम की हिकमत और सब्र से रहनुमाई की।',
      'birthPlace': 'Among Bani Israel',
      'era': 'Successor of Ilyas',
      'knownFor': 'Successor of Ilyas, Performed miracles, Guided with wisdom',
    },
    {
      'name': 'يونس',
      'transliteration': 'Yunus (Jonah)',
      'meaning': 'Dove',
      'meaningUrdu': 'کبوتر',
      'meaningHindi': 'कबूतर',
      'description':
          'Prophet Yunus (AS) was sent to the people of Nineveh in Iraq. When they rejected his message, he left in anger without Allah\'s permission. He was swallowed by a great fish but repented in its belly with the famous dua. Allah saved him and his people became the only nation to be saved after seeing the signs of punishment.',
      'descriptionUrdu':
          'حضرت یونس علیہ السلام عراق کے نینوا کے لوگوں کی طرف بھیجے گئے۔ جب انہوں نے ان کے پیغام کو رد کیا تو وہ اللہ کی اجازت کے بغیر ناراض ہو کر چلے گئے۔ انہیں ایک بڑی مچھلی نے نگل لیا لیکن انہوں نے اس کے پیٹ میں مشہور دعا کے ساتھ توبہ کی۔ اللہ نے انہیں بچایا اور ان کی قوم واحد قوم بنی جو عذاب کی علامات دیکھنے کے بعد بچ گئی۔',
      'descriptionHindi':
          'हज़रत यूनुस (अ.स.) इराक़ के नीनवा के लोगों की तरफ़ भेजे गए। जब उन्होंने उनके पैग़ाम को रद्द किया तो वे अल्लाह की इजाज़त के बग़ैर नाराज़ होकर चले गए। उन्हें एक बड़ी मछली ने निगल लिया लेकिन उन्होंने उसके पेट में मशहूर दुआ के साथ तौबा की। अल्लाह ने उन्हें बचाया और उनकी क़ौम वाहिद क़ौम बनी जो अज़ाब की अलामतें देखने के बाद बच गई।',
      'fatherName': 'Matta (Amittai)',
      'birthPlace': 'Gath-hepher, near Nazareth',
      'era': 'Sent to Nineveh (modern Mosul, Iraq)',
      'title': 'Dhun-Nun (Owner of the Fish)',
      'knownFor':
          'Swallowed by whale, Famous dua of repentance, Only nation saved after seeing punishment',
    },
    {
      'name': 'زكريا',
      'transliteration': 'Zakariya (Zechariah)',
      'meaning': 'God Remembers',
      'meaningUrdu': 'اللہ یاد رکھتا ہے',
      'meaningHindi': 'अल्लाह याद रखता है',
      'description':
          'Prophet Zakariya (AS) was a priest who cared for Maryam (mother of Isa) in the temple. In his old age, he prayed for a son and Allah blessed him with Yahya. He was told he would not speak for three days as a sign. He was known for his devotion and spent much time in prayer and worship.',
      'descriptionUrdu':
          'حضرت زکریا علیہ السلام ایک پادری تھے جو ہیکل میں مریم (عیسیٰ کی والدہ) کی دیکھ بھال کرتے تھے۔ بڑھاپے میں انہوں نے بیٹے کے لیے دعا کی اور اللہ نے انہیں یحییٰ سے نوازا۔ انہیں بتایا گیا کہ وہ نشانی کے طور پر تین دن نہیں بولیں گے۔ وہ اپنی عبادت کے لیے مشہور تھے اور نماز اور عبادت میں کافی وقت گزارتے تھے۔',
      'descriptionHindi':
          'हज़रत ज़करिया (अ.स.) एक पादरी थे जो हैकल में मरयम (ईसा की वालिदा) की देखभाल करते थे। बुढ़ापे में उन्होंने बेटे के लिए दुआ की और अल्लाह ने उन्हें यहया से नवाज़ा। उन्हें बताया गया कि वे निशानी के तौर पर तीन दिन नहीं बोलेंगे। वे अपनी इबादत के लिए मशहूर थे और नमाज़ और इबादत में काफ़ी वक़्त गुज़ारते थे।',
      'birthPlace': 'Jerusalem',
      'deathPlace': 'Jerusalem (martyred)',
      'spouse': 'Elizabeth (Ishba)',
      'children': 'Yahya (John)',
      'era': 'Shortly before Isa',
      'knownFor': 'Guardian of Maryam, Father of Yahya, Devoted worshipper',
    },
    {
      'name': 'يحيى',
      'transliteration': 'Yahya (John)',
      'meaning': 'God is Gracious',
      'meaningUrdu': 'اللہ مہربان ہے',
      'meaningHindi': 'अल्लाह मेहरबान है',
      'description':
          'Prophet Yahya (AS) was born miraculously to elderly parents Zakariya and Elizabeth. He was given wisdom as a child and was pure, kind to his parents, and devout. He was the first to be named Yahya. He confirmed the coming of Isa and was martyred for speaking against injustice. He is described as noble and chaste.',
      'descriptionUrdu':
          'حضرت یحییٰ علیہ السلام معجزانہ طور پر بوڑھے والدین زکریا اور الزبتھ کے ہاں پیدا ہوئے۔ انہیں بچپن میں حکمت دی گئی اور وہ پاکباز، والدین کے ساتھ مہربان اور عبادت گزار تھے۔ وہ پہلے شخص تھے جن کا نام یحییٰ رکھا گیا۔ انہوں نے عیسیٰ کی آمد کی تصدیق کی اور ناانصافی کے خلاف بولنے پر شہید ہوئے۔ انہیں شریف اور پاکدامن کہا گیا ہے۔',
      'descriptionHindi':
          'हज़रत यहया (अ.स.) मोजज़ाना तौर पर बूढ़े वालिदैन ज़करिया और एलिज़ाबेथ के यहां पैदा हुए। उन्हें बचपन में हिकमत दी गई और वे पाकबाज़, वालिदैन के साथ मेहरबान और इबादतगुज़ार थे। वे पहले शख़्स थे जिनका नाम यहया रखा गया। उन्होंने ईसा की आमद की तस्दीक़ की और नाइंसाफ़ी के ख़िलाफ़ बोलने पर शहीद हुए। उन्हें शरीफ़ और पाकदामन कहा गया है।',
      'fatherName': 'Zakariya',
      'motherName': 'Elizabeth (Ishba)',
      'birthPlace': 'Ein Kerem, near Jerusalem',
      'deathPlace': 'Palestine (martyred)',
      'era': 'Contemporary of Isa',
      'knownFor': 'Miracle birth, Wisdom as child, First named Yahya, Martyr',
    },
    {
      'name': 'عيسى',
      'transliteration': 'Isa (Jesus)',
      'meaning': 'God is Salvation',
      'meaningUrdu': 'اللہ نجات ہے',
      'meaningHindi': 'अल्लाह निजात है',
      'description':
          'Prophet Isa (AS) was born miraculously to Maryam without a father. He is called Ruhullah (Spirit of Allah) and Masih (Messiah). He performed many miracles including healing the sick and raising the dead by Allah\'s permission. He was given the Injeel (Gospel). Allah raised him to heaven alive, and he will return before the Day of Judgment.',
      'descriptionUrdu':
          'حضرت عیسیٰ علیہ السلام معجزانہ طور پر بغیر باپ کے مریم سے پیدا ہوئے۔ انہیں روح اللہ اور مسیح کہا جاتا ہے۔ انہوں نے اللہ کے حکم سے بیماروں کو شفا دینے اور مردوں کو زندہ کرنے سمیت بہت سے معجزے دکھائے۔ انہیں انجیل دی گئی۔ اللہ نے انہیں زندہ آسمان پر اٹھا لیا اور وہ قیامت سے پہلے واپس آئیں گے۔',
      'descriptionHindi':
          'हज़रत ईसा (अ.स.) मोजज़ाना तौर पर बग़ैर बाप के मरयम से पैदा हुए। उन्हें रूहुल्लाह और मसीह कहा जाता है। उन्होंने अल्लाह के हुक्म से बीमारों को शिफ़ा देने और मुर्दों को ज़िंदा करने समेत बहुत से मोजज़े दिखाए। उन्हें इंजील दी गई। अल्लाह ने उन्हें ज़िंदा आसमान पर उठा लिया और वे क़यामत से पहले वापस आएंगे।',
      'motherName': 'Maryam (Mary)',
      'birthPlace': 'Bethlehem, Palestine',
      'deathPlace': 'Raised alive to heavens',
      'era': 'Approximately 1-33 CE',
      'title': 'Ruhullah (Spirit of Allah), Al-Masih (Messiah)',
      'knownFor':
          'Ulul Azm Prophet, Injeel (Gospel), Miracles, Will return before Day of Judgment',
    },
    {
      'name': 'محمد',
      'transliteration': 'Muhammad ﷺ',
      'meaning': 'The Praised One',
      'meaningUrdu': 'تعریف کیا گیا',
      'meaningHindi': 'तारीफ़ किया गया',
      'description':
          'Prophet Muhammad ﷺ is the final messenger of Allah, sent as a mercy to all worlds. He received the Holy Quran over 23 years. He is the leader of all prophets and the best of creation. His life, teachings, and example (Sunnah) are a complete guide for humanity. He established the Muslim Ummah and spread the message of Islam across Arabia and beyond.',
      'descriptionUrdu':
          'نبی محمد ﷺ اللہ کے آخری رسول ہیں، تمام جہانوں کے لیے رحمت بن کر بھیجے گئے۔ انہیں 23 سالوں میں قرآن پاک ملا۔ وہ تمام انبیاء کے سردار اور بہترین مخلوق ہیں۔ ان کی زندگی، تعلیمات اور سنت انسانیت کے لیے مکمل رہنمائی ہیں۔ انہوں نے مسلم امت قائم کی اور عرب اور اس سے باہر اسلام کا پیغام پھیلایا۔',
      'descriptionHindi':
          'नबी मुहम्मद ﷺ अल्लाह के आख़िरी रसूल हैं, तमाम जहानों के लिए रहमत बनकर भेजे गए। उन्हें 23 सालों में क़ुरान पाक मिला। वे तमाम अंबिया के सरदार और बेहतरीन मख़लूक़ हैं। उनकी ज़िंदगी, तालीमात और सुन्नत इंसानियत के लिए मुकम्मल रहनुमाई हैं। उन्होंने मुस्लिम उम्मत क़ायम की और अरब और उससे बाहर इस्लाम का पैग़ाम फैलाया।',
      'fatherName': 'Abdullah ibn Abd al-Muttalib',
      'motherName': 'Aminah bint Wahb',
      'birthDate': '12 Rabi al-Awwal, 53 BH (570 CE)',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '12 Rabi al-Awwal, 11 AH (632 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse':
          'Khadijah, Sawda, Aisha, Hafsa, Zaynab, Umm Salamah, and others',
      'children':
          'Qasim, Abdullah, Ibrahim, Zaynab, Ruqayyah, Umm Kulthum, Fatimah',
      'tribe': 'Banu Hashim, Quraysh',
      'title': 'Khatam an-Nabiyyin (Seal of Prophets), Rahmat lil-Alameen',
      'knownFor':
          'Final Prophet, Quran, Ulul Azm Prophet, Leader of all Prophets',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredNames = _nabiNames;
    _searchController.addListener(_filterNames);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredNames = _nabiNames;
      } else {
        _filteredNames = _nabiNames.where((name) {
          final transliteration = name['transliteration']!.toLowerCase();
          final meaning = name['meaning']!.toLowerCase();
          final arabicName = name['name']!;
          return transliteration.contains(query) ||
              meaning.contains(query) ||
              arabicName.contains(query);
        }).toList();
      }
    });
  }

  String _transliterateToHindi(String text) {
    final Map<String, String> map = {
      'Adam': 'आदम', 'Idris': 'इदरीस', 'Nuh (Noah)': 'नूह', 'Hud': 'हूद',
      'Salih': 'सालिह', 'Ibrahim (Abraham)': 'इब्राहीम', 'Lut (Lot)': 'लूत',
      'Ismail (Ishmael)': 'इस्माईल', 'Ishaq (Isaac)': 'इसहाक़', 'Yaqub (Jacob)': 'याक़ूब',
      'Yusuf (Joseph)': 'यूसुफ़', 'Ayyub (Job)': 'अय्यूब', 'Shuaib': 'शुऐब',
      'Musa (Moses)': 'मूसा', 'Harun (Aaron)': 'हारून', 'Dhul-Kifl': 'ज़ुल-किफ़्ल',
      'Dawud (David)': 'दाऊद', 'Sulaiman (Solomon)': 'सुलैमान', 'Ilyas (Elijah)': 'इल्यास',
      'Al-Yasa (Elisha)': 'अल-यसा', 'Yunus (Jonah)': 'यूनुस', 'Zakariya (Zechariah)': 'ज़करिया',
      'Yahya (John)': 'यहया', 'Isa (Jesus)': 'ईसा', 'Muhammad ﷺ': 'मुहम्मद ﷺ',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    final Map<String, String> map = {
      'Adam': 'آدم', 'Idris': 'ادریس', 'Nuh (Noah)': 'نوح', 'Hud': 'ہود',
      'Salih': 'صالح', 'Ibrahim (Abraham)': 'ابراہیم', 'Lut (Lot)': 'لوط',
      'Ismail (Ishmael)': 'اسماعیل', 'Ishaq (Isaac)': 'اسحاق', 'Yaqub (Jacob)': 'یعقوب',
      'Yusuf (Joseph)': 'یوسف', 'Ayyub (Job)': 'ایوب', 'Shuaib': 'شعیب',
      'Musa (Moses)': 'موسیٰ', 'Harun (Aaron)': 'ہارون', 'Dhul-Kifl': 'ذوالکفل',
      'Dawud (David)': 'داؤد', 'Sulaiman (Solomon)': 'سلیمان', 'Ilyas (Elijah)': 'الیاس',
      'Al-Yasa (Elisha)': 'الیسع', 'Yunus (Jonah)': 'یونس', 'Zakariya (Zechariah)': 'زکریا',
      'Yahya (John)': 'یحییٰ', 'Isa (Jesus)': 'عیسیٰ', 'Muhammad ﷺ': 'محمد ﷺ',
    };
    return map[text] ?? text;
  }

  String _getDisplayName(Map<String, dynamic> name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name['name']!;
      case 'hi':
        return _transliterateToHindi(name['transliteration']!);
      case 'ur':
        return _transliterateToUrdu(name['transliteration']!);
      case 'en':
      default:
        return name['transliteration']!;
    }
  }

  String _getDisplayMeaning(Map<String, dynamic> name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name['meaningUrdu'] ?? name['meaning']!;
      case 'ur':
        return name['meaningUrdu'] ?? name['meaning']!;
      case 'hi':
        return name['meaningHindi'] ?? name['meaning']!;
      case 'en':
      default:
        return name['meaning']!;
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final langProvider = context.watch<LanguageProvider>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.tr('nabi_names')),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: responsive.paddingRegular,
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_by_name_meaning'),
              onClear: () => _searchController.clear(),
              enableVoiceSearch: true,
            ),
          ),

          // Results count
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: responsive.paddingSymmetric(horizontal: 16),
              child: Text(
                '${context.tr('found')} ${_filteredNames.length} ${_filteredNames.length != 1 ? context.tr('results') : context.tr('result')}',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  fontSize: responsive.textSmall,
                ),
              ),
            ),

          Expanded(
            child: _filteredNames.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: responsive.iconXXLarge,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                        ),
                        responsive.vSpaceRegular,
                        Text(
                          context.tr('no_prophets_found'),
                          style: TextStyle(
                            fontSize: responsive.textRegular,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        responsive.vSpaceSmall,
                        Text(
                          context.tr('try_different_search'),
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(langProvider.languageCode), // Force rebuild when language changes
                    padding: responsive.paddingRegular,
                    itemCount: _filteredNames.length,
                    itemBuilder: (context, index) {
                      final name = _filteredNames[index];
                      final originalIndex = _nabiNames.indexOf(name) + 1;
                      final displayName = _getDisplayName(name, langProvider.languageCode);
                      final displayMeaning = _getDisplayMeaning(name, langProvider.languageCode);
                      return _buildNameCard(
                        name: name,
                        index: originalIndex,
                        isDark: isDark,
                        displayName: displayName,
                        displayMeaning: displayMeaning,
                        languageCode: langProvider.languageCode,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard({
    required Map<String, dynamic> name,
    required int index,
    required bool isDark,
    required String displayName,
    required String displayMeaning,
    required String languageCode,
  }) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    final responsive = context.responsive;

    return Container(
      margin: responsive.paddingOnly(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: darkGreen.withValues(alpha: 0.08),
                  blurRadius: 10.0,
                  offset: Offset(0, 2.0),
                ),
              ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IslamicNameDetailScreen(
                arabicName: name['name']!,
                transliteration: name['transliteration']!,
                meaning: name['meaning']!,
                meaningUrdu: name['meaningUrdu'] ?? '',
                meaningHindi: name['meaningHindi'] ?? '',
                description: name['description']!,
                descriptionUrdu: name['descriptionUrdu'] ?? '',
                descriptionHindi: name['descriptionHindi'] ?? '',
                category: 'Prophet of Allah',
                number: index,
                icon: Icons.person,
                color: Colors.green,
                fatherName: name['fatherName'],
                motherName: name['motherName'],
                birthDate: name['birthDate'],
                birthPlace: name['birthPlace'],
                deathDate: name['deathDate'],
                deathPlace: name['deathPlace'],
                spouse: name['spouse'],
                children: name['children'],
                tribe: name['tribe'],
                title: name['title'],
                era: name['era'],
                knownFor: name['knownFor'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge (circular)
              Container(
                width: responsive.iconLarge * 1.5,
                height: responsive.iconLarge * 1.5,
                decoration: BoxDecoration(
                  color: isDark ? emeraldGreen : darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? emeraldGreen : darkGreen).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              responsive.hSpaceSmall,

              // Prophet Name
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : darkGreen,
                    fontFamily: languageCode == 'ar'
                        ? 'Poppins'
                        : (languageCode == 'ur' ? 'Poppins' : null),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: (languageCode == 'ar' || languageCode == 'ur')
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),

              // Forward Arrow in Circle
              Container(
                padding: responsive.paddingAll(6),
                decoration: BoxDecoration(
                  color: isDark ? emeraldGreen : emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
