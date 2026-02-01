import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
            context.tr('about'),
            style: TextStyle(fontSize: responsive.textLarge),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                        color: AppColors.primary.withValues(alpha: 0.3),
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

                // App Description Card
                _buildInfoCard(
                  context,
                  responsive: responsive,
                  title: context.tr('about_app'),
                  child: Text(
                    context.tr('about_app_description'),
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: responsive.spaceRegular),

                // Features Card
                _buildInfoCard(
                  context,
                  responsive: responsive,
                  title: context.tr('app_features'),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.access_time,
                        text: context.tr('feature_prayer_times'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.explore,
                        text: context.tr('feature_qibla_compass'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.menu_book,
                        text: context.tr('feature_quran'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.auto_stories,
                        text: context.tr('feature_hadith'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.front_hand,
                        text: context.tr('feature_duas'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.radio_button_checked,
                        text: context.tr('feature_tasbih'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.calendar_month,
                        text: context.tr('feature_calendar'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.star,
                        text: context.tr('feature_99_names'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.calculate,
                        text: context.tr('feature_zakat'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.restaurant,
                        text: context.tr('feature_halal_finder'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.mosque,
                        text: context.tr('feature_mosque_finder'),
                      ),
                      _buildFeatureItem(
                        context,
                        responsive: responsive,
                        icon: Icons.nightlight_round,
                        text: context.tr('feature_ramadan_tracker'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.spaceRegular),

                // Mission Card
                _buildInfoCard(
                  context,
                  responsive: responsive,
                  title: context.tr('our_mission'),
                  child: Text(
                    context.tr('mission_description'),
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: responsive.spaceRegular),

                // Developer Info Card
                _buildInfoCard(
                  context,
                  responsive: responsive,
                  title: context.tr('developed_with_love'),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: responsive.iconSize(32),
                      ),
                      SizedBox(height: responsive.spaceSmall),
                      Text(
                        context.tr('made_for_ummah'),
                        style: TextStyle(
                          fontSize: responsive.textRegular,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),

                // Copyright
                Text(
                  '© 2025 Noor-ul-Iman',
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.spaceSmall),
                Text(
                  context.tr('all_rights_reserved'),
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
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required ResponsiveUtils responsive,
    required String title,
    required Widget child,
  }) {
    return Container(
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
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.textLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.spaceRegular),
          child,
        ],
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
