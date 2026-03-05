import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_activity_log.freezed.dart';
part 'team_activity_log.g.dart';

@freezed
class TeamActivityLog with _$TeamActivityLog {
  const factory TeamActivityLog({
    required String id,
    required String teamId,
    required String userId, // user who performed the action
    required String
    actionType, // e.g. 'member_added', 'expense_created', 'settings_changed'
    required String description, // e.g. "Maria R. updated 'Project X' card"
    required DateTime timestamp,
    Map<String, dynamic>? metadata, // Any extra data specific to the action
  }) = _TeamActivityLog;

  factory TeamActivityLog.fromJson(Map<String, dynamic> json) =>
      _$TeamActivityLogFromJson(json);
}
