import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Shared BoxDecorations, shadows, and shapes used across the app.
class AppDecorations {
  AppDecorations._();

  // ── Cards ──

  static BoxDecoration card(BuildContext context) => BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.monoDivider, width: 0.5),
      );

  static BoxDecoration cardElevated(BuildContext context) => BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

  // ── Button shapes ──

  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  );

  // ── Image placeholder ──

  static BoxDecoration get imagePlaceholder => BoxDecoration(
        color: AppColors.monoLightGrey,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      );

  // ── Bottom sheet ──

  static const RoundedRectangleBorder bottomSheetShape =
      RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  );

  // ── Drag handle ──

  static Widget get dragHandle => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          width: 32,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.monoDivider,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      );
}
