import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Core palette ──
  static const Color monoBlack = Color(0xFF111111);
  static const Color monoOffWhite = Color(0xFFF7F6F4);
  static const Color white = Color(0xFFFFFFFF);

  // ── Accent ──
  static const Color brass = Color(0xFFC8A96E);
  static const Color brassLight = Color(0xFFF5EDDE);

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
  static const Color navy = monoBlack;
  static const Color charcoal = monoBlack;
  static const Color slate = Color(0xFF5A6570);
  static const Color warmGray = monoGrey;
  static const Color lightGray = monoLightGrey;
  static const Color offWhite = monoOffWhite;
  static const Color black = monoBlack;
  static const Color accent = brass;
}
