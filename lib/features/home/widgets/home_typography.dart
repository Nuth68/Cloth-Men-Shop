import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

TextStyle monoSerif(double size, {FontWeight weight = FontWeight.w400, Color color = AppColors.monoBlack, double? height, double letterSpacing = 0}) {
  return TextStyle(
    fontFamily: 'Georgia',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

TextStyle monoSans(double size, {FontWeight weight = FontWeight.w400, Color color = AppColors.monoBlack, double letterSpacing = 0.5}) {
  return TextStyle(
    fontFamily: 'Helvetica Neue',
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );
}
