import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/constants/api_config.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  List<ProductModel> _results = [];
  bool _loading = false;
  bool _hasSearched = false;

  static const _recent = ['Blazer', 'Merino', 'Boots', 'Cashmere', 'Linen Shirt', 'Trench Coat'];

  @override
  void initState() { super.initState(); _focusNode.requestFocus(); }

  @override
  void dispose() { _searchCtrl.dispose(); _focusNode.dispose(); super.dispose(); }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) { setState(() { _results = []; _hasSearched = false; }); return; }
    setState(() => _loading = true);
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
      final repo = ProductRepository(gql);
      final all = await repo.getProducts();
      final filtered = all.where((p) =>
        p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.brand.toLowerCase().contains(query.toLowerCase())
      ).toList();
      if (mounted) setState(() { _results = filtered; _loading = false; _hasSearched = true; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, elevation: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(color: AppColors.monoLightGrey.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _searchCtrl, focusNode: _focusNode, autofocus: true,
            onChanged: _search,
            style: AppTypography.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface),
            cursorColor: AppColors.monoBlack,
            decoration: InputDecoration(
              hintText: l10n.translate('searchHint'), hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey),
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.monoGrey),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.close, size: 18, color: AppColors.monoGrey),
                      onPressed: () => setState(() { _searchCtrl.clear(); _results.clear(); _hasSearched = false; }))
                  : null,
              border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: _loading
          ? Padding(padding: const EdgeInsets.all(16), child: LoadingIndicator.shimmerProductGrid(count: 6))
          : _hasSearched && _results.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.search_off, size: 48, color: AppColors.monoGrey),
                  const SizedBox(height: 12),
                  Text(l10n.translate('noResultsFound'), style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey)),
                ]))
              : _hasSearched
                  ? _buildResults()
                  : _buildRecent(),
    );
  }

  Widget _buildRecent() {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l10n.translate('recentSearches'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: _recent.map((q) => _Pill(icon: Icons.history, text: q, onTap: () { _searchCtrl.text = q; _search(q); })).toList()),
      const SizedBox(height: 32),
      Text(l10n.translate('trending'), style: AppTypography.labelSmall.copyWith(letterSpacing: 1.5, color: AppColors.monoGrey)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: ['New Arrivals', 'Outerwear', 'Sale', 'Best Sellers', 'Formal'].map((q) => _Pill(icon: Icons.trending_up, text: q, onTap: () { _searchCtrl.text = q; _search(q); })).toList()),
    ]));
  }

  Widget _buildResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final p = _results[i];
        return GestureDetector(
          onTap: () => context.push('/product-detail', extra: p),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.monoDivider, width: 0.5)),
            child: Row(children: [
              Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(width: 80, height: 80,
                    child: CachedNetworkImage(imageUrl: p.imageUrl, fit: BoxFit.cover,
                      placeholder: (_, __) => ShimmerLoading.productCard(width: 80, height: 80),
                      errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey)))),
                  Positioned(
                    bottom: 4, right: 4,
                    child: GestureDetector(
                      onTap: () {
                        AppHaptics.medium();
                        final cartBloc = context.read<CartBloc>();
                        cartBloc.add(AddToCart(CartItemModel(id: p.id, product: p, selectedSize: p.sizes.isNotEmpty ? p.sizes.first : 'M', selectedColor: p.colors.isNotEmpty ? p.colors.first : '')));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} added to cart'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
                      },
                      child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.monoBlack, borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.add_shopping_cart, color: AppColors.white, size: 14)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.brand, style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey, letterSpacing: 1.5)),
                const SizedBox(height: 2),
                Text(p.name, style: AppTypography.sans(14, weight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('\$${p.price.toStringAsFixed(0)}', style: AppTypography.price.copyWith(fontSize: 15)),
              ])),
              const Icon(Icons.chevron_right, color: AppColors.monoGrey, size: 20),
            ]),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon; final String text; final VoidCallback onTap;
  const _Pill({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: AppColors.monoLightGrey.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: AppColors.monoGrey),
          const SizedBox(width: 6),
          Text(text, style: AppTypography.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ]),
      ),
    );
  }
}
