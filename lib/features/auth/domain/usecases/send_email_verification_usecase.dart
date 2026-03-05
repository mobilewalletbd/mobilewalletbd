// Use case for sending email verification
// Part of the verification system for Smart Contact Wallet V1

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_wallet/core/utils/app_logger.dart';

/// Use case to send email verification to the current user
class SendEmailVerificationUseCase {
  final FirebaseAuth _auth;

  SendEmailVerificationUseCase(this._auth);

  /// Execute the use case to send email verification
  Future<void> execute() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      if (user.emailVerified) {
        throw Exception('Email is already verified');
      }

      await user.sendEmailVerification();

      AppLogger.info(
        'Email verification sent to: ${user.email}',
        tag: 'SendEmailVerification',
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Failed to send email verification',
        tag: 'SendEmailVerification',
        error: e.message,
      );
      rethrow;
    } catch (e) {
      AppLogger.error(
        'Error sending email verification',
        tag: 'SendEmailVerification',
        error: e,
      );
      rethrow;
    }
  }

  /// Check if email is verified
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    // Reload user to get latest verification status
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }
}
