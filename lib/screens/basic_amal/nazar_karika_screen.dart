import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NazarKarikaScreen extends StatefulWidget {
  const NazarKarikaScreen({super.key});

  @override
  State<NazarKarikaScreen> createState() => _NazarKarikaScreenState();
}

class _NazarKarikaScreenState extends State<NazarKarikaScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Nazar Complete Guide',
    'urdu': 'نذر کا طریقہ - مکمل رہنمائی',
    'hindi': 'नज़र का तरीका - संपूर्ण मार्गदर्शन',
  };

  final List<Map<String, dynamic>> _nazarTypes = [
    {
      'title': 'Nazar for Charity',
      'titleUrdu': 'صدقے کی نذر',
      'titleHindi': 'सदक़े की नज़र',
      'icon': Icons.volunteer_activism,
      'color': Colors.green,
      'details': {
        'english': '''Nazar for Charity (Sadaqah)

How to Make This Nazar:
Say: "Ya Allah, if You fulfill my wish (mention your wish), I will give (amount/item) in charity for Your sake."

Example: "Ya Allah, if my child recovers from illness, I will distribute food to 10 poor people."

How to Fulfill:
1. When your wish is fulfilled, fulfill your promise as soon as possible
2. Give charity to the poor and needy
3. Do not delay unnecessarily
4. Give with pure intention (Niyyah) for Allah

Types of Charity:
• Money to the poor
• Food distribution
• Clothes to needy
• Educational support
• Medical assistance

Important Points:
• The charity should be given to those who are eligible to receive Zakat
• You can distribute to one person or multiple people
• The intention (Niyyah) must be purely for Allah
• Keep your promise - breaking a Nazar is a sin''',
        'urdu': '''صدقے کی نذر

نذر ماننے کا طریقہ:
کہیں: "یا اللہ! اگر تو نے میری مراد (اپنی مراد بتائیں) پوری کر دی تو میں تیری رضا کے لیے (رقم/چیز) صدقہ کروں گا۔"

مثال: "یا اللہ! اگر میرا بچہ بیماری سے شفا پا گیا تو میں 10 غریبوں کو کھانا کھلاؤں گا۔"

پورا کرنے کا طریقہ:
۱۔ جب آپ کی مراد پوری ہو جائے تو جلد از جلد اپنا وعدہ پورا کریں
۲۔ غریبوں اور ضرورت مندوں کو صدقہ دیں
۳۔ بلا وجہ تاخیر نہ کریں
۴۔ خالص اللہ کی رضا کی نیت سے دیں

صدقے کی اقسام:
• غریبوں کو پیسے
• کھانے کی تقسیم
• ضرورت مندوں کو کپڑے
• تعلیمی مدد
• طبی امداد

اہم نکات:
• صدقہ ان لوگوں کو دیں جو زکوٰۃ کے مستحق ہوں
• ایک شخص کو یا کئی لوگوں کو تقسیم کر سکتے ہیں
• نیت خالصتاً اللہ کے لیے ہونی چاہیے
• اپنا وعدہ ضرور پورا کریں - نذر توڑنا گناہ ہے''',
        'hindi': '''सदक़े की नज़र

नज़र मानने का तरीका:
कहें: "या अल्लाह! अगर तूने मेरी मुराद (अपनी मुराद बताएं) पूरी कर दी तो मैं तेरी रज़ा के लिए (रकम/चीज़) सदक़ा करूंगा।"

उदाहरण: "या अल्लाह! अगर मेरा बच्चा बीमारी से ठीक हो गया तो मैं 10 ग़रीबों को खाना खिलाऊंगा।"

पूरा करने का तरीका:
१. जब आपकी मुराद पूरी हो जाए तो जल्द से जल्द अपना वादा पूरा करें
२. ग़रीबों और ज़रूरतमंदों को सदक़ा दें
३. बिना वजह देरी न करें
४. ख़ालिस अल्लाह की रज़ा की नीयत से दें

सदक़े के प्रकार:
• ग़रीबों को पैसे
• खाने की तक़सीम
• ज़रूरतमंदों को कपड़े
• तालीमी मदद
• तिब्बी इमदाद

महत्वपूर्ण बातें:
• सदक़ा उन लोगों को दें जो ज़कात के हक़दार हों
• एक शख़्स को या कई लोगों को तक़सीम कर सकते हैं
• नीयत ख़ालिस अल्लाह के लिए होनी चाहिए
• अपना वादा ज़रूर पूरा करें - नज़र तोड़ना गुनाह है''',
      },
    },
    {
      'title': 'Nazar for Fasting',
      'titleUrdu': 'روزے کی نذر',
      'titleHindi': 'रोज़े की नज़र',
      'icon': Icons.no_food,
      'color': Colors.orange,
      'details': {
        'english': '''Nazar for Fasting (Sawm)

How to Make This Nazar:
Say: "Ya Allah, if You fulfill my wish (mention your wish), I will fast for (number) days for Your sake."

Example: "Ya Allah, if I get this job, I will fast for 3 days."

How to Fulfill:
1. Fast on permissible days (not on Eid days or the days of Tashreeq)
2. Make intention (Niyyah) before Fajr: "I am fasting today to fulfill my Nazar for Allah"
3. Keep the fast from Fajr to Maghrib
4. Break the fast at Maghrib time with dates or water

Rules for Nazar Fast:
• These fasts are Wajib (obligatory) once the condition is met
• They can be kept consecutively or separately
• Cannot fast on the two Eid days
• Cannot fast on 11th, 12th, and 13th of Dhul Hijjah
• If you cannot fast due to illness, you must make it up later
• If permanently unable, give Fidya (compensation)

Fidya (If Unable to Fast):
• Feed one poor person for each missed fast
• Give the equivalent of one meal
• Or pay the monetary equivalent''',
        'urdu': '''روزے کی نذر

نذر ماننے کا طریقہ:
کہیں: "یا اللہ! اگر تو نے میری مراد (اپنی مراد بتائیں) پوری کر دی تو میں تیری رضا کے لیے (تعداد) دن روزے رکھوں گا۔"

مثال: "یا اللہ! اگر مجھے یہ نوکری مل گئی تو میں 3 دن روزے رکھوں گا۔"

پورا کرنے کا طریقہ:
۱۔ جائز دنوں میں روزے رکھیں (عید کے دنوں یا ایام تشریق میں نہیں)
۲۔ فجر سے پہلے نیت کریں: "میں آج اللہ کے لیے اپنی نذر پوری کرنے کے لیے روزہ رکھ رہا ہوں"
۳۔ فجر سے مغرب تک روزہ رکھیں
۴۔ مغرب کے وقت کھجور یا پانی سے روزہ کھولیں

نذر کے روزے کے احکام:
• یہ روزے شرط پوری ہونے کے بعد واجب ہو جاتے ہیں
• لگاتار یا الگ الگ رکھ سکتے ہیں
• دونوں عیدوں کے دن روزہ نہیں رکھ سکتے
• ذوالحجہ کی 11، 12 اور 13 تاریخ کو روزہ نہیں رکھ سکتے
• اگر بیماری کی وجہ سے روزہ نہیں رکھ سکتے تو بعد میں قضا کریں
• اگر مستقل طور پر قاصر ہوں تو فدیہ دیں

فدیہ (اگر روزہ نہیں رکھ سکتے):
• ہر چھوٹے ہوئے روزے کے بدلے ایک غریب کو کھانا کھلائیں
• ایک وقت کے کھانے کے برابر دیں
• یا اس کی مالی قیمت ادا کریں''',
        'hindi': '''रोज़े की नज़र

नज़र मानने का तरीका:
कहें: "या अल्लाह! अगर तूने मेरी मुराद (अपनी मुराद बताएं) पूरी कर दी तो मैं तेरी रज़ा के लिए (संख्या) दिन रोज़े रखूंगा।"

उदाहरण: "या अल्लाह! अगर मुझे यह नौकरी मिल गई तो मैं 3 दिन रोज़े रखूंगा।"

पूरा करने का तरीका:
१. जायज़ दिनों में रोज़े रखें (ईद के दिनों या अय्याम-ए-तशरीक़ में नहीं)
२. फज्र से पहले नीयत करें: "मैं आज अल्लाह के लिए अपनी नज़र पूरी करने के लिए रोज़ा रख रहा हूं"
३. फज्र से मग़रिब तक रोज़ा रखें
४. मग़रिब के वक़्त खजूर या पानी से रोज़ा खोलें

नज़र के रोज़े के अहकाम:
• ये रोज़े शर्त पूरी होने के बाद वाजिब हो जाते हैं
• लगातार या अलग-अलग रख सकते हैं
• दोनों ईदों के दिन रोज़ा नहीं रख सकते
• ज़ुल-हिज्जा की 11, 12 और 13 तारीख़ को रोज़ा नहीं रख सकते
• अगर बीमारी की वजह से रोज़ा नहीं रख सकते तो बाद में क़ज़ा करें
• अगर स्थायी रूप से असमर्थ हों तो फ़िदया दें

फ़िदया (अगर रोज़ा नहीं रख सकते):
• हर छूटे हुए रोज़े के बदले एक ग़रीब को खाना खिलाएं
• एक वक़्त के खाने के बराबर दें
• या उसकी माली क़ीमत अदा करें''',
      },
    },
    {
      'title': 'Nazar for Prayer',
      'titleUrdu': 'نماز کی نذر',
      'titleHindi': 'नमाज़ की नज़र',
      'icon': Icons.mosque,
      'color': Colors.blue,
      'details': {
        'english': '''Nazar for Prayer (Salah)

How to Make This Nazar:
Say: "Ya Allah, if You fulfill my wish (mention your wish), I will pray (number) rakats of Nafl prayer for Your sake."

Example: "Ya Allah, if my surgery is successful, I will pray 4 rakats of Shukrana (thanksgiving) prayer."

How to Fulfill:
1. Perform the prayer with proper Wudu
2. Make intention (Niyyah): "I am praying these rakats to fulfill my Nazar for Allah"
3. Pray with full concentration (Khushu)
4. Complete all pillars (Arkan) of prayer properly

Types of Nazar Prayers:
• Shukrana (Thanksgiving) Prayer - 2 or 4 rakats
• Hajat (Need) Prayer - 2 or 4 rakats
• Taubah (Repentance) Prayer - 2 rakats
• General Nafl Prayer - as promised

Best Times for Nafl Prayer:
• After Fajr until sunrise - NOT recommended
• After sunrise until 15 min before Zuhr - Good
• After Zuhr until Asr - Good
• After Asr until Maghrib - NOT recommended
• After Maghrib until Isha - Good
• After Isha until Fajr - Best time (Tahajjud)

Important Notes:
• Nazar prayer cannot replace Fard prayers
• If you vowed to pray in a specific masjid, you must pray there
• If unable to pray in that masjid, pray wherever possible''',
        'urdu': '''نماز کی نذر

نذر ماننے کا طریقہ:
کہیں: "یا اللہ! اگر تو نے میری مراد (اپنی مراد بتائیں) پوری کر دی تو میں تیری رضا کے لیے (تعداد) رکعت نفل نماز پڑھوں گا۔"

مثال: "یا اللہ! اگر میرا آپریشن کامیاب ہو گیا تو میں 4 رکعت شکرانے کی نماز پڑھوں گا۔"

پورا کرنے کا طریقہ:
۱۔ وضو کے ساتھ نماز ادا کریں
۲۔ نیت کریں: "میں اللہ کے لیے اپنی نذر پوری کرنے کے لیے یہ رکعتیں پڑھ رہا ہوں"
۳۔ پوری توجہ (خشوع) کے ساتھ نماز پڑھیں
۴۔ نماز کے تمام ارکان صحیح طریقے سے ادا کریں

نذر کی نمازوں کی اقسام:
• شکرانے کی نماز - 2 یا 4 رکعت
• نماز حاجت - 2 یا 4 رکعت
• نماز توبہ - 2 رکعت
• عام نفل نماز - جیسا وعدہ کیا

نفل نماز کے بہترین اوقات:
• فجر کے بعد طلوع آفتاب تک - مکروہ
• طلوع آفتاب کے بعد ظہر سے 15 منٹ پہلے تک - اچھا
• ظہر کے بعد عصر تک - اچھا
• عصر کے بعد مغرب تک - مکروہ
• مغرب کے بعد عشاء تک - اچھا
• عشاء کے بعد فجر تک - بہترین وقت (تہجد)

اہم نکات:
• نذر کی نماز فرض نمازوں کی جگہ نہیں لے سکتی
• اگر کسی خاص مسجد م��ں نماز پڑھنے کی نذر مانی تو وہیں پڑھنی ہوگی
• اگر اس مسجد میں نماز پڑھنا ممکن نہ ہو تو جہاں ممکن ہو وہاں پڑھیں''',
        'hindi': '''नमाज़ की नज़र

नज़र मानने का तरीका:
कहें: "या अल्लाह! अगर तूने मेरी मुराद (अपनी मुराद बताएं) पूरी कर दी तो मैं तेरी रज़ा के लिए (संख्या) रकअत नफ़्ल नमाज़ पढ़ूंगा।"

उदाहरण: "या अल्लाह! अगर मेरा ऑपरेशन कामयाब हो गया तो मैं 4 रकअत शुक्राने की नमाज़ पढ़ूंगा।"

पूरा करने का तरीका:
१. वुज़ू के साथ नमाज़ अदा करें
२. नीयत करें: "मैं अल्लाह के लिए अपनी नज़र पूरी करने के लिए ये रकअतें पढ़ रहा हूं"
३. पूरी तवज्जो (ख़ुशू) के साथ नमाज़ पढ़ें
४. नमाज़ के सभी अरकान सही तरीक़े से अदा करें

नज़र की नमाज़ों के प्रकार:
• शुक्राने की नमाज़ - 2 या 4 रकअत
• नमाज़-ए-हाजत - 2 या 4 रकअत
• नमाज़-ए-तौबा - 2 रकअत
• आम नफ़्ल नमाज़ - जैसा वादा किया

नफ़्ल नमाज़ के बेहतरीन औक़ात:
• फज्र के बाद तुलू-ए-आफ़ताब तक - मकरूह
• तुलू-ए-आफ़ताब के बाद ज़ुहर से 15 मिनट पहले तक - अच्छा
• ज़ुहर के बाद अस्र तक - अच्छा
• अस्र के बाद मग़रिब तक - मकरूह
• मग़रिब के बाद इशा तक - अच्छा
• इशा के बाद फज्र तक - बेहतरीन वक़्त (तहज्जुद)

महत्वपूर्ण बातें:
• नज़र की नमाज़ फ़र्ज़ नमाज़ों की जगह नहीं ले सकती
• अगर किसी ख़ास मस्जिद में नमाज़ पढ़ने की नज़र मानी तो वहीं पढ़नी होगी
• अगर उस मस्जिद में नमाज़ पढ़ना मुमकिन न हो तो जहां मुमकिन हो वहां पढ़ें''',
      },
    },
    {
      'title': 'Nazar for Sacrifice',
      'titleUrdu': 'قربانی کی نذر',
      'titleHindi': 'क़ुर्बानी की नज़र',
      'icon': Icons.pets,
      'color': Colors.red,
      'details': {
        'english': '''Nazar for Sacrifice (Qurbani/Udhiya)

How to Make This Nazar:
Say: "Ya Allah, if You fulfill my wish (mention your wish), I will sacrifice (animal type) for Your sake."

Example: "Ya Allah, if my son returns safely, I will sacrifice a goat."

How to Fulfill:
1. Purchase a healthy animal that meets the requirements
2. On the day of sacrifice, make intention (Niyyah)
3. Say: "Bismillahi Allahu Akbar" before slaughtering
4. Sacrifice according to Islamic method (Zabiha)
5. Distribute the meat as per Shariah

Animal Requirements:
• Goat/Sheep: At least 1 year old
• Cow/Buffalo: At least 2 years old
• Camel: At least 5 years old
• Must be healthy and free from defects

Meat Distribution:
• Divide into three parts:
  - 1/3 for yourself and family
  - 1/3 for relatives and friends
  - 1/3 for the poor and needy
• You can give all to the poor if you wish

When to Sacrifice:
• Can be done on any day (not restricted to Eid days)
• Best to do as soon as possible after condition is met
• Avoid unnecessary delay

Important Notes:
• Cannot sell any part of the animal
• Skin can be given in charity but not sold
• The sacrifice must be done with proper Islamic method''',
        'urdu': '''قربانی کی نذر

نذر ماننے کا طریقہ:
کہیں: "یا اللہ! اگر تو نے میری مراد (اپنی مراد بتائیں) پوری کر دی تو میں تیری رضا کے لیے (جانور) قربان کروں گا۔"

مثال: "یا اللہ! اگر میرا بیٹا صحیح سلامت واپس آ گیا تو میں ایک بکرا قربان کروں گا۔"

پورا کرنے کا طریقہ:
۱۔ ایک صحت مند جانور خریدیں جو شرائط پوری کرتا ہو
۲۔ قربانی کے دن نیت کریں
۳۔ ذبح کرنے سے پہلے کہیں: "بسم اللہ اللہ اکبر"
۴۔ اسلامی طریقے (ذبیحہ) سے قربانی کریں
۵۔ گوشت شریعت کے مطابق تقسیم کریں

جانور کی شرائط:
• بکری/بھیڑ: کم از کم 1 سال کا
• گائے/بھینس: کم از کم 2 سال کا
• اونٹ: کم از کم 5 سال کا
• صحت مند اور عیب سے پاک ہو

گوشت کی تقسیم:
• تین حصوں میں تقسیم کریں:
  - 1/3 اپنے اور خاندان کے لیے
  - 1/3 رشتہ داروں اور دوستوں کے لیے
  - 1/3 غریبوں اور ضرورت مندوں کے لیے
• چاہیں تو سارا غریبوں کو دے سکتے ہیں

قربانی کا وقت:
• کسی بھی دن کر سکتے ہیں (عید کے دنوں تک محدود نہیں)
• شرط پوری ہونے کے بعد جلد از جلد کرنا بہتر ہے
• غیر ضروری تاخیر سے بچیں

اہم نکات:
• جانور کا کوئی حصہ فروخت نہیں کر سکتے
• کھال صدقہ میں دے سکتے ہیں لیکن فروخت نہیں
• قربانی صحیح اسلامی طریقے سے ہونی چاہیے''',
        'hindi': '''क़ुर्बानी की नज़र

नज़र मानने का तरीका:
कहें: "या अल्लाह! अगर तूने मेरी मुराद (अपनी मुराद बताएं) पूरी कर दी तो मैं तेरी रज़ा के लिए (जानवर) क़ुर्बान करूंगा।"

उदाहरण: "या अल्लाह! अगर मेरा बेटा सही-सलामत वापस आ गया तो मैं एक बकरा क़ुर्बान करूंगा।"

पूरा करने का तरीका:
१. एक सेहतमंद जानवर ख़रीदें जो शर्तें पूरी करता हो
२. क़ुर्बानी के दिन नीयत करें
३. ज़बह करने से पहले कहें: "बिस्मिल्लाहि अल्लाहु अकबर"
४. इस्लामी तरीक़े (ज़बीहा) से क़ुर्बानी करें
५. गोश्त शरीअत के मुताबिक़ तक़सीम करें

जानवर की शर्तें:
• बकरी/भेड़: कम से कम 1 साल का
• गाय/भैंस: कम से कम 2 साल का
• ऊंट: कम से कम 5 साल का
• सेहतमंद और ऐब से पाक हो

गोश्त की तक़सीम:
• तीन हिस्सों में तक़सीम करें:
  - 1/3 अपने और ख़ानदान के लिए
  - 1/3 रिश्तेदारों और दोस्तों के लिए
  - 1/3 ग़रीबों और ज़रूरतमंदों के लिए
• चाहें तो सारा ग़रीबों को दे सकते हैं

क़ुर्बानी का वक़्त:
• किसी भी दिन कर सकते हैं (ईद के दिनों तक सीमित नहीं)
• शर्त पूरी होने के बाद जल्द से जल्द करना बेहतर है
• ग़ैर-ज़रूरी देरी से बचें

महत्वपूर्ण बातें:
• जानवर का कोई हिस्सा बेच नहीं सकते
• खाल सदक़े में दे सकते हैं लेकिन बेच नहीं सकते
• क़ुर्बानी सही इस्लामी तरीक़े से होनी चाहिए''',
      },
    },
    {
      'title': 'Nazar for Hajj/Umrah',
      'titleUrdu': 'حج/عمرہ کی نذر',
      'titleHindi': 'हज/उमरा की नज़र',
      'icon': Icons.place,
      'color': Colors.purple,
      'details': {
        'english': '''Nazar for Hajj or Umrah

How to Make This Nazar:
Say: "Ya Allah, if You fulfill my wish (mention your wish), I will perform Hajj/Umrah for Your sake."

Example: "Ya Allah, if I recover from this illness, I will perform Umrah."

Important Considerations:
• This is a major commitment - only make this vow if you have the means
• Once the condition is met, performing the pilgrimage becomes Wajib
• If you cannot perform it yourself, you must send someone on your behalf

How to Fulfill:
1. Make arrangements for the journey as soon as possible
2. Ensure you have sufficient funds and physical ability
3. Perform all rituals according to Sunnah
4. Complete the pilgrimage with pure intention

If Unable to Perform Personally:
• You can send a proxy (Badal) to perform on your behalf
• The proxy must have already performed their own Hajj/Umrah
• Pay for all expenses of the proxy
• The reward goes to you, and the proxy also gets reward

Umrah Rituals:
1. Enter Ihram at the Miqat
2. Perform Tawaf (7 circuits around Kaaba)
3. Pray 2 rakats behind Maqam Ibrahim
4. Perform Sa'i (7 times between Safa and Marwa)
5. Shave or trim hair

Important Notes:
• Start saving immediately once condition is met
• Do not delay unnecessarily
• If you pass away before fulfilling, your heirs should send someone on your behalf''',
        'urdu': '''حج یا عمرہ کی نذر

نذر ماننے کا طریقہ:
کہیں: "یا اللہ! اگر تو نے میری مراد (اپنی مراد بتائیں) پوری کر دی تو میں تیری رضا کے لیے حج/عمرہ کروں گا۔"

مثال: "یا اللہ! اگر میں اس بیماری سے شفا پا گیا تو میں عمرہ کروں گا۔"

اہم باتیں:
• یہ ایک بڑی ذمہ داری ہے - یہ نذر تبھی مانیں جب آپ کے پاس وسائل ہوں
• شرط پوری ہونے کے بعد زیارت واجب ہو جاتی ہے
• اگر خود نہیں کر سکتے تو اپنی طرف سے کسی کو بھیجنا ہوگا

پورا کرنے کا طریقہ:
۱۔ جلد از جلد سفر کا انتظام کریں
۲۔ یقینی بنائیں کہ آپ کے پاس کافی رقم اور جسمانی صلاحیت ہے
۳۔ تمام مناسک سنت کے مطابق ادا کریں
۴۔ خالص نیت کے ساتھ زیارت مکمل کریں

اگر خود نہیں کر سکتے:
• اپنی طرف سے کسی کو (بدل) بھیج سکتے ہیں
• بدل نے پہلے اپنا حج/عمرہ کیا ہوا ہو
• بدل کے تمام اخراجات ادا کریں
• ثواب آپ کو ملے گا اور بدل کو بھی ثواب ملے گا

عمرہ کے مناسک:
۱۔ میقات پر احرام باندھیں
۲۔ طواف کریں (کعبہ کے 7 چکر)
۳۔ مقام ابراہیم کے پیچھے 2 رکعت نماز پڑھیں
۴۔ سعی کریں (صفا اور مروہ کے درمیان 7 بار)
۵۔ سر منڈوائیں یا بال کتروائیں

اہم نکات:
• شرط پوری ہوتے ہی بچت شروع کریں
• غیر ضروری تاخیر نہ کریں
• اگر پورا کرنے سے پہلے وفات ہو جائے تو ورثاء آپ کی طرف سے کسی کو بھیجیں''',
        'hindi': '''हज या उमरा की नज़र

नज़र मानने का तरीका:
कहें: "या अल्लाह! अगर तूने मेरी मुराद (अपनी मुराद बताएं) पूरी कर दी तो मैं तेरी रज़ा के लिए हज/उमरा करूंगा।"

उदाहरण: "या अल्लाह! अगर मैं इस बीमारी से शिफ़ा पा गया तो मैं उमरा करूंगा।"

महत्वपूर्ण बातें:
• यह एक बड़ी ज़िम्मेदारी है - यह नज़र तभी मानें जब आपके पास साधन हों
• शर्त पूरी होने के बाद ज़ियारत वाजिब हो जाती है
• अगर ख़ुद नहीं कर सकते तो अपनी तरफ़ से किसी को भेजना होगा

पूरा करने का तरीका:
१. जल्द से जल्द सफ़र का इंतेज़ाम करें
२. यक़ीनी बनाएं कि आपके पास काफ़ी रक़म और जिस्मानी सलाहियत है
३. तमाम मनासिक सुन्नत के मुताबिक़ अदा करें
४. ख़ालिस नीयत के साथ ज़ियारत मुकम्मल करें

अगर ख़ुद नहीं कर सकते:
• अपनी तरफ़ से किसी को (बदल) भेज सकते हैं
• बदल ने पहले अपना हज/उमरा किया हुआ हो
• बदल के तमाम अख़राजात अदा करें
• सवाब आपको मिलेगा और बदल को भी सवाब मिलेगा

उमरा के मनासिक:
१. मीक़ात पर इहराम बांधें
२. तवाफ़ करें (काबा के 7 चक्कर)
३. मक़ाम-ए-इब्राहीम के पीछे 2 रकअत नमाज़ पढ़ें
४. सई करें (सफ़ा और मरवा के बीच 7 बार)
५. सर मुंडवाएं या बाल कटवाएं

महत्वपूर्ण बातें:
• शर्त पूरी होते ही बचत शुरू करें
• ग़ैर-ज़रूरी देरी न करें
• अगर पूरा करने से पहले वफ़ात हो जाए तो वारिस आपकी तरफ़ से किसी को भेजें''',
      },
    },
    {
      'title': 'Breaking a Nazar',
      'titleUrdu': 'نذر توڑنا',
      'titleHindi': 'नज़र तोड़ना',
      'icon': Icons.warning_amber,
      'color': Colors.amber,
      'details': {
        'english': '''What Happens If You Break a Nazar?

Breaking a Nazar (not fulfilling your vow after the condition is met) is a serious sin in Islam. However, there is a way to make amends through Kaffara (expiation).

When Kaffara is Required:
• When you deliberately break your Nazar
• When you are unable to fulfill the original vow
• When you want to change your vow to something else

Kaffara for Breaking Nazar:
The Kaffara is the same as breaking an oath (Yameen):

Option 1: Feed 10 poor people
• Give each person one meal (breakfast and lunch, or lunch and dinner)
• Or give the equivalent in grain/food items
• Approximately 1.75 kg of wheat or equivalent per person

Option 2: Clothe 10 poor people
• Give each person clothing that covers their body adequately
• One complete outfit per person

Option 3: Free a slave
• This option is not applicable in modern times

Option 4: Fast for 3 consecutive days
• Only if you cannot afford Options 1 or 2
• The fasts must be consecutive (back to back)
• If you break the sequence, restart from day 1

Important Notes:
• Kaffara should be given promptly
• Do not make Nazars carelessly in the future
• Think carefully before making any vow to Allah
• If you made a Nazar for something Haram, do not fulfill it and give Kaffara instead''',
        'urdu': '''نذر توڑنے پر کیا ہوتا ہے؟

نذر توڑنا (شرط پوری ہونے کے بعد وعدہ پورا نہ کرنا) اسلام میں ایک سنگین گناہ ہے۔ تاہم، کفارے کے ذریعے اس کی تلافی کی جا سکتی ہے۔

کفارہ کب ضروری ہے:
• جب آپ جان بوجھ کر نذر توڑیں
• جب آپ اصل نذر پوری کرنے سے قاصر ہوں
• جب آپ اپنی نذر کو کسی اور چیز میں بدلنا چاہیں

نذر توڑنے کا کفارہ:
کفارہ قسم (یمین) توڑنے جیسا ہے:

پہلا آپشن: 10 غریبوں کو کھانا کھلائیں
• ہر شخص کو ایک وقت کا کھانا دیں (ناشتہ اور دوپہر، یا دوپہر اور رات)
• یا اناج/کھانے کی اشیاء میں اتنی مقدار دیں
• تقریباً 1.75 کلو گندم یا اس کے برابر فی شخص

دوسرا آپشن: 10 غریبوں کو لباس دیں
• ہر شخص کو ایسا لباس دیں جو ان کے جسم کو مناسب طور پر ڈھانپے
• ہر شخص کو ایک مکمل لباس

تیسرا آپشن: غلام آزاد کریں
• یہ آپشن موجودہ دور میں قابل اطلاق نہیں

چوتھا آپشن: لگاتار 3 دن روزے رکھیں
• صرف اس صورت میں جب آپ پہلے دو آپشنز برداشت نہ کر سکیں
• روزے لگاتار ہونے چاہئیں
• اگر سلسلہ ٹوٹ جائے تو دوبارہ پہلے دن سے شروع کریں

اہم نکات:
• کفارہ فوری طور پر دینا چاہیے
• مستقبل میں لاپرواہی سے نذر نہ مانیں
• اللہ سے کوئی وعدہ کرنے سے پہلے سوچ سمجھ لیں
• اگر کسی حرام چیز کی نذر مانی تو اسے پورا نہ کریں بلکہ کفارہ دیں''',
        'hindi': '''नज़र तोड़ने पर क्या होता है?

नज़र तोड़ना (शर्त पूरी होने के बाद वादा पूरा न करना) इस्लाम में एक गंभीर गुनाह है। हालांकि, कफ़्फ़ारे के ज़रिए इसकी भरपाई की जा सकती है।

कफ़्फ़ारा कब ज़रूरी है:
• जब आप जानबूझकर नज़र तोड़ें
• जब आप असल नज़र पूरी करने से क़ासिर हों
• जब आप अपनी नज़र को किसी और चीज़ में बदलना चाहें

नज़र तोड़ने का कफ़्फ़ारा:
कफ़्फ़ारा क़सम (यमीन) तोड़ने जैसा है:

पहला विकल्प: 10 ग़रीबों को खाना खिलाएं
• हर शख़्स को एक वक़्त का खाना दें (नाश्ता और दोपहर, या दोपहर और रात)
• या अनाज/खाने की चीज़ों में इतनी मात्रा दें
• तक़रीबन 1.75 किलो गेहूं या उसके बराबर प्रति व्यक्ति

दूसरा विकल्प: 10 ग़रीबों को कपड़े दें
• हर शख़्स को ऐसा लिबास दें जो उनके जिस्म को मुनासिब तौर पर ढांपे
• हर शख़्स को एक मुकम्मल लिबास

तीसरा विकल्प: ग़ुलाम आज़ाद करें
• यह विकल्प मौजूदा दौर में लागू नहीं

चौथा विकल्प: लगातार 3 दिन रोज़े रखें
• सिर्फ़ उस सूरत में जब आप पहले दो विकल्प बर्दाश्त न कर सकें
• रोज़े लगातार होने चाहिए
• अगर सिलसिला टूट जाए तो दोबारा पहले दिन से शुरू करें

महत्वपूर्ण बातें:
• कफ़्फ़ारा फ़ौरी तौर पर देना चाहिए
• मुस्तक़बिल में लापरवाही से नज़र न मानें
• अल्लाह से कोई वादा करने से पहले सोच-समझ लें
• अगर किसी हराम चीज़ की नज़र मानी तो उसे पूरा न करें बल्कि कफ़्फ़ारा दें''',
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
            // Nazar Types Grid
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _nazarTypes.length,
              itemBuilder: (context, index) {
                final nazar = _nazarTypes[index];
                return _buildNazarCard(
                  nazar,
                  isDark,
                  index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNazarCard(
    Map<String, dynamic> nazar,
    bool isDark,
    int index,
  ) {
    const emeraldGreen = Color(0xFF1E8F5A);

    final title = _selectedLanguage == 'english'
        ? nazar['title']
        : _selectedLanguage == 'urdu'
        ? nazar['titleUrdu']
        : nazar['titleHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.05 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showNazarDetails(nazar),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon Circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: nazar['color'] as Color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (nazar['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    nazar['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
                  ),
                  textDirection: _selectedLanguage == 'urdu'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),
              // Arrow
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark
                      ? emeraldGreen.withValues(alpha: 0.3)
                      : emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? Colors.green.shade300 : Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNazarDetails(Map<String, dynamic> nazar) {
    final details = nazar['details'] as Map<String, String>;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: nazar['title'],
          titleUrdu: nazar['titleUrdu'] ?? '',
          titleHindi: nazar['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: nazar['color'] as Color,
          icon: nazar['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Nazar',
        ),
      ),
    );
  }
}
