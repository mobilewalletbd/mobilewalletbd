// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_design_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CardDesignVersion _$CardDesignVersionFromJson(Map<String, dynamic> json) {
  return _CardDesignVersion.fromJson(json);
}

/// @nodoc
mixin _$CardDesignVersion {
  String get id => throw _privateConstructorUsedError;
  String get cardId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  Map<String, dynamic> get snapshotData => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get commitMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CardDesignVersionCopyWith<CardDesignVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardDesignVersionCopyWith<$Res> {
  factory $CardDesignVersionCopyWith(
          CardDesignVersion value, $Res Function(CardDesignVersion) then) =
      _$CardDesignVersionCopyWithImpl<$Res, CardDesignVersion>;
  @useResult
  $Res call(
      {String id,
      String cardId,
      String userId,
      Map<String, dynamic> snapshotData,
      DateTime createdAt,
      String? commitMessage});
}

/// @nodoc
class _$CardDesignVersionCopyWithImpl<$Res, $Val extends CardDesignVersion>
    implements $CardDesignVersionCopyWith<$Res> {
  _$CardDesignVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? userId = null,
    Object? snapshotData = null,
    Object? createdAt = null,
    Object? commitMessage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotData: null == snapshotData
          ? _value.snapshotData
          : snapshotData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      commitMessage: freezed == commitMessage
          ? _value.commitMessage
          : commitMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardDesignVersionImplCopyWith<$Res>
    implements $CardDesignVersionCopyWith<$Res> {
  factory _$$CardDesignVersionImplCopyWith(_$CardDesignVersionImpl value,
          $Res Function(_$CardDesignVersionImpl) then) =
      __$$CardDesignVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String cardId,
      String userId,
      Map<String, dynamic> snapshotData,
      DateTime createdAt,
      String? commitMessage});
}

/// @nodoc
class __$$CardDesignVersionImplCopyWithImpl<$Res>
    extends _$CardDesignVersionCopyWithImpl<$Res, _$CardDesignVersionImpl>
    implements _$$CardDesignVersionImplCopyWith<$Res> {
  __$$CardDesignVersionImplCopyWithImpl(_$CardDesignVersionImpl _value,
      $Res Function(_$CardDesignVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? userId = null,
    Object? snapshotData = null,
    Object? createdAt = null,
    Object? commitMessage = freezed,
  }) {
    return _then(_$CardDesignVersionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotData: null == snapshotData
          ? _value._snapshotData
          : snapshotData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      commitMessage: freezed == commitMessage
          ? _value.commitMessage
          : commitMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardDesignVersionImpl implements _CardDesignVersion {
  const _$CardDesignVersionImpl(
      {required this.id,
      required this.cardId,
      required this.userId,
      required final Map<String, dynamic> snapshotData,
      required this.createdAt,
      this.commitMessage})
      : _snapshotData = snapshotData;

  factory _$CardDesignVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardDesignVersionImplFromJson(json);

  @override
  final String id;
  @override
  final String cardId;
  @override
  final String userId;
  final Map<String, dynamic> _snapshotData;
  @override
  Map<String, dynamic> get snapshotData {
    if (_snapshotData is EqualUnmodifiableMapView) return _snapshotData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_snapshotData);
  }

  @override
  final DateTime createdAt;
  @override
  final String? commitMessage;

  @override
  String toString() {
    return 'CardDesignVersion(id: $id, cardId: $cardId, userId: $userId, snapshotData: $snapshotData, createdAt: $createdAt, commitMessage: $commitMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardDesignVersionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._snapshotData, _snapshotData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.commitMessage, commitMessage) ||
                other.commitMessage == commitMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cardId,
      userId,
      const DeepCollectionEquality().hash(_snapshotData),
      createdAt,
      commitMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CardDesignVersionImplCopyWith<_$CardDesignVersionImpl> get copyWith =>
      __$$CardDesignVersionImplCopyWithImpl<_$CardDesignVersionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardDesignVersionImplToJson(
      this,
    );
  }
}

abstract class _CardDesignVersion implements CardDesignVersion {
  const factory _CardDesignVersion(
      {required final String id,
      required final String cardId,
      required final String userId,
      required final Map<String, dynamic> snapshotData,
      required final DateTime createdAt,
      final String? commitMessage}) = _$CardDesignVersionImpl;

  factory _CardDesignVersion.fromJson(Map<String, dynamic> json) =
      _$CardDesignVersionImpl.fromJson;

  @override
  String get id;
  @override
  String get cardId;
  @override
  String get userId;
  @override
  Map<String, dynamic> get snapshotData;
  @override
  DateTime get createdAt;
  @override
  String? get commitMessage;
  @override
  @JsonKey(ignore: true)
  _$$CardDesignVersionImplCopyWith<_$CardDesignVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
