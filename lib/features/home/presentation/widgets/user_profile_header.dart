// User Profile Header Widget
// Displays user info and quick stats on home dashboard

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';

/// User profile header widget for home dashboard
/// Shows profile picture, name, email, and quick stats
class UserProfileHeader extends StatelessWidget {
  final AuthUser user;
  final int contactCount;
  final VoidCallback? onTap;

  const UserProfileHeader({
    super.key,
    required this.user,
    this.contactCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            // Profile picture
            _buildProfilePicture(),
            const SizedBox(width: 16),
            // User info
            Expanded(child: _buildUserInfo()),
            // Quick stats
            _buildQuickStat(contactCount.toString(), 'Contacts'),
          ],
        ),
      ),
    );
  }

  /// Build profile picture circle
  Widget _buildProfilePicture() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primaryGreenLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryGreen, width: 2),
      ),
      child: user.photoUrl != null && user.photoUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                user.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitials();
                },
              ),
            )
          : _buildInitials(),
    );
  }

  /// Build user initials
  Widget _buildInitials() {
    return Center(
      child: Text(
        _getInitials(user.displayName ?? 'U'),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// Build user information
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.displayName ?? 'User',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? user.phoneNumber ?? 'No email',
          style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Build quick stat chip
  Widget _buildQuickStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  /// Get user initials from name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
