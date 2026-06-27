import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool _isDark = false;
  static void setDarkMode(bool dark) => _isDark = dark;

  // ── Dynamic (invert in dark mode) ──
  static Color get white => _isDark ? darkSurface : const Color(0xFFFFFFFF);
  static Color get monoOffWhite => _isDark ? darkBg : const Color(0xFFF7F6F4);
  static Color get monoBlack =>
      _isDark ? const Color(0xFFE8E0D8) : const Color(0xFF111111);
  static Color get textPrimary =>
      _isDark ? const Color(0xFFE8E0D8) : const Color(0xFF111111);

  // ── Always-dark (use for elements that should stay dark in both modes) ──
  static const Color solidDark = Color(0xFF111111);

  // ── Accent ──
  static const Color brass = Color(0xFF9B72CF);
  static const Color brassLight = Color(0xFFF0E6FF);

  // ── Semantic ──
  static const Color success = Color(0xFF2D5A3D);
  static const Color error = Color(0xFFB94040);
  static const Color warning = Color(0xFFD4A017);

  // ── Greys ──
  static const Color monoGrey = Color(0xFF8A8A8A);
  static const Color monoLightGrey = Color(0xFFE8E6E1);
  static const Color monoDivider = Color(0xFFDDDAD5);

  // ── Dark mode ──
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2A2A2A);

  // ── Backward-compatible aliases ──
  static Color get navy => monoBlack;
  static Color get charcoal => monoBlack;
  static const Color slate = Color(0xFF5A6570);
  static const Color warmGray = monoGrey;
  static const Color lightGray = monoLightGrey;
  static Color get offWhite => monoOffWhite;
  static Color get black => monoBlack;
  static const Color accent = brass;
}
