import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/allah_name_model.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'name_of_allah_detail_screen.dart';

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key});

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ContentService _contentService = ContentService();
  List<AllahNameModel> _allNames = [];
  List<AllahNameModel> _filteredNames = [];
  bool _isLoading = true;
  Map<String, String> _hindiTransliterations = {};
  Map<String, String> _urduTransliterations = {};

  @override
  void initState() {
    super.initState();
    _loadNames();
    _loadTransliterations();
  }

  Future<void> _loadNames() async {
    setState(() => _isLoading = true);

    try {
      final names = await _contentService.getAllahNamesLegacy();
      if (mounted) {
        setState(() {
          _allNames = names;
          _filteredNames = names;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading Allah names: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadTransliterations() async {
    try {
      final data = await _contentService.getNameTransliterations('allah_names');
      if (data.isNotEmpty && mounted) {
        setState(() {
          _hindiTransliterations = data['hindi'] ?? {};
          _urduTransliterations = data['urdu'] ?? {};
        });
      }
    } catch (e) {
      debugPrint('Error loading transliterations: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNames = _allNames;
      } else {
        _filteredNames = _allNames.where((name) {
          return name.transliteration.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              name.meaning.toLowerCase().contains(query.toLowerCase()) ||
              name.number.toString() == query;
        }).toList();
      }
    });
  }

  String _transliterateToHindi(String text) {
    return _hindiTransliterations[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    return _urduTransliterations[text] ?? text;
  }

  String _getDisplayName(AllahNameModel name, String languageCode) {
    switch (languageCode) {
      case 'ar':
        return name.name; // Arabic: الله، الرَّحْمَنُ
      case 'hi':
        return _transliterateToHindi(name.transliteration); // Hindi: अल्लाह, अर-रहमान
      case 'ur':
        return _transliterateToUrdu(name.transliteration); // Urdu: اللہ، الرحمان
      default:
        return name.transliteration; // English: Allah, Ar-Rahman
    }
  }

  String _getDisplayMeaning(AllahNameModel name, String languageCode) {
    // Return meaning in selected language (not used anymore but kept for future)
    switch (languageCode) {
      case 'ar':
        return name.meaning;
      case 'ur':
        return name.meaningUrdu.isNotEmpty ? name.meaningUrdu : name.meaning;
      case 'hi':
        return name.meaningHindi.isNotEmpty ? name.meaningHindi : name.meaning;
      case 'en':
      default:
        return name.meaning;
    }
  }


  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('names_of_allah'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Column(
        children: [
          // Header Info Card

          // Search Field
          Padding(
            padding: responsive.paddingAll(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: context.tr('search_name_meaning_number'),
              onChanged: _filterNames,
              onClear: () => _filterNames(''),
            ),
          ),

          // Names Count
          Padding(
            padding: responsive.paddingSymmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${context.tr('showing')} ${_filteredNames.length} ${context.tr('of_99_names')}',
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spaceSmall),

          // Names List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNames.isEmpty
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
                          context.tr('no_names_found'),
                          style: TextStyle(
                            fontSize: responsive.textRegular,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(langProvider.languageCode), // Force rebuild when language changes
                    padding: responsive.paddingSymmetric(horizontal: 16),
                    itemCount: _filteredNames.length,
                    itemBuilder: (context, index) {
                      final name = _filteredNames[index];
                      final displayName = _getDisplayName(name, langProvider.languageCode);
                      final displayMeaning = _getDisplayMeaning(name, langProvider.languageCode);
                      return _buildNameCard(
                        name: name,
                        displayName: displayName,
                        displayMeaning: displayMeaning,
                        languageCode: langProvider.languageCode,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard({
    required AllahNameModel name,
    required String displayName,
    required String displayMeaning,
    required String languageCode,
  }) {
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

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
        onTap: () => _showNameDetail(name),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (darkGreen).withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${name.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Name Info
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    fontFamily: languageCode == 'ar'
                        ? 'Poppins'
                        : (languageCode == 'ur' ? 'Poppins' : null),
                  ),
                  textDirection: (languageCode == 'ar' || languageCode == 'ur')
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Arrow only
              Container(
                padding: responsive.paddingAll(6),
                decoration: BoxDecoration(
                  color: emeraldGreen,
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

  void _showNameDetail(AllahNameModel name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NameOfAllahDetailScreen(name: name)),
    );
  }
}
