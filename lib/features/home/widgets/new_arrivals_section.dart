import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_item.dart';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Arrivals',
                    style: AppTypography.serif(22),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'The Foundation Collection',
                    style: AppTypography.sans(
                      10,
                      color: AppColors.monoGrey,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.go('/shop'),
                child: Text(
                  'VIEW ALL',
                  style: AppTypography.sans(
                    10,
                    weight: FontWeight.w600,
                    letterSpacing: 1.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...List.generate(products.length, (i) {
            final p = products[i];
            return AnimatedListItem(
              index: i,
              child: _ProductCard(
                product: p,
                onTap: () => context.push('/product-detail', extra: p),
              ),
            );
          }),
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
            Hero(
              tag: 'product-${product.id}',
              child: AspectRatio(
                aspectRatio: 3 / 3.8,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      ShimmerLoading.productCard(height: 240),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.monoLightGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.sans(
                          13,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.colors.isNotEmpty
                            ? product.colors.first.toUpperCase()
                            : '',
                        style: AppTypography.sans(
                          9.5,
                          color: AppColors.monoGrey,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: AppTypography.sans(
                    13,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
