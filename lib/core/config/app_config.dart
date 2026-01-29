import 'package:flutter_dotenv/flutter_dotenv.dart';

export 'app_config_model.dart';
export 'config_provider.dart';
export 'config_service.dart';

/// Legacy AppConfig class for backward compatibility.
///
/// New code should use the providers from config_provider.dart instead:
/// - appConfigProvider for full configuration
/// - envConfigProvider for environment variables
/// - featureFlagsProvider for feature flags
///
/// This class is maintained for backward compatibility with existing code
/// that uses AppConfig.load() and static getters.
class AppConfig {
  /// Azure Functions base URL (legacy).
  static String get azureFunctionsBaseUrl =>
      dotenv.env['AZURE_FUNCTIONS_BASE_URL'] ?? '';

  /// Azure Cosmos endpoint (legacy).
  static String get azureCosmosEndpoint =>
      dotenv.env['AZURE_COSMOS_ENDPOINT'] ?? '';

  /// Azure Storage connection string (legacy).
  static String get azureStorageConnectionString =>
      dotenv.env['AZURE_STORAGE_CONNECTION_STRING'] ?? '';

  /// Firebase Project ID.
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  /// Firebase API Key.
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  /// Firebase App ID.
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  /// Cloudinary Cloud Name.
  static String get cloudinaryCloudName =>
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  /// Cloudinary Upload Preset.
  static String get cloudinaryUploadPreset =>
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  /// Current environment (development, staging, production).
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  /// Whether running in debug mode.
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  /// Privacy policy URL.
  static String get privacyPolicyUrl => dotenv.env['PRIVACY_POLICY_URL'] ?? '';

  /// Terms of service URL.
  static String get termsOfServiceUrl =>
      dotenv.env['TERMS_OF_SERVICE_URL'] ?? '';

  /// Support email.
  static String get supportEmail => dotenv.env['SUPPORT_EMAIL'] ?? '';

  /// Loads environment variables from .env file.
  ///
  /// Note: For full configuration including JSON config,
  /// use initializeConfig() from config_provider.dart instead.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // .env file is optional
    }
  }
}
