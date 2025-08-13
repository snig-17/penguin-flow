import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// User data model for PenguinFlow
/// Stores user profile, progress, and preferences
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String penguinName;

  @HiveField(3)
  late int totalXp;

  @HiveField(4)
  late int completedSessions;

  @HiveField(5)
  late int currentStreak;

  @HiveField(6)
  late int longestStreak;

  @HiveField(7)
  late DateTime lastSessionDate;

  @HiveField(8)
  late DateTime createdAt;

  @HiveField(9)
  late Duration totalFocusTime;

  @HiveField(10)
  late List<String> unlockedAchievements;

  @HiveField(11)
  late Map<String, int> sessionsByType;

  @HiveField(12)
  late int islandLevel;

  @HiveField(13)
  late List<String> islandBuildings;

  @HiveField(14)
  late bool soundEnabled;

  @HiveField(15)
  late bool notificationsEnabled;

  @HiveField(16)
  late bool darkModeEnabled;

  UserModel({
    required this.id,
    required this.name,
    required this.penguinName,
    this.totalXp = 0,
    this.completedSessions = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    DateTime? lastSessionDate,
    DateTime? createdAt,
    Duration? totalFocusTime,
    List<String>? unlockedAchievements,
    Map<String, int>? sessionsByType,
    this.islandLevel = 1,
    List<String>? islandBuildings,
    this.soundEnabled = true,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
  }) {
    this.lastSessionDate = lastSessionDate ?? DateTime.now();
    this.createdAt = createdAt ?? DateTime.now();
    this.totalFocusTime = totalFocusTime ?? Duration.zero;
    this.unlockedAchievements = unlockedAchievements ?? [];
    this.sessionsByType = sessionsByType ?? {
      'work': 0,
      'study': 0,
      'creative': 0,
    };
    this.islandBuildings = islandBuildings ?? [];
  }

  /// Calculate current level from total XP
  int get currentLevel {
    int level = 1;
    int requiredXp = 100;
    int totalRequired = 0;

    while (totalXp >= totalRequired + requiredXp) {
      totalRequired += requiredXp;
      level++;
      requiredXp = (level * 100) + (level * level * 50);
    }

    return level;
  }

  /// Calculate XP needed for next level
  int get xpForNextLevel {
    final nextLevel = currentLevel + 1;
    return (nextLevel * 100) + (nextLevel * nextLevel * 50);
  }

  /// Calculate current level progress (0.0 to 1.0)
  double get levelProgress {
    int level = 1;
    int xpUsed = 0;

    while (true) {
      final levelXp = (level * 100) + (level * level * 50);
      if (xpUsed + levelXp > totalXp) {
        final progressXp = totalXp - xpUsed;
        return progressXp / levelXp;
      }
      xpUsed += levelXp;
      level++;
    }
  }

  /// Add XP and return if level increased
  bool addXp(int xp) {
    final oldLevel = currentLevel;
    totalXp += xp;
    return currentLevel > oldLevel;
  }

  /// Complete a session with given type and duration
  void completeSession(String sessionType, Duration duration) {
    completedSessions++;
    totalFocusTime += duration;
    sessionsByType[sessionType] = (sessionsByType[sessionType] ?? 0) + 1;

    // Update streak
    final now = DateTime.now();
    final daysSinceLastSession = now.difference(lastSessionDate).inDays;

    if (daysSinceLastSession <= 1) {
      if (daysSinceLastSession == 1) {
        currentStreak++;
      }
      // Same day, streak continues
    } else {
      // Streak broken
      currentStreak = 1;
    }

    longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;
    lastSessionDate = now;

    // Calculate XP based on session type and duration
    int baseXp = (duration.inMinutes * 2).round();
    int multiplier = 1;

    switch (sessionType) {
      case 'work':
        multiplier = 1;
        break;
      case 'study':
        multiplier = 2;
        break;
      case 'creative':
        multiplier = 3;
        break;
    }

    addXp(baseXp * multiplier);

    // Add building to island every 5 sessions
    if (completedSessions % 5 == 0) {
      islandBuildings.add('\${sessionType}_building_\${islandBuildings.length}');
    }

    // Level up island every 10 levels
    final newIslandLevel = (currentLevel / 10).floor() + 1;
    if (newIslandLevel > islandLevel) {
      islandLevel = newIslandLevel;
    }
  }

  /// Check if user has achievement
  bool hasAchievement(String achievementId) {
    return unlockedAchievements.contains(achievementId);
  }

  /// Unlock achievement
  void unlockAchievement(String achievementId) {
    if (!hasAchievement(achievementId)) {
      unlockedAchievements.add(achievementId);
    }
  }

  /// Check if streak is maintained today
  bool get streakMaintainedToday {
    final now = DateTime.now();
    final daysSinceLastSession = now.difference(lastSessionDate).inDays;
    return daysSinceLastSession <= 1;
  }

  /// Get achievement progress for display
  Map<String, dynamic> getAchievementProgress() {
    return {
      'first_session': completedSessions >= 1,
      'streak_7': longestStreak >= 7,
      'streak_30': longestStreak >= 30,
      'sessions_10': completedSessions >= 10,
      'sessions_50': completedSessions >= 50,
      'sessions_100': completedSessions >= 100,
      'level_5': currentLevel >= 5,
      'level_10': currentLevel >= 10,
      'level_25': currentLevel >= 25,
      'focus_time_10h': totalFocusTime.inHours >= 10,
      'focus_time_50h': totalFocusTime.inHours >= 50,
      'focus_time_100h': totalFocusTime.inHours >= 100,
    };
  }

  @override
  String toString() {
    return 'UserModel(name: \$name, level: \$currentLevel, xp: \$totalXp, sessions: \$completedSessions)';
  }
}
