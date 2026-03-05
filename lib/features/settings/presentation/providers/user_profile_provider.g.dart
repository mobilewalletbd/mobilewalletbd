// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasProfileHash() => r'7f24d3d5e05d9d6f1f585f7bf23539d4002c2996';

/// Provider for checking if profile exists
///
/// Copied from [hasProfile].
@ProviderFor(hasProfile)
final hasProfileProvider = AutoDisposeProvider<bool>.internal(
  hasProfile,
  name: r'hasProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasProfileRef = AutoDisposeProviderRef<bool>;
String _$isProfileLoadingHash() => r'f8390745f8ba1d42b4e4f9110099f922dffb1ffe';

/// Provider for profile loading state
///
/// Copied from [isProfileLoading].
@ProviderFor(isProfileLoading)
final isProfileLoadingProvider = AutoDisposeProvider<bool>.internal(
  isProfileLoading,
  name: r'isProfileLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isProfileLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsProfileLoadingRef = AutoDisposeProviderRef<bool>;
String _$displayNameHash() => r'4e299cfcccc60ab78308ea0c4039b1d1a29938d1';

/// Provider for user's display name
///
/// Copied from [displayName].
@ProviderFor(displayName)
final displayNameProvider = AutoDisposeProvider<String>.internal(
  displayName,
  name: r'displayNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$displayNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DisplayNameRef = AutoDisposeProviderRef<String>;
String _$avatarUrlHash() => r'0b1724470cba8bfd8ba15c7e4faf05c851d11eef';

/// Provider for user's avatar URL
///
/// Copied from [avatarUrl].
@ProviderFor(avatarUrl)
final avatarUrlProvider = AutoDisposeProvider<String?>.internal(
  avatarUrl,
  name: r'avatarUrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$avatarUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvatarUrlRef = AutoDisposeProviderRef<String?>;
String _$userInitialsHash() => r'598bf621d635f26b3d77e93d530d6e49d086340d';

/// Provider for user's initials (for avatar fallback)
///
/// Copied from [userInitials].
@ProviderFor(userInitials)
final userInitialsProvider = AutoDisposeProvider<String>.internal(
  userInitials,
  name: r'userInitialsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userInitialsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserInitialsRef = AutoDisposeProviderRef<String>;
String _$userPreferencesHash() => r'1efc06e60916924f3219d458fb5ec9b89e34eee1';

/// Provider for user preferences
///
/// Copied from [userPreferences].
@ProviderFor(userPreferences)
final userPreferencesProvider =
    AutoDisposeProvider<Map<String, dynamic>>.internal(
  userPreferences,
  name: r'userPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserPreferencesRef = AutoDisposeProviderRef<Map<String, dynamic>>;
String _$preferredThemeHash() => r'11e7579eae9d47cedc33a214d07bb75a6229ce65';

/// Provider for preferred theme
///
/// Copied from [preferredTheme].
@ProviderFor(preferredTheme)
final preferredThemeProvider = AutoDisposeProvider<String>.internal(
  preferredTheme,
  name: r'preferredThemeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$preferredThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PreferredThemeRef = AutoDisposeProviderRef<String>;
String _$preferredLanguageHash() => r'1d1bb96be6e5e63e376fdbe4669d051c1a73864f';

/// Provider for preferred language
///
/// Copied from [preferredLanguage].
@ProviderFor(preferredLanguage)
final preferredLanguageProvider = AutoDisposeProvider<String>.internal(
  preferredLanguage,
  name: r'preferredLanguageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$preferredLanguageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PreferredLanguageRef = AutoDisposeProviderRef<String>;
String _$userProfileByIdHash() => r'ec7626436abed012847c9fda2a724376b57e5066';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userProfileById].
@ProviderFor(userProfileById)
const userProfileByIdProvider = UserProfileByIdFamily();

/// See also [userProfileById].
class UserProfileByIdFamily extends Family<AsyncValue<UserProfile?>> {
  /// See also [userProfileById].
  const UserProfileByIdFamily();

  /// See also [userProfileById].
  UserProfileByIdProvider call(
    String uid,
  ) {
    return UserProfileByIdProvider(
      uid,
    );
  }

  @override
  UserProfileByIdProvider getProviderOverride(
    covariant UserProfileByIdProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userProfileByIdProvider';
}

/// See also [userProfileById].
class UserProfileByIdProvider extends AutoDisposeFutureProvider<UserProfile?> {
  /// See also [userProfileById].
  UserProfileByIdProvider(
    String uid,
  ) : this._internal(
          (ref) => userProfileById(
            ref as UserProfileByIdRef,
            uid,
          ),
          from: userProfileByIdProvider,
          name: r'userProfileByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfileByIdHash,
          dependencies: UserProfileByIdFamily._dependencies,
          allTransitiveDependencies:
              UserProfileByIdFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserProfileByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<UserProfile?> Function(UserProfileByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProfileByIdProvider._internal(
        (ref) => create(ref as UserProfileByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserProfile?> createElement() {
    return _UserProfileByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileByIdProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserProfileByIdRef on AutoDisposeFutureProviderRef<UserProfile?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserProfileByIdProviderElement
    extends AutoDisposeFutureProviderElement<UserProfile?>
    with UserProfileByIdRef {
  _UserProfileByIdProviderElement(super.provider);

  @override
  String get uid => (origin as UserProfileByIdProvider).uid;
}

String _$userProfileNotifierHash() =>
    r'4930ed60aed0ac15e5a781cd7bd33a7bdada5c60';

/// User profile state provider.
///
/// Manages the current user's profile data, handling loading,
/// caching, and updates. Automatically refreshes when auth state changes.
///
/// Copied from [UserProfileNotifier].
@ProviderFor(UserProfileNotifier)
final userProfileNotifierProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>.internal(
  UserProfileNotifier.new,
  name: r'userProfileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserProfileNotifier = AsyncNotifier<UserProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
