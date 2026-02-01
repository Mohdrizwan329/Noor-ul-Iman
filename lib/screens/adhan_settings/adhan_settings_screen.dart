import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/adhan_provider.dart';

class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen> {
  bool _batteryOptimizationDisabled = true;

  @override
  void initState() {
    super.initState();
    _checkBatteryOptimization();
  }

  Future<void> _checkBatteryOptimization() async {
    final adhanProvider = context.read<AdhanProvider>();
    final isDisabled = await adhanProvider.isBatteryOptimizationDisabled();
    if (mounted) {
      setState(() {
        _batteryOptimizationDisabled = isDisabled;
      });
    }
  }

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

              // Battery Optimization Warning (Android only)
              if (Platform.isAndroid && !_batteryOptimizationDisabled)
                _buildBatteryWarningCard(context, adhanProvider),

              if (Platform.isAndroid && !_batteryOptimizationDisabled)
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

              // Test Notification Button
              ElevatedButton.icon(
                onPressed: () async {
                  await adhanProvider.showTestNotification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.tr('test_notification_sent')),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.notifications_active, size: responsive.iconMedium),
                label: Text(
                  context.tr('test_notification'),
                  style: TextStyle(fontSize: responsive.textRegular),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: responsive.paddingRegular,
                ),
              ),
              SizedBox(height: responsive.spaceRegular),

              // Test Adhan Button
              if (adhanProvider.adhanSoundEnabled)
                ElevatedButton.icon(
                  onPressed: () {
                    adhanProvider.playAdhan();
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

  Widget _buildBatteryWarningCard(
    BuildContext context,
    AdhanProvider adhanProvider,
  ) {
    final responsive = ResponsiveUtils(context);

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.battery_alert,
                  color: Colors.orange.shade700,
                  size: responsive.iconMedium,
                ),
                SizedBox(width: responsive.spaceSmall),
                Expanded(
                  child: Text(
                    context.tr('battery_optimization'),
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spaceSmall),
            Text(
              context.tr('battery_optimization_message'),
              style: TextStyle(
                fontSize: responsive.textSmall,
                color: Colors.orange.shade900,
              ),
            ),
            SizedBox(height: responsive.spaceRegular),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await adhanProvider.requestDisableBatteryOptimization();
                  // Check again after returning from settings
                  Future.delayed(const Duration(seconds: 1), () {
                    _checkBatteryOptimization();
                  });
                },
                icon: const Icon(Icons.settings),
                label: Text(context.tr('disable_battery_optimization')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
