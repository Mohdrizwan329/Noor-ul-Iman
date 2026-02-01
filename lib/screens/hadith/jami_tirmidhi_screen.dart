import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
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

// Complete list of all 49 Books in Jami at-Tirmidhi (sunnah.com numbering)
// Source: https://sunnah.com/tirmidhi - Total ~3956 hadith across 49 books
final List<TirmidhiBookInfo> _tirmidhiBooks = [
  const TirmidhiBookInfo(id: 1, name: "The Book on Purification", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 148),
  const TirmidhiBookInfo(id: 2, name: "The Book on Salat (Prayer)", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 423),
  const TirmidhiBookInfo(id: 3, name: "The Book on Al-Witr", arabicName: "كتاب الوتر", urduName: "کتاب الوتر", hindiName: "वित्र की किताब", hadithCount: 31),
  const TirmidhiBookInfo(id: 4, name: "The Book on the Day of Friday", arabicName: "كتاب الجمعة", urduName: "کتاب الجمعہ", hindiName: "जुमा की किताब", hadithCount: 80),
  const TirmidhiBookInfo(id: 5, name: "The Book on the Two Eids", arabicName: "كتاب العيدين", urduName: "کتاب العیدین", hindiName: "दोनों ईदों की किताब", hadithCount: 23),
  const TirmidhiBookInfo(id: 6, name: "The Book on Traveling", arabicName: "كتاب السفر", urduName: "کتاب السفر", hindiName: "सफ़र की किताब", hadithCount: 50),
  const TirmidhiBookInfo(id: 7, name: "The Book on Zakat", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 89),
  const TirmidhiBookInfo(id: 8, name: "The Book on Fasting", arabicName: "كتاب الصوم", urduName: "کتاب الصوم", hindiName: "रोज़ा की किताब", hadithCount: 128),
  const TirmidhiBookInfo(id: 9, name: "The Book on Hajj", arabicName: "كتاب الحج", urduName: "کتاب الحج", hindiName: "हज की किताब", hadithCount: 157),
  const TirmidhiBookInfo(id: 10, name: "The Book on Jana'iz (Funerals)", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "जनाज़े की किताब", hadithCount: 121),
  const TirmidhiBookInfo(id: 11, name: "The Book on Marriage", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 74),
  const TirmidhiBookInfo(id: 12, name: "The Book on Suckling", arabicName: "كتاب الرضاع", urduName: "کتاب الرضاع", hindiName: "दूध पिलाने की किताब", hadithCount: 28),
  const TirmidhiBookInfo(id: 13, name: "The Book on Divorce and Li'an", arabicName: "كتاب الطلاق واللعان", urduName: "کتاب الطلاق واللعان", hindiName: "तलाक़ और लिआन की किताब", hadithCount: 48),
  const TirmidhiBookInfo(id: 14, name: "The Book on Business", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "खरीद-फ़रोख्त की किताब", hadithCount: 106),
  const TirmidhiBookInfo(id: 15, name: "Chapters on Judgments", arabicName: "كتاب الأحكام", urduName: "کتاب الاحکام", hindiName: "फ़ैसलों की किताब", hadithCount: 79),
  const TirmidhiBookInfo(id: 16, name: "The Book on Blood Money", arabicName: "كتاب الديات", urduName: "کتاب الدیات", hindiName: "खून-बहा की किताब", hadithCount: 37),
  const TirmidhiBookInfo(id: 17, name: "The Book on Legal Punishments (Al-Hudud)", arabicName: "كتاب الحدود", urduName: "کتاب الحدود", hindiName: "हुदूद की किताब", hadithCount: 76),
  const TirmidhiBookInfo(id: 18, name: "The Book on Hunting", arabicName: "كتاب الصيد", urduName: "کتاب الصید", hindiName: "शिकार की किताब", hadithCount: 26),
  const TirmidhiBookInfo(id: 19, name: "The Book on Sacrifices", arabicName: "كتاب الأضاحي", urduName: "کتاب الاضاحی", hindiName: "क़ुर्बानी की किताब", hadithCount: 31),
  const TirmidhiBookInfo(id: 20, name: "The Book on Vows and Oaths", arabicName: "كتاب النذور والأيمان", urduName: "کتاب النذور والایمان", hindiName: "मन्नत और क़सम की किताब", hadithCount: 42),
  const TirmidhiBookInfo(id: 21, name: "The Book on Military Expeditions", arabicName: "كتاب السير", urduName: "کتاب السیر", hindiName: "ग़ज़वात की किताब", hadithCount: 52),
  const TirmidhiBookInfo(id: 22, name: "The Book on Virtues of Jihad", arabicName: "كتاب فضائل الجهاد", urduName: "کتاب فضائل الجہاد", hindiName: "जिहाद की फ़ज़ीलतें", hadithCount: 43),
  const TirmidhiBookInfo(id: 23, name: "The Book on Jihad", arabicName: "كتاب الجهاد", urduName: "کتاب الجہاد", hindiName: "जिहाद की किताब", hadithCount: 46),
  const TirmidhiBookInfo(id: 24, name: "The Book on Clothing", arabicName: "كتاب اللباس", urduName: "کتاب اللباس", hindiName: "लिबास की किताब", hadithCount: 72),
  const TirmidhiBookInfo(id: 25, name: "The Book on Food", arabicName: "كتاب الأطعمة", urduName: "کتاب الاطعمہ", hindiName: "खाने की चीज़ों की किताब", hadithCount: 68),
  const TirmidhiBookInfo(id: 26, name: "The Book on Drinks", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पेय की किताब", hadithCount: 61),
  const TirmidhiBookInfo(id: 27, name: "Chapters on Righteousness and Maintaining Relations", arabicName: "كتاب البر والصلة", urduName: "کتاب البر والصلہ", hindiName: "नेकी और सिला रहमी की किताब", hadithCount: 107),
  const TirmidhiBookInfo(id: 28, name: "Chapters on Medicine", arabicName: "كتاب الطب", urduName: "کتاب الطب", hindiName: "तिब (इलाज) की किताब", hadithCount: 35),
  const TirmidhiBookInfo(id: 29, name: "Chapters on Inheritance", arabicName: "كتاب الفرائض", urduName: "کتاب الفرائض", hindiName: "विरासत की किताब", hadithCount: 26),
  const TirmidhiBookInfo(id: 30, name: "Chapters on Wills and Testaments (Wasaya)", arabicName: "كتاب الوصايا", urduName: "کتاب الوصایا", hindiName: "वसीयत की किताब", hadithCount: 12),
  const TirmidhiBookInfo(id: 31, name: "Chapters on Wala' and Gifts", arabicName: "كتاب الولاء والهبة", urduName: "کتاب الولاء والہبہ", hindiName: "वला और हिबा की किताब", hadithCount: 11),
  const TirmidhiBookInfo(id: 32, name: "Chapters on Al-Qadar (Destiny)", arabicName: "كتاب القدر", urduName: "کتاب القدر", hindiName: "तक़दीर की किताब", hadithCount: 27),
  const TirmidhiBookInfo(id: 33, name: "Chapters on Al-Fitan (Tribulations)", arabicName: "كتاب الفتن", urduName: "کتاب الفتن", hindiName: "फ़ितनों की किताब", hadithCount: 79),
  const TirmidhiBookInfo(id: 34, name: "Chapters on Dreams", arabicName: "كتاب الرؤيا", urduName: "کتاب الرؤیا", hindiName: "ख्वाबों की किताब", hadithCount: 17),
  const TirmidhiBookInfo(id: 35, name: "Chapters on Witnesses", arabicName: "كتاب الشهادات", urduName: "کتاب الشہادات", hindiName: "गवाहियों की किताब", hadithCount: 13),
  const TirmidhiBookInfo(id: 36, name: "Chapters on Zuhd (Asceticism)", arabicName: "كتاب الزهد", urduName: "کتاب الزہد", hindiName: "ज़ुहद की किताब", hadithCount: 113),
  const TirmidhiBookInfo(id: 37, name: "Chapters on the Description of the Day of Judgment", arabicName: "كتاب صفة القيامة والرقائق والورع", urduName: "کتاب صفۃ القیامۃ", hindiName: "क़यामत का बयान", hadithCount: 113),
  const TirmidhiBookInfo(id: 38, name: "Chapters on the Description of Paradise", arabicName: "كتاب صفة الجنة", urduName: "کتاب صفۃ الجنۃ", hindiName: "जन्नत का बयान", hadithCount: 34),
  const TirmidhiBookInfo(id: 39, name: "The Book on the Description of Hellfire", arabicName: "كتاب صفة جهنم", urduName: "کتاب صفۃ جہنم", hindiName: "जहन्नम का बयान", hadithCount: 24),
  const TirmidhiBookInfo(id: 40, name: "The Book on Faith", arabicName: "كتاب الإيمان", urduName: "کتاب الایمان", hindiName: "ईमान की किताब", hadithCount: 39),
  const TirmidhiBookInfo(id: 41, name: "Chapters on Knowledge", arabicName: "كتاب العلم", urduName: "کتاب العلم", hindiName: "इल्म की किताब", hadithCount: 29),
  const TirmidhiBookInfo(id: 42, name: "Chapters on Seeking Permission", arabicName: "كتاب الاستئذان والآداب", urduName: "کتاب الاستئذان والآداب", hindiName: "इजाज़त लेने की किताब", hadithCount: 43),
  const TirmidhiBookInfo(id: 43, name: "Chapters on Manners", arabicName: "كتاب الأدب", urduName: "کتاب الادب", hindiName: "आदाब की किताब", hadithCount: 120),
  const TirmidhiBookInfo(id: 44, name: "Chapters on Parables", arabicName: "كتاب الأمثال", urduName: "کتاب الامثال", hindiName: "मिसालों की किताब", hadithCount: 19),
  const TirmidhiBookInfo(id: 45, name: "Chapters on the Virtues of the Qur'an", arabicName: "كتاب فضائل القرآن", urduName: "کتاب فضائل القرآن", hindiName: "क़ुरआन की फ़ज़ीलतें", hadithCount: 48),
  const TirmidhiBookInfo(id: 46, name: "Chapters on Recitation", arabicName: "كتاب القراءات", urduName: "کتاب القراءات", hindiName: "क़िराअत की किताब", hadithCount: 18),
  const TirmidhiBookInfo(id: 47, name: "Chapters on Tafsir (Qur'anic Exegesis)", arabicName: "كتاب التفسير", urduName: "کتاب التفسیر", hindiName: "तफ़्सीर की किताब", hadithCount: 406),
  const TirmidhiBookInfo(id: 48, name: "Chapters on Supplication (Du'a)", arabicName: "كتاب الدعوات", urduName: "کتاب الدعوات", hindiName: "दुआओं की किताब", hadithCount: 146),
  const TirmidhiBookInfo(id: 49, name: "Chapters on Virtues (Al-Manaqib)", arabicName: "كتاب المناقب", urduName: "کتاب المناقب", hindiName: "फ़ज़ाइल की किताब", hadithCount: 279),
];
