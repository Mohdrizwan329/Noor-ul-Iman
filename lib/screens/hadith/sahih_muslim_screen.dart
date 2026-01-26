import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'hadith_book_detail_screen.dart';

class SahihMuslimScreen extends StatefulWidget {
  const SahihMuslimScreen({super.key});

  @override
  State<SahihMuslimScreen> createState() => _SahihMuslimScreenState();
}

class _SahihMuslimScreenState extends State<SahihMuslimScreen> {
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

  List<MuslimBookInfo> _getFilteredBooks() {
    if (_searchQuery.isEmpty) {
      return _muslimBooks;
    }
    final query = _searchQuery.toLowerCase();
    return _muslimBooks.where((book) {
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
        title: Text(context.tr('sahih_muslim'), style: TextStyle(fontSize: responsive.textLarge)),
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
                          final originalIndex = _muslimBooks.indexOf(book) + 1;
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

  Widget _buildBookCard(BuildContext context, MuslimBookInfo book, int number) {
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
                collection: HadithCollection.muslim,
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
              // Book Number
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

              // Book Info
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

              // Arrow Icon
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

// Muslim Book Info Model
class MuslimBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final String urduName;
  final String hindiName;
  final int hadithCount;

  const MuslimBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.urduName,
    required this.hindiName,
    required this.hadithCount,
  });
}

// Complete list of all 56 Books in Sahih Muslim
final List<MuslimBookInfo> _muslimBooks = [
  const MuslimBookInfo(id: 1, name: "The Book of Faith", arabicName: "كتاب الإيمان", urduName: "کتاب الایمان", hindiName: "ईमान की किताब", hadithCount: 432),
  const MuslimBookInfo(id: 2, name: "The Book of Purification", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 279),
  const MuslimBookInfo(id: 3, name: "The Book of Menstruation", arabicName: "كتاب الحيض", urduName: "کتاب الحیض", hindiName: "माहवारी की किताब", hadithCount: 139),
  const MuslimBookInfo(id: 4, name: "The Book of Prayer", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 285),
  const MuslimBookInfo(id: 5, name: "The Book of Mosques", arabicName: "كتاب المساجد", urduName: "کتاب المساجد", hindiName: "मस्जिदों की किताब", hadithCount: 319),
  const MuslimBookInfo(id: 6, name: "The Book of Prayer - Travellers", arabicName: "كتاب صلاة المسافرين", urduName: "کتاب صلوٰۃ المسافرین", hindiName: "मुसाफ़िरों की नमाज़ की किताब", hadithCount: 311),
  const MuslimBookInfo(id: 7, name: "The Book of Friday Prayer", arabicName: "كتاب الجمعة", urduName: "کتاب الجمعہ", hindiName: "जुमा की नमाज़ की किताब", hadithCount: 68),
  const MuslimBookInfo(id: 8, name: "The Book of Eid Prayer", arabicName: "كتاب صلاة العيدين", urduName: "کتاب صلوٰۃ العیدین", hindiName: "ईद की नमाज़ की किताब", hadithCount: 26),
  const MuslimBookInfo(id: 9, name: "The Book of Prayer for Rain", arabicName: "كتاب الاستسقاء", urduName: "کتاب الاستسقاء", hindiName: "बारिश की दुआ की किताब", hadithCount: 16),
  const MuslimBookInfo(id: 10, name: "The Book of Eclipse Prayer", arabicName: "كتاب الكسوف", urduName: "کتاب الکسوف", hindiName: "ग्रहण की नमाज़ की किताब", hadithCount: 31),
  const MuslimBookInfo(id: 11, name: "The Book of Funerals", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "अंतिम संस्कार की किताब", hadithCount: 163),
  const MuslimBookInfo(id: 12, name: "The Book of Zakat", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 224),
  const MuslimBookInfo(id: 13, name: "The Book of Fasting", arabicName: "كتاب الصيام", urduName: "کتاب الصیام", hindiName: "रोज़ा की किताब", hadithCount: 222),
  const MuslimBookInfo(id: 14, name: "The Book of Itikaf", arabicName: "كتاب الاعتكاف", urduName: "کتاب الاعتکاف", hindiName: "एतिकाफ़ की किताब", hadithCount: 11),
  const MuslimBookInfo(id: 15, name: "The Book of Pilgrimage", arabicName: "كتاب الحج", urduName: "کتاب الحج", hindiName: "हज की किताब", hadithCount: 605),
  const MuslimBookInfo(id: 16, name: "The Book of Marriage", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 174),
  const MuslimBookInfo(id: 17, name: "The Book of Suckling", arabicName: "كتاب الرضاع", urduName: "کتاب الرضاع", hindiName: "दूध पिलाने की किताब", hadithCount: 56),
  const MuslimBookInfo(id: 18, name: "The Book of Divorce", arabicName: "كتاب الطلاق", urduName: "کتاب الطلاق", hindiName: "तलाक़ की किताब", hadithCount: 75),
  const MuslimBookInfo(id: 19, name: "The Book of Cursing", arabicName: "كتاب اللعان", urduName: "کتاب اللعان", hindiName: "लानत की किताब", hadithCount: 23),
  const MuslimBookInfo(id: 20, name: "The Book of Manumission", arabicName: "كتاب العتق", urduName: "کتاب العتق", hindiName: "आज़ादी की किताब", hadithCount: 49),
  const MuslimBookInfo(id: 21, name: "The Book of Transactions", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "लेन-देन की किताब", hadithCount: 146),
  const MuslimBookInfo(id: 22, name: "The Book of Agriculture", arabicName: "كتاب المساقاة", urduName: "کتاب المساقاۃ", hindiName: "खेती की किताब", hadithCount: 83),
  const MuslimBookInfo(id: 23, name: "The Book of Inheritance", arabicName: "كتاب الفرائض", urduName: "کتاب الفرائض", hindiName: "विरासत की किताब", hadithCount: 19),
  const MuslimBookInfo(id: 24, name: "The Book of Gifts", arabicName: "كتاب الهبات", urduName: "کتاب الہبات", hindiName: "उपहार की किताब", hadithCount: 35),
  const MuslimBookInfo(id: 25, name: "The Book of Wills", arabicName: "كتاب الوصية", urduName: "کتاب الوصیہ", hindiName: "वसीयत की किताब", hadithCount: 29),
  const MuslimBookInfo(id: 26, name: "The Book of Vows", arabicName: "كتاب النذر", urduName: "کتاب النذر", hindiName: "मन्नत की किताब", hadithCount: 26),
  const MuslimBookInfo(id: 27, name: "The Book of Oaths", arabicName: "كتاب الأيمان", urduName: "کتاب الایمان", hindiName: "कसम की किताब", hadithCount: 61),
  const MuslimBookInfo(id: 28, name: "The Book of Oaths (Qasama)", arabicName: "كتاب القسامة", urduName: "کتاب القسامہ", hindiName: "क़सामा की किताब", hadithCount: 37),
  const MuslimBookInfo(id: 29, name: "The Book of Legal Punishments", arabicName: "كتاب الحدود", urduName: "کتاب الحدود", hindiName: "हदूद की किताब", hadithCount: 71),
  const MuslimBookInfo(id: 30, name: "The Book of Judicial Decisions", arabicName: "كتاب الأقضية", urduName: "کتاب الاقضیہ", hindiName: "न्यायिक फ़ैसलों की किताब", hadithCount: 30),
  const MuslimBookInfo(id: 31, name: "The Book of Lost Property", arabicName: "كتاب اللقطة", urduName: "کتاب اللقطہ", hindiName: "खोई हुई वस्तु की किताब", hadithCount: 21),
  const MuslimBookInfo(id: 32, name: "The Book of Jihad", arabicName: "كتاب الجهاد والسير", urduName: "کتاب الجہاد والسیر", hindiName: "जिहाद की किताब", hadithCount: 203),
  const MuslimBookInfo(id: 33, name: "The Book of Leadership", arabicName: "كتاب الإمارة", urduName: "کتاب الامارہ", hindiName: "नेतृत्व की किताब", hadithCount: 251),
  const MuslimBookInfo(id: 34, name: "The Book of Hunting", arabicName: "كتاب الصيد والذبائح", urduName: "کتاب الصید والذبائح", hindiName: "शिकार और ज़बीहा की किताब", hadithCount: 74),
  const MuslimBookInfo(id: 35, name: "The Book of Sacrifices", arabicName: "كتاب الأضاحي", urduName: "کتاب الاضاحی", hindiName: "क़ुर्बानी की किताब", hadithCount: 46),
  const MuslimBookInfo(id: 36, name: "The Book of Drinks", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पेय पदार्थों की किताब", hadithCount: 183),
  const MuslimBookInfo(id: 37, name: "The Book of Clothes", arabicName: "كتاب اللباس والزينة", urduName: "کتاب اللباس والزینہ", hindiName: "वस्त्र और सजावट की किताब", hadithCount: 136),
  const MuslimBookInfo(id: 38, name: "The Book of Good Manners", arabicName: "كتاب الآداب", urduName: "کتاب الآداب", hindiName: "शिष्टाचार की किताब", hadithCount: 56),
  const MuslimBookInfo(id: 39, name: "The Book of Greetings", arabicName: "كتاب السلام", urduName: "کتاب السلام", hindiName: "सलाम की किताब", hadithCount: 166),
  const MuslimBookInfo(id: 40, name: "The Book of Poetry", arabicName: "كتاب الشعر", urduName: "کتاب الشعر", hindiName: "शायरी की किताब", hadithCount: 10),
  const MuslimBookInfo(id: 41, name: "The Book of Dreams", arabicName: "كتاب الرؤيا", urduName: "کتاب الرؤیا", hindiName: "ख़्वाब की किताब", hadithCount: 28),
  const MuslimBookInfo(id: 42, name: "The Book of Virtues", arabicName: "كتاب الفضائل", urduName: "کتاب الفضائل", hindiName: "फ़ज़ीलतों की किताब", hadithCount: 167),
  const MuslimBookInfo(id: 43, name: "The Book of Companions", arabicName: "كتاب فضائل الصحابة", urduName: "کتاب فضائل الصحابہ", hindiName: "सहाबा की फ़ज़ीलतों की किताब", hadithCount: 270),
  const MuslimBookInfo(id: 44, name: "The Book of Righteousness", arabicName: "كتاب البر والصلة", urduName: "کتاب البر والصلہ", hindiName: "नेकी और रिश्तों की किताब", hadithCount: 181),
  const MuslimBookInfo(id: 45, name: "The Book of Destiny", arabicName: "كتاب القدر", urduName: "کتاب القدر", hindiName: "तक़दीर की किताब", hadithCount: 44),
  const MuslimBookInfo(id: 46, name: "The Book of Knowledge", arabicName: "كتاب العلم", urduName: "کتاب العلم", hindiName: "ज्ञान की किताब", hadithCount: 21),
  const MuslimBookInfo(id: 47, name: "The Book of Remembrance", arabicName: "كتاب الذكر والدعاء", urduName: "کتاب الذکر والدعاء", hindiName: "ज़िक्र और दुआ की किताब", hadithCount: 110),
  const MuslimBookInfo(id: 48, name: "The Book of Repentance", arabicName: "كتاب التوبة", urduName: "کتاب التوبہ", hindiName: "तौबा की किताब", hadithCount: 77),
  const MuslimBookInfo(id: 49, name: "The Book of Hypocrites", arabicName: "كتاب صفات المنافقين", urduName: "کتاب صفات المنافقین", hindiName: "मुनाफ़िक़ों की किताब", hadithCount: 36),
  const MuslimBookInfo(id: 50, name: "The Book of Paradise", arabicName: "كتاب الجنة وصفة نعيمها", urduName: "کتاب الجنۃ وصفۃ نعیمہا", hindiName: "जन्नत की किताब", hadithCount: 93),
  const MuslimBookInfo(id: 51, name: "The Book of Tribulations", arabicName: "كتاب الفتن وأشراط الساعة", urduName: "کتاب الفتن واشراط الساعہ", hindiName: "फ़ितनों और क़यामत की निशानियों की किताब", hadithCount: 161),
  const MuslimBookInfo(id: 52, name: "The Book of Asceticism", arabicName: "كتاب الزهد والرقائق", urduName: "کتاب الزہد والرقائق", hindiName: "ज़ुहद और नर्म दिली की किताब", hadithCount: 80),
  const MuslimBookInfo(id: 53, name: "The Book of Tafsir", arabicName: "كتاب التفسير", urduName: "کتاب التفسیر", hindiName: "तफ़्सीर की किताब", hadithCount: 51),
  const MuslimBookInfo(id: 54, name: "Introduction", arabicName: "المقدمة", urduName: "المقدمہ", hindiName: "मुक़द्दमा", hadithCount: 89),
  const MuslimBookInfo(id: 55, name: "The Book of Foods", arabicName: "كتاب الأطعمة", urduName: "کتاب الاطعمہ", hindiName: "खाद्य पदार्थों की किताब", hadithCount: 168),
  const MuslimBookInfo(id: 56, name: "The Book of Aqeeqa", arabicName: "كتاب العقيقة", urduName: "کتاب العقیقہ", hindiName: "अक़ीक़ा की किताब", hadithCount: 8),
];
