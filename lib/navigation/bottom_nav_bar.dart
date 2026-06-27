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

<<<<<<< Updated upstream
class _FashionBottomNavState extends State<FashionBottomNav> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final tabs = widget.items.take(4).toList();
    final barWidth = MediaQuery.of(context).size.width - 48;
    final tabWidth = barWidth / tabs.length;

    return Container(
      height: 48 + bottomPadding,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
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
                  color: isDark ? AppColors.brass : AppColors.monoBlack,
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
                          color: sel
                              ? (isDark
                                  ? AppColors.solidDark
                                  : AppColors.white)
                              : AppColors.monoGrey,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          tabs[i].label,
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 8,
                            fontWeight: sel
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: sel
                                ? (isDark
                                    ? AppColors.solidDark
                                    : AppColors.white)
                                : AppColors.monoGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
=======
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
>>>>>>> Stashed changes
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
