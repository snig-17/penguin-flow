import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/island_model.dart';
import '../../providers/island_provider.dart';
import '../../services/island_service.dart';
import 'building_shop_screen.dart';

class IslandScreen extends StatelessWidget {
  const IslandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final islandProvider = context.watch<IslandProvider>();
    final island = islandProvider.island;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myIsland),
        actions: [
          // Theme selector
          PopupMenuButton<IslandTheme>(
            icon: const Icon(Icons.palette_rounded),
            onSelected: (theme) => islandProvider.changeTheme(theme),
            itemBuilder: (_) => IslandTheme.values
                .map((theme) => PopupMenuItem(
                      value: theme,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: _themeColor(theme),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(_themeLabel(theme)),
                          if (theme == islandProvider.theme)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.check, size: 16),
                            ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          // Shop button
          IconButton(
            icon: const Icon(Icons.store_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BuildingShopScreen(),
              ),
            ),
          ),
        ],
      ),
      body: island == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Island background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _themeGradient(islandProvider.theme),
                    ),
                  ),
                ),

                // Island platform
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: _islandGroundColor(islandProvider.theme),
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Buildings
                        ...island.buildings.map((building) => Positioned(
                              left: building.x *
                                  MediaQuery.of(context).size.width *
                                  0.85 -
                                  30,
                              top: building.y *
                                  MediaQuery.of(context).size.width *
                                  0.85 -
                                  30,
                              child: GestureDetector(
                                onTap: () => _showBuildingInfo(
                                    context, building),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      building.emoji,
                                      style: const TextStyle(fontSize: 36),
                                    ),
                                    Text(
                                      building.name,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),

                        // Decorations
                        ...island.decorations.map((deco) => Positioned(
                              left: deco.x *
                                  MediaQuery.of(context).size.width *
                                  0.85 -
                                  15,
                              top: deco.y *
                                  MediaQuery.of(context).size.width *
                                  0.85 -
                                  15,
                              child: Text(
                                deco.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                // Island info overlay
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMD),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  island.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  '${island.buildings.length} buildings \u2022 ${island.decorations.length} decorations',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Add decoration button
                          PopupMenuButton<Map<String, String>>(
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            tooltip: 'Add decoration',
                            onSelected: (deco) {
                              islandProvider.placeDecoration(
                                deco['type']!,
                                deco['emoji']!,
                              );
                            },
                            itemBuilder: (_) => IslandService
                                .availableDecorations
                                .map((d) => PopupMenuItem(
                                      value: d,
                                      child: Text(
                                          '${d['emoji']} ${d['type']}'),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showBuildingInfo(BuildContext context, BuildingModel building) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Text(building.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(building.name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Level: ${building.level}'),
            const SizedBox(height: 4),
            Text('Placed: ${building.placedAt.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _themeColor(IslandTheme theme) => switch (theme) {
        IslandTheme.tropical => AppColors.tropicalWater,
        IslandTheme.arctic => AppColors.arcticWater,
        IslandTheme.volcanic => AppColors.volcanicLava,
        IslandTheme.forest => AppColors.forestGreen,
      };

  String _themeLabel(IslandTheme theme) => switch (theme) {
        IslandTheme.tropical => 'Tropical',
        IslandTheme.arctic => 'Arctic',
        IslandTheme.volcanic => 'Volcanic',
        IslandTheme.forest => 'Forest',
      };

  List<Color> _themeGradient(IslandTheme theme) => switch (theme) {
        IslandTheme.tropical => [
            const Color(0xFF87CEEB),
            AppColors.tropicalWater,
          ],
        IslandTheme.arctic => [
            const Color(0xFFE3F2FD),
            AppColors.arcticWater,
          ],
        IslandTheme.volcanic => [
            const Color(0xFF37474F),
            const Color(0xFF263238),
          ],
        IslandTheme.forest => [
            const Color(0xFF81C784),
            const Color(0xFF388E3C),
          ],
      };

  Color _islandGroundColor(IslandTheme theme) => switch (theme) {
        IslandTheme.tropical => AppColors.tropicalSand,
        IslandTheme.arctic => AppColors.arcticIce,
        IslandTheme.volcanic => AppColors.volcanicRock,
        IslandTheme.forest => AppColors.forestGround,
      };
}
