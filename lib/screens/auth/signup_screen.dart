import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../screens/main/main_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final languageProvider = context.read<LanguageProvider>();

    final success = await authProvider.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      context: context,
      language: languageProvider.languageCode,
    );

    if (!mounted) return;

    if (success) {
      // Sign out the user immediately after account creation
      await authProvider.signOut();

      if (!mounted) return;

      // Show success message and redirect to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('signup_success_please_login')),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );

      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // Show error
      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signInWithGoogle(context);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else if (authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

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
            Text(context.tr('sign_up')),
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
                  // Logo
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
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Applogo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: responsive.spaceLarge),
                // Create Account
                Center(
                  child: Text(
                    context.tr('create_account'),
                    style: TextStyle(
                      fontSize: responsive.textXXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: responsive.spaceLarge),
                // Name Field
                AuthTextField(
                  controller: _nameController,
                  hintText: context.tr('enter_name'),
                  labelText: context.tr('full_name'),
                  prefixIcon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => Validators.validateName(value, context),
                ),
                SizedBox(height: responsive.spaceMedium),
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
                SizedBox(height: responsive.spaceMedium),
                // Password Field
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
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _signUpWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: authProvider.isLoading
                          ? const Color(0xFFFFD700)
                          : (isDark ? const Color(0xFF5C6BC0) : const Color(0xFF4CAF50)),
                      elevation: 8,
                      shadowColor: Colors.black.withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: authProvider.isLoading
                            ? const BorderSide(
                                color: Color(0xFFFFD700),
                                width: 2,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Text(
                            context.tr('sign_up'),
                            style: TextStyle(
                              fontSize: responsive.textLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
                // Divider with "Or"
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0x80FFFFFF),
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: responsive.paddingSymmetric(horizontal: 16),
                      child: Text(
                        context.tr('or_continue_with'),
                        style: TextStyle(
                          color: const Color(0xE6FFFFFF),
                          fontSize: responsive.textSmall,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0x80FFFFFF),
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spaceLarge),
                // Social Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: authProvider.isLoading
                        ? null
                        : _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: responsive.paddingSymmetric(vertical: 12),
                      backgroundColor: Colors.white.withAlpha(25),
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
                // Sign In Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: responsive.textMedium,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: "${context.tr('already_have_account_question')} "),
                          TextSpan(
                            text: context.tr('sign_in'),
                            style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
