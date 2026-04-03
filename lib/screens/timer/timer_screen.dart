import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/session_model.dart';
import '../../providers/timer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/penguin_avatar.dart';
import 'session_complete_screen.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.focusTime),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Column(
            children: [
              const Spacer(),

              // Penguin
              PenguinAvatar(
                size: 80,
                expression: timerProvider.isRunning
                    ? PenguinExpression.focused
                    : timerProvider.isPaused
                        ? PenguinExpression.confused
                        : PenguinExpression.happy,
              ),
              const SizedBox(height: 24),

              // Timer ring
              TimerProgressRing(
                progress: timerProvider.progress,
                size: 260,
                timeText: timerProvider.hasSession
                    ? timerProvider.formattedTime
                    : '${timerProvider.selectedMinutes}:00',
              ),
              const SizedBox(height: 32),

              // Session type selector (only when not running)
              if (!timerProvider.hasSession) ...[
                _SessionTypeSelector(timerProvider: timerProvider),
                const SizedBox(height: 20),
                _DurationPresets(timerProvider: timerProvider),
                const SizedBox(height: 32),
              ],

              // Controls
              _TimerControls(
                timerProvider: timerProvider,
                userId: authProvider.uid,
                onComplete: () => _onSessionComplete(context),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSessionComplete(BuildContext context) async {
    final timerProvider = context.read<TimerProvider>();
    final userProvider = context.read<UserProvider>();
    final session = await timerProvider.complete();

    if (session != null && context.mounted) {
      await userProvider.onSessionCompleted(session);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SessionCompleteScreen(session: session),
          ),
        );
      }
    }
  }
}

class _SessionTypeSelector extends StatelessWidget {
  final TimerProvider timerProvider;

  const _SessionTypeSelector({required this.timerProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: SessionType.values.map((type) {
        final isSelected = type == timerProvider.selectedType;
        final label = switch (type) {
          SessionType.work => AppStrings.work,
          SessionType.study => AppStrings.study,
          SessionType.creative => AppStrings.creative,
        };
        final emoji = switch (type) {
          SessionType.work => '💼',
          SessionType.study => '📚',
          SessionType.creative => '🎨',
        };

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            selected: isSelected,
            onSelected: (_) => timerProvider.setSessionType(type),
            label: Text('$emoji $label'),
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
            labelStyle: TextStyle(
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DurationPresets extends StatelessWidget {
  final TimerProvider timerProvider;

  const _DurationPresets({required this.timerProvider});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: TimerProvider.presets.map((preset) {
        final minutes = preset['minutes'] as int;
        final isSelected = minutes == timerProvider.selectedMinutes;
        return ChoiceChip(
          selected: isSelected,
          onSelected: (_) => timerProvider.setDuration(minutes),
          label: Text('${preset['icon']} ${preset['label']}'),
          selectedColor: AppColors.secondary.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.secondary : AppColors.textSecondary,
            fontSize: 13,
          ),
        );
      }).toList(),
    );
  }
}

class _TimerControls extends StatelessWidget {
  final TimerProvider timerProvider;
  final String userId;
  final VoidCallback onComplete;

  const _TimerControls({
    required this.timerProvider,
    required this.userId,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (timerProvider.isTimerDone) {
      return ElevatedButton.icon(
        onPressed: onComplete,
        icon: const Icon(Icons.celebration_rounded),
        label: const Text('Collect Reward!'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          minimumSize: const Size(200, AppDimensions.buttonHeight),
        ),
      );
    }

    if (!timerProvider.hasSession) {
      return ElevatedButton.icon(
        onPressed: () => timerProvider.startSession(userId),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text(AppStrings.startFocus),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, AppDimensions.buttonHeight),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Give up
        OutlinedButton(
          onPressed: () async {
            final session = await context.read<TimerProvider>().cancel();
            if (session != null && session.actualMinutes > 0 && context.mounted) {
              await context.read<UserProvider>().onSessionCompleted(session);
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            minimumSize: const Size(100, AppDimensions.buttonHeight),
          ),
          child: const Text(AppStrings.giveUp),
        ),
        const SizedBox(width: 16),

        // Pause/Resume
        ElevatedButton.icon(
          onPressed: timerProvider.isPaused
              ? timerProvider.resume
              : timerProvider.pause,
          icon: Icon(
            timerProvider.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
          ),
          label: Text(timerProvider.isPaused ? AppStrings.resume : AppStrings.pause),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(140, AppDimensions.buttonHeight),
          ),
        ),
      ],
    );
  }
}
