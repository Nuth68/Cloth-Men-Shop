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
    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
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

    }
  }
}
