import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import 'steav_fashion_logo.dart';

class MonographHeader extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onBag;
  final VoidCallback? onNotification;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool elevated;

  const MonographHeader({
    super.key,
    this.onSearch,
    this.onBag,
    this.onNotification,
    this.onBack,
    this.actions,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor = AppColors.surface(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: headerColor,
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
          padding: EdgeInsets.fromLTRB(20, statusBarHeight + 10, 20, 10),
        child: Row(
          children: [
            if (onBack != null)
              GestureDetector(
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 22,
                ),
              )
            else if (onSearch != null)
              GestureDetector(
                onTap: onSearch,
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 22,
                ),
              ),
            const Spacer(),
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
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 22,
                  ),
                ),
              ),
            if (onBag != null)
              GestureDetector(
                onTap: onBag,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 22,
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
