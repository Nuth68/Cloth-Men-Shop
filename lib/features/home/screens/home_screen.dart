import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/api_config.dart';
import '../widgets/hero_section.dart';
import '../widgets/press_banner.dart';
import '../widgets/category_bar.dart';
import '../widgets/new_arrivals_section.dart';
import '../widgets/bestsellers_section.dart';
import '../widgets/philosophy_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _newArrivals = [];
  List<ProductModel> _bestsellers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cache = CacheService();
    final gql = GraphqlService(baseUrl: ApiConfig.baseUrl, cache: cache);
    final repo = ProductRepository(gql);
    try {
      final newArrivals = await repo.getNewArrivals();
      final allProducts = await repo.getProducts();
      if (!mounted) return;
      setState(() {
        _newArrivals = newArrivals;
        _bestsellers = allProducts.take(4).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
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
              elevated: true,
            ),
            Expanded(
              child: _loading
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
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: CustomScrollView(
                        slivers: [
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
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
