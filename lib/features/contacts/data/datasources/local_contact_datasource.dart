// Local data source for Contact entity using Isar
// Implements offline-first CRUD operations
// Note: This data source is used by ContactRepositoryImpl for local operations

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// Local data source for Contact entity
/// Handles all local database operations for contacts using Isar
class LocalContactDataSource {
  final Isar _isar;

  LocalContactDataSource() : _isar = IsarService.instance;

  // ==========================================================================
  // CREATE OPERATIONS
  // ==========================================================================

  /// Save a new contact to local database
  Future<ContactIsar> createContact(Contact contact) async {
    final isarContact = _mapToIsar(contact);

    await _isar.writeTxn(() async {
      await _isar.contactIsars.put(isarContact);
    });

    // Mark for sync
    await _addToSyncQueue(isarContact.contactId, SyncOperation.create);

    return isarContact;
  }

  // ==========================================================================
  // READ OPERATIONS
  // ==========================================================================

  /// Get all contacts for a specific owner
  Future<List<ContactIsar>> getContactsByOwner(String ownerId) async {
    return await _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .sortByFullNameDesc()
        .findAll();
  }

  /// Get a single contact by ID
  Future<ContactIsar?> getContactById(String contactId) async {
    return await _isar.contactIsars
        .filter()
        .contactIdEqualTo(contactId)
        .findFirst();
  }

  /// Get favorite contacts
  Future<List<ContactIsar>> getFavoriteContacts(String ownerId) async {
    return await _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .isFavoriteEqualTo(true)
        .sortByFullNameDesc()
        .findAll();
  }

  /// Get contacts by category
  Future<List<ContactIsar>> getContactsByCategory(
    String ownerId,
    ContactCategory category,
  ) async {
    return await _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .categoryEqualTo(category)
        .sortByFullNameDesc()
        .findAll();
  }

  /// Search contacts by query
  Future<List<ContactIsar>> searchContacts(String ownerId, String query) async {
    return await _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .group(
          (q) => q
              .fullNameContains(query, caseSensitive: false)
              .or()
              .companyNameContains(query, caseSensitive: false)
              .or()
              .jobTitleContains(query, caseSensitive: false),
        )
        .sortByFullNameDesc()
        .findAll();
  }

  /// Get contacts count for owner
  Future<int> getContactsCount(String ownerId) async {
    return await _isar.contactIsars.filter().ownerIdEqualTo(ownerId).count();
  }

  /// Watch contacts stream for real-time updates
  Stream<List<ContactIsar>> watchContacts(String ownerId) {
    return _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .sortByFullNameDesc()
        .watch(fireImmediately: true);
  }

  // ==========================================================================
  // UPDATE OPERATIONS
  // ==========================================================================

