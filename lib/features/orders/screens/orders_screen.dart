import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/animated_list_item.dart';
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
        final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.monoBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Orders',
            style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: LoadingIndicator.shimmerList(count: 3),
            );
          }
          if (state is OrdersError) {
            return EmptyStateWidget(
              state: EmptyState.error,
              title: 'Couldn\'t load orders',
              message: state.message,
              actionLabel: 'Retry',
              onAction: () =>
                  context.read<OrdersBloc>().add(const LoadOrders()),
            );
          }
          if (state is OrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return EmptyStateWidget(
                state: EmptyState.empty,
                title: 'No orders yet',
                message: 'Your purchase history will appear here.',
                icon: Icons.receipt_long_outlined,
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrdersBloc>().add(const LoadOrders());
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) => AnimatedListItem(
                  index: i,
                  child: _OrderCard(order: orders[i]),
                ),
              ),
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
      onTap: () {
        AppHaptics.light();
        context.push('/order-detail', extra: order);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.monoDivider, width: 0.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 56,
                height: 56,
                child: order.items.isNotEmpty &&
                        order.items.first.product.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: order.items.first.product.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                            color: AppColors.monoLightGrey),
                      )
                    : Container(color: AppColors.monoLightGrey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order #${order.id}',
                      style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.monoBlack)),
                  const SizedBox(height: 4),
                  Text(
                      '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.monoGrey)),
                  const SizedBox(height: 4),
                  Text('\$${order.total.toStringAsFixed(0)}',
                      style: AppTypography.price.copyWith(fontSize: 15)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDelivered
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: isDelivered ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                color: AppColors.monoGrey, size: 20),
          ],
        ),
      ),
    );
  }
}
