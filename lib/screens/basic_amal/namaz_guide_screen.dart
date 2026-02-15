import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/icon_color_helpers.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'basic_amal_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import '../../core/services/content_service.dart';

class NamazGuideScreen extends StatefulWidget {
  const NamazGuideScreen({super.key});

  @override
  State<NamazGuideScreen> createState() => _NamazGuideScreenState();
}

class _NamazGuideScreenState extends State<NamazGuideScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ContentService for Firestore data loading
  final ContentService _contentService = ContentService();
  List<Map<String, dynamic>> _allNamazCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    try {
      final firestoreData = await _contentService.getBasicAmalGuide('namaz_guide');
      if (firestoreData != null && firestoreData.steps.isNotEmpty) {
        final List<Map<String, dynamic>> mappedData = firestoreData.steps.asMap().entries.map((entry) {
          final step = entry.value;
          return {
            'number': step.step,
            'titleKey': step.titleKey.isNotEmpty ? step.titleKey : 'namaz_guide_${entry.key + 1}',
            'title': step.title.en,
            'titleUrdu': step.title.ur,
            'titleHindi': step.title.hi,
            'titleArabic': step.title.ar,
            'rakats': '',
            'rakatsUrdu': '',
            'rakatsHindi': '',
            'rakatsArabic': '',
            'time': '',
            'timeUrdu': '',
            'timeHindi': '',
            'icon': getIconFromString(step.icon),
            'color': getColorFromString(step.color),
            'details': {
              'english': step.details.en,
              'urdu': step.details.ur,
              'hindi': step.details.hi,
              'arabic': step.details.ar,
            },
          };
        }).toList();

        if (mounted && mappedData.isNotEmpty) {
          setState(() {
            _allNamazCategories = mappedData;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading namaz guide from Firestore: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredNamazCategories {
    if (_searchQuery.isEmpty) {
      return _allNamazCategories;
    }
    final query = _searchQuery.toLowerCase();
    final langCode = context.languageProvider.languageCode;
    return _allNamazCategories.where((namaz) {
      String title;
      switch (langCode) {
        case 'ur':
          title = namaz['titleUrdu'] ?? namaz['title'] ?? '';
          break;
        case 'hi':
          title = namaz['titleHindi'] ?? namaz['title'] ?? '';
          break;
        case 'ar':
          title = namaz['titleArabic'] ?? namaz['title'] ?? '';
          break;
        default:
          title = namaz['title'] ?? '';
      }
      title = title.toLowerCase();
      String rakats;
      switch (context.languageProvider.languageCode) {
        case 'ur':
          rakats = namaz['rakatsUrdu'] ?? namaz['rakats'] ?? '';
          break;
        case 'hi':
          rakats = namaz['rakatsHindi'] ?? namaz['rakats'] ?? '';
          break;
        case 'ar':
          rakats = namaz['rakatsArabic'] ?? namaz['rakats'] ?? '';
          break;
        default:
          rakats = namaz['rakats'] ?? '';
      }
      rakats = rakats.toLowerCase();
      return title.contains(query) || rakats.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('sabhi_namaz'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: context.responsive.paddingAll(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_prayers'),
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
            ),
          ),

          // Prayer List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredNamazCategories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: context.responsive.spaceRegular),
                            Text(
                              context.tr('no_results_found'),
                              style: TextStyle(
                                fontSize: context.responsive.textRegular,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: context.responsive.paddingRegular,
                        itemCount: AdListHelper.totalCount(filteredNamazCategories.length),
                        itemBuilder: (context, index) {
                          if (AdListHelper.isAdPosition(index)) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: BannerAdWidget(height: 250),
                            );
                          }
                          final dataIdx = AdListHelper.dataIndex(index);
                          final namaz = filteredNamazCategories[dataIdx];
                          return _buildNamazCard(namaz, dataIdx);
                        },
                      ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  String _getRakatsText(Map<String, dynamic> namaz, String langCode) {
    switch (langCode) {
      case 'ur':
        return namaz['rakatsUrdu'] ?? namaz['rakats'] ?? '';
      case 'hi':
        return namaz['rakatsHindi'] ?? namaz['rakats'] ?? '';
      case 'ar':
        return namaz['rakatsArabic'] ?? namaz['rakats'] ?? '';
      default:
        return namaz['rakats'] ?? '';
    }
  }

  Widget _buildNamazCard(
    Map<String, dynamic> namaz,
    int index,
  ) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = namaz['titleUrdu'] ?? namaz['title'] ?? '';
        break;
      case 'hi':
        title = namaz['titleHindi'] ?? namaz['title'] ?? '';
        break;
      case 'ar':
        title = namaz['titleArabic'] ?? namaz['title'] ?? '';
        break;
      default:
        title = namaz['title'] ?? '';
    }
    final responsive = context.responsive;
    return Container(
      margin: responsive.paddingOnly(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showNamazDetails(namaz),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge
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
                      offset: Offset(0, 2.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${namaz['number']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              responsive.hSpaceSmall,

              // Title and Icon chip
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: (langCode == 'ur' || langCode == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    responsive.vSpaceXSmall,
                    // Rakats chip
                    Container(
                      padding: responsive.paddingSymmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusSmall,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            namaz['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              _getRakatsText(namaz, langCode),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: AppColors.emeraldGreen,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: AppColors.emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.textXSmall + 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNamazDetails(Map<String, dynamic> namaz) {
    final details = namaz['details'] as Map<String, String>;
    final langCode = context.languageProvider.languageCode;

    // Get translated title based on current language
    String displayTitle;
    switch (langCode) {
      case 'ur':
        displayTitle = namaz['titleUrdu'] ?? namaz['title'] ?? '';
        break;
      case 'hi':
        displayTitle = namaz['titleHindi'] ?? namaz['title'] ?? '';
        break;
      case 'ar':
        displayTitle = namaz['titleArabic'] ?? namaz['title'] ?? '';
        break;
      default:
        displayTitle = namaz['title'] ?? '';
    }

    AdNavigator.push(context, BasicAmalDetailScreen(
      title: displayTitle,
      titleUrdu: namaz['titleUrdu'] ?? '',
      titleHindi: namaz['titleHindi'] ?? '',
      titleArabic: namaz['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: namaz['color'] as Color,
      icon: namaz['icon'] as IconData,
      categoryKey: 'category_namaz_guide',
    ));
  }
}
