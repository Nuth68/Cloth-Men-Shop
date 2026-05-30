import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static final List<OrderModel> _orders = [
    OrderModel(
      id: '1024',
      items: [
        CartItemModel(
          id: '1',
          product: ProductModel(
            id: 'p1', name: 'Structured Wool Blazer', description: 'Premium wool.', price: 485.00,
            imageUrl: '', categoryId: 'cat_1',
          ),
          selectedSize: 'M', selectedColor: 'Noir',
        ),
      ],
      total: 485.00,
      status: 'Delivered',
      address: '123 Main St, New York, NY 10001',
      createdAt: DateTime(2024, 10, 15),
    ),
    OrderModel(
      id: '1023',
      items: [
        CartItemModel(
          id: '2',
          product: ProductModel(
            id: 'p2', name: 'Merino Mock Neck', description: 'Fine merino.', price: 175.00,
            imageUrl: '', categoryId: 'cat_2',
          ),
          selectedSize: 'L', selectedColor: 'Ecru',
        ),
      ],
      total: 175.00,
      status: 'Shipped',
      address: '123 Main St, New York, NY 10001',
      createdAt: DateTime(2024, 10, 12),
    ),
    OrderModel(
      id: '1022',
      items: [
        CartItemModel(
          id: '3',
          product: ProductModel(
            id: 'p3', name: 'Pleated Trousers', description: 'Wool blend.', price: 298.00,
            imageUrl: '', categoryId: 'cat_3',
          ),
          selectedSize: '32', selectedColor: 'Charcoal',
        ),
      ],
      total: 298.00,
      status: 'Processing',
      address: '123 Main St, New York, NY 10001',
      createdAt: DateTime(2024, 10, 8),
    ),
  ];

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
        title: const Text(AppStrings.orders,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: _orders.isEmpty
          ? const EmptyStateWidget(message: 'No orders yet')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: _orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status.toLowerCase() == 'delivered';
    return GestureDetector(
      onTap: () => context.push('/order-detail', extra: order),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: order.items.isNotEmpty && order.items.first.product.imageUrl.isNotEmpty
                  ? Image.network(order.items.first.product.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.image, color: Colors.grey))
                  : const Icon(Icons.image, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text('\$${order.total.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDelivered ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDelivered ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
