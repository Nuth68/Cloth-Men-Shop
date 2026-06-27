import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;

  const CartItemTile({
    super.key,
    required this.item,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(item.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              AppHaptics.heavy();
              onRemove?.call();
            },
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            icon: Icons.delete_outline,
            label: 'REMOVE',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
<<<<<<< Updated upstream
          borderRadius: BorderRadius.circular(12),
=======
          borderRadius: BorderRadius.circular(4),
>>>>>>> Stashed changes
          border: Border.all(color: AppColors.monoDivider, width: 0.5),
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(3),
              ),
              child: SizedBox(
                width: 90,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: item.product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      ShimmerLoading.productCard(width: 90, height: 100),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.monoLightGrey,
                  ),
                ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.monoBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: AppTypography.price.copyWith(
                        color: AppColors.monoBlack,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.monoLightGrey.withValues(alpha: 0.5),
<<<<<<< Updated upstream
                        borderRadius: BorderRadius.circular(12),
=======
                        borderRadius: BorderRadius.circular(2),
>>>>>>> Stashed changes
                      ),
                      child: Text(
                        '${item.selectedSize} / ${item.selectedColor}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.monoGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Quantity stepper
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QtyButton(
                          icon: Icons.remove,
                          onTap: () {
                            AppHaptics.light();
                            if (item.quantity > 1) {
                              onQuantityChanged?.call(item.quantity - 1);
                            }
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${item.quantity}',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.add,
                          onTap: () {
                            AppHaptics.light();
                            onQuantityChanged
                                ?.call(item.quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.monoDivider),
<<<<<<< Updated upstream
          borderRadius: BorderRadius.circular(12),
=======
          borderRadius: BorderRadius.circular(2),
>>>>>>> Stashed changes
        ),
        child: Icon(icon, size: 14, color: AppColors.monoBlack),
      ),
    );
  }
}
