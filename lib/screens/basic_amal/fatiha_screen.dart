import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class FatihaScreen extends StatefulWidget {
  const FatihaScreen({super.key});

  @override
  State<FatihaScreen> createState() => _FatihaScreenState();
}

class _FatihaScreenState extends State<FatihaScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Fatiha - Complete Guide',
    'urdu': 'فاتحہ کا طریقہ - مکمل رہنمائی',
    'hindi': 'फातिहा का तरीका - संपूर्ण मार्गदर्शन',
  };

  final List<Map<String, dynamic>> _fatihaTypes = [
    {
      'title': 'Fatiha for Deceased',
      'titleUrdu': 'مرحوم کے لیے فاتحہ',
      'titleHindi': 'मरहूम के लिए फातिहा',
      'icon': Icons.favorite,
      'color': Colors.purple,
      'details': {
        'english': '''Fatiha for Deceased (Isal-e-Sawab)

This is performed to send blessings to deceased loved ones.

Items Needed (Optional):
• Dates, sweets, or any halal food
• Clean cloth to cover the food
• Rose water or attar (optional)

Step-by-Step Method:

1. Make Intention (Niyyah):
"I am performing this Fatiha for the Isal-e-Sawab of (name of deceased)."

2. Recite Durood Shareef (3 times):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"
"Allahumma salli ala Muhammadin wa ala aali Muhammad"

3. Recite Surah Al-Fatiha (1 time):
"بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
الرَّحْمَٰنِ الرَّحِيمِ
مَالِكِ يَوْمِ الدِّينِ
إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ
صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ"

4. Recite Surah Al-Ikhlas (3 times):
"قُلْ هُوَ اللَّهُ أَحَدٌ
اللَّهُ الصَّمَدُ
لَمْ يَلِدْ وَلَمْ يُولَدْ
وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ"

5. Recite Durood Shareef again (3 times)

6. Make Dua:
"Ya Allah, accept this recitation and send its reward to (name). Forgive their sins, elevate their status in Jannah, and grant them mercy."

7. Blow gently on the food (if present)

8. Distribute the food to family and the needy''',
        'urdu': '''مرحوم کے لیے فاتحہ (ایصال ثواب)

یہ فوت شدہ پیاروں کو ثواب پہنچانے کے لیے کیا جاتا ہے۔

ضروری چیزیں (اختیاری):
• کھجور، مٹھائی، یا کوئی حلال کھانا
• کھانے کو ڈھانپنے کے لیے صاف کپڑا
• عرق گلاب یا عطر (اختیاری)

طریقہ:

۱۔ نیت کریں:
"میں (مرحوم کا نام) کے ایصال ثواب کے لیے یہ فاتحہ پڑھ رہا/رہی ہوں۔"

۲۔ درود شریف پڑھیں (3 بار):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

۳۔ سورۃ الفاتحہ پڑھیں (1 بار):
"بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
الرَّحْمَٰنِ الرَّحِيمِ
مَالِكِ يَوْمِ الدِّينِ
إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ
صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ"

۴۔ سورۃ الاخلاص پڑھیں (3 بار):
"قُلْ هُوَ اللَّهُ أَحَدٌ
اللَّهُ الصَّمَدُ
لَمْ يَلِدْ وَلَمْ يُولَدْ
وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ"

۵۔ دوبارہ درود شریف پڑھیں (3 بار)

۶۔ دعا کریں:
"یا اللہ! اس تلاوت کو قبول فرما اور اس کا ثواب (نام) کو پہنچا دے۔ ان کے گناہ معاف فرما، جنت میں ان کا درجہ بلند فرما، اور ان پر رحم فرما۔"

۷۔ کھانے پر آہستہ سے دم کریں (اگر موجود ہو)

۸۔ کھانا گھر والوں اور ضرورت مندوں میں تقسیم کریں''',
        'hindi': '''मरहूम के लिए फातिहा (ईसाल-ए-सवाब)

यह मरहूम प्रियजनों को सवाब पहुंचाने के लिए किया जाता है।

ज़रूरी चीज़ें (वैकल्पिक):
• खजूर, मिठाई, या कोई हलाल खाना
• खाने को ढांपने के लिए साफ़ कपड़ा
• अर्क़-ए-गुलाब या इत्र (वैकल्पिक)

तरीक़ा:

१. नीयत करें:
"मैं (मरहूम का नाम) के ईसाल-ए-सवाब के लिए यह फातिहा पढ़ रहा/रही हूं।"

२. दुरूद शरीफ़ पढ़ें (3 बार):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"
"अल्लाहुम्मा सल्लि अला मुहम्मदिन व अला आलि मुहम्मद"

३. सूरह अल-फातिहा पढ़ें (1 बार):
"بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
الرَّحْمَٰنِ الرَّحِيمِ
مَالِكِ يَوْمِ الدِّينِ
إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ
صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ"

४. सूरह अल-इख़्लास पढ़ें (3 बार):
"قُلْ هُوَ اللَّهُ أَحَدٌ
اللَّهُ الصَّمَدُ
لَمْ يَلِدْ وَلَمْ يُولَدْ
وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ"

५. दोबारा दुरूद शरीफ़ पढ़ें (3 बार)

६. दुआ करें:
"या अल्लाह! इस तिलावत को क़बूल फ़रमा और इसका सवाब (नाम) को पहुंचा दे। उनके गुनाह माफ़ फ़रमा, जन्नत में उनका दर्जा बुलंद फ़रमा, और उन पर रहम फ़रमा।"

७. खाने पर आहिस्ता से दम करें (अगर मौजूद हो)

८. खाना घर वालों और ज़रूरतमंदों में तक़सीम करें''',
      },
    },
    {
      'title': 'Gyarhween Shareef',
      'titleUrdu': 'گیارہویں شریف',
      'titleHindi': 'ग्यारहवीं शरीफ़',
      'icon': Icons.star,
      'color': Colors.green,
      'details': {
        'english': '''Gyarhween Shareef (11th of Every Month)

This Fatiha is performed on the 11th of every Islamic month in honor of Hazrat Sheikh Abdul Qadir Jilani (Ghaus-e-Azam) رحمۃ اللہ علیہ.

Preparation:
• Prepare sweet dishes like Kheer, Halwa, or sweets
• Arrange a clean place
• Gather family members if possible

Complete Method:

1. Make Intention (Niyyah):
"I am performing this Gyarhween Shareef for the Isal-e-Sawab of Hazrat Ghaus-e-Azam Sheikh Abdul Qadir Jilani رحمۃ اللہ علیہ."

2. Recite Durood Shareef (11 times):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

3. Recite Surah Al-Fatiha (1 time)

4. Recite Surah Al-Ikhlas (11 times)

5. Recite Durood Shareef again (11 times)

6. Make Dua:
"Ya Allah, accept this recitation. Send its reward to Your beloved Prophet Muhammad ﷺ, to Hazrat Ghaus-e-Azam Sheikh Abdul Qadir Jilani رحمۃ اللہ علیہ, and to all the Awliya and Salihin."

"Ya Ghaus-e-Azam! We seek your spiritual attention (Tawajjuh). May Allah bless us through your wasila."

7. Blow on the food

8. Distribute the food (Niyaz)

Virtues:
• Blessings from the Wali Allah
• Spiritual connection with the Awliya
• Rewards sent to the deceased
• Barakah in the home''',
        'urdu': '''گیارہویں شریف (ہر ماہ کی 11 تاریخ)

یہ فاتحہ ہر اسلامی مہینے کی 11 تاریخ کو حضرت شیخ عبدالقادر جیلانی (غوث اعظم) رحمۃ اللہ علیہ کے ایصال ثواب کے لیے کی جاتی ہے۔

تیاری:
• کھیر، حلوہ یا مٹھائی جیسی میٹھی چیزیں تیار کریں
• صاف جگہ کا انتظام کریں
• اگر ممکن ہو تو گھر والوں کو جمع کریں

مکمل طریقہ:

۱۔ نیت کریں:
"میں حضرت غوث اعظم شیخ عبدالقادر جیلانی رحمۃ اللہ علیہ کے ایصال ثواب کے لیے یہ گیارہویں شریف پڑھ رہا/رہی ہوں۔"

۲۔ درود شریف پڑھیں (11 بار):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

۳۔ سورۃ الفاتحہ پڑھیں (1 بار)

۴۔ سورۃ الاخلاص پڑھیں (11 بار)

۵۔ دوبارہ درود شریف پڑھیں (11 بار)

۶۔ دعا کریں:
"یا اللہ! اس تلاوت کو قبول فرما۔ اس کا ثواب اپنے محبوب نبی محمد ﷺ کو، حضرت غوث اعظم شیخ عبدالقادر جیلانی رحمۃ اللہ علیہ کو، اور تمام اولیاء و صالحین کو پہنچا۔"

"یا غوث اعظم! ہم آپ کی توجہ کے طالب ہیں۔ اللہ ہمیں آپ کے وسیلے سے برکت عطا فرمائے۔"

۷۔ کھانے پر دم کریں

۸۔ کھانا (نیاز) تقسیم کریں

فضائل:
• ولی اللہ کی برکات
• اولیاء کے ساتھ روحانی تعلق
• فوت شدگان کو ثواب
• گھر میں برکت''',
        'hindi': '''ग्यारहवीं शरीफ़ (हर महीने की 11 तारीख़)

यह फातिहा हर इस्लामी महीने की 11 तारीख़ को हज़रत शेख़ अब्दुल क़ादिर जीलानी (ग़ौस-ए-आज़म) रहमतुल्लाह अलैह के ईसाल-ए-सवाब के लिए की जाती है।

तैयारी:
• खीर, हलवा या मिठाई जैसी मीठी चीज़ें तैयार करें
• साफ़ जगह का इंतेज़ाम करें
• अगर मुमकिन हो तो घर वालों को जमा करें

मुकम्मल तरीक़ा:

१. नीयत करें:
"मैं हज़रत ग़ौस-ए-आज़म शेख़ अब्दुल क़ादिर जीलानी रहमतुल्लाह अलैह के ईसाल-ए-सवाब के लिए यह ग्यारहवीं शरीफ़ पढ़ रहा/रही हूं।"

२. दुरूद शरीफ़ पढ़ें (11 बार):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

३. सूरह अल-फातिहा पढ़ें (1 बार)

४. सूरह अल-इख़्लास पढ़ें (11 बार)

५. दोबारा दुरूद शरीफ़ पढ़ें (11 बार)

६. दुआ करें:
"या अल्लाह! इस तिलावत को क़बूल फ़रमा। इसका सवाब अपने महबूब नबी मुहम्मद ﷺ को, हज़रत ग़ौस-ए-आज़म शेख़ अब्दुल क़ादिर जीलानी रहमतुल्लाह अलैह को, और तमाम औलिया व सालिहीन को पहुंचा।"

"या ग़ौस-ए-आज़म! हम आपकी तवज्जुह के तालिब हैं। अल्लाह हमें आपके वसीले से बरकत अता फ़रमाए।"

७. खाने पर दम करें

८. खाना (नियाज़) तक़सीम करें

फ़ज़ाइल:
• वली अल्लाह की बरकात
• औलिया के साथ रूहानी ताल्लुक़
• मरहूमीन को सवाब
• घर में बरकत''',
      },
    },
    {
      'title': 'Fatiha on Thursday',
      'titleUrdu': 'جمعرات کی فاتحہ',
      'titleHindi': 'जुमेरात की फातिहा',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
      'details': {
        'english': '''Fatiha on Thursday (Jumeraat Ki Fatiha)

Thursday is considered an auspicious day for performing Fatiha as it precedes the blessed day of Friday (Jumu'ah).

Why Thursday?
• Thursday leads into the night of Jumu'ah (the most blessed night of the week)
• The souls of the deceased are said to visit their families
• Extra rewards are gained during this time

Complete Method:

1. After Maghrib or Isha Prayer:
Sit in a clean place facing the Qibla

2. Make Intention (Niyyah):
"I am performing this Fatiha for my deceased parents, grandparents, and all relatives."

3. Recite Durood Shareef (3 times)

4. Recite Surah Al-Fatiha (7 times)

5. Recite Surah Al-Ikhlas (11 times)

6. Recite Ayatul Kursi (1 time):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."

7. Recite Durood Shareef (3 times)

8. Make Dua:
"Ya Allah, I have recited Your Quran and sent Durood upon Your Prophet ﷺ. Please accept this and send its reward to my parents (names), grandparents, and all my deceased relatives. Forgive them, have mercy on them, and grant them high ranks in Jannah."

9. If food is prepared, blow on it and distribute

Special Additions for Thursday:
• Light an incense (Agarbatti) - optional, not mandatory
• Recite Surah Yaseen if time permits
• Make extra dua for parents''',
        'urdu': '''جمعرات کی فاتحہ

جمعرات کو فاتحہ کے لیے مبارک دن سمجھا جاتا ہے کیونکہ یہ جمعہ کے مبارک دن سے پہلے آتا ہے۔

جمعرات کیوں؟
• جمعرات جمعہ کی رات (ہفتے کی سب سے مبارک رات) میں داخل ہوتا ہے
• کہا جاتا ہے کہ فوت شدگان کی روحیں اپنے گھر والوں سے ملنے آتی ہیں
• اس وقت اضافی ثواب ملتا ہے

مکمل طریقہ:

۱۔ مغرب یا عشاء کی نماز کے بعد:
قبلہ رخ صاف جگہ بیٹھیں

۲۔ نیت کریں:
"میں اپنے فوت شدہ والدین، دادا دادی / نانا نانی، اور تمام رشتہ داروں کے لیے یہ فاتحہ پڑھ رہا/رہی ہوں۔"

۳۔ درود شریف پڑھیں (3 بار)

۴۔ سورۃ الفاتحہ پڑھیں (7 بار)

۵۔ سورۃ الاخلاص پڑھیں (11 بار)

۶۔ آیت الکرسی پڑھیں (1 بار):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."

۷۔ درود شریف پڑھیں (3 بار)

۸۔ دعا کریں:
"یا اللہ! میں نے تیرا قرآن پڑھا اور تیرے نبی ﷺ پر درود بھیجا۔ براہ کرم اسے قبول فرما اور اس کا ثواب میرے والدین (نام)، دادا دادی / نانا نانی، اور میرے تمام فوت شدہ رشتہ داروں کو پہنچا دے۔ انہیں بخش دے، ان پر رحم فرما، اور جنت میں ان کے درجات بلند فرما۔"

۹۔ اگر کھانا تیار ہو تو اس پر دم کریں اور تقسیم کریں

جمعرات کے لیے خاص اضافے:
• اگربتی جلائیں - اختیاری، ضروری نہیں
• اگر وقت ہو تو سورۃ یٰسین پڑھیں
• والدین کے لیے خصوصی دعا کریں''',
        'hindi': '''जुमेरात की फातिहा

जुमेरात को फातिहा के लिए मुबारक दिन माना जाता है क्योंकि यह जुमा के मुबारक दिन से पहले आता है।

जुमेरात क्यों?
• जुमेरात जुमा की रात (हफ़्ते की सबसे मुबारक रात) में दाख़िल होता है
• कहा जाता है कि मरहूमीन की रूहें अपने घर वालों से मिलने आती हैं
• इस वक़्त ज़्यादा सवाब मिलता है

मुकम्मल तरीक़ा:

१. मग़रिब या इशा की नमाज़ के बाद:
क़िबला रुख़ साफ़ जगह बैठें

२. नीयत करें:
"मैं अपने मरहूम वालिदैन, दादा-दादी / नाना-नानी, और तमाम रिश्तेदारों के लिए यह फातिहा पढ़ रहा/रही हूं।"

३. दुरूद शरीफ़ पढ़ें (3 बार)

४. सूरह अल-फातिहा पढ़ें (7 बार)

५. सूरह अल-इख़्लास पढ़ें (11 बार)

६. आयतुल कुर्सी पढ़ें (1 बार):
"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ..."

७. दुरूद शरीफ़ पढ़ें (3 बार)

८. दुआ करें:
"या अल्लाह! मैंने तेरा क़ुरआन पढ़ा और तेरे नबी ﷺ पर दुरूद भेजा। बराह-ए-करम इसे क़बूल फ़रमा और इसका सवाब मेरे वालिदैन (नाम), दादा-दादी / नाना-नानी, और मेरे तमाम मरहूम रिश्तेदारों को पहुंचा दे। उन्हें बख़्श दे, उन पर रहम फ़रमा, और जन्नत में उनके दर्जात बुलंद फ़रमा।"

९. अगर खाना तैयार हो तो उस पर दम करें और तक़सीम करें

जुमेरात के लिए ख़ास इज़ाफ़े:
• अगरबत्ती जलाएं - वैकल्पिक, ज़रूरी नहीं
• अगर वक़्त हो तो सूरह यासीन पढ़ें
• वालिदैन के लिए ख़ुसूसी दुआ करें''',
      },
    },
    {
      'title': 'Urs/Death Anniversary',
      'titleUrdu': 'عرس / برسی',
      'titleHindi': 'उर्स / बरसी',
      'icon': Icons.event,
      'color': Colors.orange,
      'details': {
        'english': '''Urs/Death Anniversary Fatiha

Urs (عرس) is the annual commemoration of a saint's death, while Barsi is the death anniversary of a family member.

Preparation:
• Prepare food (Niaz) - typically Biryani, Halwa, Kheer
• Arrange seating for guests
• Set a clean place for the gathering
• Have dates and water ready

Complete Method:

1. Gather Family/Guests:
Sit in a circle facing the Qibla if possible

2. Begin with Durood Shareef (11 times):
Everyone recites together

3. Recite Surah Al-Fatiha (1 time)

4. Recite Surah Al-Ikhlas (11 times or 100 times)

5. Recite Surah Yaseen (1 time):
"يس وَالْقُرْآنِ الْحَكِيمِ..."
(Complete Surah)

6. Recite Surah Al-Mulk (1 time):
"تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ..."
(Complete Surah)

7. Recite Durood Shareef (11 times)

8. Make Collective Dua:
"Ya Allah, we have gathered here to remember (name) on their death anniversary. Accept our recitations and send the rewards to their soul. Forgive their sins, grant them the highest place in Jannatul Firdaus, and have mercy on them. Also send rewards to all our deceased relatives and all Muslims who have passed away."

9. Distribute Food:
• First serve the elders
• Then serve all guests
• Send portions to neighbors and the needy

Special Additions for Urs of Saints:
• Recite the saint's manaqib (virtues)
• Share stories of their piety
• Make dua through their wasila (intercession)''',
        'urdu': '''عرس / برسی کی فاتحہ

عرس کسی ولی کی وفات کی سالانہ یادگار ہے، جبکہ برسی خاندان کے کسی فرد کی وفات کی سالگرہ ہے۔

تیاری:
• کھانا (نیاز) تیار کریں - عموماً بریانی، حلوہ، کھیر
• مہمانوں کے بیٹھنے کا انتظام کریں
• اجتماع کے لیے صاف جگہ رکھیں
• کھجور اور پانی تیار رکھیں

مکمل طریقہ:

۱۔ گھر والوں/مہمانوں کو جمع کریں:
اگر ممکن ہو تو قبلہ رخ گول دائرے میں بیٹھیں

۲۔ درود شریف سے شروع کریں (11 بار):
سب مل کر پڑھیں

۳۔ سورۃ الفاتحہ پڑھیں (1 بار)

۴۔ سورۃ الاخلاص پڑھیں (11 بار یا 100 بار)

۵۔ سورۃ یٰسین پڑھیں (1 بار):
"يس وَالْقُرْآنِ الْحَكِيمِ..."
(مکمل سورہ)

۶۔ سورۃ الملک پڑھیں (1 بار):
"تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ..."
(مکمل سورہ)

۷۔ درود شریف پڑھیں (11 بار)

۸۔ اجتماعی دعا کریں:
"یا اللہ! ہم یہاں (نام) کو ان کی برسی پر یاد کرنے کے لیے جمع ہوئے ہیں۔ ہماری تلاوت قبول فرما اور اس کا ثواب ان کی روح کو پہنچا دے۔ ان کے گناہ معاف فرما، انہیں جنت الفردوس میں اعلیٰ مقام عطا فرما، اور ان پر رحم فرما۔ ہمارے تمام فوت شدہ رشتہ داروں اور تمام فوت شدہ مسلمانوں کو بھی ثواب پہنچا۔"

۹۔ کھانا تقسیم کریں:
• پہلے بزرگوں کو دیں
• پھر تمام مہمانوں کو دیں
• پڑوسیوں اور ضرورت مندوں کو بھیجیں

اولیاء کے عرس کے لیے خاص اضافے:
• ولی کے مناقب پڑھیں
• ان کی پرہیزگاری کے قصے سنائیں
• ان کے وسیلے سے دعا کریں''',
        'hindi': '''उर्स / बरसी की फातिहा

उर्स किसी वली की वफ़ात की सालाना यादगार है, जबकि बरसी ख़ानदान के किसी फ़र्द की वफ़ात की सालगिरह है।

तैयारी:
• खाना (नियाज़) तैयार करें - आम तौर पर बिरयानी, हलवा, खीर
• मेहमानों के बैठने का इंतेज़ाम करें
• इजतिमा के लिए साफ़ जगह रखें
• खजूर और पानी तैयार रखें

मुकम्मल तरीक़ा:

१. घर वालों/मेहमानों को जमा करें:
अगर मुमकिन हो तो क़िबला रुख़ गोल दायरे में बैठें

२. दुरूद शरीफ़ से शुरू करें (11 बार):
सब मिलकर पढ़ें

३. सूरह अल-फातिहा पढ़ें (1 बार)

४. सूरह अल-इख़्लास पढ़ें (11 बार या 100 बार)

५. सूरह यासीन पढ़ें (1 बार):
"يس وَالْقُرْآنِ الْحَكِيمِ..."
(मुकम्मल सूरह)

६. सूरह अल-मुल्क पढ़ें (1 बार):
"تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ..."
(मुकम्मल सूरह)

७. दुरूद शरीफ़ पढ़ें (11 बार)

८. इजतिमाई दुआ करें:
"या अल्लाह! हम यहां (नाम) को उनकी बरसी पर याद करने के लिए जमा हुए हैं। हमारी तिलावत क़बूल फ़रमा और इसका सवाब उनकी रूह को पहुंचा दे। उनके गुनाह माफ़ फ़रमा, उन्हें जन्नतुल फ़िरदौस में आला मक़ाम अता फ़रमा, और उन पर रहम फ़रमा। हमारे तमाम मरहूम रिश्तेदारों और तमाम मरहूम मुसलमानों को भी सवाब पहुंचा।"

९. खाना तक़सीम करें:
• पहले बुज़ुर्गों को दें
• फिर तमाम मेहमानों को दें
• पड़ोसियों और ज़रूरतमंदों को भेजें

औलिया के उर्स के लिए ख़ास इज़ाफ़े:
• वली के मनाक़िब पढ़ें
• उनकी परहेज़गारी के क़िस्से सुनाएं
• उनके वसीले से दुआ करें''',
      },
    },
    {
      'title': 'Khatam-e-Quran Fatiha',
      'titleUrdu': 'ختم قرآن کی فاتحہ',
      'titleHindi': 'ख़तम-ए-क़ुरआन की फातिहा',
      'icon': Icons.menu_book,
      'color': Colors.teal,
      'details': {
        'english': '''Khatam-e-Quran Fatiha

This is performed after completing the recitation of the entire Quran.

When to Perform:
• After completing Quran recitation
• Can be done individually or collectively
• Often done in Ramadan after Taraweeh

Complete Method:

1. After Completing the Quran:
Make intention that you are completing this for the pleasure of Allah and for Isal-e-Sawab

2. Recite Durood Shareef (3 times)

3. Make Dua for Khatam-e-Quran:
"اللَّهُمَّ ارْحَمْنِي بِالقُرْآنِ وَاجْعَلْهُ لِي إِمَامًا وَنُورًا وَهُدًى وَرَحْمَةً"
"O Allah, have mercy on me through the Quran, and make it for me a leader, a light, guidance, and mercy."

"اللَّهُمَّ ذَكِّرْنِي مِنْهُ مَا نَسِيتُ وَعَلِّمْنِي مِنْهُ مَا جَهِلْتُ"
"O Allah, remind me of what I have forgotten of it, and teach me from it what I do not know."

4. Recite Surah Al-Fatiha (1 time)

5. Recite the beginning of Surah Al-Baqarah (first 5 verses):
"الم ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ..."
(This connects the end to the beginning, symbolizing continuous recitation)

6. Recite Surah Al-Ikhlas (3 times)

7. Recite Durood Shareef (3 times)

8. Make Comprehensive Dua:
• For yourself and family
• For the Ummah
• For the deceased
• Send rewards to Prophet ﷺ and his family

9. If food is prepared, blow on it and distribute

Virtues:
• Angels make dua for the person who completes Quran
• Great rewards are written
• Intercession of Quran on Day of Judgment''',
        'urdu': '''ختم قرآن کی فاتحہ

یہ پورے قرآن کی تلاوت مکمل کرنے کے بعد کی جاتی ہے۔

کب کریں:
• قرآن کی تلاوت مکمل کرنے کے بعد
• انفرادی یا اجتماعی طور پر کر سکتے ہیں
• اکثر رمضان میں تراویح کے بعد کی جاتی ہے

مکمل طریقہ:

۱۔ قرآن مکمل کرنے کے بعد:
نیت کریں کہ آپ اللہ کی رضا اور ایصال ثواب کے لیے ختم کر رہے ہیں

۲۔ درود شریف پڑھیں (3 بار)

۳۔ ختم قرآن کی دعا پڑھیں:
"اللَّهُمَّ ارْحَمْنِي بِالقُرْآنِ وَاجْعَلْهُ لِي إِمَامًا وَنُورًا وَهُدًى وَرَحْمَةً"
"اے اللہ! قرآن کے ذریعے مجھ پر رحم فرما، اور اسے میرے لیے امام، نور، ہدایت اور رحمت بنا دے۔"

"اللَّهُمَّ ذَكِّرْنِي مِنْهُ مَا نَسِيتُ وَعَلِّمْنِي مِنْهُ مَا جَهِلْتُ"
"اے اللہ! اس میں سے جو میں بھول گیا ہوں وہ مجھے یاد دلا، اور جو میں نہیں جانتا وہ مجھے سکھا۔"

۴۔ سورۃ الفاتحہ پڑھیں (1 بار)

۵۔ سورۃ البقرہ کی ابتداء پڑھیں (پہلی 5 آیات):
"الم ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ..."
(یہ آخر کو شروع سے جوڑتا ہے، مسلسل تلاوت کی علامت)

۶۔ سورۃ الاخلاص پڑھیں (3 بار)

۷۔ درود شریف پڑھیں (3 بار)

۸۔ جامع دعا کریں:
• اپنے اور خاندان کے لیے
• امت کے لیے
• فوت شدگان کے لیے
• نبی ﷺ اور ان کے اہل بیت کو ثواب پہنچائیں

۹۔ اگر کھانا تیار ہو تو اس پر دم کریں اور تقسیم کریں

فضائل:
• قرآن ختم کرنے والے کے لیے فرشتے دعا کرتے ہیں
• عظیم ثواب لکھا جاتا ہے
• قیامت کے دن قرآن کی شفاعت''',
        'hindi': '''ख़तम-ए-क़ुरआन की फातिहा

यह पूरे क़ुरआन की तिलावत मुकम्मल करने के बाद की जाती है।

कब करें:
• क़ुरआन की तिलावत मुकम्मल करने के बाद
• इंफ़िरादी या इजतिमाई तौर पर कर सकते हैं
• अक्सर रमज़ान में तरावीह के बाद की जाती है

मुकम्मल तरीक़ा:

१. क़ुरआन मुकम्मल करने के बाद:
नीयत करें कि आप अल्लाह की रज़ा और ईसाल-ए-सवाब के लिए ख़तम कर रहे हैं

२. दुरूद शरीफ़ पढ़ें (3 बार)

३. ख़तम-ए-क़ुरआन की दुआ पढ़ें:
"اللَّهُمَّ ارْحَمْنِي بِالقُرْآنِ وَاجْعَلْهُ لِي إِمَامًا وَنُورًا وَهُدًى وَرَحْمَةً"
"ऐ अल्लाह! क़ुरआन के ज़रिए मुझ पर रहम फ़रमा, और इसे मेरे लिए इमाम, नूर, हिदायत और रहमत बना दे।"

"اللَّهُمَّ ذَكِّرْنِي مِنْهُ مَا نَسِيتُ وَعَلِّمْنِي مِنْهُ مَا جَهِلْتُ"
"ऐ अल्लाह! इसमें से जो मैं भूल गया हूं वो मुझे याद दिला, और जो मैं नहीं जानता वो मुझे सिखा।"

४. सूरह अल-फातिहा पढ़ें (1 बार)

५. सूरह अल-बक़रा की इब्तिदा पढ़ें (पहली 5 आयात):
"الم ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ..."
(यह आख़िर को शुरू से जोड़ता है, मुसलसल तिलावत की अलामत)

६. सूरह अल-इख़्लास पढ़ें (3 बार)

७. दुरूद शरीफ़ पढ़ें (3 बार)

८. जामे दुआ करें:
• अपने और ख़ानदान के लिए
• उम्मत के लिए
• मरहूमीन के लिए
• नबी ﷺ और उनके अहल-ए-बैत को सवाब पहुंचाएं

९. अगर खाना तैयार हो तो उस पर दम करें और तक़सीम करें

फ़ज़ाइल:
• क़ुरआन ख़तम करने वाले के लिए फ़रिश्ते दुआ करते हैं
• अज़ीम सवाब लिखा जाता है
• क़यामत के दिन क़ुरआन की शफ़ाअत''',
      },
    },
    {
      'title': 'Fatiha After Burial',
      'titleUrdu': 'تدفین کے بعد فاتحہ',
      'titleHindi': 'दफ़न के बाद फातिहा',
      'icon': Icons.landscape,
      'color': Colors.brown,
      'details': {
        'english': '''Fatiha After Burial (Talqeen)

This is performed at the graveside immediately after burial to remind the deceased and send them blessings.

At the Graveside:

1. After the burial is complete, stand at the head of the grave

2. Recite Durood Shareef (3 times)

3. Recite Surah Al-Fatiha (1 time)

4. Recite the beginning of Surah Al-Baqarah (up to Muflihoon):
"الم ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ..."

5. Recite the ending of Surah Al-Baqarah (last 3 verses):
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ..."

6. Recite Surah Al-Ikhlas (3 times)

7. Recite Surah Yaseen (if time permits)

8. Recite Durood Shareef (3 times)

9. Make Dua:
"Ya Allah, make his/her grave spacious and fill it with light. Protect them from the punishment of the grave. Make their questioning easy. Forgive their sins and admit them to Jannatul Firdaus."

"Ya Allah, send patience to their family and reward them for their loss."

Talqeen (Reminder):
Some scholars recommend reciting the Talqeen after burial:
"Ya Abdullah/Amatullah (son/daughter of Allah), remember the covenant you made when you left the world - La ilaha illallah Muhammadur Rasulullah..."

Leaving the Graveyard:
• Make dua for all the deceased in the graveyard
• Walk quietly and respectfully
• Remember death and prepare for the Hereafter''',
        'urdu': '''تدفین کے بعد فاتحہ (تلقین)

یہ تدفین کے فوراً بعد قبر کے پاس کی جاتی ہے تاکہ میت کو یاد دہانی کرائی جائے اور انہیں برکات بھیجی جائیں۔

قبر کے پاس:

۱۔ تدفین مکمل ہونے کے بعد قبر کے سرہانے کھڑے ہوں

۲۔ درود شریف پڑھیں (3 بار)

۳۔ سورۃ الفاتحہ پڑھیں (1 بار)

۴۔ سورۃ البقرہ کی ابتداء پڑھیں (مفلحون تک):
"الم ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ..."

۵۔ سورۃ البقرہ کا آخر پڑھیں (آخری 3 آیات):
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ..."

۶۔ سورۃ الاخلاص پڑھیں (3 بار)

۷۔ سورۃ یٰسین پڑھیں (اگر وقت ہو)

۸۔ درود شریف پڑھیں (3 بار)

۹۔ دعا کریں:
"یا اللہ! ان کی قبر کو کشادہ کر اور اسے نور سے بھر دے۔ انہیں ع��اب قبر سے بچا۔ ان کا سوال جواب آسان فرما۔ ان کے گناہ معاف فرما اور انہیں جنت الفردوس میں داخل فرما۔"

"یا اللہ! ان کے خاندان کو صبر عطا فرما اور ان کے نقصان کا اجر دے۔"

تلقین (یاد دہانی):
بعض علماء تدفین کے بعد تلقین پڑھنے کی تجویز دیتے ہیں:
"یا عبداللہ/امۃ اللہ (اللہ کے بندے/بندی)، وہ عہد یاد رکھو جو تم نے دنیا سے جاتے وقت کیا تھا - لا الہ الا اللہ محمد رسول اللہ..."

قبرستان سے واپسی:
• قبرستان کے تمام فوت شدگان کے لیے دعا کریں
• خاموشی اور احترام سے چلیں
• موت کو یاد رکھیں اور آخرت کی تیاری کریں''',
        'hindi': '''दफ़न के बाद फातिहा (तलक़ीन)

यह दफ़न के फ़ौरन बाद क़ब्र के पास की जाती है ताकि मय्यित को याद दिलाई जाए और उन्हें बरकात भेजी जाएं।

क़ब्र के पास:

१. दफ़न मुकम्मल होने के बाद क़ब्र के सिरहाने खड़े हों

२. दुरूद शरीफ़ पढ़ें (3 बार)

३. सूरह अल-फातिहा पढ़ें (1 बार)

४. सूरह अल-बक़रा की इब्तिदा पढ़ें (मुफ़्लिहून तक):
"الم ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ..."

५. सूरह अल-बक़रा का आख़िर पढ़ें (आख़िरी 3 आयात):
"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ..."

६. सूरह अल-इख़्लास पढ़ें (3 बार)

७. सूरह यासीन पढ़ें (अगर वक़्त हो)

८. दुरूद शरीफ़ पढ़ें (3 बार)

९. दुआ करें:
"या अल्लाह! उनकी क़ब्र को कुशादा कर और उसे नूर से भर दे। उन्हें अज़ाब-ए-क़ब्र से बचा। उनका सवाल-जवाब आसान फ़रमा। उनके गुनाह माफ़ फ़रमा और उन्हें जन्नतुल फ़िरदौस में दाख़िल फ़रमा।"

"या अल्लाह! उनके ख़ानदान को सब्र अता फ़रमा और उनके नुक़सान का अज्र दे।"

तलक़ीन (याद दहानी):
बाज़ उलमा दफ़न के बाद तलक़ीन पढ़ने की तज्वीज़ देते हैं:
"या अब्दुल्लाह/अमतुल्लाह (अल्लाह के बंदे/बंदी), वो अहद याद रखो जो तुमने दुनिया से जाते वक़्त किया था - ला इलाहा इल्लल्लाह मुहम्मदुर रसूलुल्लाह..."

क़ब्रिस्तान से वापसी:
• क़ब्रिस्तान के तमाम मरहूमीन के लिए दुआ करें
• ख़ामोशी और एहतेराम से चलें
• मौत को याद रखें और आख़िरत की तैयारी करें''',
      },
    },
    {
      'title': 'Shab-e-Barat Fatiha',
      'titleUrdu': 'شب برات کی فاتحہ',
      'titleHindi': 'शब-ए-बरात की फातिहा',
      'icon': Icons.nightlight_round,
      'color': const Color(0xFF3F51B5),
      'details': {
        'english': '''Shab-e-Barat Fatiha (15th Shaban Night)

Shab-e-Barat is the night of fortune and forgiveness. Fatiha on this night holds special significance.

Significance:
• The night when Allah descends to the lowest heaven
• Fates for the coming year are written
• Sins are forgiven for those who seek forgiveness
• Souls of the deceased visit their families

Preparation:
• Prepare Halwa, Kheer, or sweets
• Clean the house
• Light candles or lamps (optional)
• Gather family members

Complete Method:

1. After Maghrib Prayer:
Begin the special worship of Shab-e-Barat

2. Recite Durood Shareef (100 times):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

3. Recite Surah Yaseen (3 times):
- First time: For long life with health
- Second time: For protection from calamities
- Third time: For freedom from dependence on others

4. After each Surah Yaseen, recite the Dua of Shab-e-Barat

5. Recite Surah Al-Fatiha (7 times)

6. Recite Surah Al-Ikhlas (100 times or more)

7. Make Dua:
"Ya Allah, if my name is written among the unfortunate, erase it and write it among the fortunate. If my sustenance is limited, expand it. Forgive my sins and the sins of my deceased relatives."

8. Visit the Graveyard (if possible):
• Recite Fatiha for the deceased
• Make dua for all Muslims

9. Blow on the food and distribute

Special Worship:
• Pray Salatul Tasbeeh
• Recite Quran throughout the night
• Make abundant istighfar (seeking forgiveness)''',
        'urdu': '''شب برات کی فاتحہ (15 شعبان کی رات)

شب برات قسمت اور مغفرت کی رات ہے۔ اس رات کی فاتحہ کی خاص اہمیت ہے۔

اہمیت:
• وہ رات جب اللہ آسمان دنیا پر نزول فرماتے ہیں
• آنے والے سال کی تقدیریں لکھی جاتی ہیں
• جو مغفرت مانگیں ان کے گناہ معاف ہوتے ہیں
• فوت شدگان کی روحیں اپنے گھر والوں سے ملنے آتی ہیں

تیاری:
• حلوہ، کھیر یا مٹھائی تیار کریں
• گھر صاف کریں
• موم بتیاں یا چراغ جلائیں (اختیاری)
• گھر والوں کو جمع کریں

مکمل طریقہ:

۱۔ مغرب کی نماز کے بعد:
شب برات کی خاص عبادت شروع کریں

۲۔ درود شریف پڑھیں (100 بار):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

۳۔ سورۃ یٰسین پڑھیں (3 بار):
- پہلی بار: صحت کے ساتھ لمبی عمر کے لیے
- دوسری بار: آفات سے حفاظت کے لیے
- تیسری بار: دوسروں کی محتاجی سے آزادی کے لیے

۴۔ ہر سورۃ یٰسین کے بعد شب برات کی دعا پڑھیں

۵۔ سورۃ الفاتحہ پڑھیں (7 بار)

۶۔ سورۃ الاخلاص پڑھیں (100 بار یا زیادہ)

۷۔ دعا کریں:
"یا اللہ! اگر میرا نام بدبختوں میں لکھا ہے تو اسے مٹا کر نیک بختوں میں لکھ دے۔ اگر میرا رزق کم ہے تو اسے وسیع فرما۔ میرے گناہ اور میرے فوت شدہ رشتہ داروں کے گناہ معاف فرما۔"

۸۔ قبرستان جائیں (اگر ممکن ہو):
• فوت شدگان کے لیے فاتحہ پڑھیں
• تمام مسلمانوں کے لیے دعا کریں

۹۔ کھانے پر دم کریں اور تقسیم کریں

خاص عبادت:
• صلاۃ التسبیح پڑھیں
• رات بھر قرآن پڑھیں
• کثرت سے استغفار کریں''',
        'hindi': '''शब-ए-बरात की फातिहा (15 शाबान की रात)

शब-ए-बरात क़िस्मत और मग़फ़िरत की रात है। इस रात की फातिहा की ख़ास अहमियत है।

अहमियत:
• वो रात जब अल्लाह आसमान-ए-दुनिया पर नुज़ूल फ़रमाते हैं
• आने वाले साल की तक़दीरें लिखी जाती हैं
• जो मग़फ़िरत मांगें उनके गुनाह माफ़ होते हैं
• मरहूमीन की रूहें अपने घर वालों से मिलने आती हैं

तैयारी:
• हलवा, खीर या मिठाई तैयार करें
• घर साफ़ करें
• मोमबत्तियां या चिराग़ जलाएं (वैकल्पिक)
• घर वालों को जमा करें

मुकम्मल तरीक़ा:

१. मग़रिब की नमाज़ के बाद:
शब-ए-बरात की ख़ास इबादत शुरू करें

२. दुरूद शरीफ़ पढ़ें (100 बार):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

३. सूरह यासीन पढ़ें (3 बार):
- पहली बार: सेहत के साथ लंबी उम्र के लिए
- दूसरी बार: आफ़ात से हिफ़ाज़त के लिए
- तीसरी बार: दूसरों की मोहताजी से आज़ादी के लिए

४. हर सूरह यासीन के बाद शब-ए-बरात की दुआ पढ़ें

५. सूरह अल-फातिहा पढ़ें (7 बार)

६. सूरह अल-इख़्लास पढ़ें (100 बार या ज़्यादा)

७. दुआ करें:
"या अल्लाह! अगर मेरा नाम बदबख़्तों में लिखा है तो उसे मिटाकर नेकबख़्तों में लिख दे। अगर मेरा रिज़्क़ कम है तो उसे वसीअ फ़रमा। मेरे गुनाह और मेरे मरहूम रिश्तेदारों के गुनाह माफ़ फ़रमा।"

८. क़ब्रिस्तान जाएं (अगर मुमकिन हो):
• मरहूमीन के लिए फातिहा पढ़ें
• तमाम मुसलमानों के लिए दुआ करें

९. खाने पर दम करें और तक़सीम करें

ख़ास इबादत:
• सलातुत तस्बीह पढ़ें
• रात भर क़ुरआन पढ़ें
• कसरत से इस्तिग़फ़ार करें''',
      },
    },
    {
      'title': 'Niyaz/Langar Fatiha',
      'titleUrdu': 'نیاز / لنگر کی فاتحہ',
      'titleHindi': 'नियाज़ / लंगर की फातिहा',
      'icon': Icons.restaurant,
      'color': const Color(0xFFFF9800),
      'details': {
        'english': '''Niyaz/Langar Fatiha

Niyaz is food prepared and distributed for the sake of Allah, seeking blessings for oneself or deceased relatives.

Types of Niyaz:
• Niyaz for Saints (Gyarhween, Chatti, etc.)
• Niyaz for Deceased Relatives
• Niyaz for Fulfillment of Wishes
• Langar (Community Kitchen)

Preparation:
• Cook food with clean intentions
• Common items: Biryani, Kheer, Halwa, Dates
• Ensure the food is halal and pure
• Prepare in a clean environment

Complete Method:

1. Make Intention (Niyyah):
"I am preparing this Niyaz for the pleasure of Allah and for Isal-e-Sawab to (name/saint)."

2. While Cooking:
• Recite Durood Shareef continuously
• Maintain wudu if possible
• Keep tongue engaged in zikr

3. After Cooking is Complete:
Gather family members around the food

4. Recite Durood Shareef (11 times):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

5. Recite Surah Al-Fatiha (1 time)

6. Recite Surah Al-Ikhlas (3 times)

7. Recite Durood Shareef (11 times)

8. Make Dua:
"Ya Allah, accept this Niyaz. Send its reward to Prophet Muhammad ﷺ, to the Awliya, and to (name for whom it is prepared). Bless this food and make it beneficial for all who eat it."

9. Blow on the Food

10. Distribution:
• First portion to the poor and needy
• Then to neighbors
• Then to family members
• Do not waste any food

Virtues:
• Great rewards for feeding others
• Blessings in one's sustenance
• Dua of the hungry is accepted''',
        'urdu': '''نیاز / لنگر کی فاتحہ

نیاز وہ کھانا ہے جو اللہ کی رضا کے لیے تیار کیا جائے اور تقسیم کیا جائے، اپنے لیے یا فوت شدہ رشتہ داروں کے لیے برکات حاصل کرنے کے لیے۔

نیاز کی اقسام:
• اولیاء کی نیاز (گیارہویں، چھٹی، وغیرہ)
• فوت شدہ رشتہ داروں کی نیاز
• حاجت پوری ہونے کی نیاز
• لنگر (اجتماعی کھانا)

تیاری:
• صاف نیت کے ساتھ کھانا پکائیں
• عام چیزیں: بریانی، کھیر، حلوہ، کھجور
• یقینی بنائیں کہ کھانا حلال اور پاک ہو
• صاف ماحول میں تیار کریں

مکمل طریقہ:

۱۔ نیت کریں:
"میں اللہ کی رضا اور (نام/ولی) کے ایصال ثواب کے لیے یہ نیاز تیار کر رہا/رہی ہوں۔"

۲۔ پکاتے وقت:
• مسلسل درود شریف پڑھیں
• اگر ممکن ہو تو وضو رکھیں
• زبان کو ذکر میں مشغول رکھیں

۳۔ پکانے کے بعد:
گھر والوں کو کھانے کے گرد جمع کریں

۴۔ درود شریف پڑھیں (11 بار):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

۵۔ سورۃ الفاتحہ پڑھیں (1 بار)

۶۔ سورۃ الاخلاص پڑھیں (3 بار)

۷۔ درود شریف پڑھیں (11 بار)

۸۔ دعا کریں:
"یا اللہ! اس نیاز کو قبول فرما۔ اس کا ثواب نبی محمد ﷺ کو، اولیاء کو، اور (جس کے لیے تیار کی گئی ہے) کو پہنچا۔ اس کھانے میں برکت ڈال اور اسے کھانے والوں کے لیے فائدہ مند بنا۔"

۹۔ کھانے پر دم کریں

۱۰۔ تقسیم:
• پہلا حصہ غریبوں اور ضرورت مندوں کو
• پھر پڑوسیوں کو
• پھر گھر والوں کو
• کوئی کھانا ضائع نہ کریں

فضائل:
• دوسروں کو کھلانے کا عظیم ثواب
• رزق میں برکت
• بھوکے کی دعا قبول ہوتی ہے''',
        'hindi': '''नियाज़ / लंगर की फातिहा

नियाज़ वो खाना है जो अल्लाह की रज़ा के लिए तैयार किया जाए और तक़सीम किया जाए, अपने लिए या मरहूम रिश्तेदारों के लिए बरकात हासिल करने के लिए।

नियाज़ की क़िस्में:
• औलिया की नियाज़ (ग्यारहवीं, छट्टी, वग़ैरह)
• मरहूम रिश्तेदारों की नियाज़
• हाजत पूरी होने की नियाज़
• लंगर (इजतिमाई खाना)

तैयारी:
• साफ़ नीयत के साथ खाना पकाएं
• आम चीज़ें: बिरयानी, खीर, हलवा, खजूर
• यक़ीनी बनाएं कि खाना हलाल और पाक हो
• साफ़ माहौल में तैयार करें

मुकम्मल तरीक़ा:

१. नीयत करें:
"मैं अल्लाह की रज़ा और (नाम/वली) के ईसाल-ए-सवाब के लिए यह नियाज़ तैयार कर रहा/रही हूं।"

२. पकाते वक़्त:
• मुसलसल दुरूद शरीफ़ पढ़ें
• अगर मुमकिन हो तो वुज़ू रखें
• ज़बान को ज़िक्र में मशग़ूल रखें

३. पकाने के बाद:
घर वालों को खाने के गिर्द जमा करें

४. दुरूद शरीफ़ पढ़ें (11 बार):
"اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ"

५. सूरह अल-फातिहा पढ़ें (1 बार)

६. सूरह अल-इख़्लास पढ़ें (3 बार)

७. दुरूद शरीफ़ पढ़ें (11 बार)

८. दुआ करें:
"या अल्लाह! इस नियाज़ को क़बूल फ़रमा। इसका सवाब नबी मुहम्मद ﷺ को, औलिया को, और (जिसके लिए तैयार की गई है) को पहुंचा। इस खाने में बरकत डाल और इसे खाने वालों के लिए फ़ायदेमंद बना।"

९. खाने पर दम करें

१०. तक़सीम:
• पहला हिस्सा ग़रीबों और ज़रूरतमंदों को
• फिर पड़ोसियों को
• फिर घर वालों को
• कोई खाना ज़ाया न करें

फ़ज़ाइल:
• दूसरों को खिलाने का अज़ीम सवाब
• रिज़्क़ में बरकत
• भूके की दुआ क़��ूल होती है''',
      },
    },
    {
      'title': 'Chatti (6th Day) Fatiha',
      'titleUrdu': 'چھٹی کی فاتحہ',
      'titleHindi': 'छट्टी की फातिहा',
      'icon': Icons.calendar_view_day,
      'color': const Color(0xFF607D8B),
      'details': {
        'english': '''Chatti (6th Day) Fatiha

Chatti is performed on the 6th day after a person's death.

Complete Method:
1. Gather Family and Friends
2. Recite Durood Shareef (11 times)
3. Recite Surah Al-Fatiha (7 times)
4. Recite Surah Al-Ikhlas (11 times)
5. Recite Surah Yaseen (1 time) - if time permits
6. Recite Durood Shareef (11 times)
7. Make Dua for the deceased
8. Blow on the Food and Distribute''',
        'urdu': '''چھٹی کی فاتحہ

چھٹی کسی شخص کی وفات کے چھٹے دن کی جاتی ہے۔

مکمل طریقہ:
۱۔ گھر والوں اور دوستوں کو جمع کریں
۲۔ درود شریف پڑھیں (11 بار)
۳۔ سورۃ الفاتحہ پڑھیں (7 بار)
۴۔ سورۃ الاخلاص پڑھیں (11 بار)
۵۔ سورۃ یٰسین پڑھیں (1 بار) - اگر وقت ہو
۶۔ درود شریف پڑھیں (11 بار)
۷۔ میت کے لیے دعا کریں
۸۔ کھانے پر دم کریں اور تقسیم کریں''',
        'hindi': '''छट्टी की फातिहा

छट्टी किसी शख्स की वफात के छठे दिन की जाती है।

मुकम्मल तरीका:
१. घर वालों और दोस्तों को जमा करें
२. दुरूद शरीफ पढ़ें (11 बार)
३. सूरह अल-फातिहा पढ़ें (7 बार)
४. सूरह अल-इखलास पढ़ें (11 बार)
५. सूरह यासीन पढ़ें (1 बार) - अगर वक्त हो
६. दुरूद शरीफ पढ़ें (11 बार)
७. मय्यित के लिए दुआ करें
८. खाने पर दम करें और तकसीम करें''',
      },
    },
    {
      'title': 'Daswan (10th Day) Fatiha',
      'titleUrdu': 'دسواں کی فاتحہ',
      'titleHindi': 'दसवां की फातिहा',
      'icon': Icons.looks_one,
      'color': const Color(0xFF795548),
      'details': {
        'english': '''Daswan (10th Day) Fatiha

Daswan is performed on the 10th day after a person's death.

Complete Method:
1. Gather Family and Friends
2. Recite Durood Shareef (11 times)
3. Recite Surah Al-Fatiha (10 times)
4. Recite Surah Al-Ikhlas (100 times)
5. Recite Surah Yaseen (1 time)
6. Recite Durood Shareef (11 times)
7. Make Dua for the deceased
8. Blow on the Food and Distribute''',
        'urdu': '''دسواں کی فاتحہ

دسواں کسی شخص کی وفات کے دسویں دن کی جاتی ہے۔

مکمل طریقہ:
۱۔ گھر والوں اور دوستوں کو جمع کریں
۲۔ درود شریف پڑھیں (11 بار)
۳۔ سورۃ الفاتحہ پڑھیں (10 بار)
۴۔ سورۃ الاخلاص پڑھیں (100 بار)
۵۔ سورۃ یٰسین پڑھیں (1 بار)
۶۔ درود شریف پڑھیں (11 بار)
۷۔ میت کے لیے دعا کریں
۸۔ کھانے پر دم کریں اور تقسیم کریں''',
        'hindi': '''दसवां की फातिहा

दसवां किसी शख्स की वफात के दसवें दिन की जाती है।

मुकम्मल तरीका:
१. घर वालों और दोस्तों को जमा करें
२. दुरूद शरीफ पढ़ें (11 बार)
३. सूरह अल-फातिहा पढ़ें (10 बार)
४. सूरह अल-इखलास पढ़ें (100 बार)
५. सूरह यासीन पढ़ें (1 बार)
६. दुरूद शरीफ पढ़ें (11 बार)
७. मय्यित के लिए दुआ करें
८. खाने पर दम करें और तकसीम करें''',
      },
    },
    {
      'title': 'Chehlum (40th Day) Fatiha',
      'titleUrdu': 'چہلم کی فاتحہ',
      'titleHindi': 'चहलुम की फातिहा',
      'icon': Icons.event_note,
      'color': const Color(0xFF9C27B0),
      'details': {
        'english': '''Chehlum (40th Day) Fatiha

Chehlum is performed on the 40th day after death.

Complete Method:
1. Large Gathering of Family and Friends
2. Recite Durood Shareef (40 times)
3. Recite Surah Al-Fatiha (40 times)
4. Recite Surah Al-Ikhlas (100 times)
5. Recite Surah Yaseen (1 time)
6. Recite Surah Al-Mulk (1 time)
7. Recite Durood Shareef (40 times)
8. Make Comprehensive Dua
9. Distribute Food to All Present''',
        'urdu': '''چہلم کی فاتحہ

چہلم وفات کے چالیسویں دن کی جاتی ہے۔

مکمل طریقہ:
۱۔ گھر والوں اور دوستوں کا بڑا اجتماع
۲۔ درود شریف پڑھیں (40 بار)
۳۔ سورۃ الفاتحہ پڑھیں (40 بار)
۴۔ سورۃ الاخلاص پڑھیں (100 بار)
۵۔ سورۃ یٰسین پڑھیں (1 بار)
۶۔ سورۃ الملک پڑھیں (1 بار)
۷۔ درود شریف پڑھیں (40 بار)
۸۔ جامع دعا کریں
۹۔ تمام لوگوں میں کھانا تقسیم کریں''',
        'hindi': '''चहलुम की फातिहा

चहलुम वफात के चालीसवें दिन की जाती है।

मुकम्मल तरीका:
१. घर वालों और दोस्तों का बड़ा इजतिमा
२. दुरूद शरीफ पढ़ें (40 बार)
३. सूरह अल-फातिहा पढ़ें (40 बार)
४. सूरह अल-इखलास पढ़ें (100 बार)
५. सूरह यासीन पढ़ें (1 बार)
६. सूरह अल-मुल्क पढ़ें (1 बार)
७. दुरूद शरीफ पढ़ें (40 बार)
८. जामे दुआ करें
९. तमाम लोगों में खाना तकसीम करें''',
      },
    },
    {
      'title': 'Bismillah Fatiha',
      'titleUrdu': 'بسم اللہ کی فاتحہ',
      'titleHindi': 'बिस्मिल्लाह की फातिहा',
      'icon': Icons.school,
      'color': const Color(0xFF2196F3),
      'details': {
        'english': '''Bismillah Fatiha (New Beginning)

Bismillah Fatiha is performed when a child begins Quran education or any new auspicious beginning.

When to Perform:
• Child starts learning Quran
• Starting new business
• Moving to new house
• Any new beginning

Complete Method:
1. Gather Family Members
2. Recite Durood Shareef (3 times)
3. Recite Surah Al-Fatiha (1 time)
4. Recite Surah Al-Ikhlas (3 times)
5. Recite Durood Shareef (3 times)
6. Make Dua for success and blessings
7. Distribute sweets''',
        'urdu': '''بسم اللہ کی فاتحہ (نئی شروعات)

بسم اللہ کی فاتحہ جب بچہ قرآن پڑھنا شروع کرے یا کسی نئی مبارک شروعات پر کی جاتی ہے۔

کب کریں:
• بچہ قرآن سیکھنا شروع کرے
• نیا کاروبار شروع کریں
• نئے گھر میں منتقل ہوں
• کوئی نئی شروعات

مکمل طریقہ:
۱۔ گھر والوں کو جمع کریں
۲۔ درود شریف پڑھیں (3 بار)
۳۔ سورۃ الفاتحہ پڑھیں (1 بار)
۴۔ سورۃ الاخلاص پڑھیں (3 بار)
۵۔ درود شریف پڑھیں (3 بار)
۶۔ کامیابی اور برکت کی دعا کریں
۷۔ مٹھائی تقسیم کریں''',
        'hindi': '''बिस्मिल्लाह की फातिहा (नई शुरुआत)

बिस्मिल्लाह की फातिहा जब बच्चा कुरआन पढ़ना शुरू करे या किसी नई मुबारक शुरुआत पर की जाती है।

कब करें:
• बच्चा कुरआन सीखना शुरू करे
• नया कारोबार शुरू करें
• नए घर में जाएं
• कोई नई शुरुआत

मुकम्मल तरीका:
१. घर वालों को जमा करें
२. दुरूद शरीफ पढ़ें (3 बार)
३. सूरह अल-फातिहा पढ़ें (1 बार)
४. सूरह अल-इखलास पढ़ें (3 बार)
५. दुरूद शरीफ पढ़ें (3 बार)
६. कामयाबी और बरकत की दुआ करें
७. मिठाई तकसीम करें''',
      },
    },
    {
      'title': 'Aqeeqah Fatiha',
      'titleUrdu': 'عقیقہ کی فاتحہ',
      'titleHindi': 'अकीका की फातिहा',
      'icon': Icons.child_friendly,
      'color': const Color(0xFFE91E63),
      'details': {
        'english': '''Aqeeqah Fatiha

Aqeeqah is performed on the 7th day after a child's birth. It involves sacrifice and Fatiha.

Sunnah Method:
• 2 goats/sheep for a boy
• 1 goat/sheep for a girl
• Performed on 7th day (or 14th, 21st)
• Child's head is shaved

Complete Method:
1. After the sacrifice, gather family
2. Recite Durood Shareef (11 times)
3. Recite Surah Al-Fatiha (1 time)
4. Recite Surah Al-Ikhlas (3 times)
5. Recite Durood Shareef (11 times)
6. Make Dua for the child's health and guidance
7. Distribute the meat to family, friends, and poor''',
        'urdu': '''عقیقہ کی فاتحہ

عقیقہ بچے کی پیدائش کے ساتویں دن کیا جاتا ہے۔ اس میں قربانی اور فاتحہ شامل ہے۔

سنت طریقہ:
• لڑکے کے لیے 2 بکریاں/بھیڑیں
• لڑکی کے لیے 1 بکری/بھیڑ
• ساتویں دن کیا جائے (یا 14ویں، 21ویں)
• بچے کے سر کے بال مونڈے جائیں

مکمل طریقہ:
۱۔ قربانی کے بعد گھر والوں کو جمع کریں
۲۔ درود شریف پڑھیں (11 بار)
۳۔ سورۃ الفاتحہ پڑھیں (1 بار)
۴۔ سورۃ الاخلاص پڑھیں (3 بار)
۵۔ درود شریف پڑھیں (11 بار)
۶۔ بچے کی صحت اور ہدایت کی دعا کریں
۷۔ گوشت گھر والوں، دوستوں اور غریبوں میں تقسیم کریں''',
        'hindi': '''अकीका की फातिहा

अकीका बच्चे की पैदाइश के सातवें दिन किया जाता है। इसमें कुर्बानी और फातिहा शामिल है।

सुन्नत तरीका:
• लड़के के लिए 2 बकरियां/भेड़ें
• लड़की के लिए 1 बकरी/भेड़
• सातवें दिन किया जाए (या 14वें, 21वें)
• बच्चे के सर के बाल मुंडवाए जाएं

मुकम्मल तरीका:
१. कुर्बानी के बाद घर वालों को जमा करें
२. दुरूद शरीफ पढ़ें (11 बार)
३. सूरह अल-फातिहा पढ़ें (1 बार)
४. सूरह अल-इखलास पढ़ें (3 बार)
५. दुरूद शरीफ पढ़ें (11 बार)
६. बच्चे की सेहत और हिदायत की दुआ करें
७. गोश्त घर वालों, दोस्तों और गरीबों में तकसीम करें''',
      },
    },
    {
      'title': 'Shadi/Nikah Fatiha',
      'titleUrdu': 'شادی/نکاح کی فاتحہ',
      'titleHindi': 'शादी/निकाह की फातिहा',
      'icon': Icons.favorite_border,
      'color': const Color(0xFFFF5722),
      'details': {
        'english': '''Shadi/Nikah Fatiha (Wedding)

Fatiha is performed at weddings to seek blessings for the couple.

When to Perform:
• Before the Nikah ceremony
• After the Nikah
• At the Walima

Complete Method:
1. Gather family members
2. Recite Durood Shareef (11 times)
3. Recite Surah Al-Fatiha (1 time)
4. Recite Surah Al-Ikhlas (3 times)
5. Recite Durood Shareef (11 times)
6. Make Dua:
"Ya Allah, bless this marriage. Grant them love, mercy, and understanding. Give them righteous children and a happy life together."
7. Distribute sweets

Dua for Newlyweds:
"بَارَكَ اللهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"May Allah bless you and send blessings upon you and bring you together in goodness."''',
        'urdu': '''شادی/نکاح کی فاتحہ

فاتحہ شادیوں میں جوڑے کے لیے برکات حاصل کرنے کے لیے کی جاتی ہے۔

کب کریں:
• نکاح کی تقریب سے پہلے
• نکاح کے بعد
• ولیمے میں

مکمل طریقہ:
۱۔ گھر والوں کو جمع کریں
۲۔ درود شریف پڑھیں (11 بار)
۳۔ سورۃ الفاتحہ پڑھیں (1 بار)
۴۔ سورۃ الاخلاص پڑھیں (3 بار)
۵۔ درود شریف پڑھیں (11 بار)
۶۔ دعا کریں:
"یا اللہ! اس شادی میں برکت ڈال۔ انہیں محبت، رحمت اور سمجھ بوجھ عطا فرما۔ انہیں نیک اولاد اور خوشگوار زندگی عطا فرما۔"
۷۔ مٹھائی تقسیم کریں

نئے جوڑے کے لیے دعا:
"بَارَكَ اللهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"اللہ تمہیں برکت دے، تم پر برکت نازل کرے اور تم دونوں کو خیر میں جمع رکھے۔"''',
        'hindi': '''शादी/निकाह की फातिहा

फातिहा शादियों में जोड़े के लिए बरकात हासिल करने के लिए की जाती है।

कब करें:
• निकाह की तकरीब से पहले
• निकाह के बाद
• वलीमे में

मुकम्मल तरीका:
१. घर वालों को जमा करें
२. दुरूद शरीफ पढ़ें (11 बार)
३. सूरह अल-फातिहा पढ़ें (1 बार)
४. सूरह अल-इखलास पढ़ें (3 बार)
५. दुरूद शरीफ पढ़ें (11 बार)
६. दुआ करें:
"या अल्लाह! इस शादी में बरकत डाल। इन्हें मोहब्बत, रहमत और समझ बूझ अता फरमा। इन्हें नेक औलाद और खुशगवार जिंदगी अता फरमा।"
७. मिठाई तकसीम करें

नए जोड़े के लिए दुआ:
"بَارَكَ اللهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ"
"अल्लाह तुम्हें बरकत दे, तुम पर बरकत नाजिल करे और तुम दोनों को खैर में जमा रखे।"''',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDarkMode;
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenBorder = Color(0xFF8AAF9A);

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
            // Fatiha Types List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _fatihaTypes.length,
              itemBuilder: (context, index) {
                final fatiha = _fatihaTypes[index];
                return _buildFatihaCard(
                  fatiha,
                  isDark,
                  darkGreen,
                  lightGreenBorder,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFatihaCard(
    Map<String, dynamic> fatiha,
    bool isDark,
    Color darkGreen,
    Color lightGreenBorder,
  ) {
    const emeraldGreen = Color(0xFF1E8F5A);
    final title = _selectedLanguage == 'english'
        ? fatiha['title']
        : _selectedLanguage == 'urdu'
        ? fatiha['titleUrdu']
        : fatiha['titleHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: isDark ? 0.05 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showFatihaDetails(fatiha),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: fatiha['color'] as Color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (fatiha['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    fatiha['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : darkGreen,
                  ),
                  textDirection: _selectedLanguage == 'urdu'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),
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

  void _showFatihaDetails(Map<String, dynamic> fatiha) {
    final details = fatiha['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: fatiha['title'],
          titleUrdu: fatiha['titleUrdu'] ?? '',
          titleHindi: fatiha['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: fatiha['color'] as Color,
          icon: fatiha['icon'] as IconData,
          category: 'Deen Ki Buniyadi Amal - Fatiha',
        ),
      ),
    );
  }
}
