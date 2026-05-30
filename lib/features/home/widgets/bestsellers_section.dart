import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'home_typography.dart';
import 'home_constants.dart';

class BestsellersSection extends StatelessWidget {
  const BestsellersSection({super.key});

  static const _items = [
    ('Hand-Stitched Derbies', '\$695', shoesUrl),
    ('Haversac', '\$550', bagUrl),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bestsellers', style: monoSerif(22)),
          const SizedBox(height: 14),
          Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 0 ? 8 : 0, left: i == 1 ? 8 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(item.$3,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(color: const Color(0xFFE0DDD8))),
                      ),
                      const SizedBox(height: 8),
                      Text(item.$1, style: monoSans(11, weight: FontWeight.w500), maxLines: 2),
                      const SizedBox(height: 2),
                      Text(item.$2, style: monoSans(11, color: AppColors.monoGrey)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
