// lib/services/island_service.dart
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/island_model.dart';
import '../../../models/user_model.dart';
import '../../storage_service.dart';

class IslandService extends ChangeNotifier {
  final StorageService _storageService;
  IslandModel? _userIsland;
  List<IslandModel> _friendIslands = [];

  IslandService(this._storageService) {
    _loadIslandData();
  }

  // Getters
  IslandModel? get userIsland => _userIsland;
  List<IslandModel> get friendIslands => _friendIslands;
  List<IslandModel> get allIslands => [
    if (_userIsland != null) _userIsland!,
    ..._friendIslands,
  ];

  // Island management
  Future<void> createUserIsland(String ownerName, IslandTheme theme) async {
    _userIsland = IslandModel(
      id: 'user_island',
      ownerName: ownerName,
      theme: theme,
      buildings: [
        Building(
          type: BuildingType.tent,
          position: const Offset(0.3, 0.7),
          level: 1,
          isUnlocked: true,
        ),
      ],
      decorations: [
        Decoration(
          type: 'tree_pine',
          position: const Offset(0.2, 0.6),
          isUnlocked: true,
        ),
      ],
      totalFocusTime: 0,
      lastUpdated: DateTime.now(),
    );

    await _saveIslandData();
    notifyListeners();
  }

  Future<void> updateIslandProgress(int focusMinutes) async {
    if (_userIsland == null) return;

    final oldFocusTime = _userIsland!.totalFocusTime;
    final newFocusTime = oldFocusTime + focusMinutes;

    _userIsland = _userIsland!.copyWith(
      totalFocusTime: newFocusTime,
      lastUpdated: DateTime.now(),
    );

    // Check for new buildings/decorations unlocks
    _checkUnlocks(oldFocusTime, newFocusTime);

    await _saveIslandData();
    notifyListeners();
  }

  void _checkUnlocks(int oldTime, int newTime) {
    if (_userIsland == null) return;

    final milestones = [
      (30, BuildingType.cabin),     // 30 minutes
      (120, BuildingType.workshop), // 2 hours
      (300, BuildingType.lighthouse), // 5 hours
      (600, BuildingType.observatory), // 10 hours
      (1200, BuildingType.castle),  // 20 hours
    ];

    final decorationMilestones = [
      (60, 'rock_formation'),   // 1 hour
      (180, 'flower_patch'),    // 3 hours
      (360, 'fountain'),        // 6 hours
      (720, 'statue'),          // 12 hours
      (1000, 'bridge'),         // 16.7 hours
    ];

    bool hasNewUnlocks = false;

    // Check building unlocks
    for (final milestone in milestones) {
      final requiredTime = milestone.$1;
      final buildingType = milestone.$2;

      if (oldTime < requiredTime && newTime >= requiredTime) {
        _unlockBuilding(buildingType);
        hasNewUnlocks = true;
      }
    }

    // Check decoration unlocks
    for (final milestone in decorationMilestones) {
      final requiredTime = milestone.$1;
      final decorationType = milestone.$2;

      if (oldTime < requiredTime && newTime >= requiredTime) {
        _unlockDecoration(decorationType);
        hasNewUnlocks = true;
      }
    }

    if (hasNewUnlocks) {
      // This could trigger a notification or celebration animation
      debugPrint('New island features unlocked!');
    }
  }

  void _unlockBuilding(BuildingType type) {
    if (_userIsland == null) return;

    // Find a good position for the new building
    final position = _findBuildingPosition(type);

    final newBuilding = Building(
      type: type,
      position: position,
      level: 1,
      isUnlocked: true,
    );

    _userIsland = _userIsland!.copyWith(
      buildings: [..._userIsland!.buildings, newBuilding],
    );
  }

  void _unlockDecoration(String type) {
    if (_userIsland == null) return;

    // Find a good position for the new decoration
    final position = _findDecorationPosition();

    final newDecoration = Decoration(
      type: type,
      position: position,
      isUnlocked: true,
    );

    _userIsland = _userIsland!.copyWith(
      decorations: [..._userIsland!.decorations, newDecoration],
    );
  }

