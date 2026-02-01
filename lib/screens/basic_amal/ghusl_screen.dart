import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class GhuslScreen extends StatefulWidget {
  const GhuslScreen({super.key});

  @override
  State<GhuslScreen> createState() => _GhuslScreenState();
}

class _GhuslScreenState extends State<GhuslScreen> {
  final List<Map<String, dynamic>> _ghuslTypes = [
    {
      'number': 1,
      'titleKey': 'ghusl_1_when_is_ghusl_obligatory',
      'title': 'When is Ghusl Obligatory?',
      'titleUrdu': 'غسل کب فرض ہوتا ہے؟',
      'titleHindi': 'ग़ुस्ल कब फ़र्ज़ होता है?',
      'titleArabic': 'متى يجب الغسل؟',
      'icon': Icons.help_outline,
      'color': Colors.blue,
      'details': {
        'english': '''When is Ghusl Obligatory (Fard)?

Ghusl becomes obligatory in the following situations:

1. After Janaba (Major Impurity):
   • After sexual intercourse (even without ejaculation)
   • After ejaculation (during sleep or while awake)
   • After wet dreams (Ihtilam)

2. After Menstruation (Hayd):
   • Women must perform Ghusl after their monthly period ends
   • Prayer and fasting are not valid without Ghusl after menstruation

3. After Post-Natal Bleeding (Nifas):
   • After childbirth, once the bleeding stops
   • Maximum period is 40 days

4. Upon Accepting Islam:
   • A new Muslim should perform Ghusl upon conversion
   • This is considered Sunnah or obligatory by different scholars

5. Death:
   • The deceased must be given Ghusl before burial
   • This is a communal obligation (Fard Kifaya)

Note: If any of these conditions apply, Ghusl is mandatory before prayer, touching the Quran, or performing Tawaf.''',
        'urdu': '''غسل کب فرض ہوتا ہے؟

غسل ان حالات میں فرض ہو جاتا ہے:

۱۔ جنابت کے بعد:
   • جماع کے بعد (بغیر انزال کے بھی)
   • انزال کے بعد (نیند میں یا جاگتے ہوئے)
   • احتلام کے بعد

۲۔ حیض کے بعد:
   • خواتین کو ماہواری ختم ہونے کے بعد غسل کرنا ضروری ہے
   • حیض کے بعد غسل کے بغیر نماز اور روزہ درست نہیں

۳۔ نفاس کے بعد:
   • ولادت کے بعد، جب خون بند ہو جائے
   • زیادہ سے زیادہ مدت 40 دن ہے

۴۔ اسلام قبول کرنے پر:
   • نو مسلم کو قبول اسلام پر غسل کرنا چاہیے
   • مختلف علماء کے نزدیک یہ سنت یا واجب ہے

۵۔ وفات پر:
   • میت کو دفن سے پہلے غسل دینا ضروری ہے
   • یہ فرض کفایہ ہے

نوٹ: اگر ان میں سے کوئی حالت لاگو ہو تو نماز، قرآن چھونے، یا طواف سے پہلے غسل فرض ہے۔''',
        'hindi': '''ग़ुस्ल कब फ़र्ज़ होता है?

ग़ुस्ल इन हालात में फ़र्ज़ हो जाता है:

१. जनाबत के बाद:
   • जिमाअ के बाद (बग़ैर इंज़ाल के भी)
   • इंज़ाल के बाद (नींद में या जागते हुए)
   • एहतेलाम के बाद

२. हैज़ के बाद:
   • ख़वातीन को माहवारी ख़त्म होने के बाद ग़ुस्ल करना ज़रूरी है
   • हैज़ के बाद ग़ुस्ल के बग़ैर नमाज़ और रोज़ा दुरुस्त नहीं

३. निफ़ास के बाद:
   • विलादत के बाद, जब ख़ून बंद हो जाए
   • ज़्यादा से ज़्यादा मुद्दत 40 दिन है

४. इस्लाम क़बूल करने पर:
   • नव मुस्लिम को क़बूल-ए-इस्लाम पर ग़ुस्ल करना चाहिए
   • मुख़्तलिफ़ उलमा के नज़दीक यह सुन्नत या वाजिब है

५. वफ़ात पर:
   • मय्यित को दफ़न से पहले ग़ुस्ल देना ज़रूरी है
   • यह फ़र्ज़-ए-किफ़ाया है

नोट: अगर इनमें से कोई हालत लागू हो तो नमाज़, क़ुरआन छूने, या तवाफ़ से पहले ग़ुस्ल फ़र्ज़ है।''',
        'arabic': '''متى يجب الغسل (الفرض)؟

يجب الغسل في الحالات التالية:

١. بعد الجنابة (النجاسة الكبرى):
   • بعد الجماع (حتى بدون إنزال)
   • بعد الإنزال (أثناء النوم أو في اليقظة)
   • بعد الاحتلام

٢. بعد الحيض:
   • يجب على النساء الاغتسال بعد انتهاء الدورة الشهرية
   • الصلاة والصوم غير صحيحين بدون الغسل بعد الحيض

٣. بعد النفاس (دم ما بعد الولادة):
   • بعد الولادة، عندما يتوقف النزيف
   • المدة القصوى 40 يومًا

٤. عند الدخول في الإسلام:
   • ينبغي للمسلم الجديد أن يغتسل عند إسلامه
   • يعتبر هذا سنة أو واجبًا عند مختلف العلماء

٥. الموت:
   • يجب تغسيل الميت قبل الدفن
   • هذا فرض كفاية

ملاحظة: إذا انطبق أي من هذه الشروط، يكون الغسل واجبًا قبل الصلاة، أو لمس القرآن، أو أداء الطواف.''',
      },
    },
    {
      'number': 2,
      'titleKey': 'ghusl_2_recommended_ghusl',
      'title': 'Recommended Ghusl',
      'titleUrdu': 'مستحب غسل',
      'titleHindi': 'मुस्तहब ग़ुस्ल',
      'titleArabic': 'الغسل المستحب',
      'icon': Icons.star,
      'color': Colors.amber,
      'details': {
        'english': '''Recommended (Mustahab/Sunnah) Ghusl

Ghusl is recommended (not obligatory) in these situations:

1. Friday (Jumu'ah) Ghusl:
   • Highly recommended before Friday prayer
   • The Prophet ﷺ said: "Ghusl on Friday is obligatory for every adult." (Most scholars interpret this as highly recommended)

2. Eid Prayers:
   • Before Eid ul-Fitr prayer
   • Before Eid ul-Adha prayer

3. Before Ihram:
   • Before entering the state of Ihram for Hajj or Umrah
   • Even for women in menstruation

4. Entering Makkah:
   • When entering the sacred city

5. Standing at Arafat:
   • On the day of Arafah during Hajj

6. After Washing a Deceased:
   • Recommended for the one who gave Ghusl to the deceased

7. After Recovering from Unconsciousness:
   • When one regains consciousness

8. Before Special Prayers:
   • Istisqa (rain prayer)
   • Eclipse prayer
   • Night of Power (Laylatul Qadr)

These are recommended acts that bring additional reward but are not obligatory.''',
        'urdu': '''مستحب/سنت غسل

غسل ان حالات میں مستحب ہے (فرض نہیں):

۱۔ جمعہ کا غسل:
   • جمعہ کی نماز سے پہلے انتہائی مستحب ہے
   • نبی کریم ﷺ نے فرمایا: "جمعہ کے دن غسل ہر بالغ پر واجب ہے۔" (اکثر علماء اسے مستحب مؤکد سمجھتے ہیں)

۲۔ عید کی نمازیں:
   • عید الفطر کی نماز سے پہلے
   • عید الاضحیٰ کی نماز سے پہلے

۳۔ احرام سے پہلے:
   • حج یا عمرے کے لیے احرام باندھنے سے پہلے
   • حائضہ خواتین کے لیے بھی

۴۔ مکہ میں داخل ہوتے وقت:
   • شہر مقدس میں داخل ہوتے وقت

۵۔ عرفات میں ٹھہرنا:
   • حج کے دوران یوم عرفہ پر

۶۔ میت کو غسل دینے کے بعد:
   • جس نے میت کو غسل دیا اس کے لیے مستحب ہے

۷۔ بے ہوشی سے ہوش آنے کے بعد:
   • جب ہوش بحال ہو

۸۔ خاص نمازوں سے پہلے:
   • استسقاء (بارش کی نماز)
   • کسوف کی نماز
   • لیلۃ القدر

یہ مستحب اعمال ہیں جو اضافی ثواب لاتے ہیں لیکن فرض نہیں۔''',
        'hindi': '''मुस्तहब/सुन्नत ग़ुस्ल

ग़ुस्ल इन हालात में मुस्तहब है (फ़र्ज़ नहीं):

१. जुमा का ग़ुस्ल:
   • जुमा की नमाज़ से पहले बेहद मुस्तहब है
   • नबी करीम ﷺ ने फ़रमाया: "जुमा के दिन ग़ुस्ल हर बालिग़ पर वाजिब है।" (अक्सर उलमा इसे मुस्तहब मुअक्कद समझते हैं)

२. ईद की नमाज़ें:
   • ईद उल-फ़ित्र की नमाज़ से पहले
   • ईद उल-अज़्हा की नमाज़ से पहले

३. इहराम से पहले:
   • हज या उमरे के लिए इहराम बांधने से पहले
   • हाइज़ा ख़वातीन के लिए भी

४. मक्का में दाख़िल होते वक़्त:
   • शहर-ए-मुक़द्दस में दाख़िल होते वक़्त

५. अरफ़ात में ठहरना:
   • हज के दौरान यौम-ए-अरफ़ा पर

६. मय्यित को ग़ुस्ल देने के बाद:
   • जिसने मय्यित को ग़ुस्ल दिया उसके लिए मुस्तहब है

७. बेहोशी से होश आने के बाद:
   • जब होश बहाल हो

८. ख़ास नमाज़ों से पहले:
   • इस्तिस्क़ा (बारिश की नमाज़)
   • कुसूफ़ की नमाज़
   • लैलतुल क़द्र

ये मुस्तहब आमाल हैं जो इज़ाफ़ी सवाब लाते हैं लेकिन फ़र्ज़ नहीं।''',
        'arabic': '''الغسل المستحب/السنة

الغسل مستحب (وليس واجبًا) في هذه الحالات:

١. غسل الجمعة:
   • مستحب جدًا قبل صلاة الجمعة
   • قال النبي ﷺ: "غُسل الجمعة واجب على كل محتلم." (يرى معظم العلماء أنه مستحب مؤكد)

٢. صلاة العيدين:
   • قبل صلاة عيد الفطر
   • قبل صلاة عيد الأضحى

٣. قبل الإحرام:
   • قبل الإحرام للحج أو العمرة
   • حتى للنساء الحائض

٤. عند دخول مكة:
   • يستحب الغسل عند دخول مكة المكرمة

٥. يوم عرفة:
   • في التاسع من ذي الحجة

٦. عند الوقوف بعرفة:
   • للحجاج

٧. بعد الإفاقة من الإغماء:
   • عند استعادة الوعي

٨. قبل صلوات خاصة:
   • الاستسقاء (صلاة طلب المطر)
   • صلاة الكسوف
   • ليلة القدر

هذه أعمال مستحبة تجلب ثوابًا إضافيًا ولكنها ليست فرضًا.''',
      },
    },
    {
      'number': 3,
      'titleKey': 'ghusl_3_fard_acts_of_ghusl',
      'title': 'Fard Acts of Ghusl',
      'titleUrdu': 'غسل کے فرائض',
      'titleHindi': 'ग़ुस्ल के फ़राइज़',
      'titleArabic': 'فرائض الغسل',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'details': {
        'english': '''Obligatory (Fard) Acts of Ghusl

The Ghusl is valid only if these three obligatory acts are performed:

1. Rinsing the Mouth (Madmadah):
   • Water must reach all parts of the mouth
   • Gargle if not fasting
   • This is Fard according to Hanafi school

2. Cleaning the Nose (Istinshaq):
   • Water must reach inside the nostrils
   • Sniff water in and blow it out
   • This is Fard according to Hanafi school

3. Washing the Entire Body:
   • Every part of the body must be washed
   • Water must reach the scalp (hair roots)
   • Water must reach all folds of the body
   • Navel must be cleaned
   • Between toes and fingers

Important Points:
• If any area equal to a hair's breadth remains dry, the Ghusl is invalid
• Remove anything that prevents water from reaching the skin (nail polish, dried paint, etc.)
• Hair must be wet to the roots
• Men must wash under the beard
• Women don't need to undo braids if water reaches the roots

Note: According to Shafi'i and Hanbali schools, intention (Niyyah) is also Fard.''',
        'urdu': '''غسل کے فرائض

غسل صرف تبھی درست ہوتا ہے جب یہ تین فرض ادا کیے جائیں:

۱۔ کلی کرنا (مضمضہ):
   • پانی منہ کے تمام حصوں تک پہنچنا چاہیے
   • اگر روزے سے نہیں تو غرغرہ کریں
   • حنفی مسلک کے مطابق یہ فرض ہے

۲۔ ناک صاف کرنا (استنشاق):
   • پانی نتھنوں کے اندر پہنچنا چاہیے
   • پانی اندر کھینچیں اور باہر نکالیں
   • حنفی مسلک کے مطابق یہ فرض ہے

۳۔ پورا جسم دھونا:
   • جسم کا ہر حصہ دھلنا چاہیے
   • پانی سر کی جڑوں (بالوں کی جڑوں) تک پہنچنا چاہیے
   • پانی جسم کی تمام تہوں تک پہنچنا چاہیے
   • ناف صاف ہونی چاہیے
   • پاؤں اور ہاتھوں کی انگلیوں کے درمیان

اہم نکات:
• اگر بال برابر جگہ بھی خشک رہ جائے تو غسل ناقص ہے
• ہر وہ چیز ہٹا دیں جو پانی کو جلد تک پہنچنے سے روکے (نیل پالش، خشک پینٹ، وغیرہ)
• بال جڑوں تک گیلے ہونے چاہیے
• مردوں کو داڑھی کے نیچے دھونا ضروری ہے
• خواتین کو چوٹیاں کھولنے کی ضرورت نہیں اگر پانی جڑوں تک پہنچ جائے

نوٹ: شافعی اور حنبلی مسلک کے مطابق نیت بھی فرض ہے۔''',
        'hindi': '''ग़ुस्ल के फ़राइज़

ग़ुस्ल सिर्फ़ तभी दुरुस्त होता है जब ये तीन फ़र्ज़ अदा किए जाएं:

१. कुल्ली करना (मज़मज़ा):
   • पानी मुंह के तमाम हिस्सों तक पहुंचना चाहिए
   • अगर रोज़े से नहीं तो ग़रग़रा करें
   • हनफ़ी मसलक के मुताबिक़ यह फ़र्ज़ है

२. नाक साफ़ करना (इस्तिनशाक़):
   • प��नी नथनों के अंदर पहुंचना चाहिए
   • पानी अंदर खींचें और बाहर निकालें
   • हनफ़ी मसलक के मुताबिक़ यह फ़र्ज़ है

३. पूरा जिस्म धोना:
   • जिस्म का हर हिस्सा धुलना चाहिए
   • पानी सर की जड़ों (बालों की जड़ों) तक पहुंचना चाहिए
   • पानी जिस्म की तमाम तहों तक पहुंचना चाहिए
   • नाफ़ साफ़ होनी चाहिए
   • पांव और हाथों की उंगलियों के दरमियान

महत्वपूर्ण बातें:
• अगर बाल बराबर जगह भी ख़ुश्क रह जाए तो ग़ुस्ल नाक़िस है
• हर वो चीज़ हटा दें जो पानी को जिल्द तक पहुंचने से रोके (नेल पॉलिश, ख़ुश्क पेंट, वग़ैरह)
• बाल जड़ों तक गीले होने चाहिए
• मर्दों को दाढ़ी के नीचे धोना ज़रूरी है
• ख़वातीन को चोटियां खोलने की ज़रूरत नहीं अगर पानी जड़ों तक पहुंच जाए

नोट: शाफ़ई और हंबली मसलक के मुताबिक़ नीयत भी फ़र्ज़ है।''',
        'arabic': '''فرائض الغسل

الغسل صحيح فقط عندما تُؤدى هذه الفرائض الثلاثة:

١. المضمضة (غسل الفم):
   • يجب أن يصل الماء إلى جميع أجزاء الفم
   • تغرغر إذا لم تكن صائمًا
   • هذا فرض وفقًا للمذهب الحنفي

٢. الاستنشاق (تنظيف الأنف):
   • يجب أن يصل الماء داخل فتحتي الأنف
   • استنشق الماء إلى داخل الأنف ثم أخرجه
   • هذا فرض وفقًا للمذهب الحنفي

٣. غسل الجسم كله:
   • كل جزء من الجسم يجب أن يُبلل بالماء
   • من أعلى الرأس إلى أسفل القدمين
   • لا يجوز ترك أي جزء جافًا

الأماكن التي يجب الانتباه لها:
   • خلف الأذنين وفي الأذنين
   • تحت الذقن والرقبة
   • تحت الإبطين
   • السرة يجب تنظيفها
   • بين أصابع القدمين واليدين

نقاط مهمة:
• إذا بقي أي مكان بمقدار شعرة جافًا، فالغسل غير صحيح
• أزل أي شيء يمنع وصول الماء إلى الجلد (طلاء الأظافر، الطلاء الجاف، إلخ)
• يجب أن يبتل الشعر حتى الجذور
• يجب على الرجال غسل تحت اللحية
• النساء لا يحتجن إلى فك الضفائر إذا وصل الماء إلى الجذور

ملاحظة: وفقًا للمذهبين الشافعي والحنبلي، النية أيضًا فرض.''',
      },
    },
    {
      'number': 4,
      'titleKey': 'ghusl_4_complete_method_of_ghusl',
      'title': 'Complete Method of Ghusl',
      'titleUrdu': 'غسل کا مکمل طریقہ',
      'titleHindi': 'ग़ुस्ल का मुकम्मल तरीक़ा',
      'titleArabic': 'الطريقة الكاملة للغسل',
      'icon': Icons.format_list_numbered,
      'color': Colors.purple,
      'details': {
        'english': '''Complete Sunnah Method of Ghusl

Step 1: Make Intention (Niyyah)
• Intend in your heart to purify yourself from major impurity
• Say "Bismillah" (In the name of Allah)

Step 2: Wash Both Hands (3 times)
• Wash hands up to the wrists three times
• Clean between fingers

Step 3: Wash Private Parts
• Clean the private parts thoroughly
• Remove any impurity (Najasah)

Step 4: Perform Complete Wudu
• Perform full Wudu as you would for prayer
• Some scholars say to delay washing feet until the end

Step 5: Pour Water Over the Head (3 times)
• Ensure water reaches the scalp
• Rub the hair with fingers
• Water must reach the roots of the hair

Step 6: Pour Water Over Right Side of Body (3 times)
• Start with the right shoulder
• Wash the right side completely
• Rub the body to ensure water reaches everywhere

Step 7: Pour Water Over Left Side of Body (3 times)
• Then wash the left shoulder
• Wash the left side completely
• Rub the body thoroughly

Step 8: Pour Water Over Entire Body
• Ensure no part remains dry
• Pay attention to:
  - Under the arms
  - Behind the ears
  - Inside the navel
  - Between toes
  - All body folds

Step 9: Move to a Clean Place and Wash Feet
• If you delayed feet in Wudu, wash them now
• Wash between the toes

Step 10: Recite Dua After Ghusl
• Same dua as after Wudu:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"''',
        'urdu': '''غسل کا مکمل سنت طریقہ

پہلا قدم: نیت کریں
• دل میں نیت کریں کہ آپ بڑی ناپاکی سے پاک ہو رہے ہیں
• "بسم اللہ" کہیں

دوسرا قدم: دونوں ہاتھ دھوئیں (3 بار)
• کلائیوں تک ہاتھ تین بار دھوئیں
• انگلیوں کے درمیان صاف کریں

تیسرا قدم: شرمگاہ دھوئیں
• شرمگاہ کو اچھی طرح صاف کریں
• کوئی بھی نجاست دور کریں

چوتھا قدم: مکمل وضو کریں
• نماز والا مکمل وضو کریں
• بعض علماء کہتے ہیں پاؤں آخر میں دھوئیں

پانچواں قدم: سر پر پانی ڈالیں (3 بار)
• یقینی بنائیں کہ پانی سر کی جلد تک پہنچے
• انگلیوں سے بال ملیں
• پانی بالوں کی جڑوں تک پہنچنا چاہیے

چھٹا قدم: جسم کے دائیں حصے پر پانی ڈالیں (3 بار)
• دائیں کندھے سے شروع کریں
• دایاں حصہ مکمل دھوئیں
• جسم کو ملیں تاکہ پانی ہر جگہ پہنچے

ساتواں قدم: جسم کے بائیں حصے پر پانی ڈالیں (3 بار)
• پھر بایاں کندھا دھوئیں
• بایاں حصہ مکمل دھوئیں
• جسم کو اچھی طرح ملیں

آٹھواں قدم: پورے جسم پر پانی ڈالیں
• یقینی بنائیں کوئی حصہ خشک نہ رہے
• خاص توجہ دیں:
  - بغلوں کے نیچے
  - کانوں کے پیچھے
  - ناف کے اندر
  - پاؤں کی انگلیوں کے درمیان
  - جسم کی تمام تہیں

نواں قدم: صاف جگہ جائیں اور پاؤں دھوئیں
• اگر وضو میں پاؤں چھوڑے تھے تو اب دھوئیں
• انگلیوں کے درمیان دھوئیں

دسواں قدم: غسل کے بعد دعا پڑھیں
• وضو والی دعا:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"''',
        'hindi': '''ग़ुस्ल का मुकम्मल सुन्नत तरीक़ा

पहला क़दम: नीयत करें
• दिल में नीयत करें कि आप बड़ी नापाकी से पाक हो रहे हैं
• "बिस्मिल्लाह" कहें

दूसरा क़दम: दोनों हाथ धोएं (3 बार)
• कलाइयों तक हाथ तीन बार धोएं
• उंगलियों के दरमियान साफ़ करें

तीसरा क़दम: शर्मगाह धोएं
• शर्मगाह को अच्छी तरह साफ़ करें
• कोई भी नजासत दूर करें

चौथा क़दम: मुकम्मल वुज़ू करें
• नमाज़ वाला मुकम्मल वुज़ू करें
• बाज़ उलमा कहते हैं पांव आख़िर में धोएं

पांचवां क़दम: सर पर पानी डालें (3 बार)
• यक़ीनी बनाएं कि पानी सर की जिल्द तक पहुंचे
• उंगलियों से बाल मलें
• पानी बालों की जड़ों तक पहुंचना चाहिए

छठा क़दम: जिस्म के दाएं हिस्से पर पानी डालें (3 बार)
• दाएं कंधे से शुरू करें
• दायां हिस्सा मुकम्मल धोएं
• जिस्म को मलें ताकि पानी हर जगह पहुंचे

सातवां क़दम: जिस्म के बाएं हिस्से पर पानी डालें (3 बार)
• फिर बायां कंधा धोएं
• बायां हिस्सा मुकम्मल धोएं
• जिस्म को अच्छी तरह मलें

आठवां क़दम: पूरे जिस्म पर पानी डालें
• यक़ीनी बनाएं कोई हिस्सा ख़ुश्क न रहे
• ख़ास तवज्जो दें:
  - बग़लों के नीचे
  - कानों के पीछे
  - नाफ़ के अंदर
  - पांव की उंगलियों के दरमियान
  - जिस्म की तमाम तहें

नौवां क़दम: साफ़ जगह जाएं और पांव धोएं
• अगर वुज़ू में पांव छोड़े थे तो अब धोएं
• उंगलियों के दरमियान धोएं

दसवां क़दम: ग़ुस्ल के बाद दुआ पढ़ें
• वुज़ू वाली दुआ:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"''',
        'arabic': '''الطريقة الكاملة للغسل وفق السنة

الخطوة الأولى: النية
• انو في قلبك أن تتطهر من النجاسة الكبرى
• قل "بسم الله"

الخطوة الثانية: اغسل اليدين (3 مرات)
• اغسل اليدين حتى المعصمين ثلاث مرات

الخطوة الثالثة: اغسل الأعضاء التناسلية
• اغسل وطهر المكان النجس
• استخدم اليد اليسرى لهذا
• تأكد من النظافة الكاملة

الخطوة الرابعة: توضأ للصلاة
• توضأ وضوءًا كاملاً
• يمكنك ترك غسل القدمين للنهاية
• أو اغسلهما الآن

الخطوة الخامسة: صب الماء على الرأس (3 مرات)
• تأكد أن الماء يصل إلى فروة الرأس
• دلك الشعر بالأصابع
• يجب أن يصل الماء إلى جذور الشعر

الخطوة السادسة: صب الماء على الجانب الأيمن من الجسم (3 مرات)
• ابدأ من الكتف الأيمن
• اغسل الجانب الأيمن بالكامل
• دلك الجسم لضمان وصول الماء في كل مكان

الخطوة السابعة: صب الماء على الجانب الأيسر من الجسم (3 مرات)
• ثم اغسل الكتف الأيسر
• اغسل الجانب الأيسر بالكامل
• دلك الجسم جيدًا

الخطوة الثامنة: صب الماء على الجسم كله
• تأكد من عدم بقاء أي جزء جافًا
• انتبه بشكل خاص إلى:
  - تحت الإبطين
  - خلف الأذنين
  - داخل السرة
  - بين أصابع القدمين
  - جميع طيات الجسم

الخطوة التاسعة: انتقل إلى مكان نظيف واغسل القدمين
• إذا تركت القدمين في الوضوء فاغسلهما الآن
• اغسل بين الأصابع

الخطوة العاشرة: اقرأ الدعاء بعد الغسل
• دعاء الوضوء:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"''',
      },
    },
    {
      'number': 5,
      'titleKey': 'ghusl_5_ghusl_for_women',
      'title': 'Ghusl for Women',
      'titleUrdu': 'خواتین کا غسل',
      'titleHindi': 'ख़वातीन का ग़ुस्ल',
      'titleArabic': 'غسل النساء',
      'icon': Icons.female,
      'color': Colors.pink,
      'details': {
        'english': '''Ghusl for Women - Special Guidelines

The method of Ghusl for women is the same as for men, with a few additional considerations:

Regarding Hair:
• Women do NOT need to undo their braids if water reaches the roots
• The Prophet ﷺ told Umm Salamah (RA): "It is enough for you to pour three handfuls of water over your head, then pour water over yourself, and you will be purified." (Sahih Muslim)
• However, after menstruation, some scholars recommend undoing braids

After Menstruation (Hayd):
• Ghusl is obligatory when menstruation ends
• Use a piece of cloth with musk or perfume to clean the area of bleeding (Sunnah)
• If musk is not available, any clean scent or just water is sufficient

After Post-Natal Bleeding (Nifas):
• Same as after menstruation
• Can resume prayer and fasting after Ghusl
• Maximum period of Nifas is 40 days

After Sexual Intercourse:
• Both husband and wife must perform Ghusl
• Can perform Ghusl together if privacy allows

Special Notes:
• Jewelry that is tight and prevents water from reaching skin should be removed
• Nail polish must be removed as it creates a barrier
• False eyelashes that prevent water from reaching eyelid skin should be removed
• Makeup that forms a layer should be removed

If Unable to Use Water:
• During illness or lack of water, Tayammum can be performed instead''',
        'urdu': '''خواتین کا غسل - خصوصی رہنمائی

خواتین کے غسل کا طریقہ مردوں جیسا ہی ہے، کچھ اضافی باتوں کے ساتھ:

بالوں کے بارے میں:
• خواتین کو چوٹیاں کھولنے کی ضرورت نہیں اگر پانی جڑوں تک پہنچ جائے
• نبی کریم ﷺ نے ام سلمہ رضی اللہ عنہا سے فرمایا: "تمہارے لیے کافی ہے کہ اپنے سر پر تین چلو پانی ڈالو، پھر اپنے اوپر پانی بہاؤ، اور تم پاک ہو جاؤ گی۔" (صحیح مسلم)
• تاہم، حیض کے بعد بعض علماء چوٹیاں کھولنے کی تجویز دیتے ہیں

حیض کے بعد:
• حیض ختم ہونے پر غسل فرض ہے
• خون کی جگہ صاف کرنے کے لیے مشک یا خوشبو والا کپڑا استعمال کریں (سنت)
• اگر مشک نہ ہو تو کوئی صاف خوشبو یا صرف پانی کافی ہے

نفاس کے بعد:
• حیض جیسا ہی طریقہ
• غسل کے بعد نماز اور روزہ شروع کر سکتی ہیں
• نفاس کی زیادہ سے زیادہ مدت 40 دن ہے

ہم بستری کے بعد:
• میاں بیوی دونوں کو غسل کرنا ضروری ہے
• اگر پردے کا انتظام ہو تو ایک ساتھ غسل کر سکتے ہیں

خصوصی نکات:
• تنگ زیورات جو پانی کو جلد تک پہنچنے سے روکیں، اتار دینے چاہئیں
• نیل پالش اتارنی ضروری ہے کیونکہ یہ رکاوٹ بنتی ہے
• مصنوعی پلکیں جو پلکوں کی جلد تک پانی پہنچنے سے روکیں، اتاریں
• میک اپ جو تہہ بناتا ہو، اتارنا چاہیے

اگر پانی استعمال نہ کر سکیں:
• بیماری یا پانی نہ ہونے کی صورت میں تیمم کر سکتی ہیں''',
        'hindi': '''ख़वातीन का ग़ुस्ल - ख़ुसूसी रहनुमाई

ख़वातीन के ग़ुस्ल का तरीक़ा मर्दों जैसा ही है, कुछ इज़ाफ़ी बातों के साथ:

बालों के बारे में:
• ख़वातीन को चोटियां खोलने की ज़रूरत नहीं अगर पानी जड़ों तक पहुंच जाए
• नबी करीम ﷺ ने उम्म सलमा रज़ि. से फ़रमाया: "तुम्हारे लिए काफ़ी है कि अपने सर पर तीन चुल्लू पानी डालो, फिर अपने ऊपर पानी बहाओ, और तुम पाक हो जाओगी।" (सहीह मुस्लिम)
• ताहम, हैज़ के बाद बाज़ उलमा चोटियां खोलने की तज्वीज़ देते हैं

हैज़ के बाद:
• हैज़ ख़त्म होने पर ग़ुस्ल फ़र्ज़ है
• ख़ून की जगह साफ़ करने के लिए मुश्क या ख़ुश्बू वाला कपड़ा इस्तेमाल करें (सुन्नत)
• अगर मुश्क न हो तो कोई साफ़ ख़ुश्बू या सिर्फ़ पानी काफ़ी है

निफ़ास के बाद:
• हैज़ जैसा ही तरीक़ा
• ग़ुस्ल के बाद नमाज़ और रोज़ा शुरू कर सकती हैं
• निफ़ास की ज़्यादा से ज़्यादा मुद्दत 40 दिन है

हम-बिस्तरी के बाद:
• मियां-बीवी दोनों को ग़ुस्ल करना ज़रूरी है
• अगर पर्दे का इंतेज़ाम हो तो एक साथ ग़ुस्ल कर सकते हैं

ख़ुसूसी बातें:
• तंग ज़ेवरात जो पानी को जिल्द तक पहुंचने से रोकें, उतार देने चाहिए
• नेल पॉलिश उतारना ज़रूरी है क्योंकि यह रुकावट बनती है
• मस्नूई पलकें जो पलकों की जिल्द तक पानी पहुंचने से रोकें, उतारें
• मेकअप जो तह बनाता हो, उतारना चाहिए

अगर पानी इस्तेमाल न कर सकें:
• बीमारी या पानी न होने की सूरत में तयम्मुम कर सकती हैं''',
        'arabic': '''غسل النساء - إرشادات خاصة

طريقة الغسل للنساء هي نفسها كما للرجال، مع بعض الاعتبارات الإضافية:

بخصوص الشعر:
• النساء لا يحتجن إلى فك ضفائرهن إذا وصل الماء إلى الجذور
• قال النبي ﷺ لأم سلمة رضي الله عنها: "يكفيك أن تحثي على رأسك ثلاث حثيات، ثم تفيضين عليك الماء فتطهرين." (صحيح مسلم)
• ومع ذلك، بعد الحيض، يوصي بعض العلماء بفك الضفائر

بعد الحيض:
• الغسل واجب عند انتهاء الحيض
• استخدم مسكًا أو قطعة قماش معطرة لتطهير مكان الدم (سنة)
• إذا لم يتوفر المسك، فأي عطر نظيف أو الماء فقط يكفي

بعد النفاس:
• نفس الطريقة كما في الحيض
• يمكن بدء الصلاة والصيام بعد الغسل
• المدة القصوى للنفاس 40 يومًا

بعد الجماع:
• يجب على كل من الزوج والزوجة الاغتسال
• يمكنهما الاغتسال معًا إذا كان هناك حجاب مناسب

نقاط خاصة:
• يجب إزالة المجوهرات الضيقة التي تمنع الماء من الوصول إلى الجلد
• يجب إزالة طلاء الأظافر لأنه يشكل حاجزًا
• يجب إزالة الرموش الصناعية التي تمنع الماء من الوصول إلى جلد الجفن
• تأكد من وصول الماء تحت الأساور والخواتم

إذا لم تتمكن من استخدام الماء:
• في حالة المرض أو نقص الماء، يمكن أداء التيمم بدلاً من ذلك''',
      },
    },
    {
      'number': 6,
      'titleKey': 'ghusl_6_tayammum_dry_ablution',
      'title': 'Tayammum (Dry Ablution)',
      'titleUrdu': 'تیمم',
      'titleHindi': 'तयम्मुम',
      'titleArabic': 'التيمم (الوضوء الجاف)',
      'icon': Icons.landscape,
      'color': Colors.brown,
      'details': {
        'english': '''Tayammum (Dry Ablution)

Tayammum is the Islamic act of dry ablution using clean earth or dust, which can be performed when water is unavailable or cannot be used.

When is Tayammum Allowed?

1. No Water Available:
   • When traveling and water cannot be found
   • When there is no water source nearby

2. Unable to Use Water:
   • Due to illness where water would cause harm
   • Extreme cold where water would cause harm
   • Wound or skin condition

3. Water is Needed for More Important Purpose:
   • Drinking water for survival
   • Cooking essential food

Method of Tayammum:

Step 1: Make Intention (Niyyah)
• Intend to perform Tayammum for purification

Step 2: Say Bismillah
• "بِسْمِ اللَّهِ" (In the name of Allah)

Step 3: Strike Clean Earth with Palms
• Strike or place palms on clean earth, sand, or stone
• Blow off excess dust

Step 4: Wipe the Face
• Wipe the entire face once with both palms

Step 5: Strike Earth Again
• Strike palms on clean earth again

Step 6: Wipe the Arms
• Wipe the right arm with the left hand (up to elbow)
• Wipe the left arm with the right hand (up to elbow)
• Include between the fingers

What Tayammum Replaces:
• Both Wudu and Ghusl
• One Tayammum is valid until it is broken or water becomes available

What Breaks Tayammum:
• Same things that break Wudu
• Finding water when able to use it
• The reason for Tayammum no longer exists''',
        'urdu': '''تیمم

تیمم صاف مٹی یا دھول سے خشک طہارت ہے، جو پانی نہ ملنے یا استعمال نہ کر سکنے کی صورت میں کی جا سکتی ہے۔

تیمم کب جائز ہے؟

۱۔ پانی نہ ملے:
   • سفر میں جب پانی نہ ملے
   • جب قریب پانی کا ذریعہ نہ ہو

۲۔ پانی استعمال نہ کر سکیں:
   • بیماری کی وجہ سے جہاں پانی نقصان دہ ہو
   • شدید سردی جہاں پانی نقصان دہ ہو
   • زخم یا جلد کی بیماری

۳۔ پانی زیادہ اہم مقصد کے لیے درکار ہو:
   • زندہ رہنے کے لیے پینے کا پانی
   • ضروری کھانا پکانا

تیمم کا طریقہ:

پہلا قدم: نیت کریں
• طہارت کے لیے تیمم کی نیت کریں

دوسرا قدم: بسم اللہ کہیں
• "بِسْمِ اللَّهِ"

تیسرا قدم: ہتھیلیاں صاف مٹی پر ماریں
• صاف مٹی، ریت یا پتھر پر ہتھیلیاں ماریں یا رکھیں
• زائد دھول جھاڑ دیں

چوتھا قدم: چہرے کا مسح کریں
• دونوں ہتھیلیوں سے پورے چہرے کا ایک بار مسح کریں

پانچواں قدم: دوبارہ مٹی پر ہاتھ ماریں
• صاف مٹی پر دوبارہ ہتھیلیاں ماریں

چھٹا قدم: بازوؤں کا مسح کریں
• بائیں ہاتھ سے دائیں بازو کا مسح کریں (کہنی تک)
• دائیں ہاتھ سے بائیں بازو کا مسح کریں (کہنی تک)
• انگلیوں کے درمیان بھی شامل کریں

تیمم کس کی جگہ لیتا ہے:
• وضو اور غسل دونوں کی
• ایک تیمم تب تک درست ہے جب تک ٹوٹ نہ جائے یا پانی مل جائے

تیمم کیا توڑتا ہے:
• وہی چیزیں جو وضو توڑتی ہیں
• پانی ملنا جب استعمال کر سکیں
• تیمم کی وجہ باقی نہ رہے''',
        'hindi': '''तयम्मुम

तयम्मुम साफ़ मिट्टी या धूल से ख़ुश्क तहारत है, जो पानी न मिलने या इस्तेमाल न कर सकने की सूरत में की जा सकती है।

तयम्मुम कब जायज़ है?

१. पानी न मिले:
   • सफ़र में जब पानी न मिले
   • जब क़रीब पानी का ज़रिया न हो

२. पानी इस्तेमाल न कर सकें:
   • बीमारी की वजह से जहां पानी नुक़सानदेह हो
   • शदीद सर्दी जहां पानी नुक़सानदेह हो
   • ज़ख़्म या जिल्द की बीमारी

३. पानी ज़्यादा अहम मक़सद के लिए दरकार हो:
   • ज़िंदा रहने के लिए पीने का पानी
   • ज़रूरी खाना पकाना

तयम्मुम का तरीक़ा:

पहला क़दम: नीयत करें
• तहारत के लिए तयम्मुम की नीयत करें

दूसरा क़दम: बिस्मिल्लाह कहें
• "بِسْمِ اللَّهِ"

तीसरा क़दम: हथेलियां साफ़ मिट्टी पर मारें
• साफ़ मिट्टी, रेत या पत्थर पर हथेलियां मारें या रखें
• ज़ाइद धूल झाड़ दें

चौथा क़दम: चेहरे का मसह करें
• दोनों हथेलियों से पूरे चेहरे का एक बार मसह करें

पांचवां क़दम: दोबारा मिट्टी पर हाथ मारें
• साफ़ मिट्टी पर दोबारा हथेलियां मारें

छठा क़दम: बाज़ुओं का मसह करें
• बाएं हाथ से दाएं बाज़ू का मसह करें (कोहनी तक)
• दाएं हाथ से बाएं बाज़ू का मसह करें (कोहनी तक)
• उंगलियों के दरमियान भी शामिल करें

तयम्मुम किसकी जगह लेता है:
• वुज़ू और ग़ुस्ल दोनों की
• एक तयम्मुम तब तक दुरुस्त है जब तक टूट न जाए या पानी मिल जाए

तयम्मुम क्या तोड़ता है:
• वही चीज़ें जो वुज़ू तोड़ती हैं
• पानी मिलना जब इस्तेमाल कर सकें
• तयम्मुम की वजह बाक़ी न रहे''',
        'arabic': '''التيمم (الوضوء الجاف)

التيمم هو عمل إسلامي للوضوء الجاف باستخدام تراب نظيف أو غبار، ويمكن أداؤه عندما يكون الماء غير متوفر أو لا يمكن استخدامه.

متى يُسمح بالتيمم؟

١. عدم توفر الماء:
   • في السفر عندما لا يتوفر الماء
   • عندما لا يكون هناك مصدر ماء قريب

٢. عدم القدرة على استخدام الماء:
   • بسبب المرض حيث يكون الماء ضارًا
   • في البرد الشديد حيث يكون الماء ضارًا
   • الجروح أو الأمراض الجلدية

٣. الماء مطلوب لغرض أكثر أهمية:
   • ماء الشرب للبقاء على قيد الحياة
   • الطبخ الضروري

طريقة التيمم:

الخطوة الأولى: النية
• انو التيمم للطهارة

الخطوة الثانية: قل بسم الله
• "بِسْمِ اللَّهِ"

الخطوة الثالثة: اضرب راحتي اليدين على تراب نظيف
• اضرب أو ضع راحتي اليدين على تراب نظيف أو رمل أو حجر
• انفخ الغبار الزائد

الخطوة الرابعة: امسح الوجه
• امسح الوجه كله مرة واحدة بكلتا راحتي اليدين
• من الجبهة إلى الذقن
• من أذن إلى أذن

الخطوة الخامسة: اضرب راحتي اليدين على التراب مرة أخرى
• للمذهب الحنفي: ضربة واحدة تكفي
• للشافعي: ضربتان منفصلتان

الخطوة السادسة: امسح الذراعين
• امسح الذراع الأيمن باليد اليسرى (حتى المرفق)
• امسح الذراع الأيسر باليد اليمنى (حتى المرفق)
• شمل بين الأصابع أيضًا

التيمم يحل محل:
• كل من الوضوء والغسل
• تيمم واحد صحيح حتى يُنقض أو يتوفر الماء

ما الذي يُبطل التيمم:
• نفس الأشياء التي تُبطل الوضوء
• توفر الماء عندما يمكنك استخدامه
• انتهاء سبب التيمم''',
      },
    },
    {
      'number': 7,
      'titleKey': 'ghusl_7_common_mistakes',
      'title': 'Common Mistakes in Ghusl',
      'titleUrdu': 'غسل میں عام غلطیاں',
      'titleHindi': 'ग़ुस्ल में आम ग़लतियां',
      'titleArabic': 'الأخطاء الشائعة في الغسل',
      'icon': Icons.warning_amber,
      'color': Colors.orange,
      'details': {
        'english': '''Common Mistakes in Ghusl

Many people make mistakes during Ghusl that can invalidate it. Here are the most common ones:

1. Missing Parts of the Body:
   • Forgetting to wash under the armpits
   • Not washing the soles of the feet properly
   • Missing the back of the neck
   • Not washing between toes
   • Forgetting to wash behind the ears
   • Missing the navel area
   • Not washing under rings or watches

2. Not Removing Barriers:
   • Leaving nail polish on (prevents water from reaching nails)
   • Not removing tight jewelry that blocks water
   • Waterproof makeup or creams
   • Dried glue, paint, or dough on skin
   • Wax or gel in hair that prevents water penetration
   • Bandages when not necessary
   • Contact lenses (some scholars say they should be removed)

3. Improper Intention (Niyyah):
   • Continuing under the shower and then making intention
   • Must remove water source, make intention, then start Ghusl
   • Taking a normal shower without intention of purification
   • Making intention only at the end

4. Not Ensuring Water Reaches Everywhere:
   • Just letting water run over body without rubbing
   • Not ensuring water reaches scalp and hair roots
   • Not opening mouth and nose sufficiently
   • Hair too thick or oily, preventing water from reaching roots

5. Performing Wudu AFTER Ghusl Janabah:
   • For Ghusl Janabah specifically, Wudu is already included
   • Performing Wudu after is considered Bid'ah (innovation)
   • Note: This applies to Ghusl Janabah, not other types

6. Not Checking for Purity First:
   • Women taking Ghusl before confirming menstruation has ended
   • Not checking for white discharge or complete dryness
   • Rushing without proper verification

7. Using Impure Water:
   • Water must be pure (Tahir)
   • Used water that has already been used for removing impurity
   • Contaminated or dirty water

8. Long Interruptions:
   • Taking breaks during Ghusl
   • Must maintain continuity
   • Answering phone or doing other tasks mid-Ghusl

Important: If you realize you made any of these mistakes, repeat the Ghusl correctly to ensure your prayers are valid.''',
        'urdu': '''غسل میں عام غلطیاں

بہت سے لوگ غسل کے دوران غلطیاں کرتے ہیں جو اسے باطل کر سکتی ہیں۔ یہاں سب سے عام غلطیاں ہیں:

۱۔ جسم کے حصے چھوڑنا:
   • بغلوں کے نیچے دھونا بھول جانا
   • پاؤں کے تلوے اچھی طرح نہ دھونا
   • گردن کے پیچھے کا حصہ
   • پاؤں کی انگلیوں کے درمیان نہ دھونا
   • کانوں کے پیچھے بھول جانا
   • ناف کا علاقہ چھوڑنا
   • انگوٹھیوں یا گھڑی کے نیچے نہ دھونا

۲۔ رکاوٹیں نہ ہٹانا:
   • نیل پالش لگائے رکھنا (ناخنوں تک پانی نہیں پہنچتا)
   • تنگ زیورات نہ اتارنا جو پانی روکیں
   • واٹر پروف میک اپ یا کریمیں
   • جلد پر خشک گوند، پینٹ، یا آٹا
   • بالوں میں ویکس یا جیل جو پانی کو جذب ہونے سے روکے
   • غیر ضروری پٹیاں
   • کانٹیکٹ لینز (بعض علماء کہتے ہیں انہیں اتارنا چاہیے)

۳۔ غلط نیت:
   • شاور کے نیچے رہتے ہوئے نیت کرنا
   • پانی بند کریں، نیت کریں، پھر غسل شروع کریں
   • طہارت کی نیت کے بغیر عام شاور لینا
   • آخر میں ہی نیت کرنا

۴۔ پانی کا ہر جگہ پہنچنا یقینی نہ بنانا:
   • صرف جسم پر پانی بہانا، ملنا نہیں
   • سر کی جلد اور بالوں کی جڑوں تک پانی نہ پہنچانا
   • منہ اور ناک کافی نہ کھولنا
   • بال بہت گھنے یا چکنے، جڑوں تک پانی نہ پہنچے

۵۔ غسل جنابت کے بعد وضو کرنا:
   • غسل جنابت میں وضو پہلے سے شامل ہے
   • بعد میں وضو کرنا بدعت سمجھا جاتا ہے
   • نوٹ: یہ غسل جنابت کے لیے ہے، دوسری اقسام کے لیے نہیں

۶۔ پہلے پاکی چیک نہ کرنا:
   • خواتین کا حیض ختم ہونے سے پہلے غسل کرنا
   • سفید رطوبت یا مکمل خشکی چیک نہ کرنا
   • بغیر تصدیق کے جلدی کرنا

۷۔ ناپاک پانی استعمال کرنا:
   • پانی پاک (طاہر) ہونا چاہیے
   • وہ پانی جو نجاست ہٹانے کے لیے استعمال ہو چکا ہو
   • آلودہ یا گندا پانی

۸۔ لمبے وقفے:
   • غسل کے دوران وقفہ لینا
   • تسلسل برقرار رکھنا ضروری ہے
   • غسل کے درمیان فون اٹھانا یا دوسرے کام کرنا

اہم: اگر آپ کو احساس ہو کہ آپ نے یہ غلطیاں کیں تو غسل دوبارہ صحیح طریقے سے کریں تاکہ آپ کی نمازیں درست ہوں۔''',
        'hindi': '''ग़ुस्ल में आम ग़लतियां

बहुत से लोग ग़ुस्ल के दौरान ग़लतियां करते हैं जो उसे बातिल कर सकती हैं। यहां सबसे आम ग़लतियां हैं:

१. जिस्म के हिस्से छोड़ना:
   • बग़लों के नीचे धोना भूल जाना
   • पांव के तलवे अच्छी तरह न धोना
   • गर्दन के पीछे का हिस्सा
   • पांव की उंगलियों के दरमियान न धोना
   • कानों के पीछे भूल जाना
   • नाफ़ का इलाक़ा छोड़ना
   • अंगूठियों या घड़ी के नीचे न धोना

२. रुकावटें न हटाना:
   • नेल पॉलिश लगाए रखना (नाख़ुनों तक पानी नहीं पहुंचता)
   • तंग ज़ेवरात न उतारना जो पानी रोकें
   • वाटरप्रूफ़ मेकअप या क्रीम
   • जिल्द पर ख़ुश्क गोंद, पेंट, या आटा
   • बालों में वैक्स या जेल जो पानी को जज़्ब होने से रोके
   • ग़ैर ज़रूरी पट्टियां
   • कॉन्टैक्ट लेंज़ (बाज़ उलमा कहते हैं इन्हें उतारना चाहिए)

३. ग़लत नीयत:
   • शावर के नीचे रहते हुए नीयत करना
   • पानी बंद करें, नीयत करें, फिर ग़��स्ल शुरू करें
   • तहारत की नीयत के बग़ैर आम शावर लेना
   • आख़िर में ही नीयत करना

४. पानी का हर जगह पहुंचना यक़ीनी न बनाना:
   • सिर्फ़ जिस्म पर पानी बहाना, मलना नहीं
   • सर की जिल्द और बालों की जड़ों तक पानी न पहुंचाना
   • मुंह और नाक काफ़ी न खोलना
   • बाल बहुत घने या चिकने, जड़ों तक पानी न पहुंचे

५. ग़ुस्ल-ए-जनाबत के बाद वुज़ू करना:
   • ग़ुस्ल-ए-जनाबत में वुज़ू पहले से शामिल है
   • बाद में वुज़ू करना बिदअत समझा जाता है
   • नोट: यह ग़ुस्ल-ए-जनाबत के लिए है, दूसरी क़िस्मों के लिए नहीं

६. पहले पाकी चेक न करना:
   • ख़वातीन का हैज़ ख़त्म होने से पहले ग़ुस्ल करना
   • सफ़ेद रुतूबत या मुकम्मल ख़ुश्की चेक न करना
   • बग़ैर तस्दीक़ के जल्दी करना

७. नापाक पानी इस्तेमाल करना:
   • पानी पाक (ताहिर) होना चाहिए
   • वो पानी जो नजासत हटाने के लिए इस्तेमाल हो चुका हो
   • आलूदा या गंदा पानी

८. लंबे वक़्फ़े:
   • ग़ुस्ल के दौरान वक़्फ़ा लेना
   • तसलसुल बरक़रार रखना ज़रूरी है
   • ग़ुस्ल के दरमियान फ़ोन उठाना या दूसरे काम करना

अहम: अगर आपको एहसास हो कि आपने यह ग़लतियां कीं तो ग़ुस्ल दोबारा सही तरीक़े से करें ताकि आपकी नमाज़ें दुरुस्त हों।''',
        'arabic': '''الأخطاء الشائعة في الغسل

يرتكب كثير من الناس أخطاء أثناء الغسل قد تبطله. إليك أكثرها شيوعًا:

١. تفويت أجزاء من الجسم:
   • نسيان غسل تحت الإبطين
   • عدم غسل باطن القدمين بشكل صحيح
   • مؤخرة العنق
   • عدم غسل بين أصابع القدمين
   • نسيان غسل خلف الأذنين
   • منطقة السرة
   • عدم غسل تحت الخواتم أو الساعات

٢. عدم إزالة الحواجز:
   • ترك طلاء الأظافر (يمنع الماء من الوصول إلى الأظافر)
   • عدم إزالة المجوهرات الضيقة التي تمنع الماء
   • المكياج أو الكريمات المقاومة للماء
   • الغراء المجفف أو الطلاء أو العجين على الجلد
   • الشمع أو الجل في الشعر الذي يمنع تغلغل الماء
   • الضمادات عند عدم الضرورة
   • العدسات اللاصقة (يقول بعض العلماء يجب إزالتها)

٣. النية غير الصحيحة:
   • البقاء تحت الدش ثم النية
   • يجب إيقاف الماء، النية، ثم بدء الغسل
   • أخذ دش عادي بدون نية الطهارة
   • النية في النهاية فقط

٤. عدم التأكد من وصول الماء لكل مكان:
   • مجرد ترك الماء يجري على الجسم دون فرك
   • عدم التأكد من وصول الماء إلى فروة الرأس وجذور الشعر
   • عدم فتح الفم والأنف بشكل كافٍ
   • الشعر كثيف جدًا أو دهني، يمنع الماء من الوصول للجذور

٥. الوضوء بعد غسل الجنابة:
   • في غسل الجنابة تحديدًا، الوضوء مشمول بالفعل
   • الوضوء بعده يُعتبر بدعة
   • ملاحظة: هذا ينطبق على غسل الجنابة، ليس الأنواع الأخرى

٦. عدم التحقق من الطهارة أولاً:
   • النساء تأخذ الغسل قبل التأكد من انتهاء الحيض
   • عدم التحقق من الإفرازات البيضاء أو الجفاف الكامل
   • التسرع بدون تحقق صحيح

٧. استخدام ماء نجس:
   • يجب أن يكون الماء طاهرًا
   • الماء المستخدم بالفعل لإزالة النجاسة
   • الماء الملوث أو القذر

٨. انقطاعات طويلة:
   • أخذ فترات راحة أثناء الغسل
   • يجب الحفاظ على الاستمرارية
   • الرد على الهاتف أو القيام بمهام أخرى أثناء الغسل

مهم: إذا أدركت أنك ارتكبت أيًا من هذه الأخطاء، كرر الغسل بشكل صحيح للتأكد من صحة صلواتك.''',
      },
    },
    {
      'number': 8,
      'titleKey': 'ghusl_8_what_invalidates_ghusl',
      'title': 'What Invalidates Ghusl?',
      'titleUrdu': 'غسل کو کیا باطل کرتا ہے؟',
      'titleHindi': 'ग़ुस्ल को क्या बातिल करता है?',
      'titleArabic': 'ما الذي يبطل الغسل؟',
      'icon': Icons.cancel,
      'color': Colors.red,
      'details': {
        'english': '''What Invalidates Ghusl?

Understanding what breaks or invalidates Ghusl is crucial for maintaining ritual purity. Here are the things that invalidate Ghusl:

1. Anything That Breaks Wudu Also Breaks Ghusl:
   • Passing urine or stool
   • Passing gas (wind)
   • Deep sleep that causes loss of consciousness
   • Losing consciousness, fainting, or insanity
   • Bleeding from a wound (according to Hanafi school)
   • Touching private parts directly without barrier
   • Vomiting (mouthful, according to Hanafi school)

2. Conditions That Make Ghusl Invalid From the Start:

A. Missing Any Part of the Body:
   • If even a hair's breadth of skin remains dry
   • Any area not washed properly
   • Water did not reach a part of the body
   • Barriers prevented water from reaching skin

B. Lack of Proper Intention (Niyyah):
   • According to Shafi'i and Hanbali schools
   • Ghusl done without intention is invalid
   • Hanafi school: intention is Sunnah, not Fard

C. Using Impure Water:
   • Water that is Najis (impure)
   • Water already used for removing impurity
   • Water mixed with impurities

D. Lengthy Interruption:
   • Long breaks between washing different parts
   • Continuity is essential
   • Excessive delay between steps

3. Things That Require a New Ghusl:

Major Impurities (Janabah):
   • Sexual intercourse (even without ejaculation)
   • Ejaculation of semen with desire
   • Menstruation (after it ends)
   • Post-natal bleeding/Nifas (after it ends)

4. Special Cases:

A. Finding a Missed Spot After Ghusl:
   • If you discover you missed a part after completing Ghusl
   • You must wash that specific part immediately
   • Some scholars say you must repeat entire Ghusl

B. Uncertainty About Completion:
   • If you're unsure whether you washed a part
   • Better to repeat that part to be certain
   • When in doubt, ensure completeness

C. Water Not Reaching Due to Barriers:
   • Nail polish, waterproof makeup
   • Tight rings or jewelry
   • Any substance that creates a barrier
   • These make Ghusl invalid from the start

Important Rules:

• After proper Ghusl Janabah, you don't need Wudu for prayer
• Ghusl includes Wudu when done correctly
• If something breaks your state during Ghusl, complete it first, then repeat
• When in doubt about validity, it's better to repeat the Ghusl

Note: Different schools of Islamic jurisprudence may have slightly different rulings. When in doubt, consult a knowledgeable scholar.''',
        'urdu': '''غسل کو کیا باطل کرتا ہے؟

رسمی طہارت برقرار رکھنے کے لیے یہ سمجھنا ضروری ہے کہ غسل کو کیا توڑتا یا باطل کرتا ہے:

۱۔ جو چیزیں وضو توڑتی ہیں وہ غسل بھی توڑتی ہیں:
   • پیشاب یا پاخانہ کرنا
   • ہوا خارج ہونا
   • گہری نیند جو بے ہوشی کا سبب بنے
   • بے ہوشی، مدہوشی، یا جنون
   • زخم سے خون بہنا (حنفی مسلک کے مطابق)
   • بغیر رکاوٹ کے شرمگاہ چھونا
   • قے کرنا (منہ بھر، حنفی مسلک کے مطابق)

۲۔ وہ شرائط جو غسل کو شروع سے ہی باطل کر دیں:

الف۔ جسم کا کوئی حصہ چھوڑنا:
   • اگر بال برابر جلد بھی خشک رہ جائے
   • کوئی علاقہ اچھی طرح نہ دھویا گیا
   • پانی جسم کے کسی حصے تک نہ پہنچا
   • رکاوٹوں نے پانی کو جلد تک پہنچنے سے روکا

ب۔ صحیح نیت کی کمی:
   • شافعی اور حنبلی مسلک کے مطابق
   • بغیر نیت کے غسل باطل ہے
   • حنفی مسلک: نیت سنت ہے، فرض نہیں

ج۔ ناپاک پانی استعمال کرنا:
   • پانی جو نجس ہو
   • پانی جو نجاست ہٹانے کے لیے استعمال ہو چکا ہو
   • نجاست ملا ہوا پانی

د۔ لمبا وقفہ:
   • مختلف حصوں کو دھونے کے درمیان لمبے وقفے
   • تسلسل ضروری ہے
   • مراحل کے درمیان زیادہ تاخیر

۳۔ وہ چیزیں جو نیا غسل ضروری کرتی ہیں:

بڑی ناپاکی (جنابت):
   • جماع (بغیر انزال کے بھی)
   • خواہش کے ساتھ منی کا اخراج
   • حیض (ختم ہونے کے بعد)
   • نفاس (ختم ہونے کے بعد)

۴۔ خاص حالات:

الف۔ غسل کے بعد چھوٹا حصہ ملنا:
   • اگر غسل مکمل کرنے کے بعد پتا چلے کہ کوئی حصہ چھوٹ گیا
   • اس مخصوص حصے کو فوری دھونا ضروری ہے
   • بعض علماء کہتے ہیں پورا غسل دہرانا ہوگا

ب۔ تکمیل میں شک:
   • اگر یقین نہ ہو کہ کوئی حصہ دھویا یا نہیں
   • بہتر ہے وہ حصہ دوبارہ دھو لیں
   • شک کی صورت میں مکمل کریں

ج۔ رکاوٹوں کی وجہ سے پانی نہ پہنچنا:
   • نیل پالش، واٹر پروف میک اپ
   • تنگ انگوٹھیاں یا زیورات
   • کوئی بھی چیز جو رکاوٹ بنائے
   • یہ غسل کو شروع سے باطل کرتے ہیں

اہم اصول:

• صحیح غسل جنابت کے بعد نماز کے لیے وضو کی ضرورت نہیں
• صحیح طریقے سے کیا گیا غسل، وضو شامل کرتا ہے
• اگر غسل کے دوران کچھ آپ کی حالت توڑ دے، پہلے مکمل کریں، پھر دہرائیں
• صحت میں شک ہو تو بہتر ہے غسل دہرا لیں

نوٹ: اسلامی فقہ کے مختلف مکاتب فکر کے احکام قدرے مختلف ہو سکتے ہیں۔ شک کی صورت میں علم رکھنے والے عالم سے مشورہ کریں۔''',
        'hindi': '''ग़ुस्ल को क्या बातिल करता है?

रस्मी तहारत बरक़रार रखने के लिए यह समझना ज़रूरी है कि ग़ुस्ल को क्या तोड़ता या बातिल करता है:

१. जो चीज़ें वुज़ू तोड़ती हैं वो ग़ुस्ल भी तोड़ती हैं:
   • पेशाब या पाख़ाना करना
   • हवा ख़ारिज होना
   • गहरी नींद जो बेहोशी का सबब बने
   • बेहोशी, मदहोशी, या जुनून
   • ज़ख़्म से ख़ून बहना (हनफ़ी मसलक के मुताबिक़)
   • बग़ैर रुकावट के शर्मगाह छूना
   • क़ै करना (मुंह भर, हनफ़ी मसलक के मुताबिक़)

२. वो शर्तें जो ग़ुस्ल को शुरू से ही बातिल कर दें:

अलिफ़। जिस्म का कोई हिस्सा छोड़ना:
   • अगर बाल बराबर जिल्द भी ख़ुश्क रह जाए
   • कोई इलाक़ा अच्छी तरह न धोया गया
   • पानी जिस्म के किसी हिस्से तक न पहुंचा
   • रुकावटों ने पानी को जिल्द तक पहुंचने से रोका

बे। सही नीयत की कमी:
   • शाफ़ई और हंबली मसलक के मुताबिक़
   • बग़ैर नीयत के ग़ुस्ल बातिल है
   • हनफ़ी मसलक: नीयत सुन्नत है, फ़र्ज़ नहीं

जीम। नापाक पानी इस्तेमाल करना:
   • पानी जो नजिस हो
   • पानी जो नजासत हटाने के लिए इस्तेमाल हो चुका हो
   • नजासत मिला हुआ पानी

दाल। लंबा वक़्फ़ा:
   • मुख़्तलिफ़ हिस्सों को धोने के दरमियान लंबे वक़्फ़े
   • तसलसुल ज़रूरी है
   • मराहिल के दरमियान ज़्यादा ताख़ीर

३. वो चीज़ें जो नया ग़ुस्ल ज़रूरी करती हैं:

बड़ी नापाकी (जनाबत):
   • जिमाअ (बग़ैर इंज़ाल के भी)
   • ख़्वाहिश के साथ मनी का इख़राज
   • हैज़ (ख़त्म होने के बाद)
   • निफ़ास (ख़त्म होने के बाद)

४. ख़ास हालात:

अलिफ़। ग़ुस्ल के बाद छोटा हिस्सा मिलना:
   • अगर ग़ुस्ल मुकम्मल करने के बाद पता चले कि कोई हिस्सा छूट गया
   • उस मख़सूस हिस्से को फ़ौरन धोना ज़रूरी है
   • बाज़ उलमा कहते हैं पूरा ग़ुस्ल दोहराना होगा

बे। तक्मील में शक:
   • अगर यक़ीन न हो कि कोई हिस्सा धोया या नहीं
   • बेहतर है वो हिस्सा दोबारा धो लें
   • शक की सूरत में मुकम्मल करें

जीम। रुकावटों की वजह से पानी न पहुंचना:
   • नेल पॉलिश, वाटरप्रूफ़ मेकअप
   • तंग अंगूठियां या ज़ेवरात
   • कोई भी चीज़ जो रुकावट बनाए
   • यह ग़ुस्ल को शुरू से बातिल करते हैं

अहम उसूल:

• सही ग़ुस्ल-ए-जनाबत के बाद नमाज़ के लिए वुज़ू की ज़रूरत नहीं
• सही तरीक़े से किया गया ग़ुस्ल, वुज़ू शामिल करता है
• अगर ग़ुस्ल के दौरान कुछ आपकी हालत तोड़ दे, पहले मुकम्मल करें, फिर दोहराएं
• सेहत में शक हो तो बेहतर है ग़ुस्ल दोहरा लें

नोट: इस्लामी फ़िक़्ह के मुख़्तलिफ़ मकातिब-ए-फ़िक्र के अहकाम क़द्रे मुख़्तलिफ़ हो सकते हैं। शक की सूरत में इल्म रखने वाले आलिम से मशवरा करें।''',
        'arabic': '''ما الذي يبطل الغسل؟

فهم ما يبطل الغسل أمر بالغ الأهمية للحفاظ على الطهارة الشرعية:

١. أي شيء ينقض الوضوء ينقض الغسل أيضًا:
   • التبول أو التبرز
   • خروج الريح (الغازات)
   • النوم العميق الذي يسبب فقدان الوعي
   • فقدان الوعي أو الإغماء أو الجنون
   • نزيف من جرح (وفقًا للمذهب الحنفي)
   • لمس الأعضاء التناسلية مباشرة دون حاجز
   • القيء (ملء الفم، وفقًا للمذهب الحنفي)

٢. الشروط التي تبطل الغسل من البداية:

أ. تفويت أي جزء من الجسم:
   • إذا بقي حتى مساحة شعرة من الجلد جافة
   • أي منطقة لم تُغسل بشكل صحيح
   • الماء لم يصل إلى جزء من الجسم
   • الحواجز منعت الماء من الوصول إلى الجلد

ب. عدم النية الصحيحة:
   • وفقًا للمذهبين الشافعي والحنبلي
   • الغسل بدون نية باطل
   • المذهب الحنفي: النية سنة، ليست فرضًا

ج. استخدام ماء نجس:
   • ماء نجس (غير طاهر)
   • ماء مستخدم بالفعل لإزالة النجاسة
   • ماء مختلط بالنجاسات

د. انقطاع طويل:
   • فترات راحة طويلة بين غسل أجزاء مختلفة
   • الاستمرارية ضرورية
   • تأخير مفرط بين الخطوات

٣. أشياء تتطلب غسلاً جديدًا:

النجاسة الكبرى (الجنابة):
   • الجماع (حتى بدون إنزال)
   • إنزال المني بشهوة
   • الحيض (بعد انتهائه)
   • النفاس (بعد انتهائه)

٤. حالات خاصة:

أ. اكتشاف بقعة مفقودة بعد الغسل:
   • إذا اكتشفت أنك فوت جزءًا بعد إتمام الغسل
   • يجب غسل ذلك الجزء المحدد فورًا
   • بعض العلماء يقولون يجب إعادة الغسل بالكامل

ب. عدم اليقين من الاكتمال:
   • إذا لم تكن متأكدًا من غسل جزء ما
   • من الأفضل إعادة ذلك الجزء للتأكد
   • عند الشك، تأكد من الاكتمال

ج. عدم وصول الماء بسبب الحواجز:
   • طلاء الأظافر، المكياج المقاوم للماء
   • الخواتم أو المجوهرات الضيقة
   • أي مادة تخلق حاجزًا
   • هذه تبطل الغسل من البداية

قواعد مهمة:

• بعد غسل الجنابة الصحيح، لا تحتاج إلى وضوء للصلاة
• الغسل يشمل الوضوء عند القيام به بشكل صحيح
• إذا حدث شيء ينقض حالتك أثناء الغسل، أكمله أولاً، ثم أعده
• عند الشك في الصحة، من الأفضل إعادة الغسل

ملاحظة: قد تختلف أحكام المذاهب الفقهية الإسلامية قليلاً. عند الشك، استشر عالمًا ذا علم.''',
      },
    },
    {
      'number': 9,
      'titleKey': 'ghusl_9_ghusl_vs_normal_bath',
      'title': 'Ghusl vs Normal Bath',
      'titleUrdu': 'غسل اور عام نہانا',
      'titleHindi': 'ग़ुस्ल और आम नहाना',
      'titleArabic': 'الفرق بين الغسل والاستحمام العادي',
      'icon': Icons.compare_arrows,
      'color': Colors.teal,
      'details': {
        'english': '''Difference Between Ghusl and Normal Bath

Many people wonder: "Can I just take a shower instead of doing Ghusl?" Understanding the differences is important:

Key Differences:

1. Intention (Niyyah):
   • Ghusl: Must have specific intention for purification from major impurity
   • Normal Bath: No religious intention, just for cleanliness or refreshment
   • Without intention, it's just a bath, not Ghusl (Shafi'i and Hanbali schools)

2. Mandatory Components:
   • Ghusl: MUST include rinsing mouth and nose (Fard in Hanafi school)
   • Normal Bath: Mouth and nose rinsing not required
   • Ghusl: Water must reach EVERY part of the body without exception
   • Normal Bath: Can skip some areas

3. Religious Validity:
   • Ghusl: Removes ritual impurity (Janabah)
   • Normal Bath: Only cleans physical dirt
   • After Ghusl: You can pray, touch Quran, perform Tawaf
   • After Normal Bath: Cannot do these acts if you were in state of Janabah

4. Continuity Requirement:
   • Ghusl: Must be done continuously without long breaks
   • Normal Bath: Can take breaks, pause, do other things

5. Purpose:
   • Ghusl: Act of worship for spiritual purification
   • Normal Bath: Physical cleanliness and hygiene

Can You Take a Shower for Ghusl?

YES! You can absolutely perform Ghusl in the shower, but you must:

1. Make Intention First:
   • Stop the water momentarily
   • Make intention in your heart to purify yourself
   • Say "Bismillah"
   • Then start the shower

2. Include Mandatory Acts:
   • Rinse your mouth thoroughly
   • Sniff water into your nose
   • Ensure water reaches every single part of your body

3. Follow the Sequence:
   • Better to follow Sunnah method even in shower
   • Remove impurities first
   • Perform or intend Wudu
   • Pour water over entire body starting with head

4. No Long Interruptions:
   • Don't answer phone calls
   • Don't do other tasks mid-Ghusl
   • Maintain continuity

Example Scenarios:

Scenario 1 - NOT Valid Ghusl:
• You take a normal shower after waking up
• You wash your whole body thoroughly
• But you didn't make intention for Ghusl
• Result: Just a bath, not Ghusl - cannot pray

Scenario 2 - Valid Ghusl:
• You are in state of Janabah
• You enter shower, stop water, make intention
• You rinse mouth and nose
• You wash entire body ensuring water reaches everywhere
• Result: Valid Ghusl - you can pray

Scenario 3 - NOT Valid Ghusl:
• You make intention and shower
• But you forget to rinse your mouth or nose
• Result: Ghusl is invalid (according to Hanafi school)

Important Points:

• Showering is completely acceptable for Ghusl
• Modern showers can be more thorough than traditional methods
• The KEY is intention and including mandatory components
• Ghusl = Normal thorough shower + Intention + Mouth/Nose rinsing

Common Question:
"I showered after being in Janabah but forgot to make intention. Is my Ghusl valid?"

Answer:
• According to Hanafi school: Yes, valid (intention is Sunnah)
• According to Shafi'i and Hanbali: No, not valid (intention is Fard)
• To be safe: Repeat the Ghusl with proper intention

Remember: It's better to be certain that your Ghusl is valid than to pray with doubt!''',
        'urdu': '''غسل اور عام نہانے میں فرق

بہت سے لوگ سوچتے ہیں: "کیا میں غسل کی بجائے صرف شاور لے سکتا ہوں؟" فرق کو سمجھنا ضروری ہے:

اہم فرق:

۱۔ نیت:
   • غسل: بڑی ناپاکی سے طہارت کی مخصوص نیت ضروری ہے
   • عام نہانا: کوئی مذہبی نیت نہیں، صرف صفائی یا تازگی کے لیے
   • نیت کے بغیر، یہ صرف نہانا ہے، غسل نہیں (شافعی اور حنبلی مسلک)

۲۔ لازمی اجزاء:
   • غسل: کلی اور ناک میں پانی ڈالنا لازمی ہے (حنفی مسلک میں فرض)
   • عام نہانا: منہ اور ناک کی صفائی ضروری نہیں
   • غسل: پانی جسم کے ہر حصے تک پہنچنا ضروری ہے
   • عام نہانا: کچھ حصے چھوڑے جا سکتے ہیں

۳۔ مذہبی جواز:
   • غسل: رسمی ناپاکی (جنابت) دور کرتا ہے
   • عام نہانا: صرف جسمانی گندگی صاف کرتا ہے
   • غسل کے بعد: نماز پڑھ سکتے ہیں، قرآن چھو سکتے ہیں، طواف کر سکتے ہیں
   • عام نہانے کے بعد: اگر جنابت میں تھے تو یہ کام نہیں کر سکتے

۴۔ تسلسل کی ضرورت:
   • غسل: بغیر لمبے وقفوں کے مسلسل کرنا ضروری ہے
   • عام نہانا: وقفے لے سکتے ہیں، رک سکتے ہیں، دوسرے کام کر سکتے ہیں

۵۔ مقصد:
   • غسل: روحانی طہارت کے لیے عبادت
   • عام نہانا: جسمانی صفائی اور حفظان صحت

کیا آپ غسل کے لیے شاور لے سکتے ہیں؟

جی ہاں! آپ بالکل شاور میں غسل کر سکتے ہیں، لیکن آپ کو:

۱۔ پہلے نیت کریں:
   • پانی عارضی طور پر بند کریں
   • دل میں خود کو پاک کرنے کی نیت کریں
   • "بسم اللہ" کہیں
   • پھر شاور شروع کریں

۲۔ لازمی اعمال شامل کریں:
   • اپنا منہ اچھی طرح دھوئیں
   • ناک میں پانی ڈالیں
   • یقینی بنائیں کہ پانی جسم کے ہر حصے تک پہنچے

۳۔ ترتیب کی پیروی کریں:
   • شاور میں بھی سنت طریقہ اپنانا بہتر ہے
   • پہلے نجاستیں دور کریں
   • وضو کریں یا ارادہ کریں
   • سر سے شروع کرتے ہوئے پورے جسم پر پانی ڈالیں

۴۔ لمبے وقفے نہ لیں:
   • فون کالز کا جواب نہ دیں
   • غسل کے درمیان دوسرے کام نہ کریں
   • تسلسل برقرار رکھیں

مثال کے منظر نامے:

منظر نامہ 1 - غسل درست نہیں:
• آپ جاگنے کے بعد عام شاور لیتے ہیں
• آپ اپنا پورا جسم اچھی طرح دھوتے ہیں
• لیکن آپ نے غسل کی نیت نہیں کی
• نتیجہ: صرف نہانا ہے، غسل نہیں - نماز نہیں پڑھ سکتے

منظر نامہ 2 - درست غسل:
• آپ جنابت کی حالت میں ہیں
• آپ شاور میں داخل ہوتے ہیں، پانی بند کرتے ہیں، نیت کرتے ہیں
• آپ منہ اور ناک دھوتے ہیں
• آپ پورا جسم دھوتے ہیں اور یقینی بناتے ہیں کہ پانی ہر جگہ پہنچے
• نتیجہ: درست غسل - آپ نماز پڑھ سکتے ہیں

منظر نامہ 3 - غسل درست نہیں:
• آپ نیت کرتے ہیں اور شاور لیتے ہیں
• لیکن آپ منہ یا ناک دھونا بھول جاتے ہیں
• نتیجہ: غسل باطل ہے (حنفی مسلک کے مطابق)

اہم نکات:

• غسل کے لیے شاور مکمل طور پر قابل قبول ہے
• جدید شاور روایتی طریقوں سے زیادہ مکمل ہو سکتے ہیں
• کلید ہے نیت اور لازمی اجزاء شامل کرنا
• غسل = عام مکمل شاور + نیت + منہ/ناک دھونا

عام سوال:
"میں نے جنابت میں ہونے کے بعد شاور لیا لیکن نیت کرنا بھول گیا۔ کیا میرا غسل درست ہے؟"

جواب:
• حنفی مسلک کے مطابق: ہاں، درست (نیت سنت ہے)
• شافعی اور حنبلی کے مطابق: نہیں، درست نہیں (نیت فرض ہے)
• محفوظ رہنے کے لیے: صحیح نیت کے ساتھ غسل دہرائیں

یاد رکھیں: شک کے ساتھ نماز پڑھنے سے بہتر ہے کہ آپ کو یقین ہو کہ آپ کا غسل درست ہے!''',
        'hindi': '''ग़ुस्ल और आम नहाने में फ़र्क़

बहुत से लोग सोचते हैं: "क्या मैं ग़ुस्ल की बजाय सिर्फ़ शावर ले सकता हूं?" फ़र्क़ को समझना ज़रूरी है:

अहम फ़र्क़:

१. नीयत:
   • ग़ुस्ल: बड़ी नापाकी से तहारत की मख़सूस नीयत ज़रूरी है
   • आम नहाना: कोई मज़हबी नीयत नहीं, सिर्फ़ सफ़ाई या ताज़गी के लिए
   • नीयत के बग़ैर, यह सिर्फ़ नहाना है, ग़ुस्ल नहीं (शाफ़ई और हंबली मसलक)

२. लाज़िमी अज्ज़ा:
   • ग़ुस्ल: कुल्ली और नाक में पानी डालना लाज़िमी है (हनफ़ी मसलक में फ़र्ज़)
   • आम नहाना: मुंह और नाक की सफ़ाई ज़रूरी नहीं
   • ग़ुस्ल: पानी जिस्म के हर हिस्से तक पहुंचना ज़रूरी है
   • आम नहाना: कुछ हिस्से छोड़े जा सकते हैं

३. मज़हबी जवाज़:
   • ग़ुस्ल: रस्मी नापाकी (जनाबत) दूर करता है
   • आम नहाना: सिर्फ़ जिस्मानी गंदगी साफ़ करता है
   • ग़ुस्ल के बाद: नमाज़ पढ़ सकते हैं, क़ुरआन छू सकते हैं, तवाफ़ कर सकते हैं
   • आम नहाने के बाद: अगर जनाबत में थे तो यह काम नहीं कर सकते

४. तसलसुल की ज़रूरत:
   • ग़ुस्ल: बग़ैर लंबे वक़्फ़ों के मुसलसल करना ज़रूरी है
   • आम नहाना: वक़्फ़े ले सकते हैं, रुक सकते हैं, दूसरे काम कर सकते हैं

५. मक़सद:
   • ग़ुस्ल: रूहानी तहारत के लिए इबादत
   • आम नहाना: जिस्मानी सफ़ाई और हिफ़्ज़ान-ए-सेहत

क्या आप ग़ुस्ल के लिए शावर ले सकते हैं?

जी हां! आप बिल्कुल शावर में ग़ुस्ल कर सकते हैं, लेकिन आपको:

१. पहले नीयत करें:
   • पानी आरज़ी तौर पर बंद करें
   • दिल में ख़ुद को पाक करने की नीयत करें
   • "बिस्मिल्लाह" कहें
   • फिर शावर शुरू करें

२. लाज़िमी आमाल शामिल करें:
   • अपना मुंह अच्छी तरह धोएं
   • नाक में पानी डालें
   • यक़ीनी बनाएं कि पानी जिस्म के हर हिस्से तक पहुंचे

३. तर्तीब की पैरवी करें:
   • शावर में भी सुन्नत तरीक़ा अपनाना बेहतर है
   • पहले नजासतें दूर करें
   • वुज़ू करें या इरादा करें
   • सर से शुरू करते हुए पूरे जिस्म पर पानी डालें

४. लंबे वक़्फ़े न लें:
   • फ़ोन कॉल का जवाब न दें
   • ग़ुस्ल के दरमियान दूसरे काम न करें
   • तसलसुल बरक़रार रखें

मिसाल के मंज़र नामे:

मंज़र नामा 1 - ग़ुस्ल दुरुस्त नहीं:
• आप जागने के बाद आम शावर लेते हैं
• आप अपना पूरा जिस्म अच्छी तरह धोते हैं
• लेकिन आपने ग़ुस्ल की नीयत नहीं की
• नतीजा: सिर्फ़ नहाना है, ग़ुस्ल नहीं - नमाज़ नहीं पढ़ सकते

मंज़र नामा 2 - दुरुस्त ग़ुस्ल:
• आप जनाबत की हालत में हैं
• आप शावर में दाख़िल होते हैं, पानी बंद करते हैं, नीयत करते हैं
• आप मुंह और नाक धोते हैं
• आप पूरा जिस्म धोते हैं और यक़ीनी बनाते हैं कि पानी हर जगह पहुंचे
• नतीजा: दुरुस्त ग़ुस्ल - आप नमाज़ पढ़ सकते हैं

मंज़र नामा 3 - ग़ुस्ल दुरुस्त नहीं:
• आप नीयत करते हैं और शावर लेते हैं
• लेकिन आप मुंह या नाक धोना भूल जाते हैं
• नतीजा: ग़ुस्ल बातिल है (हनफ़ी मसलक के मुताबिक़)

अहम बातें:

• ग़ुस्ल के लिए शावर मुकम्मल तौर पर क़ाबिल-ए-क़बूल है
• जदीद शावर रिवायती तरीक़ों से ज़्यादा मुकम्मल हो सकते हैं
• कुंजी है नीयत और लाज़िमी अज्ज़ा शामिल करना
• ग़ुस्ल = आम मुकम्मल शावर + नीयत + मुंह/नाक धोना

आम सवाल:
"मैंने जनाबत में होने के बाद शावर लिया लेकिन नीयत करना भूल गया। क्या मेरा ग़ुस्ल दुरुस्त है?"

जवाब:
• हनफ़ी मसलक के मुताबिक़: हां, दुरुस्त (नीयत सुन्नत है)
• शाफ़ई और हंबली के मुताबिक़: नहीं, दुरुस्त नहीं (नीयत फ़र्ज़ है)
• महफ़ूज़ रहने के लिए: सही नीयत के साथ ग़ुस्ल दोहराएं

याद रखें: शक के साथ नमाज़ पढ़ने से बेहतर है कि आपको यक़ीन हो कि आपका ग़ुस्ल दुरुस्त है!''',
        'arabic': '''الفرق بين الغسل والاستحمام العادي

يتساءل كثيرون: "هل يمكنني الاستحمام بدلاً من الغسل؟" فهم الفروق مهم:

الفروق الرئيسية:

١. النية:
   • الغسل: يجب أن تكون هناك نية محددة للطهارة من الجنابة الكبرى
   • الاستحمام العادي: لا نية دينية، فقط للنظافة أو الانتعاش
   • بدون نية، هو مجرد استحمام، ليس غسلاً (المذهب الشافعي والحنبلي)

٢. المكونات الإلزامية:
   • الغسل: يجب المضمضة والاستنشاق (فرض في المذهب الحنفي)
   • الاستحمام العادي: المضمضة والاستنشاق غير مطلوبين
   • الغسل: يجب أن يصل الماء إلى كل جزء من الجسم دون استثناء
   • الاستحمام العادي: يمكن تخطي بعض المناطق

٣. الصحة الشرعية:
   • الغسل: يزيل النجاسة الشرعية (الجنابة)
   • الاستحمام العادي: ينظف الأوساخ الجسدية فقط
   • بعد الغسل: يمكنك الصلاة، لمس القرآن، أداء الطواف
   • بعد الاستحمام العادي: لا يمكنك هذه الأعمال إذا كنت في حالة جنابة

٤. متطلبات الاستمرارية:
   • الغسل: يجب القيام به بشكل مستمر دون فترات راحة طويلة
   • الاستحمام العادي: يمكن أخذ فترات راحة، التوقف، القيام بأشياء أخرى

٥. الغرض:
   • الغسل: عبادة للطهارة الروحية
   • الاستحمام العادي: النظافة الجسدية والصحة

هل يمكنك الاستحمام للغسل؟

نعم! يمكنك تمامًا أداء الغسل في الدش، ولكن يجب:

١. النية أولاً:
   • أوقف الماء مؤقتًا
   • انو في قلبك أن تطهر نفسك
   • قل "بسم الله"
   • ثم ابدأ الدش

٢. تضمين الأعمال الإلزامية:
   • تمضمض جيدًا
   • استنشق الماء في أنفك
   • تأكد من وصول الماء إلى كل جزء من جسمك

٣. اتبع التسلسل:
   • من الأفضل اتباع الطريقة السنة حتى في الدش
   • أزل النجاسات أولاً
   • توضأ أو انو الوضوء
   • صب الماء على الجسم كله بدءًا من الرأس

٤. لا انقطاعات طويلة:
   • لا ترد على المكالمات الهاتفية
   • لا تقم بمهام أخرى أثناء الغسل
   • حافظ على الاستمرارية

سيناريوهات مثالية:

السيناريو 1 - غسل غير صحيح:
• تستحم بشكل عادي بعد الاستيقاظ
• تغسل جسمك بالكامل جيدًا
• لكنك لم تنو الغسل
• النتيجة: مجرد استحمام، ليس غسلاً - لا يمكنك الصلاة

السيناريو 2 - غسل صحيح:
• أنت في حالة جنابة
• تدخل الدش، توقف الماء، تنوي
• تتمضمض وتستنشق
• تغسل الجسم بالكامل مع التأكد من وصول الماء لكل مكان
• النتيجة: غسل صحيح - يمكنك الصلاة

السيناريو 3 - غسل غير صحيح:
• تنوي وتستحم
• لكنك نسيت المضمضة أو الاستنشاق
• النتيجة: الغسل باطل (وفقًا للمذهب الحنفي)

نقاط مهمة:

• الاستحمام مقبول تمامًا للغسل
• الدش الحديث يمكن أن يكون أكثر شمولاً من الطرق التقليدية
• المفتاح هو النية وتضمين المكونات الإلزامية
• الغسل = استحمام شامل عادي + نية + مضمضة/استنشاق

سؤال شائع:
"استحممت بعد الجنابة لكنني نسيت النية. هل غسلي صحيح؟"

الجواب:
• وفقًا للمذهب الحنفي: نعم، صحيح (النية سنة)
• وفقًا للشافعي والحنبلي: لا، غير صحيح (النية فرض)
• للأمان: كرر الغسل مع النية الصحيحة

تذكر: من الأفضل أن تكون متيقنًا من صحة غسلك بدلاً من الصلاة بشك!''',
      },
    },
    {
      'number': 10,
      'titleKey': 'ghusl_10_ghusl_for_deceased',
      'title': 'Ghusl for the Deceased',
      'titleUrdu': 'میت کا غسل',
      'titleHindi': 'मय्यित का ग़ुस्ल',
      'titleArabic': 'غسل الميت',
      'icon': Icons.account_circle_outlined,
      'color': Colors.grey,
      'details': {
        'english': '''Ghusl for the Deceased (Ghusl Mayyit)

Giving Ghusl to a deceased Muslim is a communal obligation (Fard Kifayah) - if some people do it, the obligation is lifted from the rest of the community.

Who Should Give Ghusl:

1. Preference:
   • Spouse can wash spouse
   • Same gender should wash same gender
   • Men wash men, women wash women
   • Close family members preferred

2. Exceptions:
   • Husband can wash wife and vice versa
   • Young children can be washed by either gender
   • Mother can wash young son, father can wash young daughter

Method of Ghusl for Deceased:

Step 1: Preparation
• Place deceased on elevated platform
• Cover the awrah (private parts) with cloth
• Prepare warm water (if possible)
• Use soap or lotus leaves (Sidr)

Step 2: Press the Stomach Gently
• Press gently to remove any waste
• Clean any impurities that come out

Step 3: Perform Wudu-like Washing
• Wash hands
• Wipe the face with wet cloth
• Wipe arms up to elbows
• Wipe head with wet cloth
• Wipe feet
• Do NOT let water enter mouth or nose

Step 4: Wash the Body
• Pour water over entire body, right side first
• Then left side
• Wash 3 times or more (odd number)
• Use soap or Sidr leaves

Step 5: Final Washing
• Pour water mixed with camphor (Kafur) for final wash
• Ensure all parts are cleaned

Step 6: Dry and Shroud
• Dry the body with clean cloth
• Wrap in shroud (Kafan)

Number of Washings:
• Minimum: Once (all body parts)
• Sunnah: Three times, five times, or seven times
• Always use odd number

Important Guidelines:

1. Privacy and Respect:
   • Cover the awrah at all times
   • Only necessary people present
   • Maintain dignity of deceased
   • Do not disclose any defects seen on body

2. Water Requirements:
   • Use clean, pure water
   • Warm water is better if available
   • Add camphor to final water

3. After Giving Ghusl:
   • Person who gave Ghusl should perform Ghusl themselves (recommended)
   • Or at minimum, perform Wudu

4. Special Cases:

Shaheed (Martyr):
   • One who dies in battle (shaheed in battlefield)
   • Does NOT receive Ghusl
   • Buried in same clothes
   • Blood is not washed off

Miscarried Fetus:
   • If 4 months or older: Give Ghusl and name
   • If younger than 4 months: Wrap in cloth and bury

Menstruating Woman Dies:
   • Still give Ghusl normally
   • State of menstruation ended with death

Cannot Find Water:
   • Perform Tayammum on the deceased
   • Same as Tayammum for living person

Modern Considerations:

• Autopsy does not prevent Ghusl
• If body damaged, wash what can be washed
• If complete body not available, wash what is present
• Hospital staff should allow family to perform Ghusl when possible

Du'a While Giving Ghusl:

"اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ"

"Allahumma-ghfir lahu warhamhu wa 'afihi wa'fu 'anhu"

"O Allah, forgive him, have mercy on him, pardon him and overlook his sins."

Note: Use "laha" for female deceased.

This is a great honor and responsibility. May Allah make it easy for those who perform this duty.''',
        'urdu': '''میت کا غسل

کسی مسلمان میت کو غسل دینا فرض کفایہ ہے - اگر کچھ لوگ یہ کریں تو باقی برادری سے فرض اٹھ جاتا ہے۔

غسل کون دے:

۱۔ ترجیح:
   • شوہر بیوی کو دھو سکتا ہے اور بیوی شوہر کو
   • ایک ہی جنس والے ایک ہی جنس کو دھوئیں
   • مرد مردوں کو، خواتین خواتین کو
   • قریبی خاندان کے افراد کو ترجیح

۲۔ استثناء:
   • شوہر بیوی کو دھو سکتا ہے اور بالعکس
   • چھوٹے بچوں کو کوئی بھی جنس دھو سکتی ہے
   • ماں چھوٹے بیٹے کو، باپ چھوٹی بیٹی کو دھو سکتے ہیں

میت کے غسل کا طریقہ:

پہلا قدم: تیاری
• میت کو اونچے پلیٹ فارم پر رکھیں
• شرمگاہ کو کپڑے سے ڈھانپیں
• گرم پانی تیار کریں (اگر ممکن ہو)
• صابن یا بیری کے پتے (سدر) استعمال کریں

دوسرا قدم: پیٹ کو ہلکے سے دبائیں
• فضلہ نکالنے کے لیے آہستہ دبائیں
• جو نجاست نکلے اسے صاف کریں

تیسرا قدم: وضو جیسا دھونا
• ہاتھ دھوئیں
• گیلے کپڑے سے چہرہ پونچھیں
• کہنیوں تک بازو پونچھیں
• گیلے کپڑے سے سر پونچھیں
• پاؤں پونچھیں
• منہ یا ناک میں پانی نہ جانے دیں

چوتھا قدم: جسم دھوئیں
• پورے جسم پر پانی ڈالیں، پہلے دایاں طرف
• پھر بایاں طرف
• 3 بار یا اس سے زیادہ دھوئیں (طاق نمبر)
• صابن یا سدر کے پتے استعمال کریں

پانچواں قدم: آخری دھلائی
• آخری دھلائی کے لیے کافور ملا پانی ڈالیں
• یقینی بنائیں کہ تمام حصے صاف ہوں

چھٹا قدم: خشک کریں اور کفن دیں
• صاف کپڑے سے جسم خشک کریں
• کفن میں لپیٹیں

دھلائیوں کی تعداد:
• کم از کم: ایک بار (تمام جسم کے حصے)
• سنت: تین بار، پانچ بار، یا سات بار
• ہمیشہ طاق نمبر استعمال کریں

اہم رہنما اصول:

۱۔ پردہ اور احترام:
   • ہر وقت شرمگاہ کو ڈھانپیں
   • صرف ضروری لوگ موجود ہوں
   • میت کی عزت برقرار رکھیں
   • جسم پر نظر آنے والے کسی عیب کو ظاہر نہ کریں

۲۔ پانی کی ضروریات:
   • صاف، پاک پانی استعمال کریں
   • اگر دستیاب ہو تو گرم پانی بہتر ہے
   • آخری پانی میں کافور ملائیں

۳۔ غسل دینے کے بعد:
   • جس نے غسل دیا اسے خود بھی غسل کرنا چاہیے (تجویز کردہ)
   • یا کم از کم وضو کریں

۴۔ خاص حالات:

شہید:
   • جو جنگ میں شہید ہو
   • غسل نہیں دیا جاتا
   • انہی کپڑوں میں دفن کیا جاتا ہے
   • خون نہیں دھویا جاتا

اسقاط شدہ جنین:
   • اگر 4 ماہ یا زیادہ: غسل دیں اور نام رکھیں
   • اگر 4 ماہ سے کم: کپڑے میں لپیٹ کر دفن کریں

حیض میں خاتون کی وفات:
   • پھر بھی عام طور پر غسل دیں
   • موت کے ساتھ حیض کی حالت ختم ہو گئی

پانی نہ ملے:
   • میت پر تیمم کریں
   • زندہ شخص کے تیمم جیسا ہی

جدید تحفظات:

• پوسٹ مارٹم غسل میں رکاوٹ نہیں
• اگر جسم خراب ہو، جو دھویا جا سکے دھوئیں
• اگر مکمل جسم دستیاب نہ ہو، جو موجود ہو دھوئیں
• ہسپتال کے عملے کو خاندان کو غسل دینے کی اجازت دینی چاہیے

غسل دیتے وقت دعا:

"اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ"

"اے اللہ، اسے بخش دے، اس پر رحم کر، اسے عافیت دے اور اس کے گناہ معاف فرما۔"

نوٹ: خاتون میت کے لیے "لھا" استعمال کریں۔

یہ ایک بڑا اعزاز اور ذمہ داری ہے۔ اللہ ان کے لیے آسانی فرمائے جو یہ فریضہ ادا کرتے ہیں۔''',
        'hindi': '''मय्यित का ग़ुस्ल

किसी मुस्लिम मय्यित को ग़ुस्ल देना फ़र्ज़-ए-किफ़ाया है - अगर कुछ लोग यह करें तो बाक़ी बिरादरी से फ़र्ज़ उठ जाता है।

ग़ुस्ल कौन दे:

१. तरजीह:
   • शौहर बीवी को धो सकता है और बीवी शौहर को
   • एक ही जिंस वाले एक ही जिंस को धोएं
   • मर्द मर्दों को, ख़वातीन ख़वातीन को
   • क़रीबी ख़ानदान के अफ़राद को तरजीह

२. इस्तिसना:
   • शौहर बीवी को धो सकता है और बिलअक्स
   • छोटे बच्चों को कोई भी जिंस धो सकती है
   • मां छोटे बेटे को, बाप छोटी बेटी को धो सकते हैं

मय्यित के ग़ुस्ल का तरीक़ा:

पहला क़दम: तैयारी
• मय्यित को ऊंचे प्लेटफ़ॉर्म पर रखें
• शर्मगाह को कपड़े से ढांपें
• गर्म पानी तैयार करें (अगर मुमकिन हो)
• साबुन या बेरी के पत्ते (सिद्र) इस्तेमाल करें

दूसरा क़दम: पेट को हल्के से दबाएं
• फ़ुज़्ला निकालने के लिए आहिस्ता दबाएं
• जो नजासत निकले उसे साफ़ करें

तीसरा क़दम: वुज़ू जैसा धोना
• हाथ धोएं
• गीले कपड़े से चेहरा पोंछें
• कोहनियों तक बाज़ू पोंछें
• गीले कपड़े से सर पोंछें
• पांव पोंछें
• मुंह या नाक में पानी न जाने दें

चौथा क़दम: जिस्म धोएं
• पूरे जिस्म पर पानी डालें, पहले दायां तरफ़
• फिर बायां तरफ़
• 3 बार या इससे ज़्यादा धोएं (ताक़ नंबर)
• साबुन या सिद्र के पत्ते इस्तेमाल करें

पांचवां क़दम: आख़िरी धुलाई
• आख़िरी धुलाई के लिए काफ़ूर मिला पानी डालें
• यक़ीनी बनाएं कि तमाम हिस्से साफ़ हों

छठा क़दम: ख़ुश्क करें और कफ़न दें
• साफ़ कपड़े से जिस्म ख़ुश्क करें
• कफ़न में लपेटें

धुलाइयों की तादाद:
• कम अज़ कम: एक बार (तमाम जिस्म के हिस्से)
• सुन्नत: तीन बार, पांच बार, या सात बार
• हमेशा ताक़ नंबर इस्तेमाल करें

अहम रहनुमा उसूल:

१. परदा और एहतेराम:
   • हर वक़्त शर्मगाह को ढांपें
   • सिर्फ़ ज़रूरी लोग मौजूद हों
   • मय्यित की इज़्ज़त बरक़रार रखें
   • जिस्म पर नज़र आने वाले किसी ऐब को ज़ाहिर न करें

२. पानी की ज़रूरियात:
   • साफ़, पाक पानी इस्तेमाल करें
   • अगर दस्तियाब हो तो गर्म पानी बेहतर है
   • आख़िरी पानी में काफ़ूर मिलाएं

३. ग़ुस्ल देने के बाद:
   • जिसने ग़ुस्ल दिया उसे ख़ुद भी ग़ुस्ल करना चाहिए (तजवीज़ कर्दा)
   • या कम अज़ कम वुज़ू करें

४. ख़ास हालात:

शहीद:
   • जो जंग में शहीद हो
   • ग़ुस्ल नहीं दिया जाता
   • उन्हीं कपड़ों में दफ़न किया जाता है
   • ख़ून नहीं धोया जाता

इस्क़ात शुदा जनीन:
   • अगर 4 माह या ज़्यादा: ग़ुस्ल दें और नाम रखें
   • अगर 4 माह से कम: कपड़े में लपेट कर दफ़न करें

हैज़ में ख़ातून की वफ़ात:
   • फिर भी आम तौर पर ग़ुस्ल दें
   • मौत के साथ हैज़ की हालत ख़त्म हो गई

पानी न मिले:
   • मय्यित पर तयम्मुम करें
   • ज़िंदा शख़्स के तयम्मुम जैसा ही

जदीद तहफ़्फ़ुज़ात:

• पोस्ट मार्टम ग़ुस्ल में रुकावट नहीं
• अगर जिस्म ख़राब हो, जो धोया जा सके धोएं
• अगर मुकम्मल जिस्म दस्तियाब न हो, जो मौजूद हो धोएं
• हस्पताल के अमले को ख़ानदान को ग़ुस्ल देने की इजाज़त देनी चाहिए

ग़ुस्ल देते वक़्त दुआ:

"ا��لَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ"

"ऐ अल्लाह, इसे बख़्श दे, इस पर रहम कर, इसे आफ़ियत दे और इसके गुनाह माफ़ फ़रमा।"

नोट: ख़ातून मय्यित के लिए "लहा" इस्तेमाल करें।

यह एक बड़ा एज़ाज़ और ज़िम्मेदारी है। अल्लाह उनके लिए आसानी फ़रमाए जो यह फ़रीज़ा अदा करते हैं।''',
        'arabic': '''غسل الميت

إعطاء الغسل لمسلم متوفى هو فرض كفاية - إذا قام به البعض، يُرفع الالتزام عن بقية المجتمع.

من يقوم بالغسل:

١. التفضيل:
   • الزوج يمكنه غسل الزوجة والعكس
   • نفس الجنس يغسل نفس الجنس
   • الرجال يغسلون الرجال، النساء يغسلن النساء
   • يُفضل أفراد العائلة المقربون

٢. الاستثناءات:
   • الزوج يمكنه غسل الزوجة والعكس
   • الأطفال الصغار يمكن أن يغسلهم أي من الجنسين
   • الأم يمكنها غسل الابن الصغير، الأب يمكنه غسل البنت الصغيرة

طريقة غسل الميت:

الخطوة الأولى: التحضير
• ضع الميت على منصة مرتفعة
• غطِّ العورة بقماش
• جهز ماءً دافئًا (إن أمكن)
• استخدم صابونًا أو أوراق السدر

الخطوة الثانية: اضغط على البطن برفق
• اضغط برفق لإزالة أي فضلات
• نظف أي نجاسات تخرج

الخطوة الثالثة: غسل يشبه الوضوء
• اغسل اليدين
• امسح الوجه بقماش مبلل
• امسح الذراعين حتى المرفقين
• امسح الرأس بقماش مبلل
• امسح القدمين
• لا تدع الماء يدخل الفم أو الأنف

الخطوة الرابعة: اغسل الجسم
• صب الماء على الجسم كله، الجانب الأيمن أولاً
• ثم الجانب الأيسر
• اغسل 3 مرات أو أكثر (عدد فردي)
• استخدم الصابون أو أوراق السدر

الخطوة الخامسة: الغسل النهائي
• صب ماءً مخلوطًا بالكافور للغسل النهائي
• تأكد من تنظيف جميع الأجزاء

الخطوة السادسة: التجفيف والتكفين
• جفف الجسم بقماش نظيف
• لفه في الكفن

عدد مرات الغسل:
• الحد الأدنى: مرة واحدة (جميع أجزاء الجسم)
• السنة: ثلاث مرات، خمس مرات، أو سبع مرات
• استخدم دائمًا عددًا فرديًا

إرشادات مهمة:

١. الخصوصية والاحترام:
   • غطِّ العورة في جميع الأوقات
   • الأشخاص الضروريون فقط حاضرون
   • حافظ على كرامة الميت
   • لا تكشف أي عيوب تراها على الجسم

٢. متطلبات الماء:
   • استخدم ماءً نظيفًا وطاهرًا
   • الماء الدافئ أفضل إن توفر
   • أضف الكافور للماء الأخير

٣. بعد إعطاء الغسل:
   • الشخص الذي أعطى الغسل يجب أن يغتسل (مستحب)
   • أو على الأقل، يتوضأ

٤. حالات خاصة:

الشهيد:
   • من يموت في المعركة (شهيد في ساحة المعركة)
   • لا يُعطى غسلاً
   • يُدفن بنفس الملابس
   • الدم لا يُغسل

الجنين المُجهَض:
   • إذا كان 4 أشهر أو أكثر: أعطه غسلاً واسمًا
   • إذا كان أقل من 4 أشهر: لفه في قماش وادفنه

امرأة حائض تموت:
   • ما زال يُعطى الغسل بشكل طبيعي
   • حالة الحيض انتهت بالموت

لا يمكن إيجاد ماء:
   • قم بالتيمم للميت
   • نفس تيمم الشخص الحي

اعتبارات حديثة:

• التشريح لا يمنع الغسل
• إذا كان الجسم متضررًا، اغسل ما يمكن غسله
• إذا لم يكن الجسم الكامل متاحًا، اغسل ما هو موجود
• يجب على موظفي المستشفى السماح للعائلة بإجراء الغسل عندما يكون ذلك ممكنًا

الدعاء أثناء إعطاء الغسل:

"اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ"

"اللهم اغفر له وارحمه وعافه واعف عنه"

"اللهم اغفر له وارحمه واجعله في الجنة"

ملاحظة: استخدم "لها" للميت الأنثى.

هذا شرف عظيم ومسؤولية. جعل الله الأمر سهلاً على من يؤدي هذا الواجب.''',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F9F7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('ghusl'),
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
                // Ghusl Types List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ghuslTypes.length,
                  itemBuilder: (context, index) {
                    final ghusl = _ghuslTypes[index];
                    return _buildGhuslCard(
                      ghusl,
                      isDark,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGhuslCard(ghusl, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(ghusl['titleKey'] ?? 'ghusl');
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
        onTap: () => _showGhuslDetails(ghusl),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge (if has number field)
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
                    '${ghusl['number']}',
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
                      textDirection: (langCode == 'ur' || langCode == 'ar') ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                            ghusl['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('ghusl'),
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

  void _showGhuslDetails(Map<String, dynamic> ghusl) {
    final details = ghusl['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: ghusl['title'] ?? '',
          titleUrdu: ghusl['titleUrdu'] ?? '',
          titleHindi: ghusl['titleHindi'] ?? '',
          titleArabic: ghusl['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: ghusl['color'] as Color,
          icon: ghusl['icon'] as IconData,
          categoryKey: 'category_ghusl',
        ),
      ),
    );
  }
}
