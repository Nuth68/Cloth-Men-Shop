import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'custom_button.dart';

enum EmptyState { empty, error, offline }

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
  final EmptyState state;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
    this.state = EmptyState.empty,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? _defaultIcon,
              size: 56,
              color: _iconColor,
            ),
            const SizedBox(height: 20),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: AppTypography.heading2.copyWith(
                  color: AppColors.monoBlack,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.monoGrey,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                label: actionLabel!,
                onPressed: onAction,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData get _defaultIcon {
    switch (state) {
      case EmptyState.empty:
        return Icons.inbox_outlined;
      case EmptyState.error:
        return Icons.error_outline;
      case EmptyState.offline:
        return Icons.wifi_off_outlined;
    }
  }

  Color get _iconColor {
    switch (state) {
      case EmptyState.empty:
        return AppColors.monoLightGrey;
      case EmptyState.error:
        return AppColors.error;
      case EmptyState.offline:
        return AppColors.warning;
    }
  }
}
