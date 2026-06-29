import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _promoCtrl = TextEditingController();
  List<CartItemModel> _items = [];
  double _total = 0;
  double _discount = 0;
  String? _selectedPayment;
  bool _placingOrder = false;
  bool _showItems = false;

  static const _paymentMethods = [
    ('credit', 'Credit Card', Icons.credit_card),
    ('paypal', 'PayPal', Icons.account_balance_wallet),
    ('apple', 'Apple Pay', Icons.phone_iphone),
  ];

  @override
  void initState() {
    super.initState();
    final s = context.read<CartBloc>().state;
    if (s is CartUpdated) { _items = s.items; _total = s.total; }
  }
  @override
  void dispose() { _nameCtrl.dispose(); _streetCtrl.dispose(); _cityCtrl.dispose(); _phoneCtrl.dispose(); _promoCtrl.dispose(); super.dispose(); }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code == 'SUMMER50') { setState(() => _discount = _total * 0.5); _promoCtrl.clear(); }
    else if (code == 'NEW15') { setState(() => _discount = _total * 0.15); _promoCtrl.clear(); }
    else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid promo code'))); return; }
    AppHaptics.medium();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Promo code applied!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
  }

  void _placeOrder() {
    if (_nameCtrl.text.trim().isEmpty || _streetCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate('pleaseEnterAddress'))));
      return;
    }
    if (_selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a payment method')));
      return;
    }
    AppHaptics.heavy();
    setState(() => _placingOrder = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.read<CartBloc>().add(const ClearCart());
      context.go('/orders');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tx = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final finalTotal = (_total - _discount).clamp(0.0, _total);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.monoOffWhite,
      body: SafeArea(top: false, child: Column(children: [
        MonographHeader(onBack: () => context.pop(), onBag: () => context.push('/cart'), onNotification: () => context.push('/notifications'), elevated: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ── Order Items card ──
              _card(tx, isDark, child: Column(children: [
                Row(children: [
                  Text('${_items.length} ${l10n.translate('items')}', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: tx)),
                  const Spacer(),
                  GestureDetector(onTap: () => setState(() => _showItems = !_showItems), child: Text(_showItems ? 'Hide' : 'Show', style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey))),
                ]),
                if (_showItems) ...[
                  const Divider(height: 20),
                  ..._items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _orderItem(item, tx))),
                  const Divider(height: 16),
                ],
                _row(l10n.translate('subtotal'), '\$${_total.toStringAsFixed(2)}', tx),
                const SizedBox(height: 4),
                _row(l10n.translate('shipping'), l10n.translate('free'), tx, green: true),
                if (_discount > 0) ...[
                  const SizedBox(height: 4),
                  _row('Discount', '-\$${_discount.toStringAsFixed(2)}', tx, green: true),
                ],
                const SizedBox(height: 6),
                _row(l10n.translate('total'), '\$${finalTotal.toStringAsFixed(2)}', tx, bold: true),
              ])),

              const SizedBox(height: 12),

              // ── Promo Code ──
              _card(tx, isDark, child: Row(children: [
                Expanded(child: TextField(controller: _promoCtrl, style: AppTypography.bodyMedium.copyWith(color: tx), decoration: InputDecoration(hintText: 'Promo code', hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey), border: InputBorder.none, contentPadding: EdgeInsets.zero))),
                SizedBox(height: 36, child: ElevatedButton(onPressed: _applyPromo, style: ElevatedButton.styleFrom(backgroundColor: AppColors.monoBlack, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 16)), child: Text('Apply', style: AppTypography.button.copyWith(color: AppColors.white, fontSize: 12)))),
              ])),

              const SizedBox(height: 12),

              // ── Shipping Address ──
              _card(tx, isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionTitle('Shipping Address'),
                const SizedBox(height: 14),
                _field(l10n.translate('fullName'), _nameCtrl, l10n.translate('fullNameHint'), tx),
                const SizedBox(height: 12),
                _field('Phone', _phoneCtrl, l10n.translate('phoneHint'), tx, keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _field(l10n.translate('streetAddress'), _streetCtrl, l10n.translate('addressHint'), tx, maxLines: 2),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _field(l10n.translate('city'), _cityCtrl, '', tx)),
                  const SizedBox(width: 12),
                  SizedBox(width: 100, child: _field('ZIP', TextEditingController(), '', tx, keyboardType: TextInputType.number)),
                ]),
              ])),

              const SizedBox(height: 12),

              // ── Payment Method ──
              _card(tx, isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionTitle(l10n.translate('paymentMethods')),
                const SizedBox(height: 12),
                ..._paymentMethods.map((pm) {
                  final sel = _selectedPayment == pm.$1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPayment = pm.$1),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.monoBlack.withValues(alpha: 0.04) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sel ? AppColors.monoBlack : AppColors.monoDivider, width: sel ? 1.5 : 0.5),
                      ),
                      child: Row(children: [
                        Container(width: 42, height: 42, decoration: BoxDecoration(color: isDark ? AppColors.darkCard : AppColors.monoOffWhite, borderRadius: BorderRadius.circular(10)), child: Icon(pm.$3, size: 20, color: sel ? AppColors.monoBlack : AppColors.monoGrey)),
                        const SizedBox(width: 12),
                        Expanded(child: Text(pm.$2, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: tx))),
                        Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? AppColors.monoBlack : AppColors.monoDivider, width: sel ? 6 : 1.5))),
                      ]),
                    ),
                  );
                }),
              ])),

              const SizedBox(height: 24),

              // ── Place Order ──
              SizedBox(height: 52, width: double.infinity, child: ElevatedButton(
                onPressed: _placingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.monoBlack, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: _placingOrder
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                    : Text('${l10n.translate('placeOrder')} — \$${finalTotal.toStringAsFixed(2)}', style: AppTypography.button.copyWith(color: AppColors.white, fontSize: 15)),
              )),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ])),
    );
  }

  // ── Helpers ──
  Widget _card(Color tx, bool dark, {required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.monoDivider, width: 0.5)),
    child: child,
  );

  Widget _sectionTitle(String t) => Row(children: [
    Container(width: 3, height: 16, decoration: BoxDecoration(color: AppColors.monoBlack, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(t, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
  ]);

  Widget _field(String label, TextEditingController ctrl, String hint, Color tx, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey)),
      const SizedBox(height: 4),
      TextField(controller: ctrl, keyboardType: keyboardType, maxLines: maxLines, style: AppTypography.bodyMedium.copyWith(color: tx), decoration: InputDecoration(hintText: hint, hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey), filled: true, fillColor: AppColors.monoLightGrey.withValues(alpha: 0.3), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.monoBlack)))),
    ]);
  }

  Widget _row(String label, String amount, Color tx, {bool bold = false, bool green = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: (bold ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600) : AppTypography.bodySmall).copyWith(color: green ? AppColors.success : AppColors.monoGrey)),
      Text(amount, style: (bold ? AppTypography.price.copyWith(fontSize: 16) : AppTypography.bodyMedium).copyWith(color: green ? AppColors.success : tx, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
    ]);
  }

  Widget _orderItem(CartItemModel item, Color tx) {
    return Row(children: [
      ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 56, height: 56, child: CachedNetworkImage(imageUrl: item.product.imageUrl, fit: BoxFit.cover, placeholder: (_, _) => ShimmerLoading.productCard(width: 56, height: 56), errorWidget: (_, _, _) => Container(color: AppColors.monoDivider)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.product.name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: tx), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text('${item.selectedSize}/${item.selectedColor}  ×${item.quantity}', style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey)),
      ])),
      Text('\$${(item.product.price * item.quantity).toStringAsFixed(0)}', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: tx)),
    ]);
  }
}
