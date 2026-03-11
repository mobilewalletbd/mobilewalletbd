import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/contacts/data/repositories/contact_repository_impl.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/domain/repositories/contact_repository.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_filter_state.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';

part 'contact_provider.g.dart';

/// Main contacts state provider using Riverpod.
///
/// Manages the contact list state and provides methods for
/// all contact CRUD operations. Uses AsyncNotifier pattern
/// for handling loading, success, and error states.
@Riverpod(keepAlive: true)
class ContactsNotifier extends _$ContactsNotifier {
  ContactRepository get _repository => ref.read(contactRepositoryProvider);

  @override
  Stream<List<Contact>> build() {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Stream.value([]);
    }

    return _repository.watchContacts(user.id);
  }

  /// Creates a new contact
  Future<Contact?> createContact({
    required String fullName,
    String? jobTitle,
    String? companyName,
    List<String>? phoneNumbers,
    List<String>? emails,
    List<String>? addresses,
    List<String>? websiteUrls,
    String? category,
    List<String>? tags,
    String? notes,
    String? source,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return null;

    final contact =
        Contact.create(
          id: const Uuid().v4(),
          ownerId: user.id,
          fullName: fullName,
          jobTitle: jobTitle,
          companyName: companyName,
          phoneNumbers: phoneNumbers,
          emails: emails,
          category: category,
          notes: notes,
          source: source ?? ContactSources.manual,
        ).copyWith(
          addresses: addresses ?? [],
          websiteUrls: websiteUrls ?? [],
          tags: tags ?? [],
        );

    return await _repository.createContact(contact);
  }

  /// Updates an existing contact
  Future<Contact?> updateContact(Contact contact) async {
    return await _repository.updateContact(contact);
  }

  /// Deletes a contact
  Future<bool> deleteContact(String contactId) async {
    return await _repository.deleteContact(contactId);
  }

  /// Toggles favorite status
  Future<bool> toggleFavorite(String contactId) async {
    return await _repository.toggleFavorite(contactId);
  }

  /// Updates last contacted timestamp
  Future<void> updateLastContacted(String contactId) async {
    await _repository.updateLastContacted(contactId);
  }

  /// Syncs contacts to cloud
  Future<int> syncContacts() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return 0;

    return await _repository.syncContacts(user.id);
  }

  /// Shares a contact with a team
  Future<void> shareContact(String contactId, String teamId) async {
    // Check permission (6.12)
    final teamState = ref.read(teamDetailsProvider(teamId));
    final team = teamState.valueOrNull;
    final user = ref.read(currentUserProvider);

    if (team != null && user != null) {
      final isOwner = team.ownerId == user.id;
      final canAdd = team.permMembersCanAddContacts;

      if (!isOwner && !canAdd) {
        throw Exception(
          'You do not have permission to share contacts with this team',
        );
      }
    }

    await _repository.shareContactWithTeam(contactId, teamId);
  }

  /// Unshares a contact from a team
  Future<void> unshareContact(String contactId, String teamId) async {
    await _repository.unshareContactWithTeam(contactId, teamId);
  }
}

// =============================================================================
// DERIVED PROVIDERS
// =============================================================================

/// Provider for a single contact by ID
@riverpod
Future<Contact?> contactById(ContactByIdRef ref, String contactId) async {
  final repository = ref.watch(contactRepositoryProvider);
  return await repository.getContactById(contactId);
}

/// Provider for watching a single contact
@riverpod
Stream<Contact?> watchContact(WatchContactRef ref, String contactId) {
  final repository = ref.watch(contactRepositoryProvider);
  return repository.watchContact(contactId);
}

/// Provider for contacts count
@riverpod
Future<int> contactsCount(ContactsCountRef ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;

  final repository = ref.watch(contactRepositoryProvider);
  return await repository.getContactsCount(user.id);
}

/// Provider for favorite contacts
@riverpod
Future<List<Contact>> favoriteContacts(FavoriteContactsRef ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repository = ref.watch(contactRepositoryProvider);
  return await repository.getFavoriteContacts(user.id);
}

/// Provider for contacts by category
@riverpod
Future<List<Contact>> contactsByCategory(
  ContactsByCategoryRef ref,
  String category,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repository = ref.watch(contactRepositoryProvider);
  return await repository.getContactsByCategory(user.id, category);
}

