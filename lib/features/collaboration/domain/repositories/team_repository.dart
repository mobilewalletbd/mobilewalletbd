import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_expense.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_chat_message.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_activity_log.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

abstract class TeamRepository {
  /// Creates a new team.
  Future<Team> createTeam(Team team);

  /// Gets a team by ID.
  Future<Team?> getTeam(String teamId);

  /// Gets a stream of a team by ID.
  Stream<Team?> getTeamStream(String teamId);

  /// Gets all teams where the user is a member.
  Future<List<Team>> getUserTeams(String userId);

  /// Gets a stream of all teams where the user is a member.
  Stream<List<Team>> getUserTeamsStream(String userId);

  /// Gets contacts shared with a team. Supports pagination.
  Future<List<Contact>> getSharedContacts(
    String teamId, {
    int offset = 0,
    int limit = 20,
  });

  /// Adds a member to a team.
  Future<void> addMember(String teamId, TeamMember member);

  /// Removes a member from a team.
  Future<void> removeMember(String teamId, String userId);

  /// Updates team details (name, description, photo).
  Future<void> updateTeam(Team team);

  /// Updates a member's role within the team.
  Future<void> updateMemberRole(String teamId, String userId, String newRole);

  /// Deletes a team.
  Future<void> deleteTeam(String teamId);

  // --- Sub-features ---

  /// Adds a new expense to the team.
  Future<void> addTeamExpense(String teamId, TeamExpense expense);

  /// Gets a stream of expenses for a team. Supports pagination via limit.
  Stream<List<TeamExpense>> getTeamExpensesStream(
    String teamId, {
    int limit = 20,
  });

  /// Sends a chat message to the team group chat.
  Future<void> sendTeamChatMessage(String teamId, TeamChatMessage message);

  /// Gets a stream of chat messages for a team. Supports pagination via limit.
  Stream<List<TeamChatMessage>> getTeamChatStream(
    String teamId, {
    int limit = 50,
  });

  /// Gets a stream of activity logs for a team. Supports pagination via limit.
  Stream<List<TeamActivityLog>> getTeamActivityStream(
    String teamId, {
    int limit = 20,
  });

  /// Invites a member to a team by email or phone number.
  Future<void> inviteMember(
    String teamId, {
    String? email,
    String? phoneNumber,
    required String role,
  });

  /// Responds to a team invitation.
  Future<void> respondToInvite(
    String teamId,
    String userId,
    String? email,
    String? phoneNumber,
    bool accept,
  );

  /// Gets a stream of pending invitations for a user.
  Stream<List<Team>> getPendingInvitesStream(
    String userId,
    String? email,
    String? phoneNumber,
  );

  /// Searches for public teams by name/description.
  Stream<List<Team>> discoverPublicTeams(String query);

  /// Joins a public team.
  Future<void> joinTeam(String teamId, String userId);
}
