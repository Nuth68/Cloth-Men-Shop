import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final Widget icon;
  const NavItem({required this.label, required this.icon});
}

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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFECEAE5),
        border: Border(top: BorderSide(color: Color(0xFFDDDAD5))),
      ),
      child: SafeArea(
        bottom:false,
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (index) {
              final sel = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2,
                        width: sel ? 34.0 : 0,
                        color: const Color(0xFF0D0D0D),
                      ),
                      const SizedBox(height: 10),
                      IconTheme(
                        data: IconThemeData(
                          size: 20,
                          color: sel ? const Color(0xFF0D0D0D) : const Color(0xFF888888),
                        ),
                        child: items[index].icon,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          fontSize: 10,
                          color: sel ? const Color(0xFF0D0D0D) : const Color(0xFF888888),
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
