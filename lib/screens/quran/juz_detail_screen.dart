import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/quran_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/surah_model.dart';
import '../../widgets/common/header_action_button.dart';

class JuzDetailScreen extends StatefulWidget {
  final int juzNumber;
  const JuzDetailScreen({super.key, required this.juzNumber});

  @override
  State<JuzDetailScreen> createState() => _JuzDetailScreenState();
}

// Surah names in Hindi/Urdu for complete display
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
    'hi': 'अल-मुज़्ज़म��मिल',
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

class _JuzDetailScreenState extends State<JuzDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyah;
  late QuranProvider _quranProvider;
  final ScrollController _scrollController = ScrollController();
  // Track which cards have translation visible
  final Set<int> _cardsWithTranslation = {};
  // Track which cards have transliteration visible
  final Set<int> _cardsWithTransliteration = {};
  // Number of ayahs per card (4 ayahs = ~35 cards for 141 ayahs)
  static const int _ayahsPerCard = 4;
  // Track current card being played and ayahs queue
  int? _playingCardIndex;
  List<AyahModel> _ayahsQueue = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quranProvider = context.read<QuranProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quranProvider.fetchJuz(widget.juzNumber);
    });
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.completed) {
          // Play next ayah in queue if available
          if (_ayahsQueue.isNotEmpty) {
            final nextAyah = _ayahsQueue.removeAt(0);
            _playAyah(nextAyah);
          } else {
            setState(() {
              _playingAyah = null;
              _playingCardIndex = null;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Play single ayah
  Future<void> _playAyah(AyahModel ayah) async {
    final audioUrl = _quranProvider.getAudioUrl(0, ayah.number);
    try {
      setState(() {
        _playingAyah = ayah.number;
      });
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      setState(() {
        _playingAyah = null;
      });
    }
  }

  // Stop playing
  void _stopPlaying() {
    _audioPlayer.stop();
    _ayahsQueue.clear();
    setState(() {
      _playingAyah = null;
      _playingCardIndex = null;
    });
  }

  // Play all ayahs in a card sequentially
  Future<void> _playCardAyahs(List<AyahModel> ayahs, int cardIndex) async {
    if (ayahs.isEmpty) return;
    // Stop any current playback
    _stopPlaying();
    // Set up the queue (all except first, which we'll play immediately)
    _ayahsQueue = ayahs.skip(1).toList();
    setState(() {
      _playingCardIndex = cardIndex;
    });
    // Play the first ayah
    await _playAyah(ayahs.first);
  }

  // Toggle translation for card (group of ayahs)
  void _toggleCardTranslation(int cardIndex) {
    setState(() {
      if (_cardsWithTranslation.contains(cardIndex)) {
        _cardsWithTranslation.remove(cardIndex);
      } else {
        _cardsWithTranslation.add(cardIndex);
      }
    });
  }

  // Share multiple ayahs
  void _shareAyahs(List<AyahModel> ayahs, List<String?> translations) {
    final StringBuffer shareText = StringBuffer();
    for (int i = 0; i < ayahs.length; i++) {
      shareText.writeln(ayahs[i].text);
      if (translations[i] != null) {
        shareText.writeln(translations[i]);
      }
      shareText.writeln();
    }
    shareText.writeln('- ${context.tr('para_label')} ${widget.juzNumber}');
    Share.share(shareText.toString());
  }

  // Copy multiple ayahs to clipboard
  void _copyAyahs(List<AyahModel> ayahs, List<String?> translations) {
    final StringBuffer copyText = StringBuffer();
    for (int i = 0; i < ayahs.length; i++) {
      copyText.writeln(ayahs[i].text);
      if (translations[i] != null) {
        copyText.writeln(translations[i]);
      }
      copyText.writeln();
    }
    copyText.writeln('- ${context.tr('para_label')} ${widget.juzNumber}');
    Clipboard.setData(ClipboardData(text: copyText.toString()));
  }

  // Get grouped ayahs for a card index
  List<int> _getAyahIndicesForCard(int cardIndex, int totalAyahs) {
    final startIndex = cardIndex * _ayahsPerCard;
    final endIndex = (startIndex + _ayahsPerCard).clamp(0, totalAyahs);
    return List.generate(endIndex - startIndex, (i) => startIndex + i);
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

  // Build Para header with complete details
  Widget _buildParaHeader(
    JuzInfo juzInfo,
    String startSurahName,
    String endSurahName,
    int totalAyahs,
    QuranProvider provider,
  ) {
    return const SizedBox.shrink();
  }

  // Build Surah divider widget
  Widget _buildSurahDivider(int surahNumber, QuranLanguage language) {
    // Variables available for future use
    // final responsive = context.responsive;
    // final surahName = _getSurahName(surahNumber, language);
    // final surahNameArabic = _surahNames[surahNumber]?['ar'] ?? '';
    // const darkGreen = Color(0xFF0A5C36);

    return Row(
      children: [
        // Arabic name - Placeholder for future implementation
      ],
    );
  }

  // Check if this card starts with a new Surah
  bool _startsNewSurah(List<AyahModel> ayahs) {
    if (ayahs.isEmpty) return false;
    return ayahs.first.numberInSurah == 1;
  }

  // Get the Surah number for the first ayah in the card
  int _getFirstSurahNumber(List<AyahModel> ayahs) {
    if (ayahs.isEmpty) return 0;
    return ayahs.first.surahNumber;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final settings = context.watch<SettingsProvider>();
    // Listen to language changes to rebuild UI
    context.watch<LanguageProvider>();
    final quranProvider = context.watch<QuranProvider>();
    final paraName = _getParaName(
      widget.juzNumber,
      quranProvider.selectedLanguage,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${context.tr('para_label')} ${widget.juzNumber}',
              style: TextStyle(
                fontSize: responsive.textMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' - ',
              style: TextStyle(
                fontSize: responsive.textMedium,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            Flexible(
              child: Text(
                paraName,
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  fontWeight: FontWeight.normal,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.currentJuzAyahs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: responsive.iconXLarge * 1.5,
                    color: Colors.grey.shade400,
                  ),
                  responsive.vSpaceRegular,
                  Text(context.tr('error')),
                  responsive.vSpaceSmall,
                  ElevatedButton(
                    onPressed: () => provider.fetchJuz(widget.juzNumber),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          // Calculate number of cards (grouped ayahs)
          final totalAyahs = provider.currentJuzAyahs.length;
          final cardCount = (totalAyahs / _ayahsPerCard).ceil();

          // Get Juz info for header
          final juzInfo = JuzInfo.getAllJuz()[widget.juzNumber - 1];
          final startSurahName = _getSurahName(
            juzInfo.startSurah,
            provider.selectedLanguage,
          );
          final endSurahName = _getSurahName(
            juzInfo.endSurah,
            provider.selectedLanguage,
          );

          return ListView.builder(
            controller: _scrollController,
            padding: responsive.paddingAll(12),
            itemCount: cardCount + 1, // +1 for header
            itemBuilder: (context, index) {
              // First item is the header
              if (index == 0) {
                return _buildParaHeader(
                  juzInfo,
                  startSurahName,
                  endSurahName,
                  provider.currentJuzAyahs.length,
                  provider,
                );
              }

              // Ayah cards (adjust index for header)
              final cardIndex = index - 1;
              final ayahIndices = _getAyahIndicesForCard(cardIndex, totalAyahs);
              final ayahs = ayahIndices
                  .map((i) => provider.currentJuzAyahs[i])
                  .toList();

              // Get translations using direct indices
              final translations = ayahIndices.map((i) {
                return i < provider.currentJuzTranslation.length
                    ? provider.currentJuzTranslation[i].text
                    : null;
              }).toList();

              // Get transliterations using direct indices
              final transliterations = ayahIndices.map((i) {
                return i < provider.currentJuzTransliteration.length
                    ? provider.currentJuzTransliteration[i].text
                    : null;
              }).toList();

              // Check if this card starts with a new Surah
              final showSurahDivider = _startsNewSurah(ayahs);
              final surahNumber = _getFirstSurahNumber(ayahs);

              return Column(
                children: [
                  // Show Surah divider if this card starts a new Surah
                  if (showSurahDivider && surahNumber > 0)
                    _buildSurahDivider(surahNumber, provider.selectedLanguage),
                  _buildGroupedAyahCard(
                    ayahs,
                    translations,
                    transliterations,
                    provider,
                    settings.arabicFontSize,
                    settings.translationFontSize,
                    cardIndex,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupedAyahCard(
    List<AyahModel> ayahs,
    List<String?> translations,
    List<String?> transliterations,
    QuranProvider provider,
    double arabicFontSize,
    double translationFontSize,
    int cardIndex,
  ) {
    final responsive = context.responsive;
    final isAnyPlaying =
        _playingCardIndex == cardIndex ||
        ayahs.any((a) => _playingAyah == a.number);
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final showTransliteration = _cardsWithTransliteration.contains(cardIndex);
    // Card serial number (1-based)
    final cardNumber = cardIndex + 1;

    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isAnyPlaying
              ? AppColors.primaryLight
              : AppColors.lightGreenBorder,
          width: isAnyPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card header with serial number and action buttons
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isAnyPlaying
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : AppColors.lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // First row: Card number and Ayah range
                Row(
                  children: [
                    // Card serial number badge
                    Container(
                      width: responsive.spacing(40),
                      height: responsive.spacing(40),
                      decoration: BoxDecoration(
                        color: isAnyPlaying
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6.0,
                            offset: Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$cardNumber',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.textMedium,
                          ),
                        ),
                      ),
                    ),
                    responsive.hSpaceMedium,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.tr('ayah')} ${ayahs.first.numberInSurah} - ${ayahs.last.numberInSurah}',
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          responsive.vSpaceXSmall,
                          // Page and Hizb info
                          Wrap(
                            spacing: responsive.spacing(8),
                            runSpacing: responsive.spacing(4),
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: responsive.fontSize(12),
                                    color: Colors.grey[600],
                                  ),
                                  responsive.hSpaceXSmall,
                                  Text(
                                    '${context.tr('page')} ${ayahs.first.page}',
                                    style: TextStyle(
                                      fontSize: responsive.textXSmall,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bookmark_border,
                                    size: responsive.fontSize(12),
                                    color: Colors.grey[600],
                                  ),
                                  responsive.hSpaceXSmall,
                                  Text(
                                    '${context.tr('hizb')} ${((ayahs.first.hizbQuarter - 1) ~/ 4) + 1}',
                                    style: TextStyle(
                                      fontSize: responsive.textXSmall,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Second row: Action buttons with labels
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: responsive.spacing(8),
                  runSpacing: responsive.spacing(8),
                  children: [
                    HeaderActionButton(
                      icon: isAnyPlaying ? Icons.stop : Icons.volume_up,
                      label: isAnyPlaying
                          ? context.tr('stop')
                          : context.tr('audio'),
                      onTap: isAnyPlaying
                          ? _stopPlaying
                          : () => _playCardAyahs(ayahs, cardIndex),
                      isActive: isAnyPlaying,
                    ),
                    HeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                    ),

                    HeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyAyahs(ayahs, translations),
                      isActive: false,
                    ),
                    HeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareAyahs(ayahs, translations),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Arabic texts for all ayahs in this card
          Padding(
            padding: responsive.paddingRegular,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ayahs.asMap().entries.map((entry) {
                final ayah = entry.value;
                final isPlaying = _playingAyah == ayah.number;
                return GestureDetector(
                  onTap: isPlaying ? _stopPlaying : () => _playAyah(ayah),
                  child: Container(
                    margin: entry.key < ayahs.length - 1
                        ? responsive.paddingOnly(bottom: 12)
                        : EdgeInsets.zero,
                    padding: isPlaying
                        ? responsive.paddingAll(8)
                        : EdgeInsets.zero,
                    decoration: isPlaying
                        ? BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              responsive.radiusMedium,
                            ),
                          )
                        : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Play indicator
                        if (isPlaying)
                          Padding(
                            padding: responsive.paddingOnly(right: 8, top: 8),
                            child: Icon(
                              Icons.volume_up,
                              size: responsive.iconSmall,
                              color: AppColors.primary,
                            ),
                          ),
                        // Arabic text
                        Expanded(
                          child: Text(
                            ayah.text,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: arabicFontSize,
                              height: 2.0,
                              color: isPlaying
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Transliterations (if visible)
          if (showTransliteration)
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: (!showTranslation)
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(responsive.radiusLarge),
                        bottomRight: Radius.circular(responsive.radiusLarge),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section header
                  Row(
                    children: [
                      Icon(
                        Icons.text_fields,
                        size: responsive.iconSmall,
                        color: Colors.blue[700],
                      ),
                      responsive.hSpaceXSmall,
                      Text(
                        context.tr('transliteration'),
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  responsive.vSpaceSmall,
                  ...transliterations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final transliteration = entry.value;
                    if (transliteration == null) return const SizedBox.shrink();

                    return Container(
                      margin: index < transliterations.length - 1
                          ? responsive.paddingOnly(bottom: 8)
                          : EdgeInsets.zero,
                      child: Text(
                        transliteration,
                        style: TextStyle(
                          fontSize: translationFontSize,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[800],
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }),
                ],
              ),
            ),
          // Translations (if visible)
          if (showTranslation)
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: AppColors.lightGreenChip.withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(responsive.radiusLarge),
                  bottomRight: Radius.circular(responsive.radiusLarge),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: translations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final translation = entry.value;
                  if (translation == null) return const SizedBox.shrink();

                  return Container(
                    margin: index < translations.length - 1
                        ? responsive.paddingOnly(bottom: 12)
                        : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ayah number indicator
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              responsive.radiusMedium,
                            ),
                          ),
                          child: Text(
                            '${ayahs[index].numberInSurah}',
                            style: TextStyle(
                              fontSize: responsive.fontSize(11),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        responsive.vSpaceSmall,
                        Text(
                          translation,
                          style: TextStyle(
                            fontSize: translationFontSize,
                            height: 1.5,
                          ),
                          textDirection:
                              provider.selectedLanguage == QuranLanguage.urdu
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
