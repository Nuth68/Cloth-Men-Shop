import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';

class CategoryBar extends StatefulWidget {
  const CategoryBar({super.key});

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  int _sel = 0;

  static const _cats = [
    ('OUTERWEAR', Icons.layers_outlined),
    ('SHIRTS', Icons.dry_cleaning_outlined),
    ('PANTS', Icons.straighten_outlined),
    ('SHOES', Icons.directions_walk_outlined),
    ('BAGS', Icons.work_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface(context),
      child: Column(
        children: [
          const Divider(height: 1, color: AppColors.monoDivider),
          SizedBox(
            height: 76,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: _cats.length,
              itemBuilder: (_, i) {
                final sel = i == _sel;
                return GestureDetector(
                  onTap: () {
                    AppHaptics.selection();
                    setState(() => _sel = i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 82,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _cats[i].$2,
                          size: 22,
                          color: sel
                              ? AppColors.monoBlack
                              : AppColors.monoGrey,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _cats[i].$1,
                          style: AppTypography.sans(
                            8.5,
                            weight: sel ? FontWeight.w600 : FontWeight.w400,
                            color: sel
                                ? AppColors.monoBlack
                                : AppColors.monoGrey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.monoDivider),
        ],
      ),
    );
  }
}
