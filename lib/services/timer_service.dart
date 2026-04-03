import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/session_model.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  SessionModel? _currentSession;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  SessionModel? get currentSession => _currentSession;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get hasSession => _currentSession != null;

  double get progress {
    if (_currentSession == null) return 0;
    final total = _currentSession!.targetMinutes * 60;
    if (total == 0) return 0;
    return 1.0 - (_remainingSeconds / total);
  }

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startSession({
    required String userId,
    required SessionType type,
    required int minutes,
  }) {
    _currentSession = SessionModel(
      userId: userId,
      type: type,
      targetMinutes: minutes,
    );
    _remainingSeconds = minutes * 60;
    _isRunning = true;
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  void pauseSession() {
    _timer?.cancel();
    _isPaused = true;
    _isRunning = false;
    _currentSession?.pauseTimes.add(DateTime.now());
    notifyListeners();
  }

  void resumeSession() {
    _isPaused = false;
    _isRunning = true;
    _currentSession?.resumeTimes.add(DateTime.now());
    _startTimer();
    notifyListeners();
  }

  SessionModel? completeSession() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    final session = _currentSession;
    session?.complete();
    _currentSession = null;
    _remainingSeconds = 0;
    notifyListeners();
    return session;
  }

  SessionModel? cancelSession() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    final session = _currentSession;
    if (session != null) {
      final elapsed = session.targetMinutes * 60 - _remainingSeconds;
      session.cancel(elapsed ~/ 60);
    }
    _currentSession = null;
    _remainingSeconds = 0;
    notifyListeners();
    return session;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        // Timer complete
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
