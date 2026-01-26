import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/utils/validators.dart';
import '../../widgets/auth/auth_text_field.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call to reset password
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('password_reset_success')),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate to login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
            ),
            const SizedBox(width: 8),
            Text(context.tr('reset_password')),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.paddingAll(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF5C6BC0), const Color(0xFF7986CB)]
                    : [const Color(0xFF81C784), const Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0x40000000)
                      : const Color(0x3081C784),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: responsive.paddingAll(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: responsive.iconSize(100),
                      height: responsive.iconSize(100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.lock_open,
                        size: responsive.iconXXLarge,
                        color: isDark
                            ? const Color(0xFF5C6BC0)
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spaceLarge),
                  // Title
                  Center(
                    child: Text(
                      context.tr('reset_password'),
                      style: TextStyle(
                        fontSize: responsive.textXXLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spaceSmall),
                  // Instructions
                  Center(
                    child: Text(
                      '${context.tr('create_new_password_for')}\n${widget.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        color: Colors.white.withAlpha(230),
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spaceLarge),
                  // New Password Field
                  AuthTextField(
                    controller: _passwordController,
                    hintText: context.tr('enter_password'),
                    labelText: context.tr('password'),
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) =>
                        Validators.validatePassword(value, context),
                  ),
                  SizedBox(height: responsive.spaceMedium),
                  // Confirm Password Field
                  AuthTextField(
                    controller: _confirmPasswordController,
                    hintText: context.tr('enter_password'),
                    labelText: context.tr('confirm_password'),
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                      context,
                    ),
                  ),
                  SizedBox(height: responsive.spaceLarge),
                  // Reset Password Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: isDark
                            ? const Color(0xFF5C6BC0)
                            : const Color(0xFF4CAF50),
                        elevation: 8,
                        shadowColor: Colors.black.withAlpha(80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: isDark
                                  ? const Color(0xFF5C6BC0)
                                  : const Color(0xFF4CAF50),
                            )
                          : Text(
                              context.tr('reset_password'),
                              style: TextStyle(
                                fontSize: responsive.textLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
