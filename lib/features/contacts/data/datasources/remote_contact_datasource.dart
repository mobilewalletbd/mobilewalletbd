// Remote data source for Contact entity using Firebase Firestore
// Implements cloud storage operations for contact synchronization

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/core/database/firestore_collections.dart';
import 'package:mobile_wallet/core/services/firestore_service.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// Remote data source for Contact entity
/// Handles all Firestore operations for contacts
class RemoteContactDataSource {
  final FirestoreService _firestoreService;

  RemoteContactDataSource(this._firestoreService);

  /// Get the contacts collection reference
  CollectionReference<Map<String, dynamic>> get _contactsRef =>
      _firestoreService.contactsCollection;

  // ==========================================================================
  // CREATE OPERATIONS
  // ==========================================================================

  /// Create a new contact in Firestore
  Future<void> createContact(Contact contact) async {
    final data = _contactToMap(contact);
    await _contactsRef.doc(contact.id).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================================
  // READ OPERATIONS
  // ==========================================================================

  /// Get all contacts for a specific owner
  Future<List<Contact>> getContactsByOwner(String ownerId) async {
    final snapshot = await _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('fullName')
        .get();

    return snapshot.docs
        .map((doc) => _mapToContact(doc.data(), doc.id))
        .toList();
  }

  /// Get a single contact by ID
  Future<Contact?> getContactById(String contactId) async {
    final doc = await _contactsRef.doc(contactId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return _mapToContact(doc.data()!, doc.id);
  }

  /// Get favorite contacts for a user
  Future<List<Contact>> getFavoriteContacts(String ownerId) async {
    final snapshot = await _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .where('isFavorite', isEqualTo: true)
        .orderBy('fullName')
        .get();

    return snapshot.docs
        .map((doc) => _mapToContact(doc.data(), doc.id))
        .toList();
  }

  /// Get contacts by category
  Future<List<Contact>> getContactsByCategory(
    String ownerId,
    String category,
  ) async {
    final snapshot = await _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .where('category', isEqualTo: category)
        .orderBy('fullName')
        .get();

    return snapshot.docs
        .map((doc) => _mapToContact(doc.data(), doc.id))
        .toList();
  }

  /// Search contacts by query (note: Firestore has limited text search)
  /// For full-text search, consider using Algolia or similar
  Future<List<Contact>> searchContacts(String ownerId, String query) async {
    // Firestore doesn't support full-text search natively
    // This is a simple prefix search on fullName
    final lowerQuery = query.toLowerCase();

    final snapshot = await _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('fullName')
        .get();

    // Filter locally for more flexible search
    return snapshot.docs
        .map((doc) => _mapToContact(doc.data(), doc.id))
        .where(
          (contact) =>
              contact.fullName.toLowerCase().contains(lowerQuery) ||
              (contact.companyName?.toLowerCase().contains(lowerQuery) ??
                  false) ||
              (contact.jobTitle?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  /// Get contacts count for owner
  Future<int> getContactsCount(String ownerId) async {
    final snapshot = await _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  // ==========================================================================
  // STREAM OPERATIONS
  // ==========================================================================

  /// Watch contacts for real-time updates
  Stream<List<Contact>> watchContacts(String ownerId) {
    return _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('fullName')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _mapToContact(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Watch a single contact
  Stream<Contact?> watchContact(String contactId) {
    return _contactsRef.doc(contactId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return _mapToContact(doc.data()!, doc.id);
    });
  }

  // ==========================================================================
  // UPDATE OPERATIONS
  // ==========================================================================

  /// Update an existing contact
  Future<void> updateContact(Contact contact) async {
    final data = _contactToMap(contact);
    await _contactsRef.doc(contact.id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String contactId, bool isFavorite) async {
    await _contactsRef.doc(contactId).update({
      'isFavorite': isFavorite,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update last contacted timestamp
  Future<void> updateLastContacted(String contactId, int newCount) async {
    await _contactsRef.doc(contactId).update({
      'lastContactedAt': FieldValue.serverTimestamp(),
      'contactCount': newCount,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================================
  // DELETE OPERATIONS
  // ==========================================================================

  /// Delete a contact by ID
  Future<void> deleteContact(String contactId) async {
    await _contactsRef.doc(contactId).delete();
  }

  /// Delete all contacts for an owner (batch operation)
  Future<int> deleteAllContacts(String ownerId) async {
    final batch = _firestoreService.instance.batch();
    final snapshot = await _contactsRef
        .where('ownerId', isEqualTo: ownerId)
        .get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    return snapshot.docs.length;
  }

  // ==========================================================================
  // BATCH OPERATIONS
  // ==========================================================================

  /// Sync multiple contacts in a batch
  Future<void> syncContacts(List<Contact> contacts) async {
    final batch = _firestoreService.instance.batch();

    for (final contact in contacts) {
      final data = _contactToMap(contact);
      batch.set(_contactsRef.doc(contact.id), {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  // ==========================================================================
  // MAPPING METHODS
  // ==========================================================================

  /// Convert Contact entity to Firestore map
  Map<String, dynamic> _contactToMap(Contact contact) {
    return FirestoreContact.toMap(
      contactId: contact.id,
      ownerId: contact.ownerId,
      fullName: contact.fullName,
      jobTitle: contact.jobTitle,
      companyName: contact.companyName,
      phoneNumbers: contact.phoneNumbers,
      emails: contact.emails,
      addresses: contact.addresses,
      websiteUrls: contact.websiteUrls,
      socialLinks: contact.socialLinks
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
      category: contact.category,
      tags: contact.tags,
      isFavorite: contact.isFavorite,
      notes: contact.notes,
      frontImageUrl: contact.frontImageUrl,
      backImageUrl: contact.backImageUrl,
      frontImageOcrText: contact.frontImageOcrText,
      backImageOcrText: contact.backImageOcrText,
      ocrFields: contact.ocrFields,
      lastContactedAt: contact.lastContactedAt,
      contactCount: contact.contactCount,
      source: contact.source,
      isVerified: contact.isVerified,
      fraudScore: contact.fraudScore,
      createdBy: contact.createdBy,
      sharedWith: contact.sharedWith,
      createdAt: contact.createdAt,
      updatedAt: contact.updatedAt,
    );
  }

  /// Convert Firestore document to Contact entity
  Contact _mapToContact(Map<String, dynamic> data, String docId) {
    // Parse social links
    final socialLinksData = data['socialLinks'] as List<dynamic>? ?? [];
    final socialLinks = socialLinksData
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

    // Parse timestamps
    DateTime? parseTimestamp(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return Contact(
      id: data['contactId'] ?? docId,
      ownerId: data['ownerId'] ?? '',
      fullName: data['fullName'] ?? '',
      jobTitle: data['jobTitle'],
      companyName: data['companyName'],
      phoneNumbers: List<String>.from(data['phoneNumbers'] ?? []),
      emails: List<String>.from(data['emails'] ?? []),
      addresses: List<String>.from(data['addresses'] ?? []),
      websiteUrls: List<String>.from(data['websiteUrls'] ?? []),
      socialLinks: socialLinks,
      category: data['category'] ?? 'uncategorized',
      tags: List<String>.from(data['tags'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
      notes: data['notes'],
      frontImageUrl: data['frontImageUrl'],
      backImageUrl: data['backImageUrl'],
      frontImageOcrText: data['frontImageOcrText'],
      backImageOcrText: data['backImageOcrText'],
      ocrFields: data['ocrFields'] != null
          ? Map<String, dynamic>.from(data['ocrFields'])
          : null,
      lastContactedAt: parseTimestamp(data['lastContactedAt']),
      contactCount: data['contactCount'] ?? 0,
      source: data['source'],
      isVerified: data['isVerified'] ?? false,
      fraudScore: (data['fraudScore'] ?? 0.0).toDouble(),
      createdAt: parseTimestamp(data['createdAt']) ?? DateTime.now(),
      updatedAt: parseTimestamp(data['updatedAt']) ?? DateTime.now(),
      createdBy: data['createdBy'],
      sharedWith: data['sharedWith'] != null
          ? List<String>.from(data['sharedWith'])
          : null,
    );
  }
}

/// Provider for RemoteContactDataSource
final remoteContactDataSourceProvider = Provider<RemoteContactDataSource>((
  ref,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return RemoteContactDataSource(firestoreService);
});
