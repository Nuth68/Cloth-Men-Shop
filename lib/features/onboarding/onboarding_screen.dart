import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/l10n/app_localizations.dart';
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

  List<_Slide> _buildSlides(AppLocalizations l10n) => [
        _Slide(
          title: l10n.translate('slideArchiveTitle'),
          subtitle: l10n.translate('slideArchiveSubtitle'),
          icon: Icons.archive_outlined,
        ),
        _Slide(
          title: l10n.translate('slideStylistTitle'),
          subtitle: l10n.translate('slideStylistSubtitle'),
          icon: Icons.design_services_outlined,
        ),
        _Slide(
          title: l10n.translate('slideCraftedTitle'),
          subtitle: l10n.translate('slideCraftedSubtitle'),
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
    final l10n = AppLocalizations.of(context);
    final slides = _buildSlides(l10n);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: false, 
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.translate('skip'),
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
                itemCount: slides.length,
                itemBuilder: (_, i) {
                  final slide = slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(slide.icon,
                            size: 72,
                           ),
                        const SizedBox(height: 48),
                        Text(slide.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.displayLarge
                                .copyWith(

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
              children: List.generate(slides.length, (i) {
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
                    borderRadius: BorderRadius.circular(12),
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
                label: _currentPage == slides.length - 1
                    ? l10n.translate('getStarted')
                    : l10n.translate('next'),
                onPressed: () async {
                  if (_currentPage < slides.length - 1) {
                    _pageController.nextPage(
                      duration:
                          const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    final cache = CacheService();
                    await cache.setOnboardingComplete();
                    if (!mounted) return;
                    if (!context.mounted) return;
                    context.go('/login');
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
