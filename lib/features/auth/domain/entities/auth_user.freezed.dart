// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return _AuthUser.fromJson(json);
}

/// @nodoc
mixin _$AuthUser {
  /// Unique User ID from Firebase
  String get id => throw _privateConstructorUsedError;

  /// User's email address
  String? get email => throw _privateConstructorUsedError;

  /// User's phone number (with country code)
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// User's display name
  String? get displayName => throw _privateConstructorUsedError;

  /// URL to user's profile photo (Cloudinary or Firebase)
  String? get photoUrl => throw _privateConstructorUsedError;

  /// Whether the user's email has been verified
  bool get emailVerified => throw _privateConstructorUsedError;

  /// Timestamp of user's last sign-in
  DateTime? get lastSignIn => throw _privateConstructorUsedError;

  /// Authentication provider (google, phone, email, apple)
  String? get provider => throw _privateConstructorUsedError;

  /// Whether this is an anonymous user
  bool get isAnonymous => throw _privateConstructorUsedError;

  /// Custom claims from Firebase token (roles, permissions)
  List<String>? get customClaims => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res, AuthUser>;
  @useResult
  $Res call(
      {String id,
      String? email,
      String? phoneNumber,
      String? displayName,
      String? photoUrl,
      bool emailVerified,
      DateTime? lastSignIn,
      String? provider,
      bool isAnonymous,
      List<String>? customClaims});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res, $Val extends AuthUser>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? emailVerified = null,
    Object? lastSignIn = freezed,
    Object? provider = freezed,
    Object? isAnonymous = null,
    Object? customClaims = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSignIn: freezed == lastSignIn
          ? _value.lastSignIn
          : lastSignIn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      customClaims: freezed == customClaims
          ? _value.customClaims
          : customClaims // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthUserImplCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$$AuthUserImplCopyWith(
          _$AuthUserImpl value, $Res Function(_$AuthUserImpl) then) =
      __$$AuthUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? email,
      String? phoneNumber,
      String? displayName,
      String? photoUrl,
      bool emailVerified,
      DateTime? lastSignIn,
      String? provider,
      bool isAnonymous,
      List<String>? customClaims});
}

/// @nodoc
class __$$AuthUserImplCopyWithImpl<$Res>
    extends _$AuthUserCopyWithImpl<$Res, _$AuthUserImpl>
    implements _$$AuthUserImplCopyWith<$Res> {
  __$$AuthUserImplCopyWithImpl(
      _$AuthUserImpl _value, $Res Function(_$AuthUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? emailVerified = null,
    Object? lastSignIn = freezed,
    Object? provider = freezed,
    Object? isAnonymous = null,
    Object? customClaims = freezed,
  }) {
    return _then(_$AuthUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSignIn: freezed == lastSignIn
          ? _value.lastSignIn
          : lastSignIn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      customClaims: freezed == customClaims
          ? _value._customClaims
          : customClaims // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserImpl extends _AuthUser {
  const _$AuthUserImpl(
      {required this.id,
      this.email,
      this.phoneNumber,
      this.displayName,
      this.photoUrl,
      this.emailVerified = false,
      this.lastSignIn,
      this.provider,
      this.isAnonymous = false,
      final List<String>? customClaims})
      : _customClaims = customClaims,
        super._();

  factory _$AuthUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserImplFromJson(json);

  /// Unique User ID from Firebase
  @override
  final String id;

  /// User's email address
  @override
  final String? email;

  /// User's phone number (with country code)
  @override
  final String? phoneNumber;

  /// User's display name
  @override
  final String? displayName;

  /// URL to user's profile photo (Cloudinary or Firebase)
  @override
  final String? photoUrl;

  /// Whether the user's email has been verified
  @override
  @JsonKey()
  final bool emailVerified;

  /// Timestamp of user's last sign-in
  @override
  final DateTime? lastSignIn;

  /// Authentication provider (google, phone, email, apple)
  @override
  final String? provider;

  /// Whether this is an anonymous user
  @override
  @JsonKey()
  final bool isAnonymous;

  /// Custom claims from Firebase token (roles, permissions)
  final List<String>? _customClaims;

  /// Custom claims from Firebase token (roles, permissions)
  @override
  List<String>? get customClaims {
    final value = _customClaims;
    if (value == null) return null;
    if (_customClaims is EqualUnmodifiableListView) return _customClaims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, phoneNumber: $phoneNumber, displayName: $displayName, photoUrl: $photoUrl, emailVerified: $emailVerified, lastSignIn: $lastSignIn, provider: $provider, isAnonymous: $isAnonymous, customClaims: $customClaims)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.lastSignIn, lastSignIn) ||
                other.lastSignIn == lastSignIn) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            const DeepCollectionEquality()
                .equals(other._customClaims, _customClaims));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      phoneNumber,
      displayName,
      photoUrl,
      emailVerified,
      lastSignIn,
      provider,
      isAnonymous,
      const DeepCollectionEquality().hash(_customClaims));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      __$$AuthUserImplCopyWithImpl<_$AuthUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserImplToJson(
      this,
    );
  }
}

abstract class _AuthUser extends AuthUser {
  const factory _AuthUser(
      {required final String id,
      final String? email,
      final String? phoneNumber,
      final String? displayName,
      final String? photoUrl,
      final bool emailVerified,
      final DateTime? lastSignIn,
      final String? provider,
      final bool isAnonymous,
      final List<String>? customClaims}) = _$AuthUserImpl;
  const _AuthUser._() : super._();

  factory _AuthUser.fromJson(Map<String, dynamic> json) =
      _$AuthUserImpl.fromJson;

  @override

  /// Unique User ID from Firebase
  String get id;
  @override

  /// User's email address
  String? get email;
  @override

  /// User's phone number (with country code)
  String? get phoneNumber;
  @override

  /// User's display name
  String? get displayName;
  @override

  /// URL to user's profile photo (Cloudinary or Firebase)
  String? get photoUrl;
  @override

  /// Whether the user's email has been verified
  bool get emailVerified;
  @override

  /// Timestamp of user's last sign-in
  DateTime? get lastSignIn;
  @override

  /// Authentication provider (google, phone, email, apple)
  String? get provider;
  @override

  /// Whether this is an anonymous user
  bool get isAnonymous;
  @override

  /// Custom claims from Firebase token (roles, permissions)
  List<String>? get customClaims;
  @override
  @JsonKey(ignore: true)
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
