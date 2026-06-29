import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/api_config.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/cart_item_model.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _allProducts = [];
  bool _loading = true;
  final PageController _heroCtrl = PageController();
  int _heroPage = 0;

  static const _slides = [
    _Slide('New Season\nEssentials', 'Curated for the modern wardrobe', 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=900&q=80'),
    _Slide('The Tailoring\nArchive', 'Discover precision-crafted pieces', 'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=900&q=80'),
    _Slide('Summer\nEdit 2024', 'Lightweight styles for the season', 'https://images.unsplash.com/photo-1516820827855-3ea1bd6f79ea?w=900&q=80'),
  ];

  @override
  void initState() { super.initState(); _loadData(); _autoSlide(); }
  @override
  void dispose() { _heroCtrl.dispose(); super.dispose(); }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted || !_heroCtrl.hasClients) return;
      _heroCtrl.animateToPage((_heroPage + 1) % _slides.length, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      _autoSlide();
    });
  }

  Future<void> _loadData() async {
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
      final repo = ProductRepository(gql);
      final products = await repo.getProducts();
      if (mounted) setState(() { _allProducts = products; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  List<ProductModel> get _newArrivals => _allProducts.where((p) => p.isNew).toList();
  List<ProductModel> get _bestsellers => _allProducts.take(8).toList();
  List<ProductModel> get _onSale => _allProducts.where((p) => _allProducts.indexOf(p) % 3 == 0).take(8).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(top: false, child: Column(children: [
        MonographHeader(onSearch: () => context.push('/search'), onBag: () => context.push('/cart'), onNotification: () => context.push('/notifications'), elevated: true),
        Expanded(
          child: _loading ? _shimmer() : RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _hero(),
              _categories(),
              _section(l10n.translate('newArrivals'), _newArrivals),
              _promo(),
              _section(l10n.translate('top'), _bestsellers),
              _editorial(),
              _section(l10n.translate('discount'), _onSale),
              const SizedBox(height: 24),
            ])),
          ),
        ),
      ])),
    );
  }

  // ── Hero ──
  Widget _hero() {
    return SizedBox(height: 420, child: Stack(children: [
      PageView.builder(
        controller: _heroCtrl, itemCount: _slides.length,
        onPageChanged: (i) => setState(() => _heroPage = i),
        itemBuilder: (_, i) {
          final s = _slides[i];
          return Stack(fit: StackFit.expand, children: [
            CachedNetworkImage(imageUrl: s.image, fit: BoxFit.cover, placeholder: (_, _) => ShimmerLoading.banner(height: 420), errorWidget: (_, _, _) => Container(color: AppColors.monoBlack)),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)], stops: const [0.4, 1.0]))),
            Positioned(left: 24, bottom: 44, right: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(s.title, style: AppTypography.serif(28, weight: FontWeight.w700, color: AppColors.white, height: 1.1)),
              const SizedBox(height: 8),
              Text(s.subtitle, style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
              const SizedBox(height: 12),
              SizedBox(height: 40, child: ElevatedButton(onPressed: () => context.push('/shop'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.white, foregroundColor: AppColors.monoBlack, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 24)), child: Text('Shop Now', style: AppTypography.button.copyWith(color: AppColors.monoBlack)))),
            ])),
          ]);
        },
      ),
      Positioned(left: 0, right: 0, bottom: 16, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_slides.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 3), width: _heroPage == i ? 24 : 8, height: 3, decoration: BoxDecoration(color: _heroPage == i ? AppColors.white : Colors.white30, borderRadius: BorderRadius.circular(2)))))),
    ]));
  }

  // ── Product section ──
  Widget _section(String title, List<ProductModel> products) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: AppTypography.heading2.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          GestureDetector(onTap: () => context.push('/shop'), child: Text(AppLocalizations.of(context).translate('seeAll'), style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey))),
        ]),
      ),
      const SizedBox(height: 8),
      SizedBox(height: 290, child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => SizedBox(width: 165, child: _ProductCard(product: products[i], onTap: () => context.push('/product-detail', extra: products[i]))),
      )),
    ]);
  }

  // ── Categories scroll ──
  Widget _categories() {
    final cats = ['All', 'Outerwear', 'Shirts', 'Pants', 'Shoes', 'Bags', 'Accessories'];
    final icons = [Icons.grid_view_rounded, Icons.layers_outlined, Icons.dry_cleaning_outlined, Icons.straighten_outlined, Icons.directions_walk_outlined, Icons.work_outline, Icons.watch];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 8),
      SizedBox(
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => context.push('/shop'),
            child: Container(
              width: 80,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isDark ? AppColors.darkCard : AppColors.monoOffWhite),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icons[i], size: 20, color: isDark ? Colors.white70 : AppColors.monoGrey),
                const SizedBox(height: 4),
                Text(cats[i], style: AppTypography.labelSmall.copyWith(fontSize: 9, color: isDark ? Colors.white54 : AppColors.monoGrey)),
              ]),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
    ]);
  }

  // ── Promo ──
  Widget _promo() {
    return GestureDetector(
      onTap: () => context.push('/promotions'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        height: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), image: const DecorationImage(image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=600&q=80'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(colors: [Colors.black.withValues(alpha: 0.6), Colors.black.withValues(alpha: 0.3)], begin: Alignment.centerLeft, end: Alignment.centerRight)),
          padding: const EdgeInsets.all(24),
          child: Row(children: [
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)), child: Text('SALE', style: AppTypography.labelSmall.copyWith(color: Colors.white, letterSpacing: 2))),
              const SizedBox(height: 10),
              Text('Up to 50% Off', style: AppTypography.heading1.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              Text('Use code: SUMMER50', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
            ])),
            Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_forward, color: AppColors.monoBlack, size: 20)),
          ]),
        ),
      ),
    );
  }

  // ── Editorial ──
  Widget _editorial() {
    return GestureDetector(
      onTap: () => context.push('/lookbook'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        height: 280,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), image: const DecorationImage(image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600&q=80'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)], stops: const [0.4, 1.0])),
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('THE EDIT', style: AppTypography.labelSmall.copyWith(color: Colors.white70, letterSpacing: 3)),
            const SizedBox(height: 8),
            Text('Explore the\nLookbook', style: AppTypography.serif(24, weight: FontWeight.w700, color: Colors.white, height: 1.15)),
            const SizedBox(height: 12),
            SizedBox(height: 36, child: OutlinedButton(onPressed: () => context.push('/lookbook'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Explore', style: AppTypography.button.copyWith(color: Colors.white)))),
          ]),
        ),
      ),
    );
  }

  Widget _shimmer() => SingleChildScrollView(child: Column(children: [ShimmerLoading.banner(height: 420), const SizedBox(height: 16), ShimmerLoading.productGrid(count: 4)]));
}

