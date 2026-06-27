import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'shimmer_loading.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  /// Full-screen centered spinner.
  const LoadingIndicator.spinner({super.key});

  /// Shimmer product grid.
  factory LoadingIndicator.shimmerProductGrid({int count = 6}) {
    return _ShimmerLoadingIndicator(
      child: ShimmerLoading.productGrid(count: count),
    );
  }

  /// Shimmer list tiles.
  factory LoadingIndicator.shimmerList({int count = 4}) {
    return _ShimmerLoadingIndicator(
      child: ShimmerLoading.listTile(count: count),
    );
  }

  /// Shimmer profile header.
  factory LoadingIndicator.shimmerProfile() {
    return _ShimmerLoadingIndicator(
      child: ShimmerLoading.profileHeader(),
    );
  }

  /// Shimmer banner.
  factory LoadingIndicator.shimmerBanner({double height = 460}) {
    return _ShimmerLoadingIndicator(
      child: ShimmerLoading.banner(height: height),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: AppColors.monoBlack),
    );
  }
}

class _ShimmerLoadingIndicator extends LoadingIndicator {
  final Widget child;

  const _ShimmerLoadingIndicator({required this.child});

  @override
  Widget build(BuildContext context) => child;
}
