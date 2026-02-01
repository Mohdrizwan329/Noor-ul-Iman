import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final bool readOnly;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = ResponsiveUtils(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      textCapitalization: widget.textCapitalization,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      enableInteractiveSelection: true,
      autocorrect: false,
      enableSuggestions: false,
      style: TextStyle(
        fontSize: responsive.textMedium,
        color: isDark ? AppColors.darkTextPrimary : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade500,
          fontSize: responsive.textMedium,
        ),
        labelStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.primary,
          fontSize: responsive.textMedium,
        ),
        floatingLabelStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.primary,
          fontSize: responsive.fontSize(17),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: isDark ? AppColors.darkTextSecondary : AppColors.primary,
          size: responsive.iconMedium,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color:
                      isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  size: responsive.iconMedium,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkTextSecondary : AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: responsive.paddingSymmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: TextStyle(
          fontSize: responsive.textSmall,
          color: Colors.red,
        ),
      ),
    );
  }
}
