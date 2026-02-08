import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import 'app_card.dart';

/// Reusable search bar widget with text search and clear button.
class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return AppCard(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
        textInputAction: TextInputAction.search,
        style: AppTextStyles.bodyLarge(context),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.bodyMedium(
            context,
            color: AppColors.textHint,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    setState(() {});
                    widget.onClear?.call();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            borderSide: BorderSide.none,
          ),
          contentPadding: responsive.paddingSymmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
