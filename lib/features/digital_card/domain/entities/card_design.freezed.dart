// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_design.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CardDesign _$CardDesignFromJson(Map<String, dynamic> json) {
  return _CardDesign.fromJson(json);
}

/// @nodoc
mixin _$CardDesign {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get themeColor => throw _privateConstructorUsedError;
  CardDesignLayout get layoutStyle => throw _privateConstructorUsedError;
  bool get showQrCode => throw _privateConstructorUsedError;
  String? get customLogoUrl => throw _privateConstructorUsedError;
  Map<String, bool> get visibleFields => throw _privateConstructorUsedError;
  String? get frontCardTemplateId => throw _privateConstructorUsedError;
  String? get backCardTemplateId => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get customFields =>
      throw _privateConstructorUsedError;
  QrCodeStyle get qrCodeStyle => throw _privateConstructorUsedError;
  bool get allowSharing => throw _privateConstructorUsedError;
  bool get enablePattern => throw _privateConstructorUsedError;
  bool get enableGradient => throw _privateConstructorUsedError;
  List<String> get sharedWithTeams => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;
  CardStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  int get scanCount => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CardDesignCopyWith<CardDesign> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardDesignCopyWith<$Res> {
  factory $CardDesignCopyWith(
          CardDesign value, $Res Function(CardDesign) then) =
      _$CardDesignCopyWithImpl<$Res, CardDesign>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String themeColor,
      CardDesignLayout layoutStyle,
      bool showQrCode,
      String? customLogoUrl,
      Map<String, bool> visibleFields,
      String? frontCardTemplateId,
      String? backCardTemplateId,
      List<Map<String, dynamic>> customFields,
      QrCodeStyle qrCodeStyle,
      bool allowSharing,
      bool enablePattern,
      bool enableGradient,
      List<String> sharedWithTeams,
      DateTime lastModified,
      CardStatus status,
      DateTime createdAt,
      int viewCount,
      int scanCount,
      int shareCount});
}

/// @nodoc
class _$CardDesignCopyWithImpl<$Res, $Val extends CardDesign>
    implements $CardDesignCopyWith<$Res> {
  _$CardDesignCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? themeColor = null,
    Object? layoutStyle = null,
    Object? showQrCode = null,
    Object? customLogoUrl = freezed,
    Object? visibleFields = null,
    Object? frontCardTemplateId = freezed,
    Object? backCardTemplateId = freezed,
    Object? customFields = null,
    Object? qrCodeStyle = null,
    Object? allowSharing = null,
    Object? enablePattern = null,
    Object? enableGradient = null,
    Object? sharedWithTeams = null,
    Object? lastModified = null,
    Object? status = null,
    Object? createdAt = null,
    Object? viewCount = null,
    Object? scanCount = null,
    Object? shareCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as String,
      layoutStyle: null == layoutStyle
          ? _value.layoutStyle
          : layoutStyle // ignore: cast_nullable_to_non_nullable
              as CardDesignLayout,
      showQrCode: null == showQrCode
          ? _value.showQrCode
          : showQrCode // ignore: cast_nullable_to_non_nullable
              as bool,
      customLogoUrl: freezed == customLogoUrl
          ? _value.customLogoUrl
          : customLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      visibleFields: null == visibleFields
          ? _value.visibleFields
          : visibleFields // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      frontCardTemplateId: freezed == frontCardTemplateId
          ? _value.frontCardTemplateId
          : frontCardTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      backCardTemplateId: freezed == backCardTemplateId
          ? _value.backCardTemplateId
          : backCardTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      customFields: null == customFields
          ? _value.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      qrCodeStyle: null == qrCodeStyle
          ? _value.qrCodeStyle
          : qrCodeStyle // ignore: cast_nullable_to_non_nullable
              as QrCodeStyle,
      allowSharing: null == allowSharing
          ? _value.allowSharing
          : allowSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      enablePattern: null == enablePattern
          ? _value.enablePattern
          : enablePattern // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGradient: null == enableGradient
          ? _value.enableGradient
          : enableGradient // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedWithTeams: null == sharedWithTeams
          ? _value.sharedWithTeams
          : sharedWithTeams // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CardStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      scanCount: null == scanCount
          ? _value.scanCount
          : scanCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardDesignImplCopyWith<$Res>
    implements $CardDesignCopyWith<$Res> {
  factory _$$CardDesignImplCopyWith(
          _$CardDesignImpl value, $Res Function(_$CardDesignImpl) then) =
      __$$CardDesignImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String themeColor,
      CardDesignLayout layoutStyle,
      bool showQrCode,
      String? customLogoUrl,
      Map<String, bool> visibleFields,
      String? frontCardTemplateId,
      String? backCardTemplateId,
      List<Map<String, dynamic>> customFields,
      QrCodeStyle qrCodeStyle,
      bool allowSharing,
      bool enablePattern,
      bool enableGradient,
      List<String> sharedWithTeams,
      DateTime lastModified,
      CardStatus status,
      DateTime createdAt,
      int viewCount,
      int scanCount,
      int shareCount});
}

