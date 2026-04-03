import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../providers/timer_provider.dart';
import '../providers/gamification_provider.dart';
import '../models/session_model.dart';
import '../widgets/progress_ring.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, _) {
        if (timerProvider.isActive) {
          return _ActiveTimerView(timerProvider: timerProvider);
        }
        return _IdleTimerView(timerProvider: timerProvider);
      },
    );
  }
}

// ---- Active timer (session running or paused) ----

class _ActiveTimerView extends StatelessWidget {
  final TimerProvider timerProvider;
  const _ActiveTimerView({required this.timerProvider});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final gamification = Provider.of<GamificationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.paddingLarge),
            // Session label
            Text(
              'Deep Focus',
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.textWhite.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              timerProvider.progressText,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            // Timer ring
            ProgressRing(
              progress: timerProvider.progress,
              size: AppDimensions.timerSize,
              strokeWidth: AppDimensions.timerStrokeWidth,
              progressColor: timerProvider.isPaused
                  ? AppColors.warning
                  : AppColors.primary,
              backgroundColor: AppColors.textWhite.withOpacity(0.1),
              animate: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timerProvider.formattedTime,
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'remaining',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textWhite.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Session info card
            _buildSessionInfoCard(context, timerProvider, gamification, textTheme),
            const SizedBox(height: AppDimensions.paddingLarge),
            // Control buttons
            _buildControls(context, timerProvider),
            const SizedBox(height: AppDimensions.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfoCard(
    BuildContext context,
    TimerProvider timerProvider,
    GamificationProvider gamification,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem(
            label: 'Session',
            value: '${gamification.totalSessions + 1}',
            textTheme: textTheme,
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.textWhite.withOpacity(0.15),
          ),
          _infoItem(
            label: 'Elapsed',
            value: timerProvider.formattedElapsedTime,
            textTheme: textTheme,
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.textWhite.withOpacity(0.15),
          ),
          _infoItem(
            label: 'Coins',
            value: '+${timerProvider.currentSessionStats['estimatedXP'] ?? 0}',
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required String label,
    required String value,
    required TextTheme textTheme,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textWhite.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, TimerProvider timerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop button
        _controlButton(
          icon: Icons.stop_rounded,
          color: AppColors.error,
          size: 52,
          onTap: () => timerProvider.cancelSession(),
        ),
        const SizedBox(width: AppDimensions.paddingLarge),
        // Pause / Resume button (larger, center)
        _controlButton(
          icon: timerProvider.isPaused
              ? Icons.play_arrow_rounded
              : Icons.pause_rounded,
          color: AppColors.primary,
          size: 72,
          onTap: () {
            if (timerProvider.isPaused) {
              timerProvider.resumeSession();
            } else {
              timerProvider.pauseSession();
            }
          },
        ),
        const SizedBox(width: AppDimensions.paddingLarge),
        // Skip button
        _controlButton(
          icon: Icons.skip_next_rounded,
          color: AppColors.secondary,
          size: 52,
          onTap: () => timerProvider.completeSession(),
        ),
      ],
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textWhite, size: size * 0.5),
      ),
    );
  }
}

// ---- Idle view (no session active) ----

class _IdleTimerView extends StatefulWidget {
  final TimerProvider timerProvider;
  const _IdleTimerView({required this.timerProvider});

  @override
  State<_IdleTimerView> createState() => _IdleTimerViewState();
}

class _IdleTimerViewState extends State<_IdleTimerView> {
  int _selectedMinutes = 25;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.paddingLarge),
              Text(
                'Focus Timer',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'Choose a session and start focusing',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textWhite.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              // Big time display
              ProgressRing(
                progress: 0,
                size: AppDimensions.timerSize,
                strokeWidth: AppDimensions.timerStrokeWidth,
                progressColor: AppColors.primary,
                backgroundColor: AppColors.textWhite.withOpacity(0.1),
                animate: false,
                child: Text(
                  '${_selectedMinutes.toString().padLeft(2, '0')}:00',
                  style: textTheme.displayLarge?.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
              ),
              const Spacer(),
              // Preset cards
              _buildPresets(textTheme),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Start button
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.timerProvider.startSession(
                      type: SessionType.focus,
                      durationMinutes: _selectedMinutes,
                      taskDescription: 'Focus Session',
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLarge),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresets(TextTheme textTheme) {
    final presets = [
      _Preset('Pomodoro', 25, Icons.timer),
      _Preset('Short Break', 5, Icons.coffee),
      _Preset('Long Break', 15, Icons.self_improvement),
      _Preset('Deep Work', 90, Icons.psychology),
    ];

    return Wrap(
      spacing: AppDimensions.paddingSmall,
      runSpacing: AppDimensions.paddingSmall,
      children: presets.map((p) {
        final isSelected = p.minutes == _selectedMinutes;
        return GestureDetector(
          onTap: () => setState(() => _selectedMinutes = p.minutes),
          child: Container(
            width: (MediaQuery.of(context).size.width -
                    AppDimensions.paddingLarge * 2 -
                    AppDimensions.paddingSmall) /
                2,
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.textWhite.withOpacity(0.06),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textWhite.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(p.icon,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textWhite.withOpacity(0.6),
                    size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textWhite,
                      ),
                    ),
                    Text(
                      '${p.minutes} min',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textWhite.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Preset {
  final String name;
  final int minutes;
  final IconData icon;
  _Preset(this.name, this.minutes, this.icon);
}
