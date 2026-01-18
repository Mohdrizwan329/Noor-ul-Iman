import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';

enum IslamicNameLanguage { english, urdu, hindi }

class IslamicNameDetailScreen extends StatefulWidget {
  final String arabicName;
  final String transliteration;
  final String meaning;
  final String meaningUrdu;
  final String meaningHindi;
  final String description;
  final String descriptionUrdu;
  final String descriptionHindi;
  final String category;
  final int number;
  final IconData icon;
  final Color color;
  final String? fatherName;
  final String? motherName;
  final String? birthDate;
  final String? birthPlace;
  final String? deathDate;
  final String? deathPlace;
  final String? spouse;
  final String? children;
  final String? knownFor;
  final String? title;
  final String? tribe;
  final String? era;

  const IslamicNameDetailScreen({
    super.key,
    required this.arabicName,
    required this.transliteration,
    required this.meaning,
    this.meaningUrdu = '',
    this.meaningHindi = '',
    required this.description,
    this.descriptionUrdu = '',
    this.descriptionHindi = '',
    required this.category,
    required this.number,
    required this.icon,
    required this.color,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.birthPlace,
    this.deathDate,
    this.deathPlace,
    this.spouse,
    this.children,
    this.knownFor,
    this.title,
    this.tribe,
    this.era,
  });

  @override
  State<IslamicNameDetailScreen> createState() => _IslamicNameDetailScreenState();
}

