// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String,
      jobTitle: json['jobTitle'] as String?,
      companyName: json['companyName'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
      personalCardId: json['personalCardId'] as String?,
      accountStatus:
          $enumDecodeNullable(_$AccountStatusEnumMap, json['accountStatus']) ??
              AccountStatus.active,
      kycTier: $enumDecodeNullable(_$KycTierEnumMap, json['kycTier']),
      timeZone: json['timeZone'] as String?,
      defaultLanguage: json['defaultLanguage'] as String? ?? 'en',
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      deviceId: json['deviceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'jobTitle': instance.jobTitle,
      'companyName': instance.companyName,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'preferences': instance.preferences,
      'personalCardId': instance.personalCardId,
      'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
      'kycTier': _$KycTierEnumMap[instance.kycTier],
      'timeZone': instance.timeZone,
      'defaultLanguage': instance.defaultLanguage,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'deviceId': instance.deviceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'ACTIVE',
  AccountStatus.suspended: 'SUSPENDED',
  AccountStatus.pendingVerification: 'PENDING_VERIFICATION',
};

const _$KycTierEnumMap = {
  KycTier.basic: 'BASIC',
  KycTier.pro: 'PRO',
  KycTier.enterprise: 'ENTERPRISE',
};
