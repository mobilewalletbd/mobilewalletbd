import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_wallet/core/services/firestore_service.dart';
import 'package:mobile_wallet/features/collaboration/data/repositories/team_repository_impl.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_expense.dart';

import 'manual_mocks.dart';

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
    when(mockUser.uid).thenReturn('user-123');
  });

  group('Pagination Tests', () {
    test('getTeamExpensesStream should respect the limit parameter', () async {
      final teamId = 'team-pagination';

      // Add 5 expenses to Firestore
      for (int i = 0; i < 5; i++) {
        await fakeFirestore.collection('team_expenses').add({
          'teamId': teamId,
          'title': 'Expense $i',
          'amount': 10.0 * (i + 1),
          'currency': 'BDT',
          'date': DateTime.now().toIso8601String(),
          'createdAt': Timestamp.now(),
          'category': 'other',
          'addedByUserId': 'user-123',
        });
      }

      // Test with limit = 2
      final stream2 = repository.getTeamExpensesStream(teamId, limit: 2);
      final firstBatch = await stream2.first;
      expect(firstBatch.length, 2);

      // Test with limit = 5
      final stream5 = repository.getTeamExpensesStream(teamId, limit: 5);
      final fullBatch = await stream5.first;
      expect(fullBatch.length, 5);
    });

    test('getTeamChatStream should respect the limit parameter', () async {
      final teamId = 'team-chat-pagination';

      for (int i = 0; i < 10; i++) {
        await fakeFirestore.collection('team_chat_messages').add({
          'teamId': teamId,
          'text': 'Msg $i',
          'senderId': 'user-123',
          'senderName': 'User 123',
          'createdAt': Timestamp.now(),
        });
      }

      final stream = repository.getTeamChatStream(teamId, limit: 3);
      final batch = await stream.first;
      expect(batch.length, 3);
    });
  });

  group('Security & Access Tests', () {
    test(
      'getUserTeams should only return teams where user is a member',
      () async {
        // Team where user IS a member
        await fakeFirestore.collection('teams').doc('team-yes').set({
          'name': 'Team Yes',
          'ownerId': 'other-456',
          'memberIds': ['user-123', 'other-456'],
          'members': [
            {
              'userId': 'user-123',
              'role': 'member',
              'joinedAt': DateTime.now().toIso8601String(),
              'status': 'active',
            },
            {
              'userId': 'other-456',
              'role': 'owner',
              'joinedAt': DateTime.now().toIso8601String(),
              'status': 'active',
            },
          ],
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });

        // Team where user IS NOT a member
        await fakeFirestore.collection('teams').doc('team-no').set({
          'name': 'Team No',
          'ownerId': 'other-456',
          'memberIds': ['other-456'],
          'members': [
            {
              'userId': 'other-456',
              'role': 'owner',
              'joinedAt': DateTime.now().toIso8601String(),
              'status': 'active',
            },
          ],
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });

        final teams = await repository.getUserTeams('user-123');
        expect(teams.length, 1);
        expect(teams.first.id, 'team-yes');
      },
    );
  });
}
