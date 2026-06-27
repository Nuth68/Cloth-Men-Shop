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

        // Color scheme
<<<<<<< Updated upstream
        colorScheme: ColorScheme.light(
=======
        colorScheme: const ColorScheme.light(
>>>>>>> Stashed changes
          primary: AppColors.monoBlack,
          secondary: AppColors.brass,
          surface: AppColors.white,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.monoBlack,
          error: AppColors.error,
        ),

        // AppBar
<<<<<<< Updated upstream
        appBarTheme: AppBarTheme(
=======
        appBarTheme: const AppBarTheme(
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            borderRadius: BorderRadius.circular(12),
=======
            borderRadius: BorderRadius.circular(4),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                const BorderSide(color: AppColors.monoBlack, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                const BorderSide(color: AppColors.error, width: 1),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
              borderRadius: BorderRadius.circular(12),
=======
              borderRadius: BorderRadius.circular(2),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            side: BorderSide(color: AppColors.monoBlack, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
=======
            side: const BorderSide(color: AppColors.monoBlack, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
>>>>>>> Stashed changes
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.button,
          ),
        ),

        // Bottom sheets
<<<<<<< Updated upstream
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),

        // Bottom nav
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
=======
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),

        // Bottom nav
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
>>>>>>> Stashed changes
          selectedItemColor: AppColors.monoBlack,
          unselectedItemColor: AppColors.monoGrey,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
        ),

        // Icons
<<<<<<< Updated upstream
        iconTheme: IconThemeData(
=======
        iconTheme: const IconThemeData(
>>>>>>> Stashed changes
          color: AppColors.monoBlack,
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
<<<<<<< Updated upstream
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
=======
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
>>>>>>> Stashed changes
          behavior: SnackBarBehavior.floating,
        ),

        // Text theme (Material 3 mapping)
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          headlineLarge: AppTypography.heading1,
          headlineMedium: AppTypography.heading2,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelSmall: AppTypography.labelSmall,
<<<<<<< Updated upstream
        ),
      );

  // ── Dark theme ──

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.darkBg,
        fontFamily: AppTypography.primaryFont,
        brightness: Brightness.dark,

        colorScheme: ColorScheme.dark(
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
          contentTextStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          headlineLarge: AppTypography.heading1,
          headlineMedium: AppTypography.heading2,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelSmall: AppTypography.labelSmall,
=======
>>>>>>> Stashed changes
        ),
      );

  // ── Dark theme ──

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.darkBg,
        brightness: Brightness.dark,

        colorScheme: const ColorScheme.dark(
          primary: AppColors.white,
          secondary: AppColors.brass,
          surface: AppColors.darkSurface,
          onPrimary: AppColors.monoBlack,
          onSecondary: AppColors.white,
          onSurface: AppColors.white,
          error: AppColors.error,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBg,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0.5,
        ),

        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          margin: EdgeInsets.zero,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.white, width: 1),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.monoBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.button,
            elevation: 0,
          ),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkBg,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.monoGrey,
        ),

        iconTheme: const IconThemeData(color: AppColors.white, size: 20),

        dividerTheme: const DividerThemeData(color: AppColors.darkCard),
      );
}
