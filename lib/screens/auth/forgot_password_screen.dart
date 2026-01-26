import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/utils/validators.dart';
import '../../core/services/otp_service.dart';
import '../../widgets/auth/auth_text_field.dart';
import 'otp_password_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use lowercase for consistency
      final email = _emailController.text.trim().toLowerCase();

      // Call OTP Service to send OTP (stores in Firestore)
      final result = await OtpService.sendOtp(email);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      // Always navigate to OTP screen
      // OTP is stored in Firestore and will be displayed on screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpPasswordVerificationScreen(email: email),
        ),
      );

      // Show message about email status
      if (result['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('otp_generated_check_screen')),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Still navigate to OTP screen for testing
      final email = _emailController.text.trim().toLowerCase();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpPasswordVerificationScreen(email: email),
        ),
      );
    }
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Icons.lock_reset,
                        size: responsive.iconXXLarge,
                        color: isDark ? const Color(0xFF5C6BC0) : const Color(0xFF4CAF50),
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
                    context.tr('reset_password_instructions'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.textMedium,
                      color: Colors.white.withAlpha(230),
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
                // Email Field
                AuthTextField(
                  controller: _emailController,
                  hintText: context.tr('enter_email'),
                  labelText: context.tr('email'),
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.validateEmail(value, context),
                ),
                SizedBox(height: responsive.spaceLarge),
                // Send Reset Link Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isDark ? const Color(0xFF5C6BC0) : const Color(0xFF4CAF50),
                      elevation: 8,
                      shadowColor: Colors.black.withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: isDark ? const Color(0xFF5C6BC0) : const Color(0xFF4CAF50),
                          )
                        : Text(
                            context.tr('send_reset_link'),
                            style: TextStyle(
                              fontSize: responsive.textLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: responsive.spaceMedium),
                // Back to Sign In
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      context.tr('sign_in'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
