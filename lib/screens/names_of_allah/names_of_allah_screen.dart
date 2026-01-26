import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/allah_name_model.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'name_of_allah_detail_screen.dart';
import '../../core/utils/localization_helper.dart';

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key});

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AllahNameModel> _filteredNames = AllahNames.names;

  @override
  void initState() {
    super.initState();

    // Listen to language changes to force rebuild
  }

  @override

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNames = AllahNames.names;
      } else {
        _filteredNames = AllahNames.names.where((name) {
          return name.transliteration.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              name.meaning.toLowerCase().contains(query.toLowerCase()) ||
              name.number.toString() == query;
        }).toList();
      }
    });
  }

  String _transliterateToHindi(String text) {
    // Transliteration map: English names to Hindi Devanagari
    final Map<String, String> map = {
      'Allah': 'अल्लाह', 'Ar-Rahman': 'अर-रहमान', 'Ar-Raheem': 'अर-रहीम',
      'Al-Malik': 'अल-मलिक', 'Al-Quddus': 'अल-कुद्दूस', 'As-Salam': 'अस-सलाम',
      'Al-Mumin': 'अल-मुमिन', 'Al-Muhaymin': 'अल-मुहैमिन', 'Al-Aziz': 'अल-अज़ीज़',
      'Al-Jabbar': 'अल-जब्बार', 'Al-Mutakabbir': 'अल-मुतकब्बिर', 'Al-Khaliq': 'अल-ख़ालिक़',
      'Al-Bari': 'अल-बारी', 'Al-Musawwir': 'अल-मुसव्विर', 'Al-Ghaffar': 'अल-ग़फ़्फ़ार',
      'Al-Qahhar': 'अल-क़ह्हार', 'Al-Wahhab': 'अल-वह्हाब', 'Ar-Razzaq': 'अर-रज़्ज़ाक़',
      'Al-Fattah': 'अल-फ़त्ताह', 'Al-Alim': 'अल-अलीम', 'Al-Qabid': 'अल-क़ाबिद',
      'Al-Basit': 'अल-बासित', 'Al-Khafid': 'अल-ख़ाफ़िद', 'Ar-Rafi': 'अर-राफ़ि',
      'Al-Muizz': 'अल-मुइज़्ज़', 'Al-Mudhill': 'अल-मुज़िल्ल', 'As-Sami': 'अस-समी',
      'Al-Basir': 'अल-बसीर', 'Al-Hakam': 'अल-हकम', 'Al-Adl': 'अल-अद्ल',
      'Al-Latif': 'अल-लतीफ़', 'Al-Khabir': 'अल-ख़बीर', 'Al-Halim': 'अल-हलीम',
      'Al-Azim': 'अल-अज़ीम', 'Al-Ghafur': 'अल-ग़फ़ूर', 'Ash-Shakur': 'अश-शकूर',
      'Al-Ali': 'अल-अली', 'Al-Kabir': 'अल-कबीर', 'Al-Hafiz': 'अल-हाफ़िज़',
      'Al-Muqit': 'अल-मुक़ीत', 'Al-Hasib': 'अल-हसीब', 'Al-Jalil': 'अल-जलील',
      'Al-Karim': 'अल-करीम', 'Ar-Raqib': 'अर-रक़ीब', 'Al-Mujib': 'अल-मुजीब',
      'Al-Wasi': 'अल-वासि', 'Al-Hakim': 'अल-हकीम', 'Al-Wadud': 'अल-वदूद',
      'Al-Majid': 'अल-मजीद', 'Al-Baith': 'अल-बाइस', 'Ash-Shahid': 'अश-शहीद',
      'Al-Haqq': 'अल-हक़्क़', 'Al-Wakil': 'अल-वकील', 'Al-Qawiyy': 'अल-क़वीय्य',
      'Al-Matin': 'अल-मतीन', 'Al-Waliyy': 'अल-वलीय्य', 'Al-Hamid': 'अल-हमीद',
      'Al-Muhsi': 'अल-मुहसी', 'Al-Mubdi': 'अल-मुब्दि', 'Al-Muid': 'अल-मुईद',
      'Al-Muhyi': 'अल-मुह्यी', 'Al-Mumit': 'अल-मुमीत', 'Al-Hayy': 'अल-हय्य',
      'Al-Qayyum': 'अल-क़य्यूम', 'Al-Wajid': 'अल-वाजिद', 'Al-Wahid': 'अल-वाहिद',
      'Al-Ahad': 'अल-अहद', 'As-Samad': 'अस-समद', 'Al-Qadir': 'अल-क़ादिर',
      'Al-Muqtadir': 'अल-मुक़्तदिर', 'Al-Muqaddim': 'अल-मुक़द्दिम', 'Al-Muakhkhir': 'अल-मुअख़्ख़ि���',
      'Al-Awwal': 'अल-अव्वल', 'Al-Akhir': 'अल-आख़िर', 'Az-Zahir': 'अज़-ज़ाहिर',
      'Al-Batin': 'अल-बातिन', 'Al-Wali': 'अल-वाली', 'Al-Mutaali': 'अल-मुताली',
      'Al-Barr': 'अल-बर्र', 'At-Tawwab': 'अत-तव्वाब', 'Al-Muntaqim': 'अल-मुन्तक़िम',
      'Al-Afuww': 'अल-अफ़ुव्व', 'Ar-Rauf': 'अर-रऊफ़', 'Malik-ul-Mulk': 'मलिक-उल-मुल्क',
      'Dhul-Jalal-wal-Ikram': 'ज़ुल-जलाल-वल-इकराम', 'Al-Muqsit': 'अल-मुक़सित',
      'Al-Jami': 'अल-जामि', 'Al-Ghani': 'अल-ग़नी', 'Al-Mughni': 'अल-मुग़नी',
      'Al-Mani': 'अल-मानि', 'Ad-Darr': 'अद-दर्र', 'An-Nafi': 'अन-नाफ़ि',
      'An-Nur': 'अन-नूर', 'Al-Hadi': 'अल-हादी', 'Al-Badi': 'अल-बदी',
      'Al-Baqi': 'अल-बाक़ी', 'Al-Warith': 'अल-वारिस', 'Ar-Rashid': 'अर-रशीद',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    // Transliteration map: English names to Urdu script
    final Map<String, String> map = {
      'Allah': 'اللہ', 'Ar-Rahman': 'الرحمان', 'Ar-Raheem': 'الرحیم',
      'Al-Malik': 'الملک', 'Al-Quddus': 'القدوس', 'As-Salam': 'السلام',
      'Al-Mumin': 'المومن', 'Al-Muhaymin': 'المہیمن', 'Al-Aziz': 'العزیز',
      'Al-Jabbar': 'الجبار', 'Al-Mutakabbir': 'المتکبر', 'Al-Khaliq': 'الخالق',
      'Al-Bari': 'الباری', 'Al-Musawwir': 'المصور', 'Al-Ghaffar': 'الغفار',
      'Al-Qahhar': 'القہار', 'Al-Wahhab': 'الوہاب', 'Ar-Razzaq': 'الرزاق',
      'Al-Fattah': 'الفتاح', 'Al-Alim': 'العلیم', 'Al-Qabid': 'القابض',
      'Al-Basit': 'الباسط', 'Al-Khafid': 'الخافض', 'Ar-Rafi': 'الرافع',
      'Al-Muizz': 'المعز', 'Al-Mudhill': 'المذل', 'As-Sami': 'السمیع',
      'Al-Basir': 'البصیر', 'Al-Hakam': 'الحکم', 'Al-Adl': 'العدل',
      'Al-Latif': 'اللطیف', 'Al-Khabir': 'الخبیر', 'Al-Halim': 'الحلیم',
      'Al-Azim': 'العظیم', 'Al-Ghafur': 'الغفور', 'Ash-Shakur': 'الشکور',
      'Al-Ali': 'العلی', 'Al-Kabir': 'الکبیر', 'Al-Hafiz': 'الحفیظ',
      'Al-Muqit': 'المقیت', 'Al-Hasib': 'الحسیب', 'Al-Jalil': 'الجلیل',
      'Al-Karim': 'الکریم', 'Ar-Raqib': 'الرقیب', 'Al-Mujib': 'المجیب',
      'Al-Wasi': 'الواسع', 'Al-Hakim': 'الحکیم', 'Al-Wadud': 'الودود',
      'Al-Majid': 'المجید', 'Al-Baith': 'الباعث', 'Ash-Shahid': 'الشہید',
      'Al-Haqq': 'الحق', 'Al-Wakil': 'الوکیل', 'Al-Qawiyy': 'القوی',
      'Al-Matin': 'المتین', 'Al-Waliyy': 'الولی', 'Al-Hamid': 'الحمید',
      'Al-Muhsi': 'المحصی', 'Al-Mubdi': 'المبدی', 'Al-Muid': 'المعید',
      'Al-Muhyi': 'المحیی', 'Al-Mumit': 'الممیت', 'Al-Hayy': 'الحی',
      'Al-Qayyum': 'القیوم', 'Al-Wajid': 'الواجد', 'Al-Wahid': 'الواحد',
      'Al-Ahad': 'الاحد', 'As-Samad': 'الصمد', 'Al-Qadir': 'القادر',
      'Al-Muqtadir': 'المقتدر', 'Al-Muqaddim': 'المقدم', 'Al-Muakhkhir': 'المؤخر',
      'Al-Awwal': 'الاول', 'Al-Akhir': 'الآخر', 'Az-Zahir': 'الظاہر',
      'Al-Batin': 'الباطن', 'Al-Wali': 'الوالی', 'Al-Mutaali': 'المتعالی',
      'Al-Barr': 'البر', 'At-Tawwab': 'التواب', 'Al-Muntaqim': 'المنتقم',
      'Al-Afuww': 'العفو', 'Ar-Rauf': 'الرؤوف', 'Malik-ul-Mulk': 'مالک الملک',
      'Dhul-Jalal-wal-Ikram': 'ذوالجلال والاکرام', 'Al-Muqsit': 'المقسط',
      'Al-Jami': 'الجامع', 'Al-Ghani': 'الغنی', 'Al-Mughni': 'المغنی',
      'Al-Mani': 'المانع', 'Ad-Darr': 'الضار', 'An-Nafi': 'النافع',
      'An-Nur': 'النور', 'Al-Hadi': 'الہادی', 'Al-Badi': 'البدیع',
      'Al-Baqi': 'الباقی', 'Al-Warith': 'الوارث', 'Ar-Rashid': 'الرشید',
    };
    return map[text] ?? text;
  }

  String _getDisplayName(AllahNameModel name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name.name; // Arabic: الله، الرَّحْمَنُ
      case 'hi':
        return _transliterateToHindi(name.transliteration); // Hindi: अल्लाह, अर-रहमान
      case 'ur':
        return _transliterateToUrdu(name.transliteration); // Urdu: اللہ، الرحمان
      default:
        return name.transliteration; // English: Allah, Ar-Rahman
    }
  }

  String _getDisplayMeaning(AllahNameModel name, String languageCode) {
    // Return meaning in selected language (not used anymore but kept for future)
    switch (languageCode) {
      case 'ar':
        return name.meaning;
      case 'ur':
        return name.meaningUrdu.isNotEmpty ? name.meaningUrdu : name.meaning;
      case 'hi':
        return name.meaningHindi.isNotEmpty ? name.meaningHindi : name.meaning;
      case 'en':
      default:
        return name.meaning;
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final langProvider = context.watch<LanguageProvider>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('names_of_allah'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Column(
        children: [
          // Header Info Card

          // Search Field
          Padding(
            padding: responsive.paddingAll(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_name_meaning_number'),
              onChanged: _filterNames,
              onClear: () => _filterNames(''),
              enableVoiceSearch: true,
            ),
          ),

          // Names Count
          Padding(
            padding: responsive.paddingSymmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${context.tr('showing')} ${_filteredNames.length} ${context.tr('of_99_names')}',
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spaceSmall),

          // Names List
          Expanded(
            child: _filteredNames.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: responsive.iconHuge,
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        SizedBox(height: responsive.spaceRegular),
                        Text(
                          context.tr('no_names_found'),
                          style: TextStyle(
                            fontSize: responsive.textRegular,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(langProvider.languageCode), // Force rebuild when language changes
                    padding: responsive.paddingSymmetric(horizontal: 16),
                    itemCount: _filteredNames.length,
                    itemBuilder: (context, index) {
                      final name = _filteredNames[index];
                      final displayName = _getDisplayName(name, langProvider.languageCode);
                      final displayMeaning = _getDisplayMeaning(name, langProvider.languageCode);
                      return _buildNameCard(
                        name: name,
                        isDark: isDark,
                        displayName: displayName,
                        displayMeaning: displayMeaning,
                        languageCode: langProvider.languageCode,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard({
    required AllahNameModel name,
    required bool isDark,
    required String displayName,
    required String displayMeaning,
    required String languageCode,
  }) {
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
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: darkGreen.withValues(alpha: 0.08),
                  blurRadius: responsive.spacing(10),
                  offset: Offset(0, responsive.spacing(2)),
                ),
              ],
      ),
      child: InkWell(
        onTap: () => _showNameDetail(name),
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
                  color: isDark ? emeraldGreen : darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? emeraldGreen : darkGreen).withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${name.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Name Info
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : darkGreen,
                    fontFamily: languageCode == 'ar'
                        ? 'Amiri'
                        : (languageCode == 'ur' ? 'NotoNastaliq' : null),
                  ),
                  textDirection: (languageCode == 'ar' || languageCode == 'ur')
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),

              // Arrow only
              Container(
                padding: responsive.paddingAll(6),
                decoration: BoxDecoration(
                  color: isDark ? emeraldGreen : emeraldGreen,
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

  void _showNameDetail(AllahNameModel name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameOfAllahDetailScreen(name: name),
      ),
    );
  }
}
