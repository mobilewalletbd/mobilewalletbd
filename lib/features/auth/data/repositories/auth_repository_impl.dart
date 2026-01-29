import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';
import 'package:mobile_wallet/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using Firebase Authentication.
///
/// Handles all authentication operations with Firebase Auth,
/// mapping Firebase User objects to domain AuthUser entities.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapFirebaseUser(user) : null;
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? _mapFirebaseUser(user) : null;
    });
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(result.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Sign in failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await result.user!.updateDisplayName(displayName);
        await result.user!.reload();
      }

      // Send email verification
      await result.user!.sendEmailVerification();

      return _mapFirebaseUser(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Sign up failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure(
          type: AuthFailureType.cancelled,
          message: 'Google sign-in was cancelled.',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      return _mapFirebaseUser(result.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Google sign-in failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> sendPhoneOTP({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(AuthUser user) onAutoVerified,
    required void Function(String error) onError,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final result = await _firebaseAuth.signInWithCredential(credential);
          onAutoVerified(_mapFirebaseUser(result.user!));
        } catch (e) {
          onError('Auto-verification failed: $e');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        final failure = AuthFailure.fromFirebaseCode(e.code, e.message);
        onError(failure.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout - code can still be entered manually
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Future<AuthUser> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      return _mapFirebaseUser(result.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'OTP verification failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUser> signInAnonymously() async {
    try {
      final result = await _firebaseAuth.signInAnonymously();
      return _mapFirebaseUser(result.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Anonymous sign-in failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Password reset failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthFailure(
          type: AuthFailureType.userNotFound,
          message: 'No user signed in.',
        );
      }
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Email verification failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUser?> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      await user.reload();
      return _mapFirebaseUser(_firebaseAuth.currentUser!);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthFailure(
          type: AuthFailureType.userNotFound,
          message: 'No user signed in.',
        );
      }
      await user.updateDisplayName(displayName);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Update display name failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthFailure(
          type: AuthFailureType.userNotFound,
          message: 'No user signed in.',
        );
      }
      await user.updatePhotoURL(photoUrl);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Update photo URL failed: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return await user.getIdToken(forceRefresh);
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthFailure(
          type: AuthFailureType.userNotFound,
          message: 'No user signed in.',
        );
      }
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(
        type: AuthFailureType.unknown,
        message: 'Delete account failed: $e',
        originalError: e,
      );
    }
  }

  /// Maps Firebase User to domain AuthUser entity
  AuthUser _mapFirebaseUser(User user) {
    // Determine the auth provider
    String? provider;
    if (user.providerData.isNotEmpty) {
      final providerId = user.providerData.first.providerId;
      if (providerId.contains('google')) {
        provider = AuthProviderType.google;
      } else if (providerId.contains('phone')) {
        provider = AuthProviderType.phone;
      } else if (providerId.contains('password')) {
        provider = AuthProviderType.email;
      } else if (providerId.contains('apple')) {
        provider = AuthProviderType.apple;
      }
    }
    if (user.isAnonymous) {
      provider = AuthProviderType.anonymous;
    }

    return AuthUser(
      id: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      lastSignIn: user.metadata.lastSignInTime,
      provider: provider,
      isAnonymous: user.isAnonymous,
      customClaims: null, // Custom claims require getIdTokenResult
    );
  }
}

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});
