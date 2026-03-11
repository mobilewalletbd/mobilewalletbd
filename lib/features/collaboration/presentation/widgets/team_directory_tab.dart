import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/features/settings/data/repositories/user_profile_repository_impl.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

/// Converts a raw role string to a display-friendly label.
String _roleLabel(String role) {
  switch (role.toLowerCase()) {
    case 'owner':
      return 'Owner';
    case 'admin':
      return 'Admin';
    case 'co-admin':
      return 'Co-Admin';
    case 'viewer':
      return 'Viewer';
    default:
      return 'Member';
  }
}

/// Returns a priority weight so we can sort Owners → Admins → Members.
int _rolePriority(String role) {
  switch (role.toLowerCase()) {
    case 'owner':
      return 0;
    case 'admin':
      return 1;
    case 'co-admin':
      return 2;
    case 'viewer':
      return 4;
    default:
      return 3; // member
  }
}

Color _roleBadgeColor(String role) {
  switch (role.toLowerCase()) {
    case 'owner':
      return Colors.orange;
    case 'admin':
      return Colors.blue;
    case 'co-admin':
      return Colors.teal;
    case 'viewer':
      return Colors.grey;
    default:
      return AppColors.primaryIndigo;
  }
}

class TeamDirectoryTab extends ConsumerStatefulWidget {
  final Team team;

  const TeamDirectoryTab({super.key, required this.team});

  @override
  ConsumerState<TeamDirectoryTab> createState() => _TeamDirectoryTabState();
}

class _TeamDirectoryTabState extends ConsumerState<TeamDirectoryTab> {
  final _searchController = TextEditingController();
  String _query = '';
  String _roleFilter = 'All'; // 'All', 'Admin', 'Member'
  bool _showSearch = false; // Toggle for search bar visibility

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filter and sort members based on search and role filter.
  List<TeamMember> _filteredMembers(List<TeamMember> members) {
    var filtered = members
        .where((m) {
          if (_roleFilter == 'Admin') {
            return m.role.toLowerCase() == 'admin' ||
                m.role.toLowerCase() == 'owner' ||
                m.role.toLowerCase() == 'co-admin';
          }
          if (_roleFilter == 'Member') {
            return m.role.toLowerCase() == 'member' ||
                m.role.toLowerCase() == 'viewer';
          }
          return true;
        })
        .where((m) {
          if (_query.isEmpty) return true;
          return m.userId.toLowerCase().contains(_query.toLowerCase()) ||
              (m.jobTitle?.toLowerCase().contains(_query.toLowerCase()) ??
                  false) ||
              m.role.toLowerCase().contains(_query.toLowerCase());
        })
        .toList();

    // Sort: Owners → Admins → Co-Admins → Members → Viewers
    filtered.sort((a, b) => _rolePriority(a.role) - _rolePriority(b.role));
    return filtered;
  }

