// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cameraListHash() => r'c3c6a7c12d14e023e260f4a48b7d2bf20d444f93';

/// Provider for available cameras
///
/// Copied from [cameraList].
@ProviderFor(cameraList)
final cameraListProvider =
    AutoDisposeFutureProvider<List<CameraDescription>>.internal(
  cameraList,
  name: r'cameraListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cameraListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CameraListRef = AutoDisposeFutureProviderRef<List<CameraDescription>>;
String _$scanNotifierHash() => r'0144d76edc0ee4eedbe46a2f705d573b6fc7ecfc';

/// Provider for managing scan state
///
/// Copied from [ScanNotifier].
@ProviderFor(ScanNotifier)
final scanNotifierProvider =
    AutoDisposeNotifierProvider<ScanNotifier, ScanState>.internal(
  ScanNotifier.new,
  name: r'scanNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScanNotifier = AutoDisposeNotifier<ScanState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
