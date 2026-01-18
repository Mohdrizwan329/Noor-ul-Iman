import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NamazGuideScreen extends StatefulWidget {
  const NamazGuideScreen({super.key});

  @override
  State<NamazGuideScreen> createState() => _NamazGuideScreenState();
}

class _NamazGuideScreenState extends State<NamazGuideScreen> {
  String _selectedLanguage = 'english';

  final List<Map<String, dynamic>> _namazCategories = [
    {
      'title': 'Fajr Prayer',
      'titleUrdu': 'نماز فجر',
      'titleHindi': 'फज्र की नमाज़',
      'rakats': '2 Sunnah + 2 Fard = 4 Rakats',
      'rakatsUrdu': '۲ سنت + ۲ فرض = ۴ رکعت',
      'rakatsHindi': '2 सुन्नत + 2 फ़र्ज़ = 4 रकात',
      'time': 'Dawn to Sunrise',
      'timeUrdu': 'صبح صادق سے طلوع آفتاب تک',
      'timeHindi': 'सुबह-ए-सादिक़ से तुलू-ए-आफ़ताब तक',
      'icon': Icons.wb_twilight,
      'color': Colors.orange,
      'details': {
        'english': '''
**Fajr Prayer (فجر)**

**Time:** From dawn (when light first appears on horizon) until just before sunrise.

**Rakats:**
• 2 Sunnah Muakkadah (emphasized)
• 2 Fard (obligatory)
• Total: 4 Rakats

**How to Pray:**

**2 Sunnah Rakats:**
1. Make intention (Niyyah) for 2 Sunnah of Fajr
2. Raise hands to ears saying "Allahu Akbar"
3. Recite Thana, Ta'awwuz, Tasmiyah
4. Recite Surah Al-Fatiha
5. Recite any Surah (e.g., Surah Al-Ikhlas)
6. Go to Ruku saying "Allahu Akbar"
7. Say "Subhana Rabbiyal Azeem" (3 times)
8. Rise saying "Sami Allahu Liman Hamidah"
9. Say "Rabbana Lakal Hamd"
10. Go to Sajdah saying "Allahu Akbar"
11. Say "Subhana Rabbiyal A'la" (3 times)
12. Sit up saying "Allahu Akbar"
13. Do second Sajdah same way
14. Stand for 2nd Rakat
15. Repeat steps 4-13
16. Sit for Tashahhud (Attahiyyat)
17. Recite Durood Ibrahim
18. Recite Dua
19. Turn right then left saying "Assalamu Alaikum Wa Rahmatullah"

**2 Fard Rakats:**
Same procedure as above with intention for Fard of Fajr.

**Virtues:**
• The two Sunnah of Fajr are better than the world and all it contains (Sahih Muslim)
• Angels of night and day witness Fajr prayer
• Protection from hellfire for those who pray Fajr and Asr''',
        'urdu': '''
**نماز فجر**

**وقت:** صبح صادق (جب افق پر پہلی روشنی ظاہر ہو) سے طلوع آفتاب سے پہلے تک۔

**رکعات:**
• ۲ سنت مؤکدہ
• ۲ فرض
• کل: ۴ رکعت

**نماز پڑھنے کا طریقہ:**

**۲ سنت رکعات:**
۱. فجر کی ۲ سنت کی نیت کریں
۲. کانوں تک ہاتھ اٹھائیں "اللہ اکبر" کہتے ہوئے
۳. ثناء، تعوذ، تسمیہ پڑھیں
۴. سورۃ الفاتحہ پڑھیں
۵. کوئی سورت پڑھیں (مثلاً سورۃ الاخلاص)
۶. "اللہ اکبر" کہتے ہوئے رکوع میں جائیں
۷. "سبحان ربی العظیم" (۳ مرتبہ) کہیں
۸. "سمع اللہ لمن حمدہ" کہتے ہوئے کھڑے ہوں
۹. "ربنا لک الحمد" کہیں
۱۰. "اللہ اکبر" کہتے ہوئے سجدے میں جائیں
۱۱. "سبحان ربی الاعلیٰ" (۳ مرتبہ) کہیں
۱۲. "اللہ اکبر" کہتے ہوئے بیٹھیں
۱۳. دوسرا سجدہ اسی طرح کریں
۱۴. دوسری رکعت کے لیے کھڑے ہوں
۱۵. مرحلہ ۴-۱۳ دہرائیں
۱۶. تشہد (التحیات) کے لیے بیٹھیں
۱۷. درود ابراہیمی پڑھیں
۱۸. دعا پڑھیں
۱۹. دائیں پھر بائیں سلام پھیریں "السلام علیکم ورحمۃ اللہ"

**۲ فرض رکعات:**
وہی طریقہ فجر کے فرض کی نیت کے ساتھ۔

**فضیلت:**
• فجر کی دو سنتیں دنیا اور اس کی ہر چیز سے بہتر ہیں (صحیح مسلم)
• رات اور دن کے فرشتے فجر کی نماز میں حاضر ہوتے ہیں
• جو فجر اور عصر پڑھے اس کے لیے جہنم سے حفاظت ہے''',
        'hindi': '''
**फज्र की नमाज़**

**वक़्त:** सुबह-ए-सादिक़ (जब उफ़ुक़ पर पहली रोशनी ज़ाहिर हो) से तुलू-ए-आफ़ताब से पहले तक।

**रकात:**
• 2 सुन्नत मुअक्कदा
• 2 फ़र्ज़
• कुल: 4 रकात

**नमाज़ पढ़ने का तरीक़ा:**

**2 सुन्नत रकात:**
1. फज्र की 2 सुन्नत की नीयत करें
2. कानों तक हाथ उठाएं "अल्लाहु अकबर" कहते हुए
3. सना, तअव्वुज़, तस्मिया पढ़ें
4. सूरह अल-फ़ातिहा पढ़ें
5. कोई सूरत पढ़ें (मसलन सूरह अल-इख़लास)
6. "अल्लाहु अकबर" कहते हुए रुकू में जाएं
7. "सुब्हान रब्बियल अज़ीम" (3 मर्तबा) कहें
8. "समिअल्लाहु लिमन हमिदा" कहते हुए खड़े हों
9. "रब्बना लकल हम्द" कहें
10. "अल्लाहु अकबर" कहते हुए सजदे में जाएं
11. "सुब्हान रब्बियल आला" (3 मर्तबा) कहें
12. "अल्लाहु अकबर" कहते हुए बैठें
13. दूसरा सजदा इसी तरह करें
14. दूसरी रकात के लिए खड़े हों
15. स्टेप 4-13 दोहराएं
16. तशह्हुद (अत्तहीयात) के लिए बैठें
17. दुरूद इब्राहीमी पढ़ें
18. दुआ पढ़ें
19. दाएं फिर बाएं सलाम फेरें "अस्सलामु अलैकुम व रहमतुल्लाह"

**2 फ़र्ज़ रकात:**
वही तरीक़ा फज्र के फ़र्ज़ की नीयत के साथ।

**फ़ज़ीलत:**
• फज्र की दो सुन्नतें दुनिया और उसकी हर चीज़ से बेहतर हैं (सहीह मुस्लिम)
• रात और दिन के फ़रिश्ते फज्र की नमाज़ में हाज़िर होते हैं
• जो फज्र और अस्र पढ़े उसके लिए जहन्नम से हिफ़ाज़त है'''
      }
    },
    {
      'title': 'Zuhr Prayer',
      'titleUrdu': 'نماز ظہر',
      'titleHindi': 'ज़ुहर की नमाज़',
      'rakats': '4 Sunnah + 4 Fard + 2 Sunnah + 2 Nafl = 12 Rakats',
      'rakatsUrdu': '۴ سنت + ۴ فرض + ۲ سنت + ۲ نفل = ۱۲ رکعت',
      'rakatsHindi': '4 सुन्नत + 4 फ़र्ज़ + 2 सुन्नत + 2 नफ़्ल = 12 रकात',
      'time': 'After midday until Asr',
      'timeUrdu': 'زوال کے بعد سے عصر تک',
      'timeHindi': 'ज़वाल के बाद से अस्र तक',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
      'details': {
        'english': '''
**Zuhr Prayer (ظہر)**

**Time:** From when sun passes its zenith (midday) until the shadow of an object equals its height plus the shadow at noon.

**Rakats:**
• 4 Sunnah Muakkadah (before Fard)
• 4 Fard (obligatory)
• 2 Sunnah Muakkadah (after Fard)
• 2 Nafl (optional)
• Total: 12 Rakats

**How to Pray 4 Rakats:**

1. Make intention for the prayer
2. First 2 rakats same as Fajr
3. After 2nd Sajdah of 2nd Rakat, sit for Tashahhud
4. Recite only Attahiyyat, then stand
5. In 3rd & 4th Rakat, recite only Surah Fatiha
6. After 4th Rakat Sajdah, sit for final Tashahhud
7. Recite Attahiyyat, Durood, and Dua
8. Give Salam to both sides

**Special Note for Fard:**
• In 3rd and 4th Rakat of Fard, only Surah Fatiha is recited
• No additional Surah after Fatiha in these rakats

**Virtues:**
• The Prophet ﷺ never left the 4 Sunnah before Zuhr
• Whoever prays 12 rakats in a day (including Zuhr Sunnah), Allah builds a house for them in Paradise''',
        'urdu': '''
**نماز ظہر**

**وقت:** جب سورج ڈھلے (زوال) سے عصر کے وقت تک۔

**رکعات:**
• ۴ سنت مؤکدہ (فرض سے پہلے)
• ۴ فرض
• ۲ سنت مؤکدہ (فرض کے بعد)
• ۲ نفل (اختیاری)
• کل: ۱۲ رکعت

**۴ رکعت پڑھنے کا طریقہ:**

۱. نماز کی نیت کریں
۲. پہلی ۲ رکعت فجر کی طرح
۳. دوسری رکعت کے دوسرے سجدے کے بعد تشہد کے لیے بیٹھیں
۴. صرف التحیات پڑھیں، پھر کھڑے ہوں
۵. تیسری اور چوتھی رکعت میں صرف سورۃ فاتحہ پڑھیں
۶. چوتھی رکعت کے سجدے کے بعد آخری تشہد کے لیے بیٹھیں
۷. التحیات، درود اور دعا پڑھیں
۸. دونوں طرف سلام پھیریں

**فرض کے لیے خاص نوٹ:**
• فرض کی تیسری اور چوتھی رکعت میں صرف سورۃ فاتحہ پڑھی جاتی ہے
• ان رکعتوں میں فاتحہ کے بعد کوئی سورت نہیں

**فضیلت:**
• نبی ﷺ نے کبھی ظہر سے پہلے کی ۴ سنتیں نہیں چھوڑیں
• جو دن میں ۱۲ رکعت پڑھے (ظہر کی سنتیں شامل) اللہ اس کے لیے جنت میں گھر بناتا ہے''',
        'hindi': '''
**ज़ुहर की नमाज़**

**वक़्त:** जब सूरज ढले (ज़वाल) से अस्र के वक़्त तक।

**रकात:**
• 4 सुन्नत मुअक्कदा (फ़र्ज़ से पहले)
• 4 फ़र्ज़
• 2 सुन्नत मुअक्कदा (फ़र्ज़ के बाद)
• 2 नफ़्ल (इख़्तियारी)
• कुल: 12 रकात

**4 रकात पढ़ने का तरीक़ा:**

1. नमाज़ की नीयत करें
2. पहली 2 रकात फज्र की तरह
3. दूसरी रकात के दूसरे सजदे के बाद तशह्हुद के लिए बैठें
4. सिर्फ़ अत्तहीयात पढ़ें, फिर खड़े हों
5. तीसरी और चौथी रकात में सिर्फ़ सूरह फ़ातिहा पढ़ें
6. चौथी रकात के सजदे के बाद आख़िरी तशह्हुद के लिए बैठें
7. अत्तहीयात, दुरूद और दुआ पढ़ें
8. दोनों तरफ़ सलाम फेरें

**फ़र्ज़ के लिए ख़ास नोट:**
• फ़र्ज़ की तीसरी और चौथी रकात में सिर्फ़ सूरह फ़ातिहा पढ़ी जाती है
• इन रकातों में फ़ातिहा के बाद कोई सूरत नहीं

**फ़ज़ीलत:**
• नबी ﷺ ने कभी ज़ुहर से पहले की 4 सुन्नतें नहीं छोड़ीं
• जो दिन में 12 रकात पढ़े (ज़ुहर की सुन्नतें शामिल) अल्लाह उसके लिए जन्नत में घर बनाता है'''
      }
    },
    {
      'title': 'Asr Prayer',
      'titleUrdu': 'نماز عصر',
      'titleHindi': 'अस्र की नमाज़',
      'rakats': '4 Sunnah Ghair Muakkadah + 4 Fard = 8 Rakats',
      'rakatsUrdu': '۴ سنت غیر مؤکدہ + ۴ فرض = ۸ رکعت',
      'rakatsHindi': '4 सुन्नत ग़ैर मुअक्कदा + 4 फ़र्ज़ = 8 रकात',
      'time': 'Afternoon until Sunset',
      'timeUrdu': 'دوپہر بعد سے غروب آفتاب تک',
      'timeHindi': 'दोपहर बाद से ग़ुरूब-ए-आफ़ताब तक',
      'icon': Icons.wb_cloudy,
      'color': Colors.deepOrange,
      'details': {
        'english': '''
**Asr Prayer (عصر)**

**Time:** From when shadow of an object equals its height (plus noon shadow) until sunset.

**Rakats:**
• 4 Sunnah Ghair Muakkadah (optional, before Fard)
• 4 Fard (obligatory)
• Total: 8 Rakats (minimum 4 Fard)

**How to Pray:**
Same method as Zuhr 4 Rakat prayer.

**Important Points:**
• It is Makruh (disliked) to pray when sun turns yellow (15-20 min before sunset)
• But if Asr was missed, it should still be prayed even then
• Missing Asr intentionally is severely warned against

**Virtues:**
• The Prophet ﷺ said: "Whoever prays Fajr and Asr will enter Paradise" (Sahih Bukhari)
• "Whoever misses Asr prayer, his deeds become void" (Sahih Bukhari)
• The middle prayer mentioned in Quran refers to Asr according to many scholars''',
        'urdu': '''
**نماز عصر**

**وقت:** جب کسی چیز کا سایہ اس کی لمبائی (زوال کے سائے کے علاوہ) کے برابر ہو جائے غروب آفتاب تک۔

**رکعات:**
• ۴ سنت غیر مؤکدہ (اختیاری، فرض سے پہلے)
• ۴ فرض
• کل: ۸ رکعت (کم از کم ۴ فرض)

**نماز پڑھنے کا طریقہ:**
ظہر کی ۴ رکعت کا وہی طریقہ۔

**اہم باتیں:**
• جب سورج زرد ہو جائے (غروب سے ۱۵-۲۰ منٹ پہلے) نماز پڑھنا مکروہ ہے
• لیکن اگر عصر رہ گئی ہو تو پھر بھی پڑھنی چاہیے
• جان بوجھ کر عصر چھوڑنے پر سخت وعید ہے

**فضیلت:**
• نبی ﷺ نے فرمایا: "جو فجر اور عصر پڑھے گا وہ جنت میں داخل ہوگا" (صحیح بخاری)
• "جس نے عصر کی نماز چھوڑی اس کے اعمال ضائع ہو گئے" (صحیح بخاری)
• قرآن میں درمیانی نماز کا ذکر بہت سے علماء کے مطابق عصر ہے''',
        'hindi': '''
**अस्र की नमाज़**

**वक़्त:** जब किसी चीज़ का साया उसकी लंबाई (ज़वाल के साए के अलावा) के बराबर हो जाए ग़ुरूब-ए-आफ़ताब तक।

**रकात:**
• 4 सुन्नत ग़ैर मुअक्कदा (इख़्तियारी, फ़र्ज़ से पहले)
• 4 फ़र्ज़
• कुल: 8 रकात (कम से कम 4 फ़र्ज़)

**नमाज़ पढ़ने का तरीक़ा:**
ज़ुहर की 4 रकात का वही तरीक़ा।

**अहम बातें:**
• जब सूरज ज़र्द हो जाए (ग़ुरूब से 15-20 मिनट पहले) नमाज़ पढ़ना मकरूह है
• लेकिन अगर अस्र रह गई हो तो फिर भी पढ़नी चाहिए
• जा��-बूझकर अस्र छोड़ने पर सख़्त वईद है

**फ़ज़ीलत:**
• नबी ﷺ ने फ़रमाया: "जो फज्र और अस्र पढ़ेगा वो जन्नत में दाख़िल होगा" (सहीह बुख़ारी)
• "जिसने अस्र की नमाज़ छोड़ी उसके आमाल ज़ाए हो गए" (सहीह बुख़ारी)
• क़ुरान में दरमियानी नमाज़ का ज़िक्र बहुत से उलमा के मुताबिक़ अस्र है'''
      }
    },
    {
      'title': 'Maghrib Prayer',
      'titleUrdu': 'نماز مغرب',
      'titleHindi': 'मग़रिब की नमाज़',
      'rakats': '3 Fard + 2 Sunnah + 2 Nafl = 7 Rakats',
      'rakatsUrdu': '۳ فرض + ۲ سنت + ۲ نفل = ۷ رکعت',
      'rakatsHindi': '3 फ़र्ज़ + 2 सुन्नत + 2 नफ़्ल = 7 रकात',
      'time': 'After Sunset until twilight fades',
      'timeUrdu': 'غروب آفتاب سے شفق غائب ہونے تک',
      'timeHindi': 'ग़ुरूब-ए-आफ़ताब से शफ़क़ ग़ायब होने तक',
      'icon': Icons.nights_stay,
      'color': Colors.deepPurple,
      'details': {
        'english': '''
**Maghrib Prayer (مغرب)**

**Time:** From sunset until the red twilight disappears (approximately 1-1.5 hours after sunset).

**Rakats:**
• 3 Fard (obligatory)
• 2 Sunnah Muakkadah
• 2 Nafl (optional)
• Total: 7 Rakats

**How to Pray 3 Fard Rakats:**

1. Make intention for 3 Fard of Maghrib
2. First 2 rakats same as Fajr with loud recitation
3. After 2nd Sajdah, sit for Tashahhud
4. Recite only Attahiyyat, then stand
5. In 3rd Rakat, recite only Surah Fatiha (silently)
6. Complete Ruku and Sujood
7. Sit for final Tashahhud
8. Recite Attahiyyat, Durood, Dua
9. Give Salam

**Special Notes:**
• Imam recites loudly in first 2 rakats
• 3rd Rakat is recited silently
• Should not delay Maghrib unnecessarily

**Virtues:**
• First prayer after the day's fast ends
• Prophet ﷺ advised hastening to pray Maghrib
• Reward of praying at the mosque is 27 times more''',
        'urdu': '''
**نماز مغرب**

**وقت:** غروب آفتاب سے سرخی غائب ہونے تک (تقریباً غروب کے ۱-۱.۵ گھنٹے بعد)۔

**رکعات:**
• ۳ فرض
• ۲ سنت مؤکدہ
• ۲ نفل (اختیاری)
• کل: ۷ رکعت

**۳ فرض رکعت پڑھنے کا طریقہ:**

۱. مغرب کے ۳ فرض کی نیت کریں
۲. پہلی ۲ رکعت فجر کی طرح بلند آواز سے قراءت
۳. دوسرے سجدے کے بعد تشہد کے لیے بیٹھیں
۴. صرف التحیات پڑھیں، پھر کھڑے ہوں
۵. تیسری رکعت میں صرف سورۃ فاتحہ پڑھیں (آہستہ)
۶. رکوع اور سجود مکمل کریں
۷. آخری تشہد کے لیے بیٹھیں
۸. التحیات، درود، دعا پڑھیں
۹. سلام پھیریں

**خاص باتیں:**
• امام پہلی ۲ رکعت میں بلند آواز سے پڑھتا ہے
• تیسری رکعت آہستہ پڑھی جاتی ہے
• مغرب میں بلاوجہ تاخیر نہیں کرنی چاہیے

**فضیلت:**
• دن کے روزے کے بعد پہلی نماز
• نبی ﷺ نے مغرب جلدی پڑھنے کی تلقین کی
• مسجد میں نماز کا ثواب ۲۷ گنا زیادہ ہے''',
        'hindi': '''
**मग़रिब की नमाज़**

**वक़्त:** ग़ुरूब-ए-आफ़ताब से सुर्ख़ी ग़ायब होने तक (तक़रीबन ग़ुरूब के 1-1.5 घंटे बाद)।

**रकात:**
• 3 फ़र्ज़
• 2 सुन्नत मुअक्कदा
• 2 नफ़्ल (इख़्तियारी)
• कुल: 7 रकात

**3 फ़र्ज़ रकात पढ़ने का तरीक़ा:**

1. मग़रिब के 3 फ़र्ज़ की नीयत करें
2. पहली 2 रकात फज्र की तरह बुलंद आवाज़ से क़िराअत
3. दूसरे सजदे के बाद तशह्हुद के लिए बैठें
4. सिर्फ़ अत्तहीयात पढ़ें, फिर खड़े हों
5. तीसरी रकात में सिर्फ़ सूरह फ़ातिहा पढ़ें (आहिस्ता)
6. रुकू और सुजूद मुकम्मल करें
7. आख़िरी तशह्हुद के लिए बैठें
8. अत्तहीयात, दुरूद, दुआ पढ़ें
9. सलाम फेरें

**ख़ास बातें:**
• इमाम पहली 2 रकात में बुलंद आवाज़ से पढ़ता है
• तीसरी रकात आहिस्ता पढ़ी जाती है
• मग़रिब में बिलावजह ताख़ीर नहीं करनी चाहिए

**फ़ज़ीलत:**
• दिन के रोज़े के बाद पहली नमाज़
• नबी ﷺ ने मग़रिब जल्दी पढ़ने की तल्क़ीन की
• मस्जिद में नमाज़ का सवाब 27 गुना ज़्यादा है'''
      }
    },
    {
      'title': 'Isha Prayer',
      'titleUrdu': 'نماز عشاء',
      'titleHindi': 'इशा की नमाज़',
      'rakats': '4 Sunnah + 4 Fard + 2 Sunnah + 2 Nafl + 3 Witr + 2 Nafl = 17 Rakats',
      'rakatsUrdu': '۴ سنت + ۴ فرض + ۲ سنت + ۲ نفل + ۳ وتر + ۲ نفل = ۱۷ رکعت',
      'rakatsHindi': '4 सुन्नत + 4 फ़र्ज़ + 2 सुन्नत + 2 नफ़्ल + 3 वित्र + 2 नफ़्ल = 17 रकात',
      'time': 'After twilight until midnight',
      'timeUrdu': 'شفق غائب ہونے سے آدھی رات تک',
      'timeHindi': 'शफ़क़ ग़ायब होने से आधी रात तक',
      'icon': Icons.dark_mode,
      'color': Colors.indigo,
      'details': {
        'english': '''
**Isha Prayer (عشاء)**

**Time:** From when twilight disappears until midnight (can be prayed until Fajr in necessity).

**Rakats:**
• 4 Sunnah Ghair Muakkadah (before Fard)
• 4 Fard (obligatory)
• 2 Sunnah Muakkadah (after Fard)
• 2 Nafl (optional)
• 3 Witr (Wajib)
• 2 Nafl (optional)
• Total: 17 Rakats

**How to Pray Witr (3 Rakats):**

1. Make intention for 3 Witr
2. Pray 2 rakats like Fajr
3. Stand for 3rd Rakat
4. Recite Fatiha and a Surah
5. Before Ruku, raise hands and recite Dua Qunoot
6. Then complete the prayer normally

**Dua Qunoot:**
"Allahumma inna nasta'eenuka wa nastaghfiruka wa nu'minu bika wa natawakkalu 'alayka wa nuthni 'alaykal khayra wa nashkuruka wa la nakfuruka wa nakhla'u wa natruku man yafjuruka. Allahumma iyyaka na'budu wa laka nusalli wa nasjudu wa ilayka nas'a wa nahfidu wa narju rahmataka wa nakhsha 'adhabaka inna 'adhabaka bil kuffari mulhiq."

**Virtues:**
• Isha in congregation equals half the night in prayer
• Witr is highly emphasized by Prophet ﷺ
• Best time for Witr is last third of night''',
        'urdu': '''
**نماز عشاء**

**وقت:** شفق غائب ہونے سے آدھی رات تک (ضرورت میں فجر تک پڑھ سکتے ہیں)۔

**رکعات:**
• ۴ سنت غیر مؤکدہ (فرض سے پہلے)
• ۴ فرض
• ۲ سنت مؤکدہ (فرض کے بعد)
• ۲ نفل (اختیاری)
• ۳ وتر (واجب)
• ۲ نفل (اختیاری)
• کل: ۱۷ رکعت

**وتر (۳ رکعت) پڑھنے کا طریقہ:**

۱. ۳ وتر کی نیت کریں
۲. ۲ رکعت فجر کی طرح پڑھیں
۳. تیسری رکعت کے لیے کھڑے ہوں
۴. فاتحہ اور سورت پڑھیں
۵. رکوع سے پہلے ہاتھ اٹھائیں اور دعائے قنوت پڑھیں
۶. پھر نماز عام طریقے سے مکمل کریں

**دعائے قنوت:**
"اللهم إنا نستعينك ونستغفرك ونؤمن بك ونتوكل عليك ونثني عليك الخير ونشكرك ولا نكفرك ونخلع ونترك من يفجرك اللهم إياك نعبد ولك نصلي ونسجد وإليك نسعى ونحفد ونرجو رحمتك ونخشى عذابك إن عذابك بالكفار ملحق"

**فضیلت:**
• جماعت سے عشاء آدھی رات کی عبادت کے برابر ہے
• نبی ﷺ نے وتر پر بہت زور دیا
• وتر کا بہترین وقت رات کا آخری تہائی حصہ ہے''',
        'hindi': '''
**इशा की नमाज़**

**वक़्त:** शफ़क़ ग़ायब होने से आधी रात तक (ज़रूरत में फज्र तक पढ़ सकते हैं)।

**रकात:**
• 4 सुन्नत ग़ैर मुअक्कदा (फ़र्ज़ से पहले)
• 4 फ़र्ज़
• 2 सुन्नत मुअक्कदा (फ़र्ज़ के बाद)
• 2 नफ़्ल (इख़्तियारी)
• 3 वित्र (वाजिब)
• 2 नफ़्ल (इख़्तियारी)
• कुल: 17 रकात

**वित्र (3 रकात) पढ़ने का तरीक़ा:**

1. 3 वित्र की नीयत करें
2. 2 रकात फज्र की तरह पढ़ें
3. तीसरी रकात के लिए खड़े हों
4. फ़ातिहा और सूरत पढ़ें
5. रुकू से पहले हाथ उठाएं और दुआ-ए-क़ुनूत पढ़ें
6. फिर नमाज़ आम तरीक़े से मुकम्मल करें

**दुआ-ए-क़ुनूत:**
"अल्लाहुम्मा इन्ना नस्तईनुका व नस्तग़फ़िरुका व नोमिनु बिका व नतवक्कलु अलैका व नुस्नी अलैकल ख़ैर व नश्कुरुका व ला नकफ़ुरुका व नख़्लउ व नत्रुकु मय्यफ़्जुरुका अल्लाहुम्मा इय्याका नाबुदु व लका नुसल्ली व नसजुदु व इलैका नस्आ व नहफ़िदु व नरजू रहमतका व नख़्शा अज़ाबका इन्ना अज़ाबका बिल कुफ़्फ़ारि मुल्हिक़"

**फ़ज़ीलत:**
• जमाअत से इशा आधी रात की इबादत के बराबर है
• नबी ﷺ ने वित्र पर बहुत ज़ोर दिया
• वित्र का बेहतरीन वक़्त रात का आख़िरी तिहाई हिस्सा है'''
      }
    },
    {
      'title': 'Jumu\'ah Prayer',
      'titleUrdu': 'نماز جمعہ',
      'titleHindi': 'जुमा की नमाज़',
      'rakats': '4 Sunnah + 2 Fard + 4 Sunnah + 2 Sunnah + 2 Nafl = 14 Rakats',
      'rakatsUrdu': '۴ سنت + ۲ فرض + ۴ سنت + ۲ سنت + ۲ نفل = ۱۴ رکعت',
      'rakatsHindi': '4 सुन्नत + 2 फ़र्ज़ + 4 सुन्नत + 2 सुन्नत + 2 नफ़्ल = 14 रकात',
      'time': 'Friday at Zuhr time',
      'timeUrdu': 'جمعہ کو ظہر کے وقت',
      'timeHindi': 'जुमा को ज़ुहर के वक़्त',
      'icon': Icons.mosque,
      'color': AppColors.primary,
      'details': {
        'english': '''
**Jumu'ah (Friday) Prayer (جمعہ)**

**Time:** Same as Zuhr time on Fridays. Replaces Zuhr.

**Rakats:**
• 4 Sunnah (before Khutbah)
• Khutbah (sermon) - 2 parts
• 2 Fard (led by Imam)
• 4 Sunnah (after Fard)
• 2 Sunnah
• 2 Nafl
• Total: 14 Rakats

**Order of Jumu'ah:**
1. Pray 4 Sunnah when you arrive
2. Listen to the Khutbah silently
3. Pray 2 Fard behind Imam
4. Pray 4 Sunnah after
5. Then 2 Sunnah and 2 Nafl

**Rules:**
• Obligatory for adult Muslim men
• Must be prayed in congregation
• Cannot be prayed alone
• Excused: travelers, sick, women (optional for them)
• Ghusl on Friday is highly recommended

**Virtues:**
• Best day of the week
• Special hour for dua acceptance
• Angels record who comes early
• Friday is the master of days
• Prophet ﷺ said: "Whoever misses 3 Jumu'ah continuously, Allah seals his heart"''',
        'urdu': '''
**نماز جمعہ**

**وقت:** جمعہ کو ظہر کے وقت۔ ظہر کی جگہ لیتی ہے۔

**رکعات:**
• ۴ سنت (خطبے سے پہلے)
• خطبہ - ۲ حصے
• ۲ فرض (امام کے پیچھے)
• ۴ سنت (فرض کے بعد)
• ۲ سنت
• ۲ نفل
• کل: ۱۴ رکعت

**جمعہ کی ترتیب:**
۱. پہنچ کر ۴ سنت پڑھیں
۲. خطبہ خاموشی سے سنیں
۳. امام کے پیچھے ۲ فرض پڑھیں
۴. بعد میں ۴ سنت پڑھیں
۵. پھر ۲ سنت اور ۲ نفل

**احکام:**
• بالغ مسلمان مردوں پر فرض ہے
• جماعت سے پڑھنی ضروری ہے
• اکیلے نہیں پڑھ سکتے
• معذور: مسافر، بیمار، خواتین (ان کے لیے اختیاری)
• جمعہ کا غسل بہت مستحب ہے

**فضیلت:**
• ہفتے کا بہترین دن
• دعا قبول ہونے کی خاص گھڑی
• فرشتے جلدی آنے والوں کو لکھتے ہیں
• جمعہ دنوں کا سردار ہے
• نبی ﷺ نے فرمایا: "جو لگاتار ۳ جمعے چھوڑے اللہ اس کے دل پر مہر لگا دیتا ہے"''',
        'hindi': '''
**जुमा की नमाज़**

**वक़्त:** जुमा को ज़ुहर के वक़्त। ज़ुहर की जगह लेती है।

**रकात:**
• 4 सुन्नत (ख़ुत्बे से पहले)
• ख़ुत्बा - 2 हिस्से
• 2 फ़र्ज़ (इमाम के पीछे)
• 4 सुन्नत (फ़र्ज़ के बाद)
• 2 सुन्नत
• 2 नफ़्ल
• कुल: 14 रकात

**जुमा की तरतीब:**
1. पहुंचकर 4 सुन्नत पढ़ें
2. ख़ुत्बा ख़ामोशी से सुनें
3. इमाम के पीछे 2 फ़र्ज़ पढ़ें
4. बाद में 4 सुन्नत पढ़ें
5. फिर 2 सुन्नत और 2 नफ़्ल

**अहकाम:**
• बालिग़ मुस्लिम मर्दों पर फ़र्ज़ है
• जमाअत से पढ़नी ज़रूरी है
• अकेले नहीं पढ़ सकते
• माज़ूर: मुसाफ़िर, बीमार, ख़वातीन (उनके लिए इख़्तियारी)
• जुमा का ग़ुस्ल बहुत मुस्तहब है

**फ़ज़ीलत:**
• हफ़्ते का बेहतरीन दिन
• दुआ क़बूल होने की ख़ास घड़ी
• फ़रिश्ते जल्दी आने वालों को लिखते हैं
• जुमा दिनों का सरदार है
• नबी ﷺ ने फ़रमाया: "जो लगातार 3 जुमे छोड़े अल्लाह उसके दिल पर मोहर लगा देता है"'''
      }
    },
    {
      'title': 'Eid Prayer',
      'titleUrdu': 'نماز عید',
      'titleHindi': 'ईद की नमाज़',
      'rakats': '2 Rakats with 6 extra Takbeers',
      'rakatsUrdu': '۲ رکعت ۶ زائد تکبیرات کے ساتھ',
      'rakatsHindi': '2 रकात 6 ज़ायद तकबीरात के साथ',
      'time': 'After sunrise on Eid days',
      'timeUrdu': 'عید کے دن طلوع آفتاب کے بعد',
      'timeHindi': 'ईद के दिन तुलू-ए-आफ़ताब के बाद',
      'icon': Icons.celebration,
      'color': Colors.green,
      'details': {
        'english': '''
**Eid Prayer (عید)**

**Time:** After sunrise (about 15-20 minutes after) until before Zawaal (midday).

**Eid ul-Fitr:** 1st of Shawwal (after Ramadan)
**Eid ul-Adha:** 10th of Dhul Hijjah

**Rakats:** 2 Rakats with extra Takbeers

**How to Pray (Hanafi Method):**

**First Rakat:**
1. Make intention and say Takbeer Tahreema
2. Recite Thana
3. Say 3 extra Takbeers, raising hands each time
4. After 3rd Takbeer, fold hands
5. Imam recites Fatiha and Surah
6. Complete Ruku and Sujood normally

**Second Rakat:**
1. Imam recites Fatiha and Surah
2. Say 3 extra Takbeers (raising hands)
3. Say 4th Takbeer and go to Ruku
4. Complete prayer normally
5. After Salam, listen to Khutbah

**Important Points:**
• Sunnah Muakkadah according to some, Wajib according to others
• No Adhan or Iqamah
• Khutbah is after the prayer (opposite of Jumu'ah)
• Listening to Khutbah is Wajib
• Takbeer of Eid: "Allahu Akbar Allahu Akbar La ilaha illallah, Allahu Akbar Allahu Akbar wa lillahil hamd"

**Eid ul-Fitr Specific:**
• Eat something sweet before going
• Pay Sadaqat ul-Fitr before prayer

**Eid ul-Adha Specific:**
• Don't eat before prayer
• Offer Qurbani after prayer
• Takbeerat e Tashreeq from Fajr of 9th to Asr of 13th Dhul Hijjah''',
        'urdu': '''
**نماز عید**

**وقت:** طلوع آفتاب کے بعد (تقریباً ۱۵-۲۰ منٹ بعد) سے زوال سے پہلے تک۔

**عید الفطر:** ۱ شوال (رمضان کے بعد)
**عید الاضحیٰ:** ۱۰ ذی الحجہ

**رکعات:** ۲ رکعت زائد تکبیرات کے ساتھ

**نماز پڑھنے کا طریقہ (حنفی):**

**پہلی رکعت:**
۱. نیت کریں اور تکبیر تحریمہ کہیں
۲. ثناء پڑھیں
۳. ۳ زائد تکبیریں کہیں، ہر بار ہاتھ اٹھائیں
۴. تیسری تکبیر کے بعد ہاتھ باندھیں
۵. امام فاتحہ اور سورت پڑھے
۶. رکوع اور سجود عام طریقے سے کریں

**دوسری رکعت:**
۱. امام فاتحہ اور سورت پڑھے
۲. ۳ زائد تکبیریں کہیں (ہاتھ اٹھائیں)
۳. چوتھی تکبیر کہیں اور رکوع میں جائیں
۴. نماز عام طریقے سے مکمل کریں
۵. سلام کے بعد خطبہ سنیں

**اہم باتیں:**
• کچھ کے نزدیک سنت مؤکدہ، کچھ کے نزدیک واجب
• نہ اذان نہ اقامت
• خطبہ نماز کے بعد ہے (جمعہ کے برعکس)
• خطبہ سننا واجب ہے
• عید کی تکبیر: "اللہ اکبر اللہ اکبر لا الہ الا اللہ واللہ اکبر اللہ اکبر وللہ الحمد"

**عید الفطر کے لیے:**
• جانے سے پہلے کچھ میٹھا کھائیں
• نماز سے پہلے صدقۃ الفطر دیں

**عید الاضحیٰ کے لیے:**
• نماز سے پہلے نہ کھائیں
• نماز کے بعد قربانی کریں
• ۹ ذی الحجہ کی فجر سے ۱۳ کی عصر تک تکبیرات تشریق''',
        'hindi': '''
**ईद की नमाज़**

**वक़्त:** तुलू-ए-आफ़ताब के बाद (तक़रीबन 15-20 मिनट बाद) से ज़वाल से पहले तक।

**ईदुल फ़ित्र:** 1 शव्वाल (रमज़ान के बाद)
**ईदुल अज़हा:** 10 ज़ुल हिज्जा

**रकात:** 2 रकात ज़ायद तकबीरात के साथ

**नमाज़ पढ़ने का तरीक़ा (हनफ़ी):**

**पहली रकात:**
1. नीयत करें और तकबीर तहरीमा कहें
2. सना पढ़ें
3. 3 ज़ायद तकबीरें कहें, हर बार हाथ उठाएं
4. तीसरी तकबीर के बाद हाथ बांधें
5. इमाम फ़ातिहा और सूरत पढ़े
6. रुकू और सुजूद आम तरीक़े से करें

**दूसरी रकात:**
1. इमाम फ़ातिहा और सूरत पढ़े
2. 3 ज़ायद तकबीरें कहें (हाथ उठाएं)
3. चौथी तकबीर कहें और रुकू में जाएं
4. नमाज़ आम तरीक़े से मुकम्मल करें
5. सलाम के बाद ख़ुत्बा सुनें

**अहम बातें:**
• कुछ के नज़दीक सुन्नत मुअक्कदा, कुछ के नज़दीक वाजिब
• न अज़ान न इक़ामत
• ख़ुत्बा नमाज़ के बाद है (जुमा के बरअक्स)
• ख़ुत्बा सुनना वाजिब है
• ईद की तकबीर: "अल्लाहु अकबर अल्लाहु अकबर ला इलाहा इल्लल्लाह वल्लाहु अकबर अल्लाहु अकबर व लिल्लाहिल हम्द"

**ईदुल फ़ित्र के लिए:**
• जाने से पहले कुछ मीठा खाएं
• नमाज़ से पहले सदक़तुल फ़ित्र दें

**ईदुल अज़हा के लिए:**
• नमाज़ से पहले न खाएं
• नमाज़ के बाद क़ुर्बानी करें
• 9 ज़ुल हिज्जा की फज्र से 13 की अस्र तक तकबीरात-ए-तशरीक़'''
      }
    },
    {
      'title': 'Janazah Prayer',
      'titleUrdu': 'نماز جنازہ',
      'titleHindi': 'जनाज़े की नमाज़',
      'rakats': '4 Takbeers, No Ruku/Sujood',
      'rakatsUrdu': '۴ تکبیرات، رکوع سجود نہیں',
      'rakatsHindi': '4 तकबीरात, रुकू सुजूद नहीं',
      'time': 'Anytime except forbidden times',
      'timeUrdu': 'ممنوع اوقات کے علاوہ کسی بھی وقت',
      'timeHindi': 'ममनूअ औक़ात के अलावा किसी भी वक़्त',
      'icon': Icons.airline_seat_flat,
      'color': Colors.grey,
      'details': {
        'english': '''
**Janazah (Funeral) Prayer (جنازہ)**

**Status:** Fard Kifayah (communal obligation)

**Time:** Can be performed anytime except during sunrise, sunset, and when sun is at zenith.

**Standing Position:**
• For male: Stand in line with the chest
• For female: Stand in line with the middle
• For child: Stand in line with the head

**How to Pray:**

**After 1st Takbeer:**
• Fold hands and recite Thana (Subhanaka...)

**After 2nd Takbeer:**
• Recite Durood Ibrahim

**After 3rd Takbeer:**
• Make Dua for the deceased:
"Allahummaghfir li hayyina wa mayyitina wa shahidina wa ghaibina wa sagheerina wa kabeerina wa dhakarina wa unthana. Allahumma man ahyaytahu minna fa ahyihi 'alal Islam wa man tawaffaytahu minna fatawaffahu 'alal Iman."

(O Allah, forgive our living and dead, those present and absent, young and old, male and female. O Allah, whoever You keep alive among us, keep him alive in Islam, and whoever You cause to die, cause him to die in faith.)

**For Child who didn't reach puberty, add:**
"Allahummaj'alhu lana faratan waj'alhu lana ajran wa dhukhran waj'alhu lana shafi'an wa mushaffa'a"

**After 4th Takbeer:**
• Turn right and left giving Salam

**Important Points:**
• No Ruku or Sujood
• Imam stands in front of the body
• Rows should be odd numbered (3, 5, 7...)
• Shoes should be removed
• Face Qiblah
• Body should be placed with head to the right of Imam''',
        'urdu': '''
**نماز جنازہ**

**حیثیت:** فرض کفایہ (اجتماعی فرض)

**وقت:** طلوع آفتاب، غروب آفتاب اور جب سورج سر پر ہو ان اوقات کے علاوہ کسی بھی وقت پڑھ سکتے ہیں۔

**کھڑے ہونے کی جگہ:**
• مرد کے لیے: سینے کے سامنے
• عورت کے لیے: درمیان میں
• بچے کے لیے: سر کے سامنے

**نماز پڑھنے کا طریقہ:**

**پہلی تکبیر کے بعد:**
• ہاتھ باندھیں اور ثناء پڑھیں (سبحانک...)

**دوسری تکبیر کے بعد:**
• درود ابراہیمی پڑھیں

**تیسری تکبیر کے بعد:**
• میت کے لیے دعا کریں:
"اللهم اغفر لحينا وميتنا وشاهدنا وغائبنا وصغيرنا وكبيرنا وذكرنا وأنثانا اللهم من أحييته منا فأحيه على الإسلام ومن توفيته منا فتوفه على الإيمان"

(اے اللہ ہمارے زندوں اور مردوں کو، حاضر اور غیر حاضر کو، چھوٹے اور بڑے کو، مرد اور عورت کو بخش دے۔ اے اللہ جسے تو ہم میں سے زندہ رکھے اسے اسلام پر زندہ رکھ اور جسے موت دے اسے ایمان پر موت دے۔)

**نابالغ بچے کے لیے اضافہ:**
"اللهم اجعله لنا فرطاً واجعله لنا أجراً وذخراً واجعله لنا شافعاً ومشفعاً"

**چوتھی تکبیر کے بعد:**
• دائیں بائیں سلام پھیریں

**اہم باتیں:**
• رکوع یا سجود نہیں
• امام لاش کے سامنے کھڑا ہوتا ہے
• صفیں طاق ہونی چاہئیں (۳، ۵، ۷...)
• جوتے اتارنے چاہئیں
• قبلہ رخ ہوں
• لاش کا سر امام کی دائیں طرف ہونا چاہیے''',
        'hindi': '''
**जनाज़े की नमाज़**

**हैसियत:** फ़र्ज़ किफ़ाया (इज्तिमाई फ़र्ज़)

**वक़्त:** तुलू-ए-आफ़ताब, ग़ुरूब-ए-आफ़ताब और जब सूरज सर पर हो इन औक़ात के अलावा किसी भी वक़्त पढ़ सकते हैं।

**खड़े होने की जगह:**
• मर्द के लिए: सीने के सामने
• औरत के लिए: दरमियान में
• बच्चे के लिए: सर के सामने

**नमाज़ पढ़ने का तरीक़ा:**

**पहली तकबीर के बाद:**
• हाथ बांधें और सना पढ़ें (सुब्हानका...)

**दूसरी तकबीर के बाद:**
• दुरूद इब्राहीमी पढ़ें

**तीसरी तकबीर के बाद:**
• मय्यित के लिए दुआ करें:
"अल्लाहुम्मग़फ़िर लिहय्यिना व मय्यितिना व शाहिदिना व ग़ायबिना व सग़ीरिना व कबीरिना व ज़करिना व उन्साना अल्लाहुम्मा मन अहयैतहू मिन्ना फ़अह्यिहि अलल इस्लाम व मन तवफ़्फ़ैतहू मिन्ना फ़तवफ़्फ़हू अलल ईमान"

(ऐ अल्लाह हमारे ज़िंदों और मुर्दों को, हाज़िर और ग़ैर-हाज़िर को, छोटे और बड़े को, मर्द और औरत को बख़्श दे। ऐ अल्लाह जिसे तू हम में से ज़िंदा रखे उसे इस्लाम पर ज़िंदा रख और जिसे मौत दे उसे ईमान पर मौत दे।)

**नाबालिग़ बच्चे के लिए इज़ाफ़ा:**
"अल्लाहुम्मज्अल्हु लना फ़रतन वज्अल्हु लना अज्रन व ज़ुख़्रन वज्अल्हु लना शाफ़िअन व मुशफ़्फ़अन"

**चौथी तकबीर के बाद:**
• दाएं बाएं सलाम फेरें

**अहम बातें:**
• रुकू या सुजूद नहीं
• इमाम लाश के सामने खड़ा होता है
• सफ़ें ताक़ होनी चाहिएं (3, 5, 7...)
• जूते उतारने चाहिएं
• क़िब्ला रुख़ हों
• लाश का सर इमाम की दाईं तरफ़ होना चाहिए'''
      }
    },
    {
      'title': 'Tahajjud Prayer',
      'titleUrdu': 'نماز تہجد',
      'titleHindi': 'तहज्जुद की नमाज़',
      'rakats': '2-12 Rakats (in pairs)',
      'rakatsUrdu': '۲-۱۲ رکعت (جوڑوں میں)',
      'rakatsHindi': '2-12 रकात (जोड़ों में)',
      'time': 'After Isha until Fajr (best in last third of night)',
      'timeUrdu': 'عشاء کے بعد فجر تک (رات کے آخری تہائی میں بہترین)',
      'timeHindi': 'इशा के बाद फज्र तक (रात के आख़िरी तिहाई में बेहतरीन)',
      'icon': Icons.bedtime,
      'color': Colors.blueGrey,
      'details': {
        'english': '''
**Tahajjud Prayer (تہجد)**

**Time:** After sleeping at night, waking up to pray before Fajr. Best time is the last third of the night.

**Rakats:** Minimum 2, Maximum as many as you can. Usually prayed in pairs of 2.

**How to Pray:**
1. Wake up after sleeping
2. Make Wudu
3. Pray 2 rakats at a time
4. Can pray 2, 4, 6, 8, 10, or 12 rakats
5. Conclude with Witr if not prayed after Isha

**Recommended Surahs:**
• Long Surahs for those who have memorized
• Surah Mulk, Sajdah, Muzammil are recommended

**Virtues:**
• Allah descends to lowest heaven in last third of night
• Prophet ﷺ asked: "Is there anyone seeking?" and Allah responds
• Closest servant is the one who prays at night
• Prophet ﷺ prayed until his feet swelled

**Special Dua When Waking:**
"La ilaha illallahu wahdahu la shareeka lahu, lahul mulku wa lahul hamdu, wa huwa 'ala kulli shay'in qadeer. Alhamdulillahi, wa subhanallahi, wa la ilaha illallahu, wallahu akbar, wa la hawla wa la quwwata illa billah."

Then ask Allah for anything, make Wudu, and pray.

**Tips:**
• Set alarm for last third of night
• Sleep early after Isha
• Make intention before sleeping
• Start with small amount and increase gradually''',
        'urdu': '''
**نماز تہجد**

**وقت:** رات کو سونے کے بعد فجر سے پہلے اٹھ کر پڑھنا۔ بہترین وقت رات کا آخری تہائی حصہ۔

**رکعات:** کم از کم ۲، زیادہ سے زیادہ جتنی پڑھ سکیں۔ عموماً ۲-۲ رکعت کر کے پڑھی جاتی ہیں۔

**نماز پڑھنے کا طریقہ:**
۱. سونے کے بعد اٹھیں
۲. وضو کریں
۳. ایک وقت میں ۲ رکعت پڑھیں
۴. ۲، ۴، ۶، ۸، ۱۰ یا ۱۲ رکعت پڑھ سکتے ہیں
۵. اگر عشاء کے بعد وتر نہیں پڑھے تو آخر میں پڑھیں

**تجویز کردہ سورتیں:**
• جنہیں یاد ہوں ان کے لیے لمبی سورتیں
• سورۃ الملک، سجدہ، مزمل مستحب ہیں

**فضیلت:**
• رات کے آخری پہر اللہ آسمان دنیا پر نزول فرماتا ہے
• نبی ﷺ نے فرمایا اللہ پوچھتا ہے "کوئی مانگنے والا ہے؟"
• سب سے قریب بندہ وہ ہے جو رات کو نماز پڑھے
• نبی ﷺ اتنی نماز پڑھتے کہ پاؤں سوج جاتے

**جاگنے پر خاص دعا:**
"لا الہ الا اللہ وحدہ لا شریک لہ، لہ الملک ولہ الحمد، وھو علی کل شیء قدیر۔ الحمد للہ، وسبحان اللہ، ولا الہ الا اللہ، واللہ اکبر، ولا حول ولا قوۃ الا باللہ۔"

پھر اللہ سے جو چاہیں مانگیں، وضو کریں اور نماز پڑھیں۔

**تجاویز:**
• رات کے آخری پہر کا الارم لگائیں
• عشاء کے بعد جلدی سوئیں
• سونے سے پہلے نیت کریں
• کم سے شروع کریں اور آہستہ آہستہ بڑھائیں''',
        'hindi': '''
**तहज्जुद की नमाज़**

**वक़्त:** रात को सोने के बाद फज्र से पहले उठकर पढ़ना। बेहतरीन वक़्त रात का आख़िरी तिहाई हिस्सा।

**रकात:** कम से कम 2, ज़्यादा से ज़्यादा जितनी पढ़ सकें। आमतौर पर 2-2 रकात करके पढ़ी जाती हैं।

**नमाज़ पढ़ने का तरीक़ा:**
1. सोने के बाद उठें
2. वुज़ू करें
3. एक वक़्त में 2 रकात पढ़ें
4. 2, 4, 6, 8, 10 या 12 रकात पढ़ सकते हैं
5. अगर इशा के बाद वित्र नहीं पढ़े तो आख़िर में पढ़ें

**तज्वीज़ करदा सूरतें:**
• जिन्हें याद हों उनके लिए लंबी सूरतें
• सूरह अल-मुल्क, सजदा, मुज़म्मिल मुस्तहब हैं

**फ़ज़ीलत:**
• रात के आख़िरी पहर अल्लाह आसमान-ए-दुनिया पर नुज़ूल फ़रमाता है
• नबी ﷺ ने फ़रमाया अल्लाह पूछता है "कोई मांगने वाला है?"
• सबसे क़रीब बंदा वो है जो रात को नमाज़ पढ़े
• नबी ﷺ इतनी नमाज़ पढ़ते कि पांव सूज जाते

**जागने पर ख़ास दुआ:**
"ला इलाहा इल्लल्लाहु वहदहू ला शरीका लहू, लहुल मुल्कु व लहुल हम्दु, व हुवा अला कुल्लि शैइन क़दीर। अलहम्दुलिल्लाह, व सुब्हानल्लाह, व ला इलाहा इल्लल्लाह, वल्लाहु अकबर, व ला हौला व ला क़ुव्वता इल्ला बिल्लाह।"

फिर अल्लाह से जो चाहें मांगें, वुज़ू करें और नमाज़ पढ़ें।

**तजावीज़:**
• रात के आख़िरी पहर का अलार्म लगाएं
• इशा के बाद जल्दी सोएं
• सोने से पहले नीयत करें
• कम से शुरू करें और आहिस्ता-आहिस्ता बढ़ाएं'''
      }
    },
    {
      'title': 'Ishraq Prayer',
      'titleUrdu': 'نماز اشراق',
      'titleHindi': 'इशराक़ की नमाज़',
      'rakats': '2-4 Rakats',
      'rakatsUrdu': '۲-۴ رکعت',
      'rakatsHindi': '2-4 रकात',
      'time': '15-20 min after sunrise',
      'timeUrdu': 'طلوع آفتاب کے ۱۵-۲۰ منٹ بعد',
      'timeHindi': 'तुलू-ए-आफ़ताब के 15-20 मिनट बाद',
      'icon': Icons.wb_sunny_outlined,
      'color': Colors.amber.shade600,
      'details': {
        'english': '''
**Ishraq Prayer (اشراق)**

**Time:** Approximately 15-20 minutes after sunrise, when the sun has risen completely and it is no longer forbidden time.

**Rakats:** 2 to 4 Rakats (prayed in pairs of 2)

**Condition:** One must remain seated in the place of Fajr prayer, engaged in dhikr (remembrance of Allah) until the sun rises completely.

**How to Pray:**
1. Pray Fajr prayer in the masjid
2. Remain seated in your place of prayer
3. Engage in dhikr, Quran recitation, or dua
4. Wait until the sun rises fully (about 15-20 min after sunrise)
5. Then pray 2 or 4 rakats of Ishraq

**Method:**
Same as any 2 rakat Nafl prayer:
• Make intention for Ishraq
• Pray normally with Fatiha and a Surah in each rakat

**Virtues:**
• Prophet ﷺ said: "Whoever prays Fajr in congregation, then sits remembering Allah until the sun rises, then prays two rakats, will have a reward like that of Hajj and Umrah, complete, complete, complete." (Tirmidhi)
• This is one of the most rewarding voluntary prayers
• Equivalent reward of complete Hajj and Umrah

**Important Notes:**
• Must stay in the same place after Fajr
• Engage in dhikr/tilawat during waiting
• Cannot leave and come back
• Some scholars say the reward is still great even if one leaves briefly''',
        'urdu': '''
**نماز اشراق**

**وقت:** طلوع آفتاب کے تقریباً ۱۵-۲۰ منٹ بعد، جب سورج مکمل طور پر طلوع ہو جائے اور ممنوع وقت ختم ہو جائے۔

**رکعات:** ۲ سے ۴ رکعت (۲-۲ کر کے)

**شرط:** فجر کی نماز کی جگہ پر بیٹھے رہنا اور اللہ کے ذکر میں مشغول رہنا یہاں تک کہ سورج مکمل طلوع ہو جائے۔

**نماز پڑھنے کا طریقہ:**
۱. مسجد میں فجر کی نماز پڑھیں
۲. اپنی نماز کی جگہ پر بیٹھے رہیں
۳. ذکر، قرآن تلاوت یا دعا میں مشغول رہیں
۴. سورج مکمل طلوع ہونے تک انتظار کریں (تقریباً ۱۵-۲۰ منٹ بعد)
۵. پھر ۲ یا ۴ رکعت اشراق پڑھیں

**طریقہ:**
کسی بھی ۲ رکعت نفل کی طرح:
• اشراق کی نیت کریں
• عام طریقے سے فاتحہ اور سورت کے ساتھ پڑھیں

**فضیلت:**
• نبی ﷺ نے فرمایا: "جو فجر کی نماز جماعت سے پڑھے، پھر اللہ کے ذکر میں مشغول رہے یہاں تک کہ سورج طلوع ہو جائے، پھر دو رکعت پڑھے، اسے حج اور عمرہ کا مکمل، مکمل، مکمل ثواب ملے گا۔" (ترمذی)
• یہ سب سے زیادہ ثواب والی نفل نمازوں میں سے ایک ہے
• مکمل حج اور عمرہ کے برابر ثواب

**اہم باتیں:**
• فجر کے بعد اسی جگہ رہنا ضروری ہے
• انتظار کے دوران ذکر/تلاوت کریں
• جا کر واپس نہیں آ سکتے
• کچھ علماء کہتے ہیں کہ مختصر وقفے کے باوجود بھی ثواب عظیم ہے''',
        'hindi': '''
**इशराक़ की नमाज़**

**वक़्त:** तुलू-ए-आफ़ताब के तक़रीबन 15-20 मिनट बाद, जब सूरज पूरी तरह तुलू हो जाए और ममनूअ वक़्त ख़त्म हो जाए।

**रकात:** 2 से 4 रकात (2-2 करके)

**शर्त:** फज्र की नमाज़ की जगह पर बैठे रहना और अल्लाह के ज़िक्र में मशग़ूल रहना यहां तक कि सूरज मुकम्मल तुलू हो जाए।

**नमाज़ पढ़ने का तरीक़ा:**
1. मस्जिद में फज्र की नमाज़ पढ़ें
2. अपनी नमाज़ की जगह पर बैठे रहें
3. ज़िक्र, क़ुरान तिलावत या दुआ में मशग़ूल रहें
4. सूरज मुकम्मल तुलू होने तक इंतिज़ार करें (तक़रीबन 15-20 मिनट बाद)
5. फिर 2 या 4 रकात इशराक़ पढ़ें

**तरीक़ा:**
किसी भी 2 रकात नफ़्ल की तरह:
• इशराक़ की नीयत करें
• आम तरीक़े से फ़ातिहा और सूरत के साथ पढ़ें

**फ़ज़ीलत:**
• नबी ﷺ ने फ़रमाया: "जो फज्र की नमाज़ जमाअत से पढ़े, फिर अल्लाह के ज़िक्र में मशग़ूल रहे यहां तक कि सूरज तुलू हो जाए, फिर दो रकात पढ़े, उसे हज और उमरा का मुकम्मल, मुकम्मल, मुकम्मल सवाब मिलेगा।" (तिर्मिज़ी)
• यह सबसे ज़्यादा सवाब वाली नफ़्ल नमाज़ों में से एक है
• मुकम्मल हज और उमरा के बराबर सवाब

**अहम बातें:**
• फज्र के बाद उसी जगह रहना ज़रूरी है
• इंतिज़ार के दौरान ज़िक्र/तिलावत करें
• जाकर वापस नहीं आ सकते
• कुछ उलमा कहते हैं कि मुख़्तसर वक़्फ़े के बावजूद भी सवाब अज़ीम है'''
      }
    },
    {
      'title': 'Duha/Chasht Prayer',
      'titleUrdu': 'نماز چاشت/ضحیٰ',
      'titleHindi': 'चाश्त/ज़ुहा की नमाज़',
      'rakats': '2-12 Rakats',
      'rakatsUrdu': '۲-۱۲ رکعت',
      'rakatsHindi': '2-12 रकात',
      'time': 'Mid-morning to before Zawaal',
      'timeUrdu': 'چاشت سے زوال سے پہلے تک',
      'timeHindi': 'चाश्त से ज़वाल से पहले तक',
      'icon': Icons.light_mode,
      'color': Colors.orange.shade400,
      'details': {
        'english': '''
**Duha/Chasht Prayer (ضحیٰ/چاشت)**

**Time:** From when the sun has risen well (about 45 minutes after sunrise) until just before Zawaal (midday).

**Best Time:** When the sun's heat becomes intense, which is about mid-morning.

**Rakats:**
• Minimum: 2 Rakats
• Recommended: 4 Rakats
• Maximum: 8-12 Rakats
• All prayed in pairs of 2

**How to Pray:**
1. Make intention for Salat ud-Duha
2. Pray 2 rakats at a time
3. Can pray as many pairs as desired (up to 12)
4. Each pair is complete with Salam

**Method:**
Same as any Nafl prayer:
• Fatiha + any Surah in each rakat
• Complete 2 rakats, give Salam
• Repeat if praying more

**Virtues:**
• "In the morning, charity is due from every bone in the body of every one of you. Every tasbeeh is charity, every tahmeed is charity, every taheel is charity, every takbeer is charity, enjoining good is charity, forbidding evil is charity, and two rakats of Duha suffices for all of that." (Muslim)

• Prophet ﷺ said: "None is constant in praying Duha except an Awwab (one who turns to Allah in repentance), and it is the prayer of the Awwabeen (those who turn to Allah)."

• Abu Hurairah said: "My friend (Prophet ﷺ) advised me three things: fasting three days every month, praying Duha, and praying Witr before sleeping."

**Benefits:**
• Equivalent to giving charity for every joint in the body
• Called "Prayer of the Penitent" (Salat ul-Awwabin by some)
• Great way to thank Allah for the new day
• Brings barakah (blessings) in one's day''',
        'urdu': '''
**نماز چاشت/ضحیٰ**

**وقت:** جب سورج اچھی طرح چڑھ جائے (طلوع کے تقریباً ۴۵ منٹ بعد) سے زوال سے پہلے تک۔

**بہترین وقت:** جب سورج کی گرمی تیز ہو جائے، یعنی تقریباً دوپہر سے پہلے۔

**رکعات:**
• کم از کم: ۲ رکعت
• مستحب: ۴ رکعت
• زیادہ سے زیادہ: ۸-۱۲ رکعت
• سب ۲-۲ کر کے پڑھی جائیں

**نماز پڑھنے کا طریقہ:**
۱. صلاۃ الضحیٰ کی نیت کریں
۲. ایک وقت میں ۲ رکعت پڑھیں
۳. جتنے جوڑے چاہیں پڑھ سکتے ہیں (۱۲ تک)
۴. ہر جوڑا سلام کے ساتھ مکمل

**طریقہ:**
کسی بھی نفل نماز کی طرح:
• ہر رکعت میں فاتحہ + کوئی سورت
• ۲ رکعت مکمل کریں، سلام پھیریں
• اگر زیادہ پڑھنا ہو تو دہرائیں

**فضیلت:**
• "صبح کو تم میں سے ہر ایک کے جسم کی ہر ہڈی پر صدقہ واجب ہے۔ ہر تسبیح صدقہ ہے، ہر تحمید صدقہ ہے، ہر تہلیل صدقہ ہے، ہر تکبیر صدقہ ہے، نیکی کا حکم دینا صدقہ ہے، برائی سے روکنا صدقہ ہے، اور چاشت کی دو رکعتیں ان سب کے لیے کافی ہیں۔" (مسلم)

• نبی ﷺ نے فرمایا: "چاشت کی نماز پر صرف اواب (اللہ کی طرف رجوع کرنے والا) ہی قائم رہتا ہے، اور یہ اوابین کی نماز ہے۔"

• ابو ہریرہ نے کہا: "میرے دوست (نبی ﷺ) نے مجھے تین چیزوں کی نصیحت کی: ہر مہینے تین روزے، چاشت کی نماز، اور سونے سے پہلے وتر۔"

**فوائد:**
• جسم کے ہر جوڑ پر صدقہ دینے کے برابر
• "توبہ کرنے والوں کی نماز" کہلاتی ہے
• نئے دن کے لیے اللہ کا شکر ادا کرنے کا بہترین طریقہ
• دن میں برکت لاتی ہے''',
        'hindi': '''
**चाश्त/ज़ुहा की नमाज़**

**वक़्त:** जब सूरज अच्छी तरह चढ़ जाए (तुलू के तक़रीबन 45 मिनट बाद) से ज़वाल से पहले तक।

**बेहतरीन वक़्त:** जब सूरज की गर्मी तेज़ हो जाए, यानी तक़रीबन दोपहर से पहले।

**रकात:**
• कम से कम: 2 रकात
• मुस्तहब: 4 रकात
• ज़्यादा से ज़्यादा: 8-12 रकात
• सब 2-2 करके पढ़ी जाएं

**नमाज़ पढ़ने का तरीक़ा:**
1. सलातुज़्ज़ुहा की नीयत करें
2. एक वक़्त में 2 रकात पढ़ें
3. जितने जोड़े चाहें पढ़ सकते हैं (12 तक)
4. हर जोड़ा सलाम के साथ मुकम्मल

**तरीक़ा:**
किसी भी नफ़्ल नमाज़ की तरह:
• हर रकात में फ़ातिहा + कोई सूरत
• 2 रकात मुकम्मल करें, सलाम फेरें
• अगर ज़्यादा पढ़ना हो तो दोहराएं

**फ़ज़ीलत:**
• "सुबह को तुम में से हर एक के जिस्म की हर हड्डी पर सदक़ा वाजिब है। हर तस्बीह सदक़ा है, हर तहमीद सदक़ा है, हर तहलील सदक़ा है, हर तकबीर सदक़ा है, नेकी का हुक्म देना सदक़ा है, बुराई से रोकना सदक़ा है, और चाश्त की दो रकातें इन सब के लिए काफ़ी हैं।" (मुस्लिम)

• नबी ﷺ ने फ़रमाया: "चाश्त की नमाज़ पर सिर्फ़ अव्वाब (अल्लाह की तरफ़ रुजू करने वाला) ही क़ायम रहता है, और यह अव्वाबीन की नमाज़ है।"

• अबू हुरैरा ने कहा: "मेरे दोस्त (नबी ﷺ) ने मुझे तीन चीज़ों की नसीहत की: हर महीने तीन रोज़े, चाश्त की नमाज़, और सोने से पहले वित्र।"

**फ़वायद:**
• जिस्म के हर जोड़ पर सदक़ा देने के बराबर
• "तौबा करने वालों की नमाज़" कहलाती है
• नए दिन के लिए अल्लाह का शुक्र अदा करने का बेहतरीन तरीक़ा
• दिन में बरकत लाती है'''
      }
    },
    {
      'title': 'Awwabin Prayer',
      'titleUrdu': 'نماز اوابین',
      'titleHindi': 'अव्वाबीन की नमाज़',
      'rakats': '6-20 Rakats',
      'rakatsUrdu': '۶-۲۰ رکعت',
      'rakatsHindi': '6-20 रकात',
      'time': 'After Maghrib Sunnah',
      'timeUrdu': 'مغرب کی سنت کے بعد',
      'timeHindi': 'मग़रिब की सुन्नत के बाद',
      'icon': Icons.nights_stay_outlined,
      'color': Colors.purple.shade400,
      'details': {
        'english': '''
**Awwabin Prayer (اوابین)**

**Time:** Between Maghrib and Isha prayers, after completing the Sunnah of Maghrib.

**Rakats:**
• Minimum: 6 Rakats (according to many scholars)
• Some say: 2-20 Rakats
• Prayed in pairs of 2

**How to Pray:**
1. Complete Maghrib Fard (3) and Sunnah (2)
2. Make intention for Salat ul-Awwabin
3. Pray 2 rakats at a time
4. Repeat until you complete 6 or more rakats

**Method:**
Same as any Nafl prayer:
• Make intention for Awwabin
• Pray 2 rakats with Fatiha and any Surah
• Give Salam and repeat

**Virtues:**
• Prophet ﷺ said: "Whoever prays six rakats after Maghrib without speaking ill between them, they will be equivalent to twelve years of worship." (Tirmidhi)

• This is called "Salat ul-Awwabin" (Prayer of the Oft-Returning)

• Some scholars say this refers to the Duha prayer, while others say it refers to prayer after Maghrib

• The time between Maghrib and Isha is blessed and often unutilized

**Important Notes:**
• Should not speak ill of anyone between the rakats
• Should maintain focus on worship
• Can recite Quran, do dhikr between sets
• This is Mustahab (recommended), not obligatory

**Benefits:**
• Enormous reward (equivalent to years of worship)
• Utilizes often-wasted time
• Strengthens connection with Allah
• Follows the practice of the pious predecessors''',
        'urdu': '''
**نماز اوابین**

**وقت:** مغرب اور عشاء کے درمیان، مغرب کی سنت کے بعد۔

**رکعات:**
• کم از کم: ۶ رکعت (بہت سے علماء کے مطابق)
• کچھ کہتے ہیں: ۲-۲۰ رکعت
• ۲-۲ کر کے پڑھی جائیں

**نماز پڑھنے کا طریقہ:**
۱. مغرب کے فرض (۳) اور سنت (۲) مکمل کریں
۲. صلاۃ الاوابین کی نیت کریں
۳. ایک وقت میں ۲ رکعت پڑھیں
۴. ۶ یا زیادہ رکعت مکمل ہونے تک دہرائیں

**طریقہ:**
کسی بھی نفل نماز کی طرح:
• اوابین کی نیت کریں
• فاتحہ اور کسی سورت کے ساتھ ۲ رکعت پڑھیں
• سلام پھیریں اور دہرائیں

**فضیلت:**
• نبی ﷺ نے فرمایا: "جو مغرب کے بعد ۶ رکعت پڑھے بغیر درمیان میں برا کہے، یہ بارہ سال کی عبادت کے برابر ہوں گی۔" (ترمذی)

• اسے "صلاۃ الاوابین" (توبہ کرنے والوں کی نماز) کہتے ہیں

• کچھ علماء کہتے ہیں یہ چاشت کی نماز ہے، جبکہ دوسرے کہتے ہیں یہ مغرب کے بعد کی نماز ہے

• مغرب اور عشاء کے درمیان کا وقت بابرکت اور اکثر غیر استعمال شدہ ہے

**اہم باتیں:**
• رکعتوں کے درمیان کسی کی برائی نہیں کرنی چاہیے
• عبادت پر توجہ رکھنی چاہیے
• سیٹوں کے درمیان قرآن، ذکر کر سکتے ہیں
• یہ مستحب ہے، فرض نہیں

**فوائد:**
• بے پناہ ثواب (سالوں کی عبادت کے برابر)
• اکثر ضائع ہونے والے وقت کا استعمال
• اللہ سے تعلق مضبوط کرتی ہے
• سلف صالحین کی پیروی''',
        'hindi': '''
**अव्वाबीन की नमाज़**

**वक़्त:** मग़रिब और इशा के दरमियान, मग़रिब की सुन्नत के बाद।

**रकात:**
• कम से कम: 6 रकात (बहुत से उलमा के मुताबिक़)
• कुछ कहते हैं: 2-20 रकात
• 2-2 करके पढ़ी जाएं

**नमाज़ पढ़ने का तरीक़ा:**
1. मग़रिब के फ़र्ज़ (3) और सुन्नत (2) मुकम्मल करें
2. सलातुल अव्वाबीन की नीयत करें
3. एक वक़्त में 2 रकात पढ़ें
4. 6 या ज़्यादा रकात मुकम्मल होने तक दोहराएं

**तरीक़ा:**
किसी भी नफ़्ल नमाज़ की तरह:
• अव्वाबीन की नीयत करें
• फ़ातिहा और किसी सूरत के साथ 2 रकात पढ़ें
• सलाम फेरें और दोहराएं

**फ़ज़ीलत:**
• नबी ﷺ ने फ़रमाया: "जो मग़रिब के बाद 6 रकात पढ़े बग़ैर दरमियान में बुरा कहे, यह बारह साल की इबादत के बराबर होंगी।" (तिर्मिज़ी)

• इसे "सलातुल अव्वाबीन" (तौबा करने वालों की नमाज़) कहते हैं

• कुछ उलमा कहते हैं यह चाश्त की नमाज़ है, जबकि दूसरे कहते हैं यह मग़रिब के बाद की नमाज़ है

• मग़रिब और इशा के दरमियान का वक़्त बाबरकत और अक्सर ग़ैर-इस्तेमाल शुदा है

**अहम बातें:**
• रकातों के दरमियान किसी की बुराई नहीं करनी चाहिए
• इबादत पर तवज्जोह रखनी चाहिए
• सेटों के दरमियान क़ुरान, ज़िक्र कर सकते हैं
• यह मुस्तहब है, फ़र्ज़ नहीं

**फ़वायद:**
• बेपनाह सवाब (सालों की इबादत के बराबर)
• अक्सर ज़ाए होने वाले वक़्त का इस्तेमाल
• अल्लाह से ताल्लुक़ मज़बूत करती है
• सलफ़ सालिहीन की पैरवी'''
      }
    },
    {
      'title': 'Tasbeeh Prayer',
      'titleUrdu': 'نماز تسبیح',
      'titleHindi': 'तस्बीह की नमाज़',
      'rakats': '4 Rakats with 300 Tasbeeh',
      'rakatsUrdu': '۴ رکعت ۳۰۰ تسبیح کے ساتھ',
      'rakatsHindi': '4 रकात 300 तस्बीह के साथ',
      'time': 'Anytime (best on Fridays)',
      'timeUrdu': 'کسی بھی وقت (جمعہ کو بہترین)',
      'timeHindi': 'किसी भी वक़्त (जुमा को बेहतरीन)',
      'icon': Icons.repeat,
      'color': Colors.teal,
      'details': {
        'english': '''
**Salat ut-Tasbeeh (Prayer of Glorification)**

**Time:** Can be prayed at any permissible time. Recommended at least once in lifetime, or once a year, month, week, or daily if possible.

**Rakats:** 4 Rakats (can be prayed as 2+2 or 4 continuous)

**Tasbeeh to Recite:** "Subhan Allahi wal Hamdu lillahi wa la ilaha illallahu wallahu Akbar"
(Glory be to Allah, Praise be to Allah, There is no god but Allah, Allah is the Greatest)

**Total Count:** 75 Tasbeeh per rakat × 4 = 300 Tasbeeh

**How to Pray (Detailed Method):**

**In Each Rakat:**
1. After Thana: Recite Tasbeeh 15 times
2. After Fatiha + Surah: Recite Tasbeeh 10 times
3. In Ruku: Recite Tasbeeh 10 times (after regular dhikr)
4. After standing from Ruku: Recite Tasbeeh 10 times
5. In First Sajdah: Recite Tasbeeh 10 times (after regular dhikr)
6. Sitting between Sajdahs: Recite Tasbeeh 10 times
7. In Second Sajdah: Recite Tasbeeh 10 times (after regular dhikr)

**Summary per Rakat:**
15 + 10 + 10 + 10 + 10 + 10 + 10 = 75 Tasbeeh

**Special Notes:**
• If praying 4 continuous, sit after 2nd rakat only for Tashahhud (no Tasbeeh here)
• In 3rd & 4th rakat, start with Tasbeeh after standing (not after Thana)
• Some scholars prefer 2+2 method for ease

**Virtues:**
• Prophet ﷺ said to Abbas (RA): "If you do so, Allah will forgive all your sins - the first and the last, old and new, intentional and unintentional, small and great, hidden and open." (Abu Dawud, Tirmidhi)

**Tips:**
• Use fingers to count (don't use beads during prayer)
• Practice the sequence before performing
• Choose a quiet time without distractions''',
        'urdu': '''
**نماز تسبیح**

**وقت:** کسی بھی جائز وقت میں پڑھ سکتے ہیں۔ زندگی میں کم از کم ایک بار، یا ہر سال، مہینے، ہفتے یا روزانہ مستحب۔

**رکعات:** ۴ رکعت (۲+۲ یا ۴ لگاتار پڑھ سکتے ہیں)

**تسبیح:** "سبحان اللہ والحمد للہ ولا الہ الا اللہ واللہ اکبر"
(اللہ پاک ہے، تمام تعریف ��للہ کے لیے، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے)

**کل تعداد:** ۷۵ تسبیح فی رکعت × ۴ = ۳۰۰ تسبیح

**نماز پڑھنے کا تفصیلی طریقہ:**

**ہر رکعت میں:**
۱. ثناء کے بعد: ۱۵ مرتبہ تسبیح پڑھیں
۲. فاتحہ + سورت کے بعد: ۱۰ مرتبہ تسبیح پڑھیں
۳. رکوع میں: ۱۰ مرتبہ تسبیح پڑھیں (عام ذکر کے بعد)
۴. رکوع سے کھڑے ہو کر: ۱۰ مرتبہ تسبیح پڑھیں
۵. پہلے سجدے میں: ۱۰ مرتبہ تسبیح پڑھیں (عام ذکر کے بعد)
۶. سجدوں کے درمیان بیٹھ کر: ۱۰ مرتبہ تسبیح پڑھیں
۷. دوسرے سجدے میں: ۱۰ مرتبہ تسبیح پڑھیں (عام ذکر کے بعد)

**فی رکعت خلاصہ:**
۱۵ + ۱۰ + ۱۰ + ۱۰ + ۱۰ + ۱۰ + ۱۰ = ۷۵ تسبیح

**خاص باتیں:**
• اگر ۴ لگاتار پڑھ رہے ہیں تو دوسری رکعت کے بعد صرف تشہد کے لیے بیٹھیں (یہاں تسبیح نہیں)
• تیسری اور چوتھی رکعت میں کھڑے ہونے کے بعد تسبیح شروع کریں (ثناء کے بعد نہیں)
• کچھ علماء آسانی کے لیے ۲+۲ کا طریقہ پسند کرتے ہیں

**فضیلت:**
• نبی ﷺ نے عباس (رضی اللہ عنہ) سے فرمایا: "اگر تم ایسا کرو گے تو اللہ تمہارے تمام گناہ معاف فرما دے گا - پہلے اور آخری، پرانے اور نئے، جان بوجھ کر اور بھول کر، چھوٹے اور بڑے، چھپے اور ظاہر۔" (ابو داؤد، ترمذی)

**تجاویز:**
• انگلیوں سے گنتی کریں (نماز میں تسبیح نہ استعمال کریں)
• پڑھنے سے پہلے ترتیب کی مشق کریں
• بغیر خلل کا پرسکون وقت چنیں''',
        'hindi': '''
**तस्बीह की नमाज़**

**वक़्त:** किसी भी जायज़ वक़्त में पढ़ सकते हैं। ज़िंदगी में कम से कम एक बार, या हर साल, महीने, हफ़्ते या रोज़ाना मुस्तहब।

**रकात:** 4 रकात (2+2 या 4 लगातार पढ़ सकते हैं)

**तस्बीह:** "सुब्हानल्लाहि वल हम्दुलिल्लाहि व ला इलाहा इल्लल्लाहु वल्लाहु अकबर"
(अल्लाह पाक है, तमाम तारीफ़ अल्लाह के लिए, अल्लाह के सिवा कोई माबूद नहीं, अल्लाह सबसे बड़ा है)

**कुल तादाद:** 75 तस्बीह फ़ी रकात × 4 = 300 तस्बीह

**नमाज़ पढ़ने का तफ़्सीली तरीक़ा:**

**हर रकात में:**
1. सना के बाद: 15 मर्तबा तस्बीह पढ़ें
2. फ़ातिहा + सूरत के बाद: 10 मर्तबा तस्बीह पढ़ें
3. रुकू में: 10 मर्तबा तस्बीह पढ़ें (आम ज़िक्र के बाद)
4. रुकू से खड़े होकर: 10 मर्तबा तस्बीह पढ़ें
5. पहले सजदे में: 10 मर्तबा तस्बीह पढ़ें (आम ज़िक्र के बाद)
6. सजदों के दरमियान बैठकर: 10 मर्तबा तस्बीह पढ़ें
7. दूसरे सजदे में: 10 मर्तबा तस्बीह पढ़ें (आम ज़िक्र के बाद)

**फ़ी रकात ख़ुलासा:**
15 + 10 + 10 + 10 + 10 + 10 + 10 = 75 तस्बीह

**ख़ास बातें:**
• अगर 4 लगातार पढ़ रहे हैं तो दूसरी रकात के बाद सिर्फ़ तशह्हुद के लिए बैठें (यहां तस्बीह नहीं)
• तीसरी और चौथी रकात में खड़े होने के बाद तस्बीह शुरू करें (सना के बाद नहीं)
• कुछ उलमा आसानी के लिए 2+2 का तरीक़ा पसंद करते हैं

**फ़ज़ीलत:**
• नबी ﷺ ने अब्बास (रज़ियल्लाहु अन्हु) से फ़रमाया: "अगर तुम ऐसा करोगे तो अल्लाह तुम्हारे तमाम गुनाह माफ़ फ़रमा देगा - पहले और आख़िरी, पुराने और नए, जान-बूझकर और भूलकर, छोटे और बड़े, छुपे और ज़ाहिर।" (अबू दाऊद, तिर्मिज़ी)

**तजावीज़:**
• उंगलियों से गिनती करें (नमाज़ में तस्बीह न इस्तेमाल करें)
• पढ़ने से पहले तरतीब की मश्क़ करें
• बग़ैर ख़लल का पुरसुकून वक़्त चुनें'''
      }
    },
    {
      'title': 'Kusoof Prayer (Solar Eclipse)',
      'titleUrdu': 'نماز کسوف (سورج گرہن)',
      'titleHindi': 'कुसूफ़ की नमाज़ (सूरज ग्रहण)',
      'rakats': '2 Rakats (special method)',
      'rakatsUrdu': '۲ رکعت (خاص طریقہ)',
      'rakatsHindi': '2 रकात (ख़ास तरीक़ा)',
      'time': 'During Solar Eclipse',
      'timeUrdu': 'سورج گرہن کے دوران',
      'timeHindi': 'सूरज ग्रहण के दौरान',
      'icon': Icons.wb_sunny,
      'color': Colors.brown,
      'details': {
        'english': '''
**Kusoof Prayer (Solar Eclipse) - نماز کسوف**

**When:** Performed when a solar eclipse occurs, from beginning until end.

**Status:** Sunnah Muakkadah (emphasized Sunnah)

**Rakats:** 2 Rakats with special method

**How to Pray (Hanafi Method):**
2 rakats prayed like normal prayer but with very long recitation:
1. Long Qiyam (standing) with long Surah
2. Long Ruku
3. Long Sajdah
4. Second rakat same way
5. Total time should cover duration of eclipse

**How to Pray (Other Methods):**
Each rakat has 2 Qiyams and 2 Rukus:

**First Rakat:**
1. Takbeer, Thana, Fatiha, long Surah
2. Go to Ruku (long)
3. Stand again, recite Fatiha and Surah
4. Go to Ruku again (shorter)
5. Two Sajdahs normally

**Second Rakat:**
Same as first rakat

**Important Points:**
• No Adhan or Iqamah
• Imam recites loudly (according to some scholars)
• Can be prayed individually or in congregation
• Continue until eclipse ends
• Make dua and istighfar during eclipse

**Virtues:**
• Prophet ﷺ prayed this when eclipse occurred
• He said: "The sun and moon are signs of Allah. They do not eclipse for anyone's death or birth. When you see this, hasten to prayer."

**Additional Acts During Eclipse:**
• Make dua and istighfar
• Give charity
• Free slaves (in past)
• Remember Allah abundantly
• Seek refuge from punishment''',
        'urdu': '''
**نماز کسوف (سورج گرہن)**

**کب:** سورج گرہن ہونے پر، شروع سے آخر تک۔

**حیثیت:** سنت مؤکدہ

**رکعات:** ۲ رکعت خاص طریقے سے

**نماز پڑھنے کا طریقہ (حنفی):**
۲ رکعت عام نماز کی طرح لیکن بہت لمبی قراءت کے ساتھ:
۱. لمبا قیام لمبی س��رت کے ساتھ
۲. لمبا رکوع
۳. لمبا سجدہ
۴. دوسری رکعت بھی اسی طرح
۵. کل وقت گرہن کی مدت جتنا ہونا چاہیے

**دوسرے طریقے:**
ہر رکعت میں ۲ قیام اور ۲ رکوع:

**پہلی رکعت:**
۱. تکبیر، ثناء، فاتحہ، لمبی سورت
۲. رکوع میں جائیں (لمبا)
۳. دوبارہ کھڑے ہوں، فاتحہ اور سورت پڑھیں
۴. پھر رکوع میں جائیں (چھوٹا)
۵. دو سجدے عام طریقے سے

**دوسری رکعت:**
پہلی رکعت کی طرح

**اہم باتیں:**
• نہ اذان نہ اقامت
• امام بلند آواز سے پڑھے (کچھ علماء کے مطابق)
• اکیلے یا جماعت سے پڑھ سکتے ہیں
• گرہن ختم ہونے تک جاری رکھیں
• گرہن کے دوران دعا اور استغفار کریں

**فضیلت:**
• نبی ﷺ نے گرہن ہونے پر یہ نماز پڑھی
• آپ ﷺ نے فرمایا: "سورج اور چاند اللہ کی نشانیاں ہیں۔ یہ کسی کی موت یا پیدائش سے گرہن نہیں لگاتے۔ جب تم یہ دیکھو تو نماز کی طرف دوڑو۔"

**گرہن کے دوران اضافی اعمال:**
• دعا اور استغفار کریں
• صدقہ دیں
• غلام آزاد کریں (ماضی میں)
• کثرت سے اللہ کو یاد کریں
• عذاب سے پناہ مانگیں''',
        'hindi': '''
**कुसूफ़ की नमाज़ (सूरज ग्रहण)**

**कब:** सूरज ग्रहण होने पर, शुरू से आख़िर तक।

**हैसियत:** सुन्नत मुअक्कदा

**रकात:** 2 रकात ख़ास तरीक़े से

**नमाज़ पढ़ने का तरीक़ा (हनफ़ी):**
2 रकात आम नमाज़ की तरह लेकिन बहुत लंबी क़िराअत के साथ:
1. लंबा क़ियाम लंबी सूरत के साथ
2. लंबा रुकू
3. लंबा सजदा
4. दूसरी रकात भी इसी तरह
5. कुल वक़्त ग्रहण की मुद्दत जितना होना चाहिए

**दूसरे तरीक़े:**
हर रकात में 2 क़ियाम और 2 रुकू:

**पहली रकात:**
1. तकबीर, सना, फ़ातिहा, लंबी सूरत
2. रुकू में जाएं (लंबा)
3. दोबारा खड़े हों, फ़ातिहा और सूरत पढ़ें
4. फिर रुकू में जाएं (छोटा)
5. दो सजदे आम तरीक़े से

**दूसरी रकात:**
पहली रकात की तरह

**अहम बातें:**
• न अज़ान न इक़ामत
• इमाम बुलंद आवाज़ से पढ़े (कुछ उलमा के मुताबिक़)
• अकेले या जमाअत से पढ़ सकते हैं
• ग्रहण ख़त्म होने तक जारी रखें
• ग्रहण के दौरान दुआ और इस्तिग़फ़ार करें

**फ़ज़ीलत:**
• नबी ﷺ ने ग्रहण होने पर यह नमाज़ पढ़ी
• आप ﷺ ने फ़रमाया: "सूरज और चांद अल्लाह की निशानियां हैं। यह किसी की मौत या पैदाइश से ग्रहण नहीं लगाते। जब तुम यह देखो तो नमाज़ की तरफ़ दौड़ो।"

**ग्रहण के दौरान इज़ाफ़ी आमाल:**
• दुआ और इस्तिग़फ़ार करें
• सदक़ा दें
• ग़ुलाम आज़ाद करें (माज़ी में)
• कसरत से अल्लाह को याद करें
• अज़ाब से पनाह मांगें'''
      }
    },
    {
      'title': 'Khusoof Prayer (Lunar Eclipse)',
      'titleUrdu': 'نماز خسوف (چاند گرہن)',
      'titleHindi': 'ख़ुसूफ़ की नमाज़ (चांद ग्रहण)',
      'rakats': '2 Rakats',
      'rakatsUrdu': '۲ رکعت',
      'rakatsHindi': '2 रकात',
      'time': 'During Lunar Eclipse',
      'timeUrdu': 'چاند گرہن کے دوران',
      'timeHindi': 'चांद ग्रहण के दौरान',
      'icon': Icons.nightlight_round,
      'color': Colors.blueGrey.shade700,
      'details': {
        'english': '''
**Khusoof Prayer (Lunar Eclipse) - نماز خسوف**

**When:** Performed when a lunar eclipse occurs.

**Status:** Sunnah (recommended)

**Rakats:** 2 Rakats

**How to Pray:**
According to most Hanafi scholars, same as regular 2 rakat Nafl:
1. Make intention for Salat ul-Khusoof
2. Pray 2 rakats with long recitation
3. Long Ruku and Sujood
4. Continue making dua until eclipse ends

**Alternative Method (used by some):**
Same as Kusoof prayer with multiple Rukus per rakat

**Important Points:**
• No Adhan or Iqamah
• Can be prayed at home (unlike Kusoof which is better in congregation)
• Recitation is silent (as it's at night)
• Should engage in dua, dhikr, and istighfar
• Continue worship until eclipse ends

**Virtues:**
• Prophet ﷺ encouraged prayer and dua during eclipses
• Eclipses are reminders of Allah's power
• Time for repentance and seeking forgiveness

**What to Do During Lunar Eclipse:**
• Pray Salat ul-Khusoof
• Make abundant dua
• Seek forgiveness (Istighfar)
• Remember death and Day of Judgment
• Give charity if possible
• Recite Quran

**Note:** Some scholars say praying at home individually is fine for lunar eclipse, while solar eclipse prayer is preferably in congregation at the masjid.''',
        'urdu': '''
**نماز خسوف (چاند گرہن)**

**کب:** چاند گرہن ہونے پر۔

**حیثیت:** سنت (مستحب)

**رکعات:** ۲ رکعت

**نماز پڑھنے کا طریقہ:**
زیادہ تر حنفی علماء کے مطابق، عام ۲ رکعت نفل کی طرح:
۱. صلاۃ الخسوف کی نیت کریں
۲. لمبی قراءت کے ساتھ ۲ رکعت پڑھیں
۳. لمبا رکوع اور سجود
۴. گرہن ختم ہونے تک دعا کرتے رہیں

**متبادل طریقہ (کچھ علماء کے مطابق):**
کسوف کی نماز کی طرح ہر رکعت میں متعدد رکوع

**اہم باتیں:**
• نہ اذان نہ اقامت
• گھر پر پڑھ سکتے ہیں (کسوف کے برعکس جو جماعت سے بہتر ہے)
• آہستہ قراءت (کیونکہ رات کا وقت ہے)
• دعا، ذکر اور استغفار میں مشغول رہیں
• گرہن ختم ہونے تک عبادت جاری رکھیں

**فضیلت:**
• نبی ﷺ نے گرہن کے دوران نماز اور دعا کی ترغیب دی
• گرہن اللہ کی قدرت کی یاد دہانی ہیں
• توبہ اور استغفار کا وقت

**چاند گرہن کے دوران کیا کریں:**
• صلاۃ الخسوف پڑھیں
• کثرت سے دعا کریں
• استغفار کریں
• موت اور قیامت کو یاد کریں
• اگر ممکن ہو تو صدقہ دیں
• قرآن پڑھیں

**نوٹ:** کچھ علماء کہتے ہیں چاند گرہن کے لیے گھر پر اکیلے نماز ٹھیک ہے، جبکہ سورج گرہن کی نماز مسجد میں جماعت سے بہتر ہے۔''',
        'hindi': '''
**ख़ुसूफ़ की नमाज़ (चांद ग��रहण)**

**कब:** चांद ग्रहण होने पर।

**हैसियत:** सुन्नत (मुस्तहब)

**रकात:** 2 रकात

**नमाज़ पढ़ने का तरीक़ा:**
ज़्यादातर हनफ़ी उलमा के मुताबिक़, आम 2 रकात नफ़्ल की तरह:
1. सलातुल ख़ुसूफ़ की नीयत करें
2. लंबी क़िराअत के साथ 2 रकात पढ़ें
3. लंबा रुकू और सुजूद
4. ग्रहण ख़त्म होने तक दुआ करते रहें

**मुतबादिल तरीक़ा (कुछ उलमा के मुताबिक़):**
कुसूफ़ की नमाज़ की तरह हर रकात में मुतअद्दिद रुकू

**अहम बातें:**
• न अज़ान न इक़ामत
• घर पर पढ़ सकते हैं (कुसूफ़ के बरअक्स जो जमाअत से बेहतर है)
• आहिस्ता क़िराअत (क्योंकि रात का वक़्त है)
• दुआ, ज़िक्र और इस्तिग़फ़ार में मशग़ूल रहें
• ग्रहण ख़त्म होने तक इबादत जारी रखें

**फ़ज़ीलत:**
• नबी ﷺ ने ग्रहण के दौरान नमाज़ और दुआ की तरग़ीब दी
• ग्रहण अल्लाह की क़ुदरत की याद दिहानी हैं
• तौबा और इस्तिग़फ़ार का वक़्त

**चांद ग्रहण के दौरान क्या करें:**
• सलातुल ख़ुसूफ़ पढ़ें
• कसरत से दुआ करें
• इस्तिग़फ़ार करें
• मौत और क़यामत को याद करें
• अगर मुमकिन हो तो सदक़ा दें
• क़ुरान पढ़ें

**नोट:** कुछ उलमा कहते हैं चांद ग्रहण के लिए घर पर अकेले नमाज़ ठीक है, जबकि सूरज ग्रहण की नमाज़ मस्जिद में जमाअत से बेहतर है।'''
      }
    },
    {
      'title': 'Istisqa Prayer (Rain)',
      'titleUrdu': 'نماز استسقاء (بارش)',
      'titleHindi': 'इस्तिस्क़ा की नमाज़ (बारिश)',
      'rakats': '2 Rakats',
      'rakatsUrdu': '۲ رکعت',
      'rakatsHindi': '2 रकात',
      'time': 'During drought',
      'timeUrdu': 'خشک سالی کے دوران',
      'timeHindi': 'ख़ुश्क सालि के दौरान',
      'icon': Icons.water_drop,
      'color': Colors.blue,
      'details': {
        'english': '''
**Salat ul-Istisqa (Prayer for Rain) - نماز استسقاء**

**When:** During times of drought or when rain is desperately needed.

**Status:** Sunnah Muakkadah (confirmed Sunnah)

**Rakats:** 2 Rakats

**How to Pray:**
1. Make intention for Salat ul-Istisqa
2. Pray 2 rakats like Eid prayer:
   - First rakat: 7 Takbeers before recitation
   - Second rakat: 5 Takbeers before recitation
3. Or pray like regular 2 rakat Nafl (Hanafi view)
4. After prayer, Imam gives Khutbah
5. Make abundant dua for rain
6. Turn cloaks inside out (symbolic)

**Recommended Acts:**
• Fast for 3 days before
• Give charity
• Repent from sins
• Go out with humility
• Take animals and children
• Face Qiblah when making dua
• Raise hands high in dua
• Imam reverses his cloak after Khutbah

**Dua for Rain:**
"Allahumma asqina ghaithan mugheethan maree'an maree'an nafi'an ghayra dharrin 'ajilan ghayra ajilin"
(O Allah, give us rain that is helpful and wholesome, abundant and widespread, beneficial not harmful, now and not delayed)

**Important Points:**
• Should be prayed in open area (Musalla)
• People go out humbly, not in festive mood
• Expression of dependence on Allah
• Repentance is essential before asking

**When Rain Comes:**
Say: "Allahumma sayyiban nafi'an" (O Allah, make it beneficial rain)
And: "Muttirna bi fadhlillahi wa rahmatihi" (We have received rain by Allah's grace and mercy)''',
        'urdu': '''
**نماز استسقاء (بارش کی نماز)**

**کب:** خشک سالی کے وقت یا جب بارش کی شدید ضرورت ہو۔

**حیثیت:** سنت مؤکدہ

**رکعات:** ۲ رکعت

**نماز پڑھنے کا طریقہ:**
۱. صلاۃ الاستسقاء کی نیت کریں
۲. عید کی نماز کی طرح ۲ رکعت پڑھیں:
   - پہلی رکعت: قراءت سے پہلے ۷ تکبیریں
   - دوسری رکعت: قراءت سے پہلے ۵ تکبیریں
۳. یا عام ۲ رکعت نفل کی طرح پڑھیں (حنفی نظریہ)
۴. نماز کے بعد امام خطبہ دے
۵. بارش کے لیے کثرت سے دعا کریں
۶. چادریں الٹ لیں (علامتی)

**مستحب اعمال:**
• پہلے ۳ دن روزے رکھیں
• صدقہ دیں
• گناہوں سے توبہ کریں
• عاجزی سے نکلیں
• جانوروں اور بچوں کو ساتھ لے جائیں
• دعا کرتے وقت قبلہ رخ ہوں
• دعا میں ہاتھ اونچے کریں
• امام خطبے کے بعد چادر الٹ لے

**بارش کی دعا:**
"اللهم اسقنا غيثا مغيثا مريئا مريعا نافعا غير ضار عاجلا غير آجل"
(اے اللہ ہمیں مددگار، خوشگوار، فراواں، فائدہ مند، نقصان دہ نہیں، فوری، دیر نہ کرنے والی بارش دے)

**اہم باتیں:**
• کھلی جگہ (مصلیٰ) میں پڑھنی چاہیے
• لوگ عاجزی سے نکلیں، تہوار کے موڈ میں نہیں
• اللہ پر انحصار کا اظہار
• مانگنے سے پہلے توبہ ضروری ہے

**جب بارش آئے:**
کہیں: "اللهم صيبا نافعا" (اے اللہ اسے فائدہ مند بنا)
اور: "مطرنا بفضل الله ورحمته" (ہمیں اللہ کے فضل اور رحمت سے بارش ملی)''',
        'hindi': '''
**इस्तिस्क़ा की नमाज़ (बारिश की नमाज़)**

**कब:** ख़ुश्क सालि के वक़्त या जब बारिश की शदीद ज़रूरत हो।

**हैसियत:** सुन्नत मुअक्कदा

**रकात:** 2 रकात

**नमाज़ पढ़ने का तरीक़ा:**
1. सलातुल इस्तिस्क़ा की नीयत करें
2. ईद की नमाज़ की तरह 2 रकात पढ़ें:
   - पहली रकात: क़िराअत से पहले 7 तकबीरें
   - दूसरी रकात: क़िराअत से पहले 5 तकबीरें
3. या आम 2 रकात नफ़्ल की तरह पढ़ें (हनफ़ी नज़रिया)
4. नमाज़ के बाद इमाम ख़ुत्बा दे
5. बारिश के लिए कसरत से दुआ करें
6. चादरें उलट लें (इलामती)

**मुस्तहब आमाल:**
• पहले 3 दिन रोज़े रखें
• सदक़ा दें
• गुनाहों से तौबा करें
• आजिज़ी से निकलें
• जानवरों और बच्चों को साथ ले जाएं
• दुआ ���रते वक़्त क़िब्ला रुख़ हों
• दुआ में हाथ ऊंचे करें
• इमाम ख़ुत्बे के बाद चादर उलट ले

**बारिश की दुआ:**
"अल्लाहुम्मस्क़िना ग़ैसन मुग़ीसन मरीअन मरीअन नाफ़िअन ग़ैरा ज़ार्रिन आजिलन ग़ैरा आजिलिन"
(ऐ अल्लाह हमें मददगार, ख़ुशगवार, फ़रावां, फ़ायदेमंद, नुक़सानदेह नहीं, फ़ौरी, देर न करने वाली बारिश दे)

**अहम बातें:**
• खुली जगह (मुसल्ला) में पढ़नी चाहिए
• लोग आजिज़ी से निकलें, तियोहार के मूड में नहीं
• अल्लाह पर इन्हिसार का इज़हार
• मांगने से पहले तौबा ज़रूरी है

**जब बारिश आए:**
कहें: "अल्लाहुम्मा सय्यिबन नाफ़िअन" (ऐ अल्लाह इसे फ़ायदेमंद बना)
और: "मुत्तिरना बिफ़ज़्लिल्लाहि व रहमतिहि" (हमें अल्लाह के फ़ज़ल और रहमत से बारिश मिली)'''
      }
    },
    {
      'title': 'Hajat Prayer (Need)',
      'titleUrdu': 'نماز حاجت',
      'titleHindi': 'हाजत की नमाज़',
      'rakats': '2-12 Rakats',
      'rakatsUrdu': '۲-۱۲ رکعت',
      'rakatsHindi': '2-12 रकात',
      'time': 'Anytime when in need',
      'timeUrdu': 'جب بھی ضرورت ہو',
      'timeHindi': 'जब भी ज़रूरत हो',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'details': {
        'english': '''
**Salat ul-Hajat (Prayer of Need)**

**When:** Whenever you have a specific need or wish from Allah.

**Status:** Mustahab (recommended)

**Rakats:** 2 rakats (some narrations mention up to 12)

**How to Pray:**
1. Make proper Wudu with care and focus
2. Pray 2 rakats of Nafl
3. After Salam, praise Allah
4. Send blessings on Prophet ﷺ
5. Make your specific dua with sincerity

**Dua After Prayer:**
"La ilaha illallahul Haleemul Kareem. Subhanallahi Rabbil 'Arshil 'Azeem. Alhamdulillahi Rabbil 'Aalameen. As'aluka mujibati rahmatika, wa 'aza'ima maghfiratika, wal ghaneemata min kulli birrin, was salamata min kulli ithmin. La tada' li dhanban illa ghafartahu, wa la hamman illa farrajtahu, wa la hajatan hiya laka ridan illa qadaytaha, ya Arhamar Rahimeen."

**Translation:**
"There is no god but Allah, the Forbearing, the Generous. Glory be to Allah, Lord of the Mighty Throne. Praise be to Allah, Lord of the worlds. I ask You for all that brings Your mercy, and all that brings Your forgiveness, and profit from every good deed, and safety from every sin. Do not leave any sin of mine unforgiven, any worry unrelieved, or any need that pleases You unfulfilled, O Most Merciful of those who show mercy."

**Tips for Acceptance:**
• Pray with complete sincerity
• Have firm belief Allah will respond
• Be patient - Allah answers in His time
• Make sure your income is halal
• Don't ask for anything haram
• Persist in asking

**Best Times:**
• Last third of night
• Between Adhan and Iqamah
• While fasting
• During rain
• After obligatory prayers''',
        'urdu': '''
**نماز حاجت**

**کب:** جب بھی آپ کی اللہ سے کوئی خاص ضرورت یا خواہش ہو۔

**حیثیت:** مستحب

**رکعات:** ۲ رکعت (کچھ روایات میں ۱۲ تک کا ذکر ہے)

**نماز پڑھنے کا طریقہ:**
۱. توجہ سے اچھی طرح وضو کریں
۲. ۲ رکعت نفل پڑھیں
۳. سلام کے بعد اللہ کی حمد کریں
۴. نبی ﷺ پر درود بھیجیں
۵. خلوص سے اپنی مخصوص دعا مانگیں

**نماز کے بعد دعا:**
"لا إله إلا الله الحليم الكريم سبحان الله رب العرش العظيم الحمد لله رب العالمين أسألك موجبات رحمتك وعزائم مغفرتك والغنيمة من كل بر والسلامة من كل إثم لا تدع لي ذنبا إلا غفرته ولا هما إلا فرجته ولا حاجة هي لك رضا إلا قضيتها يا أرحم الراحمين"

**ترجمہ:**
"اللہ کے سوا کوئی معبود نہیں، بردبار، کریم۔ پاک ہے اللہ، عرش عظیم کا رب۔ تمام تعریف اللہ کے لیے جو تمام جہانوں کا رب ہے۔ میں تجھ سے وہ سب مانگتا ہوں جو تیری رحمت لائے، اور جو تیری مغفرت کا سبب بنے، ہر نیکی سے فائدہ اور ہر گناہ سے سلامتی۔ میرا کوئی گناہ نہ چھوڑ مگر معاف کر دے، کوئی پریشانی نہ چھوڑ مگر دور کر دے، کوئی ضرورت جو تیری رضا ہو نہ چھوڑ مگر پوری کر دے، اے سب سے زیادہ رحم کرنے والے۔"

**قبولیت کے لیے مشورے:**
• مکمل خلوص سے پڑھیں
• پختہ یقین رکھیں اللہ جواب دے گا
• صبر کریں - اللہ اپنے وقت پر جواب دیتا ہے
• یقینی بنائیں آمدنی حلال ہے
• کوئی حرام چیز نہ مانگیں
• مانگتے رہیں

**بہترین اوقات:**
• رات کا آخری تہائی
• اذان اور اقامت کے درمیان
• روزے کی حالت میں
• بارش کے دوران
• فرض نماز کے بعد''',
        'hindi': '''
**हाजत की नमाज़**

**कब:** जब भी आपकी अल्लाह से कोई ख़ास ज़रूरत या ख़्वाहिश हो।

**हैसियत:** मुस्तहब

**रकात:** 2 रकात (कुछ रिवायतों में 12 तक का ज़िक्र है)

**नमाज़ पढ़ने का तरीक़ा:**
1. तवज्जोह से अच्छी तरह वुज़ू करें
2. 2 रकात नफ़्ल पढ़ें
3. सलाम के बाद अल्लाह की हम्द करें
4. नबी ﷺ पर दुरूद भेजें
5. ख़ुलूस से अपनी मख़सूस दुआ मांगें

**नमाज़ के बाद दुआ:**
"ला इलाहा इल्लल्लाहुल हलीमुल करीम सुब्हानल्लाहि रब्बिल अर्शिल अज़ीम अलहम्दुलिल्लाहि रब्बिल आलमीन अस्अलुका मूजिबाति रहमतिका व अज़ायिमा मग़फ़िरतिका वल ग़नीमता मिन कुल्लि बिर्रिन वस्सलामता मिन कुल्लि इस्मिन ला तदअ ली ज़न्बन इल्ला ग़फ़र्तहू व ला हम्मन इल्ला फ़र्रज्तहू व ला हाजतन हिया लका रिज़न इल्ला क़ज़ैतहा या अरहमर्राहिमीन"

**तर्जुमा:**
"अल्लाह के सिवा कोई माबूद नहीं, बुर्दबार, करीम। पाक है अल्लाह, अर्श-ए-अज़ीम का रब। तमाम तारीफ़ अल्लाह के लिए जो तमाम जहानों का रब है। मैं तुझसे वो सब मांगता हूं जो तेरी रहमत लाए, और जो तेरी मग़फ़िरत का सबब बने, हर नेकी से फ़ायदा और हर गुनाह से सलामती। मेरा कोई गुनाह न छोड़ मगर माफ़ कर दे, कोई परेशानी न छोड़ मगर दूर कर दे, कोई ज़रूरत जो तेरी रज़ा हो न छोड़ मगर पूरी कर दे, ऐ सबसे ज़्यादा रहम करने वाले।"

**क़बूलियत के लिए मश्वरे:**
• मुकम्मल ख़ुलूस से पढ़ें
• पुख़्ता यक़ीन रखें अल्लाह जवाब देगा
• सब्र करें - अल्लाह अपने वक़्त पर जवाब देता है
• यक़ीनी बनाएं आमदनी हलाल है
• कोई हराम चीज़ न मांगें
• मांगते रहें

**बेहतरीन औक़ात:**
• रात का आख़िरी तिहाई
• अज़ान और इक़ामत के दरमियान
• रोज़े की हालत में
• बारिश के दौरान
• फ़र्ज़ नमाज़ के बाद'''
      }
    },
    {
      'title': 'Istikhara Prayer',
      'titleUrdu': 'نماز استخارہ',
      'titleHindi': 'इस्तिख़ारा की नमाज़',
      'rakats': '2 Rakats',
      'rakatsUrdu': '۲ رکعت',
      'rakatsHindi': '2 रकात',
      'time': 'When making important decisions',
      'timeUrdu': 'اہم فیصلے کرتے وقت',
      'timeHindi': 'अहम फ़ैसले करते वक़्त',
      'icon': Icons.help_outline,
      'color': Colors.cyan,
      'details': {
        'english': '''
**Salat ul-Istikhara (Prayer for Guidance)**

**When:** Before making any important decision - marriage, job, travel, purchase, etc.

**Status:** Sunnah Muakkadah for important matters

**Rakats:** 2 Rakats

**How to Pray:**
1. Make intention for Salat ul-Istikhara
2. Pray 2 rakats of Nafl
3. In 1st rakat after Fatiha: Surah Kafirun (recommended)
4. In 2nd rakat after Fatiha: Surah Ikhlas (recommended)
5. After Salam, recite the Istikhara Dua

**Istikhara Dua:**
"Allahumma inni astakhiruka bi 'ilmika, wa astaqdiruka bi qudratika, wa as'aluka min fadlikal 'azeem. Fa innaka taqdiru wa la aqdiru, wa ta'lamu wa la a'lamu, wa anta 'allamul ghuyub.

Allahumma in kunta ta'lamu anna hadhal amra (mention your matter) khayrun li fi deeni wa ma'ashi wa 'aqibati amri - or he said: 'ajili amri wa ajilihi - faqdurhu li wa yassirhu li thumma barik li fihi.

Wa in kunta ta'lamu anna hadhal amra sharrun li fi deeni wa ma'ashi wa 'aqibati amri - or he said: 'ajili amri wa ajilihi - fasrifhu 'anni wasrifni 'anhu, waqdur liyal khayra haythu kana, thumma ardini bihi."

**Translation:**
"O Allah, I seek Your guidance by Your knowledge, and I seek ability by Your power, and I ask You of Your great bounty. You are capable while I am not, You know while I do not, and You are the Knower of hidden things.

O Allah, if You know that this matter (mention it) is good for me in my religion, my livelihood and my affairs - or he said: in the short term and long term - then ordain it for me, make it easy for me, and bless it for me.

And if You know that this matter is bad for me in my religion, my livelihood and my affairs - or: in the short term and long term - then turn it away from me and turn me away from it, and ordain for me the good wherever it may be, and make me content with it."

**Important Points:**
• Can repeat Istikhara for 7 days if needed
• Don't expect dreams - guidance comes through inclination
• Act on what feels right after praying
• If still unsure, consult knowledgeable people
• Trust in Allah's decision

**Signs of Guidance:**
• Feeling of ease or peace about a decision
• Doors opening or closing naturally
• Advice from trustworthy people aligning
• Events unfolding in a particular direction''',
        'urdu': '''
**نماز استخارہ**

**کب:** کوئی اہم فیصلہ کرنے سے پہلے - شادی، نوکری، سفر، خریداری وغیرہ۔

**حیثیت:** اہم معاملات کے لیے سنت مؤکدہ

**رکعات:** ۲ رکعت

**نماز پڑھنے کا طریقہ:**
۱. صلاۃ الاستخارہ کی نیت کریں
۲. ۲ رکعت نفل پڑھیں
۳. پہلی رکعت میں فاتحہ کے بعد: سورۃ الکافرون (مستحب)
۴. دوسری رکعت میں فاتحہ کے بعد: سورۃ الاخلاص (مستحب)
۵. سلام کے بعد استخارہ کی دعا پڑھیں

**استخارہ کی دعا:**
"اللهم إني أستخيرك بعلمك وأستقدرك بقدرتك وأسألك من فضلك العظيم فإنك تقدر ولا أقدر وتعلم ولا أعلم وأنت علام الغيوب

اللهم إن كنت تعلم أن هذا الأمر (اپنا معاملہ بتائیں) خير لي في ديني ومعاشي وعاقبة أمري أو قال عاجل أمري وآجله فاقدره لي ويسره لي ثم بارك لي فيه

وإن كنت تعلم أن هذا الأمر شر لي في ديني ومعاشي وعاقبة أمري أو قال عاجل أمري وآجله فاصرفه عني واصرفني عنه واقدر لي الخير حيث كان ثم أرضني به"

**ترجمہ:**
"اے اللہ میں تیرے علم سے تجھ سے رہنمائی چاہتا ہوں، تیری قدرت سے طاقت چاہتا ہوں، اور تیرے بڑے فضل سے مانگتا ہوں۔ تو قادر ہے اور میں نہیں، تو جانتا ہے اور میں نہیں، اور تو غیب کا جاننے والا ہے۔

اے اللہ اگر تو جانتا ہے کہ یہ معاملہ میرے دین، معاش اور انجام کے لیے بہتر ہے - یا فوری اور دور کے لیے - تو اسے میرے لیے مقدر کر، آسان کر، پھر اس میں برکت دے۔

اور اگر تو جانتا ہے کہ یہ معاملہ میرے دین، معاش اور انجام کے لیے برا ہے - یا فوری اور دور کے لیے - تو اسے مجھ سے پھیر دے اور مجھے اس سے پھیر دے، اور جہاں بھی خیر ہو میرے لیے مقدر کر، پھر مجھے اس پر راضی کر۔"

**اہم باتیں:**
• ضرورت ہو تو ۷ دن تک دہرا سکتے ہیں
• خواب کا انتظار نہ کریں - رہنمائی دلی میلان سے آتی ہے
• نماز کے بعد جو صحیح لگے اس پر عمل کریں
• ابھی بھی یقین نہ ہو تو علماء سے مشورہ کریں
• اللہ کے فیصلے پر بھروسہ کریں

**رہنمائی کی نشانیاں:**
• کسی فیصلے کے بارے میں آسانی یا سکون کا احساس
• دروازے قدرتی طور پر کھلنا یا بند ہونا
• قابل اعتماد لوگوں کا مشورہ ہم آہنگ ہونا
• واقعات کا کسی خاص سمت میں ہونا''',
        'hindi': '''
**इस्तिख़ारा की नमाज़**

**कब:** कोई अहम फ़ैसला करने से पहले - शादी, नौकरी, सफ़र, ख़रीदारी वग़ैरह।

**हैसियत:** अहम मामलों के लिए सुन्नत मुअक्कदा

**रकात:** 2 रकात

**नमाज़ पढ़ने का तरीक़ा:**
1. सलातुल इस्तिख़ारा की नीयत करें
2. 2 रकात नफ़्ल पढ़ें
3. पहली रकात में फ़ातिहा के बाद: सूरह अल-काफ़िरून (मुस्तहब)
4. दूसरी रकात में फ़ातिहा के बाद: सूरह अल-इख़लास (मुस्तहब)
5. सलाम के बाद इस्तिख़ारा की दुआ पढ़ें

**इस्तिख़ारा की दुआ:**
"अल्लाहुम्मा इन्नी अस्तख़ीरुका बि इल्मिका व अस्तक़्दिरुका बि क़ुदरतिका व अस्अलुका मिन फ़ज़्लिकल अज़ीम फ़इन्नका तक़्दिरु व ला अक़्दिरु व तालमु व ला आलमु व अन्ता अल्लामुल ग़ुयूब

अल्लाहुम्मा इन कुन्ता तालमु अन्ना हाज़ल अम्र (अपना मामला बताएं) ख़ैरुन ली फ़ी दीनी व मआशी व आक़िबति अम्री औ क़ाला आजिलि अम्री व आजिलिही फ़क़्दुर्हू ली व यस्सिर्हू ली सुम्मा बारिक ली फ़ीहि

व इन कुन्ता तालमु अन्ना हाज़ल अम्र शर्रुन ली फ़ी दीनी व मआशी व आक़िबति अम्री औ क़ाला आजिलि अम्री व आजिलिही फ़स्रिफ़्हू अन्नी वस्रिफ़्नी अन्हू वक़्दुर लियल ख़ैरा हैसु काना सुम्मा अर्ज़िनी बिही"

**तर्जुमा:**
"ऐ अल्लाह मैं तेरे इल्म से तुझसे रहनुमाई चाहता हूं, तेरी क़ुदरत से ताक़त चाहता हूं, और तेरे बड़े फ़ज़्ल से मांगता हूं। तू क़ादिर है और मैं नहीं, तू जानता है और मैं नहीं, और तू ग़ैब का जानने वाला है।

ऐ अल्लाह अगर तू जानता है कि यह मामला मेरे दीन, मआश और अंजाम के लिए बेहतर है - या फ़ौरी और दूर के लिए - तो इसे मेरे लिए मुक़द्दर कर, आसान कर, फिर इसमें बरकत दे।

और अगर तू जानता है कि यह मामला मेरे दीन, मआश और अंजाम के लिए बुरा है - या फ़ौरी और दूर के लिए - तो इसे मुझसे फेर दे और मुझे इससे फेर दे, और जहां भी ख़ैर हो मेरे लिए मुक़द्दर कर, फिर मुझे उस पर राज़ी कर।"

**अहम बातें:**
• ज़रूरत हो तो 7 दिन तक दोहरा सकते हैं
• ख़्वाब का इंतिज़ार न करें - रहनुमाई दिली मैलान से आती है
• नमाज़ के बाद जो सही लगे उस पर अमल करें
• अभी भी यक़ीन न हो तो उलमा से मश्वरा करें
• अल्लाह के फ़ैसले पर भरोसा करें

**रहनुमाई की निशानियां:**
• किसी फ़ैसले के बारे में आसानी या सुकून का एहसास
• दरवाज़े क़ुदरती तौर पर खुलना या बंद होना
• क़ाबिल-ए-एतिमाद लोगों का मश्वरा हम-आहंग होना
• वाक़िआत का किसी ख़ास सिम्त में होना'''
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenBorder = Color(0xFF8AAF9A);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(_selectedLanguage == 'urdu'
            ? 'نماز کا مکمل طریقہ'
            : _selectedLanguage == 'hindi'
                ? 'नमाज़ का मुकम्मल तरीक़ा'
                : 'Complete Namaz Guide'),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedLanguage == 'urdu' ? 'اردو' : _selectedLanguage == 'hindi' ? 'हिंदी' : 'EN',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
            onSelected: (value) => setState(() => _selectedLanguage = value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'english',
                child: Row(
                  children: [
                    if (_selectedLanguage == 'english') Icon(Icons.check, color: AppColors.primary, size: 18) else const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text('English', style: TextStyle(fontWeight: _selectedLanguage == 'english' ? FontWeight.bold : FontWeight.normal, color: _selectedLanguage == 'english' ? AppColors.primary : null)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'urdu',
                child: Row(
                  children: [
                    if (_selectedLanguage == 'urdu') Icon(Icons.check, color: AppColors.primary, size: 18) else const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text('اردو', style: TextStyle(fontWeight: _selectedLanguage == 'urdu' ? FontWeight.bold : FontWeight.normal, color: _selectedLanguage == 'urdu' ? AppColors.primary : null)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hindi',
                child: Row(
                  children: [
                    if (_selectedLanguage == 'hindi') Icon(Icons.check, color: AppColors.primary, size: 18) else const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text('हिंदी', style: TextStyle(fontWeight: _selectedLanguage == 'hindi' ? FontWeight.bold : FontWeight.normal, color: _selectedLanguage == 'hindi' ? AppColors.primary : null)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _namazCategories.length,
        itemBuilder: (context, index) {
          final namaz = _namazCategories[index];
          return _buildNamazCard(namaz, isDark, darkGreen, lightGreenBorder, index);
        },
      ),
    );
  }

  Widget _buildNamazCard(Map<String, dynamic> namaz, bool isDark, Color darkGreen, Color lightGreenBorder, int index) {
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);

    final title = _selectedLanguage == 'urdu'
        ? namaz['titleUrdu']
        : _selectedLanguage == 'hindi'
            ? namaz['titleHindi']
            : namaz['title'];
    final rakats = _selectedLanguage == 'urdu'
        ? namaz['rakatsUrdu']
        : _selectedLanguage == 'hindi'
            ? namaz['rakatsHindi']
            : namaz['rakats'];
    final time = _selectedLanguage == 'urdu'
        ? namaz['timeUrdu']
        : _selectedLanguage == 'hindi'
            ? namaz['timeHindi']
            : namaz['time'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.grey.shade800 : lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: isDark ? 0.05 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showNamazDetails(namaz, isDark),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Number Circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: namaz['color'] as Color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (namaz['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    namaz['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? emeraldGreen.withValues(alpha: 0.2) : lightGreenChip,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.green.shade300 : emeraldGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rakats,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? emeraldGreen.withValues(alpha: 0.3) : emeraldGreen,
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

  void _showNamazDetails(Map<String, dynamic> namaz, bool isDark) {
    final details = namaz['details'] as Map<String, String>;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: namaz['title'],
          titleUrdu: namaz['titleUrdu'] ?? '',
          titleHindi: namaz['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: namaz['color'] as Color,
          icon: namaz['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Namaz',
        ),
      ),
    );
  }
}

