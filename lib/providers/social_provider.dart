import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/island_model.dart';
import '../services/firestore_service.dart';

class SocialProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _feedItems = [];
  List<UserModel> _leaderboard = [];
  List<String> _friendIds = [];
  List<Map<String, dynamic>> _pendingRequests = [];
  List<UserModel> _searchResults = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get feedItems => _feedItems;
  List<UserModel> get leaderboard => _leaderboard;
  List<String> get friendIds => _friendIds;
  List<Map<String, dynamic>> get pendingRequests => _pendingRequests;
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> loadFeed(String uid) async {
    _isLoading = true;
    notifyListeners();

    _friendIds = await _firestoreService.getFriendIds(uid);
    _feedItems = await _firestoreService.getFriendActivity(_friendIds);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLeaderboard() async {
    _leaderboard = await _firestoreService.getLeaderboard();
    notifyListeners();
  }

  Future<void> loadPendingRequests(String uid) async {
    _pendingRequests = await _firestoreService.getPendingRequests(uid);
    notifyListeners();
  }

  Future<void> sendFriendRequest(String fromUid, String toUid) async {
    await _firestoreService.sendFriendRequest(fromUid, toUid);
    notifyListeners();
  }

  Future<void> acceptRequest(String docId, String uid) async {
    await _firestoreService.acceptFriendRequest(docId);
    await loadPendingRequests(uid);
    await loadFeed(uid);
  }

  Future<void> searchUsers(String query) async {
    if (query.length < 2) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _searchResults = await _firestoreService.searchUsers(query);
    notifyListeners();
  }

  Future<IslandModel?> getFriendIsland(String userId) async {
    return await _firestoreService.getIsland(userId);
  }
}
