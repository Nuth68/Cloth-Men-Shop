import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/monograph_header.dart';
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
              child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return EmptyStateWidget(
              state: EmptyState.empty,
              title: l10n.translate('cartEmpty'),
              message: l10n.translate('cartEmptyMessage'),
              actionLabel: l10n.translate('shopNow'),
              onAction: null,
              icon: Icons.shopping_bag_outlined,
            );
          }
          if (state is CartUpdated) {
            final items = state.items;
            if (items.isEmpty) {
              return EmptyStateWidget(
                state: EmptyState.empty,
                title: l10n.translate('cartEmpty'),
                message: l10n.translate('cartEmptyMessage'),
                actionLabel: l10n.translate('shopNow'),
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
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
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
                              l10n.translate('total'),
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w500,
                               
                              ),
                            ),
                            Text(
                              '\$${state.total.toStringAsFixed(2)}',
                              style: AppTypography.price.copyWith(
                               
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
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              l10n.translate('checkout'),
                              style: AppTypography.button.copyWith(
                                color: AppColors.surface(context),
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
            ),
          ],
        ),
      ),
    );
  }
}
