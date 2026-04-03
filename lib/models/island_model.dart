import 'dart:ui';
import 'package:hive/hive.dart';
import 'user_model.dart';

part 'island_model.g.dart';

/// Building type enum
@HiveType(typeId: 13)
enum BuildingType {
  @HiveField(0)
  tent,
  @HiveField(1)
  cabin,
  @HiveField(2)
  workshop,
  @HiveField(3)
  lighthouse,
  @HiveField(4)
  observatory,
  @HiveField(5)
  castle,
}

/// Building model for island structures
@HiveType(typeId: 4)
class Building extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late BuildingType type;

  @HiveField(2)
  late double positionX;

  @HiveField(3)
  late double positionY;

  @HiveField(4)
  late int level;

  @HiveField(5)
  late bool isUnlocked;

  Building({
    String? id,
    required this.type,
    this.positionX = 0.0,
    this.positionY = 0.0,
    this.level = 1,
    this.isUnlocked = false,
  }) {
    this.id = id ?? '${type.name}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Create a Building with an Offset position
  factory Building.withPosition({
    String? id,
    required BuildingType type,
    required Offset position,
    int level = 1,
    bool isUnlocked = false,
  }) {
    return Building(
      id: id,
      type: type,
      positionX: position.dx,
      positionY: position.dy,
      level: level,
      isUnlocked: isUnlocked,
    );
  }

  Offset get position => Offset(positionX, positionY);

  Building copyWith({
    String? id,
    BuildingType? type,
    Offset? position,
    int? level,
    bool? isUnlocked,
  }) {
    return Building(
      id: id ?? this.id,
      type: type ?? this.type,
      positionX: position?.dx ?? positionX,
      positionY: position?.dy ?? positionY,
      level: level ?? this.level,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  @override
  String toString() {
    return 'Building(type: ${type.name}, level: $level, position: ($positionX, $positionY))';
  }
}

/// Decoration model for island aesthetics
@HiveType(typeId: 5)
class Decoration extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late double positionX;

  @HiveField(3)
  late double positionY;

  @HiveField(4)
  late bool isUnlocked;

  Decoration({
    String? id,
    required this.type,
    this.positionX = 0.0,
    this.positionY = 0.0,
    this.isUnlocked = false,
  }) {
    this.id = id ?? '${type}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Create a Decoration with an Offset position
  factory Decoration.withPosition({
    String? id,
    required String type,
    required Offset position,
    bool isUnlocked = false,
  }) {
    return Decoration(
      id: id,
      type: type,
      positionX: position.dx,
      positionY: position.dy,
      isUnlocked: isUnlocked,
    );
  }

  Offset get position => Offset(positionX, positionY);

  Decoration copyWith({
    String? id,
    String? type,
    Offset? position,
    bool? isUnlocked,
  }) {
    return Decoration(
      id: id ?? this.id,
      type: type ?? this.type,
      positionX: position?.dx ?? positionX,
      positionY: position?.dy ?? positionY,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  @override
  String toString() {
    return 'Decoration(type: $type, position: ($positionX, $positionY))';
  }
}

/// Island model representing user's productivity island
@HiveType(typeId: 3)
class IslandModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String ownerName;

  @HiveField(2)
  late int themeIndex; // stored as int for Hive

  @HiveField(3)
  late List<Building> buildings;

  @HiveField(4)
  late List<Decoration> decorations;

  @HiveField(5)
  late int totalFocusTime; // in minutes

  @HiveField(6)
  late DateTime lastUpdated;

  IslandModel({
    required this.id,
    required this.ownerName,
    IslandTheme theme = IslandTheme.arctic,
    List<Building>? buildings,
    List<Decoration>? decorations,
    this.totalFocusTime = 0,
    DateTime? lastUpdated,
    int? themeIndex,
  }) {
    this.themeIndex = themeIndex ?? theme.index;
    this.buildings = buildings ?? [];
    this.decorations = decorations ?? [];
    this.lastUpdated = lastUpdated ?? DateTime.now();
  }

  IslandTheme get theme => IslandTheme.values[themeIndex];
  set theme(IslandTheme value) => themeIndex = value.index;

  IslandModel copyWith({
    String? id,
    String? ownerName,
    IslandTheme? theme,
    List<Building>? buildings,
    List<Decoration>? decorations,
    int? totalFocusTime,
    DateTime? lastUpdated,
  }) {
    return IslandModel(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      theme: theme ?? this.theme,
      buildings: buildings ?? this.buildings,
      decorations: decorations ?? this.decorations,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerName': ownerName,
      'theme': theme.name,
      'totalFocusTime': totalFocusTime,
      'lastUpdated': lastUpdated.toIso8601String(),
      'buildingCount': buildings.length,
      'decorationCount': decorations.length,
    };
  }

  /// Deserialize from JSON
  factory IslandModel.fromJson(Map<String, dynamic> json) {
    return IslandModel(
      id: json['id'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      theme: IslandTheme.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => IslandTheme.arctic,
      ),
      totalFocusTime: json['totalFocusTime'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'IslandModel(owner: $ownerName, theme: ${theme.name}, buildings: ${buildings.length})';
  }
}
