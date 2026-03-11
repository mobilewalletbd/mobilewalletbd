import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/team_list_widgets.dart';

class TeamListScreen extends ConsumerStatefulWidget {
  const TeamListScreen({super.key});

  @override
  ConsumerState<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends ConsumerState<TeamListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isDiscoverMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(userTeamsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.primaryIndigo,
        foregroundColor: Colors.white,
        title: Text(
          _isDiscoverMode ? 'Discover Teams' : 'My Teams',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isDiscoverMode ? Icons.group : Icons.explore),
            tooltip: _isDiscoverMode ? 'My Teams' : 'Discover Public Teams',
            onPressed: () => setState(() => _isDiscoverMode = !_isDiscoverMode),
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Container(
            color: AppColors.primaryIndigo,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                hintText: 'Search teams...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // --- Category Filters ---
          CategoryFilterBar(
            selectedCategory: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),

          ref
              .watch(pendingInvitesProvider)
              .when(
                data: (invites) => invites.isEmpty
                    ? const SizedBox.shrink()
                    : _PendingInvitesSection(invites: invites),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

          Expanded(
            child: _isDiscoverMode
                ? ref
                      .watch(publicTeamsProvider(_searchQuery))
                      .when(
                        data: (publicTeams) {
                          if (publicTeams.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No public teams found',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: publicTeams.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final team = publicTeams[index];
                              final isMember = team.members.any(
                                (m) => m.userId == currentUser?.id,
                              );

                              return _TeamCard(
                                team: team,
                                currentUserId: currentUser?.id,
                                isDiscovery: true,
                                isMember: isMember,
                                onTap: isMember
                                    ? () => context.push(
                                        '/settings/teams/${team.id}',
                                      )
                                    : null,
                                onJoin: () => ref
                                    .read(teamNotifierProvider.notifier)
                                    .joinTeam(team.id),
                              );
                            },
                          );
                        },
                        loading: () => _TeamListShimmer(),
                        error: (e, __) => Center(child: Text('Error: $e')),
                      )
                : teamsAsync.when(
                    data: (teams) {
                      // Filter teams by search and category
                      var filteredTeams = teams;
                      if (_searchQuery.isNotEmpty) {
                        filteredTeams = filteredTeams.where((t) {
                          return t.name.toLowerCase().contains(_searchQuery) ||
                              (t.description?.toLowerCase().contains(
                                    _searchQuery,
                                  ) ??
                                  false);
                        }).toList();
                      }
                      if (_selectedCategory != null) {
                        filteredTeams = filteredTeams
                            .where((t) => t.category == _selectedCategory)
                            .toList();
                      }

                      if (filteredTeams.isEmpty) {
                        if (_searchQuery.isNotEmpty ||
                            _selectedCategory != null) {
                          return NoResultsState(
                            onClear: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _selectedCategory = null;
                              });
                            },
                          );
                        }
                        // Only show empty state if NO pending invites either
                        final invites =
                            ref.watch(pendingInvitesProvider).value ?? [];
                        if (invites.isEmpty) {
                          return _EmptyTeamsState(
                            onCreateTap: () {
                              context.push('/settings/teams/create');
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      return RefreshIndicator(
                        color: AppColors.primaryIndigo,
                        onRefresh: () async {
                          ref.invalidate(userTeamsProvider);
                          ref.invalidate(pendingInvitesProvider);
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          itemCount: filteredTeams.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final team = filteredTeams[index];
                            return _TeamCard(
                              team: team,
                              currentUserId: currentUser?.id,
                              onTap: () =>
                                  context.push('/settings/teams/${team.id}'),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => _TeamListShimmer(),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryIndigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Team'),
        onPressed: () => context.push('/settings/teams/create'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TeamCard extends StatelessWidget {
  final Team team;
  final String? currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final bool isDiscovery;
  final bool isMember;

  const _TeamCard({
    required this.team,
    required this.currentUserId,
    this.onTap,
    this.onJoin,
    this.isDiscovery = false,
    this.isMember = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the current user's role in this team
    final myMember = team.members
        .where((m) => m.userId == currentUserId)
        .firstOrNull;
    final myRole = myMember?.role ?? 'member';
    final roleLabel = myRole[0].toUpperCase() + myRole.substring(1);

    final activeMemberCount = team.members
        .where((m) => m.status == 'active')
        .length;
    final hasPending = team.members.any((m) => m.status == 'pending');

    // Avatar color from team name
    final hue = (team.name.hashCode.abs() % 360).toDouble();
    final avatarBg = HSLColor.fromAHSL(1, hue, 0.55, 0.50).toColor();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: avatarBg,
                    backgroundImage:
                        team.photoUrl != null && team.photoUrl!.isNotEmpty
                        ? NetworkImage(team.photoUrl!)
                        : null,
                    child: team.photoUrl == null || team.photoUrl!.isEmpty
                        ? Text(
                            team.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        : null,
                  ),
                  // Pending invite dot
                  if (hasPending)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            team.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Role badge pill (only if member)
                        if (!isDiscovery || isMember)
                          _RolePill(role: myRole, label: roleLabel),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$activeMemberCount member${activeMemberCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (team.category != null) ...[
                          const Text(
                            ' • ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            team.category!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    if (hasPending && !isDiscovery) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 12,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Pending invites',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              if (isDiscovery && !isMember)
                FilledButton(
                  onPressed: onJoin,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryIndigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Join', style: TextStyle(fontSize: 12)),
                )
              else
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String role;
  final String label;

  const _RolePill({required this.role, required this.label});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (role.toLowerCase()) {
      case 'owner':
        color = Colors.orange;
        break;
      case 'admin':
      case 'co-admin':
        color = Colors.blue;
        break;
      default:
        color = AppColors.primaryIndigo;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _EmptyTeamsState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyTeamsState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigoLight.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryIndigoLight,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons
                      .hub_outlined, // Changed to a more "team/network" focused icon
                  size: 80,
                  color: AppColors.primaryIndigo,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'No Teams Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Create a space to collaborate, share contacts, and track expenses together with your colleagues.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                onPressed: onCreateTap,
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Create Your First Team',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryIndigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Skeleton ────────────────────────────────────────────────────────

class _PendingInvitesSection extends StatelessWidget {
  final List<Team> invites;
  const _PendingInvitesSection({required this.invites});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mail_outline, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'PENDING INVITATIONS (${invites.length})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...invites.map(
            (team) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _PendingInviteCard(team: team),
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}

class _PendingInviteCard extends ConsumerWidget {
  final Team team;
  const _PendingInviteCard({required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      color: Colors.orange.shade50.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange.shade100,
                  backgroundImage:
                      team.photoUrl != null && team.photoUrl!.isNotEmpty
                      ? NetworkImage(team.photoUrl!)
                      : null,
                  child: team.photoUrl == null || team.photoUrl!.isEmpty
                      ? Text(
                          team.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Wants you to join their team',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ref
                        .read(teamNotifierProvider.notifier)
                        .respondToInvite(team.id, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ref
                        .read(teamNotifierProvider.notifier)
                        .respondToInvite(team.id, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryIndigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 120, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 50, height: 22, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
