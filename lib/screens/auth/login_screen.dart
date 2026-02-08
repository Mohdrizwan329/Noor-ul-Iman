import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/phone_number_field.dart';
import '../../screens/main/main_screen.dart';
import 'signup_screen.dart';
import '../../core/services/otp_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPhoneInput = false; // Auto-detect if input is phone number
  String _completePhoneNumber = '';
  bool _isTransitioning = false; // Flag to prevent immediate switch back

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_detectInputType);
  }

  @override
  void dispose() {
    _emailController.removeListener(_detectInputType);
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _detectInputType() {
    final text = _emailController.text.trim();
    // Check if input starts with numbers (phone number)
    final startsWithNumber =
        text.isNotEmpty && RegExp(r'^[0-9+]').hasMatch(text);
    if (startsWithNumber && !_isPhoneInput && !_isTransitioning) {
      // Remove listener temporarily to prevent loop
      _emailController.removeListener(_detectInputType);
      _isTransitioning = true;
      _emailController.clear();
      setState(() {
        _isPhoneInput = true;
      });
      // Re-add listener after state change
      _emailController.addListener(_detectInputType);
      // Reset transition flag after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _isTransitioning = false;
      });
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    // Clear any previous errors
    authProvider.clearError();

    // Get email or phone based on input type
    final emailOrPhone = _isPhoneInput
        ? _completePhoneNumber
        : _emailController.text.trim();

    final success = await authProvider.signInWithEmail(
      email: emailOrPhone,
      password: _passwordController.text,
      context: context,
    );

    if (!mounted) return;

    if (success) {
      // Save user name locally for immediate availability
      final name = authProvider.displayName;
      if (name.isNotEmpty && name != 'User') {
        context.read<SettingsProvider>().setProfileName(name);
      }
      // Navigate to main screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      // Error is automatically set in AuthProvider and will be displayed
      // Scroll to top to make error visible
      if (authProvider.error != null) {
        // Optional: Show snackbar for additional feedback
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
      // Save user name locally for immediate availability
      final name = authProvider.displayName;
      if (name.isNotEmpty && name != 'User') {
        context.read<SettingsProvider>().setProfileName(name);
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final responsive = ResponsiveUtils(dialogContext);

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: responsive.value(
                    mobile: responsive.screenWidth * 0.9,
                    tablet: 600,
                  ),
                  maxHeight: responsive.screenHeight * 0.85,
                ),
                decoration: AppDecorations.gradient(context),
                padding: responsive.paddingAll(32),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                        // Icon
                        Center(
                          child: Container(
                            width: responsive.spacing(100),
                            height: responsive.spacing(100),
                            decoration: AppDecorations.circularIcon(context),
                            child: Icon(
                              Icons.lock_reset,
                              size: responsive.iconSize(48),
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(20)),
                        // Title
                        Center(
                          child: Text(
                            context.tr('reset_password'),
                            style: TextStyle(
                              fontSize: responsive.fontSize(24),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(8)),
                        // Instructions
                        Center(
                          child: Text(
                            context.tr('reset_password_instructions'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.fontSize(16),
                              color: const Color(0xE6FFFFFF),
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(20)),
                        // Email Field
                        AuthTextField(
                          controller: emailController,
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
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setState(() => isLoading = true);

                                    try {
                                      final email = emailController.text
                                          .trim()
                                          .toLowerCase();

                                      // Validate email format
                                      if (!email.contains('@') ||
                                          !email.contains('.')) {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr('email_invalid'),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        setState(() => isLoading = false);
                                        return;
                                      }

                                      // Send OTP directly - Firebase will handle if email doesn't exist
                                      await OtpService.sendOtp(email);

                                      setState(() => isLoading = false);

                                      if (!context.mounted) return;

                                      // Close forgot password dialog
                                      Navigator.pop(dialogContext);

                                      // Show OTP verification dialog
                                      _showOtpVerificationDialog(email);
                                    } catch (e) {
                                      setState(() => isLoading = false);
                                      if (!context.mounted) return;
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: isLoading
                                  ? const Color(0xFFFFD700)
                                  : (const Color(0xFF4CAF50)),
                              elevation: 8,
                              shadowColor: Colors.black.withAlpha(80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: isLoading
                                    ? const BorderSide(
                                        color: Color(0xFFFFD700),
                                        width: 2,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: responsive.spacing(3),
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOtpVerificationDialog(String email) {
    final controllers = List.generate(4, (_) => TextEditingController());
    final focusNodes = List.generate(4, (_) => FocusNode());
    bool isLoading = false;
    String? generatedOtp;
    bool loadingOtp = true;

    // Fetch OTP from Firestore
    Future<void> fetchGeneratedOtp(
      StateSetter setState, {
      int retryCount = 0,
    }) async {
      if (retryCount > 5) {
        setState(() {
          generatedOtp = context.tr('unable_to_load_otp');
          loadingOtp = false;
        });
        return;
      }

      setState(() {
        loadingOtp = true;
        generatedOtp = null;
      });

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final otpDoc = await FirebaseFirestore.instance
            .collection('otps')
            .doc(email.toLowerCase())
            .get();

        if (otpDoc.exists) {
          final otpData = otpDoc.data() as Map<String, dynamic>;
          final fetchedOtp = otpData['otp'] as String?;

          if (fetchedOtp != null) {
            setState(() {
              generatedOtp = fetchedOtp;
              loadingOtp = false;
            });
          } else {
            throw Exception('OTP field is null in document');
          }
        } else {
          await Future.delayed(const Duration(seconds: 1));
          fetchGeneratedOtp(setState, retryCount: retryCount + 1);
        }
      } catch (e) {
        setState(() {
          generatedOtp = '${context.tr('error_loading_otp')}: ${e.toString()}';
          loadingOtp = false;
        });
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final responsive = ResponsiveUtils(dialogContext);

        return StatefulBuilder(
          builder: (context, setState) {
            // Initial OTP fetch
            if (generatedOtp == null && loadingOtp) {
              fetchGeneratedOtp(setState);
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: responsive.value(
                    mobile: responsive.screenWidth * 0.9,
                    tablet: 600,
                  ),
                  maxHeight: responsive.screenHeight * 0.85,
                ),
                decoration: AppDecorations.gradient(context),
                padding: responsive.paddingAll(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                      // Icon
                      Container(
                        width: responsive.spacing(100),
                        height: responsive.spacing(100),
                        decoration: AppDecorations.circularIcon(context),
                        child: Icon(
                          Icons.mail_lock,
                          size: responsive.iconSize(48),
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(20)),
                      // Title
                      Text(
                        context.tr('verify_otp'),
                        style: TextStyle(
                          fontSize: responsive.fontSize(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(8)),
                      // Instructions
                      Text(
                        '${context.tr('enter_4_digit_code_sent_to')}\n$email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.fontSize(16),
                          color: const Color(0xE6FFFFFF),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(12)),
                      // Display Generated OTP
                      if (loadingOtp)
                        Column(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: responsive.spacing(2),
                            ),
                            SizedBox(height: responsive.spacing(8)),
                            Text(
                              context.tr('loading_otp'),
                              style: TextStyle(
                                fontSize: responsive.fontSize(12),
                                color: const Color(0xB3FFFFFF),
                              ),
                            ),
                          ],
                        )
                      else if (generatedOtp != null)
                        Container(
                          padding: responsive.paddingAll(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(12),
                            ),
                            border: Border.all(
                              color: Colors.white.withAlpha(76),
                              width: responsive.spacing(1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: Colors.white.withAlpha(204),
                                    size: responsive.iconSize(16),
                                  ),
                                  SizedBox(width: responsive.spacing(8)),
                                  Text(
                                    context.tr('your_otp_code'),
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(204),
                                      fontSize: responsive.fontSize(12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: responsive.spacing(8)),
                              Text(
                                generatedOtp!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.fontSize(32),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: responsive.spacing(8),
                                ),
                              ),
                              SizedBox(height: responsive.spacing(4)),
                              Text(
                                context.tr('copy_code_below'),
                                style: TextStyle(
                                  color: Colors.white.withAlpha(153),
                                  fontSize: responsive.fontSize(11),
                                ),
                              ),
                              if (generatedOtp!.contains('Error') ||
                                  generatedOtp!.contains('Unable'))
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: responsive.spacing(12),
                                  ),
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        fetchGeneratedOtp(setState),
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: responsive.iconSize(16),
                                    ),
                                    label: Text(
                                      context.tr('retry'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsive.fontSize(12),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white.withAlpha(
                                        25,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.spacing(16),
                                        vertical: responsive.spacing(8),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      SizedBox(height: responsive.spacing(20)),
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return SizedBox(
                            width: responsive.spacing(60),
                            height: responsive.spacing(70),
                            child: TextField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: responsive.fontSize(24),
                                fontWeight: FontWeight.bold,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(12),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(12),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(12),
                                  ),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF4CAF50),
                                    width: responsive.spacing(2),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                }
                              },
                              onTap: () {
                                controllers[index].selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: controllers[index].text.length,
                                      ),
                                    );
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: responsive.spacing(20)),
                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: responsive.spacing(56),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final otp = controllers
                                      .map((c) => c.text)
                                      .join();

                                  if (otp.length != 4) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.tr('enter_complete_otp'),
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    final result = await OtpService.verifyOtp(
                                      email,
                                      otp,
                                    );

                                    if (!context.mounted) return;

                                    if (result['success'] == true) {
                                      // Close OTP dialog
                                      Navigator.pop(dialogContext);

                                      // Show reset password dialog
                                      _showResetPasswordDialog(email, otp);
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            result['error'] ??
                                                context.tr('invalid_otp_try_again'),
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${context.tr('error')}: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                          style: AppButtonStyles.white(
                            context,
                            border: isLoading
                                ? const BorderSide(
                                    color: Color(0xFFFFD700),
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: responsive.spacing(3),
                                )
                              : Text(
                                  context.tr('verify_otp'),
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(12)),
                      // Resend OTP
                      TextButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          try {
                            await OtpService.sendOtp(email);

                            setState(() => isLoading = false);

                            for (var controller in controllers) {
                              controller.clear();
                            }
                            focusNodes[0].requestFocus();

                            fetchGeneratedOtp(setState);
                          } catch (e) {
                            setState(() => isLoading = false);
                          }
                        },
                        child: Text(
                          context.tr('resend_otp'),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.fontSize(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showResetPasswordDialog(String email, String otp) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final responsive = ResponsiveUtils(dialogContext);

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: AppDecorations.gradient(context),
                padding: responsive.paddingAll(32),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                        // Icon
                        Container(
                          width: responsive.spacing(100),
                          height: responsive.spacing(100),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(50),
                                blurRadius: responsive.spacing(15),
                                offset: Offset(0, responsive.spacing(5)),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.lock_open,
                            size: responsive.iconSize(48),
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(20)),
                        // Title
                        Text(
                          context.tr('reset_password'),
                          style: TextStyle(
                            fontSize: responsive.fontSize(24),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: responsive.spacing(8)),
                        // Instructions
                        Text(
                          '${context.tr('create_new_password_for')}\n$email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.fontSize(16),
                            color: const Color(0xE6FFFFFF),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(20)),
                        // New Password Field
                        AuthTextField(
                          controller: passwordController,
                          hintText: context.tr('enter_password'),
                          labelText: context.tr('password'),
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) =>
                              Validators.validatePassword(value, context),
                        ),
                        SizedBox(height: responsive.spacing(12)),
                        // Confirm Password Field
                        AuthTextField(
                          controller: confirmPasswordController,
                          hintText: context.tr('enter_password'),
                          labelText: context.tr('confirm_password'),
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) =>
                              Validators.validateConfirmPassword(
                                value,
                                passwordController.text,
                                context,
                              ),
                        ),
                        SizedBox(height: responsive.spacing(20)),
                        // Reset Password Button
                        SizedBox(
                          width: double.infinity,
                          height: responsive.spacing(56),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setState(() => isLoading = true);

                                    try {
                                      final result =
                                          await OtpService.resetPassword(
                                            email,
                                            passwordController.text,
                                          );

                                      setState(() => isLoading = false);

                                      if (!context.mounted) return;

                                      if (result['success'] == true) {
                                        // Close reset password dialog
                                        Navigator.pop(dialogContext);
                                      }
                                    } catch (e) {
                                      setState(() => isLoading = false);
                                      if (!context.mounted) return;
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: isLoading
                                  ? const Color(0xFFFFD700)
                                  : (const Color(0xFF4CAF50)),
                              elevation: 8,
                              shadowColor: Colors.black.withAlpha(80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  responsive.borderRadius(16),
                                ),
                                side: isLoading
                                    ? BorderSide(
                                        color: const Color(0xFFFFD700),
                                        width: responsive.spacing(2),
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: responsive.spacing(3),
                                  )
                                : Text(
                                    context.tr('reset_password'),
                                    style: TextStyle(
                                      fontSize: responsive.fontSize(18),
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
            );
          },
        );
      },
    );
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
            Text(context.tr('sign_in')),
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
                      width: responsive.spacing(100),
                      height: responsive.spacing(100),
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
                  // Welcome Back
                  Center(
                    child: Text(
                      context.tr('welcome_back'),
                      style: TextStyle(
                        fontSize: responsive.fontSize(24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: responsive.spacing(20)),
                  // Smart Email/Phone Input Field
                  if (_isPhoneInput)
                    Builder(
                      builder: (ctx) {
                        // Store translations before validator callback
                        final mobileRequired = ctx.tr('mobile_required');
                        final invalidMobile = ctx.tr('invalid_mobile');
                        return PhoneNumberField(
                          controller: _phoneController,
                          labelText: ctx.tr('mobile_number'),
                          hintText: ctx.tr('enter_mobile'),
                          onChanged: (completeNumber) {
                            _completePhoneNumber = completeNumber;
                            // Switch back to email if phone is empty
                            if (_phoneController.text.isEmpty &&
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
                  SizedBox(height: responsive.spacing(8)),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordDialog(),
                      child: Text(
                        context.tr('forgot_password'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.fontSize(16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(12)),
                  // Sign In Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => SizedBox(
                      width: double.infinity,
                      height: responsive.spacing(56),
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : _signInWithEmail,
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
                                context.tr('sign_in'),
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
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.fontSize(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Sign Up Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
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
                                  "${context.tr('dont_have_account_question')} ",
                            ),
                            TextSpan(
                              text: context.tr('sign_up'),
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
