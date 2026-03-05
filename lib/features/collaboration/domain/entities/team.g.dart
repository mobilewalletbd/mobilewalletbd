// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamImpl _$$TeamImplFromJson(Map<String, dynamic> json) => _$TeamImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      photoUrl: json['photoUrl'] as String?,
      ownerId: json['ownerId'] as String,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
      sharedContactsCount: (json['sharedContactsCount'] as num?)?.toInt() ?? 0,
      inviteCode: json['inviteCode'] as String?,
      invitedEmails: (json['invitedEmails'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      invitedPhones: (json['invitedPhones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      visibility: json['visibility'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TeamImplToJson(_$TeamImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'photoUrl': instance.photoUrl,
      'ownerId': instance.ownerId,
      'members': instance.members,
      'totalExpenses': instance.totalExpenses,
      'sharedContactsCount': instance.sharedContactsCount,
      'inviteCode': instance.inviteCode,
      'invitedEmails': instance.invitedEmails,
      'invitedPhones': instance.invitedPhones,
      'visibility': instance.visibility,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TeamMemberImpl _$$TeamMemberImplFromJson(Map<String, dynamic> json) =>
    _$TeamMemberImpl(
      userId: json['userId'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String,
      jobTitle: json['jobTitle'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$TeamMemberImplToJson(_$TeamMemberImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'jobTitle': instance.jobTitle,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'status': instance.status,
    };
