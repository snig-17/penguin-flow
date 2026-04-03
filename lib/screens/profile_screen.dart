import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../providers/user_provider.dart';
import '../providers/gamification_provider.dart';
import '../services/auth_service.dart';
import '../widgets/penguin_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userProvider = Provider.of<UserProvider>(context);
    final gamification = Provider.of<GamificationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Green banner + avatar
            _buildHeader(context, textTheme, userProvider),
            const SizedBox(height: 44), // space for avatar overlap
            // User info
            _buildUserInfo(context, textTheme, userProvider),
            const SizedBox(height: AppDimensions.paddingLarge),
            // Stats row
            _buildStatsRow(textTheme, userProvider, gamification),
            const SizedBox(height: AppDimensions.paddingLarge),
            // Achievements section
            _buildAchievements(context, textTheme, gamification),
            const SizedBox(height: AppDimensions.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    TextTheme textTheme,
    UserProvider userProvider,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Green banner
        Container(
          height: 160,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  color: AppColors.textWhite,
                ),
              ),
            ),
          ),
        ),
        // Avatar overlapping the banner
        Positioned(
          bottom: -40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.background,
                child: PenguinAvatar(
                  size: 72,
                  expression: PenguinExpression.happy,
                  animate: false,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(
    BuildContext context,
    TextTheme textTheme,
    UserProvider userProvider,
  ) {
    return Column(
      children: [
        Text(
          userProvider.userName,
          style: textTheme.headlineMedium,
        ),
        if (userProvider.userEmail.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            userProvider.userEmail,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          userProvider.levelTitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Joined ${userProvider.formattedJoinDate}',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        // Sign Out button
        SizedBox(
          width: 160,
          child: OutlinedButton.icon(
            onPressed: () {
              AuthService().signOut();
            },
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    TextTheme textTheme,
    UserProvider userProvider,
    GamificationProvider gamification,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingMedium,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _statItem(
              label: 'Focus Time',
              value: userProvider.formattedTotalFocusTime,
              textTheme: textTheme,
            ),
            _divider(),
            _statItem(
              label: 'Sessions',
              value: '${gamification.totalSessions}',
              textTheme: textTheme,
            ),
            _divider(),
            _statItem(
              label: 'Streak',
              value: '${userProvider.currentStreak}',
              textTheme: textTheme,
            ),
            _divider(),
            _statItem(
              label: 'Level',
              value: '${userProvider.level}',
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem({
    required String label,
    required String value,
    required TextTheme textTheme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border,
    );
  }

  Widget _buildAchievements(
    BuildContext context,
    TextTheme textTheme,
    GamificationProvider gamification,
  ) {
    final achievements = gamification.availableAchievements;
    final unlocked = gamification.unlockedAchievements;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Achievements', style: textTheme.headlineSmall),
              const Spacer(),
              Text(
                '${unlocked.length}/${achievements.length}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          // Achievement cards (use available achievements, show lock state)
          if (achievements.isEmpty)
            _emptyAchievements(textTheme)
          else
            ...achievements.take(6).map((a) {
              final isUnlocked =
                  unlocked.any((u) => u.id == a.id);
              return Container(
                margin: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSmall),
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? AppColors.achievement.withOpacity(0.15)
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall),
                      ),
                      child: Icon(
                        isUnlocked
                            ? Icons.emoji_events
                            : Icons.lock_outline,
                        color: isUnlocked
                            ? AppColors.achievement
                            : AppColors.textLight,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: textTheme.titleMedium?.copyWith(
                              color: isUnlocked
                                  ? AppColors.textPrimary
                                  : AppColors.textLight,
                            ),
                          ),
                          Text(
                            a.description,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${a.xpReward} XP',
                      style: textTheme.bodySmall?.copyWith(
                        color: isUnlocked
                            ? AppColors.primary
                            : AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          // Placeholder achievements if the service returns none
          if (achievements.isEmpty) ...[],
        ],
      ),
    );
  }

  Widget _emptyAchievements(TextTheme textTheme) {
    final placeholders = [
      ('First Steps', 'Complete your first focus session', 50),
      ('Week Warrior', 'Maintain a 7-day streak', 100),
      ('Focused Mind', 'Complete 50 focus sessions', 200),
    ];

    return Column(
      children: placeholders.map((p) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: const Icon(Icons.lock_outline,
                    color: AppColors.textLight, size: 22),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.$1,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textLight,
                        )),
                    Text(p.$2,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        )),
                  ],
                ),
              ),
              Text(
                '+${p.$3} XP',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
