class UserModel {
  final String uid;
  String displayName;
  String email;
  String? photoUrl;
  int totalXp;
  int totalSessions;
  int totalFocusMinutes;
  int currentStreak;
  int longestStreak;
  DateTime? lastSessionDate;
  List<String> unlockedAchievements;
  String islandTheme;
  DateTime createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.totalXp = 0,
    this.totalSessions = 0,
    this.totalFocusMinutes = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSessionDate,
    List<String>? unlockedAchievements,
    this.islandTheme = 'tropical',
    DateTime? createdAt,
  })  : unlockedAchievements = unlockedAchievements ?? [],
        createdAt = createdAt ?? DateTime.now();

  int get level {
    int lvl = 1;
    int xpNeeded = 150;
    int remaining = totalXp;
    while (remaining >= xpNeeded) {
      remaining -= xpNeeded;
      lvl++;
      xpNeeded = lvl * 100 + lvl * lvl * 50;
    }
    return lvl;
  }

  double get levelProgress {
    int lvl = 1;
    int xpNeeded = 150;
    int remaining = totalXp;
    while (remaining >= xpNeeded) {
      remaining -= xpNeeded;
      lvl++;
      xpNeeded = lvl * 100 + lvl * lvl * 50;
    }
    return remaining / xpNeeded;
  }

  int get xpToNextLevel {
    int lvl = 1;
    int xpNeeded = 150;
    int remaining = totalXp;
    while (remaining >= xpNeeded) {
      remaining -= xpNeeded;
      lvl++;
      xpNeeded = lvl * 100 + lvl * lvl * 50;
    }
    return xpNeeded - remaining;
  }

  void addXp(int xp) {
    totalXp += xp;
  }

  void completeSession(int focusMinutes) {
    totalSessions++;
    totalFocusMinutes += focusMinutes;
    final now = DateTime.now();
    if (lastSessionDate != null) {
      final diff = now.difference(lastSessionDate!).inDays;
      if (diff == 1) {
        currentStreak++;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
    lastSessionDate = now;
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'totalXp': totalXp,
        'totalSessions': totalSessions,
        'totalFocusMinutes': totalFocusMinutes,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastSessionDate': lastSessionDate?.toIso8601String(),
        'unlockedAchievements': unlockedAchievements,
        'islandTheme': islandTheme,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] as String,
        displayName: json['displayName'] as String? ?? 'Explorer',
        email: json['email'] as String? ?? '',
        photoUrl: json['photoUrl'] as String?,
        totalXp: json['totalXp'] as int? ?? 0,
        totalSessions: json['totalSessions'] as int? ?? 0,
        totalFocusMinutes: json['totalFocusMinutes'] as int? ?? 0,
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
        lastSessionDate: json['lastSessionDate'] != null
            ? DateTime.parse(json['lastSessionDate'] as String)
            : null,
        unlockedAchievements:
            (json['unlockedAchievements'] as List<dynamic>?)
                ?.cast<String>() ??
                [],
        islandTheme: json['islandTheme'] as String? ?? 'tropical',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );
}
