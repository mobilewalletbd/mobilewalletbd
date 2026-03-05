// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Team _$TeamFromJson(Map<String, dynamic> json) {
  return _Team.fromJson(json);
}

/// @nodoc
mixin _$Team {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  List<TeamMember> get members => throw _privateConstructorUsedError;
  double? get totalExpenses => throw _privateConstructorUsedError;
  int get sharedContactsCount => throw _privateConstructorUsedError;
  String? get inviteCode => throw _privateConstructorUsedError;
  List<String> get invitedEmails =>
      throw _privateConstructorUsedError; // Added for easy querying of invites
  List<String> get invitedPhones =>
      throw _privateConstructorUsedError; // Added for mobile number invites
  String? get visibility =>
      throw _privateConstructorUsedError; // 'public', 'private' (default)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamCopyWith<Team> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamCopyWith<$Res> {
  factory $TeamCopyWith(Team value, $Res Function(Team) then) =
      _$TeamCopyWithImpl<$Res, Team>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? category,
      String? photoUrl,
      String ownerId,
      List<TeamMember> members,
      double? totalExpenses,
      int sharedContactsCount,
      String? inviteCode,
      List<String> invitedEmails,
      List<String> invitedPhones,
      String? visibility,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TeamCopyWithImpl<$Res, $Val extends Team>
    implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? photoUrl = freezed,
    Object? ownerId = null,
    Object? members = null,
    Object? totalExpenses = freezed,
    Object? sharedContactsCount = null,
    Object? inviteCode = freezed,
    Object? invitedEmails = null,
    Object? invitedPhones = null,
    Object? visibility = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<TeamMember>,
      totalExpenses: freezed == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double?,
      sharedContactsCount: null == sharedContactsCount
          ? _value.sharedContactsCount
          : sharedContactsCount // ignore: cast_nullable_to_non_nullable
              as int,
      inviteCode: freezed == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedEmails: null == invitedEmails
          ? _value.invitedEmails
          : invitedEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      invitedPhones: null == invitedPhones
          ? _value.invitedPhones
          : invitedPhones // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamImplCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$$TeamImplCopyWith(
          _$TeamImpl value, $Res Function(_$TeamImpl) then) =
      __$$TeamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? category,
      String? photoUrl,
      String ownerId,
      List<TeamMember> members,
      double? totalExpenses,
      int sharedContactsCount,
      String? inviteCode,
      List<String> invitedEmails,
      List<String> invitedPhones,
      String? visibility,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TeamImplCopyWithImpl<$Res>
    extends _$TeamCopyWithImpl<$Res, _$TeamImpl>
    implements _$$TeamImplCopyWith<$Res> {
  __$$TeamImplCopyWithImpl(_$TeamImpl _value, $Res Function(_$TeamImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? photoUrl = freezed,
    Object? ownerId = null,
    Object? members = null,
    Object? totalExpenses = freezed,
    Object? sharedContactsCount = null,
    Object? inviteCode = freezed,
    Object? invitedEmails = null,
    Object? invitedPhones = null,
    Object? visibility = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TeamImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<TeamMember>,
      totalExpenses: freezed == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as double?,
      sharedContactsCount: null == sharedContactsCount
          ? _value.sharedContactsCount
          : sharedContactsCount // ignore: cast_nullable_to_non_nullable
              as int,
      inviteCode: freezed == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedEmails: null == invitedEmails
          ? _value._invitedEmails
          : invitedEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      invitedPhones: null == invitedPhones
          ? _value._invitedPhones
          : invitedPhones // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamImpl extends _Team {
  const _$TeamImpl(
      {required this.id,
      required this.name,
      this.description,
      this.category,
      this.photoUrl,
      required this.ownerId,
      final List<TeamMember> members = const [],
      this.totalExpenses,
      this.sharedContactsCount = 0,
      this.inviteCode,
      final List<String> invitedEmails = const [],
      final List<String> invitedPhones = const [],
      this.visibility,
      required this.createdAt,
      required this.updatedAt})
      : _members = members,
        _invitedEmails = invitedEmails,
        _invitedPhones = invitedPhones,
        super._();

  factory _$TeamImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? category;
  @override
  final String? photoUrl;
  @override
  final String ownerId;
  final List<TeamMember> _members;
  @override
  @JsonKey()
  List<TeamMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final double? totalExpenses;
  @override
  @JsonKey()
  final int sharedContactsCount;
  @override
  final String? inviteCode;
  final List<String> _invitedEmails;
  @override
  @JsonKey()
  List<String> get invitedEmails {
    if (_invitedEmails is EqualUnmodifiableListView) return _invitedEmails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invitedEmails);
  }

// Added for easy querying of invites
  final List<String> _invitedPhones;
// Added for easy querying of invites
  @override
  @JsonKey()
  List<String> get invitedPhones {
    if (_invitedPhones is EqualUnmodifiableListView) return _invitedPhones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invitedPhones);
  }

// Added for mobile number invites
  @override
  final String? visibility;
// 'public', 'private' (default)
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Team(id: $id, name: $name, description: $description, category: $category, photoUrl: $photoUrl, ownerId: $ownerId, members: $members, totalExpenses: $totalExpenses, sharedContactsCount: $sharedContactsCount, inviteCode: $inviteCode, invitedEmails: $invitedEmails, invitedPhones: $invitedPhones, visibility: $visibility, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.sharedContactsCount, sharedContactsCount) ||
                other.sharedContactsCount == sharedContactsCount) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            const DeepCollectionEquality()
                .equals(other._invitedEmails, _invitedEmails) &&
            const DeepCollectionEquality()
                .equals(other._invitedPhones, _invitedPhones) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      photoUrl,
      ownerId,
      const DeepCollectionEquality().hash(_members),
      totalExpenses,
      sharedContactsCount,
      inviteCode,
      const DeepCollectionEquality().hash(_invitedEmails),
      const DeepCollectionEquality().hash(_invitedPhones),
      visibility,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamImplCopyWith<_$TeamImpl> get copyWith =>
      __$$TeamImplCopyWithImpl<_$TeamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamImplToJson(
      this,
    );
  }
}

