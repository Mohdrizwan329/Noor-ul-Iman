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
      scrollPadding: const EdgeInsets.all(20),
      style: TextStyle(
        fontSize: responsive.textMedium,
        color: Colors.black87,
        overflow: TextOverflow.visible,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: responsive.textMedium,
        ),
        labelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: responsive.textMedium,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: responsive.fontSize(17),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: AppColors.primary,
          size: responsive.iconMedium,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: responsive.spacing(40),
          minHeight: responsive.spacing(40),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color:
                      Colors.grey.shade600,
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
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: BorderSide(
            color: AppColors.lightGreenBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: BorderSide(
            color: AppColors.lightGreenBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          borderSide: BorderSide(
            color: AppColors.primary,
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
          horizontal: 12,
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
