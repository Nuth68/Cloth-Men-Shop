import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';



class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc()
        ..add(const AddToCart(CartItemModel(
          id: '1',
          product: ProductModel(
            id: 'p1',
            name: 'Structured Wool Blazer',
            description: 'Premium wool blend with modern tailoring.',
            price: 485.00,
            imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=700&q=85',
            categoryId: 'cat_1',
          ),
          selectedSize: 'M',
          selectedColor: 'Noir',
        )))
        ..add(const AddToCart(CartItemModel(
          id: '2',
          product: ProductModel(
            id: 'p2',
            name: 'Merino Mock Neck',
            description: 'Fine merino wool for effortless layering.',
            price: 175.00,
            imageUrl: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=700&q=85',
            categoryId: 'cat_2',
          ),
          selectedSize: 'L',
          selectedColor: 'Ecru',
        ))),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppStrings.cart,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: const [],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return const EmptyStateWidget(message: AppStrings.emptyCart);
          }
          if (state is CartUpdated) {
            final items = state.items;
            if (items.isEmpty) {
              return const EmptyStateWidget(message: AppStrings.emptyCart);
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (_, i) => CartItemTile(
                      item: items[i],
                      onRemove: () => context.read<CartBloc>().add(RemoveFromCart(items[i].id)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(AppStrings.total,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('\$${state.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/checkout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(AppStrings.checkout,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
