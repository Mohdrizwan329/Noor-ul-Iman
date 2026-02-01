import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class AzanScreen extends StatefulWidget {
  const AzanScreen({super.key});

  @override
  State<AzanScreen> createState() => _AzanScreenState();
}

class _AzanScreenState extends State<AzanScreen> {
  final List<Map<String, dynamic>> _sections = [
    {
      'number': 1,
      'titleKey': 'azan_1_complete_azan_text',
      'title': 'Complete Azan Text',
      'titleUrdu': 'مکمل اذان',
      'titleHindi': 'मुकम्मल अज़ान',
      'titleArabic': 'نص الأذان الكامل',
      'icon': Icons.record_voice_over,
      'color': Colors.green,
      'details': {
        'english': '''Complete Azan (Call to Prayer)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
Allahu Akbar, Allahu Akbar
(Allah is the Greatest, Allah is the Greatest)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
Allahu Akbar, Allahu Akbar
(Allah is the Greatest, Allah is the Greatest)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
Ash-hadu an la ilaha illallah
(I bear witness that there is no god but Allah)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
Ash-hadu an la ilaha illallah
(I bear witness that there is no god but Allah)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
Ash-hadu anna Muhammadar Rasulullah
(I bear witness that Muhammad is the Messenger of Allah)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
Ash-hadu anna Muhammadar Rasulullah
(I bear witness that Muhammad is the Messenger of Allah)

حَيَّ عَلَى الصَّلَاةِ
Hayya 'alas-Salah
(Come to prayer)

حَيَّ عَلَى الصَّلَاةِ
Hayya 'alas-Salah
(Come to prayer)

حَيَّ عَلَى الْفَلَاحِ
Hayya 'alal-Falah
(Come to success)

حَيَّ عَلَى الْفَلَاحِ
Hayya 'alal-Falah
(Come to success)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
Allahu Akbar, Allahu Akbar
(Allah is the Greatest, Allah is the Greatest)

لَا إِلَٰهَ إِلَّا اللَّهُ
La ilaha illallah
(There is no god but Allah)

For Fajr Azan - Add after "Hayya 'alal-Falah":
الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ
As-Salatu khayrum minan-nawm
(Prayer is better than sleep)
(Recite twice)''',
        'urdu': '''مکمل اذان

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
اللہ اکبر، اللہ اکبر
(اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
اللہ اکبر، اللہ اکبر
(اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
اشھد ان لا الہ الا اللہ
(میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
اشھد ان لا الہ الا اللہ
(میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
اشھد ان محمدا رسول اللہ
(میں گواہی دیتا ہوں کہ محمد ﷺ اللہ کے رسول ہیں)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
اشھد ان محمدا رسول اللہ
(میں گواہی دیتا ہوں کہ محمد ﷺ اللہ کے رسول ہیں)

حَيَّ عَلَى الصَّلَاةِ
حی علی الصلوٰۃ
(نماز کی طرف آؤ)

حَيَّ عَلَى الصَّلَاةِ
حی علی الصلوٰۃ
(نماز کی طرف آؤ)

حَيَّ عَلَى الْفَلَاحِ
حی علی الفلاح
(کامیابی کی طرف آؤ)

حَيَّ عَلَى الْفَلَاحِ
حی علی الفلاح
(کامیابی کی طرف آؤ)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
اللہ اکبر، اللہ اکبر
(اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے)

لَا إِلَٰهَ إِلَّا اللَّهُ
لا الہ الا اللہ
(اللہ کے سوا کوئی معبود نہیں)

فجر کی اذان میں - "حی علی الفلاح" کے بعد اضافہ:
الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ
الصلوٰۃ خیر من النوم
(نماز نیند سے بہتر ہے)
(دو بار پڑھیں)''',
        'hindi': '''मुकम्मल अज़ान

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
अल्लाहु अकबर, अल्लाहु अकबर
(अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
अल्लाहु अकबर, अल्लाहु अकबर
(अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
अश्हदु अन ला इलाहा इल्लल्लाह
(मैं गवाही देता हूं कि अल्लाह के सिवा कोई माबूद नहीं)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
अश्हदु अन ला इलाहा इल्लल्लाह
(मैं गवाही देता हूं कि अल्लाह के सिवा कोई माबूद नहीं)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
अश्हदु अन्ना मुहम्मदर रसूलुल्लाह
(मैं गवाही देता हूं कि मुहम्मद ﷺ अल्लाह के रसूल हैं)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
अश्हदु अन्ना मुहम्मदर रसूलुल्लाह
(मैं गवाही देता हूं कि मुहम्मद ﷺ अल्लाह के रसूल हैं)

حَيَّ عَلَى الصَّلَاةِ
हय्या अलस-सलाह
(नमाज़ की तरफ़ आओ)

حَيَّ عَلَى الصَّلَاةِ
हय्या अलस-सलाह
(नमाज़ की तरफ़ आओ)

حَيَّ عَلَى الْفَلَاحِ
हय्या अलल-फ़लाह
(कामयाबी की तरफ़ आओ)

حَيَّ عَلَى الْفَلَاحِ
हय्या अलल-फ़लाह
(कामयाबी की तरफ़ आओ)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
अल्लाहु अकबर, अल्लाहु अकबर
(अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है)

لَا إِلَٰهَ إِلَّا اللَّهُ
ला इलाहा इल्लल्लाह
(अल्लाह के सिवा कोई माबूद नहीं)

फज्र की अज़ान में - "हय्या अलल-फ़लाह" के बाद इज़ाफ़ा:
الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ
अस-सलातु ख़ैरुम मिनन-नौम
(नमाज़ नींद से बेहतर है)
(दो बार पढ़ें)''',
        'arabic': '''نص الأذان الكامل

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
الله أكبر، الله أكبر
(الله هو الأعظم، الله هو الأعظم)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
الله أكبر، الله أكبر
(الله هو الأعظم، الله هو الأعظم)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
أشهد أن لا إله إلا الله
(أشهد أنه لا إله إلا الله)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
أشهد أن لا إله إلا الله
(أشهد أنه لا إله إلا الله)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
أشهد أن محمدًا رسول الله
(أشهد أن محمدًا رسول الله)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
أشهد أن محمدًا رسول الله
(أشهد أن محمدًا رسول الله)

حَيَّ عَلَى الصَّلَاةِ
حي على الصلاة
(هلموا إلى الصلاة)

حَيَّ عَلَى الصَّلَاةِ
حي على الصلاة
(هلموا إلى الصلاة)

حَيَّ عَلَى الْفَلَاحِ
حي على الفلاح
(هلموا إلى الفلاح)

حَيَّ عَلَى الْفَلَاحِ
حي على الفلاح
(هلموا إلى الفلاح)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
الله أكبر، الله أكبر
(الله هو الأعظم، الله هو الأعظم)

لَا إِلَٰهَ إِلَّا اللَّهُ
لا إله إلا الله
(لا إله إلا الله)

لأذان الفجر - أضف بعد "حي على الفلاح":
الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ
الصلاة خير من النوم
(الصلاة خير من النوم)
(اقرأها مرتين)''',
      },
    },
    {
      'number': 2,
      'titleKey': 'azan_2_how_to_give_azan',
      'title': 'How to Give Azan',
      'titleUrdu': 'اذان دینے کا طریقہ',
      'titleHindi': 'अज़ान देने का तरीक़ा',
      'titleArabic': 'كيفية إقامة الأذان',
      'icon': Icons.school,
      'color': Colors.blue,
      'details': {
        'english': '''How to Give Azan - Step by Step

Before Azan:
1. Perform Wudu (ablution)
2. Face the Qiblah (direction of Makkah)
3. Stand in an elevated place if possible
4. Place index fingers in your ears (Sunnah)

During Azan:
1. Begin with Takbir:
   • Say "Allahu Akbar" four times
   • Each pair together, then pause

2. Shahada - La ilaha illallah:
   • Turn head slightly right when saying first Shahada
   • Say twice

3. Shahada - Muhammad Rasulullah:
   • Say twice

4. Hayya 'alas-Salah:
   • Turn head to the right
   • Say twice

5. Hayya 'alal-Falah:
   • Turn head to the left
   • Say twice

6. For Fajr Only:
   • Add "As-Salatu khayrum minan-nawm" twice
   • After Hayya 'alal-Falah

7. Final Takbir:
   • "Allahu Akbar" twice

8. End with Tahleel:
   • "La ilaha illallah" once

Voice Guidelines:
• Recite loudly and clearly
• Stretch the words appropriately
• Maintain a melodious but dignified tone
• Don't sing or be overly musical
• Pause briefly between phrases

After Azan:
• Recite the dua after Azan
• Wait for Iqamah before starting prayer''',
        'urdu': '''اذان دینے کا طریقہ - قدم بہ قدم

اذان سے پہلے:
۱۔ وضو کریں
۲۔ قبلہ رخ ہو جائیں (مکہ کی سمت)
۳۔ اگر ممکن ہو تو بلند جگہ کھڑے ہوں
۴۔ شہادت کی انگلیاں کانوں میں ڈالیں (سنت)

اذان کے دوران:
۱۔ تکبیر سے شروع کریں:
   • "اللہ اکبر" چار بار کہیں
   • ہر جوڑا ساتھ، پھر وقفہ

۲۔ شہادت - لا الہ الا اللہ:
   • پہلی شہادت کہتے وقت سر تھوڑا دائیں جانب موڑیں
   • دو بار کہیں

۳۔ شہادت - محمد رسول اللہ:
   • دو بار کہیں

۴۔ حی علی الصلوٰۃ:
   • سر دائیں طرف موڑیں
   • دو بار کہیں

۵۔ حی علی الفلاح:
   • سر بائیں طرف موڑیں
   • دو بار کہیں

۶۔ صرف فجر کے لیے:
   • "الصلوٰۃ خیر من النوم" دو بار کہیں
   • حی علی الفلاح کے بعد

۷۔ آخری تکبیر:
   • "اللہ اکبر" دو بار

۸۔ تہلیل پر ختم کریں:
   • "لا الہ الا اللہ" ایک بار

آواز کی ہدایات:
• بلند اور واضح آواز میں پڑھیں
• الفاظ کو مناسب طریقے سے کھینچیں
• خوش الحانی لیکن باوقار لہجہ رکھیں
• گانے کی طرح یا بہت موسیقی والا نہ ہو
• جملوں کے درمیان مختصر وقفہ دیں

اذان کے بعد:
• اذان کے بعد کی دعا پڑھیں
• نماز شروع کرنے سے پہلے اقامت کا انتظار کریں''',
        'hindi': '''अज़ान देने का तरीक़ा - क़दम ब क़दम

अज़ान से पहले:
१. वुज़ू करें
२. क़िबला रुख़ हो जाएं (मक्का की सिम्त)
३. अगर मुमकिन हो तो बुलंद जगह खड़े हों
४. शहादत की उंगलियां कानों में डालें (सुन्नत)

अज़ान के दौरान:
१. तकबीर से शुरू करें:
   • "अल्लाहु अकबर" चार बार कहें
   • हर जोड़ा साथ, फिर वक़्फ़ा

२. शहादत - ला इलाहा इल्लल्लाह:
   • पहली शहादत कहते वक़्त सर थोड़ा दाएं जानिब मोड़ें
   • दो बार कहें

३. शहादत - मुहम्मद रसूलुल्लाह:
   • दो बार कहें

४. हय्या अलस-सलाह:
   • सर दाएं तरफ़ मोड़ें
   • दो बार कहें

५. हय्या अलल-फ़लाह:
   • सर बाएं तरफ़ मोड़ें
   • दो बार कहें

६. सिर्फ़ फज्र के लिए:
   • "अस-सलातु ख़ैरुम मिनन-नौम" दो बार कहें
   • हय्या अलल-फ़लाह के बाद

७. आख़िरी तकबीर:
   • "अल्लाहु अकबर" दो बार

८. तहलील पर ख़त्म करें:
   • "ला इलाहा इल्लल्लाह" एक बार

आवाज़ की हिदायात:
• बुलंद और वाज़ेह आवाज़ में पढ़ें
• अल्फ़ाज़ को मुनासिब तरीक़े से खींचें
• ख़ुश-अलहानी लेकिन बावक़ार लहजा रखें
• गाने की तरह या बहुत मौसीक़ी वाला न हो
• जुम्लों के दरमियान मुख़्तसर वक़्फ़ा दें

अज़ान के बाद:
• अज़ान के बाद की दुआ पढ़ें
• नमाज़ शुरू करने से ��हले इक़ामत का इंतेज़ार करें''',
        'arabic': '''كيفية إقامة الأذان - خطوة بخطوة

قبل الأذان:
١. توضأ (الوضوء)
٢. استقبل القبلة (اتجاه مكة)
٣. قف في مكان مرتفع إن أمكن
٤. ضع أصابع السبابة في أذنيك (سنة)

أثناء الأذان:
١. ابدأ بالتكبير:
   • قل "الله أكبر" أربع مرات
   • كل زوج معًا، ثم توقف

٢. الشهادة - لا إله إلا الله:
   • أدر رأسك قليلاً إلى اليمين عند قول الشهادة الأولى
   • قلها مرتين

٣. الشهادة - محمد رسول الله:
   • قلها مرتين

٤. حي على الصلاة:
   • أدر رأسك إلى اليمين
   • قلها مرتين

٥. حي على الفلاح:
   • أدر رأسك إلى اليسار
   • قلها مرتين

٦. للفجر فقط:
   • أضف "الصلاة خير من النوم" مرتين
   • بعد حي على الفلاح

٧. التكبير الأخير:
   • "الله أكبر" مرتين

٨. اختم بالتهليل:
   • "لا إله إلا الله" مرة واحدة

إرشادات الصوت:
• اقرأ بصوت عالٍ وواضح
• مد الكلمات بشكل مناسب
• حافظ على نبرة عذبة ولكن وقورة
• لا تغني أو تكون موسيقيًا بشكل مفرط
• توقف قليلاً بين العبارات

بعد الأذان:
• اقرأ الدعاء بعد الأذان
• انتظر الإقامة قبل بدء الصلاة''',
      },
    },
    {
      'number': 3,
      'titleKey': 'azan_3_iqamah_second_call',
      'title': 'Iqamah (Second Call)',
      'titleUrdu': 'اقامت',
      'titleHindi': 'इक़ामत',
      'titleArabic': 'الإقامة (النداء الثاني)',
      'icon': Icons.play_arrow,
      'color': Colors.orange,
      'details': {
        'english': '''Iqamah (إقامة) - Second Call to Prayer

The Iqamah is given immediately before the congregational prayer begins.

Complete Iqamah:

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
Allahu Akbar, Allahu Akbar
(Allah is the Greatest, Allah is the Greatest)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
Ash-hadu an la ilaha illallah
(I bear witness that there is no god but Allah)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
Ash-hadu anna Muhammadar Rasulullah
(I bear witness that Muhammad is the Messenger of Allah)

حَيَّ عَلَى الصَّلَاةِ
Hayya 'alas-Salah
(Come to prayer)

حَيَّ عَلَى الْفَلَاحِ
Hayya 'alal-Falah
(Come to success)

قَدْ قَامَتِ الصَّلَاةُ قَدْ قَامَتِ الصَّلَاةُ
Qad qamatis-Salah, Qad qamatis-Salah
(Prayer has begun, Prayer has begun)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
Allahu Akbar, Allahu Akbar
(Allah is the Greatest, Allah is the Greatest)

لَا إِلَٰهَ إِلَّا اللَّهُ
La ilaha illallah
(There is no god but Allah)

Differences from Azan:
• Each phrase is said once (not twice) except Takbir
• "Qad qamatis-Salah" is added (twice)
• Recited faster than Azan
• Said in a lower voice than Azan
• Given inside the masjid

When to Give Iqamah:
• When the congregation is ready
• After straightening the rows
• Just before the Imam begins the prayer''',
        'urdu': '''اقامت - نماز کی دوسری پکار

اقامت جماعت کی نماز شروع ہونے سے فوراً پہلے دی جاتی ہے۔

مکمل اقامت:

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
اللہ اکبر، اللہ اکبر
(اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
اشھد ان لا الہ الا اللہ
(میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
اشھد ان محمدا رسول اللہ
(میں گواہی دیتا ہوں کہ محمد ﷺ اللہ کے رسول ہیں)

حَيَّ عَلَى الصَّلَاةِ
حی علی الصلوٰۃ
(نماز کی طرف آؤ)

حَيَّ عَلَى الْفَلَاحِ
حی علی الفلاح
(کامیابی کی طرف آؤ)

قَدْ قَامَتِ الصَّلَاةُ قَدْ قَامَتِ الصَّلَاةُ
قد قامت الصلوٰۃ، قد قامت الصلوٰۃ
(نماز کھڑی ہو گئی، نماز کھڑی ہو گئی)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
اللہ اکبر، اللہ اکبر
(اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے)

لَا إِلَٰهَ إِلَّا اللَّهُ
لا الہ الا اللہ
(اللہ کے سوا کوئی معبود نہیں)

اذان سے فرق:
• تکبیر کے علاوہ ہر جملہ ایک بار کہا جاتا ہے
• "قد قامت الصلوٰۃ" کا اضافہ (دو بار)
• اذان سے تیز پڑھی جاتی ہے
• اذان سے دھیمی آواز میں
• مسجد کے اندر دی جاتی ہے

اقامت کب دیں:
• جب جماعت تیار ہو
• صفیں سیدھی کرنے کے بعد
• امام کے نماز شروع کرنے سے بالکل پہلے''',
        'hindi': '''इक़ामत - नमाज़ की दूसरी पुकार

इक़ामत जमाअत की नमाज़ शुरू होने से फ़ौरन पहले दी जाती है।

मुकम्मल इक़ामत:

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
अल्लाहु अकबर, अल्लाहु अकबर
(अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
अश्हदु अन ला इलाहा इल्लल्लाह
(मैं गवाही देता हूं कि अल्लाह के सिवा कोई माबूद नहीं)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
अश्हदु अन्ना मुहम्मदर रसूलुल्लाह
(मैं गवाही देता हूं कि मुहम्मद ﷺ अल्लाह के रसूल हैं)

حَيَّ عَلَى الصَّلَاةِ
हय्या अलस-सलाह
(नमाज़ की तरफ़ आओ)

حَيَّ عَلَى الْفَلَاحِ
हय्या अलल-फ़लाह
(कामयाबी की तरफ़ आओ)

قَدْ قَامَتِ الصَّلَاةُ قَدْ قَامَتِ الصَّلَاةُ
क़द क़ामतिस-सलाह, क़द क़ामतिस-सलाह
(नमाज़ खड़ी हो गई, नमाज़ खड़ी हो गई)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
अल्लाहु अकबर, अल्लाहु अकबर
(अल्लाह सबसे बड़ा है, अल्लाह सबसे बड़ा है)

لَا إِلَٰهَ إِلَّا اللَّهُ
ला इलाहा इल्लल्लाह
(अल्लाह के सिवा कोई माबूद नहीं)

अज़ान से फ़र्क़:
• तकबीर के इलावा हर जुम्ला एक बार कहा जाता है
• "क़द क़ामतिस-सलाह" का इज़ाफ़ा (दो बार)
• अज़ान से तेज़ पढ़ी जाती है
• अज़ान से धीमी आवाज़ में
• मस्जिद के अंदर दी जाती है

इक़ामत कब दें:
• जब जमाअत तैयार हो
• सफ़ें सीधी करने के बाद
• इमाम के नमाज़ शुरू करने से बिल्कुल पहले''',
        'arabic': '''الإقامة - النداء الثاني للصلاة

تُقام الإقامة مباشرة قبل بدء صلاة الجماعة.

الإقامة الكاملة:

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
الله أكبر، الله أكبر
(الله هو الأعظم، الله هو الأعظم)

أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ
أشهد أن لا إله إلا الله
(أشهد أنه لا إله إلا الله)

أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ
أشهد أن محمدًا رسول الله
(أشهد أن محمدًا رسول الله)

حَيَّ عَلَى الصَّلَاةِ
حي على الصلاة
(هلموا إلى الصلاة)

حَيَّ عَلَى الْفَلَاحِ
حي على الفلاح
(هلموا إلى الفلاح)

قَدْ قَامَتِ الصَّلَاةُ قَدْ قَامَتِ الصَّلَاةُ
قد قامت الصلاة، قد قامت الصلاة
(قد أقيمت الصلاة، قد أقيمت الصلاة)

اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ
الله أكبر، الله أكبر
(الله هو الأعظم، الله هو الأعظم)

لَا إِلَٰهَ إِلَّا اللَّهُ
لا إله إلا الله
(لا إله إلا الله)

الفرق عن الأذان:
• كل عبارة تُقال مرة واحدة (وليس مرتين) ماعدا التكبير
• تُضاف "قد قامت الصلاة" (مرتين)
• تُقرأ أسرع من الأذان
• تُقال بصوت أخفض من الأذان
• تُقام داخل المسجد

متى تُقام الإقامة:
• عندما تكون الجماعة مستعدة
• بعد تسوية الصفوف
• مباشرة قبل أن يبدأ الإمام الصلاة''',
      },
    },
    {
      'number': 4,
      'titleKey': 'azan_4_response_to_azan',
      'title': 'Response to Azan',
      'titleUrdu': 'اذان کا جواب',
      'titleHindi': 'अज़ान का जवाब',
      'titleArabic': 'الرد على الأذان',
      'icon': Icons.hearing,
      'color': Colors.purple,
      'details': {
        'english': '''Response to Azan (Dua After Azan)

When You Hear the Azan:

1. Stop What You're Doing:
   • Listen attentively
   • It's disliked to talk during Azan

2. Repeat After the Muazzin:
   • Say what he says, except for:

   When he says "Hayya 'alas-Salah":
   You say: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "La hawla wa la quwwata illa billah"
   (There is no power or strength except with Allah)

   When he says "Hayya 'alal-Falah":
   You say: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "La hawla wa la quwwata illa billah"

   For Fajr - when he says "As-Salatu khayrum minan-nawm":
   You say: "صَدَقْتَ وَبَرِرْتَ"
   "Sadaqta wa bararta"
   (You have spoken the truth and done well)

3. After Azan is Complete - Say Durood:
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

4. Then Recite This Dua:
"اللَّهُمَّ رَبَّ هَٰذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَا��ِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"Allahumma Rabba hadhihid-da'watit-tammah, was-salatil-qa'imah, ati Muhammadanil-wasilata wal-fadilah, wab'athhu maqamam mahmudanil-ladhi wa'adtah"

"O Allah, Lord of this perfect call and established prayer, grant Muhammad the intercession and the eminence, and raise him to the praised station that You have promised him."

Reward:
The Prophet ﷺ said: "Whoever says this dua after hearing the Azan, my intercession will be guaranteed for him on the Day of Judgment." (Sahih Bukhari)''',
        'urdu': '''اذان کا جواب (اذان کے بعد دعا)

جب آپ اذان سنیں:

۱۔ جو کر رہے ہیں روک دیں:
   • توجہ سے سنیں
   • اذان کے دوران بات کرنا مکروہ ہے

۲۔ مؤذن کے بعد دہرائیں:
   • جو وہ کہے وہی کہیں، سوائے:

   جب وہ "حی علی الصلوٰۃ" کہے:
   آپ کہیں: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "لا حول ولا قوۃ الا باللہ"
   (اللہ کے سوا کوئی طاقت و قوت نہیں)

   جب وہ "حی علی الفلاح" کہے:
   آپ کہیں: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "لا حول ولا قوۃ الا باللہ"

   فجر میں - جب وہ "الصلوٰۃ خیر من النوم" کہے:
   آپ کہیں: "صَدَقْتَ وَبَرِرْتَ"
   "صدقت و بررت"
   (آپ نے سچ کہا اور نیکی کی)

۳۔ اذان مکمل ہونے کے بعد - درود پڑھیں:
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

۴۔ پھر یہ دعا پڑھیں:
"اللَّهُمَّ رَبَّ هَٰذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"اے اللہ، اس کامل پکار اور قائم ہونے والی نماز کے رب، محمد ﷺ کو وسیلہ اور فضیلت عطا فرما، اور انہیں اس مقام محمود پر پہنچا جس کا تو نے وعدہ کیا ہے۔"

ثواب:
نبی کریم ﷺ نے فرمایا: "جو شخص اذان سننے کے بعد یہ دعا پڑھے، قیامت کے دن اس کے لیے میری شفاعت یقینی ہو گی۔" (صحیح بخاری)''',
        'hindi': '''अज़ान का जवाब (अज़ान के बाद दुआ)

जब आप अज़ान सुनें:

१. जो कर रहे हैं रोक दें:
   • तवज्जो से सुनें
   • अज़ान के दौरान बात करना मकरूह है

२. मुअज़्ज़िन के बाद दोहराएं:
   • जो वो कहे वही कहें, सिवाए:

   जब वो "हय्या अलस-सलाह" कहे:
   आप कहें: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "ला हौला वला क़ुव्वता इल्ला बिल्लाह"
   (अल्लाह के सिवा कोई ताक़त व क़ुव्वत नहीं)

   जब वो "हय्या अलल-फ़लाह" कहे:
   आप कहें: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "ला हौला वला क़ुव्वता इल्ला बिल्लाह"

   फज्र में - जब वो "अस-सलातु ख़ैरुम मिनन-नौम" कहे:
   आप कहें: "صَدَقْتَ وَبَرِرْتَ"
   "सदक़्ता व बररता"
   (आपने सच कहा और नेकी की)

३. अज़ान मुकम्मल होने के बाद - दुरूद पढ़ें:
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

४. फिर यह दुआ पढ़ें:
"اللَّهُمَّ رَبَّ هَٰذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"ऐ अल्लाह, इस कामिल पुकार और क़ायम होने वाली नमाज़ के रब, मुहम्मद ﷺ को वसीला और फ़ज़ीलत अता फ़रमा, और उन्हें उस मक़ाम-ए-महमूद पर पहुंचा जिसका तूने वादा किया है।"

सवाब:
नबी करीम ﷺ ने फ़रमाया: "जो शख़्स अज़ान सुनने के बाद यह दुआ पढ़े, क़यामत के दिन उसके लिए मेरी शफ़ाअत यक़ीनी हो गी।" (सहीह बुख़ारी)''',
        'arabic': '''الرد على الأذان (الدعاء بعد الأذان)

عندما تسمع الأذان:

١. توقف عما تفعل:
   • استمع باهتمام
   • يُكره التحدث أثناء الأذان

٢. كرر وراء المؤذن:
   • قل ما يقوله، ماعدا:

   عندما يقول "حي على الصلاة":
   قل أنت: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "لا حول ولا قوة إلا بالله"
   (لا حول ولا قوة إلا بالله)

   عندما يقول "حي على الفلاح":
   قل أنت: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ"
   "لا حول ولا قوة إلا بالله"

   للفجر - عندما يقول "الصلاة خير من النوم":
   قل أنت: "صَدَقْتَ وَبَرِرْتَ"
   "صدقت وبررت"
   (صدقت وبررت)

٣. بعد انتهاء الأذان - قل الصلاة على النبي:
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

٤. ثم اقرأ هذا الدعاء:
"اللَّهُمَّ رَبَّ هَٰذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"اللهم رب هذه الدعوة التامة والصلاة القائمة آت محمدًا الوسيلة والفضيلة وابعثه مقامًا محمودًا الذي وعدته"

"اللهم يا رب هذه الدعوة الكاملة والصلاة القائمة، أعط محمدًا الوسيلة والفضيلة، وابعثه المقام المحمود الذي وعدته."

الثواب:
قال النبي ﷺ: "من قال هذا الدعاء بعد سماع الأذان، حلت له شفاعتي يوم القيامة." (صحيح البخاري)''',
      },
    },
    {
      'number': 5,
      'titleKey': 'azan_5_virtues_of_azan',
      'title': 'Virtues of Azan',
      'titleUrdu': 'اذان کی فضیلت',
      'titleHindi': 'अज़ान की फ़ज़ीलत',
      'titleArabic': 'فضائل الأذان',
      'icon': Icons.star,
      'color': Colors.amber,
      'details': {
        'english': '''Virtues and Rewards of Azan

1. Satan Flees:
The Prophet ﷺ said: "When the call to prayer is made, Satan runs away passing wind loudly so that he does not hear the Azan." (Sahih Bukhari)

2. Testimony on Day of Judgment:
The Prophet ﷺ said: "The Muazzin will have the longest necks on the Day of Resurrection." (Sahih Muslim)
(Meaning: They will be honored and distinguished)

3. Forgiveness:
The Prophet ﷺ said: "The Muazzin is forgiven for as far as his voice reaches, and every wet and dry thing makes dua for him." (Sunan Nasa'i)

4. Great Reward:
The Prophet ﷺ said: "If people knew what reward there is in the Azan and the first row, and they could not get it except by drawing lots, they would draw lots." (Sahih Bukhari)

5. Protection from Hellfire:
Narrated that whoever gives Azan for 12 years, Paradise becomes obligatory for him.

6. Shade on Day of Judgment:
The Muazzin will be under the shade of the Throne of Allah.

7. Dua is Accepted:
The Prophet ﷺ said: "Dua between the Azan and Iqamah is not rejected." (Sunan Abu Dawud)

Who Should Give Azan:
• Someone with a loud, beautiful voice
• Someone who knows the prayer times
• A trustworthy person
• One who is in a state of purity

Note: Giving Azan is a great honor and responsibility. The Muazzin calls people to the worship of Allah.''',
        'urdu': '''اذان کی فضیلت اور ثواب

۱۔ شیطان بھاگ جاتا ہے:
نبی کریم ﷺ نے فرمایا: "جب اذان دی جاتی ہے تو شیطان زور سے ہوا خارج کرتا ہوا بھاگ جاتا ہے تاکہ اذان نہ سنے۔" (صحیح بخاری)

۲۔ قیامت کے دن گواہی:
نبی کریم ﷺ نے فرمایا: "قیامت کے دن مؤذنین کی گردنیں سب سے لمبی ہوں گی۔" (صحیح مسلم)
(یعنی: انہیں عزت اور امتیاز دیا جائے گا)

۳۔ مغفرت:
نبی کریم ﷺ نے فرمایا: "مؤذن کی آواز جہاں تک پہنچتی ہے وہاں تک اس کی مغفرت ہو جاتی ہے، اور ہر گیلی اور خشک چیز اس کے لیے دعا کرتی ہے۔" (سنن نسائی)

۴۔ عظیم ثواب:
نب�� کریم ﷺ نے فرمایا: "اگر لوگوں کو معلوم ہوتا کہ اذان اور پہلی صف میں کتنا ثواب ہے، اور وہ اسے قرعہ ڈالے بغیر حاصل نہ کر سکتے، تو وہ قرعہ ڈالتے۔" (صحیح بخاری)

۵۔ جہنم سے حفاظت:
روایت ہے کہ جو 12 سال اذان دے، اس پر جنت واجب ہو جاتی ہے۔

۶۔ قیامت کے دن سایہ:
مؤذن اللہ کے عرش کے سائے میں ہوگا۔

۷۔ دعا قبول ہوتی ہے:
نبی کریم ﷺ نے فرمایا: "اذان اور اقامت کے درمیان کی دعا رد نہیں ہوتی۔" (سنن ابو داؤد)

اذان کون دے:
• جس کی آواز بلند اور خوبصورت ہو
• جو نماز کے اوقات جانتا ہو
• قابل اعتماد شخص
• جو پاکیزگی کی حالت میں ہو

نوٹ: اذان دینا عظیم اعزاز اور ذمہ داری ہے۔ مؤذن لوگوں کو اللہ کی عبادت کی طرف بلاتا ہے۔''',
        'hindi': '''अज़ान की फ़ज़ीलत और सवाब

१. शैतान भाग जाता है:
नबी करीम ﷺ ने फ़रमाया: "जब अज़ान दी जाती है तो शैतान ज़ोर से हवा ख़ारिज करता हुआ भाग जाता है ताकि अज़ान न सुने।" (सहीह बुख़ारी)

२. क़यामत के दिन गवाही:
नबी करीम ﷺ ने फ़रमाया: "क़यामत के दिन मुअज़्ज़िनीन की गर्दनें सबसे लंबी होंगी।" (सहीह मुस्लिम)
(यानी: उन्हें इज़्ज़त और इम्तियाज़ दिया जाएगा)

३. मग़फ़िरत:
नबी करीम ﷺ ने फ़रमाया: "मुअज़्ज़िन की आवाज़ जहां तक पहुंचती है वहां तक उसकी मग़फ़िरत हो जाती है, और हर गीली और ख़ुश्क चीज़ उसके लिए दुआ करती है।" (सुनन नसाई)

४. अज़ीम सवाब:
नबी करीम ﷺ ने फ़रमाया: "अगर लोगों को मालूम होता कि अज़ान और पहली सफ़ में कितना सवाब है, और वो इसे क़ुरआ डाले बग़ैर हासिल न कर सकते, तो वो क़ुरआ डालते।" (सहीह बुख़ारी)

५. जहन्नम से हिफ़ाज़त:
रिवायत है कि जो 12 साल अज़ान दे, उस पर जन्नत वाजिब हो जाती है।

६. क़यामत के दिन साया:
मुअज़्ज़िन अल्लाह के अर्श के साये में होगा।

७. दुआ क़बूल होती है:
नबी करीम ﷺ ने फ़रमाया: "अज़ान और इक़ामत के दरमियान की दुआ रद नहीं होती।" (सुनन अबू दाऊद)

अज़ान कौन दे:
• जिसकी आवाज़ बुलंद और ख़ूबसूरत हो
• जो नमाज़ के औक़ात जानता हो
• क़ाबिल-ए-एतिमाद शख़्स
• जो पाकीज़गी की हालत में हो

नोट: अज़ान देना अज़ीम एज़ाज़ और ज़िम्मेदारी है। मुअज़्ज़िन लोगों को अल्लाह की इबादत की तरफ़ बुलाता है।''',
        'arabic': '''فضائل وثواب الأذان

١. الشيطان يهرب:
قال النبي ﷺ: "إذا نودي للصلاة أدبر الشيطان وله ضراط حتى لا يسمع التأذين." (صحيح البخاري)

٢. الشهادة يوم القيامة:
قال النبي ﷺ: "المؤذنون أطول الناس أعناقًا يوم القيامة." (صحيح مسلم)
(أي: سيُكرمون ويُميزون)

٣. المغفرة:
قال النبي ﷺ: "يُغفر للمؤذن مدى صوته، ويصدقه كل رطب ويابس." (سنن النسائي)

٤. الثواب العظيم:
قال النبي ﷺ: "لو يعلم الناس ما في النداء والصف الأول ثم لم يجدوا إلا أن يستهموا عليه لاستهموا." (صحيح البخاري)

٥. الحماية من النار:
رُوي أن من أذن اثنتي عشرة سنة وجبت له الجنة.

٦. الظل يوم القيامة:
المؤذن يكون في ظل عرش الله.

٧. الدعاء مستجاب:
قال النبي ﷺ: "الدعاء بين الأذان والإقامة لا يُرد." (سنن أبي داود)

من ينبغي أن يؤذن:
• من له صوت عالٍ وجميل
• من يعرف أوقات الصلاة
• شخص موثوق
• من هو على طهارة

ملاحظة: الأذان شرف عظيم ومسؤولية. المؤذن يدعو الناس إلى عبادة الله.''',
      },
    },
    {
      'number': 6,
      'titleKey': 'azan_6_history_and_origin',
      'title': 'History and Origin of Azan',
      'titleUrdu': 'اذان کی تاریخ اور ابتدا',
      'titleHindi': 'अज़ान की तारीख़ और शुरुआत',
      'titleArabic': 'تاريخ وأصل الأذان',
      'icon': Icons.history_edu,
      'color': Colors.brown,
      'details': {
        'english': '''History and Origin of Azan

When was Azan Introduced?
The Azan was prescribed during the first year after the Prophet's migration (Hijrah) to Medina, around 622-623 CE. When the Muslims arrived at Medina, they used to assemble for prayer and guess the time for it. During those early days, the practice of Azan for prayers had not yet been introduced.

The Divine Solution:
The solution for the call to prayer came through a dream of Abdullah ibn Zayd, a companion of the Prophet ﷺ. In his dream, he saw a man wearing green garments teaching him the words of the Adhan. When he narrated this to the Prophet ﷺ, he recognized it as true guidance from Allah and said: "Indeed this is a true vision. So stand with Bilal and teach him what you saw, for he has a louder voice than you."

Bilal ibn Rabah - The First Muezzin:
Bilal ibn Rabah (580-640 CE) is considered the first muʾazzin (caller to prayer) in Islam, personally chosen by Prophet Muhammad ﷺ for his deep, melodious, and powerful voice. He was one of the earliest converts to Islam and is often regarded as the first African or Black Muslim.

Born into slavery in Mecca, Bilal suffered severe torture for accepting Islam. His master would place a heavy rock on his chest in the scorching desert heat, but Bilal would only say "Ahad, Ahad" (One, One), affirming the oneness of Allah. Abu Bakr eventually freed him.

Historic Moment at the Kaaba:
After the peaceful conquest of Mecca in 630 CE, the Prophet ﷺ ordered Bilal to climb on top of the Kaaba and call the Adhan. This was a historic moment symbolizing the end of idolatry and the establishment of Islam in the sacred city. Bilal's voice echoed through Mecca, marking a new era.

Alternative Account (Shia Perspective):
According to Shia sources, all Imamiyyah jurisprudents, following the Ahl al-Bayt, believe that Adhan began with God's direct order and revelation to the Prophet's heart, not through a companion's dream.

Why Was Bilal Chosen?
The Prophet ﷺ chose Bilal because:
• He had a strong, beautiful, and far-reaching voice
• He was deeply committed to Islam despite severe persecution
• He was trustworthy and punctual
• He understood the importance of the call to prayer
• His voice would become a symbol of Islamic unity

The First Adhan in Medina:
When the Prophet ﷺ introduced Adhan in Medina, he instructed Bilal to pronounce the Adhan by saying its wordings twice, and for the Iqama (the call for standing in prayer rows) by saying its wordings once. This practice continues to this day in Sunni tradition.

Bilal's Legacy:
After the Prophet's death, Bilal could not bear to give the Adhan in Medina anymore due to his grief. He moved to Syria and only gave the Adhan once more in his lifetime, when he visited Medina and the companions requested it. His voice brought tears to everyone's eyes as they remembered the Prophet ﷺ.

Authentic Sources:
• Sahih al-Bukhari (603, 604, 605)
• Sunan Abu Dawud
• Musnad Ahmad
• Ibn Kathir's Al-Bidayah wan-Nihayah
• Sirat Ibn Hisham''',
        'urdu': '''اذان کی تاریخ اور ابتدا

اذان کب شروع ہوئی؟
اذان ہجرت کے پہلے سال میں مدینہ منورہ میں شروع کی گئی، تقریباً 622-623 عیسوی میں۔ جب مسلمان مدینہ پہنچے تو نماز کے لیے جمع ہوتے تھے اور وقت کا اندازہ لگاتے تھے۔ ان ابتدائی ایام میں نماز کے لیے اذان کا رواج ابھی شروع نہیں ہوا تھا۔

الہٰی حل:
نماز کی پکار کا حل عبداللہ بن زید رضی اللہ عنہ کے خواب کے ذریعے آیا، جو نبی ﷺ کے صحابی تھے۔ اپنے خواب میں انہوں نے سبز لباس پہنے ہوئے ایک شخص کو دیکھا جو انہیں اذان کے الفاظ سکھا رہا تھا۔ جب انہوں نے یہ نبی ﷺ کو بتایا، تو آپ ﷺ نے فرمایا: "بے شک یہ سچا خواب ہے۔ بلال کے پاس جاؤ اور انہیں وہ سکھاؤ جو تم نے دیکھا، کیونکہ ان کی آواز تم سے بلند ہے۔"

بلال بن رباح - پہلے مؤذن:
بلال بن رباح رضی اللہ عنہ (580-640 عیسوی) کو اسلام کا پہلا مؤذن (اذان دینے والا) سمجھا جاتا ہے، جنہیں نبی کریم ﷺ نے ان کی گہری، خوبصورت اور طاقتور آواز کی وجہ سے ذاتی طور پر منتخب کیا۔ وہ اسلام قبول کرنے والے ابتدائی لوگوں میں سے ایک تھے اور انہیں پہلا افریقی یا سیاہ فام مسلمان سمجھا جاتا ہے۔

مکہ میں غلامی میں پیدا ہونے والے بلال رضی اللہ عنہ نے اسلام قبول کرنے پر شدید تشدد برداشت کیا۔ ان کا آقا انہیں جلتی ہوئی ریت پر لٹا کر سینے پر بھاری پتھر رکھ دیتا، لیکن بلال رضی اللہ عنہ صرف "احد، احد" (ایک، ایک) کہتے رہتے، اللہ کی وحدانیت کی تصدیق کرتے ہوئے۔ حضرت ابوبکر رضی اللہ عنہ نے بالآخر انہیں آزاد کرایا۔

کعبہ پر تاریخی لمحہ:
فتح مکہ کے بعد 630 عیسوی میں، نبی ﷺ نے بلال رضی اللہ عنہ کو کعبہ کی چھت پر چڑھنے اور اذان دینے کا حکم دیا۔ یہ ایک تاریخی لمحہ تھا جو بت پرستی کے خاتمے اور مقدس شہر میں اسلام کے قیام کی علامت تھا۔ بلال رضی اللہ عنہ کی آواز مکہ میں گونجی، ایک نئے دور کا آغاز کرتے ہوئے۔

متبادل روایت (شیعہ نقطہ نظر):
شیعہ ذرائع کے مطابق، تمام امامیہ فقہاء، اہل بیت علیہم السلام کی پیروی کرتے ہوئے، یہ مانتے ہیں کہ اذان اللہ کے براہ راست حکم اور نبی ﷺ کے دل پر وحی سے شروع ہوئی، نہ کہ کسی صحابی کے خواب سے۔

بلال رضی اللہ عنہ کیوں منتخب ہوئے؟
نبی ﷺ نے بلال رضی اللہ عنہ کو منتخب کیا کیونکہ:
• ان کی آواز مضبوط، خوبصورت اور دور تک جانے والی تھی
• وہ شدید ظلم کے باوجود اسلام کے لیے گہرے عزم کے حامل تھے
• وہ قابل اعتماد اور وقت کے پابند تھے
• وہ اذان کی اہمیت کو سمجھتے تھے
• ان کی آواز اسلامی اتحاد کی علامت بن گئی

مدینہ میں پہلی اذان:
جب نبی ﷺ نے مدینہ میں اذان متعارف کرائی، تو آپ ﷺ نے بلال رضی اللہ عنہ کو ہدایت دی کہ اذان کے الفاظ دو بار اور اقامت کے الفاظ ایک بار کہیں۔ یہ عمل آج تک سنی روایت میں جاری ہے۔

بلال رضی الل�� عنہ کی میراث:
نبی ﷺ کی وفات کے بعد، بلال رضی اللہ عنہ اپنے غم کی وجہ سے مدینہ میں اذان نہیں دے سکے۔ وہ شام چلے گئے اور اپنی زندگی میں صرف ایک بار پھر اذان دی، جب وہ مدینہ آئے اور صحابہ نے درخواست کی۔ ان کی آواز نے سب کی آنکھوں میں آنسو بھر دیے کیونکہ انہیں نبی ﷺ یاد آ گئے۔

مستند ذرائع:
• صحیح بخاری (603، 604، 605)
• سنن ابوداؤد
• مسند احمد
• ابن کثیر کی البدایہ والنہایہ
• سیرت ابن ہشام''',
        'hindi': '''अज़ान की तारीख़ और शुरुआत

अज़ान कब शुरू हुई?
अज़ान हिजरत के पहले साल में मदीना मुनव्वरा में शुरू की गई, लगभग 622-623 ईस्वी में। जब मुसलमान मदीना पहुंचे तो नमाज़ के लिए जमा होते थे और वक़्त का अंदाज़ा लगाते थे। उन शुरुआती दिनों में नमाज़ के लिए अज़ान का रिवाज अभी शुरू नहीं हुआ था।

इलाही हल:
नमाज़ की पुकार का हल अब्दुल्लाह बिन ज़ैद रज़ियल्लाहु अन्हु के ख़्वाब के ज़रिये आया, जो नबी ﷺ के सहाबी थे। अपने ख़्वाब में उन्होंने हरे कपड़े पहने हुए एक शख़्स को देखा जो उन्हें अज़ान के अल्फ़ाज़ सिखा रहा था। जब उन्होंने यह नबी ﷺ को बताया, तो आप ﷺ ने फ़रमाया: "बेशक यह सच्चा ख़्वाब है। बिलाल के पास जाओ और उन्हें वह सिखाओ जो तुमने देखा, क्योंकि उनकी आवाज़ तुमसे बुलंद है।"

बिलाल बिन रबाह - पहले मुअज़्ज़िन:
बिलाल बिन रबाह रज़ियल्लाहु अन्हु (580-640 ईस्वी) को इस्लाम का पहला मुअज़्ज़िन (अज़ान देने वाला) माना जाता है, जिन्हें नबी करीम ﷺ ने उनकी गहरी, ख़ूबसूरत और ताक़तवर आवाज़ की वजह से ज़ाती तौर पर चुना। वे इस्लाम क़बूल करने वाले शुरुआती लोगों में से एक थे और उन्हें पहला अफ़्रीकी या काले रंग का मुसलमान माना जाता है।

मक्का में ग़ुलामी में पैदा हुए बिलाल रज़ियल्लाहु अन्हु ने इस्लाम क़बूल करने पर शदीद तशद्दुद बर्दाश्त किया। उनका आक़ा उन्हें जलती हुई रेत पर लिटाकर सीने पर भारी पत्थर रख देता, लेकिन बिलाल रज़ियल्लाहु अन्हु सिर्फ़ "अहद, अहद" (एक, एक) कहते रहते, अल्लाह की वहदानियत की तस्दीक़ करते हुए। हज़रत अबू बकर रज़ियल्लाहु अन्हु ने बाल-आख़िर उन्हें आज़ाद कराया।

काबा पर तारीख़ी लम्हा:
फ़तह मक्का के बाद 630 ईस्वी में, नबी ﷺ ने बिलाल रज़ियल्लाहु अन्हु को काबा की छत पर चढ़ने और अज़ान देने का हुक्म दिया। यह एक तारीख़ी लम्हा था जो बुत-परस्ती के ख़ात्मे और मुक़द्दस शहर में इस्लाम के क़याम की निशानी था। बिलाल रज़ियल्लाहु अन्हु की आवाज़ मक्का में गूंजी, एक नए दौर का आग़ाज़ करते हुए।

मुतबादिल रिवायत (शिया नज़रिया):
शिया ज़राये के मुताबिक़, तमाम इमामिया फ़ुक़हा, अहले-बैत अलैहिमुस्सलाम की पैरवी करते हुए, यह मानते हैं कि अज़ान अल्लाह के बराह-रास्त हुक्म और नबी ﷺ के दिल पर वही से शुरू हुई, न कि किसी सहाबी के ख़्वाब से।

बिलाल रज़ियल्लाहु अन्हु क्यों चुने गए?
नबी ﷺ ने बिलाल रज़ियल्लाहु अन्हु को चुना क्योंकि:
• उनकी आवाज़ मज़बूत, ख़ूबसूरत और दूर तक जाने वाली थी
• वे शदीद ज़ुल्म के बावजूद इस्लाम के लिए गहरे अज़्म के हामिल थे
• वे क़ाबिल-ए-एतिमाद और वक़्त के पाबंद थे
• वे अज़ान की अहमियत को समझते थे
• उनकी आवाज़ इस्लामी इत्तिहाद की निशानी बन गई

मदीना में पहली अज़ान:
जब नबी ﷺ ने मदीना में अज़ान मुतअर्रिफ़ कराई, तो आप ﷺ ने बिलाल रज़ियल्लाहु अन्हु को हिदायत दी कि अज़ान के अल्फ़ाज़ दो बार और इक़ामत के अल्फ़ाज़ एक बार कहें। यह अमल आज तक सुन्नी रिवायत में जारी है।

बिलाल रज़ियल्लाहु अन्हु की मीरास:
नबी ﷺ की वफ़ात के बाद, बिलाल रज़ियल्लाहु अन्हु अपने ग़म की वजह से मदीना में अज़ान नहीं दे सके। वे शाम चले गए और अपनी ज़िंदगी में सिर्फ़ एक बार फिर अज़ान दी, जब वे मदीना आए और सहाबा ने दरख़्वास्त की। उनकी आवाज़ ने सब की आंखों में आंसू भर दिए क्योंकि उन्हें नबी ﷺ याद आ गए।

मुस्तनद ज़राये:
• सही बुख़ारी (603, 604, 605)
• सुनन अबू दाऊद
• मुस्नद अहमद
• इब्न-ए-कसीर की अल-बिदायह वन-निहायह
• सीरत इब्न-ए-हिशाम''',
        'arabic': '''تا��يخ وأصل الأذان

متى بدأ الأذان؟
شُرع الأذان في السنة الأولى بعد هجرة النبي ﷺ إلى المدينة المنورة، حوالي 622-623 م. عندما وصل المسلمون إلى المدينة، كانوا يجتمعون للصلاة ويقدرون وقتها. في تلك الأيام الأولى، لم تكن ممارسة الأذان للصلوات قد أُدخلت بعد.

الحل الإلهي:
جاء الحل لنداء الصلاة من خلال رؤيا عبد الله بن زيد رضي الله عنه، أحد صحابة النبي ﷺ. في رؤياه، رأى رجلاً يرتدي ثياباً خضراء يعلمه كلمات الأذان. عندما روى ذلك للنبي ﷺ، اعترف بها كهداية حقيقية من الله وقال: "إن هذه لرؤيا حق. فقم مع بلال فألقِ عليه ما رأيت، فإنه أندى صوتاً منك."

بلال بن رباح - المؤذن الأول:
يُعتبر بلال بن رباح رضي الله عنه (580-640 م) أول مؤذن في الإسلام، اختاره النبي محمد ﷺ شخصياً لصوته العميق والجميل والقوي. كان من أوائل الذين اعتنقوا الإسلام ويُعتبر غالباً أول مسلم أفريقي أو أسود.

وُلد بلال في العبودية في مكة، وعانى من التعذيب الشديد لقبوله الإسلام. كان سيده يضع صخرة ثقيلة على صدره في حرارة الصحراء الحارقة، لكن بلال كان يقول فقط "أحد، أحد"، مؤكداً على وحدانية الله. أعتقه أبو بكر في النهاية.

اللحظة التاريخية على الكعبة:
بعد فتح مكة سلمياً عام 630 م، أمر النبي ﷺ بلالاً بالصعود على سطح الكعبة وإطلاق الأذان. كانت هذه لحظة تاريخية ترمز إلى نهاية الوثنية وإقامة الإسلام في المدينة المقدسة. تردد صوت بلال في مكة، مُعلناً عهداً جديداً.

الرواية البديلة (المنظور الشيعي):
وفقاً للمصادر الشيعية، يؤمن جميع فقهاء الإمامية، متبعين أهل البيت عليهم السلام، أن الأذان بدأ بأمر مباشر من الله ووحي إلى قلب النبي ﷺ، وليس من خلال رؤيا صحابي.

لماذا اختير بلال؟
اختار النبي ﷺ بلالاً لأن:
• كان لديه صوت قوي وجميل وبعيد المدى
• كان ملتزماً بعمق بالإسلام رغم الاضطهاد الشديد
• كان جديراً بالثقة ودقيقاً في المواعيد
• فهم أهمية الدعوة إلى الصلاة
• أصبح صوته رمزاً للوحدة الإسلامية

أول أذان في المدينة:
عندما أدخل النبي ﷺ الأذان في المدينة، أمر بلالاً بنطق الأذان بقول كلماته مرتين، وللإقامة (نداء القيام في صفوف الصلاة) بقول كلماتها مرة واحدة. تستمر هذه الممارسة حتى يومنا هذا في التقليد السني.

إرث بلال:
بعد وفاة النبي ﷺ، لم يستطع بلال تحمل إطلاق الأذان في المدينة بعد ذلك بسبب حزنه. انتقل إلى الشام ولم يؤذن إلا مرة واحدة أخرى في حياته، عندما زار المدينة وطلب الصحابة منه ذلك. جلب صوته الدموع إلى عيون الجميع لأنهم تذكروا النبي ﷺ.

المصادر الموثوقة:
• صحيح البخاري (603، 604، 605)
• سنن أبي داود
• مسند أحمد
• البداية والنهاية لابن كثير
• السيرة النبوية لابن هشام''',
      },
    },
    {
      'number': 7,
      'titleKey': 'azan_7_conditions_requirements',
      'title': 'Conditions and Requirements for Mu\'adhdhin',
      'titleUrdu': 'مؤذن کے لیے شرائط اور تقاضے',
      'titleHindi': 'मुअज़्ज़िन के लिए शर्तें और तक़ाज़े',
      'titleArabic': 'شروط ومتطلبات المؤذن',
      'icon': Icons.checklist,
      'color': Colors.teal,
      'details': {
        'english': '''Conditions and Requirements for Mu'adhdhin

Who Should Give the Azan?

Essential Qualifications:

1. Muslim and Believer:
The muezzin must be a Muslim who believes in the oneness of Allah and the Prophethood of Muhammad ﷺ. This is a fundamental requirement.

2. Knowledge of Prayer Times:
The muezzin should be knowledgeable about the correct prayer times and able to determine when each prayer becomes due. He should be reliable and punctual.

3. Strong and Beautiful Voice:
The Prophet ﷺ said: "Indeed Allah loves a beautiful voice in the Adhan." (Sahih Bukhari)
• The voice should be loud enough to reach the community
• It should be melodious and pleasant to hear
• Clear pronunciation is essential

4. Male (According to Majority Opinion):
The scholars of the four major Sunni schools (Hanafi, Maliki, Shafi'i, and Hanbali) agree that the Adhan should be called by a man for men's congregational prayers. Women may call the Adhan for all-female congregations at home in a low voice.

5. State of Purity (Recommended):
While not strictly obligatory, it is highly recommended (mustahabb) that the muezzin be in a state of wudu (ablution) when giving the Adhan.

6. Trustworthy Character:
The muezzin should be known for honesty, reliability, and good character. The Prophet ﷺ said: "Your Imams and your Muezzins are your delegates before Allah."

7. Sane and Mature:
The muezzin should be of sound mind and preferably an adult, though the Adhan of a discerning child is also considered valid by many scholars.

Proper Manner of Giving Azan:

1. Facing the Qibla:
The muezzin should face towards the Qibla (direction of Kaaba in Mecca) when beginning the Adhan.

2. Placing Fingers in Ears:
The muezzin should place his index fingers in his ears while calling the Adhan. This helps project the voice further and blocks external sounds.

3. Turning During Certain Phrases:
• When saying "Hayya 'ala-s-Salah" (Come to prayer), turn the face to the right
• When saying "Hayya 'ala-l-Falah" (Come to success), turn the face to the left
• The body should remain facing the Qibla

4. Standing in an Elevated Place:
It is recommended to give the Adhan from an elevated place like a minaret so the voice reaches farther. This was the original purpose of minarets in Islamic architecture.

5. Measured Pace:
The Adhan should be called slowly and melodiously, while the Iqama should be quicker. The Prophet ﷺ ordered Bilal: "Make your Adhan slow and your Iqama quick."

Times When Azan is Given:

The Adhan is called five times daily for:
1. Fajr (Dawn Prayer)
2. Dhuhr (Midday Prayer)
3. Asr (Afternoon Prayer)
4. Maghrib (Sunset Prayer)
5. Isha (Night Prayer)

Additional Considerations:

• The Adhan for Fajr has an additional phrase in Sunni tradition: "As-salatu khayrun min an-naum" (Prayer is better than sleep)
• The muezzin should call the Adhan at the exact beginning of the prayer time
• It is recommended to give the Adhan in Arabic
• The muezzin should be chosen by the community or mosque administration
• Priority should be given to those who volunteer for the sake of Allah without expecting payment

Rewards for the Mu'adhdhin:

The Prophet ﷺ said: "Whoever calls the Adhan for twelve years, Paradise is guaranteed for him, and for each day sixty good deeds will be recorded for him by virtue of his Adhan, and thirty good deeds by virtue of his Iqama." (Sunan Ibn Majah)

Authentic Sources:
• Sahih al-Bukhari
• Sahih Muslim
• Sunan Abu Dawud
• Sunan Ibn Majah
• Al-Mawsu'ah al-Fiqhiyah (Encyclopaedia of Islamic Jurisprudence)''',
        'urdu': '''مؤذن کے لیے شرائط اور تقاضے

اذان کون دے؟

ضروری اہلیتیں:

1. مسلمان اور مومن:
مؤذن کا مسلمان ہونا ضروری ہے جو اللہ کی وحدانیت اور محمد ﷺ کی نبوت پر ایمان رکھتا ہو۔ یہ بنیادی تقاضا ہے۔

2. نماز کے اوقات کا علم:
مؤذن کو نماز کے صحیح اوقات کا علم ہونا چاہیے اور یہ جاننا چاہیے کہ ہر نماز کب واجب ہوتی ہے۔ وہ قابل اعتماد اور وقت کا پابند ہونا چاہیے۔

3. مضبوط اور خوبصورت آواز:
نبی ﷺ نے فرمایا: "بے شک اللہ اذان میں خوبصورت آواز کو پسند کرتا ہے۔" (صحیح بخاری)
• آواز اتنی بلند ہونی چاہیے کہ کمیونٹی تک پہنچ سکے
• یہ خوش الحان اور سننے میں خوشگوار ہونی چاہیے
• واضح تلفظ ضروری ہے

4. مرد (اکثریتی رائے کے مطابق):
چاروں بڑے سنی مکاتب فکر (حنفی، مالکی، شافعی اور حنبلی) کے علماء متفق ہیں کہ مردوں کی باجماعت نماز کے لیے مرد کو اذان دینی چاہیے۔ خواتین گھر پر مکمل طور پر خواتین کی جماعت کے لیے آہستہ آواز میں اذان دے سکتی ہیں۔

5. پاکیزگی کی حالت (مستحب):
اگرچہ یہ سختی سے واجب نہیں ہے، لیکن یہ بہت زیادہ مستحب ہے کہ مؤذن اذان دیتے وقت وضو کی حالت میں ہو۔

6. قابل اعتماد کردار:
مؤذن ایمانداری، قابل اعتماد ہونے اور اچھے کردار کے لیے جانا جانا چاہیے۔ نبی ﷺ نے فرمایا: "تمہارے امام اور تمہارے مؤذن اللہ کے سامنے تمہارے نمائندے ہیں۔"

7. عاقل اور بالغ:
مؤذن کو صحیح الدماغ اور ترجیحاً بالغ ہونا چاہیے، اگرچہ بہت سے علماء کے مطابق سمجھدار بچے کی اذان بھی درست سمجھی جاتی ہے۔

اذان دینے کا صحیح طریقہ:

1. قبلہ رخ ہونا:
مؤذن کو اذان شروع کرتے وقت قبلہ (مکہ میں کعبہ کی سمت) کی طرف منہ کرنا چاہیے۔

2. کانوں میں انگلیاں رکھنا:
مؤذن کو اذان دیتے وقت اپنی شہادت کی انگلیاں کانوں میں رکھنی چاہیے۔ یہ آواز کو مزید آگے پھیلانے میں مدد کرتا ہے اور بیرونی آوازوں کو روکتا ہے۔

3. مخصوص الفاظ کے دوران مڑنا:
• "حی علی الصلاۃ" (نماز کی طرف آؤ) کہتے وقت، چہرہ دائیں طرف موڑیں
• "حی علی الفلاح" (کامیابی کی طرف آؤ) کہتے وقت، چہرہ بائیں طرف موڑیں
• جسم کو قبلہ کی طرف ہی رہنا چاہیے

4. بلند جگہ پر کھڑے ہونا:
یہ مستحب ہ�� کہ اذان کسی بلند جگہ جیسے مینار سے دی جائے تاکہ آواز دور تک پہنچ سکے۔ یہ اسلامی فن تعمیر میں میناروں کا اصل مقصد تھا۔

5. متوازن رفتار:
اذان آہستہ اور خوش الحانی سے دی جانی چاہیے، جبکہ اقامت تیز ہونی چاہیے۔ نبی ﷺ نے بلال رضی اللہ عنہ کو حکم دیا: "اپنی اذان آہستہ اور اقامت تیز کرو۔"

اذان کے اوقات:

اذان روزانہ پانچ بار دی جاتی ہے:
1. فجر (صبح کی نماز)
2. ظہر (دوپہر کی نماز)
3. عصر (سہ پہر کی نماز)
4. مغرب (غروب آفتاب کی نماز)
5. عشاء (رات کی نماز)

اضافی باتیں:

• فجر کی اذان میں سنی روایت میں ایک اضافی فقرہ ہے: "الصلوٰۃ خیر من النوم" (نماز نیند سے بہتر ہے)
• مؤذن کو نماز کے وقت کے بالکل آغاز میں اذان دینی چاہیے
• یہ مستحب ہے کہ اذان عربی میں دی جائے
• مؤذن کو کمیونٹی یا مسجد انتظامیہ کی طرف سے منتخب کیا جانا چاہیے
• ان لوگوں کو ترجیح دی جانی چاہیے جو اللہ کی خاطر رضاکارانہ طور پر بغیر معاوضے کی توقع کے یہ کام کرتے ہیں

مؤذن کے لیے اجر:

نبی ﷺ نے فرمایا: "جو شخص بارہ سال اذان دے، اس کے لیے جنت واجب ہو جاتی ہے، اور ہر دن اس کی اذان کی وجہ سے ساٹھ نیکیاں اور اس کی اقامت کی وجہ سے تیس نیکیاں لکھی جائیں گی۔" (سنن ابن ماجہ)

مستند ذرائع:
• صحیح بخاری
• صحیح مسلم
• سنن ابوداؤد
• سنن ابن ماجہ
• الموسوعۃ الفقہیہ (اسلامی فقہ کی انسائیکلوپیڈیا)''',
        'hindi': '''मुअज़्ज़िन के लिए शर्तें और तक़ाज़े

अज़ान कौन दे?

ज़रूरी अहलियतें:

1. मुसलमान और मोमिन:
मुअज़्ज़िन का मुसलमान होना ज़रूरी है जो अल्लाह की वहदानियत और मुहम्मद ﷺ की नुबुव्वत पर ईमान रखता हो। यह बुनियादी तक़ाज़ा है।

2. नमाज़ के औक़ात का इल्म:
मुअज़्ज़िन को नमाज़ के सही औक़ात का इल्म होना चाहिए और यह जानना चाहिए कि हर नमाज़ कब वाजिब होती है। वह क़ाबिल-ए-एतिमाद और वक़्त का पाबंद होना चाहिए।

3. मज़बूत और ख़ूबसूरत आवाज़:
नबी ﷺ ने फ़रमाया: "बेशक अल्लाह अज़ान में ख़ूबसूरत आवाज़ को पसंद करता है।" (सही बुख़ारी)
• आवाज़ इतनी बुलंद होनी चाहिए कि कम्युनिटी तक पहुंच सके
• यह ख़ुश-अल्हान और सुनने में ख़ुशगवार होनी चाहिए
• वाज़ेह तलफ़्फ़ुज़ ज़रूरी है

4. मर्द (अक्सरियती राय के मुताबिक़):
चारों बड़े सुन्नी मकातिब-ए-फ़िक्र (हनफ़ी, मालिकी, शाफ़ई और हंबली) के उलमा मुत्तफ़िक़ हैं कि मर्दों की बाजमाअत नमाज़ के लिए मर्द को अज़ान देनी चाहिए। ख़वातीन घर पर मुकम्मल तौर पर ख़वातीन की जमाअत के लिए आहिस्ता आवाज़ में अज़ान दे सकती हैं।

5. पाकीज़गी की हालत (मुस्तहब):
अगरचे यह सख़्ती से वाजिब नहीं है, लेकिन यह बहुत ज़्यादा मुस्तहब है कि मुअज़्ज़िन अज़ान देते वक़्त वुज़ू की हालत में हो।

6. क़ाबिल-ए-एतिमाद किरदार:
मुअज़्ज़िन ईमानदारी, क़ाबिल-ए-एतिमाद होने और अच्छे किरदार के लिए जाना जाना चाहिए। नबी ﷺ ने फ़रमाया: "तुम्हारे इमाम और तुम्हारे मुअज़्ज़िन अल्लाह के सामने तुम्हारे नुमाइंदे हैं।"

7. आक़िल और बालिग़:
मुअज़्ज़िन को सही-उल-दिमाग़ और तर्जीहन बालिग़ होना चाहिए, अगरचे बहुत से उलमा के मुताबिक़ समझदार बच्चे की अज़ान भी दुरुस्त समझी जाती है।

अज़ान देने का सही तरीक़ा:

1. क़िबला रुख़ होना:
मुअज़्ज़िन को अज़ान शुरू करते वक़्त क़िबला (मक्का में काबा की सिम्त) की तरफ़ मुंह करना चाहिए।

2. कानों में उंगलियां रखना:
मुअज़्ज़िन को अज़ान देते वक़्त अपनी शहादत की उंगलियां कानों में रखनी चाहिए। यह आवाज़ को मज़ीद आगे फैलाने में मदद करता है और बाहरी आवाज़ों को रोकता है।

3. मख़सूस अल्फ़ाज़ के दौरान मुड़ना:
• "हय्या अलस्सलाह" (नमाज़ की तरफ़ आओ) कहते वक़्त, चेहरा दाईं तरफ़ मोड़ें
• "हय्या अलल-फ़लाह" (कामयाबी की तरफ़ आओ) कहते वक़्त, चेहरा बाईं तरफ़ मोड़ें
• जिस्म को क़िबला की तरफ़ ही रहना चाहिए

4. बुलंद जगह पर खड़े होना:
यह मुस्तहब है कि अज़ान किसी बुलंद जगह जैसे मीनार से दी जाए ताकि आवाज़ दूर तक पहुंच सके। यह इस्लामी फ़न-ए-तामीर में मीनारों का असल मक़सद था।

5. मुतवाज़िन रफ़्तार:
अज़ान आहिस्ता और ख़ुश-अल्हानी से दी जानी चाहिए, जबकि इक़ामत तेज़ होनी चाहिए। नबी ﷺ ने बिलाल रज़ियल्लाहु अन्हु को हुक्म दिया: "अपनी अज़ान आहिस्ता और इक़ामत तेज़ करो।"

अज़ान के औक़ात:

अज़ान रोज़ाना पांच बार दी जाती है:
1. फ़ज्र (सुबह की नमाज़)
2. ज़ुहर (दोपहर की नमाज़)
3. अस्र (सह-पहर की नमाज़)
4. मग़रिब (ग़ुरूब-ए-आफ़्ताब की नमाज़)
5. इशा (रात की नमाज़)

इज़ाफ़ी बातें:

• फ़ज्र की अज़ान में सुन्नी रिवायत में एक इज़ाफ़ी फ़िक़रा है: "अस्सलातु ख़ैरुम्मिनन्नौम" (नमाज़ नींद से बेहतर है)
• मुअज़्ज़िन को नमाज़ के वक़्त के बिल्कुल आग़ाज़ में अज़ान देनी चाहिए
• यह मुस्तहब है कि अज़ान अरबी में दी जाए
• मुअज़्ज़िन को कम्युनिटी या मस्जिद इंतिज़ामिया की तरफ़ से मुंतख़ब किया जाना चाहिए
• उन लोगों को तर्जीह दी जानी चाहिए जो अल्लाह की ख़ातिर रिज़ाकारना तौर पर बग़ैर मुआवज़े की तवक़्क़ो के यह काम करते हैं

मुअज़्ज़िन के लिए अज्र:

नबी ﷺ ने फ़रमाया: "जो शख़्स बारह साल अज़ान दे, उसके लिए जन्नत वाजिब हो जाती है, और हर दिन उसकी अज़ान की वजह से साठ नेकियां और उसकी इक़ामत की वजह से तीस नेकियां लिखी जाएंगी।" (सुनन इब्न-ए-माजा)

मुस्तनद ज़राये:
• सही बुख़ारी
• सही मुस्लिम
• सुनन अबू दाऊद
• सुनन इब्न-ए-माजा
• अल-मौसूअ अल-फ़िक़हिय्याह (इस्लामी फ़िक़्ह की एनसाइक्लोपीडिया)''',
        'arabic': '''شروط ومتطلبات المؤذن

من ينبغي أن يؤذن؟

المؤهلات الأساسية:

١. مسلم ومؤمن:
يجب أن يكون المؤذن مسلماً يؤمن بوحدانية الله ونبوة محمد ﷺ. هذا شرط أساسي.

٢. معرفة أوقات الصلاة:
ينبغي أن يكون المؤذن على دراية بأوقات الصلاة الصحيحة وقادراً على تحديد موعد كل صلاة. يجب أن يكون موثوقاً ودقيقاً في المواعيد.

٣. صوت قوي وجميل:
قال النبي ﷺ: "إن الله يحب الصوت الحسن في الأذان." (صحيح البخاري)
• يجب أن يكون الصوت عالياً بما يكفي للوصول إلى المجتمع
• يجب أن يكون لحنياً وممتعاً للسماع
• النطق الواضح ضروري

٤. ذكر (حسب رأي الأغلبية):
يتفق علماء المذاهب السنية الأربعة الكبرى (الحنفي والمالكي والشافعي والحنبلي) على أن الأذان يجب أن يُنادى به رجل لصلوات الجماعة للرجال. يمكن للنساء أن ينادين بالأذان لجماعات النساء فقط في المنزل بصوت منخفض.

٥. حالة الطهارة (مستحب):
على الرغم من أنه ليس واجباً بشكل صارم، إلا أنه يُستحب بشدة أن يكون المؤذن في حالة وضوء عند الأذان.

٦. شخصية جديرة بالثقة:
يجب أن يُعرف المؤذن بالصدق والموثوقية والشخصية الحسنة. قال النبي ﷺ: "إن أئمتكم ومؤذنيكم وفدكم إلى الله."

٧. عاقل وبالغ:
يجب أن يكون المؤذن سليم العقل ويُفضل أن يكون بالغاً، على الرغم من أن أذان الطفل المميز يُعتبر أيضاً صحيحاً من قبل العديد من العلماء.

الطريقة الصحيحة للأذان:

١. مواجهة القبلة:
يجب على المؤذن أن يواجه القبلة (اتجاه الكعبة في مكة) عند بدء الأذان.

٢. وضع الأصابع في الأذنين:
يجب على المؤذن أن يضع أصابعه السبابة في أذنيه أثناء الأذان. هذا يساعد على إبراز الصوت بشكل أكبر ويمنع الأصوات الخارجية.

٣. الالتفات أثناء عبارات معينة:
• عند قول "حي على الصلاة"، التفت بالوجه إلى اليمين
• عند قول "حي على الفلاح"، التفت بالوجه إلى اليسار
• يجب أن يبقى الجسم متجهاً نحو القبلة

٤. الوقوف في مكان مرتفع:
يُستحب أن يُؤذن من مكان مرتفع مثل المئذنة حتى يصل الصوت إلى أبعد مدى. كان هذا الغرض الأصلي للمآذن في العمارة الإسلامية.

٥. الوتيرة المقاسة:
يجب أن يُنادى بالأذان ببطء ولحن، بينما يجب أن تكون الإقامة أسرع. أمر النبي ﷺ بلالاً: "اجعل أذانك بطيئاً وإقامتك سريعة."

أوقات الأذان:

يُنادى بالأذان خمس مرات يومياً لـ:
١. الفجر (صلاة الفجر)
٢. الظهر (صلاة الظهر)
٣. العصر (صلاة العصر)
٤. المغرب (صلاة المغرب)
٥. العشاء (صلاة العشاء)

اعتبارات إضافية:

• أذان الفجر له عبارة إضافية في التقليد السني: "الصلاة خير من النوم"
• يجب على المؤذن أن ينادي بالأذان في بداية وقت الصلاة بالضبط
• يُستحب أن يُؤذن بالعربية
• يجب أن يُختار المؤذن من قبل المجتمع أو إدارة المسجد
• يجب إعطاء الأولوية لمن يتطوعون لوجه الله دون توقع أجر

ثواب المؤذن:

قال النبي ﷺ: "من أذن اثنتي عشرة سنة وجبت له الجنة، وكُتب له بكل أذان ستون حسنة وبكل إقامة ثلاثون حسنة." (سنن ابن ماجه)

المصادر الموثوقة:
• صحيح البخاري
• صحيح مسلم
• سنن أبي داود
• سنن ابن ماجه
• الموسوعة الفقهية (موسوعة الفقه الإسلامي)''',
      },
    },
    {
      'number': 8,
      'titleKey': 'azan_8_women_and_azan',
      'title': 'Women and Azan',
      'titleUrdu': 'خواتین اور اذان',
      'titleHindi': 'ख़वातीन और अज़ान',
      'titleArabic': 'النساء والأذان',
      'icon': Icons.woman,
      'color': Colors.purple,
      'details': {
        'english': '''Women and Azan

Islamic Rulings on Women Calling Azan

Mainstream Scholarly Consensus (Sunni):

The scholars of the four major Sunni schools of jurisprudence agree that it is not prescribed for women to give the Adhan for men. This represents the consensus across the four madhabs:

1. Hanafi School:
According to all Hanafi reports, it is not allowed for a woman to give the Adhan for men's prayers. A woman's voice is considered 'awrah (to be concealed) in the context of worship when non-mahram men are present.

2. Maliki School:
The Adhan of a woman for men is not valid according to Maliki scholars. The Adhan is specifically designated as a male duty.

3. Shafi'i School:
A woman should not give the call to prayer for men, and if she gives the Adhan in such circumstances, her Adhan is not valid for the congregation.

4. Hanbali School:
The Adhan of a woman for men is not considered valid in the Hanbali school.

Reason for the Ruling:
• The Adhan requires a loud, public voice that carries far distances
• It involves raising the voice in a way that would be heard by non-mahram men
• The Adhan has always been performed by men since the time of the Prophet ﷺ
• There is no authentic narration of women giving Adhan during the Prophet's time

Women Calling Azan at Home:

Permitted Scenario:
Women can call the Adhan at home, but only under specific conditions:

1. All-Female Congregation:
If the congregation consists only of women, a woman may call the Adhan. She should recite it in a moderate voice, not extremely loud.

2. Position During Prayer:
When a woman leads other women in prayer, she should stand in the middle of the first row, not ahead of them like male imams.

3. Privacy:
The Adhan should be called in a way that non-mahram men cannot hear it.

Minority Scholarly Opinions:

According to some scholars within the Maliki, Shafi'i and Hanbali schools, there is no harm in a woman calling the Azan and saying the Iqamah for herself or for other women, though this represents a minority view.

Shia Perspective:

Highly Recommended for Both Genders:
According to Shia jurisprudence, it is highly recommended (mustahabb) for both men and women to recite Adhan and Iqamah, especially if they are praying individually and not in congregation (jama'ah).

Key Difference:
The important distinction is that a female should recite in a low voice in the presence of non-mahram men, but she can recite it normally when alone or with mahram family members.

Women Responding to Azan:

All Scholars Agree:
All scholars unanimously agree that women should respond to the Adhan when they hear it, just as men do. When the muezzin says each phrase, women should repeat it softly.

After the Adhan, women should recite:
"Allahumma Rabba hadhihi-d-da'watit-tammah, was-salatil qa'imah, ati Muhammadan al-wasilata wal-fadilah, wab'ath-hu maqaman mahmudan-il-ladhi wa'adtahu"

(O Allah, Lord of this perfect call and established prayer, grant Muhammad the intercession and superiority, and raise him to the praiseworthy station You have promised him)

Women Attending Mosque for Prayers:

The Prophet ﷺ said: "Do not prevent the female servants of Allah from going to the mosques of Allah." (Sahih Bukhari)

However, women are not required to attend mosques for prayers, and praying at home is considered better for them according to most scholars. If they do attend, they should:
• Wear appropriate hijab
• Use the designated women's prayer area
• Avoid wearing perfume
• Enter and exit quietly

Wisdom Behind the Ruling:

The Islamic ruling on women and Adhan reflects:
• The principle of modesty (hayaa) in Islam
• The different roles assigned to men and women in public worship
• The protection of women from unnecessary exposure
• The preservation of the sanctity of worship

Important Note:
These rulings do not diminish the spiritual status of women in Islam. Women have equal opportunity for reward and closeness to Allah through prayer and other acts of worship.

Authentic Sources:
• Islamweb Fatwa 318619
• IslamQA Fatwa 39186
• SeekersGuidance
• Al-Islam.org
• Fiqh Encyclopedia''',
        'urdu': '''خواتین اور اذان

اذان دینے کے بارے میں اسلامی احکام

مرکزی علمائے دھارا کا اتفاق (سنی):

چاروں بڑے سنی فقہی مکاتب فکر کے علماء اس بات پر متفق ہیں کہ خواتین کے لیے مردوں کو اذان دینا مشروع نہیں ہے۔ یہ چاروں مذاہب میں اجماع کی نمائندگی کرتا ہے:

1. حنفی مکتب فکر:
تمام حنفی روایات کے مطابق، خاتون کے لیے مردوں کی نماز کے لیے اذان دینا جائز نہیں ہے۔ عبادت کے تناظر میں جب نامحرم مرد موجود ہوں تو خاتون کی آواز کو عورت سمجھا جاتا ہے۔

2. مالکی مکتب فکر:
مالکی علماء کے مطابق مردوں کے لیے خاتون کی اذان درست نہیں ہے۔ اذان خاص طور پر مردوں کی ذمہ داری کے طور پر مقرر کی گئی ہے۔

3. شافعی مکتب فکر:
خاتون کو مردوں کے لیے اذان نہیں دینی چاہیے، اور اگر وہ ایسے حالات میں اذان دیتی ہے، تو اس کی اذان جماعت کے لیے درست نہیں ہے۔

4. حنبلی مکتب فکر:
حنبلی مکتب فکر میں مردوں کے لیے خاتون کی اذان کو درست نہیں سمجھا جاتا۔

حکم کی وجہ:
• اذان میں بلند اور عوامی آواز کی ضرورت ہوتی ہے جو دور تک پہنچے
• اس میں آواز بلند کرنا شامل ہے جو نامحرم مردوں کو سنائی دے
• نبی ﷺ کے دور سے اذان ہمیشہ مردوں نے دی ہے
• نبی ﷺ کے دور میں خواتین کے اذان دینے کی کوئی مستند روایت نہیں ہے

گھر میں خواتین کا اذان دینا:

جائز صورت حال:
خواتین گھر میں اذان دے سکتی ہیں، لیکن صرف مخصوص شرائط کے تحت:

1. مکمل خواتین کی جماعت:
اگر جماعت میں صرف خواتین ہوں، تو خاتون اذان دے سکتی ہے۔ اسے معتدل آواز میں پڑھنا چاہیے، انتہائی بلند نہیں۔

2. نماز کے دوران پوزیشن:
جب خاتون دوسری خواتین کو نماز پڑھائے، تو اسے پہلی صف کے وسط میں کھڑا ہونا چاہیے، نہ کہ ان سے آگے جیسے مرد امام۔

3. رازداری:
اذان اس طرح دی جانی چاہیے کہ نامحرم مرد اسے نہ سن سکیں۔

اقلیتی علمائے رائے:

مالکی، شافعی اور حنبلی مکاتب فکر کے کچھ علماء کے مطابق، خاتون کے لیے اپنے لیے یا دوسری خواتین کے لیے اذان اور اقامت کہنے میں کوئی حرج نہیں، حالانکہ یہ اقلیتی نظریہ ہے۔

شیعہ نقطہ نظر:

دونوں جنسوں کے لیے انتہائی مستحب:
شیعہ فقہ کے مطابق، مردوں اور خواتین دونوں کے لیے اذان اور اقامت پڑھنا انتہائی مستحب ہے، خاص طور پر اگر وہ انفرادی طور پر نماز پڑھ رہے ہوں اور جماعت میں نہ ہوں۔

اہم فرق:
اہم فرق یہ ہے کہ خاتون کو نامحرم مردوں کی موجودگی میں آہستہ آواز میں پڑھنا چاہیے، لیکن جب اکیلی ہو یا محرم خاندان کے افراد کے ساتھ ہو تو عام طور پر پڑھ سکتی ہے۔

اذان کا جواب دینا:

تمام علماء کا اتفاق:
تمام علماء متفقہ طور پر اس بات پر متفق ہیں کہ خواتین کو اذان سننے پر اس کا جواب دینا چاہیے، جیسے مرد دیتے ہیں۔ جب مؤذن ہر فقرہ کہے، خواتین کو اسے آہستہ دہرانا چاہیے۔

اذان کے بعد، خواتین کو یہ دعا پڑھنی چاہیے:
"اللہم رب ہذہ الدعوۃ التامۃ والصلوٰۃ القائمۃ آت محمدا الوسیلۃ والفضیلۃ وابعثہ مقاما محمودا الذی وعدتہ"

(اے اللہ، اس کامل دعوت اور قائم نماز کے رب، محمد ﷺ کو وسیلہ اور فضیلت عطا فرما، اور انہیں اس قابل تعریف مقام پر اٹھا جس کا تو نے وعدہ کیا ہے)

نماز کے لیے مسجد میں خواتین کی حاضری:

نبی ﷺ نے فرمایا: "اللہ کی بندیوں کو اللہ کی مساجد میں جانے سے نہ روکو۔" (صحیح بخاری)

تاہم، خواتین کو نماز کے لیے مساجد میں حاضر ہونا ضروری نہیں ہے، اور زیادہ تر علماء کے مطابق گھر میں نماز پڑھنا ان کے لیے بہتر سمجھا جاتا ہے۔ اگر وہ حاضر ہوں تو انہیں چاہیے:
• مناسب حجاب پہنیں
• خواتین کی نماز کے مخصوص علاقے کا استعمال کریں
• خوشبو لگانے سے پرہیز کریں
• خاموشی سے داخل اور باہر نکلیں

حکم کے پیچھے حکمت:

خواتین اور اذان پر اسلامی حکم عکس کرتا ہے:
• اسلام میں شرم (حیا) کا اصول
• عوامی عبادت میں مردوں اور خواتین کو تفویض کردہ مختلف کردار
• خواتین کو غیر ضروری نمائش سے تحفظ
• عبادت کی تقدس کی حفاظت

اہم نوٹ:
یہ احکام اسلام میں خواتین کی روحانی حیثیت کو کم نہیں کرتے۔ خواتین کو نماز اور دیگر عبادات کے ذریعے اجر اور اللہ کی قربت کے مساوی مواقع ہیں۔

مستند ذرائع:
• اسلام ویب فتویٰ 318619
• اسلام کیو اے فتویٰ 39186
• سیکرز گائیڈنس
• الاسلام ڈاٹ آرگ
• فقہی انسائیکلوپیڈیا''',
        'hindi': '''ख़वातीन और अज़ान

अज़ान देने के बारे में इस्लामी अहकाम

मर्कज़ी उलमा धारा का इत्तिफ़ाक़ (सुन्नी):

चारों बड़े सुन्नी फ़िक़ही मकातिब-ए-फ़िक्र के उलमा इस बात पर मुत्तफ़िक़ हैं कि ख़वातीन के लिए मर्दों को अज़ान देना मशरू नहीं है। यह चारों मज़ाहिब में इज्मा की नुमाइंदगी करता है:

1. हनफ़ी मकतब-ए-फ़िक्र:
तमाम हनफ़ी रिवायात के मुताबिक़, ख़ातून के लिए मर्दों की नमाज़ के लिए अज़ान देना जायज़ नहीं है। इबादत के तनाज़ुर में जब ना-महरम मर्द मौजूद हों तो ख़ातून की आवाज़ को औरत समझा जाता है।

2. मालिकी मकतब-ए-फ़िक्र:
मालिकी उलमा के मुताबिक़ मर्दों के लिए ख़ातून की अज़ान दुरुस्त नहीं है। अज़ान ख़ास तौर पर मर्दों की ज़िम्मेदारी के तौर पर मुक़र्रर की गई है।

3. शाफ़ई मकतब-ए-फ़िक्र:
ख़ातून को मर्दों के लिए अज़ान नहीं देनी चाहिए, और अगर वह ऐसे हालात में अज़ान देती है, तो उसकी अज़ान जमाअत के लिए दुरुस्त नहीं है।

4. हंबली मकतब-ए-फ़िक्र:
हंबली मकतब-ए-फ़िक्र में मर्दों के लिए ख़ातून की अज़ान को दुरुस्त नहीं समझा जाता।

हुक्म की वजह:
• अज़ान में बुलंद और आम आवाज़ की ज़रूरत होती है जो दूर तक पहुंचे
• इसमें आवाज़ बुलंद करना शामिल है जो ना-महरम मर्दों को सुनाई दे
• नबी ﷺ के दौर से अज़ान हमेशा मर्दों ने दी है
• नबी ﷺ के दौर में ख़वातीन के अज़ान देने की कोई मुस्तनद रिवायत नहीं है

घर में ख़वातीन का अज़ान देना:

जायज़ सूरत-ए-हाल:
ख़वातीन घर में अज़ान दे सकती हैं, लेकिन सिर्फ़ मख़सूस शराइत के तहत:

1. मुकम्मल ख़वातीन की जमाअत:
अगर जमाअत में सिर्फ़ ख़वातीन हों, तो ख़ातून अज़ान दे सकती है। उसे मोतदिल आवाज़ में पढ़ना चाहिए, इंतिहाई बुलंद नहीं।

2. नमाज़ के दौरान पोज़ीशन:
जब ख़ातून दूसरी ख़वातीन को नमाज़ पढ़ाए, तो उसे पहली सफ़ के वसत में खड़ा होना चाहिए, न कि उनसे आगे जैसे मर्द इमाम।

3. राज़दारी:
अज़ान इस तरह दी जानी चाहिए कि ना-महरम मर्द इसे न सुन सकें।

इक़लियती उलमा राय:

मालिकी, शाफ़ई और हंबली मकातिब-ए-फ़िक्र के कुछ उलमा के मुताबिक़, ख़ातून के लिए अपने लिए या दूसरी ख़वातीन के लिए अज़ान और इक़ामत कहने में कोई हर्ज नहीं, हालांकि यह इक़ल��यती नज़रिया है।

शिया नज़रिया:

दोनों जिन्सों के लिए इंतिहाई मुस्तहब:
शिया फ़िक़्ह के मुताबिक़, मर्दों और ख़वातीन दोनों के लिए अज़ान और इक़ामत पढ़ना इंतिहाई मुस्तहब है, ख़ास तौर पर अगर वे इन्फ़िरादी तौर पर नमाज़ पढ़ रहे हों और जमाअत में न हों।

अहम फ़र्क़:
अहम फ़र्क़ यह है कि ख़ातून को ना-महरम मर्दों की मौजूदगी में आहिस्ता आवाज़ में पढ़ना चाहिए, लेकिन जब अकेली हो या महरम ख़ानदान के अफ़राद के साथ हो तो आम तौर पर पढ़ सकती है।

अज़ान का जवाब देना:

तमाम उलमा का इत्तिफ़ाक़:
तमाम उलमा मुत्तफ़िक़ा तौर पर इस बात पर मुत्तफ़िक़ हैं कि ख़वातीन को अज़ान सुनने पर इसका जवाब देना चाहिए, जैसे मर्द देते हैं। जब मुअज़्ज़िन हर फ़िक़रा कहे, ख़वातीन को इसे आहिस्ता दोहराना चाहिए।

अज़ान के बाद, ख़वातीन को यह दुआ पढ़नी चाहिए:
"अल्लाहुम्मा रब्ब हाज़िहिद्दअवतित्तम्मह वस्सलातिल क़ाइमह आति मुहम्मदनिल वसीलत वल-फ़ज़ीलह वब-अस्हु मक़ामम्महमूदनिल-लज़ी वअद्तहु"

(ऐ अल्लाह, इस कामिल दावत और क़ायम नमाज़ के रब, मुहम्मद ﷺ को वसीला और फ़ज़ीलत अता फ़रमा, और उन्हें उस क़ाबिल-ए-तारीफ़ मक़ाम पर उठा जिसका तूने वादा किया है)

नमाज़ के लिए मस्जिद में ख़वातीन की हाज़िरी:

नबी ﷺ ने फ़रमाया: "अल्लाह की बंदियों को अल्लाह की मस्जिदों में जाने से न रोको।" (सही बुख़ारी)

ताहम, ख़वातीन को नमाज़ के लिए मस्जिदों में हाज़िर होना ज़रूरी नहीं है, और ज़्यादातर उलमा के मुताबिक़ घर में नमाज़ पढ़ना उनके लिए बेहतर समझा जाता है। अगर वे हाज़िर हों तो उन्हें चाहिए:
• मुनासिब हिजाब पहनें
• ख़वातीन की नमाज़ के मख़सूस इलाक़े का इस्तेमाल करें
• ख़ुशबू लगाने से परहेज़ करें
• ख़ामोशी से दाख़िल और बाहर निकलें

हुक्म के पीछे हिकमत:

ख़वातीन और अज़ान पर इस्लामी हुक्म अक्स करता है:
• इस्लाम में शर्म (हया) का उसूल
• आम इबादत में मर्दों और ख़वातीन को तफ़वीज़ करदा मुख़्तलिफ़ किरदार
• ख़वातीन को ग़ैर-ज़रूरी नुमाइश से तहफ़्फ़ुज़
• इबादत की तक़द्दुस की हिफ़ाज़त

अहम नोट:
यह अहकाम इस्लाम में ख़वातीन की रूहानी हैसियत को कम नहीं करते। ख़वातीन को नमाज़ और दीगर इबादात के ज़रिये अज्र और अल्लाह की क़ुर्बत के मुसावी मवाक़े हैं।

मुस्तनद ज़राये:
• इस्लाम वेब फ़तवा 318619
• इस्लाम क्यू ए फ़तवा 39186
• सीकर्स गाइडन्स
• अल-इस्लाम डॉट ऑर्ग
• फ़िक़ही एनसाइक्लोपीडिया''',
        'arabic': '''النساء والأذان

الأحكام الإسلامية حول النساء والأذان

الإجماع العلمائي السائد (السنة):

يتفق علماء المذاهب السنية الأربعة الرئيسية على أنه لا يُشرع للمرأة أن تؤذن للرجال. وهذا يمثل الإجماع عبر المذاهب الأربعة:

١. المذهب الحنفي:
وفقاً لجميع الروايات الحنفية، لا يجوز للمرأة أن تؤذن لصلاة الرجال. يعتبر صوت المرأة عورة في سياق العبادة عند وجود رجال غير محارم.

٢. المذهب المالكي:
أذان المرأة للرجال غير صحيح وفقاً لعلماء المالكية. الأذان مخصص على وجه التحديد كواجب ذكوري.

٣. المذهب الشافعي:
لا ينبغي للمرأة أن تنادي بالصلاة للرجال، وإذا أذنت في مثل هذه الظروف، فإن أذانها غير صحيح للجماعة.

٤. المذهب الحنبلي:
لا يعتبر أذان المرأة للرجال صحيحاً في المذهب الحنبلي.

سبب الحكم:
• يتطلب الأذان صوتاً عالياً وعلنياً يصل إلى مسافات بعيدة
• يتضمن رفع الصوت بطريقة يسمعها رجال غير محارم
• تم أداء الأذان دائماً من قبل الرجال منذ عهد النبي ﷺ
• لا توجد رواية صحيحة عن النساء يؤذن في عهد النبي ﷺ

النساء يؤذن في المنزل:

السيناريو المسموح:
يمكن للنساء أن يؤذن في المنزل، ولكن فقط في ظروف محددة:

١. جماعة النساء فقط:
إذا كانت الجماعة تتكون من نساء فقط، فيمكن للمرأة أن تؤذن. يجب عليها أن تتلوه بصوت معتدل، وليس بصوت عالٍ للغاية.

٢. الموقف أثناء الصلاة:
عندما تؤم المرأة نساء أخريات في الصلاة، يجب أن تقف في منتصف الصف الأول، وليس أمامهن مثل الأئمة الذكور.

٣. الخصوصية:
يجب أن يُنادى بالأذان بطريقة لا يسمعه رجال غير محارم.

الآراء العلمائية الأقلية:

وفقاً لبعض العلماء في المذاهب المالكية والشافعية والحنبلية، لا حرج في أن تؤذن المرأة وتقول الإقامة لنفسها أو لنساء أخريات، على الرغم من أن هذا يمثل رأياً أقلياً.

المنظور الشيعي:

مستحب بشدة لكلا الجنسين:
وفقاً للفقه الشيعي، يُستحب بشدة لكل من الرجال والنساء أن يتلوا الأذان والإقامة، خاصة إذا كانوا يصلون فردياً وليس في جماعة.

الفرق الرئيسي:
التمييز المهم هو أن على الأنثى أن تتلو بصوت منخفض في حضور رجال غير محارم، ولكن يمكنها أن تتلوه بشكل طبيعي عندما تكون وحدها أو مع أفراد الأسرة المحارم.

النساء يجيبن على الأذان:

جميع العلماء متفقون:
يتفق جميع العلماء بالإجماع على أن النساء يجب أن يجيبن على الأذان عند سماعه، تماماً كما يفعل الرجال. عندما يقول المؤذن كل عبارة، يجب على النساء تكرارها بهدوء.

بعد الأذان، يجب على النساء أن يتلون:
"اللهم رب هذه الدعوة التامة والصلاة القائمة آت محمداً الوسيلة والفضيلة وابعثه مقاماً محموداً الذي وعدته"

حضور النساء في المسجد للصلوات:

قال النبي ﷺ: "لا تمنعوا إماء الله مساجد الله." (صحيح البخاري)

ومع ذلك، لا يُطلب من النساء حضور المساجد للصلوات، ويُعتبر الصلاة في المنزل أفضل لهن وفقاً لمعظم العلماء. إذا حضرن، يجب عليهن:
• ارتداء الحجاب المناسب
• استخدام منطقة الصلاة المخصصة للنساء
• تجنب ارتداء العطور
• الدخول والخروج بهدوء

الحكمة وراء الحكم:

يعكس الحكم الإسلامي على النساء والأذان:
• مبدأ الحياء في الإسلام
• الأدوار المختلفة المخصصة للرجال والنساء في العبادة العامة
• حماية النساء من التعرض غير الضروري
• الحفاظ على قدسية العبادة

ملاحظة مهمة:
هذه الأحكام لا تنتقص من المكانة الروحية للمرأة في الإسلام. للنساء فرصة متساوية للثواب والقرب من الله من خلال الصلاة وغيرها من أعمال العبادة.

المصادر الموثوقة:
• إسلام ويب فتوى 318619
• إسلام كيو إيه فتوى 39186
• سيكرز جايدنس
• الإسلام.org
• الموسوعة الفقهية''',
      },
    },
    {
      'number': 9,
      'titleKey': 'azan_9_sunni_shia_differences',
      'title': 'Sunni and Shia Differences in Azan',
      'titleUrdu': 'اذان میں سنی اور شیعہ اختلافات',
      'titleHindi': 'अज़ान में सुन्नी और शिया इख़्तिलाफ़ात',
      'titleArabic': 'الاختلافات بين السنة والشيعة في الأذان',
      'icon': Icons.compare_arrows,
      'color': Colors.orange,
      'details': {
        'english': '''Sunni and Shia Differences in Azan

Main Differences Between Sunni and Shia Adhan

While the core of the Adhan is the same, there are notable differences in practice between Sunni and Shia traditions:

1. "Hayya 'ala Khayril 'Amal" (Come to the Best of Deeds)

Shia Perspective:
Shia Muslims include the phrase حَيَّ عَلَىٰ خَيْرِ الْعَمَلِ (Hayy-a 'ala khayr-il 'amal) which means "Come to the best of deeds" or "Hurry to the best action."

Position in Adhan:
This phrase is recited twice after "Hayya 'ala-l-falah" (Come to success).

Historical Context:
Shia sources maintain that this phrase was part of the original Adhan taught by the Prophet ﷺ but was later removed during the caliphate of Umar ibn al-Khattab.

Sunni Perspective:
Sunni Muslims do not include this phrase in the Adhan. The mainstream Sunni schools (Hanafi, Maliki, Shafi'i, Hanbali) consider that this phrase was never part of the authentic Adhan as taught by the Prophet ﷺ.

2. "Tathwib" - Prayer is Better Than Sleep

Sunni Practice:
In Sunni tradition, the phrase الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ (As-salatu khayrun min an-naum) meaning "Prayer is better than sleep" is added to the Fajr (dawn) Adhan.

Position: This phrase is recited twice after "Hayya 'ala-l-falah" during the Fajr Adhan only.

Historical Basis:
According to Sunni sources, this addition was approved by the Prophet ﷺ when suggested by the companion Abdullah ibn Zaid or Abu Mahdhurah.

Shia Perspective:
Shia Muslims do not include "Tathwib" in the official Adhan. They consider it a bid'ah (innovation) that was not part of the original Adhan taught by the Prophet ﷺ.

Shia View on Tathwib:
According to Imamiyyah jurisprudence, Tathwib was never accepted and is considered an innovation introduced after the Prophet's time.

3. Testimony of Wilaya (Ali's Guardianship)

Shia Additional Phrase:
Some Shia Muslims recite: أَشْهَدُ أَنَّ عَلِيًّا وَلِيُّ اللَّهِ (Ash-hadu anna 'Ali-yyan wali-yyu Allah) meaning "I testify that Ali is the friend/guardian of Allah."

Important Note:
This phrase is NOT considered part of the official Adhan or Iqama in Shia jurisprudence. It is recited as a matter of personal devotion and ijtihad (scholarly interpretation), not as an obligatory part of the Adhan.

Position in Recitation:
When recited, it comes after the testimony of the Prophet's prophethood.

Scholarly Debate:
There is discussion among Shia scholars about whether this should be recited, with many emphasizing it is mustahabb (recommended) for personal devotion but not part of the official Adhan formula.

4. Number of Repetitions

Sunni Practice:
• "Allahu Akbar" - 4 times at the beginning (according to most schools)
• Final "La ilaha illallah" - 1 time at the end

Variations:
The Maliki school holds that "Allahu Akbar" should be recited only twice at the beginning, not four times.

Shia Practice:
• "Allahu Akbar" - 4 times at the beginning
• Final "La ilaha illallah" - 2 times at the end

5. Origin of the Adhan

Sunni Belief:
The Adhan was revealed through the dream of Abdullah ibn Zayd, a companion of the Prophet ﷺ. When he narrated his dream to the Prophet ﷺ, the Prophet confirmed it as divine guidance and instructed Bilal to call it.

Shia Belief:
All Imamiyyah jurisprudents, following the Ahl al-Bayt, believe that the Adhan began with God's direct order and revelation to the Prophet's heart (wahy), not through a companion's dream.

Divine Source:
Shia sources emphasize that the Adhan is too important a ritual to have originated from a dream, and must have come through divine revelation directly to the Prophet ﷺ.

Common Ground:

Despite these differences, both traditions agree on:
• The fundamental importance of Adhan in Islam
• The core phrases testifying to Allah's greatness and Muhammad's prophethood
• The five daily prayer times requiring Adhan
• The spiritual rewards for the mu'adhdhin
• The obligation to respond when hearing Adhan
• The beauty and importance of a melodious Adhan

Unity in Diversity:

These differences reflect the rich scholarly tradition in Islam and different interpretations of historical sources. Both Sunni and Shia Muslims use the Adhan as a beautiful call to worship Allah and fulfill one of the five pillars of Islam.

The core message remains the same:
• Allah is the Greatest
• There is no god but Allah
• Muhammad is the Messenger of Allah
• Come to prayer, come to success

Authentic Sources:
• Adhan - Wikipedia
• Tradition and Heresy in Adhan - Al-Islam.org
• Adhan - WikiShia
• Islamic Jurisprudence Encyclopedias
• Comparative Fiqh Studies''',
        'urdu': '''اذان میں سنی اور شیعہ اختلافات

سنی اور شیعہ اذان میں اہم اختلافات

اگرچہ اذان کا بنیادی حصہ ایک جیسا ہے، لیکن سنی اور شیعہ روایات میں عمل میں قابل ذکر فرق ہیں:

1. "حَیَّ عَلَىٰ خَیْرِ الْعَمَلِ" (بہترین عمل کی طرف آؤ)

شیعہ نقطہ نظر:
شیعہ مسلمان "حَیَّ عَلَىٰ خَیْرِ الْعَمَلِ" کا فقرہ شامل کرتے ہیں جس کا مطلب ہے "بہترین کام کی طرف آؤ" یا "بہترین عمل کی طرف جلدی کرو۔"

اذان میں موقف:
یہ فقرہ "حی علی الفلاح" (کامیابی کی طرف آؤ) کے بعد دو بار پڑھا جاتا ہے۔

تاریخی سیاق و سباق:
شیعہ ذرائع کا کہنا ہے کہ یہ فقرہ اصل اذان کا حصہ تھا جو نبی ﷺ نے سکھایا تھا لیکن بعد میں عمر بن خطاب رضی اللہ عنہ کی خلافت کے دوران ہٹا دیا گیا۔

سنی نقطہ نظر:
سنی مسلمان اس فقرے کو اذان میں شامل نہیں کرتے۔ مرکزی سنی مکاتب فکر (حنفی، مالکی، شافعی، حنبلی) یہ سمجھتے ہیں کہ یہ فقرہ کبھی بھی مستند اذان کا حصہ نہیں تھا جیسا کہ نبی ﷺ نے سکھایا۔

2. "تثویب" - نماز نیند سے بہتر ہے

سنی طریقہ:
سنی روایت میں، فقرہ "الصَّلَاةُ خَیْرٌ مِنَ النَّوْمِ" جس کا مطلب ہے "نماز نیند سے بہتر ہے" فجر کی اذان میں شامل کیا جاتا ہے۔

موقف: یہ فقرہ صرف فجر کی اذان میں "حی علی الفلاح" کے بعد دو بار پڑھا جاتا ہے۔

تاریخی بنیاد:
سنی ذرائع کے مطابق، یہ اضافہ نبی ﷺ نے منظور کیا جب صحابی عبداللہ بن زید یا ابو محذورہ نے تجویز دی۔

شیعہ نقطہ نظر:
شیعہ مسلمان سرکاری اذان میں "تثویب" شامل نہیں کرتے۔ وہ اسے بدعت سمجھتے ہیں جو اصل اذان کا حصہ نہیں تھا جو نبی ﷺ نے سکھایا۔

تثویب پر شیعہ نظریہ:
امامیہ فقہ کے مطابق، تثویب کبھی قبول نہیں کیا گیا اور اسے نبی ﷺ کے وقت کے بعد متعارف کرائی گئی بدعت سمجھا جاتا ہے۔

3. ولایت کی گواہی (علی کی سرپرستی)

شیعہ اضافی فقرہ:
کچھ شیعہ مسلمان پڑھتے ہیں: "أَشْهَدُ أَنَّ عَلِيًّا وَلِيُّ اللَّهِ" جس کا مطلب ہے "میں گواہی دیتا ہوں کہ علی اللہ کے دوست/سرپرست ہیں۔"

اہم نوٹ:
یہ فقرہ شیعہ فقہ میں سرکاری اذان یا اقامت کا حصہ نہیں سمجھا جاتا۔ یہ ذاتی عقیدت اور اجتہاد (علمائے تفسیر) کے طور پر پڑھا جاتا ہے، نہ کہ اذان کے لازمی حصے کے طور پر۔

تلاوت میں موقف:
جب پڑھا جاتا ہے، تو یہ نبی کی نبوت کی گواہی کے بعد آتا ہے۔

علمی بحث:
شیعہ علماء کے درمیان اس بارے میں بحث ہے کہ آیا یہ پڑھا جانا چاہیے، بہت سے لوگ اس بات پر زور دیتے ہیں کہ یہ ذاتی عقیدت کے لیے مستحب ہے لیکن سرکاری اذان کے فارمولے کا حصہ نہیں ہے۔

4. تکرار کی تعداد

سنی طریقہ:
• "اللہ اکبر" - شروع میں 4 بار (زیادہ تر مکاتب کے مطابق)
• آخری "لا الہ الا اللہ" - آخر میں 1 بار

تغیرات:
مالکی مکتب فکر کا کہنا ہے کہ "اللہ اکبر" کو شروع میں صرف دو بار پڑھا جانا چاہیے، چار بار نہیں۔

شیعہ طریقہ:
• "اللہ اکبر" - شروع میں 4 بار
• آخری "لا الہ الا اللہ" - آخر میں 2 بار

5. اذان کی ابتدا

سنی عقیدہ:
اذان عبداللہ بن زید رضی اللہ عنہ کے خواب کے ذریعے نازل ہوئی، جو نبی ﷺ کے صحابی تھے۔ جب انہوں نے نبی ﷺ کو اپنا خواب سنایا، تو نبی ﷺ نے اس کی تصدیق الہٰی ہدایت کے طور پر کی اور بلال رضی اللہ عنہ کو اسے پکارنے کی ہدایت دی۔

شیعہ عقیدہ:
تمام امامیہ فقہاء، اہل بیت علیہم السلام کی پیروی کرتے ہوئے، یہ مانتے ہیں کہ اذان اللہ کے براہ راست حکم اور نبی ﷺ کے دل پر وحی سے شروع ہوئی، نہ کہ کسی صحابی کے خواب سے۔

الہٰی ماخذ:
شیعہ ذرائع اس بات پر زور دیتے ہیں کہ اذان اتنی اہم رسم ہے کہ یہ خواب سے شروع نہیں ہو سکتی، اور یہ براہ راست نبی ﷺ کو الہٰی وحی کے ذریعے آئی ہوگی۔

مشترکہ بنیاد:

ان اختلافات کے باوجود، دونوں روایات اس پر متفق ہیں:
• اسلام میں اذان کی بنیادی اہمیت
• بنیادی فقرے جو اللہ کی عظمت اور محمد ﷺ کی نبوت کی گواہی دیتے ہیں
• پانچ روزانہ نماز کے اوقات جن میں اذان کی ضرورت ہے
• مؤذن کے لیے روحانی اجر
• اذان سننے پر جواب دینے کی ذمہ داری
• خوش الحان اذان کی خوبصورتی اور اہمیت

تنوع میں اتحاد:

یہ اختلافات اسلام میں بھرپور علمی روایت اور تاریخی ذرائع کی مختلف تفسیروں کی عکاسی کرتے ہیں۔ سنی اور شیعہ دونوں مسلمان اذان کو اللہ کی عبادت اور اسلام کے پانچ ارکان میں سے ایک کو پورا کرنے کے لیے خوبصورت پکار کے طور پر استعمال کرتے ہیں۔

بنیادی پیغام ایک ہی رہتا ہے:
• اللہ سب سے بڑا ہے
• اللہ کے سوا کوئی معبود نہیں
• محمد ﷺ اللہ کے رسول ہیں
• نماز کی طرف آؤ، کامیابی کی طرف آؤ

مستند ذرائع:
• اذان - ویکیپیڈیا
• اذان میں روایت اور بدعت - الاسلام ڈاٹ آرگ
• اذان - ویکی شیعہ
• اسلامی فقہی انسائیکلوپیڈیا
• تقابلی فقہ مطالعات''',
        'hindi': '''अज़ान में सुन्नी और शिया इख़्तिलाफ़ात

सुन्नी और शिया अज़ान में अहम इख़्तिलाफ़ात

अगरचे अज़ान का बुनियादी हिस्सा एक जैसा है, लेकिन सुन्नी और शिया रिवायात में अमल में क़ाबिल-ए-ज़िक्र फ़र्क़ हैं:

1. "हय्या अला ख़ैरिल अमल" (बेहतरीन अमल की तरफ़ आओ)

शिया नज़रिया:
शिया मुसलमान "حَيَّ عَلَىٰ خَيْرِ الْعَمَلِ" का फ़िक़रा शामिल करते हैं जिसका मतलब है "बेहतरीन काम की तरफ़ आओ" या "बेहतरीन अमल की तरफ़ जल्दी करो।"

अज़ान में मौक़िफ़:
यह फ़िक़रा "हय्या अलल-फ़लाह" (कामयाबी की तरफ़ आओ) के बाद दो बार पढ़ा जाता है।

तारीख़ी सियाक़ ओ सबाक़:
शिया ज़राये का कहना है कि यह फ़िक़रा असल अज़ान का हिस्सा था जो नबी ﷺ ने सिखाया था लेकिन बाद में उमर बिन ख़त्ताब रज़ियल्लाहु अन्हु की ख़िलाफ़त के दौरान हटा दिया गया।

सुन्नी नज़रिया:
सुन्नी मुसलमान इस फ़िक़रे को अज़ान में शामिल नहीं करते। मर्कज़ी सुन्नी मकातिब-ए-फ़िक्र (हनफ़ी, मालिकी, शाफ़ई, हंबली) यह समझते हैं कि यह फ़िक़रा कभी भी मुस्तनद अज़ान का हिस्सा नहीं था जैसा कि नबी ﷺ ने सिखाया।

2. "तसवीब" - नमाज़ नींद से बेहतर है

सुन्नी तरीक़ा:
सुन्नी रिवायत में, फ़िक़रा "الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ" जिसका मतलब है "नमाज़ नींद से बेहतर है" फ़ज्र की अज़ान में शामिल किया जाता है।

मौक़िफ़: यह फ़िक़रा सिर्फ़ फ़ज्र की अज़ान में "हय्या अलल-फ़लाह" के बाद दो बार पढ़ा जाता है।

तारीख़ी बुनियाद:
सुन्नी ज़राये के मुताबिक़, यह इज़ाफ़ा नबी ﷺ ने मंज़ूर किया जब सहाबी अब���दुल्लाह बिन ज़ैद या अबू महज़ूरा ने तजवीज़ दी।

शिया नज़रिया:
शिया मुसलमान सरकारी अज़ान में "तसवीब" शामिल नहीं करते। वे इसे बिदअत समझते हैं जो असल अज़ान का हिस्सा नहीं था जो नबी ﷺ ने सिखाया।

तसवीब पर शिया नज़रिया:
इमामिया फ़िक़्ह के मुताबिक़, तसवीब कभी क़बूल नहीं किया गया और इसे नबी ﷺ के वक़्त के बाद मुतअर्रिफ़ कराई गई बिदअत समझा जाता है।

3. विलायत की गवाही (अली की सरपरस्ती)

शिया इज़ाफ़ी फ़िक़रा:
कुछ शिया मुसलमान पढ़ते हैं: "أَشْهَدُ أَنَّ عَلِيًّا وَلِيُّ اللَّهِ" जिसका मतलब है "मैं गवाही देता हूं कि अली अल्लाह के दोस्त/सरपरस्त हैं।"

अहम नोट:
यह फ़िक़रा शिया फ़िक़्ह में सरकारी अज़ान या इक़ामत का हिस्सा नहीं समझा जाता। यह ज़ाती अक़ीदत और इज्तिहाद (उलमा तफ़्सीर) के तौर पर पढ़ा जाता है, न कि अज़ान के लाज़िमी हिस्से के तौर पर।

तिलावत में मौक़िफ़:
जब पढ़ा जाता है, तो यह नबी की नुबुव्वत की गवाही के बाद आता है।

इल्मी बहस:
शिया उलमा के दरमियान इस बारे में बहस है कि आया यह पढ़ा जाना चाहिए, बहुत से लोग इस बात पर ज़ोर देते हैं कि यह ज़ाती अक़ीदत के लिए मुस्तहब है लेकिन सरकारी अज़ान के फ़ॉर्मूले का हिस्सा नहीं है।

4. तकरार की तादाद

सुन्नी तरीक़ा:
• "अल्लाहु अकबर" - शुरू में 4 बार (ज़्यादातर मकातिब के मुताबिक़)
• आख़िरी "ला इलाहा इल्लल्लाह" - आख़िर में 1 बार

तग़य्युरात:
मालिकी मकतब-ए-फ़िक्र का कहना है कि "अल्लाहु अकबर" को शुरू में सिर्फ़ दो बार पढ़ा जाना चाहिए, चार बार नहीं।

शिया तरीक़ा:
• "अल्लाहु अकबर" - शुरू में 4 बार
• आख़िरी "ला इलाहा इल्लल्लाह" - आख़िर में 2 बार

5. अज़ान की इब्तिदा

सुन्नी अक़ीदा:
अज़ान अब्दुल्लाह बिन ज़ैद रज़ियल्लाहु अन्हु के ख़्वाब के ज़रिये नाज़िल हुई, जो नबी ﷺ के सहाबी थे। जब उन्होंने नबी ﷺ को अपना ख़्वाब सुनाया, तो नबी ﷺ ने इसकी तस्दीक़ इलाही हिदायत के तौर पर की और बिलाल रज़ियल्लाहु अन्हु को इसे पुकारने की हिदायत दी।

शिया अक़ीदा:
तमाम इमामिया फ़ुक़हा, अहले-बैत अलैहिमुस्सलाम की पैरवी करते हुए, यह मानते हैं कि अज़ान अल्लाह के बराह-रास्त हुक्म और नबी ﷺ के दिल पर वही से शुरू हुई, न कि किसी सहाबी के ख़्वाब से।

इलाही माख़ज़:
शिया ज़राये इस बात पर ज़ोर देते हैं कि अज़ान इतनी अहम रस्म है कि यह ख़्वाब से शुरू नहीं हो सकती, और यह बराह-रास्त नबी ﷺ को इलाही वही के ज़रिये आई होगी।

मुश्तरका बुनियाद:

इन इख़्तिलाफ़ात के बावजूद, दोनों रिवायात इस पर मुत्तफ़िक़ हैं:
• इस्लाम में अज़ान की बुनियादी अहमियत
• बुनियादी फ़िक़रे जो अल्लाह की अज़मत और मुहम्मद ﷺ की नुबुव्वत की गवाही देते हैं
• पांच रोज़ाना नमाज़ के औक़ात जिनमें अज़ान की ज़रूरत है
• मुअज़्ज़िन के लिए रूहानी अज्र
• अज़ान सुनने पर जवाब देने की ज़िम्मेदारी
• ख़ुश-अल्हान अज़ान की ख़ूबसूरती और अहमियत

तनव्वो में इत्तिहाद:

यह इख़्तिलाफ़ात इस्लाम में भरपूर इल्मी रिवायत और तारीख़ी ज़राये की मुख़्तलिफ़ तफ़सीरों की अक्कासी करते हैं। सुन्नी और शिया दोनों मुसलमान अज़ान को अल्लाह की इबादत और इस्लाम के पांच अरकान में से एक को पूरा करने के लिए ख़ूबसूरत पुकार के तौर पर इस्तेमाल करते हैं।

बुनियादी पैग़ाम एक ही रहता है:
• अल्लाह सबसे बड़ा है
• अल्लाह के सिवा कोई माबूद नहीं
• मुहम्मद ﷺ अल्लाह के रसूल हैं
• नमाज़ की तरफ़ आओ, कामयाबी की तरफ़ आओ

मुस्तनद ज़राये:
• अज़ान - विकिपीडिया
• अज़ान में रिवायत और बिदअत - अल-इस्लाम डॉट ऑर्ग
• अज़ान - विकी शिया
• इस्लामी फ़िक़ही एनसाइक्लोपीडिया
• तक़ाबुली फ़िक़्ह मुतालआत''',
        'arabic': '''الاختلافات بين السنة والشيعة في الأذان

الفروقات الرئيسية بين أذان السنة والشيعة

على الرغم من أن جوهر الأذان هو نفسه، إلا أن هناك اختلافات ملحوظة في الممارسة بين التقاليد السنية والشيعية:

١. "حي على خير العمل" (تعال إلى أفضل الأعمال)

المنظور الشيعي:
يشمل الشيعة العبارة حَيَّ عَلَىٰ خَيْرِ الْعَمَلِ التي تعني "تعال إلى أفضل الأعمال" أو "أسرع إلى أفضل العمل."

الموضع في الأذان:
تُتلى هذه العبارة مرتين بعد "حي على الفلاح".

السياق التاريخي:
تؤكد المصادر الشيعية أن هذه العبارة كانت جزءاً من الأذان الأصلي الذي علّمه النبي ﷺ ولكن تم حذفها لاحقاً خلال خلافة عمر بن الخطاب رضي الله عنه.

المنظور السني:
لا يشمل السنة هذه العبارة في الأذان. تعتبر المدارس السنية الرئيسية (الحنفية والمالكية والشافعية والحنبلية) أن هذه العبارة لم تكن أبداً جزءاً من الأذان الأصيل كما علمه النبي ﷺ.

٢. "التثويب" - الصلاة خير من النوم

الممارسة السنية:
في التقليد السني، تُضاف العبارة الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ إلى أذان الفجر.

الموضع: تُتلى هذه العبارة مرتين بعد "حي على الفلاح" في أذان الفجر فقط.

الأساس التاريخي:
وفقاً للمصادر السنية، تمت الموافقة على هذه الإضافة من قبل النبي ﷺ عندما اقترحها الصحابي عبد الله بن زيد أو أبو محذورة.

المنظور الشيعي:
لا يشمل الشيعة "التثويب" في الأذان الرسمي. يعتبرونه بدعة لم تكن جزءاً من الأذان الأصلي الذي علمه النبي ﷺ.

الرأي الشيعي في التثويب:
وفقاً للفقه الإمامي، لم يتم قبول التثويب أبداً ويُعتبر بدعة أُدخلت بعد وقت النبي ﷺ.

٣. شهادة الولاية (ولاية علي)

العبارة الشيعية الإضافية:
يتلو بعض الشيعة: أَشْهَدُ أَنَّ عَلِيًّا وَلِيُّ اللَّهِ بمعنى "أشهد أن علياً ولي الله."

ملاحظة مهمة:
هذه العبارة لا تُعتبر جزءاً من الأذان أو الإقامة الرسمية في الفقه الشيعي. تُتلى كمسألة تقوى شخصية واجتهاد، وليست كجزء واجب من الأذان.

الموضع في التلاوة:
عند تلاوتها، تأتي بعد الشهادة بنبوة النبي ﷺ.

النقاش العلمائي:
هناك نقاش بين العلماء الشيعة حول ما إذا كان ينبغي تلاوة هذا، مع تأكيد الكثيرين على أنه مستحب للتقوى الشخصية ولكنه ليس جزءاً من صيغة الأذان الرسمية.

٤. عدد التكرارات

الممارسة السنية:
• "الله أكبر" - ٤ مرات في البداية (وفقاً لمعظم المدارس)
• "لا إله إلا الله" النهائية - مرة واحدة في النهاية

الاختلافات:
يرى المذهب المالكي أن "الله أكبر" يجب أن تُتلى مرتين فقط في البداية، وليس أربع مرات.

الممارسة الشيعية:
• "الله أكبر" - ٤ مرات في البداية
• "لا إله إلا الله" النهائية - مرتان في النهاية

٥. أصل الأذان

المعتقد السني:
كُشف عن الأذان من خلال رؤيا عبد الله بن زيد رضي الله عنه، صحابي النبي ﷺ. عندما روى رؤياه للنبي ﷺ، أكدها النبي ﷺ كإرشاد إلهي وأمر بلالاً بالنداء بها.

المعتقد الشيعي:
يؤمن جميع فقهاء الإمامية، متبعين أهل البيت عليهم السلام، أن الأذان بدأ بأمر مباشر من الله ووحي إلى قلب النبي ﷺ، وليس من خلال رؤيا صحابي.

المصدر الإلهي:
تؤكد المصادر الشيعية أن الأذان طقس مهم جداً لدرجة أنه لا يمكن أن يكون قد نشأ من حلم، ويجب أن يكون قد جاء من خلال الوحي الإلهي مباشرة إلى النبي ﷺ.

أرضية مشتركة:

على الرغم من هذه الاختلافات، يتفق كلا التقليدين على:
• الأهمية الأساسية للأذان في الإسلام
• العبارات الأساسية التي تشهد بعظمة الله ونبوة محمد ﷺ
• أوقات الصلوات الخمس اليومية التي تتطلب الأذان
• الثواب الروحي للمؤذن
• الواجب بالرد عند سماع الأذان
• جمال وأهمية الأذان اللحني

الوحدة في التنوع:

تعكس هذه الاختلافات التقليد العلمائي الغني في الإسلام والتفسيرات المختلفة للمصادر التاريخية. يستخدم كل من المسلمين السنة والشيعة الأذان كنداء جميل لعبادة الله وتحقيق أحد أركان الإسلام الخمسة.

الرسالة الأساسية تبقى نفسها:
• الله أكبر
• لا إله إلا الله
• محمد رسول الله
• حي على الصلاة، حي على الفلاح

المصادر الموثوقة:
• الأذان - ويكيبيديا
• التقليد والبدعة في الأذان - الإسلام.org
• الأذان - ويكي شيعة
• موسوعات الفقه الإسلامي
• دراسات الفقه المقارن''',
      },
    },
    {
      'number': 10,
      'titleKey': 'azan_10_faq',
      'title': 'Frequently Asked Questions about Azan',
      'titleUrdu': 'اذان کے بارے میں اکثر پوچھے جانے والے سوالات',
      'titleHindi': 'अज़ान के बारे में अक्सर पूछे जाने वाले सवालात',
      'titleArabic': 'الأسئلة الشائعة عن الأذان',
      'icon': Icons.quiz,
      'color': Colors.deepPurple,
      'details': {
        'english': '''Frequently Asked Questions about Azan

Q1: Is it obligatory to give the Adhan?
A: The Adhan is considered Fard Kifayah (communal obligation) for men in congregational prayers. This means if some people perform it, the obligation is lifted from others. For individual prayers at home, it is Sunnah Muakkadah (emphasized Sunnah), highly recommended but not obligatory.

Q2: Can I pray without Adhan and Iqama?
A: Yes, your prayer is valid without Adhan and Iqama. However, calling them is a highly recommended Sunnah that brings great rewards. The Prophet ﷺ encouraged even those praying alone to call the Adhan.

Q3: What should I do when I hear the Adhan?
A: You should:
1. Stop talking and listen attentively
2. Repeat each phrase after the muezzin silently
3. When hearing "Hayya 'ala-s-Salah" or "Hayya 'ala-l-Falah", say "La hawla wa la quwwata illa billah"
4. After the Adhan, send blessings upon the Prophet ﷺ
5. Recite the du'a asking Allah to grant the Prophet the Wasilah

Q4: Can I give Adhan if I'm not in a state of Wudu?
A: Yes, the Adhan is valid even without wudu, though it is better and more recommended to be in a state of purity when calling it.

Q5: Can Adhan be given in languages other than Arabic?
A: The vast majority of scholars agree that the Adhan should be called in Arabic as this is how it was taught by the Prophet ﷺ. However, teaching its meaning in local languages is encouraged.

Q6: What is the difference between Adhan and Iqama?
A: Both are calls to prayer, but:
• Adhan announces that prayer time has entered
• Iqama announces that the prayer is about to start immediately
• Adhan is called slowly and melodiously
• Iqama is called more quickly
• Adhan includes extra phrases in Fajr ("Prayer is better than sleep" in Sunni tradition)
• Iqama includes "Qad qamatis salah" (The prayer has begun)

Q7: Can I call Adhan before the prayer time?
A: No, the Adhan should only be called after the prayer time has entered, except for Fajr where some scholars permit calling it slightly before dawn to wake people up.

Q8: Why do prayer times change daily?
A: Prayer times are based on the position of the sun, which changes throughout the year due to Earth's rotation and orbit. That's why prayers times shift slightly each day and vary by geographic location.

Q9: Is it permissible to use loudspeakers for Adhan?
A: The vast majority of contemporary scholars permit using loudspeakers and technology for Adhan as it helps the call reach more people, fulfilling the original purpose of the Adhan. However, it should be done with consideration for neighbors.

Q10: Can I give Adhan while traveling or in a non-Muslim country?
A: Yes, you can and should give Adhan wherever you are. If you're in a public place where it might disturb others or is prohibited, you can call it softly for yourself.

Q11: What if I miss the Adhan?
A: If you miss a prayer, you should still call the Adhan and Iqama before making up (Qadha) the prayer, as these calls are Sunnah for each prayer.

Q12: Are there rewards for listening to the Adhan?
A: Yes! The Prophet ﷺ said that whoever repeats the Adhan after the muezzin will receive ten rewards for each phrase, and supplication between Adhan and Iqama is not rejected.

Q13: Why does the Adhan sound different in different mosques?
A: While the words are the same, the melody and style can vary by region, Islamic tradition (Sunni/Shia), and cultural influences. All these variations are acceptable as long as the required phrases are included.

Q14: Can I record Adhan and play it instead of calling it live?
A: Most scholars prefer live Adhan over recorded ones because:
• The muezzin gets rewards for calling it
• It creates a connection between the caller and listeners
• However, in situations where no one can call it live, playing a recording is better than having no Adhan at all

Q15: What should women do when they hear the Adhan?
A: Women should respond to the Adhan just like men - by repeating the phrases softly and making the du'a afterward. This applies whether they are at home or in the mosque.

Q16: Is there a specific du'a after Adhan?
A: Yes, the Prophet ﷺ taught us to say after the Adhan:
"اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلاَةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"O Allah, Lord of this perfect call and established prayer, grant Muhammad the intercession and superiority, and raise him to the praiseworthy station You have promised him."

The Prophet ﷺ said: "Whoever says this after hearing the Adhan, my intercession will be guaranteed for him on the Day of Resurrection." (Sahih Bukhari)

Q17: Can children give the Adhan?
A: Yes, the Adhan of a discerning child (who understands what he's saying) is valid according to most scholars. In fact, it's good to teach children to give Adhan as part of their Islamic education.

Q18: What is the ruling on answering the phone during Adhan?
A: It is better to let the Adhan finish before answering the phone or engaging in conversation, as listening to and repeating the Adhan is an important Sunnah.

Q19: Can I give Adhan if I'm in an impure state (Janabah)?
A: The majority of scholars say that Adhan can be given in a state of major impurity (Janabah), though it is disliked (Makruh). It's better to purify yourself first if possible.

Q20: Why do some mosques have different timings?
A: Different mosques may follow different calculation methods, apply different safety margins, or follow different scholarly opinions on the definition of Fajr and Isha times. These minor differences are normal and acceptable.

Authentic Sources:
• Sahih al-Bukhari
• Sahih Muslim
• Sunan Abu Dawud
• Sunan al-Tirmidhi
• Contemporary Fatwa Collections
• Islamic Q&A websites''',
        'urdu': '''اذان کے بارے میں اکثر پوچھے جانے والے سوالات

سوال 1: کیا اذان دینا فرض ہے؟
جواب: اذان کو مردوں کی باجماعت نماز میں فرض کفایہ سمجھا جاتا ہے۔ اس کا مطلب ہے کہ اگر کچھ لوگ اسے ادا کریں تو دوسروں سے ذمہ داری ختم ہو جاتی ہے۔ گھر میں انفرادی نماز کے لیے، یہ سنت مؤکدہ ہے، بہت زیادہ تاکیدی لیکن فرض نہیں۔

سوال 2: کیا میں اذان اور اقامت کے بغیر نماز پڑھ سکتا ہوں؟
جواب: جی ہاں، آپ ک�� نماز اذان اور اقامت کے بغیر درست ہے۔ تاہم، انہیں پکارنا بہت زیادہ مستحب سنت ہے جو بہت بڑا اجر لاتی ہے۔ نبی ﷺ نے اکیلے نماز پڑھنے والوں کو بھی اذان دینے کی ترغیب دی۔

سوال 3: جب میں اذان سنوں تو کیا کروں؟
جواب: آپ کو چاہیے:
1. بات چیت بند کریں اور غور سے سنیں
2. مؤذن کے بعد ہر فقرہ خاموشی سے دہرائیں
3. "حی علی الصلاۃ" یا "حی علی الفلاح" سنتے وقت، "لا حول ولا قوۃ الا باللہ" کہیں
4. اذان کے بعد، نبی ﷺ پر درود بھیجیں
5. دعا پڑھیں کہ اللہ نبی ﷺ کو وسیلہ عطا فرمائے

سوال 4: کیا میں وضو کی حالت میں نہ ہوں تو اذان دے سکتا ہوں؟
جواب: جی ہاں، اذان وضو کے بغیر بھی درست ہے، اگرچہ پاکیزگی کی حالت میں اذان دینا بہتر اور زیادہ مستحب ہے۔

سوال 5: کیا اذان عربی کے علاوہ دوسری زبانوں میں دی جا سکتی ہے؟
جواب: علماء کی وسیع اکثریت اس بات پر متفق ہے کہ اذان عربی میں دی جانی چاہیے کیونکہ اسی طرح نبی ﷺ نے سکھایا تھا۔ تاہم، مقامی زبانوں میں اس کے معنی سکھانے کی ترغیب دی جاتی ہے۔

سوال 6: اذان اور اقامت میں کیا فرق ہے؟
جواب: دونوں نماز کے لیے پکار ہیں، لیکن:
• اذان اعلان کرتی ہے کہ نماز کا وقت داخل ہو گیا ہے
• اقامت اعلان کرتی ہے کہ نماز فوراً شروع ہونے والی ہے
• اذان آہستہ اور خوش الحانی سے دی جاتی ہے
• اقامت زیادہ تیزی سے دی جاتی ہے
• فجر کی اذان میں اضافی فقرے شامل ہیں (سنی روایت میں "نماز نیند سے بہتر ہے")
• اقامت میں "قد قامت الصلاۃ" (نماز شروع ہو گئی) شامل ہے

سوال 7: کیا میں نماز کے وقت سے پہلے اذان دے سکتا ہوں؟
جواب: نہیں، اذان صرف نماز کا وقت داخل ہونے کے بعد دی جانی چاہیے، سوائے فجر کے جہاں کچھ علماء لوگوں کو جگانے کے لیے صبح سے تھوڑا پہلے اذان دینے کی اجازت دیتے ہیں۔

سوال 8: نماز کے اوقات روزانہ کیوں بدلتے ہیں؟
جواب: نماز کے اوقات سورج کی پوزیشن پر مبنی ہیں، جو زمین کی گردش اور مدار کی وجہ سے سال بھر میں بدلتی رہتی ہے۔ اسی لیے نماز کے اوقات ہر دن تھوڑا سا بدلتے ہیں اور جغرافیائی محل وقوع کے لحاظ سے مختلف ہوتے ہیں۔

سوال 9: کیا اذان کے لیے لاؤڈ اسپیکر استعمال کرنا جائز ہے؟
جواب: عصری علماء کی وسیع اکثریت اذان کے لیے لاؤڈ اسپیکر اور ٹیکنالوجی استعمال کرنے کی اجازت دیتی ہے کیونکہ یہ پکار کو زیادہ لوگوں تک پہنچانے میں مدد کرتا ہے، اذان کے اصل مقصد کو پورا کرتے ہوئے۔ تاہم، اسے پڑوسیوں کی رعایت کے ساتھ کیا جانا چاہیے۔

سوال 10: کیا میں سفر کے دوران یا غیر مسلم ملک میں اذان دے سکتا ہوں؟
جواب: جی ہاں، آپ جہاں بھی ہوں اذان دے سکتے ہیں اور دینی چاہیے۔ اگر آپ ایسی عوامی جگہ پر ہیں جہاں یہ دوسروں کو پریشان کر سکتی ہے یا ممنوع ہے، تو آپ اسے اپنے لیے آہستہ پکار سکتے ہیں۔

سوال 11: اگر میں اذان چھوڑ دوں تو کیا ہوگا؟
جواب: اگر آپ نماز چھوڑ دیں، تو آپ کو قضا نماز پڑھنے سے پہلے اذان اور اقامت دینی چاہیے، کیونکہ یہ پکاریں ہر نماز کے لیے سنت ہیں۔

سوال 12: کیا اذان سننے پر اجر ملتا ہے؟
جواب: جی ہاں! نبی ﷺ نے فرمایا کہ جو کوئی مؤذن کے بعد اذان دہراتا ہے اسے ہر فقرے پر دس اجر ملیں گے، اور اذان اور اقامت کے درمیان دعا رد نہیں ہوتی۔

سوال 13: مختلف مساجد میں اذان مختلف کیوں لگتی ہے؟
جواب: اگرچہ الفاظ ایک جیسے ہیں، لیکن راگ اور انداز علاقے، اسلامی روایت (سنی/شیعہ) اور ثقافتی اثرات کے لحاظ سے مختلف ہو سکتے ہیں۔ یہ تمام تغیرات قابل قبول ہیں جب تک ضروری فقرے شامل ہوں۔

سوال 14: کیا میں اذان ریکارڈ کر سکتا ہوں اور براہ راست پکارنے کے بجائے بجا سکتا ہوں؟
جواب: زیادہ تر علماء ریکارڈ شدہ اذان کی بجائے براہ راست اذان کو ترجیح دیتے ہیں کیونکہ:
• مؤذن کو اذان دینے پر اجر ملتا ہے
• یہ پکارنے والے اور سننے والوں کے درمیان تعلق پیدا کرتا ہے
• تاہم، ایسی صورتوں میں جہاں کوئی براہ راست اذان نہیں دے سکتا، ریکارڈنگ بجانا بالکل بھی اذان نہ ہونے سے بہتر ہے

سوال 15: خواتین اذان سنتے وقت کیا کریں؟
جواب: خواتین کو مردوں کی طرح اذان کا جواب دینا چاہیے - آہستہ سے فقرے دہرا کر اور بعد میں دعا کر کے۔ یہ اس وقت لاگو ہوتا ہے چاہے وہ گھر میں ہوں یا مسجد میں۔

سوال 16: کیا اذان کے بعد کوئی مخصوص دعا ہے؟
جواب: جی ہاں، نبی ﷺ نے ہمیں سکھایا کہ اذان کے بعد یہ کہیں:
"اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلاَةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"اے اللہ، اس مکمل دعوت اور قائم نماز کے رب، محمد ﷺ کو وسیلہ اور فضیلت عطا فرما، اور انہیں اس قابل ستائش مقام پر اٹھا جس کا تو نے وعدہ کیا ہے۔"

نبی ﷺ نے فرمایا: "جو کوئی اذان سننے کے بعد یہ کہے، قیامت کے دن میری شفاعت اس کے لیے لازم ہو جائے گی۔" (صحیح بخاری)

سوال 17: کیا بچے اذان دے سکتے ہیں؟
جواب: جی ہاں، زیادہ تر علماء کے مطابق سمجھدار بچے (جو سمجھتا ہے کہ وہ کیا کہہ رہا ہے) کی اذان درست ہے۔ حقیقت میں، بچوں کو اذان دینا سکھانا اسلامی تعلیم کا حصہ اچھا ہے۔

سوال 18: اذان کے دوران فون کا جواب دینے کا کیا حکم ہے؟
جواب: یہ بہتر ہے کہ اذان ختم ہونے سے پہلے فون کا جواب دینے یا بات چیت میں مشغول ہونے سے پرہیز کریں، کیونکہ اذان سننا اور دہرانا اہم سنت ہے۔

سوال 19: کیا میں ناپاک حالت (جنابت) میں اذان دے سکتا ہوں؟
جواب: علماء کی اکثریت کہتی ہے کہ اذان بڑی ناپاکی (جنابت) کی حالت میں دی جا سکتی ہے، اگرچہ یہ مکروہ ہے۔ اگر ممکن ہو تو پہلے خود کو پاک کرنا بہتر ہے۔

س��ال 20: کچھ مساجد کے اوقات مختلف کیوں ہوتے ہیں؟
جواب: مختلف مساجد مختلف حساب کتاب کے طریقے اپنا سکتی ہیں، مختلف حفاظتی حاشیے لگا سکتی ہیں، یا فجر اور عشاء کے اوقات کی تعریف پر مختلف علمائے آرا کی پیروی کر سکتی ہیں۔ یہ معمولی اختلافات عام اور قابل قبول ہیں۔

مستند ذرائع:
• صحیح بخاری
• صحیح مسلم
• سنن ابوداؤد
• سنن ترمذی
• عصری فتاویٰ کے مجموعے
• اسلامی سوال و جواب ویب سائٹس''',
        'hindi': '''अज़ान के बारे में अक्सर पूछे जाने वाले सवालात

सवाल 1: क्या अज़ान देना फ़र्ज़ है?
जवाब: अज़ान को मर्दों की बाजमाअत नमाज़ में फ़र्ज़-ए-किफ़ाया समझा जाता है। इसका मतलब है कि अगर कुछ लोग इसे अदा करें तो दूसरों से ज़िम्मेदारी ख़त्म हो जाती है। घर में इन्फ़िरादी नमाज़ के लिए, यह सुन्नत-ए-मुअक्किदा है, बहुत ज़्यादा ताकीदी लेकिन फ़र्ज़ नहीं।

सवाल 2: क्या मैं अज़ान और इक़ामत के बग़ैर नमाज़ पढ़ सकता हूं?
जवाब: जी हां, आपकी नमाज़ अज़ान और इक़ामत के बग़ैर दुरुस्त है। ताहम, उन्हें पुकारना बहुत ज़्यादा मुस्तहब सुन्नत है जो बहुत बड़ा अज्र लाती है। नबी ﷺ ने अकेले नमाज़ पढ़ने वालों को भी अज़ान देने की तरग़ीब दी।

सवाल 3: जब मैं अज़ान सुनूं तो क्या करूं?
जवाब: आपको चाहिए:
1. बात चीत बंद करें और ग़ौर से सुनें
2. मुअज़्ज़िन के बाद हर फ़िक़रा ख़ामोशी से दोहराएं
3. "हय्या अलस्सलाह" या "हय्या अलल-फ़लाह" सुनते वक़्त, "ला हौला वला क़ुव्वता इल्ला बिल्लाह" कहें
4. अज़ान के बाद, नबी ﷺ पर दरूद भेजें
5. दुआ पढ़ें कि अल्लाह नबी ﷺ को वसीला अता फ़रमाए

सवाल 4: क्या मैं वुज़ू की हालत में न होऊं तो अज़ान दे सकता हूं?
जवाब: जी हां, अज़ान वुज़ू के बग़ैर भी दुरुस्त है, अगरचे पाकीज़गी की हालत में अज़ान देना बेहतर और ज़्यादा मुस्तहब है।

सवाल 5: क्या अज़ान अरबी के इलावा दूसरी ज़बानों में दी जा सकती है?
जवाब: उलमा की वसी अक्सरियत इस बात पर मुत्तफ़िक़ है कि अज़ान अरबी में दी जानी चाहिए क्योंकि इसी तरह नबी ﷺ ने सिखाया था। ताहम, मक़ामी ज़बानों में इसके मानी सिखाने की तरग़ीब दी जाती है।

सवाल 6: अज़ान और इक़ामत में क्या फ़र्क़ है?
जवाब: दोनों नमाज़ के लिए पुकार हैं, लेकिन:
• अज़ान एलान करती है कि नमाज़ का वक़्त दाख़िल हो गया है
• इक़ामत एलान करती है कि नमाज़ फ़ौरन शुरू होने वाली है
• अज़ान आहिस्ता और ख़ुश-अल्हानी से दी जाती है
• इक़ामत ज़्यादा तेज़ी से दी जाती है
• फ़ज्र की अज़ान में इज़ाफ़ी फ़िक़रे शामिल हैं (सुन्नी रिवायत में "नमाज़ नींद से बेहतर है")
• इक़ामत में "क़द क़ामतिस्सलाह" (नमाज़ शुरू हो गई) शामिल है

सवाल 7: क्या मैं नमाज़ के वक़्त से पहले अज़ान दे सकता हूं?
जवाब: नहीं, अज़ान सिर्फ़ नमाज़ का वक़्त दाख़िल होने के बाद दी जानी चाहिए, सिवाय फ़ज्र के जहां कुछ उलमा लोगों को जगाने के लिए सुबह से थोड़ा पहले अज़ान देने की इजाज़त देते हैं।

सवाल 8: नमाज़ के औक़ात रोज़ाना क्यों बदलते हैं?
जवाब: नमाज़ के औक़ात सूरज की पोज़ीशन पर मबनी हैं, जो ज़मीन की गर्दिश और मदार की वजह से साल भर में बदलती रहती है। इसीलिए नमाज़ के औक़ात हर दिन थोड़ा सा बदलते हैं और जुग़राफ़ियाई महल-ए-वक़ूअ के लिहाज़ से मुख़्तलिफ़ होते हैं।

सवाल 9: क्या अज़ान के लिए लाउड स्पीकर इस्तेमाल करना जायज़ है?
जवाब: असरी उलमा की वसी अक्सरियत अज़ान के लिए लाउड स्पीकर और टेक्नोलॉजी इस्तेमाल करने की इजाज़त देती है क्योंकि यह पुकार को ज़्यादा लोगों तक पहुंचाने में मदद करता है, अज़ान के असल मक़सद को पूरा करते हुए। ताहम, इसे पड़ोसियों की रिआयत के साथ किया जाना चाहिए।

सवाल 10: क्या मैं सफ़र के दौरान या ग़ैर-मुस्लिम मुल्क में अज़ान दे सकता हूं?
जवाब: जी हां, आप जहां भी हों अज़ान दे सकते हैं और देनी चाहिए। अगर आप ऐसी आम जगह पर हैं जहां यह दूसरों को परेशान कर सकती है या ममनू है, तो आप इसे अपने लिए आहिस्ता पुकार सकते हैं।

सवाल 11: अगर मैं अज़ान छोड़ दूं तो क्या होगा?
जवाब: अ��र आप नमाज़ छोड़ दें, तो आपको क़ज़ा नमाज़ पढ़ने से पहले अज़ान और इक़ामत देनी चाहिए, क्योंकि ये पुकारें हर नमाज़ के लिए सुन्नत हैं।

सवाल 12: क्या अज़ान सुनने पर अज्र मिलता है?
जवाब: जी हां! नबी ﷺ ने फ़रमाया कि जो कोई मुअज़्ज़िन के बाद अज़ान दोहराता है उसे हर फ़िक़रे पर दस अज्र मिलेंगे, और अज़ान और इक़ामत के दरमियान दुआ रद नहीं होती।

सवाल 13: मुख़्तलिफ़ मस्जिदों में अज़ान मुख़्तलिफ़ क्यों लगती है?
जवाब: अगरचे अल्फ़ाज़ एक जैसे हैं, लेकिन राग और अंदाज़ इलाक़े, इस्लामी रिवायत (सुन्नी/शिया) और सक़ाफ़ती असरात के लिहाज़ से मुख़्तलिफ़ हो सकते हैं। ये तमाम तग़य्युरात क़ाबिल-ए-क़बूल हैं जब तक ज़रूरी फ़िक़रे शामिल हों।

सवाल 14: क्या मैं अज़ान रिकॉर्ड कर सकता हूं और बराह-रास्त पुकारने के बजाय बजा सकता हूं?
जवाब: ज़्यादातर उलमा रिकॉर्ड शुदा अज़ान की बजाय बराह-रास्त अज़ान को तर्जीह देते हैं क्योंकि:
• मुअज़्ज़िन को अज़ान देने पर अज्र मिलता है
• यह पुकारने वाले और सुनने वालों के दरमियान ताल्लुक़ पैदा करता है
• ताहम, ऐसी सूरतों में जहां कोई बराह-रास्त अज़ान नहीं दे सकता, रिकॉर्डिंग बजाना बिल्कुल भी अज़ान न होने से बेहतर है

सवाल 15: ख़वातीन अज़ान सुनते वक़्त क्या करें?
जवाब: ख़वातीन को मर्दों की तरह अज़ान का जवाब देना चाहिए - आहिस्ता से फ़िक़रे दोहराकर और बाद में दुआ करके। यह उस वक़्त लागू होता है चाहे वे घर में हों या मस्जिद में।

सवाल 16: क्या अज़ान के बाद कोई मख़सूस दुआ है?
जवाब: जी हां, नबी ﷺ ने हमें सिखाया कि अज़ान के बाद यह कहें:
"اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلاَةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

"ऐ अल्लाह, इस मुकम्मल दावत और क़ायम नमाज़ के रब, मुहम्मद ﷺ को वसीला और फ़ज़ीलत अता फ़रमा, और उन्हें उस क़ाबिल-ए-तारीफ़ मक़ाम पर उठा जिसका तूने वादा किया है।"

नबी ﷺ ने फ़रमाया: "जो कोई अज़ान सुनने के बाद यह कहे, क़यामत के दिन मेरी शफ़ाअत उसके लिए लाज़िम हो जाएगी।" (सही बुख़ारी)

सवाल 17: क्या बच्चे अज़ान दे सकते हैं?
जवाब: जी हां, ज़्यादातर उलमा के मुताबिक़ समझदार बच्चे (जो समझता है कि वह क्या कह रहा है) की अज़ान दुरुस्त है। हक़ीक़त में, बच्चों को अज़ान देना सिखाना इस्लामी तालीम का हिस्सा अच्छा है।

सवाल 18: अज़ान के दौरान फ़ोन का जवाब देने का क्या हुक्म है?
जवाब: यह बेहतर है कि अज़ान ख़त्म होने से पहले फ़ोन का जवाब देने या बात चीत में मशग़ूल होने से परहेज़ करें, क्योंकि अज़ान सुनना और दोहराना अहम सुन्नत है।

सवाल 19: क्या मैं नापाक हालत (जनाबत) में अज़ान दे सकता हूं?
जवाब: उलमा की अक्सरियत कहती है कि अज़ान बड़ी नापाकी (जनाबत) की हालत में दी जा सकती है, अगरचे यह मकरूह है। अगर मुम्किन हो तो पहले ख़ुद को पाक करना बेहतर है।

सवाल 20: कुछ मस्जिदों के औक़ात मुख़्तलिफ़ क्यों होते हैं?
जवाब: मुख़्तलिफ़ मस्जिदें मुख़्तलिफ़ हिसाब किताब के तरीक़े अपना सकती हैं, मुख़्तलिफ़ हिफ़ाज़ती हाशिये लगा सकती हैं, या फ़ज्र और इशा के औक़ात की तारीफ़ पर मुख़्तलिफ़ उलमा आरा की पैरवी कर सकती हैं। ये मामूली इख़्तिलाफ़ात आम और क़ाबिल-ए-क़बूल हैं।

मुस्तनद ज़राये:
• सही बुख़ारी
• सही मुस्लिम
• सुनन अबू दाऊद
• सुनन तिर्मिज़ी
• असरी फ़तावा के मजमूए
• इस्लामी सवाल ओ जवाब वेबसाइट्स''',
        'arabic': '''الأسئلة الشائعة عن الأذان

س١: هل الأذان واجب؟
ج: يُعتبر الأذان فرض كفاية للرجال في الصلوات الجماعية. هذا يعني أنه إذا قام به بعض الناس، يُرفع الالتزام عن الآخرين. للصلوات الفردية في المنزل، هو سنة مؤكدة، موصى به بشدة ولكن ليس واجباً.

س٢: هل يمكنني الصلاة بدون أذان وإقامة؟
ج: نعم، صلاتك صحيحة بدون الأذان والإقامة. ومع ذلك، فإن الدعوة إليهما سنة موصى بها بشدة وتجلب أجراً عظيماً. شجع النبي ﷺ حتى أولئك الذين يصلون بمفردهم على الأذان.

س٣: ماذا يجب أن أفعل عندما أسمع الأذان؟
ج: يجب عليك:
١. التوقف عن الحديث والاستماع باهتمام
٢. تكرار كل عبارة بعد المؤذن بصمت
٣. عند سماع "حي على الصلاة" أو "حي على الفلاح"، قل "لا حول ولا قوة إلا بالله"
٤. بعد الأذان، أرسل الصلاة على النبي ﷺ
٥. اتل الدعاء طالباً من الله أن يمنح النبي الوسيلة

س٤: هل يمكنني الأذان إذا لم أكن على وضوء؟
ج: نعم، الأذان صحيح حتى بدون وضوء، رغم أنه من الأفضل والأكثر استحباباً أن تكون في حالة طهارة عند الأذان.

س٥: هل يمكن الأذان بلغات غير العربية؟
ج: يتفق الغالبية العظمى من العلماء على أن الأذان يجب أن يُنادى به بالعربية كما علمه النبي ﷺ. ومع ذلك، يُشجع تعليم معناه باللغات المحلية.

س٦: ما الفرق بين الأذان والإقامة؟
ج: كلاهما نداء للصلاة، لكن:
• الأذان يعلن أن وقت الصلاة قد دخل
• الإقامة تعلن أن الصلاة على وشك البدء فوراً
• الأذان يُنادى به ببطء ولحن
• الإقامة تُنادى بها بسرعة أكبر
• الأذان يتضمن عبارات إضافية في الفجر ("الصلاة خير من النوم" في التقليد السني)
• الإقامة تتضمن "قد قامت الصلاة"

س٧: هل يمكنني الأذان قبل وقت الصلاة؟
ج: لا، يجب أن يُنادى بالأذان فقط بعد دخول وقت الصلاة، باستثناء الفجر حيث يسمح بعض العلماء بالأذان قليلاً قبل الفجر لإيقاظ الناس.

س٨: لماذا تتغير أوقات الصلاة يومياً؟
ج: أوقات الصلاة تعتمد على موقع الشمس، الذي يتغير على مدار العام بسبب دوران الأرض ومدارها. لهذا السبب تتغير أوقات الصلاة قليلاً كل يوم وتختلف حسب الموقع الجغرافي.

س٩: هل يجوز استخدام مكبرات الصوت للأذان؟
ج: تسمح الغالبية العظمى من العلماء المعاصرين باستخدام مكبرات الصوت والتكنولوجيا للأذان لأنها تساعد النداء على الوصول إلى المزيد من الناس، محققة الغرض الأصلي من الأذان. ومع ذلك، يجب أن يتم ذلك مع مراعاة الجيران.

س١٠: هل يمكنني الأذان أثناء السفر أو في بلد غير مسلم؟
ج: نعم، يمكنك وينبغي أن تؤذن أينما كنت. إذا كنت في مكان عام قد يزعج الآخرين أو محظور، يمكنك أن تنادي به بهدوء لنفسك.

س١١: ماذا لو فاتني الأذان؟
ج: إذا فاتتك صلاة، يجب أن تنادي بالأذان والإقامة قبل قضاء الصلاة، لأن هذه النداءات سنة لكل صلاة.

س١٢: هل هناك ثواب للاستماع إلى الأذان؟
ج: نعم! قال النبي ﷺ إن من يكرر الأذان بعد المؤذن سيحصل على عشر حسنات لكل عبارة، والدعاء بين الأذان والإقامة لا يُرد.

س١٣: لماذا يبدو الأذان مختلفاً في المساجد المختلفة؟
ج: بينما الكلمات هي نفسها، يمكن أن يختلف اللحن والأسلوب حسب المنطقة والتقليد الإسلامي (السنة/الشيعة) والتأثيرات الثقافية. كل هذه الاختلافات مقبولة طالما تم تضمين العبارات المطلوبة.

س١٤: هل يمكنني تسجيل الأذان وتشغيله بدلاً من الأذان المباشر؟
ج: يفضل معظم العلماء الأذان المباشر على المسجل لأن:
• المؤذن يحصل على ثواب الأذان
• يخلق اتصالاً بين الداعي والمستمعين
• ومع ذلك، في الحالات التي لا يمكن فيها لأحد الأذان مباشرة، فإن تشغيل التسجيل أفضل من عدم وجود أذان على الإطلاق

س١٥: ماذا يجب أن تفعل النساء عند سماع الأذان؟
ج: يجب على النساء الرد على الأذان تماماً مثل الرجال - بتكرار العبارات بهدوء وعمل الدعاء بعد ذلك. ينطبق هذا سواء كن في المنزل أو في المسجد.

س١٦: هل هناك دعاء معين بعد الأذان؟
ج: نعم، علمنا النبي ﷺ أن نقول بعد الأذان:
"اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلاَةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"

قال النبي ﷺ: "من قال هذا بعد سماع الأذان، وجبت له شفاعتي يوم القيامة." (صحيح البخاري)

س١٧: هل يمكن للأطفال الأذان؟
ج: نعم، أذان الطفل المميز (الذي يفهم ما يقول) صحيح وفقاً لمعظم العلماء. في الواقع، من الجيد تعليم الأطفال الأذان كجزء من تعليمهم الإسلامي.

س١٨: ما حكم الرد على الهاتف أثناء الأذان؟
ج: من الأفضل ترك الأذان ينتهي قبل الرد على الهاتف أو الانخراط في المحادثة، لأن الاستماع إلى الأذان وتكراره سنة مهمة.

س١٩: هل يمكنني الأذان في حالة جنابة؟
ج: تقول غالبية العلماء إن الأذان يمكن أن يُؤذن في حالة الجنابة، رغم أنه مكروه. من الأفضل التطهر أولاً إذا أمكن.

س٢٠: لماذا لدى بعض المساجد أوقات مختلفة؟
ج: قد تتبع المساجد المختلفة طرق حساب مختلفة، أو تطبق هوامش أمان مختلفة، أو تتبع آراء علماء مختلفة حول تعريف أوقات الفجر والعشاء. هذه الاختلافات البسيطة طبيعية ومقبولة.

المصادر الموثوقة:
• صحيح البخاري
• صحيح مسلم
• سنن أبي داود
• سنن الترمذي
• مجموعات الفتاوى المعاصرة
• مواقع الأسئلة والأجوبة الإسلامية''',
      },
    },
    {
      'number': 11,
      'titleKey': 'azan_11_modern_practices',
      'title': 'Modern Practices and Technology',
      'titleUrdu': 'جدید طریقے اور ٹیکنالوجی',
      'titleHindi': 'आधुनिक तरीक़े और टेक्नोलॉजी',
      'titleArabic': 'الممارسات الحديثة والتكنولوجيا',
      'icon': Icons.devices,
      'color': Colors.cyan,
      'details': {
        'english': '''Modern Practices and Technology in Azan

How Technology Has Transformed the Call to Prayer

In the 21st century, technology has significantly impacted how Muslims practice their faith, including the tradition of the Adhan. While maintaining the spiritual essence and authenticity, modern innovations have made the call to prayer more accessible and reliable worldwide.

Digital Azan Apps and Software:

Popular Applications:
Over 170 million Muslims worldwide use apps like Muslim Pro, Al-Azan, WeMuslim, Sajda, and Salatuk for prayer times and Adhan notifications. These apps offer:
• Automatic prayer time calculations based on GPS location
• Multiple muezzin voice options from around the world
• Qibla direction finder
• Customizable Adhan sounds and volumes
• Silent mode for work/school environments
• Integration with phone calendars and reminders

Benefits of Digital Apps:
1. Accuracy: Apps sync with official Islamic institutions and astronomical calculations
2. Global Reach: Works anywhere in the world with automatic location detection
3. Accessibility: Helps Muslims maintain prayer schedule while traveling
4. Educational: Includes translations and transliterations
5. Customization: Users can choose their preferred recitation style

Automatic Azan Systems:

Mosque Technology:
Modern mosques increasingly use automated Azan systems that:
• Integrate with online prayer time databases
• Automatically adjust for daylight saving time and time zone changes
• Use high-quality speaker systems for clear, far-reaching sound
• Allow muezzins to record their own voice for authentic broadcasts
• Reduce human error in timing

Public Spaces:
Government offices, hospitals, shopping malls, and airports in Muslim-majority countries often use automated Azan systems adapted to contemporary settings, ensuring Muslims can fulfill their religious obligations even in busy modern environments.

Islamic Perspective on Digital Technology:

Scholarly Opinions:

Permissibility:
The vast majority of contemporary Islamic scholars permit and even encourage the use of technology for Adhan, viewing it as a beneficial innovation (innovation in means, not in religious practice).

Key Rulings:
1. **Recorded Adhan**: Most scholars permit recorded Adhan, especially when:
   - No one is available to call it live
   - It helps reach more people
   - The recording is of good quality and respectful
   - It serves the purpose of announcing prayer times

2. **Loudspeakers**: Unanimously permitted as they amplify the human voice, fulfilling the original purpose of reaching distant listeners

3. **Apps and Notifications**: Considered helpful tools (wasā'il) that assist in worship, not worship themselves

Hybrid Approach:
Most mosques employ a hybrid system where:
• The muezzin records the Adhan in his own voice
• The recording is played electronically at precise times
• This combines tradition with technological reliability

Concerns Addressed:

"Does technology replace the muezzin?"
No. Technology is a tool that assists the muezzin. Many mosques still have designated muezzins who:
• Manage the automated systems
• Call Adhan live on special occasions
• Maintain the human connection to this sacred duty
• Receive rewards for facilitating the call to prayer

"Is recorded Adhan less spiritual?"
Scholars emphasize that:
• The spiritual essence comes from responding to the call and performing prayer
• A recorded Adhan from a beautiful voice can inspire devotion
• What matters most is the sincerity of response, not the delivery method

Smart Azan Devices:

Modern Innovations:
1. **Azan Clocks**: Digital clocks that automatically call Adhan at correct times based on location
2. **Smart Watches**: Wearable devices with prayer time reminders and Qibla direction
3. **IoT Devices**: Internet-connected devices that update prayer times automatically
4. **Masjid Tablets**: Touch-screen displays showing prayer times, Quranic verses, and Islamic content
5. **Prayer Time APIs**: Services that provide accurate prayer times for apps and websites

Features:
• Worldwide coverage with 6+ million cities
• Multiple calculation methods (MWL, ISNA, Umm al-Qura, etc.)
• Automatic location detection
• Hijri calendar integration
• Qibla compass with augmented reality

Benefits for Modern Muslims:

1. **Consistency**: Never miss prayer times even while traveling
2. **Accuracy**: Precise calculations based on astronomical data
3. **Privacy**: Silent notifications in non-Muslim environments
4. **Education**: Learn proper Adhan pronunciation and etiquette
5. **Community**: Connect with other Muslims through app features
6. **Accessibility**: Helps those with hearing or visual impairments through vibrations and visual alerts

Etiquette for Digital Azan:

Recommended Practices:
1. **Respect**: Treat app notifications with the same reverence as live Adhan
2. **Response**: Still repeat the words silently and make du'a after
3. **Volume**: Set to appropriate levels that don't disturb others
4. **Settings**: Configure for accurate location and calculation method
5. **Backup**: Don't rely solely on technology; know your prayer times
6. **Intention**: Remember technology is a tool to help worship Allah

Guidelines for Mosque Systems:
• Use high-quality recordings from reputable reciters
• Test volume levels to avoid disturbing neighbors
• Maintain equipment regularly
• Have backup systems in case of technical failure
• Train volunteers to operate the systems correctly

Balance Between Tradition and Innovation:

Islamic Principle:
Islam encourages beneficial innovation in means while preserving the essence of worship. The Adhan's words, purpose, and spiritual significance remain unchanged; only the delivery method has evolved.

Best Practices:
• Mosques should maintain the tradition of live Adhan when possible
• Technology should enhance, not replace, human involvement
• Young Muslims should learn the traditional method alongside using modern tools
• Communities should appreciate both the muezzin's role and technology's benefits

The Future of Adhan:

As technology continues advancing, we may see:
• AI-powered prayer time calculations with even greater accuracy
• Holographic displays of Kaaba direction
• Multi-language Adhan apps for diverse communities
• Integration with smart home systems
• Virtual reality mosque experiences

However, the core remains unchanged: five times daily, Muslims worldwide pause to hear or receive the call reminding them of their Creator, whether through a traditional muezzin's voice or a smartphone notification.

Authentic Sources:
• New Age Islam - Digital Azan article
• Islamic Finder - Athan Apps
• Contemporary Islamic Fatwa Collections
• Muslim Pro App (170M+ users)
• Al-Azan and WeMuslim Apps
• Islamic Technology Research Papers''',
        'urdu': '''اذان میں جدید طریقے اور ٹیکنالوجی

کس طرح ٹیکنالوجی نے اذان کو تبدیل کیا ہے

21ویں صدی میں، ٹیکنالوجی نے مسلمانوں کے دینی طریقوں کو بہت متاثر کیا ہے، بشمول اذان کی روایت۔ روحانی جوہر اور صداقت کو برقرار رکھتے ہوئے، جدید ایجادات نے دنیا بھر میں اذان کو زیادہ قابل رسائی اور قابل اعتماد بنا دیا ہے۔

ڈیجیٹل اذان ایپس اور سافٹ ویئر:

مشہور ایپلیکیشنز:
دنیا بھر میں 170 ملین سے زیادہ مسلمان Muslim Pro، Al-Azan، WeMuslim، Sajda، اور Salatuk جیسی ایپس استعمال کرتے ہیں نماز کے اوقات اور اذان کی اطلاعات کے لیے۔ یہ ایپس پیش کرتی ہیں:
• GPS مقام کی بنیاد پر خودکار نماز کے اوقات کا حساب
• دنیا بھر سے متعدد مؤذن کی آوازیں
• قبلہ کی سمت تلاش کرنے والا
• حسب ضرورت اذان کی آوازیں اور والیوم
• کام/سکول کے ماحول کے لیے خاموش موڈ
• فون کیلنڈر اور یاد دہانیوں کے ساتھ انضمام

ڈیجیٹل ایپس کے فوائد:
1. درستگی: ایپس سرکاری اسلامی اداروں اور فلکیاتی حسابات کے ساتھ ہم آہنگ ہوتی ہیں
2. عالمی رسائی: دنیا میں کہیں بھی خودکار مقام کی تلاش کے ساتھ کام کرتی ہیں
3. قابل رسائی: سفر کے دوران مسلمانوں کو نماز کا شیڈول برقرار رکھنے میں مدد کرتی ہیں
4. تعلیمی: ترجمے اور تلفظ شامل ہیں
5. حسب ضرورت: صارفین اپنی پسندیدہ تلاوت کا انداز منتخب کر سکتے ہیں

خودکار اذان کے نظام:

مسجد کی ٹیکنالوجی:
جدید مساجد تیزی سے خودکار اذان کے نظام استعمال کر رہی ہیں جو:
• آن لائن نماز کے اوقات کے ڈیٹا بیس کے ساتھ مربوط ہیں
• ڈے لائٹ سیونگ ٹائم اور ٹائم زون کی تبدیلیوں کے لیے خودکار ایڈجسٹ کرتے ہیں
• صاف، دور تک پہنچنے والی آواز کے لیے اعلیٰ معیار کے اسپیکر سسٹم استعمال کرتے ہیں
• مؤذنین کو اصلی نشریات کے لیے اپنی آواز ریکارڈ کرنے کی اجازت دیتے ہیں
• وقت میں انسانی غلطی کو کم کرتے ہیں

عوامی جگہیں:
مسلم اکثریتی ممالک میں سرکاری دفاتر، ہسپتال، شاپنگ مالز اور ہوائی اڈے اکثر خودکار اذان کے نظام استعمال کرتے ہیں جو عصری ترتیبات کے مطابق ہیں، یہ یقینی بناتے ہوئے کہ مسلمان مصروف جدید ماحول میں بھی اپنی مذہبی ذمہ داریاں پوری کر سکیں۔

ڈیجیٹل ٹیکنالوجی پر اسلامی نقطہ نظر:

علمائے آرا:

جواز:
عصری اسلامی علماء کی وسیع اکثریت اذان کے لیے ٹیکنالوجی کے استعمال کی اجازت دیتی ہے اور یہاں تک کہ اس کی حوصلہ افزائی کرتی ہے، اسے ایک فائدہ مند جدت (ذرائع میں جدت، مذہبی عمل میں نہیں) کے طور پر دیکھتے ہوئے۔

اہم احکام:
1. **ریکارڈ شدہ اذان**: زیادہ تر علماء ریکارڈ شدہ اذان کی اجازت دیتے ہیں، خاص طور پر جب:
   - براہ راست اذان دینے کے لیے کوئی دستیاب نہ ہو
   - یہ زیادہ لوگوں تک پہنچنے میں مدد کرے
   - ریکارڈنگ اچھے معیار کی اور باادب ہو
   - یہ نماز کے اوقات کے اعلان کے مقصد کو پورا کرے

2. **لاؤڈ اسپیکر**: متفقہ طور پر جائز ہیں کیونکہ وہ انسانی آواز کو بڑھاتے ہیں، دور کے سامعین تک پہنچنے کے اصل مقصد کو پورا کرتے ہوئے

3. **ایپس اور اطلاعات**: مددگار آلات (وسائل) سمجھے جاتے ہیں جو عبادت میں مدد کرتے ہیں، خود عبادت نہیں

مخلوط طریقہ:
زیادہ تر مساجد ایک مخلوط نظام استعمال کرتی ہیں جہاں:
• مؤذن اپنی آواز میں اذان ریکارڈ کرتا ہے
• ریکارڈنگ کو صحیح اوقات پر الیکٹرانک طور پر بجایا جاتا ہے
• یہ روایت کو تکنیکی قابل اعتمادیت کے ساتھ ملاتا ہے

تشویشات کا ازالہ:

"کیا ٹیکنالوجی مؤذن کی جگہ لے لیتی ہے؟"
نہیں۔ ٹیکنالوجی ایک آلہ ہے جو مؤذن کی مدد کرتا ہے۔ بہت سی مساجد میں اب بھی نامزد مؤذن ہیں جو:
• خودکار نظاموں کا انتظام کرتے ہیں
• خاص مواقع پر براہ راست اذان دیتے ہیں
• اس مقدس فرض سے انسانی تعلق برقرار رکھتے ہیں
• اذان کی سہولت فراہم کرنے پر اجر حاصل کرتے ہیں

"کیا ریکارڈ شدہ اذان کم روحانی ہے؟"
علماء اس بات پر زور دیتے ہیں کہ:
• روحانی جوہر پکار کا جواب دینے اور نماز ادا کرنے سے آتا ہے
• خوبصورت آواز سے ریکارڈ شدہ اذان عقیدت کو متاثر کر سکتی ہے
• سب سے اہم جواب کی خلوصیت ہے، ترسیل کا طریقہ نہیں

سمارٹ اذان کے آلات:

جدید ایجادات:
1. **اذان کی گھڑیاں**: ڈیجیٹل گھڑیاں جو مقام کی بنیاد پر صحیح اوقات پر خودکار طور پر اذان دیتی ہیں
2. **سمارٹ واچز**: نماز کے اوقات کی یاد دہانیوں اور قبلہ کی سمت کے ساتھ پہننے کے قابل آلات
3. **IoT ڈیوائسز**: انٹرنیٹ سے منسلک آلات جو خودکار طور پر نماز کے اوقات کو اپ ڈیٹ کرتے ہیں
4. **مسجد ٹیبلٹس**: ٹچ اسکرین ڈسپلے جو نماز کے اوقات، قرآنی آیات اور اسلامی مواد دکھاتے ہیں
5. **نماز کے اوقات کی APIs**: خدمات جو ایپس اور ویب سائٹس کے لیے درست نماز کے اوقات فراہم کرتی ہیں

خصوصیات:
• 6+ ملین شہروں کے ساتھ عالمی کوریج
• متعدد حساب کتاب کے طریقے (MWL، ISNA، ام القریٰ، وغیرہ)
• خودکار مقام کی تلاش
• ہجری کیلنڈر کا انضمام
• Augmented reality کے ساتھ قبلہ کمپاس

جدید مسلمانوں کے لیے فوائد:

1. **مستقل مزاجی**: سفر کے دوران بھی نماز کے اوقات کبھی نہ چھوٹیں
2. **درستگی**: فلکیاتی ڈیٹا پر مبنی درست حسابات
3. **رازداری**: غیر مسلم ماحول میں خاموش اطلاعات
4. **تعلیم**: اذان کے صحیح تلفظ اور آداب سیکھیں
5. **کمیونٹی**: ایپ کی خصوصیات کے ذریعے دوسرے مسلمانوں سے جڑیں
6. **قابل رسائی**: سماعت یا بصری معذوری والوں کو کمپن اور بصری الرٹس کے ذریعے مدد کرتا ہے

ڈیجیٹل اذان کے آداب:

تجویز کردہ طریقے:
1. **احترام**: ایپ کی اطلاعات کو براہ راست اذان کی طرح ہی احترام کے ساتھ لیں
2. **جواب**: اب بھی خاموشی سے الفاظ دہرائیں اور بعد میں دعا کریں
3. **والیوم**: مناسب سطح پر سیٹ کریں جو دوسروں کو پریشان نہ کرے
4. **ترتیبات**: درست مقام اور حساب کتاب کے طریقے کے لیے کنفیگر کریں
5. **بیک اپ**: صرف ٹیکنالوجی پر انحصار نہ کریں؛ اپنے نماز کے اوقات جانیں
6. **نیت**: یاد رکھیں کہ ٹیکنالوجی اللہ کی عبادت میں مدد کرنے کا ایک آلہ ہے

مسجد کے نظاموں کے لیے رہنما خطوط:
• معتبر قاریوں سے اعلیٰ معیار کی ریکارڈنگ استعمال کریں
• پڑوسیوں کو پریشان کرنے سے بچنے کے لیے والیوم کی سطح کی جانچ کریں
• سامان کی باقاعدگی سے دیکھ بھال کریں
• تکنیکی ناکامی کی صورت میں بیک اپ نظام رکھیں
• رضاکاروں کو نظام صحیح طریقے سے چلانے کی تربیت دیں

روایت اور جدت میں توازن:

اسلامی اصول:
اسلام عبادت کے جوہر کو محفوظ رکھتے ہوئے ذرائع میں فائدہ مند جدت کی حوصلہ افزائی کرتا ہے۔ اذان کے الفاظ، مقصد اور روحانی اہمیت برقرار رہتی ہے؛ صرف ترسیل کا طریقہ تبدیل ہوا ہے۔

بہترین طریقے:
• مساجد کو جب ممکن ہو براہ راست اذان کی روایت برقرار رکھنی چاہیے
• ٹیکنالوجی کو انسانی شمولیت کی جگہ نہیں لینی چاہیے بلکہ بڑھانا چاہیے
• نوجوان مسلمانوں کو جدید آلات کے ساتھ روایتی طریقہ بھی سیکھنا چاہیے
• کمیونٹیز کو مؤذن کے کردار اور ٹیکنالوجی کے فوائد دونوں کی قدر کرنی چاہیے

اذان کا مستقبل:

جیسے جیسے ٹیکنالوجی ترقی کرتی جا رہی ہے، ہم دیکھ سکتے ہیں:
• AI سے چلنے والے نماز کے اوقات کے حسابات مزید بہتر درستگی کے ساتھ
• کعبہ کی سمت کے holographic ڈسپلے
• متنوع کمیونٹیز کے لیے کثیر زبانوں میں اذان ایپس
• سمارٹ ہوم سسٹمز کے ساتھ انضمام
• ورچوئل رئیلٹی مسجد کے تجربات

تاہم، بنیاد بدستور قائم ہے: روزانہ پانچ بار، دنیا بھر کے مسلمان اپنے خالق کی یاد دلانے والی پکار سننے یا وصول کرنے کے لیے رک جاتے ہیں، چاہے روایتی مؤذن کی آواز کے ذریعے ہو یا اسمارٹ فون کی اطلاع کے ذریعے۔

مستند ذرائع:
• نیو ایج اسلام - ڈیجیٹل اذان مضمون
• اسلامک فائنڈر - اذان ایپس
• عصری اسلامی فتاویٰ کے مجموعے
• مسلم پرو ایپ (170M+ صارفین)
• ال-اذان اور وی مسلم ایپس
• اسلامی ٹیکنالوجی تحقیقی مقالے''',
        'hindi': '''अज़ान में आधुनिक तरीक़े और टेक्नोलॉजी

कैसे टेक्नोलॉजी ने अज़ान को बदल दिया है

21वीं सदी में, टेक्नोलॉजी ने मुसलमानों के दीनी तरीक़ों को बहुत मुतअस्सिर किया है, बिशमूल अज़ान की रिवायत। रूहानी जौहर और सदाक़त को बरक़रार रखते हुए, जदीद ईजादात ने दुनिया भर में अज़ान को ज़्यादा क़ाबिल-ए-रसाई और क़ाबिल-ए-एतिमाद बना दिया है।

डिजिटल अज़ान ऐप्स और सॉफ़्टवेयर:

मशहूर ऐप्लिकेशन्स:
दुनिया भर में 170 मिलियन से ज़्यादा मुसलमान Muslim Pro, Al-Azan, WeMuslim, Sajda, और Salatuk जैसी ऐप्स इस्तेमाल करते हैं नमाज़ के औक़ात और अज़ान की इत्तिलाआत के लिए। ये ऐप्स पेश करती हैं:
• GPS मक़ाम की बुनियाद पर ख़ुदकार नमाज़ के औक़ात का हिसाब
• दुनिया भर से मुतअद्दिद मुअज़्ज़िन की आवाज़ें
• क़िबला की सिम्त तलाश करने वाला
• हसब-ए-ज़रूरत अज़ान की आवाज़ें और वॉल्यूम
• काम/स्कूल के माहौल के लिए ख़ामोश मोड
• फ़ोन कैलेंडर और याद दिहानियों के साथ इंज़िमाम

डिजिटल ऐप्स के फ़वाइद:
1. दुरुस्तगी: ऐप्स सरकारी इस्लामी इदारों और फ़लकियाती हिसाबात के साथ हम-आहंग होती हैं
2. आलमी रसाई: दुनिया में कहीं भी ख़ुदकार मक़ाम की तलाश के साथ काम करती हैं
3. क़ाबिल-ए-रसाई: सफ़र के दौरान मुसलमानों को नमाज़ का शेड्यूल बरक़रार रखने में मदद करती हैं
4. तालीमी: तर्जुमे और तलफ़्फ़ुज़ शामिल हैं
5. हसब-ए-ज़रूरत: सारफ़ीन अपनी पसंदीदा तिलावत का अंदाज़ मुंतख़ब कर सकते हैं

ख़ुदकार अज़ान के निज़ाम:

मस्जिद की टेक्नोलॉजी:
जदीद मस्जिदें तेज़ी से ख़ुदकार अज़ान के निज़ाम इस्तेमाल कर रही हैं जो:
• ऑनलाइन नमाज़ के औक़ात के डेटाबेस के साथ मरबूत हैं
• डे लाइट सेविंग टाइम और टाइम ज़ोन की तब्दीलियों के लिए ख़ुदकार एडजस्ट करते हैं
• साफ़, दूर तक पहुंचने वाली आवाज़ के लिए आला मेयार के स्पीकर सिस्टम इस्तेमाल करते हैं
• मुअज़्ज़िनीन को असली नशरियात के लिए अपनी आवाज़ रिकॉर्ड करने की इजाज़त देते हैं
• वक़्त में इंसानी ग़लती को कम करते हैं

आम जगहें:
मुस्लिम अक्सरियती मुमालिक में सरकारी दफ़ातिर, हस्पताल, शॉपिंग मॉल्स और हवाई अड्डे अक्सर ख़ुदकार अज़ान के निज़ाम इस्तेमाल करते हैं जो असरी तर्तीबात के मुताबिक़ हैं, यह यक़ीनी बनाते हुए कि मुसलमान मसरूफ़ जदीद माहौल में भ��� अपनी मज़हबी ज़िम्मेदारियां पूरी कर सकें।

डिजिटल टेक्नोलॉजी पर इस्लामी नज़रिया:

उलमा आरा:

जवाज़:
असरी इस्लामी उलमा की वसी अक्सरियत अज़ान के लिए टेक्नोलॉजी के इस्तेमाल की इजाज़त देती है और यहां तक कि इसकी हौसला-अफ़ज़ाई करती है, इसे एक फ़ायदामंद जदत (ज़राये में जदत, मज़हबी अमल में नहीं) के तौर पर देखते हुए।

अहम अहकाम:
1. **रिकॉर्ड शुदा अज़ान**: ज़्यादातर उलमा रिकॉर्ड शुदा अज़ान की इजाज़त देते हैं, ख़ास तौर पर जब:
   - बराह-रास्त अज़ान देने के लिए कोई दस्तयाब न हो
   - यह ज़्यादा लोगों तक पहुंचने में मदद करे
   - रिकॉर्डिंग अच्छे मेयार की और बा-अदब हो
   - यह नमाज़ के औक़ात के एलान के मक़सद को पूरा करे

2. **लाउड स्पीकर**: मुत्तफ़िक़ा तौर पर जायज़ हैं क्योंकि वे इंसानी आवाज़ को बढ़ाते हैं, दूर के सामईन तक पहुंचने के असल मक़सद को पूरा करते हुए

3. **ऐप्स और इत्तिलाआत**: मददगार आलात (वसाइल) समझे जाते हैं जो इबादत में मदद करते हैं, ख़ुद इबादत नहीं

मुख़्तलित तरीक़ा:
ज़्यादातर मस्जिदें एक मुख़्तलित निज़ाम इस्तेमाल करती हैं जहां:
• मुअज़्ज़िन अपनी आवाज़ में अज़ान रिकॉर्ड करता है
• रिकॉर्डिंग को सही औक़ात पर इलेक्ट्रॉनिक तौर पर बजाया जाता है
• यह रिवायत को तकनीकी क़ाबिल-ए-एतिमादी के साथ मिलाता है

तशवीशात का इज़ाला:

"क्या टेक्नोलॉजी मुअज़्ज़िन की जगह ले लेती है?"
नहीं। टेक्नोलॉजी एक आला है जो मुअज़्ज़िन की मदद करता है। बहुत सी मस्जिदों में अब भी नामज़द मुअज़्ज़िन हैं जो:
• ख़ुदकार निज़ामों का इंतिज़ाम करते हैं
• ख़ास मवाक़े पर बराह-रास्त अज़ान देते हैं
• इस मुक़द्दस फ़र्ज़ से इंसानी ताल्लुक़ बरक़रार रखते हैं
• अज़ान की सुहूलत फ़राहम करने पर अज्र हासिल करते हैं

"क्या रिकॉर्ड शुदा अज़ान कम रूहानी है?"
उलमा इस बात पर ज़ोर देते हैं कि:
• रूहानी जौहर पुकार का जवाब देने और नमाज़ अदा करने से आता है
• ख़ूबसूरत आवाज़ से रिकॉर्ड शुदा अज़ान अक़ीदत को मुतअस्सिर कर सकती है
• सबसे अहम जवाब की ख़ुलूसियत है, तरसील का तरीक़ा नहीं

स्मार्ट अज़ान के आलात:

जदीद ईजादात:
1. **अज़ान की घड़ियां**: डिजिटल घड़ियां जो मक़ाम की बुनियाद पर सही औक़ात पर ख़ुदकार तौर पर अज़ान देती हैं
2. **स्मार्ट वॉचेज़**: नमाज़ के औक़ात की याद दिहानियों और क़िबला की सिम्त के साथ पहनने के क़ाबिल आलात
3. **IoT डिवाइसेज़**: इंटरनेट से मुनस्लिक आलात जो ख़ुदकार तौर पर नमाज़ के औक़ात को अप डेट करते हैं
4. **मस्जिद टैबलेट्स**: टच स्क्रीन डिस्प्ले जो नमाज़ के औक़ात, क़ुरआनी आयात और इस्लामी मवाद दिखाते हैं
5. **नमाज़ के औक़ात की APIs**: ख़िदमात जो ऐप्स और वेबसाइट्स के लिए दुरुस्त नमाज़ के औक़ात फ़राहम करती हैं

ख़ुसूसियात:
• 6+ मिलियन शहरों के साथ आलमी कवरेज
• मुतअद्दिद हिसाब किताब के तरीक़े (MWL, ISNA, उम्मुल क़ुरा, वग़ैरा)
• ख़ुदकार मक़ाम की तलाश
• हिजरी कैलेंडर का इंज़िमाम
• Augmented reality के साथ क़िबला कम्पास

जदीद मुसलमानों के लिए फ़वाइद:

1. **मुस्तक़िल मिज़ाजी**: सफ़र के दौरान भी नमाज़ के औक़ात कभी न छूटें
2. **दुरुस्तगी**: फ़लकियाती डेटा पर मबनी दुरुस्त हिसाबात
3. **राज़दारी**: ग़ैर-मुस्लिम माहौल में ख़ामोश इत्तिलाआत
4. **तालीम**: अज़ान के सही तलफ़्फ़ुज़ और आदाब सीखें
5. **कम्युनिटी**: ऐप की ख़ुसूसियात के ज़रिये दूसरे मुसलमानों से जुड़ें
6. **क़ाबिल-ए-रसाई**: समाअत या बसरी मअज़ूरी वालों को कंपन और बसरी अलर्ट्स के ज़रिये मदद करता है

डिजिटल अज़ान के आदाब:

तजवीज़ करदा तरीक़े:
1. **एहतिराम**: ऐप की इत्तिलाआत को बराह-रास्त अज़ान की तरह ही एहतिराम के साथ लें
2. **जवाब**: अब भी ख़ामोशी से अल्फ़ाज़ दोहराएं और बाद में दुआ करें
3. **वॉल्यूम**: मुनासिब सतह पर सेट करें जो दूसरों को परेशान न करे
4. **तर्तीबात**: दुरुस्त मक़ाम और हिसाब किताब के तरीक़े के लिए कॉन्फ़िगर करें
5. **बैकअप**: सिर्फ़ टेक्नोलॉजी पर एंहिसार न करें; अपने नमाज़ के औक़ात जानें
6. **नियत**: याद रखें कि टेक्नोलॉजी अल्लाह की इबादत में मदद करने का एक आला है

मस्जिद के निज़ामों के लिए रहनुमा ख़ुतूत:
• मोतबर क़ारियों से आला मेयार की रिकॉर्डिंग इस्तेमाल करें
• पड़ोसियों को परेशान करने से बचने के लिए वॉल्यूम की सतह की जांच करें
• सामान की बाक़ायदगी से देख-भाल करें
• तकनीकी नाकामी की सूरत में बैकअप निज़ाम रखें
• रिज़ाकारों को निज़ाम सही तरीक़े से चलाने की तर्बियत दें

रिवायत और जदत में तवाज़ुन:

इस्लामी उसूल:
इस्लाम इबादत के जौहर को महफ़ूज़ रखते हुए ज़राये में फ़ायदामंद जदत की हौसला-अफ़ज़ाई करता है। अज़ान के अल्फ़ाज़, मक़सद और रूहानी अहमियत बरक़रार रहती है; सिर्फ़ तरसील का तरीक़ा तब्दील हुआ है।

बेहतरीन तरीक़े:
• मस्जिदों को जब मुम्किन हो बराह-रास्त अज़ान की रिवायत बरक़रार रखनी चाहिए
• टेक्नोलॉजी को इंसानी शुमूलियत की जगह नहीं लेनी चाहिए बल्कि बढ़ाना चाहिए
• नौजवान मुसलमानों को जदीद आलात के साथ रिवायती तरीक़ा भी सीखना चाहिए
• कम्युनिटीज़ को मुअज़्ज़िन के किरदार और टेक्नोलॉजी के फ़वाइद दोनों की क़द्र करनी चाहिए

अज़ान का मुस्तक़बिल:

जैसे जैसे टेक्नोलॉजी तरक़्क़ी करती जा रही है, हम देख सकते हैं:
• AI से चलने वाले नमाज़ के औक़ात के हिसाबात मज़ीद बेहतर दुरुस्तगी के साथ
• काबा की सिम्त के holographic डिस्प्ले
• मुतनव्वे कम्युनिटीज़ के लिए कसीर ज़बानों में अज़ान ऐप्स
• स्मार्ट होम सिस्टम्स के साथ इंज़िमाम
• वर्चुअल रियलिटी मस्जिद के तजरुबात

ताहम, बुनियाद बदस्तूर क़ायम है: रोज़ाना पांच बार, दुनिया भर के मुसलमान अपने ख़ालिक़ की याद दिलाने वाली पुकार सुनने या वुसूल करने के लिए रुक जाते हैं, चाहे रिवायती मुअज़्ज़िन की आवाज़ के ज़रिये हो या स्मार्टफ़ोन की इत्तिला के ज़रिये।

मुस्तनद ज़राये:
• न्यू एज इस्लाम - डिजिटल अज़ान मज़मून
• इस्लामिक फ़ाइंडर - अज़ान ऐप्स
• असरी इस्लामी फ़तावा के मजमूए
• मुस्लिम प्रो ऐप (170M+ सारफ़ीन)
• अल-अज़ान और वी मुस्लिम ऐप्स
• इस्लामी टेक्नोलॉजी तहक़ीक़ी मक़ाले''',
        'arabic': '''الممارسات الحديثة والتكنولوجيا في الأذان

كيف غيرت التكنولوجيا الدعوة إلى الصلاة

في القرن الحادي والعشرين، أثرت التكنولوجيا بشكل كبير على كيفية ممارسة المسلمين لدينهم، بما في ذلك تقليد الأذان. مع الحفاظ على الجوهر الروحي والأصالة، جعلت الابتكارات الحديثة الدعوة إلى الصلاة أكثر سهولة وموثوقية في جميع أنحاء العالم.

تطبيقات وبرامج الأذان الرقمية:

التطبيقات الشعبية:
يستخدم أكثر من 170 مليون مسلم حول العالم تطبيقات مثل Muslim Pro و Al-Azan و WeMuslim و Sajda و Salatuk لأوقات الصلاة وإشعارات الأذان. تقدم هذه التطبيقات:
• حسابات تلقائية لأوقات الصلاة بناءً على موقع GPS
• خيارات متعددة لأصوات المؤذنين من جميع أنحاء العالم
• محدد اتجاه القبلة
• أصوات وحجم أذان قابلة للتخصيص
• وضع صامت لبيئات العمل/المدرسة
• التكامل مع تقويمات الهاتف والتذكيرات

فوائد التطبيقات الرقمية:
1. الدقة: تتزامن التطبيقات مع المؤسسات الإسلامية الرسمية والحسابات الفلكية
2. الوصول العالمي: تعمل في أي مكان في العالم مع الكشف التلقائي عن الموقع
3. إمكانية الوصول: تساعد المسلمين على الحفاظ على جدول الصلاة أثناء السفر
4. تعليمية: تشمل الترجمات والنقل الحرفي
5. التخصيص: يمكن للمستخدمين اختيار أسلوب التلاوة المفضل لديهم

أنظمة الأذان التلقائية:

تكنولوجيا المساجد:
تستخدم المساجد الحديثة بشكل متزايد أنظمة الأذان التلقائية التي:
• تتكامل مع قواعد بيانات أوقات الصلاة عبر الإنترنت
• تضبط تلقائياً للتوقيت الصيفي وتغييرات المنطقة الزمنية
• تستخدم أنظمة مكبرات صوت عالية الجودة لصوت واضح بعيد المدى
• تسمح للمؤذنين بتسجيل صوتهم للبث الأصيل
• تقلل من الخطأ البشري في التوقيت

الأماكن العامة:
غالباً ما تستخدم المكاتب الحكومية والمستشفيات ومراكز التسوق والمطارات في الدول ذات الأغلبية المسلمة أنظمة الأذان التلقائية المكيفة مع البيئات المعاصرة، مما يضمن أن يتمكن المسلمون من الوفاء بالتزاماتهم الدينية حتى في البيئات الحديثة المزدحمة.

المنظور الإسلامي للتكنولوجيا الرقمية:

آراء العلماء:

الإذن:
الغالبية العظمى من علماء الإسلام المعاصرين يأذنون ويشجعون حتى استخدام التكنولوجيا للأذان، معتبرين إياه ابتك��راً مفيداً (الابتكار في الوسائل، وليس في الممارسة الدينية).

الأحكام الرئيسية:
1. **الأذان المسجل**: يأذن معظم العلماء بالأذان المسجل، خاصة عندما:
   - لا يتوفر أحد لإطلاقه مباشرة
   - يساعد على الوصول إلى المزيد من الناس
   - التسجيل ذو جودة عالية ومحترم
   - يخدم غرض الإعلان عن أوقات الصلاة

2. **مكبرات الصوت**: مأذون بها بالإجماع لأنها تضخم الصوت البشري، محققة الغرض الأصلي من الوصول إلى المستمعين البعيدين

3. **التطبيقات والإشعارات**: تُعتبر أدوات مفيدة (وسائل) تساعد في العبادة، وليست العبادة نفسها

النهج الهجين:
تستخدم معظم المساجد نظاماً هجيناً حيث:
• يسجل المؤذن الأذان بصوته الخاص
• يُشغل التسجيل إلكترونياً في أوقات دقيقة
• يجمع هذا بين التقليد والموثوقية التكنولوجية

المخاوف المعالجة:

"هل تحل التكنولوجيا محل المؤذن؟"
لا. التكنولوجيا أداة تساعد المؤذن. لا تزال العديد من المساجد لديها مؤذنون معينون الذين:
• يديرون الأنظمة التلقائية
• يطلقون الأذان مباشرة في المناسبات الخاصة
• يحافظون على الارتباط البشري بهذا الواجب المقدس
• يحصلون على ثواب تسهيل الدعوة إلى الصلاة

"هل الأذان المسجل أقل روحانية؟"
يؤكد العلماء أن:
• الجوهر الروحي يأتي من الاستجابة للنداء وأداء الصلاة
• يمكن للأذان المسجل من صوت جميل أن يلهم التقوى
• الأهم هو صدق الاستجابة، وليس طريقة التوصيل

أجهزة الأذان الذكية:

الابتكارات الحديثة:
1. **ساعات الأذان**: ساعات رقمية تطلق الأذان تلقائياً في الأوقات الصحيحة بناءً على الموقع
2. **الساعات الذكية**: أجهزة يمكن ارتداؤها مع تذكيرات أوقات الصلاة واتجاه القبلة
3. **أجهزة إنترنت الأشياء**: أجهزة متصلة بالإنترنت تحدث أوقات الصلاة تلقائياً
4. **أجهزة لوحية للمساجد**: شاشات لمس تعرض أوقات الصلاة والآيات القرآنية والمحتوى الإسلامي
5. **واجهات برمجة التطبيقات لأوقات الصلاة**: خدمات توفر أوقات صلاة دقيقة للتطبيقات والمواقع

الميزات:
• تغطية عالمية مع أكثر من 6 ملايين مدينة
• طرق حساب متعددة (MWL، ISNA، أم القرى، إلخ)
• كشف تلقائي عن الموقع
• تكامل التقويم الهجري
• بوصلة القبلة مع الواقع المعزز

فوائد للمسلمين المعاصرين:

1. **الاتساق**: عدم تفويت أوقات الصلاة حتى أثناء السفر
2. **الدقة**: حسابات دقيقة بناءً على البيانات الفلكية
3. **الخصوصية**: إشعارات صامتة في البيئات غير الإسلامية
4. **التعليم**: تعلم النطق والآداب الصحيحة للأذان
5. **المجتمع**: الاتصال بمسلمين آخرين من خلال ميزات التطبيق
6. **إمكانية الوصول**: تساعد ذوي الإعاقات السمعية أو البصرية من خلال الاهتزازات والتنبيهات البصرية

آداب الأذان الرقمي:

الممارسات الموصى بها:
1. **الاحترام**: عامل إشعارات التطبيق بنفس التبجيل كالأذان المباشر
2. **الاستجابة**: لا تزال تكرر الكلمات بصمت وتدعو بعد ذلك
3. **الحجم**: اضبط على مستويات مناسبة لا تزعج الآخرين
4. **الإعدادات**: قم بالتكوين للموقع الدقيق وطريقة الحساب
5. **النسخ الاحتياطي**: لا تعتمد فقط على التكنولوجيا؛ اعرف أوقات صلاتك
6. **النية**: تذكر أن التكنولوجيا أداة للمساعدة في عبادة الله

إرشادات لأنظمة المساجد:
• استخدم تسجيلات عالية الجودة من قراء موثوقين
• اختبر مستويات الحجم لتجنب إزعاج الجيران
• صيانة المعدات بانتظام
• احتفظ بأنظمة احتياطية في حالة الفشل التقني
• درب المتطوعين على تشغيل الأنظمة بشكل صحيح

التوازن بين التقليد والابتكار:

المبدأ الإسلامي:
يشجع الإسلام الابتكار المفيد في الوسائل مع الحفاظ على جوهر العبادة. تظل كلمات الأذان وهدفه وأهميته الروحية دون تغيير؛ فقط طريقة التوصيل تطورت.

أفضل الممارسات:
• يجب على المساجد الحفاظ على تقليد الأذان المباشر عندما يكون ذلك ممكناً
• يجب أن تعزز التكنولوجيا، وليس تحل محل، المشاركة البشرية
• يجب على المسلمين الشباب تعلم الطريقة التقليدية جنباً إلى جنب مع استخدام الأدوات الحديثة
• يجب على المجتمعات تقدير كل من دور المؤذن وفوائد التكنولوجيا

مستقبل الأذان:

مع استمرار تقدم التكنولوجيا، قد نرى:
• حسابات أوقات الصلاة المدعومة بالذكاء الاصطناعي بدقة أكبر
• عروض ثلاثية الأبعاد لاتجاه الكعبة
• تطبيقات أذان متعددة اللغات للمجتمعات المتنوعة
• التكامل مع أنظمة المنزل الذكي
• تجارب مسجد افتراضية

ومع ذلك، يظل الجوهر دون تغيير: خمس مرات يومياً، يتوقف المسلمون في جميع أنحاء العالم لسماع أو تلقي النداء الذي يذكرهم بخالقهم، سواء من خلال صوت المؤذن التقليدي أو إشعار الهاتف الذكي.

المصادر الموثوقة:
• نيو إيج إسلام - مقالة الأذان الرقمي
• إسلاميك فايندر - تطبيقات الأذان
• مجموعات الفتاوى الإسلامية المعاصرة
• تطبيق مسلم برو (170M+ مستخدم)
• تطبيقات الأذان وويموسلم
• أوراق بحثية عن التكنولوجيا الإسلامية''',
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
          context.tr('azan'),
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sections.length,
                  itemBuilder: (context, index) =>
                      _buildCard(_sections[index], isDark),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(item['titleKey'] ?? 'azan');
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
        onTap: () => _showDetails(item),
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
                    '${item['number']}',
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
                      textDirection: (langCode == 'ur' || langCode == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    responsive.vSpaceXSmall,
                    // Icon chip
                    Container(
                      padding: responsive.paddingSymmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusSmall,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('azan'),
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

  void _showDetails(Map<String, dynamic> item) {
    final details = item['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: item['title'] ?? '',
          titleUrdu: item['titleUrdu'] ?? '',
          titleHindi: item['titleHindi'] ?? '',
          titleArabic: item['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: item['color'] as Color,
          icon: item['icon'] as IconData,
          categoryKey: 'category_azan',
        ),
      ),
    );
  }
}
