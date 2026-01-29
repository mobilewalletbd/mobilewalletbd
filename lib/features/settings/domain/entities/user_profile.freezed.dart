// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  /// Unique identifier matching AuthUser.id (Firebase UID)
  String get uid => throw _privateConstructorUsedError;

  /// User's full name
  String get fullName => throw _privateConstructorUsedError;

  /// User's job title or position
  String? get jobTitle => throw _privateConstructorUsedError;

  /// User's company or organization name
  String? get companyName => throw _privateConstructorUsedError;

  /// User's bio or description
  String? get bio => throw _privateConstructorUsedError;

  /// URL to user's avatar image (Cloudinary URL)
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// User preferences (theme, language, notifications)
  Map<String, dynamic> get preferences => throw _privateConstructorUsedError;

  /// Reference to user's personal CardDesign ID
  String? get personalCardId => throw _privateConstructorUsedError;

  /// Account status: ACTIVE, SUSPENDED, PENDING_VERIFICATION
  AccountStatus get accountStatus => throw _privateConstructorUsedError;

  /// KYC verification tier: BASIC, PRO, ENTERPRISE
  KycTier? get kycTier => throw _privateConstructorUsedError;

  /// User's timezone (e.g., 'Asia/Dhaka')
  String? get timeZone => throw _privateConstructorUsedError;

  /// User's preferred language (en, bn)
  String get defaultLanguage => throw _privateConstructorUsedError;

  /// Timestamp of user's last activity
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;

  /// Current device identifier
  String? get deviceId => throw _privateConstructorUsedError;

  /// Timestamp when profile was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when profile was last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String uid,
      String fullName,
      String? jobTitle,
      String? companyName,
      String? bio,
      String? avatarUrl,
      Map<String, dynamic> preferences,
      String? personalCardId,
      AccountStatus accountStatus,
      KycTier? kycTier,
      String? timeZone,
      String defaultLanguage,
      DateTime? lastActiveAt,
      String? deviceId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? fullName = null,
    Object? jobTitle = freezed,
    Object? companyName = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? preferences = null,
    Object? personalCardId = freezed,
    Object? accountStatus = null,
    Object? kycTier = freezed,
    Object? timeZone = freezed,
    Object? defaultLanguage = null,
    Object? lastActiveAt = freezed,
    Object? deviceId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      personalCardId: freezed == personalCardId
          ? _value.personalCardId
          : personalCardId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountStatus: null == accountStatus
          ? _value.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as AccountStatus,
      kycTier: freezed == kycTier
          ? _value.kycTier
          : kycTier // ignore: cast_nullable_to_non_nullable
              as KycTier?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String fullName,
      String? jobTitle,
      String? companyName,
      String? bio,
      String? avatarUrl,
      Map<String, dynamic> preferences,
      String? personalCardId,
      AccountStatus accountStatus,
      KycTier? kycTier,
      String? timeZone,
      String defaultLanguage,
      DateTime? lastActiveAt,
      String? deviceId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? fullName = null,
    Object? jobTitle = freezed,
    Object? companyName = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? preferences = null,
    Object? personalCardId = freezed,
    Object? accountStatus = null,
    Object? kycTier = freezed,
    Object? timeZone = freezed,
    Object? defaultLanguage = null,
    Object? lastActiveAt = freezed,
    Object? deviceId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserProfileImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      personalCardId: freezed == personalCardId
          ? _value.personalCardId
          : personalCardId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountStatus: null == accountStatus
          ? _value.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as AccountStatus,
      kycTier: freezed == kycTier
          ? _value.kycTier
          : kycTier // ignore: cast_nullable_to_non_nullable
              as KycTier?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
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
class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {required this.uid,
      required this.fullName,
      this.jobTitle,
      this.companyName,
      this.bio,
      this.avatarUrl,
      final Map<String, dynamic> preferences = const {},
      this.personalCardId,
      this.accountStatus = AccountStatus.active,
      this.kycTier,
      this.timeZone,
      this.defaultLanguage = 'en',
      this.lastActiveAt,
      this.deviceId,
      required this.createdAt,
      required this.updatedAt})
      : _preferences = preferences,
        super._();

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  /// Unique identifier matching AuthUser.id (Firebase UID)
  @override
  final String uid;

  /// User's full name
  @override
  final String fullName;

  /// User's job title or position
  @override
  final String? jobTitle;

  /// User's company or organization name
  @override
  final String? companyName;

  /// User's bio or description
  @override
  final String? bio;

  /// URL to user's avatar image (Cloudinary URL)
  @override
  final String? avatarUrl;

  /// User preferences (theme, language, notifications)
  final Map<String, dynamic> _preferences;

  /// User preferences (theme, language, notifications)
  @override
  @JsonKey()
  Map<String, dynamic> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  /// Reference to user's personal CardDesign ID
  @override
  final String? personalCardId;

  /// Account status: ACTIVE, SUSPENDED, PENDING_VERIFICATION
  @override
  @JsonKey()
  final AccountStatus accountStatus;

  /// KYC verification tier: BASIC, PRO, ENTERPRISE
  @override
  final KycTier? kycTier;

  /// User's timezone (e.g., 'Asia/Dhaka')
  @override
  final String? timeZone;

  /// User's preferred language (en, bn)
  @override
  @JsonKey()
  final String defaultLanguage;

  /// Timestamp of user's last activity
  @override
  final DateTime? lastActiveAt;

  /// Current device identifier
  @override
  final String? deviceId;

  /// Timestamp when profile was created
  @override
  final DateTime createdAt;

  /// Timestamp when profile was last updated
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserProfile(uid: $uid, fullName: $fullName, jobTitle: $jobTitle, companyName: $companyName, bio: $bio, avatarUrl: $avatarUrl, preferences: $preferences, personalCardId: $personalCardId, accountStatus: $accountStatus, kycTier: $kycTier, timeZone: $timeZone, defaultLanguage: $defaultLanguage, lastActiveAt: $lastActiveAt, deviceId: $deviceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            (identical(other.personalCardId, personalCardId) ||
                other.personalCardId == personalCardId) &&
            (identical(other.accountStatus, accountStatus) ||
                other.accountStatus == accountStatus) &&
            (identical(other.kycTier, kycTier) || other.kycTier == kycTier) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone) &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      fullName,
      jobTitle,
      companyName,
      bio,
      avatarUrl,
      const DeepCollectionEquality().hash(_preferences),
      personalCardId,
      accountStatus,
      kycTier,
      timeZone,
      defaultLanguage,
      lastActiveAt,
      deviceId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String uid,
      required final String fullName,
      final String? jobTitle,
      final String? companyName,
      final String? bio,
      final String? avatarUrl,
      final Map<String, dynamic> preferences,
      final String? personalCardId,
      final AccountStatus accountStatus,
      final KycTier? kycTier,
      final String? timeZone,
      final String defaultLanguage,
      final DateTime? lastActiveAt,
      final String? deviceId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override

  /// Unique identifier matching AuthUser.id (Firebase UID)
  String get uid;
  @override

  /// User's full name
  String get fullName;
  @override

  /// User's job title or position
  String? get jobTitle;
  @override

  /// User's company or organization name
  String? get companyName;
  @override

  /// User's bio or description
  String? get bio;
  @override

  /// URL to user's avatar image (Cloudinary URL)
  String? get avatarUrl;
  @override

  /// User preferences (theme, language, notifications)
  Map<String, dynamic> get preferences;
  @override

  /// Reference to user's personal CardDesign ID
  String? get personalCardId;
  @override

  /// Account status: ACTIVE, SUSPENDED, PENDING_VERIFICATION
  AccountStatus get accountStatus;
  @override

  /// KYC verification tier: BASIC, PRO, ENTERPRISE
  KycTier? get kycTier;
  @override

  /// User's timezone (e.g., 'Asia/Dhaka')
  String? get timeZone;
  @override

  /// User's preferred language (en, bn)
  String get defaultLanguage;
  @override

  /// Timestamp of user's last activity
  DateTime? get lastActiveAt;
  @override

  /// Current device identifier
  String? get deviceId;
  @override

  /// Timestamp when profile was created
  DateTime get createdAt;
  @override

  /// Timestamp when profile was last updated
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
