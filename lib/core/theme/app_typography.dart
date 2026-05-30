import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String primaryFont = 'Georgia';

  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Color(0xFF2C2C2C),
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2C2C2C),
  );

  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2C2C2C),
  );

  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF7A7A7A),
  );

  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );
}
