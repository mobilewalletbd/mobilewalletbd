import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_chat_message.freezed.dart';
part 'team_chat_message.g.dart';

@freezed
class TeamChatMessage with _$TeamChatMessage {
  const factory TeamChatMessage({
    required String id,
    required String teamId,
    required String senderId, // userId of the sender
    required String text,
    required DateTime timestamp,
    String? attachmentUrl, // optional image/file attachment
  }) = _TeamChatMessage;

  factory TeamChatMessage.fromJson(Map<String, dynamic> json) =>
      _$TeamChatMessageFromJson(json);
}
