import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../core/services/firebase_auth_service.dart';
import '../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  // Dependencies
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SharedPreferences keys
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _nameKey = 'user_name';
  static const String _authTokenKey = 'auth_token';

  // Private state
  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  StreamSubscription<User?>? _authStateSubscription;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;
  String? get userId => _firebaseUser?.uid;
  String? get userEmail => _firebaseUser?.email;
  String get displayName =>
      _userModel?.name ?? _firebaseUser?.displayName ?? 'User';

  // Get localized display name based on preferred language
  String getLocalizedDisplayName(String? currentLanguage) {
    if (_userModel != null) {
      return _userModel!.getLocalizedName(currentLanguage);
    }
    return _firebaseUser?.displayName ?? 'User';
  }

  bool get isEmailVerified => _firebaseUser?.emailVerified ?? false;

  // Initialize provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check for existing Firebase session
      await _checkExistingSession();

      // Listen to auth state changes
      _authStateSubscription = _authService.authStateChanges.listen(
        _onAuthStateChanged,
        onError: (error) {
          debugPrint('Auth state change error: $error');
          _error = 'Authentication state error';
          notifyListeners();
        },
      );

      _isInitialized = true;
    } catch (e) {
      _error = 'Initialization failed: $e';
      debugPrint('AuthProvider initialization error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Check for existing session
  Future<void> _checkExistingSession() async {
    try {
      _firebaseUser = _authService.currentUser;

      if (_firebaseUser != null) {
        // Load user data from Firestore
        await _loadUserFromFirestore(_firebaseUser!.uid);

        // Save session data
        await _saveAuthSession();
      } else {
        // Try to restore from SharedPreferences (for offline check)
        await _loadAuthSession();
      }
    } catch (e) {
      debugPrint('Check existing session error: $e');
    }
  }

  // Handle auth state changes
  void _onAuthStateChanged(User? user) {
    _firebaseUser = user;

    if (user != null) {
      _loadUserFromFirestore(user.uid);
      _saveAuthSession();
    } else {
      _userModel = null;
      _clearAuthSession();
    }

    notifyListeners();
  }

  // Load user data from Firestore
  Future<void> _loadUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        _userModel = UserModel.fromFirestore(doc);
      } else if (_firebaseUser != null) {
        // Create new user document if doesn't exist
        _userModel = UserModel.fromFirebaseUser(_firebaseUser!);
        await _syncUserToFirestore();
      }
    } catch (e) {
      debugPrint('Load user from Firestore error: $e');
      // Fallback to Firebase user data
      if (_firebaseUser != null) {
        _userModel = UserModel.fromFirebaseUser(_firebaseUser!);
      }
    }
  }

  // Sync user to Firestore
  Future<void> _syncUserToFirestore() async {
    if (_userModel == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userModel!.id)
          .set(_userModel!.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Sync user to Firestore error: $e');
    }
  }

  // Save auth session to SharedPreferences
  Future<void> _saveAuthSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_firebaseUser != null) {
        final token = await _authService.getIdToken();

        await prefs.setString(_userIdKey, _firebaseUser!.uid);
        await prefs.setString(_emailKey, _firebaseUser!.email ?? '');
        await prefs.setString(_nameKey, displayName);
        if (token != null) {
          await prefs.setString(_authTokenKey, token);
        }
      }
    } catch (e) {
      debugPrint('Save auth session error: $e');
    }
  }

  // Load auth session from SharedPreferences
  Future<void> _loadAuthSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);

      // If we have a saved user ID but no Firebase user,
      // Firebase will handle restoration on next network connection
      if (userId != null && _firebaseUser == null) {
        debugPrint('Found cached user ID: $userId');
      }
    } catch (e) {
      debugPrint('Load auth session error: $e');
    }
  }

  // Clear auth session
  Future<void> _clearAuthSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_emailKey);
      await prefs.remove(_nameKey);
      await prefs.remove(_authTokenKey);
      await prefs.remove('permissions_granted');
      debugPrint('🔓 Auth session and permissions flag cleared');
    } catch (e) {
      debugPrint('Clear auth session error: $e');
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔐 Attempting sign in for: ${email.trim().toLowerCase()}');

      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (credential?.user != null) {
        debugPrint('✅ Sign in successful, loading user data...');
        _firebaseUser = credential!.user;
        await _loadUserFromFirestore(_firebaseUser!.uid);
        await _saveAuthSession();

        debugPrint('✅ User data loaded, sign in complete');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      debugPrint('❌ Sign in failed: credential is null');
      _error = 'Sign in failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      // Always try to get error message, use context if mounted
      try {
        if (context.mounted) {
          _error = _authService.getErrorMessage(e, context);
        } else {
          _error = 'Sign in failed. Please check your credentials and try again.';
        }
      } catch (_) {
        _error = 'Sign in failed: ${e.toString()}';
      }
      debugPrint('❌ Error message: $_error');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
    String? language,
    String? nameEnglish,
    String? nameUrdu,
    String? nameHindi,
    String? nameArabic,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      if (credential?.user != null) {
        _firebaseUser = credential!.user;

        // Create user model
        _userModel = UserModel.fromFirebaseUser(
          _firebaseUser!,
          displayName: name,
          language: language,
          nameEnglish: nameEnglish,
          nameUrdu: nameUrdu,
          nameHindi: nameHindi,
          nameArabic: nameArabic,
        );

        // Save to Firestore
        await _syncUserToFirestore();
        await _saveAuthSession();

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = 'Sign up failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Sign up failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithGoogle();

      if (credential?.user != null) {
        _firebaseUser = credential!.user;
        await _loadUserFromFirestore(_firebaseUser!.uid);

        // If new user, create Firestore document
        if (_userModel == null) {
          _userModel = UserModel.fromFirebaseUser(_firebaseUser!);
          await _syncUserToFirestore();
        }

        await _saveAuthSession();

        _isLoading = false;
        notifyListeners();
        return true;
      }

      // User canceled
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Google sign in failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Apple
  Future<bool> signInWithApple(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithApple();

      if (credential?.user != null) {
        _firebaseUser = credential!.user;
        await _loadUserFromFirestore(_firebaseUser!.uid);

        // If new user, create Firestore document
        if (_userModel == null) {
          _userModel = UserModel.fromFirebaseUser(_firebaseUser!);
          await _syncUserToFirestore();
        }

        await _saveAuthSession();

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Apple sign in failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Phone Number
  Future<String?> signInWithPhone({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final verificationId = await _authService.signInWithPhone(
        phoneNumber: phoneNumber,
        context: context,
      );

      _isLoading = false;
      notifyListeners();
      return verificationId;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Phone sign in failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Verify Phone OTP
  Future<bool> verifyPhoneOtp({
    required String verificationId,
    required String otp,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.verifyPhoneOtp(
        verificationId: verificationId,
        otp: otp,
      );

      if (credential?.user != null) {
        _firebaseUser = credential!.user;
        await _loadUserFromFirestore(_firebaseUser!.uid);

        // If new user, create Firestore document
        if (_userModel == null) {
          _userModel = UserModel.fromFirebaseUser(_firebaseUser!);
          await _syncUserToFirestore();
        }

        await _saveAuthSession();

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = 'Phone verification failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Phone verification failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Password reset failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _firebaseUser = null;
      _userModel = null;
      await _clearAuthSession();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Sign out failed';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? location,
    String? profileImagePath,
    String? language,
  }) async {
    if (_userModel == null) return false;

    try {
      _userModel = _userModel!.copyWith(
        name: name,
        location: location,
        profileImagePath: profileImagePath,
        preferredLanguage: language,
      );

      // Update Firebase Auth display name if changed
      if (name != null && _firebaseUser != null) {
        await _authService.updateProfile(displayName: name);
      }

      // Sync to Firestore
      await _syncUserToFirestore();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  // Sync profile data (called from SettingsProvider)
  Future<void> syncProfileData({
    required String name,
    required String location,
    String? profileImagePath,
  }) async {
    await updateUserProfile(
      name: name,
      location: location,
      profileImagePath: profileImagePath,
    );
  }

  // Delete account
  Future<bool> deleteAccount(BuildContext context) async {
    if (_firebaseUser == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Delete Firestore document
      await _firestore.collection('users').doc(_firebaseUser!.uid).delete();

      // Delete Firebase Auth account
      await _authService.deleteAccount();

      // Clear local data
      _firebaseUser = null;
      _userModel = null;
      await _clearAuthSession();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        _error = _authService.getErrorMessage(e, context);
      } else {
        _error = 'Account deletion failed: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      debugPrint('Send email verification error: $e');
    }
  }

  // Reload user data
  Future<void> reloadUser() async {
    try {
      await _authService.reloadUser();
      _firebaseUser = _authService.currentUser;

      if (_firebaseUser != null) {
        await _loadUserFromFirestore(_firebaseUser!.uid);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Reload user error: $e');
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
