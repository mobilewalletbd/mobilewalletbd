import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    UserProfile? profile;

    try {
      profile = await repository.getUserProfile(authUser.id);
    } catch (e) {
      // If fetching fails, we'll try to create it if it doesn't exist
      // This handles cases where the document is missing.
    }

    // If profile doesn't exist, auto-create from auth data
    if (profile == null) {
      final extraData = authUser.rawExtraData;

      // Extract most accurate name possible
      String name = authUser.displayName ?? '';
      String? firstName = extraData?['given_name'] as String?;
      String? lastName = extraData?['family_name'] as String?;

      if (firstName != null || lastName != null) {
        name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
      } else if (name.isNotEmpty) {
        // Handle manual registration name splitting
        final parts = name.trim().split(' ');
        if (parts.length >= 2) {
          firstName = parts[0];
          lastName = parts.sublist(1).join(' ');
        } else {
          firstName = name;
        }
      }

      if (name.isEmpty) {
        name = authUser.email?.split('@').first ?? 'User';
      }

      final newProfile =
          UserProfile.newUser(
            uid: authUser.id,
            fullName: name,
            email: authUser.email,
          ).copyWith(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: authUser.phoneNumber,
            avatarUrl: authUser.photoUrl,
            accountStatus: authUser.emailVerified
                ? AccountStatus.active
                : AccountStatus.pendingVerification,
            timeZone: extraData?['locale'] as String?,
          );

      return await repository.createUserProfile(newProfile);
    }

    // Proactive Sync: If the profile exists but is missing critical info that Auth has (like photo or email)
    // or if the account was pending but email is now verified.
    if ((profile.avatarUrl == null && authUser.photoUrl != null) ||
        (profile.email == null && authUser.email != null) ||
        (profile.firstName == null &&
            authUser.rawExtraData?['given_name'] != null) ||
        (profile.accountStatus == AccountStatus.pendingVerification &&
            authUser.emailVerified)) {
      final extraData = authUser.rawExtraData;

      // Split name for manual sync if first name is missing
      String? firstName =
          profile.firstName ?? extraData?['given_name'] as String?;
      String? lastName =
          profile.lastName ?? extraData?['family_name'] as String?;

      if (firstName == null && profile.fullName.isNotEmpty) {
        final parts = profile.fullName.trim().split(' ');
        if (parts.length >= 2) {
          firstName = parts[0];
          lastName = parts.sublist(1).join(' ');
        } else {
          firstName = profile.fullName;
        }
      }

      final updatedProfile = profile.copyWith(
        email: profile.email ?? authUser.email,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: profile.avatarUrl ?? authUser.photoUrl,
        phoneNumber: profile.phoneNumber ?? authUser.phoneNumber,
        accountStatus: authUser.emailVerified
            ? AccountStatus.active
            : profile.accountStatus,
        timeZone: profile.timeZone ?? extraData?['locale'] as String?,
        updatedAt: DateTime.now(),
      );

      return await repository.updateUserProfile(updatedProfile);
    }

    return profile;
  }

  Future<void> createProfile({
    required String fullName,
    String? jobTitle,
    String? companyName,
  }) async {
    final authUser = ref.read(currentUserProvider);
    if (authUser == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Sync display name to Auth if different
      if (authUser.displayName != fullName) {
        await ref
            .read(authenticationProvider.notifier)
            .updateDisplayName(fullName);
      }

      final repository = ref.read(userProfileRepositoryProvider);
      final profile = UserProfile.newUser(
        uid: authUser.id,
        fullName: fullName,
      ).copyWith(jobTitle: jobTitle, companyName: companyName);
      return await repository.createUserProfile(profile);
    });
  }

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
      // 1. Update Firebase Auth (Sync critical fields)
      final authNotifier = ref.read(authenticationProvider.notifier);
      if (fullName != null && fullName != currentProfile.fullName) {
        await authNotifier.updateDisplayName(fullName);
      }
      if (avatarUrl != null && avatarUrl != currentProfile.avatarUrl) {
        await authNotifier.updatePhotoUrl(avatarUrl);
      }

      // 2. Update UserProfile in Database
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

@riverpod
Future<UserProfile?> userProfileById(UserProfileByIdRef ref, String uid) async {
  final repository = ref.watch(userProfileRepositoryProvider);
  return await repository.getUserProfile(uid);
}
