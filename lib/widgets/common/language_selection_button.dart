import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Reusable language selection button with popup menu
/// Used in Quran, Hadith, and other screens that support multiple languages
class LanguageSelectionButton extends StatelessWidget {
  final String currentLanguage;
  final List<LanguageOption> languages;
  final Function(String) onLanguageChanged;
  final IconData? icon;
  final bool showLabel;

  const LanguageSelectionButton({
    super.key,
    required this.currentLanguage,
    required this.languages,
    required this.onLanguageChanged,
    this.icon,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.darkCard : Colors.white,
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : AppColors.primary,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.language,
              color: Colors.white,
              size: 16,
            ),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(
                currentLanguage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
      onSelected: onLanguageChanged,
      itemBuilder: (context) => languages.map((lang) {
        final isSelected = currentLanguage == lang.code;
        return PopupMenuItem<String>(
          value: lang.code,
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                lang.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Language option model for the language selection button
class LanguageOption {
  final String code;
  final String name;

  const LanguageOption({
    required this.code,
    required this.name,
  });
}
