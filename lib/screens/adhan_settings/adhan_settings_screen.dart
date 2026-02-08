import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/adhan_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/services/azan_background_service.dart';
import '../../core/services/azan_permission_service.dart';

class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen> {
  bool _batteryOptimizationDisabled = true;
  AzanPermissionStatus? _permissionStatus;
  bool _isPlayingBackgroundAzan = false;

  @override
  void initState() {
    super.initState();
    _checkBatteryOptimization();
    _checkAllPermissions();
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

  Future<void> _checkAllPermissions() async {
    if (!Platform.isAndroid) return;
    final status = await AzanPermissionService.checkAllPermissions();
    if (mounted) {
      setState(() {
        _permissionStatus = status;
        _batteryOptimizationDisabled = status.batteryOptimization;
      });
    }
  }

  Future<void> _testBackgroundAzan() async {
    setState(() => _isPlayingBackgroundAzan = true);
    await AzanBackgroundService.playAzan(prayerName: 'Test');
  }

  Future<void> _stopBackgroundAzan() async {
    await AzanBackgroundService.stopAzan();
    setState(() => _isPlayingBackgroundAzan = false);
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
      body: Column(
        children: [
          Expanded(
            child: Consumer<AdhanProvider>(
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

              // Permission Status Card (Android only)
              if (Platform.isAndroid && _permissionStatus != null)
                _buildPermissionStatusCard(context),

              if (Platform.isAndroid && _permissionStatus != null)
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

              // Test Adhan Button (In-app audio)
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

              // Test Background Azan Button (Native service - works when app closed)
              if (Platform.isAndroid && adhanProvider.adhanSoundEnabled) ...[
                SizedBox(height: responsive.spaceRegular),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isPlayingBackgroundAzan ? null : () async {
                          await _testBackgroundAzan();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('background_azan_started')),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.speaker_phone, size: responsive.iconMedium),
                        label: Text(
                          'Test Background Azan',
                          style: TextStyle(fontSize: responsive.textRegular),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: responsive.paddingRegular,
                        ),
                      ),
                    ),
                    if (_isPlayingBackgroundAzan) ...[
                      SizedBox(width: responsive.spaceSmall),
                      ElevatedButton.icon(
                        onPressed: _stopBackgroundAzan,
                        icon: Icon(Icons.stop, size: responsive.iconMedium),
                        label: Text(
                          'Stop',
                          style: TextStyle(fontSize: responsive.textRegular),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: responsive.paddingRegular,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: responsive.spaceSmall),
                Text(
                  'Background Azan uses native Android service - will play at prayer times even when app is closed',
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          );
        },
            ),
          ),
          const BannerAdWidget(),
        ],
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

  Widget _buildPermissionStatusCard(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final status = _permissionStatus!;
    final allGranted = status.allGranted;

    return Card(
      color: allGranted ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: responsive.paddingRegular,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  allGranted ? Icons.check_circle : Icons.warning,
                  color: allGranted ? Colors.green.shade700 : Colors.red.shade700,
                  size: responsive.iconMedium,
                ),
                SizedBox(width: responsive.spaceSmall),
                Expanded(
                  child: Text(
                    allGranted
                        ? 'All Permissions Granted'
                        : 'Missing Permissions for Background Azan',
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      fontWeight: FontWeight.bold,
                      color: allGranted ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spaceSmall),

            // Permission status list
            _buildPermissionRow(
              context,
              'Exact Alarm',
              status.exactAlarm,
              status.androidVersion >= 31,
              () => AzanPermissionService.requestExactAlarmPermission(),
            ),
            _buildPermissionRow(
              context,
              'Notifications',
              status.notification,
              status.androidVersion >= 33,
              () => AzanPermissionService.requestNotificationPermission(),
            ),
            _buildPermissionRow(
              context,
              'Battery Optimization',
              status.batteryOptimization,
              true,
              () => AzanPermissionService.requestDisableBatteryOptimization(),
            ),

            if (!allGranted) ...[
              SizedBox(height: responsive.spaceRegular),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await AzanPermissionService.requestAllPermissions();
                    Future.delayed(const Duration(seconds: 1), _checkAllPermissions);
                  },
                  icon: const Icon(Icons.security),
                  label: Text(context.tr('grant_all_permissions')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],

            // Autostart settings for Chinese phones
            SizedBox(height: responsive.spaceRegular),
            Container(
              padding: responsive.paddingSmall,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone_android, color: Colors.blue.shade700, size: responsive.iconSmall),
                      SizedBox(width: responsive.spaceSmall),
                      Expanded(
                        child: Text(
                          'Xiaomi, Oppo, Vivo, Huawei, Realme',
                          style: TextStyle(
                            fontSize: responsive.textSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spaceSmall / 2),
                  Text(
                    context.tr('enable_autostart_message'),
                    style: TextStyle(fontSize: responsive.textSmall - 1, color: Colors.blue.shade900),
                  ),
                  SizedBox(height: responsive.spaceSmall),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => AzanPermissionService.openAutoStartSettings(),
                      icon: const Icon(Icons.settings),
                      label: Text(context.tr('open_autostart_settings')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRow(
    BuildContext context,
    String name,
    bool granted,
    bool required,
    VoidCallback onRequest,
  ) {
    final responsive = ResponsiveUtils(context);

    if (!required) {
      return const SizedBox.shrink(); // Not required for this Android version
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spaceSmall / 2),
      child: Row(
        children: [
          Icon(
            granted ? Icons.check : Icons.close,
            color: granted ? Colors.green : Colors.red,
            size: responsive.iconSmall,
          ),
          SizedBox(width: responsive.spaceSmall),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: responsive.textSmall),
            ),
          ),
          if (!granted)
            TextButton(
              onPressed: () async {
                onRequest();
                Future.delayed(const Duration(seconds: 1), _checkAllPermissions);
              },
              child: Text(context.tr('grant')),
            ),
        ],
      ),
    );
  }
}
