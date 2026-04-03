import 'dart:math';

class Helpers {
  Helpers._();

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatMinutes(int totalMinutes) {
    if (totalMinutes < 60) return '${totalMinutes}m';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  static int xpForLevel(int level) => level * 100 + level * level * 50;

  static int levelFromXp(int xp) {
    int level = 1;
    while (xpForLevel(level) <= xp) {
      level++;
    }
    return level - 1;
  }

  static double xpProgressInLevel(int xp) {
    final level = levelFromXp(xp);
    final currentLevelXp = xpForLevel(level);
    final nextLevelXp = xpForLevel(level + 1);
    if (nextLevelXp == currentLevelXp) return 0;
    return (xp - currentLevelXp) / (nextLevelXp - currentLevelXp);
  }

  static int calculateSessionXp({
    required int durationMinutes,
    required String sessionType,
    required bool completed,
  }) {
    final multiplier = switch (sessionType) {
      'study' => 2.0,
      'creative' => 3.0,
      _ => 1.0,
    };
    var xp = (durationMinutes * 10 * multiplier).round();
    if (completed) xp = (xp * 1.5).round();
    return xp;
  }

  static String levelTitle(int level) {
    if (level < 5) return 'Beginner Explorer';
    if (level < 10) return 'Island Apprentice';
    if (level < 15) return 'Focus Warrior';
    if (level < 25) return 'Island Architect';
    if (level < 35) return 'Master Builder';
    if (level < 50) return 'Legendary Creator';
    return 'Island Emperor';
  }

  static String randomMotivation() {
    const messages = [
      'Stay focused, your island is growing!',
      'Every minute counts!',
      'Your penguin believes in you!',
      'Great things take time!',
    ];
    return messages[Random().nextInt(messages.length)];
  }

  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
