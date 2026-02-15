import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/otp_service.dart';
import 'reset_password_screen.dart';

class OtpPasswordVerificationScreen extends StatefulWidget {
  final String email;

  const OtpPasswordVerificationScreen({super.key, required this.email});

  @override
  State<OtpPasswordVerificationScreen> createState() =>
      _OtpPasswordVerificationScreenState();
}

class _OtpPasswordVerificationScreenState
    extends State<OtpPasswordVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
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
      debugPrint(
        '🔍 Attempt ${retryCount + 1}: Fetching OTP for ${widget.email.toLowerCase()}',
      );

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
            builder: (_) => ResetPasswordScreen(email: widget.email, otp: otp),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['error'] ?? context.tr('invalid_otp_try_again');
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = '${context.tr('error')}: ${e.toString()}';
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
      await OtpService.sendOtp(widget.email);

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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
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
            Text(context.tr('verify_otp')),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.paddingAll(24),
          child: Container(
            decoration: AppDecorations.gradient(context),
            padding: responsive.paddingAll(32),
            child: Column(
              children: [
                // Icon
                Center(
                  child: Container(
                    width: responsive.spacing(100),
                    height: responsive.spacing(100),
                    decoration: AppDecorations.circularIcon(context),
                    child: Icon(
                      Icons.mail_lock,
                      size: responsive.iconXXLarge,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spacing(20)),
                // Title
                Center(
                  child: Text(
                    context.tr('verify_otp'),
                    style: AppTextStyles.whiteHeading(context),
                  ),
                ),
                SizedBox(height: responsive.spacing(8)),
                // Instructions
                Center(
                  child: Text(
                    '${context.tr('enter_4_digit_code_sent_to')}\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.whiteBody(context, opacity: 0.9),
                  ),
                ),
                SizedBox(height: responsive.spacing(12)),
                // Display Generated OTP for Testing
                if (_loadingOtp)
                  Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: responsive.spacing(2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.tr('loading_otp'),
                          style: AppTextStyles.whiteCaption(context),
                        ),
                      ],
                    ),
                  )
                else if (_generatedOtp != null)
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
                          _generatedOtp ?? context.tr('loading_otp'),
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
                        // Refresh button if OTP shows error
                        if (_generatedOtp != null &&
                            (_generatedOtp!.contains('Error') ||
                                _generatedOtp!.contains('Unable')))
                          Padding(
                            padding: EdgeInsets.only(
                              top: responsive.spacing(12),
                            ),
                            child: TextButton.icon(
                              onPressed: () => _fetchGeneratedOtp(),
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
                                backgroundColor: Colors.white.withAlpha(25),
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
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          color: AppColors.primary,
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
                        onChanged: (value) => _onOtpChanged(index, value),
                        onTap: () {
                          _controllers[index].selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                  offset: _controllers[index].text.length,
                                ),
                              );
                        },
                      ),
                    );
                  }),
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: responsive.spacing(8)),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
                SizedBox(height: responsive.spacing(20)),
                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: responsive.spacing(56),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4CAF50),
                      elevation: 8,
                      shadowColor: Colors.black.withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(16),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: const Color(0xFF4CAF50),
                          )
                        : Text(
                            context.tr('verify_otp'),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: responsive.fontSize(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: responsive.spacing(12)),
                // Resend OTP
                Center(
                  child: TextButton(
                    onPressed: _resendOtp,
                    child: Text(
                      context.tr('resend_otp'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.fontSize(16),
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
