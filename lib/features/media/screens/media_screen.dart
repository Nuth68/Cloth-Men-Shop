import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/monograph_header.dart';
import '../../../shared/widgets/shimmer_loading.dart';

// ────────────────────────────────────────────────────────────
// Mock data
// ────────────────────────────────────────────────────────────

final List<_PhotoItem> _photoItems = [
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1467043237213-65f2da53396f?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600&q=80',
    aspectRatio: 3 / 4.5,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1479064555552-3ef4979f8908?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=600&q=80',
    aspectRatio: 3 / 4.5,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1560243563-062bfc001d68?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1446214814726-e6074845b4ce?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=600&q=80',
    aspectRatio: 3 / 4.5,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1554568218-0f1715e72254?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1520975916090-3105956dac38?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1505022610485-0249ba5b3675?w=600&q=80',
    aspectRatio: 3 / 4.5,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1492447166138-50c3889fccb1?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1564584217132-2271feaeb3c5?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1558769132-cb5aea458c5e?w=600&q=80',
    aspectRatio: 3 / 4,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1605518216938-7c31b7b14ad0?w=600&q=80',
    aspectRatio: 3 / 4.5,
  ),
  _PhotoItem(
    imageUrl:
        'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=600&q=80',
    aspectRatio: 2 / 3,
  ),
];

class _PhotoItem {
  final String imageUrl;
  final double aspectRatio;
  const _PhotoItem({required this.imageUrl, required this.aspectRatio});
}

final List<_VideoItem> _videoItems = [
  _VideoItem(
    title: 'Spring/Summer Runway',
    duration: '3:42',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=400&q=80',
  ),
  _VideoItem(
    title: 'Behind the Scenes',
    duration: '5:18',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=400&q=80',
  ),
  _VideoItem(
    title: 'Styling Tips: Blazers',
    duration: '2:55',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
  ),
  _VideoItem(
    title: 'Fall/Winter Preview',
    duration: '4:10',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=400&q=80',
  ),
  _VideoItem(
    title: 'Craftsmanship Series',
    duration: '6:32',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1560243563-062bfc001d68?w=400&q=80',
  ),
  _VideoItem(
    title: 'Editorial: Urban Edge',
    duration: '2:18',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1446214814726-e6074845b4ce?w=400&q=80',
  ),
  _VideoItem(
    title: 'Accessories Guide',
    duration: '4:05',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400&q=80',
  ),
  _VideoItem(
    title: 'Lookbook Launch 2026',
    duration: '3:28',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1554568218-0f1715e72254?w=400&q=80',
  ),
];

class _VideoItem {
  final String title;
  final String duration;
  final String thumbnailUrl;
  const _VideoItem({
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
  });
}

// ────────────────────────────────────────────────────────────
// MediaScreen
// ────────────────────────────────────────────────────────────

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openViewer(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _MediaViewerScreen(
          items: _photoItems,
          initialIndex: index,
        ),
      ),
    );
  }

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
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.monoLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.monoGrey,
                labelStyle: AppTypography.labelLarge,
                dividerHeight: 0,
                tabAlignment: TabAlignment.fill,
                tabs: [
                  Tab(text: l10n.translate('photos')),
                  Tab(text: l10n.translate('videos')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? _buildShimmer()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _PhotosTab(onTap: _openViewer),
                        const _VideosTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ShimmerLoading.productGrid(count: 8, crossAxisCount: 2),
    );
  }
}

// ────────────────────────────────────────────────────────────
// Photos Tab — Masonry / Staggered Grid
// ────────────────────────────────────────────────────────────

class _PhotosTab extends StatelessWidget {
  final void Function(int index) onTap;
  const _PhotosTab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final left = <_PhotoItem>[];
    final right = <_PhotoItem>[];
    for (int i = 0; i < _photoItems.length; i++) {
      if (i % 2 == 0) {
        left.add(_photoItems[i]);
      } else {
        right.add(_photoItems[i]);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _PhotoColumn(items: left, onTap: onTap)),
          const SizedBox(width: 10),
          Expanded(child: _PhotoColumn(items: right, onTap: onTap)),
        ],
      ),
    );
  }
}

class _PhotoColumn extends StatelessWidget {
  final List<_PhotoItem> items;
  final void Function(int index) onTap;
  const _PhotoColumn({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final globalIndex = _photoItems.indexOf(item);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _MasonryCard(
            item: item,
            heroTag: 'photo_$globalIndex',
            onTap: () => onTap(globalIndex),
          ),
        );
      }).toList(),
    );
  }
}

class _MasonryCard extends StatelessWidget {
  final _PhotoItem item;
  final String heroTag;
  final VoidCallback onTap;
  const _MasonryCard({
    required this.item,
    required this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: item.aspectRatio,
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                color: AppColors.monoLightGrey,
              ),
              errorWidget: (_, _, _) => Container(
                color: AppColors.monoLightGrey,
                child: const Icon(Icons.broken_image_outlined,
                    color: AppColors.monoGrey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// Videos Tab
// ────────────────────────────────────────────────────────────

class _VideosTab extends StatelessWidget {
  const _VideosTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_videoItems.isEmpty) {
      return Center(
        child: Text(l10n.translate('noProducts'),
            style: AppTypography.bodyMedium.copyWith(color: AppColors.monoGrey)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: _videoItems.length,
      itemBuilder: (context, index) {
        final video = _videoItems[index];
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate('videoPlaybackComingSoon')),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: video.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: AppColors.monoLightGrey,
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.monoLightGrey,
                          child: const Icon(Icons.broken_image_outlined,
                              color: AppColors.monoGrey),
                        ),
                      ),
                      // Dark overlay
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                video.title,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                video.duration,
                style: AppTypography.caption.copyWith(
                  color: AppColors.monoGrey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────
// Full-Screen Viewer
// ────────────────────────────────────────────────────────────

class _MediaViewerScreen extends StatefulWidget {
  final List<_PhotoItem> items;
  final int initialIndex;

  const _MediaViewerScreen({
    required this.items,
    required this.initialIndex,
  });

  @override
  State<_MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<_MediaViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.items.length}',
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return SafeArea(
            child: Hero(
              tag: 'photo_$index',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (_, _, _) => const Center(
                      child: Icon(Icons.broken_image_outlined,
                          color: Colors.white54, size: 48),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
