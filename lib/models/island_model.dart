import 'package:uuid/uuid.dart';

enum IslandTheme { tropical, arctic, volcanic, forest }

enum BuildingType { tent, cabin, workshop, lighthouse, observatory, castle }

class BuildingModel {
  final String id;
  final BuildingType type;
  double x;
  double y;
  int level;
  DateTime placedAt;

  BuildingModel({
    String? id,
    required this.type,
    required this.x,
    required this.y,
    this.level = 1,
    DateTime? placedAt,
  })  : id = id ?? const Uuid().v4(),
        placedAt = placedAt ?? DateTime.now();

  String get name => switch (type) {
        BuildingType.tent => 'Tent',
        BuildingType.cabin => 'Cabin',
        BuildingType.workshop => 'Workshop',
        BuildingType.lighthouse => 'Lighthouse',
        BuildingType.observatory => 'Observatory',
        BuildingType.castle => 'Castle',
      };

  String get emoji => switch (type) {
        BuildingType.tent => '⛺',
        BuildingType.cabin => '🏠',
        BuildingType.workshop => '🏗️',
        BuildingType.lighthouse => '🗼',
        BuildingType.observatory => '🔭',
        BuildingType.castle => '🏰',
      };

  int get unlockMinutes => switch (type) {
        BuildingType.tent => 0,
        BuildingType.cabin => 30,
        BuildingType.workshop => 120,
        BuildingType.lighthouse => 300,
        BuildingType.observatory => 600,
        BuildingType.castle => 1200,
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'x': x,
        'y': y,
        'level': level,
        'placedAt': placedAt.toIso8601String(),
      };

  factory BuildingModel.fromJson(Map<String, dynamic> json) => BuildingModel(
        id: json['id'] as String,
        type: BuildingType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => BuildingType.tent,
        ),
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        level: json['level'] as int? ?? 1,
        placedAt: DateTime.parse(json['placedAt'] as String),
      );
}

class DecorationModel {
  final String id;
  final String type;
  final String emoji;
  double x;
  double y;

  DecorationModel({
    String? id,
    required this.type,
    required this.emoji,
    required this.x,
    required this.y,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'emoji': emoji,
        'x': x,
        'y': y,
      };

  factory DecorationModel.fromJson(Map<String, dynamic> json) =>
      DecorationModel(
        id: json['id'] as String,
        type: json['type'] as String,
        emoji: json['emoji'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
      );
}

class IslandModel {
  final String userId;
  String name;
  IslandTheme theme;
  int islandLevel;
  List<BuildingModel> buildings;
  List<DecorationModel> decorations;
  DateTime createdAt;
  DateTime updatedAt;

  IslandModel({
    required this.userId,
    this.name = 'My Island',
    this.theme = IslandTheme.tropical,
    this.islandLevel = 1,
    List<BuildingModel>? buildings,
    List<DecorationModel>? decorations,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : buildings = buildings ?? [],
        decorations = decorations ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  List<BuildingType> get unlockedBuildingTypes {
    return BuildingType.values; // all available, actual unlock check is in the provider
  }

  void addBuilding(BuildingModel building) {
    buildings.add(building);
    updatedAt = DateTime.now();
  }

  void addDecoration(DecorationModel decoration) {
    decorations.add(decoration);
    updatedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'theme': theme.name,
        'islandLevel': islandLevel,
        'buildings': buildings.map((b) => b.toJson()).toList(),
        'decorations': decorations.map((d) => d.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory IslandModel.fromJson(Map<String, dynamic> json) => IslandModel(
        userId: json['userId'] as String,
        name: json['name'] as String? ?? 'My Island',
        theme: IslandTheme.values.firstWhere(
          (e) => e.name == json['theme'],
          orElse: () => IslandTheme.tropical,
        ),
        islandLevel: json['islandLevel'] as int? ?? 1,
        buildings: (json['buildings'] as List<dynamic>?)
                ?.map((b) =>
                    BuildingModel.fromJson(b as Map<String, dynamic>))
                .toList() ??
            [],
        decorations: (json['decorations'] as List<dynamic>?)
                ?.map((d) =>
                    DecorationModel.fromJson(d as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
      );
}

class FriendIsland {
  final String odisplayName;
  final String odisplayPhoto;
  final int level;
  final IslandModel island;

  FriendIsland({
    required this.odisplayName,
    this.odisplayPhoto = '',
    required this.level,
    required this.island,
  });
}
