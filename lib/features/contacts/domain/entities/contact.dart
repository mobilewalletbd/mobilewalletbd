import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

/// Represents a contact in the user's contact list.
///
/// This is the core domain entity for contact management.
/// Contains all contact information including business card data.
@freezed
class Contact with _$Contact {
  const Contact._();

  const factory Contact({
    /// Unique contact ID (UUID)
    required String id,

    /// ID of the user who owns this contact
    required String ownerId,

    /// Full name of the contact (required)
    required String fullName,

    /// First name
    String? firstName,

    /// Last name
    String? lastName,

    /// Job title or position
    String? jobTitle,

    /// Company or organization name
    String? companyName,

    /// List of phone numbers
    @Default([]) List<String> phoneNumbers,

    /// List of email addresses
    @Default([]) List<String> emails,

    /// List of physical addresses
    @Default([]) List<String> addresses,

    /// List of website URLs
    @Default([]) List<String> websiteUrls,

    /// Social media links
    @Default([]) List<SocialLink> socialLinks,

    /// Contact category (business, personal, friends, family, uncategorized)
    @Default('uncategorized') String category,

    /// Custom tags for organization
    @Default([]) List<String> tags,

    /// Whether this contact is marked as favorite
    @Default(false) bool isFavorite,

    /// Additional notes about the contact
    String? notes,

    /// URL to front side of business card image (Cloudinary)
    String? frontImageUrl,

    /// URL to back side of business card image (Cloudinary)
    String? backImageUrl,

    /// Raw OCR text extracted from front card image
    String? frontImageOcrText,

    /// Raw OCR text extracted from back card image
    String? backImageOcrText,

    /// Structured OCR data fields
    Map<String, dynamic>? ocrFields,

    /// Timestamp of last interaction with this contact
    DateTime? lastContactedAt,

    /// Number of times this contact has been contacted
    @Default(0) int contactCount,

    /// Source of contact (manual, scan, import, nfc, qr)
    String? source,

    /// Whether this contact has been verified
    @Default(false) bool isVerified,

    /// Fraud/trust score (0.0 - 1.0)
    @Default(0.0) double fraudScore,

    /// Raw profile data from auth provider or import source
    Map<String, dynamic>? rawExtraData,

    /// Timestamp when contact was created
    required DateTime createdAt,

    /// Timestamp when contact was last updated
    required DateTime updatedAt,

    /// ID of user who created this contact (for team sharing)
    String? createdBy,

    /// List of user IDs this contact is shared with
    List<String>? sharedWith,

    /// List of team IDs this contact is shared with
    @Default([]) List<String> sharedWithTeams,
  }) = _Contact;

  /// Creates a Contact from JSON map
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  /// Creates a new contact with default values
  factory Contact.create({
    required String id,
    required String ownerId,
    required String fullName,
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? companyName,
    List<String>? phoneNumbers,
    List<String>? emails,
    List<String>? addresses,
    List<String>? websiteUrls,
    String? category,
    List<String>? tags,
    String? notes,
    String? source,
    Map<String, dynamic>? rawExtraData,
  }) {
    final now = DateTime.now();
    return Contact(
      id: id,
      ownerId: ownerId,
      fullName: fullName,
      firstName: firstName,
      lastName: lastName,
      jobTitle: jobTitle,
      companyName: companyName,
      phoneNumbers: phoneNumbers ?? [],
      emails: emails ?? [],
      addresses: addresses ?? [],
      websiteUrls: websiteUrls ?? [],
      category: category ?? 'uncategorized',
      tags: tags ?? [],
      notes: notes,
      source: source ?? 'manual',
      rawExtraData: rawExtraData,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Gets the initials for avatar fallback (e.g., "JD" for "John Doe")
  String get initials {
    if (fullName.trim().isEmpty) return '?';

    final parts = fullName.trim().split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return '$first$second'.toUpperCase();
    }

    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  /// Gets the primary (first) phone number
  String? get primaryPhone =>
      phoneNumbers.isNotEmpty ? phoneNumbers.first : null;

  /// Gets the primary (first) email address
  String? get primaryEmail => emails.isNotEmpty ? emails.first : null;

  /// Gets the primary (first) address
  String? get primaryAddress => addresses.isNotEmpty ? addresses.first : null;

  /// Checks if this contact has business card images
  bool get hasBusinessCard => frontImageUrl != null || backImageUrl != null;

  /// Checks if this contact has any contact information
  bool get hasContactInfo =>
      phoneNumbers.isNotEmpty ||
      emails.isNotEmpty ||
      addresses.isNotEmpty ||
      websiteUrls.isNotEmpty;

  /// Gets display subtitle (job title at company, or just one)
  String? get displaySubtitle {
    if (jobTitle != null && companyName != null) {
      return '$jobTitle at $companyName';
    }
    return jobTitle ?? companyName;
  }

  /// Checks if contact belongs to a specific category
  bool isInCategory(String cat) => category.toLowerCase() == cat.toLowerCase();
}

/// Represents a social media link for a contact
@freezed
class SocialLink with _$SocialLink {
  const factory SocialLink({
    /// Platform name (linkedin, twitter, facebook, instagram, etc.)
    required String platform,

    /// Full URL to the profile
    required String url,

    /// Username/handle on the platform
    String? handle,

    /// Platform-specific ID
    String? platformId,

    /// Whether this link is publicly visible
    @Default(true) bool isPublic,
  }) = _SocialLink;

  factory SocialLink.fromJson(Map<String, dynamic> json) =>
      _$SocialLinkFromJson(json);
}

/// Contact category enum values
class ContactCategories {
  static const String business = 'business';
  static const String personal = 'personal';
  static const String friends = 'friends';
  static const String family = 'family';
  static const String uncategorized = 'uncategorized';

  static const List<String> all = [
    business,
    personal,
    friends,
    family,
    uncategorized,
  ];

  /// Gets display name for a category
  static String displayName(String category) {
    switch (category.toLowerCase()) {
      case business:
        return 'Business';
      case personal:
        return 'Personal';
      case friends:
        return 'Friends';
      case family:
        return 'Family';
      case uncategorized:
      default:
        return 'Uncategorized';
    }
  }
}

/// Contact source enum values
class ContactSources {
  static const String manual = 'manual';
  static const String scan = 'scan';
  static const String import = 'import';
  static const String nfc = 'nfc';
  static const String qr = 'qr';
}
