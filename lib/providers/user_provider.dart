// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../services/gamification_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';

class UserProvider extends ChangeNotifier {
  final GamificationService _gamificationService;
  final StorageService _storageService;

  UserProvider({
    required GamificationService gamificationService,
    required StorageService storageService,
  }) : _gamificationService = gamificationService,
       _storageService = storageService {
    // Listen to gamification service changes
    _gamificationService.addListener(_onGamificationUpdate);
  }

  // User data getters
  UserModel? get currentUser => _gamificationService.currentUser;
  bool get isUserLoggedIn => currentUser != null;

  // Profile information
  String get userName => currentUser?.name ?? 'Penguin Explorer';
  String get userEmail => currentUser?.email ?? '';
  String get avatarPath => currentUser?.avatarPath ?? 'assets/images/penguin_default.png';
  DateTime? get joinDate => currentUser?.joinDate;
  DateTime? get lastActivity => currentUser?.lastActivityDate;

  // Progression stats
  int get level => _gamificationService.currentLevel;
  int get totalXP => _gamificationService.currentXP;
  int get currentStreak => _gamificationService.currentStreak;
  int get longestStreak => _gamificationService.longestStreak;
  int get totalSessions => _gamificationService.totalSessions;
  int get totalFocusTime => currentUser?.totalFocusTime ?? 0;
  int get friendsCount => currentUser?.friendsCount ?? 0;

  // Level progression
  int get xpToNextLevel => _gamificationService.xpToNextLevel();
  double get levelProgress => _gamificationService.levelProgress();
  int get currentLevelXP => _gamificationService.xpForLevel(level);
  int get nextLevelXP => _gamificationService.xpForLevel(level + 1);

  // Settings
  IslandTheme get selectedTheme => currentUser?.islandTheme ?? IslandTheme.arctic;
  bool get notificationsEnabled => currentUser?.notificationsEnabled ?? true;
  bool get soundEnabled => currentUser?.soundEnabled ?? true;
  bool get darkModeEnabled => currentUser?.darkModeEnabled ?? false;

  // Achievements
  List<AchievementModel> get unlockedAchievements => _gamificationService.unlockedAchievements;
  List<AchievementModel> get availableAchievements => _gamificationService.availableAchievements;

  int get unlockedAchievementCount => unlockedAchievements.length;
  int get totalAchievementCount => availableAchievements.length;
  double get achievementProgress => totalAchievementCount > 0 
      ? unlockedAchievementCount / totalAchievementCount 
      : 0.0;

  // Streak information
  bool get hasActiveStreak => currentStreak > 0;
  bool get isStreakAtRisk {
    if (lastActivity == null) return false;
    final now = DateTime.now();
    final daysSinceLastActivity = now.difference(lastActivity!).inDays;
    return daysSinceLastActivity >= 1;
  }

  String get streakStatus {
    if (!hasActiveStreak) return 'Start your streak today!';
    if (isStreakAtRisk) return 'Your streak is at risk! Complete a session today.';
    return 'Great job! Keep your streak alive!';
  }

  // Level information
  String get levelTitle {
    if (level >= 50) return 'Penguin Master';
    if (level >= 25) return 'Focus Expert';
    if (level >= 15) return 'Productivity Pro';
    if (level >= 10) return 'Focused Achiever';
    if (level >= 5) return 'Rising Star';
    return 'Beginner Explorer';
  }

  String get nextLevelTitle {
    final nextLevel = level + 1;
    if (nextLevel >= 50) return 'Penguin Master';
    if (nextLevel >= 25) return 'Focus Expert';
    if (nextLevel >= 15) return 'Productivity Pro';
    if (nextLevel >= 10) return 'Focused Achiever';
    if (nextLevel >= 5) return 'Rising Star';
    return 'Beginner Explorer';
  }

  // Profile management
  Future<void> updateProfile({
    String? name,
    String? email,
    String? avatarPath,
  }) async {
    await _gamificationService.updateUserProfile(
      name: name,
      email: email,
      avatarPath: avatarPath,
    );
    notifyListeners();
  }

  Future<void> updateSettings({
    IslandTheme? theme,
    bool? notifications,
    bool? sound,
    bool? darkMode,
  }) async {
    await _gamificationService.updateUserProfile(
      theme: theme,
      notifications: notifications,
      sound: sound,
      darkMode: darkMode,
    );
    notifyListeners();
  }

