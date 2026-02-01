import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'islamic_name_detail_screen.dart';

class TwelveImamsScreen extends StatefulWidget {
  const TwelveImamsScreen({super.key});

  @override
  State<TwelveImamsScreen> createState() => _TwelveImamsScreenState();
}

class _TwelveImamsScreenState extends State<TwelveImamsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredNames = [];

  final List<Map<String, dynamic>> _imamNames = [
    {
      'name': 'علي بن أبي طالب',
      'transliteration': 'Ali ibn Abi Talib',
      'title': 'Amir al-Mu\'minin',
      'titleUrdu': 'امیر المومنین',
      'titleHindi': 'अमीरुल मोमिनीन',
      'kunya': 'Abu al-Hasan',
      'kunyaUrdu': 'ابو الحسن',
      'kunyaHindi': 'अबू अल-हसन',
      'description':
          'Imam Ali (AS) was the cousin and son-in-law of Prophet Muhammad ﷺ, married to Fatimah Az-Zahra. He was the first male to accept Islam and was known as Asadullah (Lion of Allah) for his bravery. The Prophet said "I am the city of knowledge and Ali is its gate." He was the fourth Caliph and is renowned for his wisdom, justice, eloquence, and piety. His sermons are compiled in Nahj al-Balagha.',
      'descriptionUrdu':
          'امام علی علیہ السلام نبی محمد ﷺ کے چچا زاد بھائی اور داماد تھے، فاطمہ زہرا سے شادی شدہ۔ وہ اسلام قبول کرنے والے پہلے مرد تھے اور اپنی بہادری کی وجہ سے اسد اللہ (اللہ کا شیر) کے نام سے مشہور تھے۔ نبی ﷺ نے فرمایا "میں علم کا شہر ہوں اور علی اس کا دروازہ ہے۔" وہ چوتھے خلیفہ تھے اور اپنی حکمت، انصاف، فصاحت اور تقویٰ کے لیے مشہور ہیں۔ ان کے خطبات نہج البلاغہ میں مرتب ہیں۔',
      'descriptionHindi':
          'इमाम अली (अ.स.) नबी मुहम्मद ﷺ के चचाज़ाद भाई और दामाद थे, फ़ातिमा ज़हरा से शादीशुदा। वे इस्लाम क़बूल करने वाले पहले मर्द थे और अपनी बहादुरी की वजह से असदुल्लाह (अल्लाह का शेर) के नाम से मशहूर थे। नबी ﷺ ने फ़रमाया "मैं इल्म का शहर हूं और अली इसका दरवाज़ा है।" वे चौथे ख़लीफ़ा थे और अपनी हिकमत, इंसाफ़, फ़साहत और तक़वा के लिए मशहूर हैं। उनके ख़ुत्बात नहजुल बलाग़ा में मुरत्तब हैं।',
      'fatherName': 'Abu Talib ibn Abd al-Muttalib',
      'motherName': 'Fatimah bint Asad',
      'birthDate': '13 Rajab, 30 BH (600 CE)',
      'birthPlace': 'Inside the Kaaba, Makkah',
      'deathDate': '21 Ramadan, 40 AH (661 CE)',
      'deathPlace': 'Kufa, Iraq (Martyred)',
      'spouse': 'Fatimah bint Muhammad',
      'children': 'Hasan, Husayn, Zaynab, Umm Kulthum',
      'era': '656-661 CE (Caliphate)',
      'knownFor': 'First Imam, Fourth Caliph, Lion of Allah',
    },
    {
      'name': 'الحسن بن علي',
      'transliteration': 'Hasan ibn Ali',
      'title': 'Al-Mujtaba (The Chosen)',
      'titleUrdu': 'المجتبیٰ (منتخب)',
      'titleHindi': 'अल-मुजतबा (चुना हुआ)',
      'kunya': 'Abu Muhammad',
      'kunyaUrdu': 'ابو محمد',
      'kunyaHindi': 'अबू मुहम्मद',
      'description':
          'Imam Hasan (AS) was the elder grandson of Prophet Muhammad ﷺ and son of Ali and Fatimah. The Prophet called him and his brother "leaders of the youth of Paradise." He was known for his generosity, piety, and resemblance to the Prophet. He made peace with Muawiyah to prevent Muslim bloodshed, fulfilling a prophecy of the Prophet about him bringing peace between two groups.',
      'descriptionUrdu':
          'امام حسن علیہ السلام نبی محمد ﷺ کے بڑے نواسے اور علی و فاطمہ کے بیٹے تھے۔ نبی ﷺ نے انہیں اور ان کے بھائی کو "جنت کے نوجوانوں کے سردار" کہا۔ وہ اپنی سخاوت، تقویٰ اور نبی ﷺ سے مشابہت کے لیے مشہور تھے۔ انہوں نے مسلمانوں کے خون بہانے سے بچنے کے لیے معاویہ سے صلح کی، جو نبی ﷺ کی پیشگوئی کی تکمیل تھی کہ ان کے ذریعے دو گروہوں میں صلح ہوگی۔',
      'descriptionHindi':
          'इमाम हसन (अ.स.) नबी मुहम्मद ﷺ के बड़े नवासे और अली व फ़ातिमा के बेटे थे। नबी ﷺ ने उन्हें और उनके भाई को "जन्नत के नौजवानों के सरदार" कहा। वे अपनी सख़ावत, तक़वा और नबी ﷺ से मुशाबिहत के लिए मशहूर थे। उन्होंने मुसलमानों का ख़ून बहाने से बचने के लिए मुआविया से सुलह की, जो नबी ﷺ की पेशगोई की तकमील थी कि उनके ज़रिए दो गिरोहों में सुलह होगी।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '15 Ramadan, 3 AH (625 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '28 Safar, 50 AH (670 CE)',
      'deathPlace': 'Madinah (Poisoned)',
      'spouse': 'Ja\'da bint al-Ash\'ath',
      'children': 'Zayd, Hasan, Qasim',
      'era': '3-50 AH',
      'knownFor': 'Second Imam, Peace Maker, Leader of Youth of Paradise',
    },
    {
      'name': 'الحسين بن علي',
      'transliteration': 'Husayn ibn Ali',
      'title': 'Sayyid al-Shuhada (Master of Martyrs)',
      'titleUrdu': 'سید الشہداء',
      'titleHindi': 'सय्यिदुश्शुहदा',
      'kunya': 'Abu Abdullah',
      'kunyaUrdu': 'ابو عبداللہ',
      'kunyaHindi': 'अबू अब्दुल्लाह',
      'description':
          'Imam Husayn (AS) was the younger grandson of Prophet Muhammad ﷺ. The Prophet said "Husayn is from me and I am from Husayn." He stood against tyranny at Karbala in 680 CE, refusing to give allegiance to Yazid. He and 72 companions were martyred on the 10th of Muharram (Ashura). His sacrifice is commemorated as a symbol of standing for truth against oppression.',
      'descriptionUrdu':
          'امام حسین علیہ السلام نبی محمد ﷺ کے چھوٹے نواسے تھے۔ نبی ﷺ نے فرمایا "حسین مجھ سے ہے اور میں حسین سے ہوں۔" انہوں نے 680 عیسوی میں کربلا میں ظلم کے خلاف کھڑے ہوکر یزید کی بیعت سے انکار کیا۔ وہ اور 72 ساتھی 10 محرم (عاشورہ) کو شہید ہوئے۔ ان کی قربانی حق کے لیے ظلم کے خلاف کھڑے ہونے کی علامت کے طور پر یاد کی جاتی ہے۔',
      'descriptionHindi':
          'इमाम हुसैन (अ.स.) नबी मुहम्मद ﷺ के छोटे नवासे थे। नबी ﷺ ने फ़रमाया "हुसैन मुझसे है और मैं हुसैन से हूं।" उन्होंने 680 ई. में कर्बला में ज़ुल्म के ख़िलाफ़ खड़े होकर यज़ीद की बैअत से इनकार किया। वे और 72 साथी 10 मुहर्रम (आशूरा) को शहीद हुए। उनकी क़ुर्बानी हक़ के लिए ज़ुल्म के ख़िलाफ़ खड़े होने की निशानी के तौर पर याद की जाती है।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '3 Sha\'ban, 4 AH (626 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '10 Muharram, 61 AH (680 CE)',
      'deathPlace': 'Karbala, Iraq (Martyred)',
      'spouse': 'Shahrbanu, Rabab, Layla',
      'children': 'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah',
      'era': '4-61 AH',
      'knownFor': 'Third Imam, Master of Martyrs, Hero of Karbala',
    },
    {
      'name': 'علي بن الحسين',
      'transliteration': 'Ali ibn Husayn',
      'title': 'Zayn al-Abidin (Ornament of Worshippers)',
      'titleUrdu': 'زین العابدین (عبادت گزاروں کا زیور)',
      'titleHindi': 'ज़ैनुल आबिदीन (इबादत करने वालों का ज़ेवर)',
      'kunya': 'Abu Muhammad',
      'kunyaUrdu': 'ابو محمد',
      'kunyaHindi': 'अबू मुहम्मद',
      'description':
          'Imam Zayn al-Abidin (AS) was the son of Husayn and survived Karbala due to illness. He was known for his exceptional worship, often called "Sajjad" (the one who prostrates much). He spent nights in prayer and was extremely generous to the poor, secretly delivering food at night. His supplications are compiled in "Sahifa Sajjadiyya," considered a masterpiece of Islamic spirituality.',
      'descriptionUrdu':
          'امام زین العابدین علیہ السلام امام حسین کے بیٹے تھے اور بیماری کی وجہ سے کربلا سے بچ گئے۔ وہ اپنی غیر معمولی عبادت کے لیے مشہور تھے، اکثر "سجاد" (بہت زیادہ سجدہ کرنے والے) کہلاتے تھے۔ وہ راتیں نماز میں گزارتے اور غریبوں کے ساتھ انتہائی سخی تھے، رات کو چپکے سے کھانا پہنچاتے۔ ان کی دعائیں "صحیفہ سجادیہ" میں جمع ہیں جو اسلامی روحانیت کا شاہکار سمجھی جاتی ہے۔',
      'descriptionHindi':
          'इमाम ज़ैनुल आबिदीन (अ.स.) इमाम हुसैन के बेटे थे और बीमारी की वजह से कर्बला से बच गए। वे अपनी ग़ैरमामूली इबादत के लिए मशहूर थे, अक्सर "सज्जाद" (बहुत ज़्यादा सजदा करने वाले) कहलाते थे। वे रातें नमाज़ में गुज़ारते और ग़रीबों के साथ बेहद सख़ी थे, रात को चुपके से खाना पहुंचाते। उनकी दुआएं "सहीफ़ा सज्जादिया" में जमा हैं जो इस्लामी रूहानियत का शाहकार मानी जाती है।',
      'fatherName': 'Husayn ibn Ali',
      'motherName': 'Shahrbanu (Persian Princess)',
      'birthDate': '5 Sha\'ban, 38 AH (659 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '25 Muharram, 95 AH (713 CE)',
      'deathPlace': 'Madinah (Poisoned)',
      'spouse': 'Fatimah bint Hasan',
      'children': 'Muhammad al-Baqir, Zayd, and others',
      'era': '61-95 AH',
      'knownFor': 'Fourth Imam, Sahifa Sajjadiyya, Sajjad (One who prostrates)',
    },
    {
      'name': 'محمد بن علي',
      'transliteration': 'Muhammad ibn Ali',
      'title': 'Al-Baqir (The Splitter of Knowledge)',
      'titleUrdu': 'الباقر (علم کو کھولنے والے)',
      'titleHindi': 'अल-बाक़िर (इल्म को खोलने वाले)',
      'kunya': 'Abu Ja\'far',
      'kunyaUrdu': 'ابو جعفر',
      'kunyaHindi': 'अबू जाफ़र',
      'description':
          'Imam Muhammad al-Baqir (AS) was given his title because he "split open" knowledge - making it accessible. He was a great scholar who taught many students including the founders of Islamic schools of thought. He explained complex theological and legal matters and is credited with establishing many principles of Islamic jurisprudence. His teachings spread far and wide during a relatively peaceful period.',
      'descriptionUrdu':
          'امام محمد باقر علیہ السلام کو یہ لقب اس لیے دیا گیا کیونکہ انہوں نے علم کو "کھول" کر قابل رسائی بنایا۔ وہ ایک عظیم عالم تھے جنہوں نے بہت سے شاگردوں کو پڑھایا جن میں اسلامی مکاتب فکر کے بانی بھی شامل تھے۔ انہوں نے پیچیدہ کلامی اور فقہی مسائل کی وضاحت کی اور اسلامی فقہ کے بہت سے اصول قائم کرنے کا سہرا انہیں جاتا ہے۔ ان کی تعلیمات نسبتاً پرامن دور میں دور دور تک پھیلیں۔',
      'descriptionHindi':
          'इमाम मुहम्मद बाक़िर (अ.स.) को यह लक़ब इसलिए दिया गया क्योंकि उन्होंने इल्म को "खोल" कर सुलभ बनाया। वे एक अज़ीम आलिम थे जिन्होंने बहुत से शागिर्दों को पढ़ाया जिनमें इस्लामी मकातिब-ए-फ़िक्र के बानी भी शामिल थे। उन्होंने पेचीदा कलामी और फ़िक़्ही मसाइल की वज़ाहत की और इस्लामी फ़िक़्ह के बहुत से उसूल क़ायम करने का सेहरा उन्हें जाता है। उनकी तालीमात निस्बतन पुरअमन दौर में दूर-दूर तक फैलीं।',
      'fatherName': 'Ali Zayn al-Abidin',
      'motherName': 'Fatimah bint Hasan',
      'birthDate': '1 Rajab, 57 AH (677 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '7 Dhu al-Hijjah, 114 AH (733 CE)',
      'deathPlace': 'Madinah (Poisoned)',
      'spouse': 'Umm Farwa bint al-Qasim',
      'children': 'Ja\'far al-Sadiq, Abdullah, Ibrahim',
      'era': '95-114 AH',
      'knownFor': 'Fifth Imam, Baqir al-Ulum (Splitter of Knowledge)',
    },
    {
      'name': 'جعفر بن محمد',
      'transliteration': 'Ja\'far ibn Muhammad',
      'title': 'Al-Sadiq (The Truthful)',
      'titleUrdu': 'الصادق (سچے)',
      'titleHindi': 'अस-सादिक़ (सच्चे)',
      'kunya': 'Abu Abdullah',
      'kunyaUrdu': 'ابو عبداللہ',
      'kunyaHindi': 'अबू अब्दुल्लाह',
      'description':
          'Imam Ja\'far al-Sadiq (AS) was one of the most influential Islamic scholars. He taught thousands of students including Abu Hanifa and Malik ibn Anas (founders of Sunni schools). He made significant contributions to theology, jurisprudence, and sciences including chemistry. The Ja\'fari school of jurisprudence is named after him. He lived during a transition period between Umayyad and Abbasid rule.',
      'descriptionUrdu':
          'امام جعفر صادق علیہ السلام سب سے بااثر اسلامی علماء میں سے تھے۔ انہوں نے ہزاروں شاگردوں کو پڑھایا جن میں ابو حنیفہ اور مالک بن انس (سنی مکاتب کے بانی) شامل تھے۔ انہوں نے کلام، فقہ اور علوم بشمول کیمیا میں اہم کردار ادا کیا۔ جعفری فقہ ان کے نام سے موسوم ہے۔ وہ اموی اور عباسی دور کے درمیان منتقلی کے زمانے میں رہے۔',
      'descriptionHindi':
          'इमाम जाफ़र सादिक़ (अ.स.) सबसे प्रभावशाली इस्लामी उलमा में से थे। उन्होंने हज़ारों शागिर्दों को पढ़ाया जिनमें अबू हनीफ़ा और मालिक बिन अनस (सुन्नी मकातिब के बानी) शामिल थे। उन्होंने कलाम, फ़िक़्ह और उलूम बशमूल केमिस्ट्री में अहम किरदार अदा किया। जाफ़री फ़िक़्ह उनके नाम से मौसूम है। वे उमवी और अब्बासी दौर के बीच मुंतक़िली के ज़माने में रहे।',
      'fatherName': 'Muhammad al-Baqir',
      'motherName': 'Umm Farwa bint al-Qasim',
      'birthDate': '17 Rabi al-Awwal, 83 AH (702 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '25 Shawwal, 148 AH (765 CE)',
      'deathPlace': 'Madinah (Poisoned)',
      'spouse': 'Hamida Khatun, Fatimah',
      'children': 'Musa al-Kazim, Ismail, Muhammad, Ali',
      'era': '114-148 AH',
      'knownFor':
          'Sixth Imam, Ja\'fari School of Jurisprudence, Teacher of thousands',
    },
    {
      'name': 'موسى بن جعفر',
      'transliteration': 'Musa ibn Ja\'far',
      'title': 'Al-Kazim (The One Who Suppresses Anger)',
      'titleUrdu': 'الکاظم (غصہ پینے والے)',
      'titleHindi': 'अल-काज़िम (ग़ुस्सा पीने वाले)',
      'kunya': 'Abu al-Hasan',
      'kunyaUrdu': 'ابو الحسن',
      'kunyaHindi': 'अबू अल-हसन',
      'description':
          'Imam Musa al-Kazim (AS) was known for his patience, forbearance, and suppression of anger, hence his title. He spent many years imprisoned by the Abbasid caliphs but continued teaching. He was known for his night prayers and charitable acts. He would secretly help the poor of Madinah. He was poisoned in prison in Baghdad and is buried in Kadhimiya.',
      'descriptionUrdu':
          'امام موسیٰ کاظم علیہ السلام اپنے صبر، بردباری اور غصہ دبانے کے لیے مشہور تھے، اسی لیے یہ لقب ملا۔ انہوں نے کئی سال عباسی خلفاء کی قید میں گزارے لیکن تعلیم جاری رکھی۔ وہ اپنی رات کی نمازوں اور خیراتی کاموں کے لیے مشہور تھے۔ وہ چپکے سے مدینہ کے غریبوں کی مدد کرتے۔ انہیں بغداد کی جیل میں زہر دیا گیا اور وہ کاظمیہ میں مدفون ہیں۔',
      'descriptionHindi':
          'इमाम मूसा काज़िम (अ.स.) अपने सब्र, बुर्दबारी और ग़ुस्सा दबाने के लिए मशहूर थे, इसीलिए यह लक़ब मिला। उन्होंने कई साल अब्बासी ख़ुलफ़ा की क़ैद में गुज़ारे लेकिन तालीम जारी रखी। वे अपनी रात की नमाज़ों और ख़ैराती कामों के लिए मशहूर थे। वे चुपके से मदीना के ग़रीबों की मदद करते। उन्हें बग़दाद की जेल में ज़हर दिया गया और वे काज़िमिया में मदफ़ून हैं।',
      'fatherName': 'Ja\'far al-Sadiq',
      'motherName': 'Hamida Khatun',
      'birthDate': '7 Safar, 128 AH (745 CE)',
      'birthPlace': 'Abwa, Arabia (between Makkah and Madinah)',
      'deathDate': '25 Rajab, 183 AH (799 CE)',
      'deathPlace': 'Baghdad, Iraq (Poisoned in prison)',
      'spouse': 'Najmah (Tuktam)',
      'children': 'Ali al-Rida, Ibrahim, Abbas, and others',
      'era': '148-183 AH',
      'knownFor': 'Seventh Imam, Bab al-Hawaij (Gate of Fulfilling Needs)',
    },
    {
      'name': 'علي بن موسى',
      'transliteration': 'Ali ibn Musa',
      'title': 'Al-Rida (The Pleasing One)',
      'titleUrdu': 'الرضا (پسندیدہ)',
      'titleHindi': 'अर-रिज़ा (पसंदीदा)',
      'kunya': 'Abu al-Hasan',
      'kunyaUrdu': 'ابو الحسن',
      'kunyaHindi': 'अबू अल-हसन',
      'description':
          'Imam Ali al-Rida (AS) was appointed as heir to Caliph Ma\'mun but was poisoned before ascending. He was known for his debates with scholars of different religions and his vast knowledge. He authored works on medicine and jurisprudence. His shrine in Mashhad, Iran is one of the largest in the world and visited by millions annually. He is known for his kindness and wisdom.',
      'descriptionUrdu':
          'امام علی رضا علیہ السلام کو خلیفہ مامون کا ولی عہد مقرر کیا گیا لیکن مسند پر بیٹھنے سے پہلے انہیں زہر دیا گیا۔ وہ مختلف مذاہب کے علماء سے مناظروں اور اپنے وسیع علم کے لیے مشہور تھے۔ انہوں نے طب اور فقہ پر تصانیف لکھیں۔ ان کا مزار مشہد، ایران میں دنیا کے سب سے بڑے مزارات میں سے ہے جہاں سالانہ لاکھوں زائرین آتے ہیں۔ وہ اپنی مہربانی اور حکمت کے لیے مشہور ہیں۔',
      'descriptionHindi':
          'इमाम अली रिज़ा (अ.स.) को ख़लीफ़ा मामून का वलीअहद मुक़र्रर किया गया लेकिन मसनद पर बैठने से पहले उन्हें ज़हर दिया गया। वे मुख़्तलिफ़ मज़ाहिब के उलमा से मुनाज़िरों और अपने वसी इल्म के लिए मशहूर थे। उन्होंने तिब और फ़िक़्ह पर तसानीफ़ लिखीं। उनका मज़ार मशहद, ईरान में दुनिया के सबसे बड़े मज़ारात में से है जहां सालाना लाखों ज़ाइरीन आते हैं। वे अपनी मेहरबानी और हिकमत के लिए मशहूर हैं।',
      'fatherName': 'Musa al-Kazim',
      'motherName': 'Najmah (Tuktam)',
      'birthDate': '11 Dhu al-Qi\'dah, 148 AH (765 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '17 Safar, 203 AH (818 CE)',
      'deathPlace': 'Tus (Mashhad), Iran (Poisoned)',
      'spouse': 'Sabikah (granddaughter of Ma\'mun)',
      'children': 'Muhammad al-Jawad',
      'era': '183-203 AH',
      'knownFor': 'Eighth Imam, Shrine in Mashhad, Heir to Caliphate',
    },
    {
      'name': 'محمد بن علي',
      'transliteration': 'Muhammad ibn Ali',
      'title': 'Al-Jawad (The Generous)',
      'titleUrdu': 'الجواد (سخی)',
      'titleHindi': 'अल-जवाद (सख़ी)',
      'kunya': 'Abu Ja\'far',
      'kunyaUrdu': 'ابو جعفر',
      'kunyaHindi': 'अबू जाफ़र',
      'description':
          'Imam Muhammad al-Jawad (AS) became Imam at age 7, the youngest of the Imams. Despite his young age, he displayed remarkable knowledge, debating scholars in Ma\'mun\'s court. He was known for his generosity, giving away whatever he had. He married Ma\'mun\'s daughter but was later poisoned in Baghdad at age 25. He is buried near his grandfather in Kadhimiya.',
      'descriptionUrdu':
          'امام محمد جواد علیہ السلام 7 سال کی عمر میں امام بنے، تمام ائمہ میں سب سے کم عمر۔ کم عمری کے باوجود انہوں نے غیر معمولی علم کا مظاہرہ کیا، مامون کے دربار میں علماء سے مناظرے کیے۔ وہ اپنی سخاوت کے لیے مشہور تھے، جو کچھ ان کے پاس ہوتا دے دیتے۔ انہوں نے مامون کی بیٹی سے شادی کی لیکن بعد میں 25 سال کی عمر میں بغداد میں انہیں زہر دیا گیا۔ وہ اپنے دادا کے قریب کاظمیہ میں مدفون ہیں۔',
      'descriptionHindi':
          'इमाम मुहम्मद जवाद (अ.स.) 7 साल की उम्र में इमाम बने, तमाम आइम्मा में सबसे कम उम्र। कम उम्री के बावजूद उन्होंने ग़ैरमामूली इल्म का मुज़ाहिरा किया, मामून के दरबार में उलमा से मुनाज़िरे किए। वे अपनी सख़ावत के लिए मशहूर थे, जो कुछ उनके पास होता दे देते। उन्होंने मामून की बेटी से शादी की लेकिन बाद में 25 साल की उम्र में बग़दाद में उन्हें ज़हर दिया गया। वे अपने दादा के क़रीब काज़िमिया में मदफ़ून हैं।',
      'fatherName': 'Ali al-Rida',
      'motherName': 'Sabikah (Khayzuran)',
      'birthDate': '10 Rajab, 195 AH (811 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '29 Dhu al-Qi\'dah, 220 AH (835 CE)',
      'deathPlace': 'Baghdad, Iraq (Poisoned)',
      'spouse': 'Sumana Khatun, Umm al-Fadl',
      'children': 'Ali al-Hadi',
      'era': '203-220 AH',
      'knownFor':
          'Ninth Imam, Youngest Imam (age 7), Debated scholars as child',
    },
    {
      'name': 'علي بن محمد',
      'transliteration': 'Ali ibn Muhammad',
      'title': 'Al-Hadi (The Guide)',
      'titleUrdu': 'الہادی (ہدایت دینے والے)',
      'titleHindi': 'अल-हादी (हिदायत देने वाले)',
      'kunya': 'Abu al-Hasan',
      'kunyaUrdu': 'ابو الحسن',
      'kunyaHindi': 'अबू अल-हसन',
      'description':
          'Imam Ali al-Hadi (AS) became Imam at age 8 after his father\'s martyrdom. He spent most of his life under surveillance in Samarra by Abbasid caliphs. Despite restrictions, he continued guiding the community through representatives. He established the system of deputyship that would later be important. He is known for the Ziyarat al-Jami\'a, a comprehensive visitation prayer for the Prophet\'s family.',
      'descriptionUrdu':
          'امام علی ہادی علیہ السلام اپنے والد کی شہادت کے بعد 8 سال کی عمر میں امام بنے۔ انہوں نے اپنی زیادہ تر زندگی سامرا میں عباسی خلفاء کی نگرانی میں گزاری۔ پابندیوں کے باوجود انہوں نے نمائندوں کے ذریعے امت کی رہنمائی جاری رکھی۔ انہوں نے نیابت کا نظام قائم کیا جو بعد میں اہم ثابت ہوا۔ وہ زیارت جامعہ کے لیے مشہور ہیں جو نبی کے خاندان کے لیے جامع زیارت کی دعا ہے۔',
      'descriptionHindi':
          'इमाम अली हादी (अ.स.) अपने वालिद की शहादत के बाद 8 साल की उम्र में इमाम बने। उन्होंने अपनी ज़्यादातर ज़िंदगी सामर्रा में अब्बासी ख़ुलफ़ा की निगरानी में गुज़ारी। पाबंदियों के बावजूद उन्होंने नुमाइंदों के ज़रिए उम्मत की रहनुमाई जारी रखी। उन्होंने नियाबत का निज़ाम क़ायम किया जो बाद में अहम साबित हुआ। वे ज़ियारत जामिआ के लिए मशहूर हैं जो नबी के ख़ानदान के लिए जामे ज़ियारत की दुआ है।',
      'fatherName': 'Muhammad al-Jawad',
      'motherName': 'Sumana Khatun (Samanah)',
      'birthDate': '15 Dhu al-Hijjah, 212 AH (828 CE)',
      'birthPlace': 'Surayya, near Madinah',
      'deathDate': '3 Rajab, 254 AH (868 CE)',
      'deathPlace': 'Samarra, Iraq (Poisoned)',
      'spouse': 'Hudayth (Salil)',
      'children': 'Hasan al-Askari, Husayn, Muhammad',
      'era': '220-254 AH',
      'knownFor': 'Tenth Imam, Ziyarat Jami\'a al-Kabira, Deputy System',
    },
    {
      'name': 'الحسن بن علي',
      'transliteration': 'Hasan ibn Ali',
      'title': 'Al-Askari (The One of the Army Camp)',
      'titleUrdu': 'العسکری (فوجی چھاؤنی والے)',
      'titleHindi': 'अल-अस्करी (फ़ौजी छावनी वाले)',
      'kunya': 'Abu Muhammad',
      'kunyaUrdu': 'ابو محمد',
      'kunyaHindi': 'अबू मुहम्मद',
      'description':
          'Imam Hasan al-Askari (AS) was named "al-Askari" because he lived in Samarra, a military garrison city, under house arrest. He had limited contact with his followers but maintained guidance through representatives. He is the father of the 12th Imam. He was poisoned at age 28 and is buried alongside his father in Samarra. His shrine is a major pilgrimage site.',
      'descriptionUrdu':
          'امام حسن عسکری علیہ السلام کو "العسکری" کا نام اس لیے ملا کیونکہ وہ سامرا میں رہتے تھے جو ایک فوجی چھاؤنی شہر تھا، نظربندی میں۔ ان کا اپنے پیروکاروں سے محدود رابطہ تھا لیکن نمائندوں کے ذریعے رہنمائی جاری رکھی۔ وہ بارہویں امام کے والد ہیں۔ انہیں 28 سال کی عمر میں زہر دیا گیا اور وہ اپنے والد کے ساتھ سامرا میں مدفون ہیں۔ ان کا مزار ایک اہم زیارت گاہ ہے۔',
      'descriptionHindi':
          'इमाम हसन अस्करी (अ.स.) को "अल-अस्करी" का नाम इसलिए मिला क्योंकि वे सामर्रा में रहते थे जो एक फ़ौजी छावनी शहर था, नज़रबंदी में। उनका अपने पैरोकारों से महदूद राब्ता था लेकिन नुमाइंदों के ज़रिए रहनुमाई जारी रखी। वे बारहवें इमाम के वालिद हैं। उन्हें 28 साल की उम्र में ज़हर दिया गया और वे अपने वालिद के साथ सामर्रा में मदफ़ून हैं। उनका मज़ार एक अहम ज़ियारतगाह है।',
      'fatherName': 'Ali al-Hadi',
      'motherName': 'Hudayth (Salil)',
      'birthDate': '8 Rabi al-Thani, 232 AH (846 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '8 Rabi al-Awwal, 260 AH (874 CE)',
      'deathPlace': 'Samarra, Iraq (Poisoned)',
      'spouse': 'Narjis Khatun',
      'children': 'Muhammad al-Mahdi',
      'era': '254-260 AH',
      'knownFor':
          'Eleventh Imam, Father of the Awaited Imam, House arrest in Samarra',
    },
    {
      'name': 'محمد بن الحسن',
      'transliteration': 'Muhammad ibn Hasan',
      'title': 'Al-Mahdi (The Guided One)',
      'titleUrdu': 'المہدی (ہدایت یافتہ)',
      'titleHindi': 'अल-महदी (हिदायत याफ़्ता)',
      'kunya': 'Abu al-Qasim',
      'kunyaUrdu': 'ابو القاسم',
      'kunyaHindi': 'अबू अल-क़ासिम',
      'description':
          'Imam Muhammad al-Mahdi (AS) is believed to be in occultation since 874 CE. He is awaited as the one who will return with Prophet Isa (Jesus) to establish justice on Earth. During the Minor Occultation (874-941 CE), he communicated through deputies. Now in Major Occultation, believers await his return. He is also called Sahib al-Zaman (Master of the Age) and his return is anticipated across Islamic traditions.',
      'descriptionUrdu':
          'امام محمد مہدی علیہ السلام 874 عیسوی سے غیبت میں ہیں۔ ان کا انتظار ہے کہ وہ نبی عیسیٰ علیہ السلام کے ساتھ زمین پر عدل قائم کرنے واپس آئیں گے۔ غیبت صغریٰ (874-941 عیسوی) کے دوران انہوں نے نائبوں کے ذریعے رابطہ رکھا۔ اب غیبت کبریٰ میں مومنین ان کی واپسی کا انتظار کر رہے ہیں۔ انہیں صاحب الزمان بھی کہا جاتا ہے اور ان کی واپسی کا انتظار تمام اسلامی روایات میں ہے۔',
      'descriptionHindi':
          'इमाम मुहम्मद महदी (अ.स.) 874 ई. से ग़ैबत में हैं। उनका इंतिज़ार है कि वे नबी ईसा (अ.स.) के साथ ज़मीन पर अदल क़ायम करने वापस आएंगे। ग़ैबत-ए-सुग़रा (874-941 ई.) के दौरान उन्होंने नाइबों के ज़रिए राब्ता रखा। अब ग़ैबत-ए-कुबरा में मोमिनीन उनकी वापसी का इंतिज़ार कर रहे हैं। उन्हें साहिबुज़्ज़मान भी कहा जाता है और उनकी वापसी का इंतिज़ार तमाम इस्लामी रिवायात में है।',
      'fatherName': 'Hasan al-Askari',
      'motherName': 'Narjis Khatun',
      'birthDate': '15 Sha\'ban, 255 AH (869 CE)',
      'birthPlace': 'Samarra, Iraq',
      'deathDate': 'In Occultation (Alive)',
      'deathPlace': 'N/A - Awaited',
      'era': '260 AH - Present (In Occultation)',
      'knownFor': 'Twelfth Imam, Al-Mahdi, Sahib al-Zaman, Awaited Savior',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredNames = _imamNames;
    _searchController.addListener(_filterNames);

    // Listen to language changes to force rebuild
  }

  @override

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredNames = _imamNames;
      } else {
        _filteredNames = _imamNames.where((name) {
          final transliteration = name['transliteration']!.toLowerCase();
          final title = name['title']!.toLowerCase();
          final kunya = name['kunya']!.toLowerCase();
          final arabicName = name['name']!;
          return transliteration.contains(query) ||
              title.contains(query) ||
              kunya.contains(query) ||
              arabicName.contains(query);
        }).toList();
      }
    });
  }

  String _transliterateToHindi(String text) {
    final Map<String, String> map = {
      'Ali ibn Abi Talib': 'अली बिन अबी तालिब',
      'Hasan ibn Ali': 'हसन बिन अली',
      'Husayn ibn Ali': 'हुसैन बिन अली',
      'Ali ibn Husayn': 'अली बिन हुसैन',
      'Muhammad ibn Ali': 'मुहम्मद बिन अली',
      'Ja\'far ibn Muhammad': 'जाफ़र बिन मुहम्मद',
      'Musa ibn Ja\'far': 'मूसा बिन जाफ़र',
      'Ali ibn Musa': 'अली बिन मूसा',
      'Ali ibn Muhammad': 'अली बिन मुहम्मद',
      'Muhammad ibn Hasan': 'मुहम्मद बिन हसन',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    final Map<String, String> map = {
      'Ali ibn Abi Talib': 'علی بن ابی طالب',
      'Hasan ibn Ali': 'حسن بن علی',
      'Husayn ibn Ali': 'حسین بن علی',
      'Ali ibn Husayn': 'علی بن حسین',
      'Muhammad ibn Ali': 'محمد بن علی',
      'Ja\'far ibn Muhammad': 'جعفر بن محمد',
      'Musa ibn Ja\'far': 'موسیٰ بن جعفر',
      'Ali ibn Musa': 'علی بن موسیٰ',
      'Ali ibn Muhammad': 'علی بن محمد',
      'Muhammad ibn Hasan': 'محمد بن حسن',
    };
    return map[text] ?? text;
  }

  String _getDisplayName(Map<String, dynamic> name, String languageCode) {
    final transliteration = name['transliteration']!;

    switch (languageCode) {
      case 'ar':
        return name['name']!;
      case 'ur':
        return _transliterateToUrdu(transliteration);
      case 'hi':
        return _transliterateToHindi(transliteration);
      case 'en':
      default:
        return transliteration;
    }
  }

  String _getDisplayTitle(Map<String, dynamic> name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name['titleUrdu'] ?? name['title']!;
      case 'ur':
        return name['titleUrdu'] ?? name['title']!;
      case 'hi':
        return name['titleHindi'] ?? name['title']!;
      case 'en':
      default:
        return name['title']!;
    }
  }

  String _getDisplayKunya(Map<String, dynamic> name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name['kunyaUrdu'] ?? name['kunya']!;
      case 'ur':
        return name['kunyaUrdu'] ?? name['kunya']!;
      case 'hi':
        return name['kunyaHindi'] ?? name['kunya']!;
      case 'en':
      default:
        return name['kunya']!;
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
        title: Text(context.tr('twelve_imams')),
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
                          context.tr('no_imams_found'),
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
                      final originalIndex = _imamNames.indexOf(name) + 1;
                      final displayName = _getDisplayName(name, langProvider.languageCode);
                      final displayTitle = _getDisplayTitle(name, langProvider.languageCode);
                      final displayKunya = _getDisplayKunya(name, langProvider.languageCode);
                      return _buildNameCard(
                        name: name,
                        index: originalIndex,
                        isDark: isDark,
                        displayName: displayName,
                        displayTitle: displayTitle,
                        displayKunya: displayKunya,
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
    required String displayTitle,
    required String displayKunya,
    required String languageCode,
  }) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    final responsive = context.responsive;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IslamicNameDetailScreen(
              arabicName: name['name']!,
              transliteration: name['transliteration']!,
              meaning: '${name['title']!} (${name['kunya']!})',
              meaningUrdu:
                  '${name['titleUrdu'] ?? name['title']!} (${name['kunya']!})',
              meaningHindi:
                  '${name['titleHindi'] ?? name['title']!} (${name['kunya']!})',
              description: name['description']!,
              descriptionUrdu: name['descriptionUrdu'] ?? '',
              descriptionHindi: name['descriptionHindi'] ?? '',
              category: 'Imam of Ahlul Bayt',
              number: index,
              icon: Icons.stars,
              color: Colors.purple,
              fatherName: name['fatherName'],
              motherName: name['motherName'],
              birthDate: name['birthDate'],
              birthPlace: name['birthPlace'],
              deathDate: name['deathDate'],
              deathPlace: name['deathPlace'],
              spouse: name['spouse'],
              children: name['children'],
              era: name['era'],
              knownFor: name['knownFor'],
            ),
          ),
        );
      },
      child: Container(
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
                  meaning: '${name['title']!} (${name['kunya']!})',
                  meaningUrdu:
                      '${name['titleUrdu'] ?? name['title']!} (${name['kunya']!})',
                  meaningHindi:
                      '${name['titleHindi'] ?? name['title']!} (${name['kunya']!})',
                  description: name['description']!,
                  descriptionUrdu: name['descriptionUrdu'] ?? '',
                  descriptionHindi: name['descriptionHindi'] ?? '',
                  category: 'Imam of Ahlul Bayt',
                  number: index,
                  icon: Icons.stars,
                  color: Colors.purple,
                  fatherName: name['fatherName'],
                  motherName: name['motherName'],
                  birthDate: name['birthDate'],
                  birthPlace: name['birthPlace'],
                  deathDate: name['deathDate'],
                  deathPlace: name['deathPlace'],
                  spouse: name['spouse'],
                  children: name['children'],
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
                        color: (isDark ? emeraldGreen : darkGreen).withValues(
                          alpha: 0.3,
                        ),
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

                // Imam Name
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
                  decoration: const BoxDecoration(
                    color: emeraldGreen,
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
      ),
    );
  }
}
