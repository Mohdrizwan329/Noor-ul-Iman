import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/language_provider.dart';
import '../../data/models/dua_model.dart';
import '../../widgets/common/search_bar_widget.dart';

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

  // Helper method to get language name
  String _getLanguageName(BuildContext context, DuaLanguage language) {
    switch (language) {
      case DuaLanguage.hindi:
        return context.tr('hindi');
      case DuaLanguage.urdu:
        return context.tr('urdu');
      case DuaLanguage.arabic:
        return context.tr('arabic');
      case DuaLanguage.english:
        return context.tr('english');
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
        return dua.titleUrdu ?? dua.title; // Arabic users will see Urdu or English title
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              showTranslation
                  ? context.tr('no_translation_for_audio')
                  : context.tr('no_arabic_text'),
            ),
          ),
        );
      }
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
    final text =
        '''
${dua.arabic}
${dua.transliteration}
$translation
— ${dua.getReference(selectedLanguage)}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('copied'))));
  }

  void _shareDua(DuaModel dua, DuaLanguage selectedLanguage) {
    final shareText =
        '''
${_getDuaTitle(dua, selectedLanguage)}

${dua.getTranslation(selectedLanguage)}

${context.tr('reference')}: ${dua.getReference(selectedLanguage)}

- ${context.tr('shared_from_app')}
''';
    Share.share(shareText);
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
            fontFamily: selectedLanguage == DuaLanguage.urdu
                ? 'NotoNastaliq'
                : selectedLanguage == DuaLanguage.arabic
                    ? 'Amiri'
                    : null,
          ),
          textDirection: (selectedLanguage == DuaLanguage.urdu ||
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

    return Container(
      key: _cardKeys[cardIndex],
      margin: responsive.paddingOnly(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying
              ? AppColors.primaryLight
              : AppColors.lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : AppColors.lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: responsive.spacing(40),
                      height: responsive.spacing(40),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: responsive.spacing(6),
                            offset: Offset(0, responsive.spacing(2)),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title based on selected language
                          Text(
                            _getDuaTitle(dua, selectedLanguage),
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderActionButton(
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
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyDua(dua, selectedLanguage),
                      isActive: false,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareDua(dua, selectedLanguage),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (isPlaying && !showTranslation) {
                _stopPlaying();
              } else if (!showTranslation) {
                _playDua(dua, cardIndex, false, selectedLanguage);
              }
            },
            child: Container(
              margin: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
              padding: responsive.paddingAll(12),
              decoration: (isPlaying && !showTranslation)
                  ? BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
                      ),
                    )
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPlaying && !showTranslation)
                    Padding(
                      padding: EdgeInsets.only(
                        right: responsive.spaceSmall,
                        top: responsive.spaceSmall,
                      ),
                      child: Icon(
                        Icons.volume_up,
                        size: responsive.iconSmall,
                        color: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      dua.arabic,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: responsive.fontSize(26),
                        height: 2.0,
                        color: (isPlaying && !showTranslation)
                            ? AppColors.primary
                            : AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showTranslation)
            GestureDetector(
              onTap: () {
                if (isPlaying && showTranslation) {
                  _stopPlaying();
                } else {
                  _playDua(dua, cardIndex, true, selectedLanguage);
                }
              },
              child: Container(
                margin: responsive.paddingSymmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                padding: responsive.paddingAll(12),
                decoration: BoxDecoration(
                  color: (isPlaying && showTranslation)
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlaying && showTranslation)
                      Padding(
                        padding: EdgeInsets.only(
                          right: responsive.spaceSmall,
                          top: responsive.spaceXSmall,
                        ),
                        child: Icon(
                          Icons.volume_up,
                          size: responsive.iconSmall,
                          color: AppColors.primary,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate,
                                size: responsive.iconSmall,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: responsive.spaceSmall),
                              Text(
                                '${context.tr('translation')} (${_getLanguageName(context, selectedLanguage)})',
                                style: TextStyle(
                                  fontSize: responsive.textSmall,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsive.spaceMedium),
                          Text(
                            dua.getTranslation(selectedLanguage),
                            style: TextStyle(
                              fontSize: responsive.textMedium,
                              height: 1.6,
                              color: (isPlaying && showTranslation)
                                  ? AppColors.primary
                                  : Colors.black87,
                              fontFamily: selectedLanguage == DuaLanguage.arabic
                                  ? 'Amiri'
                                  : null,
                            ),
                            textDirection: (selectedLanguage == DuaLanguage.urdu ||
                                           selectedLanguage == DuaLanguage.arabic)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: responsive.paddingAll(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(responsive.radiusLarge),
                bottomRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Text(
              dua.getReference(selectedLanguage),
              style: TextStyle(
                fontSize: responsive.textXSmall,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final responsive = context.responsive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : AppColors.lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.radiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: responsive.iconSize(22),
                color: isActive ? Colors.white : AppColors.primary,
              ),
              SizedBox(height: responsive.spaceXSmall),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive ? Colors.white : AppColors.primary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
