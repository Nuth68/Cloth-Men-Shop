import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OutfitCard extends StatelessWidget {
  final int index;

  const OutfitCard({super.key, this.index = 0});

  static const List<String> images = [
    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=400',
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=400',
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400',
    'https://images.unsplash.com/photo-1525966222134-fcfa99b594ae?w=400',
    'https://images.unsplash.com/photo-1542296332-2e4473faf563?w=400',
    'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=400',
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400',
  ];

  static const List<String> titles = [
    'Summer Casual',
    'Evening Elegance',
    'Street Edge',
    'Cozy Layers',
    'Office Edit',
    'Weekend Blues',
    'Minimalist',
    'Date Night',
  ];

  static const List<String> descriptions = [
    'Linen shirt • Chinos • Loafers',
    'Silk dress • Heels • Clutch',
    'Denim jacket • Tee • Sneakers',
    'Cashmere • Boots • Beanie',
    'Blazer • Trousers • Oxfords',
    'Denim • Sweater • Trainers',
    'Turtleneck • Wool pants',
    'Cocktail dress • Stilettos',
  ];

  @override
  Widget build(BuildContext context) {
    final i = index % images.length;
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, _, _) => Container(color: AppColors.lightGray),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[i], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(descriptions[i],
                      style: const TextStyle(fontSize: 12, color: AppColors.warmGray)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
