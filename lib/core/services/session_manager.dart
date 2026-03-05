// Session Manager for Smart Contact Wallet V1
// Handles user sessions, token management, and session persistence

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:mobile_wallet/core/utils/app_logger.dart';

/// Session manager that handles user authentication state and token management
/// Implements session persistence using flutter_secure_storage
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Session state
  User? _currentUser;
  String? _idToken;
  DateTime? _tokenExpiryTime;
  Timer? _tokenRefreshTimer;
  Timer? _sessionTimeoutTimer;

  // Session configuration
  static const Duration _tokenRefreshInterval = Duration(minutes: 50);
  static const Duration _sessionTimeout = Duration(hours: 24);
  static const Duration _inactivityTimeout = Duration(minutes: 30);

  // Storage keys
  static const String _keyUserId = 'session_user_id';
  static const String _keyIdToken = 'session_id_token';
  static const String _keyTokenExpiry = 'session_token_expiry';
  static const String _keyLastActive = 'session_last_active';
  static const String _keySessionStart = 'session_start_time';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyPinHash = 'pin_hash';

  // Session state stream
  final StreamController<SessionState> _sessionStateController =
      StreamController<SessionState>.broadcast();

  Stream<SessionState> get sessionStateStream => _sessionStateController.stream;

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================

  /// Initialize session manager and restore session if available
  Future<void> initialize() async {
    try {
      // Listen to Firebase auth state changes
      _auth.authStateChanges().listen(_handleAuthStateChange);

      // Restore session from storage
      await _restoreSession();

      AppLogger.info('Session Manager initialized', tag: 'SessionManager');
    } catch (e) {
      AppLogger.error(
        'Failed to initialize Session Manager',
        tag: 'SessionManager',
        error: e,
      );
      rethrow;
    }
  }

  /// Handle Firebase authentication state changes
  Future<void> _handleAuthStateChange(User? user) async {
    if (user != null) {
      _currentUser = user;
      await _updateSession(user);
    } else {
      await clearSession();
    }
  }

  // ==========================================================================
  // SESSION MANAGEMENT
  // ==========================================================================

  /// Start a new session for the authenticated user
  Future<void> startSession(User user) async {
    try {
      _currentUser = user;

      // Get and store ID token
      _idToken = await user.getIdToken();
      _tokenExpiryTime = DateTime.now().add(_tokenRefreshInterval);

      // Store session data
      await _secureStorage.write(key: _keyUserId, value: user.uid);
      await _secureStorage.write(key: _keyIdToken, value: _idToken);
      await _secureStorage.write(
        key: _keyTokenExpiry,
        value: _tokenExpiryTime!.toIso8601String(),
      );
      await _secureStorage.write(
        key: _keySessionStart,
        value: DateTime.now().toIso8601String(),
      );
      await _updateLastActive();

      // Store user in Isar
      await _storeUserInIsar(user);

      // Start token refresh timer
      _startTokenRefreshTimer();

      // Start session timeout timer
      _startSessionTimeoutTimer();

      // Emit session state
      _sessionStateController.add(SessionState.active);

      AppLogger.info(
        'Session started for user: ${user.uid}',
        tag: 'SessionManager',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to start session',
        tag: 'SessionManager',
        error: e,
      );
      _sessionStateController.add(SessionState.error);
      rethrow;
    }
  }

  /// Update existing session
  Future<void> _updateSession(User user) async {
    try {
      _currentUser = user;

      // Refresh ID token if needed
      if (_shouldRefreshToken()) {
        await refreshToken();
      }

      await _updateLastActive();
      _sessionStateController.add(SessionState.active);
    } catch (e) {
      AppLogger.error(
        'Failed to update session',
        tag: 'SessionManager',
        error: e,
      );
    }
  }

  /// Restore session from secure storage
  Future<void> _restoreSession() async {
    try {
      final userId = await _secureStorage.read(key: _keyUserId);
      final idToken = await _secureStorage.read(key: _keyIdToken);
      final tokenExpiryStr = await _secureStorage.read(key: _keyTokenExpiry);
      final lastActiveStr = await _secureStorage.read(key: _keyLastActive);

      if (userId == null || idToken == null) {
        _sessionStateController.add(SessionState.unauthenticated);
        return;
      }

      // Check if session has expired
      if (tokenExpiryStr != null) {
        final tokenExpiry = DateTime.parse(tokenExpiryStr);
        if (DateTime.now().isAfter(tokenExpiry.add(_sessionTimeout))) {
          await clearSession();
          _sessionStateController.add(SessionState.expired);
          return;
        }
      }

      // Check inactivity timeout
      if (lastActiveStr != null) {
        final lastActive = DateTime.parse(lastActiveStr);
        if (DateTime.now().difference(lastActive) > _inactivityTimeout) {
          await clearSession();
          _sessionStateController.add(SessionState.expired);
          return;
        }
      }

      // Restore session state
      _currentUser = _auth.currentUser;
      _idToken = idToken;
      _tokenExpiryTime = tokenExpiryStr != null
          ? DateTime.parse(tokenExpiryStr)
          : null;

      if (_currentUser != null) {
        await _updateLastActive();
        _startTokenRefreshTimer();
        _startSessionTimeoutTimer();
        _sessionStateController.add(SessionState.active);
        AppLogger.info(
          'Session restored for user: $userId',
          tag: 'SessionManager',
        );
      } else {
        await clearSession();
        _sessionStateController.add(SessionState.unauthenticated);
      }
    } catch (e) {
      AppLogger.error(
        'Failed to restore session',
        tag: 'SessionManager',
        error: e,
      );
      await clearSession();
      _sessionStateController.add(SessionState.unauthenticated);
    }
  }

  /// Clear the current session
  Future<void> clearSession() async {
    try {
      // Cancel timers
      _tokenRefreshTimer?.cancel();
      _sessionTimeoutTimer?.cancel();

      // Clear secure storage
      await _secureStorage.delete(key: _keyUserId);
      await _secureStorage.delete(key: _keyIdToken);
      await _secureStorage.delete(key: _keyTokenExpiry);
      await _secureStorage.delete(key: _keyLastActive);
      await _secureStorage.delete(key: _keySessionStart);

      // Clear state
      _currentUser = null;
      _idToken = null;
      _tokenExpiryTime = null;

      _sessionStateController.add(SessionState.unauthenticated);

      AppLogger.info('Session cleared', tag: 'SessionManager');
    } catch (e) {
      AppLogger.error(
        'Failed to clear session',
        tag: 'SessionManager',
        error: e,
      );
    }
  }

  // ==========================================================================
  // TOKEN MANAGEMENT
  // ==========================================================================

  /// Refresh the ID token
  Future<String?> refreshToken() async {
    try {
      if (_currentUser == null) {
        throw Exception('No user logged in');
      }

      // Force token refresh
      _idToken = await _currentUser!.getIdToken(true);
      _tokenExpiryTime = DateTime.now().add(_tokenRefreshInterval);

      // Update storage
      await _secureStorage.write(key: _keyIdToken, value: _idToken);
      await _secureStorage.write(
        key: _keyTokenExpiry,
        value: _tokenExpiryTime!.toIso8601String(),
      );

      AppLogger.info('Token refreshed', tag: 'SessionManager');
      return _idToken;
    } catch (e) {
      AppLogger.error(
        'Failed to refresh token',
        tag: 'SessionManager',
        error: e,
      );
      return null;
    }
  }

  /// Get current ID token (refreshes if needed)
  Future<String?> getIdToken() async {
    if (_shouldRefreshToken()) {
      return await refreshToken();
    }
    return _idToken;
  }

  /// Check if token should be refreshed
  bool _shouldRefreshToken() {
    if (_tokenExpiryTime == null) return true;

    // Refresh if token expires in less than 5 minutes
    return DateTime.now().isAfter(
      _tokenExpiryTime!.subtract(const Duration(minutes: 5)),
    );
  }

  /// Validate current token
  Future<bool> validateToken() async {
    try {
      final token = await getIdToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ==========================================================================
  // AUTO-REFRESH & TIMEOUT
  // ==========================================================================

  /// Start automatic token refresh timer
  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();

    _tokenRefreshTimer = Timer.periodic(_tokenRefreshInterval, (timer) async {
      await refreshToken();
    });
  }

  /// Start session timeout timer
  void _startSessionTimeoutTimer() {
    _sessionTimeoutTimer?.cancel();

    _sessionTimeoutTimer = Timer(_sessionTimeout, () async {
      await logout(reason: 'Session timeout');
    });
  }

  // ==========================================================================
  // ACTIVITY TRACKING
  // ==========================================================================

  /// Update last active timestamp
  Future<void> _updateLastActive() async {
    await _secureStorage.write(
      key: _keyLastActive,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// Record user activity (call this on user interactions)
  Future<void> recordActivity() async {
    await _updateLastActive();

    // Restart session timeout timer
    if (_sessionTimeoutTimer != null && _sessionTimeoutTimer!.isActive) {
      _startSessionTimeoutTimer();
    }
  }

  /// Check if session is inactive
  Future<bool> isSessionInactive() async {
    try {
      final lastActiveStr = await _secureStorage.read(key: _keyLastActive);
      if (lastActiveStr == null) return true;

      final lastActive = DateTime.parse(lastActiveStr);
      return DateTime.now().difference(lastActive) > _inactivityTimeout;
    } catch (e) {
      return true;
    }
  }

  // ==========================================================================
  // SESSION INFO
  // ==========================================================================

  /// Get current user
  User? get currentUser => _currentUser;

  /// Get current user ID
  String? get userId => _currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Get session duration
  Future<Duration?> getSessionDuration() async {
    try {
      final sessionStartStr = await _secureStorage.read(key: _keySessionStart);
      if (sessionStartStr == null) return null;

      final sessionStart = DateTime.parse(sessionStartStr);
      return DateTime.now().difference(sessionStart);
    } catch (e) {
      return null;
    }
  }

  // ==========================================================================
  // BIOMETRIC & PIN
  // ==========================================================================

  /// Check if biometric authentication is enabled
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  /// Enable biometric authentication
  Future<void> enableBiometric() async {
    await _secureStorage.write(key: _keyBiometricEnabled, value: 'true');
  }

  /// Disable biometric authentication
  Future<void> disableBiometric() async {
    await _secureStorage.write(key: _keyBiometricEnabled, value: 'false');
  }

  /// Store PIN hash
  Future<void> storePinHash(String pinHash) async {
    await _secureStorage.write(key: _keyPinHash, value: pinHash);
  }

  /// Get PIN hash
  Future<String?> getPinHash() async {
    return await _secureStorage.read(key: _keyPinHash);
  }

  /// Clear PIN
  Future<void> clearPin() async {
    await _secureStorage.delete(key: _keyPinHash);
  }

  // ==========================================================================
  // LOGOUT
  // ==========================================================================

  /// Logout user and clear session
  Future<void> logout({String? reason}) async {
    try {
      await clearSession();
      await _auth.signOut();

      _sessionStateController.add(SessionState.unauthenticated);

      AppLogger.info(
        'User logged out${reason != null ? ": $reason" : ""}',
        tag: 'SessionManager',
      );
    } catch (e) {
      AppLogger.error('Failed to logout', tag: 'SessionManager', error: e);
      rethrow;
    }
  }

  // ==========================================================================
  // ISAR INTEGRATION
  // ==========================================================================

  /// Store authenticated user in Isar
  Future<void> _storeUserInIsar(User user) async {
    try {
      final isar = IsarService.instance;

      final authUser = AuthUserIsar()
        ..uid = user.uid
        ..email = user.email
        ..phoneNumber = user.phoneNumber
        ..displayName = user.displayName
        ..photoUrl = user.photoURL
        ..emailVerified = user.emailVerified
        ..lastSignIn = DateTime.now()
        ..provider = _getProviderString(user)
        ..isAnonymous = user.isAnonymous
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.authUserIsars.put(authUser);
      });

      AppLogger.info('User stored in Isar: ${user.uid}', tag: 'SessionManager');
    } catch (e) {
      AppLogger.error(
        'Failed to store user in Isar',
        tag: 'SessionManager',
        error: e,
      );
    }
  }

  /// Get provider string from user
  String _getProviderString(User user) {
    if (user.providerData.isEmpty) return 'unknown';

    final providerId = user.providerData.first.providerId;
    if (providerId.contains('google')) return 'google';
    if (providerId.contains('phone')) return 'phone';
    if (providerId.contains('password')) return 'email';
    if (providerId.contains('apple')) return 'apple';

    return providerId;
  }

  // ==========================================================================
  // CLEANUP
  // ==========================================================================

  /// Dispose resources
  void dispose() {
    _tokenRefreshTimer?.cancel();
    _sessionTimeoutTimer?.cancel();
    _sessionStateController.close();
  }
}

/// Session state enum
enum SessionState { unauthenticated, active, expired, error }
