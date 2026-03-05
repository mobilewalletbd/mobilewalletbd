// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamChatMessage _$TeamChatMessageFromJson(Map<String, dynamic> json) {
  return _TeamChatMessage.fromJson(json);
}

/// @nodoc
mixin _$TeamChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  String get senderId =>
      throw _privateConstructorUsedError; // userId of the sender
  String get text => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get attachmentUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamChatMessageCopyWith<TeamChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamChatMessageCopyWith<$Res> {
  factory $TeamChatMessageCopyWith(
          TeamChatMessage value, $Res Function(TeamChatMessage) then) =
      _$TeamChatMessageCopyWithImpl<$Res, TeamChatMessage>;
  @useResult
  $Res call(
      {String id,
      String teamId,
      String senderId,
      String text,
      DateTime timestamp,
      String? attachmentUrl});
}

/// @nodoc
class _$TeamChatMessageCopyWithImpl<$Res, $Val extends TeamChatMessage>
    implements $TeamChatMessageCopyWith<$Res> {
  _$TeamChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? senderId = null,
    Object? text = null,
    Object? timestamp = null,
    Object? attachmentUrl = freezed,
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
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamChatMessageImplCopyWith<$Res>
    implements $TeamChatMessageCopyWith<$Res> {
  factory _$$TeamChatMessageImplCopyWith(_$TeamChatMessageImpl value,
          $Res Function(_$TeamChatMessageImpl) then) =
      __$$TeamChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teamId,
      String senderId,
      String text,
      DateTime timestamp,
      String? attachmentUrl});
}

/// @nodoc
class __$$TeamChatMessageImplCopyWithImpl<$Res>
    extends _$TeamChatMessageCopyWithImpl<$Res, _$TeamChatMessageImpl>
    implements _$$TeamChatMessageImplCopyWith<$Res> {
  __$$TeamChatMessageImplCopyWithImpl(
      _$TeamChatMessageImpl _value, $Res Function(_$TeamChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? senderId = null,
    Object? text = null,
    Object? timestamp = null,
    Object? attachmentUrl = freezed,
  }) {
    return _then(_$TeamChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamChatMessageImpl implements _TeamChatMessage {
  const _$TeamChatMessageImpl(
      {required this.id,
      required this.teamId,
      required this.senderId,
      required this.text,
      required this.timestamp,
      this.attachmentUrl});

  factory _$TeamChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String teamId;
  @override
  final String senderId;
// userId of the sender
  @override
  final String text;
  @override
  final DateTime timestamp;
  @override
  final String? attachmentUrl;

  @override
  String toString() {
    return 'TeamChatMessage(id: $id, teamId: $teamId, senderId: $senderId, text: $text, timestamp: $timestamp, attachmentUrl: $attachmentUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, teamId, senderId, text, timestamp, attachmentUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamChatMessageImplCopyWith<_$TeamChatMessageImpl> get copyWith =>
      __$$TeamChatMessageImplCopyWithImpl<_$TeamChatMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamChatMessageImplToJson(
      this,
    );
  }
}

abstract class _TeamChatMessage implements TeamChatMessage {
  const factory _TeamChatMessage(
      {required final String id,
      required final String teamId,
      required final String senderId,
      required final String text,
      required final DateTime timestamp,
      final String? attachmentUrl}) = _$TeamChatMessageImpl;

  factory _TeamChatMessage.fromJson(Map<String, dynamic> json) =
      _$TeamChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get teamId;
  @override
  String get senderId;
  @override // userId of the sender
  String get text;
  @override
  DateTime get timestamp;
  @override
  String? get attachmentUrl;
  @override
  @JsonKey(ignore: true)
  _$$TeamChatMessageImplCopyWith<_$TeamChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
