import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/constants/api_config.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/utils/size_helper.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/animated_list_item.dart';
import '../../../shared/widgets/monograph_header.dart';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onBack: () => context.pop(),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.filter_list,
                      size: 22),
                  onPressed: () {
                    AppHaptics.light();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FilterBottomSheet(
                        onApply: (size, color, fit, minPrice, maxPrice, brands) {
                          context.read<CatalogBloc>().add(FilterCatalog(
                                size: size,
                                color: color,
                                fit: fit,
                                minPrice: minPrice,
                                maxPrice: maxPrice,
                                brands: brands,
                              ));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<CatalogBloc, CatalogState>(
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
                      title: l10n.translate('somethingWentWrong'),
                      message: state.message,
                      actionLabel: l10n.translate('retry'),
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
                        title: l10n.translate('noProducts'),
                        message: l10n.translate('tryAdjustingFilters'),
                        actionLabel: l10n.translate('clearFilters'),
                        onAction: () => context
                            .read<CatalogBloc>()
                            .add(const LoadCatalog()),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<CatalogBloc>().add(const LoadCatalog());
                        await Future.delayed(const Duration(milliseconds: 300));
                      },
                      child: GridView.builder(
                        padding: EdgeInsets.all(SizeHelper.horizontalPadding(context)),
                        itemCount: products.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: SizeHelper.gridColumns(context),
                          childAspectRatio: 0.72,
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
            ),
          ],
        ),
      ),
    );
  }
}
