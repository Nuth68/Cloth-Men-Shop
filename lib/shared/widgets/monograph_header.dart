import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

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
        child: Row(
          children: [
            GestureDetector(
              onTap: onSearch,
                size: 22,
              ),
            ),
            const Spacer(),
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
