import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prayer request added. May Allah accept your dua!'),
        backgroundColor: AppColors.primary,
      ),
    );
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alhamdulillah! Prayer marked as answered.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteRequest(PrayerRequest request) {
    setState(() {
      _myRequests.removeWhere((r) => r.id == request.id);
    });
    _saveRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 50,
        title: const Text('Prayer Requests'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active Prayers'),
            Tab(text: 'Answered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestsList(false),
          _buildRequestsList(true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRequestDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Prayer'),
      ),
    );
  }

  Widget _buildRequestsList(bool answered) {
    final requests = _myRequests.where((r) => r.isAnswered == answered).toList();

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              answered ? Icons.check_circle_outline : Icons.volunteer_activism,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              answered
                  ? 'No answered prayers yet'
                  : 'No active prayer requests',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (!answered) ...[
              const SizedBox(height: 8),
              Text(
                'Tap + to add your first prayer request',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(requests[index]);
      },
    );
  }

  Widget _buildRequestCard(PrayerRequest request) {
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
            title: const Text('Delete Prayer Request'),
            content: const Text('Are you sure you want to delete this prayer request?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteRequest(request),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(request.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.category,
                      style: TextStyle(
                        color: _getCategoryColor(request.category),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (request.isAnswered)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Answered',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.text,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(request.createdAt),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  if (request.answeredAt != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.check, size: 14, color: Colors.green[400]),
                    const SizedBox(width: 4),
                    Text(
                      'Answered ${_formatDate(request.answeredAt!)}',
                      style: TextStyle(color: Colors.green[400], fontSize: 12),
                    ),
                  ],
                  const Spacer(),
                  if (!request.isAnswered)
                    TextButton.icon(
                      onPressed: () => _markAsAnswered(request),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Mark Answered'),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddRequestDialog() {
    _selectedCategory = 'General';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'New Prayer Request',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share your prayer with Allah. He is the All-Hearing, the All-Knowing.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Category Selection
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
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
              const SizedBox(height: 24),

              // Prayer Request Text
              TextField(
                controller: _requestController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your prayer request...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Prayer Request'),
                ),
              ),
            ],
          ),
        ),
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
