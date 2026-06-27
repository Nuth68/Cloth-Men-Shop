import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/order_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/monograph_header.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: order.status),
                    const SizedBox(height: 20),
                    _InfoRow(label: l10n.translate('orderId'), value: '#${order.id}'),
                    _InfoRow(label: l10n.translate('placedOn'), value: _formatDate(order.createdAt)),
                    _InfoRow(label: l10n.translate('shippingTo'), value: order.address),
                    const Divider(height: 32),
                    Text(l10n.translate('items').toUpperCase(), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 64, height: 64,
                                  child: CachedNetworkImage(
                                    imageUrl: item.product.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => ShimmerLoading.productCard(width: 64, height: 64),
                                    errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 2),
                                    Text('${item.selectedSize} / ${item.selectedColor} ×${item.quantity}',
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                                  ],
                                ),
                              ),
                              Text('\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.translate('total'), style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                        Text('\$${order.total.toStringAsFixed(2)}', style: AppTypography.price),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.monoDivider),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(l10n.translate('trackPackage').toUpperCase(), style: AppTypography.button.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                      ),
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

  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month-1]} ${dt.day}, ${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final done = status.toLowerCase() == 'delivered';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: done ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(done ? Icons.check_circle : Icons.local_shipping, size: 16, color: done ? AppColors.success : AppColors.warning),
          const SizedBox(width: 8),
          Text(l10n.translate(status.toLowerCase()), style: AppTypography.labelSmall.copyWith(color: done ? AppColors.success : AppColors.warning)),
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
          SizedBox(width: 100, child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey))),
          Expanded(child: Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
