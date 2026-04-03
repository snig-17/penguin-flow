import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

/// Achievement rarity enum
@HiveType(typeId: 12)
enum AchievementRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  rare,
  @HiveField(2)
  epic,
  @HiveField(3)
  legendary,
}

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
  late String category; // 'sessions', 'streaks', 'levels', 'time', 'social', 'special'

  @HiveField(6)
  late AchievementRarity rarity;

  @HiveField(7)
  late bool isUnlocked;

  @HiveField(8)
  DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.category,
    this.rarity = AchievementRarity.common,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'xpReward': xpReward,
      'category': category,
      'rarity': rarity.name,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// Deserialize from JSON
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      xpReward: json['xpReward'] as int,
      category: json['category'] as String,
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt'] as String) : null,
    );
  }

  /// All predefined achievements
  static List<AchievementModel> get allAchievements => [
    AchievementModel(
      id: 'first_session',
      title: 'First Steps',
      description: 'Complete your first focus session',
      icon: 'play_circle_fill',
      xpReward: 50,
      category: 'sessions',
      rarity: AchievementRarity.common,
    ),
    AchievementModel(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Complete a session before 8 AM',
      icon: 'wb_sunny',
      xpReward: 100,
      category: 'special',
      rarity: AchievementRarity.rare,
    ),
    AchievementModel(
      id: 'night_owl',
      title: 'Night Owl',
      description: 'Complete a session after 10 PM',
      icon: 'bedtime',
      xpReward: 100,
      category: 'special',
      rarity: AchievementRarity.rare,
    ),
    AchievementModel(
      id: 'streak_3',
      title: 'Getting Consistent',
      description: 'Maintain a 3-day streak',
      icon: 'local_fire_department',
      xpReward: 100,
      category: 'streaks',
      rarity: AchievementRarity.common,
    ),
    AchievementModel(
      id: 'streak_7',
      title: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      icon: 'local_fire_department',
      xpReward: 200,
      category: 'streaks',
      rarity: AchievementRarity.rare,
    ),
    AchievementModel(
      id: 'streak_30',
      title: 'Month Master',
      description: 'Maintain a 30-day streak',
      icon: 'local_fire_department',
      xpReward: 500,
      category: 'streaks',
      rarity: AchievementRarity.epic,
    ),
    AchievementModel(
      id: 'marathon',
      title: 'Marathon Runner',
      description: 'Complete a 2-hour session',
      icon: 'timer',
      xpReward: 300,
      category: 'sessions',
      rarity: AchievementRarity.epic,
    ),
    AchievementModel(
      id: 'century',
      title: 'Century Club',
      description: 'Complete 100 focus sessions',
      icon: 'psychology',
      xpReward: 500,
      category: 'sessions',
      rarity: AchievementRarity.epic,
    ),
    AchievementModel(
      id: 'focused',
      title: 'Focused Mind',
      description: 'Accumulate 10 hours of focus time',
      icon: 'schedule',
      xpReward: 200,
      category: 'time',
      rarity: AchievementRarity.rare,
    ),
    AchievementModel(
      id: 'dedicated',
      title: 'Dedicated Scholar',
      description: 'Accumulate 100 hours of focus time',
      icon: 'schedule',
      xpReward: 1000,
      category: 'time',
      rarity: AchievementRarity.legendary,
    ),
    AchievementModel(
      id: 'level_5',
      title: 'Rising Star',
      description: 'Reach level 5',
      icon: 'emoji_events',
      xpReward: 150,
      category: 'levels',
      rarity: AchievementRarity.common,
    ),
    AchievementModel(
      id: 'level_10',
      title: 'Island Master',
      description: 'Reach level 10',
      icon: 'emoji_events',
      xpReward: 300,
      category: 'levels',
      rarity: AchievementRarity.rare,
    ),
    AchievementModel(
      id: 'level_25',
      title: 'Productivity Guru',
      description: 'Reach level 25',
      icon: 'emoji_events',
      xpReward: 750,
      category: 'levels',
      rarity: AchievementRarity.epic,
    ),
    AchievementModel(
      id: 'perfectionist',
      title: 'Perfectionist',
      description: 'Complete 20 sessions with high completion rate',
      icon: 'verified',
      xpReward: 400,
      category: 'sessions',
      rarity: AchievementRarity.epic,
    ),
    AchievementModel(
      id: 'social_butterfly',
      title: 'Social Butterfly',
      description: 'Add 10 friends',
      icon: 'people',
      xpReward: 200,
      category: 'social',
      rarity: AchievementRarity.rare,
    ),
  ];

  @override
  String toString() {
    return 'AchievementModel(id: $id, title: $title, unlocked: $isUnlocked)';
  }
}
