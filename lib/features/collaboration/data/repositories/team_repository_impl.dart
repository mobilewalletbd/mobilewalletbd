import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mobile_wallet/core/services/firestore_service.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_expense.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_chat_message.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_activity_log.dart';
import 'package:mobile_wallet/features/collaboration/domain/repositories/team_repository.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart';

class TeamRepositoryImpl implements TeamRepository {
  final FirestoreService _firestoreService;
  final FirebaseAuth _firebaseAuth;

  TeamRepositoryImpl(this._firestoreService, this._firebaseAuth);

  @override
  Future<Team> createTeam(Team team) async {
    try {
      final data = Map<String, dynamic>.from(team.toJson());
      // Explicitly serialize members to avoid "instance of _$TeamMemberImpl" error
      data['members'] = team.members.map((m) => m.toJson()).toList();
      // Explicitly store memberIds for easier querying
      data['memberIds'] = team.members.map((m) => m.userId).toList();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      developer.log(
        '[TeamRepo] Creating team "${team.name}" with id: ${team.id}',
      );
      developer.log('[TeamRepo] memberIds: ${data['memberIds']}');
      developer.log('[TeamRepo] ownerId: ${data['ownerId']}');
      developer.log('[TeamRepo] Document fields: ${data.keys.toList()}');

      final batch = _firestoreService.instance.batch();
      final teamRef = _firestoreService.teamsCollection.doc(team.id);

      batch.set(teamRef, data);

      // Add Activity Log using the same batch
      await _addActivityLog(
        teamId: team.id,
        userId: team.ownerId,
        actionType: 'team_created',
        description: 'Created the team "${team.name}"',
        batch: batch,
      );

      await batch.commit();
      developer.log('[TeamRepo] ✅ Team written to Firestore successfully');

      // Fetch back to get populated timestamps
      final doc = await _firestoreService.teamsCollection.doc(team.id).get();
      return _documentToTeam(doc);
    } on FirebaseException catch (e) {
      developer.log(
        '[TeamRepo] ❌ Firestore error creating team: ${e.code} - ${e.message}',
      );
      throw Exception('Failed to create team: ${e.message}');
    }
  }

  @override
  Future<Team?> getTeam(String teamId) async {
    try {
      final doc = await _firestoreService.teamsCollection.doc(teamId).get();
      if (!doc.exists || doc.data() == null) return null;
      return _documentToTeam(doc);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get team: ${e.message}');
    }
  }

