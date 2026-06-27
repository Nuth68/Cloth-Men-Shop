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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  // ── Editorial looks data ──
  static const _looks = [
    _Look(
      title: 'The\nTailoring\nArchive',
      subtitle: 'VOL. 04',
      image: 'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=600&q=80',
      height: 420,
      tag: 'BLAZERS',
    ),
    _Look(
      title: 'Soft\nStructures',
      subtitle: 'KNITWEAR',
      image: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&q=80',
      height: 340,
      tag: 'KNITS',
    ),
    _Look(
      title: 'Urban\nSilhouette',
      subtitle: 'STREET EDIT',
      image: 'https://images.unsplash.com/photo-1516820827855-3ea1bd6f79ea?w=600&q=80',
      height: 380,
      tag: 'CASUAL',
    ),
    _Look(
      title: 'Evening\nDeco',
      subtitle: 'AFTER DARK',
      image: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600&q=80',
      height: 360,
      tag: 'FORMAL',
    ),
    _Look(
      title: 'Weekend\nEdit',
      subtitle: 'OFF DUTY',
      image: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&q=80',
      height: 400,
      tag: 'CASUAL',
    ),
    _Look(
      title: 'Coastal\nDrift',
      subtitle: 'RESORT 25',
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&q=80',
      height: 320,
      tag: 'RESORT',
    ),
    _Look(
      title: 'The\nModernist',
      subtitle: 'MINIMAL',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80',
      height: 440,
      tag: 'FORMAL',
    ),
    _Look(
      title: 'Layer\nReport',
      subtitle: 'OUTERWEAR',
      image: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=600&q=80',
      height: 350,
      tag: 'OUTERWEAR',
    ),
    _Look(
      title: 'Textile\nStudy',
      subtitle: 'FABRIC FOCUS',
      image: 'https://images.unsplash.com/photo-1523381294911-8d3cead13475?w=600&q=80',
      height: 300,
      tag: 'EDITORIAL',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MonographHeader(elevated: true),
            Expanded(
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
