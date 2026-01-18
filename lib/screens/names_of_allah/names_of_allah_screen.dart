import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/allah_name_model.dart';
import '../../providers/settings_provider.dart';
import 'name_of_allah_detail_screen.dart';

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key});

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AllahNameModel> _filteredNames = AllahNames.names;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNames = AllahNames.names;
      } else {
        _filteredNames = AllahNames.names.where((name) {
          return name.transliteration.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              name.meaning.toLowerCase().contains(query.toLowerCase()) ||
              name.number.toString() == query;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Names of Allah'),
      ),
      body: Column(
        children: [
          // Header Info Card

          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.grey.shade700
                      : const Color(0xFF8AAF9A),
                  width: 1.5,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(
                            0xFF0A5C36,
                          ).withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterNames,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by name, meaning or number...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textHint,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF0A5C36),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterNames('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Names Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Showing ${_filteredNames.length} of 99 names',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Names List
          Expanded(
            child: _filteredNames.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No names found',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredNames.length,
                    itemBuilder: (context, index) {
                      return _buildNameCard(_filteredNames[index], isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard(AllahNameModel name, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: InkWell(
        onTap: () => _showNameDetail(name),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Number Badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.emeraldGreen
                      : AppColors.primaryDark,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isDark
                                  ? AppColors.emeraldGreen
                                  : AppColors.primaryDark)
                              .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${name.number}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // English Info (Left)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.transliteration,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        name.meaning,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.emeraldGreen,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Arabic Name (Right)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Amiri',
                      color: isDark ? AppColors.secondary : AppColors.secondary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.emeraldGreen
                          : AppColors.emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
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

  void _showNameDetail(AllahNameModel name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameOfAllahDetailScreen(name: name),
      ),
    );
  }
}
