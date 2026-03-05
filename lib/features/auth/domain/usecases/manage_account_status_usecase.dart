// Use case for managing user account status
// Part of the verification system for Smart Contact Wallet V1

import 'package:isar/isar.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:mobile_wallet/core/utils/app_logger.dart';

/// Use case to manage user account status and KYC verification
class ManageAccountStatusUseCase {
  final _isar = IsarService.instance;

  /// Update account status
  Future<void> updateAccountStatus({
    required String userId,
    required AccountStatus status,
  }) async {
    try {
      final userProfile = await _getUserProfile(userId);

      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      userProfile.accountStatus = status;
      userProfile.updatedAt = DateTime.now();
      userProfile.needsSync = true;

      await _isar.writeTxn(() async {
        await _isar.userProfileIsars.put(userProfile);
      });

      AppLogger.info(
        'Account status updated to: ${status.name}',
        tag: 'ManageAccountStatus',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to update account status',
        tag: 'ManageAccountStatus',
        error: e,
      );
      rethrow;
    }
  }

  /// Update KYC tier
  Future<void> updateKycTier({
    required String userId,
    required KycTier tier,
  }) async {
    try {
      final userProfile = await _getUserProfile(userId);

      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      userProfile.kycTier = tier;
      userProfile.updatedAt = DateTime.now();
      userProfile.needsSync = true;

      await _isar.writeTxn(() async {
        await _isar.userProfileIsars.put(userProfile);
      });

      AppLogger.info(
        'KYC tier updated to: ${tier.name}',
        tag: 'ManageAccountStatus',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to update KYC tier',
        tag: 'ManageAccountStatus',
        error: e,
      );
      rethrow;
    }
  }

  /// Suspend account
  Future<void> suspendAccount(String userId, {String? reason}) async {
    await updateAccountStatus(userId: userId, status: AccountStatus.suspended);
    AppLogger.warn(
      'Account suspended${reason != null ? ": $reason" : ""}',
      tag: 'ManageAccountStatus',
    );
  }

  /// Activate account
  Future<void> activateAccount(String userId) async {
    await updateAccountStatus(userId: userId, status: AccountStatus.active);
    AppLogger.info('Account activated', tag: 'ManageAccountStatus');
  }

  /// Request verification
  Future<void> requestVerification(String userId) async {
    await updateAccountStatus(
      userId: userId,
      status: AccountStatus.pendingVerification,
    );
    AppLogger.info('Verification requested', tag: 'ManageAccountStatus');
  }

  /// Check if account is active
  Future<bool> isAccountActive(String userId) async {
    final userProfile = await _getUserProfile(userId);
    return userProfile?.accountStatus == AccountStatus.active;
  }

  /// Check if account is suspended
  Future<bool> isAccountSuspended(String userId) async {
    final userProfile = await _getUserProfile(userId);
    return userProfile?.accountStatus == AccountStatus.suspended;
  }

  /// Check if account needs verification
  Future<bool> needsVerification(String userId) async {
    final userProfile = await _getUserProfile(userId);
    return userProfile?.accountStatus == AccountStatus.pendingVerification;
  }

  /// Get account status
  Future<AccountStatus?> getAccountStatus(String userId) async {
    final userProfile = await _getUserProfile(userId);
    return userProfile?.accountStatus;
  }

  /// Get KYC tier
  Future<KycTier?> getKycTier(String userId) async {
    final userProfile = await _getUserProfile(userId);
    return userProfile?.kycTier;
  }

  /// Check if user has completed KYC
  Future<bool> hasCompletedKyc(String userId) async {
    final tier = await getKycTier(userId);
    return tier != null && tier != KycTier.basic;
  }

  /// Get user profile from Isar
  Future<UserProfileIsar?> _getUserProfile(String userId) async {
    return await _isar.userProfileIsars.where().uidEqualTo(userId).findFirst();
  }
}

/// KYC verification status
enum KycVerificationStatus {
  notStarted,
  inProgress,
  pendingReview,
  approved,
  rejected,
}

/// KYC document type
enum KycDocumentType {
  nationalId,
  passport,
  drivingLicense,
  utilityBill,
  bankStatement,
}
