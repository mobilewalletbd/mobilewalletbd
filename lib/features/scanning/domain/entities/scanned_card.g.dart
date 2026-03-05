// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScannedCardImpl _$$ScannedCardImplFromJson(Map<String, dynamic> json) =>
    _$ScannedCardImpl(
      frontImagePath: json['frontImagePath'] as String?,
      backImagePath: json['backImagePath'] as String?,
      frontOcrText: json['frontOcrText'] as String?,
      backOcrText: json['backOcrText'] as String?,
      extractedFields: (json['extractedFields'] as List<dynamic>?)
              ?.map((e) => ExtractedField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      overallConfidence: (json['overallConfidence'] as num?)?.toDouble() ?? 0.0,
      detectedLanguage: json['detectedLanguage'] as String?,
      scannedAt: json['scannedAt'] == null
          ? null
          : DateTime.parse(json['scannedAt'] as String),
    );

Map<String, dynamic> _$$ScannedCardImplToJson(_$ScannedCardImpl instance) =>
    <String, dynamic>{
      'frontImagePath': instance.frontImagePath,
      'backImagePath': instance.backImagePath,
      'frontOcrText': instance.frontOcrText,
      'backOcrText': instance.backOcrText,
      'extractedFields': instance.extractedFields,
      'overallConfidence': instance.overallConfidence,
      'detectedLanguage': instance.detectedLanguage,
      'scannedAt': instance.scannedAt?.toIso8601String(),
    };

_$ExtractedFieldImpl _$$ExtractedFieldImplFromJson(Map<String, dynamic> json) =>
    _$ExtractedFieldImpl(
      fieldType: json['fieldType'] as String,
      value: json['value'] as String,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      rawText: json['rawText'] as String?,
      isEdited: json['isEdited'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExtractedFieldImplToJson(
        _$ExtractedFieldImpl instance) =>
    <String, dynamic>{
      'fieldType': instance.fieldType,
      'value': instance.value,
      'confidence': instance.confidence,
      'rawText': instance.rawText,
      'isEdited': instance.isEdited,
    };
