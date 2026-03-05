// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasContactsPermissionHash() =>
    r'360132870c85b3799f650ce354c6dae35e5bca17';

/// Provider to check if contacts permission is granted
///
/// Copied from [hasContactsPermission].
@ProviderFor(hasContactsPermission)
final hasContactsPermissionProvider = AutoDisposeFutureProvider<bool>.internal(
  hasContactsPermission,
  name: r'hasContactsPermissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasContactsPermissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasContactsPermissionRef = AutoDisposeFutureProviderRef<bool>;
String _$phoneContactImportNotifierHash() =>
    r'fb0c87c781bb85e7b4928c16dcfc0f0a5eb706e9';

/// Provider for managing phone contact import
///
/// Copied from [PhoneContactImportNotifier].
@ProviderFor(PhoneContactImportNotifier)
final phoneContactImportNotifierProvider = AutoDisposeNotifierProvider<
    PhoneContactImportNotifier, ImportState>.internal(
  PhoneContactImportNotifier.new,
  name: r'phoneContactImportNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$phoneContactImportNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PhoneContactImportNotifier = AutoDisposeNotifier<ImportState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
