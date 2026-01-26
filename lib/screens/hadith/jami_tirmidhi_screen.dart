import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'hadith_book_detail_screen.dart';

class JamiTirmidhiScreen extends StatefulWidget {
  const JamiTirmidhiScreen({super.key});

  @override
  State<JamiTirmidhiScreen> createState() => _JamiTirmidhiScreenState();
}

class _JamiTirmidhiScreenState extends State<JamiTirmidhiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hadithProvider = context.read<HadithProvider>();
      final languageProvider = context.read<LanguageProvider>();

      // Sync hadith language with app language
      hadithProvider.syncWithAppLanguage(languageProvider.languageCode);
      hadithProvider.initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TirmidhiBookInfo> _getFilteredBooks() {
    if (_searchQuery.isEmpty) {
      return _tirmidhiBooks;
    }
    final query = _searchQuery.toLowerCase();
    return _tirmidhiBooks.where((book) {
      return book.name.toLowerCase().contains(query) ||
          book.arabicName.contains(query) ||
          book.urduName.contains(query) ||
          book.hindiName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final filteredBooks = _getFilteredBooks();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.tr('jami_tirmidhi'), style: TextStyle(fontSize: responsive.textLarge)),
      ),
      body: Column(
        children: [
          Padding(
            padding: responsive.paddingAll(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_books'),
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
            child: Consumer2<HadithProvider, LanguageProvider>(
              builder: (context, provider, langProvider, child) {
                return filteredBooks.isEmpty
                    ? Center(
                        child: Text(
                          context.tr('no_books_found'),
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: responsive.paddingSymmetric(horizontal: 16, vertical: 0),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          final originalIndex = _tirmidhiBooks.indexOf(book) + 1;
                          return _buildBookCard(context, book, originalIndex);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, TirmidhiBookInfo book, int number) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const softGold = Color(0xFFC9A24D);
    final responsive = context.responsive;

    return Container(
      margin: responsive.paddingOnly(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: lightGreenBorder,
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
              builder: (context) => HadithBookDetailScreen(
                collection: HadithCollection.tirmidhi,
                bookNumber: book.id,
                bookName: book.name,
                bookArabicName: book.arabicName,
                bookUrduName: book.urduName,
                bookHindiName: book.hindiName,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
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
                    '$number',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),
              Expanded(
                child: Consumer<LanguageProvider>(
                  builder: (context, langProvider, child) {
                    String displayName;
                    bool useArabicFont = false;
                    bool useUrduFont = false;
                    TextDirection textDir = TextDirection.ltr;

                    switch (langProvider.languageCode) {
                      case 'ar':
                        displayName = book.arabicName;
                        useArabicFont = true;
                        textDir = TextDirection.rtl;
                        break;
                      case 'ur':
                        displayName = book.urduName;
                        useUrduFont = true;
                        textDir = TextDirection.rtl;
                        break;
                      case 'hi':
                        displayName = book.hindiName;
                        break;
                      case 'en':
                      default:
                        displayName = book.name;
                        break;
                    }

                    return Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                        fontFamily: useArabicFont ? 'Amiri' : (useUrduFont ? 'NotoNastaliq' : null),
                      ),
                      textDirection: textDir,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
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

  void _showBookInfo(BuildContext context, HadithCollectionInfo info) {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.radiusXLarge)),
      ),
      builder: (context) => Padding(
        padding: responsive.paddingAll(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: responsive.paddingAll(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  ),
                  child: Icon(Icons.menu_book, color: AppColors.primary, size: responsive.iconXLarge),
                ),
                SizedBox(width: responsive.spaceRegular),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name,
                        style: TextStyle(fontSize: responsive.textXLarge, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info.arabicName,
                        style: TextStyle(fontSize: responsive.textRegular, fontFamily: 'Amiri'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spaceRegular),
            Text(
              '${context.tr('compiled_by')}: ${info.compiler}',
              style: TextStyle(fontSize: responsive.textMedium, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: responsive.spaceSmall),
            Text(
              info.description,
              style: TextStyle(fontSize: responsive.textMedium, height: 1.5),
            ),
            SizedBox(height: responsive.spaceRegular),
            Row(
              children: [
                _InfoChip(icon: Icons.book, label: '${info.totalBooks} ${context.tr('books')}'),
                SizedBox(width: responsive.spaceMedium),
                _InfoChip(icon: Icons.format_list_numbered, label: '${info.totalHadith} ${context.tr('hadiths')}'),
              ],
            ),
            SizedBox(height: responsive.spaceLarge),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Container(
      padding: responsive.paddingSymmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusXLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: responsive.iconSmall, color: AppColors.primary),
          SizedBox(width: responsive.spacing(6)),
          Text(label, style: TextStyle(fontSize: responsive.textSmall, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class TirmidhiBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final String urduName;
  final String hindiName;
  final int hadithCount;

  const TirmidhiBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.urduName,
    required this.hindiName,
    required this.hadithCount,
  });
}

// Complete list of all 33 Books in Jami at-Tirmidhi
final List<TirmidhiBookInfo> _tirmidhiBooks = [
  const TirmidhiBookInfo(id: 1, name: "Kitab at-Taharah (Purification)", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 148),
  const TirmidhiBookInfo(id: 2, name: "Kitab as-Salat (Prayer)", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 423),
  const TirmidhiBookInfo(id: 3, name: "Kitab az-Zakat", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 89),
  const TirmidhiBookInfo(id: 4, name: "Kitab as-Sawm (Fasting)", arabicName: "كتاب الصوم", urduName: "کتاب الصوم", hindiName: "रोज़ा की किताब", hadithCount: 128),
  const TirmidhiBookInfo(id: 5, name: "Kitab al-Hajj (Pilgrimage)", arabicName: "كتاب الحج", urduName: "کتاب الحج", hindiName: "हज की किताब", hadithCount: 157),
  const TirmidhiBookInfo(id: 6, name: "Kitab al-Jana'iz (Funerals)", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "अंतिम संस्कार की किताब", hadithCount: 121),
  const TirmidhiBookInfo(id: 7, name: "Kitab an-Nikah (Marriage)", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 74),
  const TirmidhiBookInfo(id: 8, name: "Kitab ar-Rada'ah (Breastfeeding)", arabicName: "كتاب الرضاع", urduName: "کتاب الرضاع", hindiName: "दूध पिलाने की किताब", hadithCount: 28),
  const TirmidhiBookInfo(id: 9, name: "Kitab at-Talaq (Divorce)", arabicName: "كتاب الطلاق واللعان", urduName: "کتاب الطلاق واللعان", hindiName: "तलाक़ की किताब", hadithCount: 48),
  const TirmidhiBookInfo(id: 10, name: "Kitab al-Buyu' (Sales)", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "लेन-देन की किताब", hadithCount: 106),
  const TirmidhiBookInfo(id: 11, name: "Kitab al-Ahkam (Judgments)", arabicName: "كتاب الأحكام", urduName: "کتاب الاحکام", hindiName: "न्यायिक फ़ैसलों की किताब", hadithCount: 79),
  const TirmidhiBookInfo(id: 12, name: "Kitab ad-Diyat (Blood Money)", arabicName: "كتاب الديات", urduName: "کتاب الدیات", hindiName: "खून का मुआवज़ा की किताब", hadithCount: 37),
  const TirmidhiBookInfo(id: 13, name: "Kitab al-Hudud (Legal Punishments)", arabicName: "كتاب الحدود", urduName: "کتاب الحدود", hindiName: "हदूद की किताब", hadithCount: 76),
  const TirmidhiBookInfo(id: 14, name: "Kitab as-Sayd (Hunting)", arabicName: "كتاب الصيد", urduName: "کتاب الصید", hindiName: "शिकार की किताब", hadithCount: 26),
  const TirmidhiBookInfo(id: 15, name: "Kitab adh-Dhaba'ih (Slaughtering)", arabicName: "كتاب الذبائح", urduName: "کتاب الذبائح", hindiName: "ज़बीहा की किताब", hadithCount: 25),
  const TirmidhiBookInfo(id: 16, name: "Kitab al-Adahi (Sacrifices)", arabicName: "كتاب الأضاحي", urduName: "کتاب الاضاحی", hindiName: "क़ुर्बानी की किताब", hadithCount: 31),
  const TirmidhiBookInfo(id: 17, name: "Kitab al-Ashriba (Drinks)", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पेय पदार्थों की किताब", hadithCount: 61),
  const TirmidhiBookInfo(id: 18, name: "Kitab al-Libas (Clothing)", arabicName: "كتاب اللباس", urduName: "کتاب اللباس", hindiName: "वस्त्र की किताब", hadithCount: 72),
  const TirmidhiBookInfo(id: 19, name: "Kitab al-Adab (Manners)", arabicName: "كتاب الأدب", urduName: "کتاب الادب", hindiName: "शिष्टाचार की किताब", hadithCount: 120),
  const TirmidhiBookInfo(id: 20, name: "Kitab al-'Ilm (Knowledge)", arabicName: "كتاب العلم", urduName: "کتاب العلم", hindiName: "ज्ञान की किताब", hadithCount: 29),
  const TirmidhiBookInfo(id: 21, name: "Kitab al-Isti'dhan (Seeking Permission)", arabicName: "كتاب الاستئذان والآداب", urduName: "کتاب الاستئذان والآداب", hindiName: "अनुमति लेने की किताब", hadithCount: 43),
  const TirmidhiBookInfo(id: 22, name: "Kitab al-Birr wa as-Silah (Righteousness & Ties)", arabicName: "كتاب البر والصلة", urduName: "کتاب البر والصلہ", hindiName: "नेकी और रिश्तों की किताब", hadithCount: 107),
  const TirmidhiBookInfo(id: 23, name: "Kitab al-Qadr (Destiny)", arabicName: "كتاب القدر", urduName: "کتاب القدر", hindiName: "तक़दीर की किताब", hadithCount: 27),
  const TirmidhiBookInfo(id: 24, name: "Kitab al-Fitan (Tribulations)", arabicName: "كتاب الفتن", urduName: "کتاب الفتن", hindiName: "फ़ितनों की किताब", hadithCount: 79),
  const TirmidhiBookInfo(id: 25, name: "Kitab az-Zuhd (Asceticism)", arabicName: "كتاب الزهد", urduName: "کتاب الزہد", hindiName: "ज़ुहद की किताब", hadithCount: 113),
  const TirmidhiBookInfo(id: 26, name: "Kitab al-Manaqib (Virtues)", arabicName: "كتاب المناقب", urduName: "کتاب المناقب", hindiName: "फ़ज़ीलतों की किताब", hadithCount: 279),
  const TirmidhiBookInfo(id: 27, name: "Kitab al-Amthal (Parables)", arabicName: "كتاب الأمثال", urduName: "کتاب الامثال", hindiName: "मिसालों की किताब", hadithCount: 19),
  const TirmidhiBookInfo(id: 28, name: "Kitab al-Qira'at (Recitations)", arabicName: "كتاب القراءات", urduName: "کتاب القراءات", hindiName: "क़िराअतों की किताब", hadithCount: 18),
  const TirmidhiBookInfo(id: 29, name: "Kitab at-Tafsir (Qur'anic Exegesis)", arabicName: "كتاب التفسير", urduName: "کتاب التفسیر", hindiName: "तफ़्सीर की किताब", hadithCount: 406),
  const TirmidhiBookInfo(id: 30, name: "Kitab ad-Da'awat (Supplications)", arabicName: "كتاب الدعوات", urduName: "کتاب الدعوات", hindiName: "दुआओं की किताब", hadithCount: 146),
  const TirmidhiBookInfo(id: 31, name: "Kitab Fada'il al-Qur'an (Virtues of Qur'an)", arabicName: "كتاب فضائل القرآن", urduName: "کتاب فضائل القرآن", hindiName: "क़ुरआन की फ़ज़ीलतों की किताब", hadithCount: 48),
  const TirmidhiBookInfo(id: 32, name: "Kitab al-Iman (Faith)", arabicName: "كتاب الإيمان", urduName: "کتاب الایمان", hindiName: "ईमान की किताब", hadithCount: 39),
  const TirmidhiBookInfo(id: 33, name: "Kitab Sifat al-Qiyamah (Day of Judgment)", arabicName: "كتاب صفة القيامة والرقائق والورع", urduName: "کتاب صفۃ القیامہ", hindiName: "क़यामत की किताब", hadithCount: 113),
];
