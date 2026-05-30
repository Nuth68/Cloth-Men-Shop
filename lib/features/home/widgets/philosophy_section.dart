import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'home_typography.dart';
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
          child: Image.network(doorwayUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: const Color(0xFF111111))),
        ),
        Container(
          color: AppColors.monoOffWhite,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('THE MONOGRAPH PHILOSOPHY',
                  style: monoSans(8.5, color: AppColors.monoGrey, weight: FontWeight.w500, letterSpacing: 1.8)),
              const SizedBox(height: 14),
              Text('Beyond The\nHorizon of Trend', style: monoSerif(28, height: 1.15)),
              const SizedBox(height: 14),
              Text(
                'We believe in the permanence of craft. Each piece is a documented study in silhouette, material, and movement, designed to outlast the season and become a core chapter in your personal history.',
                style: monoSans(13, color: const Color(0xFF444444), letterSpacing: 0.1),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.monoBlack)),
                  child: Text('READ OUR MANIFESTO',
                      style: monoSans(10, weight: FontWeight.w600, letterSpacing: 2.0)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
