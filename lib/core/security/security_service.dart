// Security Service for Smart Contact Wallet V1
// Handles encryption, biometric authentication, and PIN protection

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:mobile_wallet/core/utils/app_logger.dart';

/// Security service that provides encryption, biometric auth, and PIN protection
class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  final LocalAuthentication _localAuth = LocalAuthentication();

  // Encryption configuration
  late encrypt.Key _encryptionKey;
  late encrypt.IV _iv;
  bool _isInitialized = false;

  // Storage keys
  static const String _keyEncryptionKey = 'security_encryption_key';
  static const String _keyEncryptionIV = 'security_encryption_iv';
  static const String _keyBiometricEnabled = 'security_biometric_enabled';
  static const String _keyPinHash = 'security_pin_hash';
  static const String _keyPinSalt = 'security_pin_salt';
  static const String _keyFailedAttempts = 'security_failed_attempts';
  static const String _keyLockoutUntil = 'security_lockout_until';

  // Security configuration
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 15);

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================

  /// Initialize security service
  Future<void> initialize() async {
    try {
      // Load or generate encryption key
      await _initializeEncryption();

      _isInitialized = true;
      AppLogger.info('Security Service initialized', tag: 'SecurityService');
    } catch (e) {
      AppLogger.error(
        'Failed to initialize Security Service',
        tag: 'SecurityService',
        error: e,
      );
      rethrow;
    }
  }

  /// Initialize encryption keys
  Future<void> _initializeEncryption() async {
    try {
      // Try to load existing key
      final keyString = await _secureStorage.read(key: _keyEncryptionKey);
      final ivString = await _secureStorage.read(key: _keyEncryptionIV);

      if (keyString != null && ivString != null) {
        // Use existing keys
        _encryptionKey = encrypt.Key.fromBase64(keyString);
        _iv = encrypt.IV.fromBase64(ivString);
      } else {
        // Generate new keys
        _encryptionKey = encrypt.Key.fromSecureRandom(32);
        _iv = encrypt.IV.fromSecureRandom(16);

        // Store keys
        await _secureStorage.write(
          key: _keyEncryptionKey,
          value: _encryptionKey.base64,
        );
        await _secureStorage.write(key: _keyEncryptionIV, value: _iv.base64);
      }
    } catch (e) {
      AppLogger.error(
        'Failed to initialize encryption',
        tag: 'SecurityService',
        error: e,
      );
      rethrow;
    }
  }

  /// Ensure service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception(
        'SecurityService not initialized. Call initialize() first.',
      );
    }
  }

  // ==========================================================================
  // ENCRYPTION / DECRYPTION
  // ==========================================================================

  /// Encrypt sensitive data
  String encryptData(String plainText) {
    _ensureInitialized();

    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
      final encrypted = encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      AppLogger.error(
        'Failed to encrypt data',
        tag: 'SecurityService',
        error: e,
      );
      rethrow;
    }
  }

  /// Decrypt encrypted data
  String decryptData(String encryptedText) {
    _ensureInitialized();

    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      AppLogger.error(
        'Failed to decrypt data',
        tag: 'SecurityService',
        error: e,
      );
      rethrow;
    }
  }

  /// Encrypt and store sensitive data
  Future<void> encryptAndStore(String key, String value) async {
    _ensureInitialized();

    try {
      final encrypted = encryptData(value);
      await _secureStorage.write(key: key, value: encrypted);
    } catch (e) {
      AppLogger.error(
        'Failed to encrypt and store',
        tag: 'SecurityService',
        error: e,
      );
      rethrow;
    }
  }

  /// Retrieve and decrypt sensitive data
  Future<String?> retrieveAndDecrypt(String key) async {
    _ensureInitialized();

    try {
      final encrypted = await _secureStorage.read(key: key);
      if (encrypted == null) return null;

      return decryptData(encrypted);
    } catch (e) {
      AppLogger.error(
        'Failed to retrieve and decrypt',
        tag: 'SecurityService',
        error: e,
      );
      return null;
    }
  }

  // ==========================================================================
  // HASHING
  // ==========================================================================

  /// Generate cryptographic hash (for passwords, PINs)
  String generateHash(String input, {String? salt}) {
    salt ??= _generateSalt();
    final bytes = utf8.encode(input + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate random salt
  String _generateSalt() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return generateHash(random);
  }

  /// Verify hash
  bool verifyHash(String input, String hash, String salt) {
    final inputHash = generateHash(input, salt: salt);
    return inputHash == hash;
  }

  // ==========================================================================
  // BIOMETRIC AUTHENTICATION
  // ==========================================================================

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      AppLogger.error(
        'Failed to check biometric availability',
        tag: 'SecurityService',
        error: e,
      );
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      AppLogger.error(
        'Failed to get available biometrics',
        tag: 'SecurityService',
        error: e,
      );
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        AppLogger.warn(
          'Biometric authentication not available',
          tag: 'SecurityService',
        );
        return false;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return authenticated;
    } on PlatformException catch (e) {
      AppLogger.error(
        'Biometric authentication error',
        tag: 'SecurityService',
        error: e.message,
      );
      return false;
    } catch (e) {
      AppLogger.error(
        'Failed to authenticate with biometrics',
        tag: 'SecurityService',
        error: e,
      );
      return false;
    }
  }

  /// Check if biometric is enabled by user
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  /// Enable biometric authentication
  Future<void> enableBiometric() async {
    // Verify biometric first
    final authenticated = await authenticateWithBiometrics(
      reason: 'Authenticate to enable biometric login',
    );

    if (authenticated) {
      await _secureStorage.write(key: _keyBiometricEnabled, value: 'true');
      AppLogger.info(
        'Biometric authentication enabled',
        tag: 'SecurityService',
      );
    } else {
      throw Exception('Biometric authentication failed');
    }
  }

  /// Disable biometric authentication
  Future<void> disableBiometric() async {
    await _secureStorage.write(key: _keyBiometricEnabled, value: 'false');
    AppLogger.info('Biometric authentication disabled', tag: 'SecurityService');
  }

  // ==========================================================================
  // PIN PROTECTION
  // ==========================================================================

  /// Set up PIN
  Future<void> setupPin(String pin) async {
    if (pin.length < 4 || pin.length > 6) {
      throw ArgumentError('PIN must be 4-6 digits');
    }

    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw ArgumentError('PIN must contain only digits');
    }

    try {
      // Generate salt
      final salt = _generateSalt();

      // Hash PIN
      final pinHash = generateHash(pin, salt: salt);

      // Store hash and salt
      await _secureStorage.write(key: _keyPinHash, value: pinHash);
      await _secureStorage.write(key: _keyPinSalt, value: salt);

      // Reset failed attempts
      await _secureStorage.delete(key: _keyFailedAttempts);
      await _secureStorage.delete(key: _keyLockoutUntil);

      AppLogger.info('PIN set up successfully', tag: 'SecurityService');
    } catch (e) {
      AppLogger.error('Failed to setup PIN', tag: 'SecurityService', error: e);
      rethrow;
    }
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    try {
      // Check if account is locked
      if (await isAccountLocked()) {
        final lockoutUntil = await getLockoutEndTime();
        if (lockoutUntil != null) {
          final remaining = lockoutUntil.difference(DateTime.now());
          throw Exception(
            'Account locked. Try again in ${remaining.inMinutes} minutes.',
          );
        }
      }

      // Get stored hash and salt
      final storedHash = await _secureStorage.read(key: _keyPinHash);
      final salt = await _secureStorage.read(key: _keyPinSalt);

      if (storedHash == null || salt == null) {
        throw Exception('PIN not set up');
      }

      // Verify PIN
      final isValid = verifyHash(pin, storedHash, salt);

      if (isValid) {
        // Reset failed attempts on success
        await _secureStorage.delete(key: _keyFailedAttempts);
        await _secureStorage.delete(key: _keyLockoutUntil);
        AppLogger.info('PIN verified successfully', tag: 'SecurityService');
        return true;
      } else {
        // Increment failed attempts
        await _incrementFailedAttempts();
        AppLogger.warn('Invalid PIN', tag: 'SecurityService');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to verify PIN', tag: 'SecurityService', error: e);
      rethrow;
    }
  }

  /// Change PIN
  Future<void> changePin(String oldPin, String newPin) async {
    // Verify old PIN
    final isValid = await verifyPin(oldPin);
    if (!isValid) {
      throw Exception('Invalid current PIN');
    }

    // Set new PIN
    await setupPin(newPin);
  }

  /// Remove PIN
  Future<void> removePin(String currentPin) async {
    // Verify current PIN
    final isValid = await verifyPin(currentPin);
    if (!isValid) {
      throw Exception('Invalid PIN');
    }

    // Remove PIN data
    await _secureStorage.delete(key: _keyPinHash);
    await _secureStorage.delete(key: _keyPinSalt);
    await _secureStorage.delete(key: _keyFailedAttempts);
    await _secureStorage.delete(key: _keyLockoutUntil);

    AppLogger.info('PIN removed', tag: 'SecurityService');
  }

  /// Check if PIN is set up
  Future<bool> isPinSetup() async {
    final pinHash = await _secureStorage.read(key: _keyPinHash);
    return pinHash != null;
  }

  // ==========================================================================
  // ACCOUNT LOCKOUT
  // ==========================================================================

  /// Increment failed login attempts
  Future<void> _incrementFailedAttempts() async {
    try {
      final attemptsStr = await _secureStorage.read(key: _keyFailedAttempts);
      final attempts = attemptsStr != null ? int.parse(attemptsStr) : 0;
      final newAttempts = attempts + 1;

      await _secureStorage.write(
        key: _keyFailedAttempts,
        value: newAttempts.toString(),
      );

      // Lock account if max attempts reached
      if (newAttempts >= _maxFailedAttempts) {
        final lockoutUntil = DateTime.now().add(_lockoutDuration);
        await _secureStorage.write(
          key: _keyLockoutUntil,
          value: lockoutUntil.toIso8601String(),
        );
        AppLogger.info(
          'Account locked until: $lockoutUntil',
          tag: 'SecurityService',
        );
      }
    } catch (e) {
      AppLogger.error(
        'Failed to increment failed attempts',
        tag: 'SecurityService',
        error: e,
      );
    }
  }

  /// Get failed attempts count
  Future<int> getFailedAttempts() async {
    final attemptsStr = await _secureStorage.read(key: _keyFailedAttempts);
    return attemptsStr != null ? int.parse(attemptsStr) : 0;
  }

  /// Check if account is locked
  Future<bool> isAccountLocked() async {
    try {
      final lockoutUntilStr = await _secureStorage.read(key: _keyLockoutUntil);
      if (lockoutUntilStr == null) return false;

      final lockoutUntil = DateTime.parse(lockoutUntilStr);
      final isLocked = DateTime.now().isBefore(lockoutUntil);

      // Clear lockout if time has passed
      if (!isLocked) {
        await _secureStorage.delete(key: _keyLockoutUntil);
        await _secureStorage.delete(key: _keyFailedAttempts);
      }

      return isLocked;
    } catch (e) {
      return false;
    }
  }

  /// Get lockout end time
  Future<DateTime?> getLockoutEndTime() async {
    try {
      final lockoutUntilStr = await _secureStorage.read(key: _keyLockoutUntil);
      if (lockoutUntilStr == null) return null;

      return DateTime.parse(lockoutUntilStr);
    } catch (e) {
      return null;
    }
  }

  /// Get remaining lockout time
  Future<Duration?> getRemainingLockoutTime() async {
    final lockoutUntil = await getLockoutEndTime();
    if (lockoutUntil == null) return null;

    final now = DateTime.now();
    if (now.isAfter(lockoutUntil)) return null;

    return lockoutUntil.difference(now);
  }

  // ==========================================================================
  // SECURE DATA STORAGE
  // ==========================================================================

  /// Store sensitive data securely
  Future<void> storeSecureData(String key, String value) async {
    await encryptAndStore(key, value);
  }

  /// Retrieve sensitive data
  Future<String?> getSecureData(String key) async {
    return await retrieveAndDecrypt(key);
  }

  /// Delete sensitive data
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Clear all sensitive data
  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
    AppLogger.info('All secure data cleared', tag: 'SecurityService');
  }

  // ==========================================================================
  // TOKEN SECURITY
  // ==========================================================================

  /// Store authentication token securely
  Future<void> storeAuthToken(String token) async {
    await encryptAndStore('auth_token', token);
  }

  /// Retrieve authentication token
  Future<String?> getAuthToken() async {
    return await retrieveAndDecrypt('auth_token');
  }

  /// Clear authentication token
  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  /// Store refresh token
  Future<void> storeRefreshToken(String token) async {
    await encryptAndStore('refresh_token', token);
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await retrieveAndDecrypt('refresh_token');
  }

  // ==========================================================================
  // VALIDATION
  // ==========================================================================

  /// Validate PIN format
  bool isValidPinFormat(String pin) {
    if (pin.length < 4 || pin.length > 6) return false;
    return RegExp(r'^\d+$').hasMatch(pin);
  }

  /// Check PIN strength (simple check for common patterns)
  PinStrength checkPinStrength(String pin) {
    if (!isValidPinFormat(pin)) return PinStrength.invalid;

    // Check for common patterns
    if (pin == '0000' ||
        pin == '1111' ||
        pin == '1234' ||
        pin == '4321' ||
        pin == '0123') {
      return PinStrength.weak;
    }

    // Check for sequential numbers
    final isSequential = _isSequentialPin(pin);
    if (isSequential) return PinStrength.weak;

    // Check for repeated digits
    final hasRepeatedDigits = _hasRepeatedDigits(pin);
    if (hasRepeatedDigits) return PinStrength.medium;

    return PinStrength.strong;
  }

  /// Check if PIN has sequential digits
  bool _isSequentialPin(String pin) {
    for (int i = 0; i < pin.length - 1; i++) {
      final current = int.parse(pin[i]);
      final next = int.parse(pin[i + 1]);
      if ((next - current).abs() != 1) return false;
    }
    return true;
  }

  /// Check if PIN has repeated digits
  bool _hasRepeatedDigits(String pin) {
    final uniqueDigits = pin.split('').toSet().length;
    return uniqueDigits < pin.length;
  }

  // ==========================================================================
  // CLEANUP
  // ==========================================================================

  /// Reset security service (use with caution!)
  Future<void> reset() async {
    await clearAllSecureData();
    _isInitialized = false;
    AppLogger.warn('Security Service reset', tag: 'SecurityService');
  }
}

/// PIN strength levels
enum PinStrength { invalid, weak, medium, strong }
