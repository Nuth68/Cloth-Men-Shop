import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../widgets/size_selector.dart';
import '../widgets/color_selector.dart';
import '../widgets/fit_guide_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;

    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product not found')),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.black),
            onPressed: () {
              context.read<WishlistBloc>().add(AddToWishlist(p));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to wishlist'), duration: Duration(seconds: 1)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 380,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: p.imageUrl.isNotEmpty
                  ? Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox())
                  : const Center(child: Icon(Icons.image, size: 64, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text('NEW ARRIVAL',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
                    ),
                  if (p.isNew) const SizedBox(height: 12),
                  Text(p.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.2)),
                  const SizedBox(height: 8),
                  Text('\$${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(p.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
                  const SizedBox(height: 24),
                  const SizeSelector(),
                  const SizedBox(height: 20),
                  const ColorSelector(),
                  const SizedBox(height: 20),
                  const FitGuideWidget(),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<WishlistBloc>().add(AddToWishlist(p));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to wishlist'), duration: Duration(seconds: 1)),
                              );
                            },
                            icon: const Icon(Icons.favorite_outline, color: Colors.black),
                            label: const Text('WISHLIST',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.5)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                              context.read<CartBloc>().add(AddToCart(CartItemModel(
                                id: p.id,
                                product: p,
                                selectedSize: 'M',
                                selectedColor: p.colors.isNotEmpty ? p.colors.first : '',
                              )));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart'), duration: Duration(seconds: 1)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('ADD TO CART',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
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
