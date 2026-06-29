import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_item.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onBack: () => context.pop(),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
            ),
            Expanded(
              child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          final products = state is WishlistUpdated ? state.products : <ProductModel>[];
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite_outline, size: 56, color: AppColors.monoGrey),
                  const SizedBox(height: 16),
                  Text(l10n.translate('noFavorites'), style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => context.go('/shop'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: Text(l10n.translate('browseProducts'), style: AppTypography.button.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async { await Future.delayed(const Duration(milliseconds: 300)); },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Text('${products.length} ${l10n.translate('itemsSaved')}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey, letterSpacing: 0.3)),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AnimatedListItem(
                      index: index,
                      child: _FavCard(product: products[index]),
                    ),
                    childCount: products.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final ProductModel product;
  const _FavCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wishlistBloc = context.read<WishlistBloc>();
    final cartBloc = context.read<CartBloc>();

    return Slidable(
      key: Key('fav-${product.id}'),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              AppHaptics.medium();
              wishlistBloc.add(RemoveFromWishlist(product.id));
            },
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            icon: Icons.delete_outline,
            label: l10n.translate('remove'),
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
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 100, height: 130,
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl, fit: BoxFit.cover,
                          placeholder: (_, _) => ShimmerLoading.productCard(width: 100, height: 130),
                          errorWidget: (_, _, _) => Container(color: AppColors.monoLightGrey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: SizedBox(
                      height: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.brand, style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey, letterSpacing: 1.5)),
                          const SizedBox(height: 4),
                          Text(product.name, style: AppTypography.sans(14, weight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          if (product.colors.isNotEmpty)
                            Text(product.colors.first, style: AppTypography.sans(11, color: AppColors.monoGrey, letterSpacing: 0.8)),
                          const Spacer(),
                          Row(
                            children: [
                              Text('\$${product.price.toStringAsFixed(0)}', style: AppTypography.price.copyWith(fontSize: 16)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  AppHaptics.heavy();
                                  cartBloc.add(AddToCart(CartItemModel(
                                    id: product.id, product: product,
                                    selectedSize: product.sizes.isNotEmpty ? product.sizes.first : 'M',
                                    selectedColor: product.colors.isNotEmpty ? product.colors.first : '',
                                  )));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${product.name} ${l10n.translate('addedToCart')}'), duration: const Duration(seconds: 1)),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                   
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.monoDivider, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
