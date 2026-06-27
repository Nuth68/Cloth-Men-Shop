import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/order_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

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
        title: Text('Order #${order.id}',
            style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusBadge(status: order.status),
            const SizedBox(height: 20),
            _InfoRow(
                label: 'Order ID', value: '#${order.id}'),
            _InfoRow(
                label: 'Placed on',
                value: _formatDate(order.createdAt)),
            _InfoRow(
                label: 'Shipping to',
                value: order.address),
            const Divider(height: 32),
<<<<<<< Updated upstream
            Text('ITEMS', style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
=======
            Text('ITEMS',
                style: AppTypography.labelSmall.copyWith(
                    letterSpacing: 1.5,
                    color: AppColors.monoGrey)),
>>>>>>> Stashed changes
            const SizedBox(height: 12),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      ClipRRect(
<<<<<<< Updated upstream
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 64, height: 64,
                          child: CachedNetworkImage(
                            imageUrl: item.product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => ShimmerLoading.productCard(width: 64, height: 64),
                            errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
=======
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: CachedNetworkImage(
                            imageUrl: item.product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                ShimmerLoading.productCard(
                                    width: 64, height: 64),
                            errorWidget: (_, __, ___) => Container(
                                color: AppColors.monoLightGrey),
>>>>>>> Stashed changes
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
<<<<<<< Updated upstream
                            Text(item.product.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text('${item.selectedSize} / ${item.selectedColor} ×${item.quantity}',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                          ],
                        ),
                      ),
                      Text('\$${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
=======
                            Text(item.product.name,
                                style: AppTypography.bodyMedium
                                    .copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text(
                                '${item.selectedSize} / ${item.selectedColor} ×${item.quantity}',
                                style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.monoGrey)),
                          ],
                        ),
                      ),
                      Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600)),
>>>>>>> Stashed changes
                    ],
                  ),
                )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
<<<<<<< Updated upstream
                Text('Total', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                Text('\$${order.total.toStringAsFixed(2)}', style: AppTypography.price),
=======
                Text('Total',
                    style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600)),
                Text('\$${order.total.toStringAsFixed(2)}',
                    style: AppTypography.price),
>>>>>>> Stashed changes
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
<<<<<<< Updated upstream
                  side: const BorderSide(color: AppColors.monoDivider),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('TRACK PACKAGE', style: AppTypography.button.copyWith(color: AppColors.monoBlack)),
=======
                  side: const BorderSide(
                      color: AppColors.monoDivider),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(2)),
                ),
                child: Text('TRACK PACKAGE',
                    style: AppTypography.button.copyWith(
                        color: AppColors.monoBlack)),
>>>>>>> Stashed changes
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
<<<<<<< Updated upstream
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month-1]} ${dt.day}, ${dt.year}';
=======
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
>>>>>>> Stashed changes
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final done = status.toLowerCase() == 'delivered';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
<<<<<<< Updated upstream
        color: done ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
=======
        color: isDelivered
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
>>>>>>> Stashed changes
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
<<<<<<< Updated upstream
          Icon(done ? Icons.check_circle : Icons.local_shipping, size: 16, color: done ? AppColors.success : AppColors.warning),
          const SizedBox(width: 8),
          Text(status.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: done ? AppColors.success : AppColors.warning)),
=======
          Icon(
            isDelivered ? Icons.check_circle : Icons.local_shipping,
            size: 16,
            color: isDelivered ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: isDelivered ? AppColors.success : AppColors.warning,
            ),
          ),
>>>>>>> Stashed changes
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< Updated upstream
          SizedBox(width: 100, child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey))),
          Expanded(child: Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500))),
=======
          SizedBox(
            width: 100,
            child: Text(label,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.monoGrey)),
          ),
          Expanded(
            child: Text(value,
                style: AppTypography.bodyMedium
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
>>>>>>> Stashed changes
        ],
      ),
    );
  }
}