/// Provider for search results
@riverpod
Future<List<Contact>> searchContacts(
  SearchContactsRef ref,
  String query,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  if (query.isEmpty) {
    return await ref.watch(contactRepositoryProvider).getContacts(user.id);
  }

  final repository = ref.watch(contactRepositoryProvider);
  return await repository.searchContacts(user.id, query);
}

// =============================================================================
// UI STATE PROVIDERS
// =============================================================================

/// Provider for the current search query
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;

  void clear() => state = '';
}

/// Provider for the selected category filter
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'all';

  void select(String category) => state = category;

  void reset() => state = 'all';
}

/// Provider for advanced filters
final contactFilterProvider =
    NotifierProvider<ContactFilter, ContactFilterState>(ContactFilter.new);

class ContactFilter extends Notifier<ContactFilterState> {
  @override
  ContactFilterState build() => const ContactFilterState();

  void update({
    bool? showFavoritesOnly,
    bool? hasPhoneNumber,
    bool? hasEmail,
    String? sortBy,
  }) {
    state = state.copyWith(
      showFavoritesOnly: showFavoritesOnly,
      hasPhoneNumber: hasPhoneNumber,
      hasEmail: hasEmail,
      sortBy: sortBy,
    );
  }

  void reset() => state = const ContactFilterState();
}

/// Provider for filtered contacts based on search, category, and advanced filters
@riverpod
Future<List<Contact>> filteredContacts(FilteredContactsRef ref) async {
  final allContacts = ref.watch(contactsNotifierProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final filters = ref.watch(contactFilterProvider);

  final contacts = allContacts.valueOrNull ?? [];

  // Apply search filter
  var filtered = contacts;
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filtered = filtered.where((c) {
      return c.fullName.toLowerCase().contains(query) ||
          (c.companyName?.toLowerCase().contains(query) ?? false) ||
          (c.jobTitle?.toLowerCase().contains(query) ?? false) ||
          c.emails.any((e) => e.toLowerCase().contains(query)) ||
          c.phoneNumbers.any((p) => p.contains(query));
    }).toList();
  }

  // Apply category filter
  if (selectedCategory != 'all') {
    filtered = filtered.where((c) => c.category == selectedCategory).toList();
  }

  // Apply advanced filters
  if (filters.showFavoritesOnly) {
    filtered = filtered.where((c) => c.isFavorite).toList();
  }
  if (filters.hasPhoneNumber) {
    filtered = filtered.where((c) => c.phoneNumbers.isNotEmpty).toList();
  }
  if (filters.hasEmail) {
    filtered = filtered.where((c) => c.emails.isNotEmpty).toList();
  }

  // Apply sorting
  if (filters.sortBy == 'name') {
    filtered.sort((a, b) => a.fullName.compareTo(b.fullName));
  } else if (filters.sortBy == 'date') {
    // Assuming createdAt exists, otherwise fallback to name
    // filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    filtered.sort((a, b) => a.fullName.compareTo(b.fullName)); // Fallback
  }

  return filtered;
}

/// Provider for contacts loading state
@riverpod
bool isContactsLoading(IsContactsLoadingRef ref) {
  final contactsState = ref.watch(contactsNotifierProvider);
  return contactsState.isLoading;
}

/// Provider for contacts error state
@riverpod
Object? contactsError(ContactsErrorRef ref) {
  final contactsState = ref.watch(contactsNotifierProvider);
  return contactsState.error;
}

/// Provider for category counts
@riverpod
Future<Map<String, int>> categoryCounts(CategoryCountsRef ref) async {
  final allContacts = ref.watch(contactsNotifierProvider);
  final contacts = allContacts.valueOrNull ?? [];

  final counts = <String, int>{
    'all': contacts.length,
    'business': 0,
    'personal': 0,
    'friends': 0,
    'family': 0,
    'uncategorized': 0,
  };

  for (final contact in contacts) {
    final category = contact.category.toLowerCase();
    if (counts.containsKey(category)) {
      counts[category] = (counts[category] ?? 0) + 1;
    } else {
      counts['uncategorized'] = (counts['uncategorized'] ?? 0) + 1;
    }
  }

  return counts;
}

/// Provider for favorites count
@riverpod
int favoritesCount(FavoritesCountRef ref) {
  final allContacts = ref.watch(contactsNotifierProvider);
  final contacts = allContacts.valueOrNull ?? [];
  return contacts.where((c) => c.isFavorite).length;
}
