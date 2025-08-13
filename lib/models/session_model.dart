import 'package:hive/hive.dart';

part 'session_model.g.dart';

/// Represents a focus session in PenguinFlow
@HiveType(typeId: 1)
class SessionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type; // 'work', 'study', 'creative'

  @HiveField(2)
  late Duration plannedDuration;

  @HiveField(3)
  late Duration? actualDuration;

  @HiveField(4)
  late DateTime startTime;

  @HiveField(5)
  late DateTime? endTime;

  @HiveField(6)
  late bool completed;

  @HiveField(7)
  late int xpEarned;

  @HiveField(8)
  late String? notes;

  @HiveField(9)
  late bool wasInterrupted;

  @HiveField(10)
  late List<DateTime> pauseTimes;

  @HiveField(11)
  late List<DateTime> resumeTimes;

  SessionModel({
    required this.id,
    required this.type,
    required this.plannedDuration,
    this.actualDuration,
    required this.startTime,
    this.endTime,
    this.completed = false,
    this.xpEarned = 0,
    this.notes,
    this.wasInterrupted = false,
    List<DateTime>? pauseTimes,
    List<DateTime>? resumeTimes,
  }) {
    this.pauseTimes = pauseTimes ?? [];
    this.resumeTimes = resumeTimes ?? [];
  }

  /// Complete the session
  void complete() {
    endTime = DateTime.now();
    actualDuration = endTime!.difference(startTime);
    completed = true;

    // Calculate XP based on completion
    final completionRate = actualDuration!.inMinutes / plannedDuration.inMinutes;
    int baseXp = (actualDuration!.inMinutes * 2).round();

    // Bonus for full completion
    if (completionRate >= 1.0) {
      baseXp = (baseXp * 1.5).round();
    }

    // Type multiplier
    switch (type) {
      case 'work':
        xpEarned = baseXp;
        break;
      case 'study':
        xpEarned = (baseXp * 1.2).round();
        break;
      case 'creative':
        xpEarned = (baseXp * 1.5).round();
        break;
      default:
        xpEarned = baseXp;
    }

    // Penalty for interruptions
    if (wasInterrupted) {
      xpEarned = (xpEarned * 0.8).round();
    }
  }

  /// Add pause time
  void pause() {
    pauseTimes.add(DateTime.now());
    wasInterrupted = true;
  }

  /// Add resume time
  void resume() {
    resumeTimes.add(DateTime.now());
  }

  /// Calculate total pause duration
  Duration get totalPauseDuration {
    Duration total = Duration.zero;

    for (int i = 0; i < pauseTimes.length; i++) {
      DateTime pauseTime = pauseTimes[i];
      DateTime resumeTime = i < resumeTimes.length 
          ? resumeTimes[i] 
          : endTime ?? DateTime.now();

      total += resumeTime.difference(pauseTime);
    }

    return total;
  }

  /// Get effective work duration (excluding pauses)
  Duration get effectiveDuration {
    if (actualDuration == null) return Duration.zero;
    return actualDuration! - totalPauseDuration;
  }

  /// Get session progress (0.0 to 1.0)
  double get progress {
    if (completed) return 1.0;

    final now = DateTime.now();
    final elapsed = now.difference(startTime) - totalPauseDuration;
    return (elapsed.inMilliseconds / plannedDuration.inMilliseconds).clamp(0.0, 1.0);
  }

  /// Get remaining time
  Duration get remainingTime {
    if (completed) return Duration.zero;

    final elapsed = effectiveDuration;
    final remaining = plannedDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Check if session is currently active
  bool get isActive {
    return !completed && endTime == null;
  }

  /// Check if session is paused
  bool get isPaused {
    return isActive && pauseTimes.length > resumeTimes.length;
  }

  /// Get building type that this session creates
  String get buildingType {
    switch (type) {
      case 'work':
        return 'office';
      case 'study':
        return 'library';
      case 'creative':
        return 'studio';
      default:
        return 'office';
    }
  }

  /// Get session type color
  String get typeColor {
    switch (type) {
      case 'work':
        return '#1CB0F6'; // Blue
      case 'study':
        return '#58CC02'; // Green
      case 'creative':
        return '#FF9600'; // Orange
      default:
        return '#1CB0F6';
    }
  }

  @override
  String toString() {
    return 'SessionModel(type: \$type, duration: \$plannedDuration, completed: \$completed)';
  }
}

/// Session statistics helper
class SessionStats {
  static Map<String, dynamic> calculateDailyStats(List<SessionModel> sessions) {
    final today = DateTime.now();
    final todaySessions = sessions.where((s) => 
      s.startTime.day == today.day &&
      s.startTime.month == today.month &&
      s.startTime.year == today.year
    ).toList();

    final completedToday = todaySessions.where((s) => s.completed).toList();
    final totalDuration = completedToday.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + (session.actualDuration ?? Duration.zero),
    );

    return {
      'totalSessions': todaySessions.length,
      'completedSessions': completedToday.length,
      'totalDuration': totalDuration,
      'averageDuration': completedToday.isEmpty 
          ? Duration.zero 
          : Duration(milliseconds: totalDuration.inMilliseconds ~/ completedToday.length),
      'totalXp': completedToday.fold<int>(0, (sum, session) => sum + session.xpEarned),
    };
  }

  static Map<String, dynamic> calculateWeeklyStats(List<SessionModel> sessions) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekSessions = sessions.where((s) => s.startTime.isAfter(weekStart)).toList();

    final completedWeek = weekSessions.where((s) => s.completed).toList();
    final totalDuration = completedWeek.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + (session.actualDuration ?? Duration.zero),
    );

    return {
      'totalSessions': weekSessions.length,
      'completedSessions': completedWeek.length,
      'totalDuration': totalDuration,
      'totalXp': completedWeek.fold<int>(0, (sum, session) => sum + session.xpEarned),
      'dailyAverage': completedWeek.length / 7,
    };
  }
}
