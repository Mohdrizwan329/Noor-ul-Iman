import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import 'hadith_book_detail_screen.dart';
import 'bukhari_viewer_screen.dart';
import 'muslim_viewer_screen.dart';
import 'nasai_viewer_screen.dart';
import 'abudawud_viewer_screen.dart';
import 'tirmidhi_viewer_screen.dart';

class HadithBooksScreen extends StatefulWidget {
  final HadithCollection collection;
  final String collectionKey;
  final String titleKey;

  const HadithBooksScreen({
    super.key,
    required this.collection,
    required this.collectionKey,
    required this.titleKey,
  });

  @override
  State<HadithBooksScreen> createState() => _HadithBooksScreenState();
}

class _HadithBooksScreenState extends State<HadithBooksScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ContentService _contentService = ContentService();
  List<HadithBookFirestore> _allBooks = [];
  bool _isLoadingBooks = true;
  late TabController _tabController;

  // Show Mushaf tab for Bukhari, Muslim, Nasai, and Abu Dawud collections
  bool get _showMushafTab =>
      widget.collectionKey == 'bukhari' ||
      widget.collectionKey == 'muslim' ||
      widget.collectionKey == 'nasai' ||
      widget.collectionKey == 'abudawud' ||
      widget.collectionKey == 'tirmidhi';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _showMushafTab ? 2 : 1,
      vsync: this,
    );
    _loadBooksFromFirestore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hadithProvider = context.read<HadithProvider>();
      final languageProvider = context.read<LanguageProvider>();
      hadithProvider.syncWithAppLanguage(languageProvider.languageCode);
      hadithProvider.initialize();
    });
  }

  Future<void> _loadBooksFromFirestore() async {
    try {
      final collection =
          await _contentService.getHadithCollection(widget.collectionKey);
      if (collection != null && collection.books.isNotEmpty) {
        _allBooks = collection.books;
      }
    } catch (e) {
      debugPrint(
          'Error loading ${widget.collectionKey} books from Firestore: $e');
    }
    if (mounted) setState(() => _isLoadingBooks = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<HadithBookFirestore> _getFilteredBooks() {
    if (_searchQuery.isEmpty) {
      return _allBooks;
    }
    final query = _searchQuery.toLowerCase();
    return _allBooks.where((book) {
      return book.name.en.toLowerCase().contains(query) ||
          book.name.ur.contains(query) ||
          book.name.hi.contains(query) ||
          book.arabicName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr(widget.titleKey),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
        bottom: _showMushafTab
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontSize: responsive.fontSize(14),
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: responsive.fontSize(14),
                ),
                tabs: [
                  Tab(text: context.tr(widget.titleKey)),
                  Tab(text: context.tr('mushaf')),
                ],
              )
            : null,
      ),
      body: _showMushafTab
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildBooksTab(responsive),
                _buildMushafTab(responsive),
              ],
            )
          : _buildBooksTab(responsive),
    );
  }

  Widget _buildBooksTab(ResponsiveUtils responsive) {
    final filteredBooks = _getFilteredBooks();

    return Column(
      children: [
        if (_isLoadingBooks) const LinearProgressIndicator(),
        Padding(
          padding: responsive.paddingAll(16),
          child: SearchBarWidget(
            controller: _searchController,
            hintText: context.tr('search_books'),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ),
        Expanded(
          child: Consumer2<HadithProvider, LanguageProvider>(
            builder: (context, provider, langProvider, child) {
              if (_isLoadingBooks) {
                return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return filteredBooks.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('no_books_found'),
                        style: TextStyle(
                          fontSize: responsive.textMedium,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: responsive.paddingSymmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      itemCount:
                          AdListHelper.totalCount(filteredBooks.length),
                      itemBuilder: (context, index) {
                        if (AdListHelper.isAdPosition(index)) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: BannerAdWidget(height: 250),
                          );
                        }
                        final dataIdx = AdListHelper.dataIndex(index);
                        final book = filteredBooks[dataIdx];
                        final originalIndex =
                            _allBooks.indexOf(book) + 1;
                        return _buildBookCard(
                            context, book, originalIndex);
                      },
                    );
            },
          ),
        ),
        const BannerAdWidget(),
      ],
    );
  }

  Widget _buildMushafTab(ResponsiveUtils responsive) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    final collectionKey = widget.collectionKey;
    final volumeCount = 10;
    final titleKey = collectionKey == 'bukhari'
        ? 'sahih_bukhari'
        : collectionKey == 'muslim'
            ? 'sahih_muslim'
            : collectionKey == 'nasai'
                ? 'sunan_nasai'
                : collectionKey == 'abudawud'
                    ? 'sunan_abu_dawud'
                    : 'jami_tirmidhi';

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
      padding: responsive.paddingRegular,
      itemCount: AdListHelper.totalCount(volumeCount),
      itemBuilder: (context, index) {
        if (AdListHelper.isAdPosition(index)) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: BannerAdWidget(height: 250),
          );
        }
        final dataIdx = AdListHelper.dataIndex(index);
        final volumeNumber = dataIdx + 1;

        return Container(
          margin: responsive.paddingOnly(bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            border: Border.all(color: lightGreenBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: darkGreen.withValues(alpha: 0.08),
                blurRadius: responsive.spacing(10),
                offset: Offset(0, responsive.spacing(2)),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => collectionKey == 'bukhari'
                      ? BukhariViewerScreen(volumeNumber: volumeNumber)
                      : collectionKey == 'muslim'
                          ? MuslimViewerScreen(volumeNumber: volumeNumber)
                          : collectionKey == 'nasai'
                              ? NasaiViewerScreen(volumeNumber: volumeNumber)
                              : collectionKey == 'abudawud'
                                  ? AbuDawudViewerScreen(volumeNumber: volumeNumber)
                                  : TirmidhiViewerScreen(volumeNumber: volumeNumber),
                ),
              );
            },
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            child: Padding(
              padding: responsive.paddingAll(14),
              child: Row(
                children: [
                  Container(
                    width: responsive.spacing(50),
                    height: responsive.spacing(50),
                    decoration: BoxDecoration(
                      color: darkGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: darkGreen.withValues(alpha: 0.3),
                          blurRadius: responsive.spacing(8),
                          offset: Offset(0, responsive.spacing(2)),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$volumeNumber',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.textLarge,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.tr('volume')} $volumeNumber',
                          style: TextStyle(
                            fontSize: responsive.textSmall,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: responsive.spacing(2)),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: responsive.fontSize(12),
                              color: emeraldGreen,
                            ),
                            SizedBox(width: responsive.spacing(4)),
                            Text(
                              context.tr(titleKey),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: responsive.paddingAll(6),
                    decoration: const BoxDecoration(
                      color: emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: responsive.iconSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
        ),
        const BannerAdWidget(),
      ],
    );
  }

  Widget _buildBookCard(
    BuildContext context,
    HadithBookFirestore book,
    int number,
  ) {
    final responsive = context.responsive;

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithBookDetailScreen(
                collection: widget.collection,
                bookNumber: book.id,
                bookName: book.name.en,
                bookArabicName: book.arabicName,
                bookUrduName: book.name.ur,
                bookHindiName: book.name.hi,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),
              Expanded(
                child: Consumer<LanguageProvider>(
                  builder: (context, langProvider, child) {
                    final langCode = langProvider.languageCode;
                    final displayName = book.name.get(langCode);
                    final textDir = (langCode == 'ar' || langCode == 'ur')
                        ? TextDirection.rtl
                        : TextDirection.ltr;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            fontSize: responsive.textSmall,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Poppins',
                            height: 1.3,
                          ),
                          textDirection: textDir,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        if (book.hadithCount > 0)
                          Padding(
                            padding: EdgeInsets.only(top: responsive.spacing(3)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: responsive.fontSize(12),
                                  color: AppColors.emeraldGreen,
                                ),
                                SizedBox(width: responsive.spacing(4)),
                                Text(
                                  '${book.hadithCount} ${context.tr('hadiths')}',
                                  style: TextStyle(
                                    fontSize: responsive.textXSmall,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(width: responsive.spacing(8)),
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: AppColors.emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
