import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
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
        title: Text(
          context.tr('sahih_bukhari'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
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
                        padding: responsive.paddingSymmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
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

  Widget _buildBookCard(
    BuildContext context,
    BukhariBookInfo book,
    int number,
  ) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    final responsive = context.responsive;

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
                    TextDirection textDir = TextDirection.ltr;

                    switch (langProvider.languageCode) {
                      case 'ar':
                        displayName = book.arabicName;
                        textDir = TextDirection.rtl;
                        break;
                      case 'ur':
                        displayName = book.urduName;
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
                        fontFamily: 'Poppins',
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

// Complete list of all 97 Books in Sahih Bukhari (sunnah.com numbering)
// Source: https://sunnah.com/bukhari - Total 7563 hadith across 97 books
final List<BukhariBookInfo> _bukhariBooks = [
  const BukhariBookInfo(
    id: 1,
    name: "Revelation",
    arabicName: "بدء الوحي",
    urduName: "وحی کا بیان",
    hindiName: "वहि का बयान",
    hadithCount: 7,
    startHadith: 1,
    endHadith: 7,
  ),
  const BukhariBookInfo(
    id: 2,
    name: "Belief",
    arabicName: "الإيمان",
    urduName: "ایمان",
    hindiName: "ईमान",
    hadithCount: 51,
    startHadith: 8,
    endHadith: 58,
  ),
  const BukhariBookInfo(
    id: 3,
    name: "Knowledge",
    arabicName: "العلم",
    urduName: "علم",
    hindiName: "इल्म",
    hadithCount: 76,
    startHadith: 59,
    endHadith: 134,
  ),
  const BukhariBookInfo(
    id: 4,
    name: "Ablution (Wudu)",
    arabicName: "الوضوء",
    urduName: "وضو",
    hindiName: "वुज़ू",
    hadithCount: 113,
    startHadith: 135,
    endHadith: 247,
  ),
  const BukhariBookInfo(
    id: 5,
    name: "Bathing (Ghusl)",
    arabicName: "الغسل",
    urduName: "غسل",
    hindiName: "ग़ुस्ल",
    hadithCount: 46,
    startHadith: 248,
    endHadith: 293,
  ),
  const BukhariBookInfo(
    id: 6,
    name: "Menstruation",
    arabicName: "الحيض",
    urduName: "حیض",
    hindiName: "हैज़",
    hadithCount: 40,
    startHadith: 294,
    endHadith: 333,
  ),
  const BukhariBookInfo(
    id: 7,
    name: "Dry Ablution (Tayammum)",
    arabicName: "التيمم",
    urduName: "تیمم",
    hindiName: "तयम्मुम",
    hadithCount: 15,
    startHadith: 334,
    endHadith: 348,
  ),
  const BukhariBookInfo(
    id: 8,
    name: "Prayer (Salat)",
    arabicName: "الصلاة",
    urduName: "نماز",
    hindiName: "नमाज़",
    hadithCount: 172,
    startHadith: 349,
    endHadith: 520,
  ),
  const BukhariBookInfo(
    id: 9,
    name: "Times of Prayer",
    arabicName: "مواقيت الصلاة",
    urduName: "نماز کے اوقات",
    hindiName: "नमाज़ के औक़ात",
    hadithCount: 82,
    startHadith: 521,
    endHadith: 602,
  ),
  const BukhariBookInfo(
    id: 10,
    name: "Call to Prayer (Adhan)",
    arabicName: "الأذان",
    urduName: "اذان",
    hindiName: "अज़ान",
    hadithCount: 164,
    startHadith: 603,
    endHadith: 766,
  ),
  const BukhariBookInfo(
    id: 11,
    name: "Friday Prayer",
    arabicName: "الجمعة",
    urduName: "جمعہ کی نماز",
    hindiName: "जुमे की नमाज़",
    hadithCount: 68,
    startHadith: 767,
    endHadith: 834,
  ),
  const BukhariBookInfo(
    id: 12,
    name: "Fear Prayer",
    arabicName: "صلاة الخوف",
    urduName: "خوف کی نماز",
    hindiName: "ख़ौफ़ की नमाज़",
    hadithCount: 6,
    startHadith: 835,
    endHadith: 840,
  ),
  const BukhariBookInfo(
    id: 13,
    name: "Two Eids",
    arabicName: "العيدين",
    urduName: "دو عیدیں",
    hindiName: "दो ईदें",
    hadithCount: 40,
    startHadith: 841,
    endHadith: 880,
  ),
  const BukhariBookInfo(
    id: 14,
    name: "Witr Prayer",
    arabicName: "الوتر",
    urduName: "وتر کی نماز",
    hindiName: "वित्र की नमाज़",
    hadithCount: 20,
    startHadith: 881,
    endHadith: 900,
  ),
  const BukhariBookInfo(
    id: 15,
    name: "Rain Prayer (Istisqa)",
    arabicName: "الاستسقاء",
    urduName: "بارش کی دعا",
    hindiName: "बारिश की दुआ",
    hadithCount: 29,
    startHadith: 901,
    endHadith: 929,
  ),
  const BukhariBookInfo(
    id: 16,
    name: "Eclipse Prayer",
    arabicName: "الكسوف",
    urduName: "کسوف کی نماز",
    hindiName: "ग्रहण की नमाज़",
    hadithCount: 31,
    startHadith: 930,
    endHadith: 960,
  ),
  const BukhariBookInfo(
    id: 17,
    name: "Prostration During Quran",
    arabicName: "سجود القرآن",
    urduName: "قرآن کریم کے سجدے",
    hindiName: "क़ुरआन के सजदे",
    hadithCount: 14,
    startHadith: 961,
    endHadith: 974,
  ),
  const BukhariBookInfo(
    id: 18,
    name: "Shortening Prayer",
    arabicName: "تقصير الصلاة",
    urduName: "نماز قصر",
    hindiName: "नमाज़ क़स्र",
    hadithCount: 20,
    startHadith: 975,
    endHadith: 994,
  ),
  const BukhariBookInfo(
    id: 19,
    name: "Night Prayer (Tahajjud)",
    arabicName: "التهجد",
    urduName: "تہجد کی نماز",
    hindiName: "तहज्जुद की नमाज़",
    hadithCount: 43,
    startHadith: 995,
    endHadith: 1037,
  ),
  const BukhariBookInfo(
    id: 20,
    name: "Virtue of Prayer in Makkah & Madinah",
    arabicName: "فضل الصلاة",
    urduName: "مکہ اور مدینہ میں نماز کی فضیلت",
    hindiName: "मक्का और मदीना में नमाज़ की फ़ज़ीलत",
    hadithCount: 10,
    startHadith: 1038,
    endHadith: 1047,
  ),
  const BukhariBookInfo(
    id: 21,
    name: "Actions while Praying",
    arabicName: "العمل في الصلاة",
    urduName: "نماز میں اعمال",
    hindiName: "नमाज़ में आमाल",
    hadithCount: 24,
    startHadith: 1048,
    endHadith: 1071,
  ),
  const BukhariBookInfo(
    id: 22,
    name: "Forgetfulness in Prayer",
    arabicName: "السهو",
    urduName: "نماز میں بھول چوک",
    hindiName: "नमाज़ में भूल चूक",
    hadithCount: 15,
    startHadith: 1072,
    endHadith: 1086,
  ),
  const BukhariBookInfo(
    id: 23,
    name: "Funerals (Al-Janaiz)",
    arabicName: "الجنائز",
    urduName: "جنازے",
    hindiName: "जनाज़े",
    hadithCount: 158,
    startHadith: 1087,
    endHadith: 1244,
  ),
  const BukhariBookInfo(
    id: 24,
    name: "Zakat",
    arabicName: "الزكاة",
    urduName: "زکوٰۃ",
    hindiName: "ज़कात",
    hadithCount: 118,
    startHadith: 1245,
    endHadith: 1362,
  ),
  const BukhariBookInfo(
    id: 25,
    name: "Hajj",
    arabicName: "الحج",
    urduName: "حج",
    hindiName: "हज",
    hadithCount: 260,
    startHadith: 1363,
    endHadith: 1622,
  ),
  const BukhariBookInfo(
    id: 26,
    name: "Umrah",
    arabicName: "العمرة",
    urduName: "عمرہ",
    hindiName: "उमरा",
    hadithCount: 25,
    startHadith: 1623,
    endHadith: 1647,
  ),
  const BukhariBookInfo(
    id: 27,
    name: "Prevented from Hajj",
    arabicName: "المحصر",
    urduName: "حج سے رکاوٹ",
    hindiName: "हज से रुकावट",
    hadithCount: 18,
    startHadith: 1648,
    endHadith: 1665,
  ),
  const BukhariBookInfo(
    id: 28,
    name: "Penalty of Hunting",
    arabicName: "جزاء الصيد",
    urduName: "شکار کا کفارہ",
    hindiName: "शिकार का कफ़्फ़ारा",
    hadithCount: 31,
    startHadith: 1666,
    endHadith: 1696,
  ),
  const BukhariBookInfo(
    id: 29,
    name: "Virtues of Madinah",
    arabicName: "فضائل المدينة",
    urduName: "مدینہ کی فضیلتیں",
    hindiName: "मदीना की फ़ज़ीलतें",
    hadithCount: 28,
    startHadith: 1697,
    endHadith: 1724,
  ),
  const BukhariBookInfo(
    id: 30,
    name: "Fasting",
    arabicName: "الصوم",
    urduName: "روزہ",
    hindiName: "रोज़ा",
    hadithCount: 117,
    startHadith: 1725,
    endHadith: 1841,
  ),
  const BukhariBookInfo(
    id: 31,
    name: "Tarawih Prayer",
    arabicName: "التراويح",
    urduName: "تراویح کی نماز",
    hindiName: "तरावीह की नमाज़",
    hadithCount: 6,
    startHadith: 2008,
    endHadith: 2013,
  ),
  const BukhariBookInfo(
    id: 32,
    name: "Virtues of Laylatul Qadr",
    arabicName: "فضل ليلة القدر",
    urduName: "شب قدر کی فضیلت",
    hindiName: "शब-ए-क़द्र की फ़ज़ीलत",
    hadithCount: 11,
    startHadith: 2014,
    endHadith: 2024,
  ),
  const BukhariBookInfo(
    id: 33,
    name: "Staying in Mosque (Itikaf)",
    arabicName: "الاعتكاف",
    urduName: "اعتکاف",
    hindiName: "एतिकाफ़",
    hadithCount: 22,
    startHadith: 2025,
    endHadith: 2046,
  ),
  const BukhariBookInfo(
    id: 34,
    name: "Sales and Trade",
    arabicName: "البيوع",
    urduName: "خرید و فروخت",
    hindiName: "ख़रीद व फ़रोख़्त",
    hadithCount: 192,
    startHadith: 2047,
    endHadith: 2238,
  ),
  const BukhariBookInfo(
    id: 35,
    name: "Advance Payment (Salam)",
    arabicName: "السلم",
    urduName: "سلم",
    hindiName: "सलम",
    hadithCount: 18,
    startHadith: 2239,
    endHadith: 2256,
  ),
  const BukhariBookInfo(
    id: 36,
    name: "Pre-emption (Shuf'a)",
    arabicName: "الشفعة",
    urduName: "شفعہ",
    hindiName: "शुफ़्आ",
    hadithCount: 3,
    startHadith: 2257,
    endHadith: 2259,
  ),
  const BukhariBookInfo(
    id: 37,
    name: "Hiring",
    arabicName: "الإجارة",
    urduName: "کرایہ داری",
    hindiName: "किराया",
    hadithCount: 26,
    startHadith: 2260,
    endHadith: 2285,
  ),
  const BukhariBookInfo(
    id: 38,
    name: "Debt Transfer",
    arabicName: "الحوالات",
    urduName: "حوالہ",
    hindiName: "हवाला",
    hadithCount: 3,
    startHadith: 2287,
    endHadith: 2289,
  ),
  const BukhariBookInfo(
    id: 39,
    name: "Guarantee (Kafalah)",
    arabicName: "الكفالة",
    urduName: "کفالت",
    hindiName: "कफ़ालत",
    hadithCount: 9,
    startHadith: 2290,
    endHadith: 2298,
  ),
  const BukhariBookInfo(
    id: 40,
    name: "Representation/Authorization",
    arabicName: "الوكالة",
    urduName: "وکالت",
    hindiName: "वकालत",
    hadithCount: 21,
    startHadith: 2299,
    endHadith: 2319,
  ),
  const BukhariBookInfo(
    id: 41,
    name: "Agriculture",
    arabicName: "المزارعة",
    urduName: "کاشتکاری",
    hindiName: "खेती बाड़ी",
    hadithCount: 31,
    startHadith: 2320,
    endHadith: 2350,
  ),
  const BukhariBookInfo(
    id: 42,
    name: "Water Distribution",
    arabicName: "المساقاة",
    urduName: "پانی کی تقسیم",
    hindiName: "पानी की तक़सीम",
    hadithCount: 33,
    startHadith: 2351,
    endHadith: 2383,
  ),
  const BukhariBookInfo(
    id: 43,
    name: "Loans",
    arabicName: "الاستقراض",
    urduName: "قرض",
    hindiName: "क़र्ज़",
    hadithCount: 25,
    startHadith: 2385,
    endHadith: 2409,
  ),
  const BukhariBookInfo(
    id: 44,
    name: "Disputes",
    arabicName: "الخصومات",
    urduName: "جھگڑے",
    hindiName: "झगड़े",
    hadithCount: 16,
    startHadith: 2410,
    endHadith: 2425,
  ),
  const BukhariBookInfo(
    id: 45,
    name: "Lost Things Picked up",
    arabicName: "اللقطة",
    urduName: "گری ہوئی چیزیں",
    hindiName: "गिरी हुई चीज़ें",
    hadithCount: 14,
    startHadith: 2426,
    endHadith: 2439,
  ),
  const BukhariBookInfo(
    id: 46,
    name: "Oppression",
    arabicName: "المظالم",
    urduName: "ظلم و زیادتی",
    hindiName: "ज़ुल्म व ज़्यादती",
    hadithCount: 43,
    startHadith: 2440,
    endHadith: 2482,
  ),
  const BukhariBookInfo(
    id: 47,
    name: "Partnership",
    arabicName: "الشركة",
    urduName: "شراکت",
    hindiName: "शराकत",
    hadithCount: 25,
    startHadith: 2483,
    endHadith: 2507,
  ),
  const BukhariBookInfo(
    id: 48,
    name: "Mortgaging",
    arabicName: "الرهن",
    urduName: "رہن",
    hindiName: "रहन",
    hadithCount: 8,
    startHadith: 2508,
    endHadith: 2515,
  ),
  const BukhariBookInfo(
    id: 49,
    name: "Freeing Slaves",
    arabicName: "العتق",
    urduName: "غلام آزاد کرنا",
    hindiName: "ग़ुलाम आज़ाद करना",
    hadithCount: 43,
    startHadith: 2517,
    endHadith: 2559,
  ),
  const BukhariBookInfo(
    id: 50,
    name: "Manumission of Slaves",
    arabicName: "المكاتب",
    urduName: "مکاتب",
    hindiName: "मुकातिब",
    hadithCount: 6,
    startHadith: 2560,
    endHadith: 2565,
  ),
  const BukhariBookInfo(
    id: 51,
    name: "Gifts",
    arabicName: "الهبة وفضلها",
    urduName: "تحائف",
    hindiName: "तोहफ़े",
    hadithCount: 71,
    startHadith: 2566,
    endHadith: 2636,
  ),
  const BukhariBookInfo(
    id: 52,
    name: "Witnesses",
    arabicName: "الشهادات",
    urduName: "گواہی",
    hindiName: "गवाही",
    hadithCount: 53,
    startHadith: 2637,
    endHadith: 2689,
  ),
  const BukhariBookInfo(
    id: 53,
    name: "Peacemaking",
    arabicName: "الصلح",
    urduName: "صلح",
    hindiName: "सुलह",
    hadithCount: 21,
    startHadith: 2690,
    endHadith: 2710,
  ),
  const BukhariBookInfo(
    id: 54,
    name: "Conditions",
    arabicName: "الشروط",
    urduName: "شرائط",
    hindiName: "शर्तें",
    hadithCount: 27,
    startHadith: 2711,
    endHadith: 2737,
  ),
  const BukhariBookInfo(
    id: 55,
    name: "Wills and Testaments",
    arabicName: "الوصايا",
    urduName: "وصیت",
    hindiName: "वसीयत",
    hadithCount: 44,
    startHadith: 2738,
    endHadith: 2781,
  ),
  const BukhariBookInfo(
    id: 56,
    name: "Jihaad",
    arabicName: "الجهاد والسير",
    urduName: "جہاد",
    hindiName: "जिहाद",
    hadithCount: 309,
    startHadith: 2782,
    endHadith: 3090,
  ),
  const BukhariBookInfo(
    id: 57,
    name: "One-fifth of War Booty",
    arabicName: "فرض الخمس",
    urduName: "خمس",
    hindiName: "ख़ुम्स",
    hadithCount: 65,
    startHadith: 3091,
    endHadith: 3155,
  ),
  const BukhariBookInfo(
    id: 58,
    name: "Jizyah and Mawaada'ah",
    arabicName: "الجزية والموادعة",
    urduName: "جزیہ اور معاہدہ",
    hindiName: "जिज़्या और मुआहिदा",
    hadithCount: 34,
    startHadith: 3156,
    endHadith: 3189,
  ),
  const BukhariBookInfo(
    id: 59,
    name: "Beginning of Creation",
    arabicName: "بدء الخلق",
    urduName: "تخلیق کی ابتدا",
    hindiName: "तख़लीक़ की इब्तिदा",
    hadithCount: 136,
    startHadith: 3190,
    endHadith: 3325,
  ),
  const BukhariBookInfo(
    id: 60,
    name: "Prophets",
    arabicName: "أحاديث الأنبياء",
    urduName: "انبیاء کرام",
    hindiName: "अंबिया किराम",
    hadithCount: 163,
    startHadith: 3326,
    endHadith: 3488,
  ),
  const BukhariBookInfo(
    id: 61,
    name: "Virtues and Merits of Prophet",
    arabicName: "المناقب",
    urduName: "نبی کریم کی فضیلتیں",
    hindiName: "नबी करीम की फ़ज़ीलतें",
    hadithCount: 160,
    startHadith: 3489,
    endHadith: 3648,
  ),
  const BukhariBookInfo(
    id: 62,
    name: "Companions of the Prophet",
    arabicName: "فضائل الصحابة",
    urduName: "صحابہ کرام",
    hindiName: "सहाबा किराम",
    hadithCount: 127,
    startHadith: 3649,
    endHadith: 3775,
  ),
  const BukhariBookInfo(
    id: 63,
    name: "Merits of Al-Ansar",
    arabicName: "مناقب الأنصار",
    urduName: "انصار کی فضیلتیں",
    hindiName: "अंसार की फ़ज़ीलतें",
    hadithCount: 173,
    startHadith: 3776,
    endHadith: 3948,
  ),
  const BukhariBookInfo(
    id: 64,
    name: "Military Expeditions",
    arabicName: "المغازي",
    urduName: "غزوات",
    hindiName: "ग़ज़वात",
    hadithCount: 525,
    startHadith: 3949,
    endHadith: 4473,
  ),
  const BukhariBookInfo(
    id: 65,
    name: "Tafsir of the Prophet",
    arabicName: "التفسير",
    urduName: "تفسیر",
    hindiName: "तफ़सीर",
    hadithCount: 504,
    startHadith: 4474,
    endHadith: 4977,
  ),
  const BukhariBookInfo(
    id: 66,
    name: "Virtues of the Quran",
    arabicName: "فضائل القرآن",
    urduName: "قرآن کی فضیلتیں",
    hindiName: "क़ुरआन की फ़ज़ीलतें",
    hadithCount: 85,
    startHadith: 4978,
    endHadith: 5062,
  ),
  const BukhariBookInfo(
    id: 67,
    name: "Marriage",
    arabicName: "النكاح",
    urduName: "نکاح",
    hindiName: "निकाह",
    hadithCount: 188,
    startHadith: 5063,
    endHadith: 5250,
  ),
  const BukhariBookInfo(
    id: 68,
    name: "Divorce",
    arabicName: "الطلاق",
    urduName: "طلاق",
    hindiName: "तलाक़",
    hadithCount: 100,
    startHadith: 5251,
    endHadith: 5350,
  ),
  const BukhariBookInfo(
    id: 69,
    name: "Supporting the Family",
    arabicName: "النفقات",
    urduName: "خاندان کا نفقہ",
    hindiName: "ख़ानदान का नफ़क़ा",
    hadithCount: 22,
    startHadith: 5351,
    endHadith: 5372,
  ),
  const BukhariBookInfo(
    id: 70,
    name: "Food and Meals",
    arabicName: "الأطعمة",
    urduName: "کھانے پینے کے آداب",
    hindiName: "खाने पीने के आदाब",
    hadithCount: 94,
    startHadith: 5373,
    endHadith: 5466,
  ),
  const BukhariBookInfo(
    id: 71,
    name: "Sacrifice on Birth (Aqiqa)",
    arabicName: "العقيقة",
    urduName: "عقیقہ",
    hindiName: "अक़ीक़ा",
    hadithCount: 8,
    startHadith: 5467,
    endHadith: 5474,
  ),
  const BukhariBookInfo(
    id: 72,
    name: "Slaughtering and Hunting",
    arabicName: "الذبائح والصيد",
    urduName: "ذبح اور شکار",
    hindiName: "ज़िब्ह और शिकार",
    hadithCount: 70,
    startHadith: 5475,
    endHadith: 5544,
  ),
  const BukhariBookInfo(
    id: 73,
    name: "Al-Adha Festival Sacrifice",
    arabicName: "الأضاحي",
    urduName: "قربانی",
    hindiName: "क़ुर्बानी",
    hadithCount: 30,
    startHadith: 5545,
    endHadith: 5574,
  ),
  const BukhariBookInfo(
    id: 74,
    name: "Drinks",
    arabicName: "الأشربة",
    urduName: "مشروبات",
    hindiName: "मशरूबात",
    hadithCount: 65,
    startHadith: 5575,
    endHadith: 5639,
  ),
  const BukhariBookInfo(
    id: 75,
    name: "Patients",
    arabicName: "المرضى",
    urduName: "مریض",
    hindiName: "मरीज़",
    hadithCount: 38,
    startHadith: 5640,
    endHadith: 5677,
  ),
  const BukhariBookInfo(
    id: 76,
    name: "Medicine",
    arabicName: "الطب",
    urduName: "طب",
    hindiName: "तिब्ब",
    hadithCount: 105,
    startHadith: 5678,
    endHadith: 5782,
  ),
  const BukhariBookInfo(
    id: 77,
    name: "Dress",
    arabicName: "اللباس",
    urduName: "لباس",
    hindiName: "लिबास",
    hadithCount: 187,
    startHadith: 5783,
    endHadith: 5969,
  ),
  const BukhariBookInfo(
    id: 78,
    name: "Good Manners (Adab)",
    arabicName: "الأدب",
    urduName: "اخلاق و آداب",
    hindiName: "अख़लाक़ व आदाब",
    hadithCount: 257,
    startHadith: 5970,
    endHadith: 6226,
  ),
  const BukhariBookInfo(
    id: 79,
    name: "Asking Permission",
    arabicName: "الاستئذان",
    urduName: "اجازت طلب کرنا",
    hindiName: "इजाज़त तलब करना",
    hadithCount: 77,
    startHadith: 6227,
    endHadith: 6303,
  ),
  const BukhariBookInfo(
    id: 80,
    name: "Supplications",
    arabicName: "الدعوات",
    urduName: "دعائیں",
    hindiName: "दुआएं",
    hadithCount: 108,
    startHadith: 6304,
    endHadith: 6411,
  ),
  const BukhariBookInfo(
    id: 81,
    name: "Heart Softening (Riqaq)",
    arabicName: "الرقاق",
    urduName: "دل کو نرم کرنا",
    hindiName: "दिल को नर्म करना",
    hadithCount: 182,
    startHadith: 6412,
    endHadith: 6593,
  ),
  const BukhariBookInfo(
    id: 82,
    name: "Divine Will (Qadar)",
    arabicName: "القدر",
    urduName: "تقدیر",
    hindiName: "तक़दीर",
    hadithCount: 27,
    startHadith: 6594,
    endHadith: 6620,
  ),
  const BukhariBookInfo(
    id: 83,
    name: "Oaths and Vows",
    arabicName: "الأيمان والنذور",
    urduName: "قسمیں اور نذریں",
    hindiName: "क़समें और नज़रें",
    hadithCount: 87,
    startHadith: 6621,
    endHadith: 6707,
  ),
  const BukhariBookInfo(
    id: 84,
    name: "Expiation for Unfulfilled Oaths",
    arabicName: "كفارات الأيمان",
    urduName: "قسموں کا کفارہ",
    hindiName: "क़समों का कफ़्फ़ारा",
    hadithCount: 15,
    startHadith: 6708,
    endHadith: 6722,
  ),
  const BukhariBookInfo(
    id: 85,
    name: "Inheritance Laws",
    arabicName: "الفرائض",
    urduName: "میراث کے قوانین",
    hindiName: "मीरास के क़ानून",
    hadithCount: 49,
    startHadith: 6723,
    endHadith: 6771,
  ),
  const BukhariBookInfo(
    id: 86,
    name: "Punishment (Hudud)",
    arabicName: "الحدود",
    urduName: "حدود",
    hindiName: "हुदूद",
    hadithCount: 88,
    startHadith: 6772,
    endHadith: 6859,
  ),
  const BukhariBookInfo(
    id: 87,
    name: "Blood Money (Diyat)",
    arabicName: "الديات",
    urduName: "خون بہا",
    hindiName: "ख़ून बहा",
    hadithCount: 57,
    startHadith: 6861,
    endHadith: 6917,
  ),
  const BukhariBookInfo(
    id: 88,
    name: "Dealing with Apostates",
    arabicName: "استتابة المرتدين",
    urduName: "مرتدوں سے نمٹنا",
    hindiName: "मुर्तदों से निपटना",
    hadithCount: 22,
    startHadith: 6918,
    endHadith: 6939,
  ),
  const BukhariBookInfo(
    id: 89,
    name: "Compulsion",
    arabicName: "الإكراه",
    urduName: "مجبوری",
    hindiName: "मजबूरी",
    hadithCount: 13,
    startHadith: 6940,
    endHadith: 6952,
  ),
  const BukhariBookInfo(
    id: 90,
    name: "Tricks",
    arabicName: "الحيل",
    urduName: "حیلے",
    hindiName: "हीले",
    hadithCount: 29,
    startHadith: 6953,
    endHadith: 6981,
  ),
  const BukhariBookInfo(
    id: 91,
    name: "Dream Interpretation",
    arabicName: "التعبير",
    urduName: "خواب کی تعبیر",
    hindiName: "ख़्वाब की ताबीर",
    hadithCount: 66,
    startHadith: 6982,
    endHadith: 7047,
  ),
  const BukhariBookInfo(
    id: 92,
    name: "Afflictions and End of World",
    arabicName: "الفتن",
    urduName: "فتنے اور قیامت کی نشانیاں",
    hindiName: "फ़ितने और क़यामत की निशानियां",
    hadithCount: 89,
    startHadith: 7048,
    endHadith: 7136,
  ),
  const BukhariBookInfo(
    id: 93,
    name: "Judgments (Ahkam)",
    arabicName: "الأحكام",
    urduName: "احکام",
    hindiName: "अहकाम",
    hadithCount: 89,
    startHadith: 7137,
    endHadith: 7225,
  ),
  const BukhariBookInfo(
    id: 94,
    name: "Wishes",
    arabicName: "التمني",
    urduName: "آرزوئیں",
    hindiName: "आरज़ुएं",
    hadithCount: 20,
    startHadith: 7226,
    endHadith: 7245,
  ),
  const BukhariBookInfo(
    id: 95,
    name: "Accepting Single Report",
    arabicName: "أخبار الآحاد",
    urduName: "خبر واحد",
    hindiName: "ख़बर वाहिद",
    hadithCount: 22,
    startHadith: 7246,
    endHadith: 7267,
  ),
  const BukhariBookInfo(
    id: 96,
    name: "Holding onto Quran and Sunnah",
    arabicName: "الاعتصام بالكتاب والسنة",
    urduName: "قرآن و سنت کو مضبوطی سے تھامنا",
    hindiName: "क़ुरआन व सुन्नत को मज़बूती से थामना",
    hadithCount: 103,
    startHadith: 7268,
    endHadith: 7370,
  ),
  const BukhariBookInfo(
    id: 97,
    name: "Oneness of Allah (Tawheed)",
    arabicName: "التوحيد",
    urduName: "توحید",
    hindiName: "तौहीद",
    hadithCount: 193,
    startHadith: 7371,
    endHadith: 7563,
  ),
];
