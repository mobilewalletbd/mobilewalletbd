// Use case for phone number verification
// Part of the verification system for Smart Contact Wallet V1

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_wallet/core/utils/app_logger.dart';

/// Use case to verify user's phone number
class VerifyPhoneNumberUseCase {
  final FirebaseAuth _auth;

  VerifyPhoneNumberUseCase(this._auth);

  /// Send OTP to phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    Function(PhoneAuthCredential credential)? onAutoVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          if (onAutoVerified != null) {
            onAutoVerified(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout callback
          AppLogger.info(
            'Code auto-retrieval timeout',
            tag: 'VerifyPhoneNumber',
          );
        },
      );
    } catch (e) {
      AppLogger.error('Error sending OTP', tag: 'VerifyPhoneNumber', error: e);
      onError(e.toString());
    }
  }

  /// Verify OTP code
  Future<User?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Link credential to current user if signed in
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updatePhoneNumber(credential);
        await currentUser.reload();
        return _auth.currentUser;
      } else {
        // Sign in with phone credential
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Failed to verify OTP',
        tag: 'VerifyPhoneNumber',
        error: e.message,
      );
      rethrow;
    } catch (e) {
      AppLogger.error(
        'Error verifying OTP',
        tag: 'VerifyPhoneNumber',
        error: e,
      );
      rethrow;
    }
  }

  /// Check if phone number is verified
  Future<bool> isPhoneVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    await user.reload();
    return _auth.currentUser?.phoneNumber != null;
  }
}
