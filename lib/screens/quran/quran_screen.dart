import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/quran_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/surah_model.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'juz_detail_screen.dart';

// Surah names in all 4 languages for localized display
const Map<int, Map<String, String>> _surahNames = {
  1: {'en': 'Al-Fatihah', 'hi': 'अल-फ़ातिहा', 'ur': 'الفاتحہ', 'ar': 'الفاتحة'},
  2: {'en': 'Al-Baqarah', 'hi': 'अल-बक़रा', 'ur': 'البقرہ', 'ar': 'البقرة'},
  3: {
    'en': 'Ali \'Imran',
    'hi': 'आल-ए-इमरान',
    'ur': 'آل عمران',
    'ar': 'آل عمران',
  },
  4: {'en': 'An-Nisa', 'hi': 'अन-निसा', 'ur': 'النساء', 'ar': 'النساء'},
  5: {'en': 'Al-Ma\'idah', 'hi': 'अल-माइदा', 'ur': 'المائدہ', 'ar': 'المائدة'},
  6: {'en': 'Al-An\'am', 'hi': 'अल-अनआम', 'ur': 'الانعام', 'ar': 'الأنعام'},
  7: {'en': 'Al-A\'raf', 'hi': 'अल-आराफ़', 'ur': 'الاعراف', 'ar': 'الأعراف'},
  8: {'en': 'Al-Anfal', 'hi': 'अल-अनफ़ाल', 'ur': 'الانفال', 'ar': 'الأنفال'},
  9: {'en': 'At-Tawbah', 'hi': 'अत-तौबा', 'ur': 'التوبہ', 'ar': 'التوبة'},
  10: {'en': 'Yunus', 'hi': 'यूनुस', 'ur': 'یونس', 'ar': 'يونس'},
  11: {'en': 'Hud', 'hi': 'हूद', 'ur': 'ھود', 'ar': 'هود'},
  12: {'en': 'Yusuf', 'hi': 'यूसुफ़', 'ur': 'یوسف', 'ar': 'يوسف'},
  13: {'en': 'Ar-Ra\'d', 'hi': 'अर-रअद', 'ur': 'الرعد', 'ar': 'الرعد'},
  14: {'en': 'Ibrahim', 'hi': 'इब्राहीम', 'ur': 'ابراھیم', 'ar': 'إبراهيم'},
  15: {'en': 'Al-Hijr', 'hi': 'अल-हिज्र', 'ur': 'الحجر', 'ar': 'الحجر'},
  16: {'en': 'An-Nahl', 'hi': 'अन-नहल', 'ur': 'النحل', 'ar': 'النحل'},
  17: {'en': 'Al-Isra', 'hi': 'अल-इसरा', 'ur': 'الاسراء', 'ar': 'الإسراء'},
  18: {'en': 'Al-Kahf', 'hi': 'अल-कहफ़', 'ur': 'الکھف', 'ar': 'الكهف'},
  19: {'en': 'Maryam', 'hi': 'मरयम', 'ur': 'مریم', 'ar': 'مريم'},
  20: {'en': 'Taha', 'hi': 'ताहा', 'ur': 'طٰہٰ', 'ar': 'طه'},
  21: {'en': 'Al-Anbya', 'hi': 'अल-अंबिया', 'ur': 'الانبیاء', 'ar': 'الأنبياء'},
  22: {'en': 'Al-Hajj', 'hi': 'अल-हज', 'ur': 'الحج', 'ar': 'الحج'},
  23: {
    'en': 'Al-Mu\'minun',
    'hi': 'अल-मुमिनून',
    'ur': 'المؤمنون',
    'ar': 'المؤمنون',
  },
  24: {'en': 'An-Nur', 'hi': 'अन-नूर', 'ur': 'النور', 'ar': 'النور'},
  25: {
    'en': 'Al-Furqan',
    'hi': 'अल-फ़ुरक़ान',
    'ur': 'الفرقان',
    'ar': 'الفرقان',
  },
  26: {
    'en': 'Ash-Shu\'ara',
    'hi': 'अश-शुअरा',
    'ur': 'الشعراء',
    'ar': 'الشعراء',
  },
  27: {'en': 'An-Naml', 'hi': 'अन-नम्ल', 'ur': 'النمل', 'ar': 'النمل'},
  28: {'en': 'Al-Qasas', 'hi': 'अल-क़सस', 'ur': 'القصص', 'ar': 'القصص'},
  29: {
    'en': 'Al-Ankabut',
    'hi': 'अल-अनकबूत',
    'ur': 'العنکبوت',
    'ar': 'العنكبوت',
  },
  30: {'en': 'Ar-Rum', 'hi': 'अर-रूम', 'ur': 'الروم', 'ar': 'الروم'},
  31: {'en': 'Luqman', 'hi': 'लुक़मान', 'ur': 'لقمان', 'ar': 'لقمان'},
  32: {'en': 'As-Sajdah', 'hi': 'अस-सज्दा', 'ur': 'السجدہ', 'ar': 'السجدة'},
  33: {'en': 'Al-Ahzab', 'hi': 'अल-अहज़ाब', 'ur': 'الاحزاب', 'ar': 'الأحزاب'},
  34: {'en': 'Saba', 'hi': 'सबा', 'ur': 'سبا', 'ar': 'سبأ'},
  35: {'en': 'Fatir', 'hi': 'फ़ातिर', 'ur': 'فاطر', 'ar': 'فاطر'},
  36: {'en': 'Ya-Sin', 'hi': 'यासीन', 'ur': 'یٰسین', 'ar': 'يس'},
  37: {
    'en': 'As-Saffat',
    'hi': 'अस-साफ़्फ़ात',
    'ur': 'الصافات',
    'ar': 'الصافات',
  },
  38: {'en': 'Sad', 'hi': 'साद', 'ur': 'ص', 'ar': 'ص'},
  39: {'en': 'Az-Zumar', 'hi': 'अज़-ज़ुमर', 'ur': 'الزمر', 'ar': 'الزمر'},
  40: {'en': 'Ghafir', 'hi': 'ग़ाफ़िर', 'ur': 'غافر', 'ar': 'غافر'},
  41: {'en': 'Fussilat', 'hi': 'फ़ुस्सिलत', 'ur': 'فصلت', 'ar': 'فصلت'},
  42: {'en': 'Ash-Shura', 'hi': 'अश-शूरा', 'ur': 'الشورٰی', 'ar': 'الشورى'},
  43: {
    'en': 'Az-Zukhruf',
    'hi': 'अज़-ज़ुख़रुफ़',
    'ur': 'الزخرف',
    'ar': 'الزخرف',
  },
  44: {'en': 'Ad-Dukhan', 'hi': 'अद-दुख़ान', 'ur': 'الدخان', 'ar': 'الدخان'},
  45: {
    'en': 'Al-Jathiyah',
    'hi': 'अल-जासिया',
    'ur': 'الجاثیہ',
    'ar': 'الجاثية',
  },
  46: {'en': 'Al-Ahqaf', 'hi': 'अल-अहक़ाफ़', 'ur': 'الاحقاف', 'ar': 'الأحقاف'},
  47: {'en': 'Muhammad', 'hi': 'मुहम्मद', 'ur': 'محمد', 'ar': 'محمد'},
  48: {'en': 'Al-Fath', 'hi': 'अल-फ़तह', 'ur': 'الفتح', 'ar': 'الفتح'},
  49: {
    'en': 'Al-Hujurat',
    'hi': 'अल-हुजुरात',
    'ur': 'الحجرات',
    'ar': 'الحجرات',
  },
  50: {'en': 'Qaf', 'hi': 'क़ाफ़', 'ur': 'ق', 'ar': 'ق'},
  51: {
    'en': 'Adh-Dhariyat',
    'hi': 'अज़-ज़ारियात',
    'ur': 'الذاریات',
    'ar': 'الذاريات',
  },
  52: {'en': 'At-Tur', 'hi': 'अत-तूर', 'ur': 'الطور', 'ar': 'الطور'},
  53: {'en': 'An-Najm', 'hi': 'अन-नज्म', 'ur': 'النجم', 'ar': 'النجم'},
  54: {'en': 'Al-Qamar', 'hi': 'अल-क़मर', 'ur': 'القمر', 'ar': 'القمر'},
  55: {'en': 'Ar-Rahman', 'hi': 'अर-रहमान', 'ur': 'الرحمٰن', 'ar': 'الرحمن'},
  56: {
    'en': 'Al-Waqi\'ah',
    'hi': 'अल-वाक़िआ',
    'ur': 'الواقعہ',
    'ar': 'الواقعة',
  },
  57: {'en': 'Al-Hadid', 'hi': 'अल-हदीद', 'ur': 'الحدید', 'ar': 'الحديد'},
  58: {
    'en': 'Al-Mujadila',
    'hi': 'अल-मुजादिला',
    'ur': 'المجادلہ',
    'ar': 'المجادلة',
  },
  59: {'en': 'Al-Hashr', 'hi': 'अल-हश्र', 'ur': 'الحشر', 'ar': 'الحشر'},
  60: {
    'en': 'Al-Mumtahanah',
    'hi': 'अल-मुम्तहना',
    'ur': 'الممتحنہ',
    'ar': 'الممتحنة',
  },
  61: {'en': 'As-Saff', 'hi': 'अस-सफ़्फ़', 'ur': 'الصف', 'ar': 'الصف'},
  62: {'en': 'Al-Jumu\'ah', 'hi': 'अल-जुमुआ', 'ur': 'الجمعہ', 'ar': 'الجمعة'},
  63: {
    'en': 'Al-Munafiqun',
    'hi': 'अल-मुनाफ़िक़ून',
    'ur': 'المنافقون',
    'ar': 'المنافقون',
  },
  64: {
    'en': 'At-Taghabun',
    'hi': 'अत-तग़ाबुन',
    'ur': 'التغابن',
    'ar': 'التغابن',
  },
  65: {'en': 'At-Talaq', 'hi': 'अत-तलाक़', 'ur': 'الطلاق', 'ar': 'الطلاق'},
  66: {'en': 'At-Tahrim', 'hi': 'अत-तहरीम', 'ur': 'التحریم', 'ar': 'التحريم'},
  67: {'en': 'Al-Mulk', 'hi': 'अल-मुल्क', 'ur': 'الملک', 'ar': 'الملك'},
  68: {'en': 'Al-Qalam', 'hi': 'अल-क़लम', 'ur': 'القلم', 'ar': 'القلم'},
  69: {'en': 'Al-Haqqah', 'hi': 'अल-हाक़्क़ा', 'ur': 'الحاقہ', 'ar': 'الحاقة'},
  70: {'en': 'Al-Ma\'arij', 'hi': 'अल-मआरिज', 'ur': 'المعارج', 'ar': 'المعارج'},
  71: {'en': 'Nuh', 'hi': 'नूह', 'ur': 'نوح', 'ar': 'نوح'},
  72: {'en': 'Al-Jinn', 'hi': 'अल-जिन्न', 'ur': 'الجن', 'ar': 'الجن'},
  73: {
    'en': 'Al-Muzzammil',
    'hi': 'अल-मुज़्ज़म्मिल',
    'ur': 'المزمل',
    'ar': 'المزمل',
  },
  74: {
    'en': 'Al-Muddaththir',
    'hi': 'अल-मुद्दस्सिर',
    'ur': 'المدثر',
    'ar': 'المدثر',
  },
  75: {
    'en': 'Al-Qiyamah',
    'hi': 'अल-क़ियामा',
    'ur': 'القیامہ',
    'ar': 'القيامة',
  },
  76: {'en': 'Al-Insan', 'hi': 'अल-इंसान', 'ur': 'الانسان', 'ar': 'الإنسان'},
  77: {
    'en': 'Al-Mursalat',
    'hi': 'अल-मुर्सलात',
    'ur': 'المرسلات',
    'ar': 'المرسلات',
  },
  78: {'en': 'An-Naba', 'hi': 'अन-नबा', 'ur': 'النبا', 'ar': 'النبأ'},
  79: {
    'en': 'An-Nazi\'at',
    'hi': 'अन-नाज़िआत',
    'ur': 'النازعات',
    'ar': 'النازعات',
  },
  80: {'en': 'Abasa', 'hi': 'अबसा', 'ur': 'عبس', 'ar': 'عبس'},
  81: {'en': 'At-Takwir', 'hi': 'अत-तकवीर', 'ur': 'التکویر', 'ar': 'التكوير'},
  82: {
    'en': 'Al-Infitar',
    'hi': 'अल-इंफ़ितार',
    'ur': 'الانفطار',
    'ar': 'الانفطار',
  },
  83: {
    'en': 'Al-Mutaffifin',
    'hi': 'अल-मुतफ़्फ़िफ़ीन',
    'ur': 'المطففین',
    'ar': 'المطففين',
  },
  84: {
    'en': 'Al-Inshiqaq',
    'hi': 'अल-इंशिक़ाक़',
    'ur': 'الانشقاق',
    'ar': 'الانشقاق',
  },
  85: {'en': 'Al-Buruj', 'hi': 'अल-बुरूज', 'ur': 'البروج', 'ar': 'البروج'},
  86: {'en': 'At-Tariq', 'hi': 'अत-तारिक़', 'ur': 'الطارق', 'ar': 'الطارق'},
  87: {'en': 'Al-A\'la', 'hi': 'अल-आला', 'ur': 'الاعلٰی', 'ar': 'الأعلى'},
  88: {
    'en': 'Al-Ghashiyah',
    'hi': 'अल-ग़ाशिया',
    'ur': 'الغاشیہ',
    'ar': 'الغاشية',
  },
  89: {'en': 'Al-Fajr', 'hi': 'अल-फ़ज्र', 'ur': 'الفجر', 'ar': 'الفجر'},
  90: {'en': 'Al-Balad', 'hi': 'अल-बलद', 'ur': 'البلد', 'ar': 'البلد'},
  91: {'en': 'Ash-Shams', 'hi': 'अश-शम्स', 'ur': 'الشمس', 'ar': 'الشمس'},
  92: {'en': 'Al-Layl', 'hi': 'अल-लैल', 'ur': 'اللیل', 'ar': 'الليل'},
  93: {'en': 'Ad-Duha', 'hi': 'अद-दुहा', 'ur': 'الضحٰی', 'ar': 'الضحى'},
  94: {'en': 'Ash-Sharh', 'hi': 'अश-शर्ह', 'ur': 'الشرح', 'ar': 'الشرح'},
  95: {'en': 'At-Tin', 'hi': 'अत-तीन', 'ur': 'التین', 'ar': 'التين'},
  96: {'en': 'Al-Alaq', 'hi': 'अल-अलक़', 'ur': 'العلق', 'ar': 'العلق'},
  97: {'en': 'Al-Qadr', 'hi': 'अल-क़द्र', 'ur': 'القدر', 'ar': 'القدر'},
  98: {'en': 'Al-Bayyinah', 'hi': 'अल-बय्यिना', 'ur': 'البینہ', 'ar': 'البينة'},
  99: {
    'en': 'Az-Zalzalah',
    'hi': 'अज़-ज़लज़ला',
    'ur': 'الزلزال',
    'ar': 'الزلزلة',
  },
  100: {
    'en': 'Al-Adiyat',
    'hi': 'अल-आदियात',
    'ur': 'العادیات',
    'ar': 'العاديات',
  },
  101: {
    'en': 'Al-Qari\'ah',
    'hi': 'अल-क़ारिआ',
    'ur': 'القارعہ',
    'ar': 'القارعة',
  },
  102: {
    'en': 'At-Takathur',
    'hi': 'अत-तकासुर',
    'ur': 'التکاثر',
    'ar': 'التكاثر',
  },
  103: {'en': 'Al-Asr', 'hi': 'अल-अस्र', 'ur': 'العصر', 'ar': 'العصر'},
  104: {'en': 'Al-Humazah', 'hi': 'अल-हुमज़ा', 'ur': 'الھمزہ', 'ar': 'الهمزة'},
  105: {'en': 'Al-Fil', 'hi': 'अल-फ़ील', 'ur': 'الفیل', 'ar': 'الفيل'},
  106: {'en': 'Quraysh', 'hi': 'क़ुरैश', 'ur': 'قریش', 'ar': 'قريش'},
  107: {'en': 'Al-Ma\'un', 'hi': 'अल-माऊन', 'ur': 'الماعون', 'ar': 'الماعون'},
  108: {'en': 'Al-Kawthar', 'hi': 'अल-कौसर', 'ur': 'الکوثر', 'ar': 'الكوثر'},
  109: {
    'en': 'Al-Kafirun',
    'hi': 'अल-काफ़िरून',
    'ur': 'الکافرون',
    'ar': 'الكافرون',
  },
  110: {'en': 'An-Nasr', 'hi': 'अन-नस्र', 'ur': 'النصر', 'ar': 'النصر'},
  111: {'en': 'Al-Masad', 'hi': 'अल-मसद', 'ur': 'المسد', 'ar': 'المسد'},
  112: {'en': 'Al-Ikhlas', 'hi': 'अल-इख़लास', 'ur': 'الاخلاص', 'ar': 'الإخلاص'},
  113: {'en': 'Al-Falaq', 'hi': 'अल-फ़लक़', 'ur': 'الفلق', 'ar': 'الفلق'},
  114: {'en': 'An-Nas', 'hi': 'अन-नास', 'ur': 'الناس', 'ar': 'الناس'},
};

