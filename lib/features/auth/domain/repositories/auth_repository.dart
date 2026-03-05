import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';

/// Repository interface for authentication operations.
///
/// Defines the contract for authentication data access,
/// abstracting Firebase Auth from the domain layer.
abstract class AuthRepository {
  /// Gets the currently authenticated user.
  ///
  /// Returns the current AuthUser or null if not authenticated.
  AuthUser? get currentUser;

  /// Stream of authentication state changes.
  ///
  /// Emits a new AuthUser when user signs in/out or profile changes.
  Stream<AuthUser?> get authStateChanges;

  /// Signs in with email and password.
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// Returns the authenticated user
  /// Throws [AuthFailure] if sign-in fails
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs up with email and password.
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// [displayName] - Optional display name
  /// Returns the newly created user
  /// Throws [AuthFailure] if sign-up fails
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
    Map<String, dynamic>? metadata,
  });

  /// Signs in with Google OAuth.
  ///
  /// Returns the authenticated user
  /// Throws [AuthFailure] if sign-in fails or is cancelled
  Future<AuthUser> signInWithGoogle();

  /// Initiates phone number verification.
  ///
  /// [phoneNumber] - Phone number with country code (e.g., +8801234567890)
  /// [onCodeSent] - Callback when SMS code is sent (receives verificationId)
  /// [onAutoVerified] - Callback when auto-verification completes
  /// [onError] - Callback when verification fails
  Future<void> sendPhoneOTP({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(AuthUser user) onAutoVerified,
    required void Function(String error) onError,
  });

  /// Verifies the OTP code and signs in.
  ///
  /// [verificationId] - The verification ID from sendPhoneOTP
  /// [smsCode] - The 6-digit SMS code
  /// Returns the authenticated user
  /// Throws [AuthFailure] if verification fails
  Future<AuthUser> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  });

  /// Signs in anonymously.
  ///
  /// Returns an anonymous user
  /// Throws [AuthFailure] if sign-in fails
  Future<AuthUser> signInAnonymously();

  /// Sends a password reset email.
  ///
  /// [email] - Email address to send reset link to
  /// Throws [AuthFailure] if request fails
  Future<void> sendPasswordResetEmail(String email);

  /// Sends an email verification link.
  ///
  /// Throws [AuthFailure] if request fails
  Future<void> sendEmailVerification();

  /// Reloads the current user's profile.
  ///
  /// Returns the refreshed user data
  Future<AuthUser?> reloadUser();

  /// Signs out the current user.
  Future<void> signOut();

  /// Updates the user's display name.
  ///
  /// [displayName] - The new display name
  Future<void> updateDisplayName(String displayName);

  /// Updates the user's profile photo URL.
  ///
  /// [photoUrl] - The new photo URL
  Future<void> updatePhotoUrl(String photoUrl);

  /// Gets the Firebase ID token for API authentication.
  ///
  /// [forceRefresh] - Force token refresh even if not expired
  /// Returns the JWT token string
  Future<String?> getIdToken({bool forceRefresh = false});

  /// Updates the user's email address.
  ///
  /// [email] - The new email address
  Future<void> updateEmail(String email);

  /// Updates the user's password.
  ///
  /// [password] - The new password
  Future<void> updatePassword(String password);

  /// Re-authenticates the user with a credential.
  ///
  /// [email] - User's email
  /// [password] - User's password
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  });

  /// Updates the user's phone number.
  ///
  /// [verificationId] - The verification ID from sendPhoneOTP
  /// [smsCode] - The 6-digit SMS code
  Future<void> updatePhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  /// Deletes the current user's account.
  ///
  /// Throws [AuthFailure] if deletion fails
  Future<void> deleteAccount();

  /// Gets the authentication headers for Google API requests.
  ///
  /// Returns a map of headers or null if not signed in with Google.
  Future<Map<String, String>?> get googleAuthHeaders;
}

/// Authentication failure types
enum AuthFailureType {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  weakPassword,
  invalidCredential,
  operationNotAllowed,
  userDisabled,
  tooManyRequests,
  networkError,
  invalidVerificationCode,
  invalidPhoneNumber,
  quotaExceeded,
  sessionExpired,
  requiresRecentLogin,
  cancelled,
  unknown,
}

/// Authentication failure class
class AuthFailure implements Exception {
  final AuthFailureType type;
  final String message;
  final dynamic originalError;

  const AuthFailure({
    required this.type,
    required this.message,
    this.originalError,
  });

  factory AuthFailure.fromFirebaseCode(String code, [String? message]) {
    final type = _mapFirebaseCode(code);
    return AuthFailure(
      type: type,
      message: message ?? _getDefaultMessage(type),
    );
  }

  static AuthFailureType _mapFirebaseCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthFailureType.invalidEmail;
      case 'wrong-password':
        return AuthFailureType.wrongPassword;
      case 'user-not-found':
        return AuthFailureType.userNotFound;
      case 'email-already-in-use':
        return AuthFailureType.emailAlreadyInUse;
      case 'weak-password':
        return AuthFailureType.weakPassword;
      case 'invalid-credential':
        return AuthFailureType.invalidCredential;
      case 'operation-not-allowed':
        return AuthFailureType.operationNotAllowed;
      case 'user-disabled':
        return AuthFailureType.userDisabled;
      case 'too-many-requests':
        return AuthFailureType.tooManyRequests;
      case 'network-request-failed':
        return AuthFailureType.networkError;
      case 'invalid-verification-code':
        return AuthFailureType.invalidVerificationCode;
      case 'invalid-phone-number':
        return AuthFailureType.invalidPhoneNumber;
      case 'quota-exceeded':
        return AuthFailureType.quotaExceeded;
      case 'session-expired':
        return AuthFailureType.sessionExpired;
      case 'requires-recent-login':
        return AuthFailureType.requiresRecentLogin;
      default:
        return AuthFailureType.unknown;
    }
  }

  static String _getDefaultMessage(AuthFailureType type) {
    switch (type) {
      case AuthFailureType.invalidEmail:
        return 'Invalid email address.';
      case AuthFailureType.wrongPassword:
        return 'Incorrect password.';
      case AuthFailureType.userNotFound:
        return 'No user found with this email.';
      case AuthFailureType.emailAlreadyInUse:
        return 'An account already exists with this email.';
      case AuthFailureType.weakPassword:
        return 'Password is too weak. Use at least 6 characters.';
      case AuthFailureType.invalidCredential:
        return 'Invalid credentials.';
      case AuthFailureType.operationNotAllowed:
        return 'This operation is not allowed.';
      case AuthFailureType.userDisabled:
        return 'This account has been disabled.';
      case AuthFailureType.tooManyRequests:
        return 'Too many attempts. Please try again later.';
      case AuthFailureType.networkError:
        return 'Network error. Please check your connection.';
      case AuthFailureType.invalidVerificationCode:
        return 'Invalid verification code.';
      case AuthFailureType.invalidPhoneNumber:
        return 'Invalid phone number format.';
      case AuthFailureType.quotaExceeded:
        return 'SMS quota exceeded. Please try again later.';
      case AuthFailureType.sessionExpired:
        return 'Session expired. Please sign in again.';
      case AuthFailureType.requiresRecentLogin:
        return 'Please sign in again to complete this action.';
      case AuthFailureType.cancelled:
        return 'Operation cancelled.';
      case AuthFailureType.unknown:
        return 'An unknown error occurred.';
    }
  }

  @override
  String toString() => 'AuthFailure: $message (type: $type)';
}
