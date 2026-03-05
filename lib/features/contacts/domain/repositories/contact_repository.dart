import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// Repository interface for contact management operations.
///
/// Defines the contract for contact data access,
/// abstracting the data layer from the domain layer.
abstract class ContactRepository {
  // ==========================================================================
  // READ OPERATIONS
  // ==========================================================================

  /// Gets all contacts for the current user.
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// Returns list of contacts sorted by name
  Future<List<Contact>> getContacts(String ownerId);

  /// Gets a single contact by ID.
  ///
  /// [contactId] - Unique contact identifier
  /// Returns the contact or null if not found
  Future<Contact?> getContactById(String contactId);

  /// Gets all favorite contacts for a user.
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// Returns list of favorited contacts
  Future<List<Contact>> getFavoriteContacts(String ownerId);

  /// Gets contacts filtered by category.
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// [category] - Category to filter by (business, personal, friends, family, uncategorized)
  /// Returns list of contacts in the specified category
  Future<List<Contact>> getContactsByCategory(String ownerId, String category);

  /// Searches contacts by query string.
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// [query] - Search query (matches name, company, job title)
  /// Returns list of matching contacts
  Future<List<Contact>> searchContacts(String ownerId, String query);

  /// Gets contacts filtered by source (e.g. 'scan', 'import').
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// [source] - Source string to filter by matching `ContactSources`
  /// Returns list of contacts matching the source
  Future<List<Contact>> getContactsBySource(String ownerId, String source);

  /// Gets the total count of contacts for a user.
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// Returns the total contact count
  Future<int> getContactsCount(String ownerId);

  /// Gets contacts shared with a specific team.
  ///
  /// [teamId] - ID of the team
  /// Returns list of contacts shared with the team

  // ==========================================================================
  // STREAM OPERATIONS
  // ==========================================================================

  /// Watches contacts for real-time updates.
  ///
  /// [ownerId] - ID of the user who owns the contacts
  /// Returns a stream of contact lists
  Stream<List<Contact>> watchContacts(String ownerId);

  /// Watches a single contact for real-time updates.
  ///
  /// [contactId] - Unique contact identifier
  /// Returns a stream of the contact
  Stream<Contact?> watchContact(String contactId);

  // ==========================================================================
  // CREATE OPERATIONS
  // ==========================================================================

  /// Creates a new contact.
  ///
  /// [contact] - The contact to create
  /// Returns the created contact with generated ID
  /// Throws [ContactFailure] if creation fails
  Future<Contact> createContact(Contact contact);

  /// Creates multiple contacts in a single transaction.
  ///
  /// [contacts] - List of contacts to create
  /// Returns the number of created contacts
  /// Throws [ContactFailure] if batch creation fails
  Future<int> createContacts(List<Contact> contacts);

  // ==========================================================================
  // UPDATE OPERATIONS
  // ==========================================================================

  /// Updates an existing contact.
  ///
  /// [contact] - The contact with updated fields
  /// Returns the updated contact
  /// Throws [ContactFailure] if update fails
  Future<Contact> updateContact(Contact contact);

  /// Toggles the favorite status of a contact.
  ///
  /// [contactId] - ID of the contact to toggle
  /// Returns the updated favorite status
  Future<bool> toggleFavorite(String contactId);

  /// Updates the last contacted timestamp.
  ///
  /// [contactId] - ID of the contact
  /// Increments the contact count and updates timestamp
  Future<void> updateLastContacted(String contactId);

  /// Shares a contact with a team.
  ///
  /// [contactId] - ID of the contact
  /// [teamId] - ID of the team
  Future<void> shareContactWithTeam(String contactId, String teamId);

  /// Unshares a contact from a team.
  ///
  /// [contactId] - ID of the contact
  /// [teamId] - ID of the team
  Future<void> unshareContactWithTeam(String contactId, String teamId);

  // ==========================================================================
  // DELETE OPERATIONS
  // ==========================================================================

  /// Deletes a contact by ID.
  ///
  /// [contactId] - ID of the contact to delete
  /// Returns true if deletion was successful
  /// Throws [ContactFailure] if deletion fails
  Future<bool> deleteContact(String contactId);

  /// Deletes all contacts for a user.
  ///
  /// [ownerId] - ID of the user whose contacts to delete
  /// Returns the number of deleted contacts
  Future<int> deleteAllContacts(String ownerId);

  // ==========================================================================
  // SYNC OPERATIONS
  // ==========================================================================

  /// Syncs local contacts to remote storage.
  ///
  /// [ownerId] - ID of the user whose contacts to sync
  /// Returns the number of synced contacts
  Future<int> syncContacts(String ownerId);

  /// Gets contacts that need to be synced.
  ///
  /// [ownerId] - ID of the user
  /// Returns list of contacts pending sync
  Future<List<Contact>> getContactsNeedingSync(String ownerId);
}
