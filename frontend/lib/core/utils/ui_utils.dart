// I-Fridge — UI Utilities
// ========================
// Shared helpers for haptic feedback, smooth transitions, and formatting.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Haptic feedback helpers — call these on key interactions.
class Haptics {
  /// Light tap — buttons, toggles, nav taps.
  static void light() => HapticFeedback.lightImpact();

  /// Medium tap — likes, saves, confirmations.
  static void medium() => HapticFeedback.mediumImpact();

  /// Heavy tap — mode switch, critical actions.
  static void heavy() => HapticFeedback.heavyImpact();

  /// Selection tick — filters, pickers, steps.
  static void selection() => HapticFeedback.selectionClick();
}

/// Smooth page route with iOS-style slide transition.
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  SmoothPageRoute({
    required WidgetBuilder builder,
    super.settings,
  }) : super(
    pageBuilder: (context, anim, secAnim) => builder(context),
    transitionsBuilder: (context, anim, secAnim, child) {
      final curvedAnim = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curvedAnim),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}

/// Format large numbers (e.g. 1200 → "1.2K", 1500000 → "1.5M")
String formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return '$count';
}
