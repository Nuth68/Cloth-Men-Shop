import 'package:flutter/services.dart';

/// Centralized haptic feedback utility.
///
/// Usage:
/// ```dart
/// AppHaptics.light();  // subtle feedback (taps, selections)
/// AppHaptics.medium(); // confirmation feedback (add to cart, save)
/// AppHaptics.heavy();  // strong feedback (place order, checkout)
/// AppHaptics.selection(); // selection click (chips, toggles)
/// ```
class AppHaptics {
  AppHaptics._();

  /// Subtle tap feedback — product taps, nav item taps, filter chip selects.
  static void light() => HapticFeedback.lightImpact();

  /// Medium confirmation — add to cart, save to wishlist, apply filter.
  static void medium() => HapticFeedback.mediumImpact();

  /// Strong commitment — place order, checkout confirm, delete item.
  static void heavy() => HapticFeedback.heavyImpact();

  /// Selection click — size selector, color selector, chip toggle.
  static void selection() => HapticFeedback.selectionClick();
}
