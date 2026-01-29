import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_config_model.dart';

/// Service for loading and managing application configuration.
///
/// Loads configuration from assets/config/required_info.json and provides
/// validated access to configuration values. Handles errors gracefully
/// with fallback to default values.
class ConfigService {
  static const String _configPath = 'assets/config/required_info.json';

  AppConfigModel? _config;
  ConfigLoadError? _loadError;
  bool _isLoaded = false;

  /// Whether the configuration has been loaded.
  bool get isLoaded => _isLoaded;

  /// The loaded configuration, or defaults if loading failed.
  AppConfigModel get config => _config ?? AppConfigModel.defaults();

  /// Any error that occurred during loading.
  ConfigLoadError? get loadError => _loadError;

  /// Whether the configuration loaded successfully without errors.
  bool get hasError => _loadError != null;

  /// Loads configuration from the JSON file.
  ///
  /// Returns true if configuration was loaded successfully, false otherwise.
  /// On failure, default configuration values are used.
  Future<bool> load() async {
    if (_isLoaded) return !hasError;

    try {
      final jsonString = await rootBundle.loadString(_configPath);
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      _config = _parseConfig(jsonMap);
      _validateConfig(_config!);

      _isLoaded = true;
      _loadError = null;

      if (kDebugMode) {
        print('[ConfigService] Configuration loaded successfully');
        print(
          '[ConfigService] App: ${_config!.appMetadata.appName} v${_config!.appMetadata.version}',
        );
      }

      return true;
    } on FormatException catch (e) {
      _loadError = ConfigLoadError(
        type: ConfigErrorType.malformedJson,
        message: 'Configuration file contains invalid JSON: ${e.message}',
        originalError: e,
      );
    } on FlutterError catch (e) {
      _loadError = ConfigLoadError(
        type: ConfigErrorType.fileNotFound,
        message: 'Configuration file not found at $_configPath',
        originalError: e,
      );
    } catch (e) {
      _loadError = ConfigLoadError(
        type: ConfigErrorType.unknown,
        message: 'Failed to load configuration: $e',
        originalError: e,
      );
    }

    // Use defaults on error
    _config = AppConfigModel.defaults();
    _isLoaded = true;

    if (kDebugMode) {
      print(
        '[ConfigService] Error loading configuration: ${_loadError?.message}',
      );
      print('[ConfigService] Using default configuration');
    }

    return false;
  }

  /// Parses the JSON map into AppConfigModel.
  AppConfigModel _parseConfig(Map<String, dynamic> json) {
    return AppConfigModel(
      appMetadata: json['APP_METADATA'] != null
          ? AppMetadata.fromJson(json['APP_METADATA'] as Map<String, dynamic>)
          : AppMetadata.defaults(),
      designSystem: json['DESIGN_SYSTEM'] != null
          ? DesignSystem.fromJson(json['DESIGN_SYSTEM'] as Map<String, dynamic>)
          : DesignSystem.defaults(),
      assetsConfig: json['ASSETS_CONFIG'] != null
          ? AssetsConfig.fromJson(json['ASSETS_CONFIG'] as Map<String, dynamic>)
          : AssetsConfig.defaults(),
      featureFlags: json['FEATURE_FLAGS_V1'] != null
          ? FeatureFlags.fromJson(
              json['FEATURE_FLAGS_V1'] as Map<String, dynamic>,
            )
          : FeatureFlags.defaults(),
      securityLimits: json['SECURITY_LIMITS'] != null
          ? SecurityLimits.fromJson(
              json['SECURITY_LIMITS'] as Map<String, dynamic>,
            )
          : SecurityLimits.defaults(),
      backupConfig: json['BACKUP_CONFIG'] != null
          ? BackupConfig.fromJson(json['BACKUP_CONFIG'] as Map<String, dynamic>)
          : BackupConfig.defaults(),
      supabaseConfig: json['SUPABASE_CONFIG'] != null
          ? SupabaseConfig.fromJson(
              json['SUPABASE_CONFIG'] as Map<String, dynamic>,
            )
          : null,
      googleAuthConfig: json['GOOGLE_AUTH_CONFIG'] != null
          ? GoogleAuthConfig.fromJson(
              json['GOOGLE_AUTH_CONFIG'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Validates the loaded configuration.
  void _validateConfig(AppConfigModel config) {
    final errors = <String>[];

    // Validate app metadata
    if (config.appMetadata.appName.isEmpty) {
      errors.add('APP_NAME is required');
    }
    if (config.appMetadata.version.isEmpty) {
      errors.add('VERSION is required');
    }
    if (config.appMetadata.supportedLocales.isEmpty) {
      errors.add('SUPPORTED_LOCALES must have at least one locale');
    }

    // Validate design system
    if (config.designSystem.fontFamily.isEmpty) {
      errors.add('FONT_FAMILY is required');
    }
    if (!_isValidHexColor(config.designSystem.colors.primary)) {
      errors.add('Invalid PRIMARY color format');
    }
    if (!_isValidHexColor(config.designSystem.colors.secondary)) {
      errors.add('Invalid SECONDARY color format');
    }
    if (!_isValidHexColor(config.designSystem.colors.error)) {
      errors.add('Invalid ERROR color format');
    }

    // Validate security limits
    if (config.securityLimits.maxLoginAttempts < 1) {
      errors.add('MAX_LOGIN_ATTEMPTS must be at least 1');
    }
    if (config.securityLimits.otpExpirySeconds < 30) {
      errors.add('OTP_EXPIRY_SECONDS must be at least 30');
    }
    if (config.securityLimits.sessionTimeoutMinutes < 1) {
      errors.add('SESSION_TIMEOUT_MINUTES must be at least 1');
    }

    if (errors.isNotEmpty) {
      if (kDebugMode) {
        print('[ConfigService] Validation warnings:');
        for (final error in errors) {
          print('  - $error');
        }
      }
    }
  }

  /// Validates hex color format.
  bool _isValidHexColor(String color) {
    final regex = RegExp(r'^#?([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$');
    return regex.hasMatch(color);
  }

  /// Gets a specific feature flag value.
  bool getFeatureFlag(String flagName) {
    switch (flagName) {
      case 'ENABLE_MOCK_WALLET':
        return config.featureFlags.enableMockWallet;
      case 'ENABLE_TEAM_COLLABORATION':
        return config.featureFlags.enableTeamCollaboration;
      case 'ENABLE_GOOGLE_AUTH':
        return config.featureFlags.enableGoogleAuth;
      case 'ENABLE_FACEBOOK_AUTH':
        return config.featureFlags.enableFacebookAuth;
      case 'ENABLE_DATA_EXPORT':
        return config.featureFlags.enableDataExport;
      case 'ENABLE_AI_FRAUD_ALERTS':
        return config.featureFlags.enableAiFraudAlerts;
      case 'ENABLE_GLOBAL_SYNC':
        return config.featureFlags.enableGlobalSync;
      case 'ENABLE_MFS_DETECTION':
        return config.featureFlags.enableMfsDetection;
      default:
        return false;
    }
  }
}

/// Types of configuration loading errors.
enum ConfigErrorType { fileNotFound, malformedJson, validationFailed, unknown }

/// Configuration loading error.
class ConfigLoadError {
  final ConfigErrorType type;
  final String message;
  final dynamic originalError;

  const ConfigLoadError({
    required this.type,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'ConfigLoadError: $message (type: $type)';
}
