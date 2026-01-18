import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/quran_provider.dart';
import 'surah_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Ayahs'),
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
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Bookmarks Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon on any ayah\nto save it here',
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
            padding: const EdgeInsets.all(16),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Bookmark icon with surah number
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    Text(
                      '$surahNumber:$ayahNumber',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Surah info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ayah $ayahNumber',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Arabic name
              Text(
                arabicName,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Amiri',
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 8),

              // Delete button
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[400]),
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
      builder: (context) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: Text(
          'Remove bookmark for $surahName, Ayah $ayahNumber?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.toggleBookmark(surahNumber, ayahNumber);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bookmark removed'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
