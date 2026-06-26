import 'package:flutter/material.dart';

/// Single source of truth for all text styles in the app.
///
/// Georgia (serif)  — display, headings, editorial moments
/// Helvetica Neue (sans) — body, labels, buttons, UI
class AppTypography {
  AppTypography._();

  static const String _serif = 'Georgia';
  static const String _sans = 'Helvetica Neue';

  // ── Serif / Display ──
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _serif,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.18,
    letterSpacing: 4,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _serif,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 2.5,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: _serif,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _serif,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ── Sans / Body ──
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Labels ──
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.8,
  );

  // ── Button ──
  static const TextStyle button = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  // ── Price ──
  static const TextStyle price = TextStyle(
    fontFamily: _sans,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // ── Caption (backward compat) ──
  static const TextStyle caption = bodySmall;

  // ── Backward-compatible body alias ──
  static const TextStyle body = bodyLarge;

  // ── Helpers for easy migration ──
  static TextStyle serif(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _serif,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle sans(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _sans,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// The primary font family for backward compatibility.
  static const String primaryFont = _serif;
}
