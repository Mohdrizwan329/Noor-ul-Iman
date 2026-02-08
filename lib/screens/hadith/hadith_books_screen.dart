import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/native_ad_widget.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import 'hadith_book_detail_screen.dart';

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

class _HadithBooksScreenState extends State<HadithBooksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ContentService _contentService = ContentService();
  List<HadithBookFirestore> _allBooks = [];
  bool _isLoadingBooks = true;

  @override
  void initState() {
    super.initState();
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
    final filteredBooks = _getFilteredBooks();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr(widget.titleKey),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Column(
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
              enableVoiceSearch: true,
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
                            return const NativeAdWidget();
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
      ),
    );
  }

  Widget _buildBookCard(
    BuildContext context,
    HadithBookFirestore book,
    int number,
  ) {
    final responsive = context.responsive;

    return Container(
      margin: responsive.paddingOnly(bottom: 10),
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

                    return Text(
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
