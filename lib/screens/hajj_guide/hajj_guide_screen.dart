import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../data/models/multilingual_text.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

enum HajjLanguage { english, urdu, hindi, arabic }

class HajjGuideScreen extends StatefulWidget {
  const HajjGuideScreen({super.key});

  @override
  State<HajjGuideScreen> createState() => _HajjGuideScreenState();
}

class _HajjGuideScreenState extends State<HajjGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HajjLanguage _selectedLanguage = HajjLanguage.english;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  String? _currentPlayingId;
  final Set<String> _expandedDuas = {};
  List<HajjStep>? _firestoreHajjSteps;
  List<HajjStep>? _firestoreUmrahSteps;
  List<HajjDuaFirestore>? _firestoreDuas;
  List<MultilingualText>? _firestoreProhibitions;
  Map<String, MultilingualText>? _firestoreIntro;
  bool _isLoading = true;

  static const _iconMap = {
    'checklist': Icons.checklist,
    'flag': Icons.flag,
    'terrain': Icons.terrain,
    'celebration': Icons.celebration,
    'replay': Icons.replay,
    'mosque': Icons.mosque,
    'check_circle': Icons.check_circle,
    'rotate_right': Icons.rotate_right,
    'autorenew': Icons.autorenew,
    'directions_walk': Icons.directions_walk,
    'content_cut': Icons.content_cut,
  };

  HajjStep _convertFirestoreStep(HajjStepFirestore fs) {
    Color color = const Color(0xFF4CAF50);
    try {
      color = Color(int.parse(fs.color.replaceFirst('#', '0xFF')));
    } catch (_) {}
    return HajjStep(
      day: fs.day.en,
      dayUrdu: fs.day.ur,
      dayHindi: fs.day.hi,
      dayArabic: fs.day.ar,
      title: fs.title.en,
      titleUrdu: fs.title.ur,
      titleHindi: fs.title.hi,
      titleArabic: fs.title.ar,
      icon: _iconMap[fs.icon] ?? Icons.circle,
      color: color,
      steps: fs.steps.map<String>((s) => s.en).toList(),
      stepsUrdu: fs.steps.map<String>((s) => s.ur).toList(),
      stepsHindi: fs.steps.map<String>((s) => s.hi).toList(),
      stepsArabic: fs.steps.map<String>((s) => s.ar).toList(),
    );
  }

  Future<void> _loadFromFirestore() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final contentService = ContentService();
      final hajjData = await contentService.getHajjGuide('hajj');
      final umrahData = await contentService.getHajjGuide('umrah');
      final duasList = await contentService.getHajjDuas();
      final prohibList = await contentService.getHajjProhibitions();
      final introMap = await contentService.getHajjIntro();

      if (mounted) {
        setState(() {
          if (hajjData.isNotEmpty) {
            _firestoreHajjSteps = hajjData.map(_convertFirestoreStep).toList();
          }
          if (umrahData.isNotEmpty) {
            _firestoreUmrahSteps = umrahData
                .map(_convertFirestoreStep)
                .toList();
          }
          if (duasList.isNotEmpty) _firestoreDuas = duasList;
          if (prohibList.isNotEmpty) _firestoreProhibitions = prohibList;
          if (introMap.isNotEmpty) _firestoreIntro = introMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading hajj guide from ContentService: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initTts();
    _loadFromFirestore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync with app's language provider
    final languageProvider = Provider.of<LanguageProvider>(context);
    final langCode = languageProvider.languageCode;

    HajjLanguage newLanguage;
    if (langCode == 'ur') {
      newLanguage = HajjLanguage.urdu;
    } else if (langCode == 'hi') {
      newLanguage = HajjLanguage.hindi;
    } else if (langCode == 'ar') {
      newLanguage = HajjLanguage.arabic;
    } else {
      newLanguage = HajjLanguage.english;
    }

    if (_selectedLanguage != newLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
      });
    }
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ar-SA');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
        _currentPlayingId = null;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: responsive.value(mobile: 50, tablet: 60, desktop: 70),
        title: Text(
          context.tr('hajj_guide'),
          style: TextStyle(color: Colors.white, fontSize: responsive.textLarge),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: context.tr('hajj_rituals')),
            Tab(text: context.tr('umrah')),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildHajjGuide(), _buildUmrahGuide()],
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildHajjGuide() {
    if (_isLoading && _firestoreHajjSteps == null) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_firestoreHajjSteps == null || _firestoreHajjSteps!.isEmpty) {
      return Center(
        child: Text(
          context.tr('no_data_available'),
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return _buildGuideList(_firestoreHajjSteps!, 'Hajj');
  }

  Widget _buildUmrahGuide() {
    if (_isLoading && _firestoreUmrahSteps == null) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_firestoreUmrahSteps == null || _firestoreUmrahSteps!.isEmpty) {
      return Center(
        child: Text(
          context.tr('no_data_available'),
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return _buildGuideList(_firestoreUmrahSteps!, 'Umrah');
  }

  Widget _buildGuideList(List<HajjStep> steps, String type) {
    final responsive = ResponsiveUtils(context);

    return SingleChildScrollView(
      padding: responsive.paddingRegular,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(type),
          responsive.vSpaceRegular,
          ...steps.map((step) => _buildStepCard(step)),
          responsive.vSpaceRegular,
          _buildDuasCard(type),
          responsive.vSpaceRegular,
          _buildProhibitionsCard(),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String type) {
    final responsive = ResponsiveUtils(context);
    final title = type == 'Hajj'
        ? context.tr('guide_to_hajj')
        : context.tr('guide_to_umrah');

    final langCode = _selectedLanguage == HajjLanguage.urdu
        ? 'ur'
        : _selectedLanguage == HajjLanguage.hindi
        ? 'hi'
        : _selectedLanguage == HajjLanguage.arabic
        ? 'ar'
        : 'en';

    final subtitleKey = type == 'Hajj' ? 'hajj_subtitle' : 'umrah_subtitle';
    final subtitle =
        _firestoreIntro?[subtitleKey]?.get(langCode) ??
        (type == 'Hajj'
            ? context.tr('hajj_description')
            : context.tr('umrah_description'));

    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.radiusXLarge),
      ),
      child: Column(
        children: [
          Icon(
            Icons.mosque,
            color: Colors.white,
            size: responsive.iconSize(48),
          ),
          responsive.vSpaceMedium,
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontSize(28),
              fontWeight: FontWeight.bold,
            ),
          ),
          responsive.vSpaceSmall,
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: responsive.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(HajjStep step) {
    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);
    final responsive = ResponsiveUtils(context);

    final title = _selectedLanguage == HajjLanguage.urdu
        ? step.titleUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? step.titleHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? step.titleArabic
        : step.title;

    final day = _selectedLanguage == HajjLanguage.urdu
        ? step.dayUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? step.dayHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? step.dayArabic
        : step.day;

    final steps = _selectedLanguage == HajjLanguage.urdu
        ? step.stepsUrdu
        : _selectedLanguage == HajjLanguage.hindi
        ? step.stepsHindi
        : _selectedLanguage == HajjLanguage.arabic
        ? step.stepsArabic
        : step.steps;

    return Container(
      margin: responsive.paddingOnly(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: lightGreenBorder,
          width: responsive.spacing(1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: responsive.paddingAll(8),
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              color: step.color,
              size: responsive.iconMedium,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: responsive.textRegular,
            ),
          ),
          subtitle: Text(
            day,
            style: TextStyle(color: step.color, fontSize: responsive.textSmall),
          ),
          children: [
            Padding(
              padding: responsive.paddingRegular,
              child: Column(
                children: steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: responsive.paddingOnly(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: responsive.spacing(24),
                          height: responsive.spacing(24),
                          decoration: BoxDecoration(
                            color: step.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                color: step.color,
                                fontSize: responsive.textSmall,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        responsive.hSpaceMedium,
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: AppColors.primary,

                              height: 1.4,
                              fontSize: responsive.textMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuasCard(String type) {
    final responsive = ResponsiveUtils(context);
    final duas = _firestoreDuas ?? [];

    if (duas.isEmpty) {
      return const SizedBox.shrink();
    }

    final langCode = _selectedLanguage == HajjLanguage.urdu
        ? 'ur'
        : _selectedLanguage == HajjLanguage.hindi
        ? 'hi'
        : _selectedLanguage == HajjLanguage.arabic
        ? 'ar'
        : 'en';

    final sectionTitle =
        _firestoreIntro?['duas_section_title']?.get(langCode) ??
        'Important Duas';

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: lightGreenBorder,
          width: responsive.spacing(1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: darkGreen,
                  size: responsive.iconMedium,
                ),
                responsive.hSpaceSmall,
                Expanded(
                  child: Text(
                    sectionTitle,
                    style: TextStyle(
                      fontSize: responsive.textLarge,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            responsive.vSpaceRegular,
            ...duas.map((dua) => _buildDuaItem(dua)),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaItem(HajjDuaFirestore dua) {
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);
    final responsive = ResponsiveUtils(context);

    final langCode = _selectedLanguage == HajjLanguage.urdu
        ? 'ur'
        : _selectedLanguage == HajjLanguage.hindi
        ? 'hi'
        : _selectedLanguage == HajjLanguage.arabic
        ? 'ar'
        : 'en';

    final title = dua.title.get(langCode);
    final translation = dua.translation.get(langCode);

    final isExpanded = _expandedDuas.contains(dua.id);
    final isPlayingArabic =
        _isPlaying && _currentPlayingId == '${dua.id}_arabic';
    final isPlayingTranslation =
        _isPlaying && _currentPlayingId == '${dua.id}_translation';
    final isPlaying = isPlayingArabic || isPlayingTranslation;

    String languageLabel;
    switch (_selectedLanguage) {
      case HajjLanguage.hindi:
        languageLabel = context.tr('hindi');
        break;
      case HajjLanguage.urdu:
        languageLabel = context.tr('urdu');
        break;
      case HajjLanguage.arabic:
        languageLabel = context.tr('arabic');
        break;
      default:
        languageLabel = context.tr('english');
    }

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying ? AppColors.primaryLight : lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section with Light Green Background
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // Title Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderActionButton(
                      icon: isPlayingArabic ? Icons.stop : Icons.volume_up,
                      label: isPlayingArabic
                          ? context.tr('stop')
                          : context.tr('audio'),
                      onTap: () => _speakDua(dua.arabic, '${dua.id}_arabic'),
                      isActive: isPlayingArabic,
                      responsive: responsive,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleDuaExpanded(dua.id),
                      isActive: isExpanded,
                      responsive: responsive,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyDua(dua, title, translation),
                      isActive: false,
                      responsive: responsive,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareDua(dua, title, translation),
                      isActive: false,
                      responsive: responsive,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arabic Text with Tap to Play
          GestureDetector(
            onTap: () {
              if (isPlayingArabic) {
                _stopPlaying();
              } else {
                _speakDua(dua.arabic, '${dua.id}_arabic');
              }
            },
            child: Container(
              margin: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
              padding: responsive.paddingAll(12),
              decoration: isPlayingArabic
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
                  if (isPlayingArabic)
                    Padding(
                      padding: responsive.paddingOnly(
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
                        fontFamily: 'Poppins',
                        fontSize: responsive.fontSize(26),
                        height: 2.0,
                        color: isPlayingArabic
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

          // Translation Section (Shown when expanded)
          if (isExpanded)
            GestureDetector(
              onTap: () {
                if (isPlayingTranslation) {
                  _stopPlaying();
                } else {
                  _speakDua(translation, '${dua.id}_translation');
                }
              },
              child: Container(
                margin: responsive.paddingSymmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                padding: responsive.paddingAll(12),
                decoration: BoxDecoration(
                  color: isPlayingTranslation
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlayingTranslation)
                      Padding(
                        padding: responsive.paddingOnly(
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
                              responsive.hSpaceSmall,
                              Flexible(
                                child: Text(
                                  '${context.tr('translation')} ($languageLabel)',
                                  style: TextStyle(
                                    fontSize: responsive.textSmall,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          responsive.vSpaceMedium,
                          Text(
                            translation,
                            style: TextStyle(
                              fontSize: responsive.textMedium,
                              height: 1.6,
                              color: isPlayingTranslation
                                  ? AppColors.primary
                                  : Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                            textDirection:
                                (_selectedLanguage == HajjLanguage.urdu ||
                                    _selectedLanguage == HajjLanguage.arabic)
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
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
    required ResponsiveUtils responsive,
  }) {
    const lightGreenChip = Color(0xFFE8F3ED);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : lightGreenChip,
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
              responsive.vSpaceXSmall,
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

  void _toggleDuaExpanded(String duaId) {
    setState(() {
      if (_expandedDuas.contains(duaId)) {
        _expandedDuas.remove(duaId);
      } else {
        _expandedDuas.add(duaId);
      }
    });
  }

  void _speakDua(String text, String id) async {
    if (_isPlaying && _currentPlayingId == id) {
      _stopPlaying();
    } else {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = true;
        _currentPlayingId = id;
      });
      await _flutterTts.speak(text);
    }
  }

  void _stopPlaying() async {
    await _flutterTts.stop();
    setState(() {
      _isPlaying = false;
      _currentPlayingId = null;
    });
  }

  void _copyDua(HajjDuaFirestore dua, String title, String translation) {
    Clipboard.setData(
      ClipboardData(text: '$title\n\n${dua.arabic}\n\n$translation'),
    );
  }

  void _shareDua(HajjDuaFirestore dua, String title, String translation) {
    Share.share('$title\n\n${dua.arabic}\n\n$translation');
  }

  Widget _buildProhibitionsCard() {
    final responsive = ResponsiveUtils(context);
    final items = _firestoreProhibitions ?? [];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final langCode = _selectedLanguage == HajjLanguage.urdu
        ? 'ur'
        : _selectedLanguage == HajjLanguage.hindi
        ? 'hi'
        : _selectedLanguage == HajjLanguage.arabic
        ? 'ar'
        : 'en';

    final prohibitions = items.map((p) => p.get(langCode)).toList();
    final sectionTitle =
        _firestoreIntro?['prohibitions_section_title']?.get(langCode) ??
        'Ihram Prohibitions';

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: lightGreenBorder,
          width: responsive.spacing(1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.block,
                  color: Colors.red,
                  size: responsive.iconMedium,
                ),
                responsive.hSpaceSmall,
                Text(
                  sectionTitle,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spaceRegular),
            Wrap(
              spacing: responsive.spaceSmall,
              runSpacing: responsive.spaceSmall,
              children: prohibitions
                  .map(
                    (p) => Chip(
                      label: Text(
                        p,
                        style: TextStyle(color: AppColors.primary, fontSize: responsive.textSmall),
                      ),
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class HajjStep {
  final String day;
  final String dayUrdu;
  final String dayHindi;
  final String dayArabic;
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final IconData icon;
  final Color color;
  final List<String> steps;
  final List<String> stepsUrdu;
  final List<String> stepsHindi;
  final List<String> stepsArabic;

  HajjStep({
    required this.day,
    required this.dayUrdu,
    required this.dayHindi,
    required this.dayArabic,
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.titleArabic,
    required this.icon,
    required this.color,
    required this.steps,
    required this.stepsUrdu,
    required this.stepsHindi,
    required this.stepsArabic,
  });
}
