import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Collection names for Firestore
class FirestoreCollections {
  static const String users = 'users';
  static const String contacts = 'contacts';
  static const String transactions = 'transactions';
  static const String teams = 'teams';
  static const String globalContacts = 'globalContacts';
}

/// Service for interacting with Cloud Firestore.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  /// Get Firestore instance
  FirebaseFirestore get instance => _firestore;

  /// Get a collection reference by path
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  /// Get users collection
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection(FirestoreCollections.users);

  /// Get contacts collection
  CollectionReference<Map<String, dynamic>> get contactsCollection =>
      _firestore.collection(FirestoreCollections.contacts);

  /// Get transactions collection
  CollectionReference<Map<String, dynamic>> get transactionsCollection =>
      _firestore.collection(FirestoreCollections.transactions);

  /// Get teams collection
  CollectionReference<Map<String, dynamic>> get teamsCollection =>
      _firestore.collection(FirestoreCollections.teams);

  // ============ User Profile Operations ============

  /// Create a new user document
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await usersCollection.doc(uid).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get a user document by UID
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return await usersCollection.doc(uid).get();
  }

  /// Update a user document
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await usersCollection.doc(uid).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a user document
  Future<void> deleteUser(String uid) async {
    await usersCollection.doc(uid).delete();
  }

  /// Watch a user document for real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) {
    return usersCollection.doc(uid).snapshots();
  }

  /// Check if a user document exists
  Future<bool> userExists(String uid) async {
    final doc = await usersCollection.doc(uid).get();
    return doc.exists;
  }

  /// Update user's last active timestamp
  Future<void> updateUserLastActive(String uid) async {
    await usersCollection.doc(uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  // ============ Generic Operations ============

  /// Run a Firestore transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler,
  ) async {
    return await _firestore.runTransaction(transactionHandler);
  }

  /// Create a batch write
  WriteBatch batch() => _firestore.batch();
}

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});
