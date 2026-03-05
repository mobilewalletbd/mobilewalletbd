// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthenticatedHash() => r'21fedda6b988820a5c5898d320e3306579c40cf2';

/// Provider for checking if user is authenticated
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$currentUserHash() => r'6965766be49fbddd721beec84ccbe0f8d58c7093';

/// Provider for getting current user (non-null assertion)
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<AuthUser?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = AutoDisposeProviderRef<AuthUser?>;
String _$isAuthLoadingHash() => r'5439b958692e6835054b29f0db312b87ff183b5e';

/// Provider for authentication loading state
///
/// Copied from [isAuthLoading].
@ProviderFor(isAuthLoading)
final isAuthLoadingProvider = AutoDisposeProvider<bool>.internal(
  isAuthLoading,
  name: r'isAuthLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthLoadingRef = AutoDisposeProviderRef<bool>;
String _$authErrorHash() => r'de47dc2aaa330a9ee7faf55dd2d61dbdd6dd92fa';

/// Provider for authentication error
///
/// Copied from [authError].
@ProviderFor(authError)
final authErrorProvider = AutoDisposeProvider<Object?>.internal(
  authError,
  name: r'authErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthErrorRef = AutoDisposeProviderRef<Object?>;
String _$authenticationHash() => r'51cca8fd2da151a8857e09c130991e01720be913';

/// Authentication state provider using Riverpod.
///
/// Manages the authentication state and provides methods for
/// all authentication operations. Uses AsyncNotifier pattern
/// for handling loading, success, and error states.
///
/// Copied from [Authentication].
@ProviderFor(Authentication)
final authenticationProvider =
    StreamNotifierProvider<Authentication, AuthUser?>.internal(
  Authentication.new,
  name: r'authenticationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authenticationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Authentication = StreamNotifier<AuthUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
