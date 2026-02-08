import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/countries.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    // Filter out Israel from countries list
    final filteredCountries = countries.where((country) => country.code != 'IL').toList();

    return IntlPhoneField(
      controller: controller,
      enabled: enabled,
      countries: filteredCountries,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: responsive.textMedium,
        ),
        labelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: responsive.textMedium,
        ),
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
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: TextStyle(
          fontSize: responsive.textSmall,
          color: Colors.red,
        ),
      ),
      style: TextStyle(
        fontSize: responsive.textMedium,
        color: Colors.black87,
      ),
      dropdownTextStyle: TextStyle(
        fontSize: responsive.textMedium,
        color: Colors.black87,
      ),
      initialCountryCode: 'IN',
      dropdownIconPosition: IconPosition.trailing,
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.primary,
      ),
      flagsButtonPadding: const EdgeInsets.only(left: 12),
      showCountryFlag: true,
      showDropdownIcon: true,
      onChanged: (phone) {
        if (onChanged != null) {
          onChanged!(phone.completeNumber);
        }
      },
      validator: (phone) {
        if (validator != null) {
          return validator!(phone?.completeNumber);
        }
        return null;
      },
    );
  }
}
