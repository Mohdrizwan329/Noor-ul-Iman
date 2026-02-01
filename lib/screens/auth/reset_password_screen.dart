import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: responsive.spacing(32),
              height: responsive.spacing(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
              ),
              padding: responsive.paddingAll(4),
              child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
            ),
            responsive.hSpaceSmall,
            Text(context.tr('reset_password')),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.paddingAll(24),
          child: Container(
            decoration: AppDecorations.gradient(context),
            padding: responsive.paddingAll(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: responsive.spacing(100),
                      height: responsive.spacing(100),
                      decoration: AppDecorations.circularIcon(context),
                      child: Icon(
                        Icons.lock_open,
                        size: responsive.iconXXLarge,
                        color: isDark
                            ? const Color(0xFF5C6BC0)
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  responsive.vSpaceLarge,
                  // Title
                  Center(
                    child: Text(
                      context.tr('reset_password'),
                      style: AppTextStyles.whiteHeading(context),
                    ),
                  ),
                  responsive.vSpaceSmall,
                  // Instructions
                  Center(
                    child: Text(
                      '${context.tr('create_new_password_for')}\n${widget.email}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.whiteBody(context, opacity: 0.9),
                    ),
                  ),
                  responsive.vSpaceLarge,
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
                  responsive.vSpaceMedium,
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
                  responsive.vSpaceLarge,
                  // Reset Password Button
                  SizedBox(
                    width: double.infinity,
                    height: responsive.spacing(56),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: AppButtonStyles.white(context),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: isDark
                                  ? const Color(0xFF5C6BC0)
                                  : const Color(0xFF4CAF50),
                            )
                          : Text(
                              context.tr('reset_password'),
                              style: AppTextStyles.button(
                                context,
                                color: isDark
                                    ? const Color(0xFF5C6BC0)
                                    : const Color(0xFF4CAF50),
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
