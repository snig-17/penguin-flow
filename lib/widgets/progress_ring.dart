// lib/widgets/progress_ring.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final bool animate;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showPercentage;
  final TextStyle? percentageStyle;

  const ProgressRing({
    Key? key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.progressColor,
    this.backgroundColor,
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeInOut,
    this.showPercentage = false,
    this.percentageStyle,
  }) : super(key: key);

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    _progressAnimation.addListener(() {
      setState(() {
        _currentProgress = _progressAnimation.value;
      });
    });

    if (widget.animate) {
      _controller.forward();
    } else {
      _currentProgress = widget.progress.clamp(0.0, 1.0);
    }
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _currentProgress,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ));

      if (widget.animate) {
        _controller.reset();
        _controller.forward();
      } else {
        _currentProgress = widget.progress.clamp(0.0, 1.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = widget.progressColor ?? AppColors.primary;
    final backgroundColor = widget.backgroundColor ?? 
        AppColors.surfaceVariant.withOpacity(0.3);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ProgressRingPainter(
              progress: 1.0,
              strokeWidth: widget.strokeWidth,
              color: backgroundColor,
            ),
          ),
          // Progress ring
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ProgressRingPainter(
              progress: _currentProgress,
              strokeWidth: widget.strokeWidth,
              color: progressColor,
            ),
          ),
          // Child widget or percentage
          if (widget.child != null)
            widget.child!
          else if (widget.showPercentage)
            Text(
              '\${(_currentProgress * 100).round()}%',
              style: widget.percentageStyle ?? 
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from the top
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.color != color;
  }
}

// Specialized progress ring for timer
class TimerProgressRing extends StatelessWidget {
  final double progress;
  final String timeText;
  final bool isRunning;
  final bool isPaused;
  final double size;

  const TimerProgressRing({
    Key? key,
    required this.progress,
    required this.timeText,
    this.isRunning = false,
    this.isPaused = false,
    this.size = 200.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    if (isPaused) {
      progressColor = AppColors.warning;
    } else if (isRunning) {
      progressColor = progress > 0.8 ? AppColors.error : AppColors.primary;
    } else {
      progressColor = AppColors.success;
    }

    return ProgressRing(
      progress: progress,
      size: size,
      strokeWidth: 12.0,
      progressColor: progressColor,
      backgroundColor: AppColors.surfaceVariant.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeText,
            style: TextStyle(
              fontSize: size * 0.12, // Responsive font size
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          if (isPaused)
            Icon(
              Icons.pause,
              color: AppColors.warning,
              size: size * 0.08,
            )
          else if (isRunning)
            Icon(
              Icons.play_arrow,
              color: progressColor,
              size: size * 0.08,
            ),
        ],
      ),
    );
  }
}

// XP Progress Ring
class XPProgressRing extends StatelessWidget {
  final int currentXP;
  final int requiredXP;
  final int level;
  final double size;

  const XPProgressRing({
    Key? key,
    required this.currentXP,
    required this.requiredXP,
    required this.level,
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = requiredXP > 0 ? currentXP / requiredXP : 0.0;

    return ProgressRing(
      progress: progress,
      size: size,
      strokeWidth: 6.0,
      progressColor: AppColors.accent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LV',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            level.toString(),
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// Achievement Progress Ring
class AchievementProgressRing extends StatelessWidget {
  final double progress;
  final int unlockedCount;
  final int totalCount;
  final double size;

  const AchievementProgressRing({
    Key? key,
    required this.progress,
    required this.unlockedCount,
    required this.totalCount,
    this.size = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressRing(
      progress: progress,
      size: size,
      strokeWidth: 4.0,
      progressColor: AppColors.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            color: AppColors.accent,
            size: size * 0.25,
          ),
          Text(
            '\$unlockedCount/\$totalCount',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// Streak Progress Ring
class StreakProgressRing extends StatelessWidget {
  final int currentStreak;
  final int nextMilestone;
  final double size;

  const StreakProgressRing({
    Key? key,
    required this.currentStreak,
    required this.nextMilestone,
    this.size = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = nextMilestone > 0 ? currentStreak / nextMilestone : 0.0;

    return ProgressRing(
      progress: progress.clamp(0.0, 1.0),
      size: size,
      strokeWidth: 4.0,
      progressColor: AppColors.warning.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            color: AppColors.warning,
            size: size * 0.25,
          ),
          Text(
            currentStreak.toString(),
            style: TextStyle(
              fontSize: size * 0.15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