/// @nodoc
class __$$CardDesignImplCopyWithImpl<$Res>
    extends _$CardDesignCopyWithImpl<$Res, _$CardDesignImpl>
    implements _$$CardDesignImplCopyWith<$Res> {
  __$$CardDesignImplCopyWithImpl(
      _$CardDesignImpl _value, $Res Function(_$CardDesignImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? themeColor = null,
    Object? layoutStyle = null,
    Object? showQrCode = null,
    Object? customLogoUrl = freezed,
    Object? visibleFields = null,
    Object? frontCardTemplateId = freezed,
    Object? backCardTemplateId = freezed,
    Object? customFields = null,
    Object? qrCodeStyle = null,
    Object? allowSharing = null,
    Object? enablePattern = null,
    Object? enableGradient = null,
    Object? sharedWithTeams = null,
    Object? lastModified = null,
    Object? status = null,
    Object? createdAt = null,
    Object? viewCount = null,
    Object? scanCount = null,
    Object? shareCount = null,
  }) {
    return _then(_$CardDesignImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as String,
      layoutStyle: null == layoutStyle
          ? _value.layoutStyle
          : layoutStyle // ignore: cast_nullable_to_non_nullable
              as CardDesignLayout,
      showQrCode: null == showQrCode
          ? _value.showQrCode
          : showQrCode // ignore: cast_nullable_to_non_nullable
              as bool,
      customLogoUrl: freezed == customLogoUrl
          ? _value.customLogoUrl
          : customLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      visibleFields: null == visibleFields
          ? _value._visibleFields
          : visibleFields // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      frontCardTemplateId: freezed == frontCardTemplateId
          ? _value.frontCardTemplateId
          : frontCardTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      backCardTemplateId: freezed == backCardTemplateId
          ? _value.backCardTemplateId
          : backCardTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      customFields: null == customFields
          ? _value._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      qrCodeStyle: null == qrCodeStyle
          ? _value.qrCodeStyle
          : qrCodeStyle // ignore: cast_nullable_to_non_nullable
              as QrCodeStyle,
      allowSharing: null == allowSharing
          ? _value.allowSharing
          : allowSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      enablePattern: null == enablePattern
          ? _value.enablePattern
          : enablePattern // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGradient: null == enableGradient
          ? _value.enableGradient
          : enableGradient // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedWithTeams: null == sharedWithTeams
          ? _value._sharedWithTeams
          : sharedWithTeams // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CardStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      scanCount: null == scanCount
          ? _value.scanCount
          : scanCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardDesignImpl implements _CardDesign {
  const _$CardDesignImpl(
      {required this.id,
      required this.userId,
      this.themeColor = '#0BBF7D',
      this.layoutStyle = CardDesignLayout.classic,
      this.showQrCode = true,
      this.customLogoUrl,
      final Map<String, bool> visibleFields = const {},
      this.frontCardTemplateId,
      this.backCardTemplateId,
      final List<Map<String, dynamic>> customFields = const [],
      this.qrCodeStyle = QrCodeStyle.static,
      this.allowSharing = true,
      this.enablePattern = true,
      this.enableGradient = true,
      final List<String> sharedWithTeams = const [],
      required this.lastModified,
      this.status = CardStatus.active,
      required this.createdAt,
      this.viewCount = 0,
      this.scanCount = 0,
      this.shareCount = 0})
      : _visibleFields = visibleFields,
        _customFields = customFields,
        _sharedWithTeams = sharedWithTeams;

  factory _$CardDesignImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardDesignImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @JsonKey()
  final String themeColor;
  @override
  @JsonKey()
  final CardDesignLayout layoutStyle;
  @override
  @JsonKey()
  final bool showQrCode;
  @override
  final String? customLogoUrl;
  final Map<String, bool> _visibleFields;
  @override
  @JsonKey()
  Map<String, bool> get visibleFields {
    if (_visibleFields is EqualUnmodifiableMapView) return _visibleFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visibleFields);
  }

  @override
  final String? frontCardTemplateId;
  @override
  final String? backCardTemplateId;
  final List<Map<String, dynamic>> _customFields;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get customFields {
    if (_customFields is EqualUnmodifiableListView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFields);
  }

  @override
  @JsonKey()
  final QrCodeStyle qrCodeStyle;
  @override
  @JsonKey()
  final bool allowSharing;
  @override
  @JsonKey()
  final bool enablePattern;
  @override
  @JsonKey()
  final bool enableGradient;
  final List<String> _sharedWithTeams;
  @override
  @JsonKey()
  List<String> get sharedWithTeams {
    if (_sharedWithTeams is EqualUnmodifiableListView) return _sharedWithTeams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWithTeams);
  }

  @override
  final DateTime lastModified;
  @override
  @JsonKey()
  final CardStatus status;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int viewCount;
  @override
  @JsonKey()
  final int scanCount;
  @override
  @JsonKey()
  final int shareCount;

  @override
  String toString() {
    return 'CardDesign(id: $id, userId: $userId, themeColor: $themeColor, layoutStyle: $layoutStyle, showQrCode: $showQrCode, customLogoUrl: $customLogoUrl, visibleFields: $visibleFields, frontCardTemplateId: $frontCardTemplateId, backCardTemplateId: $backCardTemplateId, customFields: $customFields, qrCodeStyle: $qrCodeStyle, allowSharing: $allowSharing, enablePattern: $enablePattern, enableGradient: $enableGradient, sharedWithTeams: $sharedWithTeams, lastModified: $lastModified, status: $status, createdAt: $createdAt, viewCount: $viewCount, scanCount: $scanCount, shareCount: $shareCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardDesignImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.layoutStyle, layoutStyle) ||
                other.layoutStyle == layoutStyle) &&
            (identical(other.showQrCode, showQrCode) ||
                other.showQrCode == showQrCode) &&
            (identical(other.customLogoUrl, customLogoUrl) ||
                other.customLogoUrl == customLogoUrl) &&
            const DeepCollectionEquality()
                .equals(other._visibleFields, _visibleFields) &&
            (identical(other.frontCardTemplateId, frontCardTemplateId) ||
                other.frontCardTemplateId == frontCardTemplateId) &&
            (identical(other.backCardTemplateId, backCardTemplateId) ||
                other.backCardTemplateId == backCardTemplateId) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields) &&
            (identical(other.qrCodeStyle, qrCodeStyle) ||
                other.qrCodeStyle == qrCodeStyle) &&
            (identical(other.allowSharing, allowSharing) ||
                other.allowSharing == allowSharing) &&
            (identical(other.enablePattern, enablePattern) ||
                other.enablePattern == enablePattern) &&
            (identical(other.enableGradient, enableGradient) ||
                other.enableGradient == enableGradient) &&
            const DeepCollectionEquality()
                .equals(other._sharedWithTeams, _sharedWithTeams) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.scanCount, scanCount) ||
                other.scanCount == scanCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        themeColor,
        layoutStyle,
        showQrCode,
        customLogoUrl,
        const DeepCollectionEquality().hash(_visibleFields),
        frontCardTemplateId,
        backCardTemplateId,
        const DeepCollectionEquality().hash(_customFields),
        qrCodeStyle,
        allowSharing,
        enablePattern,
        enableGradient,
        const DeepCollectionEquality().hash(_sharedWithTeams),
        lastModified,
        status,
        createdAt,
        viewCount,
        scanCount,
        shareCount
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CardDesignImplCopyWith<_$CardDesignImpl> get copyWith =>
      __$$CardDesignImplCopyWithImpl<_$CardDesignImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardDesignImplToJson(
      this,
    );
  }
}

