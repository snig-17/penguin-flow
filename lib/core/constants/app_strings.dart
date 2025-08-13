/// String constants for PenguinFlow app
/// Centralized text management for easy localization
class AppStrings {
  // App Info
  static const String appName = 'PenguinFlow';
  static const String appTagline = 'Build your productivity island!';

  // Onboarding
  static const String welcomeTitle = 'Welcome to PenguinFlow!';
  static const String welcomeSubtitle = 'Turn your focus sessions into a thriving penguin island';
  static const String onboardingStep1Title = 'Focus & Build';
  static const String onboardingStep1Subtitle = 'Each 25-minute session builds your island';
  static const String onboardingStep2Title = 'Meet Your Penguin';
  static const String onboardingStep2Subtitle = 'Your penguin avatar grows with your progress';
  static const String onboardingStep3Title = 'Connect with Friends';
  static const String onboardingStep3Subtitle = 'Visit friends\' islands and share your journey';

  // Navigation
  static const String tabTimer = 'Timer';
  static const String tabIsland = 'Island';
  static const String tabSocial = 'Social';
  static const String tabStats = 'Stats';

  // Timer Screen
  static const String timerTitle = 'Focus Time';
  static const String sessionTypeWork = 'Work';
  static const String sessionTypeStudy = 'Study';
  static const String sessionTypeCreative = 'Creative';
  static const String timerStart = 'Start Session';
  static const String timerPause = 'Pause';
  static const String timerResume = 'Resume';
  static const String timerStop = 'Stop';
  static const String timerReset = 'Reset';
  static const String sessionComplete = 'Session Complete!';
  static const String sessionCompleteMessage = 'Great focus! Your island grows stronger.';

  // Island Screen
  static const String islandTitle = 'Your Island';
  static const String islandEmpty = 'Start your first session to begin building!';
  static const String buildingWork = 'Office Building';
  static const String buildingStudy = 'Library';
  static const String buildingCreative = 'Art Studio';
  static const String shareIsland = 'Share Island';

  // Social Screen
  static const String socialTitle = 'Island Map';
  static const String friendsOnline = 'Friends Online';
  static const String searchFriends = 'Search friends...';
  static const String visitIsland = 'Visit Island';
  static const String addFriend = 'Add Friend';

  // Stats Screen
  static const String statsTitle = 'Your Progress';
  static const String totalSessions = 'Total Sessions';
  static const String totalFocusTime = 'Focus Time';
  static const String currentStreak = 'Current Streak';
  static const String longestStreak = 'Longest Streak';
  static const String level = 'Level';
  static const String experience = 'XP';
  static const String achievements = 'Achievements';

  // Achievements
  static const String achievementFirstSession = 'First Steps';
  static const String achievementFirstSessionDesc = 'Complete your first focus session';
  static const String achievementStreak7 = 'Week Warrior';
  static const String achievementStreak7Desc = 'Maintain a 7-day streak';
  static const String achievementSessions50 = 'Focused Mind';
  static const String achievementSessions50Desc = 'Complete 50 focus sessions';
  static const String achievementLevel10 = 'Island Master';
  static const String achievementLevel10Desc = 'Reach level 10';

  // Gamification
  static const String levelUp = 'Level Up!';
  static const String levelUpMessage = 'You\'ve reached level';
  static const String xpEarned = 'XP Earned';
  static const String streakBroken = 'Streak Broken';
  static const String streakMaintained = 'Streak Maintained!';

  // Generic
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String retry = 'Retry';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
  static const String settings = 'Settings';

  // Time formats
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '\$hours:\$minutes:\$seconds';
    } else {
      return '\$minutes:\$seconds';
    }
  }

  /// Format large numbers with K, M suffixes
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '\${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '\${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
