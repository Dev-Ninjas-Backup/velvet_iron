import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

/// Official Dravosi Royal Wax Seal supplied by client with draping silk ribbons
class CrimsonWaxSeal extends StatelessWidget {
  final double size;

  const CrimsonWaxSeal({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF6E0D0D).withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Image.asset(
        ImagePath.dravosiRoyalWaxSeal,
        width: size,
        height: size,
        fit: BoxFit.contain,
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
      ..lineTo(w / 2, h - (w * 0.55)) // Inward swallowtail V-notch
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

    // Subtle antique thread border along the ribbon edge
    final threadPaint = Paint()
      ..color = const Color(0xFFB58A35).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, threadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
