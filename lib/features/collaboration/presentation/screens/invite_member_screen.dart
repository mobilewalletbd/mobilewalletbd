import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/settings/data/repositories/user_profile_repository_impl.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';

class InviteMemberScreen extends ConsumerStatefulWidget {
  final String teamId;
  const InviteMemberScreen({super.key, required this.teamId});

  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _searchController = TextEditingController();

  List<UserProfile> _searchResults = [];
  final Set<String> _selectedUids = {};
  bool _isSearching = false;
  bool _isSending = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final repo = ref.read(userProfileRepositoryProvider);
      final results = await repo.searchUsers(query.trim());
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        if (results.isEmpty) _error = 'No users found for "$query"';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _sendInvites() async {
    if (_selectedUids.isEmpty) return;

    setState(() => _isSending = true);

    try {
      for (final uid in _selectedUids) {
        await ref
            .read(teamNotifierProvider.notifier)
            .addMember(widget.teamId, uid);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_selectedUids.length} member${_selectedUids.length > 1 ? 's' : ''} added successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add members: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _toggleSelect(String uid) {
    setState(() {
      if (_selectedUids.contains(uid)) {
        _selectedUids.remove(uid);
      } else {
        _selectedUids.add(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Invite Members'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            color: Colors.green,
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search by email or phone…',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- Selected summary chip bar ---
          if (_selectedUids.isNotEmpty)
            Container(
              color: Colors.green.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedUids.length} selected',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _selectedUids.clear()),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),

          // --- Results List ---
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _error != null && _searchResults.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : _searchResults.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group_add,
                              size: 72,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Search for people to invite\nto your team.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _searchResults.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      final isSelected = _selectedUids.contains(user.uid);

                      return CheckboxListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        value: isSelected,
                        activeColor: Colors.green,
                        onChanged: (_) => _toggleSelect(user.uid),
                        secondary: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.green.shade100,
                          backgroundImage:
                              user.avatarUrl != null &&
                                  user.avatarUrl!.isNotEmpty
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child:
                              user.avatarUrl == null || user.avatarUrl!.isEmpty
                              ? Text(
                                  user.initials,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        title: Text(
                          user.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          user.email ?? user.phoneNumber ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // --- Sticky Send Invites Button ---
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _selectedUids.isEmpty || _isSending
                  ? null
                  : _sendInvites,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _selectedUids.isEmpty
                          ? 'Select members to invite'
                          : 'Send Invites (${_selectedUids.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
