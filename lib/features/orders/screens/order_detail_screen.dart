import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/order_model.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _loading = false;

  Future<void> _cancelOrder(String reason) async {
    setState(() => _loading = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
      final res = await gql.mutate(
        r'''mutation cancelOrder($id: Int!, $reason: String!) {
          cancelOrder(id: $id, reason: $reason)
        }''',
        variables: {
          'id': int.tryParse(widget.order.id) ?? 0,
          'reason': reason,
        },
      );

      if (res.errors != null && res.errors!.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.errors!.first.message)),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _returnOrder(String reason) async {
    setState(() => _loading = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
      final res = await gql.mutate(
        r'''mutation returnOrder($id: Int!, $reason: String!) {
          returnOrder(id: $id, reason: $reason)
        }''',
        variables: {
          'id': int.tryParse(widget.order.id) ?? 0,
          'reason': reason,
        },
      );

      if (res.errors != null && res.errors!.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.errors!.first.message)),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Return request submitted successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showCancelDialog() {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Please provide a reason for cancellation...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () {
              final reason = reasonCtrl.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(ctx);
              _cancelOrder(reason);
            },
            child: const Text('Confirm',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReturnDialog() {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Return Order'),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Please provide a reason for return...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () {
              final reason = reasonCtrl.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(ctx);
              _returnOrder(reason);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final canCancel = order.status != 'cancelled' && order.status != 'returned';
    final canReturn = order.status == 'delivered';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Order #${order.id}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBadge(status: order.status),
                const SizedBox(height: 20),
                _InfoRow(label: 'Order ID', value: '#${order.id}'),
                _InfoRow(label: 'Placed on', value: _formatDate(order.createdAt)),
                _InfoRow(label: 'Shipping to', value: order.address),
                const Divider(height: 32),
                const Text('ITEMS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.grey)),
                const SizedBox(height: 12),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    style: const TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 2),
                                Text('${item.selectedSize} / ${item.selectedColor} x${item.quantity}',
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Text('\$${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 32),
                if (canReturn) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _showReturnDialog,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('RETURN ORDER',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (canCancel) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _showCancelDialog,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('CANCEL ORDER',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tracking not available yet')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('TRACK PACKAGE',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDelivered = status.toLowerCase() == 'delivered';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDelivered ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDelivered ? Icons.check_circle : Icons.local_shipping,
            size: 16,
            color: isDelivered ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDelivered ? Colors.green.shade700 : Colors.orange.shade700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
