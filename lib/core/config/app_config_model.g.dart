// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigModelImpl _$$AppConfigModelImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigModelImpl(
      appMetadata:
          AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
      designSystem:
          DesignSystem.fromJson(json['designSystem'] as Map<String, dynamic>),
      assetsConfig:
          AssetsConfig.fromJson(json['assetsConfig'] as Map<String, dynamic>),
      featureFlags:
          FeatureFlags.fromJson(json['featureFlags'] as Map<String, dynamic>),
      securityLimits: SecurityLimits.fromJson(
          json['securityLimits'] as Map<String, dynamic>),
      backupConfig:
          BackupConfig.fromJson(json['backupConfig'] as Map<String, dynamic>),
      supabaseConfig: json['supabaseConfig'] == null
          ? null
          : SupabaseConfig.fromJson(
              json['supabaseConfig'] as Map<String, dynamic>),
      googleAuthConfig: json['googleAuthConfig'] == null
          ? null
          : GoogleAuthConfig.fromJson(
              json['googleAuthConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppConfigModelImplToJson(
        _$AppConfigModelImpl instance) =>
    <String, dynamic>{
      'appMetadata': instance.appMetadata,
      'designSystem': instance.designSystem,
      'assetsConfig': instance.assetsConfig,
      'featureFlags': instance.featureFlags,
      'securityLimits': instance.securityLimits,
      'backupConfig': instance.backupConfig,
      'supabaseConfig': instance.supabaseConfig,
      'googleAuthConfig': instance.googleAuthConfig,
    };

_$AppMetadataImpl _$$AppMetadataImplFromJson(Map<String, dynamic> json) =>
    _$AppMetadataImpl(
      appName: json['APP_NAME'] as String,
      bundleId: json['BUNDLE_ID'] as String,
      packageName: json['PACKAGE_NAME'] as String,
      version: json['VERSION'] as String,
      buildNumber: json['BUILD_NUMBER'] as String,
      defaultLocale: json['DEFAULT_LOCALE'] as String,
      supportedLocales: (json['SUPPORTED_LOCALES'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AppMetadataImplToJson(_$AppMetadataImpl instance) =>
    <String, dynamic>{
      'APP_NAME': instance.appName,
      'BUNDLE_ID': instance.bundleId,
      'PACKAGE_NAME': instance.packageName,
      'VERSION': instance.version,
      'BUILD_NUMBER': instance.buildNumber,
      'DEFAULT_LOCALE': instance.defaultLocale,
      'SUPPORTED_LOCALES': instance.supportedLocales,
    };

_$DesignSystemImpl _$$DesignSystemImplFromJson(Map<String, dynamic> json) =>
    _$DesignSystemImpl(
      fontFamily: json['FONT_FAMILY'] as String,
      colors: DesignColors.fromJson(json['COLORS'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DesignSystemImplToJson(_$DesignSystemImpl instance) =>
    <String, dynamic>{
      'FONT_FAMILY': instance.fontFamily,
      'COLORS': instance.colors,
    };

_$DesignColorsImpl _$$DesignColorsImplFromJson(Map<String, dynamic> json) =>
    _$DesignColorsImpl(
      primary: json['PRIMARY'] as String,
      secondary: json['SECONDARY'] as String,
      accent: json['ACCENT'] as String,
      background: json['BACKGROUND'] as String,
      error: json['ERROR'] as String,
    );

Map<String, dynamic> _$$DesignColorsImplToJson(_$DesignColorsImpl instance) =>
    <String, dynamic>{
      'PRIMARY': instance.primary,
      'SECONDARY': instance.secondary,
      'ACCENT': instance.accent,
      'BACKGROUND': instance.background,
      'ERROR': instance.error,
    };

_$AssetsConfigImpl _$$AssetsConfigImplFromJson(Map<String, dynamic> json) =>
    _$AssetsConfigImpl(
      appIconPath: json['APP_ICON_SOURCE_PATH'] as String,
      splashImagePath: json['SPLASH_IMAGE_PATH'] as String,
      fontWeights: (json['FONT_WEIGHTS_TO_INCLUDE'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$AssetsConfigImplToJson(_$AssetsConfigImpl instance) =>
    <String, dynamic>{
      'APP_ICON_SOURCE_PATH': instance.appIconPath,
      'SPLASH_IMAGE_PATH': instance.splashImagePath,
      'FONT_WEIGHTS_TO_INCLUDE': instance.fontWeights,
    };

_$FeatureFlagsImpl _$$FeatureFlagsImplFromJson(Map<String, dynamic> json) =>
    _$FeatureFlagsImpl(
      enableMockWallet: json['ENABLE_MOCK_WALLET'] as bool? ?? false,
      enableTeamCollaboration:
          json['ENABLE_TEAM_COLLABORATION'] as bool? ?? false,
      enableGoogleAuth: json['ENABLE_GOOGLE_AUTH'] as bool? ?? true,
      enableFacebookAuth: json['ENABLE_FACEBOOK_AUTH'] as bool? ?? false,
      enableDataExport: json['ENABLE_DATA_EXPORT'] as bool? ?? true,
      enableAiFraudAlerts: json['ENABLE_AI_FRAUD_ALERTS'] as bool? ?? false,
      enableGlobalSync: json['ENABLE_GLOBAL_SYNC'] as bool? ?? true,
      enableMfsDetection: json['ENABLE_MFS_DETECTION'] as bool? ?? false,
    );

Map<String, dynamic> _$$FeatureFlagsImplToJson(_$FeatureFlagsImpl instance) =>
    <String, dynamic>{
      'ENABLE_MOCK_WALLET': instance.enableMockWallet,
      'ENABLE_TEAM_COLLABORATION': instance.enableTeamCollaboration,
      'ENABLE_GOOGLE_AUTH': instance.enableGoogleAuth,
      'ENABLE_FACEBOOK_AUTH': instance.enableFacebookAuth,
      'ENABLE_DATA_EXPORT': instance.enableDataExport,
      'ENABLE_AI_FRAUD_ALERTS': instance.enableAiFraudAlerts,
      'ENABLE_GLOBAL_SYNC': instance.enableGlobalSync,
      'ENABLE_MFS_DETECTION': instance.enableMfsDetection,
    };

_$SecurityLimitsImpl _$$SecurityLimitsImplFromJson(Map<String, dynamic> json) =>
    _$SecurityLimitsImpl(
      maxLoginAttempts: (json['MAX_LOGIN_ATTEMPTS'] as num?)?.toInt() ?? 5,
      otpExpirySeconds: (json['OTP_EXPIRY_SECONDS'] as num?)?.toInt() ?? 300,
      sessionTimeoutMinutes:
          (json['SESSION_TIMEOUT_MINUTES'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$$SecurityLimitsImplToJson(
        _$SecurityLimitsImpl instance) =>
    <String, dynamic>{
      'MAX_LOGIN_ATTEMPTS': instance.maxLoginAttempts,
      'OTP_EXPIRY_SECONDS': instance.otpExpirySeconds,
      'SESSION_TIMEOUT_MINUTES': instance.sessionTimeoutMinutes,
    };

_$BackupConfigImpl _$$BackupConfigImplFromJson(Map<String, dynamic> json) =>
    _$BackupConfigImpl(
      driveFolderName: json['DRIVE_FOLDER_NAME'] as String,
      backupFilenamePrefix: json['BACKUP_FILENAME_PREFIX'] as String,
    );

Map<String, dynamic> _$$BackupConfigImplToJson(_$BackupConfigImpl instance) =>
    <String, dynamic>{
      'DRIVE_FOLDER_NAME': instance.driveFolderName,
      'BACKUP_FILENAME_PREFIX': instance.backupFilenamePrefix,
    };

_$SupabaseConfigImpl _$$SupabaseConfigImplFromJson(Map<String, dynamic> json) =>
    _$SupabaseConfigImpl(
      projectUrl: json['PROJECT_URL'] as String,
      anonKey: json['ANON_KEY'] as String,
      storageBucketImages: json['STORAGE_BUCKET_IMAGES'] as String,
      storageBucketBackups: json['STORAGE_BUCKET_BACKUPS'] as String,
    );

Map<String, dynamic> _$$SupabaseConfigImplToJson(
        _$SupabaseConfigImpl instance) =>
    <String, dynamic>{
      'PROJECT_URL': instance.projectUrl,
      'ANON_KEY': instance.anonKey,
      'STORAGE_BUCKET_IMAGES': instance.storageBucketImages,
      'STORAGE_BUCKET_BACKUPS': instance.storageBucketBackups,
    };

_$GoogleAuthConfigImpl _$$GoogleAuthConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleAuthConfigImpl(
      webClientId: json['WEB_CLIENT_ID'] as String,
      iosClientId: json['IOS_CLIENT_ID'] as String,
      androidClientId: json['ANDROID_CLIENT_ID'] as String,
    );

Map<String, dynamic> _$$GoogleAuthConfigImplToJson(
        _$GoogleAuthConfigImpl instance) =>
    <String, dynamic>{
      'WEB_CLIENT_ID': instance.webClientId,
      'IOS_CLIENT_ID': instance.iosClientId,
      'ANDROID_CLIENT_ID': instance.androidClientId,
    };
