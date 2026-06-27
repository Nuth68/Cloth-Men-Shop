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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  if (p.isNew) ...[
                    AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
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
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
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
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.monoBlack,
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
