import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../data/models/order_model.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../core/constants/api_config.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
        final repo = OrderRepository(gql);
        return OrdersBloc(repo)..add(const LoadOrders());
      },
      child: const _OrdersListView(),
    );
  }
}

class _OrdersListView extends StatelessWidget {
  const _OrdersListView();

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
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrdersError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<OrdersBloc>().add(const LoadOrders()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is OrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const EmptyStateWidget(message: 'No orders yet');
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            );
          }
          return const SizedBox.shrink();
        },
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
