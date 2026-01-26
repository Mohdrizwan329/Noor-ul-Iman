import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'hadith_book_detail_screen.dart';

class SunanAbuDawudScreen extends StatefulWidget {
  const SunanAbuDawudScreen({super.key});

  @override
  State<SunanAbuDawudScreen> createState() => _SunanAbuDawudScreenState();
}

class _SunanAbuDawudScreenState extends State<SunanAbuDawudScreen> {
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

  List<AbuDawudBookInfo> _getFilteredBooks() {
    if (_searchQuery.isEmpty) {
      return _abuDawudBooks;
    }
    final query = _searchQuery.toLowerCase();
    return _abuDawudBooks.where((book) {
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
        title: Text(context.tr('sunan_abu_dawud'), style: TextStyle(fontSize: responsive.textLarge)),
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
                          final originalIndex = _abuDawudBooks.indexOf(book) + 1;
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

  Widget _buildBookCard(BuildContext context, AbuDawudBookInfo book, int number) {
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
                collection: HadithCollection.abudawud,
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
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusXLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: responsive.iconSmall, color: AppColors.secondary),
          SizedBox(width: responsive.spacing(6)),
          Text(label, style: TextStyle(fontSize: responsive.textSmall, color: AppColors.secondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class AbuDawudBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final String urduName;
  final String hindiName;
  final int hadithCount;

  const AbuDawudBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.urduName,
    required this.hindiName,
    required this.hadithCount,
  });
}

// Complete list of all Books in Sunan Abu Dawud
final List<AbuDawudBookInfo> _abuDawudBooks = [
  const AbuDawudBookInfo(id: 1, name: "Kitab at-Taharah (Purification)", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 390),
  const AbuDawudBookInfo(id: 2, name: "Kitab as-Salat (Prayer)", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 457),
  const AbuDawudBookInfo(id: 3, name: "Kitab az-Zakat", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 145),
  const AbuDawudBookInfo(id: 4, name: "Kitab al-Luqatah (Lost & Found)", arabicName: "كتاب اللقطة", urduName: "کتاب اللقطہ", hindiName: "खोई हुई वस्तु की किताब", hadithCount: 25),
  const AbuDawudBookInfo(id: 5, name: "Kitab al-Manasik (Hajj Rituals)", arabicName: "كتاب المناسك", urduName: "کتاب المناسک", hindiName: "हज के रीति-रिवाज़ की किताब", hadithCount: 198),
  const AbuDawudBookInfo(id: 6, name: "Kitab an-Nikah (Marriage)", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 130),
  const AbuDawudBookInfo(id: 7, name: "Kitab at-Talaq (Divorce)", arabicName: "كتاب الطلاق", urduName: "کتاب الطلاق", hindiName: "तलाक़ की किताब", hadithCount: 94),
  const AbuDawudBookInfo(id: 8, name: "Kitab as-Sawm (Fasting)", arabicName: "كتاب الصوم", urduName: "کتاب الصوم", hindiName: "रोज़ा की किताब", hadithCount: 164),
  const AbuDawudBookInfo(id: 9, name: "Kitab al-Jihad", arabicName: "كتاب الجهاد", urduName: "کتاب الجہاد", hindiName: "जिहाद की किताब", hadithCount: 177),
  const AbuDawudBookInfo(id: 10, name: "Kitab as-Sayd (Hunting)", arabicName: "كتاب الصيد", urduName: "کتاب الصید", hindiName: "शिकार की किताब", hadithCount: 40),
  const AbuDawudBookInfo(id: 11, name: "Kitab al-Wasaya (Wills)", arabicName: "كتاب الوصايا", urduName: "کتاب الوصایا", hindiName: "वसीयत की किताब", hadithCount: 20),
  const AbuDawudBookInfo(id: 12, name: "Kitab al-Fara'id (Inheritance)", arabicName: "كتاب الفرائض", urduName: "کتاب الفرائض", hindiName: "विरासत की किताब", hadithCount: 21),
  const AbuDawudBookInfo(id: 13, name: "Kitab al-Kharaj wa al-Imarah (Tribute & Leadership)", arabicName: "كتاب الخراج والإمارة", urduName: "کتاب الخراج والامارہ", hindiName: "कर और नेतृत्व की किताब", hadithCount: 164),
  const AbuDawudBookInfo(id: 14, name: "Kitab al-Jana'iz (Funerals)", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "अंतिम संस्कार की किताब", hadithCount: 134),
  const AbuDawudBookInfo(id: 15, name: "Kitab al-Ayman wa an-Nudhur (Oaths & Vows)", arabicName: "كتاب الأيمان والنذور", urduName: "کتاب الایمان والنذور", hindiName: "कसम और मन्नत की किताब", hadithCount: 67),
  const AbuDawudBookInfo(id: 16, name: "Kitab al-Buyu' (Sales)", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "लेन-देन की किताब", hadithCount: 104),
  const AbuDawudBookInfo(id: 17, name: "Kitab al-Ijarah (Wages)", arabicName: "كتاب الإجارة", urduName: "کتاب الاجارہ", hindiName: "मज़दूरी की किताब", hadithCount: 36),
  const AbuDawudBookInfo(id: 18, name: "Kitab al-Aqdiya (Judgments)", arabicName: "كتاب الأقضية", urduName: "کتاب الاقضیہ", hindiName: "न्यायिक फ़ैसलों की किताब", hadithCount: 60),
  const AbuDawudBookInfo(id: 19, name: "Kitab al-'Ilm (Knowledge)", arabicName: "كتاب العلم", urduName: "کتاب العلم", hindiName: "ज्ञान की किताब", hadithCount: 27),
  const AbuDawudBookInfo(id: 20, name: "Kitab al-Ashriba (Drinks)", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पेय पदार्थों की किताब", hadithCount: 55),
  const AbuDawudBookInfo(id: 21, name: "Kitab al-At'imah (Foods)", arabicName: "كتاب الأطعمة", urduName: "کتاب الاطعمہ", hindiName: "खाद्य पदार्थों की किताब", hadithCount: 93),
  const AbuDawudBookInfo(id: 22, name: "Kitab at-Tibb (Medicine)", arabicName: "كتاب الطب", urduName: "کتاب الطب", hindiName: "चिकित्सा की किताब", hadithCount: 43),
  const AbuDawudBookInfo(id: 23, name: "Kitab al-Libas (Clothing)", arabicName: "كتاب اللباس", urduName: "کتاب اللباس", hindiName: "वस्त्र की किताब", hadithCount: 69),
  const AbuDawudBookInfo(id: 24, name: "Kitab al-Hudud (Punishments)", arabicName: "كتاب الحدود", urduName: "کتاب الحدود", hindiName: "हदूद की किताब", hadithCount: 79),
  const AbuDawudBookInfo(id: 25, name: "Kitab ad-Diyat (Blood Money)", arabicName: "كتاب الديات", urduName: "کتاب الدیات", hindiName: "खून का मुआवज़ा की किताब", hadithCount: 32),
  const AbuDawudBookInfo(id: 26, name: "Kitab al-Adab (Manners)", arabicName: "كتاب الأدب", urduName: "کتاب الادب", hindiName: "शिष्टाचार की किताब", hadithCount: 322),
  const AbuDawudBookInfo(id: 27, name: "Kitab al-Fitan (Tribulations)", arabicName: "كتاب الفتن", urduName: "کتاب الفتن", hindiName: "फ़ितनों की किताब", hadithCount: 87),
  const AbuDawudBookInfo(id: 28, name: "Kitab al-Malahim (Battles)", arabicName: "كتاب الملاحم", urduName: "کتاب الملاحم", hindiName: "युद्धों की किताब", hadithCount: 20),
];
