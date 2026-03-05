// Widget tests for Register Screen
// Tests registration form validation and UI interactions

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/register_screen.dart';

void main() {
  group('RegisterScreen Widget Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = const ProviderScope(
        child: MaterialApp(home: RegisterScreen()),
      );
    });

    testWidgets('should display registration form with all fields', (
      tester,
    ) async {
      await tester.pumpWidget(testWidget);

      // Verify app bar
      expect(find.text('Create Account'), findsOneWidget);

      // Verify form fields (Name, Email, Password, Confirm Password)
      expect(find.byType(TextField), findsNWidgets(4));

      // Verify register button
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);

      // Verify terms checkbox
      expect(find.textContaining('I agree to the'), findsOneWidget);

      // Verify login link
      expect(find.textContaining('Already have an account?'), findsOneWidget);
    });

    testWidgets('should show error for empty name', (tester) async {
      await tester.pumpWidget(testWidget);

      // Tap register without entering name
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Verify error message
      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('should show error for short name', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter short name
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'A');

      // Tap register button
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Verify error message
      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter name and invalid email
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'invalid-email');

      // Tap register
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Verify error
      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('should show error for weak password', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter valid name, email, and weak password
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), '123');

      // Tap register
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Verify error
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should show error for password mismatch', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter valid fields but mismatched passwords
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), 'password123');
      await tester.enterText(textFields.at(3), 'password456');

      // Tap register
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Verify error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should toggle password visibility for both fields', (
      tester,
    ) async {
      await tester.pumpWidget(testWidget);

      // Find password visibility toggles
      final visibilityIcons = find.byIcon(Icons.visibility_off);
      expect(visibilityIcons, findsNWidgets(2));

      // Tap first toggle
      await tester.tap(visibilityIcons.first);
      await tester.pump();

      // Verify icon changed for password field
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should require terms acceptance', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter all valid data
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), 'password123');
      await tester.enterText(textFields.at(3), 'password123');

      // Try to register without accepting terms
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Verify error about terms
      expect(
        find.text('You must accept the terms and conditions'),
        findsOneWidget,
      );
    });

    testWidgets('should toggle terms checkbox', (tester) async {
      await tester.pumpWidget(testWidget);

      // Find and tap terms checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pump();

      // Verify checkbox is checked
      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, true);
    });

    testWidgets('should accept valid registration data', (tester) async {
      await tester.pumpWidget(testWidget);

      // Enter all valid data
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), 'ValidPassword123!');
      await tester.enterText(textFields.at(3), 'ValidPassword123!');

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify all data is entered
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });
  });
}
