import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// Animation utilities for smooth, engaging interactions
/// Inspired by Duolingo's delightful micro-interactions
class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: AppDimensions.animationFast);
  static const Duration medium = Duration(milliseconds: AppDimensions.animationMedium);
  static const Duration slow = Duration(milliseconds: AppDimensions.animationSlow);
  static const Duration xSlow = Duration(milliseconds: AppDimensions.animationXSlow);

  // Curves - Duolingo uses bouncy, satisfying animations
  static const Curve bounceIn = Curves.elasticOut;
  static const Curve bounceOut = Curves.elasticIn;
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve snappy = Curves.easeOutBack;
  static const Curve gentle = Curves.easeInOut;

  /// Scale animation for button presses (Duolingo-style)
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 1.0,
    double end = 0.95,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  /// Bounce scale animation for achievements
  static Animation<double> createBounceAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: bounceIn,
    ));
  }

  /// Slide animation for page transitions
  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: smooth,
    ));
  }

  /// Fade animation with custom curve
  static Animation<double> createFadeAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  /// Rotation animation for loading indicators
  static Animation<double> createRotationAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }

  /// Color animation for progress indicators
  static Animation<Color?> createColorAnimation(
    AnimationController controller, {
    required Color begin,
    required Color end,
  }) {
    return ColorTween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: smooth,
    ));
  }

  /// Staggered animation helper
  static List<Animation<double>> createStaggeredAnimations(
    AnimationController controller,
    int count, {
    Duration interval = const Duration(milliseconds: 100),
  }) {
    final animations = <Animation<double>>[];
    final intervalValue = interval.inMilliseconds / controller.duration!.inMilliseconds;

    for (int i = 0; i < count; i++) {
      final begin = i * intervalValue;
      final end = (i * intervalValue) + (1.0 - (count - 1) * intervalValue);

      animations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(begin, end, curve: bounceIn),
          ),
        ),
      );
    }

    return animations;
  }
}

/// Custom page route with slide animation
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Offset direction;

  SlidePageRoute({
    required this.child,
    this.direction = const Offset(1.0, 0.0),
  }) : super(
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.medium,
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: direction,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.smooth,
      )),
      child: child,
    );
  }
}

/// Scale page route for modal-style transitions
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ScalePageRoute({required this.child})
      : super(
          transitionDuration: AppAnimations.medium,
          reverseTransitionDuration: AppAnimations.medium,
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.bounceIn,
      )),
      child: child,
    );
  }
}
