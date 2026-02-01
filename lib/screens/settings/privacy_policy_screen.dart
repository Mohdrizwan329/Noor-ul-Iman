import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('privacy_policy'),
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(responsive.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
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
                    context.tr('privacy_policy'),
                    style: TextStyle(
                      fontSize: responsive.fontSize(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(8)),
                  Text(
                    'Noor-ul-Iman',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(24)),

            // Privacy Sections
            _buildPrivacyCard(
              context,
              responsive,
              Icons.info_outline,
              context.tr('privacy_intro_title'),
              context.tr('privacy_intro_content'),
            ),
            _buildPrivacyCard(
              context,
              responsive,
              Icons.data_usage,
              context.tr('privacy_data_title'),
              context.tr('privacy_data_content'),
            ),
            _buildPrivacyCard(
              context,
              responsive,
              Icons.location_on_outlined,
              context.tr('privacy_location_title'),
              context.tr('privacy_location_content'),
            ),
            _buildPrivacyCard(
              context,
              responsive,
              Icons.storage_outlined,
              context.tr('privacy_storage_title'),
              context.tr('privacy_storage_content'),
            ),
            _buildPrivacyCard(
              context,
              responsive,
              Icons.security_outlined,
              context.tr('privacy_security_title'),
              context.tr('privacy_security_content'),
            ),
            _buildPrivacyCard(
              context,
              responsive,
              Icons.contact_mail_outlined,
              context.tr('privacy_contact_title'),
              context.tr('privacy_contact_content'),
            ),
            SizedBox(height: responsive.spaceXXLarge),
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
