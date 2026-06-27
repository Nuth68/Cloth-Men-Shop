import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_item.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          final products =
              state is WishlistUpdated ? state.products : <ProductModel>[];
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorites',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.monoBlack,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${products.length} items saved',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.monoGrey,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                            color: AppColors.monoDivider, height: 1),
                      ],
                    ),
                  ),
                ),
                if (products.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        child: Text(
                          'No favorites yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= products.length) return null;
                      return AnimatedListItem(
                        index: index,
                        child: _FavCard(
                          product: products[index],
                          onRemove: () {
                            AppHaptics.medium();
                            context.read<WishlistBloc>().add(
                                RemoveFromWishlist(products[index].id));
                          },
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: 40)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  const _FavCard({required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('fav-${product.id}'),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            icon: Icons.delete_outline,
            label: 'REMOVE',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          AppHaptics.light();
          context.push('/product-detail', extra: product);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Hero(
                tag: 'product-${product.id}',
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
<<<<<<< Updated upstream
                    borderRadius: BorderRadius.circular(12),
=======
                    borderRadius: BorderRadius.circular(2),
>>>>>>> Stashed changes
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          ShimmerLoading.productCard(),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.monoLightGrey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product.colors.isNotEmpty
                              ? product.colors.first
                              : '',
                          style: AppTypography.sans(
                            10,
                            color: AppColors.monoGrey,
                            letterSpacing: 0.8,
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
              const SizedBox(height: 20),
              const Divider(
                  color: AppColors.monoDivider, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