  @override
  Stream<Team?> getTeamStream(String teamId) {
    return _firestoreService.teamsCollection.doc(teamId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return _documentToTeam(doc);
    });
  }

  @override
  Future<List<Team>> getUserTeams(String userId) async {
    try {
      developer.log('[TeamRepo] Querying teams for userId: $userId');
      // Query teams where 'memberIds' array contains userId
      final snapshot = await _firestoreService.teamsCollection
          .where('memberIds', arrayContains: userId)
          .get();

      developer.log(
        '[TeamRepo] Found ${snapshot.docs.length} team(s) for user',
      );
      for (final doc in snapshot.docs) {
        developer.log('[TeamRepo]   - Team: ${doc.data()['name']} (${doc.id})');
      }

      return snapshot.docs.map((doc) => _documentToTeam(doc)).toList();
    } on FirebaseException catch (e) {
      developer.log(
        '[TeamRepo] ❌ Error querying teams: ${e.code} - ${e.message}',
      );
      throw Exception('Failed to get user teams: ${e.message}');
    }
  }

  @override
  Stream<List<Team>> getUserTeamsStream(String userId) {
    return _firestoreService.teamsCollection
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _documentToTeam(doc)).toList(),
        );
  }

  @override
  Future<void> addMember(String teamId, TeamMember member) async {
    try {
      // Add member to members list and also update memberIds array
      await _firestoreService.teamsCollection.doc(teamId).update({
        'members': FieldValue.arrayUnion([member.toJson()]),
        'memberIds': FieldValue.arrayUnion([member.userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Add Activity Log
      await _addActivityLog(
        teamId: teamId,
        userId: member.userId,
        actionType: 'member_added',
        description: 'Added as a new member',
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to add member: ${e.message}');
    }
  }

  @override
  Future<void> removeMember(String teamId, String userId) async {
    try {
      await _firestoreService.runTransaction((transaction) async {
        final docRef = _firestoreService.teamsCollection.doc(teamId);
        final doc = await transaction.get(docRef);
        if (!doc.exists) throw Exception('Team not found');

        final team = _documentToTeam(doc);
        final updatedMembers = team.members
            .where((m) => m.userId != userId)
            .toList();
        final updatedMemberIds = updatedMembers.map((m) => m.userId).toList();

        transaction.update(docRef, {
          'members': updatedMembers.map((m) => m.toJson()).toList(),
          'memberIds': updatedMemberIds,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Add Activity Log
        await _addActivityLog(
          teamId: teamId,
          userId: userId,
          actionType: 'member_removed',
          description: 'Removed from the team',
          transaction: transaction,
        );
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to remove member: ${e.message}');
    }
  }

  @override
  Future<void> updateTeam(Team team) async {
    try {
      final data = Map<String, dynamic>.from(team.toJson());
      // Explicitly serialize members to avoid "instance of _$TeamMemberImpl" error
      data['members'] = team.members.map((m) => m.toJson()).toList();
      // Ensure memberIds is synced with current members list
      data['memberIds'] = team.members.map((m) => m.userId).toList();
      data.remove('createdAt'); // Don't update createdAt
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestoreService.teamsCollection.doc(team.id).update(data);

      // Add Activity Log
      await _addActivityLog(
        teamId: team.id,
        userId: 'system', // Or current user if we have it
        actionType: 'team_profile_updated',
        description: 'Updated team profile details',
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to update team: ${e.message}');
    }
  }

  @override
  Future<void> deleteTeam(String teamId) async {
    try {
      final batch = _firestoreService.instance.batch();

      // 1. Find all contacts shared with this team
      final sharedContactsQuery = await _firestoreService.instance
          .collection('contacts')
          .where('sharedWithTeams', arrayContains: teamId)
          .get();

      // 2. Remove the teamId from each contact's sharedWithTeams array
      for (final doc in sharedContactsQuery.docs) {
        batch.update(doc.reference, {
          'sharedWithTeams': FieldValue.arrayRemove([teamId]),
        });
      }

      // 3. Delete the team document itself
      final teamRef = _firestoreService.teamsCollection.doc(teamId);
      batch.delete(teamRef);

      // Commit all changes atomically
      await batch.commit();

      developer.log(
        '[TeamRepo] ✅ Team $teamId deleted and associated contacts updated.',
      );
    } on FirebaseException catch (e) {
      developer.log('[TeamRepo] ❌ Failed to delete team: ${e.message}');
      throw Exception('Failed to delete team: ${e.message}');
    }
  }

  @override
  Future<void> updateMemberRole(
    String teamId,
    String userId,
    String newRole,
  ) async {
    try {
      final doc = await _firestoreService.teamsCollection.doc(teamId).get();
      if (!doc.exists) throw Exception('Team not found');

      final team = _documentToTeam(doc);
      final updatedMembers = team.members.map((m) {
        if (m.userId == userId) return m.copyWith(role: newRole);
        return m;
      }).toList();

      await _firestoreService.teamsCollection.doc(teamId).update({
        'members': updatedMembers.map((m) => m.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Add Activity Log
      await _addActivityLog(
        teamId: teamId,
        userId: userId,
        actionType: 'role_updated',
        description: 'Role updated to $newRole',
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to update member role: ${e.message}');
    }
  }

  Team _documentToTeam(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    // Handle Timestamps
    data['createdAt'] = _timestampToString(data['createdAt']);
    data['updatedAt'] = _timestampToString(data['updatedAt']);

    // Ensure 'id' is in data if it's expected by fromJson (or Freezed handles it?)
    // Our Team entity has 'id' field.
    data['id'] = doc.id;

    return Team.fromJson(data);
  }

  String _timestampToString(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate().toIso8601String();
    }
    if (timestamp is String) {
      return timestamp;
    }
    // Fallback for null or pending server timestamps
    return DateTime.now().toIso8601String();
  }

  // --- Sub-features Implementations ---

  @override
  Future<void> addTeamExpense(String teamId, TeamExpense expense) async {
    try {
      final batch = _firestoreService.instance.batch();

      // 1. Add the new expense document
      final expenseDoc = _firestoreService.instance
          .collection('team_expenses')
          .doc(expense.id);
      final data = Map<String, dynamic>.from(expense.toJson());
      data['createdAt'] = FieldValue.serverTimestamp();
      batch.set(expenseDoc, data);

      // 2. Increment the total expenses on the team document
      final teamDoc = _firestoreService.instance
          .collection('teams')
          .doc(teamId);
      batch.update(teamDoc, {
        'totalExpenses': FieldValue.increment(expense.amount),
      });

      // 3. Create an activity log
      final log = TeamActivityLog(
        id: expense.id, // Or a new UUID
        teamId: teamId,
        userId: expense.addedByUserId,
        actionType: 'expense_created',
        description:
            'Added expense of \$${expense.amount} for ${expense.title}',
        timestamp: DateTime.now(),
      );
      final logData = Map<String, dynamic>.from(log.toJson());
      logData['timestamp'] = FieldValue.serverTimestamp();
      final logDoc = _firestoreService.instance
          .collection('team_activity_logs')
          .doc();
      batch.set(logDoc, logData);

      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('Failed to add team expense: ${e.message}');
    }
  }

  @override
  Stream<List<TeamExpense>> getTeamExpensesStream(
    String teamId, {
    int limit = 20,
  }) {
    return _firestoreService.instance
        .collection('team_expenses')
        .where('teamId', isEqualTo: teamId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['date'] = _timestampToString(
              data['date'] ?? data['createdAt'],
            );
            data['id'] = doc.id;
            return TeamExpense.fromJson(data);
          }).toList(),
        );
  }

  @override
  Future<void> sendTeamChatMessage(
    String teamId,
    TeamChatMessage message,
  ) async {
    try {
      final data = Map<String, dynamic>.from(message.toJson());
      data['createdAt'] = FieldValue.serverTimestamp();
      await _firestoreService.instance
          .collection('team_chat_messages')
          .doc(message.id)
          .set(data);
    } on FirebaseException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  @override
  Stream<List<TeamChatMessage>> getTeamChatStream(
    String teamId, {
    int limit = 50,
  }) {
    return _firestoreService.instance
        .collection('team_chat_messages')
        .where('teamId', isEqualTo: teamId)
        .orderBy(
          'createdAt',
          descending: true,
        ) // Changed to descending for pagination
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs.map((doc) {
            final data = doc.data();
            data['timestamp'] = _timestampToString(
              data['timestamp'] ?? data['createdAt'],
            );
            data['id'] = doc.id;
            return TeamChatMessage.fromJson(data);
          }).toList();
          // Reverse back to ascending for UI (older first)
          return messages.reversed.toList();
        });
  }

  @override
  Stream<List<TeamActivityLog>> getTeamActivityStream(
    String teamId, {
    int limit = 20,
  }) {
    return _firestoreService.instance
        .collection('team_activity_logs')
        .where('teamId', isEqualTo: teamId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['timestamp'] = _timestampToString(data['timestamp']);
            data['id'] = doc.id;
            return TeamActivityLog.fromJson(data);
          }).toList(),
        );
  }

  @override
  Future<void> inviteMember(
    String teamId, {
    String? email,
    String? phoneNumber,
    required String role,
  }) async {
    try {
      if (email == null && phoneNumber == null) {
        throw Exception('Either email or phone number must be provided');
      }

      String userId = '';
      final inviteValue = email ?? phoneNumber!;

      // 1. Check if user exists
      if (email != null) {
        final userQuery = await _firestoreService.usersCollection
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (userQuery.docs.isNotEmpty) userId = userQuery.docs.first.id;
      } else if (phoneNumber != null) {
        final userQuery = await _firestoreService.usersCollection
            .where('phoneNumber', isEqualTo: phoneNumber)
            .limit(1)
            .get();
        if (userQuery.docs.isNotEmpty) userId = userQuery.docs.first.id;
      }

      if (userId.isEmpty) {
        userId = 'pending_$inviteValue';
      }

      final member = TeamMember(
        userId: userId,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
        joinedAt: DateTime.now(),
        status: 'pending',
      );

      // 2. Add to team
      await _firestoreService.teamsCollection.doc(teamId).update({
        'members': FieldValue.arrayUnion([member.toJson()]),
        if (email != null) 'invitedEmails': FieldValue.arrayUnion([email]),
        if (phoneNumber != null)
          'invitedPhones': FieldValue.arrayUnion([phoneNumber]),
        if (!userId.startsWith('pending_'))
          'memberIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 3. Activity Log — use the actual inviting user's UID, not 'system'
      final actingUserId = _firebaseAuth.currentUser?.uid ?? 'unknown';
      await _addActivityLog(
        teamId: teamId,
        userId: actingUserId,
        actionType: 'member_invited',
        description: 'Invited $inviteValue as $role',
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to invite member: ${e.message}');
    }
  }

  @override
  Future<void> respondToInvite(
    String teamId,
    String userId,
    String? email,
    String? phoneNumber,
    bool accept,
  ) async {
    try {
      await _firestoreService.runTransaction((transaction) async {
        final docRef = _firestoreService.teamsCollection.doc(teamId);
        final doc = await transaction.get(docRef);
        if (!doc.exists) throw Exception('Team not found');

        final team = _documentToTeam(doc);
        // Find member by userId, email, or phoneNumber
        final memberIndex = team.members.indexWhere(
          (m) =>
              m.userId == userId ||
              (email != null && m.email == email) ||
              (phoneNumber != null && m.phoneNumber == phoneNumber),
        );

        if (memberIndex == -1) throw Exception('Invitation not found');

        final member = team.members[memberIndex];
        List<TeamMember> updatedMembers = List.from(team.members);
        List<String> updatedMemberIds = List.from(team.memberIds);
        List<String> updatedInvitedEmails = List.from(team.invitedEmails);
        List<String> updatedInvitedPhones = List.from(team.invitedPhones);

        if (accept) {
          updatedMembers[memberIndex] = member.copyWith(
            status: 'active',
            userId: userId,
            joinedAt: DateTime.now(),
          );
          if (!updatedMemberIds.contains(userId)) {
            updatedMemberIds.add(userId);
          }
        } else {
          updatedMembers.removeAt(memberIndex);
          updatedMemberIds.remove(member.userId);
        }

        // Clean up invite trackers
        if (member.email != null) {
          updatedInvitedEmails.remove(member.email);
        }
        if (member.phoneNumber != null) {
          updatedInvitedPhones.remove(member.phoneNumber);
        }

        transaction.update(docRef, {
          'members': updatedMembers.map((m) => m.toJson()).toList(),
          'memberIds': updatedMemberIds,
          'invitedEmails': updatedInvitedEmails,
          'invitedPhones': updatedInvitedPhones,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Activity Log for acceptance
        if (accept) {
          final log = TeamActivityLog(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            teamId: teamId,
            userId: userId,
            actionType: 'member_joined',
            description: 'Joined the team',
            timestamp: DateTime.now(),
          );
          final logData = Map<String, dynamic>.from(log.toJson());
          logData['timestamp'] = FieldValue.serverTimestamp();
          transaction.set(
            _firestoreService.instance.collection('team_activity_logs').doc(),
            logData,
          );
        }
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to respond to invite: ${e.message}');
    }
  }

  @override
  Stream<List<Team>> getPendingInvitesStream(
    String userId,
    String? email,
    String? phoneNumber,
  ) {
    if ((email == null || email.isEmpty) &&
        (phoneNumber == null || phoneNumber.isEmpty)) {
      return Stream.value([]);
    }

    // Use Firestore's Filter.or to query both fields securely
    // This requires rules allowing read for these fields
    final filters = <Filter>[];
    if (email != null && email.isNotEmpty) {
      filters.add(Filter('invitedEmails', arrayContains: email));
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      filters.add(Filter('invitedPhones', arrayContains: phoneNumber));
    }

    final queryFilter = filters.length == 1
        ? filters.single
        : Filter.or(filters[0], filters[1]);

    return _firestoreService.teamsCollection.where(queryFilter).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => _documentToTeam(doc)).where((team) {
          // Double check not already a member
          return !team.memberIds.contains(userId);
        }).toList();
      },
    );
  }

  Future<void> _addActivityLog({
    required String teamId,
    required String userId,
    required String actionType,
    required String description,
    WriteBatch? batch,
    Transaction? transaction,
  }) async {
    final log = TeamActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      teamId: teamId,
      userId: userId,
      actionType: actionType,
      description: description,
      timestamp: DateTime.now(),
    );
    final logData = Map<String, dynamic>.from(log.toJson());
    logData['timestamp'] = FieldValue.serverTimestamp();

    if (transaction != null) {
      transaction.set(
        _firestoreService.instance.collection('team_activity_logs').doc(),
        logData,
      );
    } else if (batch != null) {
      batch.set(
        _firestoreService.instance.collection('team_activity_logs').doc(),
        logData,
      );
    } else {
      await _firestoreService.instance
          .collection('team_activity_logs')
          .add(logData);
    }
  }

  @override
  Stream<List<Team>> discoverPublicTeams(String query) {
    var collectionQuery = _firestoreService.teamsCollection.where(
      'visibility',
      isEqualTo: 'public',
    );

    return collectionQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _documentToTeam(doc)).where((team) {
        if (query.isEmpty) return true;
        final q = query.toLowerCase();
        return team.name.toLowerCase().contains(q) ||
            (team.description?.toLowerCase().contains(q) ?? false);
      }).toList();
    });
  }

  @override
  Future<List<Contact>> getSharedContacts(
    String teamId, {
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final isar = IsarService.instance;
      final contacts = await isar.contactIsars
          .filter()
          .sharedWithTeamsElementEqualTo(teamId)
          .sortByFullName()
          .offset(offset)
          .limit(limit)
          .findAll();

      return contacts.map(_mapIsarToContact).toList();
    } catch (e) {
      developer.log('[TeamRepo] ❌ Error getting shared contacts: $e');
      throw Exception('Failed to get shared contacts: $e');
    }
  }

  Contact _mapIsarToContact(ContactIsar isarContact) {
    return Contact(
      id: isarContact.contactId,
      ownerId: isarContact.ownerId,
      fullName: isarContact.fullName,
      firstName: isarContact.firstName,
      lastName: isarContact.lastName,
      jobTitle: isarContact.jobTitle,
      companyName: isarContact.companyName,
      phoneNumbers: isarContact.phoneNumbers,
      emails: isarContact.emails,
      addresses: isarContact.addresses,
      websiteUrls: isarContact.websiteUrls,
      socialLinks: [], // Simplified mapping
      category: isarContact.category.name,
      tags: isarContact.tags,
      isFavorite: isarContact.isFavorite,
      notes: isarContact.notes,
      frontImageUrl: isarContact.frontImageUrl,
      backImageUrl: isarContact.backImageUrl,
      frontImageOcrText: isarContact.frontImageOcrText,
      backImageOcrText: isarContact.backImageOcrText,
      lastContactedAt: isarContact.lastContactedAt,
      contactCount: isarContact.contactCount,
      source: isarContact.source?.name,
      isVerified: isarContact.isVerified,
      fraudScore: isarContact.fraudScore,
      createdAt: isarContact.createdAt,
      updatedAt: isarContact.updatedAt,
      createdBy: isarContact.createdBy,
      sharedWith: isarContact.sharedWith.isNotEmpty
          ? isarContact.sharedWith
          : null,
      sharedWithTeams: isarContact.sharedWithTeams,
    );
  }

  @override
  Future<void> joinTeam(String teamId, String userId) async {
    try {
      final userDoc = await _firestoreService.usersCollection.doc(userId).get();
      final userEmail = userDoc.data()?['email'] as String?;

      final member = TeamMember(
        userId: userId,
        email: userEmail,
        role: 'member',
        joinedAt: DateTime.now(),
        status: 'active',
      );

      await _firestoreService.teamsCollection.doc(teamId).update({
        'members': FieldValue.arrayUnion([member.toJson()]),
        'memberIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Activity Log
      await _addActivityLog(
        teamId: teamId,
        userId: userId,
        actionType: 'member_joined',
        description: 'Joined the team via discovery',
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to join team: ${e.message}');
    }
  }
}

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final firebaseAuth = FirebaseAuth.instance;
  return TeamRepositoryImpl(firestoreService, firebaseAuth);
});
