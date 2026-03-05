// Import Contacts Screen
// Shows phone contacts with selection UI and duplicate warnings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/data/services/phone_contact_import_service.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/import_provider.dart';

/// Screen for importing contacts from phone
class ImportContactsScreen extends ConsumerStatefulWidget {
  const ImportContactsScreen({super.key});

  @override
  ConsumerState<ImportContactsScreen> createState() =>
      _ImportContactsScreenState();
}

class _ImportContactsScreenState extends ConsumerState<ImportContactsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch contacts when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(phoneContactImportNotifierProvider.notifier).fetchContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(phoneContactImportNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Import Contacts',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (importState.result != null && !importState.isImporting)
            TextButton(
              onPressed: importState.allSelected
                  ? () => ref
                        .read(phoneContactImportNotifierProvider.notifier)
                        .deselectAll()
                  : () => ref
                        .read(phoneContactImportNotifierProvider.notifier)
                        .selectAll(),
              child: Text(
                importState.allSelected ? 'Deselect All' : 'Select All',
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(importState),
      bottomNavigationBar: _buildBottomBar(importState),
    );
  }

  Widget _buildBody(ImportState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primaryGreen),
            SizedBox(height: 16),
            Text(
              'Reading contacts...',
              style: TextStyle(fontSize: 16, color: AppColors.darkGray),
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    if (state.result == null) {
      return const Center(child: Text('Unable to load contacts'));
    }

    if (state.result!.importableCount == 0) {
      return _buildEmptyState();
    }

    return _buildContactList(state);
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.coralAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.coralAccent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              error.toLowerCase().contains('permission')
                  ? 'Permission Required'
                  : 'Error Loading Contacts',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toLowerCase().contains('permission')
                  ? 'Please grant contacts permission to import contacts from your phone.'
                  : error,
              style: const TextStyle(fontSize: 14, color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(phoneContactImportNotifierProvider.notifier)
                    .fetchContacts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No New Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'All your phone contacts have already been imported.',
              style: TextStyle(fontSize: 14, color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                side: const BorderSide(color: AppColors.primaryGreen),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList(ImportState state) {
    final result = state.result!;

    return ListView(
      children: [
        // Summary header
        _buildSummaryHeader(result, state.selectedCount),

        // New contacts section
        if (result.newContacts.isNotEmpty) ...[
          _buildSectionHeader(
            'New Contacts',
            result.newContacts.length,
            Icons.person_add_outlined,
            AppColors.primaryGreen,
          ),
          ...result.newContacts.map(
            (contact) =>
                _buildContactTile(contact, state.isSelected(contact.id), null),
          ),
        ],

        // Duplicate contacts section
        if (result.duplicates.isNotEmpty) ...[
          _buildSectionHeader(
            'Possible Duplicates',
            result.duplicates.length,
            Icons.warning_amber_outlined,
            AppColors.warmGold,
          ),
          ...result.duplicates.map(
            (dup) => _buildContactTile(
              dup.phoneContact,
              state.isSelected(dup.phoneContact.id),
              dup,
            ),
          ),
        ],

        const SizedBox(height: 100), // Space for bottom bar
      ],
    );
  }

  Widget _buildSummaryHeader(ImportResult result, int selectedCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.offWhite,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${result.totalPhoneContacts} phone contacts found',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$selectedCount selected for import',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 4),
                Text(
                  '$selectedCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    int count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: color.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    Contact contact,
    bool isSelected,
    DuplicateMatch? duplicateInfo,
  ) {
    return InkWell(
      onTap: () {
        ref
            .read(phoneContactImportNotifierProvider.notifier)
            .toggleSelection(contact.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.mediumGray,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),

            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Contact info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  if (contact.primaryPhone != null ||
                      contact.primaryEmail != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      contact.primaryPhone ?? contact.primaryEmail ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                  if (duplicateInfo != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warmGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Matches "${duplicateInfo.existingContact.fullName}" by ${duplicateInfo.matchReason}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.warmGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ImportState state) {
    if (state.isLoading || state.result == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: state.selectedCount > 0 && !state.isImporting
              ? () => _importContacts()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.lightGray,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state.isImporting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Import ${state.selectedCount} Contact${state.selectedCount != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _importContacts() async {
    final notifier = ref.read(phoneContactImportNotifierProvider.notifier);
    final imported = await notifier.importSelected();

    if (mounted) {
      final error = ref.read(phoneContactImportNotifierProvider).error;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $error'),
            backgroundColor: AppColors.coralAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$imported contact${imported != 1 ? 's' : ''} imported',
            ),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    }
  }
}
