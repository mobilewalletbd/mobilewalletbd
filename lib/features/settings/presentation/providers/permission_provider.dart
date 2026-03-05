import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mobile_wallet/core/services/permission_service.dart';

/// State for permission management
class PermissionState {
  final bool isFirstLaunch;
  final bool cameraGranted;
  final bool contactsGranted;
  final bool notificationsGranted;
  final bool locationGranted;
  final bool isLoading;

  const PermissionState({
    required this.isFirstLaunch,
    required this.cameraGranted,
    required this.contactsGranted,
    required this.notificationsGranted,
    required this.locationGranted,
    required this.isLoading,
  });

  /// Initial state
  factory PermissionState.initial() => const PermissionState(
    isFirstLaunch: false,
    cameraGranted: false,
    contactsGranted: false,
    notificationsGranted: false,
    locationGranted: false,
    isLoading: false,
  );

  /// Copy with new values
  PermissionState copyWith({
    bool? isFirstLaunch,
    bool? cameraGranted,
    bool? contactsGranted,
    bool? notificationsGranted,
    bool? locationGranted,
    bool? isLoading,
  }) => PermissionState(
    isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    cameraGranted: cameraGranted ?? this.cameraGranted,
    contactsGranted: contactsGranted ?? this.contactsGranted,
    notificationsGranted: notificationsGranted ?? this.notificationsGranted,
    locationGranted: locationGranted ?? this.locationGranted,
    isLoading: isLoading ?? this.isLoading,
  );
}

/// Provider for permission management
final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>(
      (ref) => PermissionNotifier(),
    );

/// Notifier for handling permission logic
class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(PermissionState.initial());

  /// Initialize permission state
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      // Check if this is first launch (using storage permission as indicator)
      final isFirstLaunch = await PermissionService.isFirstLaunch();

      // Check current permission statuses
      final cameraStatus = await PermissionService.isCameraPermissionGranted();
      final contactsStatus =
          await PermissionService.isContactsPermissionGranted();
      final notificationsStatus =
          await PermissionService.isNotificationPermissionGranted();
      final locationStatus =
          await PermissionService.isLocationPermissionGranted();

      state = state.copyWith(
        isFirstLaunch: isFirstLaunch,
        cameraGranted: cameraStatus,
        contactsGranted: contactsStatus,
        notificationsGranted: notificationsStatus,
        locationGranted: locationStatus,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    state = state.copyWith(isLoading: true);
    try {
      final status = await PermissionService.requestCameraPermission();
      final granted = status.isGranted;
      state = state.copyWith(cameraGranted: granted, isLoading: false);
      return granted;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Request contacts permission
  Future<bool> requestContactsPermission() async {
    state = state.copyWith(isLoading: true);
    try {
      final status = await PermissionService.requestContactsPermission();
      final granted = status.isGranted;
      state = state.copyWith(contactsGranted: granted, isLoading: false);
      return granted;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    state = state.copyWith(isLoading: true);
    try {
      final status = await PermissionService.requestNotificationPermission();
      final granted = status.isGranted;
      state = state.copyWith(notificationsGranted: granted, isLoading: false);
      return granted;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    state = state.copyWith(isLoading: true);
    try {
      final status = await PermissionService.requestLocationPermission();
      final granted = status.isGranted;
      state = state.copyWith(locationGranted: granted, isLoading: false);
      return granted;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Request multiple permissions
  Future<void> requestMultiplePermissions({
    bool requestCamera = false,
    bool requestContacts = false,
    bool requestNotifications = false,
    bool requestLocation = false,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final permissions = <Permission>[];

      if (requestCamera) permissions.add(Permission.camera);
      if (requestContacts) permissions.add(Permission.contacts);
      if (requestNotifications) permissions.add(Permission.notification);
      if (requestLocation) permissions.add(Permission.location);

      if (permissions.isNotEmpty) {
        final results = await PermissionService.requestPermissions(permissions);

        state = state.copyWith(
          cameraGranted: requestCamera
              ? results[Permission.camera]?.isGranted ?? state.cameraGranted
              : state.cameraGranted,
          contactsGranted: requestContacts
              ? results[Permission.contacts]?.isGranted ?? state.contactsGranted
              : state.contactsGranted,
          notificationsGranted: requestNotifications
              ? results[Permission.notification]?.isGranted ??
                    state.notificationsGranted
              : state.notificationsGranted,
          locationGranted: requestLocation
              ? results[Permission.location]?.isGranted ?? state.locationGranted
              : state.locationGranted,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Mark first launch as completed
  Future<void> markFirstLaunchCompleted() async {
    await PermissionService.setFirstLaunchCompleted();
    state = state.copyWith(isFirstLaunch: false);
  }

  /// Reset to initial state
  void reset() {
    state = PermissionState.initial();
  }
}
