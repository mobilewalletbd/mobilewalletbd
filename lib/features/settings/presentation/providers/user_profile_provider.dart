import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';
import 'package:mobile_wallet/features/settings/data/repositories/user_profile_repository_impl.dart';

part 'user_profile_provider.g.dart';

/// User profile state provider.
///
/// Manages the current user's profile data, handling loading,
/// caching, and updates. Automatically refreshes when auth state changes.
@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    // Watch auth state to refresh profile when user changes
    final authUser = ref.watch(currentUserProvider);

    if (authUser == null) {
      return null;
    }

    // Fetch profile from repository
    final repository = ref.read(userProfileRepositoryProvider);
    final profile = await repository.getUserProfile(authUser.id);

    // If profile doesn't exist, create a new one
    if (profile == null && authUser.displayName != null) {
      final newProfile = UserProfile.newUser(
        uid: authUser.id,
        fullName: authUser.displayName ?? 'User',
      );
      return await repository.createUserProfile(newProfile);
    }

    return profile;
  }

  /// Creates a new user profile
  Future<void> createProfile({
    required String fullName,
    String? jobTitle,
    String? companyName,
  }) async {
    final authUser = ref.read(currentUserProvider);
    if (authUser == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userProfileRepositoryProvider);
      final profile = UserProfile.newUser(
        uid: authUser.id,
        fullName: fullName,
      ).copyWith(jobTitle: jobTitle, companyName: companyName);
      return await repository.createUserProfile(profile);
    });
  }

  /// Updates the user profile
  Future<void> updateProfile({
    String? fullName,
    String? jobTitle,
    String? companyName,
    String? bio,
    String? avatarUrl,
    String? timeZone,
    String? defaultLanguage,
  }) async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userProfileRepositoryProvider);
      final updatedProfile = currentProfile.copyWith(
        fullName: fullName ?? currentProfile.fullName,
        jobTitle: jobTitle ?? currentProfile.jobTitle,
        companyName: companyName ?? currentProfile.companyName,
        bio: bio ?? currentProfile.bio,
        avatarUrl: avatarUrl ?? currentProfile.avatarUrl,
        timeZone: timeZone ?? currentProfile.timeZone,
        defaultLanguage: defaultLanguage ?? currentProfile.defaultLanguage,
        updatedAt: DateTime.now(),
      );
      return await repository.updateUserProfile(updatedProfile);
    });
  }

  /// Updates user preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userProfileRepositoryProvider);
      return await repository.updatePreferences(currentProfile.uid, {
        ...currentProfile.preferences,
        ...preferences,
      });
    });
  }

  /// Updates avatar URL
  Future<void> updateAvatar(String avatarUrl) async {
    await updateProfile(avatarUrl: avatarUrl);
  }

  /// Updates last active timestamp
  Future<void> updateLastActive() async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return;

    final repository = ref.read(userProfileRepositoryProvider);
    await repository.updateLastActive(currentProfile.uid);
  }

  /// Refreshes the profile from the server
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Deletes the user profile
  Future<void> deleteProfile() async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userProfileRepositoryProvider);
      await repository.deleteUserProfile(currentProfile.uid);
      return null;
    });
  }
}

/// Provider for checking if profile exists
@riverpod
bool hasProfile(HasProfileRef ref) {
  final profileState = ref.watch(userProfileNotifierProvider);
  return profileState.valueOrNull != null;
}

/// Provider for profile loading state
@riverpod
bool isProfileLoading(IsProfileLoadingRef ref) {
  final profileState = ref.watch(userProfileNotifierProvider);
  return profileState.isLoading;
}

/// Provider for user's display name
@riverpod
String displayName(DisplayNameRef ref) {
  final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
  if (profile != null) return profile.displayName;

  final authUser = ref.watch(currentUserProvider);
  return authUser?.displayName ?? 'User';
}

/// Provider for user's avatar URL
@riverpod
String? avatarUrl(AvatarUrlRef ref) {
  final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
  if (profile?.avatarUrl != null) return profile!.avatarUrl;

  final authUser = ref.watch(currentUserProvider);
  return authUser?.photoUrl;
}

/// Provider for user's initials (for avatar fallback)
@riverpod
String userInitials(UserInitialsRef ref) {
  final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
  if (profile != null) return profile.initials;

  final authUser = ref.watch(currentUserProvider);
  return authUser?.initials ?? 'U';
}

/// Provider for user preferences
@riverpod
Map<String, dynamic> userPreferences(UserPreferencesRef ref) {
  final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
  return profile?.preferences ?? {};
}

/// Provider for preferred theme
@riverpod
String preferredTheme(PreferredThemeRef ref) {
  final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
  return profile?.preferredTheme ?? 'system';
}

/// Provider for preferred language
@riverpod
String preferredLanguage(PreferredLanguageRef ref) {
  final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
  return profile?.preferredLanguage ?? 'en';
}
