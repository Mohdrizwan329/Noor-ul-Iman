import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import 'hadith_book_detail_screen.dart';

class SunanNasaiScreen extends StatefulWidget {
  const SunanNasaiScreen({super.key});

  @override
  State<SunanNasaiScreen> createState() => _SunanNasaiScreenState();
}

class _SunanNasaiScreenState extends State<SunanNasaiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = HadithProvider.collectionInfo[HadithCollection.nasai]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: const TextStyle(fontSize: 18)),
            Text(
              '${_nasaiBooks.length} Kutub (Books)',
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
        itemCount: _nasaiBooks.length,
        itemBuilder: (context, index) {
          return _buildBookCard(context, _nasaiBooks[index], index + 1);
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, NasaiBookInfo book, int number) {
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
                collection: HadithCollection.nasai,
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

class NasaiBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final int hadithCount;

  const NasaiBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadithCount,
  });
}

// Complete list of all 38 Books in Sunan an-Nasai
final List<NasaiBookInfo> _nasaiBooks = [
  const NasaiBookInfo(id: 1, name: "Kitab at-Taharah (Purification)", arabicName: "كتاب الطهارة", hadithCount: 327),
  const NasaiBookInfo(id: 2, name: "Kitab al-Miyah (Water)", arabicName: "كتاب المياه", hadithCount: 54),
  const NasaiBookInfo(id: 3, name: "Kitab al-Hayd (Menstruation)", arabicName: "كتاب الحيض والاستحاضة", hadithCount: 36),
  const NasaiBookInfo(id: 4, name: "Kitab al-Ghusl (Bathing)", arabicName: "كتاب الغسل", hadithCount: 82),
  const NasaiBookInfo(id: 5, name: "Kitab at-Tayammum (Dry Ablution)", arabicName: "كتاب التيمم", hadithCount: 45),
  const NasaiBookInfo(id: 6, name: "Kitab as-Salat (Prayer)", arabicName: "كتاب الصلاة", hadithCount: 61),
  const NasaiBookInfo(id: 7, name: "Kitab al-Adhan (Call to Prayer)", arabicName: "كتاب الأذان", hadithCount: 70),
  const NasaiBookInfo(id: 8, name: "Kitab Mawaqit as-Salat (Prayer Times)", arabicName: "كتاب المواقيت", hadithCount: 178),
  const NasaiBookInfo(id: 9, name: "Kitab al-Qiblah (Direction of Prayer)", arabicName: "كتاب القبلة", hadithCount: 36),
  const NasaiBookInfo(id: 10, name: "Kitab al-Imamah (Leadership)", arabicName: "كتاب الإمامة", hadithCount: 80),
  const NasaiBookInfo(id: 11, name: "Kitab al-Jumu'ah (Friday Prayer)", arabicName: "كتاب الجمعة", hadithCount: 89),
  const NasaiBookInfo(id: 12, name: "Kitab Salat al-Khawf (Fear Prayer)", arabicName: "كتاب صلاة الخوف", hadithCount: 27),
  const NasaiBookInfo(id: 13, name: "Kitab al-'Eidayn (Two Eids)", arabicName: "كتاب صلاة العيدين", hadithCount: 45),
  const NasaiBookInfo(id: 14, name: "Kitab al-Istisqa' (Rain Prayer)", arabicName: "كتاب الاستسقاء", hadithCount: 26),
  const NasaiBookInfo(id: 15, name: "Kitab al-Kusuf (Eclipse Prayer)", arabicName: "كتاب الكسوف", hadithCount: 42),
  const NasaiBookInfo(id: 16, name: "Kitab al-Jana'iz (Funerals)", arabicName: "كتاب الجنائز", hadithCount: 275),
  const NasaiBookInfo(id: 17, name: "Kitab as-Siyam (Fasting)", arabicName: "كتاب الصيام", hadithCount: 310),
  const NasaiBookInfo(id: 18, name: "Kitab az-Zakat", arabicName: "كتاب الزكاة", hadithCount: 241),
  const NasaiBookInfo(id: 19, name: "Kitab al-Manasik (Hajj Rituals)", arabicName: "كتاب المناسك", hadithCount: 441),
  const NasaiBookInfo(id: 20, name: "Kitab al-Hajj (Pilgrimage)", arabicName: "كتاب الحج", hadithCount: 200),
  const NasaiBookInfo(id: 21, name: "Kitab an-Nikah (Marriage)", arabicName: "كتاب النكاح", hadithCount: 177),
  const NasaiBookInfo(id: 22, name: "Kitab at-Talaq (Divorce)", arabicName: "كتاب الطلاق", hadithCount: 134),
  const NasaiBookInfo(id: 23, name: "Kitab al-Buyu' (Sales)", arabicName: "كتاب البيوع", hadithCount: 315),
  const NasaiBookInfo(id: 24, name: "Kitab al-Qasamah (Oath of Retaliation)", arabicName: "كتاب القسامة", hadithCount: 86),
  const NasaiBookInfo(id: 25, name: "Kitab al-Qisas (Retaliation)", arabicName: "كتاب القصاص", hadithCount: 50),
  const NasaiBookInfo(id: 26, name: "Kitab al-Hudud (Legal Punishments)", arabicName: "كتاب الحدود", hadithCount: 94),
  const NasaiBookInfo(id: 27, name: "Kitab al-Jihad", arabicName: "كتاب الجهاد", hadithCount: 217),
  const NasaiBookInfo(id: 28, name: "Kitab as-Sayd (Hunting)", arabicName: "كتاب الصيد", hadithCount: 103),
  const NasaiBookInfo(id: 29, name: "Kitab adh-Dhaba'ih (Slaughtering)", arabicName: "كتاب الذبائح", hadithCount: 50),
  const NasaiBookInfo(id: 30, name: "Kitab al-Adahi (Sacrifices)", arabicName: "كتاب الأضاحي", hadithCount: 93),
  const NasaiBookInfo(id: 31, name: "Kitab al-Ashriba (Drinks)", arabicName: "كتاب الأشربة", hadithCount: 279),
  const NasaiBookInfo(id: 32, name: "Kitab al-Libas (Clothing)", arabicName: "كتاب اللباس", hadithCount: 193),
  const NasaiBookInfo(id: 33, name: "Kitab al-Fara'id (Inheritance)", arabicName: "كتاب الفرائض", hadithCount: 57),
  const NasaiBookInfo(id: 34, name: "Kitab al-Wasaya (Wills)", arabicName: "كتاب الوصايا", hadithCount: 36),
  const NasaiBookInfo(id: 35, name: "Kitab al-Ayman wa an-Nudhur (Oaths & Vows)", arabicName: "كتاب الأيمان والنذور", hadithCount: 137),
  const NasaiBookInfo(id: 36, name: "Kitab al-Istiadha (Seeking Refuge)", arabicName: "كتاب الاستعاذة", hadithCount: 113),
  const NasaiBookInfo(id: 37, name: "Kitab al-Adab (Manners)", arabicName: "كتاب الأدب", hadithCount: 46),
  const NasaiBookInfo(id: 38, name: "Kitab al-Iman (Faith)", arabicName: "كتاب الإيمان وشرائعه", hadithCount: 74),
];
