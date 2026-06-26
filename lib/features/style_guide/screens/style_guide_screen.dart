import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptics.dart';
import '../../../shared/widgets/monograph_header.dart';

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  int _fitIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const MonographHeader(),
            Expanded(
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
                ),
              ),
            ],
          ),
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
        ),
      ),
    );
  }
}