  /// Update an existing contact
  Future<ContactIsar> updateContact(Contact contact) async {
    final isarContact = _mapToIsar(contact);
    isarContact.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.contactIsars.put(isarContact);
    });

    // Mark for sync
    await _addToSyncQueue(isarContact.contactId, SyncOperation.update);

    return isarContact;
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String contactId) async {
    await _isar.writeTxn(() async {
      final contact = await _isar.contactIsars
          .filter()
          .contactIdEqualTo(contactId)
          .findFirst();

      if (contact != null) {
        contact.isFavorite = !contact.isFavorite;
        contact.updatedAt = DateTime.now();
        contact.needsSync = true;
        await _isar.contactIsars.put(contact);
      }
    });

    await _addToSyncQueue(contactId, SyncOperation.update);
  }

  /// Update last contacted timestamp
  Future<void> updateLastContacted(String contactId) async {
    await _isar.writeTxn(() async {
      final contact = await _isar.contactIsars
          .filter()
          .contactIdEqualTo(contactId)
          .findFirst();

      if (contact != null) {
        contact.lastContactedAt = DateTime.now();
        contact.contactCount++;
        contact.updatedAt = DateTime.now();
        contact.needsSync = true;
        await _isar.contactIsars.put(contact);
      }
    });

    await _addToSyncQueue(contactId, SyncOperation.update);
  }

  // ==========================================================================
  // DELETE OPERATIONS
  // ==========================================================================

  /// Delete a contact by ID
  Future<bool> deleteContact(String contactId) async {
    bool deleted = false;

    await _isar.writeTxn(() async {
      final contact = await _isar.contactIsars
          .filter()
          .contactIdEqualTo(contactId)
          .findFirst();

      if (contact != null) {
        deleted = await _isar.contactIsars.delete(contact.id);
      }
    });

    if (deleted) {
      await _addToSyncQueue(contactId, SyncOperation.delete);
    }

    return deleted;
  }

  /// Delete all contacts for an owner
  Future<int> deleteAllContacts(String ownerId) async {
    int count = 0;

    await _isar.writeTxn(() async {
      final contacts = await _isar.contactIsars
          .filter()
          .ownerIdEqualTo(ownerId)
          .findAll();

      for (final contact in contacts) {
        await _isar.contactIsars.delete(contact.id);
        await _addToSyncQueue(contact.contactId, SyncOperation.delete);
        count++;
      }
    });

    return count;
  }

  // ==========================================================================
  // SYNC OPERATIONS
  // ==========================================================================

  /// Get contacts that need to be synced
  Future<List<ContactIsar>> getContactsNeedingSync(String ownerId) async {
    return await _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .needsSyncEqualTo(true)
        .findAll();
  }

  /// Mark contact as synced
  Future<void> markContactAsSynced(String contactId) async {
    await _isar.writeTxn(() async {
      final contact = await _isar.contactIsars
          .filter()
          .contactIdEqualTo(contactId)
          .findFirst();

      if (contact != null) {
        contact.needsSync = false;
        contact.lastSyncedAt = DateTime.now();
        await _isar.contactIsars.put(contact);
      }
    });
  }

  /// Add operation to sync queue
  Future<void> _addToSyncQueue(
    String contactId,
    SyncOperation operation,
  ) async {
    final syncItem = SyncQueueIsar()
      ..operation = operation
      ..entityType = EntityType.contact
      ..entityId = contactId
      ..createdAt = DateTime.now()
      ..status = SyncStatus.pending;

    await _isar.writeTxn(() async {
      await _isar.syncQueueIsars.put(syncItem);
    });
  }

  // ==========================================================================
  // HELPER METHODS
  // ==========================================================================

  /// Map Contact entity to ContactIsar
  ContactIsar _mapToIsar(Contact contact) {
    return ContactIsar()
      ..contactId = contact.id
      ..ownerId = contact.ownerId
      ..fullName = contact.fullName
      ..jobTitle = contact.jobTitle
      ..companyName = contact.companyName
      ..phoneNumbers = contact.phoneNumbers
      ..emails = contact.emails
      ..addresses = contact.addresses
      ..websiteUrls = contact.websiteUrls
      ..socialLinks = jsonEncode(
        contact.socialLinks
            .map(
              (sl) => {
                'platform': sl.platform,
                'url': sl.url,
                'handle': sl.handle,
                'platformId': sl.platformId,
                'isPublic': sl.isPublic,
              },
            )
            .toList(),
      )
      ..category = ContactCategory.values.firstWhere(
        (e) => e.name == contact.category.toLowerCase(),
        orElse: () => ContactCategory.uncategorized,
      )
      ..tags = contact.tags
      ..isFavorite = contact.isFavorite
      ..notes = contact.notes
      ..frontImageUrl = contact.frontImageUrl
      ..backImageUrl = contact.backImageUrl
      ..frontImageOcrText = contact.frontImageOcrText
      ..backImageOcrText = contact.backImageOcrText
      ..ocrFields = contact.ocrFields != null
          ? jsonEncode(contact.ocrFields)
          : null
      ..lastContactedAt = contact.lastContactedAt
      ..contactCount = contact.contactCount
      ..source = contact.source != null
          ? ContactSource.values.firstWhere(
              (e) => e.name == contact.source!.toLowerCase(),
            )
          : null
      ..isVerified = contact.isVerified
      ..fraudScore = contact.fraudScore
      ..createdAt = contact.createdAt
      ..updatedAt = contact.updatedAt
      ..createdBy = contact.createdBy
      ..sharedWith = contact.sharedWith ?? []
      ..needsSync = true;
  }
}

/// Provider for LocalContactDataSource
final localContactDataSourceProvider = Provider<LocalContactDataSource>((ref) {
  return LocalContactDataSource();
});
