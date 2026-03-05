// Home Dashboard Screen for Smart Contact Wallet V1
// Central hub for contact management following V1 design specifications

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';
import 'package:mobile_wallet/features/home/presentation/widgets/user_profile_header.dart';

/// Home Dashboard Screen - Page 9 from Total_page.txt
/// Purpose: Central hub for contact management
/// Content: Profile picture, User name + contact, Category tabs, Contact cards, FAB
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Business',
    'Friends',
    'Family',
    'Uncategorized',
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authenticationProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/welcome');
          });
          return const SizedBox.shrink();
        }

        // Calculate total contacts for the user profile header
        final contactCount = ref.watch(contactsCountProvider).valueOrNull ?? 0;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              UserProfileHeader(
                user: user,
                contactCount: contactCount,
                onTap: () => context.push('/settings/edit-profile'),
              ),
              const SizedBox(height: 1),
              _buildQuickActions(),
              const SizedBox(height: 8),
              _buildCategoryTabs(),
              Expanded(child: _buildContactGrid()),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.offWhite,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.offWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'Error loading dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build app bar with notification bell and clean styling
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: const Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.black),
      actions: [
        // Notification bell
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.black,
              ),
              onPressed: () {
                context.push('/notifications');
              },
            ),
            // Notification badge
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Build quick actions row
  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionButton(
            icon: Icons.qr_code_scanner,
            label: 'Scan',
            onTap: () => context.push('/contacts/scan'),
          ),
          _buildQuickActionButton(
            icon: Icons.person_add_alt_1,
            label: 'Add',
            onTap: () => context.push('/contacts/add-method'),
          ),
          _buildQuickActionButton(
            icon: Icons.share,
            label: 'Share',
            onTap: () => context.push('/settings/digital-card'),
          ),
          _buildQuickActionButton(
            icon: Icons.groups,
            label: 'Teams',
            onTap: () => context.push('/settings/teams'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build category tabs
  Widget _buildCategoryTabs() {
    return Container(
      height: 52,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.offWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.white : AppColors.darkGray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build contact grid (2-column) with improved styling
  Widget _buildContactGrid() {
    final contactsState = ref.watch(contactsNotifierProvider);

    return contactsState.when(
      data: (contacts) {
        // Filter by category
        final filteredContacts = _selectedCategory == 'All'
            ? contacts
            : contacts
                  .where(
                    (c) =>
                        c.category.toLowerCase() ==
                        _selectedCategory.toLowerCase(),
                  )
                  .toList();

        if (filteredContacts.isEmpty) {
          return _buildEmptyState();
        }

        return Container(
          color: AppColors.offWhite,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = filteredContacts[index];
              return _buildProfessionalContactCard(contact);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  /// Build professional contact card with improved styling
  Widget _buildProfessionalContactCard(Contact contact) {
    // Determine image logic (use front image if available)
    // Note: Contact entity usually stores local paths or URLs.
    // Assuming simple path check for now.
    final hasImage =
        contact.frontImageUrl != null && contact.frontImageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        context.push('/contacts/${contact.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppColors.lightGray.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card image area (50%)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  // Card image or placeholder
                  if (hasImage)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        contact
                            .frontImageUrl!, // Assuming network URL for now, or file handling needed if local
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildProfessionalPlaceholder();
                        },
                      ),
                    )
                  else
                    _buildProfessionalPlaceholder(),
                  // Favorite star
                  if (contact.isFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warmGold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Contact info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.jobTitle ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.companyName ?? 'No Company',
                    style: TextStyle(fontSize: 12, color: AppColors.mediumGray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build professional placeholder icon
  Widget _buildProfessionalPlaceholder() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 40, color: AppColors.mediumGray),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts_outlined, size: 80, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          const Text(
            'No contacts yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first contact',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }
}
