import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/helpers.dart';
import '../../providers/user_provider.dart';
import '../../widgets/progress_ring.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hey, ${user?.displayName ?? 'Explorer'}! 🐧'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: XPProgressRing(
              progress: userProvider.levelProgress,
              level: userProvider.level,
              size: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppColors.accent,
                    label: 'Streak',
                    value: '${userProvider.currentStreak}',
                    suffix: 'days',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_rounded,
                    iconColor: AppColors.secondary,
                    label: 'Level',
                    value: '${userProvider.level}',
                    suffix: Helpers.levelTitle(userProvider.level),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer_rounded,
                    iconColor: AppColors.primary,
                    label: 'Focus Time',
                    value: Helpers.formatMinutes(userProvider.totalFocusMinutes),
                    suffix: 'total',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_rounded,
                    iconColor: AppColors.success,
                    label: 'Sessions',
                    value: '${userProvider.totalSessions}',
                    suffix: 'completed',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // XP Progress
            _XPProgressCard(
              level: userProvider.level,
              progress: userProvider.levelProgress,
              xpToNext: user?.xpToNextLevel ?? 0,
            ),
            const SizedBox(height: 24),

            // Recent sessions
            Text(
              'Recent Sessions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            if (userProvider.recentSessions.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('🐧', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'No sessions yet!\nStart your first focus session.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...userProvider.recentSessions.take(5).map((session) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: session.completed
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.textHint.withValues(alpha: 0.1),
                        child: Icon(
                          session.completed
                              ? Icons.check_rounded
                              : Icons.close_rounded,
                          color: session.completed
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                      title: Text(
                        '${session.typeLabel} - ${session.actualMinutes}min',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(Helpers.timeAgo(session.startedAt)),
                      trailing: Text(
                        '+${session.xpEarned} XP',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String suffix;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            Text(
              suffix,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XPProgressCard extends StatelessWidget {
  final int level;
  final double progress;
  final int xpToNext;

  const _XPProgressCard({
    required this.level,
    required this.progress,
    required this.xpToNext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level $level',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  '$xpToNext XP to next level',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.surfaceVariant,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Helpers.levelTitle(level),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
