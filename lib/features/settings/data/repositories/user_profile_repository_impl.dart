import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_wallet/core/services/firestore_service.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';
import 'package:mobile_wallet/features/settings/domain/repositories/user_profile_repository.dart';

/// Implementation of UserProfileRepository using Firestore.
///
/// Handles all user profile CRUD operations with Cloud Firestore,
/// implementing the offline-first pattern where applicable.
class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirestoreService _firestoreService;

  UserProfileRepositoryImpl(this._firestoreService);

  @override
  Future<UserProfile> createUserProfile(UserProfile profile) async {
    try {
      final data = profile.toJson();

      // Remove timestamps as they will be set by server
      data.remove('createdAt');
      data.remove('updatedAt');

      await _firestoreService.createUser(profile.uid, data);

      // Fetch the created document to get server timestamps
      final doc = await _firestoreService.getUser(profile.uid);
      return _documentToUserProfile(doc);
    } on FirebaseException catch (e) {
      throw UserProfileException('Failed to create user profile: ${e.message}');
    }
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw UserProfileException(
          'Failed to get user profile: User not authenticated',
        );
      }

      if (currentUser.uid != uid) {
        debugPrint(
          '[UserProfileRepo] UID Mismatch: Current=${currentUser.uid}, Requested=$uid',
        );
        // We still request it if it's a mismatch, firestore rules should block it if unauthorized
        // but it's helpful for debugging.
      }

      debugPrint('[UserProfileRepo] Fetching profile for UID: $uid');
      final doc = await _firestoreService.getUser(uid);

      if (!doc.exists || doc.data() == null) {
        debugPrint('[UserProfileRepo] Profile not found for UID: $uid');
        return null;
      }

      return _documentToUserProfile(doc);
    } on FirebaseException catch (e) {
      final msg =
          'Failed to get user profile (UID: $uid): ${e.message} [Code: ${e.code}]';
      debugPrint('[UserProfileRepo] $msg');
      throw UserProfileException(msg);
    } catch (e) {
      final msg = 'Unexpected error getting user profile (UID: $uid): $e';
      debugPrint('[UserProfileRepo] $msg');
      throw UserProfileException(msg);
    }
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      final data = profile.toJson();

      // Remove read-only fields
      data.remove('uid');
      data.remove('createdAt');
      data.remove('updatedAt');

      await _firestoreService.updateUser(profile.uid, data);

      // Fetch updated document
      final doc = await _firestoreService.getUser(profile.uid);
      return _documentToUserProfile(doc);
    } on FirebaseException catch (e) {
      throw UserProfileException('Failed to update user profile: ${e.message}');
    }
  }

  @override
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestoreService.deleteUser(uid);
    } on FirebaseException catch (e) {
      throw UserProfileException('Failed to delete user profile: ${e.message}');
    }
  }

  @override
  Stream<UserProfile?> watchUserProfile(String uid) {
    debugPrint('[UserProfileRepo] Watching profile for UID: $uid');
    return _firestoreService
        .watchUser(uid)
        .handleError((error) {
          debugPrint(
            '[UserProfileRepo] Error watching profile for $uid: $error',
          );
          if (error is FirebaseException) {
            throw UserProfileException(
              'Failed to watch user profile: ${error.message} [Code: ${error.code}]',
            );
          }
          throw UserProfileException('Failed to watch user profile: $error');
        })
        .map((doc) {
          if (!doc.exists || doc.data() == null) {
            debugPrint(
              '[UserProfileRepo] Watched profile not found for UID: $uid',
            );
            return null;
          }
          return _documentToUserProfile(doc);
        });
  }

  @override
  Future<void> updateLastActive(String uid) async {
    try {
      await _firestoreService.updateUserLastActive(uid);
    } on FirebaseException catch (e) {
      throw UserProfileException('Failed to update last active: ${e.message}');
    }
  }

  @override
  Future<UserProfile> updatePreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _firestoreService.updateUser(uid, {'preferences': preferences});

      final doc = await _firestoreService.getUser(uid);
      return _documentToUserProfile(doc);
    } on FirebaseException catch (e) {
      throw UserProfileException('Failed to update preferences: ${e.message}');
    }
  }

  @override
  Future<bool> profileExists(String uid) async {
    try {
      return await _firestoreService.userExists(uid);
    } on FirebaseException catch (e) {
      throw UserProfileException(
        'Failed to check profile existence: ${e.message}',
      );
    }
  }

  @override
  Future<List<UserProfile>> searchUsers(String query) async {
    try {
      if (query.isEmpty) return [];

      // Search by email
      final emailQuery = await _firestoreService.usersCollection
          .where('email', isEqualTo: query)
          .get();

      // Search by phone
      final phoneQuery = await _firestoreService.usersCollection
          .where('phoneNumber', isEqualTo: query)
          .get();

      // Combine results using a Map to avoid duplicates
      final Map<String, UserProfile> results = {};

      for (var doc in emailQuery.docs) {
        results[doc.id] = _documentToUserProfile(doc);
      }

      for (var doc in phoneQuery.docs) {
        results[doc.id] = _documentToUserProfile(doc);
      }

      return results.values.toList();
    } on FirebaseException catch (e) {
      throw UserProfileException('Failed to search users: ${e.message}');
    }
  }

  /// Converts a Firestore document to UserProfile entity
  UserProfile _documentToUserProfile(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    // Handle Firestore Timestamps
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];
    final lastActiveAt = data['lastActiveAt'];

    return UserProfile(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      jobTitle: data['jobTitle'] as String?,
      companyName: data['companyName'] as String?,
      bio: data['bio'] as String?,
      avatarUrl: data['avatarUrl'] as String?,
      preferences: Map<String, dynamic>.from(data['preferences'] as Map? ?? {}),
      personalCardId: data['personalCardId'] as String?,
      accountStatus: _parseAccountStatus(data['accountStatus'] as String?),
      kycTier: _parseKycTier(data['kycTier'] as String?),
      timeZone: data['timeZone'] as String?,
      defaultLanguage: data['defaultLanguage'] as String? ?? 'en',
      lastActiveAt: _timestampToDateTime(lastActiveAt),
      deviceId: data['deviceId'] as String?,
      createdAt: _timestampToDateTime(createdAt) ?? DateTime.now(),
      updatedAt: _timestampToDateTime(updatedAt) ?? DateTime.now(),
      email: data['email'] as String?,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
    );
  }

  /// Converts Firestore Timestamp to DateTime
  DateTime? _timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }

  /// Parses account status string to enum
  AccountStatus _parseAccountStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return AccountStatus.active;
      case 'SUSPENDED':
        return AccountStatus.suspended;
      case 'PENDING_VERIFICATION':
        return AccountStatus.pendingVerification;
      default:
        return AccountStatus.pendingVerification;
    }
  }

  /// Parses KYC tier string to enum
  KycTier? _parseKycTier(String? tier) {
    switch (tier?.toUpperCase()) {
      case 'BASIC':
        return KycTier.basic;
      case 'PRO':
        return KycTier.pro;
      case 'ENTERPRISE':
        return KycTier.enterprise;
      default:
        return null;
    }
  }
}

/// Exception for user profile operations
class UserProfileException implements Exception {
  final String message;

  UserProfileException(this.message);

  @override
  String toString() => 'UserProfileException: $message';
}

/// Provider for UserProfileRepository
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserProfileRepositoryImpl(firestoreService);
});
