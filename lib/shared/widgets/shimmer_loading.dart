import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

/// Reusable shimmer/skeleton loading placeholders.
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  // ── Named constructors for common patterns ──

  /// Single product card shimmer (matches ProductCard dimensions).
  factory ShimmerLoading.productCard({double? width, double? height}) {
    return ShimmerLoading(
      child: _ShimmerBox(
        width: width ?? double.infinity,
        height: height ?? 220,
        borderRadius: 4,
      ),
    );
  }

  /// Grid of product card shimmers.
  factory ShimmerLoading.productGrid({int count = 6, int crossAxisCount = 2}) {
    return ShimmerLoading(
      child: Column(
        children: List.generate(
          (count / crossAxisCount).ceil(),
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: List.generate(crossAxisCount, (col) {
                final index = row * crossAxisCount + col;
                if (index >= count) return const Spacer();
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: col == 0 ? 0 : 8,
                      right: col == crossAxisCount - 1 ? 0 : 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _ShimmerBox(height: 200, borderRadius: 4),
                        const SizedBox(height: 10),
                        const _ShimmerBox(height: 12, width: 0.7),
                        const SizedBox(height: 6),
                        const _ShimmerBox(height: 14, width: 0.4),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  /// List tile shimmer (matches cart item / order card).
  factory ShimmerLoading.listTile({int count = 4}) {
    return ShimmerLoading(
      child: Column(
        children: List.generate(
          count,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const _ShimmerBox(width: 80, height: 100, borderRadius: 4),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _ShimmerBox(height: 14, width: 0.8),
                      SizedBox(height: 8),
                      _ShimmerBox(height: 12, width: 0.5),
                      SizedBox(height: 8),
                      _ShimmerBox(height: 16, width: 0.3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile header shimmer.
  factory ShimmerLoading.profileHeader() {
    return ShimmerLoading(
      child: Column(
        children: const [
          _ShimmerBox(width: 72, height: 72, borderRadius: 36),
          SizedBox(height: 12),
          _ShimmerBox(width: 160, height: 18),
          SizedBox(height: 8),
          _ShimmerBox(width: 120, height: 14),
        ],
      ),
    );
  }

  /// Full-width banner shimmer.
  factory ShimmerLoading.banner({double height = 460}) {
    return ShimmerLoading(
      child: _ShimmerBox(width: double.infinity, height: height, borderRadius: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.monoLightGrey,
      highlightColor: AppColors.monoOffWhite,
      child: child,
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    this.width,
    this.height = 16,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.monoLightGrey,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
