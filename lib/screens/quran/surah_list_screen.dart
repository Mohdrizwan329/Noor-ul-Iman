import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/quran_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/surah_model.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Get transliterated Surah name for Urdu
  String _getUrduName(String arabicName) {
    // Remove سُورَةُ prefix and clean up diacritical marks
    String cleanName = arabicName
        .replaceAll('سُورَةُ ', '')
        .replaceAll('سورة ', '')
        .replaceAll(RegExp(r'[ًٌٍَُِّْٰۡـٓ]'), '') // Remove all diacritical marks including maddah
        // Normalize hamza and alif variations
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ؤ', 'و') // Hamza on waw
        .replaceAll('ئ', 'ي') // Hamza on ya
        .replaceAll('ٱ', 'ا') // Alif wasla to regular alif
        .replaceAll('ى', 'ي') // Alif maqsurah to ya
        .trim();

    // Complete Surah names in Urdu (all 114 Surahs)
    final Map<String, String> urduMap = {
      'الفاتحة': 'الفاتحہ',
      'البقرة': 'البقرہ',
      'ال عمران': 'آل عمران',
      'النساء': 'النساء',
      'المايدة': 'المائدہ',
      'الانعام': 'الانعام',
      'الاعراف': 'الاعراف',
      'الانفال': 'الانفال',
      'التوبة': 'التوبہ',
      'يونس': 'یونس',
      'هود': 'ہود',
      'يوسف': 'یوسف',
      'الرعد': 'الرعد',
      'ابراهيم': 'ابراہیم',
      'الحجر': 'الحجر',
      'النحل': 'النحل',
      'الاسراء': 'الاسراء',
      'الكهف': 'الکہف',
      'مريم': 'مریم',
      'طه': 'طٰہٰ',
      'الانبياء': 'الانبیاء',
      'الحج': 'الحج',
      'المومنون': 'المؤمنون',
      'النور': 'النور',
      'الفرقان': 'الفرقان',
      'الشعراء': 'الشعراء',
      'النمل': 'النمل',
      'القصص': 'القصص',
      'العنكبوت': 'العنکبوت',
      'الروم': 'الروم',
      'لقمان': 'لقمان',
      'السجدة': 'السجدہ',
      'الاحزاب': 'الاحزاب',
      'سبا': 'سبا',
      'فاطر': 'فاطر',
      'يس': 'یٰسین',
      'الصافات': 'الصافات',
      'ص': 'ص',
      'الزمر': 'الزمر',
      'غافر': 'غافر',
      'فصلت': 'فصلت',
      'الشوري': 'الشوریٰ',
      'الزخرف': 'الزخرف',
      'الدخان': 'الدخان',
      'الجاثية': 'الجاثیہ',
      'الاحقاف': 'الاحقاف',
      'محمد': 'محمد',
      'الفتح': 'الفتح',
      'الحجرات': 'الحجرات',
      'ق': 'ق',
      'الذاريات': 'الذاریات',
      'الطور': 'الطور',
      'النجم': 'النجم',
      'القمر': 'القمر',
      'الرحمن': 'الرحمٰن',
      'الواقعة': 'الواقعہ',
      'الحديد': 'الحدید',
      'المجادلة': 'المجادلہ',
      'الحشر': 'الحشر',
      'الممتحنة': 'الممتحنہ',
      'الصف': 'الصف',
      'الجمعة': 'الجمعہ',
      'المنافقون': 'المنافقون',
      'التغابن': 'التغابن',
      'الطلاق': 'الطلاق',
      'التحريم': 'التحریم',
      'الملك': 'الملک',
      'القلم': 'القلم',
      'الحاقة': 'الحاقہ',
      'المعارج': 'المعارج',
      'نوح': 'نوح',
      'الجن': 'الجن',
      'المزمل': 'المزمل',
      'المدثر': 'المدثر',
      'القيامة': 'القیامہ',
      'الانسان': 'الانسان',
      'المرسلات': 'المرسلات',
      'النبا': 'النبا',
      'النازعات': 'النازعات',
      'عبس': 'عبس',
      'التكوير': 'التکویر',
      'الانفطار': 'الانفطار',
      'المطففين': 'المطففین',
      'الانشقاق': 'الانشقاق',
      'البروج': 'البروج',
      'الطارق': 'الطارق',
      'الاعلي': 'الاعلیٰ',
      'الغاشية': 'الغاشیہ',
      'الفجر': 'الفجر',
      'البلد': 'البلد',
      'الشمس': 'الشمس',
      'الليل': 'اللیل',
      'الضحي': 'الضحیٰ',
      'الشرح': 'الشرح',
      'التين': 'التین',
      'العلق': 'العلق',
      'القدر': 'القدر',
      'البينة': 'البینہ',
      'الزلزلة': 'الزلزلہ',
      'العاديات': 'العادیات',
      'القارعة': 'القارعہ',
      'التكاثر': 'التکاثر',
      'العصر': 'العصر',
      'الهمزة': 'الہمزہ',
      'الفيل': 'الفیل',
      'قريش': 'قریش',
      'الماعون': 'الماعون',
      'الكوثر': 'الکوثر',
      'الكافرون': 'الکافرون',
      'النصر': 'النصر',
      'المسد': 'المسد',
      'الاخلاص': 'الاخلاص',
      'الفلق': 'الفلق',
      'الناس': 'الناس',
    };
    return urduMap[cleanName] ?? arabicName;
  }

  // Get transliterated Surah name for Hindi
  String _getHindiName(String arabicName) {
    // Remove سُورَةُ prefix and clean up diacritical marks
    String cleanName = arabicName
        .replaceAll('سُورَةُ ', '')
        .replaceAll('سورة ', '')
        .replaceAll(RegExp(r'[ًٌٍَُِّْٰۡـٓ]'), '') // Remove all diacritical marks including maddah
        // Normalize hamza and alif variations
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ؤ', 'و') // Hamza on waw
        .replaceAll('ئ', 'ي') // Hamza on ya
        .replaceAll('ٱ', 'ا') // Alif wasla to regular alif
        .replaceAll('ى', 'ي') // Alif maqsurah to ya
        .trim();

    final Map<String, String> hindiMap = {
      'الفاتحة': 'अल-फ़ातिहा',
      'البقرة': 'अल-बक़रा',
      'ال عمران': 'आले-इमरान',
      'النساء': 'अन-निसा',
      'المايدة': 'अल-माइदा',
      'الانعام': 'अल-अनआम',
      'الاعراف': 'अल-आराफ़',
      'الانفال': 'अल-अनफ़ाल',
      'التوبة': 'अत-तौबा',
      'يونس': 'यूनुस',
      'هود': 'हूद',
      'يوسف': 'यूसुफ़',
      'الرعد': 'अर-रअद',
      'ابراهيم': 'इब्राहीम',
      'الحجر': 'अल-हिज्र',
      'النحل': 'अन-नह्ल',
      'الاسراء': 'अल-इसरा',
      'الكهف': 'अल-कह्फ़',
      'مريم': 'मरयम',
      'طه': 'ताहा',
      'الانبياء': 'अल-अंबिया',
      'الحج': 'अल-हज्ज',
      'المومنون': 'अल-मोमिनून',
      'النور': 'अन-नूर',
      'الفرقان': 'अल-फ़ुरक़ान',
      'الشعراء': 'अश-शुअरा',
      'النمل': 'अन-नम्ल',
      'القصص': 'अल-क़सस',
      'العنكبوت': 'अल-अनकबूत',
      'الروم': 'अर-रूम',
      'لقمان': 'लुक़मान',
      'السجدة': 'अस-सजदा',
      'الاحزاب': 'अल-अहज़ाब',
      'سبا': 'सबा',
      'فاطر': 'फ़ातिर',
      'يس': 'यासीन',
      'الصافات': 'अस-साफ़्फ़ात',
      'ص': 'साद',
      'الزمر': 'अज़-ज़ुमर',
      'غافر': 'ग़ाफ़िर',
      'فصلت': 'फ़ुस्सिलत',
      'الشوري': 'अश-शूरा',
      'الزخرف': 'अज़-ज़ुख़रुफ़',
      'الدخان': 'अद-दुख़ान',
      'الجاثية': 'अल-जासिया',
      'الاحقاف': 'अल-अहक़ाफ़',
      'محمد': 'मुहम्मद',
      'الفتح': 'अल-फ़तह',
      'الحجرات': 'अल-हुजुरात',
      'ق': 'क़ाफ़',
      'الذاريات': 'अज़-ज़ारियात',
      'الطور': 'अत-तूर',
      'النجم': 'अन-नज्म',
      'القمر': 'अल-क़मर',
      'الرحمن': 'अर-रहमान',
      'الواقعة': 'अल-वाक़िआ',
      'الحديد': 'अल-हदीद',
      'المجادلة': 'अल-मुजादिला',
      'الحشر': 'अल-हश्र',
      'الممتحنة': 'अल-मुम्तहना',
      'الصف': 'अस-सफ़',
      'الجمعة': 'अल-जुमुआ',
      'المنافقون': 'अल-मुनाफ़िक़ून',
      'التغابن': 'अत-तग़ाबुन',
      'الطلاق': 'अत-तलाक़',
      'التحريم': 'अत-तहरीम',
      'الملك': 'अल-मुल्क',
      'القلم': 'अल-क़लम',
      'الحاقة': 'अल-हाक़्क़ा',
      'المعارج': 'अल-मआरिज',
      'نوح': 'नूह',
      'الجن': 'अल-जिन्न',
      'المزمل': 'अल-मुज़्ज़म्मिल',
      'المدثر': 'अल-मुद्दस्सिर',
      'القيامة': 'अल-क़ियामा',
      'الانسان': 'अल-इनसान',
      'المرسلات': 'अल-मुरसलात',
      'النبا': 'अन-नबा',
      'النازعات': 'अन-नाज़िआत',
      'عبس': 'अबसा',
      'التكوير': 'अत-तकवीर',
      'الانفطار': 'अल-इन्फ़ितार',
      'المطففين': 'अल-मुतफ़्फ़िफ़ीन',
      'الانشقاق': 'अल-इनशिक़ाक़',
      'البروج': 'अल-बुरूज',
      'الطارق': 'अत-तारिक़',
      'الاعلي': 'अल-आला',
      'الغاشية': 'अल-ग़ाशिया',
      'الفجر': 'अल-फ़ज्र',
      'البلد': 'अल-बलद',
      'الشمس': 'अश-शम्स',
      'الليل': 'अल-लैल',
      'الضحي': 'अज़-ज़ुहा',
      'الشرح': 'अश-शर्ह',
      'التين': 'अत-तीन',
      'العلق': 'अल-अलक़',
      'القدر': 'अल-क़द्र',
      'البينة': 'अल-बय्यिना',
      'الزلزلة': 'अज़-ज़लज़ला',
      'العاديات': 'अल-आदियात',
      'القارعة': 'अल-क़ारिआ',
      'التكاثر': 'अत-तकासुर',
      'العصر': 'अल-अस्र',
      'الهمزة': 'अल-हुमज़ा',
      'الفيل': 'अल-फ़ील',
      'قريش': 'क़ुरैश',
      'الماعون': 'अल-माऊन',
      'الكوثر': 'अल-कौसर',
      'الكافرون': 'अल-काफ़िरून',
      'النصر': 'अन-नस्र',
      'المسد': 'अल-मसद',
      'الاخلاص': 'अल-इख़लास',
      'الفلق': 'अल-फ़लक़',
      'الناس': 'अन-नास',
    };
    return hindiMap[cleanName] ?? arabicName;
  }

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

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('surah'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
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
                  Icon(Icons.error_outline, size: responsive.iconHuge, color: Colors.grey),
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

          final surahList = provider.searchSurah(_searchQuery);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: responsive.paddingOnly(left: 16, top: 12, right: 16),
                child: SearchBarWidget(
                  controller: _searchController,
                  hintText: context.tr('search_surah'),
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

              // Surah List
              Expanded(
                child: ListView.builder(
                  key: ValueKey(langProvider.languageCode), // Force rebuild when language changes
                  padding: responsive.paddingRegular,
                  itemCount: surahList.length,
                  itemBuilder: (context, index) {
                    return _buildSurahCard(context, surahList[index], langProvider.languageCode);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, SurahInfo surah, String languageCode) {
    final responsive = context.responsive;
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    // Get display name based on language
    String displayName;
    switch (languageCode) {
      case 'ar':
        displayName = surah.name; // Arabic
        break;
      case 'ur':
        displayName = _getUrduName(surah.name); // Urdu transliteration
        break;
      case 'hi':
        displayName = _getHindiName(surah.name); // Hindi transliteration
        break;
      case 'en':
      default:
        displayName = surah.englishName; // English
    }

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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailScreen(surahNumber: surah.number),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Surah Number Badge
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
                    '${surah.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Surah Name and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surah Name (Language-based)
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: (languageCode == 'ar' || languageCode == 'ur')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Ayahs count chip
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Text(
                        '${surah.numberOfAyahs} ${context.tr('ayahs')}',
                        style: TextStyle(
                          fontSize: responsive.textXSmall,
                          fontWeight: FontWeight.w600,
                          color: emeraldGreen,
                        ),
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
