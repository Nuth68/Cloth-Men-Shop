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

class _FashionBottomNavState extends State<FashionBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _indicatorController;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final availableItems = widget.items.take(4).toList();

    return Container(
      height: 72 + bottomPadding,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.monoDivider, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Row(
              children: List.generate(availableItems.length, (index) {
                final sel = index == widget.selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      AppHaptics.light();
                      widget.onTap(index);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated indicator bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.only(bottom: 6),
                          height: 2,
                          width: sel ? 32.0 : 0,
                          color:
                              sel ? AppColors.monoBlack : Colors.transparent,
                        ),
                        // Icon with cross-fade
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              sel
                                  ? (availableItems[index].activeIcon)
                                  : availableItems[index].icon,
                              key: ValueKey('${index}_$sel'),
                              size: 20,
                              color: sel
                                  ? AppColors.monoBlack
                                  : AppColors.monoGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Label
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                sel ? FontWeight.w600 : FontWeight.w400,
                            letterSpacing: 0.5,
                            color: sel
                                ? AppColors.monoBlack
                                : AppColors.monoGrey,
                          ),
                          child: Text(availableItems[index].label),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
