import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
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

// Complete list of all 43 Books in Sunan Abu Dawud (sunnah.com numbering)
// Source: https://sunnah.com/abudawud - Total 5274 hadith across 43 books
final List<AbuDawudBookInfo> _abuDawudBooks = [
  const AbuDawudBookInfo(id: 1, name: "Purification (Kitab Al-Taharah)", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 390),
  const AbuDawudBookInfo(id: 2, name: "Prayer (Kitab Al-Salat)", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 770),
  const AbuDawudBookInfo(id: 3, name: "Prayer for Rain (Istisqa)", arabicName: "كتاب الاستسقاء", urduName: "کتاب الاستسقاء", hindiName: "बारिश की नमाज़ की किताब", hadithCount: 37),
  const AbuDawudBookInfo(id: 4, name: "Prayer During Journey", arabicName: "كتاب صلاة السفر", urduName: "کتاب صلاۃ السفر", hindiName: "सफ़र की नमाज़ की किताब", hadithCount: 52),
  const AbuDawudBookInfo(id: 5, name: "Voluntary Prayers", arabicName: "كتاب التطوع", urduName: "کتاب التطوع", hindiName: "नफ़ल नमाज़ों की किताब", hadithCount: 121),
  const AbuDawudBookInfo(id: 6, name: "Ramadan (Detailed Injunctions)", arabicName: "كتاب شهر رمضان", urduName: "کتاب شہر رمضان", hindiName: "रमज़ान की किताब", hadithCount: 30),
  const AbuDawudBookInfo(id: 7, name: "Prostration During Quran Recitation", arabicName: "كتاب سجود القرآن", urduName: "کتاب سجود القرآن", hindiName: "क़ुरआन में सज्दे की किताब", hadithCount: 15),
  const AbuDawudBookInfo(id: 8, name: "Witr Prayer", arabicName: "كتاب الوتر", urduName: "کتاب الوتر", hindiName: "वित्र नमाज़ की किताब", hadithCount: 140),
  const AbuDawudBookInfo(id: 9, name: "Zakat (Kitab Al-Zakat)", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 145),
  const AbuDawudBookInfo(id: 10, name: "Lost and Found Items", arabicName: "كتاب اللقطة", urduName: "کتاب اللقطہ", hindiName: "खोई हुई वस्तु की किताब", hadithCount: 20),
  const AbuDawudBookInfo(id: 11, name: "Hajj Rites (Kitab Al-Manasik)", arabicName: "كتاب المناسك", urduName: "کتاب المناسک", hindiName: "हज के मनासिक की किताब", hadithCount: 325),
  const AbuDawudBookInfo(id: 12, name: "Marriage (Kitab Al-Nikah)", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 129),
  const AbuDawudBookInfo(id: 13, name: "Divorce (Kitab Al-Talaq)", arabicName: "كتاب الطلاق", urduName: "کتاب الطلاق", hindiName: "तलाक़ की किताब", hadithCount: 138),
  const AbuDawudBookInfo(id: 14, name: "Fasting (Kitab Al-Siyam)", arabicName: "كتاب الصوم", urduName: "کتاب الصوم", hindiName: "रोज़ा की किताब", hadithCount: 164),
  const AbuDawudBookInfo(id: 15, name: "Jihad (Kitab Al-Jihad)", arabicName: "كتاب الجهاد", urduName: "کتاب الجہاد", hindiName: "जिहाद की किताब", hadithCount: 311),
  const AbuDawudBookInfo(id: 16, name: "Sacrifice (Kitab Al-Dahaya)", arabicName: "كتاب الضحايا", urduName: "کتاب الضحایا", hindiName: "क़ुर्बानी की किताब", hadithCount: 56),
  const AbuDawudBookInfo(id: 17, name: "Game (Kitab Al-Said)", arabicName: "كتاب الصيد", urduName: "کتاب الصید", hindiName: "शिकार की किताब", hadithCount: 18),
  const AbuDawudBookInfo(id: 18, name: "Wills (Kitab Al-Wasaya)", arabicName: "كتاب الوصايا", urduName: "کتاب الوصایا", hindiName: "वसीयत की किताब", hadithCount: 23),
  const AbuDawudBookInfo(id: 19, name: "Inheritance (Kitab Al-Fara'id)", arabicName: "كتاب الفرائض", urduName: "کتاب الفرائض", hindiName: "विरासत की किताब", hadithCount: 43),
  const AbuDawudBookInfo(id: 20, name: "Tribute, Spoils and Rulership", arabicName: "كتاب الخراج والإمارة والفىء", urduName: "کتاب الخراج والامارۃ والفیء", hindiName: "ख़राज, माल-ए-ग़नीमत और हुकूमत की किताब", hadithCount: 161),
  const AbuDawudBookInfo(id: 21, name: "Funerals (Kitab Al-Jana'iz)", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "जनाज़े की किताब", hadithCount: 153),
  const AbuDawudBookInfo(id: 22, name: "Oaths and Vows", arabicName: "كتاب الأيمان والنذور", urduName: "کتاب الایمان والنذور", hindiName: "क़समें और मन्नतें की किताब", hadithCount: 84),
  const AbuDawudBookInfo(id: 23, name: "Commercial Transactions", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "ख़रीद-फ़रोख़्त की किताब", hadithCount: 90),
  const AbuDawudBookInfo(id: 24, name: "Wages (Kitab Al-Ijarah)", arabicName: "كتاب الإجارة", urduName: "کتاب الاجارہ", hindiName: "मज़दूरी और किराए की किताब", hadithCount: 155),
  const AbuDawudBookInfo(id: 25, name: "Office of the Judge", arabicName: "كتاب الأقضية", urduName: "کتاب الاقضیہ", hindiName: "क़ाज़ी के फ़राइज़ की किताब", hadithCount: 70),
  const AbuDawudBookInfo(id: 26, name: "Knowledge (Kitab Al-Ilm)", arabicName: "كتاب العلم", urduName: "کتاب العلم", hindiName: "इल्म की किताब", hadithCount: 28),
  const AbuDawudBookInfo(id: 27, name: "Drinks (Kitab Al-Ashribah)", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पीने की चीज़ों की किताब", hadithCount: 67),
  const AbuDawudBookInfo(id: 28, name: "Foods (Kitab Al-At'imah)", arabicName: "كتاب الأطعمة", urduName: "کتاب الاطعمہ", hindiName: "खाने की चीज़ों की किताब", hadithCount: 119),
  const AbuDawudBookInfo(id: 29, name: "Medicine (Kitab Al-Tibb)", arabicName: "كتاب الطب", urduName: "کتاب الطب", hindiName: "तिब्ब की किताब", hadithCount: 49),
  const AbuDawudBookInfo(id: 30, name: "Divination and Omens", arabicName: "كتاب الكهانة و التطير", urduName: "کتاب الکہانۃ والتطیر", hindiName: "कहानत और तियरा की किताब", hadithCount: 22),
  const AbuDawudBookInfo(id: 31, name: "Manumission of Slaves", arabicName: "كتاب العتق", urduName: "کتاب العتق", hindiName: "ग़ुलाम आज़ाद करने की किताब", hadithCount: 43),
  const AbuDawudBookInfo(id: 32, name: "Dialects and Quran Readings", arabicName: "كتاب الحروف والقراءات", urduName: "کتاب الحروف والقراءات", hindiName: "हुरूफ़ और क़िराअतों की किताब", hadithCount: 40),
  const AbuDawudBookInfo(id: 33, name: "Hot Baths (Kitab Al-Hammam)", arabicName: "كتاب الحمَّام", urduName: "کتاب الحمام", hindiName: "हम्माम की किताब", hadithCount: 11),
  const AbuDawudBookInfo(id: 34, name: "Clothing (Kitab Al-Libas)", arabicName: "كتاب اللباس", urduName: "کتاب اللباس", hindiName: "लिबास की किताब", hadithCount: 139),
  const AbuDawudBookInfo(id: 35, name: "Combing the Hair", arabicName: "كتاب الترجل", urduName: "کتاب الترجل", hindiName: "बालों को सवारने की किताब", hadithCount: 55),
  const AbuDawudBookInfo(id: 36, name: "Signet-Rings (Kitab Al-Khatam)", arabicName: "كتاب الخاتم", urduName: "کتاب الخاتم", hindiName: "अंगूठी की किताब", hadithCount: 26),
  const AbuDawudBookInfo(id: 37, name: "Trials and Fierce Battles", arabicName: "كتاب الفتن والملاحم", urduName: "کتاب الفتن والملاحم", hindiName: "फ़ितने और जंगों की किताब", hadithCount: 39),
  const AbuDawudBookInfo(id: 38, name: "The Promised Deliverer (Al-Mahdi)", arabicName: "كتاب المهدى", urduName: "کتاب المہدی", hindiName: "इमाम महदी की किताब", hadithCount: 12),
  const AbuDawudBookInfo(id: 39, name: "Battles (Kitab Al-Malahim)", arabicName: "كتاب الملاحم", urduName: "کتاب الملاحم", hindiName: "मलाहिम की किताब", hadithCount: 60),
  const AbuDawudBookInfo(id: 40, name: "Prescribed Punishments", arabicName: "كتاب الحدود", urduName: "کتاب الحدود", hindiName: "हुदूद की किताब", hadithCount: 143),
  const AbuDawudBookInfo(id: 41, name: "Blood-Wit (Kitab Al-Diyat)", arabicName: "كتاب الديات", urduName: "کتاب الدیات", hindiName: "दियत की किताब", hadithCount: 102),
  const AbuDawudBookInfo(id: 42, name: "Model Behavior of the Prophet", arabicName: "كتاب السنة", urduName: "کتاب السنۃ", hindiName: "सुन्नत की किताब", hadithCount: 177),
  const AbuDawudBookInfo(id: 43, name: "General Behavior (Kitab Al-Adab)", arabicName: "كتاب الأدب", urduName: "کتاب الادب", hindiName: "आदाब की किताब", hadithCount: 502),
];
