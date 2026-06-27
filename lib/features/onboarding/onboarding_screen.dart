import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/custom_button.dart';
import '../../data/datasources/local/cache_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _Slide(
      title: 'The Archive\nAwaits',
      subtitle:
          'Discover meticulously curated pieces designed to outlast the season.',
      icon: Icons.archive_outlined,
    ),
    _Slide(
      title: 'Your Personal\nStylist',
      subtitle:
          'Book one-on-one consultations with expert stylists who understand your language.',
      icon: Icons.design_services_outlined,
    ),
    _Slide(
      title: 'Crafted to\nPerfection',
      subtitle:
          'Every piece is a documented study in silhouette, material, and movement.',
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.monoOffWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text('SKIP',
                    style: AppTypography.labelSmall.copyWith(
                        color: AppColors.monoGrey)),
              ),
            ),
            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) =>
                    setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(slide.icon,
                            size: 72,
                            color: AppColors.monoBlack),
                        const SizedBox(height: 48),
                        Text(slide.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.displayLarge
                                .copyWith(
                                    color: AppColors.monoBlack,
                                    letterSpacing: 2)),
                        const SizedBox(height: 20),
                        Text(slide.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyLarge
                                .copyWith(
                                    color: AppColors.monoGrey,
                                    height: 1.5)),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.monoBlack
                        : AppColors.monoDivider,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // CTA
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 16),
              child: CustomButton(
                label: _currentPage == _slides.length - 1
                    ? 'GET STARTED'
                    : 'NEXT',
                onPressed: () async {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration:
                          const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    final cache = CacheService();
                    await cache.setOnboardingComplete();
                    if (mounted) context.go('/login');
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final String title, subtitle;
  final IconData icon;
  const _Slide({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
