import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/dua_provider.dart';
import '../../providers/language_provider.dart';
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

  // Helper method to convert app language to DuaLanguage enum
  DuaLanguage _getSelectedLanguage(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();
    switch (langProvider.languageCode) {
      case 'hi':
        return DuaLanguage.hindi;
      case 'ur':
        return DuaLanguage.urdu;
      case 'ar':
        return DuaLanguage.arabic;
      case 'en':
      default:
        return DuaLanguage.english;
    }
  }

  // Helper method to get Dua title based on language
  String _getDuaTitle(DuaModel dua, DuaLanguage language) {
    switch (language) {
      case DuaLanguage.urdu:
        return dua.titleUrdu ?? dua.title;
      case DuaLanguage.hindi:
        return dua.titleHindi ?? dua.title;
      case DuaLanguage.arabic:
        return dua.titleUrdu ?? dua.title; // Arabic users will see Urdu or English title
      case DuaLanguage.english:
        return dua.title;
    }
  }

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
    final responsive = context.responsive;
    // Watch LanguageProvider to rebuild when language changes
    context.watch<LanguageProvider>();
    final selectedLanguage = _getSelectedLanguage(context);

    // Get translated category name
    String categoryDisplayName = widget.category.name
        .replaceAll(RegExp(r'[^\x00-\x7F]+'), '')
        .trim();
    final translatedCategoryName = widget.category.getName(selectedLanguage);
    if (selectedLanguage != DuaLanguage.english &&
        translatedCategoryName != categoryDisplayName) {
      categoryDisplayName = translatedCategoryName;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          categoryDisplayName,
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontFamily: selectedLanguage == DuaLanguage.urdu
                ? 'NotoNastaliq'
                : selectedLanguage == DuaLanguage.arabic
                    ? 'Amiri'
                    : null,
          ),
          textDirection: (selectedLanguage == DuaLanguage.urdu ||
                         selectedLanguage == DuaLanguage.arabic)
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
      ),
      body: Column(
        children: [
          // Header Card
          HeaderGradientCard(
            icon: widget.category.icon,
            title: categoryDisplayName,
            subtitle: '${widget.category.duas.length} ${context.tr('duas')}',
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_duas'),
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
              enableVoiceSearch: true,
            ),
          ),
          VSpace.large,

          // Duas List
          Expanded(
            child: filteredDuas.isEmpty
                ? EmptyStateWidget(
                    message: context.tr('no_duas_found'),
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
    final selectedLanguage = _getSelectedLanguage(context);
    return DuaListCard(
      index: index,
      title: _getDuaTitle(dua, selectedLanguage),
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
