import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../core/constants/api_config.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  List<CartItemModel> _items = [];
  double _total = 0;

  @override
  void initState() {
    super.initState();
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartUpdated) {
      _items = cartState.items;
      _total = cartState.total;
    }
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
        final repo = OrderRepository(gql);
        return CheckoutBloc(repo);
      },
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Checkout',
                style: AppTypography.heading2.copyWith(color: AppColors.monoBlack)),
          ),
          body: BlocListener<CheckoutBloc, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutSuccess) {
                context.read<CartBloc>().add(const ClearCart());
                context.go('/orders');
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORDER SUMMARY',
                      style: AppTypography.labelSmall.copyWith(
                          letterSpacing: 1.5, color: AppColors.monoGrey)),
                  const SizedBox(height: 16),
                  ..._items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _OrderItem(item: item),
                      )),
                  const Divider(height: 24),
                  _PriceRow(label: 'Subtotal', amount: '\$${_total.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  const _PriceRow(label: 'Shipping', amount: 'FREE', isGreen: true),
                  const Divider(height: 24),
                  _PriceRow(
                      label: 'Total',
                      amount: '\$${_total.toStringAsFixed(2)}',
                      isBold: true),
                  const SizedBox(height: 32),
                  Text('SHIPPING ADDRESS',
                      style: AppTypography.labelSmall.copyWith(
                          letterSpacing: 1.5, color: AppColors.monoGrey)),
                  const SizedBox(height: 12),
                  CustomTextField(
                      label: '', hint: 'Street Address', controller: _addressCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: CustomTextField(label: '', hint: 'City', controller: _cityCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: CustomTextField(label: '', hint: 'ZIP Code', controller: _zipCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton.outline(
                      label: 'ADD PAYMENT METHOD',
                      onPressed: () {
                        AppHaptics.light();
                        context.push('/payment');
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      final loading = state is CheckoutLoading;
                      return CustomButton(
                        label: loading
                            ? 'PLACING ORDER...'
                            : 'PLACE ORDER - \$${_total.toStringAsFixed(2)}',
                        onPressed: loading
                            ? null
                            : () {
                                final address = [
                                  _addressCtrl.text,
                                  _cityCtrl.text,
                                  _zipCtrl.text
                                ].where((s) => s.trim().isNotEmpty).join(', ');
                                if (address.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please enter your shipping address')),
                                  );
                                  return;
                                }
                                AppHaptics.heavy();
                                context.read<CheckoutBloc>().add(PlaceOrderEvent(
                                      items: _items
                                          .map((item) => {
                                                'productId':
                                                    int.parse(item.product.id),
                                                'selectedSize':
                                                    item.selectedSize,
                                                'selectedColor':
                                                    item.selectedColor,
                                                'quantity': item.quantity,
                                              })
                                          .toList(),
                                      total: _total,
                                      address: address,
                                    ));
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label, amount;
  final bool isGreen, isBold;
  const _PriceRow({
    required this.label,
    required this.amount,
    this.isGreen = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: (isBold
                    ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)
                    : AppTypography.bodyLarge)
                .copyWith(color: isGreen ? AppColors.success : AppColors.monoGrey)),
        Text(amount,
            style: (isBold ? AppTypography.price : AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600))),
      ],
    );
  }
}

class _OrderItem extends StatelessWidget {
  final CartItemModel item;
  const _OrderItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => ShimmerLoading.productCard(width: 60, height: 60),
              errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name,
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text('${item.selectedSize} / ${item.selectedColor} ×${item.quantity}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
            ],
          ),
        ),
        Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
