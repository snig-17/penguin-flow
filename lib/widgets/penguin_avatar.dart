import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum PenguinExpression { happy, focused, excited, sleepy, confused }

class PenguinAvatar extends StatefulWidget {
  final double size;
  final PenguinExpression expression;
  final bool animate;

  const PenguinAvatar({
    super.key,
    this.size = 120,
    this.expression = PenguinExpression.happy,
    this.animate = true,
  });

  @override
  State<PenguinAvatar> createState() => _PenguinAvatarState();
}

class _PenguinAvatarState extends State<PenguinAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bobAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _bobAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bobAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.animate ? _bobAnimation.value : 0),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _PenguinPainter(expression: widget.expression),
            ),
          ),
        );
      },
    );
  }
}

class _PenguinPainter extends CustomPainter {
  final PenguinExpression expression;

  _PenguinPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.35;

    // Body (black)
    final bodyPaint = Paint()..color = const Color(0xFF2C2C2C);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + bodyRadius * 0.2),
        width: bodyRadius * 2,
        height: bodyRadius * 2.4,
      ),
      bodyPaint,
    );

    // Belly (white)
    final bellyPaint = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + bodyRadius * 0.4),
        width: bodyRadius * 1.3,
        height: bodyRadius * 1.8,
      ),
      bellyPaint,
    );

    // Eyes
    final eyeY = center.dy - bodyRadius * 0.15;
    final eyeSpacing = bodyRadius * 0.35;
    _drawEye(canvas, Offset(center.dx - eyeSpacing, eyeY), bodyRadius * 0.18);
    _drawEye(canvas, Offset(center.dx + eyeSpacing, eyeY), bodyRadius * 0.18);

    // Beak
    final beakPaint = Paint()..color = AppColors.accent;
    final beakPath = Path();
    final beakY = eyeY + bodyRadius * 0.35;
    beakPath.moveTo(center.dx - bodyRadius * 0.2, beakY);
    beakPath.lineTo(center.dx, beakY + bodyRadius * 0.25);
    beakPath.lineTo(center.dx + bodyRadius * 0.2, beakY);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Feet
    final feetPaint = Paint()..color = AppColors.accent;
    final feetY = center.dy + bodyRadius * 1.4;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bodyRadius * 0.3, feetY),
        width: bodyRadius * 0.5,
        height: bodyRadius * 0.2,
      ),
      feetPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bodyRadius * 0.3, feetY),
        width: bodyRadius * 0.5,
        height: bodyRadius * 0.2,
      ),
      feetPaint,
    );

    // Expression
    if (expression == PenguinExpression.happy || expression == PenguinExpression.excited) {
      // Rosy cheeks
      final cheekPaint = Paint()..color = Colors.pink.withValues(alpha: 0.3);
      canvas.drawCircle(
        Offset(center.dx - bodyRadius * 0.5, eyeY + bodyRadius * 0.2),
        bodyRadius * 0.12,
        cheekPaint,
      );
      canvas.drawCircle(
        Offset(center.dx + bodyRadius * 0.5, eyeY + bodyRadius * 0.2),
        bodyRadius * 0.12,
        cheekPaint,
      );
    }
  }

  void _drawEye(Canvas canvas, Offset center, double radius) {
    // White
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    // Pupil
    final pupilOffset = switch (expression) {
      PenguinExpression.focused => Offset(0, -radius * 0.15),
      PenguinExpression.sleepy => Offset(0, radius * 0.2),
      _ => Offset.zero,
    };
    canvas.drawCircle(
      center + pupilOffset,
      radius * 0.55,
      Paint()..color = const Color(0xFF2C2C2C),
    );
    // Highlight
    canvas.drawCircle(
      center + pupilOffset + Offset(-radius * 0.2, -radius * 0.2),
      radius * 0.2,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _PenguinPainter oldDelegate) =>
      expression != oldDelegate.expression;
}
