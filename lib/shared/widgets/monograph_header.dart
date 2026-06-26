import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'steav_fashion_logo.dart';

class MonographHeader extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onBag;
  final List<Widget>? actions;
  final bool elevated;

  const MonographHeader({
    super.key,
    this.onSearch,
    this.onBag,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: onSearch,
              child: const Icon(
                Icons.search,
                color: AppColors.monoBlack,
                size: 22,
              ),
            ),
            const Spacer(),
            SteavFashionLogo.small(),
            const Spacer(),
            if (actions != null) ...actions!,
            if (onBag != null)
              GestureDetector(
                onTap: onBag,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.monoBlack,
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
