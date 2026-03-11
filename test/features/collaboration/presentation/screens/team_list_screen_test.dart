import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/collaboration/presentation/screens/team_list_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';

void main() {
  testWidgets('TeamListScreen showing empty state when no teams', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userTeamsProvider.overrideWith((ref) => Stream.value([])),
          pendingInvitesProvider.overrideWith((ref) => Stream.value([])),
          currentUserProvider.overrideWith(
            (ref) => AuthUser(id: '1', email: 't@t.com', displayName: 'User'),
          ),
        ],
        child: const MaterialApp(home: TeamListScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('No Teams Yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('TeamListScreen showing teams when available', (tester) async {
    final teams = [
      Team(
        id: 'team-1',
        name: 'Alpha Team',
        ownerId: '1',
        members: [
          TeamMember(
            userId: '1',
            role: 'owner',
            joinedAt: DateTime.now(),
            status: 'active',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userTeamsProvider.overrideWith((ref) => Stream.value(teams)),
          pendingInvitesProvider.overrideWith((ref) => Stream.value([])),
          currentUserProvider.overrideWith(
            (ref) => AuthUser(id: '1', email: 't@t.com', displayName: 'User'),
          ),
        ],
        child: const MaterialApp(home: TeamListScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Alpha Team'), findsOneWidget);
    expect(find.text('1 member'), findsOneWidget);
  });
}
