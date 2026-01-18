import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/hadith_model.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  String _selectedBook = 'Sahih Bukhari';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith Collection'),
      ),
      body: Column(
        children: [
          // Book Selector
          _buildBookSelector(),

          // Hadith List
          Expanded(
            child: _buildHadithList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSelector() {
    final books = [
      'Sahih Bukhari',
      'Sahih Muslim',
      'Sunan Abu Dawud',
      'Jami at-Tirmidhi',
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final isSelected = book == _selectedBook;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(book),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedBook = book;
                  });
                }
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHadithList() {
    final hadiths = _getHadithsForBook(_selectedBook);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hadiths.length,
      itemBuilder: (context, index) {
        return _HadithCard(hadith: hadiths[index]);
      },
    );
  }

  List<HadithModel> _getHadithsForBook(String book) {
    // Sample Hadiths - In production, this would come from local JSON or API
    switch (book) {
      case 'Sahih Bukhari':
        return _bukhariHadiths;
      case 'Sahih Muslim':
        return _muslimHadiths;
      case 'Sunan Abu Dawud':
        return _abuDawudHadiths;
      default:
        return _tirmidhiHadiths;
    }
  }
}

class _HadithCard extends StatelessWidget {
  final HadithModel hadith;

  const _HadithCard({required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#${hadith.hadithNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hadith.narrator,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hadith.grade.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getGradeColor(hadith.grade),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hadith.grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic
                if (hadith.arabic.isNotEmpty) ...[
                  Text(
                    hadith.arabic,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Amiri',
                      height: 2,
                      color: AppColors.arabicText,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                ],

                // English Translation
                Text(
                  hadith.english,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),

                // Reference
                if (hadith.reference.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '— ${hadith.reference}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: '${hadith.arabic}\n\n${hadith.english}\n\n— ${hadith.reference}',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () {
                    Share.share(
                      '${hadith.arabic}\n\n${hadith.english}\n\n— ${hadith.reference}',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'sahih':
        return AppColors.success;
      case 'hasan':
        return Colors.orange;
      case 'daif':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }
}

// Sample Hadith Data
final List<HadithModel> _bukhariHadiths = [
  HadithModel(
    id: 1,
    hadithNumber: '1',
    arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
    english: 'Actions are judged by intentions, so each man will have what he intended.',
    urdu: '',
    narrator: 'Narrated by Umar ibn Al-Khattab (RA)',
    grade: 'Sahih',
    reference: 'Sahih Bukhari, Book 1, Hadith 1',
  ),
  HadithModel(
    id: 2,
    hadithNumber: '6',
    arabic: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ',
    english: 'A Muslim is the one from whose tongue and hands the Muslims are safe.',
    urdu: '',
    narrator: 'Narrated by Abdullah ibn Amr (RA)',
    grade: 'Sahih',
    reference: 'Sahih Bukhari, Book 2, Hadith 9',
  ),
  HadithModel(
    id: 3,
    hadithNumber: '13',
    arabic: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
    english: 'None of you truly believes until he loves for his brother what he loves for himself.',
    urdu: '',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    grade: 'Sahih',
    reference: 'Sahih Bukhari, Book 2, Hadith 12',
  ),
  HadithModel(
    id: 4,
    hadithNumber: '52',
    arabic: 'الْحَلاَلُ بَيِّنٌ وَالْحَرَامُ بَيِّنٌ',
    english: 'Both legal and illegal things are evident but in between them there are doubtful things.',
    urdu: '',
    narrator: "Narrated by An-Nu'man bin Bashir (RA)",
    grade: 'Sahih',
    reference: 'Sahih Bukhari, Book 2, Hadith 45',
  ),
];

final List<HadithModel> _muslimHadiths = [
  HadithModel(
    id: 5,
    hadithNumber: '1',
    arabic: 'الإِيمَانُ أَنْ تُؤْمِنَ بِاللَّهِ وَمَلاَئِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الآخِرِ',
    english: 'Faith is to believe in Allah, His angels, His books, His messengers, and the Last Day.',
    urdu: '',
    narrator: 'Narrated by Umar ibn Al-Khattab (RA)',
    grade: 'Sahih',
    reference: 'Sahih Muslim, Book 1, Hadith 1',
  ),
  HadithModel(
    id: 6,
    hadithNumber: '45',
    arabic: 'مَنْ رَأَى مِنْكُمْ مُنْكَرًا فَلْيُغَيِّرْهُ بِيَدِهِ',
    english: 'Whoever among you sees an evil, let him change it with his hand.',
    urdu: '',
    narrator: 'Narrated by Abu Said Al-Khudri (RA)',
    grade: 'Sahih',
    reference: 'Sahih Muslim, Book 1, Hadith 78',
  ),
];

final List<HadithModel> _abuDawudHadiths = [
  HadithModel(
    id: 7,
    hadithNumber: '495',
    arabic: 'مُرُوا أَوْلاَدَكُمْ بِالصَّلاَةِ وَهُمْ أَبْنَاءُ سَبْعِ سِنِينَ',
    english: 'Command your children to pray when they become seven years old.',
    urdu: '',
    narrator: 'Narrated by Abdullah ibn Amr (RA)',
    grade: 'Hasan',
    reference: 'Sunan Abu Dawud, Book 2, Hadith 495',
  ),
];

final List<HadithModel> _tirmidhiHadiths = [
  HadithModel(
    id: 8,
    hadithNumber: '2317',
    arabic: 'إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ',
    english: 'Verily Allah does not look at your appearances or wealth, but rather He looks at your hearts and actions.',
    urdu: '',
    narrator: 'Narrated by Abu Hurairah (RA)',
    grade: 'Sahih',
    reference: 'Jami at-Tirmidhi, Book 27, Hadith 2317',
  ),
];
