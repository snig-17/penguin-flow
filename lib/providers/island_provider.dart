// lib/providers/island_provider.dart
import 'package:flutter/foundation.dart';
import '../../../services/island_service.dart';
import '../../../models/island_model.dart';
import '../../../models/user_model.dart';

class IslandProvider extends ChangeNotifier {
  final IslandService _islandService;

  bool _isEditMode = false;
  String? _selectedBuildingId;
  String? _selectedDecorationId;
  bool _showBuildingInfo = false;

  IslandProvider({
    required IslandService islandService,
  }) : _islandService = islandService {
    // Listen to island service changes
    _islandService.addListener(_onIslandUpdate);
  }

  // Island data getters
  IslandModel? get userIsland => _islandService.userIsland;
  List<IslandModel> get friendIslands => _islandService.friendIslands;
  List<IslandModel> get allIslands => _islandService.allIslands;

  bool get hasUserIsland => userIsland != null;

  // Island properties
  String get ownerName => userIsland?.ownerName ?? 'Unknown';
  IslandTheme get theme => userIsland?.theme ?? IslandTheme.arctic;
  int get totalFocusTime => userIsland?.totalFocusTime ?? 0;
  DateTime? get lastUpdated => userIsland?.lastUpdated;
  List<Building> get buildings => userIsland?.buildings ?? [];
  List<Decoration> get decorations => userIsland?.decorations ?? [];

  // Edit mode state
  bool get isEditMode => _isEditMode;
  String? get selectedBuildingId => _selectedBuildingId;
  String? get selectedDecorationId => _selectedDecorationId;
  bool get showBuildingInfo => _showBuildingInfo;
  bool get hasSelection => _selectedBuildingId != null || _selectedDecorationId != null;

  // Island statistics
  Map<String, dynamic> get islandStats => _islandService.getIslandStats();
  int get buildingCount => buildings.length;
  int get decorationCount => decorations.length;
  double get completionPercentage => islandStats['completionPercentage'] ?? 0.0;

  // Available content
  List<BuildingType> get availableBuildings => _islandService.getAvailableBuildings(totalFocusTime);

  List<BuildingType> get lockedBuildings {
    final all = BuildingType.values;
    final available = availableBuildings;
    return all.where((building) => !available.contains(building)).toList();
  }

  // Building management
  Future<void> createIsland(String ownerName, IslandTheme theme) async {
    await _islandService.createUserIsland(ownerName, theme);
    notifyListeners();
  }

  Future<void> upgradeBuilding(String buildingId) async {
    await _islandService.upgradeBuilding(buildingId);
    notifyListeners();
  }

  Future<void> moveBuilding(String buildingId, Offset position) async {
    await _islandService.moveBuilding(buildingId, position);
    notifyListeners();
  }

  Future<void> moveDecoration(String decorationId, Offset position) async {
    await _islandService.moveDecoration(decorationId, position);
    notifyListeners();
  }

  // Theme management
  Future<void> changeTheme(IslandTheme newTheme) async {
    await _islandService.changeTheme(newTheme);
    notifyListeners();
  }

  List<IslandTheme> get availableThemes => [
    IslandTheme.arctic,
    IslandTheme.tropical,
    IslandTheme.forest,
    IslandTheme.desert,
    IslandTheme.volcanic,
    IslandTheme.crystal,
  ];

  String getThemeDisplayName(IslandTheme theme) {
    switch (theme) {
      case IslandTheme.arctic:
        return 'Arctic Paradise';
      case IslandTheme.tropical:
        return 'Tropical Haven';
      case IslandTheme.forest:
        return 'Mystic Forest';
      case IslandTheme.desert:
        return 'Desert Oasis';
      case IslandTheme.volcanic:
        return 'Volcanic Island';
      case IslandTheme.crystal:
        return 'Crystal Caverns';
    }
  }

  String getThemeDescription(IslandTheme theme) {
    switch (theme) {
      case IslandTheme.arctic:
        return 'A serene icy landscape with snow-covered peaks';
      case IslandTheme.tropical:
        return 'A vibrant paradise with palm trees and beaches';
      case IslandTheme.forest:
        return 'A mystical woodland filled with ancient trees';
      case IslandTheme.desert:
        return 'A golden oasis with cacti and sand dunes';
      case IslandTheme.volcanic:
        return 'A dramatic landscape with active volcanoes';
      case IslandTheme.crystal:
        return 'A magical realm with glowing crystal formations';
    }
  }

  // Edit mode management
  void enterEditMode() {
    _isEditMode = true;
    _clearSelection();
    notifyListeners();
  }

  void exitEditMode() {
    _isEditMode = false;
    _clearSelection();
    notifyListeners();
  }

  void selectBuilding(String buildingId) {
    _selectedBuildingId = buildingId;
    _selectedDecorationId = null;
    _showBuildingInfo = true;
    notifyListeners();
  }

  void selectDecoration(String decorationId) {
    _selectedDecorationId = decorationId;
    _selectedBuildingId = null;
    _showBuildingInfo = false;
    notifyListeners();
  }

  void clearSelection() {
    _clearSelection();
    notifyListeners();
  }

  void _clearSelection() {
    _selectedBuildingId = null;
    _selectedDecorationId = null;
    _showBuildingInfo = false;
  }

  void toggleBuildingInfo() {
    _showBuildingInfo = !_showBuildingInfo;
    notifyListeners();
  }

