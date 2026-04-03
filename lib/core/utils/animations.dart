import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static const fastDuration = Duration(milliseconds: 200);
  static const mediumDuration = Duration(milliseconds: 300);
  static const slowDuration = Duration(milliseconds: 500);
  static const extraSlowDuration = Duration(milliseconds: 800);

  static const defaultCurve = Curves.easeInOut;
  static const bounceCurve = Curves.elasticOut;
  static const sharpCurve = Curves.easeOutCubic;

  static Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  static Animation<double> createBounceAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );
  }

  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 0.3),
  }) {
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );
  }
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: AppAnimations.mediumDuration,
        );
}
