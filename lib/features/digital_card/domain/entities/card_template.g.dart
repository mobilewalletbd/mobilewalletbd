// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardTemplateImpl _$$CardTemplateImplFromJson(Map<String, dynamic> json) =>
    _$CardTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$TemplateCategoryEnumMap, json['category']),
      layoutStyle: $enumDecode(_$LayoutStyleEnumMap, json['layoutStyle']),
      primaryColor: const ColorConverter()
          .fromJson((json['primaryColor'] as num).toInt()),
      secondaryColor: const ColorConverter()
          .fromJson((json['secondaryColor'] as num).toInt()),
      backgroundColor: const ColorConverter()
          .fromJson((json['backgroundColor'] as num).toInt()),
      textColor:
          const ColorConverter().fromJson((json['textColor'] as num).toInt()),
      accentColor:
          const ColorConverter().fromJson((json['accentColor'] as num).toInt()),
      backgroundGradient: const ColorListConverter()
          .fromJson(json['backgroundGradient'] as List<int>?),
      patternType:
          $enumDecodeNullable(_$CardPatternTypeEnumMap, json['patternType']) ??
              CardPatternType.none,
      patternColor: json['patternColor'] == null
          ? const Color(0x1A000000)
          : const ColorConverter()
              .fromJson((json['patternColor'] as num).toInt()),
      patternOpacity: (json['patternOpacity'] as num?)?.toDouble() ?? 0.05,
      fontFamily: json['fontFamily'] as String,
      nameFontSize: (json['nameFontSize'] as num).toDouble(),
      titleFontSize: (json['titleFontSize'] as num).toDouble(),
      bodyFontSize: (json['bodyFontSize'] as num).toDouble(),
      nameFontWeight: const FontWeightConverter()
          .fromJson((json['nameFontWeight'] as num).toInt()),
      titleFontWeight: const FontWeightConverter()
          .fromJson((json['titleFontWeight'] as num).toInt()),
      nameAlignment: $enumDecode(_$TextAlignmentEnumMap, json['nameAlignment']),
      titleAlignment:
          $enumDecode(_$TextAlignmentEnumMap, json['titleAlignment']),
      contactAlignment:
          $enumDecode(_$TextAlignmentEnumMap, json['contactAlignment']),
      showLogo: json['showLogo'] as bool,
      showQrCode: json['showQrCode'] as bool,
      showSocialIcons: json['showSocialIcons'] as bool,
      hasBackgroundPattern: json['hasBackgroundPattern'] as bool? ?? false,
      contentPadding: (json['contentPadding'] as num).toDouble(),
      elementSpacing: (json['elementSpacing'] as num).toDouble(),
      borderRadius: (json['borderRadius'] as num).toDouble(),
      previewImageUrl: json['previewImageUrl'] as String,
      isPremium: json['isPremium'] as bool,
      popularity: (json['popularity'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CardTemplateImplToJson(_$CardTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$TemplateCategoryEnumMap[instance.category]!,
      'layoutStyle': _$LayoutStyleEnumMap[instance.layoutStyle]!,
      'primaryColor': const ColorConverter().toJson(instance.primaryColor),
      'secondaryColor': const ColorConverter().toJson(instance.secondaryColor),
      'backgroundColor':
          const ColorConverter().toJson(instance.backgroundColor),
      'textColor': const ColorConverter().toJson(instance.textColor),
      'accentColor': const ColorConverter().toJson(instance.accentColor),
      'backgroundGradient':
          const ColorListConverter().toJson(instance.backgroundGradient),
      'patternType': _$CardPatternTypeEnumMap[instance.patternType]!,
      'patternColor': const ColorConverter().toJson(instance.patternColor),
      'patternOpacity': instance.patternOpacity,
      'fontFamily': instance.fontFamily,
      'nameFontSize': instance.nameFontSize,
      'titleFontSize': instance.titleFontSize,
      'bodyFontSize': instance.bodyFontSize,
      'nameFontWeight':
          const FontWeightConverter().toJson(instance.nameFontWeight),
      'titleFontWeight':
          const FontWeightConverter().toJson(instance.titleFontWeight),
      'nameAlignment': _$TextAlignmentEnumMap[instance.nameAlignment]!,
      'titleAlignment': _$TextAlignmentEnumMap[instance.titleAlignment]!,
      'contactAlignment': _$TextAlignmentEnumMap[instance.contactAlignment]!,
      'showLogo': instance.showLogo,
      'showQrCode': instance.showQrCode,
      'showSocialIcons': instance.showSocialIcons,
      'hasBackgroundPattern': instance.hasBackgroundPattern,
      'contentPadding': instance.contentPadding,
      'elementSpacing': instance.elementSpacing,
      'borderRadius': instance.borderRadius,
      'previewImageUrl': instance.previewImageUrl,
      'isPremium': instance.isPremium,
      'popularity': instance.popularity,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TemplateCategoryEnumMap = {
  TemplateCategory.minimal: 'minimal',
  TemplateCategory.modern: 'modern',
  TemplateCategory.elegant: 'elegant',
  TemplateCategory.creative: 'creative',
  TemplateCategory.professional: 'professional',
  TemplateCategory.luxury: 'luxury',
  TemplateCategory.corporate: 'corporate',
  TemplateCategory.tech: 'tech',
};

const _$LayoutStyleEnumMap = {
  LayoutStyle.centered: 'centered',
  LayoutStyle.leftAligned: 'leftAligned',
  LayoutStyle.rightAligned: 'rightAligned',
  LayoutStyle.split: 'split',
  LayoutStyle.asymmetric: 'asymmetric',
};

const _$CardPatternTypeEnumMap = {
  CardPatternType.none: 'none',
  CardPatternType.dots: 'dots',
  CardPatternType.grid: 'grid',
  CardPatternType.waves: 'waves',
  CardPatternType.lines: 'lines',
  CardPatternType.circles: 'circles',
};

const _$TextAlignmentEnumMap = {
  TextAlignment.left: 'left',
  TextAlignment.center: 'center',
  TextAlignment.right: 'right',
};