  void _showAddMemberDialog() {
    context.push('/settings/teams/${widget.team.id}/invite');
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwnerOrAdmin = widget.team.ownerId == currentUser?.id;
    final members = _filteredMembers(widget.team.members);

    // Group members
    final admins = members
        .where(
          (m) =>
              m.role.toLowerCase() == 'owner' ||
              m.role.toLowerCase() == 'admin' ||
              m.role.toLowerCase() == 'co-admin',
        )
        .toList();
    final others = members
        .where(
          (m) =>
              m.role.toLowerCase() == 'member' ||
              m.role.toLowerCase() == 'viewer',
        )
        .toList();

    return Stack(
      children: [
        Column(
          children: [
            // Search + Filter bar (Conditionally visible)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _showSearch
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: _showSearch,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Search members…',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter button
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.primaryIndigo,
                      ),
                      tooltip: 'Filter by role',
                      initialValue: _roleFilter,
                      onSelected: (v) => setState(() => _roleFilter = v),
                      itemBuilder: (_) => ['All', 'Admin', 'Member']
                          .map((f) => PopupMenuItem(value: f, child: Text(f)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Stats strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    'Shared Contacts',
                    widget.team.sharedContactsCount.toString(),
                    Icons.contacts,
                  ),
                  _buildStatCard(
                    'Active',
                    widget.team.members
                        .where((m) => m.status == 'active')
                        .length
                        .toString(),
                    Icons.circle,
                    iconColor: Colors.green,
                  ),
                  _buildStatCard(
                    'Total',
                    widget.team.members.length.toString(),
                    Icons.group,
                  ),
                ],
              ),
            ),

            // Quick Actions
            if (isOwnerOrAdmin)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _showAddMemberDialog,
                    icon: const Icon(Icons.person_add),
                    label: const Text('+ Add Member'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryIndigo,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

            const Divider(height: 1),

            // Member list with groups
            Expanded(
              child: members.isEmpty
                  ? Center(
                      child: Text(
                        _query.isEmpty
                            ? 'No members found.'
                            : 'No results for "$_query".',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView(
                      children: [
                        if (admins.isNotEmpty) ...[
                          _SectionHeader(
                            label: 'Admins & Owners (${admins.length})',
                          ),
                          ...admins.map(
                            (m) => _MemberTile(
                              member: m,
                              team: widget.team,
                              currentUserId: currentUser?.id,
                              isOwnerOrAdmin: isOwnerOrAdmin,
                            ),
                          ),
                        ],
                        if (others.isNotEmpty) ...[
                          _SectionHeader(label: 'Members (${others.length})'),
                          ...others.map(
                            (m) => _MemberTile(
                              member: m,
                              team: widget.team,
                              currentUserId: currentUser?.id,
                              isOwnerOrAdmin: isOwnerOrAdmin,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
        // Task 5.13 — Green FAB for Search/Filter
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'team_directory_search_fab',
            onPressed: () => setState(() => _showSearch = !_showSearch),
            backgroundColor: AppColors.primaryIndigo,
            child: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    Color? iconColor,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, size: 20, color: iconColor ?? Colors.grey.shade600),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header widget
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single member tile
// ---------------------------------------------------------------------------
class _MemberTile extends ConsumerWidget {
  final TeamMember member;
  final Team team;
  final String? currentUserId;
  final bool isOwnerOrAdmin;

  const _MemberTile({
    required this.member,
    required this.team,
    required this.currentUserId,
    required this.isOwnerOrAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = member.userId == team.ownerId;
    final isOnline = member.status == 'active';
    final isCurrentUser = member.userId == currentUserId;

    // Generate a deterministic avatar colour from userId
    final hue = (member.userId.hashCode.abs() % 360).toDouble();
    final avatarColor = HSLColor.fromAHSL(1, hue, 0.6, 0.45).toColor();

    final profileAsync = ref.watch(teamMemberProfileProvider(member.userId));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 22,
            backgroundImage:
                profileAsync.value?.avatarUrl != null &&
                    profileAsync.value!.avatarUrl!.isNotEmpty
                ? NetworkImage(profileAsync.value!.avatarUrl!)
                : null,
            child:
                profileAsync.value?.avatarUrl == null ||
                    profileAsync.value!.avatarUrl!.isEmpty
                ? Text(
                    _getInitials(profileAsync.value?.fullName ?? member.userId),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          // Online status dot
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: isOnline
                    ? AppColors.primaryIndigo
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              isCurrentUser
                  ? 'You'
                  : _getDisplayName(profileAsync.value, member.userId),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isCurrentUser ? AppColors.primaryIndigo : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          if (isOwner)
            const Icon(Icons.stars_rounded, color: Colors.orange, size: 16),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          // Role badge + job title
          Row(
            children: [
              _RoleBadge(role: member.role),
              if (member.jobTitle != null && member.jobTitle!.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  member.jobTitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ],
      ),
      isThreeLine: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chat bubble
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, size: 20),
            color: Colors.green,
            tooltip: 'Chat',
            onPressed: () {
              // TODO: Navigate to team chat filtered for this member
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Team Chat coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          // Owner can manage member roles
          if (isOwnerOrAdmin && !isCurrentUser && !isOwner)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              onSelected: (action) async {
                if (action == 'remove') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Remove Member'),
                      content: const Text(
                        'Are you sure you want to remove this member from the team?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await ref
                        .read(teamNotifierProvider.notifier)
                        .removeMember(team.id, member.userId);
                  }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _getInitials(String str) {
    if (str.isEmpty) return '?';
    final parts = str.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return str.substring(0, str.length > 1 ? 2 : str.length).toUpperCase();
  }

  String _getDisplayName(UserProfile? profile, String fallbackId) {
    if (profile != null) {
      if (profile.fullName.isNotEmpty) return profile.fullName;
      if (profile.firstName != null && profile.lastName != null) {
        return '${profile.firstName} ${profile.lastName}';
      }
      if (profile.firstName != null) return profile.firstName!;
    }
    return 'Member ${fallbackId.substring(0, fallbackId.length > 5 ? 6 : fallbackId.length)}';
  }
}

// ---------------------------------------------------------------------------
// Role badge pill widget
// ---------------------------------------------------------------------------
class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final color = _roleBadgeColor(role);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        _roleLabel(role),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Public Add Member bottom sheet (shared with TeamDetailsScreen AppBar).
class TeamDirectoryAddMemberSheet extends ConsumerStatefulWidget {
  final String teamId;
  const TeamDirectoryAddMemberSheet({super.key, required this.teamId});

  @override
  ConsumerState<TeamDirectoryAddMemberSheet> createState() =>
      _TeamDirectoryAddMemberSheetState();
}

class _TeamDirectoryAddMemberSheetState
    extends ConsumerState<TeamDirectoryAddMemberSheet> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _error = null;
      _searchResults = [];
    });

    try {
      final repo = ref.read(userProfileRepositoryProvider);
      final results = await repo.searchUsers(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        if (results.isEmpty) _error = 'No user found for "$query"';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _inviteValue(String value) async {
    setState(() => _isSearching = true);
    final isEmail = value.contains('@');
    try {
      await ref
          .read(teamNotifierProvider.notifier)
          .inviteMember(
            teamId: widget.teamId,
            email: isEmail ? value : null,
            phoneNumber: isEmail ? null : value,
            role: 'member',
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: bottomInset + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Add Member',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by email or phone…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: TextButton(
                  onPressed: _search,
                  child: const Text('Search'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              if (_error != null && _searchResults.isEmpty) ...[
                if (_searchController.text.trim().isNotEmpty)
                  _buildInviteEmptyState(_searchController.text.trim())
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ] else if (_searchResults.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              user.avatarUrl != null &&
                                  user.avatarUrl!.isNotEmpty
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child:
                              user.avatarUrl == null || user.avatarUrl!.isEmpty
                              ? Text(user.initials)
                              : null,
                        ),
                        title: Text(user.fullName),
                        subtitle: Text(user.email ?? user.phoneNumber ?? ''),
                        trailing: FilledButton(
                          onPressed: () async {
                            await ref
                                .read(teamNotifierProvider.notifier)
                                .addMember(widget.teamId, user.uid);
                            if (context.mounted) Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryIndigo,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Add'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInviteEmptyState(String value) {
    final isEmail = value.contains('@');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEmail ? Icons.mail_outline : Icons.phone_outlined,
                size: 32,
                color: Colors.orange.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No user found for "$value"',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'You can still invite them to join via ${isEmail ? 'email' : 'mobile number'}.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _inviteValue(value),
              icon: Icon(isEmail ? Icons.send : Icons.sms),
              label: Text(isEmail ? 'Invite by Email' : 'Invite by Mobile'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
