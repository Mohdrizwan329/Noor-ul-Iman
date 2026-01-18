import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/quran_provider.dart';
import '../../data/models/surah_model.dart';
import 'juz_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Para'),
        actions: [
          // Language Selector Button
          Consumer<QuranProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<QuranLanguage>(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    QuranProvider.languageNames[provider.selectedLanguage]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                onSelected: (QuranLanguage language) {
                  provider.setLanguage(language);
                },
                itemBuilder: (context) => QuranLanguage.values.map((language) {
                  final isSelected = provider.selectedLanguage == language;
                  return PopupMenuItem<QuranLanguage>(
                    value: language,
                    child: Row(
                      children: [
                        if (isSelected)
                          Icon(Icons.check, color: AppColors.primary, size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(
                          QuranProvider.languageNames[language]!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
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
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.surahList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.error != null && provider.surahList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchSurahList(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Para List
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.juzList.length,
            itemBuilder: (context, index) {
              return _buildJuzCard(context, provider.juzList[index], provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildJuzCard(
    BuildContext context,
    JuzInfo juz,
    QuranProvider provider,
  ) {
    const softGold = Color(0xFFC9A24D);

    // Get surah names for start and end
    String startSurahName = '';
    String endSurahName = '';
    if (provider.surahList.isNotEmpty) {
      final startSurah = provider.surahList.firstWhere(
        (s) => s.number == juz.startSurah,
        orElse: () => provider.surahList.first,
      );
      final endSurah = provider.surahList.firstWhere(
        (s) => s.number == juz.endSurah,
        orElse: () => provider.surahList.first,
      );
      startSurahName = startSurah.englishName;
      endSurahName = endSurah.englishName;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
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
              builder: (context) => JuzDetailScreen(juzNumber: juz.number),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Juz Number
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${juz.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Juz Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Para ${juz.number}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$startSurahName ${juz.startAyah} - $endSurahName ${juz.endAyah}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7F73),
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
                    juz.arabicName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'Amiri',
                      color: softGold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
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
}
