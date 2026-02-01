import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpService {
  // TODO: Replace these with your actual EmailJS credentials after setup
  // Get these from: https://dashboard.emailjs.com/
  static const String _serviceId = 'YOUR_SERVICE_ID'; // e.g., service_abc123
  static const String _templateId = 'YOUR_TEMPLATE_ID'; // e.g., template_xyz789
  static const String _publicKey = 'YOUR_PUBLIC_KEY'; // e.g., abc123xyz789
  static const String _privateKey = 'YOUR_PRIVATE_KEY'; // e.g., pvt_abc123xyz789

  // EmailJS API endpoint
  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  // Firestore instance for OTP storage
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a random 4-digit OTP
  static String _generateOtp() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  /// Send OTP to email using EmailJS
  /// Returns a map with 'success' key (bool) and 'message' or 'error' key (String)
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      // Generate OTP
      final otp = _generateOtp();
      debugPrint('🔑 OTP Generated: $otp for $email');

      // Store OTP in Firestore with 10-minute expiry
      final expiryTime = DateTime.now().add(const Duration(minutes: 10));
      await _firestore.collection('otps').doc(email.toLowerCase()).set({
        'otp': otp,
        'expiryTime': expiryTime.millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      debugPrint('✅ OTP Saved to Firestore: otps/${email.toLowerCase()}');

      // Prepare EmailJS request
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'accessToken': _privateKey,
          'template_params': {
            'to_email': email,
            'otp_code': otp,
          },
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'OTP sent successfully to email',
        };
      } else {
        // Email sending failed, but OTP is still saved in Firestore
        // This allows the OTP to be displayed on screen for verification
        debugPrint('⚠️ Email sending failed, but OTP is saved in Firestore for on-screen display');

        return {
          'success': false,
          'error': 'Email not sent (service not configured), but OTP is available on screen',
        };
      }
    } catch (e) {
      // Even if there's an error, OTP is already saved in Firestore
      // This allows the OTP to be displayed on screen for verification
      debugPrint('⚠️ Email sending error: $e, but OTP is saved in Firestore');

      return {
        'success': false,
        'error': 'Email service error, but OTP is available on screen',
      };
    }
  }

  /// Verify OTP
  /// Returns a map with 'success' key (bool) and 'message' or 'error' key (String)
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      // Get OTP from Firestore
      final otpDoc = await _firestore
          .collection('otps')
          .doc(email.toLowerCase())
          .get();

      if (!otpDoc.exists) {
        return {
          'success': false,
          'error': 'OTP not found or expired',
        };
      }

      final otpData = otpDoc.data() as Map<String, dynamic>;
      final storedOtp = otpData['otp'] as String;
      final expiryTime = otpData['expiryTime'] as int;

      // Check if OTP has expired
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        // Delete expired OTP
        await _firestore.collection('otps').doc(email.toLowerCase()).delete();
        return {
          'success': false,
          'error': 'OTP has expired. Please request a new one.',
        };
      }

      // Verify OTP
      if (storedOtp != otp) {
        return {
          'success': false,
          'error': 'Invalid OTP. Please try again.',
        };
      }

      // OTP is valid - delete it so it can't be reused
      await _firestore.collection('otps').doc(email.toLowerCase()).delete();

      return {
        'success': true,
        'message': 'OTP verified successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Reset password for the given email
  /// Reset password using Firebase Authentication
  /// IMPORTANT: Passwords are managed by Firebase Auth, NOT Firestore
  /// Returns a map with 'success' key (bool) and 'message' or 'error' key (String)
  static Future<Map<String, dynamic>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      // SECURITY NOTE: This method requires the user to be signed in
      // For a proper password reset flow, use Firebase Auth's email reset link
      // This is a simplified version for OTP-based reset

      final auth = FirebaseAuth.instance;

      // First, try to sign in with a temporary credential to verify user exists
      // Note: This won't work without the old password
      // Instead, we'll send a password reset email

      debugPrint('Sending password reset email to: ${email.toLowerCase()}');

      await auth.sendPasswordResetEmail(email: email.toLowerCase());

      return {
        'success': true,
        'message': 'Password reset email sent. Please check your inbox.',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error resetting password: ${e.toString()}',
      };
    }
  }

  /// Clean up expired OTPs (optional utility method)
  static Future<void> cleanupExpiredOtps() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiredOtps = await _firestore
          .collection('otps')
          .where('expiryTime', isLessThan: now)
          .get();

      for (var doc in expiredOtps.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      // Silently fail - cleanup is not critical
    }
  }
}
