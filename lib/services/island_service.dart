import 'dart:math';
import '../models/island_model.dart';

class IslandService {
  static IslandModel createNewIsland(String userId) {
    final island = IslandModel(userId: userId);
    // Start with a tent in the center
    island.addBuilding(BuildingModel(
      type: BuildingType.tent,
      x: 0.5,
      y: 0.5,
    ));
    return island;
  }

  static List<BuildingType> getUnlockedBuildings(int totalFocusMinutes) {
    return BuildingType.values.where((type) {
      final required = BuildingModel(type: type, x: 0, y: 0).unlockMinutes;
      return totalFocusMinutes >= required;
    }).toList();
  }

  static List<BuildingType> getLockedBuildings(int totalFocusMinutes) {
    return BuildingType.values.where((type) {
      final required = BuildingModel(type: type, x: 0, y: 0).unlockMinutes;
      return totalFocusMinutes < required;
    }).toList();
  }

  static ({double x, double y}) generatePosition(List<BuildingModel> existing) {
    final random = Random();
    double x, y;
    int attempts = 0;
    do {
      x = 0.1 + random.nextDouble() * 0.8;
      y = 0.1 + random.nextDouble() * 0.8;
      attempts++;
    } while (_tooClose(x, y, existing) && attempts < 50);
    return (x: x, y: y);
  }

  static bool _tooClose(double x, double y, List<BuildingModel> existing) {
    for (final b in existing) {
      final dx = x - b.x;
      final dy = y - b.y;
      if (dx * dx + dy * dy < 0.02) return true;
    }
    return false;
  }

  static List<Map<String, String>> get availableDecorations => [
    {'type': 'tree', 'emoji': '🌴'},
    {'type': 'flower', 'emoji': '🌺'},
    {'type': 'rock', 'emoji': '🪨'},
    {'type': 'bush', 'emoji': '🌿'},
    {'type': 'flag', 'emoji': '🚩'},
    {'type': 'lamp', 'emoji': '💡'},
    {'type': 'bench', 'emoji': '🪑'},
    {'type': 'fountain', 'emoji': '⛲'},
  ];
}