  // Building information
  Building? get selectedBuilding {
    if (_selectedBuildingId == null) return null;
    try {
      return buildings.firstWhere((b) => b.id == _selectedBuildingId);
    } catch (e) {
      return null;
    }
  }

  Decoration? get selectedDecoration {
    if (_selectedDecorationId == null) return null;
    try {
      return decorations.firstWhere((d) => d.id == _selectedDecorationId);
    } catch (e) {
      return null;
    }
  }

  String getBuildingDisplayName(BuildingType type) {
    switch (type) {
      case BuildingType.tent:
        return 'Explorer\'s Tent';
      case BuildingType.cabin:
        return 'Cozy Cabin';
      case BuildingType.workshop:
        return 'Craft Workshop';
      case BuildingType.lighthouse:
        return 'Guiding Lighthouse';
      case BuildingType.observatory:
        return 'Star Observatory';
      case BuildingType.castle:
        return 'Majestic Castle';
    }
  }

  String getBuildingDescription(BuildingType type) {
    switch (type) {
      case BuildingType.tent:
        return 'Your first shelter on the island. Simple but effective.';
      case BuildingType.cabin:
        return 'A comfortable wooden cabin for extended stays.';
      case BuildingType.workshop:
        return 'A place to craft and create useful items.';
      case BuildingType.lighthouse:
        return 'A beacon of hope guiding you through challenges.';
      case BuildingType.observatory:
        return 'Study the stars and expand your knowledge.';
      case BuildingType.castle:
        return 'The ultimate achievement - your own castle!';
    }
  }

  int getBuildingUnlockTime(BuildingType type) {
    switch (type) {
      case BuildingType.tent:
        return 0;
      case BuildingType.cabin:
        return 30;
      case BuildingType.workshop:
        return 120;
      case BuildingType.lighthouse:
        return 300;
      case BuildingType.observatory:
        return 600;
      case BuildingType.castle:
        return 1200;
    }
  }

  String getFormattedUnlockTime(int minutes) {
    if (minutes < 60) {
      return '\${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '\${hours}h';
      } else {
        return '\${hours}h \${remainingMinutes}m';
      }
    }
  }

  // Progress tracking
  double get progressToNextBuilding {
    final availableCount = availableBuildings.length;
    final totalCount = BuildingType.values.length;

    if (availableCount >= totalCount) {
      return 1.0; // All buildings unlocked
    }

    final nextBuilding = BuildingType.values
        .where((building) => !availableBuildings.contains(building))
        .reduce((a, b) => getBuildingUnlockTime(a) < getBuildingUnlockTime(b) ? a : b);

    final requiredTime = getBuildingUnlockTime(nextBuilding);
    return (totalFocusTime / requiredTime).clamp(0.0, 1.0);
  }

  BuildingType? get nextBuildingToUnlock {
    final locked = lockedBuildings;
    if (locked.isEmpty) return null;

    locked.sort((a, b) => getBuildingUnlockTime(a).compareTo(getBuildingUnlockTime(b)));
    return locked.first;
  }

  int get minutesToNextBuilding {
    final nextBuilding = nextBuildingToUnlock;
    if (nextBuilding == null) return 0;

    final requiredTime = getBuildingUnlockTime(nextBuilding);
    return (requiredTime - totalFocusTime).clamp(0, requiredTime);
  }

  // Friend islands
  Future<void> generateFriendIslands([int count = 8]) async {
    await _islandService.generateFriendIslands(count);
    notifyListeners();
  }

  IslandModel? getFriendIsland(String id) {
    try {
      return friendIslands.firstWhere((island) => island.id == id);
    } catch (e) {
      return null;
    }
  }

  // Sorting and filtering
  List<IslandModel> getSortedFriendIslands({
    IslandSortBy sortBy = IslandSortBy.lastUpdated,
    bool ascending = false,
  }) {
    final sorted = [...friendIslands];

    switch (sortBy) {
      case IslandSortBy.name:
        sorted.sort((a, b) => a.ownerName.compareTo(b.ownerName));
        break;
      case IslandSortBy.focusTime:
        sorted.sort((a, b) => a.totalFocusTime.compareTo(b.totalFocusTime));
        break;
      case IslandSortBy.buildings:
        sorted.sort((a, b) => a.buildings.length.compareTo(b.buildings.length));
        break;
      case IslandSortBy.lastUpdated:
        sorted.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
        break;
    }

    return ascending ? sorted : sorted.reversed.toList();
  }

  List<IslandModel> filterIslandsByTheme(IslandTheme theme) {
    return friendIslands.where((island) => island.theme == theme).toList();
  }

  // Export functionality
  Map<String, dynamic> exportIslandData() {
    return _islandService.exportIslandData();
  }

  // Formatted display values
  String get formattedFocusTime {
    final hours = totalFocusTime ~/ 60;
    final minutes = totalFocusTime % 60;

    if (hours > 0) {
      return '\${hours}h \${minutes}m';
    } else {
      return '\${minutes}m';
    }
  }

  String get formattedLastUpdated {
    if (lastUpdated == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastUpdated!);

    if (difference.inDays > 0) {
      return '\${difference.inDays} day\${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '\${difference.inHours} hour\${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '\${difference.inMinutes} minute\${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Private methods
  void _onIslandUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _islandService.removeListener(_onIslandUpdate);
    super.dispose();
  }
}

// Sorting enum
enum IslandSortBy {
  name,
  focusTime,
  buildings,
  lastUpdated,
}
