import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ContentService _contentService = ContentService();
  AboutScreenContentFirestore? _aboutContent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await _contentService.getAboutScreenContent();
    if (mounted) {
      setState(() {
        _aboutContent = content;
        _isLoading = false;
      });
    }
  }

  String _t(String key) {
    final langCode = Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).languageCode;
    if (_aboutContent != null) {
      return _aboutContent!.getString(key, langCode);
    }
    return key;
  }

  /// Map icon name string from Firebase to IconData
  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'access_time':
        return Icons.access_time;
      case 'explore':
        return Icons.explore;
      case 'menu_book':
        return Icons.menu_book;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'front_hand':
        return Icons.front_hand;
      case 'radio_button_checked':
        return Icons.radio_button_checked;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'star':
        return Icons.star;
      case 'calculate':
        return Icons.calculate;
      case 'restaurant':
        return Icons.restaurant;
      case 'mosque':
        return Icons.mosque;
      case 'nightlight_round':
        return Icons.nightlight_round;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRtl =
        languageProvider.languageCode == 'ar' ||
        languageProvider.languageCode == 'ur';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isLoading ? '' : _t('about'),
            style: TextStyle(color: Colors.white, fontSize: responsive.textLarge),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: responsive.paddingRegular,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: responsive.spaceLarge),

                            // App Logo
                            Container(
                              width: responsive.spacing(120),
                              height: responsive.spacing(120),
                              decoration: BoxDecoration(
                                gradient: AppColors.headerGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.mosque,
                                color: Colors.white,
                                size: responsive.iconSize(60),
                              ),
                            ),
                            SizedBox(height: responsive.spaceLarge),

                            // All sections in a single card
                            Container(
                              width: double.infinity,
                              padding: responsive.paddingLarge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(responsive.radiusLarge),
                                border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // About App
                                  _buildSectionHeader(responsive, _t('about_app')),
                                  SizedBox(height: responsive.spacing(4)),
                                  Text(
                                    _t('about_app_description'),
                                    style: TextStyle(
                                      fontSize: responsive.fontSize(13),
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),

                                  Divider(height: responsive.spacing(24), color: AppColors.lightGreenBorder),

                                  // Features
                                  _buildSectionHeader(responsive, _t('app_features')),
                                  SizedBox(height: responsive.spacing(8)),
                                  ..._aboutContent!.features.map(
                                    (feature) => _buildFeatureItem(
                                      context,
                                      responsive: responsive,
                                      icon: _getIcon(feature.icon),
                                      text: _t(feature.key),
                                    ),
                                  ),

                                  Divider(height: responsive.spacing(24), color: AppColors.lightGreenBorder),

                                  // Mission
                                  _buildSectionHeader(responsive, _t('our_mission')),
                                  SizedBox(height: responsive.spacing(4)),
                                  Text(
                                    _t('mission_description'),
                                    style: TextStyle(
                                      fontSize: responsive.fontSize(13),
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),

                                  Divider(height: responsive.spacing(24), color: AppColors.lightGreenBorder),

                                  // Developed with Love
                                  Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: responsive.iconSize(28),
                                        ),
                                        SizedBox(height: responsive.spacing(4)),
                                        Text(
                                          _t('developed_with_love'),
                                          style: TextStyle(
                                            fontSize: responsive.fontSize(15),
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(height: responsive.spacing(4)),
                                        Text(
                                          _t('made_for_ummah'),
                                          style: TextStyle(
                                            fontSize: responsive.fontSize(13),
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: responsive.spaceLarge),

                            // Copyright
                            Text(
                              _t('copyright_text'),
                              style: TextStyle(
                                fontSize: responsive.textSmall,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: responsive.spaceSmall),
                            Text(
                              _t('all_rights_reserved'),
                              style: TextStyle(
                                fontSize: responsive.textSmall,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: responsive.spaceXXLarge),
                          ],
                        ),
                      ),
              ),
              const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ResponsiveUtils responsive, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: responsive.fontSize(15),
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required ResponsiveUtils responsive,
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spacing(6)),
      child: Row(
        children: [
          Container(
            width: responsive.spacing(36),
            height: responsive.spacing(36),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: responsive.iconSize(18),
            ),
          ),
          SizedBox(width: responsive.spaceRegular),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: responsive.textRegular,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
