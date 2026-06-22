import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product_model.dart';
import 'home_typography.dart';

class BestsellersSection extends StatelessWidget {
  final List<ProductModel> products;

  const BestsellersSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bestsellers', style: monoSerif(22)),
          const SizedBox(height: 14),
          Row(
            children: List.generate(products.length > 2 ? 2 : products.length, (i) {
              final p = products[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 0 ? 8 : 0, left: i == 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => context.push('/product-detail', extra: p),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(p.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(color: const Color(0xFFE0DDD8))),
                        ),
                        const SizedBox(height: 8),
                        Text(p.name, style: monoSans(11, weight: FontWeight.w500), maxLines: 2),
                        const SizedBox(height: 2),
                        Text('\$${p.price.toStringAsFixed(0)}', style: monoSans(11, color: AppColors.monoGrey)),
                      ],
                    ),
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
