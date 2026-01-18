import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import 'app_card.dart';

/// Reusable search bar widget that automatically handles dark mode styling.
/// Replaces repeated search bar patterns across 10+ screens.
///
/// Example usage:
/// ```dart
/// SearchBarWidget(
///   controller: _searchController,
///   hintText: 'Search...',
///   onChanged: (value) => _filterItems(value),
///   onClear: () => _clearSearch(),
/// )
/// ```
class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? suffixIcon;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.suffixIcon,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          setState(() {}); // Rebuild to show/hide clear button
          widget.onChanged?.call(value);
        },
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textHint,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    setState(() {});
                    widget.onClear?.call();
                  },
                )
              : widget.suffixIcon,
          filled: true,
          fillColor: isDark ? AppColors.darkCard : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
            vertical: AppDimens.paddingMedium,
          ),
        ),
      ),
    );
  }
}
