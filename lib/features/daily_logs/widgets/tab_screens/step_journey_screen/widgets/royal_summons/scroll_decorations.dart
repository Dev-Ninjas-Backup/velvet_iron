import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Subtle ornamental parchment divider flourish
class ScrollDivider extends StatelessWidget {
  final bool isSubtle;

  const ScrollDivider({super.key, this.isSubtle = false});

  @override
  Widget build(BuildContext context) {
    final color = isSubtle
        ? const Color(0xFF7A4F1D).withValues(alpha: 0.25)
        : const Color(0xFF7A4F1D).withValues(alpha: 0.50);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 1.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, color],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.diamond_rounded,
            size: isSubtle ? 8 : 10,
            color: color,
          ),
        ),
        Container(
          width: 50,
          height: 1.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for antique parchment paper fiber and grain
class ParchmentTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Subtle horizontal aging fibers
    final fiberPaint = Paint()
      ..color = const Color(0xFF7A4B1A).withValues(alpha: 0.035)
      ..strokeWidth = 0.8;

    final random = math.Random(42); // deterministic seed for consistent grain
    for (int i = 0; i < 40; i++) {
      final y = random.nextDouble() * size.height;
      final x1 = random.nextDouble() * size.width * 0.3;
      final x2 = x1 + random.nextDouble() * size.width * 0.5;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), fiberPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
