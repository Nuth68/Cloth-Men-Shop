import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kBg = Color(0xFFF2F1EF);
const _kBlack = Color(0xFF0D0D0D);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'MONOGRAPH',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: _kBlack,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: _kBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
