import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'islamic_name_detail_screen.dart';

class SahabaNamesScreen extends StatefulWidget {
  const SahabaNamesScreen({super.key});

  @override
  State<SahabaNamesScreen> createState() => _SahabaNamesScreenState();
}

class _SahabaNamesScreenState extends State<SahabaNamesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredNames = [];

  final List<Map<String, dynamic>> _sahabaNames = [
    {
      'name': 'أبو بكر الصديق',
      'transliteration': 'Abu Bakr As-Siddiq',
      'meaning': 'The Truthful',
      'meaningUrdu': 'صدیق',
      'meaningHindi': 'सच्चा',
      'description':
          'Abu Bakr (RA) was the closest companion of Prophet Muhammad ﷺ and the first adult male to accept Islam. He accompanied the Prophet during the Hijrah to Madinah. He became the first Caliph after the Prophet\'s death and united the Muslim community. He is known for his unwavering faith, generosity, and freeing many slaves including Bilal.',
      'descriptionUrdu':
          'حضرت ابوبکر صدیق رضی اللہ عنہ نبی کریم ﷺ کے سب سے قریبی صحابی اور اسلام قبول کرنے والے پہلے بالغ مرد تھے۔ انہوں نے ہجرت کے دوران مدینہ تک نبی ﷺ کا ساتھ دیا۔ وہ نبی ﷺ کی وفات کے بعد پہلے خلیفہ بنے اور مسلم امت کو متحد کیا۔ وہ اپنے پختہ ایمان، سخاوت اور بلال سمیت کئی غلاموں کو آزاد کرنے کے لیے مشہور ہیں۔',
      'descriptionHindi':
          'हज़रत अबू बक्र सिद्दीक़ (रज़ि.) नबी करीम ﷺ के सबसे क़रीबी साथी और इस्लाम क़बूल करने वाले पहले बालिग़ मर्द थे। उन्होंने हिजरत के दौरान मदीना तक नबी ﷺ का साथ दिया। वे नबी ﷺ की वफ़ात के बाद पहले ख़लीफ़ा बने और मुस्लिम उम्मत को मुत्तहिद किया। वे अपने पक्के ईमान, सख़ावत और बिलाल समेत कई ग़ुलामों को आज़ाद करने के लिए मशहूर हैं।',
      'fatherName': 'Abu Quhafa (Uthman ibn Amir)',
      'motherName': 'Salma bint Sakhar (Umm al-Khayr)',
      'birthDate': '573 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '22 Jumada al-Thani, 13 AH (634 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Qutaylah, Umm Ruman, Asma bint Umais, Habibah',
      'children': 'Aisha, Asma, Abdullah, Abdur Rahman, Muhammad',
      'tribe': 'Quraysh (Banu Taym)',
      'title': 'As-Siddiq (The Truthful)',
      'era': '632-634 CE (Caliphate)',
      'knownFor':
          'First Caliph, Closest companion, Freed slaves, Ashara Mubashara',
    },
    {
      'name': 'عمر بن الخطاب',
      'transliteration': 'Umar ibn Al-Khattab',
      'meaning': 'The Distinguisher',
      'meaningUrdu': 'فاروق',
      'meaningHindi': 'फ़ारूक़',
      'description':
          'Umar (RA) was initially a fierce opponent of Islam but his conversion strengthened the Muslim community greatly. Known as Al-Farooq (the one who distinguishes truth from falsehood), he became the second Caliph. During his rule, the Islamic empire expanded significantly. He was known for his justice, simplicity, and administrative genius.',
      'descriptionUrdu':
          'حضرت عمر رضی اللہ عنہ ابتدا میں اسلام کے سخت مخالف تھے لیکن ان کے قبول اسلام سے مسلم جماعت کو بہت تقویت ملی۔ الفاروق (حق و باطل میں تمیز کرنے والا) کے نام سے مشہور، وہ دوسرے خلیفہ بنے۔ ان کے دور حکومت میں اسلامی سلطنت میں نمایاں توسیع ہوئی۔ وہ اپنے انصاف، سادگی اور انتظامی صلاحیت کے لیے مشہور تھے۔',
      'descriptionHindi':
          'हज़रत उमर (रज़ि.) शुरू में इस्लाम के सख़्त मुख़ालिफ़ थे लेकिन उनके क़बूल-ए-इस्लाम से मुस्लिम जमाअत को बहुत ताक़त मिली। अल-फ़ारूक़ (हक़ और बातिल में तमीज़ करने वाला) के नाम से मशहूर, वे दूसरे ख़लीफ़ा बने। उनके दौर-ए-हुकूमत में इस्लामी सल्तनत में नुमायां तौसी हुई। वे अपने इंसाफ़, सादगी और इंतिज़ामी सलाहियत के लिए मशहूर थे।',
      'fatherName': 'Al-Khattab ibn Nufayl',
      'motherName': 'Hantamah bint Hashim',
      'birthDate': '584 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '26 Dhu al-Hijjah, 23 AH (644 CE)',
      'deathPlace': 'Madinah (Martyred)',
      'spouse': 'Zaynab, Jamila, Atikah, Umm Kulthum bint Ali',
      'children': 'Abdullah, Hafsa, Asim, and others',
      'tribe': 'Quraysh (Banu Adi)',
      'title': 'Al-Farooq (The Distinguisher)',
      'era': '634-644 CE (Caliphate)',
      'knownFor': 'Second Caliph, Empire expansion, Justice, Ashara Mubashara',
    },
    {
      'name': 'عثمان بن عفان',
      'transliteration': 'Uthman ibn Affan',
      'meaning': 'The Possessor of Two Lights',
      'meaningUrdu': 'ذوالنورین',
      'meaningHindi': 'ज़ुन्नूरैन',
      'description':
          'Uthman (RA) was called Dhun-Nurayn because he married two daughters of the Prophet ﷺ. He was extremely wealthy but spent generously for Islam, including buying the well of Rumah and equipping the army of Tabuk. As the third Caliph, he compiled the Quran in a standardized form that we use today. He was known for his modesty and generosity.',
      'descriptionUrdu':
          'حضرت عثمان رضی اللہ عنہ کو ذوالنورین کہا جاتا تھا کیونکہ انہوں نے نبی ﷺ کی دو بیٹیوں سے شادی کی۔ وہ انتہائی دولت مند تھے لیکن اسلام کے لیے بہت سخاوت سے خرچ کیا، جس میں رومہ کا کنواں خریدنا اور تبوک کی فوج کو لیس کرنا شامل ہے۔ تیسرے خلیفہ کے طور پر، انہوں نے قرآن کو ایک معیاری شکل میں مرتب کیا جو ہم آج استعمال کرتے ہیں۔ وہ اپنی حیا اور سخاوت کے لیے مشہور تھے۔',
      'descriptionHindi':
          'हज़रत उस्मान (रज़ि.) को ज़ुन्नूरैन कहा जाता था क्योंकि उन्होंने नबी ﷺ की दो बेटियों से शादी की। वे बेहद दौलतमंद थे लेकिन इस्लाम के लिए बहुत सख़ावत से ख़र्च किया, जिसमें रूमा का कुआं ख़रीदना और तबूक की फ़ौज को लैस करना शामिल है। तीसरे ख़लीफ़ा के तौर पर, उन्होंने क़ुरान को एक मेयारी शक्ल में मुरत्तब किया जो हम आज इस्तेमाल करते हैं। वे अपनी हया और सख़ावत के लिए मशहूर थे।',
      'fatherName': 'Affan ibn Abi al-As',
      'motherName': 'Arwa bint Kurayz',
      'birthDate': '576 CE',
      'birthPlace': 'Taif, Arabia',
      'deathDate': '18 Dhu al-Hijjah, 35 AH (656 CE)',
      'deathPlace': 'Madinah (Martyred)',
      'spouse': 'Ruqayyah bint Muhammad, Umm Kulthum bint Muhammad',
      'children': 'Abdullah, Amr, and others',
      'tribe': 'Quraysh (Banu Umayya)',
      'title': 'Dhun-Nurayn (Possessor of Two Lights)',
      'era': '644-656 CE (Caliphate)',
      'knownFor': 'Third Caliph, Compiled Quran, Ashara Mubashara',
    },
    {
      'name': 'علي بن أبي طالب',
      'transliteration': 'Ali ibn Abi Talib',
      'meaning': 'The Gate of Knowledge',
      'meaningUrdu': 'علم کا دروازہ',
      'meaningHindi': 'इल्म का दरवाज़ा',
      'description':
          'Ali (RA) was the cousin and son-in-law of the Prophet ﷺ, married to Fatimah. He was among the first to accept Islam as a child. Known for his bravery, wisdom, and knowledge, he was called Asadullah (Lion of Allah). He slept in the Prophet\'s bed during the Hijrah and became the fourth Caliph. The Prophet said: "I am the city of knowledge and Ali is its gate."',
      'descriptionUrdu':
          'حضرت علی رضی اللہ عنہ نبی ﷺ کے چچا زاد بھائی اور داماد تھے، فاطمہ سے شادی شدہ۔ وہ بچپن میں اسلام قبول کرنے والوں میں سے پہلے تھے۔ اپنی بہادری، حکمت اور علم کے لیے مشہور، انہیں اسد اللہ (اللہ کا شیر) کہا جاتا تھا۔ انہ��ں نے ہجرت کے دوران نبی ﷺ کے بستر پر سویا اور چوتھے خلیفہ بنے۔ نبی ﷺ نے فرمایا: "میں علم کا شہر ہوں اور علی اس کا دروازہ ہے۔"',
      'descriptionHindi':
          'हज़रत अली (रज़ि.) नबी ﷺ के चचाज़ाद भाई और दामाद थे, फ़ातिमा से शादीशुदा। वे बचपन में इस्लाम क़बूल करने वालों में से पहले थे। अपनी बहादुरी, हिकमत और इल्म के लिए मशहूर, उन्हें असदुल्लाह (अल्लाह का शेर) कहा जाता था। उन्होंने हिजरत के दौरान नबी ﷺ के बिस्तर पर सोया और चौथे ख़लीफ़ा बने। नबी ﷺ ने फ़रमाया: "मैं इल्म का शहर हूं और अली इसका दरवाज़ा है।"',
      'fatherName': 'Abu Talib ibn Abd al-Muttalib',
      'motherName': 'Fatimah bint Asad',
      'birthDate': '13 Rajab, 30 BH (600 CE)',
      'birthPlace': 'Inside the Kaaba, Makkah',
      'deathDate': '21 Ramadan, 40 AH (661 CE)',
      'deathPlace': 'Kufa, Iraq (Martyred)',
      'spouse': 'Fatimah bint Muhammad',
      'children': 'Hasan, Husayn, Zaynab, Umm Kulthum',
      'tribe': 'Quraysh (Banu Hashim)',
      'title': 'Asadullah (Lion of Allah), Bab al-Ilm (Gate of Knowledge)',
      'era': '656-661 CE (Caliphate)',
      'knownFor': 'Fourth Caliph, First male Muslim, Ashara Mubashara',
    },
    {
      'name': 'طلحة بن عبيد الله',
      'transliteration': 'Talha ibn Ubaydullah',
      'meaning': 'The Generous',
      'meaningUrdu': 'سخی',
      'meaningHindi': 'सख़ी',
      'description':
          'Talha (RA) was one of the ten companions promised Paradise (Ashara Mubashara). He was known for his exceptional generosity and bravery. In the Battle of Uhud, he protected the Prophet with his own body, sustaining over 70 wounds. The Prophet called him "Talha the Generous" and "Talha the Good."',
      'descriptionUrdu':
          'حضرت طلحہ رضی اللہ عنہ دس صحابہ میں سے ایک تھے جنہیں جنت کی بشارت دی گئی (عشرہ مبشرہ)۔ وہ اپنی غیر معمولی سخاوت اور بہادری کے لیے مشہور تھے۔ غزوہ احد میں انہوں نے اپنے جسم سے نبی ﷺ کی حفاظت کی اور 70 سے زیادہ زخم کھائے۔ نبی ﷺ نے انہیں "طلحہ السخی" اور "طلحہ الخیر" کہا۔',
      'descriptionHindi':
          'हज़रत तल्हा (रज़ि.) दस सहाबा में से एक थे जिन्हें जन्नत की बशारत दी गई (अशरा मुबश्शरा)। वे अपनी ग़ैर-मामूली सख़ावत और बहादुरी के लिए मशहूर थे। ग़ज़्वा-ए-उहुद में उन्होंने अपने जिस्म से नबी ﷺ की हिफ़ाज़त की और 70 से ज़्यादा ज़ख़्म खाए। नबी ﷺ ने उन्हें "तल्हा अस-सख़ी" और "तल्हा अल-ख़ैर" कहा।',
      'fatherName': 'Ubaydullah ibn Uthman',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '36 AH (656 CE)',
      'deathPlace': 'Battle of Jamal, Basra',
      'tribe': 'Quraysh (Banu Taym)',
      'title': 'Talha the Generous, Talha the Good',
      'knownFor': 'Protected Prophet at Uhud, Ashara Mubashara, Generosity',
    },
    {
      'name': 'الزبير بن العوام',
      'transliteration': 'Zubayr ibn Al-Awwam',
      'meaning': 'Disciple of the Prophet',
      'meaningUrdu': 'نبی کے حواری',
      'meaningHindi': 'नबी के हवारी',
      'description':
          'Zubayr (RA) was the cousin of the Prophet ﷺ and one of the ten promised Paradise. He was the first to draw his sword for Islam. He was known for his bravery and was called "the Disciple of the Prophet." He participated in all major battles and was known for his exceptional horsemanship and fighting skills.',
      'descriptionUrdu':
          'حضرت زبیر رضی اللہ عنہ نبی ﷺ کے چچا زاد بھائی اور جنت کی بشارت پانے والے دس صحابہ میں سے ایک تھے۔ وہ اسلام کے لیے تلوار نکالنے والے پہلے شخص تھے۔ وہ اپنی بہادری کے لیے مشہور تھے اور انہیں "نبی کے حواری" کہا جاتا تھا۔ انہوں نے تمام بڑی لڑائیوں میں حصہ لیا اور اپنی شاندار گھڑ سواری اور جنگی مہارت کے لیے جانے جاتے تھے۔',
      'descriptionHindi':
          'हज़रत ज़ुबैर (रज़ि.) नबी ﷺ के चचाज़ाद भाई और जन्नत की बशारत पाने वाले दस सहाबा में से एक थे। वे इस्लाम के लिए तलवार निकालने वाले पहले शख़्स थे। वे अपनी बहादुरी के लिए मशहूर थे और उन्हें "नबी के हवारी" कहा जाता था। उन्होंने तमाम बड़ी लड़ाइयों में हिस्सा लिया और अपनी शानदार घुड़सवारी और जंगी महारत के लिए जाने जाते थे।',
      'fatherName': 'Al-Awwam ibn Khuwaylid',
      'motherName': 'Safiyyah bint Abd al-Muttalib (Prophet\'s aunt)',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '36 AH (656 CE)',
      'deathPlace': 'Wadi al-Siba, near Basra',
      'spouse': 'Asma bint Abi Bakr, and others',
      'children': 'Abdullah, Urwa, Mundhir',
      'tribe': 'Quraysh (Banu Asad)',
      'title': 'Hawari an-Nabi (Disciple of the Prophet)',
      'knownFor': 'First to draw sword for Islam, Ashara Mubashara, Bravery',
    },
    {
      'name': 'عبد الرحمن بن عوف',
      'transliteration': 'Abdur Rahman ibn Awf',
      'meaning': 'Servant of the Merciful',
      'meaningUrdu': 'رحمان کا بندہ',
      'meaningHindi': 'रहमान का बंदा',
      'description':
          'Abdur Rahman (RA) was one of the ten promised Paradise and among the first eight to accept Islam. He was an extremely successful merchant who gave half his wealth for Islam when he migrated to Madinah. He donated 700 camels laden with goods for the cause of Allah. He was known for his generosity and business acumen.',
      'descriptionUrdu':
          'حضرت عبدالرحمن بن عوف رضی اللہ عنہ جنت کی بشارت پانے والے دس صحابہ میں سے ایک اور اسلام قبول کرنے والے پہلے آٹھ لوگوں میں سے تھے۔ وہ ایک انتہائی کامیاب تاجر تھے جنہوں نے مدینہ ہجرت کرتے وقت اپنا آدھا مال اسلام کے لیے دے دیا۔ انہوں نے اللہ کی راہ میں 700 اونٹ سامان سے لدے ہوئے دیے۔ وہ اپنی سخاوت اور تجارتی ذہانت کے لیے مشہور تھے۔',
      'descriptionHindi':
          'हज़रत अब्दुर्रहमान बिन औफ़ (रज़ि.) जन्नत की बशारत पाने वाले दस सहाबा में से एक और इस्लाम क़बूल करने वाले पहले आठ लोगों में से थे। वे एक बेहद कामयाब ताजिर थे जिन्होंने मदीना हिजरत करते वक़्त अपना आधा माल इस्लाम के लिए दे दिया। उन्होंने अल्लाह की राह में 700 ऊंट सामान से लदे हुए दिए। वे अपनी सख़ावत और तिजारती ज़ेहनियत के लिए मशहूर थे।',
    },
    {
      'name': 'سعد بن أبي وقاص',
      'transliteration': 'Saad ibn Abi Waqqas',
      'meaning': 'The First Archer',
      'meaningUrdu': 'پہلا تیر انداز',
      'meaningHindi': 'पहला तीरअंदाज़',
      'description':
          'Saad (RA) was one of the ten promised Paradise and the first to shoot an arrow in defense of Islam. He was the commander who conquered Persia and founded the city of Kufa. The Prophet made special dua for his arrows to always hit the target. He was the last of the ten Ashara Mubashara to pass away.',
      'descriptionUrdu':
          'حضرت سعد بن ابی وقاص رضی اللہ عنہ جنت کی بشارت پانے والے دس صحابہ میں سے ایک اور اسلام کے دفاع میں تیر چلانے والے پہلے شخص تھے۔ وہ وہ سپہ سالار تھے جنہوں نے فارس فتح کیا اور کوفہ شہر کی بنیاد رکھی۔ نبی ﷺ نے ان کے تیروں کے ہمیشہ نشانے پر لگنے کی خاص دعا کی۔ وہ عشرہ مبشرہ میں سے آخری تھے جو وفات پائے۔',
      'descriptionHindi':
          'हज़रत साद बिन अबी वक़्क़ास (रज़ि.) जन्नत की बशारत पाने वाले दस सहाबा में से एक और इस्लाम के दिफ़ाअ में तीर चलाने वाले पहले शख़्स थे। वे वो सिपहसालार थे जिन्होंने फ़ारस फ़तह किया और कूफ़ा शहर की बुनियाद रखी। नबी ﷺ ने उनके तीरों के हमेशा निशाने पर लगने की ख़ास दुआ की। वे अशरा मुबश्शरा में से आख़िरी थे जो वफ़ात पाए।',
    },
    {
      'name': 'سعيد بن زيد',
      'transliteration': 'Said ibn Zayd',
      'meaning': 'The Blessed',
      'meaningUrdu': 'برکت والا',
      'meaningHindi': 'बरकत वाला',
      'description':
          'Said (RA) was one of the ten promised Paradise. His father Zayd ibn Amr was a monotheist before Islam. He and his wife Fatimah bint Al-Khattab (Umar\'s sister) accepted Islam early, and it was in their house that Umar converted to Islam. He was known for his piety and participated in all major battles except Badr.',
      'descriptionUrdu':
          'حضرت سعید بن زید رضی اللہ عنہ جنت کی بشارت پانے والے دس صحابہ میں سے ایک تھے۔ ان کے والد زید بن عمرو اسلام سے پہلے توحید پرست تھے۔ انہوں نے اور ان کی بیوی فاطمہ بنت الخطاب (عمر کی بہن) نے ابتدائی دور میں اسلام قبول کیا، اور انہی کے گھر میں عمر نے اسلام قبول کیا۔ وہ اپنی تقویٰ کے لیے مشہور تھے اور بدر کے علاوہ تمام بڑی لڑائیوں میں شریک ہوئے۔',
      'descriptionHindi':
          'हज़रत सईद बिन ज़ैद (रज़ि.) जन्नत की बशारत पाने वाले दस सहाबा में से एक थे। उनके वालिद ज़ैद बिन अम्र इस्लाम से पहले तौहीद परस्त थे। उन्होंने और उनकी बीवी फ़ातिमा बिन्त अल-ख़त्ताब (उमर की बहन) ने इब्तिदाई दौर में इस्लाम क़बूल किया, और उन्हीं के घर में उमर ने इस्लाम क़बूल किया। वे अपने तक़वा के लिए मशहूर थे और बद्र के अलावा तमाम बड़ी लड़ाइयों में शरीक हुए।',
    },
    {
      'name': 'أبو عبيدة بن الجراح',
      'transliteration': 'Abu Ubayda ibn Al-Jarrah',
      'meaning': 'Trustee of the Ummah',
      'meaningUrdu': 'امت کے امین',
      'meaningHindi': 'उम्मत के अमीन',
      'description':
          'Abu Ubayda (RA) was one of the ten promised Paradise and was called "the Trustee of this Ummah" by the Prophet ﷺ. He was known for his humility, simplicity, and trustworthiness. He led the Muslim armies in Syria and conquered many cities. He passed away during the plague of Amwas while serving as the commander.',
      'descriptionUrdu':
          'حضرت ابو عبیدہ بن الجراح رضی اللہ عنہ جنت کی بشارت پانے والے دس صحابہ میں سے ایک تھے اور نبی ﷺ نے انہیں "اس امت کا امین" کہا۔ وہ اپنی عاجزی، سادگی اور امانت داری کے لیے مشہور تھے۔ انہوں نے شام میں مسلم فوجوں کی قیادت کی اور کئی شہر فتح کیے۔ وہ سپہ سالار کی حیثیت سے خدمات انجام دیتے ہوئے طاعون عمواس میں وفات پائے۔',
      'descriptionHindi':
          'हज़रत अबू उबैदा बिन अल-जर्राह (रज़ि.) जन्नत की बशारत पाने वाले दस सहाबा में से एक थे और नबी ﷺ ने उन्हें "इस उम्मत का अमीन" कहा। वे अपनी आजिज़ी, सादगी और अमानतदारी के लिए मशहूर थे। उन्होंने शाम में मुस्लिम फ़ौजों की क़यादत की और कई शहर फ़तह किए। वे सिपहसालार की हैसियत से ख़िदमात अंजाम देते हुए ताऊन-ए-अमवास में वफ़ात पाए।',
    },
    {
      'name': 'بلال بن رباح',
      'transliteration': 'Bilal ibn Rabah',
      'meaning': 'First Muezzin',
      'meaningUrdu': 'پہلا موذن',
      'meaningHindi': 'पहला मुअज़्ज़िन',
      'description':
          'Bilal (RA) was an Ethiopian slave who was among the earliest converts to Islam. He was tortured severely by his master for his faith, famously saying "Ahad, Ahad" (One, One) while being tortured. Abu Bakr bought and freed him. He became the first muezzin (caller to prayer) in Islam and had a beautiful voice. The Prophet ﷺ honored him greatly.',
      'descriptionUrdu':
          'حضرت بلال رضی اللہ عنہ ایک حبشی غلام تھے جو ابتدائی دور میں اسلام قبول کرنے والوں میں شامل تھے۔ انہیں ان کے مالک نے ایمان کی وجہ سے شدید اذیت دی، وہ تشدد کے دوران "احد، احد" (ایک، ایک) کہتے رہے۔ ابوبکر نے انہیں خرید کر آزاد کیا۔ وہ اسلام میں پہلے موذن بنے اور ان کی آواز بہت خوبصورت تھی۔ نبی ﷺ نے انہیں بہت عزت دی۔',
      'descriptionHindi':
          'हज़रत बिलाल (रज़ि.) एक हब्शी ग़ुलाम थे जो इब्तिदाई दौर में इस्लाम क़बूल करने वालों में शामिल थे। उन्हें उनके मालिक ने ईमान की वजह से शदीद अज़ीयत दी, वे तशद्दुद के दौरान "अहद, अहद" (एक, एक) कहते रहे। अबू बक्र ने उन्हें ख़रीद कर आज़ाद किया। वे इस्लाम में पहले मुअज़्ज़िन बने और उनकी आवाज़ बहुत ख़ूबसूरत थी। नबी ﷺ ने उन्हें बहुत इज़्ज़त दी।',
      'birthPlace': 'Abyssinia (Ethiopia)',
      'deathDate': '20 AH (641 CE)',
      'deathPlace': 'Damascus, Syria',
      'title': 'First Muezzin of Islam',
      'knownFor':
          'First Muezzin, Patience under torture, Beautiful voice, Freed by Abu Bakr',
    },
    {
      'name': 'أبو ذر الغفاري',
      'transliteration': 'Abu Dharr Al-Ghifari',
      'meaning': 'The Truthful Speaker',
      'meaningUrdu': 'سچ بولنے والا',
      'meaningHindi': 'सच बोलने वाला',
      'description':
          'Abu Dharr (RA) was among the earliest converts to Islam and was known for his truthfulness. The Prophet said there was no one more truthful than Abu Dharr. He was extremely ascetic and lived a simple life, speaking out against accumulation of wealth. He is considered a model of sincerity and truthfulness in speech.',
      'descriptionUrdu':
          'حضرت ابوذر غفاری رضی اللہ عنہ ابتدائی دور میں اسلام قبول کرنے والوں میں شامل تھے اور اپنی سچائی کے لیے مشہور تھے۔ نبی ﷺ نے فرمایا کہ ابوذر سے زیادہ سچا کوئی نہیں۔ وہ انتہائی زاہد تھے ا��ر سادہ زندگی گزارتے تھے، مال جمع کرنے کے خلاف بولتے تھے۔ انہیں اخلاص اور سچ بولنے کا نمونہ سمجھا جاتا ہے۔',
      'descriptionHindi':
          'हज़रत अबू ज़र ग़िफ़ारी (रज़ि.) इब्तिदाई दौर में इस्लाम क़बूल करने वालों में शामिल थे और अपनी सच्चाई के लिए मशहूर थे। नबी ﷺ ने फ़रमाया कि अबू ज़र से ज़्यादा सच्चा कोई नहीं। वे बेहद ज़ाहिद थे और सादा ज़िंदगी गुज़ारते थे, माल जमा करने के ख़िलाफ़ बोलते थे। उन्हें इख़लास और सच बोलने का नमूना समझा जाता है।',
    },
    {
      'name': 'سلمان الفارسي',
      'transliteration': 'Salman Al-Farsi',
      'meaning': 'The Persian',
      'meaningUrdu': 'فارسی',
      'meaningHindi': 'फ़ारसी',
      'description':
          'Salman (RA) traveled from Persia seeking the true religion, passing through Christianity before finding Islam. The Prophet said "Salman is from us, the People of the House (Ahlul Bayt)." He suggested digging the trench during the Battle of the Trench. He was known for his knowledge and became the governor of Madain (Persia).',
      'descriptionUrdu':
          'حضرت سلمان فارسی رضی اللہ عنہ نے سچے دین کی تلاش میں فارس سے سفر کیا، عیسائیت سے گزرتے ہوئے اسلام پایا۔ نبی ﷺ نے فرمایا "سلمان ہم میں سے ہے، اہل بیت میں سے۔" انہوں نے غزوہ خندق کے دوران خندق کھودنے کا مشورہ دیا۔ وہ اپنے علم کے لیے مشہور تھے اور مدائن (فارس) کے گورنر بنے۔',
      'descriptionHindi':
          'हज़रत सलमान फ़ारसी (रज़ि.) ने सच्चे दीन की तलाश में फ़ारस से सफ़र किया, ईसाइयत से गुज़रते हुए इस्लाम पाया। नबी ﷺ ने फ़रमाया "सलमान हम में से है, अहल-ए-बैत में से।" उन्होंने ग़ज़्वा-ए-ख़ंदक़ के दौरान ख़ंदक़ खोदने का मशवरा दिया। वे अपने इल्म के लिए मशहूर थे और मदाइन (फ़ारस) के गवर्नर बने।',
    },
    {
      'name': 'عمار بن ياسر',
      'transliteration': 'Ammar ibn Yasir',
      'meaning': 'The Patient',
      'meaningUrdu': 'صبر کرنے والا',
      'meaningHindi': 'सब्र करने वाला',
      'description':
          'Ammar (RA) and his parents were among the first to accept Islam and were severely tortured. His mother Sumayyah was the first martyr in Islam. The Prophet said "Ammar is filled with faith from head to toe." He built the first mosque in Islam (Quba) and was known for his patience and steadfastness in faith.',
      'descriptionUrdu':
          'حضرت عمار بن یاسر رضی اللہ عنہ اور ان کے والدین پہلے لوگوں میں شامل تھے جنہوں نے اسلام قبول کیا اور شدید اذیت سہی۔ ان کی والدہ سمیہ اسلام میں پہلی شہید تھیں۔ نبی ﷺ نے فرمایا "عمار سر سے پاؤں تک ایمان سے بھرا ہوا ہے۔" انہوں نے اسلام میں پہلی مسجد (قبا) تعمیر کی اور صبر اور ایمان میں استقامت کے لیے مشہور تھے۔',
      'descriptionHindi':
          'हज़रत अम्मार बिन यासिर (रज़ि.) और उनके वालिदैन पहले लोगों में शामिल थे जिन्होंने इस्लाम क़बूल किया और शदीद अज़ीयत सही। उनकी वालिदा सुमैय्या इस्लाम में पहली शहीद थीं। नबी ﷺ ने फ़रमाया "अम्मार सर से पांव तक ईमान से भरा हुआ है।" उन्होंने इस्लाम में पहली मस्जिद (क़ुबा) तामीर की और सब्र और ईमान में इस्तिक़ामत के लिए मशहूर थे।',
    },
    {
      'name': 'حذيفة بن اليمان',
      'transliteration': 'Hudhayfah ibn Al-Yaman',
      'meaning': 'Keeper of Secrets',
      'meaningUrdu': 'رازوں کا امین',
      'meaningHindi': 'राज़ों का अमीन',
      'description':
          'Hudhayfah (RA) was known as the "Keeper of the Secret" because the Prophet ﷺ told him the names of the hypocrites. He was an expert in knowledge of trials and tribulations (fitan). He participated in many battles and was known for his intelligence and wisdom. He served as the governor of Madain under Umar.',
      'descriptionUrdu':
          'حضرت حذیفہ بن الیمان رضی اللہ عنہ کو "راز کے امین" کے نام سے جانا جاتا تھا کیونکہ نبی ﷺ نے انہیں منافقین کے نام بتائے۔ وہ فتنوں کے علم میں ماہر تھے۔ انہوں نے کئی لڑائیوں میں حصہ لیا اور اپنی ذہانت اور حکمت کے لیے مشہور تھے۔ انہوں نے عمر کے دور میں مدائن کے گورنر کی حیثیت سے خدمات انجام دیں۔',
      'descriptionHindi':
          'हज़रत हुज़ैफ़ा बिन अल-यमान (रज़ि.) को "राज़ के अमीन" के नाम से जाना जाता था क्योंकि नबी ﷺ ने उन्हें मुनाफ़िक़ों के नाम बताए। वे फ़ित्नों के इल्म में माहिर थे। उन्होंने कई लड़ाइयों में हिस्सा लिया और अपनी ज़ेहानत और हिकमत के लिए मशहूर थे। उन्होंने उमर के दौर में मदाइन के गवर्नर की हैसियत से ख़िदमात अंजाम दीं।',
    },
    {
      'name': 'أبو هريرة',
      'transliteration': 'Abu Hurayrah',
      'meaning': 'Father of the Kitten',
      'meaningUrdu': 'بلی والا',
      'meaningHindi': 'बिल्ली वाला',
      'description':
          'Abu Hurayrah (RA) is the most prolific narrator of hadith, transmitting over 5,300 hadiths. His real name was Abdur Rahman. He was called Abu Hurayrah because he loved cats and would carry a kitten with him. He accepted Islam in 7 AH and stayed close to the Prophet ﷺ, memorizing his teachings. He was known for his exceptional memory.',
      'descriptionUrdu':
          'حضرت ابوہریرہ رضی اللہ عنہ سب سے زیادہ حدیثیں روایت کرنے والے صحابی ہیں، انہوں نے 5,300 سے زیادہ حدیثیں روایت کیں۔ ان کا اصل نام عبدالرحمن تھا۔ انہیں ابوہریرہ کہا جاتا تھا کیونکہ وہ بلیوں سے محبت کرتے تھے اور ایک بلی کا بچہ ساتھ رکھتے تھے۔ انہوں نے 7 ہجری میں اسلام قبول کیا اور نبی ﷺ کے قریب رہ کر ان کی تعلیمات یاد کیں۔ وہ اپنی غیر معمولی یادداشت کے لیے مشہور تھے۔',
      'descriptionHindi':
          'हज़रत अबू हुरैरा (रज़ि.) सबसे ज़्यादा हदीसें रिवायत करने वाले सहाबी हैं, उन्होंने 5,300 से ज़्यादा हदीसें रिवायत कीं। उनका असल नाम अब्दुर्रहमान था। उन्हें अबू हुरैरा कहा जाता था क्योंकि वे बिल्लियों से मुहब्बत करते थे और एक बिल्ली का बच्चा साथ रखते थे। उन्होंने 7 हिजरी में इस्लाम क़बूल किया और नबी ﷺ के क़रीब रहकर उनकी तालीमात याद कीं। वे अपनी ग़ैर-मामूली याददाश्त के लिए मशहूर थे।',
    },
    {
      'name': 'عبد الله بن مسعود',
      'transliteration': 'Abdullah ibn Masud',
      'meaning': 'The Scholar',
      'meaningUrdu': 'عالم',
      'meaningHindi': 'आलिम',
      'description':
          'Abdullah ibn Masud (RA) was among the first to accept Islam and the first to recite the Quran publicly in Makkah. The Prophet told people to learn the Quran from him. He was extremely knowledgeable in Quran and its interpretation. He served as a teacher and judge, and his students became great scholars of Islam.',
      'descriptionUrdu':
          'حضرت عبداللہ بن مسعود رضی اللہ عنہ اسلام قبول کرنے والے پہلے لوگوں میں سے اور مکہ میں قرآن کھلے عام پڑھنے والے پہلے شخص تھے۔ نبی ﷺ نے لوگوں کو ان سے قرآن سیکھنے کو کہا۔ وہ قرآن اور اس کی تفسیر میں انتہائی عالم تھے۔ انہوں نے استاد اور قاضی کی حیثیت سے خدمات انجام دیں، اور ان کے شاگرد اسلام کے عظیم علماء بنے۔',
      'descriptionHindi':
          'हज़रत अब्दुल्लाह बिन मसऊद (रज़ि.) इस्लाम क़बूल करने वाले पहले लोगों में से और मक्का में क़ुरान खुले आम पढ़ने वाले पहले शख़्स थे। नबी ﷺ ने लोगों को उनसे क़ुरान सीखने को कहा। वे क़ुरान और उसकी तफ़सीर में बेहद आलिम थे। उन्होंने उस्ताद और क़ाज़ी की हैसियत से ख़िदमात अंजाम दीं, और उनके शागिर्द इस्लाम के अज़ीम उलेमा बने।',
    },
    {
      'name': 'عبد الله بن عباس',
      'transliteration': 'Abdullah ibn Abbas',
      'meaning': 'The Ocean of Knowledge',
      'meaningUrdu': 'علم کا سمندر',
      'meaningHindi': 'इल्म का समंदर',
      'description':
          'Abdullah ibn Abbas (RA) was the cousin of the Prophet ﷺ and is called "The Ocean of Knowledge" and "The Interpreter of the Quran." The Prophet prayed for him to understand the Quran deeply. He was a great scholar of tafsir (Quranic interpretation) and fiqh (Islamic jurisprudence). He became blind in old age but continued teaching.',
      'descriptionUrdu':
          'حضرت عبداللہ بن عباس رضی اللہ عنہ نبی ﷺ کے چچا زاد بھائی تھے اور انہیں "علم کا سمندر" اور "قرآن کے مفسر" کہا جاتا ہے۔ نبی ﷺ نے ان کے لیے قرآن کی گہری سمجھ کی دعا کی۔ وہ تفسیر اور فقہ کے عظیم عالم تھے۔ بڑھاپے میں ان کی بینائی جاتی رہی لیکن انہوں نے پڑھانا جاری رکھا۔',
      'descriptionHindi':
          'हज़रत अब्दुल्लाह बिन अब्बास (रज़ि.) नबी ﷺ के चचाज़ाद भाई थे और उन्हें "इल्म का समंदर" और "क़ुरान के मुफ़स्सिर" कहा जाता है। नबी ﷺ ने उनके लिए क़ुरान की गहरी समझ की दुआ की। वे तफ़सीर और फ़िक़्ह के अज़ीम आलिम थे। बुढ़ापे में उनकी बीनाई चली गई लेकिन उन्होंने पढ़ाना जारी रखा।',
    },
    {
      'name': 'عبد الله بن عمر',
      'transliteration': 'Abdullah ibn Umar',
      'meaning': 'The Devout',
      'meaningUrdu': 'عبادت گزار',
      'meaningHindi': 'इबादतगुज़ार',
      'description':
          'Abdullah ibn Umar (RA) was the son of Caliph Umar and was known for strictly following the Sunnah of the Prophet ﷺ. He would go to the exact places the Prophet went and do exactly as he did. He narrated many hadiths and was extremely cautious about religious rulings. He lived a simple, devout life and avoided political positions.',
      'descriptionUrdu':
          'حضرت عبداللہ بن عمر رضی اللہ عنہ خلیفہ عمر کے بیٹے تھے اور نبی ﷺ کی سنت کی سختی سے پیروی کے لیے مشہور تھے۔ وہ وہاں جاتے جہاں نبی ﷺ گئے اور بالکل ویسا ہی کرتے۔ انہوں نے بہت سی حدیثیں روایت کیں اور مذہبی احکام میں انتہائی محتاط تھے۔ انہوں نے سادہ، عبادت گزار زندگی گزاری اور سیاسی عہدوں سے گریز کیا۔',
      'descriptionHindi':
          'हज़रत अब्दुल्लाह बिन उमर (रज़ि.) ख़लीफ़ा उमर के बेटे थे और नबी ﷺ की सुन्नत की सख़्ती से पैरवी के लिए मशहूर थे। वे वहां जाते जहां नबी ﷺ गए और बिल्कुल वैसा ही करते। उन्होंने बहुत सी हदीसें रिवायत कीं और मज़हबी अहकाम में बेहद महतात थे। उन्होंने सादा, इबादतगुज़ार ज़िंदगी गुज़ारी और सियासी ओहदों से गुरेज़ किया।',
    },
    {
      'name': 'أنس بن مالك',
      'transliteration': 'Anas ibn Malik',
      'meaning': 'Servant of the Prophet',
      'meaningUrdu': 'نبی کا خادم',
      'meaningHindi': 'नबी का ख़ादिम',
      'description':
          'Anas (RA) served the Prophet ﷺ for ten years from the age of ten. The Prophet never said a harsh word to him or complained about anything he did. He narrated over 2,200 hadiths and was the last of the major companions to pass away in Basra. He was blessed with long life, many children, and abundant provision as the Prophet prayed for him.',
      'descriptionUrdu':
          'حضرت انس بن مالک رضی اللہ عنہ نے دس سال کی عمر سے دس سال تک نبی ﷺ کی خدمت کی۔ نبی ﷺ نے کبھی ان سے سخت بات نہیں کی اور نہ ہی ان کے کسی کام پر شکایت کی۔ انہوں نے 2,200 سے زیادہ حدیثیں روایت کیں اور بصرہ میں وفات پانے والے آخری بڑے صحابی تھے۔ نبی ﷺ کی دعا سے انہیں لمبی عمر، کثیر اولاد اور فراوانی کی نعمت ملی۔',
      'descriptionHindi':
          'हज़रत अनस बिन मालिक (रज़ि.) ने दस साल की उम्र से दस साल तक नबी ﷺ की ख़िदमत की। नबी ﷺ ने कभी उनसे सख़्त बात नहीं की और न ही उनके किसी काम पर शिकायत की। उन्होंने 2,200 से ज़्यादा हदीसें रिवायत कीं और बसरा में वफ़ात पाने वाले आख़िरी बड़े सहाबी थे। नबी ﷺ की दुआ से उन्हें लंबी उम्र, कसीर औलाद और फ़रावानी की नेमत मिली।',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredNames = _sahabaNames;
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
        _filteredNames = _sahabaNames;
      } else {
        _filteredNames = _sahabaNames.where((name) {
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

  String _transliterateToHindi(String text) {
    final Map<String, String> map = {
      'Abu Bakr As-Siddiq': 'अबू बक्र सिद्दीक़',
      'Umar ibn Al-Khattab': 'उमर बिन अल-ख़त्ताब',
      'Uthman ibn Affan': 'उस्मान बिन अफ़्फ़ान',
      'Ali ibn Abi Talib': 'अली बिन अबी तालिब',
      'Talha ibn Ubaydullah': 'तल्हा बिन उबैदुल्लाह',
      'Zubayr ibn Al-Awwam': 'ज़ुबैर बिन अल-अव्वाम',
      'Abdur Rahman ibn Awf': 'अब्दुर्रहमान बिन औफ़',
      'Saad ibn Abi Waqqas': 'साद बिन अबी वक़्क़ास',
      'Said ibn Zayd': 'सईद बिन ज़ैद',
      'Abu Ubayda ibn Al-Jarrah': 'अबू उबैदा बिन अल-जर्राह',
      'Bilal ibn Rabah': 'बिलाल बिन रबाह',
      'Abu Dharr Al-Ghifari': 'अबू ज़र ग़िफ़ारी',
      'Salman Al-Farsi': 'सलमान फ़ारसी',
      'Ammar ibn Yasir': 'अम्मार बिन यासिर',
      'Hudhayfah ibn Al-Yaman': 'हुज़ैफ़ा बिन अल-यमान',
      'Abu Hurayrah': 'अबू हुरैरा',
      'Abdullah ibn Masud': 'अब्दुल्लाह बिन मसऊद',
      'Abdullah ibn Abbas': 'अब्दुल्लाह बिन अब्बास',
      'Abdullah ibn Umar': 'अब्दुल्लाह बिन उमर',
      'Anas ibn Malik': 'अनस बिन मालिक',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    final Map<String, String> map = {
      'Abu Bakr As-Siddiq': 'ابوبکر صدیق',
      'Umar ibn Al-Khattab': 'عمر بن الخطاب',
      'Uthman ibn Affan': 'عثمان بن عفان',
      'Ali ibn Abi Talib': 'علی بن ابی طالب',
      'Talha ibn Ubaydullah': 'طلحہ بن عبیداللہ',
      'Zubayr ibn Al-Awwam': 'زبیر بن العوام',
      'Abdur Rahman ibn Awf': 'عبدالرحمان بن عوف',
      'Saad ibn Abi Waqqas': 'سعد بن ابی وقاص',
      'Said ibn Zayd': 'سعید بن زید',
      'Abu Ubayda ibn Al-Jarrah': 'ابو عبیدہ بن الجراح',
      'Bilal ibn Rabah': 'بلال بن رباح',
      'Abu Dharr Al-Ghifari': 'ابوذر غفاری',
      'Salman Al-Farsi': 'سلمان فارسی',
      'Ammar ibn Yasir': 'عمار بن یاسر',
      'Hudhayfah ibn Al-Yaman': 'حذیفہ بن الیمان',
      'Abu Hurayrah': 'ابوہریرہ',
      'Abdullah ibn Masud': 'عبداللہ بن مسعود',
      'Abdullah ibn Abbas': 'عبداللہ بن عباس',
      'Abdullah ibn Umar': 'عبداللہ بن عمر',
      'Anas ibn Malik': 'انس بن مالک',
    };
    return map[text] ?? text;
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
        title: Text(context.tr('sahaba_names')),
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
                          context.tr('no_companions_found'),
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
                      final originalIndex = _sahabaNames.indexOf(name) + 1;
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
                category: 'Companion of Prophet ﷺ',
                number: index,
                icon: Icons.people,
                color: Colors.blue,
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

              // Companion Name
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
