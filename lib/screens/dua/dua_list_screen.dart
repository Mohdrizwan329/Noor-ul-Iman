import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../providers/dua_provider.dart';
import '../../data/models/dua_model.dart';
import '../../widgets/common/common_widgets.dart';
import 'dua_detail_screen.dart';

class DuaListScreen extends StatefulWidget {
  final DuaCategory category;

  const DuaListScreen({super.key, required this.category});

  @override
  State<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DuaModel> get filteredDuas {
    if (_searchQuery.isEmpty) {
      return widget.category.duas;
    }

    final query = _searchQuery.toLowerCase();
    return widget.category.duas.where((dua) {
      return dua.title.toLowerCase().contains(query) ||
          dua.transliteration.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.category.name.replaceAll(RegExp(r'[^\x00-\x7F]+'), '').trim(),
          style: const TextStyle(fontSize: AppDimens.fontSizeXLarge),
        ),
      ),
      body: Column(
        children: [
          // Header Card
          HeaderGradientCard(
            icon: widget.category.icon,
            title: widget.category.name.replaceAll(RegExp(r'[^\x00-\x7F]+'), '').trim(),
            subtitle: '${widget.category.duas.length} Duas',
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: AppStrings.searchInCategory,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          ),
          VSpace.large,

          // Duas List
          Expanded(
            child: filteredDuas.isEmpty
                ? const EmptyStateWidget(
                    message: AppStrings.noDuasFound,
                    icon: Icons.search_off,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
                    itemCount: filteredDuas.length,
                    itemBuilder: (context, index) {
                      final dua = filteredDuas[index];
                      return _buildDuaCard(context, dua, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuaCard(BuildContext context, DuaModel dua, int index) {
    return DuaListCard(
      index: index,
      title: dua.title,
      subtitle: dua.transliteration,
      onTap: () {
        final provider = context.read<DuaProvider>();
        provider.selectDua(dua);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DuaDetailScreen(
              dua: dua,
              category: widget.category,
            ),
          ),
        );
      },
    );
  }
}
