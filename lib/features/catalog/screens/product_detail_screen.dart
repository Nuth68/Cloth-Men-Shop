import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../shared/widgets/product_image_viewer.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../widgets/size_selector.dart';
import '../widgets/color_selector.dart';
import '../widgets/fit_guide_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;
  const ProductDetailScreen({super.key, this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

final _relatedProducts = []; // Loaded from ProductRepository API

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late SizeSelectorController _sz;
  late ColorSelectorController _cl;
  late FitGuideController _ft;
  bool _descExpanded = false;
  bool _fitExpanded = false;
  bool _shippingExpanded = false;

  @override
  void initState() { super.initState(); _sz = SizeSelectorController(); _cl = ColorSelectorController(); _ft = FitGuideController(); }
  @override
  void dispose() { _sz.dispose(); _cl.dispose(); _ft.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = widget.product;
    final d = Theme.of(context).brightness == Brightness.dark;
    final tx = d ? AppColors.white : AppColors.monoBlack;
    final bg = d ? AppColors.darkBg : AppColors.white;

    if (p == null) return Scaffold(body: EmptyStateWidget(state: EmptyState.error, title: l10n.translate('productNotFound'), message: l10n.translate('notAvailable')));

    final wl = context.read<WishlistBloc>();
    final ct = context.read<CartBloc>();

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          MonographHeader(
            onBack: () => context.pop(),
            onBag: () => context.push('/cart'),
            onNotification: () => context.push('/notifications'),
            elevated: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Hero(tag: 'product-${p.id}', child: ProductImageViewer.gallery(imageUrls: p.imageUrls, height: 420)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 20),
                  Text(p.brand.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey, letterSpacing: 2)),
                  const SizedBox(height: 6),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: Text(p.name, style: AppTypography.heading1.copyWith(color: tx, height: 1.1))),
                    const SizedBox(width: 12),
                    Text('\$${p.price.toStringAsFixed(0)}', style: AppTypography.price.copyWith(color: tx, fontSize: 22)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    ...List.generate(5, (i) => Icon(i < p.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: AppColors.brass)),
                    const SizedBox(width: 6),
                    Text('${p.rating} (128 ${l10n.translate('reviews').toLowerCase()})', style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
                  ]),
                  if (p.isNew) ...[
                    const SizedBox(height: 8),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.brass.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                      child: Text(l10n.translate('newArrivalTag'), style: AppTypography.labelSmall.copyWith(color: AppColors.brass, letterSpacing: 1))),
                  ],
                  const SizedBox(height: 24),
                  _sectionLabel('Size', required: true),
                  const SizedBox(height: 8),
                  SizeSelector(controller: _sz),
                  const SizedBox(height: 20),
                  _sectionLabel('Color'),
                  const SizedBox(height: 8),
                  ColorSelector(controller: _cl),
                  const SizedBox(height: 28),
                  if (p.description.isNotEmpty) ...[
                    _accordion(title: 'Description', expanded: _descExpanded, onTap: () => setState(() => _descExpanded = !_descExpanded),
                      child: Text(p.description, style: AppTypography.bodyMedium.copyWith(color: d ? Colors.white54 : AppColors.monoGrey, height: 1.6))),
                    const SizedBox(height: 8),
                  ],
                  _accordion(title: 'Size & Fit', expanded: _fitExpanded, onTap: () => setState(() => _fitExpanded = !_fitExpanded),
                    child: FitGuideWidget(controller: _ft)),
                  const SizedBox(height: 8),
                  _accordion(title: 'Shipping & Returns', expanded: _shippingExpanded, onTap: () => setState(() => _shippingExpanded = !_shippingExpanded),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _shippingRow(Icons.local_shipping_outlined, 'Free shipping on orders over \$100'),
                      const SizedBox(height: 8),
                      _shippingRow(Icons.refresh, 'Free returns within 30 days'),
                      const SizedBox(height: 8),
                      _shippingRow(Icons.verified_outlined, 'Authenticity guaranteed'),
                    ])),
                  const SizedBox(height: 28),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(l10n.translate('reviews'), style: AppTypography.heading2.copyWith(color: tx)),
                    GestureDetector(onTap: () => context.push('/reviews', extra: p),
                      child: Text(l10n.translate('seeAll'), style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey, decoration: TextDecoration.underline))),
                  ]),
                  const SizedBox(height: 24),
                  Text(l10n.translate('youMightAlsoLike'), style: AppTypography.heading2.copyWith(color: tx)),
                  const SizedBox(height: 14),
                ])),
                SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _relatedProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final rp = _relatedProducts[i];
                      return GestureDetector(
                        onTap: () => context.push('/product-detail', extra: rp),
                        child: SizedBox(width: 150, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Stack(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(imageUrl: rp.imageUrl, height: 170, width: 150, fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(height: 170, color: AppColors.monoDivider),
                                  errorWidget: (_, __, ___) => Container(height: 170, color: AppColors.monoDivider))),
                              Positioned(
                                bottom: 6, right: 6,
                                child: GestureDetector(
                                  onTap: () {
                                    AppHaptics.medium();
                                    ct.add(AddToCart(CartItemModel(id: rp.id, product: rp, selectedSize: rp.sizes.isNotEmpty ? rp.sizes.first : 'M', selectedColor: rp.colors.isNotEmpty ? rp.colors.first : '')));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${rp.name} added to cart'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
                                  },
                                  child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.monoBlack, borderRadius: BorderRadius.circular(7)),
                                    child: const Icon(Icons.add_shopping_cart, color: AppColors.white, size: 15)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(rp.brand, style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey, fontSize: 10)),
                          Text(rp.name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500, color: tx), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('\$${rp.price.toStringAsFixed(0)}', style: AppTypography.price.copyWith(fontSize: 13, color: tx)),
                        ])),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
          // Sticky add to cart bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(color: bg, border: Border(top: BorderSide(color: AppColors.monoDivider, width: 0.5))),
            child: SafeArea(top: false, child: Row(children: [
              GestureDetector(
                onTap: () { AppHaptics.medium(); wl.add(AddToWishlist(p)); },
                child: Container(width: 48, height: 48, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.monoDivider)),
                  child: Icon(Icons.favorite_outline, color: tx, size: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(child: SizedBox(height: 48, child: ElevatedButton(
                onPressed: () {
                  AppHaptics.heavy();
                  ct.add(AddToCart(CartItemModel(id: p.id, product: p, selectedSize: _sz.selectedSize, selectedColor: _cl.selectedColor ?? (p.colors.isNotEmpty ? p.colors.first : ''))));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} ${l10n.translate('addedToCart')}'), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating));
                },
                style: ElevatedButton.styleFrom(backgroundColor: d ? AppColors.white : AppColors.monoBlack, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.shopping_bag_outlined, size: 18, color: d ? AppColors.monoBlack : AppColors.white),
                  const SizedBox(width: 8),
                  Text(l10n.translate('addToCart'), style: AppTypography.button.copyWith(color: d ? AppColors.monoBlack : AppColors.white)),
                ]),
              ))),
            ])),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, {bool required = false}) {
    return Row(children: [
      Text(label, style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.monoGrey)),
      if (required) Text(' *', style: AppTypography.labelSmall.copyWith(color: AppColors.error)),
    ]);
  }

  Widget _accordion({required String title, required bool expanded, required VoidCallback onTap, required Widget child}) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.monoDivider, width: 0.5), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(top: const Radius.circular(10), bottom: expanded ? Radius.zero : const Radius.circular(10)),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: Row(children: [
            Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            AnimatedRotation(turns: expanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.monoGrey)),
          ])),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: child),
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ]),
    );
  }

  Widget _shippingRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.brass),
      const SizedBox(width: 10),
      Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
    ]);
  }

}
