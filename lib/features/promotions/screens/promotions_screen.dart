import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../shared/widgets/monograph_header.dart';

class _CouponData {
  final String code;
  final String title;
  final String subtitle;
  final int expiryDays;
  final Color stripColor;

  const _CouponData({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.expiryDays,
    required this.stripColor,
  });
}

class _BannerData {
  final String title;
  final String subtitle;
  final String codeLabel;
  final String codeValue;
  final List<Color> gradientColors;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.codeLabel,
    required this.codeValue,
    required this.gradientColors,
  });
}

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoRotateTimer;

  static const _banners = [
    _BannerData(
      title: 'SUMMER SALE',
      subtitle: 'Up to 50% Off',
      codeLabel: 'Use code:',
      codeValue: 'SUMMER50',
      gradientColors: [Color(0xFFE8613C), Color(0xFFD4452A)],
    ),
    _BannerData(
      title: 'NEW ARRIVALS',
      subtitle: '15% Off First Order',
      codeLabel: 'Code:',
      codeValue: 'NEW15',
      gradientColors: [Color(0xFF2A2A2A), Color(0xFF111111)],
    ),
    _BannerData(
      title: 'FREE SHIPPING',
      subtitle: 'On Orders Over \$100',
      codeLabel: 'Code:',
      codeValue: 'FREESHIP',
      gradientColors: [Color(0xFF2D5A3D), Color(0xFF1B3A26)],
    ),
  ];

  static const _coupons = [
    _CouponData(
      code: 'SUMMER50',
      title: '50% OFF',
      subtitle: 'Summer Sale',
      expiryDays: 15,
      stripColor: Color(0xFFE8613C),
    ),
    _CouponData(
      code: 'NEW15',
      title: '15% OFF',
      subtitle: 'First Order',
      expiryDays: 30,
      stripColor: Color(0xFF111111),
    ),
    _CouponData(
      code: 'FREESHIP',
      title: 'FREE SHIP',
      subtitle: 'Orders over \$100',
      expiryDays: 7,
      stripColor: Color(0xFF2D5A3D),
    ),
    _CouponData(
      code: 'FLASH30',
      title: '30% OFF',
      subtitle: 'Outerwear',
      expiryDays: 3,
      stripColor: Color(0xFFD4A017),
    ),
    _CouponData(
      code: 'WELCOME10',
      title: '\$10 OFF',
      subtitle: 'Orders over \$50',
      expiryDays: 60,
      stripColor: Color(0xFF5A6570),
    ),
    _CouponData(
      code: 'VIP25',
      title: '25% OFF',
      subtitle: 'Everything',
      expiryDays: 10,
      stripColor: Color(0xFFC8A96E),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoRotate();
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoRotate() {
    _autoRotateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translate('codeCopied')),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.monoOffWhite;

    return Scaffold(
      backgroundColor: bg,
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
                    _buildCarousel(),
                    _buildCouponsHeader(l10n),
                    ..._coupons.map(
                      (c) => _buildCouponCard(c, l10n, isDark),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.discount,
                        size: 100,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner.title,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner.subtitle,
                            style: AppTypography.heading1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${banner.codeLabel} ',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  banner.codeValue,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppColors.monoBlack
                    : AppColors.monoDivider,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCouponsHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(
        l10n.translate('availableCoupons'),
        style: AppTypography.heading2,
      ),
    );
  }

  Widget _buildCouponCard(
    _CouponData coupon,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: AppDecorations.card(context),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left colored strip
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: coupon.stripColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + discount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon.title,
                                style: AppTypography.heading2.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                coupon.subtitle,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.monoGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Code box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.monoLightGrey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.confirmation_number_outlined,
                              size: 16, color: coupon.stripColor),
                          const SizedBox(width: 8),
                          Text(
                            coupon.code,
                            style: AppTypography.bodyMedium.copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: coupon.stripColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Expiry + Add Card button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14,
                                color: coupon.expiryDays <= 5
                                    ? AppColors.error
                                    : AppColors.monoGrey),
                            const SizedBox(width: 4),
                            Text(
                              '${coupon.expiryDays} ${l10n.translate('days')}',
                              style: AppTypography.bodySmall.copyWith(
                                color: coupon.expiryDays <= 5
                                    ? AppColors.error
                                    : AppColors.monoGrey,
                                fontWeight: coupon.expiryDays <= 5
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _copyCode(coupon.code);
                              context.push('/shop');
                            },
                            icon: const Icon(Icons.add_card, size: 18),
                            label: Text(l10n.translate('addToCart')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: coupon.stripColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
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
