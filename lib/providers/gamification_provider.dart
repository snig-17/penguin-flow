import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';
import '../services/gamification_service.dart';

class GamificationProvider extends ChangeNotifier {
  final GamificationService _service = GamificationService();

  List<AchievementModel> get achievements => _service.achievements;
  int get totalUnlocked => _service.totalUnlocked;
  int get totalAchievements => _service.totalAchievements;
  double get completionPercent =>
      totalAchievements > 0 ? totalUnlocked / totalAchievements : 0;

  List<AchievementModel> get unlockedAchievements =>
      achievements.where((a) => a.unlocked).toList();

  List<AchievementModel> get lockedAchievements =>
      achievements.where((a) => !a.unlocked).toList();

  List<AchievementModel> byCategory(AchievementCategory category) =>
      _service.byCategory(category);

  List<AchievementModel> byRarity(AchievementRarity rarity) =>
      _service.byRarity(rarity);

  void syncFromUser(List<String> unlockedIds) {
    _service.syncUnlockedState(unlockedIds);
    notifyListeners();
  }
}
