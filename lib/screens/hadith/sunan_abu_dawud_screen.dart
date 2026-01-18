import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import 'hadith_book_detail_screen.dart';

class SunanAbuDawudScreen extends StatefulWidget {
  const SunanAbuDawudScreen({super.key});

  @override
  State<SunanAbuDawudScreen> createState() => _SunanAbuDawudScreenState();
}

class _SunanAbuDawudScreenState extends State<SunanAbuDawudScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = HadithProvider.collectionInfo[HadithCollection.abudawud]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: const TextStyle(fontSize: 18)),
            Text(
              '${_abuDawudBooks.length} Kutub (Books)',
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
        itemCount: _abuDawudBooks.length,
        itemBuilder: (context, index) {
          return _buildBookCard(context, _abuDawudBooks[index], index + 1);
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, AbuDawudBookInfo book, int number) {
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
                collection: HadithCollection.abudawud,
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

class AbuDawudBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final int hadithCount;

  const AbuDawudBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadithCount,
  });
}

// Complete list of all Books in Sunan Abu Dawud
final List<AbuDawudBookInfo> _abuDawudBooks = [
  const AbuDawudBookInfo(id: 1, name: "Kitab at-Taharah (Purification)", arabicName: "كتاب الطهارة", hadithCount: 390),
  const AbuDawudBookInfo(id: 2, name: "Kitab as-Salat (Prayer)", arabicName: "كتاب الصلاة", hadithCount: 457),
  const AbuDawudBookInfo(id: 3, name: "Kitab az-Zakat", arabicName: "كتاب الزكاة", hadithCount: 145),
  const AbuDawudBookInfo(id: 4, name: "Kitab al-Luqatah (Lost & Found)", arabicName: "كتاب اللقطة", hadithCount: 25),
  const AbuDawudBookInfo(id: 5, name: "Kitab al-Manasik (Hajj Rituals)", arabicName: "كتاب المناسك", hadithCount: 198),
  const AbuDawudBookInfo(id: 6, name: "Kitab an-Nikah (Marriage)", arabicName: "كتاب النكاح", hadithCount: 130),
  const AbuDawudBookInfo(id: 7, name: "Kitab at-Talaq (Divorce)", arabicName: "كتاب الطلاق", hadithCount: 94),
  const AbuDawudBookInfo(id: 8, name: "Kitab as-Sawm (Fasting)", arabicName: "كتاب الصوم", hadithCount: 164),
  const AbuDawudBookInfo(id: 9, name: "Kitab al-Jihad", arabicName: "كتاب الجهاد", hadithCount: 177),
  const AbuDawudBookInfo(id: 10, name: "Kitab as-Sayd (Hunting)", arabicName: "كتاب الصيد", hadithCount: 40),
  const AbuDawudBookInfo(id: 11, name: "Kitab al-Wasaya (Wills)", arabicName: "كتاب الوصايا", hadithCount: 20),
  const AbuDawudBookInfo(id: 12, name: "Kitab al-Fara'id (Inheritance)", arabicName: "كتاب الفرائض", hadithCount: 21),
  const AbuDawudBookInfo(id: 13, name: "Kitab al-Kharaj wa al-Imarah (Tribute & Leadership)", arabicName: "كتاب الخراج والإمارة", hadithCount: 164),
  const AbuDawudBookInfo(id: 14, name: "Kitab al-Jana'iz (Funerals)", arabicName: "كتاب الجنائز", hadithCount: 134),
  const AbuDawudBookInfo(id: 15, name: "Kitab al-Ayman wa an-Nudhur (Oaths & Vows)", arabicName: "كتاب الأيمان والنذور", hadithCount: 67),
  const AbuDawudBookInfo(id: 16, name: "Kitab al-Buyu' (Sales)", arabicName: "كتاب البيوع", hadithCount: 104),
  const AbuDawudBookInfo(id: 17, name: "Kitab al-Ijarah (Wages)", arabicName: "كتاب الإجارة", hadithCount: 36),
  const AbuDawudBookInfo(id: 18, name: "Kitab al-Aqdiya (Judgments)", arabicName: "كتاب الأقضية", hadithCount: 60),
  const AbuDawudBookInfo(id: 19, name: "Kitab al-'Ilm (Knowledge)", arabicName: "كتاب العلم", hadithCount: 27),
  const AbuDawudBookInfo(id: 20, name: "Kitab al-Ashriba (Drinks)", arabicName: "كتاب الأشربة", hadithCount: 55),
  const AbuDawudBookInfo(id: 21, name: "Kitab al-At'imah (Foods)", arabicName: "كتاب الأطعمة", hadithCount: 93),
  const AbuDawudBookInfo(id: 22, name: "Kitab at-Tibb (Medicine)", arabicName: "كتاب الطب", hadithCount: 43),
  const AbuDawudBookInfo(id: 23, name: "Kitab al-Libas (Clothing)", arabicName: "كتاب اللباس", hadithCount: 69),
  const AbuDawudBookInfo(id: 24, name: "Kitab al-Hudud (Punishments)", arabicName: "كتاب الحدود", hadithCount: 79),
  const AbuDawudBookInfo(id: 25, name: "Kitab ad-Diyat (Blood Money)", arabicName: "كتاب الديات", hadithCount: 32),
  const AbuDawudBookInfo(id: 26, name: "Kitab al-Adab (Manners)", arabicName: "كتاب الأدب", hadithCount: 322),
  const AbuDawudBookInfo(id: 27, name: "Kitab al-Fitan (Tribulations)", arabicName: "كتاب الفتن", hadithCount: 87),
  const AbuDawudBookInfo(id: 28, name: "Kitab al-Malahim (Battles)", arabicName: "كتاب الملاحم", hadithCount: 20),
];
