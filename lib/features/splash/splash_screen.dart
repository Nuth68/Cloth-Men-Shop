import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/steav_fashion_logo.dart';
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
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Steav Fashion logo with SF mark
                  Opacity(
                    opacity: _logoFadeSlide.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _logoFadeSlide.value) * 20),
                      child: SteavFashionLogo.large(),
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
