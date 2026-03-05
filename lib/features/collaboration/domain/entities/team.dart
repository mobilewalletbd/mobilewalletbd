import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';
part 'team.g.dart';

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
