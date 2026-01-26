import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'hadith_book_detail_screen.dart';

class SahihBukhariScreen extends StatefulWidget {
  const SahihBukhariScreen({super.key});

  @override
  State<SahihBukhariScreen> createState() => _SahihBukhariScreenState();
}

class _SahihBukhariScreenState extends State<SahihBukhariScreen> {
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

  List<BukhariBookInfo> _getFilteredBooks() {
    if (_searchQuery.isEmpty) {
      return _bukhariBooks;
    }
    final query = _searchQuery.toLowerCase();
    return _bukhariBooks.where((book) {
      return book.name.toLowerCase().contains(query) ||
          book.arabicName.contains(query);
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
        title: Text(context.tr('sahih_bukhari'), style: TextStyle(fontSize: responsive.textLarge)),
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
                          final originalIndex = _bukhariBooks.indexOf(book) + 1;
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

  Widget _buildBookCard(BuildContext context, BukhariBookInfo book, int number) {
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
                collection: HadithCollection.bukhari,
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
                    TextDirection textDir = TextDirection.ltr;

                    switch (langProvider.languageCode) {
                      case 'ar':
                        displayName = book.arabicName;
                        useArabicFont = true;
                        textDir = TextDirection.rtl;
                        break;
                      case 'ur':
                        displayName = book.urduName;
                        useArabicFont = true;
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
                        fontFamily: useArabicFont ? 'Amiri' : null,
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

// Bukhari Book Info Model
class BukhariBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final String urduName;
  final String hindiName;
  final int hadithCount;
  final int startHadith;
  final int endHadith;

  const BukhariBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.urduName,
    required this.hindiName,
    required this.hadithCount,
    required this.startHadith,
    required this.endHadith,
  });
}

// Complete list of all 97 Books in Sahih Bukhari (API numbering)
// Note: Classical scholars count 73 Kutub, but modern API uses 97 book divisions
final List<BukhariBookInfo> _bukhariBooks = [
  const BukhariBookInfo(id: 1, name: "Revelation", arabicName: "بدء الوحي", urduName: "وحی کا بیان", hindiName: "वहि का बयान", hadithCount: 7, startHadith: 1, endHadith: 7),
  const BukhariBookInfo(id: 2, name: "Belief", arabicName: "الإيمان", urduName: "ایمان", hindiName: "ईमान", hadithCount: 51, startHadith: 8, endHadith: 58),
  const BukhariBookInfo(id: 3, name: "Knowledge", arabicName: "العلم", urduName: "علم", hindiName: "इल्म", hadithCount: 76, startHadith: 59, endHadith: 134),
  const BukhariBookInfo(id: 4, name: "Ablution (Wudu)", arabicName: "الوضوء", urduName: "وضو", hindiName: "वुज़ू", hadithCount: 113, startHadith: 135, endHadith: 247),
  const BukhariBookInfo(id: 5, name: "Bathing (Ghusl)", arabicName: "الغسل", urduName: "غسل", hindiName: "ग़ुस्ल", hadithCount: 46, startHadith: 248, endHadith: 293),
  const BukhariBookInfo(id: 6, name: "Menstruation", arabicName: "الحيض", urduName: "حیض", hindiName: "हैज़", hadithCount: 40, startHadith: 294, endHadith: 333),
  const BukhariBookInfo(id: 7, name: "Dry Ablution (Tayammum)", arabicName: "التيمم", urduName: "تیمم", hindiName: "तयम्मुम", hadithCount: 15, startHadith: 334, endHadith: 348),
  const BukhariBookInfo(id: 8, name: "Prayer (Salat)", arabicName: "الصلاة", urduName: "نماز", hindiName: "नमाज़", hadithCount: 172, startHadith: 349, endHadith: 520),
  const BukhariBookInfo(id: 9, name: "Times of Prayer", arabicName: "مواقيت الصلاة", urduName: "نماز کے اوقات", hindiName: "नमाज़ के औक़ात", hadithCount: 82, startHadith: 521, endHadith: 602),
  const BukhariBookInfo(id: 10, name: "Call to Prayer (Adhan)", arabicName: "الأذان", urduName: "اذان", hindiName: "अज़ान", hadithCount: 164, startHadith: 603, endHadith: 766),
  const BukhariBookInfo(id: 11, name: "Friday Prayer", arabicName: "الجمعة", urduName: "جمعہ کی نماز", hindiName: "जुमे की नमाज़", hadithCount: 68, startHadith: 767, endHadith: 834),
  const BukhariBookInfo(id: 12, name: "Fear Prayer", arabicName: "صلاة الخوف", urduName: "خوف کی نماز", hindiName: "ख़ौफ़ की नमाज़", hadithCount: 6, startHadith: 835, endHadith: 840),
  const BukhariBookInfo(id: 13, name: "Two Eids", arabicName: "العيدين", urduName: "دو عیدیں", hindiName: "दो ईदें", hadithCount: 40, startHadith: 841, endHadith: 880),
  const BukhariBookInfo(id: 14, name: "Witr Prayer", arabicName: "الوتر", urduName: "وتر کی نماز", hindiName: "वित्र की नमाज़", hadithCount: 20, startHadith: 881, endHadith: 900),
  const BukhariBookInfo(id: 15, name: "Rain Prayer (Istisqa)", arabicName: "الاستسقاء", urduName: "بارش کی دعا", hindiName: "बारिश की दुआ", hadithCount: 29, startHadith: 901, endHadith: 929),
  const BukhariBookInfo(id: 16, name: "Eclipse Prayer", arabicName: "الكسوف", urduName: "کسوف کی نماز", hindiName: "ग्रहण की नमाज़", hadithCount: 31, startHadith: 930, endHadith: 960),
  const BukhariBookInfo(id: 17, name: "Prostration During Quran", arabicName: "سجود القرآن", urduName: "قرآن کریم کے سجدے", hindiName: "क़ुरआन के सजदे", hadithCount: 14, startHadith: 961, endHadith: 974),
  const BukhariBookInfo(id: 18, name: "Shortening Prayer", arabicName: "تقصير الصلاة", urduName: "نماز قصر", hindiName: "नमाज़ क़स्र", hadithCount: 20, startHadith: 975, endHadith: 994),
  const BukhariBookInfo(id: 19, name: "Night Prayer (Tahajjud)", arabicName: "التهجد", urduName: "تہجد کی نماز", hindiName: "तहज्जुद की नमाज़", hadithCount: 43, startHadith: 995, endHadith: 1037),
  const BukhariBookInfo(id: 20, name: "Virtue of Prayer in Makkah & Madinah", arabicName: "فضل الصلاة", urduName: "مکہ اور مدینہ میں نماز کی فضیلت", hindiName: "मक्का और मदीना में नमाज़ की फ़ज़ीलत", hadithCount: 10, startHadith: 1038, endHadith: 1047),
  const BukhariBookInfo(id: 21, name: "Actions while Praying", arabicName: "العمل في الصلاة", urduName: "نماز میں اعمال", hindiName: "नमाज़ में आमाल", hadithCount: 24, startHadith: 1048, endHadith: 1071),
  const BukhariBookInfo(id: 22, name: "Forgetfulness in Prayer", arabicName: "السهو", urduName: "نماز میں بھول چوک", hindiName: "नमाज़ में भूल चूक", hadithCount: 15, startHadith: 1072, endHadith: 1086),
  const BukhariBookInfo(id: 23, name: "Funerals (Al-Janaiz)", arabicName: "الجنائز", urduName: "جنازے", hindiName: "जनाज़े", hadithCount: 158, startHadith: 1087, endHadith: 1244),
  const BukhariBookInfo(id: 24, name: "Zakat", arabicName: "الزكاة", urduName: "زکوٰۃ", hindiName: "ज़कात", hadithCount: 118, startHadith: 1245, endHadith: 1362),
  const BukhariBookInfo(id: 25, name: "Hajj", arabicName: "الحج", urduName: "حج", hindiName: "हज", hadithCount: 260, startHadith: 1363, endHadith: 1622),
  const BukhariBookInfo(id: 26, name: "Umrah", arabicName: "العمرة", urduName: "عمرہ", hindiName: "उमरा", hadithCount: 25, startHadith: 1623, endHadith: 1647),
  const BukhariBookInfo(id: 27, name: "Prevented from Hajj", arabicName: "المحصر", urduName: "حج سے رکاوٹ", hindiName: "हज से रुकावट", hadithCount: 18, startHadith: 1648, endHadith: 1665),
  const BukhariBookInfo(id: 28, name: "Penalty of Hunting", arabicName: "جزاء الصيد", urduName: "شکار کا کفارہ", hindiName: "शिकार का कफ़्फ़ारा", hadithCount: 31, startHadith: 1666, endHadith: 1696),
  const BukhariBookInfo(id: 29, name: "Virtues of Madinah", arabicName: "فضائل المدينة", urduName: "مدینہ کی فضیلتیں", hindiName: "मदीना की फ़ज़ीलतें", hadithCount: 28, startHadith: 1697, endHadith: 1724),
  const BukhariBookInfo(id: 30, name: "Fasting", arabicName: "الصوم", urduName: "روزہ", hindiName: "रोज़ा", hadithCount: 117, startHadith: 1725, endHadith: 1841),
  const BukhariBookInfo(id: 31, name: "Tarawih Prayer", arabicName: "التراويح", urduName: "تراویح کی نماز", hindiName: "तरावीह की नमाज़", hadithCount: 7, startHadith: 1842, endHadith: 1848),
  const BukhariBookInfo(id: 32, name: "Staying in Mosque (Itikaf)", arabicName: "الاعتكاف", urduName: "اعتکاف", hindiName: "एतिकाफ़", hadithCount: 21, startHadith: 1849, endHadith: 1869),
  const BukhariBookInfo(id: 33, name: "Sales and Trade", arabicName: "البيوع", urduName: "خرید و فروخت", hindiName: "ख़रीद व फ़रोख़्त", hadithCount: 169, startHadith: 1870, endHadith: 2038),
  const BukhariBookInfo(id: 34, name: "Advance Payment (Salam)", arabicName: "السلم", urduName: "سلم", hindiName: "सलम", hadithCount: 12, startHadith: 2039, endHadith: 2050),
  const BukhariBookInfo(id: 35, name: "Pre-emption (Shuf'a)", arabicName: "الشفعة", urduName: "شفعہ", hindiName: "शुफ़्आ", hadithCount: 5, startHadith: 2051, endHadith: 2055),
  const BukhariBookInfo(id: 36, name: "Hiring", arabicName: "الإجارة", urduName: "کرایہ داری", hindiName: "किराया", hadithCount: 22, startHadith: 2056, endHadith: 2077),
  const BukhariBookInfo(id: 37, name: "Debt Transfer", arabicName: "الحوالة", urduName: "حوالہ", hindiName: "हवाला", hadithCount: 5, startHadith: 2078, endHadith: 2082),
  const BukhariBookInfo(id: 38, name: "Guarantee (Kafalah)", arabicName: "الكفالة", urduName: "کفالت", hindiName: "कफ़ालत", hadithCount: 5, startHadith: 2083, endHadith: 2087),
  const BukhariBookInfo(id: 39, name: "Representation/Authorization", arabicName: "الوكالة", urduName: "وکالت", hindiName: "वकालत", hadithCount: 20, startHadith: 2088, endHadith: 2107),
  const BukhariBookInfo(id: 40, name: "Agriculture", arabicName: "المزارعة", urduName: "کاشتکاری", hindiName: "खेती बाड़ी", hadithCount: 22, startHadith: 2108, endHadith: 2129),
  const BukhariBookInfo(id: 41, name: "Water Distribution", arabicName: "المساقاة", urduName: "پانی کی تقسیم", hindiName: "पानी की तक़सीम", hadithCount: 28, startHadith: 2130, endHadith: 2157),
  const BukhariBookInfo(id: 42, name: "Loans", arabicName: "الاستقراض", urduName: "قرض", hindiName: "क़र्ज़", hadithCount: 27, startHadith: 2158, endHadith: 2184),
  const BukhariBookInfo(id: 43, name: "Disputes", arabicName: "الخصومات", urduName: "جھگڑے", hindiName: "झगड़े", hadithCount: 10, startHadith: 2185, endHadith: 2194),
  const BukhariBookInfo(id: 44, name: "Lost Things Picked up", arabicName: "اللقطة", urduName: "گری ہوئی چیزیں", hindiName: "गिरी हुई चीज़ें", hadithCount: 18, startHadith: 2195, endHadith: 2212),
  const BukhariBookInfo(id: 45, name: "Oppression", arabicName: "المظالم", urduName: "ظلم و زیادتی", hindiName: "ज़ुल्म व ज़्यादती", hadithCount: 46, startHadith: 2213, endHadith: 2258),
  const BukhariBookInfo(id: 46, name: "Partnership", arabicName: "الشركة", urduName: "شراکت", hindiName: "शराकत", hadithCount: 19, startHadith: 2259, endHadith: 2277),
  const BukhariBookInfo(id: 47, name: "Mortgaging", arabicName: "الرهن", urduName: "رہن", hindiName: "रहन", hadithCount: 10, startHadith: 2278, endHadith: 2287),
  const BukhariBookInfo(id: 48, name: "Freeing Slaves", arabicName: "العتق", urduName: "غلام آزاد کرنا", hindiName: "ग़ुलाम आज़ाद करना", hadithCount: 24, startHadith: 2288, endHadith: 2311),
  const BukhariBookInfo(id: 49, name: "Manumission of Slaves", arabicName: "المكاتب", urduName: "مکاتب", hindiName: "मुकातिब", hadithCount: 10, startHadith: 2312, endHadith: 2321),
  const BukhariBookInfo(id: 50, name: "Gifts", arabicName: "الهبة", urduName: "تحائف", hindiName: "तोहफ़े", hadithCount: 61, startHadith: 2322, endHadith: 2382),
  const BukhariBookInfo(id: 51, name: "Witnesses", arabicName: "الشهادات", urduName: "گواہی", hindiName: "गवाही", hadithCount: 55, startHadith: 2383, endHadith: 2437),
  const BukhariBookInfo(id: 52, name: "Peacemaking", arabicName: "الصلح", urduName: "صلح", hindiName: "सुलह", hadithCount: 17, startHadith: 2438, endHadith: 2454),
  const BukhariBookInfo(id: 53, name: "Conditions", arabicName: "الشروط", urduName: "شرائط", hindiName: "शर्तें", hadithCount: 20, startHadith: 2455, endHadith: 2474),
  const BukhariBookInfo(id: 54, name: "Wills and Testaments", arabicName: "الوصايا", urduName: "وصیت", hindiName: "वसीयत", hadithCount: 43, startHadith: 2475, endHadith: 2517),
  const BukhariBookInfo(id: 55, name: "Jihaad", arabicName: "الجهاد والسير", urduName: "جہاد", hindiName: "जिहाद", hadithCount: 310, startHadith: 2518, endHadith: 2827),
  const BukhariBookInfo(id: 56, name: "One-fifth of War Booty", arabicName: "فرض الخمس", urduName: "خمس", hindiName: "ख़ुम्स", hadithCount: 40, startHadith: 2828, endHadith: 2867),
  const BukhariBookInfo(id: 57, name: "Jizyah and Mawaada'ah", arabicName: "الجزية والموادعة", urduName: "جزیہ اور معاہدہ", hindiName: "जिज़्या और मुआहिदा", hadithCount: 23, startHadith: 2868, endHadith: 2890),
  const BukhariBookInfo(id: 58, name: "Beginning of Creation", arabicName: "بدء الخلق", urduName: "تخلیق کی ابتدا", hindiName: "तख़लीक़ की इब्तिदा", hadithCount: 110, startHadith: 2891, endHadith: 3000),
  const BukhariBookInfo(id: 59, name: "Prophets", arabicName: "أحاديث الأنبياء", urduName: "انبیاء کرام", hindiName: "अंबिया किराम", hadithCount: 171, startHadith: 3001, endHadith: 3171),
  const BukhariBookInfo(id: 60, name: "Virtues and Merits of Prophet", arabicName: "المناقب", urduName: "نبی کریم کی فضیلتیں", hindiName: "नबी करीम की फ़ज़ीलतें", hadithCount: 294, startHadith: 3172, endHadith: 3465),
  const BukhariBookInfo(id: 61, name: "Companions of the Prophet", arabicName: "فضائل الصحابة", urduName: "صحابہ کرام", hindiName: "सहाबा किराम", hadithCount: 274, startHadith: 3466, endHadith: 3739),
  const BukhariBookInfo(id: 62, name: "Merits of Al-Ansar", arabicName: "مناقب الأنصار", urduName: "انصار کی فضیلتیں", hindiName: "अंसार की फ़ज़ीलतें", hadithCount: 264, startHadith: 3740, endHadith: 4003),
  const BukhariBookInfo(id: 63, name: "Military Expeditions", arabicName: "المغازي", urduName: "غزوات", hindiName: "ग़ज़वात", hadithCount: 459, startHadith: 4004, endHadith: 4462),
  const BukhariBookInfo(id: 64, name: "Tafsir of the Prophet", arabicName: "التفسير", urduName: "تفسیر", hindiName: "तफ़सीर", hadithCount: 558, startHadith: 4463, endHadith: 5020),
  const BukhariBookInfo(id: 65, name: "Virtues of the Quran", arabicName: "فضائل القرآن", urduName: "قرآن کی فضیلتیں", hindiName: "क़ुरआन की फ़ज़ीलतें", hadithCount: 86, startHadith: 5021, endHadith: 5106),
  const BukhariBookInfo(id: 66, name: "Marriage", arabicName: "النكاح", urduName: "نکاح", hindiName: "निकाह", hadithCount: 188, startHadith: 5107, endHadith: 5294),
  const BukhariBookInfo(id: 67, name: "Divorce", arabicName: "الطلاق", urduName: "طلاق", hindiName: "तलाक़", hadithCount: 71, startHadith: 5295, endHadith: 5365),
  const BukhariBookInfo(id: 68, name: "Supporting the Family", arabicName: "النفقات", urduName: "خاندان کا نفقہ", hindiName: "ख़ानदान का नफ़क़ा", hadithCount: 27, startHadith: 5366, endHadith: 5392),
  const BukhariBookInfo(id: 69, name: "Food and Meals", arabicName: "الأطعمة", urduName: "کھانے پینے کے آداب", hindiName: "खाने पीने के आदाब", hadithCount: 80, startHadith: 5393, endHadith: 5472),
  const BukhariBookInfo(id: 70, name: "Sacrifice on Birth (Aqiqa)", arabicName: "العقيقة", urduName: "عقیقہ", hindiName: "अक़ीक़ा", hadithCount: 4, startHadith: 5473, endHadith: 5476),
  const BukhariBookInfo(id: 71, name: "Slaughtering and Hunting", arabicName: "الذبائح والصيد", urduName: "ذبح اور شکار", hindiName: "ज़िब्ह और शिकार", hadithCount: 78, startHadith: 5477, endHadith: 5554),
  const BukhariBookInfo(id: 72, name: "Al-Adha Festival Sacrifice", arabicName: "الأضاحي", urduName: "قربانی", hindiName: "क़ुर्बानी", hadithCount: 19, startHadith: 5555, endHadith: 5573),
  const BukhariBookInfo(id: 73, name: "Drinks", arabicName: "الأشربة", urduName: "مشروبات", hindiName: "मशरूबात", hadithCount: 77, startHadith: 5574, endHadith: 5650),
  const BukhariBookInfo(id: 74, name: "Patients", arabicName: "المرضى", urduName: "مریض", hindiName: "मरीज़", hadithCount: 30, startHadith: 5651, endHadith: 5680),
  const BukhariBookInfo(id: 75, name: "Medicine", arabicName: "الطب", urduName: "طب", hindiName: "तिब्ब", hadithCount: 96, startHadith: 5681, endHadith: 5776),
  const BukhariBookInfo(id: 76, name: "Dress", arabicName: "اللباس", urduName: "لباس", hindiName: "लिबास", hadithCount: 136, startHadith: 5777, endHadith: 5912),
  const BukhariBookInfo(id: 77, name: "Good Manners (Adab)", arabicName: "الأدب", urduName: "اخلاق و آداب", hindiName: "अख़लाक़ व आदाब", hadithCount: 253, startHadith: 5913, endHadith: 6165),
  const BukhariBookInfo(id: 78, name: "Asking Permission", arabicName: "الاستئذان", urduName: "اجازت طلب کرنا", hindiName: "इजाज़त तलब करना", hadithCount: 62, startHadith: 6166, endHadith: 6227),
  const BukhariBookInfo(id: 79, name: "Supplications", arabicName: "الدعوات", urduName: "دعائیں", hindiName: "दुआएं", hadithCount: 104, startHadith: 6228, endHadith: 6331),
  const BukhariBookInfo(id: 80, name: "Heart Softening (Riqaq)", arabicName: "الرقاق", urduName: "دل کو نرم کرنا", hindiName: "दिल को नर्म करना", hadithCount: 124, startHadith: 6332, endHadith: 6455),
  const BukhariBookInfo(id: 81, name: "Divine Will (Qadar)", arabicName: "القدر", urduName: "تقدیر", hindiName: "तक़दीर", hadithCount: 28, startHadith: 6456, endHadith: 6483),
  const BukhariBookInfo(id: 82, name: "Oaths and Vows", arabicName: "الأيمان والنذور", urduName: "قسمیں اور نذریں", hindiName: "क़समें और नज़रें", hadithCount: 87, startHadith: 6484, endHadith: 6570),
  const BukhariBookInfo(id: 83, name: "Expiation for Unfulfilled Oaths", arabicName: "كفارات الأيمان", urduName: "قسموں کا کفارہ", hindiName: "क़समों का कफ़्फ़ारा", hadithCount: 19, startHadith: 6571, endHadith: 6589),
  const BukhariBookInfo(id: 84, name: "Inheritance Laws", arabicName: "الفرائض", urduName: "میراث کے قوانین", hindiName: "मीरास के क़ानून", hadithCount: 31, startHadith: 6590, endHadith: 6620),
  const BukhariBookInfo(id: 85, name: "Punishment (Hudud)", arabicName: "الحدود", urduName: "حدود", hindiName: "हुदूद", hadithCount: 60, startHadith: 6621, endHadith: 6680),
  const BukhariBookInfo(id: 86, name: "Blood Money (Diyat)", arabicName: "الديات", urduName: "خون بہا", hindiName: "ख़ून बहा", hadithCount: 37, startHadith: 6681, endHadith: 6717),
  const BukhariBookInfo(id: 87, name: "Dealing with Apostates", arabicName: "استتابة المرتدين", urduName: "مرتدوں سے نمٹنا", hindiName: "मुर्तदों से निपटना", hadithCount: 16, startHadith: 6718, endHadith: 6733),
  const BukhariBookInfo(id: 88, name: "Compulsion", arabicName: "الإكراه", urduName: "مجبوری", hindiName: "मजबूरी", hadithCount: 9, startHadith: 6734, endHadith: 6742),
  const BukhariBookInfo(id: 89, name: "Tricks", arabicName: "الحيل", urduName: "حیلے", hindiName: "हीले", hadithCount: 24, startHadith: 6743, endHadith: 6766),
  const BukhariBookInfo(id: 90, name: "Dream Interpretation", arabicName: "التعبير", urduName: "خواب کی تعبیر", hindiName: "ख़्वाब की ताबीर", hadithCount: 48, startHadith: 6767, endHadith: 6814),
  const BukhariBookInfo(id: 91, name: "Afflictions and End of World", arabicName: "الفتن", urduName: "فتنے اور قیامت کی نشانیاں", hindiName: "फ़ितने और क़यामत की निशानियां", hadithCount: 92, startHadith: 6815, endHadith: 6906),
  const BukhariBookInfo(id: 92, name: "Judgments (Ahkam)", arabicName: "الأحكام", urduName: "احکام", hindiName: "अहकाम", hadithCount: 70, startHadith: 6907, endHadith: 6976),
  const BukhariBookInfo(id: 93, name: "Wishes", arabicName: "التمني", urduName: "آرزوئیں", hindiName: "आरज़ुएं", hadithCount: 20, startHadith: 6977, endHadith: 6996),
  const BukhariBookInfo(id: 94, name: "Accepting Single Report", arabicName: "أخبار الآحاد", urduName: "خبر واحد", hindiName: "ख़बर वाहिद", hadithCount: 14, startHadith: 6997, endHadith: 7010),
  const BukhariBookInfo(id: 95, name: "Holding onto Quran and Sunnah", arabicName: "الاعتصام بالكتاب", urduName: "قرآن و سنت کو مضبوطی سے تھامنا", hindiName: "क़ुरआन व सुन्नत को मज़बूती से थामना", hadithCount: 52, startHadith: 7011, endHadith: 7062),
  const BukhariBookInfo(id: 96, name: "Oneness of Allah (Tawheed)", arabicName: "التوحيد", urduName: "توحید", hindiName: "तौहीद", hadithCount: 145, startHadith: 7063, endHadith: 7207),
];
