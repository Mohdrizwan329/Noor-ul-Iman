import 'package:flutter/material.dart';
import '../../core/utils/localization_helper.dart';

enum PasswordStrength { weak, medium, strong }

class Validators {
  // Minimum password length
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Email validation regex - Very permissive, just basic check
  static final RegExp _emailRegex = RegExp(
    r'^.+@.+\..+$',
  );

  // Validate email
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('email_required');
    }

    final trimmedEmail = value.trim().toLowerCase();

    // Basic checks
    if (!trimmedEmail.contains('@')) {
      return context.tr('email_invalid');
    }

    final parts = trimmedEmail.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return context.tr('email_invalid');
    }

    if (!parts[1].contains('.')) {
      return context.tr('email_invalid');
    }

    return null; // Email is valid
  }

  // Validate password
  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('password_required');
    }

    if (value.length < minPasswordLength) {
      return context.tr('password_too_short');
    }

    if (value.length > maxPasswordLength) {
      return 'Password must be less than $maxPasswordLength characters';
    }

    return null;
  }

  // Validate password confirmation
  static String? validateConfirmPassword(
    String? value,
    String password,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return context.tr('password_required');
    }

    if (value != password) {
      return context.tr('passwords_not_match');
    }

    return null;
  }

  // Validate name
  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('name_required');
    }

    final trimmedName = value.trim();
    if (trimmedName.length < minNameLength) {
      return 'Name must be at least $minNameLength characters';
    }

    if (trimmedName.length > maxNameLength) {
      return 'Name must be less than $maxNameLength characters';
    }

    return null;
  }

  // Validate phone number
  static String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('phone_required');
    }

    // Remove spaces and special characters for validation
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it contains only digits and + sign
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(cleanedPhone)) {
      return context.tr('phone_invalid');
    }

    // Extract only the phone number without country code
    final phoneNumberOnly = cleanedPhone.replaceAll(RegExp(r'^\+[0-9]+'), '');

    // Check for exactly 10 digits
    if (phoneNumberOnly.length != 10) {
      return context.tr('phone_must_be_10_digits');
    }

    return null;
  }

  // Check password strength
  static PasswordStrength checkPasswordStrength(String password) {
    if (password.length < minPasswordLength) {
      return PasswordStrength.weak;
    }

    int strengthPoints = 0;

    // Check length
    if (password.length >= 8) strengthPoints++;
    if (password.length >= 12) strengthPoints++;

    // Check for uppercase letters
    if (RegExp(r'[A-Z]').hasMatch(password)) strengthPoints++;

    // Check for lowercase letters
    if (RegExp(r'[a-z]').hasMatch(password)) strengthPoints++;

    // Check for numbers
    if (RegExp(r'[0-9]').hasMatch(password)) strengthPoints++;

    // Check for special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strengthPoints++;

    if (strengthPoints >= 5) {
      return PasswordStrength.strong;
    } else if (strengthPoints >= 3) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.weak;
    }
  }

  // Get password strength text
  static String getPasswordStrengthText(
    PasswordStrength strength,
    BuildContext context,
  ) {
    switch (strength) {
      case PasswordStrength.weak:
        return context.tr('password_strength_weak');
      case PasswordStrength.medium:
        return context.tr('password_strength_medium');
      case PasswordStrength.strong:
        return context.tr('password_strength_strong');
    }
  }

  // Get password strength color
  static Color getPasswordStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  // Sanitize name (remove potentially harmful characters)
  static String sanitizeName(String name) {
    final trimmed = name.trim();
    final cleaned = trimmed.replaceAll(RegExp(r'[<>{}"]'), '');
    final maxLen = cleaned.length > maxNameLength ? maxNameLength : cleaned.length;
    return cleaned.substring(0, maxLen);
  }

  // Sanitize email (trim and lowercase)
  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  // Validate generic required field
  static String? validateRequired(
    String? value,
    String fieldName,
    BuildContext context,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Check if email has valid format (quick check without context)
  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  // Check if password meets minimum requirements
  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength &&
        password.length <= maxPasswordLength;
  }
}
