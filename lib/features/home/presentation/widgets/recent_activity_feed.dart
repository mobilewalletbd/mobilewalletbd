// Recent Activity Feed Widget
// Displays timeline of recent contact-related actions

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Activity type enum
enum ActivityType { added, edited, deleted, contacted, shared }

/// Activity item model
class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });
}

/// Recent activity feed widget
/// Shows chronological timeline of user actions
class RecentActivityFeed extends StatelessWidget {
  final List<ActivityItem> activities;
  final VoidCallback? onSeeAll;

  const RecentActivityFeed({
    super.key,
    required this.activities,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Activity list
          if (activities.isEmpty)
            _buildEmptyState()
          else
            ...activities
                .take(5)
                .map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.history, size: 48, color: AppColors.mediumGray),
            const SizedBox(height: 8),
            const Text(
              'No recent activity',
              style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ],
        ),
      ),
    );
  }

  /// Build activity item
  Widget _buildActivityItem(ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getActivityColor(activity.type).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity.type),
              size: 20,
              color: _getActivityColor(activity.type),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mediumGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get activity icon
  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.added:
        return Icons.person_add_outlined;
      case ActivityType.edited:
        return Icons.edit_outlined;
      case ActivityType.deleted:
        return Icons.delete_outline;
      case ActivityType.contacted:
        return Icons.phone_outlined;
      case ActivityType.shared:
        return Icons.share_outlined;
    }
  }

  /// Get activity color
  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.added:
        return AppColors.success;
      case ActivityType.edited:
        return AppColors.info;
      case ActivityType.deleted:
        return AppColors.error;
      case ActivityType.contacted:
        return AppColors.primaryGreen;
      case ActivityType.shared:
        return AppColors.skyBlue;
    }
  }

  /// Format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
