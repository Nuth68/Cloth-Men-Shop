import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  // ── Light theme ──

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.monoOffWhite,
        fontFamily: AppTypography.primaryFont,
        brightness: Brightness.light,

        // 
        
        colorScheme: ColorScheme.light(
          primary: AppColors.monoBlack,
          secondary: AppColors.brass,
          surface: AppColors.white,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.monoBlack,
          error: AppColors.error,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.monoBlack,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0.5,
          titleTextStyle: AppTypography.heading2,
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.monoDivider, width: 0.5),
          ),
          margin: EdgeInsets.zero,
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.monoLightGrey.withValues(alpha: 0.4),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.monoBlack, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.error, width: 1),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.monoGrey,
          ),
          labelStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.monoGrey,
          ),
        ),

        // Elevated buttons (solid black)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.monoBlack,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.monoGrey,
            disabledForegroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.button,
            elevation: 0,
          ),
        ),

        // Outlined buttons
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.monoBlack,
            side: BorderSide(color: AppColors.monoBlack, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.button,
          ),
        ),

        // Bottom sheets
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),

        // Bottom nav
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.monoBlack,
          unselectedItemColor: AppColors.monoGrey,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
        ),

        // Icons
        iconTheme: IconThemeData(
         
          size: 20,
        ),

        // Dividers
        dividerTheme: const DividerThemeData(
          color: AppColors.monoDivider,
          thickness: 0.5,
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.monoBlack,
          contentTextStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),

        // Text theme (Material 3 mapping)
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          headlineLarge: AppTypography.heading1,
          headlineMedium: AppTypography.heading2,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelSmall: AppTypography.labelSmall,
        ),
      );

  // ── Dark theme ──

  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: AppColors.darkBg,

        colorScheme: const ColorScheme.dark(
          primary: AppColors.white,
          secondary: AppColors.brass,
          surface: AppColors.darkSurface,
          onPrimary: AppColors.monoBlack,
          onSecondary: AppColors.white,
          onSurface: AppColors.white,
          error: AppColors.error,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBg,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0.5,
          titleTextStyle: AppTypography.heading2,
        ),

        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.darkSurface, width: 0.5),
          ),
          margin: EdgeInsets.zero,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.white, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.monoGrey,
          ),
          labelStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.monoGrey,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brass,
            foregroundColor: AppColors.solidDark,
            disabledBackgroundColor: AppColors.monoGrey,
            disabledForegroundColor: AppColors.solidDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.button,
            elevation: 0,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: BorderSide(color: AppColors.textPrimary, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.button,
          ),
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkBg,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.monoGrey,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
        ),

        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 20),

        dividerTheme: const DividerThemeData(
          color: AppColors.darkCard,
          thickness: 0.5,
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkCard,
          contentTextStyle: AppTypography.bodySmall.copyWith(color: AppColors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),

        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.white),
          displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.white),
          headlineLarge: AppTypography.heading1.copyWith(color: AppColors.white),
          headlineMedium: AppTypography.heading2.copyWith(color: AppColors.white),
          bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.white),
          bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.white),
          bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.white),
          labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.white),
          labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.white),
        ),
      );
}
