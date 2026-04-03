import 'package:flutter/foundation.dart';
import '../models/island_model.dart';
import '../services/island_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class IslandProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService;

  IslandModel? _island;
  bool _editMode = false;
  BuildingType? _selectedBuildingType;
  String? _selectedDecorationType;

  IslandProvider(this._storageService);

  IslandModel? get island => _island;
  bool get editMode => _editMode;
  BuildingType? get selectedBuildingType => _selectedBuildingType;
  String? get selectedDecorationType => _selectedDecorationType;
  List<BuildingModel> get buildings => _island?.buildings ?? [];
  List<DecorationModel> get decorations => _island?.decorations ?? [];
  IslandTheme get theme => _island?.theme ?? IslandTheme.tropical;

  Future<void> loadIsland(String userId) async {
    // Try local first
    _island = _storageService.getIsland();
    if (_island == null || _island!.userId != userId) {
      _island = await _firestoreService.getIsland(userId);
    }
    if (_island == null) {
      _island = IslandService.createNewIsland(userId);
      await _saveIsland();
    }
    notifyListeners();
  }

  List<BuildingType> unlockedBuildings(int totalFocusMinutes) =>
      IslandService.getUnlockedBuildings(totalFocusMinutes);

  List<BuildingType> lockedBuildings(int totalFocusMinutes) =>
      IslandService.getLockedBuildings(totalFocusMinutes);

  void toggleEditMode() {
    _editMode = !_editMode;
    if (!_editMode) {
      _selectedBuildingType = null;
      _selectedDecorationType = null;
    }
    notifyListeners();
  }

  void selectBuilding(BuildingType type) {
    _selectedBuildingType = type;
    _selectedDecorationType = null;
    notifyListeners();
  }

  void selectDecoration(String type) {
    _selectedDecorationType = type;
    _selectedBuildingType = null;
    notifyListeners();
  }

  Future<void> placeBuilding(BuildingType type) async {
    if (_island == null) return;
    final pos = IslandService.generatePosition(_island!.buildings);
    _island!.addBuilding(BuildingModel(
      type: type,
      x: pos.x,
      y: pos.y,
    ));
    _selectedBuildingType = null;
    await _saveIsland();
    notifyListeners();
  }

  Future<void> placeDecoration(String type, String emoji) async {
    if (_island == null) return;
    final pos = IslandService.generatePosition(_island!.buildings);
    _island!.addDecoration(DecorationModel(
      type: type,
      emoji: emoji,
      x: pos.x,
      y: pos.y,
    ));
    _selectedDecorationType = null;
    await _saveIsland();
    notifyListeners();
  }

  Future<void> moveBuilding(String id, double x, double y) async {
    if (_island == null) return;
    final building = _island!.buildings.where((b) => b.id == id).firstOrNull;
    if (building != null) {
      building.x = x;
      building.y = y;
      await _saveIsland();
      notifyListeners();
    }
  }

  Future<void> changeTheme(IslandTheme newTheme) async {
    if (_island == null) return;
    _island!.theme = newTheme;
    await _saveIsland();
    notifyListeners();
  }

  Future<void> _saveIsland() async {
    if (_island == null) return;
    await _storageService.saveIsland(_island!);
    await _firestoreService.saveIsland(_island!);
  }
}
