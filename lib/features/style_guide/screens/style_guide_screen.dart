import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:cached_network_image/cached_network_image.dart';
=======
>>>>>>> Stashed changes
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';
<<<<<<< Updated upstream
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_item.dart';
=======
>>>>>>> Stashed changes

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  // ── Editorial looks data ──
  static const _looks = [
    _Look(
      title: 'The\nTailoring\nArchive',
      subtitle: 'VOL. 04',
      image: 'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=600&q=80',
      height: 420,
      tag: 'BLAZERS',
    ),
    _Look(
      title: 'Soft\nStructures',
      subtitle: 'KNITWEAR',
      image: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&q=80',
      height: 340,
      tag: 'KNITS',
    ),
    _Look(
      title: 'Urban\nSilhouette',
      subtitle: 'STREET EDIT',
      image: 'https://images.unsplash.com/photo-1516820827855-3ea1bd6f79ea?w=600&q=80',
      height: 380,
      tag: 'CASUAL',
    ),
    _Look(
      title: 'Evening\nDeco',
      subtitle: 'AFTER DARK',
      image: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600&q=80',
      height: 360,
      tag: 'FORMAL',
    ),
    _Look(
      title: 'Weekend\nEdit',
      subtitle: 'OFF DUTY',
      image: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&q=80',
      height: 400,
      tag: 'CASUAL',
    ),
    _Look(
      title: 'Coastal\nDrift',
      subtitle: 'RESORT 25',
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&q=80',
      height: 320,
      tag: 'RESORT',
    ),
    _Look(
      title: 'The\nModernist',
      subtitle: 'MINIMAL',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80',
      height: 440,
      tag: 'FORMAL',
    ),
    _Look(
      title: 'Layer\nReport',
      subtitle: 'OUTERWEAR',
      image: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=600&q=80',
      height: 350,
      tag: 'OUTERWEAR',
    ),
    _Look(
      title: 'Textile\nStudy',
      subtitle: 'FABRIC FOCUS',
      image: 'https://images.unsplash.com/photo-1523381294911-8d3cead13475?w=600&q=80',
      height: 300,
      tag: 'EDITORIAL',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      backgroundColor: AppColors.monoOffWhite,
=======
      backgroundColor: AppColors.white,
>>>>>>> Stashed changes
      body: SafeArea(
        child: Column(
          children: [
            const MonographHeader(elevated: true),
            Expanded(
<<<<<<< Updated upstream
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
                            _buildCategoryChips(),
                            const SizedBox(height: 28),
                            // ── Masonry-style look grid ──
                            _buildLookGrid(),
                            const SizedBox(height: 40),
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
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800&q=80',
            fit: BoxFit.cover,
            placeholder: (_, __) => ShimmerLoading.banner(height: 200),
            errorWidget: (_, __, ___) => Container(color: AppColors.monoBlack),
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
                  'THE EDIT',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white70,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Autumn / Winter\n2024 Lookbook',
                  style: AppTypography.serif(22, weight: FontWeight.w700, color: AppColors.white, height: 1.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Category chips ──
  Widget _buildCategoryChips() {
    final tags = ['ALL', 'BLAZERS', 'KNITS', 'FORMAL', 'CASUAL', 'OUTERWEAR', 'EDITORIAL', 'RESORT'];
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final selected = i == 0;
            return GestureDetector(
              onTap: () => AppHaptics.selection(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.monoBlack : AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected ? AppColors.monoBlack : AppColors.monoDivider,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  tags[i],
                  style: AppTypography.labelSmall.copyWith(
                    color: selected ? AppColors.white : AppColors.monoBlack,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Quilted look grid (alternating 2-col / 1-col) ──
  Widget _buildLookGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate((_looks.length / 2).ceil(), (row) {
          final i = row * 2;
          // Every 3rd row: full-span hero card
          if (row % 3 == 0 && i < _looks.length) {
            final look = _looks[i];
            return AnimatedListItem(
              index: i,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _LookCardWide(look: look),
              ),
            );
          }
          // Normal: 2-column row
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (i < _looks.length)
                  Expanded(
                    child: AnimatedListItem(
                      index: i,
                      child: _LookCard(look: _looks[i]),
                    ),
                  ),
                const SizedBox(width: 14),
                if (i + 1 < _looks.length)
                  Expanded(
                    child: AnimatedListItem(
                      index: i + 1,
                      child: _LookCard(look: _looks[i + 1]),
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Data class ──
class _Look {
  final String title, subtitle, image, tag;
  final double height;
  const _Look({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.height,
    required this.tag,
  });
}

// ── Standard look card (2-col) ──
class _LookCard extends StatelessWidget {
  final _Look look;
  const _LookCard({required this.look});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppHaptics.light(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: look.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: look.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => ShimmerLoading.productCard(height: look.height),
                errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 14, bottom: 16, right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(look.subtitle,
                          style: AppTypography.labelSmall.copyWith(
                              color: Colors.white70, letterSpacing: 2)),
                    ),
                    const SizedBox(height: 8),
                    Text(look.title,
                        style: AppTypography.serif(16, weight: FontWeight.w700, color: AppColors.white, height: 1.15)),
=======
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _HeroSection(),
                    const SizedBox(height: 4),
                    _GridSection(),
                    const SizedBox(height: 32),
                    _FitSection(
                      fitIndex: _fitIndex,
                      onFitChanged: (i) {
                        AppHaptics.selection();
                        setState(() => _fitIndex = i);
                      },
                    ),
                    const SizedBox(height: 40),
>>>>>>> Stashed changes
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

<<<<<<< Updated upstream
// ── Wide hero look card (full-span) ──
class _LookCardWide extends StatelessWidget {
  final _Look look;
  const _LookCardWide({required this.look});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppHaptics.light(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: look.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => ShimmerLoading.banner(height: 280),
                errorWidget: (_, __, ___) => Container(color: AppColors.monoLightGrey),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 20, bottom: 24, right: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('EDITORIAL',
                                style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white70, letterSpacing: 2)),
                          ),
                          const SizedBox(height: 8),
                          Text(look.title,
                              style: AppTypography.serif(22, weight: FontWeight.w700, color: AppColors.white, height: 1.12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_forward, size: 18, color: AppColors.monoBlack),
                    ),
                  ],
=======
class _HeroSection extends StatelessWidget {
  static const _imgColors = Color(0xFF3D3830);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'AUTUMN / WINTER 2024',
          style: AppTypography.labelSmall.copyWith(
            letterSpacing: 2.5,
            color: AppColors.monoGrey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'The Motion of\nCraft',
          textAlign: TextAlign.center,
          style: AppTypography.displayLarge.copyWith(
            color: AppColors.monoBlack,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
            width: 30, height: 1.5, color: AppColors.monoBlack),
        const SizedBox(height: 16),
        Stack(
          children: [
            _PlaceholderImage(
              color: _imgColors,
              height: 240,
              width: double.infinity,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volume_off,
                    color: Colors.white, size: 14),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RUNWAY CLIP',
                      style: AppTypography.labelSmall.copyWith(
                          color: Colors.white70, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text('Structured\nFluidity',
                      style: AppTypography.displayMedium.copyWith(
                          color: AppColors.white)),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                color: AppColors.white,
                child: Text('SHOP →',
                    style: AppTypography.button.copyWith(
                        color: AppColors.monoBlack)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GridSection extends StatelessWidget {
  static const _imgColors = [
    Color(0xFF5C4A3A),
    Color(0xFF4A4040),
    Color(0xFF2A2E35),
    Color(0xFF3B3530),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ShoppableImage(color: _imgColors[0], height: 200)),
              const SizedBox(width: 4),
              Expanded(child: _ShoppableImage(color: _imgColors[2], height: 200)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              _PlaceholderImage(
                color: _imgColors[1],
                height: 180,
                width: double.infinity,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  color: Colors.white,
                  child: Text('BEHIND THE SCENES',
                      style: AppTypography.labelSmall.copyWith(
                          color: AppColors.monoBlack)),
>>>>>>> Stashed changes
                ),
              ),
            ],
          ),
<<<<<<< Updated upstream
=======
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _ShoppableImage(color: _imgColors[3], height: 200)),
              const SizedBox(width: 4),
              Expanded(child: _ShoppableImage(color: _imgColors[0], height: 200)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShoppableImage extends StatelessWidget {
  final Color color;
  final double height;
  const _ShoppableImage({required this.color, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _PlaceholderImage(
            color: color, height: height, width: double.infinity),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 14, color: AppColors.monoBlack),
          ),
        ),
      ],
    );
  }
}

class _FitSection extends StatelessWidget {
  final int fitIndex;
  final ValueChanged<int> onFitChanged;
  const _FitSection({required this.fitIndex, required this.onFitChanged});

  static const _labels = ['RUNS SMALL', 'TRUE TO SIZE', 'RUNS LARGE'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.monoOffWhite,
      padding:
          const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Text('The Precision of Fit',
              style: AppTypography.heading1.copyWith(
                  color: AppColors.monoBlack)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                width: fitIndex == i ? 8 : 6,
                height: fitIndex == i ? 8 : 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fitIndex == i
                      ? AppColors.monoBlack
                      : AppColors.monoGrey,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) {
              final selected = fitIndex == i;
              return GestureDetector(
                onTap: () => onFitChanged(i),
                child: Text(
                  _labels[i],
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w400,
                    color: selected
                        ? AppColors.monoBlack
                        : AppColors.monoGrey,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            '"Engineered to drape perfectly on the frame,\nmaintaining its architectural integrity throughout\nthe day."',
            textAlign: TextAlign.center,
            style: AppTypography.serif(13,
                height: 1.6,
                color: AppColors.monoBlack).copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final Color color;
  final double height, width;
  const _PlaceholderImage({
    required this.color,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.black, 0.4)!,
          ],
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}
