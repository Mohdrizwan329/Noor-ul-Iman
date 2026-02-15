import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/adhan_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ContentService _contentService = ContentService();
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  NotificationsScreenContentFirestore? _content;
  bool _isContentLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final content = await _contentService.getNotificationsScreenContent();
      if (mounted) {
        setState(() {
          _content = content;
          _isContentLoading = false;
        });
        _loadNotifications();
      }
    } catch (e) {
      debugPrint('Error loading notifications content from Firebase: $e');
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
        _loadNotifications();
      }
    }
  }

  String get _langCode =>
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  /// Get translated string from Firebase only
  String _t(String key) {
    if (_content == null) return '';
    return _content!.getString(key, _langCode);
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final adhanProvider = context.read<AdhanProvider>();

      // Ensure notifications are scheduled (triggers saving past ones to received)
      if (adhanProvider.isInitialized) {
        await adhanProvider.scheduleAllIslamicNotifications();
      }

      // Load received notifications from storage
      await adhanProvider.loadReceivedNotifications();
      final receivedNotifications = adhanProvider.receivedNotifications;

      final List<NotificationItem> items = [];

      // Convert received notifications to NotificationItem
      for (final notification in receivedNotifications) {
        NotificationType type = _getTypeFromString(notification.type);
        NotificationCategory category = _getCategoryFromType(type);

        items.add(
          NotificationItem(
            id: notification.id,
            title: notification.title,
            body: notification.body,
            type: type,
            category: category,
            receivedAt: notification.receivedAt,
            isUpcoming: false,
          ),
        );
      }

      // Also load upcoming/pending notifications to show scheduled ones
      final pendingNotifications = await adhanProvider.getPendingNotifications();
      debugPrint('Pending notifications: ${pendingNotifications.length}');

      for (final pending in pendingNotifications) {
        final pendingId = pending.id;

        // Skip if already in received list
        if (items.any((n) => n.id == pendingId)) continue;

        // Determine type based on notification ID ranges
        NotificationType type = NotificationType.prayer;
        if (pendingId == 300) {
          type = NotificationType.quran;
        } else if (pendingId == 301) {
          type = NotificationType.dhikr;
        } else if (pendingId == 302) {
          type = NotificationType.dua;
        } else if (pendingId == 303) {
          type = NotificationType.reminder;
        } else if (pendingId == 304) {
          type = NotificationType.charity;
        } else if (pendingId == 305) {
          type = NotificationType.morningSummary;
        } else if (pendingId == 306) {
          type = NotificationType.sadqa;
        } else if (pendingId == 307) {
          type = NotificationType.jumma;
        } else if (pendingId >= 400) {
          type = NotificationType.festival;
        }

        items.add(
          NotificationItem(
            id: pendingId,
            title: pending.title ?? _t('scheduled_notification'),
            body: pending.body ?? '',
            type: type,
            category: _getCategoryFromType(type),
            receivedAt: DateTime.now(),
            isUpcoming: true,
          ),
        );
      }

      // Mark all notifications as read when screen opens
      await adhanProvider.markAllAsRead();

      if (mounted) {
        setState(() {
          _notifications = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      if (mounted) {
        setState(() {
          _notifications = [];
          _isLoading = false;
        });
      }
    }
  }

  NotificationType _getTypeFromString(String type) {
    switch (type) {
      case 'prayer':
        return NotificationType.prayer;
      case 'quran':
        return NotificationType.quran;
      case 'dhikr':
        return NotificationType.dhikr;
      case 'charity':
        return NotificationType.charity;
      case 'dua':
        return NotificationType.dua;
      case 'festival':
        return NotificationType.festival;
      case 'jumma':
        return NotificationType.jumma;
      case 'sadqa':
        return NotificationType.sadqa;
      case 'morning_summary':
        return NotificationType.morningSummary;
      default:
        return NotificationType.reminder;
    }
  }

  NotificationCategory _getCategoryFromType(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return NotificationCategory.prayer;
      case NotificationType.festival:
      case NotificationType.jumma:
        return NotificationCategory.festival;
      default:
        return NotificationCategory.reminder;
    }
  }

  // Format only time (HH:MM AM/PM) - all from Firebase
  String _formatTimeOnly(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? _t('pm') : _t('am');
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:$minute $period';
  }

  // Get day header text for grouping - all data from Firebase
  String _getDayHeader(DateTime dateTime) {
    if (_content == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notificationDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    final difference = today.difference(notificationDate).inDays;

    if (difference == 0) {
      return _t('today');
    } else if (difference == 1) {
      return _t('yesterday');
    } else if (difference < 7) {
      final days = [
        'sunday',
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
      ];
      return _content!.getDayName(days[dateTime.weekday % 7], _langCode);
    } else {
      final monthAbbr = _content!.getMonthAbbr(dateTime.month - 1, _langCode);
      return '${dateTime.day} $monthAbbr ${dateTime.year}';
    }
  }

  // Get date key for grouping (without time)
  String _getDateKey(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  // Group notifications by day
  Map<String, List<NotificationItem>> _groupNotificationsByDay() {
    final Map<String, List<NotificationItem>> grouped = {};

    for (final notification in _notifications) {
      final dateKey = _getDateKey(notification.receivedAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRtl =
        languageProvider.languageCode == 'ar' ||
        languageProvider.languageCode == 'ur';

    if (_isContentLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(''),
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            _t('notifications'),
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
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : _notifications.isEmpty
                    ? _buildEmptyState(context, responsive)
                    : _buildNotificationsList(context, responsive),
              ),
              const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    ResponsiveUtils responsive,
  ) {
    // Group notifications by day
    final groupedNotifications = _groupNotificationsByDay();

    // Sort date keys (newest first)
    final sortedDateKeys = groupedNotifications.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: AppColors.primary,
      child: ListView.builder(
        padding: responsive.paddingRegular,
        itemCount: AdListHelper.totalCount(sortedDateKeys.length),
        itemBuilder: (context, index) {
          if (AdListHelper.isAdPosition(index)) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: BannerAdWidget(height: 250),
            );
          }
          final dataIdx = AdListHelper.dataIndex(index);
          final dateKey = sortedDateKeys[dataIdx];
          final dayNotificationsList = groupedNotifications[dateKey];

          // Skip if null or empty
          if (dayNotificationsList == null || dayNotificationsList.isEmpty) {
            return const SizedBox.shrink();
          }

          // Create a copy and sort (to avoid modifying original list)
          final dayNotifications = List<NotificationItem>.from(
            dayNotificationsList,
          )..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

          // Get the day header text from the first notification
          final dayHeader = _getDayHeader(dayNotifications.first.receivedAt);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day Header
              _buildDayHeader(context, dayHeader, responsive),
              SizedBox(height: responsive.spaceSmall),

              // Notifications for this day
              ...dayNotifications.map(
                (notification) => _buildNotificationCard(
                  context,
                  notification,
                  responsive,
                ),
              ),
              SizedBox(height: responsive.spaceMedium),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayHeader(
    BuildContext context,
    String dayName,
    ResponsiveUtils responsive,
  ) {
    return Container(
      padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: AppColors.primary,
            size: responsive.iconSmall,
          ),
          SizedBox(width: responsive.spaceSmall),
          Expanded(
            child: Text(
              dayName,
              style: TextStyle(
                fontSize: responsive.textLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNotification(NotificationItem notification) async {
    // Delete from storage
    final adhanProvider = context.read<AdhanProvider>();
    await adhanProvider.deleteReceivedNotification(notification.id);

    // Remove from local list
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });
  }

  void _showDeleteConfirmation(
    BuildContext context,
    NotificationItem notification,
    ResponsiveUtils responsive,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
        ),
        title: Text(
          _t('delete_notification'),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          _t('delete_notification_confirm'),
          style: TextStyle(color: AppColors.primary, fontSize: responsive.textRegular),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              _t('cancel'),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: responsive.textRegular,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteNotification(notification);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              _t('delete'),
              style: TextStyle(color: AppColors.primary, fontSize: responsive.textRegular),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem notification,
    ResponsiveUtils responsive,
  ) {
    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: responsive.spaceSmall),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: responsive.spaceLarge),
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: responsive.iconLarge,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                title: Text(
                  _t('delete_notification'),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  _t('delete_notification_confirm'),
                  style: TextStyle(color: AppColors.primary, fontSize: responsive.textRegular),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(
                      _t('cancel'),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: responsive.textRegular,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _t('delete'),
                      style: TextStyle(color: AppColors.primary, fontSize: responsive.textRegular),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (direction) {
        _deleteNotification(notification);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('notification_deleted')),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.spaceSmall),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          border: Border.all(
            color: AppColors.lightGreenBorder,
            width: 1,
          ),
          boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: responsive.paddingSymmetric(
            horizontal: 12,
            vertical: 0,
          ),
          leading: Container(
            width: responsive.spacing(36),
            height: responsive.spacing(36),
            decoration: BoxDecoration(
              color: _getTypeColor(notification.type).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(responsive.radiusSmall),
            ),
            child: Icon(
              _getTypeIcon(notification.type),
              color: _getTypeColor(notification.type),
              size: responsive.iconMedium,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: responsive.textRegular,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: responsive.spacing(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.spacing(4)),
                Row(
                  children: [
                    if (notification.isUpcoming) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _t('upcoming'),
                          style: TextStyle(
                            fontSize: responsive.textXSmall,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.spaceSmall),
                    ],
                    Text(
                      notification.isUpcoming
                          ? _t('scheduled')
                          : _formatTimeOnly(notification.receivedAt),
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: null,
          onLongPress: () =>
              _showDeleteConfirmation(context, notification, responsive),
        ),
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return Icons.mosque;
      case NotificationType.quran:
        return Icons.menu_book;
      case NotificationType.dhikr:
        return Icons.favorite;
      case NotificationType.charity:
        return Icons.volunteer_activism;
      case NotificationType.dua:
        return Icons.front_hand;
      case NotificationType.reminder:
        return Icons.lightbulb_outline;
      case NotificationType.festival:
        return Icons.celebration;
      case NotificationType.jumma:
        return Icons.mosque_outlined;
      case NotificationType.sadqa:
        return Icons.card_giftcard;
      case NotificationType.morningSummary:
        return Icons.wb_sunny;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return AppColors.primary;
      case NotificationType.quran:
        return Colors.teal;
      case NotificationType.dhikr:
        return Colors.pink;
      case NotificationType.charity:
        return Colors.orange;
      case NotificationType.dua:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.blue;
      case NotificationType.festival:
        return Colors.amber;
      case NotificationType.jumma:
        return Colors.green;
      case NotificationType.sadqa:
        return Colors.deepOrange;
      case NotificationType.morningSummary:
        return Colors.amber.shade700;
    }
  }

  Widget _buildEmptyState(
    BuildContext context,
    ResponsiveUtils responsive,
  ) {
    return Center(
      child: Padding(
        padding: responsive.paddingAll(32),
        child: Container(
          padding: responsive.paddingAll(24),
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
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: responsive.spacing(100),
                height: responsive.spacing(100),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: responsive.iconXXLarge,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: responsive.spaceLarge),
              Text(
                _t('no_notifications'),
                style: TextStyle(
                  fontSize: responsive.textXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: responsive.spaceMedium),
              Text(
                _t('all_caught_up'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum NotificationType {
  prayer,
  quran,
  dhikr,
  charity,
  dua,
  reminder,
  festival,
  jumma,
  sadqa,
  morningSummary,
}

enum NotificationCategory { prayer, reminder, festival }

class NotificationItem {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationCategory category;
  final DateTime receivedAt;
  final bool isUpcoming;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.category,
    required this.receivedAt,
    this.isUpcoming = false,
  });
}
