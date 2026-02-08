import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

/// A reusable OTP (One-Time Password) input field widget.
/// Features:
/// - Configurable length (default 6 digits)
/// - Auto-focus management between fields
/// - Paste support
/// - Responsive styling
/// - Theme-aware colors
///
/// Example usage:
/// ```dart
/// OTPInputField(
///   length: 6,
///   onCompleted: (otp) {
///     print('OTP: $otp');
///     _verifyOTP(otp);
///   },
/// )
/// ```
class OTPInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final bool enabled;
  final bool autoFocus;

  const OTPInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.enabled = true,
    this.autoFocus = true,
  });

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    // Auto-focus first field
    if (widget.autoFocus && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_focusNodes.isNotEmpty && mounted) {
          _focusNodes[0].requestFocus();
        }
      });
    }
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

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - unfocus and trigger completion
        _focusNodes[index].unfocus();
        _checkCompletion();
      }
    } else if (value.isEmpty) {
      // Move to previous field on backspace
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length > 1) {
      // Handle paste operation
      _handlePaste(value, index);
    }
  }

  void _handlePaste(String value, int startIndex) {
    final digits = value.replaceAll(RegExp(r'\D'), ''); // Keep only digits
    for (
      int i = 0;
      i < digits.length && (startIndex + i) < widget.length;
      i++
    ) {
      _controllers[startIndex + i].text = digits[i];
    }

    // Focus appropriate field
    final lastFilledIndex = (startIndex + digits.length - 1).clamp(
      0,
      widget.length - 1,
    );
    if (lastFilledIndex < widget.length - 1) {
      _focusNodes[lastFilledIndex + 1].requestFocus();
    } else {
      _focusNodes[lastFilledIndex].unfocus();
      _checkCompletion();
    }
  }

  void _checkCompletion() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  Widget _buildOTPBox(BuildContext context, int index) {
    final responsive = context.responsive;

    return Container(
      width: responsive.spacing(60),
      height: responsive.spacing(70),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primary
              : Colors.grey.shade300,
          width: _focusNodes[index].hasFocus ? 2 : 1,
        ),
        boxShadow: _focusNodes[index].hasFocus
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: responsive.textXLarge,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => _buildOTPBox(context, index),
      ),
    );
  }
}
