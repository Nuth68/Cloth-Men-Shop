import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/constants/api_config.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cache = CacheService();
        final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
        final repo = ProductRepository(gql);
        return CatalogBloc(repo)..add(const LoadCatalog());
      },
      child: const _CatalogView(),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView();

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
        title: const Text('SHOP',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black, size: 22),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => FilterBottomSheet(
                onApply: (size, color, fit) {
                  context.read<CatalogBloc>().add(FilterCatalog(size: size, color: color, fit: fit));
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CatalogError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<CatalogBloc>().add(const LoadCatalog()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is CatalogLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) => ProductCard(
                product: products[index],
                onTap: () => context.push('/product-detail', extra: products[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
