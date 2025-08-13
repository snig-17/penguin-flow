import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility helper functions for PenguinFlow
class AppHelpers {
  /// Provide haptic feedback for button presses
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  /// Generate random colors for friend islands
  static Color generateRandomColor() {
    final random = math.Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  /// Calculate XP needed for next level
  static int calculateXpForLevel(int level) {
    return (level * 100) + (level * level * 50);
  }

  /// Calculate level from total XP
  static int calculateLevelFromXp(int totalXp) {
    int level = 1;
    while (calculateXpForLevel(level) <= totalXp) {
      level++;
    }
    return level - 1;
  }

  /// Calculate progress to next level (0.0 to 1.0)
  static double calculateLevelProgress(int totalXp) {
    final currentLevel = calculateLevelFromXp(totalXp);
    final currentLevelXp = calculateXpForLevel(currentLevel);
    final nextLevelXp = calculateXpForLevel(currentLevel + 1);

    if (totalXp <= currentLevelXp) return 0.0;

    final progressXp = totalXp - currentLevelXp;
    final requiredXp = nextLevelXp - currentLevelXp;

    return (progressXp / requiredXp).clamp(0.0, 1.0);
  }

  /// Format time duration to readable string
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '\${duration.inHours}h \${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '\${duration.inMinutes}m \${duration.inSeconds.remainder(60)}s';
    } else {
      return '\${duration.inSeconds}s';
    }
  }

  /// Format numbers with K, M suffixes
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '\${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '\${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  /// Generate island position based on user ID
  static Offset generateIslandPosition(String userId, Size mapSize) {
    final hash = userId.hashCode.abs();
    final random = math.Random(hash);

    return Offset(
      random.nextDouble() * mapSize.width,
      random.nextDouble() * mapSize.height,
    );
  }

  /// Calculate distance between two points
  static double calculateDistance(Offset point1, Offset point2) {
    final dx = point1.dx - point2.dx;
    final dy = point1.dy - point2.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Clamp value with animation easing
  static double easeInOut(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  /// Generate random penguin name
  static String generatePenguinName() {
    final adjectives = [
      'Happy', 'Jolly', 'Wise', 'Swift', 'Brave', 'Clever', 'Gentle', 'Bold',
      'Sunny', 'Frosty', 'Zippy', 'Cozy', 'Peppy', 'Merry', 'Bright', 'Calm'
    ];

    final nouns = [
      'Penguin', 'Waddle', 'Flipper', 'Arctic', 'Iceberg', 'Snow', 'Frost',
      'Blizzard', 'Glacier', 'Crystal', 'Winter', 'Polar', 'Storm', 'Chill'
    ];

    final random = math.Random();
    final adjective = adjectives[random.nextInt(adjectives.length)];
    final noun = nouns[random.nextInt(nouns.length)];

    return '\$adjective \$noun';
  }

  /// Show snackbar with custom styling
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Validate if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Generate achievement icon based on type
  static IconData getAchievementIcon(String achievementType) {
    switch (achievementType) {
      case 'first_session':
        return Icons.play_circle_fill;
      case 'streak':
        return Icons.local_fire_department;
      case 'sessions':
        return Icons.psychology;
      case 'level':
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }
}
