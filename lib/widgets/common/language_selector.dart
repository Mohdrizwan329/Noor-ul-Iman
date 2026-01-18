import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/utils/spacing.dart';

/// Reusable language selector widget.
/// Used in Quran, Dua, and other screens for language selection.
///
/// Example usage:
/// ```dart
/// LanguageSelector<Language>(
///   selectedLanguage: _selectedLanguage,
///   languageNames: {
///     Language.arabic: 'عربی',
///     Language.urdu: 'اردو',
///     Language.english: 'English',
///   },
///   onLanguageChanged: (language) {
///     setState(() => _selectedLanguage = language);
///   },
/// )
/// ```
class LanguageSelector<T> extends StatelessWidget {
  final T selectedLanguage;
  final Map<T, String> languageNames;
  final ValueChanged<T> onLanguageChanged;
  final Color? backgroundColor;
  final Color? textColor;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.languageNames,
    required this.onLanguageChanged,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingSmall,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: (backgroundColor ?? Colors.white).withValues(alpha: AppDimens.opacityMedium),
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageNames[selectedLanguage] ?? '',
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            HSpace.small,
            Icon(
              Icons.arrow_drop_down,
              color: textColor ?? Colors.white,
              size: AppDimens.iconSizeSmall,
            ),
          ],
        ),
      ),
      onSelected: onLanguageChanged,
      itemBuilder: (context) {
        return languageNames.entries.map((entry) {
          final isSelected = selectedLanguage == entry.key;
          return PopupMenuItem<T>(
            value: entry.key,
            child: Row(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: AppDimens.iconSizeSmall,
                  )
                else
                  const SizedBox(width: AppDimens.iconSizeSmall),
                HSpace.small,
                Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : null,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
