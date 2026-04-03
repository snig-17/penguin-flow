import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/island_model.dart';

class StorageService {
  static const _userBox = 'user';
  static const _sessionsBox = 'sessions';
  static const _islandBox = 'island';
  static const _settingsBox = 'settings';

  late Box<Map> _userStore;
  late Box<Map> _sessionsStore;
  late Box<Map> _islandStore;
  late Box _settingsStore;

  Future<void> init() async {
    _userStore = await Hive.openBox<Map>(_userBox);
    _sessionsStore = await Hive.openBox<Map>(_sessionsBox);
    _islandStore = await Hive.openBox<Map>(_islandBox);
    _settingsStore = await Hive.openBox(_settingsBox);
  }

  // User
  Future<void> saveUser(UserModel user) async {
    await _userStore.put('current', user.toJson());
  }

  UserModel? getUser() {
    final data = _userStore.get('current');
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  // Sessions
  Future<void> saveSession(SessionModel session) async {
    await _sessionsStore.put(session.id, session.toJson());
  }

  List<SessionModel> getSessions() {
    return _sessionsStore.values
        .map((data) => SessionModel.fromJson(Map<String, dynamic>.from(data)))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  // Island
  Future<void> saveIsland(IslandModel island) async {
    await _islandStore.put('current', island.toJson());
  }

  IslandModel? getIsland() {
    final data = _islandStore.get('current');
    if (data == null) return null;
    return IslandModel.fromJson(Map<String, dynamic>.from(data));
  }

  // Settings
  Future<void> setSetting(String key, dynamic value) async {
    await _settingsStore.put(key, value);
  }

  T? getSetting<T>(String key) => _settingsStore.get(key) as T?;

  bool get isDarkMode => getSetting<bool>('darkMode') ?? false;
  bool get soundEnabled => getSetting<bool>('sound') ?? true;
  bool get notificationsEnabled => getSetting<bool>('notifications') ?? true;

  Future<void> clearAll() async {
    await _userStore.clear();
    await _sessionsStore.clear();
    await _islandStore.clear();
    await _settingsStore.clear();
  }
}
