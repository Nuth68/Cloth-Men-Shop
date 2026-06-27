import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/look_model.dart';
import '../../../data/repositories/look_repository.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  bool _loading = true;
  List<_Look> _looks = [];
  late PageController _pageController;
  int _currentPage = 0;
  int _selectedTag = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(_onPageScroll);
    _loadLooks();
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page ?? 0.0;
    setState(() {
      _currentPage = page.round();
    });
  }

  // ── Mock products map ──
  static final Map<String, ProductModel> _mockProducts = {
    'p1': ProductModel(
      id: 'p1',
      name: 'Tailored Wool Blazer',
      description:
          'Impeccably cut from Super 120s wool with a half-canvas construction. Notch lapel, double vent, and a soft shoulder for a natural drape.',
      price: 395.00,
      imageUrl:
          'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=600&q=80',
      categoryId: 'blazers',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Navy', 'Charcoal'],
      brand: 'Steav',
      fit: 'Regular',
      isNew: true,
    ),
    'p2': ProductModel(
      id: 'p2',
      name: 'Cashmere Crew Neck',
      description:
          'Knitted in Italy from pure cashmere with a relaxed silhouette. Rib-knit cuffs, hem, and a classic crew neckline.',
      price: 280.00,
      imageUrl:
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&q=80',
      categoryId: 'knits',
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['Cream', 'Grey'],
      brand: 'Urban Thread',
      fit: 'Regular',
      isNew: false,
    ),
    'p3': ProductModel(
      id: 'p3',
      name: 'Urban Cotton Hoodie',
      description:
          'Heavyweight loopback cotton hoodie with a boxy street-ready fit. Drawcord hood, kangaroo pocket, and ribbed panels.',
      price: 165.00,
      imageUrl:
          'https://images.unsplash.com/photo-1516820827855-3ea1bd6f79ea?w=600&q=80',
      categoryId: 'casual',
      sizes: ['M', 'L', 'XL', 'XXL'],
      colors: ['Black', 'Grey'],
      brand: 'Drift',
      fit: 'Runs Large',
      isNew: true,
    ),
    'p4': ProductModel(
      id: 'p4',
      name: 'Evening Dinner Jacket',
      description:
          'Satin-peak lapel dinner jacket in a modern slim cut. Fully lined with jacquard lining and finished with horn buttons.',
      price: 450.00,
      imageUrl:
          'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600&q=80',
      categoryId: 'formal',
      sizes: ['S', 'M', 'L'],
      colors: ['Black', 'Burgundy'],
      brand: 'Heritage Co',
      fit: 'Slim',
      isNew: false,
    ),
    'p5': ProductModel(
      id: 'p5',
      name: 'Linen Weekend Shirt',
      description:
          'Breezy linen shirt washed for a soft hand feel. Boxy cut, camp collar, and mother-of-pearl buttons. Perfect for off-duty days.',
      price: 130.00,
      imageUrl:
          'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&q=80',
      categoryId: 'casual',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['White', 'Beige'],
      brand: 'Modernist',
      fit: 'Runs Large',
      isNew: true,
    ),
    'p6': ProductModel(
      id: 'p6',
      name: 'Coastal Resort Shirt',
      description:
          'Silk-blend camp shirt printed with an exclusive hand-painted motif. Open collar, straight hem, and a relaxed drape.',
      price: 220.00,
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&q=80',
      categoryId: 'shirts',
      sizes: ['S', 'M', 'L'],
      colors: ['Green', 'Brown'],
      brand: 'Steav',
      fit: 'Regular',
      isNew: false,
    ),
    'p7': ProductModel(
      id: 'p7',
      name: 'Minimalist Overcoat',
      description:
          'Clean-lined overcoat in a wool-cashmere blend. Hidden placket, raglan sleeve, and a relaxed but refined silhouette.',
      price: 520.00,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80',
      categoryId: 'outerwear',
      sizes: ['M', 'L', 'XL'],
      colors: ['Grey', 'Black'],
      brand: 'Modernist',
      fit: 'Regular',
      isNew: true,
    ),
    'p8': ProductModel(
      id: 'p8',
      name: 'Waxed Field Jacket',
      description:
          'British Millerain waxed-cotton shell with a quilted lining. Four utility pockets, corduroy collar, and storm cuffs.',
      price: 345.00,
      imageUrl:
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=600&q=80',
      categoryId: 'outerwear',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Olive', 'Brown'],
      brand: 'Heritage Co',
      fit: 'Regular',
      isNew: false,
    ),
    'p9': ProductModel(
      id: 'p9',
      name: 'Japanese Selvedge Jean',
      description:
          '14oz Japanese selvedge denim woven on vintage shuttle looms. High-rise, straight-leg, and a button fly.',
      price: 195.00,
      imageUrl:
          'https://images.unsplash.com/photo-1523381294911-8d3cead13475?w=600&q=80',
      categoryId: 'pants',
      sizes: ['28', '30', '32', '34', '36'],
      colors: ['Indigo'],
      brand: 'Drift',
      fit: 'True to Size',
      isNew: false,
    ),
  };

  // ── Editorial looks data (loaded from API) ──
  void _navigateToProduct(BuildContext context, String productId) {
    final product = _mockProducts[productId];
    if (product != null) {
      context.push('/product-detail', extra: product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onSearch: () => context.push('/search'),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
            ),
            Expanded(
              child: _loading
                  ? _buildShimmer()
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() => _loading = true);
                        await Future.delayed(const Duration(milliseconds: 400));
                        if (mounted) setState(() => _loading = false);
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Hero editorial header ──
                            _buildHeroHeader(),
                            const SizedBox(height: 24),
                            // ── Category filter chips ──
                            _buildCategoryChips(isDark),
                            const SizedBox(height: 28),
                            // ── Horizontal PageView lookbook ──
                            _buildLookbookPageView(),
                            const SizedBox(height: 16),
                            // ── Dot indicators ──
                            _buildDotIndicators(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shimmer ──
  Widget _buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShimmerLoading.banner(height: 180),
          const SizedBox(height: 16),
          ShimmerLoading.productGrid(count: 4),
        ],
      ),
    );
  }

  // ── Hero header ──
  Widget _buildHeroHeader() {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800&q=80',
            fit: BoxFit.cover,
            placeholder: (_, __) => ShimmerLoading.banner(height: 200),
            errorWidget: (_, __, ___) =>
                Container(color: Theme.of(context).colorScheme.onSurface),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.translate('theEdit'),
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white70,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate('autumnWinter'),
                  style: AppTypography.serif(22,
                      weight: FontWeight.w700,
                      color: AppColors.surface(context),
                      height: 1.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Category chips ──
  Widget _buildCategoryChips(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final tags = [
      l10n.translate('allCategory'),
      l10n.translate('blazers'),
      l10n.translate('knits'),
      l10n.translate('formal'),
      l10n.translate('casual'),
      l10n.translate('outerwear'),
      l10n.translate('editorial'),
      l10n.translate('resort'),
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final selected = i == _selectedTag;
            return GestureDetector(
              onTap: () {
                AppHaptics.selection();
                setState(() => _selectedTag = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: selected
                      ? (isDark ? AppColors.brass : AppColors.monoBlack)
                      : (isDark ? AppColors.darkCard : AppColors.white),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? (isDark ? AppColors.brass : AppColors.monoBlack)
                        : AppColors.monoDivider,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  tags[i],
                  style: AppTypography.labelSmall.copyWith(
                    color: selected
                        ? AppColors.white
                        : (isDark ? AppColors.white : AppColors.monoBlack),
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Filtered looks ──
  List<_Look> get _filteredLooks {
    if (_selectedTag == 0) return _looks;
    final tagNames = ['ALL', 'BLAZERS', 'KNITS', 'FORMAL', 'CASUAL', 'OUTERWEAR', 'EDITORIAL', 'RESORT'];
    final selectedTagName = _selectedTag < tagNames.length ? tagNames[_selectedTag] : 'ALL';
    return _looks.where((l) => l.tag == selectedTagName).toList();
  }

  Future<void> _loadLooks() async {
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
      final repo = LookRepository(gql);
      final looks = await repo.getLooks();
      if (mounted) setState(() {
        _looks = looks.map((l) => _Look(title: l.title, subtitle: l.subtitle, image: l.image, height: l.height, tag: l.tag, productId: l.id)).toList();
        _loading = false;
      });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  // ── Horizontal PageView lookbook ──
  Widget _buildLookbookPageView() {
    final looks = _filteredLooks;
    if (looks.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No looks found', style: TextStyle(color: Colors.grey))));
    }
    return SizedBox(
      height: 460,
      child: PageView.builder(
        controller: _pageController,
        itemCount: looks.length,
        padEnds: true,
        itemBuilder: (context, index) {
          final look = looks[index];
          // Calculate parallax offset for this page
          final parallaxOffset = _calculateParallax(index);
          return _LookbookPageCard(
            look: look,
            parallaxOffset: parallaxOffset,
            onTap: () => _navigateToProduct(context, look.productId),
            onShopTap: () => _navigateToProduct(context, look.productId),
          );
        },
      ),
    );
  }

  double _calculateParallax(int index) {
    // The parallax base: offset of the current page from its centered position
    final diff = (_pageController.hasClients ? (_pageController.page ?? 0.0) : 0.0) - index;
    // Clamp to [-1, 1] range then multiply by a factor for a subtle shift
    return diff.clamp(-1.0, 1.0) * 20.0;
  }

  // ── Dot indicators ──
  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_filteredLooks.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.monoBlack
                : AppColors.monoDivider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── Data class ──
class _Look {
  final String title, subtitle, image, tag;
  final double height;
  final String productId;
  const _Look({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.height,
    required this.tag,
    required this.productId,
  });
}

// ── Horizontal PageView look card ──
class _LookbookPageCard extends StatelessWidget {
  final _Look look;
  final double parallaxOffset;
  final VoidCallback onTap;
  final VoidCallback onShopTap;

  const _LookbookPageCard({
    required this.look,
    required this.parallaxOffset,
    required this.onTap,
    required this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 460,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Parallax image ──
                Transform.translate(
                  offset: Offset(parallaxOffset, 0),
                  child: CachedNetworkImage(
                    imageUrl: look.image,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        ShimmerLoading.productCard(height: 460),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.monoLightGrey),
                  ),
                ),
                // ── Gradient overlay ──
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.45, 1.0],
                    ),
                  ),
                ),
                // ── Content: subtitle tag, title, button ──
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Subtitle tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          look.subtitle,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        look.title,
                        style: AppTypography.serif(24,
                            weight: FontWeight.w700,
                            color: AppColors.surface(context),
                            height: 1.15),
                      ),
                      const SizedBox(height: 18),
                      // Shop This Look button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onShopTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface(context),
                            foregroundColor: AppColors.monoBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.translate('shopThisLook'),
                            style: AppTypography.button.copyWith(
                              color: AppColors.monoBlack,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
