import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/hadith_reference_translator.dart';
import '../../data/models/hadith_model.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final ContentService _contentService = ContentService();
  final Map<String, List<HadithModel>> _loadedHadiths = {};
  String _selectedBook = 'sahih_bukhari';

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    final collections = {
      'bukhari': 'sahih_bukhari',
      'muslim': 'sahih_muslim',
      'abudawud': 'sunan_abu_dawud',
      'tirmidhi': 'jami_tirmidhi',
    };

    for (final entry in collections.entries) {
      final firestoreKey = entry.key;
      final bookKey = entry.value;

      try {
        final sampleHadiths =
            await _contentService.getSampleHadiths(firestoreKey);

        final hadithModels = sampleHadiths
            .map((sample) => HadithModel(
                  id: sample.id,
                  hadithNumber: sample.hadithNumber,
                  arabic: sample.arabic,
                  english: sample.english,
                  urdu: sample.urdu,
                  hindi: sample.hindi,
                  narrator: sample.narrator,
                  grade: sample.grade,
                  reference: sample.reference,
                ))
            .toList();

        if (mounted) {
          setState(() {
            _loadedHadiths[bookKey] = hadithModels;
          });
        }
      } catch (e) {
        // Silently fail and use hardcoded fallback
        debugPrint('Failed to load hadiths for $firestoreKey: $e');
      }
    }
  }


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
          const BannerAdWidget(),
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
    return _loadedHadiths[book] ?? [];
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
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
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
                      fontFamily: 'Poppins',
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

