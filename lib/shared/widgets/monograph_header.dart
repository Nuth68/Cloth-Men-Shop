import 'package:flutter/material.dart';

const _black = Color(0xFF111111);

class MonographHeader extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onBag;
  final List<Widget>? actions;

  const MonographHeader({
    super.key,
    this.onSearch,
    this.onBag,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSearch,
            child: const Icon(Icons.search, color: _black, size: 22),
          ),
          const Spacer(),
          const Text(
            'MONOGRAPH',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: _black,
            ),
          ),
          const Spacer(),
          if (actions != null) ...actions!,
          if (onBag != null)
            GestureDetector(
              onTap: onBag,
              child: const Icon(Icons.shopping_bag_outlined, color: _black, size: 22),
            ),
        ],
      ),
    );
  }
}
