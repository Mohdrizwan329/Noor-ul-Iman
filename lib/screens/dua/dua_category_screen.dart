import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/dua_provider.dart';
import '../../data/models/dua_model.dart';
import 'dua_detail_screen.dart';

class DuaCategoryScreen extends StatefulWidget {
  const DuaCategoryScreen({super.key});

  @override
  State<DuaCategoryScreen> createState() => _DuaCategoryScreenState();
}

class _DuaCategoryScreenState extends State<DuaCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  String _searchQuery = '';

  // Audio playback state
  String? _playingCategoryId;
  bool _isSpeaking = false;

  // Language selection
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;

  static const Map<DuaLanguage, String> languageNames = {
    DuaLanguage.hindi: 'Hindi',
    DuaLanguage.english: 'English',
    DuaLanguage.urdu: 'Urdu',
  };

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DuaProvider>().loadCategories();
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingCategoryId = null;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingCategoryId = null;
        });
      }
    });
  }

  Future<void> _playDuaAudio(DuaCategory category) async {
    if (category.duas.isEmpty) return;

    // If already playing this category, stop it
    if (_playingCategoryId == category.id && _isSpeaking) {
      await _stopPlaying();
      return;
    }

    // Stop any current playback
    await _stopPlaying();

    final dua = category.duas.first;
    String textToSpeak = dua.arabic;
    String ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';

    if (textToSpeak.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Arabic text available')),
        );
      }
      return;
    }

    await _flutterTts.setLanguage(ttsLangCode);

    setState(() {
      _playingCategoryId = category.id;
      _isSpeaking = true;
    });

    await _flutterTts.speak(textToSpeak);
  }

  Future<bool> _isLanguageAvailable(String langCode) async {
    try {
      final result = await _flutterTts.isLanguageAvailable(langCode);
      return result == 1 || result == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _stopPlaying() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _playingCategoryId = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Duain'),
        actions: [
          PopupMenuButton<DuaLanguage>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                languageNames[_selectedLanguage]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onSelected: (DuaLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => DuaLanguage.values.map((language) {
              return PopupMenuItem<DuaLanguage>(
                value: language,
                child: Row(
                  children: [
                    if (_selectedLanguage == language)
                      const Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(languageNames[language]!),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Consumer<DuaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final categories = provider.categories;

          if (categories.isEmpty) {
            return const Center(child: Text('No duas available'));
          }

          // Filter categories based on search
          final filteredCategories = _searchQuery.isEmpty
              ? categories
              : categories.where((cat) {
                  if (cat.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  )) {
                    return true;
                  }
                  return cat.duas.any(
                    (dua) =>
                        dua.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        dua.transliteration.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                  );
                }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.lightGreenBorder,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search duas...',
                      hintStyle: TextStyle(color: AppColors.textHint),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // Categories List with Duas
              Expanded(
                child: filteredCategories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return _buildCategoryWithDuas(
                            context,
                            category,
                            provider,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryWithDuas(
    BuildContext context,
    DuaCategory category,
    DuaProvider provider,
  ) {
    const lightGreenChip = Color(0xFFE8F3ED);

    final categoryName = category.name
        .replaceAll(RegExp(r'[^\x00-\x7F]+'), '')
        .trim();
    final translatedName = category.getName(_selectedLanguage);
    final isPlaying = _playingCategoryId == category.id && _isSpeaking;
    final showTranslatedName = _selectedLanguage != DuaLanguage.english &&
        translatedName != categoryName;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPlaying ? AppColors.primaryLight : AppColors.lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
        ),
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
          // Open detail screen with first dua of category
          if (category.duas.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DuaDetailScreen(
                  dua: category.duas.first,
                  category: category,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
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
                    category.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    if (showTranslatedName) ...[
                      const SizedBox(height: 2),
                      Text(
                        translatedName,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: _selectedLanguage == DuaLanguage.urdu
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: lightGreenChip,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${category.duas.length} Duas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Audio Play Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _playDuaAudio(category),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isPlaying ? AppColors.primary : lightGreenChip,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.stop : Icons.volume_up,
                      size: 20,
                      color: isPlaying ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Arrow
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
