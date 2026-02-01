import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../../data/models/dua_model.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/header_action_button.dart';

class DuaDetailScreen extends StatefulWidget {
  final DuaModel dua;
  final DuaCategory category;
  const DuaDetailScreen({super.key, required this.dua, required this.category});

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};
  final FlutterTts _flutterTts = FlutterTts();
  final Set<int> _cardsWithTranslation = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _playingCardIndex;
  bool _isSpeaking = false;

  // Helper method to convert app language to DuaLanguage enum
  DuaLanguage _getSelectedLanguage(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();
    switch (langProvider.languageCode) {
      case 'hi':
        return DuaLanguage.hindi;
      case 'ur':
        return DuaLanguage.urdu;
      case 'ar':
        return DuaLanguage.arabic;
      case 'en':
      default:
        return DuaLanguage.english;
    }
  }

  // Helper method to get Dua title based on language
  String _getDuaTitle(DuaModel dua, DuaLanguage language) {
    switch (language) {
      case DuaLanguage.urdu:
        return dua.titleUrdu ?? dua.title;
      case DuaLanguage.hindi:
        return dua.titleHindi ?? dua.title;
      case DuaLanguage.arabic:
        return dua.titleUrdu ??
            dua.title; // Arabic users will see Urdu or English title
      case DuaLanguage.english:
        return dua.title;
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.category.duas.length; i++) {
      _cardKeys[i] = GlobalKey();
    }
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDua();
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
          _playingCardIndex = null;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingCardIndex = null;
        });
      }
    });
  }

  void _scrollToSelectedDua() {
    final selectedIndex = widget.category.duas.indexWhere(
      (d) => d.id == widget.dua.id,
    );
    if (selectedIndex > 0 && _cardKeys.containsKey(selectedIndex)) {
      final key = _cardKeys[selectedIndex];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  List<DuaModel> get filteredDuas {
    if (_searchQuery.isEmpty) {
      return widget.category.duas;
    }
    final query = _searchQuery.toLowerCase();
    return widget.category.duas.where((dua) {
      return dua.title.toLowerCase().contains(query) ||
          dua.arabic.contains(query) ||
          dua.transliteration.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _playDua(
    DuaModel dua,
    int cardIndex,
    bool showTranslation,
    DuaLanguage selectedLanguage,
  ) async {
    if (_playingCardIndex == cardIndex && _isSpeaking) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (showTranslation) {
      switch (selectedLanguage) {
        case DuaLanguage.english:
          textToSpeak = dua.translationEnglish ?? dua.translation;
          ttsLangCode = 'en-US';
          break;
        case DuaLanguage.urdu:
          textToSpeak = dua.translationUrdu ?? dua.translation;
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case DuaLanguage.hindi:
          textToSpeak = dua.translation;
          ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          break;
        case DuaLanguage.arabic:
          textToSpeak = dua.translationEnglish ?? dua.translation;
          ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'en-US';
          break;
      }
    } else {
      textToSpeak = dua.arabic;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {}
      return;
    }

    await _flutterTts.setLanguage(ttsLangCode);
    setState(() {
      _playingCardIndex = cardIndex;
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
      _playingCardIndex = null;
    });
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

  void _copyDua(DuaModel dua, DuaLanguage selectedLanguage) {
    final translation = dua.getTranslation(selectedLanguage);
    ActionHelpers.copyFormattedContent(
      context,
      arabicText: dua.arabic,
      translation: translation,
      reference: dua.getReference(selectedLanguage),
      title: _getDuaTitle(dua, selectedLanguage),
    );
  }

  void _shareDua(DuaModel dua, DuaLanguage selectedLanguage) {
    final translation = dua.getTranslation(selectedLanguage);
    ActionHelpers.shareFormattedContent(
      arabicText: dua.arabic,
      translation: translation,
      reference: dua.getReference(selectedLanguage),
      title: _getDuaTitle(dua, selectedLanguage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // Watch LanguageProvider to rebuild when language changes
    context.watch<LanguageProvider>();
    final selectedLanguage = _getSelectedLanguage(context);

    // Get translated category name
    String categoryDisplayName = widget.category.name
        .replaceAll(RegExp(r'[^\x00-\x7F]+'), '')
        .trim();
    final translatedCategoryName = widget.category.getName(selectedLanguage);
    if (selectedLanguage != DuaLanguage.english &&
        translatedCategoryName != categoryDisplayName) {
      categoryDisplayName = translatedCategoryName;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          categoryDisplayName,
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection:
              (selectedLanguage == DuaLanguage.urdu ||
                  selectedLanguage == DuaLanguage.arabic)
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: responsive.paddingAll(12),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_duas'),
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

          // Duas List
          Expanded(
            child: filteredDuas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: responsive.iconHuge,
                          color: Colors.grey.shade400,
                        ),
                        responsive.vSpaceRegular,
                        Text(
                          context.tr('no_duas_found'),
                          style: TextStyle(
                            fontSize: responsive.textRegular,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: responsive.paddingAll(12),
                    itemCount: filteredDuas.length,
                    itemBuilder: (context, index) {
                      final dua = filteredDuas[index];
                      // Get original index for card keys
                      final originalIndex = widget.category.duas.indexOf(dua);
                      return _buildDuaCard(dua, originalIndex);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuaCard(DuaModel dua, int cardIndex) {
    final responsive = context.responsive;
    final selectedLanguage = _getSelectedLanguage(context);
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final isPlaying = _playingCardIndex == cardIndex && _isSpeaking;
    final cardNumber = cardIndex + 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get language code from DuaLanguage enum
    String langCode;
    switch (selectedLanguage) {
      case DuaLanguage.urdu:
        langCode = 'ur';
      case DuaLanguage.hindi:
        langCode = 'hi';
      case DuaLanguage.arabic:
        langCode = 'ar';
      case DuaLanguage.english:
        langCode = 'en';
    }

    // Get translation based on selected language
    final translation = dua.getTranslation(selectedLanguage);

    // Green theme colors matching Seven Kalma screen
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      key: _cardKeys[cardIndex],
      margin: responsive.paddingOnly(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying
              ? AppColors.primaryLight
              : (isDark ? Colors.grey.shade700 : lightGreenBorder),
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: darkGreen.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with number badge, title, and action buttons
          Container(
            padding: responsive.paddingSymmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // First row: Number badge and title
                Row(
                  children: [
                    // Number badge
                    Container(
                      width: responsive.spacing(36),
                      height: responsive.spacing(36),
                      decoration: BoxDecoration(
                        color: isPlaying ? AppColors.primaryLight : darkGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$cardNumber',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.textMedium,
                          ),
                        ),
                      ),
                    ),
                    responsive.hSpaceMedium,
                    // Title
                    Expanded(
                      child: Text(
                        _getDuaTitle(dua, selectedLanguage),
                        style: TextStyle(
                          fontSize: responsive.textMedium,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : darkGreen,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Second row: Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Audio Button
                    HeaderActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying
                          ? context.tr('stop')
                          : context.tr('audio'),
                      onTap: () => _playDua(
                        dua,
                        cardIndex,
                        showTranslation,
                        selectedLanguage,
                      ),
                      isActive: isPlaying,
                      activeColor: darkGreen,
                    ),
                    // Translate Button
                    HeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                      activeColor: darkGreen,
                    ),
                    // Copy Button
                    HeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyDua(dua, selectedLanguage),
                      activeColor: darkGreen,
                    ),
                    // Share Button
                    HeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareDua(dua, selectedLanguage),
                      activeColor: darkGreen,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arabic text
          Container(
            padding: responsive.paddingAll(16),
            child: Text(
              dua.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: responsive.textXLarge,
                fontFamily: 'Scheherazade',
                height: 2.0,
                color: isDark ? Colors.white : darkGreen,
              ),
            ),
          ),

          // Translation (only visible when translate button is clicked)
          if (showTranslation)
            Container(
              padding: responsive.paddingAll(16),
              decoration: BoxDecoration(
                color: lightGreenChip.withValues(alpha: 0.5),
              ),
              child: Text(
                translation,
                textAlign: langCode == 'ur' || langCode == 'ar'
                    ? TextAlign.right
                    : TextAlign.left,
                textDirection: langCode == 'ur' || langCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  height: 1.8,
                ),
              ),
            ),

          // Reference footer
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade800.withValues(alpha: 0.3)
                  : lightGreenChip.withValues(alpha: 0.3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(responsive.radiusLarge),
                bottomRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Text(
              dua.getReference(selectedLanguage),
              style: AppTextStyles.caption(context).copyWith(
                color: isDark ? Colors.grey.shade400 : AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
