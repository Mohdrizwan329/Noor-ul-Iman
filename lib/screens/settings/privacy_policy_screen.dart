import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ContentService _contentService = ContentService();
  PrivacyPolicyScreenContentFirestore? _content;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await _contentService.getPrivacyPolicyScreenContent();
    if (mounted) {
      setState(() {
        _content = content;
        _isLoading = false;
      });
    }
  }

  String _t(String key) {
    final langCode =
        Provider.of<LanguageProvider>(context, listen: false).languageCode;
    if (_content != null) {
      return _content!.getString(key, langCode);
    }
    return key;
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'info_outline':
        return Icons.info_outline;
      case 'data_usage':
        return Icons.data_usage;
      case 'location_on_outlined':
        return Icons.location_on_outlined;
      case 'storage_outlined':
        return Icons.storage_outlined;
      case 'security_outlined':
        return Icons.security_outlined;
      case 'contact_mail_outlined':
        return Icons.contact_mail_outlined;
      default:
        return Icons.article_outlined;
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
            _isLoading ? '' : _t('privacy_policy'),
            style: TextStyle(fontSize: responsive.fontSize(18)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: responsive.paddingRegular,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Card
                          Container(
                            width: double.infinity,
                            padding: responsive.paddingLarge,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryLight,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                responsive.radiusLarge,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.privacy_tip,
                                  color: Colors.white,
                                  size: responsive.iconSize(48),
                                ),
                                SizedBox(height: responsive.spacing(12)),
                                Text(
                                  _t('privacy_policy'),
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(22),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: responsive.spacing(8)),
                                Text(
                                  _t('app_name'),
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(14),
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: responsive.spacing(24)),

                          // Privacy Sections from Firebase
                          ..._content!.sections.map(
                            (section) => _buildPrivacyCard(
                              context,
                              responsive,
                              _getIcon(section.icon),
                              _t(section.titleKey),
                              _t(section.contentKey),
                            ),
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
    );
  }

  Widget _buildPrivacyCard(
    BuildContext context,
    ResponsiveUtils responsive,
    IconData icon,
    String title,
    String content,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: responsive.spacing(16)),
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
          Row(
            children: [
              Container(
                width: responsive.spacing(40),
                height: responsive.spacing(40),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: responsive.iconSize(20),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            content,
            style: TextStyle(
              fontSize: responsive.fontSize(14),
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
