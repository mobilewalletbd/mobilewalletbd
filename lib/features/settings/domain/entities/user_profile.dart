import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Extended user data stored in Cloud Firestore (Users Collection).
///
/// This entity contains the user's profile information beyond
/// basic authentication data, including preferences, settings,
/// and account status.
@freezed
class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    /// Unique identifier matching AuthUser.id (Firebase UID)
    required String uid,

    /// User's full name
    required String fullName,

    /// User's email address (for search and notifications)
    String? email,

    /// User's first name
    String? firstName,

    /// User's last name
    String? lastName,

    /// User's phone number (for team addition)
    String? phoneNumber,

    /// User's job title or position
    String? jobTitle,

    /// User's company or organization name
    String? companyName,

    /// User's bio or description
    String? bio,

    /// URL to user's avatar image (Cloudinary URL)
    String? avatarUrl,

    /// User preferences (theme, language, notifications)
    @Default({}) Map<String, dynamic> preferences,

    /// Reference to user's personal CardDesign ID
    String? personalCardId,

    /// Account status: ACTIVE, SUSPENDED, PENDING_VERIFICATION
    @Default(AccountStatus.active) AccountStatus accountStatus,

    /// KYC verification tier: BASIC, PRO, ENTERPRISE
    KycTier? kycTier,

    /// User's timezone (e.g., 'Asia/Dhaka')
    String? timeZone,

    /// User's preferred language (en, bn)
    @Default('en') String defaultLanguage,

    /// Timestamp of user's last activity
    DateTime? lastActiveAt,

    /// Current device identifier
    String? deviceId,

    /// Timestamp when profile was created
    required DateTime createdAt,

    /// Timestamp when profile was last updated
    required DateTime updatedAt,
  }) = _UserProfile;

  /// Creates a UserProfile from JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// Creates a new UserProfile with default values for a new user
  factory UserProfile.newUser({
    required String uid,
    required String fullName,
    String? email,
  }) {
    final now = DateTime.now();
    return UserProfile(
      uid: uid,
      fullName: fullName,
      email: email,
      accountStatus: AccountStatus.pendingVerification,
      kycTier: KycTier.basic,
      defaultLanguage: 'en',
      preferences: {
        'theme': 'system',
        'language': 'en',
        'notificationsEnabled': true,
      },
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Updates the preferences map with new values
  UserProfile updatePreferences(Map<String, dynamic> newPrefs) {
    return copyWith(
      preferences: {...preferences, ...newPrefs},
      updatedAt: DateTime.now(),
    );
  }

  /// Checks if user has been active within the last 30 days
  bool get isActive {
    if (lastActiveAt == null) return false;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return lastActiveAt!.isAfter(thirtyDaysAgo);
  }

  /// Checks if user account is in good standing
  bool get isAccountActive => accountStatus == AccountStatus.active;

  /// Checks if user has completed profile setup
  bool get isProfileComplete {
    return fullName.isNotEmpty &&
        (avatarUrl != null || jobTitle != null || companyName != null);
  }

  /// Gets user's preferred theme from preferences
  String get preferredTheme => preferences['theme'] as String? ?? 'system';

  /// Gets user's preferred language from preferences
  String get preferredLanguage =>
      preferences['language'] as String? ?? defaultLanguage;

  /// Checks if notifications are enabled
  bool get notificationsEnabled =>
      preferences['notificationsEnabled'] as bool? ?? true;

  /// Gets display name (fullName or 'User' if empty)
  String get displayName => fullName.isNotEmpty ? fullName : 'User';

  /// Gets initials for avatar fallback
  String get initials {
    if (fullName.isEmpty) return 'U';
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

/// Account status enumeration
@JsonEnum(alwaysCreate: true)
enum AccountStatus {
  @JsonValue('ACTIVE')
  active,

  @JsonValue('SUSPENDED')
  suspended,

  @JsonValue('PENDING_VERIFICATION')
  pendingVerification,
}

/// KYC verification tier enumeration
@JsonEnum(alwaysCreate: true)
enum KycTier {
  @JsonValue('BASIC')
  basic,

  @JsonValue('PRO')
  pro,

  @JsonValue('ENTERPRISE')
  enterprise,
}

/// Privacy setting levels
class PrivacyLevels {
  static const String public = 'public';
  static const String connectionsOnly = 'connections_only';
  static const String private = 'private'; // 'nobody'
}

extension UserProfilePrivacy on UserProfile {
  /// Who can see my card?
  String get cardVisibility =>
      preferences['cardVisibility'] as String? ?? PrivacyLevels.public;

  /// Who can import my contacts?
  String get contactImportPrivacy =>
      preferences['contactImportPrivacy'] as String? ?? PrivacyLevels.public;

  /// Update privacy settings
  UserProfile updatePrivacy({
    String? cardVisibility,
    String? contactImportPrivacy,
  }) {
    final Map<String, dynamic> newPrefs = Map.from(preferences);
    if (cardVisibility != null) newPrefs['cardVisibility'] = cardVisibility;
    if (contactImportPrivacy != null) {
      newPrefs['contactImportPrivacy'] = contactImportPrivacy;
    }
    return copyWith(preferences: newPrefs, updatedAt: DateTime.now());
  }
}
