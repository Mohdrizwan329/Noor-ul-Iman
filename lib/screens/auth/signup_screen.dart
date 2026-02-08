import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/phone_number_field.dart';
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
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  String _completePhoneNumber = '';
  bool _isPhoneInput = false;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_detectInputType);
  }

  @override
  void dispose() {
    _emailController.removeListener(_detectInputType);
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _detectInputType() {
    final text = _emailController.text.trim();
    final startsWithNumber =
        text.isNotEmpty && RegExp(r'^[0-9+]').hasMatch(text);
    if (startsWithNumber && !_isPhoneInput && !_isTransitioning) {
      _emailController.removeListener(_detectInputType);
      _isTransitioning = true;
      _emailController.clear();
      setState(() {
        _isPhoneInput = true;
      });
      _emailController.addListener(_detectInputType);
      Future.delayed(const Duration(milliseconds: 100), () {
        _isTransitioning = false;
      });
    }
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final languageProvider = context.read<LanguageProvider>();

    // Clear any previous errors
    authProvider.clearError();

    final name = _nameController.text.trim();
    final emailOrPhone = _isPhoneInput
        ? _completePhoneNumber
        : _emailController.text.trim();

    final success = await authProvider.signUpWithEmail(
      email: emailOrPhone,
      password: _passwordController.text,
      name: name,
      context: context,
      language: languageProvider.languageCode,
    );

    if (!mounted) return;

    if (success) {
      // Save user name locally before signing out
      if (name.isNotEmpty) {
        context.read<SettingsProvider>().setProfileName(name);
      }
      // Sign out the user immediately after account creation
      await authProvider.signOut();

      if (!mounted) return;

      // Navigate to login screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      // Error is automatically set in AuthProvider and will be displayed
      // Show snackbar for additional feedback
      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

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
            Text(context.tr('sign_up')),
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
                  // Logo
                  Center(
                    child: Container(
                      width: responsive.iconHuge,
                      height: responsive.iconHuge,
                      decoration: AppDecorations.circularIcon(context),
                      padding: responsive.paddingAll(4),
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.appLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Create Account
                  Center(
                    child: Text(
                      context.tr('create_account'),
                      style: TextStyle(
                        fontSize: responsive.fontSize(24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.spacing(20)),
                  // Name Field
                  AuthTextField(
                    controller: _nameController,
                    hintText: context.tr('enter_name'),
                    labelText: context.tr('name'),
                    prefixIcon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('name_required');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: responsive.spacing(12)),
                  // Smart Email/Phone Field
                  if (_isPhoneInput)
                    Builder(
                      builder: (ctx) {
                        final mobileRequired = ctx.tr('mobile_required');
                        final invalidMobile = ctx.tr('invalid_mobile');
                        return PhoneNumberField(
                          controller: _mobileController,
                          labelText: ctx.tr('mobile_number'),
                          hintText: ctx.tr('enter_mobile'),
                          onChanged: (completeNumber) {
                            _completePhoneNumber = completeNumber;
                            if (_mobileController.text.isEmpty &&
                                !_isTransitioning) {
                              setState(() {
                                _isPhoneInput = false;
                                _completePhoneNumber = '';
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return mobileRequired;
                            }
                            if (value.length < 10) {
                              return invalidMobile;
                            }
                            return null;
                          },
                        );
                      },
                    )
                  else
                    AuthTextField(
                      controller: _emailController,
                      hintText: context.tr('enter_email_or_phone'),
                      labelText: context.tr('email'),
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr('email_or_phone_required');
                        }
                        return Validators.validateEmail(value, context);
                      },
                    ),
                  SizedBox(height: responsive.spacing(12)),
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
                  SizedBox(height: responsive.spacing(20)),
                  // Sign Up Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => SizedBox(
                      width: double.infinity,
                      height: responsive.spacing(56),
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : _signUpWithEmail,
                        style: AppButtonStyles.white(
                          context,
                          border: authProvider.isLoading
                              ? const BorderSide(
                                  color: Color(0xFFFFD700),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: authProvider.isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: responsive.spacing(3),
                              )
                            : Text(
                                context.tr('sign_up'),
                                style: TextStyle(
                                  fontSize: responsive.fontSize(18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Divider with "Or"
                  AppDecorations.dividerWithText(
                    context,
                    text: context.tr('or_continue_with'),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Social Sign In Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => SizedBox(
                      width: double.infinity,
                      height: responsive.spacing(56),
                      child: OutlinedButton.icon(
                        onPressed: authProvider.isLoading
                            ? null
                            : _signInWithGoogle,
                        style: AppButtonStyles.outlined(
                          context,
                          borderColor: Colors.white,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withAlpha(25),
                        ),
                        icon: Icon(
                          Icons.g_mobiledata,
                          size: responsive.iconSize(24),
                          color: Colors.white,
                        ),
                        label: Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Sign In Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: responsive.fontSize(16),
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "${context.tr('already_have_account_question')} ",
                            ),
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
