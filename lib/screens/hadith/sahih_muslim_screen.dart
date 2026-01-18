import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import 'hadith_book_detail_screen.dart';

class SahihMuslimScreen extends StatefulWidget {
  const SahihMuslimScreen({super.key});

  @override
  State<SahihMuslimScreen> createState() => _SahihMuslimScreenState();
}

class _SahihMuslimScreenState extends State<SahihMuslimScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = HadithProvider.collectionInfo[HadithCollection.muslim]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: const TextStyle(fontSize: 18)),
            Text(
              '${_muslimBooks.length} Kutub (Books)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showBookInfo(context, info),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _muslimBooks.length,
        itemBuilder: (context, index) {
          return _buildBookCard(context, _muslimBooks[index], index + 1);
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, MuslimBookInfo book, int number) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const softGold = Color(0xFFC9A24D);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Book Number
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${book.hadithCount} Hadiths',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: emeraldGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arabic Name with arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    book.arabicName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Amiri',
                      color: softGold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookInfo(BuildContext context, HadithCollectionInfo info) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info.arabicName,
                        style: const TextStyle(fontSize: 16, fontFamily: 'Amiri'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Compiled by: ${info.compiler}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              info.description,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _InfoChip(icon: Icons.book, label: '${info.totalBooks} Books'),
                const SizedBox(width: 12),
                _InfoChip(icon: Icons.format_list_numbered, label: '${info.totalHadith} Hadiths'),
              ],
            ),
            const SizedBox(height: 20),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
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
  final int hadithCount;

  const MuslimBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadithCount,
  });
}

