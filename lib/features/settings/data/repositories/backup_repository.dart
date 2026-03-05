import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/core/config/config_provider.dart';
import 'package:mobile_wallet/core/services/google_drive_service.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/domain/repositories/contact_repository.dart';
import 'package:mobile_wallet/features/contacts/data/repositories/contact_repository_impl.dart';
import 'package:mobile_wallet/features/auth/data/repositories/auth_repository_impl.dart';

/// Repository for handling contact backups to Google Drive.
class BackupRepository {
  final GoogleDriveService _driveService;
  final ContactRepository _contactRepository;
  final Ref _ref;

  BackupRepository(this._driveService, this._contactRepository, this._ref);

  /// Performs a full backup of all contacts to Google Drive.
  Future<bool> performBackup() async {
    try {
      // 1. Get current user
      final authRepo = _ref.read(authRepositoryProvider);
      final currentUser = authRepo.currentUser;
      if (currentUser == null) return false;

      // 2. Get all contacts
      final contacts = await _contactRepository.getContacts(currentUser.id);
      if (contacts.isEmpty) return false;

      // 2. Serialize to JSON
      final jsonData = jsonEncode(contacts.map((c) => c.toJson()).toList());

      // 3. Get backup config
      final config = _ref.read(appConfigProvider);
      final folderName = config.backupConfig.driveFolderName;
      final filename = config.backupConfig.generateBackupFilename();

      // 4. Find/Create folder
      final folderId = await _driveService.findOrCreateBackupFolder(folderName);
      if (folderId == null) return false;

      // 5. Upload file
      final fileId = await _driveService.uploadBackupFile(
        folderId: folderId,
        filename: filename,
        content: jsonData,
      );

      return fileId != null;
    } catch (e) {
      print('[BackupRepository] Backup failed: $e');
      return false;
    }
  }

  /// Restores contacts from a specific backup file.
  Future<int> restoreFromBackup(String fileId) async {
    try {
      // 1. Download data
      final jsonData = await _driveService.downloadBackup(fileId);
      if (jsonData == null) return 0;

      // 2. Parse data
      final List<dynamic> list = jsonDecode(jsonData);
      final List<Contact> contacts = list
          .map((item) => Contact.fromJson(item as Map<String, dynamic>))
          .toList();

      if (contacts.isEmpty) return 0;

      // 3. Import contacts (using batch method for efficiency)
      return await _contactRepository.createContacts(contacts);
    } catch (e) {
      print('[BackupRepository] Restore failed: $e');
      return 0;
    }
  }

  /// Lists available backups on Google Drive.
  Future<List<Map<String, dynamic>>> getAvailableBackups() async {
    final config = _ref.read(appConfigProvider);
    final folderName = config.backupConfig.driveFolderName;

    final folderId = await _driveService.findOrCreateBackupFolder(folderName);
    if (folderId == null) return [];

    final files = await _driveService.listBackups(folderId);
    return files
        .map(
          (f) => {
            'id': f.id,
            'name': f.name,
            'date': f.createdTime,
            'size': f.size,
          },
        )
        .toList();
  }
}

/// Provider for BackupRepository
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final driveService = ref.watch(googleDriveServiceProvider);
  final contactRepository = ref.watch(contactRepositoryProvider);
  return BackupRepository(driveService, contactRepository, ref);
});
