import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_item.dart';

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
          Text('Bestsellers', style: AppTypography.serif(22)),
          const SizedBox(height: 14),
          Row(
            children: List.generate(
              products.length > 2 ? 2 : products.length,
              (i) {
                final p = products[i];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i == 0 ? 8 : 0,
                      left: i == 1 ? 8 : 0,
                    ),
                    child: AnimatedListItem(
                      index: i,
                      child: GestureDetector(
                        onTap: () =>
                            context.push('/product-detail', extra: p),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'product-${p.id}',
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: CachedNetworkImage(
                                  imageUrl: p.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) =>
                                      ShimmerLoading.productCard(height: 180),
                                  errorWidget: (_, __, ___) => Container(
                                    color: AppColors.monoLightGrey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.name,
                              style: AppTypography.sans(
                                11,
                                weight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${p.price.toStringAsFixed(0)}',
                              style: AppTypography.sans(
                                11,
                                color: AppColors.monoGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
