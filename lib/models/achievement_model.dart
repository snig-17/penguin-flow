import 'package:flutter/material.dart';

enum AchievementRarity { common, rare, epic, legendary }

enum AchievementCategory { sessions, streaks, level, time, special }

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementRarity rarity;
  final AchievementCategory category;
  final int xpReward;
  final int requirement;
  bool unlocked;
  DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    this.icon = '🏆',
    this.rarity = AchievementRarity.common,
    this.category = AchievementCategory.sessions,
    this.xpReward = 100,
    this.requirement = 1,
    this.unlocked = false,
    this.unlockedAt,
  });

  Color get rarityColor => switch (rarity) {
        AchievementRarity.common => const Color(0xFF777777),
        AchievementRarity.rare => const Color(0xFF1CB0F6),
        AchievementRarity.epic => const Color(0xFFCE82FF),
        AchievementRarity.legendary => const Color(0xFFFF9600),
      };

  String get rarityLabel => switch (rarity) {
        AchievementRarity.common => 'Common',
        AchievementRarity.rare => 'Rare',
        AchievementRarity.epic => 'Epic',
        AchievementRarity.legendary => 'Legendary',
      };

  void unlock() {
    unlocked = true;
    unlockedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'rarity': rarity.name,
        'category': category.name,
        'xpReward': xpReward,
        'requirement': requirement,
        'unlocked': unlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      AchievementModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String? ?? '🏆',
        rarity: AchievementRarity.values.firstWhere(
          (e) => e.name == json['rarity'],
          orElse: () => AchievementRarity.common,
        ),
        category: AchievementCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => AchievementCategory.sessions,
        ),
        xpReward: json['xpReward'] as int? ?? 100,
        requirement: json['requirement'] as int? ?? 1,
        unlocked: json['unlocked'] as bool? ?? false,
        unlockedAt: json['unlockedAt'] != null
            ? DateTime.parse(json['unlockedAt'] as String)
            : null,
      );

  static List<AchievementModel> get allAchievements => [
        // Sessions
        AchievementModel(id: 'first_session', title: 'First Steps', description: 'Complete your first focus session', icon: '🎯', category: AchievementCategory.sessions, requirement: 1, xpReward: 50),
        AchievementModel(id: 'sessions_10', title: 'Getting Started', description: 'Complete 10 focus sessions', icon: '🔥', category: AchievementCategory.sessions, rarity: AchievementRarity.common, requirement: 10, xpReward: 100),
        AchievementModel(id: 'sessions_50', title: 'Focus Master', description: 'Complete 50 focus sessions', icon: '⚡', category: AchievementCategory.sessions, rarity: AchievementRarity.rare, requirement: 50, xpReward: 250),
        AchievementModel(id: 'sessions_100', title: 'Century Club', description: 'Complete 100 focus sessions', icon: '💯', category: AchievementCategory.sessions, rarity: AchievementRarity.epic, requirement: 100, xpReward: 500),
        AchievementModel(id: 'sessions_500', title: 'Unstoppable', description: 'Complete 500 focus sessions', icon: '🏆', category: AchievementCategory.sessions, rarity: AchievementRarity.legendary, requirement: 500, xpReward: 1000),

        // Streaks
        AchievementModel(id: 'streak_7', title: 'Week Warrior', description: 'Maintain a 7-day streak', icon: '🔥', category: AchievementCategory.streaks, rarity: AchievementRarity.common, requirement: 7, xpReward: 150),
        AchievementModel(id: 'streak_30', title: 'Monthly Master', description: 'Maintain a 30-day streak', icon: '🌟', category: AchievementCategory.streaks, rarity: AchievementRarity.rare, requirement: 30, xpReward: 500),
        AchievementModel(id: 'streak_100', title: 'Legendary Focus', description: 'Maintain a 100-day streak', icon: '👑', category: AchievementCategory.streaks, rarity: AchievementRarity.legendary, requirement: 100, xpReward: 2000),

        // Time
        AchievementModel(id: 'time_600', title: 'Time Investor', description: 'Focus for 10 total hours', icon: '⏰', category: AchievementCategory.time, rarity: AchievementRarity.common, requirement: 600, xpReward: 200),
        AchievementModel(id: 'time_3000', title: 'Dedicated', description: 'Focus for 50 total hours', icon: '⌛', category: AchievementCategory.time, rarity: AchievementRarity.rare, requirement: 3000, xpReward: 500),
        AchievementModel(id: 'time_6000', title: 'Time Lord', description: 'Focus for 100 total hours', icon: '🕐', category: AchievementCategory.time, rarity: AchievementRarity.epic, requirement: 6000, xpReward: 1000),

        // Level
        AchievementModel(id: 'level_5', title: 'Rising Star', description: 'Reach level 5', icon: '⭐', category: AchievementCategory.level, rarity: AchievementRarity.common, requirement: 5, xpReward: 100),
        AchievementModel(id: 'level_10', title: 'Island Expert', description: 'Reach level 10', icon: '🌟', category: AchievementCategory.level, rarity: AchievementRarity.rare, requirement: 10, xpReward: 300),
        AchievementModel(id: 'level_25', title: 'Master Architect', description: 'Reach level 25', icon: '💫', category: AchievementCategory.level, rarity: AchievementRarity.epic, requirement: 25, xpReward: 750),

        // Special
        AchievementModel(id: 'early_bird', title: 'Early Bird', description: 'Complete a session before 7 AM', icon: '🌅', category: AchievementCategory.special, rarity: AchievementRarity.rare, requirement: 1, xpReward: 200),
        AchievementModel(id: 'night_owl', title: 'Night Owl', description: 'Complete a session after 11 PM', icon: '🦉', category: AchievementCategory.special, rarity: AchievementRarity.rare, requirement: 1, xpReward: 200),
        AchievementModel(id: 'deep_focus', title: 'Deep Focus', description: 'Complete a 60-minute session', icon: '🧠', category: AchievementCategory.special, rarity: AchievementRarity.epic, requirement: 60, xpReward: 300),
      ];
}
