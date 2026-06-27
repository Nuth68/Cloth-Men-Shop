import 'package:flutter/material.dart';

/// Single source of truth for all text styles in the app.
/// Locale-aware: uses system fonts for Khmer, Georgia/Helvetica for others.
class AppTypography {
  AppTypography._();

  static const String _serif = 'Georgia';
  static const String _sans = 'Helvetica Neue';
  // Use system default for Khmer (iOS/Android have built-in Khmer support)
  static const String _khmerSans = 'sans-serif';
  static const String _khmerSerif = 'serif';

  static Locale _locale = const Locale('en');
  static void setLocale(Locale locale) => _locale = locale;

  static bool get _isKhmer => _locale.languageCode == 'km';

  static String get serifFamily => _isKhmer ? _khmerSerif : _serif;
  static String get sansFamily => _isKhmer ? _khmerSans : _sans;

  static String get primaryFont => serifFamily;

  // ── Display ──
  static TextStyle get displayLarge => TextStyle(fontFamily: serifFamily, fontSize: 28, fontWeight: FontWeight.w700, height: 1.18, letterSpacing: _isKhmer ? 1 : 4);
  static TextStyle get displayMedium => TextStyle(fontFamily: serifFamily, fontSize: 26, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: _isKhmer ? 1 : 2.5);
  static TextStyle get heading1 => TextStyle(fontFamily: serifFamily, fontSize: 22, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get heading2 => TextStyle(fontFamily: serifFamily, fontSize: 18, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: 0.5);

  // ── Body ──
  static TextStyle get bodyLarge => TextStyle(fontFamily: sansFamily, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodyMedium => TextStyle(fontFamily: sansFamily, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodySmall => TextStyle(fontFamily: sansFamily, fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);

  // ── Labels ──
  static TextStyle get labelLarge => TextStyle(fontFamily: sansFamily, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.5);
  static TextStyle get labelSmall => TextStyle(fontFamily: sansFamily, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.8);

  // ── Button ──
  static TextStyle get button => TextStyle(fontFamily: sansFamily, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.5);

  // ── Price ──
  static TextStyle get price => TextStyle(fontFamily: sansFamily, fontSize: 20, fontWeight: FontWeight.w700);

  // ── Aliases ──
  static TextStyle get caption => bodySmall;
  static TextStyle get body => bodyLarge;

  // ── Helpers ──
  static TextStyle serif(double size, {FontWeight weight = FontWeight.w400, Color? color, double? height, double? letterSpacing}) {
    return TextStyle(fontFamily: serifFamily, fontSize: size, fontWeight: weight, color: color, height: height, letterSpacing: letterSpacing);
  }

  static TextStyle sans(double size, {FontWeight weight = FontWeight.w400, Color? color, double? height, double? letterSpacing}) {
    return TextStyle(fontFamily: sansFamily, fontSize: size, fontWeight: weight, color: color, height: height, letterSpacing: letterSpacing);
  }
}
