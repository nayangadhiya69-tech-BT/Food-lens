import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared route transitions for pushed routes.
///
/// ## Direction semantics (documented on purpose)
///
/// * Forward navigation (push) slides the incoming page in **from the right**,
///   moving visually to the left — the classic "right-to-left" slide.
/// * Back navigation (pop) mirrors it: the page slides out to the right.
/// * The direction is fixed by **navigation-stack semantics** and is *not*
///   derived from `Directionality`/`textDirection`. RTL localization changes
///   text layout only, so back/forward gestures are never reversed for an RTL
///   language, and LTR languages (all current locales: en, hi, gu) get a
///   consistent polished slide.
/// * Tab switches inside the shell are not route pushes and use no slide at
///   all (stateful shell keeps tabs alive).
/// * When the user enables reduced-motion (`MediaQuery.disableAnimations`),
///   the slide is replaced with a short fade.
class AppTransitions {
  AppTransitions._();

  static const Duration forward = Duration(milliseconds: 300);
  static const Duration backward = Duration(milliseconds: 260);
  static const Duration reduced = Duration(milliseconds: 120);

  static CustomTransitionPage<T> slide<T>({
    required LocalKey key,
    required Widget child,
    required BuildContext context,
  }) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: reduceMotion ? reduced : forward,
      reverseTransitionDuration: reduceMotion ? reduced : backward,
      transitionsBuilder: (context, animation, secondary, child) {
        if (reduceMotion) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        }
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }
}
