import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../widgets/common/native_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import '../../core/utils/ad_navigation.dart';
import 'islamic_name_detail_screen.dart';

class IslamicNamesListScreen extends StatefulWidget {
  final String collectionKey;
  final String assetFileName;
  final String titleKey;
  final bool hasSearch;
  final String emptyStateKey;
  final String detailCategory;
  final IconData detailIcon;
  final Color detailColor;
  final bool showPeriodInMeaning;
  final bool showKunya;

  const IslamicNamesListScreen({
    super.key,
    required this.collectionKey,
    required this.assetFileName,
    required this.titleKey,
    required this.detailCategory,
    required this.detailIcon,
    required this.detailColor,
    this.hasSearch = false,
    this.emptyStateKey = 'no_data_available',
    this.showPeriodInMeaning = false,
    this.showKunya = false,
  });

  @override
  State<IslamicNamesListScreen> createState() =>
      _IslamicNamesListScreenState();
}

class _IslamicNamesListScreenState extends State<IslamicNamesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ContentService _contentService = ContentService();
  List<IslamicNameFirestore> _allNames = [];
  List<IslamicNameFirestore> _filteredNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.hasSearch) {
      _searchController.addListener(_filterNames);
    }
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final names =
          await _contentService.getIslamicNames(widget.collectionKey);
      if (names.isNotEmpty) {
        _allNames = names;
        _filteredNames = _allNames;
      } else {
        await _loadFromAsset();
      }
    } catch (e) {
      debugPrint('Error loading ${widget.collectionKey} from Firestore: $e');
      await _loadFromAsset();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/firebase/${widget.assetFileName}',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final names = (jsonData['names'] as List<dynamic>? ?? [])
          .map(
              (n) => IslamicNameFirestore.fromJson(n as Map<String, dynamic>))
          .toList();
      _allNames = names;
      _filteredNames = _allNames;
    } catch (e) {
      debugPrint(
          'Error loading ${widget.collectionKey} from asset: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredNames = _allNames;
      } else {
        _filteredNames = _allNames.where((name) {
          final match = name.transliteration.toLowerCase().contains(query) ||
              name.title.en.toLowerCase().contains(query) ||
              name.name.contains(query) ||
              (name.nameUrdu ?? '').contains(query) ||
              (name.nameHindi ?? '').contains(query);
          if (widget.showKunya) {
            return match || (name.kunya ?? '').toLowerCase().contains(query);
          }
          return match;
        }).toList();
      }
    });
  }

  String _getDisplayName(IslamicNameFirestore name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name.name;
      case 'ur':
        return name.nameUrdu ?? name.transliteration;
      case 'hi':
        return name.nameHindi ?? name.transliteration;
      case 'en':
      default:
        return name.transliteration;
    }
  }

  String _buildMeaning(IslamicNameFirestore name, String langCode) {
    final meaning = name.title.get(langCode);
    if (widget.showPeriodInMeaning) {
      final period = name.period ?? '';
      return period.isNotEmpty ? '$meaning ($period)' : meaning;
    }
    if (widget.showKunya) {
      final kunya = _getKunya(name, langCode);
      return kunya.isNotEmpty ? '$meaning ($kunya)' : meaning;
    }
    return meaning;
  }

  String _getKunya(IslamicNameFirestore name, String languageCode) {
    final kunyaRaw = name.kunya;
    if (kunyaRaw == null || kunyaRaw.isEmpty) return '';
    final parts = kunyaRaw.split(' | ');
    if (parts.length >= 3) {
      switch (languageCode) {
        case 'ur':
          return parts[1].trim();
        case 'hi':
          return parts[2].trim();
        case 'ar':
          return parts.length > 3 ? parts[3].trim() : parts[0].trim();
        case 'en':
        default:
          return parts[0].trim();
      }
    }
    return kunyaRaw;
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final responsive = context.responsive;
    final displayList = widget.hasSearch ? _filteredNames : _allNames;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.tr(widget.titleKey)),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          if (widget.hasSearch)
            Padding(
              padding: responsive.paddingRegular,
              child: SearchBarWidget(
                controller: _searchController,
                hintText: context.tr('search_by_name_meaning'),
                onClear: () => _searchController.clear(),
                enableVoiceSearch: true,
              ),
            ),
          if (widget.hasSearch && _searchController.text.isNotEmpty)
            Padding(
              padding: responsive.paddingSymmetric(horizontal: 16),
              child: Text(
                '${context.tr('found')} ${_filteredNames.length} ${_filteredNames.length != 1 ? context.tr('results') : context.tr('result')}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: responsive.textSmall,
                ),
              ),
            ),
          Expanded(
            child: displayList.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: responsive.iconXXLarge,
                          color: Colors.grey.shade400,
                        ),
                        responsive.vSpaceRegular,
                        Text(
                          context.tr(widget.emptyStateKey),
                          style: TextStyle(
                            fontSize: responsive.textRegular,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(langProvider.languageCode),
                    padding: responsive.paddingRegular,
                    itemCount: AdListHelper.totalCount(displayList.length),
                    itemBuilder: (context, index) {
                      if (AdListHelper.isAdPosition(index)) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: NativeAdWidget(),
                        );
                      }
                      final dataIndex = AdListHelper.dataIndex(index);
                      final name = displayList[dataIndex];
                      final originalIndex = _allNames.indexOf(name) + 1;
                      return _buildNameCard(
                        name: name,
                        index: originalIndex,
                        displayName: _getDisplayName(
                            name, langProvider.languageCode),
                        languageCode: langProvider.languageCode,
                      );
                    },
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildNameCard({
    required IslamicNameFirestore name,
    required int index,
    required String displayName,
    required String languageCode,
  }) {
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
            blurRadius: 10.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          AdNavigator.push(
            context,
            IslamicNameDetailScreen(
              arabicName: name.name,
              transliteration: name.transliteration,
              meaning: _buildMeaning(name, 'en'),
              meaningUrdu: _buildMeaning(name, 'ur'),
              meaningHindi: _buildMeaning(name, 'hi'),
              description: name.description.en,
              descriptionUrdu: name.description.ur,
              descriptionHindi: name.description.hi,
              category: widget.detailCategory,
              number: index,
              icon: widget.detailIcon,
              color: widget.detailColor,
              fatherName: name.fatherName,
              motherName: name.motherName,
              birthDate: name.birthDate,
              birthPlace: name.birthPlace,
              deathDate: name.deathDate,
              deathPlace: name.deathPlace,
              spouse: name.spouse,
              children: name.children,
              tribe: name.tribe,
              title: name.fullTitle ?? name.title.en,
              era: name.era,
              knownFor: name.knownFor,
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              Container(
                width: responsive.iconLarge * 1.5,
                height: responsive.iconLarge * 1.5,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              responsive.hSpaceSmall,
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: (languageCode == 'ar' || languageCode == 'ur')
                        ? 'Poppins'
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: (languageCode == 'ar' || languageCode == 'ur')
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),
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
