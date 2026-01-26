import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import '../utils/localization_helper.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign in error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name.trim());
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign up error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Check if running on web
      if (kIsWeb) {
        // Web implementation
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile implementation
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // User canceled the sign-in
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Google sign in error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  // Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    try {
      // Check if platform supports Apple Sign In
      if (!kIsWeb && !Platform.isIOS && !Platform.isMacOS) {
        throw UnsupportedError('Apple Sign In is only supported on iOS, macOS, and web');
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // Update display name if provided and not already set
      if (userCredential.user != null) {
        final user = userCredential.user!;
        if ((user.displayName == null || user.displayName!.isEmpty) &&
            appleCredential.givenName != null) {
          final fullName = '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'.trim();
          if (fullName.isNotEmpty) {
            await user.updateDisplayName(fullName);
            await user.reload();
          }
        }
      }

      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('Apple sign in authorization error: ${e.code} - ${e.message}');
      rethrow;
    } on FirebaseAuthException catch (e) {
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Apple sign in error: $e');
      rethrow;
    }
  }

  // Sign in with Phone Number
  Future<String?> signInWithPhone({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      String? verificationId;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          debugPrint('Phone verification completed automatically');
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Phone verification failed: ${e.code} - ${e.message}');
          throw e;
        },
        codeSent: (String verId, int? resendToken) {
          debugPrint('OTP code sent to $phoneNumber');
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {
          debugPrint('Code auto-retrieval timeout');
          verificationId = verId;
        },
        timeout: const Duration(seconds: 60),
      );

      // Wait for codeSent to be called
      int attempts = 0;
      while (verificationId == null && attempts < 60) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      return verificationId;
    } on FirebaseAuthException catch (e) {
      debugPrint('Phone sign in error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Phone sign in error: $e');
      rethrow;
    }
  }

  // Verify Phone OTP
  Future<UserCredential?> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('OTP verification error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('OTP verification error: $e');
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Password reset error: $e');
      rethrow;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      debugPrint('Email verification error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Delete account error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Delete account error: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
        await user.reload();
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      rethrow;
    }
  }

  // Get user-friendly error message
  String getErrorMessage(dynamic error, BuildContext context) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return context.tr('auth_error_user_not_found');
        case 'wrong-password':
          return context.tr('auth_error_wrong_password');
        case 'email-already-in-use':
          return context.tr('auth_error_email_in_use');
        case 'weak-password':
          return context.tr('auth_error_weak_password');
        case 'invalid-email':
          return context.tr('auth_error_invalid_email');
        case 'network-request-failed':
          return context.tr('auth_error_network');
        case 'user-disabled':
          return 'This account has been disabled';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        case 'invalid-credential':
          return 'Invalid credentials. Please try again';
        case 'account-exists-with-different-credential':
          return 'An account already exists with this email';
        case 'requires-recent-login':
          return 'Please sign in again to perform this action';
        case 'invalid-phone-number':
          return context.tr('auth_error_invalid_phone');
        case 'invalid-verification-code':
          return context.tr('auth_error_invalid_otp');
        case 'session-expired':
          return context.tr('auth_error_otp_expired');
        default:
          debugPrint('Unhandled Firebase Auth error: ${error.code}');
          return context.tr('auth_error_unknown');
      }
    } else if (error is SignInWithAppleAuthorizationException) {
      switch (error.code) {
        case AuthorizationErrorCode.canceled:
          return 'Apple Sign In was canceled';
        case AuthorizationErrorCode.failed:
          return 'Apple Sign In failed';
        case AuthorizationErrorCode.invalidResponse:
          return 'Invalid response from Apple';
        case AuthorizationErrorCode.notHandled:
          return 'Apple Sign In not handled';
        case AuthorizationErrorCode.unknown:
          return 'Unknown error with Apple Sign In';
        default:
          return 'Apple Sign In error';
      }
    }

    return context.tr('auth_error_unknown');
  }

  // Check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email.trim());
      return methods.isNotEmpty;
    } catch (e) {
      debugPrint('Check email error: $e');
      return false;
    }
  }

  // Reload current user
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      debugPrint('Reload user error: $e');
    }
  }

  // Get ID token
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      return await _auth.currentUser?.getIdToken(forceRefresh);
    } catch (e) {
      debugPrint('Get ID token error: $e');
      return null;
    }
  }
}