  Offset _findBuildingPosition(BuildingType type) {
    final random = Random();

    // Different building types prefer different areas
    switch (type) {
      case BuildingType.tent:
        return Offset(0.2 + random.nextDouble() * 0.3, 0.6 + random.nextDouble() * 0.2);
      case BuildingType.cabin:
        return Offset(0.4 + random.nextDouble() * 0.3, 0.5 + random.nextDouble() * 0.3);
      case BuildingType.workshop:
        return Offset(0.1 + random.nextDouble() * 0.3, 0.4 + random.nextDouble() * 0.3);
      case BuildingType.lighthouse:
        return Offset(0.7 + random.nextDouble() * 0.2, 0.1 + random.nextDouble() * 0.3);
      case BuildingType.observatory:
        return Offset(0.6 + random.nextDouble() * 0.3, 0.2 + random.nextDouble() * 0.2);
      case BuildingType.castle:
        return Offset(0.4 + random.nextDouble() * 0.2, 0.2 + random.nextDouble() * 0.2);
    }
  }

  Offset _findDecorationPosition() {
    final random = Random();
    return Offset(
      0.1 + random.nextDouble() * 0.8,
      0.1 + random.nextDouble() * 0.8,
    );
  }

  // Building management
  Future<void> upgradeBuilding(String buildingId) async {
    if (_userIsland == null) return;

    final buildings = [..._userIsland!.buildings];
    final buildingIndex = buildings.indexWhere((b) => b.id == buildingId);

    if (buildingIndex != -1 && buildings[buildingIndex].level < 3) {
      buildings[buildingIndex] = buildings[buildingIndex].copyWith(
        level: buildings[buildingIndex].level + 1,
      );

      _userIsland = _userIsland!.copyWith(buildings: buildings);
      await _saveIslandData();
      notifyListeners();
    }
  }

  Future<void> moveBuilding(String buildingId, Offset newPosition) async {
    if (_userIsland == null) return;

    final buildings = [..._userIsland!.buildings];
    final buildingIndex = buildings.indexWhere((b) => b.id == buildingId);

    if (buildingIndex != -1) {
      buildings[buildingIndex] = buildings[buildingIndex].copyWith(
        position: newPosition,
      );

      _userIsland = _userIsland!.copyWith(buildings: buildings);
      await _saveIslandData();
      notifyListeners();
    }
  }

  Future<void> moveDecoration(String decorationId, Offset newPosition) async {
    if (_userIsland == null) return;

    final decorations = [..._userIsland!.decorations];
    final decorationIndex = decorations.indexWhere((d) => d.id == decorationId);

    if (decorationIndex != -1) {
      decorations[decorationIndex] = decorations[decorationIndex].copyWith(
        position: newPosition,
      );

      _userIsland = _userIsland!.copyWith(decorations: decorations);
      await _saveIslandData();
      notifyListeners();
    }
  }

  // Theme management
  Future<void> changeTheme(IslandTheme newTheme) async {
    if (_userIsland == null) return;

    _userIsland = _userIsland!.copyWith(theme: newTheme);
    await _saveIslandData();
    notifyListeners();
  }

  // Friend islands
  Future<void> generateFriendIslands(int count) async {
    _friendIslands = List.generate(count, (index) => _generateRandomIsland(index));
    await _saveFriendIslands();
    notifyListeners();
  }

