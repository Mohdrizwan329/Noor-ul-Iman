import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class GhuslScreen extends StatefulWidget {
  const GhuslScreen({super.key});

  @override
  State<GhuslScreen> createState() => _GhuslScreenState();
}

class _GhuslScreenState extends State<GhuslScreen> {
  String _selectedLanguage = 'english';


  final List<Map<String, dynamic>> _ghuslTypes = [
    {
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
      body: SingleChildScrollView(
        padding: context.responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
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
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    ghusl['icon'] as IconData,
                    color: Colors.white,
                    size: responsive.textLarge,
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

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
                      textDirection: langCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
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
                          SizedBox(width: responsive.spacing(4)),
                          Text(
                            context.tr('ghusl'),
                            style: TextStyle(
                              fontSize: responsive.textXSmall,
                              fontWeight: FontWeight.w600,
                              color: emeraldGreen,
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
