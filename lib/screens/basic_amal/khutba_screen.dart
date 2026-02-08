import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import 'basic_amal_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/icon_color_helpers.dart';

class KhutbaScreen extends StatefulWidget {
  const KhutbaScreen({super.key});

  @override
  State<KhutbaScreen> createState() => _KhutbaScreenState();
}

class _KhutbaScreenState extends State<KhutbaScreen> {
  // ContentService for Firestore data loading
  final ContentService _contentService = ContentService();
  List<Map<String, dynamic>> _allKhutbaTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    try {
      final firestoreData = await _contentService.getBasicAmalGuide('khutba');
      if (firestoreData != null && firestoreData.steps.isNotEmpty) {
        final List<Map<String, dynamic>> mappedData = firestoreData.steps.asMap().entries.map((entry) {
          final step = entry.value;
          return {
            'titleKey': step.titleKey.isNotEmpty ? step.titleKey : 'khutba_${entry.key + 1}',
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
            _allKhutbaTypes = mappedData;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading khutba from Firestore: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F7),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('khutba'),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _allKhutbaTypes.length,
                        itemBuilder: (context, index) => _buildKhutbaCard(
                          _allKhutbaTypes[index],
                        ),
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

  Widget _buildKhutbaCard(khutba) {
    final langCode = context.languageProvider.languageCode;
    String title;
    switch (langCode) {
      case 'ur':
        title = khutba['titleUrdu'] ?? khutba['title'] ?? '';
        break;
      case 'hi':
        title = khutba['titleHindi'] ?? khutba['title'] ?? '';
        break;
      case 'ar':
        title = khutba['titleArabic'] ?? khutba['title'] ?? '';
        break;
      default:
        title = khutba['title'] ?? '';
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
        onTap: () => _showKhutbaDetails(khutba),
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
                  child: Icon(
                    khutba['icon'] as IconData,
                    color: Colors.white,
                    size: responsive.textLarge,
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
                            khutba['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: AppColors.emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              title,
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

  void _showKhutbaDetails(Map<String, dynamic> khutba) {
    final details = khutba['details'] as Map<String, String>;
    AdNavigator.push(context, BasicAmalDetailScreen(
      title: khutba['title'] ?? '',
      titleUrdu: khutba['titleUrdu'] ?? '',
      titleHindi: khutba['titleHindi'] ?? '',
      titleArabic: khutba['titleArabic'] ?? '',
      contentEnglish: details['english'] ?? '',
      contentUrdu: details['urdu'] ?? '',
      contentHindi: details['hindi'] ?? '',
      contentArabic: details['arabic'] ?? '',
      color: khutba['color'] as Color,
      icon: khutba['icon'] as IconData,
      categoryKey: 'category_khutba',
    ));
  }
}
