// Unit tests for AuthUser entity
// Tests all properties, methods, and edge cases

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AuthUser Entity Tests', () {
    // Test data
    const testId = 'test-user-id-123';
    const testEmail = 'test@example.com';
    const testPhone = '+8801234567890';
    const testDisplayName = 'John Doe';
    const testPhotoUrl = 'https://example.com/photo.jpg';
    final testLastSignIn = DateTime(2026, 1, 29, 12, 0);

    group('Constructor and Properties', () {
      test('should create AuthUser with required fields only', () {
        const user = AuthUser(id: testId);

        expect(user.id, testId);
        expect(user.email, isNull);
        expect(user.phoneNumber, isNull);
        expect(user.displayName, isNull);
        expect(user.photoUrl, isNull);
        expect(user.emailVerified, false);
        expect(user.lastSignIn, isNull);
        expect(user.provider, isNull);
        expect(user.isAnonymous, false);
        expect(user.customClaims, isNull);
      });

      test('should create AuthUser with all fields', () {
        final user = AuthUser(
          id: testId,
          email: testEmail,
          phoneNumber: testPhone,
          displayName: testDisplayName,
          photoUrl: testPhotoUrl,
          emailVerified: true,
          lastSignIn: testLastSignIn,
          provider: AuthProviderType.email,
          isAnonymous: false,
          customClaims: ['admin', 'premium'],
        );

        expect(user.id, testId);
        expect(user.email, testEmail);
        expect(user.phoneNumber, testPhone);
        expect(user.displayName, testDisplayName);
        expect(user.photoUrl, testPhotoUrl);
        expect(user.emailVerified, true);
        expect(user.lastSignIn, testLastSignIn);
        expect(user.provider, AuthProviderType.email);
        expect(user.isAnonymous, false);
        expect(user.customClaims, ['admin', 'premium']);
      });

      test('should create anonymous user correctly', () {
        const user = AuthUser(id: testId, isAnonymous: true);

        expect(user.id, testId);
        expect(user.isAnonymous, true);
        expect(user.email, isNull);
        expect(user.phoneNumber, isNull);
      });
    });

    group('copyWith Method', () {
      test('should create copy with updated fields', () {
        const user = AuthUser(
          id: testId,
          email: testEmail,
          emailVerified: false,
        );

        final updatedUser = user.copyWith(
          emailVerified: true,
          displayName: testDisplayName,
        );

        expect(updatedUser.id, testId);
        expect(updatedUser.email, testEmail);
        expect(updatedUser.emailVerified, true);
        expect(updatedUser.displayName, testDisplayName);
      });

      test('should create copy without changing original', () {
        const user = AuthUser(id: testId, email: testEmail);

        final updatedUser = user.copyWith(displayName: testDisplayName);

        expect(user.displayName, isNull);
        expect(updatedUser.displayName, testDisplayName);
      });
    });

    group('isFullyVerified Getter', () {
      test('should return true when email is verified', () {
        const user = AuthUser(
          id: testId,
          email: testEmail,
          emailVerified: true,
        );

        expect(user.isFullyVerified, true);
      });

      test('should return false when email is not verified', () {
        const user = AuthUser(
          id: testId,
          email: testEmail,
          emailVerified: false,
        );

        expect(user.isFullyVerified, false);
      });

      test('should return true when no email present', () {
        const user = AuthUser(id: testId, phoneNumber: testPhone);

        expect(user.isFullyVerified, true);
      });

      test('should return true when email is empty string', () {
        const user = AuthUser(id: testId, email: '', emailVerified: false);

        expect(user.isFullyVerified, true);
      });
    });

    group('Helper Getters', () {
      test('hasEmail should return true when email exists', () {
        const user = AuthUser(id: testId, email: testEmail);

        expect(user.hasEmail, true);
      });

      test('hasEmail should return false when email is null', () {
        const user = AuthUser(id: testId);

        expect(user.hasEmail, false);
      });

      test('hasEmail should return false when email is empty', () {
        const user = AuthUser(id: testId, email: '');

        expect(user.hasEmail, false);
      });

      test('hasPhone should return true when phone exists', () {
        const user = AuthUser(id: testId, phoneNumber: testPhone);

        expect(user.hasPhone, true);
      });

      test('hasPhone should return false when phone is null', () {
        const user = AuthUser(id: testId);

        expect(user.hasPhone, false);
      });

      test('hasDisplayName should return true when display name exists', () {
        const user = AuthUser(id: testId, displayName: testDisplayName);

        expect(user.hasDisplayName, true);
      });

      test('hasDisplayName should return false when display name is null', () {
        const user = AuthUser(id: testId);

        expect(user.hasDisplayName, false);
      });

      test('hasPhoto should return true when photo URL exists', () {
        const user = AuthUser(id: testId, photoUrl: testPhotoUrl);

        expect(user.hasPhoto, true);
      });

      test('hasPhoto should return false when photo URL is null', () {
        const user = AuthUser(id: testId);

        expect(user.hasPhoto, false);
      });
    });

    group('primaryIdentifier Getter', () {
      test('should return email when both email and phone exist', () {
        const user = AuthUser(
          id: testId,
          email: testEmail,
          phoneNumber: testPhone,
        );

        expect(user.primaryIdentifier, testEmail);
      });

      test('should return phone when only phone exists', () {
        const user = AuthUser(id: testId, phoneNumber: testPhone);

        expect(user.primaryIdentifier, testPhone);
      });

      test('should return null when neither email nor phone exist', () {
        const user = AuthUser(id: testId);

        expect(user.primaryIdentifier, isNull);
      });
    });

    group('initials Getter', () {
      test('should return initials from two-word name', () {
        const user = AuthUser(id: testId, displayName: 'John Doe');

        expect(user.initials, 'JD');
      });

      test('should return first letter from one-word name', () {
        const user = AuthUser(id: testId, displayName: 'John');

        expect(user.initials, 'J');
      });

      test('should return first letter from three-word name', () {
        const user = AuthUser(id: testId, displayName: 'John Michael Doe');

        expect(user.initials, 'JM');
      });

      test('should return first letter of email when no display name', () {
        const user = AuthUser(id: testId, email: testEmail);

        expect(user.initials, 'T');
      });

      test('should return question mark when no display name or email', () {
        const user = AuthUser(id: testId);

        expect(user.initials, '?');
      });

      test('should handle names with extra spaces', () {
        const user = AuthUser(id: testId, displayName: '  John   Doe  ');

        expect(user.initials, 'JD');
      });

      test('should be case insensitive', () {
        const user = AuthUser(id: testId, displayName: 'john doe');

        expect(user.initials, 'JD');
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        final user = AuthUser(
          id: testId,
          email: testEmail,
          phoneNumber: testPhone,
          displayName: testDisplayName,
          photoUrl: testPhotoUrl,
          emailVerified: true,
          lastSignIn: testLastSignIn,
          provider: AuthProviderType.email,
          isAnonymous: false,
          customClaims: ['admin'],
        );

        final json = user.toJson();

        expect(json['id'], testId);
        expect(json['email'], testEmail);
        expect(json['phoneNumber'], testPhone);
        expect(json['displayName'], testDisplayName);
        expect(json['photoUrl'], testPhotoUrl);
        expect(json['emailVerified'], true);
        expect(json['provider'], AuthProviderType.email);
        expect(json['isAnonymous'], false);
        expect(json['customClaims'], ['admin']);
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'id': testId,
          'email': testEmail,
          'phoneNumber': testPhone,
          'displayName': testDisplayName,
          'photoUrl': testPhotoUrl,
          'emailVerified': true,
          'lastSignIn': testLastSignIn.toIso8601String(),
          'provider': AuthProviderType.email,
          'isAnonymous': false,
          'customClaims': ['admin'],
        };

        final user = AuthUser.fromJson(json);

        expect(user.id, testId);
        expect(user.email, testEmail);
        expect(user.phoneNumber, testPhone);
        expect(user.displayName, testDisplayName);
        expect(user.photoUrl, testPhotoUrl);
        expect(user.emailVerified, true);
        expect(user.provider, AuthProviderType.email);
        expect(user.isAnonymous, false);
        expect(user.customClaims, ['admin']);
      });

      test('should handle missing optional fields in JSON', () {
        final json = {'id': testId};

        final user = AuthUser.fromJson(json);

        expect(user.id, testId);
        expect(user.email, isNull);
        expect(user.phoneNumber, isNull);
        expect(user.emailVerified, false);
        expect(user.isAnonymous, false);
      });
    });

    group('Equality and HashCode', () {
      test('should be equal when all fields match', () {
        const user1 = AuthUser(
          id: testId,
          email: testEmail,
          emailVerified: true,
        );
        const user2 = AuthUser(
          id: testId,
          email: testEmail,
          emailVerified: true,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when fields differ', () {
        const user1 = AuthUser(id: testId, email: testEmail);
        const user2 = AuthUser(id: testId, email: 'different@example.com');

        expect(user1, isNot(equals(user2)));
      });
    });

    group('AuthProviderType Constants', () {
      test('should have correct provider type constants', () {
        expect(AuthProviderType.email, 'email');
        expect(AuthProviderType.google, 'google');
        expect(AuthProviderType.phone, 'phone');
        expect(AuthProviderType.apple, 'apple');
        expect(AuthProviderType.anonymous, 'anonymous');
      });
    });
  });
}
