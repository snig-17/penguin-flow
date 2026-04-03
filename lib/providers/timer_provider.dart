import 'package:flutter/foundation.dart';
import '../models/session_model.dart';
import '../services/timer_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class TimerProvider extends ChangeNotifier {
  final TimerService _timerService = TimerService();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService;

  SessionType _selectedType = SessionType.work;
  int _selectedMinutes = 25;
  SessionModel? _lastCompletedSession;

  TimerProvider(this._storageService) {
    _timerService.addListener(_onTimerChanged);
  }

  // Getters
  TimerService get timerService => _timerService;
  bool get isRunning => _timerService.isRunning;
  bool get isPaused => _timerService.isPaused;
  bool get hasSession => _timerService.hasSession;
  int get remainingSeconds => _timerService.remainingSeconds;
  double get progress => _timerService.progress;
  String get formattedTime => _timerService.formattedTime;
  SessionModel? get currentSession => _timerService.currentSession;
  SessionModel? get lastCompletedSession => _lastCompletedSession;
  SessionType get selectedType => _selectedType;
  int get selectedMinutes => _selectedMinutes;
  bool get isTimerDone => hasSession && remainingSeconds == 0 && !isRunning;

  // Presets
  static const List<Map<String, dynamic>> presets = [
    {'label': 'Quick Focus', 'minutes': 15, 'icon': '⚡'},
    {'label': 'Pomodoro', 'minutes': 25, 'icon': '🍅'},
    {'label': 'Deep Work', 'minutes': 45, 'icon': '🧠'},
    {'label': 'Marathon', 'minutes': 60, 'icon': '🏃'},
  ];

  void setSessionType(SessionType type) {
    _selectedType = type;
    notifyListeners();
  }

  void setDuration(int minutes) {
    _selectedMinutes = minutes;
    notifyListeners();
  }

  void startSession(String userId) {
    _lastCompletedSession = null;
    _timerService.startSession(
      userId: userId,
      type: _selectedType,
      minutes: _selectedMinutes,
    );
  }

  void pause() => _timerService.pauseSession();
  void resume() => _timerService.resumeSession();

  Future<SessionModel?> complete() async {
    final session = _timerService.completeSession();
    if (session != null) {
      _lastCompletedSession = session;
      await _firestoreService.saveSession(session);
      await _storageService.saveSession(session);
    }
    return session;
  }

  Future<SessionModel?> cancel() async {
    final session = _timerService.cancelSession();
    if (session != null && session.actualMinutes > 0) {
      await _firestoreService.saveSession(session);
      await _storageService.saveSession(session);
    }
    return session;
  }

  void _onTimerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _timerService.removeListener(_onTimerChanged);
    _timerService.dispose();
    super.dispose();
  }
}
