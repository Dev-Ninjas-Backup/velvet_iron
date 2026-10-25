import 'package:flutter/material.dart';

/// Authentic Physical Stamped Crimson Wax Seal with Crown & Silk Ribbons
class CrimsonWaxSeal extends StatelessWidget {
  const CrimsonWaxSeal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 58,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Twin Draping Silk Ribbons
          Positioned(
            top: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left Ribbon
                Transform.rotate(
                  angle: -0.15,
                  child: CustomPaint(
                    size: const Size(12, 36),
                    painter: NotchedRibbonPainter(
                      color: const Color(0xFF7A1212),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Right Ribbon
                Transform.rotate(
                  angle: 0.18,
                  child: CustomPaint(
                    size: const Size(12, 38),
                    painter: NotchedRibbonPainter(
                      color: const Color(0xFF8F1717),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3D Stamped Wax Seal Disc
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.25, -0.25),
                radius: 0.95,
                colors: [
                  Color(0xFFB52424), // Specular red highlight
                  Color(0xFF8A1414), // Rich vermilion wax
                  Color(0xFF5D0B0B), // Deep shadow wax
                ],
                stops: [0.0, 0.65, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: const Color(0xFF8A1414).withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: const Color(0xFFDF9E9E).withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stamped recessed inner ring
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF450606),
                      width: 1.5,
                    ),
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF6A0C0C),
                        Color(0xFF8F1515),
                      ],
                    ),
                  ),
                ),

                // Embossed Royal Crown in raised relief
                const Icon(
                  Icons.shield_rounded,
                  color: Color(0xFFFFD54F),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws an authentic notched medieval silk ribbon tail
class NotchedRibbonPainter extends CustomPainter {
  final Color color;

  NotchedRibbonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(w / 2, h - 7) // Inward swallowtail V-notch
      ..lineTo(0, h)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Ambient ribbon shadow
    canvas.drawPath(
      path.shift(const Offset(1, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );

    canvas.drawPath(path, paint);

    // Subtle golden thread border along the ribbon edge
    final threadPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, threadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
