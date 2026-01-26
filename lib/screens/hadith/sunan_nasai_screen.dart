import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
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

// Complete list of all 38 Books in Sunan an-Nasai
final List<NasaiBookInfo> _nasaiBooks = [
  const NasaiBookInfo(id: 1, name: "Kitab at-Taharah (Purification)", arabicName: "كتاب الطهارة", urduName: "کتاب الطہارت", hindiName: "पवित्रता की किताब", hadithCount: 327),
  const NasaiBookInfo(id: 2, name: "Kitab al-Miyah (Water)", arabicName: "كتاب المياه", urduName: "کتاب المیاہ", hindiName: "पानी की किताब", hadithCount: 54),
  const NasaiBookInfo(id: 3, name: "Kitab al-Hayd (Menstruation)", arabicName: "كتاب الحيض والاستحاضة", urduName: "کتاب الحیض", hindiName: "माहवारी की किताब", hadithCount: 36),
  const NasaiBookInfo(id: 4, name: "Kitab al-Ghusl (Bathing)", arabicName: "كتاب الغسل", urduName: "کتاب الغسل", hindiName: "स्नान की किताब", hadithCount: 82),
  const NasaiBookInfo(id: 5, name: "Kitab at-Tayammum (Dry Ablution)", arabicName: "كتاب التيمم", urduName: "کتاب التیمم", hindiName: "तयम्मुम की किताब", hadithCount: 45),
  const NasaiBookInfo(id: 6, name: "Kitab as-Salat (Prayer)", arabicName: "كتاب الصلاة", urduName: "کتاب الصلوٰۃ", hindiName: "नमाज़ की किताब", hadithCount: 61),
  const NasaiBookInfo(id: 7, name: "Kitab al-Adhan (Call to Prayer)", arabicName: "كتاب الأذان", urduName: "کتاب الاذان", hindiName: "अज़ान की किताब", hadithCount: 70),
  const NasaiBookInfo(id: 8, name: "Kitab Mawaqit as-Salat (Prayer Times)", arabicName: "كتاب المواقيت", urduName: "کتاب المواقیت", hindiName: "नमाज़ के समय की किताब", hadithCount: 178),
  const NasaiBookInfo(id: 9, name: "Kitab al-Qiblah (Direction of Prayer)", arabicName: "كتاب القبلة", urduName: "کتاب القبلہ", hindiName: "क़िबला की किताब", hadithCount: 36),
  const NasaiBookInfo(id: 10, name: "Kitab al-Imamah (Leadership)", arabicName: "كتاب الإمامة", urduName: "کتاب الامامہ", hindiName: "नेतृत्व की किताब", hadithCount: 80),
  const NasaiBookInfo(id: 11, name: "Kitab al-Jumu'ah (Friday Prayer)", arabicName: "كتاب الجمعة", urduName: "کتاب الجمعہ", hindiName: "जुमा की नमाज़ की किताब", hadithCount: 89),
  const NasaiBookInfo(id: 12, name: "Kitab Salat al-Khawf (Fear Prayer)", arabicName: "كتاب صلاة الخوف", urduName: "کتاب صلوٰۃ الخوف", hindiName: "भय की नमाज़ की किताब", hadithCount: 27),
  const NasaiBookInfo(id: 13, name: "Kitab al-'Eidayn (Two Eids)", arabicName: "كتاب صلاة العيدين", urduName: "کتاب صلوٰۃ العیدین", hindiName: "ईद की नमाज़ की किताब", hadithCount: 45),
  const NasaiBookInfo(id: 14, name: "Kitab al-Istisqa' (Rain Prayer)", arabicName: "كتاب الاستسقاء", urduName: "کتاب الاستسقاء", hindiName: "बारिश की दुआ की किताब", hadithCount: 26),
  const NasaiBookInfo(id: 15, name: "Kitab al-Kusuf (Eclipse Prayer)", arabicName: "كتاب الكسوف", urduName: "کتاب الکسوف", hindiName: "ग्रहण की नमाज़ की किताब", hadithCount: 42),
  const NasaiBookInfo(id: 16, name: "Kitab al-Jana'iz (Funerals)", arabicName: "كتاب الجنائز", urduName: "کتاب الجنائز", hindiName: "अंतिम संस्कार की किताब", hadithCount: 275),
  const NasaiBookInfo(id: 17, name: "Kitab as-Siyam (Fasting)", arabicName: "كتاب الصيام", urduName: "کتاب الصیام", hindiName: "रोज़ा की किताब", hadithCount: 310),
  const NasaiBookInfo(id: 18, name: "Kitab az-Zakat", arabicName: "كتاب الزكاة", urduName: "کتاب الزکوٰۃ", hindiName: "ज़कात की किताब", hadithCount: 241),
  const NasaiBookInfo(id: 19, name: "Kitab al-Manasik (Hajj Rituals)", arabicName: "كتاب المناسك", urduName: "کتاب المناسک", hindiName: "हज के रीति-रिवाज़ की किताब", hadithCount: 441),
  const NasaiBookInfo(id: 20, name: "Kitab al-Hajj (Pilgrimage)", arabicName: "كتاب الحج", urduName: "کتاب الحج", hindiName: "हज की किताब", hadithCount: 200),
  const NasaiBookInfo(id: 21, name: "Kitab an-Nikah (Marriage)", arabicName: "كتاب النكاح", urduName: "کتاب النکاح", hindiName: "निकाह की किताब", hadithCount: 177),
  const NasaiBookInfo(id: 22, name: "Kitab at-Talaq (Divorce)", arabicName: "كتاب الطلاق", urduName: "کتاب الطلاق", hindiName: "तलाक़ की किताब", hadithCount: 134),
  const NasaiBookInfo(id: 23, name: "Kitab al-Buyu' (Sales)", arabicName: "كتاب البيوع", urduName: "کتاب البیوع", hindiName: "लेन-देन की किताब", hadithCount: 315),
  const NasaiBookInfo(id: 24, name: "Kitab al-Qasamah (Oath of Retaliation)", arabicName: "كتاب القسامة", urduName: "کتاب القسامہ", hindiName: "क़सम की किताब", hadithCount: 86),
  const NasaiBookInfo(id: 25, name: "Kitab al-Qisas (Retaliation)", arabicName: "كتاب القصاص", urduName: "کتاب القصاص", hindiName: "बदला की किताब", hadithCount: 50),
  const NasaiBookInfo(id: 26, name: "Kitab al-Hudud (Legal Punishments)", arabicName: "كتاب الحدود", urduName: "کتاب الحدود", hindiName: "हदूद की किताब", hadithCount: 94),
  const NasaiBookInfo(id: 27, name: "Kitab al-Jihad", arabicName: "كتاب الجهاد", urduName: "کتاب الجہاد", hindiName: "जिहाद की किताब", hadithCount: 217),
  const NasaiBookInfo(id: 28, name: "Kitab as-Sayd (Hunting)", arabicName: "كتاب الصيد", urduName: "کتاب الصید", hindiName: "शिकार की किताब", hadithCount: 103),
  const NasaiBookInfo(id: 29, name: "Kitab adh-Dhaba'ih (Slaughtering)", arabicName: "كتاب الذبائح", urduName: "کتاب الذبائح", hindiName: "ज़बीहा की किताब", hadithCount: 50),
  const NasaiBookInfo(id: 30, name: "Kitab al-Adahi (Sacrifices)", arabicName: "كتاب الأضاحي", urduName: "کتاب الاضاحی", hindiName: "क़ुर्बानी की किताब", hadithCount: 93),
  const NasaiBookInfo(id: 31, name: "Kitab al-Ashriba (Drinks)", arabicName: "كتاب الأشربة", urduName: "کتاب الاشربہ", hindiName: "पेय पदार्थों की किताब", hadithCount: 279),
  const NasaiBookInfo(id: 32, name: "Kitab al-Libas (Clothing)", arabicName: "كتاب اللباس", urduName: "کتاب اللباس", hindiName: "वस्त्र की किताब", hadithCount: 193),
  const NasaiBookInfo(id: 33, name: "Kitab al-Fara'id (Inheritance)", arabicName: "كتاب الفرائض", urduName: "کتاب الفرائض", hindiName: "विरासत की किताब", hadithCount: 57),
  const NasaiBookInfo(id: 34, name: "Kitab al-Wasaya (Wills)", arabicName: "كتاب الوصايا", urduName: "کتاب الوصایا", hindiName: "वसीयत की किताब", hadithCount: 36),
  const NasaiBookInfo(id: 35, name: "Kitab al-Ayman wa an-Nudhur (Oaths & Vows)", arabicName: "كتاب الأيمان والنذور", urduName: "کتاب الایمان والنذور", hindiName: "कसम और मन्नत की किताब", hadithCount: 137),
  const NasaiBookInfo(id: 36, name: "Kitab al-Istiadha (Seeking Refuge)", arabicName: "كتاب الاستعاذة", urduName: "کتاب الاستعاذہ", hindiName: "शरण लेने की किताब", hadithCount: 113),
  const NasaiBookInfo(id: 37, name: "Kitab al-Adab (Manners)", arabicName: "كتاب الأدب", urduName: "کتاب الادب", hindiName: "शिष्टाचार की किताब", hadithCount: 46),
  const NasaiBookInfo(id: 38, name: "Kitab al-Iman (Faith)", arabicName: "كتاب الإيمان وشرائعه", urduName: "کتاب الایمان وشرائعہ", hindiName: "ईमान की किताब", hadithCount: 74),
];
