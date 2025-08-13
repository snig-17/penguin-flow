// lib/services/gamification_service.dart
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/achievement_model.dart';
import './storage_service.dart';

class GamificationService extends ChangeNotifier {
  final StorageService _storageService;
  UserModel? _currentUser;
  List<AchievementModel> _unlockedAchievements = [];

  GamificationService(this._storageService) {
    _loadUserData();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  List<AchievementModel> get unlockedAchievements => _unlockedAchievements;
  List<AchievementModel> get availableAchievements => AchievementModel.allAchievements;

  // User progression
  int get currentLevel => _currentUser?.level ?? 1;
  int get currentXP => _currentUser?.totalXP ?? 0;
  int get currentStreak => _currentUser?.currentStreak ?? 0;
  int get longestStreak => _currentUser?.longestStreak ?? 0;
  int get totalSessions => _currentUser?.completedSessions ?? 0;

  // Level progression calculations
  int xpForLevel(int level) => (level * level * 100) + (level * 50);
  int xpToNextLevel() {
    final nextLevel = currentLevel + 1;
    final requiredXP = xpForLevel(nextLevel);
    return requiredXP - currentXP;
  }
  double levelProgress() {
    final currentLevelXP = xpForLevel(currentLevel);
    final nextLevelXP = xpForLevel(currentLevel + 1);
    final progressXP = currentXP - currentLevelXP;
    final totalXPNeeded = nextLevelXP - currentLevelXP;
    return totalXPNeeded > 0 ? progressXP / totalXPNeeded : 0.0;
  }

  // Session completion and XP awarding
  Future<List<AchievementModel>> completeSession(SessionModel session) async {
    if (_currentUser == null) return [];

    // Update user stats
    final updatedUser = _currentUser!.copyWith(
      totalXP: _currentUser!.totalXP + session.xpEarned,
      completedSessions: _currentUser!.completedSessions + 1,
      totalFocusTime: _currentUser!.totalFocusTime + session.actualDuration.inMinutes,
    );

    // Update streak if session was completed today
    final newUser = _updateStreak(updatedUser, session);

    // Check for level up
    final leveledUpUser = _checkLevelUp(newUser);

    // Update current user
    _currentUser = leveledUpUser;

    // Check for new achievements
    final newAchievements = await _checkAchievements();

    // Save user data
    await _saveUserData();

    notifyListeners();
    return newAchievements;
  }

  // Streak management
  UserModel _updateStreak(UserModel user, SessionModel session) {
    final today = DateTime.now();
    final sessionDate = session.startTime;

    // Check if session was completed today
    if (_isSameDay(sessionDate, today) && session.wasCompleted) {
      final lastActivityDate = user.lastActivityDate;

      if (lastActivityDate == null) {
        // First session ever
        return user.copyWith(
          currentStreak: 1,
          longestStreak: 1,
          lastActivityDate: today,
        );
      } else if (_isSameDay(lastActivityDate, today)) {
        // Already had activity today - no streak change
        return user.copyWith(lastActivityDate: today);
      } else if (_isConsecutiveDay(lastActivityDate, today)) {
        // Consecutive day - increment streak
        final newStreak = user.currentStreak + 1;
        return user.copyWith(
          currentStreak: newStreak,
          longestStreak: max(user.longestStreak, newStreak),
          lastActivityDate: today,
        );
      } else {
        // Gap in days - reset streak
        return user.copyWith(
          currentStreak: 1,
          longestStreak: max(user.longestStreak, 1),
          lastActivityDate: today,
        );
      }
    }

    return user;
  }

  // Achievement checking
  Future<List<AchievementModel>> _checkAchievements() async {
    if (_currentUser == null) return [];

    final newAchievements = <AchievementModel>[];

    for (final achievement in AchievementModel.allAchievements) {
      if (_unlockedAchievements.any((a) => a.id == achievement.id)) continue;

      if (_hasUnlockedAchievement(achievement)) {
        newAchievements.add(achievement);
        _unlockedAchievements.add(achievement);

        // Award XP for achievement
        _currentUser = _currentUser!.copyWith(
          totalXP: _currentUser!.totalXP + achievement.xpReward,
        );
      }
    }

    return newAchievements;
  }

  bool _hasUnlockedAchievement(AchievementModel achievement) {
    if (_currentUser == null) return false;

    switch (achievement.id) {
      case 'first_session':
        return _currentUser!.completedSessions >= 1;
      case 'early_bird':
        return _hasEarlyMorningSessions();
      case 'night_owl':
        return _hasLateNightSessions();
      case 'streak_3':
        return _currentUser!.currentStreak >= 3;
      case 'streak_7':
        return _currentUser!.currentStreak >= 7;
      case 'streak_30':
        return _currentUser!.currentStreak >= 30;
      case 'marathon':
        return _hasLongSession(120); // 2 hours
      case 'century':
        return _currentUser!.completedSessions >= 100;
      case 'focused':
        return _currentUser!.totalFocusTime >= 600; // 10 hours
      case 'dedicated':
        return _currentUser!.totalFocusTime >= 6000; // 100 hours
      case 'level_5':
        return _currentUser!.level >= 5;
      case 'level_10':
        return _currentUser!.level >= 10;
      case 'level_25':
        return _currentUser!.level >= 25;
      case 'perfectionist':
        return _hasHighCompletionRate();
      case 'social_butterfly':
        return _currentUser!.friendsCount >= 10;
      default:
        return false;
    }
  }

  // Helper methods for achievement checking
  bool _hasEarlyMorningSessions() {
    // This would check stored session data for sessions between 5-8 AM
    // For now, returning false as we don't have session history in current model
    return false;
  }

  bool _hasLateNightSessions() {
    // This would check stored session data for sessions between 10 PM - 2 AM
    return false;
  }

  bool _hasLongSession(int minutes) {
    // This would check if user has completed a session longer than specified minutes
    return false;
  }

  bool _hasHighCompletionRate() {
    // This would calculate completion rate from session history
    // For now, using a simple heuristic
    return _currentUser!.completedSessions >= 20;
  }

  // Level up checking
  UserModel _checkLevelUp(UserModel user) {
    int newLevel = user.level;

    while (user.totalXP >= xpForLevel(newLevel + 1)) {
      newLevel++;
    }

    return user.copyWith(level: newLevel);
  }

  // Island building progress
  double get islandProgress {
    if (_currentUser == null) return 0.0;
    return min(1.0, _currentUser!.totalFocusTime / 1000.0); // Complete at 1000 minutes
  }

  int get availableBuildings {
    final progress = islandProgress;
    if (progress >= 1.0) return 10;
    if (progress >= 0.8) return 8;
    if (progress >= 0.6) return 6;
    if (progress >= 0.4) return 4;
    if (progress >= 0.2) return 2;
    return 1;
  }

  // Data persistence
  Future<void> _loadUserData() async {
    _currentUser = await _storageService.getUser();
    _unlockedAchievements = await _storageService.getAchievements();

    // Create default user if none exists
    if (_currentUser == null) {
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Penguin Explorer',
        email: '',
        avatarPath: 'assets/images/penguin_default.png',
        level: 1,
        totalXP: 0,
        currentStreak: 0,
        longestStreak: 0,
        completedSessions: 0,
        totalFocusTime: 0,
        joinDate: DateTime.now(),
        lastActivityDate: null,
        friendsCount: 0,
        islandTheme: IslandTheme.arctic,
        notificationsEnabled: true,
        soundEnabled: true,
        darkModeEnabled: false,
      );
      await _saveUserData();
    }

    notifyListeners();
  }

  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      await _storageService.saveUser(_currentUser!);
      await _storageService.saveAchievements(_unlockedAchievements);
    }
  }

  // Utility methods
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _isConsecutiveDay(DateTime previousDate, DateTime currentDate) {
    final difference = currentDate.difference(previousDate).inDays;
    return difference == 1;
  }

  // Public methods for UI
  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? avatarPath,
    IslandTheme? theme,
    bool? notifications,
    bool? sound,
    bool? darkMode,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
      avatarPath: avatarPath ?? _currentUser!.avatarPath,
      islandTheme: theme ?? _currentUser!.islandTheme,
      notificationsEnabled: notifications ?? _currentUser!.notificationsEnabled,
      soundEnabled: sound ?? _currentUser!.soundEnabled,
      darkModeEnabled: darkMode ?? _currentUser!.darkModeEnabled,
    );

    await _saveUserData();
    notifyListeners();
  }

  Future<void> addFriend() async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      friendsCount: _currentUser!.friendsCount + 1,
    );

    await _saveUserData();
    notifyListeners();
  }
}
