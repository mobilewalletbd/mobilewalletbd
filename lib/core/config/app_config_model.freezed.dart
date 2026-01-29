// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) {
  return _AppConfigModel.fromJson(json);
}

/// @nodoc
mixin _$AppConfigModel {
  AppMetadata get appMetadata => throw _privateConstructorUsedError;
  DesignSystem get designSystem => throw _privateConstructorUsedError;
  AssetsConfig get assetsConfig => throw _privateConstructorUsedError;
  FeatureFlags get featureFlags => throw _privateConstructorUsedError;
  SecurityLimits get securityLimits => throw _privateConstructorUsedError;
  BackupConfig get backupConfig => throw _privateConstructorUsedError;
  SupabaseConfig? get supabaseConfig => throw _privateConstructorUsedError;
  GoogleAuthConfig? get googleAuthConfig => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppConfigModelCopyWith<AppConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigModelCopyWith<$Res> {
  factory $AppConfigModelCopyWith(
          AppConfigModel value, $Res Function(AppConfigModel) then) =
      _$AppConfigModelCopyWithImpl<$Res, AppConfigModel>;
  @useResult
  $Res call(
      {AppMetadata appMetadata,
      DesignSystem designSystem,
      AssetsConfig assetsConfig,
      FeatureFlags featureFlags,
      SecurityLimits securityLimits,
      BackupConfig backupConfig,
      SupabaseConfig? supabaseConfig,
      GoogleAuthConfig? googleAuthConfig});

  $AppMetadataCopyWith<$Res> get appMetadata;
  $DesignSystemCopyWith<$Res> get designSystem;
  $AssetsConfigCopyWith<$Res> get assetsConfig;
  $FeatureFlagsCopyWith<$Res> get featureFlags;
  $SecurityLimitsCopyWith<$Res> get securityLimits;
  $BackupConfigCopyWith<$Res> get backupConfig;
  $SupabaseConfigCopyWith<$Res>? get supabaseConfig;
  $GoogleAuthConfigCopyWith<$Res>? get googleAuthConfig;
}

/// @nodoc
class _$AppConfigModelCopyWithImpl<$Res, $Val extends AppConfigModel>
    implements $AppConfigModelCopyWith<$Res> {
  _$AppConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appMetadata = null,
    Object? designSystem = null,
    Object? assetsConfig = null,
    Object? featureFlags = null,
    Object? securityLimits = null,
    Object? backupConfig = null,
    Object? supabaseConfig = freezed,
    Object? googleAuthConfig = freezed,
  }) {
    return _then(_value.copyWith(
      appMetadata: null == appMetadata
          ? _value.appMetadata
          : appMetadata // ignore: cast_nullable_to_non_nullable
              as AppMetadata,
      designSystem: null == designSystem
          ? _value.designSystem
          : designSystem // ignore: cast_nullable_to_non_nullable
              as DesignSystem,
      assetsConfig: null == assetsConfig
          ? _value.assetsConfig
          : assetsConfig // ignore: cast_nullable_to_non_nullable
              as AssetsConfig,
      featureFlags: null == featureFlags
          ? _value.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as FeatureFlags,
      securityLimits: null == securityLimits
          ? _value.securityLimits
          : securityLimits // ignore: cast_nullable_to_non_nullable
              as SecurityLimits,
      backupConfig: null == backupConfig
          ? _value.backupConfig
          : backupConfig // ignore: cast_nullable_to_non_nullable
              as BackupConfig,
      supabaseConfig: freezed == supabaseConfig
          ? _value.supabaseConfig
          : supabaseConfig // ignore: cast_nullable_to_non_nullable
              as SupabaseConfig?,
      googleAuthConfig: freezed == googleAuthConfig
          ? _value.googleAuthConfig
          : googleAuthConfig // ignore: cast_nullable_to_non_nullable
              as GoogleAuthConfig?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppMetadataCopyWith<$Res> get appMetadata {
    return $AppMetadataCopyWith<$Res>(_value.appMetadata, (value) {
      return _then(_value.copyWith(appMetadata: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DesignSystemCopyWith<$Res> get designSystem {
    return $DesignSystemCopyWith<$Res>(_value.designSystem, (value) {
      return _then(_value.copyWith(designSystem: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssetsConfigCopyWith<$Res> get assetsConfig {
    return $AssetsConfigCopyWith<$Res>(_value.assetsConfig, (value) {
      return _then(_value.copyWith(assetsConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FeatureFlagsCopyWith<$Res> get featureFlags {
    return $FeatureFlagsCopyWith<$Res>(_value.featureFlags, (value) {
      return _then(_value.copyWith(featureFlags: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SecurityLimitsCopyWith<$Res> get securityLimits {
    return $SecurityLimitsCopyWith<$Res>(_value.securityLimits, (value) {
      return _then(_value.copyWith(securityLimits: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BackupConfigCopyWith<$Res> get backupConfig {
    return $BackupConfigCopyWith<$Res>(_value.backupConfig, (value) {
      return _then(_value.copyWith(backupConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SupabaseConfigCopyWith<$Res>? get supabaseConfig {
    if (_value.supabaseConfig == null) {
      return null;
    }

    return $SupabaseConfigCopyWith<$Res>(_value.supabaseConfig!, (value) {
      return _then(_value.copyWith(supabaseConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GoogleAuthConfigCopyWith<$Res>? get googleAuthConfig {
    if (_value.googleAuthConfig == null) {
      return null;
    }

    return $GoogleAuthConfigCopyWith<$Res>(_value.googleAuthConfig!, (value) {
      return _then(_value.copyWith(googleAuthConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppConfigModelImplCopyWith<$Res>
    implements $AppConfigModelCopyWith<$Res> {
  factory _$$AppConfigModelImplCopyWith(_$AppConfigModelImpl value,
          $Res Function(_$AppConfigModelImpl) then) =
      __$$AppConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppMetadata appMetadata,
      DesignSystem designSystem,
      AssetsConfig assetsConfig,
      FeatureFlags featureFlags,
      SecurityLimits securityLimits,
      BackupConfig backupConfig,
      SupabaseConfig? supabaseConfig,
      GoogleAuthConfig? googleAuthConfig});

  @override
  $AppMetadataCopyWith<$Res> get appMetadata;
  @override
  $DesignSystemCopyWith<$Res> get designSystem;
  @override
  $AssetsConfigCopyWith<$Res> get assetsConfig;
  @override
  $FeatureFlagsCopyWith<$Res> get featureFlags;
  @override
  $SecurityLimitsCopyWith<$Res> get securityLimits;
  @override
  $BackupConfigCopyWith<$Res> get backupConfig;
  @override
  $SupabaseConfigCopyWith<$Res>? get supabaseConfig;
  @override
  $GoogleAuthConfigCopyWith<$Res>? get googleAuthConfig;
}

/// @nodoc
class __$$AppConfigModelImplCopyWithImpl<$Res>
    extends _$AppConfigModelCopyWithImpl<$Res, _$AppConfigModelImpl>
    implements _$$AppConfigModelImplCopyWith<$Res> {
  __$$AppConfigModelImplCopyWithImpl(
      _$AppConfigModelImpl _value, $Res Function(_$AppConfigModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appMetadata = null,
    Object? designSystem = null,
    Object? assetsConfig = null,
    Object? featureFlags = null,
    Object? securityLimits = null,
    Object? backupConfig = null,
    Object? supabaseConfig = freezed,
    Object? googleAuthConfig = freezed,
  }) {
    return _then(_$AppConfigModelImpl(
      appMetadata: null == appMetadata
          ? _value.appMetadata
          : appMetadata // ignore: cast_nullable_to_non_nullable
              as AppMetadata,
      designSystem: null == designSystem
          ? _value.designSystem
          : designSystem // ignore: cast_nullable_to_non_nullable
              as DesignSystem,
      assetsConfig: null == assetsConfig
          ? _value.assetsConfig
          : assetsConfig // ignore: cast_nullable_to_non_nullable
              as AssetsConfig,
      featureFlags: null == featureFlags
          ? _value.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as FeatureFlags,
      securityLimits: null == securityLimits
          ? _value.securityLimits
          : securityLimits // ignore: cast_nullable_to_non_nullable
              as SecurityLimits,
      backupConfig: null == backupConfig
          ? _value.backupConfig
          : backupConfig // ignore: cast_nullable_to_non_nullable
              as BackupConfig,
      supabaseConfig: freezed == supabaseConfig
          ? _value.supabaseConfig
          : supabaseConfig // ignore: cast_nullable_to_non_nullable
              as SupabaseConfig?,
      googleAuthConfig: freezed == googleAuthConfig
          ? _value.googleAuthConfig
          : googleAuthConfig // ignore: cast_nullable_to_non_nullable
              as GoogleAuthConfig?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppConfigModelImpl extends _AppConfigModel {
  const _$AppConfigModelImpl(
      {required this.appMetadata,
      required this.designSystem,
      required this.assetsConfig,
      required this.featureFlags,
      required this.securityLimits,
      required this.backupConfig,
      this.supabaseConfig,
      this.googleAuthConfig})
      : super._();

  factory _$AppConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppConfigModelImplFromJson(json);

  @override
  final AppMetadata appMetadata;
  @override
  final DesignSystem designSystem;
  @override
  final AssetsConfig assetsConfig;
  @override
  final FeatureFlags featureFlags;
  @override
  final SecurityLimits securityLimits;
  @override
  final BackupConfig backupConfig;
  @override
  final SupabaseConfig? supabaseConfig;
  @override
  final GoogleAuthConfig? googleAuthConfig;

  @override
  String toString() {
    return 'AppConfigModel(appMetadata: $appMetadata, designSystem: $designSystem, assetsConfig: $assetsConfig, featureFlags: $featureFlags, securityLimits: $securityLimits, backupConfig: $backupConfig, supabaseConfig: $supabaseConfig, googleAuthConfig: $googleAuthConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigModelImpl &&
            (identical(other.appMetadata, appMetadata) ||
                other.appMetadata == appMetadata) &&
            (identical(other.designSystem, designSystem) ||
                other.designSystem == designSystem) &&
            (identical(other.assetsConfig, assetsConfig) ||
                other.assetsConfig == assetsConfig) &&
            (identical(other.featureFlags, featureFlags) ||
                other.featureFlags == featureFlags) &&
            (identical(other.securityLimits, securityLimits) ||
                other.securityLimits == securityLimits) &&
            (identical(other.backupConfig, backupConfig) ||
                other.backupConfig == backupConfig) &&
            (identical(other.supabaseConfig, supabaseConfig) ||
                other.supabaseConfig == supabaseConfig) &&
            (identical(other.googleAuthConfig, googleAuthConfig) ||
                other.googleAuthConfig == googleAuthConfig));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appMetadata,
      designSystem,
      assetsConfig,
      featureFlags,
      securityLimits,
      backupConfig,
      supabaseConfig,
      googleAuthConfig);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigModelImplCopyWith<_$AppConfigModelImpl> get copyWith =>
      __$$AppConfigModelImplCopyWithImpl<_$AppConfigModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppConfigModelImplToJson(
      this,
    );
  }
}

abstract class _AppConfigModel extends AppConfigModel {
  const factory _AppConfigModel(
      {required final AppMetadata appMetadata,
      required final DesignSystem designSystem,
      required final AssetsConfig assetsConfig,
      required final FeatureFlags featureFlags,
      required final SecurityLimits securityLimits,
      required final BackupConfig backupConfig,
      final SupabaseConfig? supabaseConfig,
      final GoogleAuthConfig? googleAuthConfig}) = _$AppConfigModelImpl;
  const _AppConfigModel._() : super._();

  factory _AppConfigModel.fromJson(Map<String, dynamic> json) =
      _$AppConfigModelImpl.fromJson;

  @override
  AppMetadata get appMetadata;
  @override
  DesignSystem get designSystem;
  @override
  AssetsConfig get assetsConfig;
  @override
  FeatureFlags get featureFlags;
  @override
  SecurityLimits get securityLimits;
  @override
  BackupConfig get backupConfig;
  @override
  SupabaseConfig? get supabaseConfig;
  @override
  GoogleAuthConfig? get googleAuthConfig;
  @override
  @JsonKey(ignore: true)
  _$$AppConfigModelImplCopyWith<_$AppConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppMetadata _$AppMetadataFromJson(Map<String, dynamic> json) {
  return _AppMetadata.fromJson(json);
}

/// @nodoc
mixin _$AppMetadata {
  @JsonKey(name: 'APP_NAME')
  String get appName => throw _privateConstructorUsedError;
  @JsonKey(name: 'BUNDLE_ID')
  String get bundleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'PACKAGE_NAME')
  String get packageName => throw _privateConstructorUsedError;
  @JsonKey(name: 'VERSION')
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'BUILD_NUMBER')
  String get buildNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'DEFAULT_LOCALE')
  String get defaultLocale => throw _privateConstructorUsedError;
  @JsonKey(name: 'SUPPORTED_LOCALES')
  List<String> get supportedLocales => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppMetadataCopyWith<AppMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppMetadataCopyWith<$Res> {
  factory $AppMetadataCopyWith(
          AppMetadata value, $Res Function(AppMetadata) then) =
      _$AppMetadataCopyWithImpl<$Res, AppMetadata>;
  @useResult
  $Res call(
      {@JsonKey(name: 'APP_NAME') String appName,
      @JsonKey(name: 'BUNDLE_ID') String bundleId,
      @JsonKey(name: 'PACKAGE_NAME') String packageName,
      @JsonKey(name: 'VERSION') String version,
      @JsonKey(name: 'BUILD_NUMBER') String buildNumber,
      @JsonKey(name: 'DEFAULT_LOCALE') String defaultLocale,
      @JsonKey(name: 'SUPPORTED_LOCALES') List<String> supportedLocales});
}

/// @nodoc
class _$AppMetadataCopyWithImpl<$Res, $Val extends AppMetadata>
    implements $AppMetadataCopyWith<$Res> {
  _$AppMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? bundleId = null,
    Object? packageName = null,
    Object? version = null,
    Object? buildNumber = null,
    Object? defaultLocale = null,
    Object? supportedLocales = null,
  }) {
    return _then(_value.copyWith(
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      bundleId: null == bundleId
          ? _value.bundleId
          : bundleId // ignore: cast_nullable_to_non_nullable
              as String,
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
      defaultLocale: null == defaultLocale
          ? _value.defaultLocale
          : defaultLocale // ignore: cast_nullable_to_non_nullable
              as String,
      supportedLocales: null == supportedLocales
          ? _value.supportedLocales
          : supportedLocales // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppMetadataImplCopyWith<$Res>
    implements $AppMetadataCopyWith<$Res> {
  factory _$$AppMetadataImplCopyWith(
          _$AppMetadataImpl value, $Res Function(_$AppMetadataImpl) then) =
      __$$AppMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'APP_NAME') String appName,
      @JsonKey(name: 'BUNDLE_ID') String bundleId,
      @JsonKey(name: 'PACKAGE_NAME') String packageName,
      @JsonKey(name: 'VERSION') String version,
      @JsonKey(name: 'BUILD_NUMBER') String buildNumber,
      @JsonKey(name: 'DEFAULT_LOCALE') String defaultLocale,
      @JsonKey(name: 'SUPPORTED_LOCALES') List<String> supportedLocales});
}

/// @nodoc
class __$$AppMetadataImplCopyWithImpl<$Res>
    extends _$AppMetadataCopyWithImpl<$Res, _$AppMetadataImpl>
    implements _$$AppMetadataImplCopyWith<$Res> {
  __$$AppMetadataImplCopyWithImpl(
      _$AppMetadataImpl _value, $Res Function(_$AppMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? bundleId = null,
    Object? packageName = null,
    Object? version = null,
    Object? buildNumber = null,
    Object? defaultLocale = null,
    Object? supportedLocales = null,
  }) {
    return _then(_$AppMetadataImpl(
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      bundleId: null == bundleId
          ? _value.bundleId
          : bundleId // ignore: cast_nullable_to_non_nullable
              as String,
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
      defaultLocale: null == defaultLocale
          ? _value.defaultLocale
          : defaultLocale // ignore: cast_nullable_to_non_nullable
              as String,
      supportedLocales: null == supportedLocales
          ? _value._supportedLocales
          : supportedLocales // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppMetadataImpl extends _AppMetadata {
  const _$AppMetadataImpl(
      {@JsonKey(name: 'APP_NAME') required this.appName,
      @JsonKey(name: 'BUNDLE_ID') required this.bundleId,
      @JsonKey(name: 'PACKAGE_NAME') required this.packageName,
      @JsonKey(name: 'VERSION') required this.version,
      @JsonKey(name: 'BUILD_NUMBER') required this.buildNumber,
      @JsonKey(name: 'DEFAULT_LOCALE') required this.defaultLocale,
      @JsonKey(name: 'SUPPORTED_LOCALES')
      required final List<String> supportedLocales})
      : _supportedLocales = supportedLocales,
        super._();

  factory _$AppMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppMetadataImplFromJson(json);

  @override
  @JsonKey(name: 'APP_NAME')
  final String appName;
  @override
  @JsonKey(name: 'BUNDLE_ID')
  final String bundleId;
  @override
  @JsonKey(name: 'PACKAGE_NAME')
  final String packageName;
  @override
  @JsonKey(name: 'VERSION')
  final String version;
  @override
  @JsonKey(name: 'BUILD_NUMBER')
  final String buildNumber;
  @override
  @JsonKey(name: 'DEFAULT_LOCALE')
  final String defaultLocale;
  final List<String> _supportedLocales;
  @override
  @JsonKey(name: 'SUPPORTED_LOCALES')
  List<String> get supportedLocales {
    if (_supportedLocales is EqualUnmodifiableListView)
      return _supportedLocales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedLocales);
  }

  @override
  String toString() {
    return 'AppMetadata(appName: $appName, bundleId: $bundleId, packageName: $packageName, version: $version, buildNumber: $buildNumber, defaultLocale: $defaultLocale, supportedLocales: $supportedLocales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppMetadataImpl &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.bundleId, bundleId) ||
                other.bundleId == bundleId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.buildNumber, buildNumber) ||
                other.buildNumber == buildNumber) &&
            (identical(other.defaultLocale, defaultLocale) ||
                other.defaultLocale == defaultLocale) &&
            const DeepCollectionEquality()
                .equals(other._supportedLocales, _supportedLocales));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appName,
      bundleId,
      packageName,
      version,
      buildNumber,
      defaultLocale,
      const DeepCollectionEquality().hash(_supportedLocales));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppMetadataImplCopyWith<_$AppMetadataImpl> get copyWith =>
      __$$AppMetadataImplCopyWithImpl<_$AppMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppMetadataImplToJson(
      this,
    );
  }
}

abstract class _AppMetadata extends AppMetadata {
  const factory _AppMetadata(
      {@JsonKey(name: 'APP_NAME') required final String appName,
      @JsonKey(name: 'BUNDLE_ID') required final String bundleId,
      @JsonKey(name: 'PACKAGE_NAME') required final String packageName,
      @JsonKey(name: 'VERSION') required final String version,
      @JsonKey(name: 'BUILD_NUMBER') required final String buildNumber,
      @JsonKey(name: 'DEFAULT_LOCALE') required final String defaultLocale,
      @JsonKey(name: 'SUPPORTED_LOCALES')
      required final List<String> supportedLocales}) = _$AppMetadataImpl;
  const _AppMetadata._() : super._();

  factory _AppMetadata.fromJson(Map<String, dynamic> json) =
      _$AppMetadataImpl.fromJson;

  @override
  @JsonKey(name: 'APP_NAME')
  String get appName;
  @override
  @JsonKey(name: 'BUNDLE_ID')
  String get bundleId;
  @override
  @JsonKey(name: 'PACKAGE_NAME')
  String get packageName;
  @override
  @JsonKey(name: 'VERSION')
  String get version;
  @override
  @JsonKey(name: 'BUILD_NUMBER')
  String get buildNumber;
  @override
  @JsonKey(name: 'DEFAULT_LOCALE')
  String get defaultLocale;
  @override
  @JsonKey(name: 'SUPPORTED_LOCALES')
  List<String> get supportedLocales;
  @override
  @JsonKey(ignore: true)
  _$$AppMetadataImplCopyWith<_$AppMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignSystem _$DesignSystemFromJson(Map<String, dynamic> json) {
  return _DesignSystem.fromJson(json);
}

/// @nodoc
mixin _$DesignSystem {
  @JsonKey(name: 'FONT_FAMILY')
  String get fontFamily => throw _privateConstructorUsedError;
  @JsonKey(name: 'COLORS')
  DesignColors get colors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemCopyWith<DesignSystem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemCopyWith<$Res> {
  factory $DesignSystemCopyWith(
          DesignSystem value, $Res Function(DesignSystem) then) =
      _$DesignSystemCopyWithImpl<$Res, DesignSystem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'FONT_FAMILY') String fontFamily,
      @JsonKey(name: 'COLORS') DesignColors colors});

  $DesignColorsCopyWith<$Res> get colors;
}

/// @nodoc
class _$DesignSystemCopyWithImpl<$Res, $Val extends DesignSystem>
    implements $DesignSystemCopyWith<$Res> {
  _$DesignSystemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontFamily = null,
    Object? colors = null,
  }) {
    return _then(_value.copyWith(
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as DesignColors,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DesignColorsCopyWith<$Res> get colors {
    return $DesignColorsCopyWith<$Res>(_value.colors, (value) {
      return _then(_value.copyWith(colors: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DesignSystemImplCopyWith<$Res>
    implements $DesignSystemCopyWith<$Res> {
  factory _$$DesignSystemImplCopyWith(
          _$DesignSystemImpl value, $Res Function(_$DesignSystemImpl) then) =
      __$$DesignSystemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'FONT_FAMILY') String fontFamily,
      @JsonKey(name: 'COLORS') DesignColors colors});

  @override
  $DesignColorsCopyWith<$Res> get colors;
}

/// @nodoc
class __$$DesignSystemImplCopyWithImpl<$Res>
    extends _$DesignSystemCopyWithImpl<$Res, _$DesignSystemImpl>
    implements _$$DesignSystemImplCopyWith<$Res> {
  __$$DesignSystemImplCopyWithImpl(
      _$DesignSystemImpl _value, $Res Function(_$DesignSystemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontFamily = null,
    Object? colors = null,
  }) {
    return _then(_$DesignSystemImpl(
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as DesignColors,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesignSystemImpl extends _DesignSystem {
  const _$DesignSystemImpl(
      {@JsonKey(name: 'FONT_FAMILY') required this.fontFamily,
      @JsonKey(name: 'COLORS') required this.colors})
      : super._();

  factory _$DesignSystemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DesignSystemImplFromJson(json);

  @override
  @JsonKey(name: 'FONT_FAMILY')
  final String fontFamily;
  @override
  @JsonKey(name: 'COLORS')
  final DesignColors colors;

  @override
  String toString() {
    return 'DesignSystem(fontFamily: $fontFamily, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesignSystemImpl &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.colors, colors) || other.colors == colors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fontFamily, colors);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DesignSystemImplCopyWith<_$DesignSystemImpl> get copyWith =>
      __$$DesignSystemImplCopyWithImpl<_$DesignSystemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DesignSystemImplToJson(
      this,
    );
  }
}

abstract class _DesignSystem extends DesignSystem {
  const factory _DesignSystem(
          {@JsonKey(name: 'FONT_FAMILY') required final String fontFamily,
          @JsonKey(name: 'COLORS') required final DesignColors colors}) =
      _$DesignSystemImpl;
  const _DesignSystem._() : super._();

  factory _DesignSystem.fromJson(Map<String, dynamic> json) =
      _$DesignSystemImpl.fromJson;

  @override
  @JsonKey(name: 'FONT_FAMILY')
  String get fontFamily;
  @override
  @JsonKey(name: 'COLORS')
  DesignColors get colors;
  @override
  @JsonKey(ignore: true)
  _$$DesignSystemImplCopyWith<_$DesignSystemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignColors _$DesignColorsFromJson(Map<String, dynamic> json) {
  return _DesignColors.fromJson(json);
}

/// @nodoc
mixin _$DesignColors {
  @JsonKey(name: 'PRIMARY')
  String get primary => throw _privateConstructorUsedError;
  @JsonKey(name: 'SECONDARY')
  String get secondary => throw _privateConstructorUsedError;
  @JsonKey(name: 'ACCENT')
  String get accent => throw _privateConstructorUsedError;
  @JsonKey(name: 'BACKGROUND')
  String get background => throw _privateConstructorUsedError;
  @JsonKey(name: 'ERROR')
  String get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignColorsCopyWith<DesignColors> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignColorsCopyWith<$Res> {
  factory $DesignColorsCopyWith(
          DesignColors value, $Res Function(DesignColors) then) =
      _$DesignColorsCopyWithImpl<$Res, DesignColors>;
  @useResult
  $Res call(
      {@JsonKey(name: 'PRIMARY') String primary,
      @JsonKey(name: 'SECONDARY') String secondary,
      @JsonKey(name: 'ACCENT') String accent,
      @JsonKey(name: 'BACKGROUND') String background,
      @JsonKey(name: 'ERROR') String error});
}

/// @nodoc
class _$DesignColorsCopyWithImpl<$Res, $Val extends DesignColors>
    implements $DesignColorsCopyWith<$Res> {
  _$DesignColorsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? secondary = null,
    Object? accent = null,
    Object? background = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      secondary: null == secondary
          ? _value.secondary
          : secondary // ignore: cast_nullable_to_non_nullable
              as String,
      accent: null == accent
          ? _value.accent
          : accent // ignore: cast_nullable_to_non_nullable
              as String,
      background: null == background
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DesignColorsImplCopyWith<$Res>
    implements $DesignColorsCopyWith<$Res> {
  factory _$$DesignColorsImplCopyWith(
          _$DesignColorsImpl value, $Res Function(_$DesignColorsImpl) then) =
      __$$DesignColorsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'PRIMARY') String primary,
      @JsonKey(name: 'SECONDARY') String secondary,
      @JsonKey(name: 'ACCENT') String accent,
      @JsonKey(name: 'BACKGROUND') String background,
      @JsonKey(name: 'ERROR') String error});
}

/// @nodoc
class __$$DesignColorsImplCopyWithImpl<$Res>
    extends _$DesignColorsCopyWithImpl<$Res, _$DesignColorsImpl>
    implements _$$DesignColorsImplCopyWith<$Res> {
  __$$DesignColorsImplCopyWithImpl(
      _$DesignColorsImpl _value, $Res Function(_$DesignColorsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? secondary = null,
    Object? accent = null,
    Object? background = null,
    Object? error = null,
  }) {
    return _then(_$DesignColorsImpl(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      secondary: null == secondary
          ? _value.secondary
          : secondary // ignore: cast_nullable_to_non_nullable
              as String,
      accent: null == accent
          ? _value.accent
          : accent // ignore: cast_nullable_to_non_nullable
              as String,
      background: null == background
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesignColorsImpl extends _DesignColors {
  const _$DesignColorsImpl(
      {@JsonKey(name: 'PRIMARY') required this.primary,
      @JsonKey(name: 'SECONDARY') required this.secondary,
      @JsonKey(name: 'ACCENT') required this.accent,
      @JsonKey(name: 'BACKGROUND') required this.background,
      @JsonKey(name: 'ERROR') required this.error})
      : super._();

  factory _$DesignColorsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DesignColorsImplFromJson(json);

  @override
  @JsonKey(name: 'PRIMARY')
  final String primary;
  @override
  @JsonKey(name: 'SECONDARY')
  final String secondary;
  @override
  @JsonKey(name: 'ACCENT')
  final String accent;
  @override
  @JsonKey(name: 'BACKGROUND')
  final String background;
  @override
  @JsonKey(name: 'ERROR')
  final String error;

  @override
  String toString() {
    return 'DesignColors(primary: $primary, secondary: $secondary, accent: $accent, background: $background, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesignColorsImpl &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.secondary, secondary) ||
                other.secondary == secondary) &&
            (identical(other.accent, accent) || other.accent == accent) &&
            (identical(other.background, background) ||
                other.background == background) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, primary, secondary, accent, background, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DesignColorsImplCopyWith<_$DesignColorsImpl> get copyWith =>
      __$$DesignColorsImplCopyWithImpl<_$DesignColorsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DesignColorsImplToJson(
      this,
    );
  }
}

abstract class _DesignColors extends DesignColors {
  const factory _DesignColors(
          {@JsonKey(name: 'PRIMARY') required final String primary,
          @JsonKey(name: 'SECONDARY') required final String secondary,
          @JsonKey(name: 'ACCENT') required final String accent,
          @JsonKey(name: 'BACKGROUND') required final String background,
          @JsonKey(name: 'ERROR') required final String error}) =
      _$DesignColorsImpl;
  const _DesignColors._() : super._();

  factory _DesignColors.fromJson(Map<String, dynamic> json) =
      _$DesignColorsImpl.fromJson;

  @override
  @JsonKey(name: 'PRIMARY')
  String get primary;
  @override
  @JsonKey(name: 'SECONDARY')
  String get secondary;
  @override
  @JsonKey(name: 'ACCENT')
  String get accent;
  @override
  @JsonKey(name: 'BACKGROUND')
  String get background;
  @override
  @JsonKey(name: 'ERROR')
  String get error;
  @override
  @JsonKey(ignore: true)
  _$$DesignColorsImplCopyWith<_$DesignColorsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssetsConfig _$AssetsConfigFromJson(Map<String, dynamic> json) {
  return _AssetsConfig.fromJson(json);
}

/// @nodoc
mixin _$AssetsConfig {
  @JsonKey(name: 'APP_ICON_SOURCE_PATH')
  String get appIconPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'SPLASH_IMAGE_PATH')
  String get splashImagePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE')
  List<int> get fontWeights => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetsConfigCopyWith<AssetsConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetsConfigCopyWith<$Res> {
  factory $AssetsConfigCopyWith(
          AssetsConfig value, $Res Function(AssetsConfig) then) =
      _$AssetsConfigCopyWithImpl<$Res, AssetsConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'APP_ICON_SOURCE_PATH') String appIconPath,
      @JsonKey(name: 'SPLASH_IMAGE_PATH') String splashImagePath,
      @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE') List<int> fontWeights});
}

/// @nodoc
class _$AssetsConfigCopyWithImpl<$Res, $Val extends AssetsConfig>
    implements $AssetsConfigCopyWith<$Res> {
  _$AssetsConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appIconPath = null,
    Object? splashImagePath = null,
    Object? fontWeights = null,
  }) {
    return _then(_value.copyWith(
      appIconPath: null == appIconPath
          ? _value.appIconPath
          : appIconPath // ignore: cast_nullable_to_non_nullable
              as String,
      splashImagePath: null == splashImagePath
          ? _value.splashImagePath
          : splashImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      fontWeights: null == fontWeights
          ? _value.fontWeights
          : fontWeights // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetsConfigImplCopyWith<$Res>
    implements $AssetsConfigCopyWith<$Res> {
  factory _$$AssetsConfigImplCopyWith(
          _$AssetsConfigImpl value, $Res Function(_$AssetsConfigImpl) then) =
      __$$AssetsConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'APP_ICON_SOURCE_PATH') String appIconPath,
      @JsonKey(name: 'SPLASH_IMAGE_PATH') String splashImagePath,
      @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE') List<int> fontWeights});
}

/// @nodoc
class __$$AssetsConfigImplCopyWithImpl<$Res>
    extends _$AssetsConfigCopyWithImpl<$Res, _$AssetsConfigImpl>
    implements _$$AssetsConfigImplCopyWith<$Res> {
  __$$AssetsConfigImplCopyWithImpl(
      _$AssetsConfigImpl _value, $Res Function(_$AssetsConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appIconPath = null,
    Object? splashImagePath = null,
    Object? fontWeights = null,
  }) {
    return _then(_$AssetsConfigImpl(
      appIconPath: null == appIconPath
          ? _value.appIconPath
          : appIconPath // ignore: cast_nullable_to_non_nullable
              as String,
      splashImagePath: null == splashImagePath
          ? _value.splashImagePath
          : splashImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      fontWeights: null == fontWeights
          ? _value._fontWeights
          : fontWeights // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetsConfigImpl extends _AssetsConfig {
  const _$AssetsConfigImpl(
      {@JsonKey(name: 'APP_ICON_SOURCE_PATH') required this.appIconPath,
      @JsonKey(name: 'SPLASH_IMAGE_PATH') required this.splashImagePath,
      @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE')
      required final List<int> fontWeights})
      : _fontWeights = fontWeights,
        super._();

  factory _$AssetsConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetsConfigImplFromJson(json);

  @override
  @JsonKey(name: 'APP_ICON_SOURCE_PATH')
  final String appIconPath;
  @override
  @JsonKey(name: 'SPLASH_IMAGE_PATH')
  final String splashImagePath;
  final List<int> _fontWeights;
  @override
  @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE')
  List<int> get fontWeights {
    if (_fontWeights is EqualUnmodifiableListView) return _fontWeights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fontWeights);
  }

  @override
  String toString() {
    return 'AssetsConfig(appIconPath: $appIconPath, splashImagePath: $splashImagePath, fontWeights: $fontWeights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetsConfigImpl &&
            (identical(other.appIconPath, appIconPath) ||
                other.appIconPath == appIconPath) &&
            (identical(other.splashImagePath, splashImagePath) ||
                other.splashImagePath == splashImagePath) &&
            const DeepCollectionEquality()
                .equals(other._fontWeights, _fontWeights));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, appIconPath, splashImagePath,
      const DeepCollectionEquality().hash(_fontWeights));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetsConfigImplCopyWith<_$AssetsConfigImpl> get copyWith =>
      __$$AssetsConfigImplCopyWithImpl<_$AssetsConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetsConfigImplToJson(
      this,
    );
  }
}

abstract class _AssetsConfig extends AssetsConfig {
  const factory _AssetsConfig(
      {@JsonKey(name: 'APP_ICON_SOURCE_PATH') required final String appIconPath,
      @JsonKey(name: 'SPLASH_IMAGE_PATH') required final String splashImagePath,
      @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE')
      required final List<int> fontWeights}) = _$AssetsConfigImpl;
  const _AssetsConfig._() : super._();

  factory _AssetsConfig.fromJson(Map<String, dynamic> json) =
      _$AssetsConfigImpl.fromJson;

  @override
  @JsonKey(name: 'APP_ICON_SOURCE_PATH')
  String get appIconPath;
  @override
  @JsonKey(name: 'SPLASH_IMAGE_PATH')
  String get splashImagePath;
  @override
  @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE')
  List<int> get fontWeights;
  @override
  @JsonKey(ignore: true)
  _$$AssetsConfigImplCopyWith<_$AssetsConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeatureFlags _$FeatureFlagsFromJson(Map<String, dynamic> json) {
  return _FeatureFlags.fromJson(json);
}

/// @nodoc
mixin _$FeatureFlags {
  @JsonKey(name: 'ENABLE_MOCK_WALLET')
  bool get enableMockWallet => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_TEAM_COLLABORATION')
  bool get enableTeamCollaboration => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_GOOGLE_AUTH')
  bool get enableGoogleAuth => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_FACEBOOK_AUTH')
  bool get enableFacebookAuth => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_DATA_EXPORT')
  bool get enableDataExport => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS')
  bool get enableAiFraudAlerts => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_GLOBAL_SYNC')
  bool get enableGlobalSync => throw _privateConstructorUsedError;
  @JsonKey(name: 'ENABLE_MFS_DETECTION')
  bool get enableMfsDetection => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeatureFlagsCopyWith<FeatureFlags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureFlagsCopyWith<$Res> {
  factory $FeatureFlagsCopyWith(
          FeatureFlags value, $Res Function(FeatureFlags) then) =
      _$FeatureFlagsCopyWithImpl<$Res, FeatureFlags>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ENABLE_MOCK_WALLET') bool enableMockWallet,
      @JsonKey(name: 'ENABLE_TEAM_COLLABORATION') bool enableTeamCollaboration,
      @JsonKey(name: 'ENABLE_GOOGLE_AUTH') bool enableGoogleAuth,
      @JsonKey(name: 'ENABLE_FACEBOOK_AUTH') bool enableFacebookAuth,
      @JsonKey(name: 'ENABLE_DATA_EXPORT') bool enableDataExport,
      @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS') bool enableAiFraudAlerts,
      @JsonKey(name: 'ENABLE_GLOBAL_SYNC') bool enableGlobalSync,
      @JsonKey(name: 'ENABLE_MFS_DETECTION') bool enableMfsDetection});
}

/// @nodoc
class _$FeatureFlagsCopyWithImpl<$Res, $Val extends FeatureFlags>
    implements $FeatureFlagsCopyWith<$Res> {
  _$FeatureFlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableMockWallet = null,
    Object? enableTeamCollaboration = null,
    Object? enableGoogleAuth = null,
    Object? enableFacebookAuth = null,
    Object? enableDataExport = null,
    Object? enableAiFraudAlerts = null,
    Object? enableGlobalSync = null,
    Object? enableMfsDetection = null,
  }) {
    return _then(_value.copyWith(
      enableMockWallet: null == enableMockWallet
          ? _value.enableMockWallet
          : enableMockWallet // ignore: cast_nullable_to_non_nullable
              as bool,
      enableTeamCollaboration: null == enableTeamCollaboration
          ? _value.enableTeamCollaboration
          : enableTeamCollaboration // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGoogleAuth: null == enableGoogleAuth
          ? _value.enableGoogleAuth
          : enableGoogleAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFacebookAuth: null == enableFacebookAuth
          ? _value.enableFacebookAuth
          : enableFacebookAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableDataExport: null == enableDataExport
          ? _value.enableDataExport
          : enableDataExport // ignore: cast_nullable_to_non_nullable
              as bool,
      enableAiFraudAlerts: null == enableAiFraudAlerts
          ? _value.enableAiFraudAlerts
          : enableAiFraudAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGlobalSync: null == enableGlobalSync
          ? _value.enableGlobalSync
          : enableGlobalSync // ignore: cast_nullable_to_non_nullable
              as bool,
      enableMfsDetection: null == enableMfsDetection
          ? _value.enableMfsDetection
          : enableMfsDetection // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureFlagsImplCopyWith<$Res>
    implements $FeatureFlagsCopyWith<$Res> {
  factory _$$FeatureFlagsImplCopyWith(
          _$FeatureFlagsImpl value, $Res Function(_$FeatureFlagsImpl) then) =
      __$$FeatureFlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ENABLE_MOCK_WALLET') bool enableMockWallet,
      @JsonKey(name: 'ENABLE_TEAM_COLLABORATION') bool enableTeamCollaboration,
      @JsonKey(name: 'ENABLE_GOOGLE_AUTH') bool enableGoogleAuth,
      @JsonKey(name: 'ENABLE_FACEBOOK_AUTH') bool enableFacebookAuth,
      @JsonKey(name: 'ENABLE_DATA_EXPORT') bool enableDataExport,
      @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS') bool enableAiFraudAlerts,
      @JsonKey(name: 'ENABLE_GLOBAL_SYNC') bool enableGlobalSync,
      @JsonKey(name: 'ENABLE_MFS_DETECTION') bool enableMfsDetection});
}

/// @nodoc
class __$$FeatureFlagsImplCopyWithImpl<$Res>
    extends _$FeatureFlagsCopyWithImpl<$Res, _$FeatureFlagsImpl>
    implements _$$FeatureFlagsImplCopyWith<$Res> {
  __$$FeatureFlagsImplCopyWithImpl(
      _$FeatureFlagsImpl _value, $Res Function(_$FeatureFlagsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableMockWallet = null,
    Object? enableTeamCollaboration = null,
    Object? enableGoogleAuth = null,
    Object? enableFacebookAuth = null,
    Object? enableDataExport = null,
    Object? enableAiFraudAlerts = null,
    Object? enableGlobalSync = null,
    Object? enableMfsDetection = null,
  }) {
    return _then(_$FeatureFlagsImpl(
      enableMockWallet: null == enableMockWallet
          ? _value.enableMockWallet
          : enableMockWallet // ignore: cast_nullable_to_non_nullable
              as bool,
      enableTeamCollaboration: null == enableTeamCollaboration
          ? _value.enableTeamCollaboration
          : enableTeamCollaboration // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGoogleAuth: null == enableGoogleAuth
          ? _value.enableGoogleAuth
          : enableGoogleAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFacebookAuth: null == enableFacebookAuth
          ? _value.enableFacebookAuth
          : enableFacebookAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableDataExport: null == enableDataExport
          ? _value.enableDataExport
          : enableDataExport // ignore: cast_nullable_to_non_nullable
              as bool,
      enableAiFraudAlerts: null == enableAiFraudAlerts
          ? _value.enableAiFraudAlerts
          : enableAiFraudAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGlobalSync: null == enableGlobalSync
          ? _value.enableGlobalSync
          : enableGlobalSync // ignore: cast_nullable_to_non_nullable
              as bool,
      enableMfsDetection: null == enableMfsDetection
          ? _value.enableMfsDetection
          : enableMfsDetection // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeatureFlagsImpl extends _FeatureFlags {
  const _$FeatureFlagsImpl(
      {@JsonKey(name: 'ENABLE_MOCK_WALLET') this.enableMockWallet = false,
      @JsonKey(name: 'ENABLE_TEAM_COLLABORATION')
      this.enableTeamCollaboration = false,
      @JsonKey(name: 'ENABLE_GOOGLE_AUTH') this.enableGoogleAuth = true,
      @JsonKey(name: 'ENABLE_FACEBOOK_AUTH') this.enableFacebookAuth = false,
      @JsonKey(name: 'ENABLE_DATA_EXPORT') this.enableDataExport = true,
      @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS') this.enableAiFraudAlerts = false,
      @JsonKey(name: 'ENABLE_GLOBAL_SYNC') this.enableGlobalSync = true,
      @JsonKey(name: 'ENABLE_MFS_DETECTION') this.enableMfsDetection = false})
      : super._();

  factory _$FeatureFlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeatureFlagsImplFromJson(json);

  @override
  @JsonKey(name: 'ENABLE_MOCK_WALLET')
  final bool enableMockWallet;
  @override
  @JsonKey(name: 'ENABLE_TEAM_COLLABORATION')
  final bool enableTeamCollaboration;
  @override
  @JsonKey(name: 'ENABLE_GOOGLE_AUTH')
  final bool enableGoogleAuth;
  @override
  @JsonKey(name: 'ENABLE_FACEBOOK_AUTH')
  final bool enableFacebookAuth;
  @override
  @JsonKey(name: 'ENABLE_DATA_EXPORT')
  final bool enableDataExport;
  @override
  @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS')
  final bool enableAiFraudAlerts;
  @override
  @JsonKey(name: 'ENABLE_GLOBAL_SYNC')
  final bool enableGlobalSync;
  @override
  @JsonKey(name: 'ENABLE_MFS_DETECTION')
  final bool enableMfsDetection;

  @override
  String toString() {
    return 'FeatureFlags(enableMockWallet: $enableMockWallet, enableTeamCollaboration: $enableTeamCollaboration, enableGoogleAuth: $enableGoogleAuth, enableFacebookAuth: $enableFacebookAuth, enableDataExport: $enableDataExport, enableAiFraudAlerts: $enableAiFraudAlerts, enableGlobalSync: $enableGlobalSync, enableMfsDetection: $enableMfsDetection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureFlagsImpl &&
            (identical(other.enableMockWallet, enableMockWallet) ||
                other.enableMockWallet == enableMockWallet) &&
            (identical(
                    other.enableTeamCollaboration, enableTeamCollaboration) ||
                other.enableTeamCollaboration == enableTeamCollaboration) &&
            (identical(other.enableGoogleAuth, enableGoogleAuth) ||
                other.enableGoogleAuth == enableGoogleAuth) &&
            (identical(other.enableFacebookAuth, enableFacebookAuth) ||
                other.enableFacebookAuth == enableFacebookAuth) &&
            (identical(other.enableDataExport, enableDataExport) ||
                other.enableDataExport == enableDataExport) &&
            (identical(other.enableAiFraudAlerts, enableAiFraudAlerts) ||
                other.enableAiFraudAlerts == enableAiFraudAlerts) &&
            (identical(other.enableGlobalSync, enableGlobalSync) ||
                other.enableGlobalSync == enableGlobalSync) &&
            (identical(other.enableMfsDetection, enableMfsDetection) ||
                other.enableMfsDetection == enableMfsDetection));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enableMockWallet,
      enableTeamCollaboration,
      enableGoogleAuth,
      enableFacebookAuth,
      enableDataExport,
      enableAiFraudAlerts,
      enableGlobalSync,
      enableMfsDetection);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureFlagsImplCopyWith<_$FeatureFlagsImpl> get copyWith =>
      __$$FeatureFlagsImplCopyWithImpl<_$FeatureFlagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeatureFlagsImplToJson(
      this,
    );
  }
}

abstract class _FeatureFlags extends FeatureFlags {
  const factory _FeatureFlags(
      {@JsonKey(name: 'ENABLE_MOCK_WALLET') final bool enableMockWallet,
      @JsonKey(name: 'ENABLE_TEAM_COLLABORATION')
      final bool enableTeamCollaboration,
      @JsonKey(name: 'ENABLE_GOOGLE_AUTH') final bool enableGoogleAuth,
      @JsonKey(name: 'ENABLE_FACEBOOK_AUTH') final bool enableFacebookAuth,
      @JsonKey(name: 'ENABLE_DATA_EXPORT') final bool enableDataExport,
      @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS') final bool enableAiFraudAlerts,
      @JsonKey(name: 'ENABLE_GLOBAL_SYNC') final bool enableGlobalSync,
      @JsonKey(name: 'ENABLE_MFS_DETECTION')
      final bool enableMfsDetection}) = _$FeatureFlagsImpl;
  const _FeatureFlags._() : super._();

  factory _FeatureFlags.fromJson(Map<String, dynamic> json) =
      _$FeatureFlagsImpl.fromJson;

  @override
  @JsonKey(name: 'ENABLE_MOCK_WALLET')
  bool get enableMockWallet;
  @override
  @JsonKey(name: 'ENABLE_TEAM_COLLABORATION')
  bool get enableTeamCollaboration;
  @override
  @JsonKey(name: 'ENABLE_GOOGLE_AUTH')
  bool get enableGoogleAuth;
  @override
  @JsonKey(name: 'ENABLE_FACEBOOK_AUTH')
  bool get enableFacebookAuth;
  @override
  @JsonKey(name: 'ENABLE_DATA_EXPORT')
  bool get enableDataExport;
  @override
  @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS')
  bool get enableAiFraudAlerts;
  @override
  @JsonKey(name: 'ENABLE_GLOBAL_SYNC')
  bool get enableGlobalSync;
  @override
  @JsonKey(name: 'ENABLE_MFS_DETECTION')
  bool get enableMfsDetection;
  @override
  @JsonKey(ignore: true)
  _$$FeatureFlagsImplCopyWith<_$FeatureFlagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SecurityLimits _$SecurityLimitsFromJson(Map<String, dynamic> json) {
  return _SecurityLimits.fromJson(json);
}

/// @nodoc
mixin _$SecurityLimits {
  @JsonKey(name: 'MAX_LOGIN_ATTEMPTS')
  int get maxLoginAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'OTP_EXPIRY_SECONDS')
  int get otpExpirySeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'SESSION_TIMEOUT_MINUTES')
  int get sessionTimeoutMinutes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SecurityLimitsCopyWith<SecurityLimits> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityLimitsCopyWith<$Res> {
  factory $SecurityLimitsCopyWith(
          SecurityLimits value, $Res Function(SecurityLimits) then) =
      _$SecurityLimitsCopyWithImpl<$Res, SecurityLimits>;
  @useResult
  $Res call(
      {@JsonKey(name: 'MAX_LOGIN_ATTEMPTS') int maxLoginAttempts,
      @JsonKey(name: 'OTP_EXPIRY_SECONDS') int otpExpirySeconds,
      @JsonKey(name: 'SESSION_TIMEOUT_MINUTES') int sessionTimeoutMinutes});
}

/// @nodoc
class _$SecurityLimitsCopyWithImpl<$Res, $Val extends SecurityLimits>
    implements $SecurityLimitsCopyWith<$Res> {
  _$SecurityLimitsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxLoginAttempts = null,
    Object? otpExpirySeconds = null,
    Object? sessionTimeoutMinutes = null,
  }) {
    return _then(_value.copyWith(
      maxLoginAttempts: null == maxLoginAttempts
          ? _value.maxLoginAttempts
          : maxLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      otpExpirySeconds: null == otpExpirySeconds
          ? _value.otpExpirySeconds
          : otpExpirySeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionTimeoutMinutes: null == sessionTimeoutMinutes
          ? _value.sessionTimeoutMinutes
          : sessionTimeoutMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SecurityLimitsImplCopyWith<$Res>
    implements $SecurityLimitsCopyWith<$Res> {
  factory _$$SecurityLimitsImplCopyWith(_$SecurityLimitsImpl value,
          $Res Function(_$SecurityLimitsImpl) then) =
      __$$SecurityLimitsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'MAX_LOGIN_ATTEMPTS') int maxLoginAttempts,
      @JsonKey(name: 'OTP_EXPIRY_SECONDS') int otpExpirySeconds,
      @JsonKey(name: 'SESSION_TIMEOUT_MINUTES') int sessionTimeoutMinutes});
}

/// @nodoc
class __$$SecurityLimitsImplCopyWithImpl<$Res>
    extends _$SecurityLimitsCopyWithImpl<$Res, _$SecurityLimitsImpl>
    implements _$$SecurityLimitsImplCopyWith<$Res> {
  __$$SecurityLimitsImplCopyWithImpl(
      _$SecurityLimitsImpl _value, $Res Function(_$SecurityLimitsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxLoginAttempts = null,
    Object? otpExpirySeconds = null,
    Object? sessionTimeoutMinutes = null,
  }) {
    return _then(_$SecurityLimitsImpl(
      maxLoginAttempts: null == maxLoginAttempts
          ? _value.maxLoginAttempts
          : maxLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      otpExpirySeconds: null == otpExpirySeconds
          ? _value.otpExpirySeconds
          : otpExpirySeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionTimeoutMinutes: null == sessionTimeoutMinutes
          ? _value.sessionTimeoutMinutes
          : sessionTimeoutMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecurityLimitsImpl extends _SecurityLimits {
  const _$SecurityLimitsImpl(
      {@JsonKey(name: 'MAX_LOGIN_ATTEMPTS') this.maxLoginAttempts = 5,
      @JsonKey(name: 'OTP_EXPIRY_SECONDS') this.otpExpirySeconds = 300,
      @JsonKey(name: 'SESSION_TIMEOUT_MINUTES')
      this.sessionTimeoutMinutes = 60})
      : super._();

  factory _$SecurityLimitsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecurityLimitsImplFromJson(json);

  @override
  @JsonKey(name: 'MAX_LOGIN_ATTEMPTS')
  final int maxLoginAttempts;
  @override
  @JsonKey(name: 'OTP_EXPIRY_SECONDS')
  final int otpExpirySeconds;
  @override
  @JsonKey(name: 'SESSION_TIMEOUT_MINUTES')
  final int sessionTimeoutMinutes;

  @override
  String toString() {
    return 'SecurityLimits(maxLoginAttempts: $maxLoginAttempts, otpExpirySeconds: $otpExpirySeconds, sessionTimeoutMinutes: $sessionTimeoutMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecurityLimitsImpl &&
            (identical(other.maxLoginAttempts, maxLoginAttempts) ||
                other.maxLoginAttempts == maxLoginAttempts) &&
            (identical(other.otpExpirySeconds, otpExpirySeconds) ||
                other.otpExpirySeconds == otpExpirySeconds) &&
            (identical(other.sessionTimeoutMinutes, sessionTimeoutMinutes) ||
                other.sessionTimeoutMinutes == sessionTimeoutMinutes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, maxLoginAttempts, otpExpirySeconds, sessionTimeoutMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SecurityLimitsImplCopyWith<_$SecurityLimitsImpl> get copyWith =>
      __$$SecurityLimitsImplCopyWithImpl<_$SecurityLimitsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecurityLimitsImplToJson(
      this,
    );
  }
}

abstract class _SecurityLimits extends SecurityLimits {
  const factory _SecurityLimits(
      {@JsonKey(name: 'MAX_LOGIN_ATTEMPTS') final int maxLoginAttempts,
      @JsonKey(name: 'OTP_EXPIRY_SECONDS') final int otpExpirySeconds,
      @JsonKey(name: 'SESSION_TIMEOUT_MINUTES')
      final int sessionTimeoutMinutes}) = _$SecurityLimitsImpl;
  const _SecurityLimits._() : super._();

  factory _SecurityLimits.fromJson(Map<String, dynamic> json) =
      _$SecurityLimitsImpl.fromJson;

  @override
  @JsonKey(name: 'MAX_LOGIN_ATTEMPTS')
  int get maxLoginAttempts;
  @override
  @JsonKey(name: 'OTP_EXPIRY_SECONDS')
  int get otpExpirySeconds;
  @override
  @JsonKey(name: 'SESSION_TIMEOUT_MINUTES')
  int get sessionTimeoutMinutes;
  @override
  @JsonKey(ignore: true)
  _$$SecurityLimitsImplCopyWith<_$SecurityLimitsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackupConfig _$BackupConfigFromJson(Map<String, dynamic> json) {
  return _BackupConfig.fromJson(json);
}

/// @nodoc
mixin _$BackupConfig {
  @JsonKey(name: 'DRIVE_FOLDER_NAME')
  String get driveFolderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'BACKUP_FILENAME_PREFIX')
  String get backupFilenamePrefix => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BackupConfigCopyWith<BackupConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupConfigCopyWith<$Res> {
  factory $BackupConfigCopyWith(
          BackupConfig value, $Res Function(BackupConfig) then) =
      _$BackupConfigCopyWithImpl<$Res, BackupConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'DRIVE_FOLDER_NAME') String driveFolderName,
      @JsonKey(name: 'BACKUP_FILENAME_PREFIX') String backupFilenamePrefix});
}

/// @nodoc
class _$BackupConfigCopyWithImpl<$Res, $Val extends BackupConfig>
    implements $BackupConfigCopyWith<$Res> {
  _$BackupConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driveFolderName = null,
    Object? backupFilenamePrefix = null,
  }) {
    return _then(_value.copyWith(
      driveFolderName: null == driveFolderName
          ? _value.driveFolderName
          : driveFolderName // ignore: cast_nullable_to_non_nullable
              as String,
      backupFilenamePrefix: null == backupFilenamePrefix
          ? _value.backupFilenamePrefix
          : backupFilenamePrefix // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupConfigImplCopyWith<$Res>
    implements $BackupConfigCopyWith<$Res> {
  factory _$$BackupConfigImplCopyWith(
          _$BackupConfigImpl value, $Res Function(_$BackupConfigImpl) then) =
      __$$BackupConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'DRIVE_FOLDER_NAME') String driveFolderName,
      @JsonKey(name: 'BACKUP_FILENAME_PREFIX') String backupFilenamePrefix});
}

/// @nodoc
class __$$BackupConfigImplCopyWithImpl<$Res>
    extends _$BackupConfigCopyWithImpl<$Res, _$BackupConfigImpl>
    implements _$$BackupConfigImplCopyWith<$Res> {
  __$$BackupConfigImplCopyWithImpl(
      _$BackupConfigImpl _value, $Res Function(_$BackupConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driveFolderName = null,
    Object? backupFilenamePrefix = null,
  }) {
    return _then(_$BackupConfigImpl(
      driveFolderName: null == driveFolderName
          ? _value.driveFolderName
          : driveFolderName // ignore: cast_nullable_to_non_nullable
              as String,
      backupFilenamePrefix: null == backupFilenamePrefix
          ? _value.backupFilenamePrefix
          : backupFilenamePrefix // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupConfigImpl extends _BackupConfig {
  const _$BackupConfigImpl(
      {@JsonKey(name: 'DRIVE_FOLDER_NAME') required this.driveFolderName,
      @JsonKey(name: 'BACKUP_FILENAME_PREFIX')
      required this.backupFilenamePrefix})
      : super._();

  factory _$BackupConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupConfigImplFromJson(json);

  @override
  @JsonKey(name: 'DRIVE_FOLDER_NAME')
  final String driveFolderName;
  @override
  @JsonKey(name: 'BACKUP_FILENAME_PREFIX')
  final String backupFilenamePrefix;

  @override
  String toString() {
    return 'BackupConfig(driveFolderName: $driveFolderName, backupFilenamePrefix: $backupFilenamePrefix)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupConfigImpl &&
            (identical(other.driveFolderName, driveFolderName) ||
                other.driveFolderName == driveFolderName) &&
            (identical(other.backupFilenamePrefix, backupFilenamePrefix) ||
                other.backupFilenamePrefix == backupFilenamePrefix));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, driveFolderName, backupFilenamePrefix);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupConfigImplCopyWith<_$BackupConfigImpl> get copyWith =>
      __$$BackupConfigImplCopyWithImpl<_$BackupConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupConfigImplToJson(
      this,
    );
  }
}

abstract class _BackupConfig extends BackupConfig {
  const factory _BackupConfig(
      {@JsonKey(name: 'DRIVE_FOLDER_NAME')
      required final String driveFolderName,
      @JsonKey(name: 'BACKUP_FILENAME_PREFIX')
      required final String backupFilenamePrefix}) = _$BackupConfigImpl;
  const _BackupConfig._() : super._();

  factory _BackupConfig.fromJson(Map<String, dynamic> json) =
      _$BackupConfigImpl.fromJson;

  @override
  @JsonKey(name: 'DRIVE_FOLDER_NAME')
  String get driveFolderName;
  @override
  @JsonKey(name: 'BACKUP_FILENAME_PREFIX')
  String get backupFilenamePrefix;
  @override
  @JsonKey(ignore: true)
  _$$BackupConfigImplCopyWith<_$BackupConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupabaseConfig _$SupabaseConfigFromJson(Map<String, dynamic> json) {
  return _SupabaseConfig.fromJson(json);
}

/// @nodoc
mixin _$SupabaseConfig {
  @JsonKey(name: 'PROJECT_URL')
  String get projectUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'ANON_KEY')
  String get anonKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'STORAGE_BUCKET_IMAGES')
  String get storageBucketImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'STORAGE_BUCKET_BACKUPS')
  String get storageBucketBackups => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupabaseConfigCopyWith<SupabaseConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupabaseConfigCopyWith<$Res> {
  factory $SupabaseConfigCopyWith(
          SupabaseConfig value, $Res Function(SupabaseConfig) then) =
      _$SupabaseConfigCopyWithImpl<$Res, SupabaseConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'PROJECT_URL') String projectUrl,
      @JsonKey(name: 'ANON_KEY') String anonKey,
      @JsonKey(name: 'STORAGE_BUCKET_IMAGES') String storageBucketImages,
      @JsonKey(name: 'STORAGE_BUCKET_BACKUPS') String storageBucketBackups});
}

/// @nodoc
class _$SupabaseConfigCopyWithImpl<$Res, $Val extends SupabaseConfig>
    implements $SupabaseConfigCopyWith<$Res> {
  _$SupabaseConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectUrl = null,
    Object? anonKey = null,
    Object? storageBucketImages = null,
    Object? storageBucketBackups = null,
  }) {
    return _then(_value.copyWith(
      projectUrl: null == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String,
      anonKey: null == anonKey
          ? _value.anonKey
          : anonKey // ignore: cast_nullable_to_non_nullable
              as String,
      storageBucketImages: null == storageBucketImages
          ? _value.storageBucketImages
          : storageBucketImages // ignore: cast_nullable_to_non_nullable
              as String,
      storageBucketBackups: null == storageBucketBackups
          ? _value.storageBucketBackups
          : storageBucketBackups // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupabaseConfigImplCopyWith<$Res>
    implements $SupabaseConfigCopyWith<$Res> {
  factory _$$SupabaseConfigImplCopyWith(_$SupabaseConfigImpl value,
          $Res Function(_$SupabaseConfigImpl) then) =
      __$$SupabaseConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'PROJECT_URL') String projectUrl,
      @JsonKey(name: 'ANON_KEY') String anonKey,
      @JsonKey(name: 'STORAGE_BUCKET_IMAGES') String storageBucketImages,
      @JsonKey(name: 'STORAGE_BUCKET_BACKUPS') String storageBucketBackups});
}

/// @nodoc
class __$$SupabaseConfigImplCopyWithImpl<$Res>
    extends _$SupabaseConfigCopyWithImpl<$Res, _$SupabaseConfigImpl>
    implements _$$SupabaseConfigImplCopyWith<$Res> {
  __$$SupabaseConfigImplCopyWithImpl(
      _$SupabaseConfigImpl _value, $Res Function(_$SupabaseConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectUrl = null,
    Object? anonKey = null,
    Object? storageBucketImages = null,
    Object? storageBucketBackups = null,
  }) {
    return _then(_$SupabaseConfigImpl(
      projectUrl: null == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String,
      anonKey: null == anonKey
          ? _value.anonKey
          : anonKey // ignore: cast_nullable_to_non_nullable
              as String,
      storageBucketImages: null == storageBucketImages
          ? _value.storageBucketImages
          : storageBucketImages // ignore: cast_nullable_to_non_nullable
              as String,
      storageBucketBackups: null == storageBucketBackups
          ? _value.storageBucketBackups
          : storageBucketBackups // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupabaseConfigImpl implements _SupabaseConfig {
  const _$SupabaseConfigImpl(
      {@JsonKey(name: 'PROJECT_URL') required this.projectUrl,
      @JsonKey(name: 'ANON_KEY') required this.anonKey,
      @JsonKey(name: 'STORAGE_BUCKET_IMAGES') required this.storageBucketImages,
      @JsonKey(name: 'STORAGE_BUCKET_BACKUPS')
      required this.storageBucketBackups});

  factory _$SupabaseConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupabaseConfigImplFromJson(json);

  @override
  @JsonKey(name: 'PROJECT_URL')
  final String projectUrl;
  @override
  @JsonKey(name: 'ANON_KEY')
  final String anonKey;
  @override
  @JsonKey(name: 'STORAGE_BUCKET_IMAGES')
  final String storageBucketImages;
  @override
  @JsonKey(name: 'STORAGE_BUCKET_BACKUPS')
  final String storageBucketBackups;

  @override
  String toString() {
    return 'SupabaseConfig(projectUrl: $projectUrl, anonKey: $anonKey, storageBucketImages: $storageBucketImages, storageBucketBackups: $storageBucketBackups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupabaseConfigImpl &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.anonKey, anonKey) || other.anonKey == anonKey) &&
            (identical(other.storageBucketImages, storageBucketImages) ||
                other.storageBucketImages == storageBucketImages) &&
            (identical(other.storageBucketBackups, storageBucketBackups) ||
                other.storageBucketBackups == storageBucketBackups));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, projectUrl, anonKey,
      storageBucketImages, storageBucketBackups);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupabaseConfigImplCopyWith<_$SupabaseConfigImpl> get copyWith =>
      __$$SupabaseConfigImplCopyWithImpl<_$SupabaseConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupabaseConfigImplToJson(
      this,
    );
  }
}

abstract class _SupabaseConfig implements SupabaseConfig {
  const factory _SupabaseConfig(
      {@JsonKey(name: 'PROJECT_URL') required final String projectUrl,
      @JsonKey(name: 'ANON_KEY') required final String anonKey,
      @JsonKey(name: 'STORAGE_BUCKET_IMAGES')
      required final String storageBucketImages,
      @JsonKey(name: 'STORAGE_BUCKET_BACKUPS')
      required final String storageBucketBackups}) = _$SupabaseConfigImpl;

  factory _SupabaseConfig.fromJson(Map<String, dynamic> json) =
      _$SupabaseConfigImpl.fromJson;

  @override
  @JsonKey(name: 'PROJECT_URL')
  String get projectUrl;
  @override
  @JsonKey(name: 'ANON_KEY')
  String get anonKey;
  @override
  @JsonKey(name: 'STORAGE_BUCKET_IMAGES')
  String get storageBucketImages;
  @override
  @JsonKey(name: 'STORAGE_BUCKET_BACKUPS')
  String get storageBucketBackups;
  @override
  @JsonKey(ignore: true)
  _$$SupabaseConfigImplCopyWith<_$SupabaseConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoogleAuthConfig _$GoogleAuthConfigFromJson(Map<String, dynamic> json) {
  return _GoogleAuthConfig.fromJson(json);
}

/// @nodoc
mixin _$GoogleAuthConfig {
  @JsonKey(name: 'WEB_CLIENT_ID')
  String get webClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'IOS_CLIENT_ID')
  String get iosClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ANDROID_CLIENT_ID')
  String get androidClientId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoogleAuthConfigCopyWith<GoogleAuthConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleAuthConfigCopyWith<$Res> {
  factory $GoogleAuthConfigCopyWith(
          GoogleAuthConfig value, $Res Function(GoogleAuthConfig) then) =
      _$GoogleAuthConfigCopyWithImpl<$Res, GoogleAuthConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'WEB_CLIENT_ID') String webClientId,
      @JsonKey(name: 'IOS_CLIENT_ID') String iosClientId,
      @JsonKey(name: 'ANDROID_CLIENT_ID') String androidClientId});
}

/// @nodoc
class _$GoogleAuthConfigCopyWithImpl<$Res, $Val extends GoogleAuthConfig>
    implements $GoogleAuthConfigCopyWith<$Res> {
  _$GoogleAuthConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? webClientId = null,
    Object? iosClientId = null,
    Object? androidClientId = null,
  }) {
    return _then(_value.copyWith(
      webClientId: null == webClientId
          ? _value.webClientId
          : webClientId // ignore: cast_nullable_to_non_nullable
              as String,
      iosClientId: null == iosClientId
          ? _value.iosClientId
          : iosClientId // ignore: cast_nullable_to_non_nullable
              as String,
      androidClientId: null == androidClientId
          ? _value.androidClientId
          : androidClientId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleAuthConfigImplCopyWith<$Res>
    implements $GoogleAuthConfigCopyWith<$Res> {
  factory _$$GoogleAuthConfigImplCopyWith(_$GoogleAuthConfigImpl value,
          $Res Function(_$GoogleAuthConfigImpl) then) =
      __$$GoogleAuthConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'WEB_CLIENT_ID') String webClientId,
      @JsonKey(name: 'IOS_CLIENT_ID') String iosClientId,
      @JsonKey(name: 'ANDROID_CLIENT_ID') String androidClientId});
}

/// @nodoc
class __$$GoogleAuthConfigImplCopyWithImpl<$Res>
    extends _$GoogleAuthConfigCopyWithImpl<$Res, _$GoogleAuthConfigImpl>
    implements _$$GoogleAuthConfigImplCopyWith<$Res> {
  __$$GoogleAuthConfigImplCopyWithImpl(_$GoogleAuthConfigImpl _value,
      $Res Function(_$GoogleAuthConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? webClientId = null,
    Object? iosClientId = null,
    Object? androidClientId = null,
  }) {
    return _then(_$GoogleAuthConfigImpl(
      webClientId: null == webClientId
          ? _value.webClientId
          : webClientId // ignore: cast_nullable_to_non_nullable
              as String,
      iosClientId: null == iosClientId
          ? _value.iosClientId
          : iosClientId // ignore: cast_nullable_to_non_nullable
              as String,
      androidClientId: null == androidClientId
          ? _value.androidClientId
          : androidClientId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleAuthConfigImpl implements _GoogleAuthConfig {
  const _$GoogleAuthConfigImpl(
      {@JsonKey(name: 'WEB_CLIENT_ID') required this.webClientId,
      @JsonKey(name: 'IOS_CLIENT_ID') required this.iosClientId,
      @JsonKey(name: 'ANDROID_CLIENT_ID') required this.androidClientId});

  factory _$GoogleAuthConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleAuthConfigImplFromJson(json);

  @override
  @JsonKey(name: 'WEB_CLIENT_ID')
  final String webClientId;
  @override
  @JsonKey(name: 'IOS_CLIENT_ID')
  final String iosClientId;
  @override
  @JsonKey(name: 'ANDROID_CLIENT_ID')
  final String androidClientId;

  @override
  String toString() {
    return 'GoogleAuthConfig(webClientId: $webClientId, iosClientId: $iosClientId, androidClientId: $androidClientId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleAuthConfigImpl &&
            (identical(other.webClientId, webClientId) ||
                other.webClientId == webClientId) &&
            (identical(other.iosClientId, iosClientId) ||
                other.iosClientId == iosClientId) &&
            (identical(other.androidClientId, androidClientId) ||
                other.androidClientId == androidClientId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, webClientId, iosClientId, androidClientId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleAuthConfigImplCopyWith<_$GoogleAuthConfigImpl> get copyWith =>
      __$$GoogleAuthConfigImplCopyWithImpl<_$GoogleAuthConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleAuthConfigImplToJson(
      this,
    );
  }
}

abstract class _GoogleAuthConfig implements GoogleAuthConfig {
  const factory _GoogleAuthConfig(
      {@JsonKey(name: 'WEB_CLIENT_ID') required final String webClientId,
      @JsonKey(name: 'IOS_CLIENT_ID') required final String iosClientId,
      @JsonKey(name: 'ANDROID_CLIENT_ID')
      required final String androidClientId}) = _$GoogleAuthConfigImpl;

  factory _GoogleAuthConfig.fromJson(Map<String, dynamic> json) =
      _$GoogleAuthConfigImpl.fromJson;

  @override
  @JsonKey(name: 'WEB_CLIENT_ID')
  String get webClientId;
  @override
  @JsonKey(name: 'IOS_CLIENT_ID')
  String get iosClientId;
  @override
  @JsonKey(name: 'ANDROID_CLIENT_ID')
  String get androidClientId;
  @override
  @JsonKey(ignore: true)
  _$$GoogleAuthConfigImplCopyWith<_$GoogleAuthConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
