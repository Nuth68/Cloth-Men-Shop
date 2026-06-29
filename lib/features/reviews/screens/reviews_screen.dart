import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../data/datasources/remote/graphql_service.dart';
import '../../../data/datasources/local/cache_service.dart';
import '../../../core/constants/api_config.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/fit_feedback_bar.dart';

class _ReviewData {
  final String name;
  final String date;
  final double rating;
  final String text;
  final String? size;
  final String? color;

  const _ReviewData({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
    this.size,
    this.color,
  });
}

class _StarDistribution {
  final int stars;
  final int count;

  const _StarDistribution({required this.stars, required this.count});
}

class ReviewsScreen extends StatefulWidget {
  final ProductModel? product;

  const ReviewsScreen({super.key, this.product});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<_ReviewData> _reviews = [];
  List<_StarDistribution> _distributions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final cache = CacheService();
      final gql = GraphqlService(baseUrls: ApiConfig.baseUrls, cache: cache);
      final repo = ReviewRepository(gql);
      final productId = widget.product?.id ?? '0';
      final reviews = await repo.getReviews(productId);
      if (!mounted) return;
      // Convert ReviewModel to _ReviewData for UI compatibility
      final data = reviews.map((r) => _ReviewData(
        name: r.userName ?? 'Customer',
        date: _formatDate(r.createdAt),
        rating: r.rating,
        text: r.comment ?? '',
        size: r.size,
        color: r.color,
      )).toList();
      // Compute star distributions
      final dists = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      for (final r in reviews) { dists[r.rating.round()] = (dists[r.rating.round()] ?? 0) + 1; }
      setState(() {
        _reviews = data;
        _distributions = dists.entries.map((e) => _StarDistribution(stars: e.key, count: e.value)).toList()..sort((a, b) => b.stars.compareTo(a.stars));
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() { _reviews = []; _distributions = []; _loading = false; });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays < 1) return 'Today';
    if (diff.inDays < 2) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  double get _averageRating {
    int totalCount = 0;
    double totalStars = 0;
    for (final d in _distributions) {
      totalCount += d.count;
      totalStars += d.stars * d.count;
    }
    return totalCount > 0
        ? double.parse((totalStars / totalCount).toStringAsFixed(1))
        : 0.0;
  }

  int get _totalReviews {
    int total = 0;
    for (final d in _distributions) {
      total += d.count;
    }
    return total;
  }

  int get _maxCount => _distributions.isNotEmpty ? _distributions.first.count : 1;

