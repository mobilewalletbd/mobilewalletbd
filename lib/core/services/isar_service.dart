// Isar Database Service for Smart Contact Wallet V1
// Manages local database initialization and operations

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart';
import 'package:mobile_wallet/core/utils/app_logger.dart';

/// Service class for managing Isar database
class IsarService {
  static Isar? _isar;

  /// Get the Isar instance
  static Isar get instance {
    if (_isar == null) {
      throw Exception('Isar not initialized. Call initialize() first.');
    }
    return _isar!;
  }

  /// Initialize the Isar database
  /// Should be called during app startup before any database operations
  static Future<void> initialize() async {
    if (_isar != null) {
      return; // Already initialized
    }

    try {
      final dir = await getApplicationDocumentsDirectory();

      _isar = await Isar.open(
        [
          // Auth & User Profile Schemas
          AuthUserIsarSchema,
          UserProfileIsarSchema,

          // Contact Management Schemas
          ContactIsarSchema,
          GlobalContactIsarSchema,

          // Digital Card Schema
          CardDesignIsarSchema,

          // Wallet & Transaction Schemas
          WalletIsarSchema,
          WalletTransactionIsarSchema,

          // Team Schema
          TeamIsarSchema,

          // Notification Schema
          NotificationIsarSchema,

          // Settings Schema
          AppSettingsIsarSchema,

          // Sync Queue Schema
          SyncQueueIsarSchema,
        ],
        directory: dir.path,
        name: 'mobile_wallet_db',
        inspector: true, // Enable Isar Inspector in debug mode
      );

      AppLogger.info(
        'Isar database initialized successfully',
        tag: 'IsarService',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to initialize Isar',
        tag: 'IsarService',
        error: e,
      );
      rethrow;
    }
  }

  /// Close the Isar instance
  /// Should be called when the app is disposed
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  /// Clear all data from the database
  /// WARNING: This will delete all local data!
  static Future<void> clearAllData() async {
    if (_isar == null) return;

    await _isar!.writeTxn(() async {
      await _isar!.clear();
    });

    AppLogger.info('All local data cleared', tag: 'IsarService');
  }

  /// Get database size in bytes
  static Future<int> getDatabaseSize() async {
    if (_isar == null) return 0;
    return await _isar!.getSize();
  }

  /// Export database to JSON (for backup/debug)
  static Future<Map<String, dynamic>> exportToJson() async {
    if (_isar == null) {
      throw Exception('Isar not initialized');
    }

    return {
      'authUsers': await _isar!.authUserIsars.where().exportJson(),
      'userProfiles': await _isar!.userProfileIsars.where().exportJson(),
      'contacts': await _isar!.contactIsars.where().exportJson(),
      'cardDesigns': await _isar!.cardDesignIsars.where().exportJson(),
      'wallets': await _isar!.walletIsars.where().exportJson(),
      'transactions': await _isar!.walletTransactionIsars.where().exportJson(),
      'teams': await _isar!.teamIsars.where().exportJson(),
      'notifications': await _isar!.notificationIsars.where().exportJson(),
      'appSettings': await _isar!.appSettingsIsars.where().exportJson(),
    };
  }
}
