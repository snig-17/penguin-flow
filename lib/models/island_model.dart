import 'package:hive/hive.dart';
import 'dart:math' as math;

part 'island_model.g.dart';

/// Island model representing user's productivity island
@HiveType(typeId: 3)
class IslandModel extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int level;

  @HiveField(3)
  late List<BuildingModel> buildings;

  @HiveField(4)
  late List<DecorationModel> decorations;

  @HiveField(5)
  late String theme; // 'tropical', 'arctic', 'volcanic', 'forest'

  @HiveField(6)
  late double size; // Island size multiplier

  @HiveField(7)
  late DateTime lastUpdated;

  @HiveField(8)
  late Map<String, int> resources;

  @HiveField(9)
  late bool isPublic;

  IslandModel({
    required this.userId,
    required this.name,
    this.level = 1,
    List<BuildingModel>? buildings,
    List<DecorationModel>? decorations,
    this.theme = 'tropical',
    this.size = 1.0,
    DateTime? lastUpdated,
    Map<String, int>? resources,
    this.isPublic = true,
  }) {
    this.buildings = buildings ?? [];
    this.decorations = decorations ?? [];
    this.lastUpdated = lastUpdated ?? DateTime.now();
    this.resources = resources ?? {
      'wood': 0,
      'stone': 0,
      'crystal': 0,
    };
  }

  /// Add a building to the island
  void addBuilding(BuildingModel building) {
    buildings.add(building);
    lastUpdated = DateTime.now();
  }

  /// Add a decoration to the island
  void addDecoration(DecorationModel decoration) {
    decorations.add(decoration);
    lastUpdated = DateTime.now();
  }

  /// Level up the island
  void levelUp() {
    level++;
    size = 1.0 + (level * 0.1); // Island grows 10% per level
    lastUpdated = DateTime.now();
  }

  /// Get total building count
  int get totalBuildings => buildings.length;

  /// Get buildings by type
  List<BuildingModel> getBuildingsByType(String type) {
    return buildings.where((b) => b.type == type).toList();
  }

  /// Calculate island population (for social features)
  int get population {
    return buildings.fold(0, (sum, building) => sum + building.capacity);
  }

  /// Get island color based on theme
  String get themeColor {
    switch (theme) {
      case 'tropical':
        return '#4FC3F7'; // Light blue
      case 'arctic':
        return '#E1F5FE'; // Ice blue
      case 'volcanic':
        return '#FF5722'; // Red orange
      case 'forest':
        return '#66BB6A'; // Green
      default:
        return '#4FC3F7';
    }
  }

  /// Generate random position for new buildings
  math.Point<double> generateBuildingPosition() {
    final random = math.Random();
    final angle = random.nextDouble() * 2 * math.pi;
    final distance = random.nextDouble() * (size * 100);

    return math.Point(
      math.cos(angle) * distance,
      math.sin(angle) * distance,
    );
  }

  @override
  String toString() {
    return 'IslandModel(name: \$name, level: \$level, buildings: \${buildings.length})';
  }
}

/// Building model for island structures
@HiveType(typeId: 4)
class BuildingModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type; // 'office', 'library', 'studio', 'house'

  @HiveField(2)
  late String name;

  @HiveField(3)
  late double x;

  @HiveField(4)
  late double y;

  @HiveField(5)
  late int level;

  @HiveField(6)
  late DateTime builtAt;

  @HiveField(7)
  late int capacity;

  @HiveField(8)
  late String sessionType; // Which session type built this

  BuildingModel({
    required this.id,
    required this.type,
    required this.name,
    required this.x,
    required this.y,
    this.level = 1,
    DateTime? builtAt,
    this.capacity = 1,
    required this.sessionType,
  }) {
    this.builtAt = builtAt ?? DateTime.now();
  }

  /// Get building color based on type
  String get color {
    switch (type) {
      case 'office':
        return '#1CB0F6'; // Blue
      case 'library':
        return '#58CC02'; // Green
      case 'studio':
        return '#FF9600'; // Orange
      case 'house':
        return '#9C27B0'; // Purple
      default:
        return '#1CB0F6';
    }
  }

  /// Get building icon
  String get icon {
    switch (type) {
      case 'office':
        return 'business';
      case 'library':
        return 'local_library';
      case 'studio':
        return 'palette';
      case 'house':
        return 'home';
      default:
        return 'business';
    }
  }

  /// Level up the building
  void levelUp() {
    level++;
    capacity = level;
  }

  @override
  String toString() {
    return 'BuildingModel(type: \$type, level: \$level, position: (\$x, \$y))';
  }
}

