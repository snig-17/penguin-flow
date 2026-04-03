import 'package:cloud_firestore/cloud_firestore.dart';

/// CRUD operations for user data in Cloud Firestore
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Creates a user document in the 'users' collection
  Future<void> createUserDocument(
      String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  /// Reads a user document
  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  /// Updates fields on a user document
  Future<void> updateUserDocument(
      String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  /// Saves a focus session to the user's sessions subcollection
  Future<void> saveSession(
      String uid, Map<String, dynamic> sessionData) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .add(sessionData);
  }

  /// Reads all sessions for a user, ordered by startTime descending
  Future<List<Map<String, dynamic>>> getSessions(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('startTime', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Increments user stats (focusMinutes, coins, xp) atomically
  Future<void> updateStats(
      String uid, int focusMinutes, int coins, int xp) async {
    await _db.collection('users').doc(uid).update({
      'totalFocusTime': FieldValue.increment(focusMinutes),
      'coins': FieldValue.increment(coins),
      'totalXP': FieldValue.increment(xp),
    });
  }
}
