import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_text_field.dart';
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
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      context: context,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to main screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
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

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final responsive = ResponsiveUtils(dialogContext);
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
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
                          controller: emailController,
                          hintText: context.tr('enter_email'),
                          labelText: context.tr('email'),
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              Validators.validateEmail(value, context),
                        ),
                        SizedBox(height: responsive.spaceLarge),
                        // Send Reset Link Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
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

                                      // Check if email exists in Firestore by querying email field
                                      final userQuery = await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .where('email', isEqualTo: email)
                                          .limit(1)
                                          .get();

                                      if (userQuery.docs.isEmpty) {
                                        setState(() => isLoading = false);
                                        if (!context.mounted) return;

                                        // Show error message
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr(
                                                'email_not_registered',
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );
                                        return;
                                      }

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

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error: ${e.toString()}',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: isLoading
                                  ? const Color(0xFFFFD700)
                                  : (isDark
                                        ? const Color(0xFF5C6BC0)
                                        : const Color(0xFF4CAF50)),
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
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
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
    String? errorMessage;

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
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            // Initial OTP fetch
            if (generatedOtp == null && loadingOtp) {
              fetchGeneratedOtp(setState);
            }

            return Dialog(
              backgroundColor: Colors.transparent,
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
                          Icons.mail_lock,
                          size: responsive.iconXXLarge,
                          color: isDark
                              ? const Color(0xFF5C6BC0)
                              : const Color(0xFF4CAF50),
                        ),
                      ),
                      SizedBox(height: responsive.spaceLarge),
                      // Title
                      Text(
                        context.tr('verify_otp'),
                        style: TextStyle(
                          fontSize: responsive.textXXLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: responsive.spaceSmall),
                      // Instructions
                      Text(
                        '${context.tr('enter_4_digit_code_sent_to')}\n$email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.textMedium,
                          color: Colors.white.withAlpha(230),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: responsive.spaceMedium),
                      // Display Generated OTP
                      if (loadingOtp)
                        Column(
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.tr('loading_otp'),
                              style: TextStyle(
                                color: Colors.white.withAlpha(204),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      else if (generatedOtp != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withAlpha(76),
                              width: 1,
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
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.tr('your_otp_code'),
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(204),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                generatedOtp!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.tr('copy_code_below'),
                                style: TextStyle(
                                  color: Colors.white.withAlpha(153),
                                  fontSize: 11,
                                ),
                              ),
                              if (generatedOtp!.contains('Error') ||
                                  generatedOtp!.contains('Unable'))
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        fetchGeneratedOtp(setState),
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    label: Text(
                                      context.tr('retry'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white.withAlpha(
                                        25,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      SizedBox(height: responsive.spaceLarge),
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return SizedBox(
                            width: 60,
                            height: 70,
                            child: TextField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
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
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark
                                        ? const Color(0xFF5C6BC0)
                                        : const Color(0xFF4CAF50),
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                }
                                setState(() => errorMessage = null);
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
                      if (errorMessage != null) ...[
                        SizedBox(height: responsive.spaceSmall),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      SizedBox(height: responsive.spaceLarge),
                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final otp = controllers
                                      .map((c) => c.text)
                                      .join();

                                  if (otp.length != 4) {
                                    setState(() {
                                      errorMessage =
                                          'Please enter complete OTP';
                                    });
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                    errorMessage = null;
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
                                        errorMessage =
                                            result['error'] ??
                                            'Invalid OTP. Please try again.';
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                      errorMessage = 'Error: ${e.toString()}';
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: isLoading
                                ? const Color(0xFFFFD700)
                                : (isDark
                                      ? const Color(0xFF5C6BC0)
                                      : const Color(0xFF4CAF50)),
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : Text(
                                  context.tr('verify_otp'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: responsive.spaceMedium),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
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
                        SizedBox(height: responsive.spaceLarge),
                        // Title
                        Text(
                          context.tr('reset_password'),
                          style: TextStyle(
                            fontSize: responsive.textXXLarge,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: responsive.spaceSmall),
                        // Instructions
                        Text(
                          '${context.tr('create_new_password_for')}\n$email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            color: Colors.white.withAlpha(230),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: responsive.spaceLarge),
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
                        SizedBox(height: responsive.spaceMedium),
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
                        SizedBox(height: responsive.spaceLarge),
                        // Reset Password Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setState(() => isLoading = true);

                                    // Simulate API call
                                    await Future.delayed(
                                      const Duration(seconds: 2),
                                    );

                                    if (!context.mounted) return;

                                    // Close reset password dialog
                                    Navigator.pop(dialogContext);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: isLoading
                                  ? const Color(0xFFFFD700)
                                  : (isDark
                                        ? const Color(0xFF5C6BC0)
                                        : const Color(0xFF4CAF50)),
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
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
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
            );
          },
        );
      },
    );
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
            Text(context.tr('sign_in')),
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
                  // Welcome Back
                  Center(
                    child: Text(
                      context.tr('welcome_back'),
                      style: TextStyle(
                        fontSize: responsive.textXXLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  SizedBox(height: responsive.spaceSmall),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordDialog(),
                      child: Text(
                        context.tr('forgot_password'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.textMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spaceMedium),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : _signInWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: authProvider.isLoading
                            ? const Color(0xFFFFD700)
                            : (isDark
                                  ? const Color(0xFF5C6BC0)
                                  : const Color(0xFF4CAF50)),
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
                              context.tr('sign_in'),
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
                            fontSize: responsive.textMedium,
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
