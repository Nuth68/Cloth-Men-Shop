import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

TextStyle _serif(double sz,
    {FontWeight w = FontWeight.w400, Color c = AppColors.monoBlack, double h = 1.2, double ls = 0}) {
  return TextStyle(fontFamily: 'Georgia', fontSize: sz, fontWeight: w, color: c, height: h, letterSpacing: ls);
}

TextStyle _sans(double sz,
    {FontWeight w = FontWeight.w400, Color c = AppColors.monoBlack, double ls = 0.5}) {
  return TextStyle(fontFamily: 'Helvetica Neue', fontSize: sz, fontWeight: w, color: c, letterSpacing: ls);
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          final products = state is WishlistUpdated ? state.products : <ProductModel>[];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Favorites', style: _serif(28, w: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${products.length} items saved', style: _sans(10, c: AppColors.monoGrey, ls: 0.3)),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.monoDivider, height: 1),
                    ],
                  ),
                ),
              ),
              if (products.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(child: Text('No favorites yet', style: TextStyle(color: Colors.grey))),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= products.length) return null;
                    return _FavCard(
                      product: products[index],
                      onRemove: () => context.read<WishlistBloc>().add(RemoveFromWishlist(products[index].id)),
                    );
                  },
                  childCount: products.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GestureDetector(
        onTap: () => context.push('/product-detail', extra: product),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(product.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: AppColors.monoOffWhite)),
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
                          Text(product.name, style: _sans(13, w: FontWeight.w500, ls: 0.3)),
                          const SizedBox(height: 3),
                          Text(product.colors.isNotEmpty ? product.colors.first : '', style: _sans(10, c: AppColors.monoGrey, ls: 0.8)),
                        ],
                      ),
                    ),
                    Text('\$${product.price.toStringAsFixed(0)}', style: _sans(13, w: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.monoDivider, height: 1),
              ],
            ),
            Positioned(
              top: 32,
              right: 10,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: AppColors.monoBlack, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

