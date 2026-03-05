// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamActivityLogImpl _$$TeamActivityLogImplFromJson(
        Map<String, dynamic> json) =>
    _$TeamActivityLogImpl(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      userId: json['userId'] as String,
      actionType: json['actionType'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TeamActivityLogImplToJson(
        _$TeamActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'userId': instance.userId,
      'actionType': instance.actionType,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };
