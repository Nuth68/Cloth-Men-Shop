import 'package:flutter/material.dart';

/// Steav Fashion logo — geometric "SF" mark + wordmark.
///
/// Available in named sizes: [small] (header), [medium] (login/register),
/// [large] (splash screen).
class SteavFashionLogo extends StatelessWidget {
  final double markSize;
  final double gap;
  final bool showSubtitle;
  final double wordmarkSize;
  final double wordmarkSpacing;
  final Color? color;

  const SteavFashionLogo({
    super.key,
    this.markSize = 40,
    this.gap = 12,
    this.color,
    this.showSubtitle = false,
    this.wordmarkSize = 16,
    this.wordmarkSpacing = 6,
  });

  /// Compact size for the header bar.
  factory SteavFashionLogo.small({Color? color}) {
    return SteavFashionLogo(
      markSize: 24,
      gap: 8,
      color: color,
      wordmarkSize: 13,
      wordmarkSpacing: 3,
    );
  }

  /// Medium size for login/register screens.
  factory SteavFashionLogo.medium({Color? color}) {
    return SteavFashionLogo(
      markSize: 44,
      gap: 14,
      color: color,
      wordmarkSize: 18,
      wordmarkSpacing: 4,
      showSubtitle: true,
    );
  }

  /// Large size for the splash screen.
  factory SteavFashionLogo.large({Color? color}) {
    return SteavFashionLogo(
      markSize: 64,
      gap: 18,
      color: color,
      wordmarkSize: 24,
      wordmarkSpacing: 8,
      showSubtitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SF geometric mark
        CustomPaint(
          size: Size(markSize, markSize),
          painter: _SFMarkPainter(color: c),
        ),
        SizedBox(height: gap),
        // Wordmark
        Text(
          'STEAV FASHION',
          style: TextStyle(
            fontFamily: 'Helvetica Neue',
            fontSize: wordmarkSize,
            fontWeight: FontWeight.w700,
            color: c,
            letterSpacing: wordmarkSpacing,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 6),
          Container(
            width: markSize * 0.5,
            height: 1,
            color: c.withValues(alpha: 0.4),
          ),
        ],
      ],
    );
  }
}

// ── SF geometric fashion mark ──
//
// A stylized monogram combining S + F into a single abstract mark
// inspired by fabric drape and tailoring — a flowing curve (S)
// intersecting a structural vertical (F).
class _SFMarkPainter extends CustomPainter {
  final Color color;

  _SFMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final strokeW = w * 0.11;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // ── Outer ring (fine, like a seal) ──
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      w / 2 - 1,
      ringPaint,
    );

    // ── S-curve (left side) — flowing fabric drape ──
    final sPath = Path();
    final cx = w * 0.48;
    final topY = h * 0.2;
    final botY = h * 0.78;

    sPath.moveTo(cx - w * 0.12, topY);
    sPath.cubicTo(
      cx - w * 0.16, h * 0.36,  // control 1
      cx + w * 0.08, h * 0.58,  // control 2
      cx - w * 0.06, botY,       // end
    );
    canvas.drawPath(sPath, paint);

    // ── F vertical (right side) — structural tailoring line ──
    final fV = w * 0.66;
    canvas.drawLine(
      Offset(fV, h * 0.15),
      Offset(fV, h * 0.88),
      paint,
    );

    // ── F top bar ──
    canvas.drawLine(
      Offset(fV, h * 0.15),
      Offset(w * 0.85, h * 0.15),
      paint,
    );

    // ── F middle bar (shorter) ──
    canvas.drawLine(
      Offset(fV, h * 0.48),
      Offset(w * 0.78, h * 0.48),
      paint,
    );

    // ── Accent dot (like a button/stud on a garment) ──
    canvas.drawCircle(
      Offset(w * 0.28, h * 0.62),
      strokeW * 0.6,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
