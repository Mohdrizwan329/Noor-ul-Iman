import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../providers/adhan_provider.dart';
import '../../core/utils/localization_helper.dart';

class AdhanSettingsScreen extends StatelessWidget {
  const AdhanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('adhan_settings'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Consumer<AdhanProvider>(
        builder: (context, adhanProvider, child) {
          return ListView(
            padding: responsive.paddingRegular,
            children: [
              // Notifications Toggle
              _buildSectionCard(
                context,
                title: context.tr('prayer_notifications'),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(context.tr('enable_notifications')),
                      subtitle: Text(context.tr('get_notified_prayer_times')),
                      value: adhanProvider.notificationsEnabled,
                      onChanged: (value) {
                        adhanProvider.setNotificationsEnabled(value);
                      },
                    ),
                    if (adhanProvider.notificationsEnabled) ...[
                      const Divider(),
                      SwitchListTile(
                        title: Text(context.tr('play_adhan_sound')),
                        subtitle: Text(context.tr('play_adhan_notification')),
                        value: adhanProvider.adhanSoundEnabled,
                        onChanged: (value) {
                          adhanProvider.setAdhanSoundEnabled(value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: responsive.spaceRegular),

              // Individual Prayer Notifications
              if (adhanProvider.notificationsEnabled)
                _buildSectionCard(
                  context,
                  title: context.tr('prayer_alerts'),
                  child: Column(
                    children: adhanProvider.prayerNotifications.entries.map((entry) {
                      return SwitchListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontSize: responsive.textRegular),
                        ),
                        value: entry.value,
                        onChanged: (value) {
                          adhanProvider.setPrayerNotification(entry.key, value);
                        },
                      );
                    }).toList(),
                  ),
                ),

              if (adhanProvider.notificationsEnabled &&
                  adhanProvider.adhanSoundEnabled) ...[
                SizedBox(height: responsive.spaceRegular),
                // Adhan Selection
                _buildSectionCard(
                  context,
                  title: context.tr('select_adhan'),
                  child: Column(
                    children: AdhanProvider.adhanOptions.entries.map((entry) {
                      final isSelected = adhanProvider.selectedAdhan == entry.key;
                      return ListTile(
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected ? AppColors.primary : null,
                        ),
                        title: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_outline),
                          onPressed: () {
                            adhanProvider.previewAdhan(entry.key);
                          },
                        ),
                        onTap: () {
                          adhanProvider.setSelectedAdhan(entry.key);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],

              SizedBox(height: responsive.spaceLarge),

              // Test Adhan Button
              if (adhanProvider.adhanSoundEnabled)
                ElevatedButton.icon(
                  onPressed: () {
                    adhanProvider.playAdhan();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.tr('playing_adhan'),
                          style: TextStyle(fontSize: responsive.textMedium),
                        ),
                        action: SnackBarAction(
                          label: context.tr('stop'),
                          onPressed: () {
                            adhanProvider.stopAdhan();
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.volume_up, size: responsive.iconMedium),
                  label: Text(
                    context.tr('test_adhan'),
                    style: TextStyle(fontSize: responsive.textRegular),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: responsive.paddingRegular,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final responsive = ResponsiveUtils(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: responsive.paddingRegular,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
