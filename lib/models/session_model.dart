import 'package:hive/hive.dart';

part 'session_model.g.dart';

/// Session type enum
@HiveType(typeId: 11)
enum SessionType {
  @HiveField(0)
  focus,
  @HiveField(1)
  shortBreak,
  @HiveField(2)
  longBreak,
  @HiveField(3)
  deepWork;

  /// Base XP reward for this session type
  int get baseXP {
    switch (this) {
      case SessionType.focus:
        return 50;
      case SessionType.shortBreak:
        return 10;
      case SessionType.longBreak:
        return 25;
      case SessionType.deepWork:
        return 200;
    }
  }
}

/// Represents a focus session in PenguinFlow
@HiveType(typeId: 1)
class SessionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late SessionType type;

  @HiveField(2)
  late DateTime startTime;

  @HiveField(3)
  late Duration plannedDuration;

  @HiveField(4)
  DateTime? endTime;

  @HiveField(5)
  late Duration actualDuration;

  @HiveField(6)
  late bool wasCompleted;

  @HiveField(7)
  late int xpEarned;

  @HiveField(8)
  String? taskDescription;

  @HiveField(9)
  late int pauseCount;

  SessionModel({
    required this.id,
    required this.type,
    required this.startTime,
    required this.plannedDuration,
    this.endTime,
    Duration? actualDuration,
    this.wasCompleted = false,
    this.xpEarned = 0,
    this.taskDescription,
    this.pauseCount = 0,
  }) {
    this.actualDuration = actualDuration ?? Duration.zero;
  }

  /// Create a copy of this model with updated fields
  SessionModel copyWith({
    String? id,
    SessionType? type,
    DateTime? startTime,
    Duration? plannedDuration,
    DateTime? endTime,
    Duration? actualDuration,
    bool? wasCompleted,
    int? xpEarned,
    String? taskDescription,
    int? pauseCount,
  }) {
    return SessionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      endTime: endTime ?? this.endTime,
      actualDuration: actualDuration ?? this.actualDuration,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      xpEarned: xpEarned ?? this.xpEarned,
      taskDescription: taskDescription ?? this.taskDescription,
      pauseCount: pauseCount ?? this.pauseCount,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'startTime': startTime.toIso8601String(),
      'plannedDuration': plannedDuration.inMilliseconds,
      'endTime': endTime?.toIso8601String(),
      'actualDuration': actualDuration.inMilliseconds,
      'wasCompleted': wasCompleted,
      'xpEarned': xpEarned,
      'taskDescription': taskDescription,
      'pauseCount': pauseCount,
    };
  }

  /// Deserialize from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      type: SessionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SessionType.focus,
      ),
      startTime: DateTime.parse(json['startTime'] as String),
      plannedDuration: Duration(milliseconds: json['plannedDuration'] as int),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      actualDuration: Duration(milliseconds: json['actualDuration'] as int? ?? 0),
      wasCompleted: json['wasCompleted'] as bool? ?? false,
      xpEarned: json['xpEarned'] as int? ?? 0,
      taskDescription: json['taskDescription'] as String?,
      pauseCount: json['pauseCount'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'SessionModel(type: ${type.name}, duration: $plannedDuration, completed: $wasCompleted)';
  }
}
