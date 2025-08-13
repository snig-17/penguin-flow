// lib/providers/timer_provider.dart
import 'package:flutter/foundation.dart';
import '../services/timer_service.dart';
import '../services/gamification_service.dart';
import '../services/island_service.dart';
import '../models/session_model.dart';
import '../models/achievement_model.dart';

class TimerProvider extends ChangeNotifier {
  final TimerService _timerService;
  final GamificationService _gamificationService;
  final IslandService _islandService;

  List<AchievementModel> _newAchievements = [];
  bool _showCelebration = false;

  TimerProvider({
    required TimerService timerService,
    required GamificationService gamificationService,
    required IslandService islandService,
  }) : _timerService = timerService,
       _gamificationService = gamificationService,
       _islandService = islandService {
    // Listen to timer service changes
    _timerService.addListener(_onTimerUpdate);
  }

  // Getters - expose timer service state
  bool get isRunning => _timerService.isRunning;
  bool get isPaused => _timerService.isPaused;
  bool get isActive => _timerService.isActive;
  int get remainingSeconds => _timerService.remainingSeconds;
  int get totalSeconds => _timerService.totalSeconds;
  int get elapsedSeconds => _timerService.elapsedSeconds;
  double get progress => _timerService.progress;
  String get formattedTime => _timerService.formattedTime;
  String get formattedElapsedTime => _timerService.formattedElapsedTime;
  SessionModel? get currentSession => _timerService.currentSession;

  // Celebration state
  List<AchievementModel> get newAchievements => _newAchievements;
  bool get showCelebration => _showCelebration;

  // Session management
  Future<void> startSession({
    required SessionType type,
    required int durationMinutes,
    String? taskDescription,
  }) async {
    _timerService.startSession(
      type: type,
      durationMinutes: durationMinutes,
      taskDescription: taskDescription,
    );
    notifyListeners();
  }

  void resumeSession() {
    _timerService.resumeSession();
    notifyListeners();
  }

  void pauseSession() {
    _timerService.pauseSession();
    notifyListeners();
  }

  Future<void> completeSession() async {
    final session = _timerService.completeSession();
    if (session != null) {
      // Award XP and check achievements
      _newAchievements = await _gamificationService.completeSession(session);

      // Update island progress
      await _islandService.updateIslandProgress(session.actualDuration.inMinutes);

      // Show celebration if there are new achievements or level up
      _showCelebration = _newAchievements.isNotEmpty || _hasLeveledUp();

      notifyListeners();
    }
  }

  void cancelSession() {
    _timerService.cancelSession();
    notifyListeners();
  }

  void addTime(int minutes) {
    _timerService.addTime(minutes);
    notifyListeners();
  }

  // Quick start methods
  void startPomodoroSession() => startSession(
    type: SessionType.focus,
    durationMinutes: 25,
    taskDescription: 'Pomodoro Focus Session',
  );

  void startShortBreak() => startSession(
    type: SessionType.shortBreak,
    durationMinutes: 5,
    taskDescription: 'Short Break',
  );

  void startLongBreak() => startSession(
    type: SessionType.longBreak,
    durationMinutes: 15,
    taskDescription: 'Long Break',
  );

  void startDeepWork() => startSession(
    type: SessionType.deepWork,
    durationMinutes: 90,
    taskDescription: 'Deep Work Session',
  );

  void startCustomSession(int minutes, String description) => startSession(
    type: SessionType.focus,
    durationMinutes: minutes,
    taskDescription: description,
  );

  // Celebration management
  void dismissCelebration() {
    _showCelebration = false;
    _newAchievements.clear();
    notifyListeners();
  }

  // Session presets
  List<SessionPreset> get sessionPresets => [
    SessionPreset(
      name: 'Pomodoro',
      description: 'Classic 25-minute focus session',
      duration: 25,
      type: SessionType.focus,
      xpReward: 50,
      icon: '🍅',
    ),
    SessionPreset(
      name: 'Short Break',
      description: 'Quick 5-minute recharge',
      duration: 5,
      type: SessionType.shortBreak,
      xpReward: 10,
      icon: '☕',
    ),
    SessionPreset(
      name: 'Long Break',
      description: '15-minute rest period',
      duration: 15,
      type: SessionType.longBreak,
      xpReward: 25,
      icon: '🧘',
    ),
    SessionPreset(
      name: 'Deep Work',
      description: 'Extended 90-minute focus',
      duration: 90,
      type: SessionType.deepWork,
      xpReward: 200,
      icon: '🎯',
    ),
  ];

  // Timer display helpers
  String get progressText {
    if (!isActive) return 'Ready to focus';
    if (isPaused) return 'Paused';
    if (isRunning) {
      switch (currentSession?.type) {
        case SessionType.focus:
          return 'Focusing...';
        case SessionType.shortBreak:
          return 'Short break';
        case SessionType.longBreak:
          return 'Long break';
        case SessionType.deepWork:
          return 'Deep work mode';
        default:
          return 'Active session';
      }
    }
    return 'Session complete!';
  }

  String get motivationalMessage {
    final remainingMinutes = remainingSeconds ~/ 60;

    if (!isActive) {
      return 'Ready to start your focus journey?';
    }

    if (isPaused) {
      return 'Take your time, then get back to it!';
    }

    if (remainingMinutes > 20) {
      return 'You\'ve got this! Strong start! 💪';
    } else if (remainingMinutes > 10) {
      return 'Great progress! Keep the momentum! 🚀';
    } else if (remainingMinutes > 5) {
      return 'You\'re in the zone! Almost there! 🔥';
    } else if (remainingMinutes > 1) {
      return 'Final push! You\'re doing amazing! ⭐';
    } else {
      return 'Last minute! Finish strong! 🏆';
    }
  }

  // Animation helpers
  double get pulseIntensity {
    if (!isRunning) return 0.0;

    // Increase pulse intensity as time runs out
    final progressPercent = progress * 100;
    if (progressPercent > 90) return 1.0;      // Final 10%
    if (progressPercent > 75) return 0.7;      // Final 25%
    if (progressPercent > 50) return 0.4;      // Final 50%
    return 0.2;                                // Normal pace
  }

  bool get shouldShowTimeWarning => remainingSeconds <= 300 && isRunning; // Last 5 minutes
  bool get shouldShowFinalCountdown => remainingSeconds <= 60 && isRunning; // Last minute

  // Statistics for current session
  Map<String, dynamic> get currentSessionStats {
    if (currentSession == null) return {};

    final elapsed = elapsedSeconds;
    final sessionType = currentSession!.type;

    return {
      'elapsedTime': formattedElapsedTime,
      'remainingTime': formattedTime,
      'progress': progress,
      'type': sessionType.name,
      'estimatedXP': sessionType.baseXP + (elapsed / 60).round(),
      'pauseCount': currentSession!.pauseCount,
    };
  }

  // Private methods
  void _onTimerUpdate() {
    notifyListeners();
  }

  bool _hasLeveledUp() {
    // This would check if user leveled up in the last session
    // For now, we'll implement a simple check
    return false; // TODO: Implement proper level up detection
  }

  @override
  void dispose() {
    _timerService.removeListener(_onTimerUpdate);
    super.dispose();
  }
}

// Session preset model
class SessionPreset {
  final String name;
  final String description;
  final int duration;
  final SessionType type;
  final int xpReward;
  final String icon;

  SessionPreset({
    required this.name,
    required this.description,
    required this.duration,
    required this.type,
    required this.xpReward,
    required this.icon,
  });
}
