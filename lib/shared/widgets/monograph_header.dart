import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
<<<<<<< Updated upstream
import 'steav_fashion_logo.dart';
=======
import '../../core/theme/app_typography.dart';
>>>>>>> Stashed changes

class MonographHeader extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onBag;
  final VoidCallback? onNotification;
  final List<Widget>? actions;
  final bool elevated;

  const MonographHeader({
    super.key,
    this.onSearch,
    this.onBag,
    this.onNotification,
    this.actions,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
<<<<<<< Updated upstream
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
=======
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
>>>>>>> Stashed changes
        child: Row(
          children: [
            GestureDetector(
              onTap: onSearch,
<<<<<<< Updated upstream
              child: Icon(
                Icons.search,
                color: AppColors.textPrimary,
=======
              child: const Icon(
                Icons.search,
                color: AppColors.monoBlack,
>>>>>>> Stashed changes
                size: 22,
              ),
            ),
            const Spacer(),
<<<<<<< Updated upstream
            SteavFashionLogo.small(),
            const Spacer(),
            if (actions != null) ...actions!,
            if (onNotification != null)
              GestureDetector(
                onTap: onNotification,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
            if (onBag != null)
              GestureDetector(
                onTap: onBag,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textPrimary,
=======
            Text(
              'MONOGRAPH',
              style: AppTypography.heading2.copyWith(
                letterSpacing: 3,
                color: AppColors.monoBlack,
              ),
            ),
            const Spacer(),
            if (actions != null) ...actions!,
            if (onBag != null)
              GestureDetector(
                onTap: onBag,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.monoBlack,
>>>>>>> Stashed changes
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
