import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/icon_color_helpers.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'basic_amal_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';

class WazuScreen extends StatefulWidget {
  const WazuScreen({super.key});

  @override
  State<WazuScreen> createState() => _WazuScreenState();
}

class _WazuScreenState extends State<WazuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ContentService integration
  final ContentService _contentService = ContentService();
  List<Map<String, dynamic>> _allSteps = [];
  List<Map<String, dynamic>> _allAdditionalInfo = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    try {
      final guide = await _contentService.getBasicAmalGuide('wazu');
      if (guide != null && guide.steps.isNotEmpty) {
        setState(() {
          _allSteps = guide.steps.asMap().entries.map((entry) {
            final step = entry.value;
            return {
              'step': step.step,
              'titleKey': step.titleKey,
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
        });
      }
    } catch (e) {
      debugPrint('Error loading wazu from Firestore: $e');
    }

    // Load additional info from Firestore
    try {
      final additionalGuide = await _contentService.getBasicAmalGuide('wazu_additional_info');
      if (additionalGuide != null && additionalGuide.steps.isNotEmpty) {
        setState(() {
          _allAdditionalInfo = additionalGuide.steps.asMap().entries.map((entry) {
            final step = entry.value;
            return {
              'number': step.step,
              'titleKey': step.titleKey,
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
        });
      }
    } catch (e) {
      debugPrint('Error loading wazu additional info from Firestore: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredWazuSteps {
    if (_searchQuery.isEmpty) {
      return _allSteps;
    }
    final query = _searchQuery.toLowerCase();
    final langCode = context.languageProvider.languageCode;
    return _allSteps.where((step) {
      final title = (langCode == 'ur'
          ? (step['titleUrdu'] ?? step['title'])
          : langCode == 'hi'
              ? (step['titleHindi'] ?? step['title'])
              : langCode == 'ar'
                  ? (step['titleArabic'] ?? step['title'])
                  : step['title']).toString().toLowerCase();
      final stepNumber = step['step'].toString();
      return title.contains(query) || stepNumber.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredAdditionalInfo {
    if (_searchQuery.isEmpty) {
      return _allAdditionalInfo;
    }
    final query = _searchQuery.toLowerCase();
    final langCode = context.languageProvider.languageCode;
    return _allAdditionalInfo.where((info) {
      final title = (langCode == 'ur'
          ? (info['titleUrdu'] ?? info['title'])
          : langCode == 'hi'
              ? (info['titleHindi'] ?? info['title'])
              : langCode == 'ar'
                  ? (info['titleArabic'] ?? info['title'])
                  : info['title']).toString().toLowerCase();
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
          context.tr('wazu'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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
                      hintText: context.tr('search_wazu_steps'),
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

            // Wudu Steps
            filteredWazuSteps.isEmpty && filteredAdditionalInfo.isEmpty
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
                    itemCount: AdListHelper.totalCount(filteredWazuSteps.length),
                    itemBuilder: (context, index) {
                      if (AdListHelper.isAdPosition(index)) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: BannerAdWidget(height: 250),
                        );
                      }
                      final dataIdx = AdListHelper.dataIndex(index);
                      final step = filteredWazuSteps[dataIdx];
                      return _buildStepCard(step);
                    },
                  ),

            if (filteredWazuSteps.isNotEmpty || filteredAdditionalInfo.isNotEmpty) ...[
              const SizedBox(height: 24),

              // Additional Info Title
              if (filteredAdditionalInfo.isNotEmpty) ...[
                Text(
                  context.tr('additional_information'),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Additional Info Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AdListHelper.totalCount(filteredAdditionalInfo.length),
                  itemBuilder: (context, index) {
                    if (AdListHelper.isAdPosition(index)) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: BannerAdWidget(height: 250),
                      );
                    }
                    final dataIdx = AdListHelper.dataIndex(index);
                    final info = filteredAdditionalInfo[dataIdx];
                    return _buildInfoCard(info);
                  },
                ),
              ],
            ],
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

  Widget _buildStepCard(
    Map<String, dynamic> step,
  ) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = step['titleUrdu'] ?? step['title'] ?? '';
        break;
      case 'hi':
        title = step['titleHindi'] ?? step['title'] ?? '';
        break;
      case 'ar':
        title = step['titleArabic'] ?? step['title'] ?? '';
        break;
      default:
        title = step['title'] ?? '';
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
        onTap: () => _showStepDetails(step),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Step Number Badge
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
                    '${step['step']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              responsive.hSpaceSmall,

              // Step Name and Icon
              Expanded(
                child: Column(
                  crossAxisAlignment: (langCode == 'ur' || langCode == 'ar')
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Step Title
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
                    // Step icon chip
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
                            step['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              '${context.tr('step')} ${step['step']}',
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

  Widget _buildInfoCard(
    Map<String, dynamic> info,
  ) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = info['titleUrdu'] ?? info['title'] ?? '';
        break;
      case 'hi':
        title = info['titleHindi'] ?? info['title'] ?? '';
        break;
      case 'ar':
        title = info['titleArabic'] ?? info['title'] ?? '';
        break;
      default:
        title = info['title'] ?? '';
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
        onTap: () => _showInfoDetails(info),
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
                    '${info['number']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              responsive.hSpaceSmall,

              // Info Title
              Expanded(
                child: Column(
                  crossAxisAlignment: (langCode == 'ur' || langCode == 'ar')
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Info Title
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
                    // Info chip
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
                            Icons.info_outline,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('additional_information'),
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

  void _showStepDetails(Map<String, dynamic> step) {
    final details = step['details'] as Map<String, String>;
    AdNavigator.push(context, BasicAmalDetailScreen(
      title: step['title'] ?? '',
      titleUrdu: step['titleUrdu'] ?? '',
      titleHindi: step['titleHindi'] ?? '',
      titleArabic: step['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: step['color'] as Color,
      icon: step['icon'] as IconData,
      categoryKey: 'category_wazu',
      number: step['step'] as int?,
    ));
  }

  void _showInfoDetails(Map<String, dynamic> info) {
    final details = info['details'] as Map<String, String>;
    AdNavigator.push(context, BasicAmalDetailScreen(
      title: info['title'] ?? '',
      titleUrdu: info['titleUrdu'] ?? '',
      titleHindi: info['titleHindi'] ?? '',
      titleArabic: info['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: info['color'] as Color,
      icon: info['icon'] as IconData,
      categoryKey: 'category_wazu',
      number: info['number'] as int?,
    ));
  }
}
