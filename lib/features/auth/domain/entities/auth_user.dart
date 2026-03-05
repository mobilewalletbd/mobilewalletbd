import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// Represents the authenticated user in the app.
///
/// This is the core domain entity for authentication state.
/// Contains user identity information from Firebase Auth.
@freezed
class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    /// Unique User ID from Firebase
    required String id,

    /// User's email address
    String? email,

    /// User's phone number (with country code)
    String? phoneNumber,

    /// User's first name
    String? firstName,

    /// User's last name
    String? lastName,

    /// User's display name
    String? displayName,

    /// URL to user's profile photo (Cloudinary or Firebase)
    String? photoUrl,

    /// Whether the user's email has been verified
    @Default(false) bool emailVerified,

    /// Timestamp of user's last sign-in
    DateTime? lastSignIn,

    /// Authentication provider (google, phone, email, apple)
    String? provider,

    /// Whether this is an anonymous user
    @Default(false) bool isAnonymous,

    /// Custom claims from Firebase token (roles, permissions)
    List<String>? customClaims,

    /// Raw profile data from auth provider (e.g., Google AdditionalUserInfo)
    Map<String, dynamic>? rawExtraData,
  }) = _AuthUser;

  /// Creates an AuthUser from JSON map
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  /// Checks if the user is fully verified.
  ///
  /// A user is considered fully verified when:
  /// - Email is verified (if email is present)
  /// - Phone is linked (if phone authentication is used)
  bool get isFullyVerified {
    // If user has email, it must be verified
    if (email != null && email!.isNotEmpty && !emailVerified) {
      return false;
    }
    return true;
  }

  /// Checks if user has a linked email
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Checks if user has a linked phone number
  bool get hasPhone => phoneNumber != null && phoneNumber!.isNotEmpty;

  /// Checks if user has a display name set
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Checks if user has a profile photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Gets the primary identifier (email or phone)
  String? get primaryIdentifier => email ?? phoneNumber;

  /// Gets initials for avatar fallback (e.g., "JD" for "John Doe")
  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      if (email != null && email!.isNotEmpty) {
        return email![0].toUpperCase();
      }
      return '?';
    }

    final parts = displayName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

/// Authentication providers supported by the app
class AuthProviderType {
  static const String email = 'email';
  static const String google = 'google';
  static const String phone = 'phone';
  static const String apple = 'apple';
  static const String anonymous = 'anonymous';
}
