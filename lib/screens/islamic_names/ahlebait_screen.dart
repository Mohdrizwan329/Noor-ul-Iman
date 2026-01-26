import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'islamic_name_detail_screen.dart';

class AhlebaitScreen extends StatefulWidget {
  const AhlebaitScreen({super.key});

  @override
  State<AhlebaitScreen> createState() => _AhlebaitScreenState();
}

class _AhlebaitScreenState extends State<AhlebaitScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredNames = [];

  final List<Map<String, dynamic>> _ahlebaitNames = [
    {
      'name': 'محمد ﷺ',
      'transliteration': 'Muhammad ﷺ',
      'relation': 'Prophet of Allah',
      'relationUrdu': 'اللہ کے نبی',
      'relationHindi': 'अल्लाह के नबी',
      'description':
          'Prophet Muhammad ﷺ is the head of Ahlul Bayt and the final messenger of Allah. Born in 570 CE in Makkah, he received prophethood at age 40. He is Al-Amin (The Trustworthy), sent as a mercy to all worlds. He brought the Quran and established Islam. He said: "I am leaving behind two weighty things: the Book of Allah and my Ahlul Bayt. They will never separate until they meet me at the Pool (of Kawthar)."',
      'descriptionUrdu':
          'نبی محمد ﷺ اہل بیت کے سربراہ اور اللہ کے آخری رسول ہیں۔ 570 عیسوی میں مکہ میں پیدا ہوئے، 40 سال کی عمر میں نبوت ��لی۔ وہ الامین (قابل اعتماد) ہیں، تمام جہانوں کے لیے رحمت بن کر بھیجے گئے۔ انہوں نے قرآن لایا اور اسلام قائم کیا۔ فرمایا: "میں تمہارے درمیان دو بھاری چیزیں چھوڑ کر جا رہا ہوں: اللہ کی کتاب اور میرے اہل بیت۔ یہ کبھی جدا نہیں ہوں گے جب تک حوض (کوثر) پر مجھ سے نہ ملیں۔"',
      'descriptionHindi':
          'नबी मुहम्मद ﷺ अहले-बैत के सरबराह और अल्लाह के आख़िरी रसूल हैं। 570 ई. में मक्का में पैदा हुए, 40 साल की उम्र में नबुव्वत मिली। वे अल-अमीन (क़ाबिल-ए-एतिमाद) हैं, तमाम जहानों के लिए रहमत बनकर भेजे गए। उन्होंने क़ुरआन लाया और इस्लाम क़ायम किया। फ़रमाया: "मैं तुम्हारे दरमियान दो भारी चीज़ें छोड़कर जा रहा हूं: अल्लाह की किताब और मेरे अहले-बैत। ये कभी जुदा नहीं होंगे जब तक हौज़ (कौसर) पर मुझसे न मिलें।"',
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
      'knownFor': 'Final Prophet, Founder of Islam, Received the Quran',
    },
    {
      'name': 'خديجة',
      'transliteration': 'Khadijah bint Khuwaylid',
      'relation': 'Wife of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی زوجہ',
      'relationHindi': 'नबी ﷺ की ज़ौजा',
      'description':
          'Khadijah (RA) was the first wife of Prophet Muhammad ﷺ and the first person to accept Islam. She was a successful businesswoman who proposed marriage to the Prophet. She supported him emotionally and financially during the difficult early years of Islam. She bore all his children except Ibrahim. The Prophet never forgot her love and loyalty. Angel Jibreel conveyed Allah\'s salam to her and gave her glad tidings of a palace in Paradise. She is one of the four perfect women of all time.',
      'descriptionUrdu':
          'خدیجہ (رض) نبی محمد ﷺ کی پہلی بیوی اور اسلام قبول کرنے والی پہلی شخصیت تھیں۔ وہ ایک کامیاب تاجر خاتون تھیں جنہوں نے نبی کو شادی کی پیشکش کی۔ انہوں نے اسلام کے مشکل ابتدائی سالوں میں جذباتی اور مالی طور پر ان کی مدد کی۔ ابراہیم کے علاوہ ان کے تمام بچے انہی سے ہوئے۔ نبی ﷺ ان کی محبت اور وفاداری کبھی نہیں بھولے۔ فرشتہ جبرائیل نے انہیں اللہ کا سلام پہنچایا اور جنت میں ایک محل کی خوشخبری دی۔ وہ تاریخ کی چار کامل خواتین میں سے ایک ہیں۔',
      'descriptionHindi':
          'ख़दीजा (र.अ.) नबी मुहम्मद ﷺ की पहली बीवी और इस्लाम क़बूल करने वाली पहली शख़्सियत थीं। वे एक कामयाब ताजिर ख़ातून थीं जिन्होंने नबी को शादी की पेशकश की। उन्होंने इस्लाम के मुश्किल इब्तिदाई सालों में जज़्बाती और माली तौर पर उनकी मदद की। इब्राहीम के अलावा उनके तमाम बच्चे उन्हीं से हुए। नबी ﷺ उनकी मुहब्बत और वफ़ादारी कभी नहीं भूले। फ़रिश्ता जिब्राईल ने उन्हें अल्लाह का सलाम पहुंचाया और जन्नत में एक महल की ख़ुशख़बरी दी। वे तारीख़ की चार कामिल ख़वातीन में से एक हैं।',
      'fatherName': 'Khuwaylid ibn Asad',
      'motherName': 'Fatimah bint Za\'idah',
      'birthDate': '555 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '10 Ramadan, 3 BH (619 CE)',
      'deathPlace': 'Makkah, Arabia',
      'spouse': 'Prophet Muhammad ﷺ',
      'children': 'Qasim, Abdullah, Zaynab, Ruqayyah, Umm Kulthum, Fatimah',
      'tribe': 'Quraysh (Banu Asad)',
      'knownFor': 'First Muslim, First wife of Prophet, Mother of Believers',
    },
    {
      'name': 'علي',
      'transliteration': 'Ali ibn Abi Talib',
      'relation': 'Cousin & Son-in-law',
      'relationUrdu': 'چچا زاد اور داماد',
      'relationHindi': 'चचाज़ाद और दामाद',
      'description':
          'Imam Ali (AS) was the cousin of the Prophet ﷺ, raised in his household, and married to his daughter Fatimah. He was the first male to accept Islam and was born inside the Kaaba. Known as Asadullah (Lion of Allah), he never fled from battle. The Prophet said: "Ali is from me and I am from Ali." He was the father of Hasan and Husayn, and the fourth Caliph. He was known for his justice, wisdom, bravery, and worship.',
      'descriptionUrdu':
          'امام علی (ع) نبی ﷺ کے چچا زاد تھے، ان کے گھر میں پرورش پائی، اور ان کی بیٹی فاطمہ سے شادی کی۔ وہ اسلام قبول کرنے والے پہلے مرد تھے اور کعبہ کے اندر پیدا ہوئے۔ اسد اللہ (اللہ کا شیر) کے نام سے مشہور، کبھی میدان جنگ سے نہیں بھاگے۔ نبی ﷺ نے فرمایا: "علی مجھ سے ہے اور میں علی سے ہوں۔" وہ حسن و حسین کے والد اور چوتھے خلیفہ تھے۔ اپنے انصاف، حکمت، بہادری اور عبادت کے لیے مشہور تھے۔',
      'descriptionHindi':
          'इमाम अली (अ.स.) नबी ﷺ के चचाज़ाद थे, उनके घर में परवरिश पाई, और उनकी बेटी फ़ातिमा से शादी की। वे इस्लाम क़बूल करने वाले पहले मर्द थे और काबा के अंदर पैदा हुए। असदुल्लाह (अल्लाह का शेर) के नाम से मशहूर, कभी मैदान-ए-जंग से नहीं भागे। नबी ﷺ ने फ़रमाया: "अली मुझसे है और मैं अली से हूं।" वे हसन व हुसैन के वालिद और चौथे ख़लीफ़ा थे। अपने इंसाफ़, हिकमत, बहादुरी और इबादत के लिए मशहूर थे।',
      'fatherName': 'Abu Talib ibn Abd al-Muttalib',
      'motherName': 'Fatimah bint Asad',
      'birthDate': '13 Rajab, 30 BH (600 CE)',
      'birthPlace': 'Inside the Kaaba, Makkah',
      'deathDate': '21 Ramadan, 40 AH (661 CE)',
      'deathPlace': 'Kufa, Iraq (Martyred)',
      'spouse': 'Fatimah bint Muhammad',
      'children': 'Hasan, Husayn, Zaynab, Umm Kulthum',
      'era': '656-661 CE (Caliphate)',
      'knownFor': 'First Imam, Fourth Caliph, Lion of Allah, Bab al-Ilm',
    },
    {
      'name': 'فاطمة',
      'transliteration': 'Fatimah Az-Zahra',
      'relation': 'Daughter of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی بیٹی',
      'relationHindi': 'नबी ﷺ की बेटी',
      'description':
          'Fatimah (AS) was the beloved daughter of the Prophet ﷺ from Khadijah. She is called "part of me" by the Prophet - whoever angers her angers him. She is the leader of the women of Paradise. She married Ali and was the mother of Hasan, Husayn, Zaynab, and Umm Kulthum. Through her, the Prophet\'s lineage continues. The verse of purification was revealed about her family. She lived a life of simplicity, worship, and charity.',
      'descriptionUrdu':
          'فاطمہ (ع) نبی ﷺ کی خدیجہ سے محبوب بیٹی تھیں۔ نبی ﷺ نے انہیں "میرا ٹکڑا" کہا - جس نے انہیں ناراض کیا اس نے مجھے ناراض کیا۔ وہ جنت کی خواتین کی سردار ہیں۔ انہوں نے علی سے شادی کی اور حسن، حسین، زینب اور ام کلثوم کی ماں تھیں۔ ان کے ذریعے نبی ﷺ کا سلسلہ نسب جاری ہے۔ آیت تطہیر ان کے خاندان کے بارے میں نازل ہوئی۔ انہوں نے سادگی، عبادت اور خیرات کی زندگی گزاری۔',
      'descriptionHindi':
          'फ़ातिमा (अ.स.) नबी ﷺ की ख़दीजा से महबूब बेटी थीं। नबी ﷺ ने उन्हें "मेरा टुकड़ा" कहा - जिसने उन्हें नाराज़ किया उसने मुझे नाराज़ किया। वे जन्नत की ख़वातीन की सरदार हैं। उन्होंने अली से शादी की और हसन, हुसैन, ज़ैनब और उम्मे कुलसूम की माँ थीं। उनके ज़रिए नबी ﷺ का सिलसिला-ए-नसब जारी है। आयत-ए-तत्हीर उनके ख़ानदान के बारे में नाज़िल हुई। उन्होंने सादगी, इबादत और ख़ैरात की ज़िंदगी गुज़ारी।',
      'fatherName': 'Prophet Muhammad ﷺ',
      'motherName': 'Khadijah bint Khuwaylid',
      'birthDate': '20 Jumada al-Thani, 5 BH (615 CE)',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '3 Jumada al-Thani, 11 AH (632 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Ali ibn Abi Talib',
      'children': 'Hasan, Husayn, Zaynab, Umm Kulthum, Muhsin',
      'title': 'Az-Zahra (The Radiant), Sayyidatu Nisa al-Alamin',
      'knownFor': 'Leader of Women of Paradise, Mother of the Imams',
    },
    {
      'name': 'الحسن',
      'transliteration': 'Hasan ibn Ali',
      'relation': 'Grandson of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کے نواسے',
      'relationHindi': 'नबी ﷺ के नवासे',
      'description':
          'Imam Hasan (AS) was the elder grandson of Prophet Muhammad ﷺ, born to Ali and Fatimah. The Prophet loved him dearly and said he and Husayn are "leaders of the youth of Paradise." He resembled the Prophet in appearance. He was known for his generosity, patience, and piety. He made peace with Muawiyah to prevent Muslim bloodshed. He was poisoned and is buried in Jannat al-Baqi, Madinah.',
      'descriptionUrdu':
          'امام حسن (ع) نبی محمد ﷺ کے بڑے نواسے تھے، علی اور فاطمہ سے پیدا ہوئے۔ نبی ﷺ انہیں بہت پیار کرتے تھے اور فرمایا وہ اور حسین "جنت کے نوجوانوں کے سردار" ہیں۔ وہ شکل میں نبی ﷺ سے ملتے تھے۔ اپنی سخاوت، صبر اور تقویٰ کے لیے مشہور تھے۔ انہوں نے مسلمانوں کی خونریزی روکنے کے لیے معاویہ سے صلح کی۔ انہیں زہر دیا گیا اور جنت البقیع مدینہ میں مدفون ہیں۔',
      'descriptionHindi':
          'इमाम हसन (अ.स.) नबी मुहम्मद ﷺ के बड़े नवासे थे, अली और फ़ातिमा से पैदा हुए। नबी ﷺ उन्हें बहुत प्यार करते थे और फ़रमाया वे और हुसैन "जन्नत के नौजवानों के सरदार" हैं। वे शक्ल में नबी ﷺ से मिलते थे। अपनी सख़ावत, सब्र और तक़वा के लिए मशहूर थे। उन्होंने मुसलमानों की ख़ूंरेज़ी रोकने के लिए मुआविया से सुलह की। उन्हें ज़हर दिया गया और जन्नतुल बक़ी मदीना में मदफ़ून हैं।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '15 Ramadan, 3 AH (625 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '28 Safar, 50 AH (670 CE)',
      'deathPlace': 'Madinah (Poisoned)',
      'spouse': 'Ja\'da bint al-Ash\'ath, Umm Ishaq',
      'children': 'Zayd, Hasan, Qasim, Abdullah',
      'title': 'Al-Mujtaba (The Chosen One)',
      'knownFor': 'Second Imam, Leader of Youth of Paradise, Peace Maker',
    },
    {
      'name': 'الحسين',
      'transliteration': 'Husayn ibn Ali',
      'relation': 'Grandson of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کے نواسے',
      'relationHindi': 'नबी ﷺ के नवासे',
      'description':
          'Imam Husayn (AS) was the younger grandson of the Prophet ﷺ. The Prophet said "Husayn is from me and I am from Husayn." He stood against tyranny at Karbala in 680 CE, where he and 72 companions were martyred. His sacrifice symbolizes the eternal struggle of truth against falsehood. His sister Zaynab preserved his message. Millions visit his shrine in Karbala annually. Muharram commemorates his martyrdom.',
      'descriptionUrdu':
          'امام حسین (ع) نبی ﷺ کے چھوٹے نواسے تھے۔ نبی ﷺ نے فرمایا "حسین مجھ سے ہے اور میں حسین سے ہوں۔" انہوں نے 680 عیسوی میں کربلا میں ظلم کے خلاف کھڑے ہوکر 72 ساتھیوں سمیت شہادت پائی۔ ان کی قربانی حق کی باطل کے خلاف ابدی جدوجہد کی علامت ہے۔ ان کی بہن زینب نے ان کا پیغام محفوظ کیا۔ کربلا میں ان کے مزار کی سالانہ لاکھوں زیارت کرتے ہیں۔ محرم ان کی شہادت کی یاد ہے۔',
      'descriptionHindi':
          'इमाम हुसैन (अ.स.) नबी ﷺ के छोटे नवासे थे। नबी ﷺ ने फ़रमाया "हुसैन मुझसे है और मैं हुसैन से हूं।" उन्होंने 680 ई. में कर्बला में ज़ुल्म के ख़िलाफ़ खड़े होकर 72 साथियों समेत शहादत पाई। उनकी क़ुर्बानी हक़ की बातिल के ख़िलाफ़ अबदी जद्दोजहद की निशानी है। उनकी बहन ज़ैनब ने उनका पैग़ाम महफ़ूज़ किया। कर्बला में उनके मज़ार की सालाना लाखों ज़ियारत करते हैं। मुहर्रम उनकी शहादत की याद है।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '3 Sha\'ban, 4 AH (626 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '10 Muharram, 61 AH (680 CE)',
      'deathPlace': 'Karbala, Iraq (Martyred)',
      'spouse': 'Shahrbanu, Rabab, Layla',
      'children': 'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah',
      'title': 'Sayyid al-Shuhada (Master of Martyrs)',
      'knownFor': 'Third Imam, Hero of Karbala, Symbol of Sacrifice',
    },
    {
      'name': 'زينب',
      'transliteration': 'Zaynab bint Ali',
      'relation': 'Granddaughter of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی نواسی',
      'relationHindi': 'नबी ﷺ की नवासी',
      'description':
          'Sayyidah Zaynab (AS) was the daughter of Ali and Fatimah, and granddaughter of the Prophet ﷺ. She was present at Karbala and witnessed the martyrdom of her brother Husayn and many family members. After Karbala, she delivered powerful sermons in the courts of Ibn Ziyad and Yazid, preserving the message of Husayn\'s sacrifice. She is known as the "Heroine of Karbala" for her courage and eloquence. Her shrine in Damascus is a major pilgrimage site.',
      'descriptionUrdu':
          'سیدہ زینب (ع) علی اور فاطمہ کی بیٹی اور نبی ﷺ کی نواسی تھیں۔ وہ کربلا میں موجود تھیں اور اپنے بھائی حسین اور بہت سے خاندان کے افراد کی شہادت دیکھی۔ کربلا کے بعد انہوں نے ابن زیاد اور یزید کے درباروں میں طاقتور خطبات دیے، حسین کی قربانی کا پیغام محفوظ کیا۔ انہیں اپنی ہمت اور فصاحت کے لیے "کربلا کی ہیروئن" کہا جاتا ہے۔ دمشق میں ان کا مزار ایک اہم زیارت گاہ ہے۔',
      'descriptionHindi':
          'सय्यिदा ज़ैनब (अ.स.) अली और फ़ातिमा की बेटी और नबी ﷺ की नवासी थीं। वे कर्बला में मौजूद थीं और अपने भाई हुसैन और बहुत से ख़ानदान के अफ़राद की शहादत देखी। कर्बला के बाद उन्होंने इब्न ज़ियाद और यज़ीद के दरबारों में ताक़तवर ख़ुत्बात दिए, हुसैन की क़ुर्बानी का पैग़ाम महफ़ूज़ किया। उन्हें अपनी हिम्मत और फ़साहत के लिए "कर्बला की हीरोइन" कहा जाता है। दमिश्क़ में उनका मज़ार एक अहम ज़ियारतगाह है।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '5 Jumada al-Awwal, 6 AH (627 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': '15 Rajab, 62 AH (682 CE)',
      'deathPlace': 'Damascus, Syria',
      'spouse': 'Abdullah ibn Ja\'far',
      'children': 'Ali, Aun, Muhammad, Umm Kulthum',
      'title': 'Aqilat Bani Hashim (Wise Woman of Banu Hashim)',
      'knownFor':
          'Heroine of Karbala, Preserved Husayn\'s message, Eloquent speaker',
    },
    {
      'name': 'أم كلثوم',
      'transliteration': 'Umm Kulthum bint Ali',
      'relation': 'Granddaughter of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی نواسی',
      'relationHindi': 'नबी ﷺ की नवासी',
      'description':
          'Umm Kulthum (AS) was the daughter of Ali and Fatimah, and granddaughter of the Prophet ﷺ. She accompanied her sister Zaynab and the surviving family members after the tragedy of Karbala. She supported her sister in preserving the message of Husayn\'s sacrifice. She was known for her piety and patience during the difficult times the Ahlul Bayt faced.',
      'descriptionUrdu':
          'ام کلثوم (ع) علی اور فاطمہ کی بیٹی اور نبی ﷺ کی نواسی تھیں۔ انہوں نے کربلا کے سانحے کے بعد اپنی بہن زینب اور بچ جانے والے خاندان کے افراد کا ساتھ دیا۔ انہوں نے حسین کی قربانی کا پیغام محفوظ کرنے میں اپنی بہن کی مدد کی۔ وہ اہل بیت کے مشکل وقت میں اپنی تقویٰ اور صبر کے لیے مشہور تھیں۔',
      'descriptionHindi':
          'उम्मे कुलसूम (अ.स.) अली और फ़ातिमा की बेटी और नबी ﷺ की नवासी थीं। उन्होंने कर्बला के सानिहे के बाद अपनी बहन ज़ैनब और बच जाने वाले ख़ानदान के अफ़राद का साथ दिया। उन्होंने हुसैन की क़ुर्बानी का पैग़ाम महफ़ूज़ करने में अपनी बहन की मदद की। वे अहले-बैत के मुश्किल वक़्त में अपने तक़वा और सब्र के लिए मशहूर थीं।',
      'fatherName': 'Ali ibn Abi Talib',
      'motherName': 'Fatimah bint Muhammad',
      'birthDate': '6 AH (628 CE)',
      'birthPlace': 'Madinah, Arabia',
      'deathDate': 'After Karbala (exact date unknown)',
      'deathPlace': 'Unknown',
      'spouse': 'Umar ibn al-Khattab (disputed), Awn ibn Ja\'far',
      'children': 'Zayd, Ruqayyah',
      'title': 'Granddaughter of the Prophet',
      'knownFor': 'Supported Zaynab after Karbala, Piety and patience',
    },
    {
      'name': 'عائشة',
      'transliteration': 'Aisha bint Abi Bakr',
      'relation': 'Wife of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی زوجہ',
      'relationHindi': 'नबी ﷺ की ज़ौजा',
      'description':
          'Aisha (RA) was the daughter of Abu Bakr and wife of the Prophet ﷺ. She was one of the most learned women of her time, and many companions sought her knowledge of hadith, fiqh, and the Prophet\'s personal life. She narrated over 2,200 hadiths. The Prophet loved her dearly and passed away in her room with his head in her lap. She continued teaching Islam for decades after his death, and many great scholars learned from her.',
      'descriptionUrdu':
          'عائشہ (رض) ابوبکر کی بیٹی اور نبی ﷺ کی زوجہ تھیں۔ وہ اپنے وقت کی سب سے عالم خواتین میں سے تھیں، بہت سے صحابہ حدیث، فقہ اور نبی ﷺ کی ذاتی زندگی کے بارے میں ان سے علم حاصل کرتے۔ انہوں نے 2200 سے زیادہ احادیث روایت کیں۔ نبی ﷺ انہیں بہت پیار کرتے تھے اور ان کے کمرے میں سر ان کی گود میں رکھ کر وفات پائی۔ انہوں نے ان کی وفات کے بعد دہائیوں تک اسلام کی تعلیم جاری رکھی۔',
      'descriptionHindi':
          'आयशा (र.अ.) अबू बक्र की बेटी और नबी ﷺ की ज़ौजा थीं। वे अपने वक़्त की सबसे आलिम ख़वातीन में से थीं, बहुत से सहाबा हदीस, फ़िक़्ह और नबी ﷺ की ज़ाती ज़िंदगी के बारे में उनसे इल्म हासिल करते। उन्होंने 2200 से ज़्यादा अहादीस रिवायत कीं। नबी ﷺ उन्हें बहुत प्यार करते थे और उनके कमरे में सर उनकी गोद में रखकर वफ़ात पाई। उन्होंने उनकी वफ़ात के बाद दहाइयों तक इस्लाम की तालीम जारी रखी।',
      'fatherName': 'Abu Bakr al-Siddiq',
      'motherName': 'Umm Ruman',
      'birthDate': '613 or 614 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '17 Ramadan, 58 AH (678 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Prophet Muhammad ﷺ',
      'title': 'Umm al-Mu\'minin (Mother of the Believers)',
      'knownFor': 'Greatest female scholar, Narrated 2200+ hadiths, Teacher',
    },
    {
      'name': 'حفصة',
      'transliteration': 'Hafsa bint Umar',
      'relation': 'Wife of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی زوجہ',
      'relationHindi': 'नबी ﷺ की ज़ौजा',
      'description':
          'Hafsa (RA) was the daughter of Umar ibn Al-Khattab and wife of the Prophet ﷺ. She was known for her piety, knowledge, and strong character. After the Prophet\'s death, the original manuscript of the Quran compiled by Abu Bakr was entrusted to her for safekeeping. This manuscript was later used by Uthman when standardizing the Quran. She was devoted to fasting and prayer.',
      'descriptionUrdu':
          'حفصہ (رض) عمر بن الخطاب کی بیٹی اور نبی ﷺ کی زوجہ تھیں۔ وہ اپنی تقویٰ، علم اور مضبوط کردار کے لیے مشہور تھیں۔ نبی ﷺ کی وفات کے بعد ابوبکر کا مرتب کردہ قرآن کا اصل مسودہ حفاظت کے لیے انہیں سونپا گیا۔ یہ مسودہ بعد میں عثمان نے قرآن کی معیاری کاری کے وقت استعمال کیا۔ وہ روزے اور نماز کی پابند تھیں۔',
      'descriptionHindi':
          'हफ़सा (र.अ.) उमर बिन अल-ख़त्ताब की बेटी और नबी ﷺ की ज़ौजा थीं। वे अपने तक़वा, इल्म और मज़बूत किरदार के लिए मशहूर थीं। नबी ﷺ की वफ़ात के बाद अबू बक्र का मुरत्तब करदा क़ुरआन का असल मुसव्वदा हिफ़ाज़त के लिए उन्हें सौंपा गया। यह मुसव्वदा बाद में उस्मान ने क़ुरआन की मेयारीकारी के वक़्त इस्तेमाल किया। वे रोज़े और नमाज़ की पाबंद थीं।',
      'fatherName': 'Umar ibn al-Khattab',
      'motherName': 'Zaynab bint Maz\'un',
      'birthDate': '605 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '45 AH (665 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Prophet Muhammad ﷺ (previously Khunays ibn Hudhafa)',
      'title': 'Umm al-Mu\'minin (Mother of the Believers)',
      'knownFor': 'Guardian of the first Quran manuscript, Piety and fasting',
    },
    {
      'name': 'زينب بنت جحش',
      'transliteration': 'Zaynab bint Jahsh',
      'relation': 'Wife of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی زوجہ',
      'relationHindi': 'नबी ﷺ की ज़ौजा',
      'description':
          'Zaynab (RA) was the cousin of the Prophet ﷺ and became his wife after a divine command. She was known for her generosity, charitable works, and skill in leather work and crafts, the proceeds of which she gave to the poor. She was called "the Mother of the Poor." The Prophet said she would be the first of his wives to join him after death, and she passed away during Umar\'s caliphate.',
      'descriptionUrdu':
          'زینب (رض) نبی ﷺ کی چچا زاد تھیں اور الہٰی حکم کے بعد ان کی زوجہ بنیں۔ وہ اپنی سخاوت، خیراتی کاموں اور چمڑے کے کام اور دستکاری میں مہارت کے لیے مشہور تھیں، جن کی آمدنی غریبوں کو دیتیں۔ انہیں "غریبوں کی ماں" کہا جاتا تھا۔ نبی ﷺ نے فرمایا وہ ان کی بیویوں میں سب سے پہلے ان سے ملیں گی، اور انہوں نے عمر کی خلافت میں وفات پائی۔',
      'descriptionHindi':
          'ज़ैनब (र.अ.) नबी ﷺ की चचाज़ाद थीं और इलाही हुक्म के बाद उनकी ज़ौजा बनीं। वे अपनी सख़ावत, ख़ैराती कामों और चमड़े के काम और दस्तकारी में महारत के लिए मशहूर थीं, जिनकी आमदनी ग़रीबों को देतीं। उन्हें "ग़रीबों की माँ" कहा जाता था। नबी ﷺ ने फ़रमाया वे उनकी बीवियों में सबसे पहले उनसे मिलेंगी, और उन्होंने उमर की ख़िलाफ़त में वफ़ात पाई।',
      'fatherName': 'Jahsh ibn Ri\'ab',
      'motherName': 'Umaymah bint Abd al-Muttalib (Prophet\'s aunt)',
      'birthDate': '590 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '20 AH (641 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Prophet Muhammad ﷺ (previously Zayd ibn Haritha)',
      'title': 'Umm al-Mu\'minin (Mother of the Believers)',
      'knownFor':
          'Mother of the Poor, Generous charity, First to die after Prophet',
    },
    {
      'name': 'أم سلمة',
      'transliteration': 'Umm Salamah',
      'relation': 'Wife of Prophet ﷺ',
      'relationUrdu': 'نبی ﷺ کی زوجہ',
      'relationHindi': 'नबी ﷺ की ज़ौजा',
      'description':
          'Umm Salamah (RA) was known for her wisdom and intelligence. She gave the Prophet ﷺ crucial advice during the Treaty of Hudaybiyyah. She was among the early emigrants to Abyssinia and later to Madinah. She narrated many hadiths and was consulted by companions on religious matters. She was present at many important events in Islamic history and lived until the caliphate of Yazid, witnessing the tragedy of Karbala.',
      'descriptionUrdu':
          'ام سلمہ (رض) اپنی حکمت اور ذہانت کے لیے مشہور تھیں۔ انہوں نے صلح حدیبیہ کے موقع پر نبی ﷺ کو اہم مشورہ دیا۔ وہ حبشہ اور بعد میں مدینہ ہجرت کرنے والوں میں شامل تھیں۔ انہوں نے بہت سی احادیث روایت کیں اور صحابہ دینی معاملات میں ان سے مشورہ کرتے۔ وہ اسلامی تاریخ کے بہت سے اہم واقعات میں موجود تھیں اور یزید کی خلافت تک زندہ رہیں، کربلا کا سانحہ دیکھا۔',
      'descriptionHindi':
          'उम्मे सलमा (र.अ.) अपनी हिकमत और ज़हानत के लिए मशहूर थीं। उन्होंने सुलह-ए-हुदैबिया के मौक़े पर नबी ﷺ को अहम मश्वरा दिया। वे हबशा और बाद में मदीना हिजरत करने वालों में शामिल थीं। उन्होंने बहुत सी अहादीस रिवायत कीं और सहाबा दीनी मामलात में उनसे मश्वरा करते। वे इस्लामी तारीख़ के बहुत से अहम वाक़ेआत में मौजूद थीं और यज़ीद की ख़िलाफ़त तक ज़िंदा रहीं, कर्बला का सानिहा देखा।',
      'fatherName': 'Abu Umayya ibn al-Mughira',
      'motherName': 'Atikah bint Amir',
      'birthDate': '596 CE',
      'birthPlace': 'Makkah, Arabia',
      'deathDate': '61 AH (680 CE)',
      'deathPlace': 'Madinah, Arabia',
      'spouse': 'Prophet Muhammad ﷺ (previously Abu Salamah)',
      'children': 'Salamah, Umar, Zaynab, Durrah',
      'title': 'Umm al-Mu\'minin (Mother of the Believers)',
      'knownFor': 'Wisdom, Advice at Hudaybiyyah, Longest living wife',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredNames = _ahlebaitNames;
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
        _filteredNames = _ahlebaitNames;
      } else {
        _filteredNames = _ahlebaitNames.where((name) {
          final transliteration = name['transliteration']!.toLowerCase();
          final relation = name['relation']!.toLowerCase();
          final arabicName = name['name']!;
          return transliteration.contains(query) ||
              relation.contains(query) ||
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

  String _getDisplayRelation(Map<String, dynamic> name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name['relationUrdu'] ?? name['relation']!;
      case 'ur':
        return name['relationUrdu'] ?? name['relation']!;
      case 'hi':
        return name['relationHindi'] ?? name['relation']!;
      case 'en':
      default:
        return name['relation']!;
    }
  }

  String _transliterateToHindi(String text) {
    final Map<String, String> map = {
      'Muhammad ﷺ': 'मुहम्मद ﷺ',
      'Khadijah bint Khuwaylid': 'ख़दीजा बिन्त ख़ुवैलिद',
      'Ali ibn Abi Talib': 'अली बिन अबी तालिब',
      'Fatimah Az-Zahra': 'फ़ातिमा ज़हरा',
      'Hasan ibn Ali': 'हसन बिन अली',
      'Husayn ibn Ali': 'हुसैन बिन अली',
      'Zaynab bint Ali': 'ज़ैनब बिन्त अली',
      'Umm Kulthum bint Ali': 'उम्मे कुलसूम बिन्त अली',
      'Aisha bint Abi Bakr': 'आयशा बिन्त अबी बक्र',
      'Hafsa bint Umar': 'हफ़सा बिन्त उमर',
      'Zaynab bint Jahsh': 'ज़ैनब बिन्त जहश',
      'Umm Salamah': 'उम्मे सलमा',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    final Map<String, String> map = {
      'Muhammad ﷺ': 'محمد ﷺ',
      'Khadijah bint Khuwaylid': 'خدیجہ بنت خویلد',
      'Ali ibn Abi Talib': 'علی بن ابی طالب',
      'Fatimah Az-Zahra': 'فاطمہ زہرا',
      'Hasan ibn Ali': 'حسن بن علی',
      'Husayn ibn Ali': 'حسین بن علی',
      'Zaynab bint Ali': 'زینب بنت علی',
      'Umm Kulthum bint Ali': 'ام کلثوم بنت علی',
      'Aisha bint Abi Bakr': 'عائشہ بنت ابی بکر',
      'Hafsa bint Umar': 'حفصہ بنت عمر',
      'Zaynab bint Jahsh': 'زینب بنت جحش',
      'Umm Salamah': 'ام سلمہ',
    };
    return map[text] ?? text;
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
        title: Text(context.tr('ahlebait')),
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
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
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
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                        responsive.vSpaceRegular,
                        Text(
                          context.tr('no_members_found'),
                          style: TextStyle(
                            fontSize: responsive.textRegular,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                        responsive.vSpaceSmall,
                        Text(
                          context.tr('try_different_search'),
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(
                      langProvider.languageCode,
                    ), // Force rebuild when language changes
                    padding: responsive.paddingRegular,
                    itemCount: _filteredNames.length,
                    itemBuilder: (context, index) {
                      final name = _filteredNames[index];
                      final originalIndex = _ahlebaitNames.indexOf(name) + 1;
                      final displayName = _getDisplayName(
                        name,
                        langProvider.languageCode,
                      );
                      final displayRelation = _getDisplayRelation(
                        name,
                        langProvider.languageCode,
                      );
                      return _buildNameCard(
                        name: name,
                        index: originalIndex,
                        isDark: isDark,
                        displayName: displayName,
                        displayRelation: displayRelation,
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
    required String displayRelation,
    required String languageCode,
  }) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    return Builder(
      builder: (context) {
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
                      blurRadius: responsive.spacing(10),
                      offset: Offset(0, responsive.spacing(2)),
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
                    meaning: name['relation']!,
                    meaningUrdu: name['relationUrdu'] ?? '',
                    meaningHindi: name['relationHindi'] ?? '',
                    description: name['description']!,
                    descriptionUrdu: name['descriptionUrdu'] ?? '',
                    descriptionHindi: name['descriptionHindi'] ?? '',
                    category: 'Ahlul Bayt',
                    number: index,
                    icon: Icons.family_restroom,
                    color: Colors.teal,
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
                    knownFor: name['knownFor'],
                    era: name['era'],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            child: Padding(
              padding: responsive.paddingAll(14),
              child: Row(
                children: [
                  // Circular badge
                  Container(
                    width: responsive.spacing(50),
                    height: responsive.spacing(50),
                    decoration: BoxDecoration(
                      color: isDark ? emeraldGreen : darkGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          fontSize: responsive.textLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(14)),
                  // Name
                  Expanded(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textRegular,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                        fontFamily: languageCode == 'ar'
                            ? 'Amiri'
                            : (languageCode == 'ur' ? 'NotoNastaliq' : null),
                      ),
                      textDirection:
                          (languageCode == 'ar' || languageCode == 'ur')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                  // Circular forward arrow
                  Container(
                    width: responsive.spacing(32),
                    height: responsive.spacing(32),
                    decoration: BoxDecoration(
                      color: isDark
                          ? emeraldGreen.withValues(alpha: 0.2)
                          : const Color(0xFFE8F3ED),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: responsive.iconXSmall,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : emeraldGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