abstract class _CardDesign implements CardDesign {
  const factory _CardDesign(
      {required final String id,
      required final String userId,
      final String themeColor,
      final CardDesignLayout layoutStyle,
      final bool showQrCode,
      final String? customLogoUrl,
      final Map<String, bool> visibleFields,
      final String? frontCardTemplateId,
      final String? backCardTemplateId,
      final List<Map<String, dynamic>> customFields,
      final QrCodeStyle qrCodeStyle,
      final bool allowSharing,
      final bool enablePattern,
      final bool enableGradient,
      final List<String> sharedWithTeams,
      required final DateTime lastModified,
      final CardStatus status,
      required final DateTime createdAt,
      final int viewCount,
      final int scanCount,
      final int shareCount}) = _$CardDesignImpl;

  factory _CardDesign.fromJson(Map<String, dynamic> json) =
      _$CardDesignImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get themeColor;
  @override
  CardDesignLayout get layoutStyle;
  @override
  bool get showQrCode;
  @override
  String? get customLogoUrl;
  @override
  Map<String, bool> get visibleFields;
  @override
  String? get frontCardTemplateId;
  @override
  String? get backCardTemplateId;
  @override
  List<Map<String, dynamic>> get customFields;
  @override
  QrCodeStyle get qrCodeStyle;
  @override
  bool get allowSharing;
  @override
  bool get enablePattern;
  @override
  bool get enableGradient;
  @override
  List<String> get sharedWithTeams;
  @override
  DateTime get lastModified;
  @override
  CardStatus get status;
  @override
  DateTime get createdAt;
  @override
  int get viewCount;
  @override
  int get scanCount;
  @override
  int get shareCount;
  @override
  @JsonKey(ignore: true)
  _$$CardDesignImplCopyWith<_$CardDesignImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
