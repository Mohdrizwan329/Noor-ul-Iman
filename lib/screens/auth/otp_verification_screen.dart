import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/auth_provider.dart';
import '../../screens/main/main_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 4) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyPhoneOtp(
      verificationId: widget.verificationId,
      otp: otp,
      context: context,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to main screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildOtpField(int index) {
    final responsive = context.responsive;

    return Container(
      width: responsive.spacing(60),
      height: responsive.spacing(70),
      decoration: AppDecorations.card(
        context,
        borderRadius: responsive.radiusMedium,
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.heading1(context),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusMedium),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Auto-verify when all 4 digits are entered
          if (index == 3 && value.length == 1) {
            _verifyOtp();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final authProvider = context.watch<AuthProvider>();

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
            Text(context.tr('verify_otp')),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.paddingAll(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              responsive.vSpaceLarge,
              // Icon
              Container(
                width: responsive.spacing(100),
                height: responsive.spacing(100),
                decoration: AppDecorations.primaryContainer(
                  context,
                  opacity: 0.1,
                ),
                child: Icon(
                  Icons.phone_android,
                  size: responsive.iconXXLarge,
                  color: AppColors.primary,
                ),
              ),
              responsive.vSpaceLarge,
              // Title
              Text(
                context.tr('verify_otp'),
                style: AppTextStyles.heading1(context),
              ),
              responsive.vSpaceSmall,
              // Instructions
              Text(
                context.tr('otp_sent_to'),
                style: AppTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),
              responsive.vSpaceXSmall,
              Text(widget.phoneNumber, style: AppTextStyles.heading3(context)),
              responsive.vSpaceLarge,
              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpField(index)),
              ),
              responsive.vSpaceLarge,
              // Verify Button
              SizedBox(
                width: double.infinity,
                height: responsive.spacing(56),
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _verifyOtp,
                  style: AppButtonStyles.primary(context),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          context.tr('verify_otp'),
                          style: AppTextStyles.button(context),
                        ),
                ),
              ),
              responsive.vSpaceMedium,
              // Resend OTP
              TextButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () {
                        // TODO: Implement resend OTP
                      },
                style: AppButtonStyles.text(context),
                child: Text(
                  context.tr('resend_otp'),
                  style: AppTextStyles.link(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
