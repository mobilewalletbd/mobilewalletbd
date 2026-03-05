import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/security_settings_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';
import 'package:mockito/mockito.dart';

// Mock generic classes if needed, or use Fake
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Settings Screens Smoke Test', () {
    testWidgets('AccountSettingsScreen renders correctly', (tester) async {
      // Override the auth provider to return a dummy user so we don't crash on null checks if any
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith(
              (ref) => const AuthUser(
                id: '123',
                email: 'test@example.com',
                emailVerified: true,
              ),
            ),
          ],
          child: const MaterialApp(home: AccountSettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Account Settings'), findsOneWidget);
      expect(find.text('Login & Security'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('SecuritySettingsScreen renders correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SecuritySettingsScreen())),
      );

      // We expect the local_auth check to happen, which might be async.
      // pumpAndSettle should handle it if it uses standard futures.
      await tester.pumpAndSettle();

      expect(find.text('Security Settings'), findsOneWidget);
      expect(find.text('Data Privacy'), findsOneWidget);
      // Biometrics might show "Biometrics Unavailable" in test environment without mocking LocalAuth platform channel
      // So we just check for the title "Biometrics" or common elements
    });
  });
}
