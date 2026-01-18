import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'islamic_name_detail_screen.dart';

class KhalifaNamesScreen extends StatefulWidget {
  const KhalifaNamesScreen({super.key});

  @override
  State<KhalifaNamesScreen> createState() => _KhalifaNamesScreenState();
}

class _KhalifaNamesScreenState extends State<KhalifaNamesScreen> {
  final List<Map<String, dynamic>> _khalifaNames = [
    {
      'name': 'أبو بكر الصديق',
      'transliteration': 'Abu Bakr As-Siddiq',
      'meaning': 'The Truthful',
      'meaningUrdu': 'صدیق',
      'meaningHindi': 'सच्चा',
      'period': '632-634 CE',
      'description':
          'Abu Bakr (RA) was the first Caliph of Islam, ruling for about 2 years after the Prophet\'s ﷺ death. He was the closest companion of the Prophet and accompanied him during the Hijrah to Madinah. During his caliphate, he successfully managed the Ridda Wars (Wars of Apostasy) and began the compilation of the Quran. He united the Muslim community during a critical period and initiated the expansion of Islam beyond Arabia. Known for his unwavering faith, he earned the title "As-Siddiq" (The Truthful) when he immediately believed in the Prophet\'s night journey (Isra and Mi\'raj). He passed away at age 63 and is buried next to the Prophet ﷺ in Madinah.',
      'descriptionUrdu':
          'حضرت ابوبکر صدیق رضی اللہ عنہ اسلام کے پہلے خلیفہ تھے، جنہوں نے نبی ﷺ کی وفات کے بعد تقریباً 2 سال حکومت کی۔ وہ نبی ﷺ کے سب سے قریبی صحابی تھے اور ہجرت کے دوران مدینہ تک ان کے ساتھ رہے۔ ان کی خلافت میں انہوں نے جنگ ردہ کا کامیابی سے انتظام کیا اور قرآن کی تدوین شروع کی۔ انہوں نے ایک نازک دور میں مسلم امت کو متحد کیا اور عرب سے باہر اسلام کی توسیع شروع کی۔ اپنے پختہ ایمان کی وجہ سے انہیں "صدیق" کا لقب ملا جب انہوں نے فوراً نبی ﷺ کے معراج کی تصدیق کی۔ وہ 63 سال کی عمر میں وفات پائے اور مدینہ میں نبی ﷺ کے پہلو میں دفن ہیں۔',
      'descriptionHindi':
          'हज़रत अबू बक्र सिद्दीक़ (रज़ि.) इस्लाम के पहले ख़लीफ़ा थे, जिन्होंने नबी ﷺ की वफ़ात के बाद तक़रीबन 2 साल हुकूमत की। वे नबी ﷺ के सबसे क़रीबी साथी थे और हिजरत के दौरान मदीना तक उनके साथ रहे। उनकी ख़िलाफ़त में उन्होंने जंग-ए-रिद्दा का कामयाबी से इंतिज़ाम किया और क़ुरान की तदवीन शुरू की। उन्होंने एक नाज़ुक दौर में मुस्लिम उम्मत को मुत्तहिद किया और अरब से बाहर इस्लाम की तौसी शुरू की। अपने पक्के ईमान की वजह से उन्हें "सिद्दीक़" का लक़ब मिला जब उन्होंने फ़ौरन नबी ﷺ के मेराज की तस्दीक़ की। वे 63 साल की उम्र में वफ़ात पाए और मदीना में नबी ﷺ के पहलू में दफ़्न हैं।',
      'fatherName':
          'Abu Quhafa Uthman ibn Amir | ابو قحافہ عثمان بن عامر | अबू क़ुहाफ़ा उस्मान बिन आमिर',
      'motherName':
          'Salma bint Sakhar (Umm al-Khayr) | سلمیٰ بنت صخر (ام الخیر) | सलमा बिंत सख़र (उम्मुल ख़ैर)',
      'birthDate': '573 CE | ۵۷۳ عیسوی | 573 ईसवी',
      'birthPlace': 'Makkah | مکہ | मक्का',
      'deathDate':
          '23 August 634 CE (13 AH) | ۲۳ اگست ۶۳۴ عیسوی | 23 अगस्त 634 ईसवी',
      'deathPlace': 'Madinah | مدینہ | मदीना',
      'spouse':
          'Qutaylah bint Abd al-Uzza, Umm Ruman, Asma bint Umais, Habibah bint Kharijah | قتیلہ، ام رومان، اسماء بنت عمیس، حبیبہ | क़ुतैला, उम्मे रूमान, अस्मा बिंत उमैस, हबीबा',
      'children':
          'Abdur Rahman, Abdullah, Muhammad, Asma, Aisha, Umm Kulthum | عبدالرحمان، عبداللہ، محمد، اسماء، عائشہ، ام کلثوم | अब्दुर्रहमान, अब्दुल्लाह, मुहम्मद, अस्मा, आयशा, उम्मे कुलसूम',
      'tribe': 'Banu Taym (Quraysh) | بنو تیم (قریش) | बनू तैम (क़ुरैश)',
      'title':
          'As-Siddiq (The Truthful), Atiq | الصدیق، عتیق | अस-सिद्दीक़ (सच्चा), अतीक़',
      'era': 'First Caliph (632-634 CE) | پہلے خلیفہ | पहले ख़लीफ़ा',
      'knownFor':
          'Closest companion of Prophet, First adult male to accept Islam, Companion during Hijrah, Quran compilation, Ridda Wars | نبی کے قریب ترین ساتھی، پہلے بالغ مرد جنہوں نے اسلام قبول کیا، ہجرت میں ساتھی، قرآن کی تدوین، جنگ ردہ | नबी के सबसे क़रीबी साथी, पहले बालिग़ मर्द जिन्होंने इस्लाम क़बूल किया, हिजरत में साथी, क़ुरान की तदवीन, जंग-ए-रिद्दा',
    },
    {
      'name': 'عمر بن الخطاب',
      'transliteration': 'Umar ibn Al-Khattab',
      'meaning': 'Al-Farooq (The Distinguisher)',
      'meaningUrdu': 'الفاروق',
      'meaningHindi': 'अल-फ़ारूक़',
      'period': '634-644 CE',
      'description':
          'Umar (RA) was the second Caliph of Islam, ruling for about 10 years. Initially a fierce opponent of Islam, his conversion brought great strength to the Muslim community. During his caliphate, the Islamic empire expanded dramatically to include Egypt, Syria, Iraq, and Persia. He established many administrative systems including the Islamic calendar, treasury (Bayt al-Mal), and the welfare state. He was known for his justice - walking the streets at night to check on the welfare of his people. He conquered Jerusalem peacefully and refused to pray inside the Church of the Holy Sepulchre to protect Christian rights. He was martyred while leading Fajr prayer and is buried next to the Prophet ﷺ and Abu Bakr.',
      'descriptionUrdu':
          'حضرت عمر رضی اللہ عنہ اسلام کے دوسرے خلیفہ تھے، جنہوں نے تقریباً 10 سال حکومت کی۔ ابتدا میں اسلام کے سخت مخالف تھے لیکن ان کے قبول اسلام سے مسلم جماعت کو بہت تقویت ملی۔ ان کی خلافت میں اسلامی سلطنت نے مصر، شام، عراق اور فارس تک نمایاں توسیع حاصل کی۔ انہوں نے اسلامی کیلنڈر، بیت المال اور فلاحی ریاست سمیت کئی انتظامی نظام قائم کیے۔ وہ اپنے انصاف کے لیے مشہور تھے - رات کو گلیوں میں گھوم کر اپنے لوگوں کی فلاح کا جائزہ لیتے۔ انہوں نے یروشلم کو پرامن طریقے سے فتح کیا اور عیسائیوں کے حقوق کی حفاظت کے لیے چرچ میں نماز پڑھنے سے انکار کیا۔ وہ فجر کی نماز کی امامت کرتے ہوئے شہید ہوئے اور نبی ﷺ اور ابوبکر کے پہلو میں دفن ہیں۔',
      'descriptionHindi':
          'हज़रत उमर (रज़ि.) इस्लाम के दूसरे ख़लीफ़ा थे, जिन्होंने तक़रीबन 10 साल हुकूमत की। शुरू में इस्लाम के सख़्त मुख़ालिफ़ थे लेकिन उनके क़बूल-ए-इस्लाम से मुस्लिम जमाअत को बहुत ताक़त मिली। उनकी ख़िलाफ़त में इस्लामी सल्तनत ने मिस्र, शाम, इराक़ और फ़ारस तक नुमायां तौसी हासिल की। उन्होंने इस्लामी कैलेंडर, बैतुल माल और फ़लाही रियासत समेत कई इंतिज़ामी निज़ाम क़ायम किए। वे अपने इंसाफ़ के लिए मशहूर थे - रात को गलियों में घूमकर अपने लोगों की फ़लाह का जायज़ा लेते। उन्होंने येरुशलम को पुरअमन तरीक़े से फ़तह किया और ईसाइयों के हुक़ूक़ की हिफ़ाज़त के लिए चर्च में नमाज़ पढ़ने से इनकार किया। वे फ़ज्र की नमाज़ की इमामत करते हुए शहीद हुए और नबी ﷺ और अबू बक्र के पहलू में दफ़्न हैं।',
      'fatherName': 'Khattab ibn Nufayl | خطاب بن نفیل | ख़त्ताब बिन नुफ़ैल',
      'motherName': 'Hantamah bint Hashim | حنتمہ بنت ہاشم | हंतमा बिंत हाशिम',
      'birthDate': '584 CE | ۵۸۴ عیسوی | 584 ईसवी',
      'birthPlace': 'Makkah | مکہ | मक्का',
      'deathDate':
          '3 November 644 CE (26 Dhul Hijjah 23 AH) | ۳ نومبر ۶۴۴ عیسوی | 3 नवंबर 644 ईसवी',
      'deathPlace': 'Madinah (martyred) | مدینہ (شہید) | मदीना (शहीद)',
      'spouse':
          'Zaynab bint Mazun, Umm Kulthum bint Ali, and others | زینب بنت مظعون، ام کلثوم بنت علی اور دیگر | ज़ैनब बिंत मज़ऊन, उम्मे कुलसूम बिंत अली और अन्य',
      'children':
          'Abdullah, Hafsa, Abdur Rahman, Asim, Zayd, and others | عبداللہ، حفصہ، عبدالرحمان، عاصم، زید اور دیگر | अब्दुल्लाह, हफ़्सा, अब्दुर्रहमान, आसिम, ज़ैद और अन्य',
      'tribe': 'Banu Adi (Quraysh) | بنو عدی (قریش) | बनू अदी (क़ुरैश)',
      'title':
          'Al-Farooq (The Distinguisher), Amir al-Mu\'minin | الفاروق، امیر المومنین | अल-फ़ारूक़ (फ़र्क़ करने वाला), अमीरुल मोमिनीन',
      'era': 'Second Caliph (634-644 CE) | دوسرے خلیفہ | दूसरे ख़लीफ़ा',
      'knownFor':
          'Established Islamic calendar, Bayt al-Mal (Treasury), Conquest of Jerusalem, Justice and welfare state | اسلامی کیلنڈر، بیت المال، فتح یروشلم، عدل و فلاحی ریاست | इस्लामी कैलेंडर, बैतुल माल, फ़तह येरुशलम, इंसाफ़ और फ़लाही रियासत',
    },
    {
      'name': 'عثمان بن عفان',
      'transliteration': 'Uthman ibn Affan',
      'meaning': 'Dhun-Nurayn (Possessor of Two Lights)',
      'meaningUrdu': 'ذوالنورین',
      'meaningHindi': 'ज़ुन्नूरैन',
      'period': '644-656 CE',
      'description':
          'Uthman (RA) was the third Caliph of Islam, ruling for about 12 years. He was called Dhun-Nurayn because he married two daughters of the Prophet ﷺ - Ruqayyah and then Umm Kulthum. His greatest achievement was standardizing the Quran into one official text, sending copies to all major cities. He expanded the Prophet\'s Mosque in Madinah and built the first Muslim naval fleet. He was known for his modesty, generosity, and gentleness. During his caliphate, the empire expanded to include parts of North Africa and Central Asia. He was martyred in his home while reading the Quran during a period of political unrest. The Quran he was reading is preserved in museums today.',
      'descriptionUrdu':
          'حضرت عثمان رضی اللہ عنہ اسلام کے تیسرے خلیفہ تھے، جنہوں نے تقریباً 12 سال حکومت کی۔ انہیں ذوالنورین کہا جاتا تھا کیونکہ انہوں نے نبی ﷺ کی دو بیٹیوں - رقیہ اور پھر ام کلثوم سے شادی کی۔ ان کا سب سے بڑا کارنامہ قرآن کو ایک سرکاری متن میں معیاری بنانا تھا، جس کی نقلیں تمام بڑے شہروں کو بھیجی گئیں۔ انہوں نے مدینہ میں مسجد نبوی کی توسیع کی اور پہلا مسلم بحری بیڑا بنایا۔ وہ اپنی حیا، سخاوت اور نرم مزاجی کے لیے مشہور تھے۔ ان کی خلافت میں سلطنت نے شمالی افریقہ اور وسطی ایشیا کے کچھ حصوں تک توسیع کی۔ وہ سیاسی بدامنی کے دوران اپنے گھر میں قرآن پڑھتے ہوئے شہید ہوئے۔ جو قرآن وہ پڑھ رہے تھے وہ آج عجائب گھروں میں محفوظ ہے۔',
      'descriptionHindi':
          'हज़रत उस्मान (रज़ि.) इस्लाम के तीसरे ख़लीफ़ा थे, जिन्होंने तक़रीबन 12 साल हुकूमत की। उन्हें ज़ुन्नूरैन कहा जाता था क्योंकि उन्होंने नबी ﷺ की दो बेटियों - रुक़य्या और फिर उम्मे कुलसूम से शादी की। उनका सबसे बड़ा कारनामा क़ुरान को एक सरकारी मतन में मेयारी बनाना था, जिसकी नक़लें तमाम बड़े शहरों को भेजी गईं। उन्होंने मदीना में मस्जिद-ए-नबवी की तौसी की और पहला मुस्लिम बहरी बेड़ा बनाया। वे अपनी हया, सख़ावत और नर्म मिज़ाजी के लिए मशहूर थे। उनकी ख़िलाफ़त में सल्तनत ने शुमाली अफ़्रीक़ा और वुस्ती एशिया के कुछ हिस्सों तक तौसी की। वे सियासी बदअमनी के दौरान अपने घर में क़ुरान पढ़ते हुए शहीद हुए। जो क़ुरान वे पढ़ रहे थे वो आज अजायबघरों में महफ़ूज़ है।',
      'fatherName':
          'Affan ibn Abi al-As | عفان بن ابی العاص | अफ़्फ़ान बिन अबिल आस',
      'motherName': 'Arwa bint Kurayz | اروی بنت کریز | अरवा बिंत कुरैज़',
      'birthDate': '576 CE | ۵۷۶ عیسوی | 576 ईसवी',
      'birthPlace': 'Ta\'if | طائف | ताइफ़',
      'deathDate':
          '17 June 656 CE (18 Dhul Hijjah 35 AH) | ۱۷ جون ۶۵۶ عیسوی | 17 जून 656 ईसवी',
      'deathPlace': 'Madinah (martyred) | مدینہ (شہید) | मदीना (शहीद)',
      'spouse':
          'Ruqayyah bint Muhammad ﷺ, Umm Kulthum bint Muhammad ﷺ, and others | رقیہ بنت محمد ﷺ، ام کلثوم بنت محمد ﷺ اور دیگر | रुक़य्या बिंत मुहम्मद ﷺ, उम्मे कुलसूम बिंत मुहम्मद ﷺ और अन्य',
      'children':
          'Abdullah, Amr, Aban, Umar, Maryam, and others | عبداللہ، عمرو، ابان، عمر، مریم اور دیگر | अब्दुल्लाह, अम्र, अबान, उमर, मरयम और अन्य',
      'tribe': 'Banu Umayya (Quraysh) | بنو امیہ (قریش) | बनू उमय्या (क़ुरैश)',
      'title':
          'Dhun-Nurayn (Possessor of Two Lights) | ذوالنورین (دو نوروں والا) | ज़ुन्नूरैन (दो नूरों वाले)',
      'era': 'Third Caliph (644-656 CE) | تیسرے خلیفہ | तीसरे ख़लीफ़ा',
      'knownFor':
          'Standardization of Quran, Expansion of Masjid Nabawi, First Muslim naval fleet, Known for modesty and generosity | قرآن کی معیار بندی، مسجد نبوی کی توسیع، پہلا بحری بیڑا، حیا اور سخاوت | क़ुरान की मेयारबंदी, मस्जिद-ए-नबवी की तौसी, पहला बहरी बेड़ा, हया और सख़ावत',
    },
    {
      'name': 'علي بن أبي طالب',
      'transliteration': 'Ali ibn Abi Talib',
      'meaning': 'Asadullah (Lion of Allah)',
      'meaningUrdu': 'اسد اللہ',
      'meaningHindi': 'असदुल्लाह',
      'period': '656-661 CE',
      'description':
          'Ali (RA) was the fourth and last of the Rightly Guided Caliphs, ruling for about 5 years. He was the cousin and son-in-law of the Prophet ﷺ, married to Fatimah (RA). He was among the first to accept Islam and was known for his exceptional bravery, wisdom, and knowledge. The Prophet said "I am the city of knowledge and Ali is its gate." During his caliphate, he faced internal conflicts including the battles of Jamal and Siffin. He moved the capital to Kufa and was known for his eloquent sermons and judgments. He was martyred while praying Fajr in the mosque of Kufa. His sayings and sermons are compiled in "Nahj al-Balagha" (Peak of Eloquence), considered a masterpiece of Arabic literature.',
      'descriptionUrdu':
          'حضرت علی رضی اللہ عنہ خلفائے راشدین میں چوتھے اور آخری خلیفہ تھے، جنہوں نے تقریباً 5 سال حکومت کی۔ وہ نبی ﷺ کے چچا زاد بھائی اور داماد تھے، فاطمہ (رض) سے شادی شدہ۔ وہ اسلام قبول کرنے والوں میں سب سے پہلے تھے اور اپنی غیر معمولی بہادری، حکمت اور علم کے لیے مشہور تھے۔ نبی ﷺ نے فرمایا "میں علم کا شہر ہوں اور علی اس کا دروازہ ہے۔" ان کی خلافت میں انہیں داخلی تنازعات کا سامنا کرنا پڑا جن میں جنگ جمل اور صفین شامل ہیں۔ انہوں نے دارالحکومت کوفہ منتقل کیا اور اپنے فصیح خطبات اور فیصلوں کے لیے مشہور تھے۔ وہ کوفہ کی مسجد میں فجر کی نماز پڑھتے ہوئے شہید ہوئے۔ ان کے اقوال اور خطبات "نہج البلاغہ" میں مرتب ہیں جو عربی ادب کا شاہکار ہے۔',
      'descriptionHindi':
          'हज़रत अली (रज़ि.) ख़ुलफ़ा-ए-राशिदीन में चौथे और आख़िरी ख़लीफ़ा थे, जिन्होंने तक़रीबन 5 साल हुकूमत की। वे नबी ﷺ के चचाज़ाद भाई और दामाद थे, फ़ातिमा (रज़ि.) से शादीशुदा। वे इस्लाम क़बूल करने वालों में सबसे पहले थे और अपनी ग़ैर-मामूली बहादुरी, हिकमत और इल्म के लिए मशहूर थे। नबी ﷺ ने फ़रमाया "मैं इल्म का शहर हूं और अली इसका दरवाज़ा है।" उनकी ख़िलाफ़त में उन्हें दाख़िली तनाज़ात का सामना करना पड़ा जिनमें जंग-ए-जमल और सिफ़्फ़ीन शामिल हैं। उन्होंने दारुलहुकूमत कूफ़ा मुंतक़िल किया और अपने फ़सीह ख़ुत्बात और फ़ैसलों के लिए मशहूर थे। वे कूफ़ा की मस्जिद में फ़ज्र की नमाज़ पढ़ते हुए शहीद हुए। उनके अक़वाल और ख़ुत्बात "नहजुल बलाग़ा" में मुरत्तब हैं जो अरबी अदब का शाहकार है।',
      'fatherName':
          'Abu Talib ibn Abd al-Muttalib | ابو طالب بن عبدالمطلب | अबू तालिब बिन अब्दुल मुत्तलिब',
      'motherName': 'Fatimah bint Asad | فاطمہ بنت اسد | फ़ातिमा बिंत असद',
      'birthDate':
          '13 Rajab 601 CE (inside the Ka\'bah) | ۱۳ رجب ۶۰۱ عیسوی (کعبہ میں) | 13 रजब 601 ईसवी (काबा में)',
      'birthPlace':
          'Makkah (inside the Ka\'bah) | مکہ (کعبہ کے اندر) | मक्का (काबा के अंदर)',
      'deathDate':
          '28 January 661 CE (21 Ramadan 40 AH) | ۲۸ جنوری ۶۶۱ عیسوی | 28 जनवरी 661 ईसवी',
      'deathPlace': 'Kufa (martyred) | کوفہ (شہید) | कूफ़ा (शहीद)',
      'spouse':
          'Fatimah bint Muhammad ﷺ (primary), and others | فاطمہ بنت محمد ﷺ (اولین) اور دیگر | फ़ातिमा बिंत मुहम्मद ﷺ (प्राथमिक) और अन्य',
      'children':
          'Hasan, Husayn, Zaynab, Umm Kulthum, Abbas, and others | حسن، حسین، زینب، ام کلثوم، عباس اور دیگر | हसन, हुसैन, ज़ैनब, उम्मे कुलसूम, अब्बास और अन्य',
      'tribe': 'Banu Hashim (Quraysh) | بنو ہاشم (قریش) | बनू हाशिम (क़ुरैश)',
      'title':
          'Asadullah (Lion of Allah), Amir al-Mu\'minin, Murtaza, Haydar | اسد اللہ، امیر المومنین، مرتضیٰ، حیدر | असदुल्लाह (अल्लाह का शेर), अमीरुल मोमिनीन, मुर्तज़ा, हैदर',
      'era': 'Fourth Caliph (656-661 CE) | چوتھے خلیفہ | चौथे ख़लीफ़ा',
      'knownFor':
          'First male child to accept Islam, Gate of Knowledge, Nahj al-Balagha, Bravery in battles | پہلے بچے جنہوں نے اسلام قبول کیا، باب العلم، نہج البلاغہ، جنگوں میں بہادری | पहले बच्चे जिन्होंने इस्लाम क़बूल किया, बाबुल इल्म, नहजुल बलाग़ा, जंगों में बहादुरी',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Khulafa-e-Rashideen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _khalifaNames.length,
              itemBuilder: (context, index) {
                return _buildNameCard(_khalifaNames[index], index + 1, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard(Map<String, dynamic> name, int index, bool isDark) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const softGold = Color(0xFFC9A24D);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IslamicNameDetailScreen(
              arabicName: name['name']!,
              transliteration: name['transliteration']!,
              meaning: '${name['meaning']!} (${name['period']!})',
              meaningUrdu: '${name['meaningUrdu']!} (${name['period']!})',
              meaningHindi: '${name['meaningHindi']!} (${name['period']!})',
              description: name['description']!,
              descriptionUrdu: name['descriptionUrdu'] ?? '',
              descriptionHindi: name['descriptionHindi'] ?? '',
              category: 'Rightly Guided Caliph',
              number: index,
              icon: Icons.account_balance,
              color: Colors.orange,
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : lightGreenBorder,
            width: 1.5,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: darkGreen.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? emeraldGreen : darkGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? emeraldGreen : darkGreen).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name['transliteration']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name['meaning']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : emeraldGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name['name']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Amiri',
                          color: isDark ? AppColors.secondary : softGold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : emeraldGreen,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade800
                      : const Color(0xFFE8F3ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : emeraldGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Period: ${name['period']!}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : emeraldGreen,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Tap for details',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
