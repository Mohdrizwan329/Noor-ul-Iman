import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'basic_amal_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/icon_color_helpers.dart';

class FatihaScreen extends StatefulWidget {
  const FatihaScreen({super.key});

  @override
  State<FatihaScreen> createState() => _FatihaScreenState();
}

class _FatihaScreenState extends State<FatihaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ContentService for Firestore data loading
  final ContentService _contentService = ContentService();
  List<Map<String, dynamic>> _allFatihaTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    try {
      final firestoreData = await _contentService.getBasicAmalGuide('fatiha');
      if (firestoreData != null && firestoreData.steps.isNotEmpty) {
        final List<Map<String, dynamic>> mappedData = firestoreData.steps.asMap().entries.map((entry) {
          final step = entry.value;
          return {
            'number': step.step,
            'titleKey': step.titleKey.isNotEmpty ? step.titleKey : 'fatiha_${entry.key + 1}',
            'title': step.title.en,
            'titleUrdu': step.title.ur,
            'titleHindi': step.title.hi,
            'titleArabic': step.title.ar,
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
            _allFatihaTypes = mappedData;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading fatiha from Firestore: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredFatihaTypes {
    if (_searchQuery.isEmpty) {
      return _allFatihaTypes;
    }
    final query = _searchQuery.toLowerCase();
    final langCode = context.languageProvider.languageCode;
    return _allFatihaTypes.where((fatiha) {
      final title = (langCode == 'ur'
          ? (fatiha['titleUrdu'] ?? fatiha['title'])
          : langCode == 'hi'
              ? (fatiha['titleHindi'] ?? fatiha['title'])
              : langCode == 'ar'
                  ? (fatiha['titleArabic'] ?? fatiha['title'])
                  : fatiha['title']).toString().toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('fatiha'),
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Builder(
              builder: (context) {
                final langCode = context.languageProvider.languageCode;
                final isRtl = langCode == 'ur' || langCode == 'ar';
                return SingleChildScrollView(
            padding: context.responsive.paddingRegular,
            child: Column(
              crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: context.tr('search_fatiha_types'),
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

            // Fatiha Types List
            filteredFatihaTypes.isEmpty
                ? Center(
                    child: Padding(
                      padding: context.responsive.paddingAll(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: context.responsive.iconLarge * 2,
                            color: Colors.grey.shade400,
                          ),
                          context.responsive.vSpaceRegular,
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
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AdListHelper.totalCount(filteredFatihaTypes.length),
                    itemBuilder: (context, index) {
                      if (AdListHelper.isAdPosition(index)) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: BannerAdWidget(height: 250),
                        );
                      }
                      final dataIdx = AdListHelper.dataIndex(index);
                      final fatiha = filteredFatihaTypes[dataIdx];
                      return _buildFatihaCard(fatiha);
                    },
                  ),
          ],
        ),
      );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildFatihaCard(fatiha) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = fatiha['titleUrdu'] ?? fatiha['title'] ?? '';
        break;
      case 'hi':
        title = fatiha['titleHindi'] ?? fatiha['title'] ?? '';
        break;
      case 'ar':
        title = fatiha['titleArabic'] ?? fatiha['title'] ?? '';
        break;
      default:
        title = fatiha['title'] ?? '';
    }
    final responsive = context.responsive;
return Container(
      margin: responsive.paddingOnly(bottom: 10),
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
        onTap: () => _showFatihaDetails(fatiha),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge (if has number field)
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
                    '${fatiha['number'] ?? ''}',
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
                  crossAxisAlignment: (langCode == 'ur' || langCode == 'ar')
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textDirection: (langCode == 'ur' || langCode == 'ar') ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    responsive.vSpaceXSmall,
                    // Icon chip
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            fatiha['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('fatiha'),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: AppColors.emeraldGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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

  void _showFatihaDetails(Map<String, dynamic> fatiha) {
    final details = fatiha['details'] as Map<String, String>;
    AdNavigator.push(context, BasicAmalDetailScreen(
      title: fatiha['title'] ?? '',
      titleUrdu: fatiha['titleUrdu'] ?? '',
      titleHindi: fatiha['titleHindi'] ?? '',
      titleArabic: fatiha['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: fatiha['color'] as Color,
      icon: fatiha['icon'] as IconData,
      categoryKey: 'category_fatiha',
    ));
  }
}
