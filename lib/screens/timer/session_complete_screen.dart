import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/session_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/penguin_avatar.dart';

class SessionCompleteScreen extends StatelessWidget {
  final SessionModel session;

  const SessionCompleteScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final newAchievements = userProvider.newAchievements;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PenguinAvatar(
                size: 120,
                expression: PenguinExpression.excited,
              ),
              const SizedBox(height: 24),
              Text(
                session.completed
                    ? AppStrings.sessionComplete
                    : 'Good effort!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                session.completed
                    ? 'Amazing focus! Your island is growing.'
                    : 'Every minute counts towards your island.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Stats
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.timer_rounded,
                        label: 'Focus Time',
                        value: '${session.actualMinutes} minutes',
                      ),
                      const Divider(height: 24),
                      _StatRow(
                        icon: Icons.star_rounded,
                        label: 'XP Earned',
                        value: '+${session.xpEarned}',
                        valueColor: AppColors.primary,
                      ),
                      const Divider(height: 24),
                      _StatRow(
                        icon: Icons.category_rounded,
                        label: 'Session Type',
                        value: session.typeLabel,
                      ),
                    ],
                  ),
                ),
              ),

              // New achievements
              if (newAchievements.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'New Achievements!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.accent,
                      ),
                ),
                const SizedBox(height: 12),
                ...newAchievements.map((a) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Text(a.icon, style: const TextStyle(fontSize: 28)),
                        title: Text(a.title,
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(a.description),
                        trailing: Text(
                          '+${a.xpReward} XP',
                          style: TextStyle(
                            color: a.rarityColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )),
              ],

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  userProvider.clearNewAchievements();
                  Navigator.of(context).pop();
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: TextStyle(color: AppColors.textSecondary)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
