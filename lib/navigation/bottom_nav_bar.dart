import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/haptics.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const NavItem({required this.label, required this.icon, required this.activeIcon});
}

/// A pill-shaped bottom navigation bar that floats on top of screen content.
///
/// Must be placed inside a [Stack] with [Positioned] at the bottom.
class FashionBottomNav extends StatelessWidget {
  final int selectedIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  const FashionBottomNav({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tabs = items.take(4).toList();

    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 24),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 66,
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: ShapeDecoration(
                shape: StadiumBorder(side: BorderSide(color: !isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.20)
                    : AppColors.white.withValues(alpha: 0.20),
                    width: 1.0
                    ),

                  ),
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.38)
                    : AppColors.white.withValues(alpha: 0.8),
                shadows: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.75)
                        : Colors.black.withValues(alpha: 0.74),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(tabs.length, (i) {
                  final sel = i == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        AppHaptics.light();
                        onTap(i);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.symmetric(
                          horizontal: sel ? 4 : 2,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? (isDark
                                      ? AppColors.white.withValues(alpha: 0.14)
                                      : AppColors.monoBlack
                                          .withValues(alpha: 0.08))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              sel ? tabs[i].activeIcon : tabs[i].icon,
                              size: 20,
                              color: sel
                                  ? (isDark
                                      ? AppColors.white
                                      : AppColors.monoBlack)
                                  : (isDark
                                      ? Colors.white38
                                      : AppColors.monoGrey),
                            ),
                            if (true) ...[
                              const SizedBox(height: 4),
                              AnimatedScale(
                                duration: const Duration(milliseconds: 240),
                                scale: 1.0,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    tabs[i].label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Helvetica Neue',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.monoBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
