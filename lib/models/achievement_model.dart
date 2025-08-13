import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

/// Achievement model for PenguinFlow gamification
@HiveType(typeId: 2)
class AchievementModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String icon;

  @HiveField(4)
  late int xpReward;

  @HiveField(5)
  late String category; // 'streak', 'sessions', 'level', 'time'

  @HiveField(6)
  late int requirement;

  @HiveField(7)
  late bool isUnlocked;

  @HiveField(8)
  late DateTime? unlockedAt;

  @HiveField(9)
  late int rarity; // 1=common, 2=rare, 3=epic, 4=legendary

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.category,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rarity = 1,
  });

  /// Get rarity color
  String get rarityColor {
    switch (rarity) {
      case 1:
        return '#9E9E9E'; // Gray
      case 2:
        return '#2196F3'; // Blue
      case 3:
        return '#9C27B0'; // Purple
      case 4:
        return '#FF9600'; // Gold
      default:
        return '#9E9E9E';
    }
  }

  /// Get rarity name
  String get rarityName {
    switch (rarity) {
      case 1:
        return 'Common';
      case 2:
        return 'Rare';
      case 3:
        return 'Epic';
      case 4:
        return 'Legendary';
      default:
        return 'Common';
    }
  }

  /// Unlock the achievement
  void unlock() {
    isUnlocked = true;
    unlockedAt = DateTime.now();
  }

  @override
  String toString() {
    return 'AchievementModel(id: \$id, title: \$title, unlocked: \$isUnlocked)';
  }
}

/// Predefined achievements for PenguinFlow
class Achievements {
  static List<AchievementModel> getDefaultAchievements() {
    return [
      // First session achievements
      AchievementModel(
        id: 'first_session',
        title: 'First Steps',
        description: 'Complete your first focus session',
        icon: 'play_circle_fill',
        xpReward: 50,
        category: 'sessions',
        requirement: 1,
        rarity: 1,
      ),

      // Session count achievements
      AchievementModel(
        id: 'sessions_10',
        title: 'Getting Started',
        description: 'Complete 10 focus sessions',
        icon: 'psychology',
        xpReward: 100,
        category: 'sessions',
        requirement: 10,
        rarity: 1,
      ),
      AchievementModel(
        id: 'sessions_50',
        title: 'Focused Mind',
        description: 'Complete 50 focus sessions',
        icon: 'psychology',
        xpReward: 250,
        category: 'sessions',
        requirement: 50,
        rarity: 2,
      ),
      AchievementModel(
        id: 'sessions_100',
        title: 'Concentration Master',
        description: 'Complete 100 focus sessions',
        icon: 'psychology',
        xpReward: 500,
        category: 'sessions',
        requirement: 100,
        rarity: 3,
      ),
      AchievementModel(
        id: 'sessions_500',
        title: 'Focus Legend',
        description: 'Complete 500 focus sessions',
        icon: 'psychology',
        xpReward: 1000,
        category: 'sessions',
        requirement: 500,
        rarity: 4,
      ),

      // Streak achievements
      AchievementModel(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: 'local_fire_department',
        xpReward: 200,
        category: 'streak',
        requirement: 7,
        rarity: 2,
      ),
      AchievementModel(
        id: 'streak_30',
        title: 'Month Master',
        description: 'Maintain a 30-day streak',
        icon: 'local_fire_department',
        xpReward: 500,
        category: 'streak',
        requirement: 30,
        rarity: 3,
      ),
      AchievementModel(
        id: 'streak_100',
        title: 'Streak Legend',
        description: 'Maintain a 100-day streak',
        icon: 'local_fire_department',
        xpReward: 1500,
        category: 'streak',
        requirement: 100,
        rarity: 4,
      ),

      // Level achievements
      AchievementModel(
        id: 'level_5',
        title: 'Rising Star',
        description: 'Reach level 5',
        icon: 'emoji_events',
        xpReward: 150,
        category: 'level',
        requirement: 5,
        rarity: 1,
      ),
      AchievementModel(
        id: 'level_10',
        title: 'Island Master',
        description: 'Reach level 10',
        icon: 'emoji_events',
        xpReward: 300,
        category: 'level',
        requirement: 10,
        rarity: 2,
      ),
      AchievementModel(
        id: 'level_25',
        title: 'Productivity Guru',
        description: 'Reach level 25',
        icon: 'emoji_events',
        xpReward: 750,
        category: 'level',
        requirement: 25,
        rarity: 3,
      ),
      AchievementModel(
        id: 'level_50',
        title: 'Focus Deity',
        description: 'Reach level 50',
        icon: 'emoji_events',
        xpReward: 2000,
        category: 'level',
        requirement: 50,
        rarity: 4,
      ),

      // Time-based achievements
      AchievementModel(
        id: 'focus_time_10h',
        title: 'Time Keeper',
        description: 'Accumulate 10 hours of focus time',
        icon: 'schedule',
        xpReward: 200,
        category: 'time',
        requirement: 10,
        rarity: 2,
      ),
      AchievementModel(
        id: 'focus_time_50h',
        title: 'Time Master',
        description: 'Accumulate 50 hours of focus time',
        icon: 'schedule',
        xpReward: 500,
        category: 'time',
        requirement: 50,
        rarity: 3,
      ),
      AchievementModel(
        id: 'focus_time_100h',
        title: 'Time Lord',
        description: 'Accumulate 100 hours of focus time',
        icon: 'schedule',
        xpReward: 1000,
        category: 'time',
        requirement: 100,
        rarity: 4,
      ),

      // Special achievements
      AchievementModel(
        id: 'early_bird',
        title: 'Early Bird',
        description: 'Complete a session before 8 AM',
        icon: 'wb_sunny',
        xpReward: 100,
        category: 'special',
        requirement: 1,
        rarity: 2,
      ),
      AchievementModel(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Complete a session after 10 PM',
        icon: 'bedtime',
        xpReward: 100,
        category: 'special',
        requirement: 1,
        rarity: 2,
      ),
      AchievementModel(
        id: 'perfect_week',
        title: 'Perfect Week',
        description: 'Complete at least one session every day for a week',
        icon: 'calendar_today',
        xpReward: 300,
        category: 'special',
        requirement: 7,
        rarity: 3,
      ),
    ];
  }

  /// Check if user has earned an achievement
  static bool checkAchievement(AchievementModel achievement, Map<String, dynamic> userStats) {
    switch (achievement.category) {
      case 'sessions':
        return userStats['completedSessions'] >= achievement.requirement;
      case 'streak':
        return userStats['longestStreak'] >= achievement.requirement;
      case 'level':
        return userStats['currentLevel'] >= achievement.requirement;
      case 'time':
        return userStats['totalFocusTimeHours'] >= achievement.requirement;
      default:
        return false;
    }
  }
}
