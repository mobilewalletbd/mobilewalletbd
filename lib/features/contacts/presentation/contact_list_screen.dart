import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';
import 'package:mobile_wallet/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:mobile_wallet/features/contacts/presentation/widgets/delete_contact_dialog.dart';

/// Contact List Screen (Page 10 in design specs)
/// Features: Search bar, category tabs, alphabetical list with sticky headers
class ContactListScreen extends ConsumerStatefulWidget {
  const ContactListScreen({super.key});

  @override
  ConsumerState<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends ConsumerState<ContactListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSelectionMode = false;
  final Set<String> _selectedContactIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).update(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  void _onCategorySelected(String category) {
    ref.read(selectedCategoryProvider.notifier).select(category);
  }

  Future<void> _onDeleteContact(Contact contact) async {
    final confirmed = await DeleteContactDialog.show(
      context,
      contactName: contact.fullName,
    );

    if (confirmed == true) {
      await ref
          .read(contactsNotifierProvider.notifier)
          .deleteContact(contact.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${contact.fullName} deleted'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onToggleFavorite(Contact contact) async {
    await ref
        .read(contactsNotifierProvider.notifier)
        .toggleFavorite(contact.id);
  }

  void _navigateToContactDetails(Contact contact) {
    context.push('/contacts/${contact.id}');
  }

  void _navigateToAddContact() {
    context.push('/contacts/add');
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedContactIds.clear();
    });
  }

  void _toggleContactSelection(String id) {
    setState(() {
      if (_selectedContactIds.contains(id)) {
        _selectedContactIds.remove(id);
        if (_selectedContactIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedContactIds.add(id);
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  Future<void> _deleteSelectedContacts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contacts'),
        content: Text('Delete ${_selectedContactIds.length} contacts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final ids = _selectedContactIds.toList();
      for (final id in ids) {
        await ref.read(contactsNotifierProvider.notifier).deleteContact(id);
      }
      _toggleSelectionMode();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ids.length} contacts deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(filteredContactsProvider);
    final categoryCounts = ref.watch(categoryCountsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.black),
                onPressed: _toggleSelectionMode,
              )
            : null,
        title: Text(
          _isSelectionMode
              ? '${_selectedContactIds.length} selected'
              : 'Contacts',
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.primaryGreen),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing coming soon')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _deleteSelectedContacts,
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.darkGray),
              onPressed: _showFilterBottomSheet,
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSelectionMode) ...[
            // Search bar
            _buildSearchBar(searchQuery),

            // Category tabs
            _buildCategoryTabs(selectedCategory, categoryCounts),
          ],

          // Contact list
          Expanded(
            child: contactsAsync.when(
              data: (contacts) => _buildContactList(contacts),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
              error: (error, _) => _buildErrorState(error),
            ),
          ),
        ],
      ),
      // FAB handled by BottomNavShell
      floatingActionButton: null,
    );
  }

  Widget _buildSearchBar(String searchQuery) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search contacts...',
          hintStyle: const TextStyle(color: AppColors.mediumGray, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.mediumGray,
            size: 20,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: _clearSearch,
                  color: AppColors.mediumGray,
                )
              : null,
          filled: true,
          fillColor: AppColors.offWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryGreen,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(
    String selectedCategory,
    AsyncValue<Map<String, int>> categoryCountsAsync,
  ) {
    final counts = categoryCountsAsync.valueOrNull ?? {};

    final categories = [
      ('all', 'All'),
      (ContactCategories.business, 'Business'),
      (ContactCategories.friends, 'Friends'),
      (ContactCategories.family, 'Family'),
      (ContactCategories.uncategorized, 'Uncategorized'),
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (value, label) = categories[index];
          final isSelected = selectedCategory == value;
          final count = counts[value] ?? 0;

          return GestureDetector(
            onTap: () => _onCategorySelected(value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : AppColors.offWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? Colors.white : AppColors.darkGray,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.mediumGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.darkGray,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactList(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return EmptyContactsState(
        onAddContact: _navigateToAddContact,
        message: ref.watch(searchQueryProvider).isNotEmpty
            ? 'No contacts found'
            : 'No contacts yet',
      );
    }

    // Group contacts alphabetically
    final groupedContacts = <String, List<Contact>>{};
    for (final contact in contacts) {
      final firstLetter = contact.fullName.isNotEmpty
          ? contact.fullName[0].toUpperCase()
          : '#';
      final key = RegExp(r'[A-Z]').hasMatch(firstLetter) ? firstLetter : '#';
      groupedContacts.putIfAbsent(key, () => []).add(contact);
    }

    // Sort keys alphabetically
    final sortedKeys = groupedContacts.keys.toList()..sort();

    // Build list with sticky headers
    final items = <Widget>[];
    for (final key in sortedKeys) {
      items.add(ContactSectionHeader(letter: key));
      for (int i = 0; i < groupedContacts[key]!.length; i++) {
        final contact = groupedContacts[key]![i];
        final isSelected = _selectedContactIds.contains(contact.id);

        items.add(
          ContactListItem(
            contact: contact,
            isSelectionMode: _isSelectionMode,
            isSelected: isSelected,
            onSelectionChanged: (_) => _toggleContactSelection(contact.id),
            onLongPress: () {
              if (!_isSelectionMode) {
                _toggleSelectionMode();
                _toggleContactSelection(contact.id);
              }
            },
            onTap: _isSelectionMode
                ? () => _toggleContactSelection(contact.id)
                : () => _navigateToContactDetails(contact),
            onFavoriteToggle: () => _onToggleFavorite(contact),
            onDelete: () => _onDeleteContact(contact),
            showDivider: i < groupedContacts[key]!.length - 1,
          ),
        );
      }
    }

    return Stack(
      children: [
        ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(right: 24),
          children: items,
        ),
        // Alphabet scrubber
        AlphabetScrubber(
          letters: sortedKeys,
          onLetterSelected: (letter) {
            // Find the position of the letter and scroll to it
            int index = 0;
            for (final key in sortedKeys) {
              if (key == letter) break;
              index++; // For header
              index += groupedContacts[key]!.length; // For contacts
            }
            // Approximate scroll position (header = 28px, item = 72px)
            // This is a simple approximation
            _scrollController.animateTo(
              index * 72.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.coralAccent,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load contacts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(fontSize: 14, color: AppColors.darkGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(contactsNotifierProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(contactFilterProvider);
    final notifier = ref.read(contactFilterProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Contacts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  notifier.reset();
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Favorites Only'),
            value: filters.showFavoritesOnly,
            onChanged: (val) {
              notifier.update(showFavoritesOnly: val);
            },
          ),
          CheckboxListTile(
            title: const Text('Has Phone Number'),
            value: filters.hasPhoneNumber,
            onChanged: (val) {
              notifier.update(hasPhoneNumber: val);
            },
          ),
          CheckboxListTile(
            title: const Text('Has Email'),
            value: filters.hasEmail,
            onChanged: (val) {
              notifier.update(hasEmail: val);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Sort By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<String>(
            title: const Text('Name (A-Z)'),
            value: 'name',
            groupValue: filters.sortBy,
            onChanged: (val) {
              notifier.update(sortBy: val);
            },
          ),
          RadioListTile<String>(
            title: const Text('Recently Added'),
            value: 'date',
            groupValue: filters.sortBy,
            onChanged: (val) {
              notifier.update(sortBy: val);
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
