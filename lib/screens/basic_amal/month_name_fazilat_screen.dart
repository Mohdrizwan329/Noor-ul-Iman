import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/icon_color_helpers.dart';
import '../../core/services/content_service.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'basic_amal_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';

class MonthNameFazilatScreen extends StatefulWidget {
  const MonthNameFazilatScreen({super.key});

  @override
  State<MonthNameFazilatScreen> createState() => _MonthNameFazilatScreenState();
}

class _MonthNameFazilatScreenState extends State<MonthNameFazilatScreen> {
  final ContentService _contentService = ContentService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    try {
      final guide = await _contentService.getBasicAmalGuide('month_name_fazilat');
      if (guide != null && guide.steps.isNotEmpty && mounted) {
        setState(() {
          _allItems = guide.steps.map((step) {
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
      debugPrint('Error loading month fazilat from Firestore: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredMonths {
    if (_searchQuery.isEmpty) {
      return _allItems;
    }
    final query = _searchQuery.toLowerCase();
    return _allItems.where((month) {
      final title = context
          .tr(month['titleKey'] ?? 'month_name_fazilat_1_muharram')
          .toString()
          .toLowerCase();
      final monthNumber = month['number'].toString();
      return title.contains(query) || monthNumber.contains(query);
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
          context.tr('month_fazilat'),
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
                : SingleChildScrollView(
              padding: context.responsive.paddingRegular,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SearchBarWidget(
                      controller: _searchController,
                      hintText: context.tr('search_month_fazilat'),
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

                  // Islamic Months List
                  filteredMonths.isEmpty
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
                                  context.tr('no_months_found'),
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
                          itemCount: AdListHelper.totalCount(filteredMonths.length),
                          itemBuilder: (context, index) {
                            if (AdListHelper.isAdPosition(index)) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: BannerAdWidget(height: 250),
                              );
                            }
                            final dataIdx = AdListHelper.dataIndex(index);
                            final month = filteredMonths[dataIdx];
                            return _buildMonthCard(month);
                          },
                        ),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildMonthCard(Map<String, dynamic> month) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = month['titleUrdu'] ?? month['title'] ?? '';
        break;
      case 'hi':
        title = month['titleHindi'] ?? month['title'] ?? '';
        break;
      case 'ar':
        title = month['titleArabic'] ?? month['title'] ?? '';
        break;
      default:
        title = month['title'] ?? '';
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
        onTap: () => _showMonthDetails(month),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Month Number Badge
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
                    '${month['number']}',
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
                      textDirection: (langCode == 'ur' || langCode == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    responsive.vSpaceXSmall,
                    // Icon chip
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
                            month['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              '${context.tr('islamic_month')} ${month['number']}',
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

  void _showMonthDetails(Map<String, dynamic> month) {
    final details = month['details'] as Map<String, String>;
    AdNavigator.push(context, BasicAmalDetailScreen(
      title: month['title'] ?? '',
      titleUrdu: month['titleUrdu'] ?? '',
      titleHindi: month['titleHindi'] ?? '',
      titleArabic: month['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: month['color'] as Color,
      icon: month['icon'] as IconData,
      categoryKey: 'category_month_fazilat',
      number: month['number'] as int?,
    ));
  }
}
