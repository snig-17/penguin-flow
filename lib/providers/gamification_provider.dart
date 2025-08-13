// lib/providers/gamification_provider.dart
import 'package:flutter/foundation.dart';
import '../../../services/gamification_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/user_model.dart';
import '../../../models/achievement_model.dart';
import '../../../models/session_model.dart';

class GamificationProvider extends ChangeNotifier {
  final GamificationService _gamificationService;
  final StorageService _storageService;

  List<AchievementModel> _recentlyUnlocked = [];
  bool _showLevelUpCelebration = false;
  int _previousLevel = 1;

  GamificationProvider({
    required GamificationService gamificationService,
    required StorageService storageService,
  }) : _gamificationService = gamificationService,
       _storageService = storageService {
    // Listen to gamification service changes
    _gamificationService.addListener(_onGamificationUpdate);
    _previousLevel = _gamificationService.currentLevel;
  }

  // Core gamification data
  UserModel? get currentUser => _gamificationService.currentUser;
  List<AchievementModel> get unlockedAchievements => _gamificationService.unlockedAchievements;
  List<AchievementModel> get availableAchievements => _gamificationService.availableAchievements;

  // Level and XP
  int get currentLevel => _gamificationService.currentLevel;
  int get currentXP => _gamificationService.currentXP;
  int get xpToNextLevel => _gamificationService.xpToNextLevel();
  double get levelProgress => _gamificationService.levelProgress();

  // Statistics
  int get currentStreak => _gamificationService.currentStreak;
  int get longestStreak => _gamificationService.longestStreak;
  int get totalSessions => _gamificationService.totalSessions;

  // Celebration state
  List<AchievementModel> get recentlyUnlocked => _recentlyUnlocked;
  bool get showLevelUpCelebration => _showLevelUpCelebration;
  bool get hasCelebrations => _recentlyUnlocked.isNotEmpty || _showLevelUpCelebration;

  // Achievement categories
  List<AchievementModel> get sessionAchievements => 
      availableAchievements.where((a) => a.category == 'sessions').toList();

  List<AchievementModel> get streakAchievements => 
      availableAchievements.where((a) => a.category == 'streaks').toList();

  List<AchievementModel> get levelAchievements => 
      availableAchievements.where((a) => a.category == 'levels').toList();

  List<AchievementModel> get timeAchievements => 
      availableAchievements.where((a) => a.category == 'time').toList();

  List<AchievementModel> get socialAchievements => 
      availableAchievements.where((a) => a.category == 'social').toList();

  // Achievement rarity groups
  List<AchievementModel> get commonAchievements => 
      unlockedAchievements.where((a) => a.rarity == AchievementRarity.common).toList();

  List<AchievementModel> get rareAchievements => 
      unlockedAchievements.where((a) => a.rarity == AchievementRarity.rare).toList();

  List<AchievementModel> get epicAchievements => 
      unlockedAchievements.where((a) => a.rarity == AchievementRarity.epic).toList();

  List<AchievementModel> get legendaryAchievements => 
      unlockedAchievements.where((a) => a.rarity == AchievementRarity.legendary).toList();

  // Progress calculations
  double get overallAchievementProgress => 
      availableAchievements.isNotEmpty 
          ? unlockedAchievements.length / availableAchievements.length 
          : 0.0;

  Map<String, double> get categoryProgress {
    final categories = ['sessions', 'streaks', 'levels', 'time', 'social'];
    final progress = <String, double>{};

    for (final category in categories) {
      final total = availableAchievements.where((a) => a.category == category).length;
      final unlocked = unlockedAchievements.where((a) => a.category == category).length;
      progress[category] = total > 0 ? unlocked / total : 0.0;
    }

    return progress;
  }

  Map<AchievementRarity, double> get rarityProgress {
    final rarities = AchievementRarity.values;
    final progress = <AchievementRarity, double>{};

    for (final rarity in rarities) {
      final total = availableAchievements.where((a) => a.rarity == rarity).length;
      final unlocked = unlockedAchievements.where((a) => a.rarity == rarity).length;
      progress[rarity] = total > 0 ? unlocked / total : 0.0;
    }

    return progress;
  }

  // Achievement checking and unlocking
  Future<List<AchievementModel>> processSessionCompletion(SessionModel session) async {
    final newAchievements = await _gamificationService.completeSession(session);

    if (newAchievements.isNotEmpty) {
      _recentlyUnlocked.addAll(newAchievements);
      notifyListeners();
    }

    return newAchievements;
  }

  void dismissAchievementCelebration(String achievementId) {
    _recentlyUnlocked.removeWhere((a) => a.id == achievementId);
    notifyListeners();
  }

  void dismissAllAchievementCelebrations() {
    _recentlyUnlocked.clear();
    notifyListeners();
  }

  void dismissLevelUpCelebration() {
    _showLevelUpCelebration = false;
    notifyListeners();
  }

  void dismissAllCelebrations() {
    _recentlyUnlocked.clear();
    _showLevelUpCelebration = false;
    notifyListeners();
  }

  // Level system helpers
  String getLevelTitle(int level) {
    if (level >= 50) return 'Penguin Master';
    if (level >= 25) return 'Focus Expert';
    if (level >= 15) return 'Productivity Pro';
    if (level >= 10) return 'Focused Achiever';
    if (level >= 5) return 'Rising Star';
    return 'Beginner Explorer';
  }

  String getLevelDescription(int level) {
    if (level >= 50) return 'You have achieved the ultimate mastery of focus!';
    if (level >= 25) return 'Your expertise in focus is truly impressive!';
    if (level >= 15) return 'You\'re a productivity professional!';
    if (level >= 10) return 'Your focus achievements are remarkable!';
    if (level >= 5) return 'You\'re rising through the ranks quickly!';
    return 'Welcome to your focus journey!';
  }

