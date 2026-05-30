import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'home_typography.dart';
import 'home_constants.dart';

class NewArrivalsSection extends StatelessWidget {
  const NewArrivalsSection({super.key});

  static const _products = [
    ('Raw Silk Tailored Blazer', 'CHARCOAL GREY', '\$850', blazerUrl),
    ('Wide-Leg Pleated Trousers', 'OBSIDIAN BLACK', '\$420', trousersUrl),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('New Arrivals', style: monoSerif(22)),
                const SizedBox(height: 3),
                Text('The Foundation Collection, AW24', style: monoSans(10, color: AppColors.monoGrey, letterSpacing: 0.2)),
              ]),
              Text('VIEW ALL', style: monoSans(10, weight: FontWeight.w600, letterSpacing: 1.6)),
            ],
          ),
          const SizedBox(height: 18),
          ..._products.map((p) => _ProductCard(name: p.$1, sub: p.$2, price: p.$3, url: p.$4)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name, sub, price, url;
  const _ProductCard({required this.name, required this.sub, required this.price, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 3.8,
            child: Image.network(url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: const Color(0xFFE8E5E0))),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: monoSans(13, weight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(sub, style: monoSans(9.5, color: AppColors.monoGrey, letterSpacing: 1)),
              ]),
              Text(price, style: monoSans(13, weight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
