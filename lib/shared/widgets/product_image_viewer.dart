import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import 'shimmer_loading.dart';

class ProductImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final bool showDots;

  ProductImageViewer({
    super.key,
    required String imageUrl,
    this.height = 380,
    this.showDots = true,
  }) : imageUrls = [imageUrl];

  const ProductImageViewer.gallery({
    super.key,
    required this.imageUrls,
    this.height = 380,
    this.showDots = true,
  });

  @override
  State<ProductImageViewer> createState() => _ProductImageViewerState();
}

class _ProductImageViewerState extends State<ProductImageViewer> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, _) => ShimmerLoading.banner(
                    height: widget.height,
                  ),
                  errorWidget: (_, _, _) => Container(
                    decoration: AppDecorations.imagePlaceholder,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: AppColors.monoGrey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.imageUrls.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.imageUrls.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _currentPage == index;
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            ShimmerLoading.banner(height: 56),
                        errorWidget: (_, _, _) => Container(
                          decoration: AppDecorations.imagePlaceholder,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 20,
                            color: AppColors.monoGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        if (widget.showDots && widget.imageUrls.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == i ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppColors.monoBlack
                      : AppColors.monoDivider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
