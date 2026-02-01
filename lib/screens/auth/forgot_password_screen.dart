import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
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
      if (result['success'] != true) {}
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
            SizedBox(width: responsive.spacing(8)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: responsive.spacing(100),
                      height: responsive.spacing(100),
                      decoration: AppDecorations.circularIcon(context),
                      child: Icon(
                        Icons.lock_reset,
                        size: responsive.iconSize(48),
                        color: isDark
                            ? const Color(0xFF5C6BC0)
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Title
                  Center(
                    child: Text(
                      context.tr('reset_password'),
                      style: AppTextStyles.whiteHeading(context),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(8)),
                  // Instructions
                  Center(
                    child: Text(
                      context.tr('reset_password_instructions'),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.whiteBody(context, opacity: 0.9),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Email Field
                  AuthTextField(
                    controller: _emailController,
                    hintText: context.tr('enter_email'),
                    labelText: context.tr('email'),
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        Validators.validateEmail(value, context),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Send Reset Link Button
                  SizedBox(
                    width: double.infinity,
                    height: responsive.spacing(56),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendResetLink,
                      style: AppButtonStyles.white(context),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: isDark
                                  ? const Color(0xFF5C6BC0)
                                  : const Color(0xFF4CAF50),
                            )
                          : Text(
                              context.tr('send_reset_link'),
                              style: TextStyle(
                                fontSize: responsive.fontSize(18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(12)),
                  // Back to Sign In
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        context.tr('sign_in'),
                        style: AppTextStyles.whiteBody(
                          context,
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
