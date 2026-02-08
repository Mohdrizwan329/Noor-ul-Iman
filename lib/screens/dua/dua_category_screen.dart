import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/dua_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/dua_model.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'dua_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';

class DuaCategoryScreen extends StatefulWidget {
  const DuaCategoryScreen({super.key});

  @override
  State<DuaCategoryScreen> createState() => _DuaCategoryScreenState();
}

class _DuaCategoryScreenState extends State<DuaCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DuaProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // Watch LanguageProvider to rebuild when language changes
    context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('duas'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Consumer<DuaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final categories = provider.categories;

          if (categories.isEmpty) {
            return Center(child: Text(context.tr('no_duas_available')));
          }

          // Filter categories based on search
          final filteredCategories = _searchQuery.isEmpty
              ? categories
              : categories.where((cat) {
                  if (cat.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  )) {
                    return true;
                  }
                  return cat.duas.any(
                    (dua) =>
                        dua.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        dua.transliteration.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                  );
                }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: responsive.paddingAll(16),
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

              // Categories List with Duas
              Expanded(
                child: filteredCategories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: responsive.iconHuge,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: responsive.spaceRegular),
                            Text(
                              context.tr('no_results_found'),
                              style: TextStyle(
                                fontSize: responsive.textRegular,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: responsive.paddingSymmetric(horizontal: 16),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return _buildCategoryWithDuas(
                            context,
                            category,
                            provider,
                          );
                        },
                      ),
              ),
              const BannerAdWidget(),
            ],
          );
        },
      ),
    );
  }

  // Helper method to convert app language to DuaLanguage enum
  DuaLanguage _getSelectedLanguage(String languageCode) {
    switch (languageCode) {
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

  Widget _buildCategoryWithDuas(
    BuildContext context,
    DuaCategory category,
    DuaProvider provider,
  ) {
    final responsive = context.responsive;
    final langProvider = context.watch<LanguageProvider>();
    final selectedLanguage = _getSelectedLanguage(langProvider.languageCode);
    final languageCode = langProvider.languageCode;
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    // Get display name based on language
    String displayName;
    if (selectedLanguage == DuaLanguage.english) {
      displayName = category.name
          .replaceAll(RegExp(r'[^\x00-\x7F]+'), '')
          .trim();
    } else {
      displayName = category.getName(selectedLanguage);
    }

    return Container(
      margin: responsive.paddingOnly(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Open detail screen with first dua of category
          if (category.duas.isNotEmpty) {
            AdNavigator.push(context, DuaDetailScreen(
              dua: category.duas.first,
              category: category,
            ));
          }
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Category Icon Badge (like Surah number badge)
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: TextStyle(fontSize: responsive.fontSize(24)),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Category Name and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Name (Language-based)
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: (languageCode == 'ur' || languageCode == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Duas count chip
                    Container(
                      padding: responsive.paddingSymmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: lightGreenChip,
                        borderRadius: BorderRadius.circular(
                          responsive.radiusSmall,
                        ),
                      ),
                      child: Text(
                        '${category.duas.length} ${context.tr('duas')}',
                        style: TextStyle(
                          fontSize: responsive.textXSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E8F5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
