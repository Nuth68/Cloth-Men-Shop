import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
<<<<<<< Updated upstream
import '../../shared/widgets/steav_fashion_logo.dart';
=======
import '../../core/theme/app_typography.dart';
>>>>>>> Stashed changes
import '../../data/datasources/local/cache_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFadeSlide;
<<<<<<< Updated upstream
=======
  late final Animation<double> _lineExpand;
  late final Animation<double> _subtitleFade;
>>>>>>> Stashed changes
  late final Animation<double> _screenFadeOut;
  bool _isCheckingOnboarding = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _logoFadeSlide = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
<<<<<<< Updated upstream
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
=======
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );

    _lineExpand = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOutCubic),
>>>>>>> Stashed changes
      ),
    );

    _screenFadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _checkOnboarding();
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _navigate();
      }
    });
  }

  Future<void> _checkOnboarding() async {
    final cache = CacheService();
    final complete = await cache.isOnboardingComplete();
    if (mounted) {
      setState(() => _isCheckingOnboarding = !complete);
    }
  }

  void _navigate() {
    if (!mounted) return;
    if (_isCheckingOnboarding) {
      context.go('/onboarding');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _screenFadeOut,
      child: Scaffold(
        backgroundColor: AppColors.monoOffWhite,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
<<<<<<< Updated upstream
                  // Steav Fashion logo with SF mark
=======
                  // "MONOGRAPH" logo
>>>>>>> Stashed changes
                  Opacity(
                    opacity: _logoFadeSlide.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _logoFadeSlide.value) * 20),
<<<<<<< Updated upstream
                      child: SteavFashionLogo.large(),
=======
                      child: Text(
                        'MONOGRAPH',
                        style: AppTypography.displayLarge.copyWith(
                          color: AppColors.monoBlack,
                          letterSpacing: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Expanding line
                  SizedBox(
                    width: 120,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _lineExpand.value,
                        child: Container(
                          height: 1,
                          color: AppColors.monoBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // "THE ARCHIVE" subtitle
                  Opacity(
                    opacity: _subtitleFade.value,
                    child: Text(
                      'THE ARCHIVE',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.monoGrey,
                        letterSpacing: 6,
                      ),
>>>>>>> Stashed changes
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
