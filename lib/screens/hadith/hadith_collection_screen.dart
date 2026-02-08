import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/hadith_model.dart';
import '../../data/models/firestore_models.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';

class HadithCollectionScreen extends StatefulWidget {
  final HadithCollection collection;

  const HadithCollectionScreen({super.key, required this.collection});

  @override
  State<HadithCollectionScreen> createState() => _HadithCollectionScreenState();
}

class _HadithCollectionScreenState extends State<HadithCollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int? _selectedChapter;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  // Track which cards have translation visible
  final Set<int> _cardsWithTranslation = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hadithProvider = context.read<HadithProvider>();
      final languageProvider = context.read<LanguageProvider>();

      // Sync hadith language with app language
      hadithProvider.syncWithAppLanguage(languageProvider.languageCode);

      hadithProvider.fetchChapters(widget.collection);
      hadithProvider.fetchAllHadiths(widget.collection, page: 1);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _selectedChapter != null) return;

    setState(() => _isLoadingMore = true);
    _currentPage++;
    await context.read<HadithProvider>().fetchAllHadiths(
      widget.collection,
      page: _currentPage,
    );
    setState(() => _isLoadingMore = false);
  }

  void _onChapterSelected(int? chapter) {
    setState(() {
      _selectedChapter = chapter;
      _currentPage = 1;
    });

    final provider = context.read<HadithProvider>();
    if (chapter != null) {
      provider.fetchChapterHadiths(widget.collection, chapter);
    } else {
      provider.fetchAllHadiths(widget.collection, page: 1);
    }
  }

  void _toggleCardTranslation(int cardIndex) {
    setState(() {
      if (_cardsWithTranslation.contains(cardIndex)) {
        _cardsWithTranslation.remove(cardIndex);
      } else {
        _cardsWithTranslation.add(cardIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hadithProvider = context.watch<HadithProvider>();
    final info = hadithProvider.getCollectionInfo(widget.collection);
    final langCode = context.watch<LanguageProvider>().languageCode;
    final settings = context.watch<SettingsProvider>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info?.name.get(langCode) ?? widget.collection.name,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              info?.arabicName ?? '',
              style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
            ),
          ],
        ),
        actions: [
          if (info != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showBookInfo(context, info, langCode),
          ),
        ],
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF8AAF9A),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A5C36).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: context.tr('search_hadith_hint'),
                      hintStyle: TextStyle(color: AppColors.textHint),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF0A5C36),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // Chapter Filter
              if (provider.chapters.isNotEmpty)
                SizedBox(
                  height: responsive.spacing(50),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: provider.chapters.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(context.tr('all')),
                            selected: _selectedChapter == null,
                            onSelected: (selected) => _onChapterSelected(null),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _selectedChapter == null
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        );
                      }
                      final chapter = provider.chapters[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            chapter.name.length > 20
                                ? '${chapter.name.substring(0, 20)}...'
                                : chapter.name,
                          ),
                          selected: _selectedChapter == chapter.id,
                          onSelected: (selected) =>
                              _onChapterSelected(selected ? chapter.id : null),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _selectedChapter == chapter.id
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Hadith Count
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getFilteredHadiths(provider).length} ${context.tr('hadiths')}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hadith List
              Expanded(child: _buildHadithList(provider, settings)),
              const BannerAdWidget(),
            ],
          );
        },
      ),
    );
  }

  List<HadithModel> _getFilteredHadiths(HadithProvider provider) {
    if (_searchQuery.isEmpty) return provider.currentHadiths;
    return provider.searchHadiths(_searchQuery);
  }

  Widget _buildHadithList(HadithProvider provider, SettingsProvider settings) {
    if (provider.isLoading && provider.currentHadiths.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.error != null && provider.currentHadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(provider.error ?? context.tr('failed_to_load_hadiths')),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_selectedChapter != null) {
                  provider.fetchChapterHadiths(
                    widget.collection,
                    _selectedChapter!,
                  );
                } else {
                  provider.fetchAllHadiths(widget.collection, page: 1);
                }
              },
              child: Text(context.tr('retry')),
            ),
          ],
        ),
      );
    }

    final hadiths = _getFilteredHadiths(provider);

    if (hadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(context.tr('no_hadiths_found')),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: AdListHelper.totalCount(hadiths.length) + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        final totalWithAds = AdListHelper.totalCount(hadiths.length);
        if (index >= totalWithAds) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (AdListHelper.isAdPosition(index)) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: BannerAdWidget(height: 250),
          );
        }
        final dataIdx = AdListHelper.dataIndex(index);

        return _buildHadithCard(
          hadiths[dataIdx],
          provider,
          settings.arabicFontSize,
          settings.translationFontSize,
          index,
        );
      },
    );
  }

  Widget _buildHadithCard(
    HadithModel hadith,
    HadithProvider provider,
    double arabicFontSize,
    double translationFontSize,
    int cardIndex,
  ) {
    final responsive = context.responsive;
    final showTranslation = _cardsWithTranslation.contains(cardIndex);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
            child: Row(
              children: [
                // Hadith number badge
                Container(
                  width: responsive.spacing(40),
                  height: responsive.spacing(40),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '#${hadith.hadithNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hadith.narrator.isNotEmpty)
                        Text(
                          '${context.tr('narrated_by')} ${hadith.narrator}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (hadith.grade.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getGradeColor(hadith.grade),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _translateGrade(hadith.grade),
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
                // Action buttons
                _buildActionButton(
                  icon: Icons.translate,
                  onTap: () => _toggleCardTranslation(cardIndex),
                  isActive: showTranslation,
                ),

                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.copy,
                  onTap: () => _copyHadith(hadith),
                  isActive: false,
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.share,
                  onTap: () => _shareHadith(hadith),
                  isActive: false,
                ),
              ],
            ),
          ),

          // Arabic Text
          if (hadith.arabic.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                hadith.arabic,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: arabicFontSize,
                  height: 2.0,
                  color: AppColors.arabicText,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),

          // Translation (if visible)
          if (showTranslation)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Show translation based on current language
                  Builder(
                    builder: (context) {
                      final langCode = context
                          .watch<LanguageProvider>()
                          .languageCode;
                      final isRtl = langCode == 'ur' || langCode == 'ar';
                      String translationText = '';

                      switch (langCode) {
                        case 'ur':
                          translationText = hadith.urdu.isNotEmpty
                              ? hadith.urdu
                              : hadith.english;
                          break;
                        case 'hi':
                          translationText = hadith.hindi.isNotEmpty
                              ? hadith.hindi
                              : hadith.english;
                          break;
                        case 'ar':
                          translationText = hadith.arabic;
                          break;
                        default:
                          translationText = hadith.english;
                      }

                      if (translationText.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Text(
                        translationText,
                        style: TextStyle(
                          fontSize: translationFontSize,
                          height: 1.5,
                          color: Colors.black87,
                          fontFamily: 'Poppins',
                        ),
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      );
                    },
                  ),
                  if (hadith.reference.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      '— ${_translateReference(hadith.reference)}',
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

          // Always show translation button hint at bottom if not expanded
          if (!showTranslation && hadith.arabic.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: TextButton.icon(
                  onPressed: () => _toggleCardTranslation(cardIndex),
                  icon: Icon(
                    Icons.translate,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    context.tr('show_translation'),
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final responsive = context.responsive;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: responsive.spacing(32),
        height: responsive.spacing(32),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isActive ? AppColors.primary : Colors.grey.shade600,
        ),
      ),
    );
  }

  void _copyHadith(HadithModel hadith) {
    final langCode = context.read<LanguageProvider>().languageCode;
    String translationText = '';

    switch (langCode) {
      case 'ur':
        translationText = hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
        break;
      case 'hi':
        translationText = hadith.hindi.isNotEmpty
            ? hadith.hindi
            : hadith.english;
        break;
      case 'ar':
        translationText = hadith.arabic;
        break;
      default:
        translationText = hadith.english;
    }

    final text =
        '${hadith.arabic}\n\n$translationText\n\n— ${_translateReference(hadith.reference)}\n\n- ${context.tr('from_app')}';
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareHadith(HadithModel hadith) {
    final langCode = context.read<LanguageProvider>().languageCode;
    String translationText = '';

    switch (langCode) {
      case 'ur':
        translationText = hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
        break;
      case 'hi':
        translationText = hadith.hindi.isNotEmpty
            ? hadith.hindi
            : hadith.english;
        break;
      case 'ar':
        translationText = hadith.arabic;
        break;
      default:
        translationText = hadith.english;
    }

    final text =
        '${hadith.arabic}\n\n$translationText\n\n— ${_translateReference(hadith.reference)}\n\n- ${context.tr('shared_from_app')}';
    Share.share(text);
  }

  Color _getGradeColor(String grade) {
    final lowerGrade = grade.toLowerCase();
    if (lowerGrade.contains('sahih')) {
      return AppColors.success;
    } else if (lowerGrade.contains('hasan')) {
      return Colors.orange;
    } else if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) {
      return Colors.red;
    }
    return AppColors.textSecondary;
  }

  String _translateGrade(String grade) {
    final lowerGrade = grade.toLowerCase();
    if (lowerGrade.contains('sahih')) {
      return context.tr('sahih');
    } else if (lowerGrade.contains('hasan')) {
      return context.tr('hasan');
    } else if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) {
      return context.tr('daif');
    }
    return grade;
  }

  String _translateReference(String reference) {
    // Reference format: "Collection Name, Book X, Hadith Y"
    // Translate "Book" and "Hadith" to current language
    return reference
        .replaceAll('Book ', '${context.tr('book')} ')
        .replaceAll('Hadith ', '${context.tr('hadith')} ');
  }

  void _showBookInfo(
      BuildContext context, HadithCollectionInfoFirestore info, String langCode) {
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
                  child: Icon(
                    Icons.menu_book,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name.get(langCode),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        info.arabicName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${context.tr('compiled_by')}: ${info.compiler.get(langCode)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(info.description.get(langCode), style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.book,
                  label: '${info.totalBooks} ${context.tr('books')}',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.format_list_numbered,
                  label: '${info.totalHadith} ${context.tr('hadiths')}',
                ),
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
          Text(
            label,
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
