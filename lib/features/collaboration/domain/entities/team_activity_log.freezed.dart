// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_activity_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamActivityLog _$TeamActivityLogFromJson(Map<String, dynamic> json) {
  return _TeamActivityLog.fromJson(json);
}

/// @nodoc
mixin _$TeamActivityLog {
  String get id => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // user who performed the action
  String get actionType =>
      throw _privateConstructorUsedError; // e.g. 'member_added', 'expense_created', 'settings_changed'
  String get description =>
      throw _privateConstructorUsedError; // e.g. "Maria R. updated 'Project X' card"
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamActivityLogCopyWith<TeamActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamActivityLogCopyWith<$Res> {
  factory $TeamActivityLogCopyWith(
          TeamActivityLog value, $Res Function(TeamActivityLog) then) =
      _$TeamActivityLogCopyWithImpl<$Res, TeamActivityLog>;
  @useResult
  $Res call(
      {String id,
      String teamId,
      String userId,
      String actionType,
      String description,
      DateTime timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TeamActivityLogCopyWithImpl<$Res, $Val extends TeamActivityLog>
    implements $TeamActivityLogCopyWith<$Res> {
  _$TeamActivityLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? userId = null,
    Object? actionType = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamActivityLogImplCopyWith<$Res>
    implements $TeamActivityLogCopyWith<$Res> {
  factory _$$TeamActivityLogImplCopyWith(_$TeamActivityLogImpl value,
          $Res Function(_$TeamActivityLogImpl) then) =
      __$$TeamActivityLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teamId,
      String userId,
      String actionType,
      String description,
      DateTime timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$TeamActivityLogImplCopyWithImpl<$Res>
    extends _$TeamActivityLogCopyWithImpl<$Res, _$TeamActivityLogImpl>
    implements _$$TeamActivityLogImplCopyWith<$Res> {
  __$$TeamActivityLogImplCopyWithImpl(
      _$TeamActivityLogImpl _value, $Res Function(_$TeamActivityLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? userId = null,
    Object? actionType = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$TeamActivityLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamActivityLogImpl implements _TeamActivityLog {
  const _$TeamActivityLogImpl(
      {required this.id,
      required this.teamId,
      required this.userId,
      required this.actionType,
      required this.description,
      required this.timestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$TeamActivityLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamActivityLogImplFromJson(json);

  @override
  final String id;
  @override
  final String teamId;
  @override
  final String userId;
// user who performed the action
  @override
  final String actionType;
// e.g. 'member_added', 'expense_created', 'settings_changed'
  @override
  final String description;
// e.g. "Maria R. updated 'Project X' card"
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TeamActivityLog(id: $id, teamId: $teamId, userId: $userId, actionType: $actionType, description: $description, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActivityLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, teamId, userId, actionType,
      description, timestamp, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActivityLogImplCopyWith<_$TeamActivityLogImpl> get copyWith =>
      __$$TeamActivityLogImplCopyWithImpl<_$TeamActivityLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamActivityLogImplToJson(
      this,
    );
  }
}

abstract class _TeamActivityLog implements TeamActivityLog {
  const factory _TeamActivityLog(
      {required final String id,
      required final String teamId,
      required final String userId,
      required final String actionType,
      required final String description,
      required final DateTime timestamp,
      final Map<String, dynamic>? metadata}) = _$TeamActivityLogImpl;

  factory _TeamActivityLog.fromJson(Map<String, dynamic> json) =
      _$TeamActivityLogImpl.fromJson;

  @override
  String get id;
  @override
  String get teamId;
  @override
  String get userId;
  @override // user who performed the action
  String get actionType;
  @override // e.g. 'member_added', 'expense_created', 'settings_changed'
  String get description;
  @override // e.g. "Maria R. updated 'Project X' card"
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$TeamActivityLogImplCopyWith<_$TeamActivityLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