// Complete list of all 56 Books in Sahih Muslim
final List<MuslimBookInfo> _muslimBooks = [
  const MuslimBookInfo(id: 1, name: "The Book of Faith", arabicName: "كتاب الإيمان", hadithCount: 432),
  const MuslimBookInfo(id: 2, name: "The Book of Purification", arabicName: "كتاب الطهارة", hadithCount: 279),
  const MuslimBookInfo(id: 3, name: "The Book of Menstruation", arabicName: "كتاب الحيض", hadithCount: 139),
  const MuslimBookInfo(id: 4, name: "The Book of Prayer", arabicName: "كتاب الصلاة", hadithCount: 285),
  const MuslimBookInfo(id: 5, name: "The Book of Mosques", arabicName: "كتاب المساجد", hadithCount: 319),
  const MuslimBookInfo(id: 6, name: "The Book of Prayer - Travellers", arabicName: "كتاب صلاة المسافرين", hadithCount: 311),
  const MuslimBookInfo(id: 7, name: "The Book of Friday Prayer", arabicName: "كتاب الجمعة", hadithCount: 68),
  const MuslimBookInfo(id: 8, name: "The Book of Eid Prayer", arabicName: "كتاب صلاة العيدين", hadithCount: 26),
  const MuslimBookInfo(id: 9, name: "The Book of Prayer for Rain", arabicName: "كتاب الاستسقاء", hadithCount: 16),
  const MuslimBookInfo(id: 10, name: "The Book of Eclipse Prayer", arabicName: "كتاب الكسوف", hadithCount: 31),
  const MuslimBookInfo(id: 11, name: "The Book of Funerals", arabicName: "كتاب الجنائز", hadithCount: 163),
  const MuslimBookInfo(id: 12, name: "The Book of Zakat", arabicName: "كتاب الزكاة", hadithCount: 224),
  const MuslimBookInfo(id: 13, name: "The Book of Fasting", arabicName: "كتاب الصيام", hadithCount: 222),
  const MuslimBookInfo(id: 14, name: "The Book of Itikaf", arabicName: "كتاب الاعتكاف", hadithCount: 11),
  const MuslimBookInfo(id: 15, name: "The Book of Pilgrimage", arabicName: "كتاب الحج", hadithCount: 605),
  const MuslimBookInfo(id: 16, name: "The Book of Marriage", arabicName: "كتاب النكاح", hadithCount: 174),
  const MuslimBookInfo(id: 17, name: "The Book of Suckling", arabicName: "كتاب الرضاع", hadithCount: 56),
  const MuslimBookInfo(id: 18, name: "The Book of Divorce", arabicName: "كتاب الطلاق", hadithCount: 75),
  const MuslimBookInfo(id: 19, name: "The Book of Cursing", arabicName: "كتاب اللعان", hadithCount: 23),
  const MuslimBookInfo(id: 20, name: "The Book of Manumission", arabicName: "كتاب العتق", hadithCount: 49),
  const MuslimBookInfo(id: 21, name: "The Book of Transactions", arabicName: "كتاب البيوع", hadithCount: 146),
  const MuslimBookInfo(id: 22, name: "The Book of Agriculture", arabicName: "كتاب المساقاة", hadithCount: 83),
  const MuslimBookInfo(id: 23, name: "The Book of Inheritance", arabicName: "كتاب الفرائض", hadithCount: 19),
  const MuslimBookInfo(id: 24, name: "The Book of Gifts", arabicName: "كتاب الهبات", hadithCount: 35),
  const MuslimBookInfo(id: 25, name: "The Book of Wills", arabicName: "كتاب الوصية", hadithCount: 29),
  const MuslimBookInfo(id: 26, name: "The Book of Vows", arabicName: "كتاب النذر", hadithCount: 26),
  const MuslimBookInfo(id: 27, name: "The Book of Oaths", arabicName: "كتاب الأيمان", hadithCount: 61),
  const MuslimBookInfo(id: 28, name: "The Book of Oaths (Qasama)", arabicName: "كتاب القسامة", hadithCount: 37),
  const MuslimBookInfo(id: 29, name: "The Book of Legal Punishments", arabicName: "كتاب الحدود", hadithCount: 71),
  const MuslimBookInfo(id: 30, name: "The Book of Judicial Decisions", arabicName: "كتاب الأقضية", hadithCount: 30),
  const MuslimBookInfo(id: 31, name: "The Book of Lost Property", arabicName: "كتاب اللقطة", hadithCount: 21),
  const MuslimBookInfo(id: 32, name: "The Book of Jihad", arabicName: "كتاب الجهاد والسير", hadithCount: 203),
  const MuslimBookInfo(id: 33, name: "The Book of Leadership", arabicName: "كتاب الإمارة", hadithCount: 251),
  const MuslimBookInfo(id: 34, name: "The Book of Hunting", arabicName: "كتاب الصيد والذبائح", hadithCount: 74),
  const MuslimBookInfo(id: 35, name: "The Book of Sacrifices", arabicName: "كتاب الأضاحي", hadithCount: 46),
  const MuslimBookInfo(id: 36, name: "The Book of Drinks", arabicName: "كتاب الأشربة", hadithCount: 183),
  const MuslimBookInfo(id: 37, name: "The Book of Clothes", arabicName: "كتاب اللباس والزينة", hadithCount: 136),
  const MuslimBookInfo(id: 38, name: "The Book of Good Manners", arabicName: "كتاب الآداب", hadithCount: 56),
  const MuslimBookInfo(id: 39, name: "The Book of Greetings", arabicName: "كتاب السلام", hadithCount: 166),
  const MuslimBookInfo(id: 40, name: "The Book of Poetry", arabicName: "كتاب الشعر", hadithCount: 10),
  const MuslimBookInfo(id: 41, name: "The Book of Dreams", arabicName: "كتاب الرؤيا", hadithCount: 28),
  const MuslimBookInfo(id: 42, name: "The Book of Virtues", arabicName: "كتاب الفضائل", hadithCount: 167),
  const MuslimBookInfo(id: 43, name: "The Book of Companions", arabicName: "كتاب فضائل الصحابة", hadithCount: 270),
  const MuslimBookInfo(id: 44, name: "The Book of Righteousness", arabicName: "كتاب البر والصلة", hadithCount: 181),
  const MuslimBookInfo(id: 45, name: "The Book of Destiny", arabicName: "كتاب القدر", hadithCount: 44),
  const MuslimBookInfo(id: 46, name: "The Book of Knowledge", arabicName: "كتاب العلم", hadithCount: 21),
  const MuslimBookInfo(id: 47, name: "The Book of Remembrance", arabicName: "كتاب الذكر والدعاء", hadithCount: 110),
  const MuslimBookInfo(id: 48, name: "The Book of Repentance", arabicName: "كتاب التوبة", hadithCount: 77),
  const MuslimBookInfo(id: 49, name: "The Book of Hypocrites", arabicName: "كتاب صفات المنافقين", hadithCount: 36),
  const MuslimBookInfo(id: 50, name: "The Book of Paradise", arabicName: "كتاب الجنة وصفة نعيمها", hadithCount: 93),
  const MuslimBookInfo(id: 51, name: "The Book of Tribulations", arabicName: "كتاب الفتن وأشراط الساعة", hadithCount: 161),
  const MuslimBookInfo(id: 52, name: "The Book of Asceticism", arabicName: "كتاب الزهد والرقائق", hadithCount: 80),
  const MuslimBookInfo(id: 53, name: "The Book of Tafsir", arabicName: "كتاب التفسير", hadithCount: 51),
  const MuslimBookInfo(id: 54, name: "Introduction", arabicName: "المقدمة", hadithCount: 89),
  const MuslimBookInfo(id: 55, name: "The Book of Foods", arabicName: "كتاب الأطعمة", hadithCount: 168),
  const MuslimBookInfo(id: 56, name: "The Book of Aqeeqa", arabicName: "كتاب العقيقة", hadithCount: 8),
];
