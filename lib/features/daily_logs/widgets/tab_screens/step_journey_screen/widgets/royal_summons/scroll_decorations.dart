import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Subtle High Fae ornamental parchment divider flourish
class ScrollDivider extends StatelessWidget {
  final bool isSubtle;

  const ScrollDivider({super.key, this.isSubtle = false});

  @override
  Widget build(BuildContext context) {
    final color = isSubtle
        ? const Color(0xFF6B451B).withValues(alpha: 0.35)
        : const Color(0xFF5E3914).withValues(alpha: 0.65);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: isSubtle ? 36 : 48,
          height: 1.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.transparent, color]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            isSubtle ? '✦' : '✤ ✦ ✤',
            style: TextStyle(
              fontSize: isSubtle ? 8 : 10,
              color: color,
              letterSpacing: 2.0,
            ),
          ),
        ),
        Container(
          width: isSubtle ? 36 : 48,
          height: 1.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, Colors.transparent]),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for authentic aged High Fae parchment paper:
/// Includes natural weathering, darker scorched/aged vignette perimeter, subtle fiber stains, and organic deckled edge contours.
class ParchmentTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Darker Weathered Aged Perimeter Vignette (Dark Fae burnt edges)
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.0),
        radius: 1.05,
        colors: [
          Colors.transparent,
          const Color(0xFF4A2C0D).withValues(alpha: 0.08),
          const Color(0xFF381F08).withValues(alpha: 0.22),
          const Color(0xFF261204).withValues(alpha: 0.42),
        ],
        stops: const [0.0, 0.60, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), vignettePaint);

    // 2. Subtle organic paper aging / tea-stain patches
    final patchPaint = Paint()
      ..color = const Color(0xFF593610).withValues(alpha: 0.045)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    canvas.drawCircle(Offset(w * 0.22, h * 0.18), 38, patchPaint);
    canvas.drawCircle(Offset(w * 0.82, h * 0.45), 46, patchPaint);
    canvas.drawCircle(Offset(w * 0.35, h * 0.78), 54, patchPaint);

    // 3. Fine horizontal vellum fibers
    final fiberPaint = Paint()
      ..color = const Color(0xFF4A290A).withValues(alpha: 0.04)
      ..strokeWidth = 0.75;

    final random = math.Random(1337); // deterministic seed
    for (int i = 0; i < 35; i++) {
      final y = random.nextDouble() * h;
      final x1 = random.nextDouble() * w * 0.25;
      final x2 = x1 + random.nextDouble() * w * 0.55;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), fiberPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
