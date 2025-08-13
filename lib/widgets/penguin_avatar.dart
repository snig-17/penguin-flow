// lib/widgets/penguin_avatar.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/constants/app_colors.dart';

class PenguinAvatar extends StatefulWidget {
  final double size;
  final PenguinExpression expression;
  final bool animate;
  final VoidCallback? onTap;
  final String? customImagePath;

  const PenguinAvatar({
    Key? key,
    this.size = 120.0,
    this.expression = PenguinExpression.happy,
    this.animate = true,
    this.onTap,
    this.customImagePath,
  }) : super(key: key);

  @override
  State<PenguinAvatar> createState() => _PenguinAvatarState();
}

class _PenguinAvatarState extends State<PenguinAvatar>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _blinkController;
  late AnimationController _celebrationController;

  late Animation<double> _floatAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _celebrationAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _blinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    _celebrationAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _floatController.repeat(reverse: true);

    // Random blinking
    _scheduleNextBlink();
  }

  void _scheduleNextBlink() {
    Future.delayed(Duration(seconds: 2 + math.Random().nextInt(4)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse();
          _scheduleNextBlink();
        });
      }
    });
  }

  void celebrate() {
    _celebrationController.forward().then((_) {
      _celebrationController.reverse();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _blinkController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
          celebrate();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatAnimation,
          _blinkAnimation,
          _celebrationAnimation,
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, math.sin(_floatAnimation.value * 2 * math.pi) * 5),
            child: Transform.scale(
              scale: _celebrationAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 0.1, // Subtle rotation
                child: widget.customImagePath != null
                    ? _buildCustomAvatar()
                    : _buildPenguinDrawing(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomAvatar() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          widget.customImagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPenguinDrawing(),
        ),
      ),
    );
  }

  Widget _buildPenguinDrawing() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: PenguinPainter(
          expression: widget.expression,
          eyeOpenness: _blinkAnimation.value,
        ),
      ),
    );
  }
}

class PenguinPainter extends CustomPainter {
  final PenguinExpression expression;
  final double eyeOpenness;

  PenguinPainter({
    required this.expression,
    this.eyeOpenness = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.4;

    // Body (main oval)
    final bodyPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: bodyRadius * 1.5,
        height: bodyRadius * 2,
      ),
      bodyPaint,
    );

