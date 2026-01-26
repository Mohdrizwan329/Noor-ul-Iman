import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class KhutbaScreen extends StatefulWidget {
  const KhutbaScreen({super.key});

  @override
  State<KhutbaScreen> createState() => _KhutbaScreenState();
}

class _KhutbaScreenState extends State<KhutbaScreen> {
  String _selectedLanguage = 'english';


  final List<Map<String, dynamic>> _khutbaTypes = [
    {
      'titleKey': 'friday_khutba',
      'title': 'Jumu\'ah (Friday) Khutba',
      'titleUrdu': 'جمعہ کا خطبہ',
      'titleHindi': 'जुमा का ख़ुतबा',
      'titleArabic': 'خطبة الجمعة',
      'icon': Icons.mosque,
      'color': Colors.green,
      'details': {
        'english': '''Jumu'ah (Friday) Khutba

The Friday Khutba is an essential part of Jumu'ah prayer and is delivered before the prayer.

Structure of Friday Khutba:

First Khutba:
1. Begin with Hamd (Praise of Allah):
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ"

2. Shahada (Testimony):
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

3. Durood upon the Prophet ﷺ

4. Recite a verse from the Quran

5. Deliver the main sermon:
   • Remind about Taqwa (God-consciousness)
   • Discuss Islamic topics
   • Address current community issues
   • Give practical advice

6. Conclude with Dua

Second Khutba:
1. Begin with Hamd
2. Durood upon the Prophet ﷺ
3. Dua for Muslims
4. Dua for leaders and the community

After Second Khutba:
• Iqama is called
• 2 Rakats Fard prayer is performed

Conditions:
• Both Khutbas are Wajib (obligatory)
• Must be delivered in Arabic (main parts)
• Sermon can be in local language
• Khatib should stand on the Minbar
• Congregation should listen silently''',
        'arabic': '''خطبة الجمعة

خطبة الجمعة جزء أساسي من صلاة الجمعة وتُلقى قبل الصلاة.

بنية خطبة الجمعة:

الخطبة الأولى:
١. البداية بالحمد (حمد الله):
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ"

٢. الشهادة:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

٣. الصلاة على النبي ﷺ

٤. تلاوة آية من القرآن

٥. إلقاء الموعظة الرئيسية:
   • التذكير بالتقوى
   • مناقشة المواضيع الإسلامية
   • معالجة قضايا المجتمع الحالية
   • تقديم النصائح العملية

٦. الختام بالدعاء

الخطبة الثانية:
١. البداية بالحمد
٢. الصلاة على النبي ﷺ
٣. الدعاء للمسلمين
٤. الدعاء للقادة والمجتمع

بعد الخطبة الثانية:
• تُقام الصلاة
• تُصلى ركعتا الفرض

الشروط:
• كلتا الخطبتين واجبة
• يجب أن تُلقى باللغة العربية (الأجزاء الرئيسية)
• يمكن أن تكون الموعظة باللغة المحلية
• ينبغي للخطيب أن يقف على المنبر
• يجب على الجماعة الاستماع بصمت''',
        'urdu': '''جمعہ کا خطبہ

جمعہ کا خطبہ نماز جمعہ کا لازمی حصہ ہے اور نماز سے پہلے دیا جاتا ہے۔

جمعہ کے خطبے کی ترتیب:

پہلا خطبہ:
۱۔ حمد سے شروع کریں:
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ"

۲۔ شہادت:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

۳۔ نبی کریم ﷺ پر درود

۴۔ قرآن کی کوئی آیت پڑھیں

۵۔ اصل وعظ دیں:
   • تقویٰ کی یاد دہانی
   • اسلامی موضوعات پر گفتگو
   • کمیونٹی کے موجودہ مسائل
   • عملی نصیحت

۶۔ دعا کے ساتھ اختتام

دوسرا خطبہ:
۱۔ حمد سے شروع کریں
۲۔ نبی کریم ﷺ پر درود
۳۔ مسلمانوں کے لیے دعا
۴۔ حکمرانوں اور کمیونٹی کے لیے دعا

دوسرے خطبے کے بعد:
• اقامت کہی جاتی ہے
• 2 رکعت فرض نماز پڑھی جاتی ہے

شرائط:
• دونوں خطبے واجب ہیں
• عربی میں ہونے چاہیے (اہم حصے)
• وعظ مقامی زبان میں ہو سکتا ہے
• خطیب منبر پر کھڑا ہو
• جماعت خاموشی سے سنے''',
        'hindi': '''जुमा का ख़ुतबा

जुमा का ख़ुतबा नमाज़-ए-जुमा का लाज़मी हिस्सा है और नमाज़ से पहले दिया जाता है।

जुमा के ख़ुतबे की तरतीब:

पहला ख़ुतबा:
१. हम्द से शुरू करें:
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ"

२. शहादत:
"أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

३. नबी करीम ﷺ पर दुरूद

४. क़ुरआन की कोई आयत पढ़ें

५. असल वाज़ दें:
   • तक़वा की याद दहानी
   • इस्लामी मौज़ूआत पर गुफ़्तगू
   • कम्युनिटी के मौजूदा मसाइल
   • अमली नसीहत

६. दुआ के साथ इख़्तिताम

दूसरा ख़ुतबा:
१. हम्द से शुरू करें
२. नबी करीम ﷺ पर दुरूद
३. मुसलमानों के लिए दुआ
४. हुक्मरानों और कम्युनिटी के लिए दुआ

दूसरे ख़ुतबे के बाद:
• इक़ामत कही जाती है
• 2 रकअत फ़र्ज़ नमाज़ पढ़ी जाती है

शराइत:
• दोनों ख़ुतबे वाजिब हैं
• अरबी में होने चाहिए (अहम हिस्��े)
• वाज़ मक़ामी ज़बान में हो सकता है
• ख़तीब मिंबर पर खड़ा हो
• जमाअत ख़ामोशी से सुने''',
      },
    },
    {
      'titleKey': 'khutba_1_eid_khutba',
      'title': 'Eid Khutba',
      'titleUrdu': 'عید کا خطبہ',
      'titleHindi': 'ईद का ख़ुतबा',
      'titleArabic': 'خطبة العيد',
      'icon': Icons.celebration,
      'color': Colors.orange,
      'details': {
        'english': '''Eid Khutba

The Eid Khutba is delivered AFTER the Eid prayer, unlike the Friday Khutba which is before the prayer.

Structure:

First Khutba:
1. Begin with Takbir:
"اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ"
(Allahu Akbar, Allahu Akbar, Allahu Akbar)

2. Continue with more Takbirat (9 times in first Khutba)

3. Hamd and Shahada

4. Durood upon the Prophet ﷺ

5. Sermon specific to the Eid:

   For Eid ul-Fitr:
   • Importance of Ramadan completed
   • Sadaqat ul-Fitr
   • Gratitude for fasting
   • Continuing good deeds

   For Eid ul-Adha:
   • Story of Ibrahim (AS) and Ismail (AS)
   • Spirit of sacrifice
   • Rules of Qurbani
   • Takbirat of Tashriq

6. Dua

Second Khutba:
1. Begin with Takbirat (7 times)
2. Hamd and Durood
3. Dua for the Ummah
4. Practical guidance

Key Differences from Jumu'ah:
• Delivered AFTER the prayer (not before)
• Begins with Takbirat (not Hamd)
• More Takbirat throughout
• Listening is Sunnah (not Wajib like Jumu'ah)
• People may leave before the Khutba (though not recommended)''',
        'urdu': '''عید کا خطبہ

عید کا خطبہ نماز عید کے بعد دیا جاتا ہے، جمعہ کے خطبے کے برعکس جو نماز سے پہلے ہوتا ہے۔

ترتیب:

پہلا خطبہ:
۱۔ تکبیر سے شروع کریں:
"اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ"

۲۔ مزید تکبیرات کہیں (پہلے خطبے میں 9 بار)

۳۔ حمد اور شہادت

۴۔ نبی کریم ﷺ پر درود

۵۔ عید کے مطابق وعظ:

   عید الفطر کے لیے:
   • مکمل ہونے والے رمضان کی اہمیت
   • صدقۃ الفطر
   • روزوں پر شکر
   • نیک اعمال جاری رکھنا

   عید الاضحیٰ کے لیے:
   • ابراہیم علیہ السلام اور اسماعیل علیہ السلام کا قصہ
   • قربانی کی روح
   • قربانی کے احکام
   • تکبیرات تشریق

۶۔ دعا

دوسرا خطبہ:
۱۔ تکبیرات سے شروع کریں (7 بار)
۲۔ حمد اور درود
۳۔ امت کے لیے دعا
۴۔ عملی رہنمائی

جمعہ سے فرق:
• نماز کے بعد دیا جاتا ہے (پہلے نہیں)
• تکبیرات سے شروع ہوتا ہے (حمد سے نہیں)
• پورے خطبے میں زیادہ تکبیرات
• سننا سنت ہے (جمعہ کی طرح واجب نہیں)
• لوگ خطبے سے پہلے جا سکتے ہیں (اگرچہ مستحب نہیں)''',
        'hindi': '''ईद का ख़ुतबा

ईद का ख़ुतबा नमाज़-ए-ईद के बाद दिया जाता है, जुमा के ख़ुतबे के बरअक्स जो नमाज़ से पहले होता है।

तरतीब:

पहला ख़ुतबा:
१. तकबीर से शुरू करें:
"اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ"

२. मज़ीद तकबीरात कहें (पहले ख़ुतबे में 9 बार)

३. हम्द और शहादत

४. नबी करीम ﷺ पर दुरूद

५. ईद के मुताबिक़ वाज़:

   ईद उल-फ़ित्र के लिए:
   • मुकम्मल होने वाले रमज़ान की अहमियत
   • सदक़तुल-फ़ित्र
   • रोज़ों पर शुक्र
   • नेक आमाल जारी रखना

   ईद उल-अज़्हा के लिए:
   • इब्राहीम अलैहिस्सलाम और इस्माइल अलैहिस्सलाम का क़िस्सा
   • क़ुर्बानी की रूह
   • क़ुर्बानी के अहकाम
   • तकबीरात-ए-तशरीक़

६. दुआ

दूसरा ख़ुतबा:
१. तकबीरात से शुरू करें (7 बार)
२. हम्द और दुरूद
३. उम्मत के लिए दुआ
४. अमली रहनुमाई

जुमा से फ़र्क़:
• नमाज़ के बाद दिया जाता है (पहले नहीं)
• तकबीरात से शुरू होता है (हम्द से नहीं)
• पूरे ख़ुतबे में ज़्यादा तकबीरात
• सुनना सुन्नत है (जुमा की तरह वाजिब नहीं)
• लोग ख़ुतबे से पहले जा सकते हैं (अगरचे मुस्तहब नहीं)''',
        'arabic': '''خطبة العيد

تُلقى خطبة العيد بعد صلاة العيد، بخلاف خطبة الجمعة التي تُلقى قبل الصلاة.

البنية:

الخطبة الأولى:
١. البداية بالتكبير:
"اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ"

٢. الاستمرار بالتكبيرات (٩ مرات في الخطبة الأولى)

٣. الحمد والشهادة

٤. الصلاة على النبي ﷺ

٥. موعظة خاصة بالعيد:

   لعيد الفطر:
   • أهمية إتمام رمضان
   • زكاة الفطر
   • الشكر على الصيام
   • مواصلة الأعمال الصالحة

   لعيد الأضحى:
   • قصة إبراهيم عليه السلام وإسماعيل عليه السلام
   • روح التضحية
   • أحكام الأضحية
   • تكبيرات التشريق

٦. الدعاء

الخطبة الثانية:
١. البداية بالتكبيرات (٧ مرات)
٢. الحمد والصلاة على النبي ﷺ
٣. الدعاء للأمة
٤. التوجيه العملي

الفروق عن خطبة الجمعة:
• تُلقى بعد الصلاة (وليس قبلها)
• تبدأ بالتكبيرات (وليس بالحمد)
• تكبيرات أكثر خلال الخطبة
• الاستماع سنة (وليس واجباً كخطبة الجمعة)
• يمكن للناس المغادرة قبل الخطبة (رغم أنه غير مستحب)''',
      },
    },
    {
      'titleKey': 'khutba_2_nikah_khutba',
      'title': 'Nikah Khutba',
      'titleUrdu': 'نکاح کا خطبہ',
      'titleHindi': 'निकाह का ख़ुतबा',
      'titleArabic': 'خطبة النكاح',
      'icon': Icons.favorite,
      'color': Colors.red,
      'details': {
        'english': '''Nikah (Marriage) Khutba

The Nikah Khutba is delivered before the marriage contract. It is Sunnah and brings blessings to the marriage.

The Sunnah Nikah Khutba:

Begin with Hamd:
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا"

"All praise is due to Allah. We praise Him, seek His help, seek His forgiveness, and seek refuge in Allah from the evil of our souls and the evil of our deeds."

Shahada:
"مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

Three Quranic Verses:

1. Surah An-Nisa (4:1):
"يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُمْ مِنْ نَفْسٍ وَاحِدَةٍ..."

2. Surah Al-Ahzab (33:70-71):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَقُولُوا قَوْلًا سَدِيدًا..."

3. Surah Aal-Imran (3:102):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ..."

After the Khutba:
• Bride and groom's consent is taken
• Mahr (dowry) is announced
• Witnesses attest
• Dua for the couple:
"بَارَكَ اللَّهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"May Allah bless you and shower blessings upon you and bring you together in goodness."''',
        'urdu': '''نکاح کا خطبہ

نکاح کا خطبہ عقد نکاح سے پہلے دیا جاتا ہے۔ یہ سنت ہے اور نکاح میں برکت لاتا ہے۔

سنت نکاح خطبہ:

حمد سے شروع کریں:
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّ��َاتِ أَعْمَالِنَا"

"تمام تعریف اللہ کے لیے ہے۔ ہم اس کی تعریف کرتے ہیں، اس سے مدد مانگتے ہیں، اس سے مغفرت چاہتے ہیں، اور اللہ کی پناہ مانگتے ہیں اپنے نفس کی برائی سے اور اپنے اعمال کی برائی سے۔"

شہادت:
"مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

تین قرآنی آیات:

۱۔ سورۃ النساء (4:1):
"يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُمْ مِنْ نَفْسٍ وَاحِدَةٍ..."

۲۔ سورۃ الاحزاب (33:70-71):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَقُولُوا قَوْلًا سَدِيدًا..."

۳۔ سورۃ آل عمران (3:102):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ..."

خطبے کے بعد:
• دولہا دلہن کی رضامندی لی جاتی ہے
• مہر کا اعلان ہوتا ہے
• گواہ گواہی دیتے ہیں
• جوڑے کے لیے دعا:
"بَارَكَ اللَّهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"اللہ تمہیں برکت دے اور تم پر برکتیں نازل کرے اور تم دونوں کو خیر میں جمع رکھے۔"''',
        'hindi': '''निकाह का ख़ुतबा

निकाह का ख़ुतबा अक़्द-ए-निकाह से पहले दिया जाता है। यह सुन्नत है और निकाह में बरकत लाता है।

सुन्नत निकाह ख़ुतबा:

हम्द से शुरू करें:
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا"

"तमाम तारीफ़ अल्लाह के लिए है। हम उसकी तारीफ़ करते हैं, उससे मदद मांगते हैं, उससे मग़फ़िरत चाहते हैं, और अल्लाह की पनाह मांगते हैं अपने नफ़्स की बुराई से और अपने आमाल की बुराई से।"

शहादत:
"مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

तीन क़ुरआनी आयात:

१. सूरह अन-निसा (4:1):
"يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُمْ مِنْ نَفْسٍ وَاحِدَةٍ..."

२. सूरह अल-अहज़ाब (33:70-71):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَقُولُوا قَوْلًا سَدِيدًا..."

३. सूरह आल-इमरान (3:102):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ..."

ख़ुतबे के बाद:
• दूल्हा-दुल्हन की रज़ामंदी ली जाती है
• मेहर का एलान होता है
• गवाह गवाही देते हैं
• जोड़े के लिए दुआ:
"بَارَكَ اللَّهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"अल्लाह तुम्हें बरकत दे और तुम पर बरकतें नाज़िल करे और तुम दोनों को ख़ैर में जमा रखे।"''',
        'arabic': '''خطبة النكاح

تُلقى خطبة النكاح قبل عقد الزواج. إنها سنة وتجلب البركة للزواج.

خطبة النكاح المسنونة:

البداية بالحمد:
"الْحَمْدُ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا"

"الحمد لله، نحمده ونستعينه ونستغفره، ونعوذ بالله من شرور أنفسنا ومن سيئات أعمالنا."

الشهادة:
"مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

ثلاث آيات قرآنية:

١. سورة النساء (٤:١):
"يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُمْ مِنْ نَفْسٍ وَاحِدَةٍ..."

٢. سورة الأحزاب (٣٣:٧٠-٧١):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَقُولُوا قَوْلًا سَدِيدًا..."

٣. سورة آل عمران (٣:١٠٢):
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ..."

بعد الخطبة:
• يُؤخذ موافقة العروس والعريس
• يُعلن عن المهر
• يشهد الشهود
• الدعاء للزوجين:
"بَارَكَ اللَّهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"بارك الله لك وبارك عليك وجمع بينكما في خير."''',
      },
    },
    {
      'titleKey': 'khutba_3_etiquette_of_listening',
      'title': 'Etiquette of Listening',
      'titleUrdu': 'خطبہ سننے کے آداب',
      'titleHindi': 'ख़ुतबा सुनने के आदाब',
      'titleArabic': 'آداب الاستماع للخطبة',
      'icon': Icons.hearing,
      'color': Colors.blue,
      'details': {
        'english': '''Etiquette of Listening to the Khutba

For Friday Khutba:

1. Arrive Early:
   • Come to the masjid early
   • The earlier you arrive, the more reward

2. Sit Close to the Imam:
   • Try to sit in the front rows
   • Don't step over people's shoulders

3. Listen in Complete Silence:
   • No talking during the Khutba
   • The Prophet ﷺ said: "If you tell your companion to be quiet during the Friday Khutba, you have engaged in idle talk." (Sahih Bukhari)

4. Face the Khatib:
   • Turn toward the Imam
   • Give full attention

5. Don't Fidget:
   • Avoid playing with clothes, prayer beads, phone
   • Sit still and attentively

6. Don't Greet or Respond:
   • If someone says Salaam, don't respond verbally
   • You can respond after the Khutba

7. Don't Pray During Khutba:
   • Except for Tahiyyatul Masjid (2 quick rakats when you first enter)
   • Even this should be brief

8. Avoid Leaving During Khutba:
   • Unless there's an emergency
   • Wait until the prayer is complete

9. Make Dua During Pauses:
   • When the Imam pauses, make silent dua

10. Apply What You Learn:
    • The Khutba is guidance - implement it in life

Reward:
The Prophet ﷺ said: "Whoever performs Ghusl on Friday, comes early, walks and doesn't ride, sits close to the Imam, listens and doesn't engage in idle talk, for every step he takes he will have the reward of a year of fasting and praying." (Sunan Abu Dawud)''',
        'urdu': '''خطبہ سننے کے آداب

جمعہ کے خطبے کے لیے:

۱۔ جلدی آئیں:
   • مسجد جلدی آئیں
   • جتنی جلدی آئیں گے اتنا زیادہ ثواب

۲۔ امام کے قریب بیٹھیں:
   • اگلی صفوں میں بیٹھنے کی کوشش کریں
   • لوگوں کے کندھوں پر سے نہ گزریں

۳۔ مکمل خاموشی سے سنیں:
   • خطبے کے دوران بات نہ کریں
   • نبی کریم ﷺ نے فرمایا: "اگر تم نے جمعہ کے خطبے کے دوران اپنے ساتھی سے خاموش رہنے کو کہا تو تم نے فضول بات کی۔" (صحیح بخاری)

۴۔ خطیب کی طرف رخ کریں:
   • امام کی طرف رخ کریں
   • پوری توجہ دیں

۵۔ بے چین نہ ہوں:
   • کپڑوں، تسبیح، فون سے کھیلنے سے بچیں
   • توجہ سے بیٹھیں

۶۔ سلام نہ کریں نہ جواب دیں:
   • اگر کوئی سلام کہے تو زبانی جواب نہ دیں
   • خطبے کے بعد جواب دے سکتے ہیں

۷۔ خطبے کے دوران نماز نہ پڑھیں:
   • سوائے تحیۃ المسجد کے (داخل ہوتے وقت 2 مختصر رکعت)
   • یہ بھی مختصر ہونی چاہیے

۸۔ خطبے کے دوران جانے سے بچیں:
   • جب تک ایمرجنسی نہ ہو
   • نماز مکمل ہونے تک انتظار کریں

۹۔ وقفوں میں دعا کریں:
   • جب امام رکے تو خاموشی سے دعا کریں

۱۰۔ جو سیکھیں اسے عمل میں لائیں:
    • خطبہ ہدایت ہے - زندگی میں لاگو کریں

ثواب:
نبی کریم ﷺ نے فرمایا: "جو شخص جمعہ کو غسل کرے، جلدی آئے، پیدل چل کر آئے سوار نہ ہو، امام کے قریب بیٹھے، سنے اور فضول بات نہ کرے، اس کے ہر قدم کے بدلے اسے ایک سال کے روزے اور نماز کا ثواب ملے گا۔" (سنن ابو داؤد)''',
        'hindi': '''ख़ुतबा सुनने के आदाब

जुमा के ख़ुतबे के लिए:

१. जल्दी आएं:
   • मस्जिद जल्दी आएं
   • जितनी जल्दी आएंगे उतना ज़्यादा सवाब

२. इमाम के क़रीब बैठें:
   • अगली सफ़ों में बैठने की कोशिश करें
   • लोगों के कंधों पर से न गुज़रें

३. मुकम्मल ख़ामोशी से सुनें:
   • ख़ुतबे के दौरान बात न करें
   • नबी करीम ﷺ ने फ़रमाया: "अगर तुमने जुमा के ख़ुतबे के दौरान अपने साथी से ख़ामोश रहने को कहा तो तुमने फ़ुज़ूल बात की।" (सहीह बुख़ारी)

४. ख़तीब की तरफ़ रुख़ करें:
   • इमाम की तरफ़ रुख़ करें
   • पूरी तवज्जो दें

५. बेचैन न हों:
   • कपड़ों, तस्बीह, फ़ोन से खेलने से बचें
   • तवज्जो से बैठें

६. सलाम न करें न जवाब दें:
   • अगर कोई सलाम कहे तो ज़बानी जवाब न दें
   • ख़ुतबे के बाद जवाब दे सकते हैं

७. ख़ुतबे के दौरान नमाज़ न पढ़ें:
   • सिवाए तहियतुल मस्जिद के (दाख़िल होते वक़्त 2 मुख़्तसर रकअत)
   • यह भी मुख़्तसर होनी चाहिए

८. ख़ुतबे के दौरान जाने से बचें:
   • जब तक इमरजेंसी न हो
   • नमाज़ मुकम्मल होने तक इंतेज़ार करें

९. वक़्फ़ों में दुआ करें:
   • जब इमाम रुके तो ख़ामोशी से दुआ करें

१०. जो सीखें उसे अमल में लाएं:
    • ख़ुतबा हिदायत है - ज़िंदगी में लागू करें

सवाब:
नबी करीम ﷺ ने फ़रमाया: "जो शख़्स जुमा को ग़ुस्ल करे, जल्दी आए, पैदल चलकर आए सवार न हो, इमाम के क़रीब बैठे, सुने और फ़ुज़ूल बात न करे, उसके हर क़दम के बदले उसे एक साल के रोज़े और नमाज़ का सवाब मिलेगा।" (सुनन अबू दाऊद)''',
        'arabic': '''آداب الاستماع للخطبة

لخطبة الجمعة:

١. الحضور مبكراً:
   • الحضور إلى المسجد مبكراً
   • كلما جئت مبكراً، كان الأجر أعظم

٢. الجلوس قرب الإمام:
   • حاول الجلوس في الصفوف الأولى
   • لا تتخطى رقاب الناس

٣. الاستماع بصمت تام:
   • لا تتحدث أثناء الخطبة
   • قال النبي ﷺ: "إذا قلت لصاحبك أنصت يوم الجمعة والإمام يخطب فقد لغوت." (صحيح البخاري)

٤. التوجه نحو الخطيب:
   • اتجه نحو الإمام
   • أعطِ انتباهك الكامل

٥. عدم العبث:
   • تجنب اللعب بالثياب أو السبحة أو الهاتف
   • اجلس بانتباه وسكون

٦. عدم رد السلام:
   • إذا سلم عليك أحد فلا ترد عليه لفظاً
   • يمكنك الرد بعد انتهاء الخطبة

٧. عدم الصلاة أثناء الخطبة:
   • إلا تحية المسجد (ركعتان سريعتان عند الدخول)
   • حتى هذه يجب أن تكون موجزة

٨. تجنب المغادرة أثناء الخطبة:
   • إلا في حالة الطوارئ
   • انتظر حتى تنتهي الصلاة

٩. الدعاء عند التوقف:
   • عندما يتوقف الإمام، ادعُ في نفسك

١٠. تطبيق ما تتعلم:
    • الخطبة هي إرشاد - طبقه في حياتك

الأجر:
قال النبي ﷺ: "من اغتسل يوم الجمعة، وبكر وابتكر، ومشى ولم يركب، ودنا من الإمام فاستمع ولم يلغ، كان له بكل خطوة عمل سنة أجر صيامها وقيامها." (سنن أبي داود)''',
      },
    },
    {
      'titleKey': 'khutba_4_khutba_samples',
      'title': 'Khutba Samples',
      'titleUrdu': 'خطبہ کے نمونے',
      'titleHindi': 'ख़ुतबा के नमूने',
      'titleArabic': 'نماذج الخطب',
      'icon': Icons.article,
      'color': Colors.purple,
      'details': {
        'english': '''Sample Khutba Opening (Arabic with Translation)

Opening of First Khutba:

"إِنَّ الْحَمْدَ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ"

"Indeed, all praise is due to Allah. We praise Him, seek His help, and ask for His forgiveness. We seek refuge in Allah from the evil within ourselves and from our wrongful deeds. Whoever Allah guides, none can misguide, and whoever He leaves astray, none can guide."

"وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"I bear witness that there is no god but Allah alone, without partner, and I bear witness that Muhammad is His slave and messenger."

Taqwa Verse:
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مُّسْلِمُونَ"

"O you who believe! Fear Allah as He should be feared, and die not except in a state of Islam."

Opening of Second Khutba:

"الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ وَالصَّلَاةُ وَالسَّلَامُ عَلَى أَشْرَفِ الْأَنْبِيَاءِ وَالْمُرْسَلِينَ سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ أَجْمَعِينَ"

"All praise is due to Allah, Lord of the worlds. Peace and blessings be upon the most noble of the prophets and messengers, our master Muhammad, and upon his family and all his companions."

Closing Dua:
"رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"

"Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire."

"عِبَادَ اللَّهِ إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيتَاءِ ذِي الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنكَرِ وَالْبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُونَ"

"Servants of Allah, indeed Allah commands justice, excellence, and giving to relatives, and forbids immorality, bad conduct, and oppression. He admonishes you that perhaps you will be reminded."

"أَقُولُ قَوْلِي هَذَا وَأَسْتَغْفِرُ اللَّهَ لِي وَلَكُمْ"
"I say this and ask Allah's forgiveness for myself and for you."''',
        'urdu': '''خطبے کے نمونے (عربی مع ترجمہ)

پہلے خطبے کا آغاز:

"إِنَّ الْحَمْدَ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ"

"بے شک تمام تعریف اللہ کے لیے ہے۔ ہم اس کی تعریف کرتے ہیں، اس سے مدد مانگتے ہیں، اور اس سے مغفرت چاہتے ہیں۔ ہم اللہ کی پناہ مانگتے ہیں اپنے نفس کی برائی سے اور اپنے برے اعمال سے۔ جسے اللہ ہدایت دے اسے کوئی گمراہ نہیں کر سکتا، اور جسے وہ گمراہ کر دے اسے کوئی ہدایت نہیں دے سکتا۔"

"وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"میں گواہی دیتا ہوں ک�� اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اور میں گواہی دیتا ہوں کہ محمد ﷺ اس کے بندے اور رسول ہیں۔"

تقویٰ کی آیت:
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مُّسْلِمُونَ"

"اے ایمان والو! اللہ سے ڈرو جیسا اس سے ڈرنے کا حق ہے، اور نہ مرو مگر اس حالت میں کہ تم مسلمان ہو۔"

دوسرے خطبے کا آغاز:

"الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ وَالصَّلَاةُ وَالسَّلَامُ عَلَى أَشْرَفِ الْأَنْبِيَاءِ وَالْمُرْسَلِينَ سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ أَجْمَعِينَ"

"تمام تعریف اللہ رب العالمین کے لیے ہے۔ درود و سلام ہو انبیاء و مرسلین میں سب سے افضل ہمارے سردار محمد ﷺ پر اور ان کی آل اور تمام صحابہ پر۔"

اختتامی دعا:
"رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"

"اے ہمارے رب! ہمیں دنیا میں بھلائی دے اور آخرت میں بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔"''',
        'hindi': '''ख़ुतबे के नमूने (अरबी मअ तर्जुमा)

पहले ख़ुतबे का आग़ाज़:

"إِنَّ الْحَمْدَ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ"

"बेशक तमाम तारीफ़ अल्लाह के लिए है। हम उसकी तारीफ़ करते हैं, उससे मदद मांगते हैं, और उससे मग़फ़िरत चाहते हैं। हम अल्लाह की पनाह मांगते हैं अपने नफ़्स की बुराई से और अपने बुरे आमाल से। जिसे अल्लाह हिदायत दे उसे कोई गुमराह नहीं कर सकता, और जिसे वो गुमराह कर दे उसे कोई हिदायत नहीं दे सकता।"

"وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"मैं गवाही देता हूं कि अल्लाह के सिवा कोई माबूद नहीं, वो अकेला है, उसका कोई शरीक नहीं, और मैं गवाही देता हूं कि मुहम्मद ﷺ उसके बंदे और रसूल हैं।"

तक़वा की आयत:
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مُّسْلِمُونَ"

"ऐ ईमान वालो! अल्लाह से डरो जैसा उससे डरने का हक़ है, और न मरो मगर इस हालत में कि तुम मुसलमान हो।"

दूसरे ख़ुतबे का आग़ाज़:

"الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ وَالصَّلَاةُ وَالسَّلَامُ عَلَى أَشْرَفِ الْأَنْبِيَاءِ وَالْمُرْسَلِينَ سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ أَجْمَعِينَ"

"तमाम तारीफ़ अल्लाह रब्बुल-आलमीन के लिए है। दुरूद व सलाम हो अंबिया व मुरसलीन में सबसे अफ़ज़ल हमारे सरदार मुहम्मद ﷺ पर और उनकी आल और तमाम सहाबा पर।"

इख़्तितामी दुआ:
"رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"

"ऐ हमारे रब! हमें दुनिया में भलाई दे और आख़िरत में भलाई दे और हमें आग के अज़ाब से बचा।"''',
        'arabic': '''نماذج افتتاح الخطبة (بالعربية مع الترجمة)

افتتاح الخطبة الأولى:

"إِنَّ الْحَمْدَ لِلَّهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ وَنَعُوذُ بِاللَّهِ مِنْ شُرُورِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا مَنْ يَهْدِهِ اللَّهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ"

"إن الحمد لله، نحمده ونستعينه ونستغفره، ونعوذ بالله من شرور أنفسنا ومن سيئات أعمالنا. من يهده الله فلا مضل له، ومن يضلل فلا هادي له."

"وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ"

"أشهد أن لا إله إلا الله وحده لا شريك له، وأشهد أن محمداً عبده ورسوله."

آية التقوى:
"يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مُّسْلِمُونَ"

"يا أيها الذين آمنوا اتقوا الله حق تقاته ولا تموتن إلا وأنتم مسلمون."

افتتاح الخطبة الثانية:

"الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ وَالصَّلَاةُ وَالسَّلَامُ عَلَى أَشْرَفِ الْأَنْبِيَاءِ وَالْمُرْسَلِينَ سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ أَجْمَعِينَ"

"الحمد لله رب العالمين، والصلاة والسلام على أشرف الأنبياء والمرسلين، سيدنا محمد وعلى آله وصحبه أجمعين."

دعاء الختام:
"رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"

"ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار."

"عِبَادَ اللَّهِ إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيتَاءِ ذِي الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنكَرِ وَالْبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُونَ"

"عباد الله، إن الله يأمر بالعدل والإحسان وإيتاء ذي القربى، وينهى عن الفحشاء والمنكر والبغي، يعظكم لعلكم تذكرون."

"أَقُولُ قَوْلِي هَذَا وَأَسْتَغْفِرُ اللَّهَ لِي وَلَكُمْ"
"أقول قولي هذا وأستغفر الله لي ولكم."''',
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('khutba'),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _khutbaTypes.length,
              itemBuilder: (context, index) => _buildKhutbaCard(
                _khutbaTypes[index],
                isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKhutbaCard(khutba, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(khutba['titleKey'] ?? 'khutba');
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
        onTap: () => _showKhutbaDetails(khutba),
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
                    khutba['icon'] as IconData,
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
                            khutba['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          SizedBox(width: responsive.spacing(4)),
                          Flexible(
                            child: Text(
                              context.tr(khutba['titleKey'] ?? 'khutba'),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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

  void _showKhutbaDetails(Map<String, dynamic> khutba) {
    final details = khutba['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: khutba['title'] ?? '',
          titleUrdu: khutba['titleUrdu'] ?? '',
          titleHindi: khutba['titleHindi'] ?? '',
          titleArabic: khutba['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: khutba['color'] as Color,
          icon: khutba['icon'] as IconData,
          categoryKey: 'category_khutba',
        ),
      ),
    );
  }
}
