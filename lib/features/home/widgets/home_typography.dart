// ⚠️ DEPRECATED — use AppTypography.serif() / AppTypography.sans() from
// lib/core/theme/app_typography.dart instead.
//
// This file is kept as a re-export so existing imports don't break during
// the migration. Remove once all screens have been migrated.
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

@Deprecated('Use AppTypography.serif() from core/theme/app_typography.dart')
TextStyle monoSerif(
  double size, {
  FontWeight weight = FontWeight.w400,
<<<<<<< Updated upstream
  Color color = const Color(0xFF111111),
=======
  Color color = AppColors.monoBlack,
>>>>>>> Stashed changes
  double? height,
  double letterSpacing = 0,
}) {
  return AppTypography.serif(
    size,
    weight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

@Deprecated('Use AppTypography.sans() from core/theme/app_typography.dart')
TextStyle monoSans(
  double size, {
  FontWeight weight = FontWeight.w400,
<<<<<<< Updated upstream
  Color color = const Color(0xFF111111),
=======
  Color color = AppColors.monoBlack,
>>>>>>> Stashed changes
  double letterSpacing = 0.5,
}) {
  return AppTypography.sans(
    size,
    weight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );
}
