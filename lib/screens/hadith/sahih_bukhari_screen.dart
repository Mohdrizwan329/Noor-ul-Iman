import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import 'hadith_book_detail_screen.dart';

class SahihBukhariScreen extends StatefulWidget {
  const SahihBukhariScreen({super.key});

  @override
  State<SahihBukhariScreen> createState() => _SahihBukhariScreenState();
}

class _SahihBukhariScreenState extends State<SahihBukhariScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = HadithProvider.collectionInfo[HadithCollection.bukhari]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: const TextStyle(fontSize: 18)),
            Text(
              '${_bukhariBooks.length} Kutub (Books)',
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
        itemCount: _bukhariBooks.length,
        itemBuilder: (context, index) {
          return _buildBookCard(context, _bukhariBooks[index], index + 1);
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, BukhariBookInfo book, int number) {
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
                collection: HadithCollection.bukhari,
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
                  child: Icon(Icons.menu_book, color: AppColors.primary, size: 32),
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
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// Bukhari Book Info Model
class BukhariBookInfo {
  final int id;
  final String name;
  final String arabicName;
  final int hadithCount;
  final int startHadith;
  final int endHadith;

  const BukhariBookInfo({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadithCount,
    required this.startHadith,
    required this.endHadith,
  });
}

// Complete list of all 97 Books in Sahih Bukhari (API numbering)
// Note: Classical scholars count 73 Kutub, but modern API uses 97 book divisions
final List<BukhariBookInfo> _bukhariBooks = [
  const BukhariBookInfo(id: 1, name: "Revelation", arabicName: "بدء الوحي", hadithCount: 7, startHadith: 1, endHadith: 7),
  const BukhariBookInfo(id: 2, name: "Belief", arabicName: "الإيمان", hadithCount: 51, startHadith: 8, endHadith: 58),
  const BukhariBookInfo(id: 3, name: "Knowledge", arabicName: "العلم", hadithCount: 76, startHadith: 59, endHadith: 134),
  const BukhariBookInfo(id: 4, name: "Ablution (Wudu)", arabicName: "الوضوء", hadithCount: 113, startHadith: 135, endHadith: 247),
  const BukhariBookInfo(id: 5, name: "Bathing (Ghusl)", arabicName: "الغسل", hadithCount: 46, startHadith: 248, endHadith: 293),
  const BukhariBookInfo(id: 6, name: "Menstruation", arabicName: "الحيض", hadithCount: 40, startHadith: 294, endHadith: 333),
  const BukhariBookInfo(id: 7, name: "Dry Ablution (Tayammum)", arabicName: "التيمم", hadithCount: 15, startHadith: 334, endHadith: 348),
  const BukhariBookInfo(id: 8, name: "Prayer (Salat)", arabicName: "الصلاة", hadithCount: 172, startHadith: 349, endHadith: 520),
  const BukhariBookInfo(id: 9, name: "Times of Prayer", arabicName: "مواقيت الصلاة", hadithCount: 82, startHadith: 521, endHadith: 602),
  const BukhariBookInfo(id: 10, name: "Call to Prayer (Adhan)", arabicName: "الأذان", hadithCount: 164, startHadith: 603, endHadith: 766),
  const BukhariBookInfo(id: 11, name: "Friday Prayer", arabicName: "الجمعة", hadithCount: 68, startHadith: 767, endHadith: 834),
  const BukhariBookInfo(id: 12, name: "Fear Prayer", arabicName: "صلاة الخوف", hadithCount: 6, startHadith: 835, endHadith: 840),
  const BukhariBookInfo(id: 13, name: "Two Eids", arabicName: "العيدين", hadithCount: 40, startHadith: 841, endHadith: 880),
  const BukhariBookInfo(id: 14, name: "Witr Prayer", arabicName: "الوتر", hadithCount: 20, startHadith: 881, endHadith: 900),
  const BukhariBookInfo(id: 15, name: "Rain Prayer (Istisqa)", arabicName: "الاستسقاء", hadithCount: 29, startHadith: 901, endHadith: 929),
  const BukhariBookInfo(id: 16, name: "Eclipse Prayer", arabicName: "الكسوف", hadithCount: 31, startHadith: 930, endHadith: 960),
  const BukhariBookInfo(id: 17, name: "Prostration During Quran", arabicName: "سجود القرآن", hadithCount: 14, startHadith: 961, endHadith: 974),
  const BukhariBookInfo(id: 18, name: "Shortening Prayer", arabicName: "تقصير الصلاة", hadithCount: 20, startHadith: 975, endHadith: 994),
  const BukhariBookInfo(id: 19, name: "Night Prayer (Tahajjud)", arabicName: "التهجد", hadithCount: 43, startHadith: 995, endHadith: 1037),
  const BukhariBookInfo(id: 20, name: "Virtue of Prayer in Makkah & Madinah", arabicName: "فضل الصلاة", hadithCount: 10, startHadith: 1038, endHadith: 1047),
  const BukhariBookInfo(id: 21, name: "Actions while Praying", arabicName: "العمل في الصلاة", hadithCount: 24, startHadith: 1048, endHadith: 1071),
  const BukhariBookInfo(id: 22, name: "Forgetfulness in Prayer", arabicName: "السهو", hadithCount: 15, startHadith: 1072, endHadith: 1086),
  const BukhariBookInfo(id: 23, name: "Funerals (Al-Janaiz)", arabicName: "الجنائز", hadithCount: 158, startHadith: 1087, endHadith: 1244),
  const BukhariBookInfo(id: 24, name: "Zakat", arabicName: "الزكاة", hadithCount: 118, startHadith: 1245, endHadith: 1362),
  const BukhariBookInfo(id: 25, name: "Hajj", arabicName: "الحج", hadithCount: 260, startHadith: 1363, endHadith: 1622),
  const BukhariBookInfo(id: 26, name: "Umrah", arabicName: "العمرة", hadithCount: 25, startHadith: 1623, endHadith: 1647),
  const BukhariBookInfo(id: 27, name: "Prevented from Hajj", arabicName: "المحصر", hadithCount: 18, startHadith: 1648, endHadith: 1665),
  const BukhariBookInfo(id: 28, name: "Penalty of Hunting", arabicName: "جزاء الصيد", hadithCount: 31, startHadith: 1666, endHadith: 1696),
  const BukhariBookInfo(id: 29, name: "Virtues of Madinah", arabicName: "فضائل المدينة", hadithCount: 28, startHadith: 1697, endHadith: 1724),
  const BukhariBookInfo(id: 30, name: "Fasting", arabicName: "الصوم", hadithCount: 117, startHadith: 1725, endHadith: 1841),
  const BukhariBookInfo(id: 31, name: "Tarawih Prayer", arabicName: "التراويح", hadithCount: 7, startHadith: 1842, endHadith: 1848),
  const BukhariBookInfo(id: 32, name: "Staying in Mosque (Itikaf)", arabicName: "الاعتكاف", hadithCount: 21, startHadith: 1849, endHadith: 1869),
  const BukhariBookInfo(id: 33, name: "Sales and Trade", arabicName: "البيوع", hadithCount: 169, startHadith: 1870, endHadith: 2038),
  const BukhariBookInfo(id: 34, name: "Advance Payment (Salam)", arabicName: "السلم", hadithCount: 12, startHadith: 2039, endHadith: 2050),
  const BukhariBookInfo(id: 35, name: "Pre-emption (Shuf'a)", arabicName: "الشفعة", hadithCount: 5, startHadith: 2051, endHadith: 2055),
  const BukhariBookInfo(id: 36, name: "Hiring", arabicName: "الإجارة", hadithCount: 22, startHadith: 2056, endHadith: 2077),
  const BukhariBookInfo(id: 37, name: "Debt Transfer", arabicName: "الحوالة", hadithCount: 5, startHadith: 2078, endHadith: 2082),
  const BukhariBookInfo(id: 38, name: "Guarantee (Kafalah)", arabicName: "الكفالة", hadithCount: 5, startHadith: 2083, endHadith: 2087),
  const BukhariBookInfo(id: 39, name: "Representation/Authorization", arabicName: "الوكالة", hadithCount: 20, startHadith: 2088, endHadith: 2107),
  const BukhariBookInfo(id: 40, name: "Agriculture", arabicName: "المزارعة", hadithCount: 22, startHadith: 2108, endHadith: 2129),
  const BukhariBookInfo(id: 41, name: "Water Distribution", arabicName: "المساقاة", hadithCount: 28, startHadith: 2130, endHadith: 2157),
  const BukhariBookInfo(id: 42, name: "Loans", arabicName: "الاستقراض", hadithCount: 27, startHadith: 2158, endHadith: 2184),
  const BukhariBookInfo(id: 43, name: "Disputes", arabicName: "الخصومات", hadithCount: 10, startHadith: 2185, endHadith: 2194),
  const BukhariBookInfo(id: 44, name: "Lost Things Picked up", arabicName: "اللقطة", hadithCount: 18, startHadith: 2195, endHadith: 2212),
  const BukhariBookInfo(id: 45, name: "Oppression", arabicName: "المظالم", hadithCount: 46, startHadith: 2213, endHadith: 2258),
  const BukhariBookInfo(id: 46, name: "Partnership", arabicName: "الشركة", hadithCount: 19, startHadith: 2259, endHadith: 2277),
  const BukhariBookInfo(id: 47, name: "Mortgaging", arabicName: "الرهن", hadithCount: 10, startHadith: 2278, endHadith: 2287),
  const BukhariBookInfo(id: 48, name: "Freeing Slaves", arabicName: "العتق", hadithCount: 24, startHadith: 2288, endHadith: 2311),
  const BukhariBookInfo(id: 49, name: "Manumission of Slaves", arabicName: "المكاتب", hadithCount: 10, startHadith: 2312, endHadith: 2321),
  const BukhariBookInfo(id: 50, name: "Gifts", arabicName: "الهبة", hadithCount: 61, startHadith: 2322, endHadith: 2382),
  const BukhariBookInfo(id: 51, name: "Witnesses", arabicName: "الشهادات", hadithCount: 55, startHadith: 2383, endHadith: 2437),
  const BukhariBookInfo(id: 52, name: "Peacemaking", arabicName: "الصلح", hadithCount: 17, startHadith: 2438, endHadith: 2454),
  const BukhariBookInfo(id: 53, name: "Conditions", arabicName: "الشروط", hadithCount: 20, startHadith: 2455, endHadith: 2474),
  const BukhariBookInfo(id: 54, name: "Wills and Testaments", arabicName: "الوصايا", hadithCount: 43, startHadith: 2475, endHadith: 2517),
  const BukhariBookInfo(id: 55, name: "Jihaad", arabicName: "الجهاد والسير", hadithCount: 310, startHadith: 2518, endHadith: 2827),
  const BukhariBookInfo(id: 56, name: "One-fifth of War Booty", arabicName: "فرض الخمس", hadithCount: 40, startHadith: 2828, endHadith: 2867),
  const BukhariBookInfo(id: 57, name: "Jizyah and Mawaada'ah", arabicName: "الجزية والموادعة", hadithCount: 23, startHadith: 2868, endHadith: 2890),
  const BukhariBookInfo(id: 58, name: "Beginning of Creation", arabicName: "بدء الخلق", hadithCount: 110, startHadith: 2891, endHadith: 3000),
  const BukhariBookInfo(id: 59, name: "Prophets", arabicName: "أحاديث الأنبياء", hadithCount: 171, startHadith: 3001, endHadith: 3171),
  const BukhariBookInfo(id: 60, name: "Virtues and Merits of Prophet", arabicName: "المناقب", hadithCount: 294, startHadith: 3172, endHadith: 3465),
  const BukhariBookInfo(id: 61, name: "Companions of the Prophet", arabicName: "فضائل الصحابة", hadithCount: 274, startHadith: 3466, endHadith: 3739),
  const BukhariBookInfo(id: 62, name: "Merits of Al-Ansar", arabicName: "مناقب الأنصار", hadithCount: 264, startHadith: 3740, endHadith: 4003),
  const BukhariBookInfo(id: 63, name: "Military Expeditions", arabicName: "المغازي", hadithCount: 459, startHadith: 4004, endHadith: 4462),
  const BukhariBookInfo(id: 64, name: "Tafsir of the Prophet", arabicName: "التفسير", hadithCount: 558, startHadith: 4463, endHadith: 5020),
  const BukhariBookInfo(id: 65, name: "Virtues of the Quran", arabicName: "فضائل القرآن", hadithCount: 86, startHadith: 5021, endHadith: 5106),
  const BukhariBookInfo(id: 66, name: "Marriage", arabicName: "النكاح", hadithCount: 188, startHadith: 5107, endHadith: 5294),
  const BukhariBookInfo(id: 67, name: "Divorce", arabicName: "الطلاق", hadithCount: 71, startHadith: 5295, endHadith: 5365),
  const BukhariBookInfo(id: 68, name: "Supporting the Family", arabicName: "النفقات", hadithCount: 27, startHadith: 5366, endHadith: 5392),
  const BukhariBookInfo(id: 69, name: "Food and Meals", arabicName: "الأطعمة", hadithCount: 80, startHadith: 5393, endHadith: 5472),
  const BukhariBookInfo(id: 70, name: "Sacrifice on Birth (Aqiqa)", arabicName: "العقيقة", hadithCount: 4, startHadith: 5473, endHadith: 5476),
  const BukhariBookInfo(id: 71, name: "Slaughtering and Hunting", arabicName: "الذبائح والصيد", hadithCount: 78, startHadith: 5477, endHadith: 5554),
  const BukhariBookInfo(id: 72, name: "Al-Adha Festival Sacrifice", arabicName: "الأضاحي", hadithCount: 19, startHadith: 5555, endHadith: 5573),
  const BukhariBookInfo(id: 73, name: "Drinks", arabicName: "الأشربة", hadithCount: 77, startHadith: 5574, endHadith: 5650),
  const BukhariBookInfo(id: 74, name: "Patients", arabicName: "المرضى", hadithCount: 30, startHadith: 5651, endHadith: 5680),
  const BukhariBookInfo(id: 75, name: "Medicine", arabicName: "الطب", hadithCount: 96, startHadith: 5681, endHadith: 5776),
  const BukhariBookInfo(id: 76, name: "Dress", arabicName: "اللباس", hadithCount: 136, startHadith: 5777, endHadith: 5912),
  const BukhariBookInfo(id: 77, name: "Good Manners (Adab)", arabicName: "الأدب", hadithCount: 253, startHadith: 5913, endHadith: 6165),
  const BukhariBookInfo(id: 78, name: "Asking Permission", arabicName: "الاستئذان", hadithCount: 62, startHadith: 6166, endHadith: 6227),
  const BukhariBookInfo(id: 79, name: "Supplications", arabicName: "الدعوات", hadithCount: 104, startHadith: 6228, endHadith: 6331),
  const BukhariBookInfo(id: 80, name: "Heart Softening (Riqaq)", arabicName: "الرقاق", hadithCount: 124, startHadith: 6332, endHadith: 6455),
  const BukhariBookInfo(id: 81, name: "Divine Will (Qadar)", arabicName: "القدر", hadithCount: 28, startHadith: 6456, endHadith: 6483),
  const BukhariBookInfo(id: 82, name: "Oaths and Vows", arabicName: "الأيمان والنذور", hadithCount: 87, startHadith: 6484, endHadith: 6570),
  const BukhariBookInfo(id: 83, name: "Expiation for Unfulfilled Oaths", arabicName: "كفارات الأيمان", hadithCount: 19, startHadith: 6571, endHadith: 6589),
  const BukhariBookInfo(id: 84, name: "Inheritance Laws", arabicName: "الفرائض", hadithCount: 31, startHadith: 6590, endHadith: 6620),
  const BukhariBookInfo(id: 85, name: "Punishment (Hudud)", arabicName: "الحدود", hadithCount: 60, startHadith: 6621, endHadith: 6680),
  const BukhariBookInfo(id: 86, name: "Blood Money (Diyat)", arabicName: "الديات", hadithCount: 37, startHadith: 6681, endHadith: 6717),
  const BukhariBookInfo(id: 87, name: "Dealing with Apostates", arabicName: "استتابة المرتدين", hadithCount: 16, startHadith: 6718, endHadith: 6733),
  const BukhariBookInfo(id: 88, name: "Compulsion", arabicName: "الإكراه", hadithCount: 9, startHadith: 6734, endHadith: 6742),
  const BukhariBookInfo(id: 89, name: "Tricks", arabicName: "الحيل", hadithCount: 24, startHadith: 6743, endHadith: 6766),
  const BukhariBookInfo(id: 90, name: "Dream Interpretation", arabicName: "التعبير", hadithCount: 48, startHadith: 6767, endHadith: 6814),
  const BukhariBookInfo(id: 91, name: "Afflictions and End of World", arabicName: "الفتن", hadithCount: 92, startHadith: 6815, endHadith: 6906),
  const BukhariBookInfo(id: 92, name: "Judgments (Ahkam)", arabicName: "الأحكام", hadithCount: 70, startHadith: 6907, endHadith: 6976),
  const BukhariBookInfo(id: 93, name: "Wishes", arabicName: "التمني", hadithCount: 20, startHadith: 6977, endHadith: 6996),
  const BukhariBookInfo(id: 94, name: "Accepting Single Report", arabicName: "أخبار الآحاد", hadithCount: 14, startHadith: 6997, endHadith: 7010),
  const BukhariBookInfo(id: 95, name: "Holding onto Quran and Sunnah", arabicName: "الاعتصام بالكتاب", hadithCount: 52, startHadith: 7011, endHadith: 7062),
  const BukhariBookInfo(id: 96, name: "Oneness of Allah (Tawheed)", arabicName: "التوحيد", hadithCount: 145, startHadith: 7063, endHadith: 7207),
];
