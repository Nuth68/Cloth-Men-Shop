import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_decorations.dart';

enum CustomButtonVariant { primary, outline, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final CustomButtonVariant variant;
  final double height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = CustomButtonVariant.primary,
    this.height = 54,
    this.icon,
  });

  const CustomButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.height = 54,
    this.icon,
  }) : variant = CustomButtonVariant.primary;

  const CustomButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.height = 54,
    this.icon,
  }) : variant = CustomButtonVariant.outline;

  const CustomButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.height = 54,
    this.icon,
  }) : variant = CustomButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: _foregroundColor(isDark),
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: _foregroundColor(isDark)),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.button.copyWith(color: _foregroundColor(isDark)),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    switch (variant) {
      case CustomButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.brass : AppColors.monoBlack,
              disabledBackgroundColor: AppColors.monoGrey,
              shape: AppDecorations.buttonShape,
              padding: EdgeInsets.zero,
            ),
            child: Center(child: child),
          ),
        );

      case CustomButtonVariant.outline:
        return SizedBox(
          width: double.infinity,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.textPrimary : AppColors.monoBlack,
                width: 1,
              ),
              shape: AppDecorations.buttonShape,
              padding: EdgeInsets.zero,
            ),
            child: Center(child: child),
          ),
        );

      case CustomButtonVariant.text:
        return SizedBox(
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          ),
        );
    }
  }

  Color _foregroundColor(bool isDark) {
    switch (variant) {
      case CustomButtonVariant.primary:
        return isDark ? AppColors.solidDark : AppColors.white;
      case CustomButtonVariant.outline:
      case CustomButtonVariant.text:
        return isDark ? AppColors.textPrimary : AppColors.monoBlack;
    }
  }
}
