// Unit tests for AuthRepository implementation
// Uses mockito to mock Firebase dependencies

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_wallet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';
import 'package:mobile_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_repository_impl_test.mocks.dart';

// Generate mocks
class FakeUserMetadata extends Fake implements UserMetadata {
  @override
  DateTime? get lastSignInTime => DateTime.now();
  @override
  DateTime? get creationTime => DateTime.now();
}

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
])
void main() {
  group('AuthRepositoryImpl Tests', () {
    late AuthRepository repository;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;
    late MockGoogleSignIn mockGoogleSignIn;
    // late MockGoogleSignInAccount mockGoogleSignInAccount; // Removed
    // late MockGoogleSignInAuthentication mockGoogleSignInAuthentication; // Removed

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockGoogleSignIn = MockGoogleSignIn();
      // mockGoogleSignInAccount = MockGoogleSignInAccount(); // Removed
      // mockGoogleSignInAuthentication = MockGoogleSignInAuthentication(); // Removed

      repository = AuthRepositoryImpl(
        firebaseAuth: mockFirebaseAuth,
        googleSignIn: mockGoogleSignIn,
      );

      // Setup default mock user data
      when(mockUser.uid).thenReturn('test-uid-123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.phoneNumber).thenReturn(null);
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.photoURL).thenReturn(null);
      when(mockUser.emailVerified).thenReturn(true);
      when(mockUser.isAnonymous).thenReturn(false);
      when(mockUser.metadata).thenReturn(FakeUserMetadata()); // Use fake
      when(mockUser.providerData).thenReturn([]);
    });

    group('currentUser', () {
      test('should return AuthUser when Firebase user exists', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final result = repository.currentUser;

        expect(result, isNotNull);
        expect(result!.id, 'test-uid-123');
        expect(result.email, 'test@example.com');
        expect(result.displayName, 'Test User');
      });

      test('should return null when no Firebase user', () {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = repository.currentUser;

        expect(result, isNull);
      });
    });

    group('authStateChanges', () {
      test('should emit AuthUser when user signs in', () async {
        when(
          mockFirebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream.value(mockUser));

        final stream = repository.authStateChanges;

        await expectLater(
          stream,
          emits(predicate<AuthUser>((user) => user.id == 'test-uid-123')),
        );
      });

      test('should emit null when user signs out', () async {
        when(
          mockFirebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream.value(null));

        final stream = repository.authStateChanges;

        await expectLater(stream, emits(null));
      });

      test('should emit multiple states correctly', () async {
        when(
          mockFirebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream.fromIterable([mockUser, null, mockUser]));

        final stream = repository.authStateChanges;

        await expectLater(
          stream,
          emitsInOrder([isA<AuthUser>(), null, isA<AuthUser>()]),
        );
      });
    });

    group('signInWithEmail', () {
      test('should return AuthUser on successful sign in', () async {
        when(mockUserCredential.user).thenReturn(mockUser);
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await repository.signInWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isA<AuthUser>());
        expect(result.id, 'test-uid-123');
        expect(result.email, 'test@example.com');
        verify(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('should throw AuthFailure on wrong password', () async {
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        expect(
          () => repository.signInWithEmail(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('should throw AuthFailure on user not found', () async {
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => repository.signInWithEmail(
            email: 'nonexistent@example.com',
            password: 'password123',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('should throw AuthFailure on invalid email', () async {
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => repository.signInWithEmail(
            email: 'invalid-email',
            password: 'password123',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });
    });

    group('signUpWithEmail', () {
      test('should return AuthUser on successful registration', () async {
        when(mockUserCredential.user).thenReturn(mockUser);
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUser.updateDisplayName(any)).thenAnswer((_) async => {});
        when(mockUser.reload()).thenAnswer((_) async => {});
        when(mockUser.sendEmailVerification()).thenAnswer((_) async => {});

        final result = await repository.signUpWithEmail(
          email: 'newuser@example.com',
          password: 'password123',
          displayName: 'New User',
        );

        expect(result, isA<AuthUser>());
        expect(result.id, 'test-uid-123');
        verify(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'newuser@example.com',
            password: 'password123',
          ),
        ).called(1);
        verify(mockUser.updateDisplayName('New User')).called(1);
        verify(mockUser.sendEmailVerification()).called(1);
      });

      test('should throw AuthFailure on email already in use', () async {
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => repository.signUpWithEmail(
            email: 'existing@example.com',
            password: 'password123',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('should throw AuthFailure on weak password', () async {
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'weak-password'));

        expect(
          () => repository.signUpWithEmail(
            email: 'test@example.com',
            password: '123',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });
    });

    group('signOut', () {
      test('should call Firebase signOut', () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
        when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

        await repository.signOut();

        verify(mockFirebaseAuth.signOut()).called(1);
        verify(mockGoogleSignIn.signOut()).called(1);
      });

      test('should handle signOut errors gracefully', () async {
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out error'));

        expect(() => repository.signOut(), throwsException);
      });
    });

    group('sendPasswordResetEmail', () {
      test('should send password reset email successfully', () async {
        when(
          mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')),
        ).thenAnswer((_) async => {});

        await repository.sendPasswordResetEmail('test@example.com');

        verify(
          mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'),
        ).called(1);
      });

      test('should throw AuthFailure on invalid email', () async {
        when(
          mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => repository.sendPasswordResetEmail('invalid-email'),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('should throw AuthFailure on user not found', () async {
        when(
          mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => repository.sendPasswordResetEmail('nonexistent@example.com'),
          throwsA(isA<AuthFailure>()),
        );
      });
    });

    group('deleteAccount', () {
      test('should delete user account successfully', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.delete()).thenAnswer((_) async => {});

        await repository.deleteAccount();

        verify(mockUser.delete()).called(1);
      });

      test('should throw exception when no current user', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        expect(() => repository.deleteAccount(), throwsException);
      });

      test('should handle delete errors', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(
          mockUser.delete(),
        ).thenThrow(FirebaseAuthException(code: 'requires-recent-login'));

        expect(
          () => repository.deleteAccount(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });
  });
}
