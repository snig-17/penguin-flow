import '../models/achievement_model.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';

class GamificationService {
  final List<AchievementModel> _achievements = AchievementModel.allAchievements;

  List<AchievementModel> get achievements => _achievements;

  List<AchievementModel> checkNewAchievements(UserModel user, SessionModel? session) {
    final newlyUnlocked = <AchievementModel>[];

    for (final achievement in _achievements) {
      if (achievement.unlocked) continue;
      if (user.unlockedAchievements.contains(achievement.id)) {
        achievement.unlocked = true;
        continue;
      }

      bool shouldUnlock = false;

      switch (achievement.category) {
        case AchievementCategory.sessions:
          shouldUnlock = user.totalSessions >= achievement.requirement;
          break;
        case AchievementCategory.streaks:
          shouldUnlock = user.currentStreak >= achievement.requirement;
          break;
        case AchievementCategory.time:
          shouldUnlock = user.totalFocusMinutes >= achievement.requirement;
          break;
        case AchievementCategory.level:
          shouldUnlock = user.level >= achievement.requirement;
          break;
        case AchievementCategory.special:
          if (session != null) {
            shouldUnlock = _checkSpecialAchievement(achievement, session);
          }
          break;
      }

      if (shouldUnlock) {
        achievement.unlock();
        user.unlockedAchievements.add(achievement.id);
        user.addXp(achievement.xpReward);
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  bool _checkSpecialAchievement(AchievementModel achievement, SessionModel session) {
    final hour = session.startedAt.hour;
    return switch (achievement.id) {
      'early_bird' => hour < 7,
      'night_owl' => hour >= 23,
      'deep_focus' => session.targetMinutes >= 60 && session.completed,
      _ => false,
    };
  }

  void syncUnlockedState(List<String> unlockedIds) {
    for (final achievement in _achievements) {
      if (unlockedIds.contains(achievement.id)) {
        achievement.unlocked = true;
      }
    }
  }

  int get totalUnlocked => _achievements.where((a) => a.unlocked).length;
  int get totalAchievements => _achievements.length;

  List<AchievementModel> byCategory(AchievementCategory category) =>
      _achievements.where((a) => a.category == category).toList();

  List<AchievementModel> byRarity(AchievementRarity rarity) =>
      _achievements.where((a) => a.rarity == rarity).toList();
}
