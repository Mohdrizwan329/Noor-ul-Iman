import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
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
        title: Text(
          context.tr('sahih_muslim'),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    TextAlign textAlign = TextAlign.left;

                    switch (langProvider.languageCode) {
                      case 'ar':
                        displayName = book.arabicName;
                        textDir = TextDirection.rtl;
                        textAlign = TextAlign.right;
                        break;
                      case 'ur':
                        displayName = book.urduName;
                        textDir = TextDirection.rtl;
                        textAlign = TextAlign.right;
                        break;
                      case 'hi':
                        displayName = book.hindiName;
                        textAlign = TextAlign.left;
                        break;
                      case 'en':
                      default:
                        displayName = book.name;
                        textAlign = TextAlign.left;
                        break;
                    }

                    return Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                        fontFamily: 'Poppins',
                        height: 1.3,
                      ),
                      textDirection: textDir,
                      textAlign: textAlign,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    );
                  },
                ),
              ),
              SizedBox(width: responsive.spacing(8)),

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

// Complete list of all 56 Books in Sahih Muslim (sunnah.com numbering)
// Source: https://sunnah.com/muslim - Total 3033 hadith references across 56 books
final List<MuslimBookInfo> _muslimBooks = [
  const MuslimBookInfo(
    id: 1,
    name: "The Book of Faith",
    arabicName: "كتاب الإيمان",
    urduName: "کتاب الایمان",
    hindiName: "ईमान की किताब",
    hadithCount: 215,
  ),
  const MuslimBookInfo(
    id: 2,
    name: "The Book of Purification",
    arabicName: "كتاب الطهارة",
    urduName: "کتاب الطہارت",
    hindiName: "पवित्रता की किताब",
    hadithCount: 70,
  ),
  const MuslimBookInfo(
    id: 3,
    name: "The Book of Menstruation",
    arabicName: "كتاب الحيض",
    urduName: "کتاب الحیض",
    hindiName: "माहवारी की किताब",
    hadithCount: 84,
  ),
  const MuslimBookInfo(
    id: 4,
    name: "The Book of Prayers",
    arabicName: "كتاب الصلاة",
    urduName: "کتاب الصلوٰۃ",
    hindiName: "नमाज़ की किताब",
    hadithCount: 143,
  ),
  const MuslimBookInfo(
    id: 5,
    name: "The Book of Mosques and Places of Prayer",
    arabicName: "كتاب الْمَسَاجِدِ وَمَوَاضِعِ الصَّلاَةِ",
    urduName: "کتاب المساجد ومواضع الصلاۃ",
    hindiName: "मस्जिदों और नमाज़ की जगहों की किताब",
    hadithCount: 165,
  ),
  const MuslimBookInfo(
    id: 6,
    name: "The Book of Prayer - Travellers",
    arabicName: "كتاب صلاة المسافرين وقصرها",
    urduName: "کتاب صلوٰۃ المسافرین وقصرہا",
    hindiName: "मुसाफ़िरों की नमाज़ की किताब",
    hadithCount: 159,
  ),
  const MuslimBookInfo(
    id: 7,
    name: "The Book of Friday Prayer",
    arabicName: "كتاب الجمعة",
    urduName: "کتاب الجمعہ",
    hindiName: "जुमा की नमाज़ की किताब",
    hadithCount: 40,
  ),
  const MuslimBookInfo(
    id: 8,
    name: "The Book of Prayer - Two Eids",
    arabicName: "كتاب صلاة العيدين",
    urduName: "کتاب صلوٰۃ العیدین",
    hindiName: "ईद की नमाज़ की किताब",
    hadithCount: 10,
  ),
  const MuslimBookInfo(
    id: 9,
    name: "The Book of Prayer - Rain",
    arabicName: "كتاب صلاة الاستسقاء‏",
    urduName: "کتاب صلاۃ الاستسقاء",
    hindiName: "बारिश की नमाज़ की किताब",
    hadithCount: 7,
  ),
  const MuslimBookInfo(
    id: 10,
    name: "The Book of Prayer - Eclipses",
    arabicName: "كتاب الكسوف",
    urduName: "کتاب الکسوف",
    hindiName: "ग्रहण की नमाज़ की किताब",
    hadithCount: 15,
  ),
  const MuslimBookInfo(
    id: 11,
    name: "The Book of Prayer - Funerals",
    arabicName: "كتاب الجنائز",
    urduName: "کتاب الجنائز",
    hindiName: "जनाज़े की नमाज़ की किताब",
    hadithCount: 63,
  ),
  const MuslimBookInfo(
    id: 12,
    name: "The Book of Zakat",
    arabicName: "كتاب الزكاة",
    urduName: "کتاب الزکوٰۃ",
    hindiName: "ज़कात की किताब",
    hadithCount: 100,
  ),
  const MuslimBookInfo(
    id: 13,
    name: "The Book of Fasting",
    arabicName: "كتاب الصيام",
    urduName: "کتاب الصیام",
    hindiName: "रोज़ा की किताब",
    hadithCount: 92,
  ),
  const MuslimBookInfo(
    id: 14,
    name: "The Book of I'tikaf",
    arabicName: "كتاب الاعتكاف",
    urduName: "کتاب الاعتکاف",
    hindiName: "एतिकाफ़ की किताब",
    hadithCount: 6,
  ),
  const MuslimBookInfo(
    id: 15,
    name: "The Book of Pilgrimage",
    arabicName: "كتاب الحج",
    urduName: "کتاب الحج",
    hindiName: "हज की किताब",
    hadithCount: 223,
  ),
  const MuslimBookInfo(
    id: 16,
    name: "The Book of Marriage",
    arabicName: "كتاب النكاح",
    urduName: "کتاب النکاح",
    hindiName: "निकाह की किताब",
    hadithCount: 44,
  ),
  const MuslimBookInfo(
    id: 17,
    name: "The Book of Suckling",
    arabicName: "كتاب الرضاع",
    urduName: "کتاب الرضاع",
    hindiName: "रज़ाअत की किताब",
    hadithCount: 27,
  ),
  const MuslimBookInfo(
    id: 18,
    name: "The Book of Divorce",
    arabicName: "كتاب الطلاق",
    urduName: "کتاب الطلاق",
    hindiName: "तलाक़ की किताब",
    hadithCount: 21,
  ),
  const MuslimBookInfo(
    id: 19,
    name: "The Book of Invoking Curses",
    arabicName: "كتاب اللعان",
    urduName: "کتاب اللعان",
    hindiName: "लान की किताब",
    hadithCount: 9,
  ),
  const MuslimBookInfo(
    id: 20,
    name: "The Book of Emancipating Slaves",
    arabicName: "كتاب العتق",
    urduName: "کتاب العتق",
    hindiName: "ग़ुलाम आज़ाद करने की किताब",
    hadithCount: 10,
  ),
  const MuslimBookInfo(
    id: 21,
    name: "The Book of Transactions",
    arabicName: "كتاب البيوع",
    urduName: "کتاب البیوع",
    hindiName: "ख़रीद व फ़रोख़्त की किताब",
    hadithCount: 40,
  ),
  const MuslimBookInfo(
    id: 22,
    name: "The Book of Musaqah",
    arabicName: "كتاب المساقاة",
    urduName: "کتاب المساقاۃ",
    hindiName: "मुसाक़ात की किताब",
    hadithCount: 63,
  ),
  const MuslimBookInfo(
    id: 23,
    name: "The Book of Inheritance",
    arabicName: "كتاب الفرائض",
    urduName: "کتاب الفرائض",
    hindiName: "विरासत की किताब",
    hadithCount: 6,
  ),
  const MuslimBookInfo(
    id: 24,
    name: "The Book of Gifts",
    arabicName: "كتاب الهبات",
    urduName: "کتاب الہبات",
    hindiName: "हिबा की किताब",
    hadithCount: 7,
  ),
  const MuslimBookInfo(
    id: 25,
    name: "The Book of Wills",
    arabicName: "كتاب الوصية",
    urduName: "کتاب الوصیہ",
    hindiName: "वसीयत की किताब",
    hadithCount: 11,
  ),
  const MuslimBookInfo(
    id: 26,
    name: "The Book of Vows",
    arabicName: "كتاب النذر",
    urduName: "کتاب النذر",
    hindiName: "नज़र की किताब",
    hadithCount: 8,
  ),
  const MuslimBookInfo(
    id: 27,
    name: "The Book of Oaths",
    arabicName: "كتاب الأيمان",
    urduName: "کتاب الایمان",
    hindiName: "क़समों की किताब",
    hadithCount: 23,
  ),
  const MuslimBookInfo(
    id: 28,
    name: "The Book of Qasama, Muharibin, Qisas and Diyat",
    arabicName: "كتاب القسامة والمحاربين والقصاص والديات",
    urduName: "کتاب القسامہ والمحاربین والقصاص والدیات",
    hindiName: "क़सामा, मुहारिबीन, क़िसास और दीयत की किताब",
    hadithCount: 15,
  ),
  const MuslimBookInfo(
    id: 29,
    name: "The Book of Legal Punishments",
    arabicName: "كتاب الحدود",
    urduName: "کتاب الحدود",
    hindiName: "हुदूद की किताब",
    hadithCount: 27,
  ),
  const MuslimBookInfo(
    id: 30,
    name: "The Book of Judicial Decisions",
    arabicName: "كتاب الأقضية",
    urduName: "کتاب الاقضیہ",
    hindiName: "फ़ैसलों की किताब",
    hadithCount: 11,
  ),
  const MuslimBookInfo(
    id: 31,
    name: "The Book of Lost Property",
    arabicName: "كتاب اللقطة",
    urduName: "کتاب اللقطہ",
    hindiName: "लुक़्ता की किताब",
    hadithCount: 8,
  ),
  const MuslimBookInfo(
    id: 32,
    name: "The Book of Jihad and Expeditions",
    arabicName: "كتاب الجهاد والسير",
    urduName: "کتاب الجہاد والسیر",
    hindiName: "जिहाद और ग़ज़वात की किताब",
    hadithCount: 88,
  ),
  const MuslimBookInfo(
    id: 33,
    name: "The Book on Government",
    arabicName: "كتاب الإمارة",
    urduName: "کتاب الامارۃ",
    hindiName: "इमारत की किताब",
    hadithCount: 111,
  ),
  const MuslimBookInfo(
    id: 34,
    name: "The Book of Hunting, Slaughter and Eating",
    arabicName: "كتاب الصيد والذبائح وما يؤكل من الحيوان",
    urduName: "کتاب الصید والذبائح وما یؤکل من الحیوان",
    hindiName: "शिकार, ज़बीहा और खाने की किताब",
    hadithCount: 31,
  ),
  const MuslimBookInfo(
    id: 35,
    name: "The Book of Sacrifices",
    arabicName: "كتاب الأضاحى",
    urduName: "کتاب الاضاحی",
    hindiName: "क़ुर्बानी की किताब",
    hadithCount: 19,
  ),
  const MuslimBookInfo(
    id: 36,
    name: "The Book of Drinks",
    arabicName: "كتاب الأشربة",
    urduName: "کتاب الاشربہ",
    hindiName: "पीने की चीज़ों की किताब",
    hadithCount: 86,
  ),
  const MuslimBookInfo(
    id: 37,
    name: "The Book of Clothes and Adornment",
    arabicName: "كتاب اللباس والزينة",
    urduName: "کتاب اللباس والزینہ",
    hindiName: "लिबास और ज़ीनत की किताब",
    hadithCount: 66,
  ),
  const MuslimBookInfo(
    id: 38,
    name: "The Book of Manners and Etiquette",
    arabicName: "كتاب الآداب",
    urduName: "کتاب الآداب",
    hindiName: "आदाब की किताब",
    hadithCount: 29,
  ),
  const MuslimBookInfo(
    id: 39,
    name: "The Book of Greetings",
    arabicName: "كتاب السلام",
    urduName: "کتاب السلام",
    hindiName: "सलाम की किताब",
    hadithCount: 86,
  ),
  const MuslimBookInfo(
    id: 40,
    name: "The Book of Correct Words",
    arabicName: "كتاب الألفاظ من الأدب وغيرها",
    urduName: "کتاب الالفاظ من الادب وغیرہا",
    hindiName: "सही अल्फ़ाज़ की किताब",
    hadithCount: 9,
  ),
  const MuslimBookInfo(
    id: 41,
    name: "The Book of Poetry",
    arabicName: "كتاب الشعر",
    urduName: "کتاب الشعر",
    hindiName: "शायरी की किताब",
    hadithCount: 6,
  ),
  const MuslimBookInfo(
    id: 42,
    name: "The Book of Dreams",
    arabicName: "كتاب الرؤيا",
    urduName: "کتاب الرؤیا",
    hindiName: "ख़्वाब की किताब",
    hadithCount: 15,
  ),
  const MuslimBookInfo(
    id: 43,
    name: "The Book of Virtues",
    arabicName: "كتاب الفضائل",
    urduName: "کتاب الفضائل",
    hindiName: "फ़ज़ाइल की किताब",
    hadithCount: 105,
  ),
  const MuslimBookInfo(
    id: 44,
    name: "The Book of Companions' Merits",
    arabicName: "كتاب فضائل الصحابة رضى الله تعالى عنهم",
    urduName: "کتاب فضائل الصحابہ رضی اللہ تعالیٰ عنہم",
    hindiName: "सहाबा की फ़ज़ीलतों की किताब",
    hadithCount: 167,
  ),
  const MuslimBookInfo(
    id: 45,
    name: "The Book of Virtue and Good Manners",
    arabicName: "كتاب البر والصلة والآداب",
    urduName: "کتاب البر والصلۃ والآداب",
    hindiName: "नेकी, सिला-रहमी और आदाब की किताब",
    hadithCount: 95,
  ),
  const MuslimBookInfo(
    id: 46,
    name: "The Book of Destiny",
    arabicName: "كتاب القدر",
    urduName: "کتاب القدر",
    hindiName: "तक़दीर की किताब",
    hadithCount: 22,
  ),
  const MuslimBookInfo(
    id: 47,
    name: "The Book of Knowledge",
    arabicName: "كتاب العلم",
    urduName: "کتاب العلم",
    hindiName: "इल्म की किताब",
    hadithCount: 10,
  ),
  const MuslimBookInfo(
    id: 48,
    name: "The Book of Remembrance and Supplication",
    arabicName: "كتاب الذكر والدعاء والتوبة والاستغفار",
    urduName: "کتاب الذکر والدعاء والتوبۃ والاستغفار",
    hindiName: "ज़िक्र, दुआ, तौबा और इस्तिग़्फ़ार की किताब",
    hadithCount: 61,
  ),
  const MuslimBookInfo(
    id: 49,
    name: "The Book of Heart-Melting Traditions",
    arabicName: "كتاب الرقاق",
    urduName: "کتاب الرقاق",
    hindiName: "दिल को नर्म करने वाली किताब",
    hadithCount: 8,
  ),
  const MuslimBookInfo(
    id: 50,
    name: "The Book of Repentance",
    arabicName: "كتاب التوبة",
    urduName: "کتاب التوبہ",
    hindiName: "तौबा की किताब",
    hadithCount: 28,
  ),
  const MuslimBookInfo(
    id: 51,
    name: "Characteristics of Hypocrites",
    arabicName: "كتاب صفات المنافقين وأحكامهم",
    urduName: "کتاب صفات المنافقین واحکامہم",
    hindiName: "मुनाफ़िक़ों की सिफ़ात की किताब",
    hadithCount: 13,
  ),
  const MuslimBookInfo(
    id: 52,
    name: "The Day of Judgment, Paradise and Hell",
    arabicName: "كتاب صفة القيامة والجنة والنار",
    urduName: "کتاب صفۃ القیامۃ والجنۃ والنار",
    hindiName: "क़यामत, जन्नत और जहन्नम की किताब",
    hadithCount: 37,
  ),
  const MuslimBookInfo(
    id: 53,
    name: "Paradise and Its Bounties",
    arabicName: "كتاب الجنة وصفة نعيمها وأهلها",
    urduName: "کتاب الجنۃ وصفۃ نعیمہا واہلہا",
    hindiName: "जन्नत और उसकी नेमतों की किताब",
    hadithCount: 58,
  ),
  const MuslimBookInfo(
    id: 54,
    name: "Tribulations and Signs of Hour",
    arabicName: "كتاب الفتن وأشراط الساعة",
    urduName: "کتاب الفتن واشراط الساعۃ",
    hindiName: "फ़ितने और क़यामत की निशानियों की किताब",
    hadithCount: 76,
  ),
  const MuslimBookInfo(
    id: 55,
    name: "The Book of Zuhd and Softening Hearts",
    arabicName: "كتاب الزهد والرقائق",
    urduName: "کتاب الزہد والرقائق",
    hindiName: "ज़ुहद और दिल नर्म करने की किताब",
    hadithCount: 59,
  ),
  const MuslimBookInfo(
    id: 56,
    name: "The Book of Tafsir",
    arabicName: "كتاب التفسير",
    urduName: "کتاب التفسیر",
    hindiName: "तफ़्सीर की किताब",
    hadithCount: 19,
  ),
];
