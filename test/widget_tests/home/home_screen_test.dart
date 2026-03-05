// Widget tests for Home/Dashboard Screen
// Tests dashboard UI and basic rendering
// Note: Full provider testing requires mockito setup

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/home/presentation/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should render home screen widget', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Verify HomeScreen renders
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should display loading state initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      // Verify loading indicator appears before auth state loads
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have AppBar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      await tester.pump();

      // Verify AppBar is present (might be in loading or error state)
      expect(find.byType(AppBar), findsAny);
    });

    testWidgets('should have floating action button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeScreen())),
      );

      await tester.pump();

      // Verify FAB exists when screen is rendered
      // Note: May not be visible in loading/error state
      expect(find.byType(FloatingActionButton), findsAny);
    });
  });
}
