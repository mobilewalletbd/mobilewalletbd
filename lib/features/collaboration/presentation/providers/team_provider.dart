import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mobile_wallet/features/collaboration/data/repositories/team_repository_impl.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_expense.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_chat_message.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_activity_log.dart';
import 'package:mobile_wallet/features/collaboration/domain/repositories/team_repository.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';
import 'package:mobile_wallet/features/settings/data/repositories/user_profile_repository_impl.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

// State for Team List
final userTeamsProvider = StreamProvider.autoDispose<List<Team>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final repository = ref.watch(teamRepositoryProvider);
  return repository.getUserTeamsStream(user.id);
});

// State for Pending Invites
final pendingInvitesProvider = StreamProvider.autoDispose<List<Team>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final repository = ref.watch(teamRepositoryProvider);
  return repository.getPendingInvitesStream(
    user.id,
    user.email,
    user.phoneNumber,
  );
});

// State for Single Team Details
final teamDetailsProvider = StreamProvider.autoDispose.family<Team?, String>((
  ref,
  teamId,
) {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getTeamStream(teamId);
});

// State for Team Members List Only
final teamMembersProvider = StreamProvider.autoDispose
    .family<List<TeamMember>, String>((ref, teamId) {
      final repository = ref.watch(teamRepositoryProvider);
      return repository
          .getTeamStream(teamId)
          .map((team) => team?.members ?? []);
    });

// State for Team Expenses
final teamExpensesProvider = StreamProvider.autoDispose
    .family<List<TeamExpense>, String>((ref, teamId) {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.getTeamExpensesStream(teamId);
    });

// State for Team Chat
final teamChatProvider = StreamProvider.autoDispose
    .family<List<TeamChatMessage>, String>((ref, teamId) {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.getTeamChatStream(teamId);
    });

// State for Team Activity
final teamActivityProvider = StreamProvider.autoDispose
    .family<List<TeamActivityLog>, String>((ref, teamId) {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.getTeamActivityStream(teamId);
    });

// State for Public Team Discovery
final publicTeamsProvider = StreamProvider.autoDispose
    .family<List<Team>, String>((ref, query) {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.discoverPublicTeams(query);
    });

// State for Shared Contacts (Paginated)
final sharedContactsProvider = FutureProvider.autoDispose
    .family<List<dynamic>, Map<String, dynamic>>((ref, params) async {
      final repository = ref.watch(teamRepositoryProvider);
      final teamId = params['teamId'] as String;
      final offset = params['offset'] as int? ?? 0;
      final limit = params['limit'] as int? ?? 20;

      return repository.getSharedContacts(teamId, offset: offset, limit: limit);
    });

// Team Controller for actions
class TeamNotifier extends StateNotifier<AsyncValue<void>> {
  final TeamRepository _repository;
  final Ref _ref;

  TeamNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> createTeam(
    String name,
    String? description,
    String? photoUrl, {
    String? category,
    String? visibility,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      developer.log(
        '[TeamNotifier] createTeam called. User: ${user?.id ?? 'NULL'}',
      );
      if (user == null) throw Exception('User not authenticated');

      developer.log('[TeamNotifier] Creating team "$name" for user ${user.id}');
      final newTeam = Team(
        id: const Uuid().v4(),
        name: name,
        description: description,
        category: category,
        visibility: visibility ?? 'private',
        photoUrl: photoUrl,
        ownerId: user.id,
        members: [
          TeamMember(
            userId: user.id,
            role: 'owner',
            joinedAt: DateTime.now(),
            status: 'active',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      developer.log(
        '[TeamNotifier] Team object created: id=${newTeam.id}, ownerId=${newTeam.ownerId}',
      );
      developer.log(
        '[TeamNotifier] Members: ${newTeam.members.map((m) => m.userId).toList()}',
      );
      developer.log('[TeamNotifier] Calling repository.createTeam...');

      await _repository.createTeam(newTeam);

      developer.log('[TeamNotifier] ✅ Team created successfully!');
      // Refresh list
      _ref.invalidate(userTeamsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      developer.log('[TeamNotifier] ❌ Failed to create team: $e');
      developer.log('[TeamNotifier] Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMember(String teamId, String userId) async {
    state = const AsyncValue.loading();
    try {
      final member = TeamMember(
        userId: userId,
        role: 'member',
        joinedAt: DateTime.now(),
        status: 'pending', // or active immediately
      );
      await _repository.addMember(teamId, member);
      _ref.invalidate(teamDetailsProvider(teamId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> inviteMember({
    required String teamId,
    String? email,
    String? phoneNumber,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.inviteMember(
        teamId,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
      );
      _ref.invalidate(teamDetailsProvider(teamId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> respondToInvite(String teamId, bool accept) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      await _repository.respondToInvite(
        teamId,
        user.id,
        user.email,
        user.phoneNumber,
        accept,
      );

      // Refresh both teams list and pending invites
      _ref.invalidate(userTeamsProvider);
      _ref.invalidate(pendingInvitesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeMember(String teamId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeMember(teamId, userId);
      _ref.invalidate(teamDetailsProvider(teamId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTeam(String teamId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTeam(teamId);
      _ref.invalidate(userTeamsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> leaveTeam(String teamId) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      await _repository.removeMember(teamId, user.id);
      _ref.invalidate(userTeamsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> joinTeam(String teamId) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      await _repository.joinTeam(teamId, user.id);
      _ref.invalidate(userTeamsProvider);
      _ref.invalidate(teamDetailsProvider(teamId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTeamExpense(String teamId, TeamExpense expense) async {
    try {
      await _repository.addTeamExpense(teamId, expense);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMemberRole(
    String teamId,
    String userId,
    String newRole,
  ) async {
    try {
      await _repository.updateMemberRole(teamId, userId, newRole);
      _ref.invalidate(teamDetailsProvider(teamId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendTeamChatMessage(String teamId, String text) async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');
      final message = TeamChatMessage(
        id: const Uuid().v4(),
        teamId: teamId,
        senderId: user.id,
        text: text,
        timestamp: DateTime.now(),
      );
      await _repository.sendTeamChatMessage(teamId, message);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTeamProfile(
    String teamId, {
    required String name,
    String? description,
    String? photoUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Fetch current team to preserve all existing fields
      final current = await _repository.getTeam(teamId);
      if (current == null) throw Exception('Team not found');
      final updated = current.copyWith(
        name: name,
        description: description,
        photoUrl: photoUrl,
      );
      await _repository.updateTeam(updated);
      _ref.invalidate(teamDetailsProvider(teamId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final teamNotifierProvider =
    StateNotifierProvider<TeamNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(teamRepositoryProvider);
      return TeamNotifier(repository, ref);
    });

/// Provider to fetch and cache a user's profile for the Team Directory
final teamMemberProfileProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.getUserProfile(userId);
});
