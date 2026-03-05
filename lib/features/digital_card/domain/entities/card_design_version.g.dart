// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_design_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardDesignVersionImpl _$$CardDesignVersionImplFromJson(
        Map<String, dynamic> json) =>
    _$CardDesignVersionImpl(
      id: json['id'] as String,
      cardId: json['cardId'] as String,
      userId: json['userId'] as String,
      snapshotData: json['snapshotData'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      commitMessage: json['commitMessage'] as String?,
    );

Map<String, dynamic> _$$CardDesignVersionImplToJson(
        _$CardDesignVersionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardId': instance.cardId,
      'userId': instance.userId,
      'snapshotData': instance.snapshotData,
      'createdAt': instance.createdAt.toIso8601String(),
      'commitMessage': instance.commitMessage,
    };
