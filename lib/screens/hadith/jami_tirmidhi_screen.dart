import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import 'hadith_book_detail_screen.dart';

class JamiTirmidhiScreen extends StatefulWidget {
  const JamiTirmidhiScreen({super.key});

  @override
  State<JamiTirmidhiScreen> createState() => _JamiTirmidhiScreenState();
}

class _JamiTirmidhiScreenState extends State<JamiTirmidhiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = HadithProvider.collectionInfo[HadithCollection.tirmidhi]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: const TextStyle(fontSize: 18)),
            Text(
              '${_tirmidhiBooks.length} Kutub (Books)',
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
        itemCount: _tirmidhiBooks.length,
        itemBuilder: (context, index) {
          return _buildBookCard(context, _tirmidhiBooks[index], index + 1);
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, TirmidhiBookInfo book, int number) {
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
                collection: HadithCollection.tirmidhi,
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

class TirmidhiBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final int hadithCount;

  const TirmidhiBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadithCount,
  });
}

// Complete list of all 33 Books in Jami at-Tirmidhi
final List<TirmidhiBookInfo> _tirmidhiBooks = [
  const TirmidhiBookInfo(id: 1, name: "Kitab at-Taharah (Purification)", arabicName: "كتاب الطهارة", hadithCount: 148),
  const TirmidhiBookInfo(id: 2, name: "Kitab as-Salat (Prayer)", arabicName: "كتاب الصلاة", hadithCount: 423),
  const TirmidhiBookInfo(id: 3, name: "Kitab az-Zakat", arabicName: "كتاب الزكاة", hadithCount: 89),
  const TirmidhiBookInfo(id: 4, name: "Kitab as-Sawm (Fasting)", arabicName: "كتاب الصوم", hadithCount: 128),
  const TirmidhiBookInfo(id: 5, name: "Kitab al-Hajj (Pilgrimage)", arabicName: "كتاب الحج", hadithCount: 157),
  const TirmidhiBookInfo(id: 6, name: "Kitab al-Jana'iz (Funerals)", arabicName: "كتاب الجنائز", hadithCount: 121),
  const TirmidhiBookInfo(id: 7, name: "Kitab an-Nikah (Marriage)", arabicName: "كتاب النكاح", hadithCount: 74),
  const TirmidhiBookInfo(id: 8, name: "Kitab ar-Rada'ah (Breastfeeding)", arabicName: "كتاب الرضاع", hadithCount: 28),
  const TirmidhiBookInfo(id: 9, name: "Kitab at-Talaq (Divorce)", arabicName: "كتاب الطلاق واللعان", hadithCount: 48),
  const TirmidhiBookInfo(id: 10, name: "Kitab al-Buyu' (Sales)", arabicName: "كتاب البيوع", hadithCount: 106),
  const TirmidhiBookInfo(id: 11, name: "Kitab al-Ahkam (Judgments)", arabicName: "كتاب الأحكام", hadithCount: 79),
  const TirmidhiBookInfo(id: 12, name: "Kitab ad-Diyat (Blood Money)", arabicName: "كتاب الديات", hadithCount: 37),
  const TirmidhiBookInfo(id: 13, name: "Kitab al-Hudud (Legal Punishments)", arabicName: "كتاب الحدود", hadithCount: 76),
  const TirmidhiBookInfo(id: 14, name: "Kitab as-Sayd (Hunting)", arabicName: "كتاب الصيد", hadithCount: 26),
  const TirmidhiBookInfo(id: 15, name: "Kitab adh-Dhaba'ih (Slaughtering)", arabicName: "كتاب الذبائح", hadithCount: 25),
  const TirmidhiBookInfo(id: 16, name: "Kitab al-Adahi (Sacrifices)", arabicName: "كتاب الأضاحي", hadithCount: 31),
  const TirmidhiBookInfo(id: 17, name: "Kitab al-Ashriba (Drinks)", arabicName: "كتاب الأشربة", hadithCount: 61),
  const TirmidhiBookInfo(id: 18, name: "Kitab al-Libas (Clothing)", arabicName: "كتاب اللباس", hadithCount: 72),
  const TirmidhiBookInfo(id: 19, name: "Kitab al-Adab (Manners)", arabicName: "كتاب الأدب", hadithCount: 120),
  const TirmidhiBookInfo(id: 20, name: "Kitab al-'Ilm (Knowledge)", arabicName: "كتاب العلم", hadithCount: 29),
  const TirmidhiBookInfo(id: 21, name: "Kitab al-Isti'dhan (Seeking Permission)", arabicName: "كتاب الاستئذان والآداب", hadithCount: 43),
  const TirmidhiBookInfo(id: 22, name: "Kitab al-Birr wa as-Silah (Righteousness & Ties)", arabicName: "كتاب البر والصلة", hadithCount: 107),
  const TirmidhiBookInfo(id: 23, name: "Kitab al-Qadr (Destiny)", arabicName: "كتاب القدر", hadithCount: 27),
  const TirmidhiBookInfo(id: 24, name: "Kitab al-Fitan (Tribulations)", arabicName: "كتاب الفتن", hadithCount: 79),
  const TirmidhiBookInfo(id: 25, name: "Kitab az-Zuhd (Asceticism)", arabicName: "كتاب الزهد", hadithCount: 113),
  const TirmidhiBookInfo(id: 26, name: "Kitab al-Manaqib (Virtues)", arabicName: "كتاب المناقب", hadithCount: 279),
  const TirmidhiBookInfo(id: 27, name: "Kitab al-Amthal (Parables)", arabicName: "كتاب الأمثال", hadithCount: 19),
  const TirmidhiBookInfo(id: 28, name: "Kitab al-Qira'at (Recitations)", arabicName: "كتاب القراءات", hadithCount: 18),
  const TirmidhiBookInfo(id: 29, name: "Kitab at-Tafsir (Qur'anic Exegesis)", arabicName: "كتاب التفسير", hadithCount: 406),
  const TirmidhiBookInfo(id: 30, name: "Kitab ad-Da'awat (Supplications)", arabicName: "كتاب الدعوات", hadithCount: 146),
  const TirmidhiBookInfo(id: 31, name: "Kitab Fada'il al-Qur'an (Virtues of Qur'an)", arabicName: "كتاب فضائل القرآن", hadithCount: 48),
  const TirmidhiBookInfo(id: 32, name: "Kitab al-Iman (Faith)", arabicName: "كتاب الإيمان", hadithCount: 39),
  const TirmidhiBookInfo(id: 33, name: "Kitab Sifat al-Qiyamah (Day of Judgment)", arabicName: "كتاب صفة القيامة والرقائق والورع", hadithCount: 113),
];
