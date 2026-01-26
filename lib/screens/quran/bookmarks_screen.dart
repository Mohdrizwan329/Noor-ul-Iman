import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/quran_provider.dart';
import 'surah_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('bookmarked_ayahs')),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          final bookmarks = provider.bookmarks.toList();

          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: responsive.iconHuge,
                    color: Colors.grey[400],
                  ),
                  responsive.vSpaceRegular,
                  Text(
                    context.tr('no_bookmarks'),
                    style: TextStyle(
                      fontSize: responsive.textXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  responsive.vSpaceSmall,
                  Text(
                    context.tr('bookmark_hint'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort bookmarks by surah number then ayah number
          bookmarks.sort((a, b) {
            final aParts = a.split(':');
            final bParts = b.split(':');
            final surahCompare = int.parse(aParts[0]).compareTo(int.parse(bParts[0]));
            if (surahCompare != 0) return surahCompare;
            return int.parse(aParts[1]).compareTo(int.parse(bParts[1]));
          });

          return ListView.builder(
            padding: responsive.paddingRegular,
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              final parts = bookmark.split(':');
              final surahNumber = int.parse(parts[0]);
              final ayahNumber = int.parse(parts[1]);

              // Find surah info
              final surahInfo = provider.surahList.firstWhere(
                (s) => s.number == surahNumber,
                orElse: () => provider.surahList.first,
              );

              return _buildBookmarkCard(
                context,
                surahNumber,
                ayahNumber,
                surahInfo.englishName,
                surahInfo.name,
                provider,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    int surahNumber,
    int ayahNumber,
    String surahName,
    String arabicName,
    QuranProvider provider,
  ) {
    final responsive = context.responsive;

    return Card(
      margin: responsive.paddingOnly(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailScreen(surahNumber: surahNumber),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Padding(
          padding: responsive.paddingRegular,
          child: Row(
            children: [
              // Bookmark icon with surah number
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: AppColors.secondary,
                      size: responsive.iconSmall,
                    ),
                    Text(
                      '$surahNumber:$ayahNumber',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              responsive.hSpaceRegular,

              // Surah info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: TextStyle(
                        fontSize: responsive.textRegular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    responsive.vSpaceXSmall,
                    Text(
                      '${context.tr('ayah')} $ayahNumber',
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Arabic name
              Text(
                arabicName,
                style: TextStyle(
                  fontSize: responsive.textXLarge,
                  fontFamily: 'Amiri',
                  color: AppColors.primary,
                ),
              ),

              responsive.hSpaceSmall,

              // Delete button
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[400], size: responsive.iconMedium),
                onPressed: () {
                  _showDeleteConfirmation(
                    context,
                    provider,
                    surahNumber,
                    ayahNumber,
                    surahName,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    QuranProvider provider,
    int surahNumber,
    int ayahNumber,
    String surahName,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('remove_bookmark')),
        content: Text(
          dialogContext.tr('remove_bookmark_confirmation').replaceAll('{surah}', surahName).replaceAll('{ayah}', ayahNumber.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(dialogContext.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              provider.toggleBookmark(surahNumber, ayahNumber);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('bookmark_removed')),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(dialogContext.tr('remove')),
          ),
        ],
      ),
    );
  }
}
