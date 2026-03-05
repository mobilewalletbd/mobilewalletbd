import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/team_wallet_tab.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/team_directory_tab.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/team_settings_tab.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/team_chat_tab.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/team_activity_tab.dart';
import 'package:go_router/go_router.dart';

class TeamDetailsScreen extends ConsumerStatefulWidget {
  final String teamId;

  const TeamDetailsScreen({super.key, required this.teamId});

  @override
  ConsumerState<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends ConsumerState<TeamDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(teamDetailsProvider(widget.teamId));
    final currentUser = ref.watch(currentUserProvider);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: teamAsync.when(
            data: (team) {
              if (team == null) return const Text('Team Details');
              return Column(
                children: [
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${team.members.length} Members | Total Expenses: \$${team.totalExpenses?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              );
            },
            loading: () => const Text('Loading...'),
            error: (_, __) => const Text('Error'),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Activity'),
              Tab(text: 'Chat'),
              Tab(text: 'Wallet'),
              Tab(text: 'Settings'),
            ],
          ),
          actions: [
            if (teamAsync.valueOrNull?.ownerId == currentUser?.id)
              IconButton(
                icon: const Icon(Icons.person_add),
                tooltip: 'Add Member',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) =>
                        TeamDirectoryAddMemberSheet(teamId: widget.teamId),
                  );
                },
              ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Team'),
                      content: const Text(
                        'Are you sure you want to delete this team? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref
                        .read(teamNotifierProvider.notifier)
                        .deleteTeam(widget.teamId);
                    if (context.mounted) {
                      context.go('/settings/teams'); // Go back to list
                    }
                  }
                } else if (value == 'leave') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Leave Team'),
                      content: const Text(
                        'Are you sure you want to leave this team?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Leave',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref
                        .read(teamNotifierProvider.notifier)
                        .leaveTeam(widget.teamId);
                    if (context.mounted) {
                      context.go('/settings/teams'); // Go back to list
                    }
                  }
                }
              },
              itemBuilder: (context) {
                final isOwner =
                    teamAsync.valueOrNull?.ownerId == currentUser?.id;
                return [
                  if (isOwner)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete Team',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  else
                    const PopupMenuItem(
                      value: 'leave',
                      child: Text(
                        'Leave Team',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ];
              },
            ),
          ],
        ),
        body: teamAsync.when(
          data: (team) {
            if (team == null) {
              return const Center(child: Text('Team not found'));
            }

            // Access Guard: Ensure current user is a member
            if (currentUser == null ||
                !team.memberIds.contains(currentUser.id)) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Access Denied',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You are not a member of this team.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/settings/teams'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            return TabBarView(
              children: [
                // 1. Members / Directory Tab
                TeamDirectoryTab(team: team),
                // 2. Activity Feed Tab
                TeamActivityTab(team: team),
                // 3. Group Chat Tab
                TeamChatTab(team: team),
                // 4. Wallet Tab
                TeamWalletTab(team: team),
                // 5. Settings Tab
                TeamSettingsTab(team: team),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        // Removed FAB since we have Quick Actions now
      ),
    );
  }
}
