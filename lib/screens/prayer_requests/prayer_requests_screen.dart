import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/common/banner_ad_widget.dart';

class PrayerRequestsScreen extends StatefulWidget {
  const PrayerRequestsScreen({super.key});

  @override
  State<PrayerRequestsScreen> createState() => _PrayerRequestsScreenState();
}

class _PrayerRequestsScreenState extends State<PrayerRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PrayerRequest> _myRequests = [];
  final TextEditingController _requestController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Health',
    'Family',
    'Career',
    'Education',
    'Marriage',
    'Guidance',
    'Forgiveness',
    'Gratitude',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('prayer_requests');
    if (data != null) {
      final decoded = json.decode(data) as List;
      setState(() {
        _myRequests = decoded.map((e) => PrayerRequest.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _myRequests.map((e) => e.toJson()).toList();
    await prefs.setString('prayer_requests', json.encode(data));
  }

  void _addRequest() {
    if (_requestController.text.trim().isEmpty) return;

    final request = PrayerRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _requestController.text.trim(),
      category: _selectedCategory,
      createdAt: DateTime.now(),
      isAnswered: false,
    );

    setState(() {
      _myRequests.insert(0, request);
    });
    _saveRequests();
    _requestController.clear();
    Navigator.pop(context);

  }

  void _markAsAnswered(PrayerRequest request) {
    setState(() {
      final index = _myRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _myRequests[index] = request.copyWith(
          isAnswered: true,
          answeredAt: DateTime.now(),
        );
      }
    });
    _saveRequests();

  }

  void _deleteRequest(PrayerRequest request) {
    setState(() {
      _myRequests.removeWhere((r) => r.id == request.id);
    });
    _saveRequests();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 50.0,
        title: Text(
          context.tr('prayer_requests'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontSize: responsive.textMedium),
          tabs: [
            Tab(text: context.tr('active_prayers')),
            Tab(text: context.tr('answered')),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestsList(context, false),
                _buildRequestsList(context, true),
              ],
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRequestDialog,
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, size: responsive.iconMedium),
        label: Text(
          context.tr('new_prayer'),
          style: TextStyle(fontSize: responsive.textMedium),
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, bool answered) {
    final responsive = ResponsiveUtils(context);
    final requests = _myRequests.where((r) => r.isAnswered == answered).toList();

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              answered ? Icons.check_circle_outline : Icons.volunteer_activism,
              size: 64.0,
              color: Colors.grey[400],
            ),
            SizedBox(height: responsive.spaceRegular),
            Text(
              answered
                  ? context.tr('no_answered_prayers')
                  : context.tr('no_active_prayers'),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: responsive.textRegular,
              ),
            ),
            if (!answered) ...[
              SizedBox(height: responsive.spaceSmall),
              Text(
                context.tr('tap_to_add_prayer'),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: responsive.textMedium,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: responsive.paddingRegular,
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(context, requests[index]);
      },
    );
  }

  Widget _buildRequestCard(BuildContext context, PrayerRequest request) {
    final responsive = ResponsiveUtils(context);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Dismissible(
      key: Key(request.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.tr('delete_prayer_request')),
            content: Text(context.tr('delete_prayer_confirmation')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.tr('cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.tr('delete'), style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteRequest(request),
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.spaceMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radiusLarge),
          border: Border.all(color: lightGreenBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: darkGreen.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: responsive.paddingRegular,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: responsive.paddingSymmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(request.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(responsive.radiusMedium),
                    ),
                    child: Text(
                      context.tr(request.category.toLowerCase()),
                      style: TextStyle(
                        color: _getCategoryColor(request.category),
                        fontSize: responsive.textSmall,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (request.isAnswered)
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: responsive.iconXSmall),
                          SizedBox(width: responsive.spaceXSmall),
                          Text(
                            context.tr('answered'),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: responsive.spaceMedium),
              Text(
                request.text,
                style: TextStyle(
                  fontSize: responsive.textRegular,
                  height: 1.5,
                ),
              ),
              SizedBox(height: responsive.spaceMedium),
              Row(
                children: [
                  Icon(Icons.access_time, size: responsive.iconXSmall, color: Colors.grey[500]),
                  SizedBox(width: responsive.spaceXSmall),
                  Text(
                    _formatDate(context, request.createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: responsive.textSmall,
                    ),
                  ),
                  if (request.answeredAt != null) ...[
                    SizedBox(width: responsive.spaceRegular),
                    Icon(Icons.check, size: responsive.iconXSmall, color: Colors.green[400]),
                    SizedBox(width: responsive.spaceXSmall),
                    Text(
                      '${context.tr('answered')} ${_formatDate(context, request.answeredAt!)}',
                      style: TextStyle(
                        color: Colors.green[400],
                        fontSize: responsive.textSmall,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (!request.isAnswered)
                    TextButton.icon(
                      onPressed: () => _markAsAnswered(request),
                      icon: Icon(Icons.check_circle_outline, size: responsive.iconSmall),
                      label: Text(
                        context.tr('mark_answered'),
                        style: TextStyle(fontSize: responsive.textSmall),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Health':
        return Colors.red;
      case 'Family':
        return Colors.pink;
      case 'Career':
        return Colors.blue;
      case 'Education':
        return Colors.purple;
      case 'Marriage':
        return Colors.orange;
      case 'Guidance':
        return Colors.teal;
      case 'Forgiveness':
        return Colors.indigo;
      case 'Gratitude':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return context.tr('today');
    } else if (diff.inDays == 1) {
      return context.tr('yesterday');
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ${context.tr('days_ago')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddRequestDialog() {
    final responsive = ResponsiveUtils(context);
    _selectedCategory = 'General';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.radiusXXLarge)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final responsive = ResponsiveUtils(context);
          return Padding(
            padding: EdgeInsets.only(
              left: responsive.spaceLarge,
              right: responsive.spaceLarge,
              top: responsive.spaceLarge,
              bottom: MediaQuery.of(context).viewInsets.bottom + responsive.spaceLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: responsive.spacing(40),
                    height: responsive.spacing(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(responsive.radiusSmall),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
                Text(
                  context.tr('new_prayer_request'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: responsive.textXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: responsive.spaceSmall),
                Text(
                  context.tr('prayer_request_description'),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: responsive.textMedium,
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),

                // Category Selection
                Text(
                  context.tr('category'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: responsive.textRegular,
                      ),
                ),
                SizedBox(height: responsive.spaceSmall),
                Wrap(
                  spacing: responsive.spaceSmall,
                  runSpacing: responsive.spaceSmall,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(
                        context.tr(category.toLowerCase()),
                        style: TextStyle(fontSize: responsive.textSmall),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: responsive.spaceLarge),

                // Prayer Request Text
                TextField(
                  controller: _requestController,
                  maxLines: 4,
                  style: TextStyle(fontSize: responsive.textMedium),
                  decoration: InputDecoration(
                    hintText: context.tr('write_prayer_request'),
                    hintStyle: TextStyle(fontSize: responsive.textMedium),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusMedium),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: responsive.paddingSymmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.radiusMedium),
                      ),
                    ),
                    child: Text(
                      context.tr('add_prayer_request'),
                      style: TextStyle(fontSize: responsive.textRegular),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PrayerRequest {
  final String id;
  final String text;
  final String category;
  final DateTime createdAt;
  final bool isAnswered;
  final DateTime? answeredAt;

  PrayerRequest({
    required this.id,
    required this.text,
    required this.category,
    required this.createdAt,
    this.isAnswered = false,
    this.answeredAt,
  });

  PrayerRequest copyWith({
    bool? isAnswered,
    DateTime? answeredAt,
  }) {
    return PrayerRequest(
      id: id,
      text: text,
      category: category,
      createdAt: createdAt,
      isAnswered: isAnswered ?? this.isAnswered,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'isAnswered': isAnswered,
        'answeredAt': answeredAt?.toIso8601String(),
      };

  factory PrayerRequest.fromJson(Map<String, dynamic> json) => PrayerRequest(
        id: json['id'],
        text: json['text'],
        category: json['category'],
        createdAt: DateTime.parse(json['createdAt']),
        isAnswered: json['isAnswered'] ?? false,
        answeredAt: json['answeredAt'] != null
            ? DateTime.parse(json['answeredAt'])
            : null,
      );
}
