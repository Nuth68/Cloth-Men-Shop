import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Wraps a list item in staggered fade + slide-up animation.
///
/// Usage:
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => AnimatedListItem(
///     index: index,
///     child: ProductCard(product: items[index]),
///   ),
/// )
/// ```
class AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final double slideOffset;

  const AnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.slideOffset = 30,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration,
      child: SlideAnimation(
        verticalOffset: slideOffset,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}

/// Wraps children in staggered animation — for columns, not just list builders.
class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final double slideOffset;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const AnimatedColumn({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 400),
    this.slideOffset = 20,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: AnimationConfiguration.toStaggeredList(
          duration: duration,
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: slideOffset,
            child: FadeInAnimation(child: widget),
          ),
          children: children,
        ),
      ),
    );
  }
}
