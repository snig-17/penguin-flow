import 'package:uuid/uuid.dart';

enum SessionType { work, study, creative }

class SessionModel {
  final String id;
  final String userId;
  final SessionType type;
  final int targetMinutes;
  int actualMinutes;
  int xpEarned;
  bool completed;
  DateTime startedAt;
  DateTime? completedAt;
  List<DateTime> pauseTimes;
  List<DateTime> resumeTimes;

  SessionModel({
    String? id,
    required this.userId,
    this.type = SessionType.work,
    this.targetMinutes = 25,
    this.actualMinutes = 0,
    this.xpEarned = 0,
    this.completed = false,
    DateTime? startedAt,
    this.completedAt,
    List<DateTime>? pauseTimes,
    List<DateTime>? resumeTimes,
  })  : id = id ?? const Uuid().v4(),
        startedAt = startedAt ?? DateTime.now(),
        pauseTimes = pauseTimes ?? [],
        resumeTimes = resumeTimes ?? [];

  String get typeLabel => switch (type) {
        SessionType.work => 'Work',
        SessionType.study => 'Study',
        SessionType.creative => 'Creative',
      };

  double get typeMultiplier => switch (type) {
        SessionType.work => 1.0,
        SessionType.study => 2.0,
        SessionType.creative => 3.0,
      };

  double get progress {
    if (targetMinutes == 0) return 0;
    return (actualMinutes / targetMinutes).clamp(0.0, 1.0);
  }

  void complete() {
    completed = true;
    completedAt = DateTime.now();
    actualMinutes = targetMinutes;
    xpEarned = ((targetMinutes * 10 * typeMultiplier) * 1.5).round();
  }

  void cancel(int minutesFocused) {
    completed = false;
    completedAt = DateTime.now();
    actualMinutes = minutesFocused;
    xpEarned = (minutesFocused * 10 * typeMultiplier).round();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.name,
        'targetMinutes': targetMinutes,
        'actualMinutes': actualMinutes,
        'xpEarned': xpEarned,
        'completed': completed,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'pauseTimes': pauseTimes.map((d) => d.toIso8601String()).toList(),
        'resumeTimes': resumeTimes.map((d) => d.toIso8601String()).toList(),
      };

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        type: SessionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => SessionType.work,
        ),
        targetMinutes: json['targetMinutes'] as int? ?? 25,
        actualMinutes: json['actualMinutes'] as int? ?? 0,
        xpEarned: json['xpEarned'] as int? ?? 0,
        completed: json['completed'] as bool? ?? false,
        startedAt: DateTime.parse(json['startedAt'] as String),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        pauseTimes: (json['pauseTimes'] as List<dynamic>?)
                ?.map((d) => DateTime.parse(d as String))
                .toList() ??
            [],
        resumeTimes: (json['resumeTimes'] as List<dynamic>?)
                ?.map((d) => DateTime.parse(d as String))
                .toList() ??
            [],
      );
}
