// Contact Repository Implementation
// Coordinates between local (Isar) and remote (Firestore) data sources
// Implements offline-first pattern with background sync

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:mobile_wallet/features/contacts/data/datasources/remote_contact_datasource.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/domain/failures/contact_failure.dart';
import 'package:mobile_wallet/features/contacts/domain/repositories/contact_repository.dart';

/// Implementation of ContactRepository
/// Uses Isar for local storage and Firestore for cloud sync
class ContactRepositoryImpl implements ContactRepository {
  final Isar _isar;
  final RemoteContactDataSource _remoteDataSource;

  ContactRepositoryImpl(this._isar, this._remoteDataSource);

  // ==========================================================================
  // READ OPERATIONS
  // ==========================================================================

  @override
  Future<List<Contact>> getContacts(String ownerId) async {
    try {
      final contacts = await _isar.contactIsars
          .filter()
          .ownerIdEqualTo(ownerId)
          .sortByFullName()
          .findAll();

      return contacts.map(_mapFromIsar).toList();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  @override
  Future<Contact?> getContactById(String contactId) async {
    try {
      final contact = await _isar.contactIsars
          .filter()
          .contactIdEqualTo(contactId)
          .findFirst();

      return contact != null ? _mapFromIsar(contact) : null;
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  @override
  Future<List<Contact>> getFavoriteContacts(String ownerId) async {
    try {
      final contacts = await _isar.contactIsars
          .filter()
          .ownerIdEqualTo(ownerId)
          .isFavoriteEqualTo(true)
          .sortByFullName()
          .findAll();

      return contacts.map(_mapFromIsar).toList();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  @override
  Future<List<Contact>> getContactsByCategory(
    String ownerId,
    String category,
  ) async {
    try {
      final categoryEnum = ContactCategory.values.firstWhere(
        (e) => e.name.toLowerCase() == category.toLowerCase(),
        orElse: () => ContactCategory.uncategorized,
      );

      final contacts = await _isar.contactIsars
          .filter()
          .ownerIdEqualTo(ownerId)
          .categoryEqualTo(categoryEnum)
          .sortByFullName()
          .findAll();

      return contacts.map(_mapFromIsar).toList();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  @override
  Future<List<Contact>> searchContacts(String ownerId, String query) async {
    try {
      final contacts = await _isar.contactIsars
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
          .sortByFullName()
          .findAll();

      return contacts.map(_mapFromIsar).toList();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  @override
  Future<List<Contact>> getContactsBySource(
    String ownerId,
    String source,
  ) async {
    try {
      final sourceEnum = ContactSource.values.firstWhere(
        (e) => e.name.toLowerCase() == source.toLowerCase(),
        orElse: () => ContactSource.manual,
      );

      final contacts = await _isar.contactIsars
          .filter()
          .ownerIdEqualTo(ownerId)
          .sourceEqualTo(sourceEnum)
          .sortByCreatedAtDesc() // Generally more useful to see recent scans first
          .findAll();

      return contacts.map(_mapFromIsar).toList();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  @override
  Future<int> getContactsCount(String ownerId) async {
    try {
      return await _isar.contactIsars.filter().ownerIdEqualTo(ownerId).count();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  // ==========================================================================
  // STREAM OPERATIONS
  // ==========================================================================

  @override
  Stream<List<Contact>> watchContacts(String ownerId) {
    return _isar.contactIsars
        .filter()
        .ownerIdEqualTo(ownerId)
        .sortByFullName()
        .watch(fireImmediately: true)
        .map((contacts) => contacts.map(_mapFromIsar).toList());
  }

  @override
  Stream<Contact?> watchContact(String contactId) {
    return _isar.contactIsars
        .filter()
        .contactIdEqualTo(contactId)
        .watch(fireImmediately: true)
        .map(
          (contacts) =>
              contacts.isNotEmpty ? _mapFromIsar(contacts.first) : null,
        );
  }

  // ==========================================================================
  // CREATE OPERATIONS
  // ==========================================================================

  @override
  Future<Contact> createContact(Contact contact) async {
    try {
      print(
        '[ContactRepository] Creating contact: ${contact.fullName} (${contact.id})',
      );

      await _isar.writeTxn(() async {
        final isarContact = _mapToIsar(contact);

        // CRITICAL: Preserve local Isar ID if contact already exists
        // prevents unique constraint violation on `contactId`
        final existing = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(contact.id)
            .findFirst();

        if (existing != null) {
          isarContact.id = existing.id;
        }

        await _isar.contactIsars.put(isarContact);
      });
      print('[ContactRepository] Contact saved to Isar: ${contact.fullName}');

      // Queue for background sync
      await _addToSyncQueue(contact.id, SyncOperation.create);

      // Try to sync to remote (non-blocking)
      _syncToRemote(contact, SyncOperation.create);

      return contact;
    } catch (e) {
      print('[ContactRepository] Error creating contact: $e');
      throw ContactFailure.storageError('create', e);
    }
  }

  @override
  Future<int> createContacts(List<Contact> contacts) async {
    try {
      print('[ContactRepository] Batch creating ${contacts.length} contacts');

      await _isar.writeTxn(() async {
        final isarContacts = <ContactIsar>[];
        for (final contact in contacts) {
          final isarContact = _mapToIsar(contact);

          // CRITICAL: Preserve local Isar ID if contact already exists
          // prevents unique constraint violation on `contactId`
          final existing = await _isar.contactIsars
              .filter()
              .contactIdEqualTo(contact.id)
              .findFirst();

          if (existing != null) {
            isarContact.id = existing.id;
          }

          isarContacts.add(isarContact);
        }

        await _isar.contactIsars.putAll(isarContacts);
      });

      // Queue all for background sync
      for (final contact in contacts) {
        await _addToSyncQueue(contact.id, SyncOperation.create);
      }

      // Try to sync to remote (non-blocking, batch)
      _remoteDataSource.syncContacts(contacts).catchError((e) {
        print('[ContactRepository] Batch remote sync failed: $e');
      });

      return contacts.length;
    } catch (e) {
      print('[ContactRepository] Error in batch creation: $e');
      throw ContactFailure.storageError('batch create', e);
    }
  }

  // ==========================================================================
  // UPDATE OPERATIONS
  // ==========================================================================

  @override
  Future<Contact> updateContact(Contact contact) async {
    try {
      final updatedContact = contact.copyWith(updatedAt: DateTime.now());

      await _isar.writeTxn(() async {
        final isarContact = _mapToIsar(updatedContact);

        // CRITICAL: Preserve local Isar ID if contact already exists
        final existing = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(updatedContact.id)
            .findFirst();

        if (existing != null) {
          isarContact.id = existing.id;
        } else {
          throw ContactFailure.notFound(updatedContact.id);
        }

        await _isar.contactIsars.put(isarContact);
      });

      // Queue for background sync
      await _addToSyncQueue(contact.id, SyncOperation.update);

      // Try to sync to remote (non-blocking)
      _syncToRemote(updatedContact, SyncOperation.update);

      return updatedContact;
    } catch (e) {
      throw ContactFailure.storageError('update', e);
    }
  }

  @override
  Future<bool> toggleFavorite(String contactId) async {
    try {
      bool newFavoriteStatus = false;

      await _isar.writeTxn(() async {
        final contact = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(contactId)
            .findFirst();

        if (contact == null) {
          throw ContactFailure.notFound(contactId);
        }

        newFavoriteStatus = !contact.isFavorite;
        contact.isFavorite = newFavoriteStatus;
        contact.updatedAt = DateTime.now();
        contact.needsSync = true;

        await _isar.contactIsars.put(contact);
      });

      // Queue for background sync
      await _addToSyncQueue(contactId, SyncOperation.update);

      return newFavoriteStatus;
    } catch (e) {
      if (e is ContactFailure) rethrow;
      throw ContactFailure.storageError('toggle favorite', e);
    }
  }

  @override
  Future<void> updateLastContacted(String contactId) async {
    try {
      await _isar.writeTxn(() async {
        final contact = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(contactId)
            .findFirst();

        if (contact == null) {
          throw ContactFailure.notFound(contactId);
        }

        contact.lastContactedAt = DateTime.now();
        contact.contactCount++;
        contact.updatedAt = DateTime.now();
        contact.needsSync = true;

        await _isar.contactIsars.put(contact);
      });

      // Queue for background sync
      await _addToSyncQueue(contactId, SyncOperation.update);
    } catch (e) {
      if (e is ContactFailure) rethrow;
      throw ContactFailure.storageError('update last contacted', e);
    }
  }

  @override
  Future<void> shareContactWithTeam(String contactId, String teamId) async {
    try {
      await _isar.writeTxn(() async {
        final contact = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(contactId)
            .findFirst();

        if (contact == null) {
          throw ContactFailure.notFound(contactId);
        }

        final currentTeams = contact.sharedWithTeams.toList();
        if (!currentTeams.contains(teamId)) {
          currentTeams.add(teamId);
          contact.sharedWithTeams = currentTeams;
          contact.updatedAt = DateTime.now();
          contact.needsSync = true;
          await _isar.contactIsars.put(contact);
        }
      });

      await _addToSyncQueue(contactId, SyncOperation.update);
    } catch (e) {
      if (e is ContactFailure) rethrow;
      throw ContactFailure.storageError('share contact', e);
    }
  }

  @override
  Future<void> unshareContactWithTeam(String contactId, String teamId) async {
    try {
      await _isar.writeTxn(() async {
        final contact = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(contactId)
            .findFirst();

        if (contact == null) {
          throw ContactFailure.notFound(contactId);
        }

        final currentTeams = contact.sharedWithTeams.toList();
        if (currentTeams.contains(teamId)) {
          currentTeams.remove(teamId);
          contact.sharedWithTeams = currentTeams;
          contact.updatedAt = DateTime.now();
          contact.needsSync = true;
          await _isar.contactIsars.put(contact);
        }
      });

      await _addToSyncQueue(contactId, SyncOperation.update);
    } catch (e) {
      if (e is ContactFailure) rethrow;
      throw ContactFailure.storageError('unshare contact', e);
    }
  }

  // ==========================================================================
  // DELETE OPERATIONS
  // ==========================================================================

  @override
  Future<bool> deleteContact(String contactId) async {
    try {
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
        // Queue for background sync
        await _addToSyncQueue(contactId, SyncOperation.delete);

        // Try to delete from remote (non-blocking)
        _remoteDataSource.deleteContact(contactId).catchError((_) {});
      }

      return deleted;
    } catch (e) {
      throw ContactFailure.storageError('delete', e);
    }
  }

  @override
  Future<int> deleteAllContacts(String ownerId) async {
    try {
      int count = 0;
      final contactIds = <String>[];

      await _isar.writeTxn(() async {
        final contacts = await _isar.contactIsars
            .filter()
            .ownerIdEqualTo(ownerId)
            .findAll();

        for (final contact in contacts) {
          contactIds.add(contact.contactId);
          await _isar.contactIsars.delete(contact.id);
          count++;
        }
      });

      // Queue all for deletion sync
      for (final id in contactIds) {
        await _addToSyncQueue(id, SyncOperation.delete);
      }

      return count;
    } catch (e) {
      throw ContactFailure.storageError('delete all', e);
    }
  }

  // ==========================================================================
  // SYNC OPERATIONS
  // ==========================================================================

  @override
  Future<int> syncContacts(String ownerId) async {
    try {
      final contactsToSync = await getContactsNeedingSync(ownerId);

      if (contactsToSync.isEmpty) return 0;

      // Sync to remote
      await _remoteDataSource.syncContacts(contactsToSync);

      // Mark as synced locally
      await _isar.writeTxn(() async {
        for (final contact in contactsToSync) {
          final isarContact = await _isar.contactIsars
              .filter()
              .contactIdEqualTo(contact.id)
              .findFirst();

          if (isarContact != null) {
            isarContact.needsSync = false;
            isarContact.lastSyncedAt = DateTime.now();
            await _isar.contactIsars.put(isarContact);
          }
        }
      });

      // Clear sync queue for these contacts
      await _clearSyncQueue(contactsToSync.map((c) => c.id).toList());

      return contactsToSync.length;
    } catch (e) {
      throw ContactFailure.syncError('Failed to sync contacts', e);
    }
  }

  @override
  Future<List<Contact>> getContactsNeedingSync(String ownerId) async {
    try {
      final contacts = await _isar.contactIsars
          .filter()
          .ownerIdEqualTo(ownerId)
          .needsSyncEqualTo(true)
          .findAll();

      return contacts.map(_mapFromIsar).toList();
    } catch (e, stack) {
      throw ContactFailure.fromException(e, stack);
    }
  }

  // ==========================================================================
  // PRIVATE HELPER METHODS
  // ==========================================================================

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

  /// Clear sync queue for contact IDs
  Future<void> _clearSyncQueue(List<String> contactIds) async {
    await _isar.writeTxn(() async {
      for (final id in contactIds) {
        await _isar.syncQueueIsars
            .filter()
            .entityIdEqualTo(id)
            .entityTypeEqualTo(EntityType.contact)
            .deleteAll();
      }
    });
  }

  /// Sync to remote (fire and forget)
  void _syncToRemote(Contact contact, SyncOperation operation) async {
    try {
      switch (operation) {
        case SyncOperation.create:
          await _remoteDataSource.createContact(contact);
          break;
        case SyncOperation.update:
          await _remoteDataSource.updateContact(contact);
          break;
        case SyncOperation.delete:
          await _remoteDataSource.deleteContact(contact.id);
          break;
      }

      // Mark as synced
      await _isar.writeTxn(() async {
        final isarContact = await _isar.contactIsars
            .filter()
            .contactIdEqualTo(contact.id)
            .findFirst();

        if (isarContact != null) {
          isarContact.needsSync = false;
          isarContact.lastSyncedAt = DateTime.now();
          await _isar.contactIsars.put(isarContact);
        }
      });
    } catch (e) {
      // Silently fail - will retry via sync queue
      print(
        '[ContactRepository] Remote sync failed for ${contact.fullName}: $e',
      );
    }
  }

  // ==========================================================================
  // MAPPING METHODS
  // ==========================================================================

  /// Map ContactIsar to Contact domain entity
  Contact _mapFromIsar(ContactIsar isarContact) {
    // Parse social links from JSON
    List<SocialLink> socialLinks = [];
    try {
      final socialLinksData = jsonDecode(isarContact.socialLinks) as List;
      socialLinks = socialLinksData
          .map(
            (sl) => SocialLink(
              platform: sl['platform'] ?? '',
              url: sl['url'] ?? '',
              handle: sl['handle'],
              platformId: sl['platformId'],
              isPublic: sl['isPublic'] ?? true,
            ),
          )
          .toList();
    } catch (_) {
      // Invalid JSON, use empty list
    }

    // Parse OCR fields
    Map<String, dynamic>? ocrFields;
    if (isarContact.ocrFields != null) {
      try {
        ocrFields = jsonDecode(isarContact.ocrFields!) as Map<String, dynamic>;
      } catch (_) {}
    }

    return Contact(
      id: isarContact.contactId,
      ownerId: isarContact.ownerId,
      fullName: isarContact.fullName,
      firstName: isarContact.firstName,
      lastName: isarContact.lastName,
      jobTitle: isarContact.jobTitle,
      companyName: isarContact.companyName,
      phoneNumbers: isarContact.phoneNumbers,
      emails: isarContact.emails,
      addresses: isarContact.addresses,
      websiteUrls: isarContact.websiteUrls,
      socialLinks: socialLinks,
      category: isarContact.category.name,
      tags: isarContact.tags,
      isFavorite: isarContact.isFavorite,
      notes: isarContact.notes,
      frontImageUrl: isarContact.frontImageUrl,
      backImageUrl: isarContact.backImageUrl,
      frontImageOcrText: isarContact.frontImageOcrText,
      backImageOcrText: isarContact.backImageOcrText,
      ocrFields: ocrFields,
      lastContactedAt: isarContact.lastContactedAt,
      contactCount: isarContact.contactCount,
      source: isarContact.source?.name,
      isVerified: isarContact.isVerified,
      fraudScore: isarContact.fraudScore,
      rawExtraData: isarContact.rawExtraData != null
          ? jsonDecode(isarContact.rawExtraData!) as Map<String, dynamic>
          : null,
      createdAt: isarContact.createdAt,
      updatedAt: isarContact.updatedAt,
      createdBy: isarContact.createdBy,
      sharedWith: isarContact.sharedWith.isNotEmpty
          ? isarContact.sharedWith
          : null,
      sharedWithTeams: isarContact.sharedWithTeams,
    );
  }

  /// Map Contact domain entity to ContactIsar
  ContactIsar _mapToIsar(Contact contact) {
    // Serialize social links to JSON
    final socialLinksJson = jsonEncode(
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
    );

    // Parse category enum
    final categoryEnum = ContactCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == contact.category.toLowerCase(),
      orElse: () => ContactCategory.uncategorized,
    );

    // Parse source enum
    ContactSource? sourceEnum;
    if (contact.source != null) {
      sourceEnum = ContactSource.values.firstWhere(
        (e) => e.name.toLowerCase() == contact.source!.toLowerCase(),
        orElse: () => ContactSource.manual,
      );
    }

    return ContactIsar()
      ..contactId = contact.id
      ..ownerId = contact.ownerId
      ..fullName = contact.fullName
      ..firstName = contact.firstName
      ..lastName = contact.lastName
      ..jobTitle = contact.jobTitle
      ..companyName = contact.companyName
      ..phoneNumbers = contact.phoneNumbers
      ..emails = contact.emails
      ..addresses = contact.addresses
      ..websiteUrls = contact.websiteUrls
      ..socialLinks = socialLinksJson
      ..category = categoryEnum
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
      ..source = sourceEnum
      ..isVerified = contact.isVerified
      ..fraudScore = contact.fraudScore
      ..rawExtraData = contact.rawExtraData != null
          ? jsonEncode(contact.rawExtraData)
          : null
      ..createdAt = contact.createdAt
      ..updatedAt = contact.updatedAt
      ..createdBy = contact.createdBy
      ..sharedWith = contact.sharedWith ?? []
      ..sharedWithTeams = contact.sharedWithTeams
      ..needsSync = true;
  }
}

/// Provider for ContactRepository
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final remoteDataSource = ref.watch(remoteContactDataSourceProvider);
  return ContactRepositoryImpl(IsarService.instance, remoteDataSource);
});
