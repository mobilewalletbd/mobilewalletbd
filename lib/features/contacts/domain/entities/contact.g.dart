// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      fullName: json['fullName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      jobTitle: json['jobTitle'] as String?,
      companyName: json['companyName'] as String?,
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emails: (json['emails'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      websiteUrls: (json['websiteUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      category: json['category'] as String? ?? 'uncategorized',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      notes: json['notes'] as String?,
      frontImageUrl: json['frontImageUrl'] as String?,
      backImageUrl: json['backImageUrl'] as String?,
      frontImageOcrText: json['frontImageOcrText'] as String?,
      backImageOcrText: json['backImageOcrText'] as String?,
      ocrFields: json['ocrFields'] as Map<String, dynamic>?,
      lastContactedAt: json['lastContactedAt'] == null
          ? null
          : DateTime.parse(json['lastContactedAt'] as String),
      contactCount: (json['contactCount'] as num?)?.toInt() ?? 0,
      source: json['source'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      fraudScore: (json['fraudScore'] as num?)?.toDouble() ?? 0.0,
      rawExtraData: json['rawExtraData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sharedWithTeams: (json['sharedWithTeams'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'fullName': instance.fullName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'jobTitle': instance.jobTitle,
      'companyName': instance.companyName,
      'phoneNumbers': instance.phoneNumbers,
      'emails': instance.emails,
      'addresses': instance.addresses,
      'websiteUrls': instance.websiteUrls,
      'socialLinks': instance.socialLinks,
      'category': instance.category,
      'tags': instance.tags,
      'isFavorite': instance.isFavorite,
      'notes': instance.notes,
      'frontImageUrl': instance.frontImageUrl,
      'backImageUrl': instance.backImageUrl,
      'frontImageOcrText': instance.frontImageOcrText,
      'backImageOcrText': instance.backImageOcrText,
      'ocrFields': instance.ocrFields,
      'lastContactedAt': instance.lastContactedAt?.toIso8601String(),
      'contactCount': instance.contactCount,
      'source': instance.source,
      'isVerified': instance.isVerified,
      'fraudScore': instance.fraudScore,
      'rawExtraData': instance.rawExtraData,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'sharedWith': instance.sharedWith,
      'sharedWithTeams': instance.sharedWithTeams,
    };

_$SocialLinkImpl _$$SocialLinkImplFromJson(Map<String, dynamic> json) =>
    _$SocialLinkImpl(
      platform: json['platform'] as String,
      url: json['url'] as String,
      handle: json['handle'] as String?,
      platformId: json['platformId'] as String?,
      isPublic: json['isPublic'] as bool? ?? true,
    );

Map<String, dynamic> _$$SocialLinkImplToJson(_$SocialLinkImpl instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'url': instance.url,
      'handle': instance.handle,
      'platformId': instance.platformId,
      'isPublic': instance.isPublic,
    };
