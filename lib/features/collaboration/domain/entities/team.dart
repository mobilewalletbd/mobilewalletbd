import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// Strongly-typed roles for team members. String values match Firestore.
enum TeamMemberRole {
  owner,
  admin,
  coAdmin,
  member,
  viewer;

  /// Parse a raw Firestore string to enum. Defaults to [member].
  static TeamMemberRole fromString(String raw) {
    switch (raw.toLowerCase().replaceAll('-', '').replaceAll('_', '')) {
      case 'owner':
        return TeamMemberRole.owner;
      case 'admin':
        return TeamMemberRole.admin;
      case 'coadmin':
        return TeamMemberRole.coAdmin;
      case 'viewer':
        return TeamMemberRole.viewer;
      default:
        return TeamMemberRole.member;
    }
  }

  String get label {
    switch (this) {
      case TeamMemberRole.owner:
        return 'Owner';
      case TeamMemberRole.admin:
        return 'Admin';
      case TeamMemberRole.coAdmin:
        return 'Co-Admin';
      case TeamMemberRole.viewer:
        return 'Viewer';
      case TeamMemberRole.member:
        return 'Member';
    }
  }

  /// String stored in Firestore
  String get value {
    switch (this) {
      case TeamMemberRole.owner:
        return 'owner';
      case TeamMemberRole.admin:
        return 'admin';
      case TeamMemberRole.coAdmin:
        return 'co-admin';
      case TeamMemberRole.viewer:
        return 'viewer';
      case TeamMemberRole.member:
        return 'member';
    }
  }
}

@freezed
class Team with _$Team {
  const Team._();

  const factory Team({
    required String id,
    required String name,
    String? description,
    String? category,
    String? photoUrl,
    required String ownerId,
    @Default([]) List<TeamMember> members,
    double? totalExpenses,
    @Default(0) int sharedContactsCount,
    String? inviteCode,
    @Default([])
    List<String> invitedEmails, // Added for easy querying of invites
    @Default([]) List<String> invitedPhones, // Added for mobile number invites
    String? visibility, // 'public', 'private' (default)
    // ---------- Permission flags (task 7.4 / settings tab) ----------
    @Default(true) bool permMembersCanAddContacts,
    @Default(true) bool permMembersCanShareCards,
    @Default(false) bool permMembersCanInvite,
    @Default(true) bool permMembersCanViewExpenses,
    @Default(true) bool permAdminsCanAddExpenses,
    // ----------------------------------------------------------------
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Team;

  List<String> get memberIds => members.map((m) => m.userId).toList();

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

@freezed
class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String userId,
    String? email,
    String? phoneNumber, // Added for mobile number support
    required String role, // 'owner', 'admin', 'co-admin', 'member', 'viewer'
    String? jobTitle,
    required DateTime joinedAt,
    String? status, // 'active', 'pending', 'invited'
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
}
