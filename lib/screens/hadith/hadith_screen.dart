import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/utils/hadith_reference_translator.dart';
import '../../data/models/hadith_model.dart';
import '../../providers/language_provider.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  String _selectedBook = 'sahih_bukhari';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('hadith_collection')),
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
      'sahih_bukhari',
      'sahih_muslim',
      'sunan_abu_dawud',
      'jami_tirmidhi',
    ];

    final responsive = context.responsive;

    return Container(
      height: responsive.spacing(60),
      padding: responsive.paddingSymmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: responsive.paddingSymmetric(horizontal: 12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final isSelected = book == _selectedBook;

          return Padding(
            padding: responsive.paddingSymmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(context.tr(book)),
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
                fontSize: responsive.textMedium,
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

    final responsive = context.responsive;

    return ListView.builder(
      padding: responsive.paddingAll(16),
      itemCount: hadiths.length,
      itemBuilder: (context, index) {
        return _HadithCard(hadith: hadiths[index]);
      },
    );
  }

  List<HadithModel> _getHadithsForBook(String book) {
    // Sample Hadiths - In production, this would come from local JSON or API
    switch (book) {
      case 'sahih_bukhari':
        return _bukhariHadiths;
      case 'sahih_muslim':
        return _muslimHadiths;
      case 'sunan_abu_dawud':
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
    final responsive = context.responsive;

    return Container(
      margin: responsive.paddingOnly(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: responsive.paddingAll(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: responsive.paddingSymmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  ),
                  child: Text(
                    '#${hadith.hadithNumber}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.textSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: responsive.spaceSmall),
                Expanded(
                  child: Text(
                    hadith.narrator,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: responsive.textSmall,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hadith.grade.isNotEmpty)
                  Container(
                    padding: responsive.paddingSymmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getGradeColor(hadith.grade),
                      borderRadius: BorderRadius.circular(responsive.radiusSmall),
                    ),
                    child: Text(
                      hadith.grade,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.textXSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: responsive.paddingAll(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic
                if (hadith.arabic.isNotEmpty) ...[
                  Text(
                    hadith.arabic,
                    style: TextStyle(
                      fontSize: responsive.textLarge,
                      fontFamily: 'Amiri',
                      height: 2,
                      color: AppColors.arabicText,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: responsive.spaceRegular),
                ],

                // English Translation
                Text(
                  hadith.english,
                  style: TextStyle(
                    fontSize: responsive.textMedium,
                    height: 1.6,
                  ),
                ),

                // Reference
                if (hadith.reference.isNotEmpty) ...[
                  SizedBox(height: responsive.spaceMedium),
                  Text(
                    '— ${translateHadithReference(context, hadith.reference)}',
                    style: TextStyle(
                      fontSize: responsive.textSmall,
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
            padding: responsive.paddingSymmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.copy, size: responsive.iconSmall),
                  onPressed: () {
                    final langCode = context.read<LanguageProvider>().languageCode;
                    String translation;
                    switch (langCode) {
                      case 'ur':
                        translation = hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
                        break;
                      case 'hi':
                        translation = hadith.hindi.isNotEmpty ? hadith.hindi : hadith.english;
                        break;
                      case 'ar':
                        translation = hadith.arabic;
                        break;
                      default:
                        translation = hadith.english;
                    }
                    final translatedRef = translateHadithReference(context, hadith.reference);
                    Clipboard.setData(ClipboardData(
                      text: '${hadith.arabic}\n\n$translation\n\n— $translatedRef',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.tr('copied'))),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, size: responsive.iconSmall),
                  onPressed: () {
                    final langCode = context.read<LanguageProvider>().languageCode;
                    String translation;
                    switch (langCode) {
                      case 'ur':
                        translation = hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
                        break;
                      case 'hi':
                        translation = hadith.hindi.isNotEmpty ? hadith.hindi : hadith.english;
                        break;
                      case 'ar':
                        translation = hadith.arabic;
                        break;
                      default:
                        translation = hadith.english;
                    }
                    final translatedRef = translateHadithReference(context, hadith.reference);
                    Share.share(
                      '${hadith.arabic}\n\n$translation\n\n— $translatedRef',
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