/// Decoration model for island aesthetics
@HiveType(typeId: 5)
class DecorationModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type; // 'tree', 'flower', 'rock', 'fountain'

  @HiveField(2)
  late double x;

  @HiveField(3)
  late double y;

  @HiveField(4)
  late double scale;

  @HiveField(5)
  late String color;

  @HiveField(6)
  late DateTime placedAt;

  DecorationModel({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.scale = 1.0,
    this.color = '#66BB6A',
    DateTime? placedAt,
  }) {
    this.placedAt = placedAt ?? DateTime.now();
  }

  /// Get decoration icon
  String get icon {
    switch (type) {
      case 'tree':
        return 'park';
      case 'flower':
        return 'local_florist';
      case 'rock':
        return 'landscape';
      case 'fountain':
        return 'water_drop';
      default:
        return 'park';
    }
  }

  @override
  String toString() {
    return 'DecorationModel(type: \$type, position: (\$x, \$y))';
  }
}

/// Friend island model for social features
class FriendIsland {
  final String userId;
  final String userName;
  final String penguinName;
  final IslandModel island;
  final bool isOnline;
  final DateTime lastSeen;
  final int friendshipLevel;

  FriendIsland({
    required this.userId,
    required this.userName,
    required this.penguinName,
    required this.island,
    required this.isOnline,
    required this.lastSeen,
    this.friendshipLevel = 1,
  });

  /// Generate mock friend islands for demo
  static List<FriendIsland> generateMockFriends(int count) {
    final friends = <FriendIsland>[];
    final random = math.Random();

    final names = [
      'Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank', 'Grace', 'Henry',
      'Iris', 'Jack', 'Kate', 'Liam', 'Maya', 'Noah', 'Olivia', 'Peter'
    ];

    final penguinNames = [
      'Waddles', 'Flipper', 'Snowball', 'Arctic', 'Frosty', 'Crystal',
      'Blizzard', 'Pepper', 'Sunny', 'Storm', 'Chill', 'Zippy'
    ];

    for (int i = 0; i < count; i++) {
      final userName = names[random.nextInt(names.length)];
      final penguinName = penguinNames[random.nextInt(penguinNames.length)];
      final level = random.nextInt(20) + 1;
      final buildingCount = random.nextInt(15) + 1;

      final island = IslandModel(
        userId: 'friend_\$i',
        name: '\$userName\'s Island',
        level: level,
        theme: ['tropical', 'arctic', 'volcanic', 'forest'][random.nextInt(4)],
        size: 1.0 + (level * 0.05),
      );

      // Add random buildings
      for (int j = 0; j < buildingCount; j++) {
        final position = island.generateBuildingPosition();
        final types = ['office', 'library', 'studio', 'house'];
        final sessionTypes = ['work', 'study', 'creative'];

        island.addBuilding(BuildingModel(
          id: 'building_\${j}',
          type: types[random.nextInt(types.length)],
          name: 'Building \${j + 1}',
          x: position.x,
          y: position.y,
          level: random.nextInt(3) + 1,
          sessionType: sessionTypes[random.nextInt(sessionTypes.length)],
        ));
      }

      friends.add(FriendIsland(
        userId: 'friend_\$i',
        userName: userName,
        penguinName: penguinName,
        island: island,
        isOnline: random.nextBool(),
        lastSeen: DateTime.now().subtract(Duration(
          hours: random.nextInt(24),
          minutes: random.nextInt(60),
        )),
        friendshipLevel: random.nextInt(5) + 1,
      ));
    }

    return friends;
  }
}
