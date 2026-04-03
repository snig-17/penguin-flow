import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// Enum for island themes
@HiveType(typeId: 10)
enum IslandTheme {
  @HiveField(0)
  arctic,
  @HiveField(1)
  tropical,
  @HiveField(2)
  forest,
  @HiveField(3)
  desert,
  @HiveField(4)
  volcanic,
  @HiveField(5)
  crystal,
}

/// User data model for PenguinFlow
/// Stores user profile, progress, and preferences
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String avatarPath;

  @HiveField(4)
  late int level;

  @HiveField(5)
  late int totalXP;

  @HiveField(6)
  late int currentStreak;

  @HiveField(7)
  late int longestStreak;

  @HiveField(8)
  late int completedSessions;

  @HiveField(9)
  late int totalFocusTime; // in minutes

  @HiveField(10)
  late DateTime joinDate;

  @HiveField(11)
  DateTime? lastActivityDate;

  @HiveField(12)
  late int friendsCount;

  @HiveField(13)
  late IslandTheme islandTheme;

  @HiveField(14)
  late bool notificationsEnabled;

  @HiveField(15)
  late bool soundEnabled;

  @HiveField(16)
  late bool darkModeEnabled;

  UserModel({
    required this.id,
    required this.name,
    this.email = '',
    this.avatarPath = 'assets/images/penguin_default.png',
    this.level = 1,
    this.totalXP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completedSessions = 0,
    this.totalFocusTime = 0,
    DateTime? joinDate,
    this.lastActivityDate,
    this.friendsCount = 0,
    this.islandTheme = IslandTheme.arctic,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.darkModeEnabled = false,
  }) {
    this.joinDate = joinDate ?? DateTime.now();
  }

  /// Create a copy of this model with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarPath,
    int? level,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    int? completedSessions,
    int? totalFocusTime,
    DateTime? joinDate,
    DateTime? lastActivityDate,
    int? friendsCount,
    IslandTheme? islandTheme,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? darkModeEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      level: level ?? this.level,
      totalXP: totalXP ?? this.totalXP,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedSessions: completedSessions ?? this.completedSessions,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      joinDate: joinDate ?? this.joinDate,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      friendsCount: friendsCount ?? this.friendsCount,
      islandTheme: islandTheme ?? this.islandTheme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarPath': avatarPath,
      'level': level,
      'totalXP': totalXP,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completedSessions': completedSessions,
      'totalFocusTime': totalFocusTime,
      'joinDate': joinDate.toIso8601String(),
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'friendsCount': friendsCount,
      'islandTheme': islandTheme.name,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'darkModeEnabled': darkModeEnabled,
    };
  }

  /// Deserialize from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      avatarPath: json['avatarPath'] as String? ?? 'assets/images/penguin_default.png',
      level: json['level'] as int? ?? 1,
      totalXP: json['totalXP'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      completedSessions: json['completedSessions'] as int? ?? 0,
      totalFocusTime: json['totalFocusTime'] as int? ?? 0,
      joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate'] as String) : null,
      lastActivityDate: json['lastActivityDate'] != null ? DateTime.parse(json['lastActivityDate'] as String) : null,
      friendsCount: json['friendsCount'] as int? ?? 0,
      islandTheme: IslandTheme.values.firstWhere(
        (e) => e.name == json['islandTheme'],
        orElse: () => IslandTheme.arctic,
      ),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, level: $level, xp: $totalXP, sessions: $completedSessions)';
  }
}
