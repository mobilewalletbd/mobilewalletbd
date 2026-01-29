import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

/// Application configuration loaded from required_info.json.
///
/// Contains non-sensitive configuration values for the app.
/// Sensitive values (API keys, secrets) are loaded from .env file.
@freezed
class AppConfigModel with _$AppConfigModel {
  const AppConfigModel._();

  const factory AppConfigModel({
    required AppMetadata appMetadata,
    required DesignSystem designSystem,
    required AssetsConfig assetsConfig,
    required FeatureFlags featureFlags,
    required SecurityLimits securityLimits,
    required BackupConfig backupConfig,
    SupabaseConfig? supabaseConfig,
    GoogleAuthConfig? googleAuthConfig,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  /// Creates a default configuration for fallback.
  factory AppConfigModel.defaults() => AppConfigModel(
    appMetadata: AppMetadata.defaults(),
    designSystem: DesignSystem.defaults(),
    assetsConfig: AssetsConfig.defaults(),
    featureFlags: FeatureFlags.defaults(),
    securityLimits: SecurityLimits.defaults(),
    backupConfig: BackupConfig.defaults(),
  );
}

/// App metadata configuration.
@freezed
class AppMetadata with _$AppMetadata {
  const AppMetadata._();

  const factory AppMetadata({
    @JsonKey(name: 'APP_NAME') required String appName,
    @JsonKey(name: 'BUNDLE_ID') required String bundleId,
    @JsonKey(name: 'PACKAGE_NAME') required String packageName,
    @JsonKey(name: 'VERSION') required String version,
    @JsonKey(name: 'BUILD_NUMBER') required String buildNumber,
    @JsonKey(name: 'DEFAULT_LOCALE') required String defaultLocale,
    @JsonKey(name: 'SUPPORTED_LOCALES') required List<String> supportedLocales,
  }) = _AppMetadata;

  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);

  factory AppMetadata.defaults() => const AppMetadata(
    appName: 'Smart Wallet',
    bundleId: 'com.example.mobilewallet',
    packageName: 'com.example.mobilewallet',
    version: '1.0.0',
    buildNumber: '1',
    defaultLocale: 'en_US',
    supportedLocales: ['en_US'],
  );
}

/// Design system configuration including colors and fonts.
@freezed
class DesignSystem with _$DesignSystem {
  const DesignSystem._();

  const factory DesignSystem({
    @JsonKey(name: 'FONT_FAMILY') required String fontFamily,
    @JsonKey(name: 'COLORS') required DesignColors colors,
  }) = _DesignSystem;

  factory DesignSystem.fromJson(Map<String, dynamic> json) =>
      _$DesignSystemFromJson(json);

  factory DesignSystem.defaults() =>
      DesignSystem(fontFamily: 'Inter', colors: DesignColors.defaults());
}

/// Design color configuration.
@freezed
class DesignColors with _$DesignColors {
  const DesignColors._();

  const factory DesignColors({
    @JsonKey(name: 'PRIMARY') required String primary,
    @JsonKey(name: 'SECONDARY') required String secondary,
    @JsonKey(name: 'ACCENT') required String accent,
    @JsonKey(name: 'BACKGROUND') required String background,
    @JsonKey(name: 'ERROR') required String error,
  }) = _DesignColors;

  factory DesignColors.fromJson(Map<String, dynamic> json) =>
      _$DesignColorsFromJson(json);

  factory DesignColors.defaults() => const DesignColors(
    primary: '#1E88E5',
    secondary: '#1A1F36',
    accent: '#FFC107',
    background: '#F8F9FB',
    error: '#FF4D4F',
  );

  /// Parses hex color string to Flutter Color.
  Color get primaryColor => _parseColor(primary);
  Color get secondaryColor => _parseColor(secondary);
  Color get accentColor => _parseColor(accent);
  Color get backgroundColor => _parseColor(background);
  Color get errorColor => _parseColor(error);

  Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Assets configuration paths.
@freezed
class AssetsConfig with _$AssetsConfig {
  const AssetsConfig._();

  const factory AssetsConfig({
    @JsonKey(name: 'APP_ICON_SOURCE_PATH') required String appIconPath,
    @JsonKey(name: 'SPLASH_IMAGE_PATH') required String splashImagePath,
    @JsonKey(name: 'FONT_WEIGHTS_TO_INCLUDE') required List<int> fontWeights,
  }) = _AssetsConfig;

  factory AssetsConfig.fromJson(Map<String, dynamic> json) =>
      _$AssetsConfigFromJson(json);