abstract class _Team extends Team {
  const factory _Team(
      {required final String id,
      required final String name,
      final String? description,
      final String? category,
      final String? photoUrl,
      required final String ownerId,
      final List<TeamMember> members,
      final double? totalExpenses,
      final int sharedContactsCount,
      final String? inviteCode,
      final List<String> invitedEmails,
      final List<String> invitedPhones,
      final String? visibility,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TeamImpl;
  const _Team._() : super._();

  factory _Team.fromJson(Map<String, dynamic> json) = _$TeamImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get category;
  @override
  String? get photoUrl;
  @override
  String get ownerId;
  @override
  List<TeamMember> get members;
  @override
  double? get totalExpenses;
  @override
  int get sharedContactsCount;
  @override
  String? get inviteCode;
  @override
  List<String> get invitedEmails;
  @override // Added for easy querying of invites
  List<String> get invitedPhones;
  @override // Added for mobile number invites
  String? get visibility;
  @override // 'public', 'private' (default)
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TeamImplCopyWith<_$TeamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) {
  return _TeamMember.fromJson(json);
}

/// @nodoc
mixin _$TeamMember {
  String get userId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phoneNumber =>
      throw _privateConstructorUsedError; // Added for mobile number support
  String get role =>
      throw _privateConstructorUsedError; // 'owner', 'admin', 'co-admin', 'member', 'viewer'
  String? get jobTitle => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamMemberCopyWith<TeamMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMemberCopyWith<$Res> {
  factory $TeamMemberCopyWith(
          TeamMember value, $Res Function(TeamMember) then) =
      _$TeamMemberCopyWithImpl<$Res, TeamMember>;
  @useResult
  $Res call(
      {String userId,
      String? email,
      String? phoneNumber,
      String role,
      String? jobTitle,
      DateTime joinedAt,
      String? status});
}

/// @nodoc
class _$TeamMemberCopyWithImpl<$Res, $Val extends TeamMember>
    implements $TeamMemberCopyWith<$Res> {
  _$TeamMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? role = null,
    Object? jobTitle = freezed,
    Object? joinedAt = null,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamMemberImplCopyWith<$Res>
    implements $TeamMemberCopyWith<$Res> {
  factory _$$TeamMemberImplCopyWith(
          _$TeamMemberImpl value, $Res Function(_$TeamMemberImpl) then) =
      __$$TeamMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String? email,
      String? phoneNumber,
      String role,
      String? jobTitle,
      DateTime joinedAt,
      String? status});
}

/// @nodoc
class __$$TeamMemberImplCopyWithImpl<$Res>
    extends _$TeamMemberCopyWithImpl<$Res, _$TeamMemberImpl>
    implements _$$TeamMemberImplCopyWith<$Res> {
  __$$TeamMemberImplCopyWithImpl(
      _$TeamMemberImpl _value, $Res Function(_$TeamMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? role = null,
    Object? jobTitle = freezed,
    Object? joinedAt = null,
    Object? status = freezed,
  }) {
    return _then(_$TeamMemberImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMemberImpl implements _TeamMember {
  const _$TeamMemberImpl(
      {required this.userId,
      this.email,
      this.phoneNumber,
      required this.role,
      this.jobTitle,
      required this.joinedAt,
      this.status});

  factory _$TeamMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamMemberImplFromJson(json);

  @override
  final String userId;
  @override
  final String? email;
  @override
  final String? phoneNumber;
// Added for mobile number support
  @override
  final String role;
// 'owner', 'admin', 'co-admin', 'member', 'viewer'
  @override
  final String? jobTitle;
  @override
  final DateTime joinedAt;
  @override
  final String? status;

  @override
  String toString() {
    return 'TeamMember(userId: $userId, email: $email, phoneNumber: $phoneNumber, role: $role, jobTitle: $jobTitle, joinedAt: $joinedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMemberImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, email, phoneNumber, role,
      jobTitle, joinedAt, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMemberImplCopyWith<_$TeamMemberImpl> get copyWith =>
      __$$TeamMemberImplCopyWithImpl<_$TeamMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMemberImplToJson(
      this,
    );
  }
}

abstract class _TeamMember implements TeamMember {
  const factory _TeamMember(
      {required final String userId,
      final String? email,
      final String? phoneNumber,
      required final String role,
      final String? jobTitle,
      required final DateTime joinedAt,
      final String? status}) = _$TeamMemberImpl;

  factory _TeamMember.fromJson(Map<String, dynamic> json) =
      _$TeamMemberImpl.fromJson;

  @override
  String get userId;
  @override
  String? get email;
  @override
  String? get phoneNumber;
  @override // Added for mobile number support
  String get role;
  @override // 'owner', 'admin', 'co-admin', 'member', 'viewer'
  String? get jobTitle;
  @override
  DateTime get joinedAt;
  @override
  String? get status;
  @override
  @JsonKey(ignore: true)
  _$$TeamMemberImplCopyWith<_$TeamMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
