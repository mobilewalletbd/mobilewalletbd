import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_config_model.dart';
import 'config_service.dart';

/// Global ConfigService instance.
final _configService = ConfigService();

/// Provider for the ConfigService.
///
/// Provides access to the loaded configuration service.
final configServiceProvider = Provider<ConfigService>((ref) {
  return _configService;
});

/// Provider for the complete app configuration.
///
/// Usage:
/// ```dart
/// final config = ref.watch(appConfigProvider);
/// print(config.appMetadata.appName);
/// ```
final appConfigProvider = Provider<AppConfigModel>((ref) {
  final service = ref.watch(configServiceProvider);
  return service.config;
});

/// Provider for app metadata.
final appMetadataProvider = Provider<AppMetadata>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.appMetadata;
});

/// Provider for the app name.
final appNameProvider = Provider<String>((ref) {
  final metadata = ref.watch(appMetadataProvider);
  return metadata.appName;
});

/// Provider for the app version.
final appVersionProvider = Provider<String>((ref) {
  final metadata = ref.watch(appMetadataProvider);
  return metadata.version;
});

/// Provider for design system configuration.
final designSystemProvider = Provider<DesignSystem>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.designSystem;
});

/// Provider for design colors.
final designColorsProvider = Provider<DesignColors>((ref) {
  final designSystem = ref.watch(designSystemProvider);
  return designSystem.colors;
});

/// Provider for the primary color.
final primaryColorProvider = Provider<Color>((ref) {
  final colors = ref.watch(designColorsProvider);
  return colors.primaryColor;
});

/// Provider for the secondary color.
final secondaryColorProvider = Provider<Color>((ref) {
  final colors = ref.watch(designColorsProvider);
  return colors.secondaryColor;
});

/// Provider for assets configuration.
final assetsConfigProvider = Provider<AssetsConfig>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.assetsConfig;
});

/// Provider for splash image path.
final splashImagePathProvider = Provider<String>((ref) {
  final assets = ref.watch(assetsConfigProvider);
  return assets.splashImagePath;
});

/// Provider for feature flags.
final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.featureFlags;
});

/// Provider for checking if Google Auth is enabled.
final isGoogleAuthEnabledProvider = Provider<bool>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return flags.enableGoogleAuth;
});

/// Provider for checking if team collaboration is enabled.
final isTeamCollaborationEnabledProvider = Provider<bool>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return flags.enableTeamCollaboration;
});

/// Provider for security limits.
final securityLimitsProvider = Provider<SecurityLimits>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.securityLimits;
});

/// Provider for max login attempts.
final maxLoginAttemptsProvider = Provider<int>((ref) {
  final limits = ref.watch(securityLimitsProvider);
  return limits.maxLoginAttempts;
});

/// Provider for OTP expiry duration.
final otpExpiryDurationProvider = Provider<Duration>((ref) {
  final limits = ref.watch(securityLimitsProvider);
  return limits.otpExpiry;
});

/// Provider for session timeout duration.
final sessionTimeoutProvider = Provider<Duration>((ref) {
  final limits = ref.watch(securityLimitsProvider);
  return limits.sessionTimeout;
});

/// Provider for backup configuration.
final backupConfigProvider = Provider<BackupConfig>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.backupConfig;
});

/// Provider for Google Auth configuration (from JSON).
final googleAuthConfigProvider = Provider<GoogleAuthConfig?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.googleAuthConfig;
});

/// Provider for configuration load error.
final configLoadErrorProvider = Provider<ConfigLoadError?>((ref) {
  final service = ref.watch(configServiceProvider);
  return service.loadError;
});

/// Provider for environment-specific configuration.
///
/// Combines values from .env file with JSON configuration.
final envConfigProvider = Provider<EnvConfig>((ref) {
  return EnvConfig();
});

/// Environment configuration from .env file.
///
/// Contains sensitive values that should not be in version control.
/// Safely handles cases where .env file is not available.
class EnvConfig {
  /// Safely get environment variable with fallback.
  String _getEnv(String key, [String defaultValue = '']) {
    try {
      if (!dotenv.isInitialized) return defaultValue;
      return dotenv.env[key] ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Firebase Configuration
  String get firebaseProjectId => _getEnv('FIREBASE_PROJECT_ID');
  String get firebaseApiKey => _getEnv('FIREBASE_API_KEY');
  String get firebaseAppId => _getEnv('FIREBASE_APP_ID');
  String get firebaseMessagingSenderId => _getEnv('FIREBASE_MESSAGING_SENDER_ID');
  String get firebaseAuthDomain => _getEnv('FIREBASE_AUTH_DOMAIN');

  // Cloudinary Configuration
  String get cloudinaryCloudName => _getEnv('CLOUDINARY_CLOUD_NAME');
  String get cloudinaryApiKey => _getEnv('CLOUDINARY_API_KEY');
  String get cloudinaryApiSecret => _getEnv('CLOUDINARY_API_SECRET');
  String get cloudinaryUploadPreset => _getEnv('CLOUDINARY_UPLOAD_PRESET');

  // Application Configuration
  String get appEnv => _getEnv('APP_ENV', 'development');
  bool get debugMode => _getEnv('DEBUG_MODE').toLowerCase() == 'true';
  String get appVersion => _getEnv('APP_VERSION', '1.0.0');

  // External Links
  String get privacyPolicyUrl => _getEnv('PRIVACY_POLICY_URL');
  String get termsOfServiceUrl => _getEnv('TERMS_OF_SERVICE_URL');
  String get supportWebsite => _getEnv('SUPPORT_WEBSITE');
  String get supportEmail => _getEnv('SUPPORT_EMAIL');

  // Legacy Azure Configuration (if needed)
  String get azureFunctionsBaseUrl => _getEnv('AZURE_FUNCTIONS_BASE_URL');
  String get azureCosmosEndpoint => _getEnv('AZURE_COSMOS_ENDPOINT');
  String get azureStorageConnectionString => _getEnv('AZURE_STORAGE_CONNECTION_STRING');

  /// Whether Firebase is properly configured via .env.
  bool get isFirebaseConfigured =>
      firebaseProjectId.isNotEmpty && firebaseApiKey.isNotEmpty;

  /// Whether Cloudinary is properly configured.
  bool get isCloudinaryConfigured =>
      cloudinaryCloudName.isNotEmpty && cloudinaryUploadPreset.isNotEmpty;

  /// Whether running in production environment.
  bool get isProduction => appEnv == 'production';

  /// Whether running in development environment.
  bool get isDevelopment => appEnv == 'development';
}

/// Initializes all configuration systems.
///
/// Call this at app startup before runApp().
/// Returns true if all configuration loaded successfully.
Future<bool> initializeConfig() async {
  // Load .env file
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file is optional - app can run without it using defaults
    debugPrint('[Config] Warning: .env file not found or failed to load: $e');
    debugPrint('[Config] App will continue with default/fallback values');
  }

  // Load JSON configuration
  final success = await _configService.load();

  return success;
}