  factory AssetsConfig.defaults() => const AssetsConfig(
    appIconPath: 'assets/icons/logo.ico',
    splashImagePath: 'assets/images/logo.png',
    fontWeights: [400, 500, 600, 700],
  );
}

/// Feature flags for V1.
@freezed
class FeatureFlags with _$FeatureFlags {
  const FeatureFlags._();

  const factory FeatureFlags({
    @JsonKey(name: 'ENABLE_MOCK_WALLET') @Default(false) bool enableMockWallet,
    @JsonKey(name: 'ENABLE_TEAM_COLLABORATION')
    @Default(false)
    bool enableTeamCollaboration,
    @JsonKey(name: 'ENABLE_GOOGLE_AUTH') @Default(true) bool enableGoogleAuth,
    @JsonKey(name: 'ENABLE_FACEBOOK_AUTH')
    @Default(false)
    bool enableFacebookAuth,
    @JsonKey(name: 'ENABLE_DATA_EXPORT') @Default(true) bool enableDataExport,
    @JsonKey(name: 'ENABLE_AI_FRAUD_ALERTS')
    @Default(false)
    bool enableAiFraudAlerts,
    @JsonKey(name: 'ENABLE_GLOBAL_SYNC') @Default(true) bool enableGlobalSync,
    @JsonKey(name: 'ENABLE_MFS_DETECTION')
    @Default(false)
    bool enableMfsDetection,
  }) = _FeatureFlags;

  factory FeatureFlags.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagsFromJson(json);

  factory FeatureFlags.defaults() => const FeatureFlags();
}

/// Security limits configuration.
@freezed
class SecurityLimits with _$SecurityLimits {
  const SecurityLimits._();

  const factory SecurityLimits({
    @JsonKey(name: 'MAX_LOGIN_ATTEMPTS') @Default(5) int maxLoginAttempts,
    @JsonKey(name: 'OTP_EXPIRY_SECONDS') @Default(300) int otpExpirySeconds,
    @JsonKey(name: 'SESSION_TIMEOUT_MINUTES')
    @Default(60)
    int sessionTimeoutMinutes,
  }) = _SecurityLimits;

  factory SecurityLimits.fromJson(Map<String, dynamic> json) =>
      _$SecurityLimitsFromJson(json);

  factory SecurityLimits.defaults() => const SecurityLimits();

  /// Get OTP expiry as Duration
  Duration get otpExpiry => Duration(seconds: otpExpirySeconds);

  /// Get session timeout as Duration
  Duration get sessionTimeout => Duration(minutes: sessionTimeoutMinutes);
}

/// Backup configuration.
@freezed
class BackupConfig with _$BackupConfig {
  const BackupConfig._();

  const factory BackupConfig({
    @JsonKey(name: 'DRIVE_FOLDER_NAME') required String driveFolderName,
    @JsonKey(name: 'BACKUP_FILENAME_PREFIX')
    required String backupFilenamePrefix,
  }) = _BackupConfig;

  factory BackupConfig.fromJson(Map<String, dynamic> json) =>
      _$BackupConfigFromJson(json);

  factory BackupConfig.defaults() => const BackupConfig(
    driveFolderName: 'MobileWallet_Backups',
    backupFilenamePrefix: 'scw_backup_',
  );

  /// Generate backup filename with timestamp
  String generateBackupFilename() {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    return '$backupFilenamePrefix$timestamp.json';
  }
}

/// Supabase configuration (optional, may migrate to Firebase fully).
@freezed
class SupabaseConfig with _$SupabaseConfig {
  const factory SupabaseConfig({
    @JsonKey(name: 'PROJECT_URL') required String projectUrl,
    @JsonKey(name: 'ANON_KEY') required String anonKey,
    @JsonKey(name: 'STORAGE_BUCKET_IMAGES') required String storageBucketImages,
    @JsonKey(name: 'STORAGE_BUCKET_BACKUPS')
    required String storageBucketBackups,
  }) = _SupabaseConfig;

  factory SupabaseConfig.fromJson(Map<String, dynamic> json) =>
      _$SupabaseConfigFromJson(json);
}

/// Google Auth configuration.
@freezed
class GoogleAuthConfig with _$GoogleAuthConfig {
  const factory GoogleAuthConfig({
    @JsonKey(name: 'WEB_CLIENT_ID') required String webClientId,
    @JsonKey(name: 'IOS_CLIENT_ID') required String iosClientId,
    @JsonKey(name: 'ANDROID_CLIENT_ID') required String androidClientId,
  }) = _GoogleAuthConfig;

  factory GoogleAuthConfig.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthConfigFromJson(json);
}
