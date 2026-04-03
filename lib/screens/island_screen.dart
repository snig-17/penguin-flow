import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../providers/island_provider.dart';
import '../providers/gamification_provider.dart';

class IslandScreen extends StatelessWidget {
  const IslandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final islandProvider = Provider.of<IslandProvider>(context);
    final gamification = Provider.of<GamificationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.ice,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, textTheme, gamification),
            // Island canvas
            Expanded(
              child: _buildIslandCanvas(context, textTheme, islandProvider),
            ),
            // Bottom panel
            _buildBottomPanel(context, textTheme, islandProvider, gamification),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    TextTheme textTheme,
    GamificationProvider gamification,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingMedium,
      ),
      child: Row(
        children: [
          Text(
            'My Island',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: AppColors.achievement,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${gamification.currentXP}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslandCanvas(
    BuildContext context,
    TextTheme textTheme,
    IslandProvider islandProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.snow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          // Snow ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.snow.withOpacity(0.0),
                    AppColors.snow,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusXL),
                  bottomRight: Radius.circular(AppDimensions.radiusXL),
                ),
              ),
            ),
          ),
          // Emoji buildings / decorations
          const Positioned(
            top: 60,
            left: 40,
            child: Text('\u{1F3E0}', style: TextStyle(fontSize: 36)),
          ),
          const Positioned(
            top: 90,
            right: 50,
            child: Text('\u{1F3D7}', style: TextStyle(fontSize: 32)),
          ),
          const Positioned(
            bottom: 80,
            left: 80,
            child: Text('\u{1F3E2}', style: TextStyle(fontSize: 34)),
          ),
          const Positioned(
            top: 140,
            left: 160,
            child: Text('\u{1F427}', style: TextStyle(fontSize: 28)),
          ),
          const Positioned(
            bottom: 60,
            right: 70,
            child: Text('\u{1F427}', style: TextStyle(fontSize: 24)),
          ),
          const Positioned(
            bottom: 100,
            left: 50,
            child: Text('\u{1F427}', style: TextStyle(fontSize: 22)),
          ),
          const Positioned(
            top: 40,
            right: 120,
            child: Text('\u{2744}\u{FE0F}', style: TextStyle(fontSize: 18)),
          ),
          const Positioned(
            top: 120,
            left: 100,
            child: Text('\u{1F332}', style: TextStyle(fontSize: 30)),
          ),
          // Empty state overlay
          if (islandProvider.buildingCount == 0)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.landscape_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete sessions to grow your island!',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(
    BuildContext context,
    TextTheme textTheme,
    IslandProvider islandProvider,
    GamificationProvider gamification,
  ) {
    final level = gamification.currentLevel;
    final progress = gamification.levelProgress;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      margin: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Island level + XP bar
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  'Island Level $level',
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusCircular),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: AppDimensions.progressBarHeight,
                    backgroundColor: AppColors.lightGrey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.xpBar),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(
                '${(progress * 100).toInt()}%',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Shop / Build buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppDimensions.buttonHeightSmall,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.storefront, size: 18),
                    label: const Text('Shop'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side:
                          const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: SizedBox(
                  height: AppDimensions.buttonHeightSmall,
                  child: ElevatedButton.icon(
                    onPressed: () => islandProvider.enterEditMode(),
                    icon: const Icon(Icons.construction, size: 18),
                    label: const Text('Build'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
