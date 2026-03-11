import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/collaboration/data/repositories/team_repository_impl.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';
import 'package:mockito/mockito.dart';

import '../manual_mocks.dart';

void main() {
  late MockTeamRepository mockRepository;

  setUp(() {
    mockRepository = MockTeamRepository();
  });

  test('Full Team Flow Logic Integration Test', () async {
    final testUser = AuthUser(
      id: 'user-123',
      email: 'test@example.com',
      displayName: 'Test User',
    );

    final container = ProviderContainer(
      overrides: [
        teamRepositoryProvider.overrideWithValue(mockRepository),
        currentUserProvider.overrideWithValue(testUser),
      ],
    );

    // Initial state
    when(mockRepository.getUserTeams('user-123')).thenAnswer((_) async => []);

    // 1. Create Team
    final newTeam = Team(
      id: 'team-1',
      name: 'New Team',
      ownerId: 'user-123',
      members: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockRepository.createTeam(any)).thenAnswer((_) async => newTeam);

    await container
        .read(teamNotifierProvider.notifier)
        .createTeam('New Team', 'Desc', null);

    verify(
      mockRepository.createTeam(
        argThat(predicate<Team>((t) => t.name == 'New Team')),
      ),
    ).called(1);

    // 2. Add Member
    when(mockRepository.addMember(any, any)).thenAnswer((_) async {});

    await container
        .read(teamNotifierProvider.notifier)
        .addMember('team-1', 'user-456');

    verify(
      mockRepository.addMember(
        'team-1',
        argThat(predicate<TeamMember>((m) => m.userId == 'user-456')),
      ),
    ).called(1);

    // 3. Save Permissions
    when(mockRepository.getTeam('team-1')).thenAnswer((_) async => newTeam);
    when(mockRepository.updateTeam(any)).thenAnswer((_) async {});

    await container
        .read(teamNotifierProvider.notifier)
        .savePermissions(
          'team-1',
          membersCanAddContacts: true,
          membersCanShareCards: false,
          membersCanInvite: true,
          membersCanViewExpenses: false,
          adminsCanAddExpenses: true,
        );

    verify(
      mockRepository.updateTeam(
        argThat(
          predicate<Team>(
            (t) =>
                t.permMembersCanAddContacts == true &&
                t.permMembersCanInvite == true,
          ),
        ),
      ),
    ).called(1);

    container.dispose();
  });
}
