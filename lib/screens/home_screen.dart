import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../providers/user_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/gamification_provider.dart';
import '../models/session_model.dart';
import '../widgets/penguin_avatar.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onStartTimer;

  const HomeScreen({super.key, this.onStartTimer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDuration = 25;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final gamificationProvider = Provider.of<GamificationProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting header
              _buildGreetingHeader(userProvider, textTheme),
              const SizedBox(height: AppDimensions.paddingLarge),

              // Daily streak card
              _buildStreakCard(userProvider, gamificationProvider, textTheme),
              const SizedBox(height: AppDimensions.paddingMedium),

              // Quick start timer card
              _buildQuickStartCard(textTheme),
              const SizedBox(height: AppDimensions.paddingMedium),

              // Today's progress
              Text(
                "Today's Progress",
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              _buildProgressRow(userProvider, gamificationProvider, textTheme),
              const SizedBox(height: AppDimensions.paddingLarge),

              // Recent activity
              Text(
                'Recent Activity',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              _buildRecentActivity(textTheme, userProvider, gamificationProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader(UserProvider userProvider, TextTheme textTheme) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Row(
      children: [
        const PenguinAvatar(
          size: 56,
          expression: PenguinExpression.happy,
          animate: false,
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                userProvider.userName,
                style: textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildStreakCard(
    UserProvider userProvider,
    GamificationProvider gamificationProvider,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.sunsetGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.streak.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: AppColors.textWhite,
            size: 40,
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${userProvider.currentStreak} Day Streak!',
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  gamificationProvider.streakStatus,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textWhite.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(TextTheme textTheme) {
    final durations = [15, 25, 45, 60];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Start',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'Choose a duration and start focusing',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Duration chips
          Row(
            children: durations.map((d) {
              final isSelected = d == _selectedDuration;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDuration = d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${d}m',
                        style: textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Start button
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: () {
                final timerProvider =
                    Provider.of<TimerProvider>(context, listen: false);
                timerProvider.startSession(
                  type: SessionType.focus,
                  durationMinutes: _selectedDuration,
                  taskDescription: 'Focus Session',
                );
                if (widget.onStartTimer != null) {
                  widget.onStartTimer!();
                }
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Focus Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    UserProvider userProvider,
    GamificationProvider gamificationProvider,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.timer_outlined,
          label: 'Focus Time',
          value: userProvider.formattedTotalFocusTime,
          color: AppColors.secondary,
          textTheme: textTheme,
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        _buildStatCard(
          icon: Icons.check_circle_outline,
          label: 'Sessions',
          value: '${gamificationProvider.totalSessions}',
          color: AppColors.primary,
          textTheme: textTheme,
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        _buildStatCard(
          icon: Icons.monetization_on_outlined,
          label: 'Coins',
          value: '${gamificationProvider.currentXP}',
          color: AppColors.achievement,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required TextTheme textTheme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppDimensions.iconLarge),
            const SizedBox(height: AppDimensions.paddingSmall),
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
    TextTheme textTheme,
    UserProvider userProvider,
    GamificationProvider gamificationProvider,
  ) {
    final activities = <_ActivityItem>[];

    // Show real stats-based activity
    if (gamificationProvider.totalSessions > 0) {
      activities.add(_ActivityItem(
        icon: Icons.timer,
        color: AppColors.primary,
        title: 'Focus Sessions Completed',
        subtitle: '${gamificationProvider.totalSessions} sessions - ${userProvider.formattedTotalFocusTime} total',
        time: userProvider.formattedLastActivity,
      ));
    }

    if (userProvider.currentStreak > 0) {
      activities.add(_ActivityItem(
        icon: Icons.local_fire_department,
        color: AppColors.streak,
        title: '${userProvider.currentStreak} Day Streak',
        subtitle: userProvider.streakStatus,
        time: 'Active',
      ));
    }

    if (gamificationProvider.unlockedAchievements.isNotEmpty) {
      final latest = gamificationProvider.unlockedAchievements.last;
      activities.add(_ActivityItem(
        icon: Icons.emoji_events,
        color: AppColors.achievement,
        title: 'Achievement Unlocked',
        subtitle: '${latest.title} - ${latest.description}',
        time: '',
      ));
    }

    // Fallback for new users
    if (activities.isEmpty) {
      activities.add(_ActivityItem(
        icon: Icons.play_circle_outline,
        color: AppColors.primary,
        title: 'Welcome to PenguinFlow!',
        subtitle: 'Start your first focus session to get going',
        time: 'Now',
      ));
    }

    return Column(
      children: activities.map((activity) {
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
                  color: activity.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Icon(activity.icon, color: activity.color, size: 20),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      activity.subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (activity.time.isNotEmpty)
                Text(
                  activity.time,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  _ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
