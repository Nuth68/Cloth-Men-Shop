import 'package:flutter/material.dart';
import '../../../shared/widgets/monograph_header.dart';

const _black = Color(0xFF111111);
const _offWhite = Color(0xFFF5F4F0);
const _mid = Color(0xFF888888);

const _imgColors = [
  Color(0xFF3D3830),
  Color(0xFF5C4A3A),
  Color(0xFF2A2E35),
  Color(0xFF4A4040),
  Color(0xFF1E2228),
  Color(0xFF3B3530),
];

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
      backgroundColor: Colors.white,
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
              onFitChanged: (i) => setState(() => _fitIndex = i),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          'AUTUMN / WINTER 2024',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2.5,
            color: _mid,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The Motion of\nCraft',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.15,
            color: _black,
          ),
        ),
        const SizedBox(height: 6),
        Container(width: 30, height: 1.5, color: _black),
        const SizedBox(height: 16),
        Stack(
          children: [
            _PlaceholderImage(
              color: _imgColors[0],
              height: 240,
              width: double.infinity,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volume_off, color: Colors.white, size: 14),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'RUNWAY CLIP',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      letterSpacing: 2,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Structured\nFluidity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Georgia',
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Colors.white,
                child: const Text(
                  'SHOP \u2192',
                  style: TextStyle(
                    color: _black,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GridSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ShoppableImage(color: _imgColors[1], height: 200)),
              const SizedBox(width: 4),
              Expanded(child: _ShoppableImage(color: _imgColors[3], height: 200)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              _PlaceholderImage(
                color: _imgColors[2],
                height: 180,
                width: double.infinity,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.white,
                  child: const Text(
                    'BEHIND THE SCENES',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: _black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _ShoppableImage(color: _imgColors[4], height: 200)),
              const SizedBox(width: 4),
              Expanded(child: _ShoppableImage(color: _imgColors[5], height: 200)),
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
        _PlaceholderImage(color: color, height: height, width: double.infinity),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined, size: 14, color: _black),
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
      color: _offWhite,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'The Precision of Fit',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _black,
            ),
          ),
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
                  color: fitIndex == i ? _black : _mid,
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
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: selected ? _black : _mid,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text(
            '\u201cEngineered to drape perfectly on the frame,\nmaintaining its architectural integrity throughout\nthe day.\u201d',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.6,
              color: _black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

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
