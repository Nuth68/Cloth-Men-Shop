import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class PressBanner extends StatelessWidget {
  const PressBanner({super.key});

  static const _press = [
    ('Vogue', false),
    ('Harpers', true),
    ('GQ', false),
    ('ELLE', true),
    ('Monocle', false),
  ];

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.surface(context),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _press
              .map(
                (p) => Text(
                  p.$1,
                  style: p.$2
                      ? AppTypography.serif(15, color: AppColors.monoBlack.withValues(alpha: 0.5))
                      : AppTypography.sans(11, color: AppColors.monoBlack.withValues(alpha: 0.4), letterSpacing: 1.2),
                ),
              )
              .toList(),
        ),
      );
}
