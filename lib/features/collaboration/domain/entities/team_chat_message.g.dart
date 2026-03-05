// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamChatMessageImpl _$$TeamChatMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$TeamChatMessageImpl(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      attachmentUrl: json['attachmentUrl'] as String?,
    );

Map<String, dynamic> _$$TeamChatMessageImplToJson(
        _$TeamChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'senderId': instance.senderId,
      'text': instance.text,
      'timestamp': instance.timestamp.toIso8601String(),
      'attachmentUrl': instance.attachmentUrl,
    };
