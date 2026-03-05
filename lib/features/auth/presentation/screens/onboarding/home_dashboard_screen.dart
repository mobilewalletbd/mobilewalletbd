import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

/// Home Dashboard Screen
///
/// Design based on V1_APP_DESIGN_PLAN specifications:
/// - Header with hamburger menu and notification bell
/// - Profile section with avatar, greeting, user name, phone
/// - Category tabs (All, Business, Friends, Family, Uncategorized)
/// - Contact card grid with 2-column layout
/// - FAB cluster (Add Contact, Wallet, Search, Settings)
class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  int _selectedCategoryIndex = 0;
  bool _isFabExpanded = false;

  final List<String> _categories = [
    'All',
    'Business',
    'Friends',
    'Family',
    'Uncategorized',
  ];

  // Mock contact data for demonstration
  final List<Map<String, dynamic>> _mockContacts = [
    {
      'name': 'John Doe',
      'company': 'Tech Corp',
      'title': 'Software Engineer',
      'imageUrl': null,
      'isFavorite': true,
    },
    {
      'name': 'Jane Smith',
      'company': 'Design Studio',
      'title': 'UX Designer',
      'imageUrl': null,
      'isFavorite': false,
    },
    {
      'name': 'Mike Johnson',
      'company': 'Business Inc',
      'title': 'Sales Manager',
      'imageUrl': null,
      'isFavorite': false,
    },
    {
      'name': 'Sarah Wilson',
      'company': 'Marketing Pro',
      'title': 'Marketing Director',
      'imageUrl': null,
      'isFavorite': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Profile Section
            _buildProfileSection(user?.displayName ?? 'User'),
            // Category Tabs
            _buildCategoryTabs(),
            // Contact Grid
            Expanded(child: _buildContactGrid()),
          ],
        ),
      ),
      // FAB Cluster
      floatingActionButton: _buildFabCluster(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primaryGreen),
            onPressed: () {},
          ),
          const Text(
            'Smart Wallet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.black,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.coralAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String userName) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryGreen, AppColors.white],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.primaryGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 12, color: AppColors.white),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const Text(
                  '+880 1712345678',
                  style: TextStyle(fontSize: 12, color: AppColors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = _selectedCategoryIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.offWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? AppColors.white : AppColors.darkGray,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactGrid() {
    if (_mockContacts.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.82,
        ),
        itemCount: _mockContacts.length,
        itemBuilder: (context, index) {
          final contact = _mockContacts[index];
          return _buildContactCard(contact);
        },
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Image Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Icon(
                Icons.credit_card_outlined,
                size: 40,
                color: AppColors.mediumGray,
              ),
            ),
          ),
          // Front/Back Toggle
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      size: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contact Info
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (contact['isFavorite']) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.star, size: 14, color: AppColors.warmGold),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact['company'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.contacts_outlined,
              size: 60,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No contacts yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first contact to get started',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFabCluster() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isFabExpanded) ...[
          _buildSecondaryFab(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSecondaryFab(
            icon: Icons.search_outlined,
            label: 'Search',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSecondaryFab(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet',
            onTap: () {},
          ),
          const SizedBox(height: 12),
        ],
        // Main FAB
        FloatingActionButton(
          onPressed: () => setState(() => _isFabExpanded = !_isFabExpanded),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          elevation: 4,
          child: Icon(_isFabExpanded ? Icons.close : Icons.add, size: 24),
        ),
      ],
    );
  }

  Widget _buildSecondaryFab({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.white, size: 20),
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}