  void _showWriteReviewSheet() {
    final l10n = AppLocalizations.of(context);
    int selectedRating = 0;
    final reviewController = TextEditingController();
    String selectedSize = 'M';
    String selectedFit = 'trueToSize';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (builderContext, setSheetState) {
            final isDark =
                Theme.of(builderContext).brightness == Brightness.dark;
            final bg = isDark ? AppColors.darkSurface : AppColors.white;

            return Container(
              height: MediaQuery.of(builderContext).size.height * 0.75,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.monoDivider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(builderContext),
                          child: Text(
                            'Cancel',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.monoGrey,
                            ),
                          ),
                        ),
                        Text(
                          l10n.translate('writeReview'),
                          style: AppTypography.heading2,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(builderContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Review submitted!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text(
                            l10n.translate('submitReview'),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.brass,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('yourRating'),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (i) {
                              return GestureDetector(
                                onTap: () =>
                                    setSheetState(() => selectedRating = i + 1),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Icon(
                                    i < selectedRating
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    size: 36,
                                    color: i < selectedRating
                                        ? AppColors.warning
                                        : AppColors.monoDivider,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.translate('yourReview'),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: reviewController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Share your thoughts...',
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: AppColors.monoGrey,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.darkCard
                                  : AppColors.monoOffWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.translate('sizePurchased'),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.monoOffWhite,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedSize,
                                isExpanded: true,
                                items: ['XS', 'S', 'M', 'L', 'XL', 'XXL']
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setSheetState(
                                      () => selectedSize = v,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.translate('fitFeedback'),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildFitChip(
                                label: l10n.translate('runsSmall'),
                                selected: selectedFit == 'runsSmall',
                                onTap: () => setSheetState(
                                  () => selectedFit = 'runsSmall',
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildFitChip(
                                label: l10n.translate('trueToSize'),
                                selected: selectedFit == 'trueToSize',
                                onTap: () => setSheetState(
                                  () => selectedFit = 'trueToSize',
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildFitChip(
                                label: l10n.translate('runsLarge'),
                                selected: selectedFit == 'runsLarge',
                                onTap: () => setSheetState(
                                  () => selectedFit = 'runsLarge',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFitChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.monoBlack : AppColors.monoOffWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.monoBlack : AppColors.monoDivider,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: selected ? AppColors.white : AppColors.monoGrey,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.monoOffWhite;
    final product = widget.product;

    if (_loading) {
      return Scaffold(backgroundColor: bg, body: const Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  isDark ? AppColors.white : AppColors.monoBlack,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: EmptyStateWidget(
          state: EmptyState.empty,
          title: 'No product selected',
          message: 'Please select a product to view reviews.',
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showWriteReviewSheet,
        backgroundColor: AppColors.monoBlack,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: Text(
          l10n.translate('writeReview'),
          style: AppTypography.button.copyWith(color: AppColors.white),
        ),
      ),
      body: SafeArea(top: false, 
        child: Column(
          children: [
            MonographHeader(
              onBack: () => context.pop(),
              onBag: () => context.push('/cart'),
              onNotification: () => context.push('/notifications'),
              elevated: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductHeader(product, isDark),
                    _buildSummaryCard(l10n, isDark),
                    _buildFitFeedbackSection(l10n),
                    _buildReviewsHeader(l10n),
                    ..._reviews.map(
                      (r) => _buildReviewCard(r, l10n, isDark),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader(ProductModel product, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.imageUrl,
              width: 64,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 80,
                color: AppColors.monoLightGrey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTypography.heading2.copyWith(
                    color: isDark ? AppColors.white : AppColors.monoBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.brand,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.monoGrey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTypography.price.copyWith(
                    fontSize: 16,
                    color: isDark ? AppColors.white : AppColors.monoBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AppLocalizations l10n, bool isDark) {
    final avg = _averageRating;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardElevated(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                avg.toString(),
                style: AppTypography.heading1.copyWith(fontSize: 48),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      final filled = i < avg.floor();
                      final half = !filled && i < avg.ceil() && avg % 1 >= 0.3;
                      return Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          filled
                              ? Icons.star_rounded
                              : half
                                  ? Icons.star_half_rounded
                                  : Icons.star_outline_rounded,
                          size: 20,
                          color: AppColors.warning,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.translate('basedOn')} $_totalReviews ${l10n.translate('reviews')}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.monoGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ..._distributions.map((d) => _buildDistributionRow(d)),
        ],
      ),
    );
  }

  Widget _buildDistributionRow(_StarDistribution dist) {
    final fraction = _maxCount > 0 ? dist.count / _maxCount : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '${dist.stars} ★',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.monoGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: fraction),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox(
                    height: 10,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                AppColors.monoDivider.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              '${dist.count}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.monoGrey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitFeedbackSection(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('fitFeedback'),
            style: AppTypography.heading2,
          ),
          const SizedBox(height: 16),
          const FitFeedbackBar(
            items: [
              FitFeedbackItem(
                label: 'Runs Small',
                percentage: 15,
                color: AppColors.warning,
              ),
              FitFeedbackItem(
                label: 'True to Size',
                percentage: 68,
                color: AppColors.success,
              ),
              FitFeedbackItem(
                label: 'Runs Large',
                percentage: 17,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_reviews.length} ${l10n.translate('reviews')}',
            style: AppTypography.heading2,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
      _ReviewData review, AppLocalizations l10n, bool isDark) {
    final avatarBg = _avatarColors[review.name.hashCode % _avatarColors.length];
    final initial = review.name.isNotEmpty ? review.name[0] : '?';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: avatarBg,
                child: Text(
                  initial,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      review.date,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.monoGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) {
                      final filled = i < review.rating.floor();
                      final half = !filled &&
                          i < review.rating.ceil() &&
                          review.rating % 1 >= 0.3;
                      return Icon(
                        filled
                            ? Icons.star_rounded
                            : half
                                ? Icons.star_half_rounded
                                : Icons.star_outline_rounded,
                        size: 14,
                        color: AppColors.warning,
                      );
                    }),
                  ),
                  if (true) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 12,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.translate('verifiedPurchase'),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.success,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.text,
            style: AppTypography.bodyMedium.copyWith(
              height: 1.5,
            ),
          ),
          if (review.size != null || review.color != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (review.size != null) ...[
                  _buildInfoChip(
                    '${l10n.translate('size')}: ${review.size}',
                  ),
                  const SizedBox(width: 8),
                ],
                if (review.color != null)
                  _buildInfoChip('Color: ${review.color}'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.monoOffWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.monoDivider,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.monoGrey,
          fontSize: 10,
        ),
      ),
    );
  }

  static const _avatarColors = [
    Color(0xFFE8613C),
    Color(0xFF2D5A3D),
    Color(0xFFC8A96E),
    Color(0xFF5A6570),
    Color(0xFFB94040),
    Color(0xFFD4A017),
    Color(0xFF1E3A5F),
    Color(0xFF7B2D8E),
  ];
}
