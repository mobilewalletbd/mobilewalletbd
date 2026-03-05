// Isar Schema Definitions for Smart Contact Wallet V1
// This file contains all Isar collection schemas for offline-first functionality
// All entities are stored locally in Isar and synced to Firebase Firestore

import 'package:isar/isar.dart';

part 'isar_schemas.g.dart';

// =============================================================================
// 1. AUTH & USER PROFILE SCHEMAS
// =============================================================================

/// Isar schema for AuthUser entity
/// Represents the authenticated user stored locally
@collection
class AuthUserIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // Firebase User ID

  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? displayName;
  String? photoUrl;

  bool emailVerified = false;
  DateTime? lastSignIn;
  String? provider; // 'google', 'phone', 'email', 'apple'
  bool isAnonymous = false;

  List<String> customClaims = [];

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}

/// Isar schema for UserProfile entity
/// Extended user data stored locally and synced to Firestore
@collection
class UserProfileIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // Matches AuthUser.uid

  late String fullName;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? companyName;
  String? bio;
  String? avatarUrl; // Cloudinary URL

  // Stored as JSON string since Isar doesn't support Map directly
  String preferences = '{}'; // theme, language, notifications

  String? personalCardId; // Reference to CardDesign

  @Enumerated(EnumType.name)
  AccountStatus accountStatus = AccountStatus.active;

  @Enumerated(EnumType.name)
  KycTier? kycTier;

  String? timeZone;
  String? defaultLanguage; // 'en', 'bn'
  DateTime? lastActiveAt;
  String? deviceId;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum AccountStatus { active, suspended, pendingVerification }

enum KycTier { basic, pro, enterprise }

// =============================================================================
// 2. CONTACT MANAGEMENT SCHEMAS
// =============================================================================

/// Isar schema for Contact entity
/// Represents a saved contact with business card data
@collection
class ContactIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String contactId; // UUID

  @Index()
  late String ownerId; // User who saved this contact

  late String fullName;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? companyName;

  List<String> phoneNumbers = [];
  List<String> emails = [];
  List<String> addresses = [];
  List<String> websiteUrls = [];

  // Social links stored as JSON string
  String socialLinks = '[]'; // List<SocialLink>

  @Enumerated(EnumType.name)
  ContactCategory category = ContactCategory.uncategorized;

  List<String> tags = [];
  bool isFavorite = false;
  String? notes;

  // Business card images
  String? frontImageUrl; // Cloudinary URL
  String? backImageUrl; // Cloudinary URL
  String? frontImageOcrText; // Raw OCR text
  String? backImageOcrText; // Raw OCR text

  // Structured OCR data stored as JSON string
  String? ocrFields;

  String? rawExtraData; // JSON string

  DateTime? lastContactedAt;
  int contactCount = 0;

  @Enumerated(EnumType.name)
  ContactSource? source;

  bool isVerified = false;
  double fraudScore = 0.0;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  String? createdBy; // User ID who created
  List<String> sharedWith =
      []; // Team sharing - DEPRECATED: Use sharedWithTeams
  List<String> sharedWithTeams = []; // Team IDs this contact is shared with

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum ContactCategory { business, personal, friends, family, uncategorized }

enum ContactSource { manual, scan, import, nfc, qr }

/// Isar schema for GlobalContact entity
/// Verified contact information from global directory
@collection
class GlobalContactIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String globalId; // Hashed phone/email

  // Full contact data stored as JSON string
  late String latestData;

  late String version; // UUID for version tracking
  DateTime versionTimestamp = DateTime.now();

  bool verifiedByOwner = false;
  double fraudScore = 0.0;
  int updateCount = 0;

  String? lastUpdaterId; // User ID who last updated

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

// =============================================================================
// 3. DIGITAL CARD SCHEMAS
// =============================================================================

/// Isar schema for CardDesign entity
/// User's personal digital business card configuration
@collection
class CardDesignIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String cardId; // UUID

  @Index()
  late String userId;

  late String themeColor; // Hex code

  @Enumerated(EnumType.name)
  CardDesignLayout layoutStyle = CardDesignLayout.classic;

  bool showQrCode = true;
  String? customLogoUrl;

  // Visible fields stored as JSON string
  String visibleFields = '{}'; // Map<String, bool>

  String? frontCardTemplateId;
  String? backCardTemplateId;

  // Custom fields stored as JSON string
  String? customFields; // List<Map<String, dynamic>>

  @Enumerated(EnumType.name)
  QrCodeStyle qrCodeStyle = QrCodeStyle.static;

  bool allowSharing = true;
  List<String> sharedWithTeams = [];
  DateTime lastModified = DateTime.now();

  @Enumerated(EnumType.name)
  CardStatus status = CardStatus.active;

  DateTime createdAt = DateTime.now();

  // Analytics
  int viewCount = 0;
  int scanCount = 0;
  int shareCount = 0;

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

/// Isar schema for CardDesignVersion entity
/// Version snapshot of a card design
@collection
class CardDesignVersionIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String versionId; // UUID

  @Index()
  late String cardId;

  @Index()
  late String userId;

  late String snapshotData; // JSON string

  DateTime createdAt = DateTime.now();

  String? commitMessage;

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum CardDesignLayout { classic, modern, minimal }

