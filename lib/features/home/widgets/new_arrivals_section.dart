import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product_model.dart';
import 'home_typography.dart';

class NewArrivalsSection extends StatelessWidget {
  final List<ProductModel> products;

  const NewArrivalsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
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
                Text('The Foundation Collection', style: monoSans(10, color: AppColors.monoGrey, letterSpacing: 0.2)),
              ]),
              Text('VIEW ALL', style: monoSans(10, weight: FontWeight.w600, letterSpacing: 1.6)),
            ],
          ),
          const SizedBox(height: 18),
          ...products.map((p) => _ProductCard(
            product: p,
            onTap: () => context.push('/product-detail', extra: p),
          )),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  const _ProductCard({required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 3.8,
              child: Image.network(product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(color: const Color(0xFFE8E5E0))),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(product.name, style: monoSans(13, weight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(product.colors.isNotEmpty ? product.colors.first.toUpperCase() : '',
                      style: monoSans(9.5, color: AppColors.monoGrey, letterSpacing: 1)),
                ]),
                Text('\$${product.price.toStringAsFixed(0)}', style: monoSans(13, weight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
