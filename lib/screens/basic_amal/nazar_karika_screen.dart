import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NazarKarikaScreen extends StatefulWidget {
  const NazarKarikaScreen({super.key});

  @override
  State<NazarKarikaScreen> createState() => _NazarKarikaScreenState();
}

class _NazarKarikaScreenState extends State<NazarKarikaScreen> {



  final List<Map<String, dynamic>> _nazarTypes = [
    {
      'titleKey': 'nazar_karika_1_nazar_for_charity',
      'title': 'Nazar for Charity',
      'titleUrdu': 'صدقے کی نذر',
      'titleHindi': 'सदक़े की नज़र',
      'titleArabic': 'نذر الصدقة',
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
        'arabic': '''نذر الصدقة

نذر الصدقة هو وعد تقطعه لله تعالى بإخراج صدقة عند تحقق مرادك.

كيفية النذر:
قل: "يا الله، إذا حققت لي طلبي (اذكر طلبك)، سأتصدق بـ(المبلغ/الشيء) لوجهك الكريم."

مثال: "يا الله، إذا شُفي ولدي من المرض، سأطعم 10 فقراء."

كيفية الوفاء:
١. عند تحقق مرادك، أوفِ بوعدك في أقرب وقت ممكن
٢. أعطِ الصدقة للفقراء والمحتاجين
٣. لا تؤخر بلا سبب
٤. تصدق بنية خالصة لله

أنواع الصدقة:
• المال للفقراء
• توزيع الطعام
• الملابس للمحتاجين
• الدعم التعليمي
• المساعدة الطبية

نقاط مهمة:
• يجب أن تُعطى الصدقة لمن يستحقون الزكاة
• يمكنك التوزيع على شخص واحد أو عدة أشخاص
• النية يجب أن تكون خالصة لله
• احفظ وعدك - نقض النذر إثم''',
      },
    },
    {
      'titleKey': 'nazar_karika_2_nazar_for_fasting',
      'title': 'Nazar for Fasting',
      'titleUrdu': 'روزے کی نذر',
      'titleHindi': 'रोज़े की नज़र',
      'titleArabic': 'نذر الصيام',
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
        'arabic': '''نذر الصيام

نذر الصيام هو وعد تقطعه لله تعالى بصيام عدد من الأيام عند تحقق مرادك.

كيفية النذر:
قل: "يا الله، إذا حققت لي طلبي (اذكر طلبك)، سأصوم (عدد) أيام لوجهك الكريم."

مثال: "يا الله، إذا حصلت على هذه الوظيفة، سأصوم 3 أيام."

كيفية الوفاء:
١. صم في الأيام المباحة (ليس في أيام العيد أو أيام التشريق)
٢. نوِّ قبل الفجر: "أنا صائم اليوم لأفي بنذري لله"
٣. صم من الفجر إلى المغرب
٤. أفطر عند المغرب بتمر أو ماء

أحكام صيام النذر:
• هذه الأصوام واجبة بعد تحقق الشرط
• يمكن صيامها متتابعة أو متفرقة
• لا يمكن الصيام في يومي العيد
• لا يمكن الصيام في 11 و12 و13 ذو الحجة
• إذا لم تستطع الصيام بسبب المرض، اقضها لاحقاً
• إذا كنت عاجزاً بشكل دائم، أعطِ الفدية

الفدية (إذا لم تستطع الصيام):
• أطعم مسكيناً واحداً عن كل يوم فائت
• أعطِ ما يعادل وجبة واحدة
• أو ادفع المعادل المالي''',
      },
    },
    {
      'titleKey': 'nazar_karika_3_nazar_for_prayer',
      'title': 'Nazar for Prayer',
      'titleUrdu': 'نماز کی نذر',
      'titleHindi': 'नमाज़ की नज़र',
      'titleArabic': 'نذر الصلاة',
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
        'arabic': '''نذر الصلاة

نذر الصلاة هو وعد تقطعه لله تعالى بأداء عدد من ركعات النافلة عند تحقق مرادك.

كيفية النذر:
قل: "يا الله، إذا حققت لي طلبي (اذكر طلبك)، سأصلي (عدد) ركعات نافلة لوجهك الكريم."

مثال: "يا الله، إذا نجحت العملية الجراحية، سأصلي 4 ركعات صلاة الشكر."

كيفية الوفاء:
١. صلِّ بوضوء صحيح
٢. نوِّ: "أنا أصلي هذه الركعات لأفي بنذري لله"
٣. صلِّ بخشوع تام
٤. أكمل جميع أركان الصلاة بشكل صحيح

أنواع صلوات النذر:
• صلاة الشكر - ركعتان أو 4 ركعات
• صلاة الحاجة - ركعتان أو 4 ركعات
• صلاة التوبة - ركعتان
• صلاة النافلة العامة - حسب الوعد

أفضل أوقات النوافل:
• بعد الفجر حتى الشروق - مكروه
• بعد الشروق حتى 15 دقيقة قبل الظهر - جيد
• بعد الظهر حتى العصر - جيد
• بعد العصر حتى المغرب - مكروه
• بعد المغرب حتى العشاء - جيد
• بعد العشاء حتى الفجر - أفضل وقت (التهجد)

ملاحظات مهمة:
• صلاة النذر لا تحل محل الفرائض
• إذا نذرت الصلاة في مسجد معين، يجب أن تصلي فيه
• إذا تعذر الصلاة في ذلك المسجد، صلِّ حيثما أمكن''',
      },
    },
    {
      'titleKey': 'nazar_karika_4_nazar_for_sacrifice',
      'title': 'Nazar for Sacrifice',
      'titleUrdu': 'قربانی کی نذر',
      'titleHindi': 'क़ुर्बानी की नज़र',
      'titleArabic': 'نذر الأضحية',
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
        'arabic': '''نذر الأضحية

نذر الأضحية هو وعد تقطعه لله تعالى بذبح حيوان عند تحقق مرادك.

كيفية النذر:
قل: "يا الله، إذا حققت لي طلبي (اذكر طلبك)، سأذبح (نوع الحيوان) لوجهك الكريم."

مثال: "يا الله، إذا عاد ابني سالماً، سأذبح خروفاً."

كيفية الوفاء:
١. اشترِ حيواناً صحيحاً يستوفي الشروط
٢. يوم الذبح، نوِّ النية
٣. قل: "بسم الله الله أكبر" قبل الذبح
٤. اذبح وفق الطريقة ��لإسلامية (الذبيحة)
٥. وزع اللحم حسب الشريعة

شروط الحيوان:
• الماعز/الخروف: عمره سنة على الأقل
• البقر/الجاموس: عمره سنتان على الأقل
• الجمل: عمره 5 سنوات على الأقل
• يجب أن يكون صحيحاً وخالياً من العيوب

توزيع اللحم:
• قسمه إلى ثلاثة أجزاء:
  - ثلث لنفسك وعائلتك
  - ثلث للأقارب والأصدقاء
  - ثلث للفقراء والمحتاجين
• يمكنك إعطاء الكل للفقراء إذا شئت

وقت الذبح:
• يمكن الذبح في أي يوم (ليس مقيداً بأيام العيد)
• الأفضل الذبح في أقرب وقت بعد تحقق الشرط
• تجنب التأخير غير الضروري

ملاحظات مهمة:
• لا يمكن بيع أي جزء من الحيوان
• الجلد يمكن التصدق به ولكن لا يباع
• يجب أن يتم الذبح بالطريقة الإسلامية الصحيحة''',
      },
    },
    {
      'titleKey': 'nazar_karika_5_nazar_for_hajjumrah',
      'title': 'Nazar for Hajj/Umrah',
      'titleUrdu': 'حج/عمرہ کی نذر',
      'titleHindi': 'हज/उमरा की नज़र',
      'titleArabic': 'نذر الحج/العمرة',
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
        'arabic': '''نذر الحج/العمرة

نذر الحج أو العمرة هو وعد تقطعه لله تعالى بأداء الحج أو العمرة عند تحقق مرادك.

كيفية النذر:
قل: "يا الله، إذا حققت لي طلبي (اذكر طلبك)، سأؤدي الحج/العمرة لوجهك الكريم."

مثال: "يا الله، إذا شُفيت من هذا المرض، سأعتمر."

اعتبارات مهمة:
• هذا التزام كبير - لا تنذر إلا إذا كانت لديك الوسائل
• بعد تحقق الشرط، يصبح أداء الحج واجباً
• إذا لم تستطع أداءه بنفسك، أرسل نائباً عنك

كيفية الوفاء:
١. رتب للرحلة في أقرب وقت ممكن
٢. تأكد من أن لديك الأموال الكافية والقدرة البدنية
٣. أدِّ جميع المناسك وفق السنة
٤. أكمل الحج بنية خالصة

إذا لم تستطع الأداء شخصياً:
• يمكنك إرسال بديل (نائب) ليؤدي عنك
• يجب أن يكون النائب قد أدى حجه/عمرته الخاصة
• ادفع جميع نفقات النائب
• الأجر لك والنائب ينال أجراً أيضاً

مناسك العمرة:
١. أحرم من الميقات
٢. طف بالكعبة (7 أشواط)
٣. صلِّ ركعتين خلف مقام إبراهيم
٤. اسعَ بين الصفا والمروة (7 مرات)
٥. احلق أو قصر الشعر

ملاحظات مهمة:
• ابدأ الادخار فوراً بعد تحقق الشرط
• لا تؤخر بلا سبب
• إذا توفيت قبل الوفاء، يجب على ورثتك إرسال نائب عنك''',
      },
    },
    {
      'titleKey': 'nazar_karika_6_breaking_a_nazar',
      'title': 'Breaking a Nazar',
      'titleUrdu': 'نذر توڑنا',
      'titleHindi': 'नज़र तोड़ना',
      'titleArabic': 'نقض النذر',
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
        'arabic': '''ماذا يحدث عند نقض النذر؟

نقض النذر (عدم الوفاء بالوعد بعد تحقق الشرط) إثم عظيم في الإسلام. ومع ذلك، هناك طريقة للتكفير عنه من خلال الكفارة.

متى تجب الكفارة:
• عندما تنقض نذرك عمداً
• عندما لا تستطيع الوفاء بالنذر الأصلي
• عندما تريد تغيير نذرك إلى شيء آخر

كفارة نقض النذر:
الكفارة هي نفسها كفارة نقض اليمين:

الخيار الأول: إطعام 10 مساكين
• أعطِ كل مسكين وجبة واحدة (فطور وغداء، أو غداء وعشاء)
• أو أعطِ ما يعادلها من الحبوب/المواد الغذائية
• حوالي 1.75 كجم من القمح أو ما يعادله لكل شخص

الخيار الثاني: كسوة 10 مساكين
• أعطِ كل مسكين ملابس تستر جسده بشكل مناسب
• زي كامل لكل شخص

الخيار الثالث: عتق رقبة
• هذا الخيار غير متاح في العصر الحديث

الخيار الرابع: صيام 3 أيام متتابعة
• فقط إذا لم تستطع تحمل الخيارين الأول والثاني
• يجب أن تكون الأصوام متتابعة
• إذا انقطعت التتابع، ابدأ من اليوم الأول

ملاحظات مهمة:
• يجب إعطاء الكفارة فوراً
• لا تنذر بتهور في المستقبل
• فكر جيداً قبل أن تعد الله بشيء
• إذا نذرت شيئاً حراماً، لا تفِ به وأعطِ الكفارة بدلاً منه''',
      },
    },
    {
      'titleKey': 'nazar_karika_7_rules_and_conditions',
      'title': 'Rules & Conditions',
      'titleUrdu': 'اصول اور شرائط',
      'titleHindi': 'उसूल और शर्तें',
      'titleArabic': 'القواعد والشروط',
      'icon': Icons.rule,
      'color': Colors.indigo,
      'details': {
        'english': '''Rules and Conditions of Nazar

What is Nazar (النذر)?
Nazar is a vow or promise made to Allah to perform a good deed if a specific wish is fulfilled. It becomes obligatory (Wajib) once the condition is met.

Basic Conditions:
1. The person must be Muslim
2. Must be of sound mind (not insane)
3. Must be mature (reached puberty)
4. Must make the vow willingly (not forced)
5. Must be capable of fulfilling the vow

Types of Nazar:
1. Conditional Nazar (المعلق):
   "If Allah does this, I will do that"
   Example: "If I pass the exam, I will fast 3 days"

2. Unconditional Nazar (المطلق):
   Making a vow without conditions
   Example: "I vow to Allah to pray 2 rakats tonight"

When Does Nazar Become Wajib?
• For conditional Nazar: When the condition is fulfilled
• For unconditional Nazar: Immediately after making the vow
• Cannot be cancelled once the condition is met
• Must be fulfilled as soon as possible

Valid Forms of Nazar:
• Fasting
• Prayer (Nafl)
• Charity
• Sacrifice
• Hajj/Umrah
• Any act of worship that is permissible

What You CANNOT Make Nazar For:
• Anything Haram (forbidden)
• Harming yourself or others
• Something impossible
• Fard (obligatory) acts you already must do
• Acts of disobedience

Important Rules:
1. Delaying fulfillment without reason is sinful
2. Breaking Nazar requires Kaffara (expiation)
3. If you die before fulfilling, heirs should fulfill it
4. Nazar of Haram should not be fulfilled
5. Make Nazar only when necessary

The Prophet's ﷺ Guidance:
"Do not make vows, for a vow does not change anything of the Divine Decree. It only extracts something from the miserly." (Sahih Muslim)

Scholars' Advice:
• Avoid making Nazar unnecessarily
• If you make one, fulfill it promptly
• Don't make Nazar as a bargaining tool with Allah
• Trust in Allah's decree first
• Make dua instead of Nazar when possible''',
        'urdu': '''نذر کے اصول اور شرائط

نذر (النذر) کیا ہے؟
نذر اللہ سے کیا گیا ایک وعدہ یا عہد ہے کہ اگر کوئی خاص خواہش پوری ہو جائے تو نیک کام کیا جائے گا۔ شرط پوری ہونے کے بعد یہ واجب ہو جاتی ہے۔

بنیادی شرائط:
۱۔ شخص مسلمان ہونا چاہیے
۲۔ عقل مند ہونا چاہیے (پاگل نہ ہو)
۳۔ بالغ ہونا چاہیے (بلوغت کو پہنچا ہو)
۴۔ رضامندی سے نذر مانی ہو (مجبور نہ ہو)
۵۔ نذر پوری کرنے کی صلاحیت ہو

نذر کی اقسام:
۱۔ مشروط نذر (المعلق):
   "اگر اللہ یہ کرے تو میں وہ کروں گا"
   مثال: "اگر میں امتحان پاس کر لوں تو 3 دن روزے رکھوں گا"

۲۔ غیر مشروط نذر (المطلق):
   بغیر شرط کے نذر ماننا
   مثال: "میں اللہ سے نذر مانتا ہوں کہ آج رات 2 رکعت نماز پڑھوں گا"

نذر کب واجب ہوتی ہے؟
• مشروط نذر: جب شرط پوری ہو جائے
• غیر مشروط نذر: نذر ماننے کے فوراً بعد
• شرط پوری ہونے کے بعد منسوخ نہیں کی جا سکتی
• جلد از جلد پوری کرنی چاہیے

نذر کی جائز شکلیں:
• روزہ
• نماز (نفل)
• صدقہ
• قربانی
• حج/عمرہ
• کوئی بھی جائز عبادت

کس چیز کی نذر نہیں مانی جا سکتی:
• کوئی بھی حرام چیز
• اپنے یا دوسروں کو نقصان پہنچانا
• کوئی ناممکن چیز
• فرض اعمال جو پہلے سے ضروری ہیں
• نافرمانی کے کام

اہم اصول:
۱۔ بلا وجہ تاخیر گناہ ہے
۲۔ نذر توڑنے پر کفارہ واجب ہے
۳۔ اگر پورا کرنے سے پہلے وفات ہو تو ورثاء کو پورا کرنا چاہیے
۴۔ حرام کی نذر پوری نہیں کی جائے
۵۔ صرف ضرورت کے وقت نذر مانیں

نبی کریم ﷺ کی رہنمائی:
"نذر نہ مانو، کیونکہ نذر تقدیر میں کچھ نہیں بدلتی۔ یہ صرف کنجوس سے کچھ نکلواتی ہے۔" (صحیح مسلم)

علماء کا مشورہ:
• غیر ضروری نذر نہ مانیں
• اگر مان لیں تو فوراً پوری کریں
• نذر کو اللہ سے سودا نہ بنائیں
• پہلے اللہ کی تقدیر پر بھروسہ کریں
• جہاں ممکن ہو دعا کریں نذر کی بجائے''',
        'hindi': '''नज़र के उसूल और शर्तें

नज़र (النذر) क्या है?
नज़र अल्लाह से किया गया एक वादा या अहद है कि अगर कोई ख़ास ख़्वाहिश पूरी हो जाए तो नेक काम किया जाएगा। शर्त पूरी होने के बाद यह वाजिब हो जाती है।

बुनियादी शर्तें:
१. शख़्स मुसलमान होना चाहिए
२. अक़्लमंद होना चाहिए (पागल न हो)
३. बालिग़ होना चाहिए (बलूग़त को पहुंचा हो)
४. रज़ामंदी से नज़र मानी हो (मजबूर न हो)
५. नज़र पूरी करने की सलाहियत हो

नज़र की क़िस्में:
१. मशरूत नज़र (المعلق):
   "अगर अल्लाह यह करे तो मैं वो करूंगा"
   मिसाल: "अगर मैं इम्तिहान पास कर लूं तो 3 दिन रोज़े रखूंगा"

२. ग़ैर-मशरूत नज़र (المطلق):
   बग़ैर शर्त के नज़र मानना
   मिसाल: "मैं अल्लाह से नज़र मानता हूं कि आज रात 2 रकअत नमाज़ पढ़ूंगा"

नज़र कब वाजिब होती है?
• मशरूत नज़र: जब शर्त पूरी हो जाए
• ग़ैर-मशरूत नज़र: नज़र मानने के फ़ौरन बाद
• शर्त पूरी होने के बाद मनसूख़ नहीं की जा सकती
• जल्द से जल्द पूरी करनी चाहिए

नज़र की जायज़ शक्लें:
• रोज़ा
• नमाज़ (नफ़्ल)
• सदक़ा
• क़ुर्बानी
• हज/उमरा
• कोई भी जायज़ इबादत

किस चीज़ की नज़र नहीं मानी जा सकती:
• कोई भी हराम चीज़
• अपने या दूसरों को नुक़सान पहुंचाना
• कोई नामुमकिन चीज़
• फ़र्ज़ आमाल जो पहले से ज़रूरी हैं
• नाफ़रमानी के काम

अहम उसूल:
१. बिला वजह तअख़ीर गुनाह है
२. नज़र तोड़ने पर कफ़्फ़ारा वाजिब है
३. अगर पूरा करने से पहले वफ़ात हो तो वारिस को पूरा करना चाहिए
४. हराम की नज़र पूरी नहीं की जाए
५. सिर्फ़ ज़रूरत के वक़्त नज़र मानें

नबी करीम ﷺ की रहनुमाई:
"नज़र न मानो, क्योंकि नज़र तक़दीर में कुछ नहीं बदलती। यह सिर्फ़ कंजूस से कुछ निकलवाती है।" (सहीह मुस्लिम)

उलमा का मशवरा:
• ग़ैर-ज़रूरी नज़र न मानें
• अगर मान लें तो फ़ौरन पूरी करें
• नज़र को अल्लाह से सौदा न बनाएं
• पहले अल्लाह की तक़दीर पर भरोसा करें
• जहां मुमकिन हो दुआ करें नज़र की बजाय''',
        'arabic': '''القواعد والشروط للنذر

ما هو النذر؟
النذر هو وعد أو عهد تقطعه لله بأداء عمل صالح إذا تحقق طلب معين. يصبح واجباً بعد تحقق الشرط.

الشروط الأساسية:
١. يجب أن يكون الشخص مسلماً
٢. يجب أن يكون عاقلاً (غير مجنون)
٣. يجب أن يكون بالغاً
٤. يجب أن ينذر طواعية (غير مكره)
٥. يجب أن يكون قادراً على الوفاء بالنذر

أنواع النذر:
١. النذر المعلق:
   "إذا فعل الله هذا، سأفعل ذاك"
   مثال: "إذا نجحت في الامتحان، سأصوم 3 أيام"

٢. النذر المطلق:
   النذر بدون شرط
   مثال: "نذرت لله أن أصلي ركعتين الليلة"

متى يصبح النذر واجباً?
• للنذر المعلق: عند تحقق الشرط
• للنذر المطلق: فوراً بعد النذر
• لا يمكن إلغاؤه بعد تحقق الشرط
• يجب الوفاء به في أقرب وقت

أشكال النذر الصحيحة:
• الصيام
• الصلاة (النافلة)
• الصدقة
• الأضحية
• الحج/العمرة
• أي عبادة مباحة

ما لا يجوز النذر به:
• أي شيء حرام
• إيذاء النفس أو الآخرين
• شيء مستحيل
• الفرائض الواجبة أصلاً
• أعمال المعصية

قواعد مهمة:
١. التأخير بلا سبب إثم
٢. نقض النذر يتطلب كفارة
٣. إذا مت قبل الوفاء، يجب على الورثة الوفاء به
٤. نذر الحرام لا يُوفى به
٥. انذر فقط عند الضرورة

إرشاد النبي ﷺ:
"لا تنذروا، فإن النذر لا يرد من القدر شيئاً، وإنما يستخرج به من البخيل" (صحيح مسلم)

نصيحة العلماء:
• تجنب النذر غير الضروري
• إذا نذرت، أوفِ به فوراً
• لا تجعل النذر مساومة مع الله
• توكل على قضاء الله أولاً
• ادع بدلاً من النذر حيثما أمكن''',
      },
    },
    {
      'titleKey': 'nazar_karika_8_hadith_about_nazar',
      'title': 'Hadith About Nazar',
      'titleUrdu': 'نذر کے بارے میں احادیث',
      'titleHindi': 'नज़र के बारे में हदीसें',
      'titleArabic': 'أحاديث عن النذر',
      'icon': Icons.library_books,
      'color': Colors.brown,
      'details': {
        'english': '''Authentic Hadith About Nazar (Vows)

1. The Prophet ﷺ said:
"Whoever makes a vow to obey Allah, let him obey Him. Whoever makes a vow to disobey Allah, let him not disobey Him."
(Sahih Bukhari 6696)

Lesson: Only fulfill vows of obedience, not disobedience.

2. The Prophet ﷺ said:
"Do not make vows, for a vow does not change anything of the Divine Decree. It only extracts something from the miserly."
(Sahih Muslim 1639)

Lesson: Nazar doesn't change destiny, avoid making it unnecessarily.

3. Abdullah ibn Abbas (RA) reported:
The Prophet ﷺ said: "Whoever makes a vow but does not name it, its expiation is the expiation for an oath. Whoever makes a vow to do an act of disobedience, its expiation is the expiation for an oath. Whoever makes a vow that he is unable to fulfill, its expiation is the expiation for an oath. Whoever makes a vow that he is able to fulfill must fulfill it."
(Sunan Abu Dawud 3320)

Lesson: Different types of vows have different rulings.

4. Imran ibn Husain (RA) reported:
The Prophet ﷺ said: "There is no fulfillment of a vow in something that a person does not possess, or in disobedience, or in severing family ties."
(Sunan Abu Dawud 3293)

Lesson: Invalid vows don't need to be fulfilled.

5. Aisha (RA) reported:
The Prophet ﷺ said: "There is no vow in disobedience to Allah, and its expiation is the expiation of an oath."
(Jami at-Tirmidhi 1524)

Lesson: Sinful vows require Kaffara, not fulfillment.

6. Uqbah ibn Amir (RA) reported:
The Prophet ﷺ said: "The expiation for a vow is the expiation for an oath."
(Sahih Muslim 1645)

Lesson: Breaking a vow has the same expiation as breaking an oath.

Important Points from Hadith:
• Fulfill vows of obedience to Allah
• Don't fulfill vows of disobedience
• Broken vows require Kaffara
• Avoid making vows unnecessarily
• Trust in Allah's decree, not vows
• Invalid vows don't bind you

Kaffara for Breaking Vow:
Same as oath-breaking:
1. Feed 10 poor people, OR
2. Clothe 10 poor people, OR
3. Free a slave (not applicable today), OR
4. Fast 3 consecutive days (if unable to do 1-3)''',
        'urdu': '''نذر (منت) کے بارے میں صحیح احادیث

۱۔ نبی کریم ﷺ نے فرمایا:
"جس نے اللہ کی اطاعت کی نذر مانی تو اسے چاہیے کہ اس کی اطاعت کرے۔ اور جس نے نافرمانی کی نذر مانی تو اسے نافرمانی نہیں کرنی چاہیے۔"
(صحیح بخاری 6696)

سبق: صرف فرمانبرداری کی نذریں پوری کریں، نافرمانی کی نہیں۔

۲۔ نبی کریم ﷺ نے فرمایا:
"نذر نہ مانو، کیونکہ نذر تقدیر الٰہی میں کچھ نہیں بدلتی۔ یہ صرف کنجوس سے کچھ نکلواتی ہے۔"
(صحیح مسلم 1639)

سبق: نذر تقدیر نہیں بدلتی، غیر ضروری نذر نہ مانیں۔

۳۔ عبداللہ بن عباس رضی اللہ عنہما سے روایت ہے:
نبی کریم ﷺ نے فرمایا: "جس نے نذر مانی لیکن اس کا نام نہیں بتایا، اس کا کفارہ قسم کا کفارہ ہے۔ جس نے نافرمانی کی نذر مانی، اس کا کفارہ قسم کا کفارہ ہے۔ جس نے ایسی نذر مانی جسے پورا کرنے کی طاقت نہیں، اس کا کفارہ قسم کا کفارہ ہے۔ جس نے ایسی نذر مانی جسے پورا کر سکتا ہے تو اسے ضرور پورا کرنا چاہیے۔"
(سنن ابو داؤد 3320)

سبق: مختلف قسم کی نذروں کے مختلف احکام ہیں۔

۴۔ عمران بن حصین رضی اللہ عنہ سے روایت ہے:
نبی کریم ﷺ نے فرمایا: "کسی ایسی چیز میں نذر کی تکمیل نہیں جو انسان کے پاس نہیں، یا نافرمانی میں، یا قطع رحمی میں۔"
(سنن ابو داؤد 3293)

سبق: غیر جائز نذریں پوری کرنے کی ضرورت نہیں۔

۵۔ عائشہ رضی اللہ عنہا سے روایت ہے:
نبی کریم ﷺ نے فرمایا: "اللہ کی نافرمانی میں کوئی نذر نہیں، اور اس کا کفارہ قسم کا کفارہ ہے۔"
(جامع ترمذی 1524)

سبق: گناہ کی نذروں کو پورا نہیں کیا جائے، کفارہ دیا جائے۔

۶۔ عقبہ بن عامر رضی اللہ عنہ سے روایت ہے:
نبی کریم ﷺ نے فرمایا: "نذر کا کفارہ قسم کا کفارہ ہے۔"
(صحیح مسلم 1645)

سبق: نذر توڑنے کا کفارہ قسم توڑنے جیسا ہے۔

احادیث سے اہم نکات:
• اللہ کی فرمانبرداری کی نذریں پوری کریں
• نافرمانی کی نذریں پوری نہ کریں
• توڑی گئی نذروں کا کفارہ دیں
• غیر ضروری نذر نہ مانیں
• اللہ کی تقدیر پر بھروسہ کریں، نذر پر نہیں
• غیر جائز نذریں آپ کو پابند نہیں کرتیں

نذر توڑنے کا کفارہ:
قسم توڑنے جیسا:
۱۔ 10 غریبوں کو کھانا کھلائیں، یا
۲۔ 10 غریبوں کو کپڑے دیں، یا
۳۔ غلام آزاد کریں (آج کل قابل اطلاق نہیں)، یا
۴۔ لگاتار 3 دن روزے رکھیں (اگر 1-3 نہیں کر سکتے)''',
        'hindi': '''नज़र (मन्नत) के बारे में सहीह हदीसें

१. नबी करीम ﷺ ने फ़रमाया:
"जिसने अल्लाह की इताअत की नज़र मानी तो उसे चाहिए कि उसकी इताअत करे। और जिसने नाफ़रमानी की नज़र मानी तो उसे नाफ़रमानी नहीं करनी चाहिए।"
(सहीह बुख़ारी 6696)

सबक़: सिर्फ़ फ़रमांबरदारी की नज़रें पूरी करें, नाफ़रमानी की नहीं।

२. नबी करीम ﷺ ने फ़रमाया:
"नज़र न मानो, क्योंकि नज़र तक़दीर-ए-इलाही में कुछ नहीं बदलती। यह सिर्फ़ कंजूस से कुछ निकलवाती है।"
(सहीह मुस्लिम 1639)

सबक़: नज़र तक़दीर नहीं बदलती, ग़ैर-ज़रूरी नज़र न मानें।

३. अब्दुल्लाह बिन अब्बास रज़ियल्लाहु अन्हुमा से रिवायत है:
नबी करीम ﷺ ने फ़रमाया: "जिसने नज़र मानी लेकिन उसका नाम नहीं बताया, उसका कफ़्फ़ारा क़सम का कफ़्फ़ारा है। जिसने नाफ़रमानी की नज़र मानी, उसका कफ़्फ़ारा क़सम का कफ़्फ़ारा है। जिसने ऐसी नज़र मानी जिसे पूरा करने की ताक़त नहीं, उसका कफ़्फ़ारा क़सम का कफ़्फ़ारा है। जिसने ऐसी नज़र मानी जिसे पूरा कर सकता है तो उसे ज़रूर पूरा करना चाहिए।"
(सुनन अबू दाऊद 3320)

सबक़: मुख़्तलिफ़ क़िस्म की नज़रों के मुख़्तलिफ़ अहकाम हैं।

४. इमरान बिन हुसैन रज़ियल्लाहु अन्हु से रिवायत है:
नबी करीम ﷺ ने फ़रमाया: "किसी ऐसी चीज़ में नज़र की तकमील नहीं जो इंसान के पास नहीं, या नाफ़रमानी में, या क़त-ए-रहमी में।"
(सुनन अबू दाऊद 3293)

सबक़: ग़ैर-जायज़ नज़रें पूरी करने की ज़रूरत नहीं।

५. आइशा रज़ियल्लाहु अन्हा से रिवायत है:
नबी करीम ﷺ ने फ़रमाया: "अल्लाह की नाफ़रमानी में कोई नज़र नहीं, और उसका कफ़्फ़ारा क़सम का कफ़्फ़ारा है।"
(जामे तिर्मिज़ी 1524)

सबक़: गुनाह की नज़रों को पूरा नहीं किया जाए, कफ़्फ़ारा दिया जाए।

६. उक़्बा बिन आमिर रज़ियल्लाहु अन्हु से रिवायत है:
नबी करीम ﷺ ने फ़रमाया: "नज़र का कफ़्फ़ारा क़सम का कफ़्फ़ारा है।"
(सहीह मुस्लिम 1645)

सबक़: नज़र तोड़ने का कफ़्फ़ारा क़सम तोड़ने जैसा है।

हदीसों से अहम नुक़ात:
• अल्लाह की फ़रमांबरदारी की नज़रें पूरी करें
• नाफ़रमानी की नज़रें पूरी न करें
• तोड़ी गई नज़रों का कफ़्फ़ारा दें
• ग़ैर-ज़रूरी नज़र न मानें
• अल्लाह की तक़दीर पर भरोसा करें, नज़र पर नहीं
• ग़ैर-जायज़ नज़रें आपको पाबंद नहीं करतीं

नज़र तोड़ने का कफ़्फ़ारा:
क़सम तोड़ने जैसा:
१. 10 ग़रीबों को खाना खिलाएं, या
२. 10 ग़रीबों को कपड़े दें, या
३. ग़ुलाम आज़ाद करें (आज कल लागू नहीं), या
४. लगातार 3 दिन रोज़े रखें (अगर 1-3 नहीं कर सकते)''',
        'arabic': '''أحاديث صحيحة عن النذر

١. قال النبي ﷺ:
"من نذر أن يطيع الله فليطعه، ومن نذر أن يعصيه فلا يعصه"
(صحيح البخاري 6696)

الدرس: أوفِ بنذور الطاعة فقط، وليس المعصية.

٢. قال النبي ﷺ:
"لا تنذروا، فإن النذر لا يرد من القدر شيئاً، وإنما يستخرج به من البخيل"
(صحيح مسلم 1639)

الدرس: النذر لا يغير القدر، تجنب النذر غير الضروري.

٣. عن عبد الله بن عباس رضي الله عنهما:
قال النبي ﷺ: "من نذر نذراً لم يسمه فكفارته كفارة يمين، ومن نذر نذراً في معصية فكفارته كفارة يمين، ومن نذر نذراً لا يطيقه فكفارته كفارة يمين، ومن نذر نذراً أطاقه فليف به"
(سنن أبي داود 3320)

الدرس: أنواع مختلفة من النذور لها أحكام مختلفة.

٤. عن عمران بن حصين رضي الله عنه:
قال النبي ﷺ: "لا وفاء لنذر فيما لا يملك ابن آدم، ولا في معصية، ولا في قطيعة رحم"
(سنن أبي داود 3293)

الدرس: النذور غير الصحي��ة لا حاجة للوفاء بها.

٥. عن عائشة رضي الله عنها:
قال النبي ﷺ: "لا نذر في معصية الله، وكفارته كفارة يمين"
(جامع الترمذي 1524)

الدرس: نذور المعصية تتطلب كفارة، لا وفاء.

٦. عن عقبة بن عامر رضي الله عنه:
قال النبي ﷺ: "كفارة النذر كفارة اليمين"
(صحيح مسلم 1645)

الدرس: نقض النذر له نفس كفارة نقض اليمين.

النقاط المهمة من الأحاديث:
• أوفِ بنذور الطاعة لله
• لا تفِ بنذور المعصية
• النذور المنقوضة تتطلب كفارة
• تجنب النذر غير الضروري
• توكل على قدر الله، لا على النذور
• النذور غير الصحيحة لا تلزمك

كفارة نقض النذر:
نفس كفارة نقض اليمين:
١. إطعام 10 مساكين، أو
٢. كسوة 10 مساكين، أو
٣. عتق رقبة (غير متاح اليوم)، أو
٤. صيام 3 أيام متتابعة (إذا لم تستطع 1-3)''',
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
          context.tr('nazar_karika'),
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.responsive.paddingRegular,
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
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(nazar['titleKey'] ?? 'nazar_karika');
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
        onTap: () => _showNazarDetails(nazar),
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
                    '${index + 1}',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                      ),
                      textDirection: (langCode == 'ur' || langCode == 'ar') ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    responsive.vSpaceXSmall,
                    // Icon chip
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            nazar['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('nazar_karika'),
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

  void _showNazarDetails(Map<String, dynamic> nazar) {
    final details = nazar['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: nazar['title'] ?? '',
          titleUrdu: nazar['titleUrdu'] ?? '',
          titleHindi: nazar['titleHindi'] ?? '',
          titleArabic: nazar['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: nazar['color'] as Color,
          icon: nazar['icon'] as IconData,
          categoryKey: 'category_nazar',
        ),
      ),
    );
  }

}
