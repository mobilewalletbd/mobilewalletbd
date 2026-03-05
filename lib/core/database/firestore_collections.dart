// Firestore Collection Definitions for Smart Contact Wallet V1
// Defines collection names, document structures, and data mapping

import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore collection names
class FirestoreCollections {
  // Core collections
  static const String users = 'users';
  static const String contacts = 'contacts';
  static const String globalContacts = 'global_contacts';

  // Digital card & wallet
  static const String cardDesigns = 'card_designs';
  static const String wallets = 'wallets';
  static const String transactions = 'transactions';

  // Team & collaboration
  static const String teams = 'teams';

  // Notifications & settings
  static const String notifications = 'notifications';
  static const String appSettings = 'app_settings';
}

/// Helper class for Firestore document paths
class FirestorePaths {
  /// Get user document path
  static String userDocument(String uid) =>
      '${FirestoreCollections.users}/$uid';

  /// Get contact document path
  static String contactDocument(String contactId) =>
      '${FirestoreCollections.contacts}/$contactId';

  /// Get wallet document path
  static String walletDocument(String walletId) =>
      '${FirestoreCollections.wallets}/$walletId';

  /// Get transaction document path
  static String transactionDocument(String transactionId) =>
      '${FirestoreCollections.transactions}/$transactionId';

  /// Get team document path
  static String teamDocument(String teamId) =>
      '${FirestoreCollections.teams}/$teamId';

  /// Get notification document path
  static String notificationDocument(String notificationId) =>
      '${FirestoreCollections.notifications}/$notificationId';

  /// Get card design document path
  static String cardDesignDocument(String cardId) =>
      '${FirestoreCollections.cardDesigns}/$cardId';

  /// Get app settings document path
  static String appSettingsDocument(String userId) =>
      '${FirestoreCollections.appSettings}/$userId';

  /// Get global contact document path
  static String globalContactDocument(String globalId) =>
      '${FirestoreCollections.globalContacts}/$globalId';
}

/// Firestore document structure definitions
/// These classes define the expected JSON structure for each collection

