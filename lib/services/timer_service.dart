// lib/services/timer_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/session_model.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  SessionModel? _currentSession;

  // Timer states
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get isActive => _isRunning || _isPaused;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  SessionModel? get currentSession => _currentSession;

  // Progress calculations
  double get progress => _totalSeconds > 0 ? 1 - (_remainingSeconds / _totalSeconds) : 0.0;
  int get elapsedSeconds => _totalSeconds - _remainingSeconds;

  // Time formatting
  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '\${minutes.toString().padLeft(2, '0')}:\${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedElapsedTime {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    return '\${minutes.toString().padLeft(2, '0')}:\${seconds.toString().padLeft(2, '0')}';
  }

  // Start a new focus session
  void startSession({
    required SessionType type,
    required int durationMinutes,
    String? taskDescription,
  }) {
    if (_isRunning) return;

    _totalSeconds = durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _currentSession = SessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      startTime: DateTime.now(),
      plannedDuration: Duration(minutes: durationMinutes),
      taskDescription: taskDescription,
    );

    _isRunning = true;
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  // Resume paused session
  void resumeSession() {
    if (!_isPaused || _currentSession == null) return;

    _isPaused = false;
    _isRunning = true;
    _currentSession = _currentSession!.copyWith(
      pauseCount: _currentSession!.pauseCount + 1,
    );
    _startTimer();
    notifyListeners();
  }

  // Pause active session
  void pauseSession() {
    if (!_isRunning) return;

    _isRunning = false;
    _isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  // Stop and complete session
  SessionModel? completeSession() {
    if (_currentSession == null) return null;

    _timer?.cancel();

    final completedSession = _currentSession!.copyWith(
      endTime: DateTime.now(),
      actualDuration: Duration(seconds: elapsedSeconds),
      wasCompleted: _remainingSeconds <= 0,
      xpEarned: _calculateXP(),
    );

    _reset();
    return completedSession;
  }

  // Cancel current session
  void cancelSession() {
    _timer?.cancel();
    _reset();
  }

  // Add time to current session (for break extensions)
  void addTime(int minutes) {
    if (!isActive) return;
    _remainingSeconds += minutes * 60;
    _totalSeconds += minutes * 60;
    notifyListeners();
  }

  // Quick session presets
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

  // Private methods
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        // Session completed naturally
        timer.cancel();
        _isRunning = false;
        notifyListeners();
      }
    });
  }

  int _calculateXP() {
    if (_currentSession == null) return 0;

    final baseXP = _currentSession!.type.baseXP;
    final completionBonus = _remainingSeconds <= 0 ? 1.5 : 1.0;
    final timeBonus = elapsedSeconds / 60; // 1 XP per minute

    return ((baseXP + timeBonus) * completionBonus).round();
  }

  void _reset() {
    _isRunning = false;
    _isPaused = false;
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _currentSession = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