  List<String> getLevelRewards(int level) {
    final rewards = <String>[];

    if (level >= 5) rewards.add('Tropical Island Theme');
    if (level >= 10) rewards.add('Forest Island Theme');
    if (level >= 15) rewards.add('Desert Island Theme');
    if (level >= 20) rewards.add('Volcanic Island Theme');
    if (level >= 25) rewards.add('Crystal Island Theme');
    if (level >= 30) rewards.add('Advanced Statistics');
    if (level >= 35) rewards.add('Custom Session Types');
    if (level >= 40) rewards.add('Export/Import Data');
    if (level >= 45) rewards.add('Premium Penguin Avatars');
    if (level >= 50) rewards.add('Master\'s Crown');

    return rewards;
  }

  // Achievement helpers
  bool isAchievementUnlocked(String achievementId) {
    return unlockedAchievements.any((a) => a.id == achievementId);
  }

  AchievementModel? getAchievement(String achievementId) {
    try {
      return availableAchievements.firstWhere((a) => a.id == achievementId);
    } catch (e) {
      return null;
    }
  }

  List<AchievementModel> getAchievementsForCategory(String category) {
    return availableAchievements.where((a) => a.category == category).toList();
  }

  List<AchievementModel> getUnlockedAchievementsForCategory(String category) {
    return unlockedAchievements.where((a) => a.category == category).toList();
  }

  List<AchievementModel> getLockedAchievementsForCategory(String category) {
    final categoryAchievements = getAchievementsForCategory(category);
    return categoryAchievements.where((a) => !isAchievementUnlocked(a.id)).toList();
  }

  // Streak helpers
  bool get hasActiveStreak => currentStreak > 0;

  bool get isStreakAtRisk {
    final lastActivity = currentUser?.lastActivityDate;
    if (lastActivity == null) return false;

    final now = DateTime.now();
    final daysSinceLastActivity = now.difference(lastActivity).inDays;
    return daysSinceLastActivity >= 1;
  }

  String get streakStatus {
    if (!hasActiveStreak) return 'Start your streak today!';
    if (isStreakAtRisk) return 'Your streak is at risk! Complete a session today.';
    return 'Great job! Keep your streak alive!';
  }

  int get daysUntilStreakLoss {
    final lastActivity = currentUser?.lastActivityDate;
    if (lastActivity == null) return 0;

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final daysSinceActivity = now.difference(lastActivity).inDays;

    return (1 - daysSinceActivity).clamp(0, 1);
  }

  // XP and reward calculations
  int getTotalXPFromAchievements() {
    return unlockedAchievements.fold(0, (sum, achievement) => sum + achievement.xpReward);
  }

  int getXPRequiredForLevel(int level) {
    return _gamificationService.xpForLevel(level);
  }

  int getXPEarnedAtLevel(int level) {
    if (level <= 1) return 0;
    return getXPRequiredForLevel(level) - getXPRequiredForLevel(level - 1);
  }

  // Statistics and analytics
  Map<String, dynamic> get gamificationStats {
    final totalXPFromAchievements = getTotalXPFromAchievements();
    final totalXPFromSessions = currentXP - totalXPFromAchievements;

    return {
      'level': currentLevel,
      'totalXP': currentXP,
      'xpFromSessions': totalXPFromSessions,
      'xpFromAchievements': totalXPFromAchievements,
      'xpToNextLevel': xpToNextLevel,
      'levelProgress': levelProgress,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalSessions': totalSessions,
      'achievementsUnlocked': unlockedAchievements.length,
      'achievementProgress': overallAchievementProgress,
    };
  }

  // Motivational content
  String get motivationalMessage {
    if (currentLevel == 1 && totalSessions == 0) {
      return 'Welcome to PenguinFlow! Start your first session to begin your journey! 🐧';
    }

    if (isStreakAtRisk) {
      return 'Your streak needs attention! Complete a session today to keep it alive! 🔥';
    }

    if (xpToNextLevel <= 50) {
      return 'You\'re so close to leveling up! Just \${xpToNextLevel} XP to go! ⭐';
    }

    if (currentStreak >= 7) {
      return 'Amazing streak! You\'re building fantastic habits! 💪';
    }

    final messages = [
      'Keep up the great work! Every session counts! 🚀',
      'Your focus journey is inspiring! 🌟',
      'Consistency is key - you\'re doing great! 📈',
      'Building habits one session at a time! 🏗️',
      'Your dedication is paying off! 💎',
    ];

    return messages[currentLevel % messages.length];
  }

  String getNextAchievementHint() {
    final locked = availableAchievements.where((a) => !isAchievementUnlocked(a.id)).toList();
    if (locked.isEmpty) return 'You\'ve unlocked all achievements! Amazing! 🏆';

    // Find the closest achievement to unlock
    locked.sort((a, b) => a.xpReward.compareTo(b.xpReward));
    final next = locked.first;

    return 'Next up: \${next.title} - \${next.description}';
  }

  // Data export for statistics
  Future<Map<String, dynamic>> exportGamificationData() async {
    final stats = await _storageService.getStatistics();

    return {
      'user': currentUser?.toJson(),
      'achievements': unlockedAchievements.map((a) => a.toJson()).toList(),
      'statistics': stats,
      'gamificationStats': gamificationStats,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Private methods
  void _onGamificationUpdate() {
    // Check for level up
    final newLevel = _gamificationService.currentLevel;
    if (newLevel > _previousLevel) {
      _showLevelUpCelebration = true;
      _previousLevel = newLevel;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _gamificationService.removeListener(_onGamificationUpdate);
    super.dispose();
  }
}
