import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import 'home_constants.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: heroUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => ShimmerLoading.banner(height: 460),
            errorWidget: (_, _, _) =>
                Container(color: Theme.of(context).colorScheme.onSurface),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xDD000000)],
                stops: [0.35, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Volume 04: The\nArchitecture of\nTailoring',
                  style: AppTypography.serif(
                    26,
                    weight: FontWeight.w700,
                    color: AppColors.surface(context),
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 18),
                _OutlineBtn(label: 'SHOP THE LOOK'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  const _OutlineBtn({required this.label});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.white),
          ),
          child: Text(
            label,
            style: AppTypography.sans(
              9,
              weight: FontWeight.w500,
              color: AppColors.surface(context),
              letterSpacing: 2.2,
            ),
          ),
        ),
      );
}
