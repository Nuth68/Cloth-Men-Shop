import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: AppColors.offWhite,
        fontFamily: AppTypography.primaryFont,
        colorScheme: ColorScheme.light(
          primary: AppColors.navy,
          secondary: AppColors.accent,
          surface: AppColors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.charcoal,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.charcoal,
          unselectedItemColor: AppColors.warmGray,
        ),
      );

  static ThemeData get dark => ThemeData(
        scaffoldBackgroundColor: AppColors.darkBg,
        fontFamily: AppTypography.primaryFont,
        colorScheme: ColorScheme.dark(
          primary: AppColors.white,
          secondary: AppColors.accent,
          surface: AppColors.darkCard,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkCard,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkCard,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.darkGrey,
        ),
      );
}
