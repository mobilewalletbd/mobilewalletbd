import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/contacts/data/datasources/remote_contact_datasource.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_wallet/features/collaboration/domain/repositories/team_repository.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  @override
  String get uid => super.noSuchMethod(
    Invocation.getter(#uid),
    returnValue: 'user-123',
    returnValueForMissingStub: 'user-123',
  );
}

class MockTeamRepository extends Mock implements TeamRepository {
  @override
  Future<void> updateTeam(Team? team) => super.noSuchMethod(
    Invocation.method(#updateTeam, [team]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );

  @override
  Future<Team> createTeam(Team? team) => super.noSuchMethod(
    Invocation.method(#createTeam, [team]),
    returnValue: Future<Team>.value(
      team ??
          Team(
            id: 'fake',
            name: 'fake',
            ownerId: 'fake',
            members: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
    ),
    returnValueForMissingStub: Future<Team>.value(
      team ??
          Team(
            id: 'fake',
            name: 'fake',
            ownerId: 'fake',
            members: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
    ),
  );

  @override
  Future<Team?> getTeam(String? teamId) => super.noSuchMethod(
    Invocation.method(#getTeam, [teamId]),
    returnValue: Future<Team?>.value(),
    returnValueForMissingStub: Future<Team?>.value(),
  );

  @override
  Future<List<Team>> getUserTeams(String? userId) => super.noSuchMethod(
    Invocation.method(#getUserTeams, [userId]),
    returnValue: Future<List<Team>>.value([]),
    returnValueForMissingStub: Future<List<Team>>.value([]),
  );

  @override
  Future<void> addMember(String? teamId, dynamic member) => super.noSuchMethod(
    Invocation.method(#addMember, [teamId, member]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );
}

class MockRef extends Mock implements Ref {}

class MockRemoteContactDataSource extends Mock
    implements RemoteContactDataSource {
  @override
  Future<void> createContact(Contact? contact) => super.noSuchMethod(
    Invocation.method(#createContact, [contact]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );

  @override
  Future<void> updateContact(Contact? contact) => super.noSuchMethod(
    Invocation.method(#updateContact, [contact]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );

  @override
  Future<void> syncContacts(List<Contact>? contacts) => super.noSuchMethod(
    Invocation.method(#syncContacts, [contacts]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );
}
