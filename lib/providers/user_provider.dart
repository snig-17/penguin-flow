import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/gamification_service.dart';
import '../models/achievement_model.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService;
  final GamificationService _gamificationService = GamificationService();

  UserModel? _user;
  List<SessionModel> _recentSessions = [];
  List<AchievementModel> _newAchievements = [];

  UserProvider(this._storageService);

  UserModel? get user => _user;
  List<SessionModel> get recentSessions => _recentSessions;
  List<AchievementModel> get newAchievements => _newAchievements;
  GamificationService get gamification => _gamificationService;

  int get level => _user?.level ?? 1;
  double get levelProgress => _user?.levelProgress ?? 0;
  int get totalXp => _user?.totalXp ?? 0;
  int get currentStreak => _user?.currentStreak ?? 0;
  int get totalSessions => _user?.totalSessions ?? 0;
  int get totalFocusMinutes => _user?.totalFocusMinutes ?? 0;

  void setUser(UserModel? user) {
    _user = user;
    if (user != null) {
      _gamificationService.syncUnlockedState(user.unlockedAchievements);
    }
    notifyListeners();
  }

  Future<void> loadRecentSessions() async {
    if (_user == null) return;
    _recentSessions = await _firestoreService.getUserSessions(_user!.uid);
    notifyListeners();
  }

  Future<void> onSessionCompleted(SessionModel session) async {
    if (_user == null) return;

    _user!.addXp(session.xpEarned);
    _user!.completeSession(session.actualMinutes);

    _newAchievements = _gamificationService.checkNewAchievements(_user!, session);

    await _firestoreService.updateUser(_user!);
    await _storageService.saveUser(_user!);

    _recentSessions.insert(0, session);
    if (_recentSessions.length > 20) {
      _recentSessions = _recentSessions.sublist(0, 20);
    }

    notifyListeners();
  }

  void clearNewAchievements() {
    _newAchievements = [];
    notifyListeners();
  }

  Future<void> syncFromFirestore() async {
    if (_user == null) return;
    final remote = await _firestoreService.getUser(_user!.uid);
    if (remote != null) {
      _user = remote;
      _gamificationService.syncUnlockedState(remote.unlockedAchievements);
      await _storageService.saveUser(remote);
      notifyListeners();
    }
  }
}
