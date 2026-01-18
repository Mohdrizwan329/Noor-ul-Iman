import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/adhan_provider.dart';

class AdhanSettingsScreen extends StatelessWidget {
  const AdhanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhan Settings'),
      ),
      body: Consumer<AdhanProvider>(
        builder: (context, adhanProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Notifications Toggle
              _buildSectionCard(
                context,
                title: 'Prayer Notifications',
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Notifications'),
                      subtitle: const Text('Get notified at prayer times'),
                      value: adhanProvider.notificationsEnabled,
                      onChanged: (value) {
                        adhanProvider.setNotificationsEnabled(value);
                      },
                    ),
                    if (adhanProvider.notificationsEnabled) ...[
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Play Adhan Sound'),
                        subtitle: const Text('Play adhan when notification arrives'),
                        value: adhanProvider.adhanSoundEnabled,
                        onChanged: (value) {
                          adhanProvider.setAdhanSoundEnabled(value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Individual Prayer Notifications
              if (adhanProvider.notificationsEnabled)
                _buildSectionCard(
                  context,
                  title: 'Prayer Alerts',
                  child: Column(
                    children: adhanProvider.prayerNotifications.entries.map((entry) {
                      return SwitchListTile(
                        title: Text(entry.key),
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
                const SizedBox(height: 16),
                // Adhan Selection
                _buildSectionCard(
                  context,
                  title: 'Select Adhan',
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

              const SizedBox(height: 24),

              // Test Adhan Button
              if (adhanProvider.adhanSoundEnabled)
                ElevatedButton.icon(
                  onPressed: () {
                    adhanProvider.playAdhan();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Playing Adhan...'),
                        action: SnackBarAction(
                          label: 'Stop',
                          onPressed: () {
                            adhanProvider.stopAdhan();
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Test Adhan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
