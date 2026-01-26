import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class AzanScreen extends StatefulWidget {
  const AzanScreen({super.key});

  @override
  State<AzanScreen> createState() => _AzanScreenState();
}

class _AzanScreenState extends State<AzanScreen> {
  String _selectedLanguage = 'english';

  final List<Map<String, dynamic>> _sections = [
    {
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
      body: SingleChildScrollView(
        padding: context.responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
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
                      textDirection: langCode == 'ur'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
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
                          SizedBox(width: responsive.spacing(4)),
                          Text(
                            context.tr('azan'),
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
