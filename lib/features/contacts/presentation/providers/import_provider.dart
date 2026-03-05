// Import Provider for Phone Contact Import
// Manages state for the contact import flow

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/contacts/data/repositories/contact_repository_impl.dart';
import 'package:mobile_wallet/features/contacts/data/services/phone_contact_import_service.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';

part 'import_provider.g.dart';

/// State for phone contact import flow
class ImportState {
  final bool isLoading;
  final bool isImporting;
  final ImportResult? result;
  final Set<String> selectedIds;
  final int importedCount;
  final String? error;

  const ImportState({
    this.isLoading = false,
    this.isImporting = false,
    this.result,
    this.selectedIds = const {},
    this.importedCount = 0,
    this.error,
  });

  ImportState copyWith({
    bool? isLoading,
    bool? isImporting,
    ImportResult? result,
    Set<String>? selectedIds,
    int? importedCount,
    String? error,
  }) {
    return ImportState(
      isLoading: isLoading ?? this.isLoading,
      isImporting: isImporting ?? this.isImporting,
      result: result ?? this.result,
      selectedIds: selectedIds ?? this.selectedIds,
      importedCount: importedCount ?? this.importedCount,
      error: error,
    );
  }

  /// Number of contacts selected for import
  int get selectedCount => selectedIds.length;

  /// Whether all contacts are selected
  bool get allSelected =>
      result != null && selectedIds.length == result!.importableCount;

  /// Whether a contact is selected
  bool isSelected(String id) => selectedIds.contains(id);
}

/// Provider for managing phone contact import
@riverpod
class PhoneContactImportNotifier extends _$PhoneContactImportNotifier {
  @override
  ImportState build() {
    return const ImportState();
  }

  /// Fetch contacts from phone
  Future<void> fetchContacts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not authenticated',
        );
        return;
      }

      // Get existing contacts for duplicate detection
      final existingContacts =
          ref.read(contactsNotifierProvider).valueOrNull ?? [];

      // Fetch phone contacts
      final importService = ref.read(phoneContactImportServiceProvider);
      final result = await importService.fetchPhoneContacts(
        ownerId: user.id,
        existingContacts: existingContacts,
      );

      // Select all new contacts by default
      final selectedIds = <String>{};
      for (final contact in result.newContacts) {
        selectedIds.add(contact.id);
      }

      state = state.copyWith(
        isLoading: false,
        result: result,
        selectedIds: selectedIds,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Toggle selection of a contact
  void toggleSelection(String contactId) {
    final newSelected = Set<String>.from(state.selectedIds);
    if (newSelected.contains(contactId)) {
      newSelected.remove(contactId);
    } else {
      newSelected.add(contactId);
    }
    state = state.copyWith(selectedIds: newSelected);
  }

  /// Select all contacts
  void selectAll() {
    if (state.result == null) return;

    final allIds = <String>{};
    for (final contact in state.result!.newContacts) {
      allIds.add(contact.id);
    }
    for (final dup in state.result!.duplicates) {
      allIds.add(dup.phoneContact.id);
    }
    state = state.copyWith(selectedIds: allIds);
  }

  /// Deselect all contacts
  void deselectAll() {
    state = state.copyWith(selectedIds: {});
  }

  /// Import selected contacts
  Future<int> importSelected() async {
    if (state.result == null || state.selectedIds.isEmpty) return 0;

    state = state.copyWith(isImporting: true, error: null);

    try {
      final repository = ref.read(contactRepositoryProvider);
      int imported = 0;

      // Get all contacts (new + duplicates that are selected)
      final contactsToImport = <Contact>[];

      for (final contact in state.result!.newContacts) {
        if (state.selectedIds.contains(contact.id)) {
          contactsToImport.add(contact);
        }
      }

      for (final dup in state.result!.duplicates) {
        if (state.selectedIds.contains(dup.phoneContact.id)) {
          contactsToImport.add(dup.phoneContact);
        }
      }

      // Batch import all selected contacts
      if (contactsToImport.isNotEmpty) {
        imported = await repository.createContacts(contactsToImport);
      }

      state = state.copyWith(
        isImporting: false,
        importedCount: imported,
        error: null,
      );

      return imported;
    } catch (e) {
      state = state.copyWith(isImporting: false, error: e.toString());
      return 0;
    }
  }

  /// Reset state for a fresh import
  void reset() {
    state = const ImportState();
  }
}

/// Provider to check if contacts permission is granted
@riverpod
Future<bool> hasContactsPermission(HasContactsPermissionRef ref) async {
  final importService = ref.read(phoneContactImportServiceProvider);
  return await importService.hasPermission();
}