class _IslamicNameDetailScreenState extends State<IslamicNameDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showTranslation = false;
  bool _isPlayingArabic = false;
  IslamicNameLanguage _selectedLanguage = IslamicNameLanguage.english;

  static const Map<IslamicNameLanguage, String> languageNames = {
    IslamicNameLanguage.english: 'English',
    IslamicNameLanguage.urdu: 'اردو',
    IslamicNameLanguage.hindi: 'हिंदी',
  };

  String get _currentMeaning {
    switch (_selectedLanguage) {
      case IslamicNameLanguage.urdu:
        return widget.meaningUrdu.isNotEmpty ? widget.meaningUrdu : widget.meaning;
      case IslamicNameLanguage.hindi:
        return widget.meaningHindi.isNotEmpty ? widget.meaningHindi : widget.meaning;
      default:
        return widget.meaning;
    }
  }

  String get _currentDescription {
    switch (_selectedLanguage) {
      case IslamicNameLanguage.urdu:
        return widget.descriptionUrdu.isNotEmpty ? widget.descriptionUrdu : widget.description;
      case IslamicNameLanguage.hindi:
        return widget.descriptionHindi.isNotEmpty ? widget.descriptionHindi : widget.description;
      default:
        return widget.description;
    }
  }

  @override
  void initState() {
    super.initState();
    _initTts();
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
          _isPlayingArabic = false;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _isPlayingArabic = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> playAudio(bool playArabic) async {
    if (_isSpeaking) {
      await _stopPlaying();
      return;
    }

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (playArabic) {
      textToSpeak = widget.arabicName;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
      setState(() {
        _isPlayingArabic = true;
      });
    } else {
      switch (_selectedLanguage) {
        case IslamicNameLanguage.english:
          textToSpeak = '$_currentMeaning. $_currentDescription';
          ttsLangCode = 'en-US';
          break;
        case IslamicNameLanguage.urdu:
          textToSpeak = '$_currentMeaning. $_currentDescription';
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case IslamicNameLanguage.hindi:
          textToSpeak = '$_currentMeaning. $_currentDescription';
          ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          break;
      }
      setState(() {
        _isPlayingArabic = false;
      });
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No text available for audio'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      return;
    }

    await _flutterTts.setLanguage(ttsLangCode);
    setState(() {
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
      _isPlayingArabic = false;
    });
  }

  void toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void copyDetails(BuildContext context) {
    final text = '''
${widget.arabicName}
${widget.transliteration}

$_currentMeaning

$_currentDescription

- From Jiyan Islamic Academy App
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void shareDetails() {
    final text = '''
${widget.number}. ${widget.arabicName}
${widget.transliteration}

$_currentMeaning

$_currentDescription

- Shared from Jiyan Islamic Academy App
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const softGold = Color(0xFFC9A24D);
    final isRtl = _selectedLanguage == IslamicNameLanguage.urdu;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(widget.transliteration),
        actions: [
          PopupMenuButton<IslamicNameLanguage>(
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
            onSelected: (IslamicNameLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => IslamicNameLanguage.values.map((language) {
              final isSelected = _selectedLanguage == language;
              return PopupMenuItem<IslamicNameLanguage>(
                value: language,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(
                      languageNames[language]!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isSpeaking
                  ? emeraldGreen
                  : (isDark ? Colors.grey.shade700 : lightGreenBorder),
              width: _isSpeaking ? 2 : 1.5,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isSpeaking
                      ? emeraldGreen.withValues(alpha: 0.1)
                      : (isDark ? Colors.grey.shade800 : lightGreenChip),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _isSpeaking ? emeraldGreen : darkGreen,
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
                              '${widget.number}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.transliteration,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : darkGreen,
                                ),
                              ),
                              Text(
                                widget.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : emeraldGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HeaderActionButton(
                          icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                          label: _isSpeaking ? 'Stop' : 'Audio',
                          onTap: () => playAudio(!_showTranslation),
                          isActive: _isSpeaking,
                          isDark: isDark,
                        ),
                        HeaderActionButton(
                          icon: Icons.translate,
                          label: 'Translate',
                          onTap: toggleTranslation,
                          isActive: _showTranslation,
                          isDark: isDark,
                        ),
                        HeaderActionButton(
                          icon: Icons.copy,
                          label: 'Copy',
                          onTap: () => copyDetails(context),
                          isActive: false,
                          isDark: isDark,
                        ),
                        HeaderActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: shareDetails,
                          isActive: false,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isSpeaking && _isPlayingArabic) {
                    _stopPlaying();
                  } else {
                    playAudio(true);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: (_isSpeaking && _isPlayingArabic)
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isSpeaking && _isPlayingArabic)
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8),
                          child: Icon(
                            Icons.volume_up,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.arabicName,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 56,
                                height: 1.5,
                                color: (_isSpeaking && _isPlayingArabic)
                                    ? AppColors.primary
                                    : (isDark ? AppColors.secondary : softGold),
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.transliteration,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : darkGreen,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? emeraldGreen.withValues(alpha: 0.2) : lightGreenChip,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? emeraldGreen : lightGreenBorder,
                    ),
                  ),
                  child: Text(
                    _currentMeaning,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.secondary : softGold,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
              ),
              if (_showTranslation)
                GestureDetector(
                  onTap: () {
                    if (_isSpeaking && !_isPlayingArabic) {
                      _stopPlaying();
                    } else {
                      playAudio(false);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? Colors.grey.shade800 : lightGreenChip.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSpeaking && !_isPlayingArabic)
                          Padding(
                            padding: const EdgeInsets.only(right: 8, top: 4),
                            child: Icon(
                              Icons.volume_up,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: isRtl ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: isDark ? AppColors.secondary : AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedLanguage == IslamicNameLanguage.urdu
                                        ? 'تفصیل'
                                        : _selectedLanguage == IslamicNameLanguage.hindi
                                            ? 'विवरण'
                                            : 'About (${languageNames[_selectedLanguage]})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.secondary : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _currentDescription,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.8,
                                  color: (_isSpeaking && !_isPlayingArabic)
                                      ? AppColors.primary
                                      : (isDark ? AppColors.darkTextSecondary : Colors.black87),
                                ),
                                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!_showTranslation)
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isRtl ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? emeraldGreen : darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedLanguage == IslamicNameLanguage.urdu
                                ? 'تفصیل'
                                : _selectedLanguage == IslamicNameLanguage.hindi
                                    ? 'विवरण'
                                    : 'About',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentDescription,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              if (_hasBiographicalDetails())
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? emeraldGreen : darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedLanguage == IslamicNameLanguage.urdu
                                ? 'سوانح عمری'
                                : _selectedLanguage == IslamicNameLanguage.hindi
                                    ? 'जीवनी विवरण'
                                    : 'Biographical Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildBiographicalGrid(isDark, darkGreen, emeraldGreen),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget HeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
    required bool isDark,
  }) {
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const darkGreen = Color(0xFF0A5C36);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? emeraldGreen
                : (isDark ? Colors.grey.shade700 : lightGreenChip),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive
                    ? Colors.white
                    : (isDark ? AppColors.darkTextPrimary : darkGreen),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : darkGreen),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasBiographicalDetails() {
    return widget.fatherName != null ||
        widget.motherName != null ||
        widget.birthDate != null ||
        widget.birthPlace != null ||
        widget.deathDate != null ||
        widget.deathPlace != null ||
        widget.spouse != null ||
        widget.children != null ||
        widget.knownFor != null ||
        widget.title != null ||
        widget.tribe != null ||
        widget.era != null;
  }

  Widget _buildBiographicalGrid(bool isDark, Color darkGreen, Color emeraldGreen) {
    final details = <Map<String, String>>[];

    if (widget.title != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'لقب' : _selectedLanguage == IslamicNameLanguage.hindi ? 'उपाधि' : 'Title',
        'value': widget.title!,
        'icon': 'star',
      });
    }
    if (widget.fatherName != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'والد' : _selectedLanguage == IslamicNameLanguage.hindi ? 'पिता' : 'Father',
        'value': widget.fatherName!,
        'icon': 'father',
      });
    }
    if (widget.motherName != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'والدہ' : _selectedLanguage == IslamicNameLanguage.hindi ? 'माता' : 'Mother',
        'value': widget.motherName!,
        'icon': 'mother',
      });
    }
    if (widget.spouse != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'شریک حیات' : _selectedLanguage == IslamicNameLanguage.hindi ? 'जीवनसाथी' : 'Spouse',
        'value': widget.spouse!,
        'icon': 'spouse',
      });
    }
    if (widget.children != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'اولاد' : _selectedLanguage == IslamicNameLanguage.hindi ? 'संतान' : 'Children',
        'value': widget.children!,
        'icon': 'children',
      });
    }
    if (widget.birthDate != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'تاریخ پیدائش' : _selectedLanguage == IslamicNameLanguage.hindi ? 'जन्म तिथि' : 'Birth Date',
        'value': widget.birthDate!,
        'icon': 'birth',
      });
    }
    if (widget.birthPlace != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'جائے پیدائش' : _selectedLanguage == IslamicNameLanguage.hindi ? 'जन्म स्थान' : 'Birth Place',
        'value': widget.birthPlace!,
        'icon': 'place',
      });
    }
    if (widget.deathDate != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'تاریخ وفات' : _selectedLanguage == IslamicNameLanguage.hindi ? 'मृत्यु तिथि' : 'Death Date',
        'value': widget.deathDate!,
        'icon': 'death',
      });
    }
    if (widget.deathPlace != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'جائے وفات' : _selectedLanguage == IslamicNameLanguage.hindi ? 'मृत्यु स्थान' : 'Death Place',
        'value': widget.deathPlace!,
        'icon': 'place',
      });
    }
    if (widget.tribe != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'قبیلہ' : _selectedLanguage == IslamicNameLanguage.hindi ? 'क़बीला' : 'Tribe',
        'value': widget.tribe!,
        'icon': 'tribe',
      });
    }
    if (widget.era != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'دور' : _selectedLanguage == IslamicNameLanguage.hindi ? 'काल' : 'Era',
        'value': widget.era!,
        'icon': 'era',
      });
    }
    if (widget.knownFor != null) {
      details.add({
        'label': _selectedLanguage == IslamicNameLanguage.urdu ? 'مشہور' : _selectedLanguage == IslamicNameLanguage.hindi ? 'प्रसिद्ध' : 'Known For',
        'value': widget.knownFor!,
        'icon': 'known',
      });
    }

    return Column(
      children: details.map((detail) => _buildDetailRow(
        detail['label']!,
        detail['value']!,
        _getIconForDetail(detail['icon']!),
        isDark,
        darkGreen,
        emeraldGreen,
      )).toList(),
    );
  }

  IconData _getIconForDetail(String iconType) {
    switch (iconType) {
      case 'star':
        return Icons.star_outline;
      case 'father':
        return Icons.person_outline;
      case 'mother':
        return Icons.person_2_outlined;
      case 'spouse':
        return Icons.favorite_outline;
      case 'children':
        return Icons.child_care;
      case 'birth':
        return Icons.cake_outlined;
      case 'death':
        return Icons.event_outlined;
      case 'place':
        return Icons.location_on_outlined;
      case 'tribe':
        return Icons.groups_outlined;
      case 'era':
        return Icons.access_time;
      case 'known':
        return Icons.auto_awesome_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    bool isDark,
    Color darkGreen,
    Color emeraldGreen,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? emeraldGreen.withValues(alpha: 0.2) : const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isDark ? emeraldGreen : darkGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextPrimary : darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