  // Statistics
  Map<String, dynamic> get userStatistics {
    if (currentUser == null) return {};

    final daysSinceJoining = joinDate != null 
        ? DateTime.now().difference(joinDate!).inDays 
        : 0;

    final averageSessionsPerDay = daysSinceJoining > 0 
        ? totalSessions / daysSinceJoining 
        : 0.0;

    final averageFocusTimePerDay = daysSinceJoining > 0 
        ? totalFocusTime / daysSinceJoining 
        : 0.0;

    return {
      'level': level,
      'totalXP': totalXP,
      'totalSessions': totalSessions,
      'totalFocusTime': totalFocusTime,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'achievementsUnlocked': unlockedAchievementCount,
      'daysSinceJoining': daysSinceJoining,
      'averageSessionsPerDay': averageSessionsPerDay.toStringAsFixed(1),
      'averageFocusTimePerDay': averageFocusTimePerDay.toStringAsFixed(1),
      'friendsCount': friendsCount,
    };
  }

  // Formatted display values
  String get formattedTotalFocusTime {
    final hours = totalFocusTime ~/ 60;
    final minutes = totalFocusTime % 60;

    if (hours > 0) {
      return '\${hours}h \${minutes}m';
    } else {
      return '\${minutes}m';
    }
  }

  String get formattedJoinDate {
    if (joinDate == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(joinDate!);

    if (difference.inDays > 365) {
      final years = difference.inDays ~/ 365;
      return '\${years} year\${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = difference.inDays ~/ 30;
      return '\${months} month\${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '\${difference.inDays} day\${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return 'Today';
    }
  }

  String get formattedLastActivity {
    if (lastActivity == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastActivity!);

    if (difference.inDays > 0) {
      return '\${difference.inDays} day\${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '\${difference.inHours} hour\${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '\${difference.inMinutes} minute\${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Achievement helpers
  List<AchievementModel> getAchievementsByRarity(AchievementRarity rarity) {
    return unlockedAchievements.where((a) => a.rarity == rarity).toList();
  }

  List<AchievementModel> get recentAchievements {
    final recent = unlockedAchievements.toList();
    recent.sort((a, b) => b.unlockedAt?.compareTo(a.unlockedAt ?? DateTime.now()) ?? 0);
    return recent.take(5).toList();
  }

  // Progress tracking
  bool get canLevelUp => xpToNextLevel <= 0;

  double get overallProgress {
    // Calculate overall progress based on level, achievements, and streaks
    final levelProgress = level / 50.0; // Max level 50
    final achievementProgress = unlockedAchievementCount / totalAchievementCount;
    final streakProgress = (currentStreak / 100.0).clamp(0.0, 1.0); // Max streak bonus at 100

    return (levelProgress + achievementProgress + streakProgress) / 3.0;
  }

  // Theme helpers
  String get themeDisplayName {
    switch (selectedTheme) {
      case IslandTheme.arctic:
        return 'Arctic Paradise';
      case IslandTheme.tropical:
        return 'Tropical Haven';
      case IslandTheme.forest:
        return 'Mystic Forest';
      case IslandTheme.desert:
        return 'Desert Oasis';
      case IslandTheme.volcanic:
        return 'Volcanic Island';
      case IslandTheme.crystal:
        return 'Crystal Caverns';
    }
  }

  List<IslandTheme> get availableThemes {
    // Unlock themes based on level
    final themes = <IslandTheme>[IslandTheme.arctic]; // Always available

    if (level >= 5) themes.add(IslandTheme.tropical);
    if (level >= 10) themes.add(IslandTheme.forest);
    if (level >= 15) themes.add(IslandTheme.desert);
    if (level >= 20) themes.add(IslandTheme.volcanic);
    if (level >= 25) themes.add(IslandTheme.crystal);

    return themes;
  }

  // Social features
  Future<void> addFriend() async {
    await _gamificationService.addFriend();
    notifyListeners();
  }

  // Data management
  Future<Map<String, dynamic>> exportUserData() async {
    return await _storageService.exportData();
  }

  Future<void> importUserData(Map<String, dynamic> data) async {
    await _storageService.importData(data);
    notifyListeners();
  }

  Future<void> resetUserData() async {
    await _storageService.clearAllData();
    notifyListeners();
  }

  // Motivational content
  String get motivationalQuote {
    final quotes = [
      "Focus is the gateway to success! 🚀",
      "Every session brings you closer to your goals! ⭐",
      "Consistency beats intensity every time! 💪",
      "Your future self will thank you! 🙏",
      "Progress over perfection! 📈",
      "Small steps lead to big achievements! 👣",
      "Focus flows like water - steady and persistent! 🌊",
      "Your potential is unlimited! ♾️",
      "Every focused moment counts! ⏰",
      "Building habits, building dreams! 🏗️",
    ];

    // Use level to select quote (with some randomness)
    final index = (level + DateTime.now().day) % quotes.length;
    return quotes[index];
  }

  // Private methods
  void _onGamificationUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _gamificationService.removeListener(_onGamificationUpdate);
    super.dispose();
  }
}
