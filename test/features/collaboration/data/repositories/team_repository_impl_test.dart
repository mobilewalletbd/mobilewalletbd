import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_wallet/core/services/firestore_service.dart';
import 'package:mobile_wallet/features/collaboration/data/repositories/team_repository_impl.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';

import '../../manual_mocks.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late TeamRepositoryImpl repository;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(fakeFirestore);
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    repository = TeamRepositoryImpl(firestoreService, mockAuth);

    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('owner-123');
  });

  group('TeamRepositoryImpl', () {
    final testTeam = Team(
      id: 'team-1',
      name: 'Test Team',
      ownerId: 'owner-123',
      members: [
        TeamMember(
          userId: 'owner-123',
          role: 'owner',
          joinedAt: DateTime.now(),
          status: 'active',
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('createTeam should add team to Firestore', () async {
      final createdTeam = await repository.createTeam(testTeam);

      expect(createdTeam.id, testTeam.id);
      expect(createdTeam.name, testTeam.name);

      final doc = await fakeFirestore
          .collection('teams')
          .doc(testTeam.id)
          .get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['name'], testTeam.name);
      expect(doc.data()?['memberIds'], contains('owner-123'));
    });

    test('addMember should update members list', () async {
      await repository.createTeam(testTeam);

      final newMember = TeamMember(
        userId: 'member-456',
        role: 'member',
        joinedAt: DateTime.now(),
        status: 'active',
      );

      await repository.addMember(testTeam.id, newMember);

      final doc = await fakeFirestore
          .collection('teams')
          .doc(testTeam.id)
          .get();
      final members = doc.data()?['members'] as List;
      expect(members.length, 2);
      expect(doc.data()?['memberIds'], contains('member-456'));
    });

    test('updateTeam should persist permission fields', () async {
      final teamWithPerms = testTeam.copyWith(
        permMembersCanAddContacts: false,
        permMembersCanInvite: true,
      );

      await repository.createTeam(teamWithPerms);

      // Update one perm
      final updatedTeam = teamWithPerms.copyWith(
        permMembersCanShareCards: false,
      );
      await repository.updateTeam(updatedTeam);

      final doc = await fakeFirestore
          .collection('teams')
          .doc(testTeam.id)
          .get();
      expect(doc.data()?['permMembersCanAddContacts'], isFalse);
      expect(doc.data()?['permMembersCanInvite'], isTrue);
      expect(doc.data()?['permMembersCanShareCards'], isFalse);
    });

    test('inviteMember should add member with pending status', () async {
      await repository.createTeam(testTeam);

      await repository.inviteMember(
        testTeam.id,
        email: 'new@example.com',
        role: 'member',
      );

      final doc = await fakeFirestore
          .collection('teams')
          .doc(testTeam.id)
          .get();
      final members = doc.data()?['members'] as List;
      final invitedMember = members.firstWhere(
        (m) => m['email'] == 'new@example.com',
      );

      expect(invitedMember['status'], 'pending');
      expect(doc.data()?['invitedEmails'], contains('new@example.com'));
    });
  });
}
