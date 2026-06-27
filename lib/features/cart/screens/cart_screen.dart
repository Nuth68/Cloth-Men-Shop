import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CartView();
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
<<<<<<< Updated upstream
          icon: Icon(Icons.arrow_back, color: AppColors.monoBlack),
=======
          icon: const Icon(Icons.arrow_back, color: AppColors.monoBlack),
>>>>>>> Stashed changes
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cart',
          style: AppTypography.heading2.copyWith(
            color: AppColors.monoBlack,
          ),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return const EmptyStateWidget(
              state: EmptyState.empty,
              title: 'Your cart is empty',
              message: 'Add items to get started.',
              actionLabel: 'Shop Now',
              onAction: null,
              icon: Icons.shopping_bag_outlined,
            );
          }
          if (state is CartUpdated) {
            final items = state.items;
            if (items.isEmpty) {
              return EmptyStateWidget(
                state: EmptyState.empty,
                title: 'Your cart is empty',
                message: 'Add items to get started.',
                actionLabel: 'Shop Now',
                icon: Icons.shopping_bag_outlined,
                onAction: () => context.go('/shop'),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (_, i) => CartItemTile(
                      item: items[i],
                      onRemove: () => context
                          .read<CartBloc>()
                          .add(RemoveFromCart(items[i].id)),
                      onQuantityChanged: (qty) => context
                          .read<CartBloc>()
                          .add(UpdateQuantity(items[i].id, qty)),
                    ),
                  ),
                ),
                // Bottom checkout bar
                Container(
                  padding: const EdgeInsets.all(16),
<<<<<<< Updated upstream
                  decoration: BoxDecoration(
=======
                  decoration: const BoxDecoration(
>>>>>>> Stashed changes
                    color: AppColors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.monoDivider),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.monoBlack,
                              ),
                            ),
                            Text(
                              '\$${state.total.toStringAsFixed(2)}',
                              style: AppTypography.price.copyWith(
                                color: AppColors.monoBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              AppHaptics.heavy();
                              context.push('/checkout');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.monoBlack,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
<<<<<<< Updated upstream
                                    BorderRadius.circular(12),
=======
                                    BorderRadius.circular(2),
>>>>>>> Stashed changes
                              ),
                            ),
                            child: Text(
                              'CHECKOUT',
                              style: AppTypography.button.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