class FirestoreUserProfile {
  static Map<String, dynamic> toMap({
    required String uid,
    required String fullName,
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? companyName,
    String? bio,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    String? personalCardId,
    String accountStatus = 'active',
    String? kycTier,
    String? timeZone,
    String? defaultLanguage,
    DateTime? lastActiveAt,
    String? deviceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'uid': uid,
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'preferences': preferences ?? {},
      'personalCardId': personalCardId,
      'accountStatus': accountStatus,
      'kycTier': kycTier,
      'timeZone': timeZone,
      'defaultLanguage': defaultLanguage ?? 'en',
      'lastActiveAt': lastActiveAt ?? FieldValue.serverTimestamp(),
      'deviceId': deviceId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreContact {
  static Map<String, dynamic> toMap({
    required String contactId,
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
    List<Map<String, dynamic>>? socialLinks,
    String category = 'uncategorized',
    List<String>? tags,
    bool isFavorite = false,
    String? notes,
    String? frontImageUrl,
    String? backImageUrl,
    String? frontImageOcrText,
    String? backImageOcrText,
    Map<String, dynamic>? ocrFields,
    DateTime? lastContactedAt,
    int contactCount = 0,
    String? source,
    bool isVerified = false,
    double fraudScore = 0.0,
    Map<String, dynamic>? rawExtraData,
    String? createdBy,
    List<String>? sharedWith,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'contactId': contactId,
      'ownerId': ownerId,
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'phoneNumbers': phoneNumbers ?? [],
      'emails': emails ?? [],
      'addresses': addresses ?? [],
      'websiteUrls': websiteUrls ?? [],
      'socialLinks': socialLinks ?? [],
      'category': category,
      'tags': tags ?? [],
      'isFavorite': isFavorite,
      'notes': notes,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'frontImageOcrText': frontImageOcrText,
      'backImageOcrText': backImageOcrText,
      'ocrFields': ocrFields,
      'lastContactedAt': lastContactedAt,
      'contactCount': contactCount,
      'source': source,
      'isVerified': isVerified,
      'fraudScore': fraudScore,
      'rawExtraData': rawExtraData,
      'createdBy': createdBy,
      'sharedWith': sharedWith ?? [],
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreCardDesign {
  static Map<String, dynamic> toMap({
    required String cardId,
    required String userId,
    required String themeColor,
    String layoutStyle = 'classic',
    bool showQrCode = true,
    String? customLogoUrl,
    Map<String, bool>? visibleFields,
    String? frontCardTemplateId,
    String? backCardTemplateId,
    List<Map<String, dynamic>>? customFields,
    String qrCodeStyle = 'static',
    bool allowSharing = true,
    DateTime? lastModified,
    String status = 'active',
    DateTime? createdAt,
  }) {
    return {
      'cardId': cardId,
      'userId': userId,
      'themeColor': themeColor,
      'layoutStyle': layoutStyle,
      'showQrCode': showQrCode,
      'customLogoUrl': customLogoUrl,
      'visibleFields': visibleFields ?? {},
      'frontCardTemplateId': frontCardTemplateId,
      'backCardTemplateId': backCardTemplateId,
      'customFields': customFields,
      'qrCodeStyle': qrCodeStyle,
      'allowSharing': allowSharing,
      'lastModified': lastModified ?? FieldValue.serverTimestamp(),
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreWallet {
  static Map<String, dynamic> toMap({
    required String walletId,
    required String userId,
    double balance = 0.0,
    String currency = 'BDT',
    String status = 'active',
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return {
      'walletId': walletId,
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'status': status,
      'lastUpdated': lastUpdated ?? FieldValue.serverTimestamp(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreTransaction {
  static Map<String, dynamic> toMap({
    required String transactionId,
    required String walletId,
    required String type,
    required double amount,
    String? description,
    String? counterpartyName,
    String? counterpartyId,
    String status = 'pending',
    DateTime? timestamp,
    String? referenceId,
    String category = 'manualAdd',
    String currencyCode = 'BDT',
    String? metadata,
    DateTime? completedAt,
    String? initiatedBy,
    bool isReversed = false,
    DateTime? createdAt,
  }) {
    return {
      'transactionId': transactionId,
      'walletId': walletId,
      'type': type,
      'amount': amount,
      'description': description,
      'counterpartyName': counterpartyName,
      'counterpartyId': counterpartyId,
      'status': status,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'referenceId': referenceId,
      'category': category,
      'currencyCode': currencyCode,
      'metadata': metadata,
      'completedAt': completedAt,
      'initiatedBy': initiatedBy,
      'isReversed': isReversed,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreTeam {
  static Map<String, dynamic> toMap({
    required String teamId,
    required String name,
    required String ownerId,
    List<Map<String, dynamic>>? members,
    String description = '',
    String status = 'active',
    int sharedContactsCount = 0,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'teamId': teamId,
      'name': name,
      'ownerId': ownerId,
      'members': members ?? [],
      'description': description,
      'status': status,
      'sharedContactsCount': sharedContactsCount,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreNotification {
  static Map<String, dynamic> toMap({
    required String notificationId,
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    bool isRead = false,
    bool isImportant = false,
    String? actionUrl,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'isImportant': isImportant,
      'actionUrl': actionUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'readAt': readAt,
    };
  }
}

class FirestoreAppSettings {
  static Map<String, dynamic> toMap({
    required String userId,
    String theme = 'light',
    String language = 'en',
    bool notificationsEnabled = true,
    bool biometricEnabled = false,
    bool autoSyncEnabled = true,
    String defaultViewMode = 'grid',
    bool showFavoritesFirst = false,
    int contactsPerPage = 20,
    bool enableHaptics = true,
    bool enableAnimations = true,
    String currencyDisplay = 'symbol',
    DateTime? lastBackupAt,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return {
      'userId': userId,
      'theme': theme,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'biometricEnabled': biometricEnabled,
      'autoSyncEnabled': autoSyncEnabled,
      'defaultViewMode': defaultViewMode,
      'showFavoritesFirst': showFavoritesFirst,
      'contactsPerPage': contactsPerPage,
      'enableHaptics': enableHaptics,
      'enableAnimations': enableAnimations,
      'currencyDisplay': currencyDisplay,
      'lastBackupAt': lastBackupAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class FirestoreGlobalContact {
  static Map<String, dynamic> toMap({
    required String globalId,
    required Map<String, dynamic> latestData,
    required String version,
    DateTime? versionTimestamp,
    bool verifiedByOwner = false,
    double fraudScore = 0.0,
    int updateCount = 0,
    String? lastUpdaterId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'globalId': globalId,
      'latestData': latestData,
      'version': version,
      'versionTimestamp': versionTimestamp ?? FieldValue.serverTimestamp(),
      'verifiedByOwner': verifiedByOwner,
      'fraudScore': fraudScore,
      'updateCount': updateCount,
      'lastUpdaterId': lastUpdaterId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
