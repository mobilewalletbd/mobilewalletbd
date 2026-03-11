import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

import '../../manual_mocks.dart';

void main() {
  late TeamNotifier notifier;
  late MockTeamRepository mockRepository;
  late MockRef mockRef;

  setUp(() {
    mockRepository = MockTeamRepository();
    mockRef = MockRef();
    notifier = TeamNotifier(mockRepository, mockRef);
  });

  group('TeamNotifier', () {
    final testUser = AuthUser(
      id: 'user-123',
      email: 'test@example.com',
      displayName: 'Test User',
    );

    test(
      'savePermissions should call repository.updateTeam with new perms',
      () async {
        final existingTeam = Team(
          id: 'team-1',
          name: 'Test Team',
          ownerId: 'user-123',
          members: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(
          mockRepository.getTeam('team-1'),
        ).thenAnswer((_) async => existingTeam);

        // Use a dummy team for the 'when' call because Mockito 'any' can return null
        // while the method expects a non-nullable Team.
        // Actually, with manually written Mock subclasses, we need to be careful.
        when(mockRepository.updateTeam(any)).thenAnswer((_) async {});

        await notifier.savePermissions(
          'team-1',
          membersCanAddContacts: false,
          membersCanShareCards: true,
          membersCanInvite: false,
          membersCanViewExpenses: true,
          adminsCanAddExpenses: true,
        );

        verify(
          mockRepository.updateTeam(
            argThat(
              predicate<Team>((team) {
                return team.permMembersCanAddContacts == false &&
                    team.permMembersCanShareCards == true &&
                    team.permMembersCanInvite == false;
              }),
            ),
          ),
        ).called(1);

        expect(notifier.state, isA<AsyncData>());
      },
    );

    test(
      'createTeam should set state to loading then data on success',
      () async {
        when(mockRef.read(currentUserProvider)).thenReturn(testUser);
        when(
          mockRepository.createTeam(any),
        ).thenAnswer((inv) async => inv.positionalArguments[0] as Team);

        await notifier.createTeam('New Team', 'Desc', null);

        expect(notifier.state, isA<AsyncData>());
        verify(mockRepository.createTeam(any)).called(1);
        verify(mockRef.invalidate(userTeamsProvider)).called(1);
      },
    );

    test('createTeam should set state to error on failure', () async {
      when(mockRef.read(currentUserProvider)).thenReturn(testUser);
      when(mockRepository.createTeam(any)).thenThrow(Exception('Failed'));

      await notifier.createTeam('New Team', 'Desc', null);

      expect(notifier.state, isA<AsyncError>());
    });
  });
}