  IslandModel _generateRandomIsland(int index) {
    final random = Random();
    final themes = IslandTheme.values;
    final names = [
      'Alex Explorer', 'Sam Builder', 'Casey Focused', 'Riley Calm',
      'Jordan Zen', 'Avery Creative', 'Quinn Productive', 'Blake Mindful',
      'Dakota Serene', 'Sage Peaceful', 'River Flowing', 'Phoenix Rising',
    ];

    final theme = themes[random.nextInt(themes.length)];
    final name = names[random.nextInt(names.length)];
    final focusTime = 50 + random.nextInt(2000); // 50-2050 minutes

    final buildings = <Building>[
      Building(
        type: BuildingType.tent,
        position: Offset(0.2 + random.nextDouble() * 0.6, 0.5 + random.nextDouble() * 0.3),
        level: 1 + random.nextInt(3),
        isUnlocked: true,
      ),
    ];

    // Add more buildings based on focus time
    if (focusTime > 120) {
      buildings.add(Building(
        type: BuildingType.cabin,
        position: Offset(0.1 + random.nextDouble() * 0.8, 0.2 + random.nextDouble() * 0.6),
        level: 1 + random.nextInt(2),
        isUnlocked: true,
      ));
    }

    if (focusTime > 600) {
      buildings.add(Building(
        type: BuildingType.lighthouse,
        position: Offset(0.6 + random.nextDouble() * 0.3, 0.1 + random.nextDouble() * 0.4),
        level: 1 + random.nextInt(2),
        isUnlocked: true,
      ));
    }

    final decorations = <Decoration>[
      Decoration(
        type: 'tree_pine',
        position: Offset(random.nextDouble(), random.nextDouble()),
        isUnlocked: true,
      ),
      if (focusTime > 300)
        Decoration(
          type: 'rock_formation',
          position: Offset(random.nextDouble(), random.nextDouble()),
          isUnlocked: true,
        ),
    ];

    return IslandModel(
      id: 'friend_island_\$index',
      ownerName: name,
      theme: theme,
      buildings: buildings,
      decorations: decorations,
      totalFocusTime: focusTime,
      lastUpdated: DateTime.now().subtract(
        Duration(hours: random.nextInt(72)), // Updated 0-72 hours ago
      ),
    );
  }

  // Island statistics
  Map<String, dynamic> getIslandStats() {
    if (_userIsland == null) {
      return {
        'totalBuildings': 0,
        'totalDecorations': 0,
        'totalFocusTime': 0,
        'completionPercentage': 0.0,
        'theme': 'arctic',
      };
    }

    final maxBuildings = 10; // Maximum possible buildings
    final maxDecorations = 15; // Maximum possible decorations

    final buildingCount = _userIsland!.buildings.length;
    final decorationCount = _userIsland!.decorations.length;

    final completionPercentage = 
        ((buildingCount / maxBuildings) + (decorationCount / maxDecorations)) / 2 * 100;

    return {
      'totalBuildings': buildingCount,
      'totalDecorations': decorationCount,
      'totalFocusTime': _userIsland!.totalFocusTime,
      'completionPercentage': completionPercentage.clamp(0.0, 100.0),
      'theme': _userIsland!.theme.name,
    };
  }

  // Get buildings available for unlocking
  List<BuildingType> getAvailableBuildings(int focusTime) {
    final available = <BuildingType>[];

    if (focusTime >= 0) available.add(BuildingType.tent);
    if (focusTime >= 30) available.add(BuildingType.cabin);
    if (focusTime >= 120) available.add(BuildingType.workshop);
    if (focusTime >= 300) available.add(BuildingType.lighthouse);
    if (focusTime >= 600) available.add(BuildingType.observatory);
    if (focusTime >= 1200) available.add(BuildingType.castle);

    return available;
  }

  // Data persistence
  Future<void> _loadIslandData() async {
    _userIsland = await _storageService.getIsland();
    _friendIslands = await _storageService.getFriendIslands();

    // Generate friend islands if none exist
    if (_friendIslands.isEmpty) {
      await generateFriendIslands(8);
    }

    notifyListeners();
  }

  Future<void> _saveIslandData() async {
    if (_userIsland != null) {
      await _storageService.saveIsland(_userIsland!);
    }
  }

  Future<void> _saveFriendIslands() async {
    if (_userIsland != null) {
      await _storageService.saveFriendIslands([_userIsland!, ..._friendIslands]);
    }
  }

  // Export island as image data (for sharing)
  Map<String, dynamic> exportIslandData() {
    if (_userIsland == null) return {};

    return {
      'owner': _userIsland!.ownerName,
      'theme': _userIsland!.theme.name,
      'focusTime': _userIsland!.totalFocusTime,
      'buildings': _userIsland!.buildings.length,
      'decorations': _userIsland!.decorations.length,
      'lastUpdated': _userIsland!.lastUpdated.toIso8601String(),
    };
  }
}
