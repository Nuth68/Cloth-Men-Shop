import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/haptics.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class FashionBottomNav extends StatefulWidget {
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
  State<FashionBottomNav> createState() => _FashionBottomNavState();
}

class _FashionBottomNavState extends State<FashionBottomNav> {
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final tabs = widget.items.take(4).toList();
    final barWidth = MediaQuery.of(context).size.width - 48;
    final tabWidth = barWidth / tabs.length;

    return Container(
      height: 48 + bottomPadding,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.monoBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Sliding pill background
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: widget.selectedIndex * tabWidth + 4,
              top: 4,
              bottom: 4,
              child: Container(
                width: tabWidth - 8,
                decoration: BoxDecoration(
                  color: AppColors.monoBlack,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Icons + labels
            Row(
              children: List.generate(tabs.length, (i) {
                final sel = i == widget.selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      AppHaptics.light();
                      widget.onTap(i);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          sel ? tabs[i].activeIcon : tabs[i].icon,
                          size: 18,
                          color: sel ? AppColors.white : AppColors.monoGrey,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          tabs[i].label,
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 8,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                            color: sel ? AppColors.white : AppColors.monoGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