enum QrCodeStyle { static, dynamic, custom }

enum CardStatus { active, draft, archived }

// =============================================================================
// 4. WALLET & TRANSACTION SCHEMAS
// =============================================================================

/// Isar schema for Wallet entity
/// User's internal balance
@collection
class WalletIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String walletId; // UUID

  @Index()
  late String userId;

  double balance = 0.0;
  String currency = 'BDT';

  @Enumerated(EnumType.name)
  WalletStatus status = WalletStatus.active;

  DateTime lastUpdated = DateTime.now();
  DateTime createdAt = DateTime.now();

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum WalletStatus { active, frozen }

/// Isar schema for WalletTransaction entity
/// Single entry in the ledger
@collection
class WalletTransactionIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String transactionId; // UUID

  @Index()
  late String walletId;

  @Enumerated(EnumType.name)
  late TransactionType type;

  double amount = 0.0;
  String? description;
  String? counterpartyName;
  String? counterpartyId; // Contact ID

  @Enumerated(EnumType.name)
  TransactionStatus status = TransactionStatus.pending;

  @Index()
  DateTime timestamp = DateTime.now();

  String? referenceId; // External transaction ID

  @Enumerated(EnumType.name)
  TransactionCategory category = TransactionCategory.manualAdd;

  String currencyCode = 'BDT';
  String? metadata; // JSON string for additional data

  DateTime? completedAt;
  String? initiatedBy; // User ID
  bool isReversed = false;

  DateTime createdAt = DateTime.now();

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum TransactionType { credit, debit }

enum TransactionStatus { pending, completed, failed }

enum TransactionCategory { internalTransfer, manualAdd, reward }

// =============================================================================
// 5. TEAM & COLLABORATION SCHEMAS
// =============================================================================

/// Isar schema for Team entity
/// Basic team collaboration features
@collection
class TeamIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String teamId; // UUID

  late String name;

  @Index()
  late String ownerId; // Team creator

  // Members stored as JSON string
  String members = '[]'; // List<TeamMember>

  String description = '';

  @Enumerated(EnumType.name)
  TeamStatus status = TeamStatus.active;

  int sharedContactsCount = 0;
  String? avatarUrl;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum TeamStatus { active, inactive, archived }

// =============================================================================
// 6. NOTIFICATION SCHEMAS
// =============================================================================

/// Isar schema for Notification entity
/// In-app notifications for users
@collection
class NotificationIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String notificationId; // UUID

  @Index()
  late String userId; // Recipient

  @Enumerated(EnumType.name)
  late NotificationType type;

  late String title;
  late String message;

  String? data; // JSON string for additional context

  bool isRead = false;
  bool isImportant = false;
  String? actionUrl; // Deep link

  @Index()
  DateTime createdAt = DateTime.now();
  DateTime? readAt;

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum NotificationType { contactUpdate, payment, teamInvite, system }

// =============================================================================
// 7. SETTINGS SCHEMAS
// =============================================================================

/// Isar schema for AppSettings entity
/// User's app-wide preferences
@collection
class AppSettingsIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  @Enumerated(EnumType.name)
  ThemeMode theme = ThemeMode.light;

  @Enumerated(EnumType.name)
  AppLanguage language = AppLanguage.en;

  bool notificationsEnabled = true;
  bool biometricEnabled = false;
  String? pinCode; // Encrypted
  bool autoSyncEnabled = true;

  @Enumerated(EnumType.name)
  ViewMode defaultViewMode = ViewMode.grid;

  bool showFavoritesFirst = false;
  int contactsPerPage = 20;
  bool enableHaptics = true;
  bool enableAnimations = true;

  @Enumerated(EnumType.name)
  CurrencyDisplay currencyDisplay = CurrencyDisplay.symbol;

  DateTime? lastBackupAt;
  DateTime updatedAt = DateTime.now();
  DateTime createdAt = DateTime.now();

  // Firestore sync tracking
  bool needsSync = false;
  DateTime? lastSyncedAt;
}

enum ThemeMode { light, dark, system }

enum AppLanguage { en, bn }

enum ViewMode { grid, list }

enum CurrencyDisplay { symbol, code, name }

// =============================================================================
// 8. SYNC QUEUE SCHEMA
// =============================================================================

/// Isar schema for tracking pending sync operations
/// Used for offline-first background synchronization
@collection
class SyncQueueIsar {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late SyncOperation operation;

  @Enumerated(EnumType.name)
  late EntityType entityType;

  late String entityId;
  String? entityData; // JSON string of the entity

  @Index()
  DateTime createdAt = DateTime.now();

  int retryCount = 0;
  DateTime? lastRetryAt;
  String? errorMessage;

  @Enumerated(EnumType.name)
  SyncStatus status = SyncStatus.pending;
}

enum SyncOperation { create, update, delete }

enum EntityType {
  userProfile,
  contact,
  cardDesign,
  wallet,
  walletTransaction,
  team,
  notification,
  appSettings,
}

enum SyncStatus { pending, inProgress, completed, failed }
