import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    this.color,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress.clamp(0.0, 1.0),
              color: color ?? AppColors.primary,
              backgroundColor: backgroundColor ?? AppColors.surfaceVariant,
              strokeWidth: strokeWidth,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      progress != old.progress || color != old.color;
}

// Timer-specific ring that changes color based on progress
class TimerProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final String timeText;

  const TimerProgressRing({
    super.key,
    required this.progress,
    this.size = 240,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    final color = progress < 0.5
        ? AppColors.primary
        : progress < 0.8
            ? AppColors.accent
            : AppColors.error;

    return ProgressRing(
      progress: progress,
      size: size,
      strokeWidth: 12,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeText,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.18,
                ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// XP progress ring
class XPProgressRing extends StatelessWidget {
  final double progress;
  final int level;
  final double size;

  const XPProgressRing({
    super.key,
    required this.progress,
    required this.level,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressRing(
      progress: progress,
      size: size,
      strokeWidth: 4,
      color: AppColors.secondary,
      child: Text(
        '$level',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: size * 0.3,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
