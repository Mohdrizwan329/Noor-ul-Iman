import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class WazuScreen extends StatefulWidget {
  const WazuScreen({super.key});

  @override
  State<WazuScreen> createState() => _WazuScreenState();
}

class _WazuScreenState extends State<WazuScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Wudu - Complete Guide',
    'urdu': 'وضو کا طریقہ - مکمل رہنمائی',
    'hindi': 'वुज़ू का तरीका - संपूर्ण मार्गदर्शन',
  };

  final List<Map<String, dynamic>> _wazuSteps = [
    {
      'step': 1,
      'title': 'Intention (Niyyah)',
      'titleUrdu': 'نیت',
      'titleHindi': 'नीयत',
      'icon': Icons.favorite,
      'color': Colors.red,
      'details': {
        'english': '''Step 1: Intention (Niyyah)

Before starting Wudu, make the intention in your heart that you are performing Wudu for the pleasure of Allah and to purify yourself for worship.

Say (optional):
"بِسْمِ اللَّهِ"
"Bismillah" (In the name of Allah)

Niyyah is in the heart - you don't need to say it out loud, but saying Bismillah is Sunnah.

The Prophet ﷺ said: "Actions are judged by intentions." (Sahih Bukhari)

Important Points:
• The intention should be made before washing hands
• The intention is for purification, not just washing
• Be conscious that you are preparing to meet Allah in prayer''',
        'urdu': '''پہلا قدم: نیت

وضو شروع کرنے سے پہلے دل میں نیت کریں کہ آپ اللہ کی رضا کے لیے اور عبادت کے لیے پاکیزگی حاصل کرنے کے لیے وضو کر رہے ہیں۔

کہیں (اختیاری):
"بِسْمِ اللَّهِ"
"بسم اللہ" (اللہ کے نام سے)

نیت دل میں ہوتی ہے - آپ کو اسے بلند آواز سے کہنے کی ضرورت نہیں، لیکن بسم اللہ کہنا سنت ہے۔

نبی کریم ﷺ نے فرمایا: "اعمال کا دارومدار نیتوں پر ہے۔" (صحیح بخاری)

اہم نکات:
• نیت ہاتھ دھونے سے پہلے ہونی چاہیے
• نیت طہارت کے لیے ہو، صرف دھونے کے لیے نہیں
• یہ یاد رکھیں کہ آپ نماز میں اللہ سے ملنے کی تیاری کر رہے ہیں''',
        'hindi': '''पहला क़दम: नीयत

वुज़ू शुरू करने से पहले दिल में नीयत करें कि आप अल्लाह की रज़ा के लिए और इबादत के लिए पाकीज़गी हासिल करने के लिए वुज़ू कर रहे हैं।

कहें (वैकल्पिक):
"بِسْمِ اللَّهِ"
"बिस्मिल्लाह" (अल्लाह के नाम से)

नीयत दिल में होती है - आपको इसे बुलंद आवाज़ से कहने की ज़रूरत नहीं, लेकिन बिस्मिल्लाह कहना सुन्नत है।

नबी करीम ﷺ ने फ़रमाया: "आमाल का दारोमदार नीयतों पर है।" (सहीह बुख़ारी)

महत्वपूर्ण बातें:
• नीयत हाथ धोने से पहले होनी चाहिए
• नीयत तहारत के लिए हो, सिर्फ़ धोने के लिए नहीं
• यह याद रखें कि आप नमाज़ में अल्लाह से मिलने की तैयारी कर रहे हैं''',
      },
    },
    {
      'step': 2,
      'title': 'Wash Hands (3 times)',
      'titleUrdu': 'ہاتھ دھونا (3 بار)',
      'titleHindi': 'हाथ धोना (3 बार)',
      'icon': Icons.back_hand,
      'color': Colors.blue,
      'details': {
        'english': '''Step 2: Wash Both Hands (3 times)

Wash both hands up to the wrists three times. Make sure water reaches between the fingers.

Method:
1. Take water in your right hand
2. Pour water over the left hand
3. Rub hands together, including between fingers
4. Wash up to and including the wrists
5. Repeat this three times

Sunnah Actions:
• Start with the right hand
• Interlace fingers to wash between them
• Remove rings if they prevent water from reaching the skin

Important Points:
• Ensure no part of the hands remains dry
• Wash thoroughly but don't waste water
• The Prophet ﷺ used about one mudd (handful) of water for entire Wudu''',
        'urdu': '''دوسرا قدم: دونوں ہاتھ دھونا (3 بار)

دونوں ہاتھ کلائیوں تک تین بار دھوئیں۔ یقینی بنائیں کہ پانی انگلیوں کے درمیان پہنچے۔

طریقہ:
۱۔ دائیں ہاتھ میں پانی لیں
۲۔ بائیں ہاتھ پر پانی ڈالیں
۳۔ ہاتھوں کو آپس میں ملیں، انگلیوں کے درمیان بھی
۴۔ کلائیوں تک دھوئیں
۵۔ یہ تین بار دہرائیں

سنت اعمال:
• دائیں ہاتھ سے شروع کریں
• انگلیوں کو ایک دوسرے میں ڈال کر درمیان دھوئیں
• انگوٹھیاں اتار دیں اگر وہ پانی کو جلد تک پہنچنے سے روکتی ہوں

اہم نکات:
• یقینی بنائیں کہ ہاتھ کا کوئی حصہ خشک نہ رہے
• اچھی طرح دھوئیں لیکن پانی ضائع نہ کریں
• نبی کریم ﷺ پورے وضو کے لیے تقریباً ایک مد (مٹھی بھر) پانی استعمال کرتے تھے''',
        'hindi': '''दूसरा क़दम: दोनों हाथ धोना (3 बार)

दोनों हाथ कलाइयों तक तीन बार धोएं। यक़ीनी बनाएं कि पानी उंगलियों के दरमियान पहुंचे।

तरीक़ा:
१. दाएं हाथ में पानी लें
२. बाएं हाथ पर पानी डालें
३. हाथों को आपस में मलें, उंगलियों के दरमियान भी
४. कलाइयों तक धोएं
५. यह तीन बार दोहराएं

सुन्नत आमाल:
• दाएं हाथ से शुरू करें
• उंगलियों को एक दूसरे में डालकर दरमियान धोएं
• अंगूठियां उतार दें अगर वो पानी को जिल्द तक पहुंचने से रोकती हों

महत्वपूर्ण बातें:
• यक़ीनी बनाएं कि हाथ का कोई हिस्सा ख़ुश्क न रहे
• अच्छी तरह धोएं लेकिन पानी ज़ाया न करें
• नबी करीम ﷺ पूरे वुज़ू के लिए तक़रीबन एक मुद (मुट्ठी भर) पानी इस्तेमाल करते थे''',
      },
    },
    {
      'step': 3,
      'title': 'Rinse Mouth (3 times)',
      'titleUrdu': 'کلی کرنا (3 بار)',
      'titleHindi': 'कुल्ली करना (3 बार)',
      'icon': Icons.water_drop,
      'color': Colors.cyan,
      'details': {
        'english': '''Step 3: Rinse the Mouth (Madmadah) - 3 times

Take water in the right hand and rinse the mouth thoroughly three times.

Method:
1. Take water in your right palm
2. Put water in your mouth
3. Swirl it around, reaching all areas
4. Spit the water out
5. Repeat three times

Sunnah Actions:
• Use Miswak (tooth stick) before or during Wudu
• Rinse the mouth thoroughly
• If fasting, be careful not to swallow water

The Prophet ﷺ said: "Had I not feared hardship for my Ummah, I would have commanded them to use the Miswak before every prayer." (Sahih Bukhari)

Benefits:
• Cleanses the mouth
• Removes food particles
• Freshens breath for prayer''',
        'urdu': '''تیسرا قدم: کلی کرنا (مضمضہ) - 3 بار

دائیں ہاتھ میں پانی لے کر تین بار منہ میں اچھی طرح کلی کریں۔

طریقہ:
۱۔ دائیں ہتھیلی میں پانی لیں
۲۔ منہ میں پانی ڈالیں
۳۔ اسے چاروں طرف گھمائیں، تمام حصوں تک پہنچائیں
۴۔ پانی تھوک دیں
۵۔ تین بار دہرائیں

سنت اعمال:
• وضو سے پہلے یا دوران مسواک استعمال کریں
• منہ کو اچھی طرح کلی کریں
• اگر روزے سے ہوں تو پانی نگلنے سے بچیں

نبی کریم ﷺ نے فرمایا: "اگر مجھے اپنی امت پر مشقت کا خوف نہ ہوتا تو میں انہیں ہر نماز سے پہلے مسواک کرنے کا حکم دیتا۔" (صحیح بخاری)

فوائد:
• منہ صاف ہوتا ہے
• کھانے کے ذرات نکل جاتے ہیں
• نماز کے لیے سانس تازہ ہوتی ہے''',
        'hindi': '''तीसरा क़दम: कुल्ली करना (मज़मज़ा) - 3 बार

दाएं हाथ में पानी लेकर तीन बार मुंह में अच्छी तरह कुल्ली करें।

तरीक़ा:
१. दाएं हथेली में पानी लें
२. मुंह में पानी डालें
३. इसे चारों तरफ़ घुमाएं, तमाम हिस्सों तक पहुंचाएं
४. पानी थूक दें
५. तीन बार दोहराएं

सुन्नत आमाल:
• वुज़ू से पहले या दौरान मिस्वाक इस्तेमाल करें
• मुंह को अच्छी तरह कुल्ली करें
• अगर रोज़े से हों तो पानी निगलने से बचें

नबी करीम ﷺ ने फ़रमाया: "अगर मुझे अपनी उम्मत पर मशक़्क़त का ख़ौफ़ न होता तो मैं उन्हें हर नमाज़ से पहले मिस्वाक करने का हुक्म देता।" (सहीह बुख़ारी)

फ़वाइद:
• मुंह साफ़ होता है
• खाने के ज़र्रात निकल जाते हैं
• नमाज़ के लिए सांस ताज़ा होती है''',
      },
    },
    {
      'step': 4,
      'title': 'Clean Nose (3 times)',
      'titleUrdu': 'ناک صاف کرنا (3 بار)',
      'titleHindi': 'नाक साफ़ करना (3 बार)',
      'icon': Icons.air,
      'color': Colors.lightBlue,
      'details': {
        'english': '''Step 4: Clean the Nose (Istinshaq & Istinthar) - 3 times

Sniff water into the nose and blow it out three times.

Method:
1. Take water in your right palm
2. Sniff water into the nostrils (Istinshaq)
3. Use your left hand to blow it out (Istinthar)
4. Clean the nose thoroughly
5. Repeat three times

Sunnah Actions:
• Sniff water deeply (unless fasting)
• Use the left hand little finger and thumb to clean inside the nose
• Blow gently, not forcefully

The Prophet ﷺ said: "When one of you performs Wudu, let him sniff water into his nose, then blow it out." (Sahih Bukhari)

Important Points:
• If fasting, sniff gently to avoid water going down the throat
• Clean inside the nostrils properly
• This removes dust and impurities''',
        'urdu': '''چوتھا قدم: ناک صاف کرنا (استنشاق و استنثار) - 3 بار

ناک میں پانی چڑھائیں اور تین بار نکالیں۔

طریقہ:
۱۔ دائیں ہتھیلی میں پانی لیں
۲۔ ناک میں پانی چڑھائیں (استنشاق)
۳۔ بائیں ہاتھ سے ناک صاف کریں (استنثار)
۴۔ ناک کو اچھی طرح صاف کریں
۵۔ تین بار دہرائیں

سنت اعمال:
• پانی گہرائی تک چڑھائیں (جب تک روزے سے نہ ہوں)
• بائیں ہاتھ کی چھوٹی انگلی اور انگوٹھے سے ناک کے اندر صاف کریں
• آہستگی سے صاف کریں، زور سے نہیں

نبی کریم ﷺ نے فرمایا: "جب تم میں سے کوئی وضو کرے تو اپنی ناک میں پانی چڑھائے پھر اسے نکالے۔" (صحیح بخاری)

اہم نکات:
• اگر روزے سے ہوں تو آہستگی سے پانی چڑھائیں تاکہ حلق میں نہ جائے
• نتھنوں کے اندر اچھی طرح صاف کریں
• اس سے گرد اور ناپاکی دور ہوتی ہے''',
        'hindi': '''चौथा क़दम: नाक साफ़ करना (इस्तिनशाक़ व इस्तिन्सार) - 3 बार

नाक में पानी चढ़ाएं और तीन बार निकालें।

तरीक़ा:
१. दाएं हथेली में पानी लें
२. नाक में पानी चढ़ाएं (इस्तिनशाक़)
३. बाएं हाथ से नाक साफ़ करें (इस्तिन्सार)
४. नाक को अच्छी तरह साफ़ करें
५. तीन बार दोहराएं

सुन्नत आमाल:
• पानी गहराई तक चढ़ाएं (जब तक रोज़े से न हों)
• बाएं हाथ की छोटी उंगली और अंगूठे से नाक के अंदर साफ़ करें
• आहिस्तगी से साफ़ करें, ज़ोर से नहीं

नबी करीम ﷺ ने फ़रमाया: "जब तुम में से कोई वुज़ू करे तो अपनी नाक में पानी चढ़ाए फिर उसे निकाले।" (सहीह बुख़ारी)

महत्वपूर्ण बातें:
• अगर रोज़े से हों तो आहिस्तगी से पानी चढ़ाएं ताकि हल्क़ में न जाए
• नथनों के अंदर अच्छी तरह साफ़ करें
• इससे गर्द और नापाकी दूर होती है''',
      },
    },
    {
      'step': 5,
      'title': 'Wash Face (3 times)',
      'titleUrdu': 'چہرہ دھونا (3 بار)',
      'titleHindi': 'चेहरा धोना (3 बार)',
      'icon': Icons.face,
      'color': Colors.orange,
      'details': {
        'english': '''Step 5: Wash the Face (3 times)

Wash the entire face three times - from the hairline to below the chin, and from ear to ear.

Method:
1. Take water in both hands
2. Wash from the hairline to below the chin
3. Wash from one ear to the other ear
4. Ensure water reaches all parts of the face
5. Repeat three times

Boundaries of the Face:
• Top: Where the hair normally grows
• Bottom: Below the chin
• Sides: From ear to ear

Sunnah Actions:
• Run fingers through the beard if you have one (Takhleel)
• Make sure water reaches the skin beneath the beard
• Wash eyebrows and area around the eyes

Important Points:
• Don't miss the corners of the eyes
• Wash under the nose
• If beard is thick, run wet fingers through it
• Ensure complete coverage''',
        'urdu': '''پانچواں قدم: چہرہ دھونا (3 بار)

پورا چہرہ تین بار دھوئیں - بالوں کی جڑوں سے ٹھوڑی کے نیچے تک، اور ایک کان سے دوسرے کان تک۔

طریقہ:
۱۔ دونوں ہاتھوں میں پانی لیں
۲۔ بالوں کی جڑوں سے ٹھوڑی کے نیچے تک دھوئیں
۳۔ ایک کان سے دوسرے کان تک دھوئیں
۴۔ یقینی بنائیں کہ پانی چہرے کے تمام حصوں تک پہنچے
۵۔ تین بار دہرائیں

چہرے کی حدود:
• اوپر: جہاں عام طور پر بال اگتے ہیں
• نیچے: ٹھوڑی کے نیچے
• اطراف: ایک کان سے دوسرے کان تک

سنت اعمال:
• اگر داڑھی ہو تو انگلیاں داڑھی میں پھیریں (تخلیل)
• یقینی بنائیں کہ پانی داڑھی کے نیچے جلد تک پہنچے
• بھنویں اور آنکھوں کے گرد کا حصہ دھوئیں

اہم نکات:
• آنکھوں کے کونے مت چھوڑیں
• ناک کے نیچے دھوئیں
• اگر داڑھی گھنی ہو تو گیلی انگلیاں اس میں پھیریں
• مکمل طور پر ڈھانپنا یقینی بنائیں''',
        'hindi': '''पांचवां क़दम: चेहरा धोना (3 बार)

पूरा चेहरा तीन बार धोएं - बालों की जड़ों से ठोड़ी के नीचे तक, और एक कान से दूसरे कान तक।

तरीक़ा:
१. दोनों हाथों में पानी लें
२. बालों की जड़ों से ठोड़ी के नीचे तक धोएं
३. एक कान से दूसरे कान तक धोएं
४. यक़ीनी बनाएं कि पानी चेहरे के तमाम हिस्सों तक पहुंचे
५. तीन बार दोहराएं

चेहरे की हदूद:
• ऊपर: जहां आम तौर पर बाल उगते हैं
• नीचे: ठोड़ी के नीचे
• अतराफ़: एक कान से दूसरे कान तक

सुन्नत आमाल:
• अगर दाढ़ी हो तो उंगलियां दाढ़ी में फेरें (तख़्लील)
• यक़ीनी बनाएं कि पानी दाढ़ी के नीचे जिल्द तक पहुंचे
• भौंहें और आंखों के गिर्द का हिस्सा धोएं

महत्वपूर्ण बातें:
• आंखों के कोने मत छोड़ें
• नाक के नीचे धोएं
• अगर दाढ़ी घनी हो तो गीली उंगलियां उसमें फेरें
• मुकम्मल तौर पर ढांपना यक़ीनी बनाएं''',
      },
    },
    {
      'step': 6,
      'title': 'Wash Arms (3 times)',
      'titleUrdu': 'بازو دھونا (3 بار)',
      'titleHindi': 'बाज़ू धोना (3 बार)',
      'icon': Icons.pan_tool,
      'color': Colors.green,
      'details': {
        'english': '''Step 6: Wash Both Arms Including Elbows (3 times)

Wash both arms from fingertips to and including the elbows, three times each. Start with the right arm.

Method:
1. Start with the RIGHT arm
2. Pour water from fingertips to elbow
3. Rub the arm to ensure complete washing
4. Include the elbow (it must be washed)
5. Repeat three times
6. Then wash the LEFT arm the same way three times

Sunnah Actions:
• Begin with the right arm before the left
• Wash slightly above the elbow to be safe
• Interlock fingers if not done earlier

Important Points:
• Ensure water reaches all sides of the arm
• Don't miss the inner elbow area
• Remove watches, bracelets, or anything that prevents water from reaching the skin
• Nail polish that forms a barrier must be removed''',
        'urdu': '''چھٹا قدم: دونوں بازو کہنیوں سمیت دھونا (3 بار)

دونوں بازو انگلیوں کی نوکوں سے کہنیوں تک، ہر ایک تین بار دھوئیں۔ دائیں بازو سے شروع کریں۔

طریقہ:
۱۔ دائیں بازو سے شروع کریں
۲۔ انگلیوں کی نوکوں سے کہنی تک پانی ڈال��ں
۳۔ مکمل دھلائی کے لیے بازو کو ملیں
۴۔ کہنی شامل کریں (اسے ضرور دھونا ہے)
۵۔ تین بار دہرائیں
۶۔ پھر بائیں بازو کو اسی طرح تین بار دھوئیں

سنت اعمال:
• بائیں سے پہلے دائیں بازو سے شروع کریں
• محفوظ رہنے کے لیے کہنی سے تھوڑا اوپر تک دھوئیں
• اگر پہلے نہیں کیا تو انگلیاں آپس میں ملائیں

اہم نکات:
• یقینی بنائیں کہ پانی بازو کے تمام اطراف تک پہنچے
• کہنی کے اندرونی حصے کو نہ چھوڑیں
• گھڑیاں، کڑے یا کوئی بھی چیز جو پانی کو جلد تک پہنچنے سے روکے، اتار دیں
• نیل پالش جو رکاوٹ بنے، اتارنی ضروری ہے''',
        'hindi': '''छठा क़दम: दोनों बाज़ू कोहनियों समेत धोना (3 बार)

दोनों बाज़ू उंगलियों की नोकों से कोहनियों तक, हर एक तीन बार धोएं। दाएं बाज़ू से शुरू करें।

तरीक़ा:
१. दाएं बाज़ू से शुरू करें
२. उंगलियों की नोकों से कोहनी तक पानी डालें
३. मुकम्मल धुलाई के लिए बाज़ू को मलें
४. कोहनी शामिल करें (इसे ज़रूर धोना है)
५. तीन बार दोहराएं
६. फिर बाएं बाज़ू को इसी तरह तीन बार धोएं

सुन्नत आमाल:
• बाएं से पहले दाएं बाज़ू से शुरू करें
• महफ़ूज़ रहने के लिए कोहनी से थोड़ा ऊपर तक धोएं
• अगर पहले नहीं किया तो उंगलियां आपस में मिलाएं

महत्वपूर्ण बातें:
• यक़ीनी बनाएं कि पानी बाज़ू के तमाम अतराफ़ तक पहुंचे
• कोहनी के अंदरूनी हिस्से को न छोड़ें
• घड़ियां, कड़े या कोई भी चीज़ जो पानी को जिल्द तक पहुंचने से रोके, उतार दें
• नेल पॉलिश जो रुकावट बने, उतारना ज़रूरी है''',
      },
    },
    {
      'step': 7,
      'title': 'Wipe Head (Masah)',
      'titleUrdu': 'سر کا مسح',
      'titleHindi': 'सर का मसह',
      'icon': Icons.person,
      'color': Colors.purple,
      'details': {
        'english': '''Step 7: Wipe the Head (Masah) - Once

Wipe the head with wet hands once.

Method:
1. Wet both hands with fresh water
2. Place fingertips of both hands at the front of the head (hairline)
3. Wipe back to the nape of the neck
4. Then bring hands back to the front
5. This is done once (not three times)

Different Opinions:
• Hanafi: Wipe at least 1/4 of the head (one time)
• Shafi'i: Wipe any part of the head
• Maliki/Hanbali: Wipe the entire head

Sunnah Method:
• Wipe the entire head from front to back and back to front
• Use fresh water for wiping
• Do not squeeze water onto the head - it's wiping, not washing

Important Points:
• Wiping is done once, not three times
• Use wet hands, not dripping wet
• Women can wipe over their hijab in some opinions for ease''',
        'urdu': '''ساتواں قدم: سر کا مسح - ایک بار

گیلے ہاتھوں سے سر کا مسح ایک بار کریں۔

طریقہ:
۱۔ دونوں ہاتھ تازہ پانی سے گیلے کریں
۲۔ دونوں ہاتھوں کی انگلیوں کی نوکیں سر کے آگے (بالوں کی لکیر) رکھیں
۳۔ گدی تک پیچھے کی طرف مسح کریں
۴۔ پھر ہاتھ واپس آگے لائیں
۵۔ یہ ایک بار کیا جاتا ہے (تین بار نہیں)

مختلف آراء:
• حنفی: کم از کم سر کا 1/4 مسح کریں (ایک بار)
• شافعی: سر کا کوئی بھی حصہ مسح کریں
• مالکی/حنبلی: پورے سر کا مسح کریں

سنت طریقہ:
• پورے سر کا آگے سے پیچھے اور پیچھے سے آگے مسح کریں
• مسح کے لیے تازہ پانی استعمال کریں
• سر پر پانی نہ نچوڑیں - یہ مسح ہے، دھونا نہیں

اہم نکات:
• مسح ایک بار ہوتا ہے، تین بار نہیں
• گیلے ہاتھ استعمال کریں، ٹپکتے ہوئے نہیں
• بعض آراء میں خواتین آسانی کے لیے حجاب پر مسح کر سکتی ہیں''',
        'hindi': '''सातवां क़दम: सर का मसह - एक बार

गीले हाथों से सर का मसह एक बार करें।

तरीक़ा:
१. दोनों हाथ ताज़ा पानी से गीले करें
२. दोनों हाथों की उंगलियों की नोकें सर के आगे (बालों की लकीर) रखें
३. गुद्दी तक पीछे की तरफ़ मसह करें
४. फिर हाथ वापस आगे लाएं
५. यह एक बार किया जाता है (तीन बार नहीं)

मुख़्तलिफ़ आराअ:
• हनफ़ी: कम से कम सर का 1/4 मसह करें (एक बार)
• शाफ़ई: सर का कोई भी हिस्सा मसह करें
• मालिकी/हंबली: पूरे सर का मसह करें

सुन्नत तरीक़ा:
• पूरे सर का आगे से पीछे और पीछे से आगे मसह करें
• मसह के लिए ताज़ा पानी इस्तेमाल करें
• सर पर पानी न निचोड़ें - यह मसह है, धोना नहीं

महत्वपूर्ण बातें:
• मसह एक बार होता है, तीन बार नहीं
• गीले हाथ इस्तेमाल करें, टपकते हुए नहीं
• बाज़ आराअ में ख़वातीन आसानी के लिए हिजाब पर मसह कर सकती हैं''',
      },
    },
    {
      'step': 8,
      'title': 'Wipe Ears',
      'titleUrdu': 'کانوں کا مسح',
      'titleHindi': 'कानों का मसह',
      'icon': Icons.hearing,
      'color': Colors.indigo,
      'details': {
        'english': '''Step 8: Wipe the Ears - Once

Wipe the ears with wet fingers once.

Method:
1. Use the same water from wiping the head, or take fresh water
2. Insert the index fingers into the ear openings
3. Use the thumbs to wipe behind the ears
4. Wipe the inner folds and outer parts of the ears
5. Do this once

Detailed Technique:
• Index fingers: Wipe inside the ear folds
• Thumbs: Wipe behind the ears
• Cover all parts of the ear

Sunnah Actions:
• Wipe ears along with the head
• Some scholars say fresh water should be taken

The Prophet ﷺ said: "The ears are part of the head." (Sunan Abu Dawud)

Important Points:
• Ears are considered part of the head
• Wipe inside the ear openings (outer ear, not ear canal)
• Wipe behind the ears as well''',
        'urdu': '''آٹھواں قدم: کانوں کا مسح - ایک ��ار

گیلی انگلیوں سے کانوں کا مسح ایک بار کریں۔

طریقہ:
۱۔ سر کے مسح والا پانی استعمال کریں، یا تازہ پانی لیں
۲۔ شہادت کی انگلیاں کان کے سوراخوں میں ڈالیں
۳۔ انگوٹھوں سے کانوں کے پیچھے مسح کریں
۴۔ کانوں کی اندرونی تہوں اور باہری حصوں کا مسح کریں
۵۔ یہ ایک بار کریں

تفصیلی طریقہ:
• شہادت کی انگلیاں: کان کی تہوں کے اندر مسح کریں
• انگوٹھے: کانوں کے پیچھے مسح کریں
• کان کے تمام حصے ڈھانپیں

سنت اعمال:
• سر کے ساتھ کانوں کا مسح کریں
• بعض علماء کہتے ہیں کہ تازہ پانی لینا چاہیے

نبی کریم ﷺ نے فرمایا: "کان سر کا حصہ ہیں۔" (سنن ابو داؤد)

اہم نکات:
• کان سر کا حصہ سمجھے جاتے ہیں
• کان کے سوراخوں کے اندر مسح کریں (باہری کان، کان کی نالی نہیں)
• کانوں کے پیچھے بھی مسح کریں''',
        'hindi': '''आठवां क़दम: कानों का मसह - एक बार

गीली उंगलियों से कानों का मसह एक बार करें।

तरीक़ा:
१. सर के मसह वाला पानी इस्तेमाल करें, या ताज़ा पानी लें
२. शहादत की उंगलियां कान के सूराख़ों में डालें
३. अंगूठों से कानों के पीछे मसह करें
४. कानों की अंदरूनी तहों और बाहरी हिस्सों का मसह करें
५. यह एक बार करें

तफ़सीली तरीक़ा:
• शहादत की उंगलियां: कान की तहों के अंदर मसह करें
• अंगूठे: कानों के पीछे मसह करें
• कान के तमाम हिस्से ढांपें

सुन्नत आमाल:
• सर के साथ कानों का मसह करें
• बाज़ उलमा कहते हैं कि ताज़ा पानी लेना चाहिए

नबी करीम ﷺ ने फ़रमाया: "कान सर का हिस्सा हैं।" (सुनन अबू दाऊद)

महत्वपूर्ण बातें:
• कान सर का हिस्सा समझे जाते हैं
• कान के सूराख़ों के अंदर मसह करें (बाहरी कान, कान की नली नहीं)
• कानों के पीछे भी मसह करें''',
      },
    },
    {
      'step': 9,
      'title': 'Wash Feet (3 times)',
      'titleUrdu': 'پاؤں دھونا (3 بار)',
      'titleHindi': 'पांव धोना (3 बार)',
      'icon': Icons.do_not_step,
      'color': Colors.brown,
      'details': {
        'english': '''Step 9: Wash Both Feet Including Ankles (3 times)

Wash both feet up to and including the ankles, three times each. Start with the right foot.

Method:
1. Start with the RIGHT foot
2. Pour water over the foot from toes to ankle
3. Wash between the toes with fingers (Takhleel)
4. Include the ankle bones (they must be washed)
5. Repeat three times
6. Then wash the LEFT foot the same way three times

Sunnah Actions:
• Begin with the right foot
• Use the little finger of the left hand to wash between the toes
• Start from the little toe and move to the big toe
• Rub the heels and ankle bones thoroughly

Important Points:
• Make sure water reaches between all toes
• Wash around and over the ankle bones
• The heels must be washed completely
• Remove socks, shoes, and anything that prevents water from reaching the skin

The Prophet ﷺ saw people whose heels were not washed properly and said: "Woe to the heels from the Fire!" (Sahih Bukhari)''',
        'urdu': '''نواں قدم: دونوں پاؤں ٹخنوں سمیت دھونا (3 بار)

دونوں پاؤں ٹخنوں تک، ہر ایک تین بار دھوئیں۔ دائیں پاؤں سے شروع کریں۔

طریقہ:
۱۔ دائیں پاؤں سے شروع کریں
۲۔ انگلیوں سے ٹخنے تک پاؤں پر پانی ڈالیں
۳۔ انگلیوں سے پاؤں کی انگلیوں کے درمیان دھوئیں (تخلیل)
۴۔ ٹخنے کی ہڈیاں شامل کریں (انہیں ضرور دھونا ہے)
۵۔ تین بار دہرائیں
۶۔ پھر بائیں پاؤں کو اسی طرح تین بار دھوئیں

سنت اعمال:
• دائیں پاؤں سے شروع کریں
• پاؤں کی انگلیوں کے درمیان دھونے کے لیے بائیں ہاتھ کی چھوٹی انگلی استعمال کریں
• چھوٹی انگلی سے شروع کریں اور بڑی انگلی تک جائیں
• ایڑیوں اور ٹخنوں کی ہڈیوں کو اچھی طرح ملیں

اہم نکات:
• یقینی بنائیں کہ پانی تمام انگلیوں کے درمیان پہنچے
• ٹخنوں کی ہڈیوں کے گرد اور اوپر دھوئیں
• ایڑیاں مکمل طور پر دھلنی چاہئیں
• موزے، جوتے اور کوئی بھی چیز جو پانی کو جلد تک پہنچنے سے روکے، اتار دیں

نبی کریم ﷺ نے لوگوں کو دیکھا جن کی ایڑیاں ٹھیک سے نہیں دھلی تھیں اور فرمایا: "ایڑیوں کو آگ سے ہلاکت ہے!" (صحیح بخاری)''',
        'hindi': '''नौवां क़दम: दोनों पांव टख़नों समेत धोना (3 बार)

दोनों पांव टख़नों तक, हर एक तीन बार धोएं। दाएं पांव से शुरू करें।

तरीक़ा:
१. दाएं पांव से शुरू करें
२. उंगलियों से टख़ने तक पांव पर पानी डालें
३. उंगलियों से पांव की उंगलियों के दरमियान धोएं (तख़्लील)
४. टख़ने की हड्डियां शामिल करें (इन्हें ज़रूर धोना है)
५. तीन बार दोहराएं
६. फिर बाएं पांव को इसी तरह तीन बार धोएं

सुन्नत आमाल:
• दाएं पांव से शुरू करें
• पांव की उंगलियों के दरमियान धोने के लिए बाएं हाथ की छोटी उंगली इस्तेमाल करें
• छोटी उंगली से शुरू करें और बड़ी उंगली तक जाएं
• एड़ियों और टख़नों की हड्डियों को अच्छी तरह मलें

महत्वपूर्ण बातें:
• यक़ीनी बनाएं कि पानी तमाम उंगलियों के दरमियान पहुंचे
• टख़नों की हड्डियों के गिर्द और ऊपर धोएं
• एड़ियां मुकम्मल तौर पर धुलनी चाहिए
• मोज़े, जूते और कोई भी चीज़ जो पानी को जिल्द तक पहुंचने से रोके, उतार दें

नबी करीम ﷺ ने लोगों ��ो देखा जिनकी एड़ियां ठीक से नहीं धुली थीं और फ़रमाया: "एड़ियों को आग से हलाकत है!" (सहीह बुख़ारी)''',
      },
    },
    {
      'step': 10,
      'title': 'Dua After Wudu',
      'titleUrdu': 'وضو کے بعد دعا',
      'titleHindi': 'वुज़ू के बाद दुआ',
      'icon': Icons.volunteer_activism,
      'color': Colors.teal,
      'details': {
        'english': '''Step 10: Dua After Wudu

After completing Wudu, recite the following dua:

Shahada:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"Ashhadu an la ilaha illallahu wahdahu la shareeka lahu, wa ashhadu anna Muhammadan 'abduhu wa rasuluhu"

Translation: "I bear witness that there is no god but Allah alone, with no partner, and I bear witness that Muhammad is His slave and messenger."

Additional Dua:
"اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ"

"Allahumma-j'alni minat-tawwabeen, waj'alni minal-mutatahhireen"

Translation: "O Allah, make me among those who repent and make me among those who purify themselves."

Virtues:
The Prophet ﷺ said: "Whoever performs Wudu and says these words, all eight gates of Paradise will be opened for him, and he may enter through whichever one he wishes." (Sahih Muslim)

Pray 2 Rakats (Optional):
The Prophet ﷺ said: "Whoever performs Wudu like my Wudu, then prays two rakats in which he does not let his mind wander, his previous sins will be forgiven." (Sahih Bukhari)''',
        'urdu': '''دسواں قدم: وضو کے بعد دعا

وضو مکمل کرنے کے بعد یہ دعا پڑھیں:

شہادت:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"اشھد ان لا الہ الا اللہ وحدہ لا شریک لہ، و اشھد ان محمدا عبدہ و رسولہ"

ترجمہ: "میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اور میں گواہی دیتا ہوں کہ محمد ﷺ اس کے بندے اور رسول ہیں۔"

اضافی دعا:
"اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ"

"اللھم اجعلنی من التوابین واجعلنی من المتطھرین"

ترجمہ: "اے اللہ! مجھے توبہ کرنے والوں میں سے بنا اور مجھے پاکیزگی اختیار کرنے والوں میں سے بنا۔"

فضائل:
نبی کریم ﷺ نے فرمایا: "جو شخص وضو کرے اور یہ کلمات کہے، اس کے لیے جنت کے آٹھوں دروازے کھول دیے جائیں گے، وہ جس سے چاہے داخل ہو۔" (صحیح مسلم)

2 رکعت نماز پڑھیں (اختیاری):
نبی کریم ﷺ نے فرمایا: "جو شخص میرے وضو کی طرح وضو کرے، پھر دو رکعت نماز پڑھے جس میں وہ اپنے دل کو بھٹکنے نہ دے، اس کے پچھلے گناہ معاف کر دیے جائیں گے۔" (صحیح بخاری)''',
        'hindi': '''दसवां क़दम: वुज़ू के बाद दुआ

वुज़ू मुकम्मल करने के बाद यह दुआ पढ़ें:

शहादत:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"अश्हदु अन ला इलाहा इल्लल्लाहु वहदहू ला शरीका लहू, व अश्हदु अन्ना मुहम्मदन अब्दुहू व रसूलुहू"

तर्जुमा: "मैं गवाही देता हूं कि अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं, और मैं गवाही देता हूं कि मुहम्मद ﷺ उसके बंदे और रसूल हैं।"

इज़ाफ़ी दुआ:
"اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ"

"अल्लाहुम्मज-अलनी मिनत-तव्वाबीन, वज-अलनी मिनल-मुतताह्हिरीन"

तर्जुमा: "ऐ अल्लाह! मुझे तौबा करने वालों में से बना और मुझे पाकीज़गी इख़्तियार करने वालों में से बना।"

फ़ज़ाइल:
नबी करीम ﷺ ने फ़रमाया: "जो शख़्स वुज़ू करे और ये कलिमात कहे, उसके लिए जन्नत के आठों दरवाज़े खोल दिए जाएंगे, वो जिससे चाहे दाख़िल हो।" (सहीह मुस्लिम)

2 रकअत नमाज़ पढ़ें (वैकल्पिक):
नबी करीम ﷺ ने फ़रमाया: "जो शख़्स मेरे वुज़ू की तरह वुज़ू करे, फिर दो रकअत नमाज़ पढ़े जिसमें वो अपने दिल को भटकने न दे, उसके पिछले गुनाह माफ़ कर दिए जाएंगे।" (सहीह बुख़ारी)''',
      },
    },
  ];

  final List<Map<String, dynamic>> _additionalInfo = [
    {
      'title': 'Things That Break Wudu',
      'titleUrdu': 'وضو توڑنے والی چیزیں',
      'titleHindi': 'वुज़ू तोड़ने वाली चीज़ें',
      'icon': Icons.cancel,
      'color': Colors.red,
      'details': {
        'english': '''Things That Break Wudu (Nawaqid al-Wudu)

1. Natural bodily excretions:
   • Urine
   • Stool
   • Passing wind (gas)
   • Pre-seminal fluid (Madhi)
   • Prostatic fluid (Wadi)

2. Deep sleep (lying down or reclining)

3. Loss of consciousness

4. Touching private parts directly (according to some scholars)

5. Eating camel meat (according to some scholars)

6. Blood or pus flowing from a wound (Hanafi opinion)

7. Vomiting a mouthful (Hanafi opinion)

8. Laughing loudly during prayer (Hanafi opinion)

Note: Different schools of thought have slight variations. Follow the guidance of your scholar or school.''',
        'urdu': '''وضو توڑنے والی چیزیں (نواقض الوضو)

۱۔ قدرتی جسمانی اخراج:
   • پیشاب
   • پاخانہ
   • ہوا خارج ہونا (ریاح)
   • مذی
   • ودی

۲۔ گہری نیند (لیٹ کر یا ٹیک لگا کر)

۳۔ بے ہوشی

۴۔ شرمگاہ کو براہ راست چھونا (بعض علماء کے مطابق)

۵۔ اونٹ کا گوشت کھانا (بعض علماء کے مطابق)

۶۔ زخم سے خون یا پیپ بہنا (حنفی رائے)

۷۔ منہ بھر قے آنا (حنفی رائے)

۸۔ نماز میں زور سے ہنسنا (حنفی رائے)

نوٹ: مختلف مکاتب فکر میں معمولی فرق ہے۔ اپنے عالم یا مسلک کی رہنمائی پر عمل کریں۔''',
        'hindi': '''वुज़ू तोड़ने वाली चीज़ें (नवाक़िज़ अल-वुज़ू)

१. क़ुदरती जिस्मानी इख़राज:
   • पेशाब
   • पाख़ाना
   • हवा ख़ारिज होना (रियाह)
   • मज़ी
   • वदी

२. गहरी नींद (लेटकर या टेक लगाकर)

३. बेहोशी

४. शर्मगाह को बिलावास्ता छूना (बाज़ उलमा के मुताबिक़)

५. ऊंट का गोश्त खाना (बाज़ उलमा के मुताबिक़)

६. ज़ख़्म से ख़ून या पीप बहना (हनफ़ी राय)

७. मुंह भर क़ै आना (हनफ़ी राय)

८. नमाज़ में ज़ोर से हंसना (हनफ़ी राय)

नोट: मुख़्तलिफ़ मकातिब-ए-फ़िक्र में मामूली फ़र्क़ है। अपने आलिम या मसलक की रहनुमाई पर अमल करें।''',
      },
    },
    {
      'title': 'Wudu with Socks (Masah)',
      'titleUrdu': 'موزوں پر مسح',
      'titleHindi': 'मोज़ों पर मसह',
      'icon': Icons.catching_pokemon,
      'color': Colors.grey,
      'details': {
        'english': '''Wiping Over Socks (Masah alal Khuffain)

It is permissible to wipe over leather socks (khuff) or thick socks instead of washing the feet, under certain conditions.

Conditions:
1. Socks must be put on after complete Wudu
2. Socks must cover the entire foot up to the ankles
3. Socks must be thick enough that water doesn't seep through easily
4. Must be able to walk in them

Duration:
• Resident (Muqeem): 24 hours (one day and night)
• Traveler (Musafir): 72 hours (three days and nights)

Method of Wiping:
1. Wet your hands
2. Place fingers on top of the toes
3. Wipe upward toward the ankles
4. Wipe the top of the foot only (not the bottom)
5. Wipe both feet

What Breaks This Permission:
• Removal of socks
• End of the time period
• Major impurity (requiring Ghusl)

Note: Regular cotton socks are a matter of scholarly difference. Some allow wiping over them, others require leather socks.''',
        'urdu': '''موزوں پر مسح

چمڑے کے موزوں (خف) یا موٹے موزوں پر پاؤں دھونے کی بجائے مسح کرنا جائز ہے، بعض شرائط کے ساتھ۔

شرائط:
۱۔ موزے مکمل وضو کے بعد پہنے ہوں
۲۔ موزے پورے پاؤں کو ٹخنوں تک ڈھانپتے ہوں
۳۔ موزے اتنے موٹے ہوں کہ پانی آسانی سے نہ گزرے
۴۔ ان میں چلنا ممکن ہو

مدت:
• مقیم: 24 گھنٹے (ایک دن اور رات)
• مسافر: 72 گھنٹے (تین دن اور راتیں)

مسح کا طریقہ:
۱۔ اپنے ہاتھ گیلے کریں
۲۔ انگلیاں پاؤں کی انگلیوں کے اوپر رکھیں
۳۔ ٹخنوں کی طرف اوپر مسح کریں
۴۔ صرف پاؤں کے اوپر مسح کریں (نیچے نہیں)
۵۔ دونوں پاؤں کا مسح کریں

یہ اجازت کب ختم ہوتی ہے:
• موزے اتارنا
• مدت ختم ہونا
• بڑی ناپاکی (غسل ضروری ہونا)

نوٹ: عام سوتی موزے علماء کے درمیان اختلافی ہیں۔ بعض ان پر مسح کی اجازت دیتے ہیں، بعض چمڑے کے موزے ضروری سمجھتے ہیں۔''',
        'hindi': '''मोज़ों पर मसह

चमड़े के मोज़ों (ख़ुफ़) या मोटे मोज़ों पर पांव धोने की बजाय मसह करना जायज़ है, बाज़ शराइत के साथ।

शराइत:
१. मोज़े मुकम्मल वुज़ू के बाद पहने हों
२. मोज़े पूरे पांव को टख़नों तक ढांपते हों
३. मोज़े इतने मोटे हों कि पानी आसानी से न गुज़रे
४. उनमें चलना मुमकिन हो

मुद्दत:
• मुक़ीम: 24 घंटे (एक दिन और रात)
• मुसाफ़िर: 72 घंटे (तीन दिन और रातें)

मसह का तरीक़ा:
१. अपने हाथ गीले करें
२. उंगलियां पांव की उंगलियों के ऊपर रखें
३. टख़नों की तरफ़ ऊपर मसह करें
४. सिर्फ़ पांव के ऊपर मसह करें (नीचे नहीं)
५. दोनों पांव का मसह करें

यह इजाज़त कब ख़त्म होती है:
• मोज़े उतारना
• मुद्दत ख़त्म होना
• बड़ी नापाकी (ग़ुस्ल ज़रूरी होना)

नोट: आम सूती मोज़े उलमा के दरमियान इख़्तिलाफ़ी हैं। बाज़ उन पर मसह की इजाज़त देते हैं, बाज़ चमड़े के मोज़े ज़रूरी समझते हैं।''',
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
              PopupMenuItem(
                value: 'english',
                child: Row(
                  children: [
                    if (_selectedLanguage == 'english')
                      Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(
                      'English',
                      style: TextStyle(
                        fontWeight: _selectedLanguage == 'english'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedLanguage == 'english'
                            ? AppColors.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'urdu',
                child: Row(
                  children: [
                    if (_selectedLanguage == 'urdu')
                      Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(
                      'اردو',
                      style: TextStyle(
                        fontWeight: _selectedLanguage == 'urdu'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedLanguage == 'urdu'
                            ? AppColors.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hindi',
                child: Row(
                  children: [
                    if (_selectedLanguage == 'hindi')
                      Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(
                      'हिंदी',
                      style: TextStyle(
                        fontWeight: _selectedLanguage == 'hindi'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedLanguage == 'hindi'
                            ? AppColors.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wudu Steps
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _wazuSteps.length,
              itemBuilder: (context, index) {
                final step = _wazuSteps[index];
                return _buildStepCard(
                  step,
                  isDark,
                );
              },
            ),

            const SizedBox(height: 24),

            // Additional Info Title
            Text(
              _selectedLanguage == 'english'
                  ? 'Additional Information'
                  : _selectedLanguage == 'urdu'
                  ? 'اضافی معلومات'
                  : 'इज़ाफ़ी मालूमात',
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textDirection: _selectedLanguage == 'urdu'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
            const SizedBox(height: 16),

            // Additional Info Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _additionalInfo.length,
              itemBuilder: (context, index) {
                final info = _additionalInfo[index];
                return _buildInfoCard(
                  info,
                  isDark,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    Map<String, dynamic> step,
    bool isDark,
  ) {
    final title = _selectedLanguage == 'english'
        ? step['title']
        : _selectedLanguage == 'urdu'
        ? step['titleUrdu']
        : step['titleHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showStepDetails(step),
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${step['step']}',
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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    step['icon'] as IconData,
                    color: AppColors.primary,
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

  Widget _buildInfoCard(
    Map<String, dynamic> info,
    bool isDark,
  ) {
    final title = _selectedLanguage == 'english'
        ? info['title']
        : _selectedLanguage == 'urdu'
        ? info['titleUrdu']
        : info['titleHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showInfoDetails(info),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    info['icon'] as IconData,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primary,
                      fontSize: 16,
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

  void _showStepDetails(Map<String, dynamic> step) {
    final details = step['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: step['title'],
          titleUrdu: step['titleUrdu'] ?? '',
          titleHindi: step['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: step['color'] as Color,
          icon: step['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Wudu',
          number: step['step'] as int?,
        ),
      ),
    );
  }

  void _showInfoDetails(Map<String, dynamic> info) {
    final details = info['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: info['title'],
          titleUrdu: info['titleUrdu'] ?? '',
          titleHindi: info['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: info['color'] as Color,
          icon: info['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Wudu',
        ),
      ),
    );
  }
}
