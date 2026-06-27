import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../shared/widgets/product_image_viewer.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../widgets/size_selector.dart';
import '../widgets/color_selector.dart';
import '../widgets/fit_guide_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late SizeSelectorController _sizeController;
  late ColorSelectorController _colorController;
  late FitGuideController _fitController;

  @override
  void initState() {
    super.initState();
    _sizeController = SizeSelectorController();
    _colorController = ColorSelectorController();
    _fitController = FitGuideController();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _colorController.dispose();
    _fitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product not found')),
        body: const EmptyStateWidget(
          state: EmptyState.error,
          title: 'Not Found',
          message: 'This product could not be loaded.',
        ),
      );
    }

    final wishlistBloc = context.read<WishlistBloc>();
    final cartBloc = context.read<CartBloc>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
<<<<<<< Updated upstream
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
=======
          icon: const Icon(Icons.arrow_back, color: AppColors.monoBlack),
>>>>>>> Stashed changes
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
<<<<<<< Updated upstream
            icon: Icon(Icons.favorite_outline, color: AppColors.textPrimary),
=======
            icon: const Icon(Icons.favorite_outline,
                color: AppColors.monoBlack),
>>>>>>> Stashed changes
            onPressed: () {
              AppHaptics.medium();
              wishlistBloc.add(AddToWishlist(p));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${p.name} added to wishlist'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
<<<<<<< Updated upstream
            icon: Icon(Icons.share_outlined, color: AppColors.textPrimary),
=======
            icon: const Icon(Icons.share_outlined,
                color: AppColors.monoBlack),
>>>>>>> Stashed changes
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< Updated upstream
=======
            // Image gallery
>>>>>>> Stashed changes
            Hero(
              tag: 'product-${p.id}',
              child: ProductImageViewer(
                imageUrl: p.imageUrl,
                height: 380,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< Updated upstream
=======
                  // New arrival badge
>>>>>>> Stashed changes
                  if (p.isNew) ...[
                    AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 400),
                      child: Container(
<<<<<<< Updated upstream
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.brass,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'NEW ARRIVAL',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.solidDark),
=======
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.monoBlack,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          'NEW ARRIVAL',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.white,
                          ),
>>>>>>> Stashed changes
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
<<<<<<< Updated upstream
                  Text(
                    p.name,
                    style: AppTypography.heading1.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: AppTypography.price.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    p.description,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizeSelector(controller: _sizeController),
                  const SizedBox(height: 20),
                  ColorSelector(controller: _colorController),
                  const SizedBox(height: 20),
=======
                  // Product name
                  Text(
                    p.name,
                    style: AppTypography.heading1.copyWith(
                      color: AppColors.monoBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: AppTypography.price.copyWith(
                      color: AppColors.monoBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    p.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.monoGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Size selector
                  SizeSelector(controller: _sizeController),
                  const SizedBox(height: 20),
                  // Color selector
                  ColorSelector(controller: _colorController),
                  const SizedBox(height: 20),
                  // Fit guide
>>>>>>> Stashed changes
                  FitGuideWidget(controller: _fitController),
                  const SizedBox(height: 32),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              AppHaptics.medium();
                              wishlistBloc.add(AddToWishlist(p));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
<<<<<<< Updated upstream
                                  content: Text('${p.name} added to wishlist'),
=======
                                  content:
                                      Text('${p.name} added to wishlist'),
>>>>>>> Stashed changes
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
<<<<<<< Updated upstream
                            icon: Icon(Icons.favorite_outline, size: 16, color: AppColors.textPrimary),
                            label: Text(
                              'WISHLIST',
                              style: AppTypography.button.copyWith(color: AppColors.textPrimary),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.monoDivider),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
=======
                            icon: const Icon(Icons.favorite_outline,
                                size: 16),
                            label: Text(
                              'WISHLIST',
                              style: AppTypography.button.copyWith(
                                color: AppColors.monoBlack,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: AppColors.monoDivider),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
>>>>>>> Stashed changes
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              AppHaptics.heavy();
                              cartBloc.add(AddToCart(CartItemModel(
                                id: p.id,
                                product: p,
<<<<<<< Updated upstream
                                selectedSize: _sizeController.selectedSize,
                                selectedColor: _colorController.selectedColor ??
                                    (p.colors.isNotEmpty ? p.colors.first : ''),
                              )));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${p.name} added to cart'),
=======
                                selectedSize:
                                    _sizeController.selectedSize,
                                selectedColor:
                                    _colorController.selectedColor ??
                                        (p.colors.isNotEmpty
                                            ? p.colors.first
                                            : ''),
                              )));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${p.name} added to cart'),
>>>>>>> Stashed changes
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.monoBlack,
<<<<<<< Updated upstream
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'ADD TO CART',
                              style: AppTypography.button.copyWith(color: AppColors.white),
=======
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                            child: Text(
                              'ADD TO CART',
                              style: AppTypography.button.copyWith(
                                color: AppColors.white,
                              ),
>>>>>>> Stashed changes
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
