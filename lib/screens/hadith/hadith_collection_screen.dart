import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/hadith_model.dart';

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
      final provider = context.read<HadithProvider>();
      provider.fetchChapters(widget.collection);
      provider.fetchAllHadiths(widget.collection, page: 1);
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
    final info = HadithProvider.collectionInfo[widget.collection]!;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: const TextStyle(fontSize: 18)),
            Text(
              info.arabicName,
              style: const TextStyle(fontSize: 12, fontFamily: 'Amiri'),
            ),
          ],
        ),
        actions: [
          // Language Selector
          Consumer<HadithProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<HadithLanguage>(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    HadithProvider.languageNames[provider.selectedLanguage]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                onSelected: (HadithLanguage language) {
                  provider.setLanguage(language);
                },
                itemBuilder: (context) => HadithLanguage.values.map((language) {
                  final isSelected = provider.selectedLanguage == language;
                  return PopupMenuItem<HadithLanguage>(
                    value: language,
                    child: Row(
                      children: [
                        if (isSelected)
                          Icon(Icons.check, color: AppColors.primary, size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(
                          HadithProvider.languageNames[language]!,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showBookInfo(context, info),
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
                      hintText: 'Search hadith...',
                      hintStyle: TextStyle(color: AppColors.textHint),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0A5C36)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),

              // Chapter Filter
              if (provider.chapters.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: provider.chapters.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: const Text('All'),
                            selected: _selectedChapter == null,
                            onSelected: (selected) => _onChapterSelected(null),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _selectedChapter == null ? Colors.white : AppColors.textPrimary,
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
                          onSelected: (selected) => _onChapterSelected(selected ? chapter.id : null),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _selectedChapter == chapter.id ? Colors.white : AppColors.textPrimary,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getFilteredHadiths(provider).length} Hadiths',
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
              Expanded(
                child: _buildHadithList(provider, settings),
              ),
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
            Text(provider.error ?? 'Failed to load hadiths'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_selectedChapter != null) {
                  provider.fetchChapterHadiths(widget.collection, _selectedChapter!);
                } else {
                  provider.fetchAllHadiths(widget.collection, page: 1);
                }
              },
              child: const Text('Retry'),
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
            const Text('No hadiths found'),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: hadiths.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= hadiths.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return _buildHadithCard(
          hadiths[index],
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

    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final isFav = provider.isFavorite(widget.collection, hadith.hadithNumber);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
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
                  width: 40,
                  height: 40,
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
                          hadith.narrator,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                // Action buttons
                _buildActionButton(
                  icon: Icons.translate,
                  onTap: () => _toggleCardTranslation(cardIndex),
                  isActive: showTranslation,
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: isFav ? Icons.favorite : Icons.favorite_border,
                  onTap: () => provider.toggleFavorite(widget.collection, hadith.hadithNumber),
                  isActive: isFav,
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
                  fontFamily: 'Amiri',
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
                  if (hadith.english.isNotEmpty) ...[
                    Text(
                      hadith.english,
                      style: TextStyle(
                        fontSize: translationFontSize,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  if (hadith.urdu.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      hadith.urdu,
                      style: TextStyle(
                        fontSize: translationFontSize,
                        height: 1.5,
                        color: Colors.black87,
                        fontFamily: 'Amiri',
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
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

          // Always show translation button hint at bottom if not expanded
          if (!showTranslation && hadith.arabic.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: TextButton.icon(
                  onPressed: () => _toggleCardTranslation(cardIndex),
                  icon: Icon(Icons.translate, size: 16, color: AppColors.primary),
                  label: Text(
                    'Show Translation',
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
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
    final text = '${hadith.arabic}\n\n${hadith.english}\n\n— ${hadith.reference}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _shareHadith(HadithModel hadith) {
    final text = '${hadith.arabic}\n\n${hadith.english}\n\n— ${hadith.reference}';
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
