// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      lastSignIn: json['lastSignIn'] == null
          ? null
          : DateTime.parse(json['lastSignIn'] as String),
      provider: json['provider'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      customClaims: (json['customClaims'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'emailVerified': instance.emailVerified,
      'lastSignIn': instance.lastSignIn?.toIso8601String(),
      'provider': instance.provider,
      'isAnonymous': instance.isAnonymous,
      'customClaims': instance.customClaims,
    };
