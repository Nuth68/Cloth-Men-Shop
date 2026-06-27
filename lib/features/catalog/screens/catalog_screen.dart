import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/constants/api_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/animated_list_item.dart';
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
<<<<<<< Updated upstream
          icon: Icon(Icons.arrow_back, color: AppColors.monoBlack),
=======
          icon: const Icon(Icons.arrow_back, color: AppColors.monoBlack),
>>>>>>> Stashed changes
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SHOP',
          style: AppTypography.heading2.copyWith(
            letterSpacing: 2,
            color: AppColors.monoBlack,
          ),
        ),
        actions: [
          IconButton(
<<<<<<< Updated upstream
            icon: Icon(Icons.filter_list,
=======
            icon: const Icon(Icons.filter_list,
>>>>>>> Stashed changes
                color: AppColors.monoBlack, size: 22),
            onPressed: () {
              AppHaptics.light();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FilterBottomSheet(
                  onApply: (size, color, fit) {
                    context
                        .read<CatalogBloc>()
                        .add(FilterCatalog(size: size, color: color, fit: fit));
                  },
                ),
              );
            },
          ),
          IconButton(
<<<<<<< Updated upstream
            icon: Icon(Icons.shopping_bag_outlined,
=======
            icon: const Icon(Icons.shopping_bag_outlined,
>>>>>>> Stashed changes
                color: AppColors.monoBlack, size: 22),
            onPressed: () {
              AppHaptics.light();
              context.push('/cart');
            },
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: LoadingIndicator.shimmerProductGrid(count: 6),
            );
          }
          if (state is CatalogError) {
            return EmptyStateWidget(
              state: EmptyState.error,
              title: 'Something went wrong',
              message: state.message,
              actionLabel: 'Retry',
              onAction: () => context
                  .read<CatalogBloc>()
                  .add(const LoadCatalog()),
            );
          }
          if (state is CatalogLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return EmptyStateWidget(
                state: EmptyState.empty,
                title: 'No products found',
                message: 'Try adjusting your filters or check back later.',
                actionLabel: 'Clear Filters',
                onAction: () => context
                    .read<CatalogBloc>()
                    .add(const LoadCatalog()),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CatalogBloc>().add(const LoadCatalog());
                // Small delay for the refresh indicator to show
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, index) => AnimatedListItem(
                  index: index,
                  child: ProductCard(
                    product: products[index],
                    onTap: () {
                      AppHaptics.light();
                      context.push('/product-detail',
                          extra: products[index]);
                    },
                  ),
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
