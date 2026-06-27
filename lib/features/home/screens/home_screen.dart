import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/loading_indicator.dart';
<<<<<<< Updated upstream
import '../../../shared/widgets/animated_list_item.dart';
import '../../../shared/widgets/shimmer_loading.dart';
=======
>>>>>>> Stashed changes
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/api_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _loading = true;
  int _selectedCategory = 0;

  static const _categories = [
    ('All', Icons.grid_view_rounded),
    ('Outerwear', Icons.layers_outlined),
    ('Shirts', Icons.dry_cleaning_outlined),
    ('Pants', Icons.straighten_outlined),
    ('Shoes', Icons.directions_walk_outlined),
    ('Bags', Icons.work_outline),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cache = CacheService();
    final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
    final repo = ProductRepository(gql);
    try {
<<<<<<< Updated upstream
      final products = await repo.getProducts();
=======
      final newArrivals = await repo.getNewArrivals();
      final allProducts = await repo.getProducts();
>>>>>>> Stashed changes
      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _filterByCategory(int index) {
    AppHaptics.selection();
    setState(() => _selectedCategory = index);
    if (index == 0) {
      _filteredProducts = _allProducts;
    } else {
      final catName = _categories[index].$1;
      _filteredProducts = _allProducts
          .where((p) => p.categoryId == catName || p.name.toLowerCase().contains(catName.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MonographHeader(
              onSearch: () {},
              onBag: () => context.push('/cart'),
<<<<<<< Updated upstream
              onNotification: () {},
=======
>>>>>>> Stashed changes
              elevated: true,
            ),
            Expanded(
              child: _loading
<<<<<<< Updated upstream
                  ? _buildShimmer()
=======
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          LoadingIndicator.shimmerBanner(),
                          const SizedBox(height: 8),
                          LoadingIndicator.shimmerProductGrid(count: 4),
                          const SizedBox(height: 8),
                          LoadingIndicator.shimmerProductGrid(count: 2),
                        ],
                      ),
                    )
>>>>>>> Stashed changes
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: CustomScrollView(
                        slivers: [
<<<<<<< Updated upstream
                          // ── Compact hero banner ──
                          SliverToBoxAdapter(child: _buildHeroBanner()),
                          // ── Category pills ──
                          SliverToBoxAdapter(child: _buildCategoryPills()),
                          // ── Section header ──
                          SliverToBoxAdapter(child: _buildSectionHeader()),
                          // ── Product grid ──
                          _filteredProducts.isEmpty
                              ? const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: Center(
                                      child: Text('No products found',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                )
                              : SliverPadding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  sliver: SliverGrid(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.68,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 16,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => AnimatedListItem(
                                        index: index,
                                        child: _ProductCard(
                                          product: _filteredProducts[index],
                                          onTap: () => context.push(
                                            '/product-detail',
                                            extra: _filteredProducts[index],
                                          ),
                                        ),
                                      ),
                                      childCount: _filteredProducts.length,
                                    ),
                                  ),
                                ),
                          const SliverToBoxAdapter(child: SizedBox(height: 40)),
=======
                          const SliverToBoxAdapter(child: HeroSection()),
                          const SliverToBoxAdapter(child: PressBanner()),
                          const SliverToBoxAdapter(child: CategoryBar()),
                          SliverToBoxAdapter(
                            child: NewArrivalsSection(
                              products: _newArrivals,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: BestsellersSection(
                              products: _bestsellers,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: PhilosophySection(),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 24),
                          ),
>>>>>>> Stashed changes
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shimmer loading ──
  Widget _buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          LoadingIndicator.shimmerBanner(height: 200),
          const SizedBox(height: 16),
          LoadingIndicator.shimmerProductGrid(count: 6),
        ],
      ),
    );
  }

  // ── Compact hero ──
  Widget _buildHeroBanner() {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1512149177596-f817c7ef5d4c?w=800&q=80',
            fit: BoxFit.cover,
            placeholder: (_, __) => ShimmerLoading.banner(height: 200),
            errorWidget: (_, __, ___) => Container(color: AppColors.monoBlack),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              stops: const [0.3, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 20, right: 20, bottom: 20,
          child: Text(
            'The Tailoring\nArchive',
            style: AppTypography.serif(24, weight: FontWeight.w700, color: AppColors.white, height: 1.15),
          ),
        ),
      ],
    );
  }

  // ── Category pills ──
  Widget _buildCategoryPills() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final selected = i == _selectedCategory;
            return GestureDetector(
              onTap: () => _filterByCategory(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.monoBlack : AppColors.monoLightGrey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _categories[i].$2,
                      size: 16,
                      color: selected ? AppColors.white : AppColors.monoGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _categories[i].$1,
                      style: AppTypography.bodySmall.copyWith(
                        color: selected ? AppColors.white : AppColors.monoBlack,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Section header ──
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedCategory == 0 ? 'All Products' : _categories[_selectedCategory].$1,
            style: AppTypography.heading2.copyWith(color: AppColors.monoBlack),
          ),
          Text(
            '${_filteredProducts.length} items',
            style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey),
          ),
        ],
      ),
    );
  }
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
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.monoDivider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (_, __) => ShimmerLoading.productCard(),
                    errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.monoGrey, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    style: AppTypography.sans(13, weight: FontWeight.w500, color: AppColors.monoBlack),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: AppTypography.price.copyWith(fontSize: 15, color: AppColors.monoBlack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
