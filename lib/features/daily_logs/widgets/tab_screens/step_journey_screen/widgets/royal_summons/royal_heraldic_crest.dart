import 'package:flutter/material.dart';

/// Ornate Heraldic Royal Crest with Imperial Crown & Filigree Mantling
class RoyalHeraldicCrest extends StatelessWidget {
  const RoyalHeraldicCrest({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 68,
      child: CustomPaint(
        painter: HeraldicCrestPainter(),
      ),
    );
  }
}

class HeraldicCrestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 2;

    // 1. Ornate Golden Acanthus Mantling (wings / leaves framing shield)
    final mantlingPaint = Paint()
      ..color = const Color(0xFFC79E45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final leftMantling = Path()
      ..moveTo(cx - 24, cy - 8)
      ..cubicTo(cx - 46, cy - 22, cx - 52, cy + 8, cx - 26, cy + 18)
      ..cubicTo(cx - 42, cy + 12, cx - 38, cy - 4, cx - 24, cy - 8);
    canvas.drawPath(leftMantling, mantlingPaint);

    final rightMantling = Path()
      ..moveTo(cx + 24, cy - 8)
      ..cubicTo(cx + 46, cy - 22, cx + 52, cy + 8, cx + 26, cy + 18)
      ..cubicTo(cx + 42, cy + 12, cx + 38, cy - 4, cx + 24, cy - 8);
    canvas.drawPath(rightMantling, mantlingPaint);

    // 2. Central Heater Shield Outline
    final shieldPath = Path()
      ..moveTo(cx - 20, cy - 14)
      ..lineTo(cx + 20, cy - 14)
      ..lineTo(cx + 20, cy + 4)
      ..cubicTo(cx + 20, cy + 22, cx, cy + 28, cx, cy + 30)
      ..cubicTo(cx, cy + 28, cx - 20, cy + 22, cx - 20, cy + 4)
      ..close();

    // Shield background fill (Quartered royal crimson & midnight navy)
    final shieldFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF781616), // Royal Crimson
          Color(0xFF141A28), // Midnight Royal Navy
          Color(0xFF781616), // Royal Crimson
        ],
      ).createShader(Rect.fromCenter(
          center: Offset(cx, cy + 8), width: 40, height: 44));
    canvas.drawPath(shieldPath, shieldFill);

    // Shield Golden Bevel Border
    final shieldBorder = Paint()
      ..color = const Color(0xFFE5B947)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(shieldPath, shieldBorder);

    // Quartering Gold Cross
    final crossPaint = Paint()
      ..color = const Color(0xFFE5B947)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx, cy - 14), Offset(cx, cy + 28), crossPaint);
    canvas.drawLine(Offset(cx - 20, cy + 2), Offset(cx + 20, cy + 2), crossPaint);

    // Central Mini Fleur-de-lis / Star
    final starPaint = Paint()..color = const Color(0xFFFFDF7A);
    canvas.drawCircle(Offset(cx, cy + 2), 2.2, starPaint);

    // 3. Majestic Imperial Crown on top of shield
    final crownY = cy - 20;
    final crownPath = Path()
      ..moveTo(cx - 16, crownY)
      ..lineTo(cx - 14, crownY - 11) // Left point
      ..lineTo(cx - 7, crownY - 4)
      ..lineTo(cx, crownY - 15) // High central point with cross
      ..lineTo(cx + 7, crownY - 4)
      ..lineTo(cx + 14, crownY - 11) // Right point
      ..lineTo(cx + 16, crownY)
      ..close();

    final crownFill = Paint()..color = const Color(0xFFDFB448);
    canvas.drawPath(crownPath, crownFill);

    final crownOutline = Paint()
      ..color = const Color(0xFF6B4710)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(crownPath, crownOutline);

    // Crown Base Band with mini rubies
    final bandRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, crownY + 1), width: 30, height: 4),
      const Radius.circular(2),
    );
    canvas.drawRRect(bandRect, Paint()..color = const Color(0xFFF3C759));
    canvas.drawRRect(bandRect, crownOutline);

    // Ruby jewels on crown points
    final rubyPaint = Paint()..color = const Color(0xFFA51B1B);
    canvas.drawCircle(Offset(cx, crownY - 13), 1.5, rubyPaint);
    canvas.drawCircle(Offset(cx - 13, crownY - 10), 1.3, rubyPaint);
    canvas.drawCircle(Offset(cx + 13, crownY - 10), 1.3, rubyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
