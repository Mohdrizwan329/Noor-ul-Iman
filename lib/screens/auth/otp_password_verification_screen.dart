import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/services/otp_service.dart';
import 'reset_password_screen.dart';

class OtpPasswordVerificationScreen extends StatefulWidget {
  final String email;

  const OtpPasswordVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpPasswordVerificationScreen> createState() =>
      _OtpPasswordVerificationScreenState();
}

class _OtpPasswordVerificationScreenState
    extends State<OtpPasswordVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;
  String? _generatedOtp; // Store the OTP to display on screen
  bool _loadingOtp = true;

  @override
  void initState() {
    super.initState();
    _fetchGeneratedOtp();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Fetch the generated OTP from Firestore to display on screen
  Future<void> _fetchGeneratedOtp({int retryCount = 0}) async {
    if (retryCount > 5) {
      // Max 5 retries
      setState(() {
        _generatedOtp = 'Unable to load OTP. Please try resending.';
        _loadingOtp = false;
      });
      return;
    }

    setState(() {
      _loadingOtp = true;
      _generatedOtp = null;
    });

    try {
      debugPrint('🔍 Attempt ${retryCount + 1}: Fetching OTP for ${widget.email.toLowerCase()}');

      // Add delay to ensure OTP is saved
      await Future.delayed(const Duration(milliseconds: 500));

      final otpDoc = await FirebaseFirestore.instance
          .collection('otps')
          .doc(widget.email.toLowerCase())
          .get();

      debugPrint('📄 Document exists: ${otpDoc.exists}');

      if (!mounted) return;

      if (otpDoc.exists) {
        final otpData = otpDoc.data() as Map<String, dynamic>;
        final fetchedOtp = otpData['otp'] as String?;

        if (fetchedOtp != null) {
          debugPrint('✅ OTP Fetched Successfully: $fetchedOtp');
          setState(() {
            _generatedOtp = fetchedOtp;
            _loadingOtp = false;
          });
        } else {
          throw Exception('OTP field is null in document');
        }
      } else {
        debugPrint('⏳ OTP not found yet, retrying in 1 second...');
        // Retry after 1 second
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          _fetchGeneratedOtp(retryCount: retryCount + 1);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching OTP: $e');
      debugPrint('Stack trace: $stackTrace');

      if (!mounted) return;

      setState(() {
        _generatedOtp = 'Error loading OTP: ${e.toString()}';
        _loadingOtp = false;
      });
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {
      _errorMessage = null;
    });
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 4) {
      setState(() {
        _errorMessage = 'Please enter complete OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call Cloud Function to verify OTP
      final result = await OtpService.verifyOtp(widget.email, otp);

      if (!mounted) return;

      if (result['success'] == true) {
        // OTP verified, navigate to reset password screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
              email: widget.email,
              otp: otp,
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['error'] ?? 'Invalid OTP. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call Cloud Function to send new OTP
      final result = await OtpService.sendOtp(widget.email);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Always clear fields and fetch new OTP
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      // Fetch and display the new OTP
      await _fetchGeneratedOtp();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success'] == true
                ? context.tr('new_otp_generated_check_screen')
                : context.tr('new_otp_generated_email_not_sent'),
          ),
          backgroundColor: result['success'] == true ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
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
            Text(context.tr('verify_otp')),
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
                      Icons.mail_lock,
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
                    context.tr('verify_otp'),
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
                    '${context.tr('enter_4_digit_code_sent_to')}\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.textMedium,
                      color: Colors.white.withAlpha(230),
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceMedium),
                // Display Generated OTP for Testing
                if (_loadingOtp)
                  Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
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
                    ),
                  )
                else if (_generatedOtp != null)
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
                          _generatedOtp ?? context.tr('loading_otp'),
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
                        // Refresh button if OTP shows error
                        if (_generatedOtp != null && (_generatedOtp!.contains('Error') || _generatedOtp!.contains('Unable')))
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextButton.icon(
                              onPressed: () => _fetchGeneratedOtp(),
                              icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                              label: Text(
                                context.tr('retry'),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withAlpha(25),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
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
                        onChanged: (value) => _onOtpChanged(index, value),
                        onTap: () {
                          _controllers[index].selection = TextSelection.fromPosition(
                            TextPosition(offset: _controllers[index].text.length),
                          );
                        },
                      ),
                    );
                  }),
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: responsive.spaceSmall),
                  Text(
                    _errorMessage!,
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
                    onPressed: _isLoading ? null : _verifyOtp,
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
                Center(
                  child: TextButton(
                    onPressed: _resendOtp,
                    child: Text(
                      context.tr('resend_otp'),
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
    );
  }
}
