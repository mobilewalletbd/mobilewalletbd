import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

class TeamSettingsTab extends ConsumerStatefulWidget {
  final Team team;
  const TeamSettingsTab({super.key, required this.team});

  @override
  ConsumerState<TeamSettingsTab> createState() => _TeamSettingsTabState();
}

class _TeamSettingsTabState extends ConsumerState<TeamSettingsTab> {
  // --- Permission toggles (local state; persist with updateTeam in real flow) ---
  bool _membersCanAddContacts = true;
  bool _membersCanShareCards = true;
  bool _membersCanInvite = false;
  bool _membersCanViewExpenses = true;
  bool _adminsCanAddExpenses = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = widget.team.ownerId == currentUser?.id;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // ---------------------------------------------------------------
        // Team Info Card
        // ---------------------------------------------------------------
        _SectionCard(
          title: 'Team Info',
          icon: Icons.info_outline,
          children: [
            _InfoRow(label: 'Name', value: widget.team.name),
            if (widget.team.description?.isNotEmpty == true)
              _InfoRow(label: 'Description', value: widget.team.description!),
            if (widget.team.category?.isNotEmpty == true)
              _InfoRow(label: 'Category', value: widget.team.category!),
            _InfoRow(
              label: 'Invite Code',
              value: widget.team.inviteCode ?? '—',
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18, color: Colors.green),
                onPressed: widget.team.inviteCode != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Invite code copied: ${widget.team.inviteCode}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    : null,
              ),
            ),
            _InfoRow(
              label: 'Total Members',
              value: widget.team.members.length.toString(),
            ),
            if (isOwner) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Team Info'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: () => _showEditTeamDialog(context),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 16),

        // ---------------------------------------------------------------
        // Role & Permission Settings (owner only)
        // ---------------------------------------------------------------
        _SectionCard(
          title: 'Role Permissions',
          icon: Icons.admin_panel_settings_outlined,
          children: [
            if (!isOwner)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Only the team owner can change permissions.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            _PermissionTile(
              label: 'Members can add contacts',
              subtitle: 'Allow members to share contacts with the team',
              value: _membersCanAddContacts,
              enabled: isOwner,
              onChanged: (v) => setState(() => _membersCanAddContacts = v),
            ),
            _PermissionTile(
              label: 'Members can share cards',
              subtitle: 'Allow members to share digital cards',
              value: _membersCanShareCards,
              enabled: isOwner,
              onChanged: (v) => setState(() => _membersCanShareCards = v),
            ),
            _PermissionTile(
              label: 'Members can invite',
              subtitle: 'Allow members to invite others to the team',
              value: _membersCanInvite,
              enabled: isOwner,
              onChanged: (v) => setState(() => _membersCanInvite = v),
            ),
            _PermissionTile(
              label: 'Members can view expenses',
              subtitle: 'Allow members to see team expenses',
              value: _membersCanViewExpenses,
              enabled: isOwner,
              onChanged: (v) => setState(() => _membersCanViewExpenses = v),
            ),
            _PermissionTile(
              label: 'Admins can add expenses',
              subtitle: 'Allow admins to log team expenses',
              value: _adminsCanAddExpenses,
              enabled: isOwner,
              onChanged: (v) => setState(() => _adminsCanAddExpenses = v),
            ),
            if (isOwner) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    // TODO: persist to Firestore via updateTeam
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Permissions saved (coming soon)'),
                      ),
                    );
                  },
                  child: const Text('Save Permissions'),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 16),

        // ---------------------------------------------------------------
        // Manage Roles (placeholder section)
        // ---------------------------------------------------------------
        _SectionCard(
          title: 'Manage Roles',
          icon: Icons.people_outline,
          children: [
            ...widget.team.members.map((m) {
              final isThisOwner = m.userId == widget.team.ownerId;
              final roleLabel = isThisOwner
                  ? 'Owner'
                  : m.role[0].toUpperCase() + m.role.substring(1);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    m.userId.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  isThisOwner
                      ? 'You (Owner)'
                      : 'Member …${m.userId.substring(m.userId.length - 4)}',
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  m.jobTitle ?? 'No title',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: isOwner && !isThisOwner
                    ? DropdownButton<String>(
                        value: m.role.toLowerCase() == 'owner'
                            ? 'member'
                            : m.role.toLowerCase(),
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        items: ['admin', 'co-admin', 'member', 'viewer']
                            .map(
                              (r) => DropdownMenuItem(
                                value: r,
                                child: Text(
                                  r[0].toUpperCase() + r.substring(1),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (newRole) async {
                          if (newRole == null) return;
                          await ref
                              .read(teamNotifierProvider.notifier)
                              .updateMemberRole(
                                widget.team.id,
                                m.userId,
                                newRole,
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Role updated to $newRole'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        roleLabel,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
              );
            }),
          ],
        ),

        const SizedBox(height: 24),

        // ---------------------------------------------------------------
        // Danger Zone
        // ---------------------------------------------------------------
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  'DANGER ZONE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Divider(height: 1),
              if (!isOwner)
                _DangerTile(
                  icon: Icons.exit_to_app,
                  label: 'Leave Team',
                  onTap: () async {
                    final confirm = await _showConfirm(
                      context,
                      'Leave Team',
                      'Are you sure you want to leave this team?',
                    );
                    if (confirm == true && context.mounted) {
                      await ref
                          .read(teamNotifierProvider.notifier)
                          .leaveTeam(widget.team.id);
                      if (context.mounted) context.go('/settings/teams');
                    }
                  },
                ),
              if (isOwner)
                _DangerTile(
                  icon: Icons.delete_forever_outlined,
                  label: 'Delete Team',
                  onTap: () async {
                    final confirm = await _showConfirm(
                      context,
                      'Delete Team',
                      'This will permanently delete the team and all its data. This cannot be undone.',
                    );
                    if (confirm == true && context.mounted) {
                      await ref
                          .read(teamNotifierProvider.notifier)
                          .deleteTeam(widget.team.id);
                      if (context.mounted) context.go('/settings/teams');
                    }
                  },
                ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Future<bool?> _showConfirm(
    BuildContext context,
    String title,
    String message,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditTeamDialog(BuildContext context) async {
    final nameCtrl = TextEditingController(text: widget.team.name);
    final descCtrl = TextEditingController(text: widget.team.description ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Team Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true || !context.mounted) return;
    await ref
        .read(teamNotifierProvider.notifier)
        .updateTeamProfile(
          widget.team.id,
          name: nameCtrl.text.trim().isEmpty
              ? widget.team.name
              : nameCtrl.text.trim(),
          description: descCtrl.text.trim().isEmpty
              ? null
              : descCtrl.text.trim(),
          photoUrl: widget.team.photoUrl,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _PermissionTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      value: value,
      activeColor: Colors.green,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _DangerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DangerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        label,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
