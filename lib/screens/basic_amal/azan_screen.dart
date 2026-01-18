import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class AzanScreen extends StatefulWidget {
  const AzanScreen({super.key});

  @override
  State<AzanScreen> createState() => _AzanScreenState();
}

class _AzanScreenState extends State<AzanScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Azan - Complete Guide',
    'urdu': 'اذان کا طریقہ - مکمل رہنمائی',
    'hindi': 'अज़ान का तरीक़ा - संपूर्ण मार्गदर्शन',
  };

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Complete Azan Text',
      'titleUrdu': 'مکمل اذان',
      'titleHindi': 'मुकम्मल अज़ान',
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
      },
    },
    {
      'title': 'How to Give Azan',
      'titleUrdu': 'اذان دینے کا طریقہ',
      'titleHindi': 'अज़ान देने का तरीक़ा',
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
      },
    },
    {
      'title': 'Iqamah (Second Call)',
      'titleUrdu': 'اقامت',
      'titleHindi': 'इक़ामत',
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
      },
    },
    {
      'title': 'Response to Azan',
      'titleUrdu': 'اذان کا جواب',
      'titleHindi': 'अज़ान का जवाब',
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
      },
    },
    {
      'title': 'Virtues of Azan',
      'titleUrdu': 'اذان کی فضیلت',
      'titleHindi': 'अज़ान की फ़ज़ीलत',
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
          _titles[_selectedLanguage]!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      _selectedLanguage == 'english'
                          ? 'EN'
                          : _selectedLanguage == 'urdu'
                          ? 'UR'
                          : 'HI',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onSelected: (value) => setState(() => _selectedLanguage = value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'english',
                  child: Row(
                    children: [
                      Icon(
                        _selectedLanguage == 'english'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _selectedLanguage == 'english'
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('English'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'urdu',
                  child: Row(
                    children: [
                      Icon(
                        _selectedLanguage == 'urdu'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _selectedLanguage == 'urdu'
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('اردو'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'hindi',
                  child: Row(
                    children: [
                      Icon(
                        _selectedLanguage == 'hindi'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _selectedLanguage == 'hindi'
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('हिंदी'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sections.length,
              itemBuilder: (context, index) => _buildCard(
                _sections[index],
                isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    Map<String, dynamic> item,
    bool isDark,
  ) {
    final title = _selectedLanguage == 'english'
        ? item['title']
        : _selectedLanguage == 'urdu'
        ? item['titleUrdu']
        : item['titleHindi'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetails(item),
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
                    item['icon'] as IconData,
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
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E8F5A),
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

  void _showDetails(Map<String, dynamic> item) {
    final details = item['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: item['title'],
          titleUrdu: item['titleUrdu'] ?? '',
          titleHindi: item['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: item['color'] as Color,
          icon: item['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Azan',
        ),
      ),
    );
  }
}
