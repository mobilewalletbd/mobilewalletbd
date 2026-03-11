import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_activity_log.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';

class TeamActivityTab extends ConsumerWidget {
  final Team team;

  const TeamActivityTab({super.key, required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(teamActivityProvider(team.id));
    final currentLimit = ref.watch(activityLimitProvider(team.id));

    return activityAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No recent activity',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: logs.length + (logs.length >= currentLimit ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == logs.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      ref
                          .read(teamNotifierProvider.notifier)
                          .loadMoreActivity(team.id);
                    },
                    child: const Text('Load More Activity'),
                  ),
                ),
              );
            }
            final log = logs[index];
            return _ActivityLogItem(log: log);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _ActivityLogItem extends ConsumerWidget {
  final TeamActivityLog log;

  const _ActivityLogItem({required this.log});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(teamMemberProfileProvider(log.userId));
    final userName = log.userId == 'system'
        ? 'System'
        : (profileAsync.value?.fullName ?? 'Member');

    final iconData = _getIconForAction(log.actionType);
    final iconColor = _getColorForAction(log.actionType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        title: Text(
          log.description,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          children: [
            Text(
              'by $userName',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Text(
              '•',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTimestamp(log.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForAction(String type) {
    switch (type) {
      case 'team_created':
        return Icons.group_add;
      case 'member_invited':
        return Icons.person_add_alt;
      case 'member_joined':
        return Icons.how_to_reg;
      case 'member_added':
        return Icons.person_add;
      case 'member_removed':
        return Icons.person_remove;
      case 'role_updated':
        return Icons.admin_panel_settings;
      case 'team_profile_updated':
        return Icons.edit;
      case 'expense_created':
        return Icons.account_balance_wallet;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForAction(String type) {
    switch (type) {
      case 'team_created':
        return Colors.green;
      case 'member_invited':
      case 'member_joined':
      case 'member_added':
        return Colors.blue;
      case 'member_removed':
        return Colors.red;
      case 'role_updated':
        return Colors.orange;
      case 'expense_created':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return DateFormat('MMM d, yyyy').format(timestamp);
  }
}
