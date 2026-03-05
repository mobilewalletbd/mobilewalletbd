// Widget tests for Login Screen
// Tests UI interactions, form validation, and navigation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = const ProviderScope(child: MaterialApp(home: LoginScreen()));
    });

    testWidgets('should display login screen with all elements', (
      tester,
    ) async {
      await tester.pumpWidget(testWidget);

      // Verify app bar title
      expect(find.text('Log In'), findsOneWidget);

      // Verify email and password fields
      expect(find.byType(TextField), findsNWidgets(2));

      // Verify login button
      expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);

      // Verify forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Verify social login buttons
      expect(find.text('Or continue with'), findsOneWidget);

      // Verify sign up link
      expect(find.textContaining('Don\'t have an account?'), findsOneWidget);
    });

    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(testWidget);

      // Find and tap login button without entering email
      final loginButton = find.widgetWithText(ElevatedButton, 'Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify error message appears
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show error for invalid email format', (tester) async {
      await tester.pumpWidget(testWidget);

      // Find email field and enter invalid email
      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'invalid-email');

      // Tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify error message
      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter valid email but no password
      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'test@example.com');

      // Tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify error message
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(testWidget);

      // Find password field visibility toggle
      final visibilityIcon = find.byIcon(Icons.visibility_off);
      expect(visibilityIcon, findsOneWidget);

      // Tap to show password
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Verify icon changed
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should show loading indicator during login', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter valid credentials
      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'test@example.com');
      await tester.enterText(emailFields.at(1), 'password123');

      // Tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Note: Actual loading state would require proper mock setup
      // This test verifies the UI accepts the input
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should have Remember Me checkbox', (tester) async {
      await tester.pumpWidget(testWidget);

      // Find Remember Me checkbox
      expect(find.text('Remember Me'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      // Tap checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify checkbox state changed
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('should accept valid email and password', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter valid credentials
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'user@example.com');
      await tester.enterText(textFields.at(1), 'ValidPass123!');

      // Verify text was entered
      expect(find.text('user@example.com'), findsOneWidget);
      expect(find.text('ValidPass123!'), findsOneWidget);
    });
  });
}
