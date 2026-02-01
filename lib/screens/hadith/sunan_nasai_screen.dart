import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'hadith_book_detail_screen.dart';

class SunanNasaiScreen extends StatefulWidget {
  const SunanNasaiScreen({super.key});

  @override
  State<SunanNasaiScreen> createState() => _SunanNasaiScreenState();
}

class _SunanNasaiScreenState extends State<SunanNasaiScreen> {
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

  List<NasaiBookInfo> _getFilteredBooks() {
    if (_searchQuery.isEmpty) {
      return _nasaiBooks;
    }
    final query = _searchQuery.toLowerCase();
    return _nasaiBooks.where((book) {
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
        title: Text(context.tr('sunan_nasai'), style: TextStyle(fontSize: responsive.textLarge)),
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
                          final originalIndex = _nasaiBooks.indexOf(book) + 1;
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

  Widget _buildBookCard(BuildContext context, NasaiBookInfo book, int number) {
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
                collection: HadithCollection.nasai,
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

class NasaiBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final String urduName;
  final String hindiName;
  final int hadithCount;

  const NasaiBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.urduName,
    required this.hindiName,
    required this.hadithCount,
  });
}

// Complete list of all 51 Books in Sunan an-Nasai (sunnah.com numbering)
// Source: https://sunnah.com/nasai - Total ~5700 hadith across 51 books
final List<NasaiBookInfo> _nasaiBooks = [
  const NasaiBookInfo(id: 1, name: "The Book of Purification", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 327),
  const NasaiBookInfo(id: 2, name: "The Book of Water", arabicName: "كتاب المياه", urduName: "کتاب المیاہ", hindiName: "पानी की किताब", hadithCount: 54),
  const NasaiBookInfo(id: 3, name: "The Book of Menstruation and Istihadah", arabicName: "كتاب الحيض والاستحاضة", urduName: "کتاب الحیض والاستحاضہ", hindiName: "माहवारी और इस्तिहाज़ा की किताब", hadithCount: 36),
  const NasaiBookInfo(id: 4, name: "The Book of Ghusl and Tayammum", arabicName: "كتاب الغسل والتيمم", urduName: "کتاب الغسل والتیمم", hindiName: "ग़ुस्ल और तयम्मुम की किताब", hadithCount: 127),
  const NasaiBookInfo(id: 5, name: "The Book of Salah", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 61),
  const NasaiBookInfo(id: 6, name: "The Book of Times of Prayer", arabicName: "كتاب المواقيت", urduName: "کتاب المواقیت", hindiName: "नमाज़ के औक़ात की किताब", hadithCount: 178),
  const NasaiBookInfo(id: 7, name: "The Book of the Adhan", arabicName: "كتاب الأذان", urduName: "کتاب الاذان", hindiName: "अज़ान की किताब", hadithCount: 70),
  const NasaiBookInfo(id: 8, name: "The Book of the Masjids", arabicName: "كتاب المساجد", urduName: "کتاب المساجد", hindiName: "मस्जिदों की किताब", hadithCount: 50),
  const NasaiBookInfo(id: 9, name: "The Book of the Qiblah", arabicName: "كتاب القبلة", urduName: "کتاب القبلہ", hindiName: "क़िबला की किताब", hadithCount: 36),
  const NasaiBookInfo(id: 10, name: "The Book of Leading Prayer", arabicName: "كتاب الإمامة", urduName: "کتاب الامامہ", hindiName: "इमामत की किताब", hadithCount: 80),
  const NasaiBookInfo(id: 11, name: "The Book of Commencement of Prayer", arabicName: "كتاب الافتتاح", urduName: "کتاب الافتتاح", hindiName: "नमाज़ की शुरूआत की किताब", hadithCount: 150),
  const NasaiBookInfo(id: 12, name: "The Book of At-Tatbiq", arabicName: "كتاب التطبيق", urduName: "کتاب التطبیق", hindiName: "तत्बीक़ की किताब", hadithCount: 120),
  const NasaiBookInfo(id: 13, name: "The Book of Forgetfulness in Prayer", arabicName: "كتاب السهو", urduName: "کتاب السہو", hindiName: "नमाज़ में भूल की किताब", hadithCount: 110),
  const NasaiBookInfo(id: 14, name: "The Book of Jumu'ah", arabicName: "كتاب الجمعة", urduName: "کتاب الجمعہ", hindiName: "जुमा की किताब", hadithCount: 89),
  const NasaiBookInfo(id: 15, name: "The Book of Shortening Prayer", arabicName: "كتاب تقصير الصلاة فى السفر", urduName: "کتاب تقصیر الصلاۃ فی السفر", hindiName: "सफ़र में नमाज़ क़स्र की किताब", hadithCount: 60),
  const NasaiBookInfo(id: 16, name: "The Book of Eclipses", arabicName: "كتاب الكسوف", urduName: "کتاب الکسوف", hindiName: "ग्रहण की किताब", hadithCount: 42),
  const NasaiBookInfo(id: 17, name: "The Book of Praying for Rain", arabicName: "كتاب الاستسقاء", urduName: "کتاب الاستسقاء", hindiName: "बारिश की नमाज़ की किताब", hadithCount: 26),
  const NasaiBookInfo(id: 18, name: "The Book of Fear Prayer", arabicName: "كتاب صلاة الخوف", urduName: "کتاب صلوٰۃ الخوف", hindiName: "ख़ौफ़ की नमाज़ की किताब", hadithCount: 27),
  const NasaiBookInfo(id: 19, name: "The Book of Prayer for Two Eids", arabicName: "كتاب صلاة العيدين", urduName: "کتاب صلوٰۃ العیدین", hindiName: "दो ईदों की नमाज़ की किताब", hadithCount: 45),
  const NasaiBookInfo(id: 20, name: "The Book of Qiyam Al-Lail", arabicName: "كتاب قيام الليل وتطوع النهار", urduName: "کتاب قیام اللیل وتطوع النہار", hindiName: "रात की इबादत और दिन के नफ़ल की किताब", hadithCount: 180),
  const NasaiBookInfo(id: 21, name: "The Book of Funerals", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "जनाज़े की किताब", hadithCount: 275),
  const NasaiBookInfo(id: 22, name: "The Book of Fasting", arabicName: "كتاب الصيام", urduName: "کتاب الصیام", hindiName: "रोज़ा की किताब", hadithCount: 310),
  const NasaiBookInfo(id: 23, name: "The Book of Zakah", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 241),
  const NasaiBookInfo(id: 24, name: "The Book of Hajj", arabicName: "كتاب مناسك الحج", urduName: "کتاب مناسک الحج", hindiName: "हज के मनासिक की किताब", hadithCount: 441),
  const NasaiBookInfo(id: 25, name: "The Book of Jihad", arabicName: "كتاب الجهاد", urduName: "کتاب الجہاد", hindiName: "जिहाद की किताब", hadithCount: 217),
  const NasaiBookInfo(id: 26, name: "The Book of Marriage", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 177),
  const NasaiBookInfo(id: 27, name: "The Book of Divorce", arabicName: "كتاب الطلاق", urduName: "کتاب الطلاق", hindiName: "तलाक़ की किताब", hadithCount: 134),
  const NasaiBookInfo(id: 28, name: "The Book of Horses, Races and Shooting", arabicName: "كتاب الخيل", urduName: "کتاب الخیل", hindiName: "घोड़ों, दौड़ और तीरंदाज़ी की किताब", hadithCount: 40),
  const NasaiBookInfo(id: 29, name: "The Book of Endowments", arabicName: "كتاب الإحباس", urduName: "کتاب الاحباس", hindiName: "वक़्फ़ की किताब", hadithCount: 15),
  const NasaiBookInfo(id: 30, name: "The Book of Wills", arabicName: "كتاب الوصايا", urduName: "کتاب الوصایا", hindiName: "वसीयत की किताब", hadithCount: 36),
  const NasaiBookInfo(id: 31, name: "The Book of Presents", arabicName: "كتاب النحل", urduName: "کتاب النحل", hindiName: "तोहफ़े की किताब", hadithCount: 10),
  const NasaiBookInfo(id: 32, name: "The Book of Gifts", arabicName: "كتاب الهبة", urduName: "کتاب الہبہ", hindiName: "हिबा की किताब", hadithCount: 15),
  const NasaiBookInfo(id: 33, name: "The Book of ar-Ruqba", arabicName: "كتاب الرقبى", urduName: "کتاب الرقبی", hindiName: "रुक़्बा की किताब", hadithCount: 10),
  const NasaiBookInfo(id: 34, name: "The Book of Umra", arabicName: "كتاب العمرى", urduName: "کتاب العمری", hindiName: "उम्रा की किताब", hadithCount: 15),
  const NasaiBookInfo(id: 35, name: "The Book of Oaths and Vows", arabicName: "كتاب الأيمان والنذور", urduName: "کتاب الایمان والنذور", hindiName: "क़समें और मन्नतें की किताब", hadithCount: 137),
  const NasaiBookInfo(id: 36, name: "The Book of Kind Treatment of Women", arabicName: "كتاب عشرة النساء", urduName: "کتاب عشرۃ النساء", hindiName: "औरतों के साथ अच्छा सुलूक की किताब", hadithCount: 30),
  const NasaiBookInfo(id: 37, name: "The Book of Fighting (Blood)", arabicName: "كتاب تحريم الدم", urduName: "کتاب تحریم الدم", hindiName: "ख़ून की हुर्मत की किताब", hadithCount: 50),
  const NasaiBookInfo(id: 38, name: "The Book of Distribution of Al-Fay'", arabicName: "كتاب قسم الفىء", urduName: "کتاب قسم الفیء", hindiName: "माल-ए-फ़ै की तक़सीम की किताब", hadithCount: 20),
  const NasaiBookInfo(id: 39, name: "The Book of Bay'ah", arabicName: "كتاب البيعة", urduName: "کتاب البیعۃ", hindiName: "बैअत की किताब", hadithCount: 50),
  const NasaiBookInfo(id: 40, name: "The Book of Aqiqah", arabicName: "كتاب العقيقة", urduName: "کتاب العقیقہ", hindiName: "अक़ीक़ा की किताब", hadithCount: 30),
  const NasaiBookInfo(id: 41, name: "The Book of al-Fara' and al-Atirah", arabicName: "كتاب الفرع والعتيرة", urduName: "کتاب الفرع والعتیرۃ", hindiName: "फ़रअ और अतीरा की किताब", hadithCount: 10),
  const NasaiBookInfo(id: 42, name: "The Book of Hunting and Slaughtering", arabicName: "كتاب الصيد والذبائح", urduName: "کتاب الصید والذبائح", hindiName: "शिकार और ज़बीहा की किताब", hadithCount: 103),
  const NasaiBookInfo(id: 43, name: "The Book of ad-Dahaya (Sacrifices)", arabicName: "كتاب الضحايا", urduName: "کتاب الضحایا", hindiName: "क़ुर्बानी की किताब", hadithCount: 93),
  const NasaiBookInfo(id: 44, name: "The Book of Financial Transactions", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "ख़रीद-फ़रोख़्त की किताब", hadithCount: 315),
  const NasaiBookInfo(id: 45, name: "The Book of Oaths and Retaliation", arabicName: "كتاب القسامة", urduName: "کتاب القسامہ", hindiName: "क़सामा की किताब", hadithCount: 86),
  const NasaiBookInfo(id: 46, name: "The Book of Cutting Hand of Thief", arabicName: "كتاب قطع السارق", urduName: "کتاب قطع السارق", hindiName: "चोर का हाथ काटने की किताब", hadithCount: 94),
  const NasaiBookInfo(id: 47, name: "The Book of Faith and its Signs", arabicName: "كتاب الإيمان وشرائعه", urduName: "کتاب الایمان وشرائعہ", hindiName: "ईमान और उसकी शराइत की किताब", hadithCount: 74),
  const NasaiBookInfo(id: 48, name: "The Book of Adornment", arabicName: "كتاب الزينة من السنن", urduName: "کتاب الزینۃ من السنن", hindiName: "ज़ीनत की किताब", hadithCount: 193),
  const NasaiBookInfo(id: 49, name: "The Book of Etiquette of Judges", arabicName: "كتاب آداب القضاة", urduName: "کتاب آداب القضاۃ", hindiName: "क़ाज़ियों के आदाब की किताब", hadithCount: 70),
  const NasaiBookInfo(id: 50, name: "The Book of Seeking Refuge", arabicName: "كتاب الاستعاذة", urduName: "کتاب الاستعاذہ", hindiName: "पनाह माँगने की किताब", hadithCount: 113),
  const NasaiBookInfo(id: 51, name: "The Book of Drinks", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पीने की चीज़ों की किताब", hadithCount: 279),
];
