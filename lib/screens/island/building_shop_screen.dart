import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/island_model.dart';
import '../../providers/island_provider.dart';
import '../../providers/user_provider.dart';

class BuildingShopScreen extends StatelessWidget {
  const BuildingShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final islandProvider = context.watch<IslandProvider>();
    final userProvider = context.watch<UserProvider>();
    final focusMinutes = userProvider.totalFocusMinutes;
    final unlocked = islandProvider.unlockedBuildings(focusMinutes);
    final locked = islandProvider.lockedBuildings(focusMinutes);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.buildingShop)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        children: [
          Text(
            'Available Buildings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          ...unlocked.map((type) => _BuildingCard(
                type: type,
                isUnlocked: true,
                focusMinutes: focusMinutes,
                onPlace: () async {
                  await islandProvider.placeBuilding(type);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${BuildingModel(type: type, x: 0, y: 0).emoji} ${BuildingModel(type: type, x: 0, y: 0).name} placed!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
              )),

          if (locked.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Locked Buildings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            ...locked.map((type) => _BuildingCard(
                  type: type,
                  isUnlocked: false,
                  focusMinutes: focusMinutes,
                )),
          ],
        ],
      ),
    );
  }
}

class _BuildingCard extends StatelessWidget {
  final BuildingType type;
  final bool isUnlocked;
  final int focusMinutes;
  final VoidCallback? onPlace;

  const _BuildingCard({
    required this.type,
    required this.isUnlocked,
    required this.focusMinutes,
    this.onPlace,
  });

  @override
  Widget build(BuildContext context) {
    final building = BuildingModel(type: type, x: 0, y: 0);
    final progress = isUnlocked
        ? 1.0
        : (focusMinutes / building.unlockMinutes).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Row(
          children: [
            // Building icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Center(
                child: Text(
                  building.emoji,
                  style: TextStyle(
                    fontSize: 32,
                    color: isUnlocked ? null : AppColors.textHint,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    building.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isUnlocked ? null : AppColors.textHint,
                    ),
                  ),
                  if (!isUnlocked) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.unlockAt} ${building.unlockMinutes} ${AppStrings.minutesFocused}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Place button
            if (isUnlocked)
              TextButton(
                onPressed: onPlace,
                child: const Text(
                  AppStrings.placeBuilding,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            if (!isUnlocked)
              const Icon(Icons.lock_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
