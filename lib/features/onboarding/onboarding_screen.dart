import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to StyleThread', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.charcoal)),
            const SizedBox(height: 16),
            const Text('Discover your perfect style', style: TextStyle(fontSize: 16, color: AppColors.warmGray)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
              child: const Text('Get Started', style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
