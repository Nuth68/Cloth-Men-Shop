import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import 'home_constants.dart';

class PhilosophySection extends StatelessWidget {
  const PhilosophySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 260,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: doorwayUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => ShimmerLoading.banner(height: 260),
            errorWidget: (_, __, ___) =>
                Container(color: AppColors.monoBlack),
          ),
        ),
        Container(
          color: AppColors.monoOffWhite,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
<<<<<<< Updated upstream
                'THE Steav Fashion PHILOSOPHY',
=======
                'THE MONOGRAPH PHILOSOPHY',
>>>>>>> Stashed changes
                style: AppTypography.sans(
                  8.5,
                  color: AppColors.monoGrey,
                  weight: FontWeight.w500,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Beyond The\nHorizon of Trend',
                style: AppTypography.serif(28, height: 1.15),
              ),
              const SizedBox(height: 14),
              Text(
                'We believe in the permanence of craft. Each piece is a documented study in silhouette, material, and movement, designed to outlast the season and become a core chapter in your personal history.',
                style: AppTypography.sans(
                  13,
                  color: const Color(0xFF444444),
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.monoBlack),
                  ),
                  child: Text(
                    'READ OUR MANIFESTO',
                    style: AppTypography.sans(
                      10,
                      weight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
