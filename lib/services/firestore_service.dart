import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/island_model.dart';
import '../models/session_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _islands => _db.collection('islands');
  CollectionReference<Map<String, dynamic>> get _sessions => _db.collection('sessions');
  CollectionReference<Map<String, dynamic>> get _friendships => _db.collection('friendships');

  // User CRUD
  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.uid).update(user.toJson());
  }

  Stream<UserModel?> userStream(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  // Island CRUD
  Future<void> saveIsland(IslandModel island) async {
    await _islands.doc(island.userId).set(island.toJson());
  }

  Future<IslandModel?> getIsland(String userId) async {
    final doc = await _islands.doc(userId).get();
    if (!doc.exists) return null;
    return IslandModel.fromJson(doc.data()!);
  }

  Stream<IslandModel?> islandStream(String userId) {
    return _islands.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return IslandModel.fromJson(doc.data()!);
    });
  }

  // Sessions
  Future<void> saveSession(SessionModel session) async {
    await _sessions.doc(session.id).set(session.toJson());
  }

  Future<List<SessionModel>> getUserSessions(String userId, {int limit = 20}) async {
    final query = await _sessions
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: true)
        .limit(limit)
        .get();
    return query.docs.map((d) => SessionModel.fromJson(d.data())).toList();
  }

  // Friends
  Future<void> sendFriendRequest(String fromUid, String toUid) async {
    await _friendships.add({
      'from': fromUid,
      'to': toUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFriendRequest(String docId) async {
    await _friendships.doc(docId).update({'status': 'accepted'});
  }

  Future<List<String>> getFriendIds(String uid) async {
    final sent = await _friendships
        .where('from', isEqualTo: uid)
        .where('status', isEqualTo: 'accepted')
        .get();
    final received = await _friendships
        .where('to', isEqualTo: uid)
        .where('status', isEqualTo: 'accepted')
        .get();

    final ids = <String>{};
    for (final doc in sent.docs) {
      ids.add(doc.data()['to'] as String);
    }
    for (final doc in received.docs) {
      ids.add(doc.data()['from'] as String);
    }
    return ids.toList();
  }

  Future<List<Map<String, dynamic>>> getPendingRequests(String uid) async {
    final query = await _friendships
        .where('to', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .get();
    return query.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  // Leaderboard
  Future<List<UserModel>> getLeaderboard({int limit = 20}) async {
    final query = await _users
        .orderBy('totalXp', descending: true)
        .limit(limit)
        .get();
    return query.docs.map((d) => UserModel.fromJson(d.data())).toList();
  }

  // Social feed - recent sessions from friends
  Future<List<Map<String, dynamic>>> getFriendActivity(List<String> friendIds, {int limit = 20}) async {
    if (friendIds.isEmpty) return [];
    // Firestore 'in' query limited to 30 items
    final batch = friendIds.take(30).toList();
    final query = await _sessions
        .where('userId', whereIn: batch)
        .where('completed', isEqualTo: true)
        .orderBy('completedAt', descending: true)
        .limit(limit)
        .get();

    final activities = <Map<String, dynamic>>[];
    for (final doc in query.docs) {
      final session = SessionModel.fromJson(doc.data());
      final user = await getUser(session.userId);
      activities.add({
        'session': session,
        'user': user,
      });
    }
    return activities;
  }

  // Search users by display name
  Future<List<UserModel>> searchUsers(String query) async {
    final results = await _users
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(10)
        .get();
    return results.docs.map((d) => UserModel.fromJson(d.data())).toList();
  }
}