// Para/Juz names in all 4 languages
const Map<int, Map<String, String>> _paraNames = {
  1: {
    'en': 'Alif Laam Meem',
    'hi': 'अलिफ़ लाम मीम',
    'ur': 'الم',
    'ar': 'الٓمٓ',
  },
  2: {'en': 'Sayaqool', 'hi': 'सयक़ूल', 'ur': 'سیقول', 'ar': 'سَيَقُولُ'},
  3: {
    'en': 'Tilkal Rusul',
    'hi': 'तिल्कर रुसुल',
    'ur': 'تلک الرسل',
    'ar': 'تِلْكَ ٱلرُّسُلُ',
  },
  4: {
    'en': 'Lan Tanaloo',
    'hi': 'लन तनालू',
    'ur': 'لن تنالوا',
    'ar': 'لَن تَنَالُوا۟',
  },
  5: {
    'en': 'Wal Muhsanat',
    'hi': 'वल मुहसनात',
    'ur': 'والمحصنات',
    'ar': 'وَٱلْمُحْصَنَـٰتُ',
  },
  6: {
    'en': 'La Yuhibbullah',
    'hi': 'ला युहिब्बुल्लाह',
    'ur': 'لا یحب اللہ',
    'ar': 'لَا يُحِبُّ ٱللَّهُ',
  },
  7: {
    'en': 'Wa Iza Samiu',
    'hi': 'व इज़ा समिउ',
    'ur': 'واذا سمعوا',
    'ar': 'وَإِذَا سَمِعُوا۟',
  },
  8: {
    'en': 'Wa Lau Annana',
    'hi': 'व लौ अन्नना',
    'ur': 'ولو اننا',
    'ar': 'وَلَوْ أَنَّنَا',
  },
  9: {
    'en': 'Qalal Malao',
    'hi': 'क़ालल मलाओ',
    'ur': 'قال الملا',
    'ar': 'قَالَ ٱلْمَلَأُ',
  },
  10: {
    'en': 'Wa Alamu',
    'hi': 'व आलमू',
    'ur': 'واعلموا',
    'ar': 'وَٱعْلَمُوٓا۟',
  },
  11: {
    'en': 'Yatazeroon',
    'hi': 'यअ्तज़िरून',
    'ur': 'یعتذرون',
    'ar': 'يَعْتَذِرُونَ',
  },
  12: {
    'en': 'Wa Ma Min Dabbah',
    'hi': 'व मा मिन दाब्बह',
    'ur': 'وما من دابۃ',
    'ar': 'وَمَا مِن دَآبَّةٍ',
  },
  13: {
    'en': 'Wa Ma Ubrioo',
    'hi': 'व मा उबर्रिउ',
    'ur': 'وما ابرئ',
    'ar': 'وَمَآ أُبَرِّئُ',
  },
  14: {'en': 'Rubama', 'hi': 'रुबमा', 'ur': 'ربما', 'ar': 'رُبَمَا'},
  15: {
    'en': 'Subhanallazi',
    'hi': 'सुब्हानल्लज़ी',
    'ur': 'سبحان الذی',
    'ar': 'سُبْحَـٰنَ ٱلَّذِىٓ',
  },
  16: {
    'en': 'Qal Alam',
    'hi': 'क़ाल अलम',
    'ur': 'قال الم',
    'ar': 'قَالَ أَلَمْ',
  },
  17: {'en': 'Iqtaraba', 'hi': 'इक़्तरब', 'ur': 'اقترب', 'ar': 'ٱقْتَرَبَ'},
  18: {
    'en': 'Qad Aflaha',
    'hi': 'क़द अफ़्लहा',
    'ur': 'قد افلح',
    'ar': 'قَدْ أَفْلَحَ',
  },
  19: {
    'en': 'Wa Qalallazina',
    'hi': 'व क़ालल्लज़ीना',
    'ur': 'وقال الذین',
    'ar': 'وَقَالَ ٱلَّذِينَ',
  },
  20: {
    'en': 'Amman Khalaq',
    'hi': 'अम्मन ख़लक़',
    'ur': 'امن خلق',
    'ar': 'أَمَّنْ خَلَقَ',
  },
  21: {
    'en': 'Utlu Ma Uhiya',
    'hi': 'उत्लु मा ऊहिया',
    'ur': 'اتل ما اوحی',
    'ar': 'ٱتْلُ مَآ أُوحِىَ',
  },
  22: {
    'en': 'Wa Man Yaqnut',
    'hi': 'व मन यक़्नुत',
    'ur': 'ومن یقنت',
    'ar': 'وَمَن يَقْنُتْ',
  },
  23: {'en': 'Wa Mali', 'hi': 'व मा ली', 'ur': 'وما لی', 'ar': 'وَمَا لِىَ'},
  24: {
    'en': 'Faman Azlam',
    'hi': 'फ़मन अज़्लम',
    'ur': 'فمن اظلم',
    'ar': 'فَمَنْ أَظْلَمُ',
  },
  25: {
    'en': 'Elahe Yuraddo',
    'hi': 'इलैहि युरद्दु',
    'ur': 'الیہ یرد',
    'ar': 'إِلَيْهِ يُرَدُّ',
  },
  26: {'en': 'Ha Meem', 'hi': 'हा मीम', 'ur': 'حم', 'ar': 'حمٓ'},
  27: {
    'en': 'Qala Fama Khatbukum',
    'hi': 'क़ाल फ़मा ख़तबुकुम',
    'ur': 'قال فما خطبکم',
    'ar': 'قَالَ فَمَا خَطْبُكُمْ',
  },
  28: {
    'en': 'Qad Sami Allah',
    'hi': 'क़द समिअल्लाह',
    'ur': 'قد سمع اللہ',
    'ar': 'قَدْ سَمِعَ ٱللَّهُ',
  },
  29: {
    'en': 'Tabarakallazi',
    'hi': 'तबारकल्लज़ी',
    'ur': 'تبارک الذی',
    'ar': 'تَبَـٰرَكَ ٱلَّذِى',
  },
  30: {'en': 'Amma', 'hi': 'अम्मा', 'ur': 'عم', 'ar': 'عَمَّ'},
};

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get Surah name based on language
  String _getSurahName(int surahNumber, QuranLanguage language) {
    final names = _surahNames[surahNumber];
    if (names == null) return 'Surah $surahNumber';

    switch (language) {
      case QuranLanguage.hindi:
        return names['hi'] ?? names['en'] ?? 'Surah $surahNumber';
      case QuranLanguage.urdu:
        return names['ur'] ?? names['en'] ?? 'Surah $surahNumber';
      case QuranLanguage.arabic:
        return names['ar'] ?? names['en'] ?? 'Surah $surahNumber';
      default:
        return names['en'] ?? 'Surah $surahNumber';
    }
  }

  // Get Para name based on language
  String _getParaName(int paraNumber, QuranLanguage language) {
    final names = _paraNames[paraNumber];
    if (names == null) return 'Para $paraNumber';

    switch (language) {
      case QuranLanguage.hindi:
        return names['hi'] ?? names['ar'] ?? 'Para $paraNumber';
      case QuranLanguage.urdu:
        return names['ur'] ?? names['ar'] ?? 'Para $paraNumber';
      case QuranLanguage.arabic:
        return names['ar'] ?? 'Para $paraNumber';
      default:
        return names['en'] ?? names['ar'] ?? 'Para $paraNumber';
    }
  }

  List<JuzInfo> _getFilteredJuz(List<JuzInfo> juzList, QuranProvider provider) {
    if (_searchQuery.isEmpty) {
      return juzList;
    }
    final query = _searchQuery.toLowerCase();
    return juzList.where((juz) {
      // Get surah names for this juz
      String startSurahName = '';
      String endSurahName = '';
      if (provider.surahList.isNotEmpty) {
        final startSurah = provider.surahList.firstWhere(
          (s) => s.number == juz.startSurah,
          orElse: () => provider.surahList.first,
        );
        final endSurah = provider.surahList.firstWhere(
          (s) => s.number == juz.endSurah,
          orElse: () => provider.surahList.first,
        );
        startSurahName = startSurah.englishName.toLowerCase();
        endSurahName = endSurah.englishName.toLowerCase();
      }

      return juz.number.toString().contains(query) ||
          juz.arabicName.contains(query) ||
          startSurahName.contains(query) ||
          endSurahName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Listen to language changes to rebuild UI
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(context.tr('para')),
          ),
          body: Consumer<QuranProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.surahList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (provider.error != null && provider.surahList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: responsive.iconHuge,
                        color: Colors.grey,
                      ),
                      responsive.vSpaceRegular,
                      Text(provider.error!),
                      responsive.vSpaceRegular,
                      ElevatedButton(
                        onPressed: () => provider.fetchSurahList(),
                        child: Text(context.tr('retry')),
                      ),
                    ],
                  ),
                );
              }

              // Para List with Search
              final filteredJuz = _getFilteredJuz(provider.juzList, provider);

              return Column(
                children: [
                  // Last read section
                  if (provider.lastReadSurah > 0)
                    Padding(
                      padding: responsive.paddingOnly(
                        left: 16,
                        top: 12,
                        right: 16,
                      ),
                      child: SearchBarWidget(
                        controller: _searchController,
                        hintText: context.tr('search_para'),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onClear: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        enableVoiceSearch: true,
                      ),
                    ),
                  Expanded(
                    child: filteredJuz.isEmpty
                        ? Center(
                            child: Text(
                              context.tr('no_results_found'),
                              style: TextStyle(
                                fontSize: responsive.textMedium,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: responsive.paddingRegular,
                            itemCount: filteredJuz.length,
                            itemBuilder: (context, index) {
                              return _buildJuzCard(
                                context,
                                filteredJuz[index],
                                provider,
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildJuzCard(
    BuildContext context,
    JuzInfo juz,
    QuranProvider provider,
  ) {
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    // Get Surah names for range display (localized based on selected language)
    final startSurahName = _getSurahName(
      juz.startSurah,
      provider.selectedLanguage,
    );
    final endSurahName = _getSurahName(juz.endSurah, provider.selectedLanguage);

    return Container(
      margin: responsive.paddingOnly(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JuzDetailScreen(juzNumber: juz.number),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Juz Number
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
                    '${juz.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Juz Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${context.tr('para_label')} ${juz.number}',
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        responsive.hSpaceXSmall,
                        Flexible(
                          child: Container(
                            padding: responsive.paddingSymmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F3ED),
                              borderRadius: BorderRadius.circular(
                                responsive.radiusSmall,
                              ),
                            ),
                            child: Text(
                              _getParaName(
                                juz.number,
                                provider.selectedLanguage,
                              ),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                                fontFamily:
                                    provider.selectedLanguage ==
                                            QuranLanguage.arabic ||
                                        provider.selectedLanguage ==
                                            QuranLanguage.urdu
                                    ? 'Poppins'
                                    : null,
                              ),
                              textDirection:
                                  provider.selectedLanguage ==
                                          QuranLanguage.arabic ||
                                      provider.selectedLanguage ==
                                          QuranLanguage.urdu
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Surah range info
                    if (startSurahName.isNotEmpty)
                      Text(
                        juz.startSurah == juz.endSurah
                            ? startSurahName
                            : '$startSurahName - $endSurahName',
                        style: TextStyle(
                          fontSize: responsive.textXSmall,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: responsive.spacing(2)),
                    // Ayah range
                    Text(
                      '${context.tr('ayah')} ${juz.startAyah} - ${juz.endAyah}',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow only
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
