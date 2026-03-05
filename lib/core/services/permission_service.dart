import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for managing app permissions
class PermissionService {
  static const String _firstLaunchKey = 'first_launch_completed';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Check if this is the first launch of the app
  static Future<bool> isFirstLaunch() async {
    final value = await _storage.read(key: _firstLaunchKey);
    return value != 'true';
  }

  /// Mark first launch as completed
  static Future<void> setFirstLaunchCompleted() async {
    await _storage.write(key: _firstLaunchKey, value: 'true');
  }

  /// Request camera permission
  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  /// Request contacts permission
  static Future<PermissionStatus> requestContactsPermission() async {
    return await Permission.contacts.request();
  }

  /// Request notification permission
  static Future<PermissionStatus> requestNotificationPermission() async {
    return await Permission.notification.request();
  }

  /// Request location permission
  static Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if contacts permission is granted
  static Future<bool> isContactsPermissionGranted() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  /// Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Open app settings to allow user to grant permissions
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Get status of multiple permissions
  static Future<Map<Permission, PermissionStatus>> getPermissionsStatus(
    List<Permission> permissions,
  ) async {
    final Map<Permission, PermissionStatus> result = {};
    for (final permission in permissions) {
      result[permission] = await permission.status;
    }
    return result;
  }
}