// ── Product card ──
class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  const _ProductCard({required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.monoDivider, width: 0.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(fit: StackFit.expand, children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(11)), child: CachedNetworkImage(imageUrl: product.imageUrl, fit: BoxFit.cover, width: double.infinity, placeholder: (_, _) => ShimmerLoading.productCard(), errorWidget: (_, _, _) => Container(color: AppColors.monoLightGrey))),
              Positioned(bottom: 6, right: 6, child: GestureDetector(
                onTap: () {
                  AppHaptics.medium();
                  context.read<CartBloc>().add(AddToCart(CartItemModel(id: product.id, product: product, selectedSize: product.sizes.isNotEmpty ? product.sizes.first : 'M', selectedColor: product.colors.isNotEmpty ? product.colors.first : '')));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
                },
                child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.monoBlack, borderRadius: BorderRadius.circular(7)), child: const Icon(Icons.add_shopping_cart, color: AppColors.white, size: 15)),
              )),
            ]),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.brand, style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey, letterSpacing: 1.2, fontSize: 10)),
            const SizedBox(height: 2),
            Text(product.name, style: AppTypography.sans(12, weight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('\$${product.price.toStringAsFixed(0)}', style: AppTypography.price.copyWith(fontSize: 14)),
          ])),
        ]),
      ),
    );
  }
}

class _Slide { final String title, subtitle, image; const _Slide(this.title, this.subtitle, this.image); }
