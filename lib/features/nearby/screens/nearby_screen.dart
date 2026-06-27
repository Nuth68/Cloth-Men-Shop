import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/rating_stars.dart';
import '../../../shared/widgets/store_bottom_sheet.dart';

final List<StoreInfo> _mockNearbyStores = const [
  StoreInfo(
    name: 'Steav Store - Riverside',
    address: '#78, Sisowath Quay, Riverside, Phnom Penh',
    lat: 11.5700,
    lng: 104.9320,
    distanceKm: 0.3,
    rating: 4.2,
    hours: '9:00 AM - 9:00 PM',
    phone: '+855 23 456 7803',
    isOpenNow: true,
    hasTryOn: false,
  ),
  StoreInfo(
    name: 'Steav Boutique - BKK1',
    address: '#12, Street 57, BKK1, Phnom Penh',
    lat: 11.5460,
    lng: 104.9230,
    distanceKm: 1.2,
    rating: 4.5,
    hours: '9:00 AM - 9:00 PM',
    phone: '+855 23 456 7802',
    isOpenNow: true,
    hasTryOn: true,
  ),
  StoreInfo(
    name: 'Steav Flagship - Toul Kork',
    address: '#45, Street 315, Toul Kork, Phnom Penh',
    lat: 11.5760,
    lng: 104.8980,
    distanceKm: 3.5,
    rating: 4.8,
    hours: '9:00 AM - 9:00 PM',
    phone: '+855 23 456 7801',
    isOpenNow: true,
    hasTryOn: true,
  ),
  StoreInfo(
    name: 'Steav Collection - Russian Market',
    address: '#5, Street 440, Tuol Tom Poung, Phnom Penh',
    lat: 11.5310,
    lng: 104.9130,
    distanceKm: 3.8,
    rating: 4.3,
    hours: '9:00 AM - 9:00 PM',
    phone: '+855 23 456 7805',
    isOpenNow: true,
    hasTryOn: false,
  ),
  StoreInfo(
    name: 'Steav Fashion - TK Avenue',
    address: '#203, TK Avenue, Toul Kork, Phnom Penh',
    lat: 11.5810,
    lng: 104.8900,
    distanceKm: 6.5,
    rating: 4.7,
    hours: '9:00 AM - 9:00 PM',
    phone: '+855 23 456 7804',
    isOpenNow: true,
    hasTryOn: true,
  ),
  StoreInfo(
    name: 'Steav Outlet - AEON Sen Sok',
    address: '#88, AEON Mall Sen Sok, Street 1003, Phnom Penh',
    lat: 11.5920,
    lng: 104.8750,
    distanceKm: 10.5,
    rating: 4.0,
    hours: '9:00 AM - 9:00 PM',
    phone: '+855 23 456 7806',
    isOpenNow: false,
    hasTryOn: true,
  ),
];

class NearbyScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onBag;
  final VoidCallback? onNotification;

  const NearbyScreen({
    super.key,
    this.onBack,
    this.onBag,
    this.onNotification,
  });

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool _isLoading = true;
  bool _filterOpenNow = false;
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    _simulateLoad();
  }

  Future<void> _simulateLoad() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<StoreInfo> _getFilteredStores() {
    List<StoreInfo> stores = List.from(_mockNearbyStores);

    if (_filterOpenNow) {
      stores = stores.where((s) => s.isOpenNow).toList();
    }

    if (_selectedSort == 'distance') {
      stores.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (_selectedSort == 'rating') {
      stores.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return stores;
  }

  void _onFilterTap(String filter) {
    setState(() {
      if (filter == 'openNow') {
        _filterOpenNow = !_filterOpenNow;
      } else if (filter == 'distance') {
        _selectedSort = _selectedSort == 'distance' ? null : 'distance';
      } else if (filter == 'rating') {
        _selectedSort = _selectedSort == 'rating' ? null : 'rating';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stores = _getFilteredStores();

    return Scaffold(
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onBack: widget.onBack ?? () => Navigator.of(context).pop(),
              onBag: widget.onBag,
              onNotification: widget.onNotification,
              elevated: true,
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.translate('nearbyStores'),
                  style: AppTypography.heading1,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FilterChip(
                    label: l10n.translate('openNow'),
                    selected: _filterOpenNow,
                    onTap: () => _onFilterTap('openNow'),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: l10n.translate('distance'),
                    selected: _selectedSort == 'distance',
                    onTap: () => _onFilterTap('distance'),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: l10n.translate('rating'),
                    selected: _selectedSort == 'rating',
                    onTap: () => _onFilterTap('rating'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Store list or shimmer
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: 6,
                      itemBuilder: (_, _) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _ShimmerCard(),
                      ),
                    )
                  : stores.isEmpty
                      ? _buildEmptyState(context, l10n)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: stores.length,
                          itemBuilder: (_, index) {
                            final store = stores[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _StoreCard(
                                store: store,
                                onTap: () => showStoreBottomSheet(context, store),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store_outlined,
              size: 56,
              color: AppColors.monoLightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.translate('noResultsFound'),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter Chip ──

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? AppColors.brass : AppColors.monoBlack)
              : (isDark ? AppColors.darkSurface : AppColors.monoLightGrey),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? (isDark ? AppColors.brass : AppColors.monoBlack)
                : AppColors.monoDivider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: selected
                ? (isDark ? AppColors.solidDark : AppColors.white)
                : (isDark ? AppColors.monoGrey : AppColors.monoBlack),
          ),
        ),
      ),
    );
  }
}

// ── Store Card ──

class _StoreCard extends StatelessWidget {
  final StoreInfo store;
  final VoidCallback onTap;

  const _StoreCard({
    required this.store,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          border: Border.all(color: AppColors.monoDivider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store icon circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.brassLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store_outlined,
                color: AppColors.brass,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Center info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store name
                  Text(
                    store.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Address
                  Text(
                    store.address,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.monoGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Distance + Rating row
                  Row(
                    children: [
                      Text(
                        '${store.distanceKm} ${l10n.translate('kmAway')}',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(width: 10),
                      RatingStars(rating: store.rating, size: 14),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Badges row
                  Wrap(
                    spacing: 8,
                    children: [
                      if (store.hasTryOn)
                        _Badge(
                          label: l10n.translate('tryOnInStore'),
                          color: AppColors.success,
                        ),
                      _Badge(
                        label: store.isOpenNow
                            ? l10n.translate('openNow')
                            : l10n.translate('closed'),
                        color: store.isOpenNow
                            ? AppColors.success
                            : AppColors.monoGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.monoGrey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge ──

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}

// ── Shimmer Card ──

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shimmerColor = AppColors.monoLightGrey
            .withValues(alpha: 0.3 + (_controller.value * 0.4));
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.monoDivider),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circle placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              // Text placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(
                      width: 180,
                      height: 16,
                      color: shimmerColor,
                    ),
                    const SizedBox(height: 8),
                    _ShimmerBox(
                      width: 250,
                      height: 12,
                      color: shimmerColor,
                    ),
                    const SizedBox(height: 8),
                    _ShimmerBox(
                      width: 130,
                      height: 14,
                      color: shimmerColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ShimmerBox(
                          width: 85,
                          height: 22,
                          color: shimmerColor,
                          borderRadius: 10,
                        ),
                        const SizedBox(width: 8),
                        _ShimmerBox(
                          width: 70,
                          height: 22,
                          color: shimmerColor,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
