import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onRemove;

  const CartItemTile({super.key, required this.item, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            color: AppColors.lightGray,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${item.selectedSize} / ${item.selectedColor}', style: const TextStyle(fontSize: 12, color: AppColors.warmGray)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
