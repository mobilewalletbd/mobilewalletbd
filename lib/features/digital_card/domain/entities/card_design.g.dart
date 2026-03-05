// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_design.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardDesignImpl _$$CardDesignImplFromJson(Map<String, dynamic> json) =>
    _$CardDesignImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      themeColor: json['themeColor'] as String? ?? '#0BBF7D',
      layoutStyle:
          $enumDecodeNullable(_$CardDesignLayoutEnumMap, json['layoutStyle']) ??
              CardDesignLayout.classic,
      showQrCode: json['showQrCode'] as bool? ?? true,
      customLogoUrl: json['customLogoUrl'] as String?,
      visibleFields: (json['visibleFields'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      frontCardTemplateId: json['frontCardTemplateId'] as String?,
      backCardTemplateId: json['backCardTemplateId'] as String?,
      customFields: (json['customFields'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      qrCodeStyle:
          $enumDecodeNullable(_$QrCodeStyleEnumMap, json['qrCodeStyle']) ??
              QrCodeStyle.static,
      allowSharing: json['allowSharing'] as bool? ?? true,
      enablePattern: json['enablePattern'] as bool? ?? true,
      enableGradient: json['enableGradient'] as bool? ?? true,
      sharedWithTeams: (json['sharedWithTeams'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastModified: DateTime.parse(json['lastModified'] as String),
      status: $enumDecodeNullable(_$CardStatusEnumMap, json['status']) ??
          CardStatus.active,
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      scanCount: (json['scanCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CardDesignImplToJson(_$CardDesignImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'themeColor': instance.themeColor,
      'layoutStyle': _$CardDesignLayoutEnumMap[instance.layoutStyle]!,
      'showQrCode': instance.showQrCode,
      'customLogoUrl': instance.customLogoUrl,
      'visibleFields': instance.visibleFields,
      'frontCardTemplateId': instance.frontCardTemplateId,
      'backCardTemplateId': instance.backCardTemplateId,
      'customFields': instance.customFields,
      'qrCodeStyle': _$QrCodeStyleEnumMap[instance.qrCodeStyle]!,
      'allowSharing': instance.allowSharing,
      'enablePattern': instance.enablePattern,
      'enableGradient': instance.enableGradient,
      'sharedWithTeams': instance.sharedWithTeams,
      'lastModified': instance.lastModified.toIso8601String(),
      'status': _$CardStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'viewCount': instance.viewCount,
      'scanCount': instance.scanCount,
      'shareCount': instance.shareCount,
    };

const _$CardDesignLayoutEnumMap = {
  CardDesignLayout.classic: 'classic',
  CardDesignLayout.modern: 'modern',
  CardDesignLayout.minimal: 'minimal',
};

const _$QrCodeStyleEnumMap = {
  QrCodeStyle.static: 'static',
  QrCodeStyle.dynamic: 'dynamic',
  QrCodeStyle.custom: 'custom',
};

const _$CardStatusEnumMap = {
  CardStatus.active: 'active',
  CardStatus.draft: 'draft',
  CardStatus.archived: 'archived',
};