    // Belly (white oval)
    final bellyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + bodyRadius * 0.2),
        width: bodyRadius * 0.8,
        height: bodyRadius * 1.3,
      ),
      bellyPaint,
    );

    // Head (circle)
    final headRadius = bodyRadius * 0.6;
    canvas.drawCircle(
      Offset(center.dx, center.dy - bodyRadius * 0.7),
      headRadius,
      bodyPaint,
    );

    // Eyes
    _drawEyes(canvas, Offset(center.dx, center.dy - bodyRadius * 0.7), headRadius);

    // Beak
    _drawBeak(canvas, Offset(center.dx, center.dy - bodyRadius * 0.5), headRadius);

    // Wings
    _drawWings(canvas, center, bodyRadius);

    // Feet
    _drawFeet(canvas, Offset(center.dx, center.dy + bodyRadius * 0.9), bodyRadius);
  }

  void _drawEyes(Canvas canvas, Offset headCenter, double headRadius) {
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final eyeRadius = headRadius * 0.2;
    final eyeY = headCenter.dy - headRadius * 0.2;

    // Left eye
    final leftEyeCenter = Offset(headCenter.dx - headRadius * 0.3, eyeY);
    canvas.drawCircle(leftEyeCenter, eyeRadius, eyePaint);

    if (eyeOpenness > 0.1) {
      // Draw pupil based on expression
      Offset pupilOffset = Offset.zero;
      switch (expression) {
        case PenguinExpression.happy:
          pupilOffset = const Offset(0, -2);
          break;
        case PenguinExpression.focused:
          pupilOffset = const Offset(0, 0);
          break;
        case PenguinExpression.excited:
          pupilOffset = Offset(math.cos(DateTime.now().millisecondsSinceEpoch * 0.01) * 2, 0);
          break;
        case PenguinExpression.sleepy:
          pupilOffset = const Offset(0, 3);
          break;
        case PenguinExpression.confused:
          pupilOffset = const Offset(-2, 0);
          break;
      }

      canvas.drawCircle(
        leftEyeCenter + pupilOffset,
        eyeRadius * 0.5 * eyeOpenness,
        pupilPaint,
      );
    }

    // Right eye
    final rightEyeCenter = Offset(headCenter.dx + headRadius * 0.3, eyeY);
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyePaint);

    if (eyeOpenness > 0.1) {
      Offset pupilOffset = Offset.zero;
      switch (expression) {
        case PenguinExpression.happy:
          pupilOffset = const Offset(0, -2);
          break;
        case PenguinExpression.focused:
          pupilOffset = const Offset(0, 0);
          break;
        case PenguinExpression.excited:
          pupilOffset = Offset(math.cos(DateTime.now().millisecondsSinceEpoch * 0.01) * 2, 0);
          break;
        case PenguinExpression.sleepy:
          pupilOffset = const Offset(0, 3);
          break;
        case PenguinExpression.confused:
          pupilOffset = const Offset(2, 0);
          break;
      }

      canvas.drawCircle(
        rightEyeCenter + pupilOffset,
        eyeRadius * 0.5 * eyeOpenness,
        pupilPaint,
      );
    }

    // Draw eyelids if blinking
    if (eyeOpenness < 1.0) {
      final eyelidPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      final eyelidHeight = eyeRadius * 2 * (1 - eyeOpenness);

      canvas.drawRect(
        Rect.fromCenter(
          center: leftEyeCenter,
          width: eyeRadius * 2,
          height: eyelidHeight,
        ),
        eyelidPaint,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: rightEyeCenter,
          width: eyeRadius * 2,
          height: eyelidHeight,
        ),
        eyelidPaint,
      );
    }
  }

  void _drawBeak(Canvas canvas, Offset position, double headRadius) {
    final beakPaint = Paint()
      ..color = AppColors.warning
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    final beakWidth = headRadius * 0.3;
    final beakHeight = headRadius * 0.2;

    beakPath.moveTo(position.dx - beakWidth / 2, position.dy);
    beakPath.lineTo(position.dx + beakWidth / 2, position.dy);
    beakPath.lineTo(position.dx, position.dy + beakHeight);
    beakPath.close();

    canvas.drawPath(beakPath, beakPaint);
  }

  void _drawWings(Canvas canvas, Offset bodyCenter, double bodyRadius) {
    final wingPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Left wing
    final leftWingPath = Path();
    leftWingPath.addOval(Rect.fromCenter(
      center: Offset(bodyCenter.dx - bodyRadius * 0.8, bodyCenter.dy - bodyRadius * 0.2),
      width: bodyRadius * 0.6,
      height: bodyRadius * 1.2,
    ));
    canvas.drawPath(leftWingPath, wingPaint);

    // Right wing
    final rightWingPath = Path();
    rightWingPath.addOval(Rect.fromCenter(
      center: Offset(bodyCenter.dx + bodyRadius * 0.8, bodyCenter.dy - bodyRadius * 0.2),
      width: bodyRadius * 0.6,
      height: bodyRadius * 1.2,
    ));
    canvas.drawPath(rightWingPath, wingPaint);
  }

  void _drawFeet(Canvas canvas, Offset position, double bodyRadius) {
    final feetPaint = Paint()
      ..color = AppColors.warning
      ..style = PaintingStyle.fill;

    final footWidth = bodyRadius * 0.4;
    final footHeight = bodyRadius * 0.2;

    // Left foot
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(position.dx - bodyRadius * 0.3, position.dy),
        width: footWidth,
        height: footHeight,
      ),
      feetPaint,
    );

    // Right foot
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(position.dx + bodyRadius * 0.3, position.dy),
        width: footWidth,
        height: footHeight,
      ),
      feetPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PenguinPainter oldDelegate) {
    return oldDelegate.expression != expression ||
           oldDelegate.eyeOpenness != eyeOpenness;
  }
}

enum PenguinExpression {
  happy,
  focused,
  excited,
  sleepy,
  confused,
}

// Specialized penguin avatars
class LevelPenguinAvatar extends StatelessWidget {
  final int level;
  final double size;
  final VoidCallback? onTap;

  const LevelPenguinAvatar({
    Key? key,
    required this.level,
    this.size = 80.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PenguinExpression expression;
    if (level >= 25) {
      expression = PenguinExpression.excited;
    } else if (level >= 10) {
      expression = PenguinExpression.happy;
    } else if (level >= 5) {
      expression = PenguinExpression.focused;
    } else {
      expression = PenguinExpression.happy;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        PenguinAvatar(
          size: size,
          expression: expression,
          onTap: onTap,
        ),
        if (level >= 50)
          Positioned(
            top: 0,
            child: Icon(
              Icons.emoji_events,
              color: AppColors.accent,
              size: size * 0.25,
            ),
          ),
      ],
    );
  }
}
