// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanned_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScannedCard _$ScannedCardFromJson(Map<String, dynamic> json) {
  return _ScannedCard.fromJson(json);
}

/// @nodoc
mixin _$ScannedCard {
  /// Local file path of the front card image
  String? get frontImagePath => throw _privateConstructorUsedError;

  /// Local file path of the back card image
  String? get backImagePath => throw _privateConstructorUsedError;

  /// Raw OCR text from front image
  String? get frontOcrText => throw _privateConstructorUsedError;

  /// Raw OCR text from back image
  String? get backOcrText => throw _privateConstructorUsedError;

  /// Extracted and mapped fields from OCR
  List<ExtractedField> get extractedFields =>
      throw _privateConstructorUsedError;

  /// Overall confidence score (average of all fields)
  double get overallConfidence => throw _privateConstructorUsedError;

  /// Detected language
  String? get detectedLanguage => throw _privateConstructorUsedError;

  /// Timestamp of scan
  DateTime? get scannedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScannedCardCopyWith<ScannedCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannedCardCopyWith<$Res> {
  factory $ScannedCardCopyWith(
          ScannedCard value, $Res Function(ScannedCard) then) =
      _$ScannedCardCopyWithImpl<$Res, ScannedCard>;
  @useResult
  $Res call(
      {String? frontImagePath,
      String? backImagePath,
      String? frontOcrText,
      String? backOcrText,
      List<ExtractedField> extractedFields,
      double overallConfidence,
      String? detectedLanguage,
      DateTime? scannedAt});
}

/// @nodoc
class _$ScannedCardCopyWithImpl<$Res, $Val extends ScannedCard>
    implements $ScannedCardCopyWith<$Res> {
  _$ScannedCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frontImagePath = freezed,
    Object? backImagePath = freezed,
    Object? frontOcrText = freezed,
    Object? backOcrText = freezed,
    Object? extractedFields = null,
    Object? overallConfidence = null,
    Object? detectedLanguage = freezed,
    Object? scannedAt = freezed,
  }) {
    return _then(_value.copyWith(
      frontImagePath: freezed == frontImagePath
          ? _value.frontImagePath
          : frontImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      backImagePath: freezed == backImagePath
          ? _value.backImagePath
          : backImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      frontOcrText: freezed == frontOcrText
          ? _value.frontOcrText
          : frontOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      backOcrText: freezed == backOcrText
          ? _value.backOcrText
          : backOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      extractedFields: null == extractedFields
          ? _value.extractedFields
          : extractedFields // ignore: cast_nullable_to_non_nullable
              as List<ExtractedField>,
      overallConfidence: null == overallConfidence
          ? _value.overallConfidence
          : overallConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      detectedLanguage: freezed == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      scannedAt: freezed == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScannedCardImplCopyWith<$Res>
    implements $ScannedCardCopyWith<$Res> {
  factory _$$ScannedCardImplCopyWith(
          _$ScannedCardImpl value, $Res Function(_$ScannedCardImpl) then) =
      __$$ScannedCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? frontImagePath,
      String? backImagePath,
      String? frontOcrText,
      String? backOcrText,
      List<ExtractedField> extractedFields,
      double overallConfidence,
      String? detectedLanguage,
      DateTime? scannedAt});
}

/// @nodoc
class __$$ScannedCardImplCopyWithImpl<$Res>
    extends _$ScannedCardCopyWithImpl<$Res, _$ScannedCardImpl>
    implements _$$ScannedCardImplCopyWith<$Res> {
  __$$ScannedCardImplCopyWithImpl(
      _$ScannedCardImpl _value, $Res Function(_$ScannedCardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frontImagePath = freezed,
    Object? backImagePath = freezed,
    Object? frontOcrText = freezed,
    Object? backOcrText = freezed,
    Object? extractedFields = null,
    Object? overallConfidence = null,
    Object? detectedLanguage = freezed,
    Object? scannedAt = freezed,
  }) {
    return _then(_$ScannedCardImpl(
      frontImagePath: freezed == frontImagePath
          ? _value.frontImagePath
          : frontImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      backImagePath: freezed == backImagePath
          ? _value.backImagePath
          : backImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      frontOcrText: freezed == frontOcrText
          ? _value.frontOcrText
          : frontOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      backOcrText: freezed == backOcrText
          ? _value.backOcrText
          : backOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      extractedFields: null == extractedFields
          ? _value._extractedFields
          : extractedFields // ignore: cast_nullable_to_non_nullable
              as List<ExtractedField>,
      overallConfidence: null == overallConfidence
          ? _value.overallConfidence
          : overallConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      detectedLanguage: freezed == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      scannedAt: freezed == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScannedCardImpl extends _ScannedCard {
  const _$ScannedCardImpl(
      {this.frontImagePath,
      this.backImagePath,
      this.frontOcrText,
      this.backOcrText,
      final List<ExtractedField> extractedFields = const [],
      this.overallConfidence = 0.0,
      this.detectedLanguage,
      this.scannedAt})
      : _extractedFields = extractedFields,
        super._();

  factory _$ScannedCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScannedCardImplFromJson(json);

  /// Local file path of the front card image
  @override
  final String? frontImagePath;

  /// Local file path of the back card image
  @override
  final String? backImagePath;

  /// Raw OCR text from front image
  @override
  final String? frontOcrText;

  /// Raw OCR text from back image
  @override
  final String? backOcrText;

  /// Extracted and mapped fields from OCR
  final List<ExtractedField> _extractedFields;

  /// Extracted and mapped fields from OCR
  @override
  @JsonKey()
  List<ExtractedField> get extractedFields {
    if (_extractedFields is EqualUnmodifiableListView) return _extractedFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_extractedFields);
  }

  /// Overall confidence score (average of all fields)
  @override
  @JsonKey()
  final double overallConfidence;

  /// Detected language
  @override
  final String? detectedLanguage;

  /// Timestamp of scan
  @override
  final DateTime? scannedAt;

  @override
  String toString() {
    return 'ScannedCard(frontImagePath: $frontImagePath, backImagePath: $backImagePath, frontOcrText: $frontOcrText, backOcrText: $backOcrText, extractedFields: $extractedFields, overallConfidence: $overallConfidence, detectedLanguage: $detectedLanguage, scannedAt: $scannedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannedCardImpl &&
            (identical(other.frontImagePath, frontImagePath) ||
                other.frontImagePath == frontImagePath) &&
            (identical(other.backImagePath, backImagePath) ||
                other.backImagePath == backImagePath) &&
            (identical(other.frontOcrText, frontOcrText) ||
                other.frontOcrText == frontOcrText) &&
            (identical(other.backOcrText, backOcrText) ||
                other.backOcrText == backOcrText) &&
            const DeepCollectionEquality()
                .equals(other._extractedFields, _extractedFields) &&
            (identical(other.overallConfidence, overallConfidence) ||
                other.overallConfidence == overallConfidence) &&
            (identical(other.detectedLanguage, detectedLanguage) ||
                other.detectedLanguage == detectedLanguage) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frontImagePath,
      backImagePath,
      frontOcrText,
      backOcrText,
      const DeepCollectionEquality().hash(_extractedFields),
      overallConfidence,
      detectedLanguage,
      scannedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannedCardImplCopyWith<_$ScannedCardImpl> get copyWith =>
      __$$ScannedCardImplCopyWithImpl<_$ScannedCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScannedCardImplToJson(
      this,
    );
  }
}

abstract class _ScannedCard extends ScannedCard {
  const factory _ScannedCard(
      {final String? frontImagePath,
      final String? backImagePath,
      final String? frontOcrText,
      final String? backOcrText,
      final List<ExtractedField> extractedFields,
      final double overallConfidence,
      final String? detectedLanguage,
      final DateTime? scannedAt}) = _$ScannedCardImpl;
  const _ScannedCard._() : super._();

  factory _ScannedCard.fromJson(Map<String, dynamic> json) =
      _$ScannedCardImpl.fromJson;

  @override

  /// Local file path of the front card image
  String? get frontImagePath;
  @override

  /// Local file path of the back card image
  String? get backImagePath;
  @override

  /// Raw OCR text from front image
  String? get frontOcrText;
  @override

  /// Raw OCR text from back image
  String? get backOcrText;
  @override

  /// Extracted and mapped fields from OCR
  List<ExtractedField> get extractedFields;
  @override

  /// Overall confidence score (average of all fields)
  double get overallConfidence;
  @override

  /// Detected language
  String? get detectedLanguage;
  @override

  /// Timestamp of scan
  DateTime? get scannedAt;
  @override
  @JsonKey(ignore: true)
  _$$ScannedCardImplCopyWith<_$ScannedCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExtractedField _$ExtractedFieldFromJson(Map<String, dynamic> json) {
  return _ExtractedField.fromJson(json);
}

/// @nodoc
mixin _$ExtractedField {
  /// Type of field (name, title, company, phone, email, address, website)
  String get fieldType => throw _privateConstructorUsedError;

  /// Extracted value
  String get value => throw _privateConstructorUsedError;

  /// Confidence score from 0.0 to 1.0
  double get confidence => throw _privateConstructorUsedError;

  /// Original raw text that was matched
  String? get rawText => throw _privateConstructorUsedError;

  /// Whether this field has been manually edited
  bool get isEdited => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExtractedFieldCopyWith<ExtractedField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedFieldCopyWith<$Res> {
  factory $ExtractedFieldCopyWith(
          ExtractedField value, $Res Function(ExtractedField) then) =
      _$ExtractedFieldCopyWithImpl<$Res, ExtractedField>;
  @useResult
  $Res call(
      {String fieldType,
      String value,
      double confidence,
      String? rawText,
      bool isEdited});
}

/// @nodoc
class _$ExtractedFieldCopyWithImpl<$Res, $Val extends ExtractedField>
    implements $ExtractedFieldCopyWith<$Res> {
  _$ExtractedFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldType = null,
    Object? value = null,
    Object? confidence = null,
    Object? rawText = freezed,
    Object? isEdited = null,
  }) {
    return _then(_value.copyWith(
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      rawText: freezed == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtractedFieldImplCopyWith<$Res>
    implements $ExtractedFieldCopyWith<$Res> {
  factory _$$ExtractedFieldImplCopyWith(_$ExtractedFieldImpl value,
          $Res Function(_$ExtractedFieldImpl) then) =
      __$$ExtractedFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fieldType,
      String value,
      double confidence,
      String? rawText,
      bool isEdited});
}

/// @nodoc
class __$$ExtractedFieldImplCopyWithImpl<$Res>
    extends _$ExtractedFieldCopyWithImpl<$Res, _$ExtractedFieldImpl>
    implements _$$ExtractedFieldImplCopyWith<$Res> {
  __$$ExtractedFieldImplCopyWithImpl(
      _$ExtractedFieldImpl _value, $Res Function(_$ExtractedFieldImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldType = null,
    Object? value = null,
    Object? confidence = null,
    Object? rawText = freezed,
    Object? isEdited = null,
  }) {
    return _then(_$ExtractedFieldImpl(
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      rawText: freezed == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedFieldImpl extends _ExtractedField {
  const _$ExtractedFieldImpl(
      {required this.fieldType,
      required this.value,
      this.confidence = 0.0,
      this.rawText,
      this.isEdited = false})
      : super._();

  factory _$ExtractedFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedFieldImplFromJson(json);

  /// Type of field (name, title, company, phone, email, address, website)
  @override
  final String fieldType;

  /// Extracted value
  @override
  final String value;

  /// Confidence score from 0.0 to 1.0
  @override
  @JsonKey()
  final double confidence;

  /// Original raw text that was matched
  @override
  final String? rawText;

  /// Whether this field has been manually edited
  @override
  @JsonKey()
  final bool isEdited;

  @override
  String toString() {
    return 'ExtractedField(fieldType: $fieldType, value: $value, confidence: $confidence, rawText: $rawText, isEdited: $isEdited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedFieldImpl &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fieldType, value, confidence, rawText, isEdited);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedFieldImplCopyWith<_$ExtractedFieldImpl> get copyWith =>
      __$$ExtractedFieldImplCopyWithImpl<_$ExtractedFieldImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedFieldImplToJson(
      this,
    );
  }
}

abstract class _ExtractedField extends ExtractedField {
  const factory _ExtractedField(
      {required final String fieldType,
      required final String value,
      final double confidence,
      final String? rawText,
      final bool isEdited}) = _$ExtractedFieldImpl;
  const _ExtractedField._() : super._();

  factory _ExtractedField.fromJson(Map<String, dynamic> json) =
      _$ExtractedFieldImpl.fromJson;

  @override

  /// Type of field (name, title, company, phone, email, address, website)
  String get fieldType;
  @override

  /// Extracted value
  String get value;
  @override

  /// Confidence score from 0.0 to 1.0
  double get confidence;
  @override

  /// Original raw text that was matched
  String? get rawText;
  @override

  /// Whether this field has been manually edited
  bool get isEdited;
  @override
  @JsonKey(ignore: true)
  _$$ExtractedFieldImplCopyWith<_$ExtractedFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
