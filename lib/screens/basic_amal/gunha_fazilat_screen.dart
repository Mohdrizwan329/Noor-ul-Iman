import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/icon_color_helpers.dart';
import 'basic_amal_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';

class GunhaFazilatScreen extends StatefulWidget {
  const GunhaFazilatScreen({super.key});

  @override
  State<GunhaFazilatScreen> createState() => _GunhaFazilatScreenState();
}

class _GunhaFazilatScreenState extends State<GunhaFazilatScreen> {
  final ContentService _contentService = ContentService();
  List<Map<String, dynamic>> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    setState(() => _isLoading = true);
    try {
      final firestoreData = await _contentService.getBasicAmalGuide('gunha_fazilat');
      if (firestoreData != null && firestoreData.steps.isNotEmpty) {
        _allItems = firestoreData.steps.map((step) => {
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
        }).toList();
      }
    } catch (e) {
      debugPrint('Error loading gunha_fazilat from Firestore: $e');
    }
    if (mounted) setState(() => _isLoading = false);
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
          context.tr('gunha'),
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final langCode = context.languageProvider.languageCode;
                final isRtl = langCode == 'ur' || langCode == 'ar';
                return SingleChildScrollView(
                  padding: context.responsive.paddingRegular,
                  child: Column(
                    crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _allItems.length,
                        itemBuilder: (context, index) {
                          final topic = _allItems[index];
                          return _buildTopicCard(topic);
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


  Widget _buildTopicCard(Map<String, dynamic> topic) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = topic['titleUrdu'] ?? topic['title'] ?? '';
        break;
      case 'hi':
        title = topic['titleHindi'] ?? topic['title'] ?? '';
        break;
      case 'ar':
        title = topic['titleArabic'] ?? topic['title'] ?? '';
        break;
      default:
        title = topic['title'] ?? '';
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
        onTap: () => _showTopicDetails(topic),
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
                    '${topic['number']}',
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
                            topic['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('gunha_fazilat'),
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

  void _showTopicDetails(Map<String, dynamic> topic) {
    final details = topic['details'] as Map<String, String>;
    AdNavigator.push(context, BasicAmalDetailScreen(
      title: topic['title'] ?? '',
      titleUrdu: topic['titleUrdu'] ?? '',
      titleHindi: topic['titleHindi'] ?? '',
      titleArabic: topic['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: topic['color'] as Color,
      icon: topic['icon'] as IconData,
      categoryKey: 'category_gunha_fazilat',
      number: topic['number'] as int?,
    ));
  }
}
