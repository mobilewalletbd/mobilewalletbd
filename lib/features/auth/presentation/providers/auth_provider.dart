import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';
import 'package:mobile_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_wallet/features/auth/data/repositories/auth_repository_impl.dart';

part 'auth_provider.g.dart';

/// Authentication state provider using Riverpod.
///
/// Manages the authentication state and provides methods for
/// all authentication operations. Uses AsyncNotifier pattern
/// for handling loading, success, and error states.
@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Stream<AuthUser?> build() {
    return _repository.authStateChanges;
  }

  /// Signs in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.signInWithEmail(email: email, password: password);
      return _repository.currentUser;
    });
  }

  /// Signs up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
    Map<String, dynamic>? metadata,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
        metadata: metadata,
      );
      return _repository.currentUser;
    });
  }

  /// Signs in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.signInWithGoogle();
      return _repository.currentUser;
    });
  }

  /// Initiates phone number verification
  Future<void> sendPhoneOTP({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    await _repository.sendPhoneOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onAutoVerified: (user) {
        state = AsyncData(user);
      },
      onError: onError,
    );
  }

  /// Verifies phone OTP code
  Future<void> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.verifyPhoneOTP(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return _repository.currentUser;
    });
  }

  /// Signs in anonymously
  Future<void> signInAnonymously() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.signInAnonymously();
      return _repository.currentUser;
    });
  }

  /// Sends password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _repository.sendPasswordResetEmail(email);
  }

  /// Sends email verification
  Future<void> sendEmailVerification() async {
    await _repository.sendEmailVerification();
  }

  /// Reloads user data
  Future<void> reloadUser() async {
    final user = await _repository.reloadUser();
    if (user != null) {
      state = AsyncData(user);
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }

  /// Updates user display name
  Future<void> updateDisplayName(String displayName) async {
    await _repository.updateDisplayName(displayName);
    await reloadUser();
  }

  /// Updates user photo URL
  Future<void> updatePhotoUrl(String photoUrl) async {
    await _repository.updatePhotoUrl(photoUrl);
    await reloadUser();
  }

  /// Updates user email
  Future<void> updateEmail(String email) async {
    await _repository.updateEmail(email);
    // Note: User needs to verify new email before it takes effect fully in some cases
    await reloadUser();
  }

  /// Updates user password
  Future<void> updatePassword(String password) async {
    await _repository.updatePassword(password);
  }

  /// Re-authenticates user with email/password
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    await _repository.reauthenticateWithEmail(email: email, password: password);
  }

  /// Updates user phone number
  Future<void> updatePhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    await _repository.updatePhoneNumber(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await reloadUser();
  }

  /// Deletes the user account
  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteAccount();
      return null;
    });
  }
}

/// Provider for checking if user is authenticated
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authenticationProvider);
  return authState.valueOrNull != null;
}

/// Provider for getting current user (non-null assertion)
@riverpod
AuthUser? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authenticationProvider);
  return authState.valueOrNull;
}

/// Provider for authentication loading state
@riverpod
bool isAuthLoading(IsAuthLoadingRef ref) {
  final authState = ref.watch(authenticationProvider);
  return authState.isLoading;
}

/// Provider for authentication error
@riverpod
Object? authError(AuthErrorRef ref) {
  final authState = ref.watch(authenticationProvider);
  return authState.error;
}
