import 'package:flutter/material.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/journey_milestone.dart';

class WindingTrailPainter extends CustomPainter {
  final double progressRatio;
  final int lifetimeSteps;
  final bool isCampSet;
  final int currentTargetIndex;
  final List<JourneyMilestone> milestones;
  final Function(List<Offset>)? onPositionsCalculated;

  WindingTrailPainter({
    required this.progressRatio,
    required this.lifetimeSteps,
    required this.isCampSet,
    required this.currentTargetIndex,
    required this.milestones,
    this.onPositionsCalculated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // The 11 milestone landmarks on the Aevaryn continent map (1536 x 1024)
    final p0 = Offset(w * (127 / 1536), h * (810 / 1024)); // 0: The Outpost (0 steps)
    final p1 = Offset(w * (215 / 1536), h * (610 / 1024)); // 1: Wayfarer's Arch (25k)
    final p2 = Offset(w * (385 / 1536), h * (420 / 1024)); // 2: Whisperwood (50k)
    final p3 = Offset(w * (670 / 1536), h * (615 / 1024)); // 3: Blackwater Crossing (150k)
    final p4 = Offset(w * (750 / 1536), h * (765 / 1024)); // 4: The Ruins of Vael (250k)
    final p5 = Offset(w * (1130 / 1536), h * (725 / 1024)); // 5: The Witchlight Marsh (375k)
    final p6 = Offset(w * (915 / 1536), h * (425 / 1024)); // 6: The Hollow Watchtower (500k)
    final p7 = Offset(w * (860 / 1536), h * (220 / 1024)); // 7: The Ashen Pass (625k)
    final p8 = Offset(w * (1130 / 1536), h * (275 / 1024)); // 8: The Fallen King's Road (750k)
    final p9 = Offset(w * (1400 / 1536), h * (420 / 1024)); // 9: The Obsidian Keep (875k)
    final p10 = Offset(w * (1415 / 1536), h * (155 / 1024)); // 10: The Shattered Citadel (1M)

    final milestoneAnchors = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10];
    onPositionsCalculated?.call(milestoneAnchors);

    // Natural geographic route waypoints following rivers, temple ruins, marshland, mountains, and roads:
    final naturalPathWaypoints = [
      p0, // 0: The Outpost
      Offset(w * (168 / 1536), h * (715 / 1024)), // Coastal road between Outpost and Arch
      p1, // 1: Wayfarer's Arch
      Offset(w * (265 / 1536), h * (515 / 1024)), // Entering Whisperwood tree line
      p2, // 2: Whisperwood
      Offset(w * (515 / 1536), h * (495 / 1024)), // Descending valley toward river
      p3, // 3: Blackwater Crossing (rapids)
      Offset(w * (715 / 1536), h * (690 / 1024)), // Southern riverbank
      p4, // 4: The Ruins of Vael (temple peninsula)
      Offset(w * (920 / 1536), h * (805 / 1024)), // Southern coast trail toward marsh
      p5, // 5: The Witchlight Marsh
      Offset(w * (1070 / 1536), h * (570 / 1024)), // Winding northwest past marsh
      p6, // 6: The Hollow Watchtower
      Offset(w * (880 / 1536), h * (310 / 1024)), // Mountain pass gorge ascending north
      p7, // 7: The Ashen Pass
      Offset(w * (980 / 1536), h * (240 / 1024)), // Ridge path descending to highway
      p8, // 8: The Fallen King's Road (raised bridge highway)
      Offset(w * (1270 / 1536), h * (345 / 1024)), // Basalt highway heading toward Keep
      p9, // 9: The Obsidian Keep
      Offset(w * (1425 / 1536), h * (290 / 1024)), // Cliff switchback path
      p10, // 10: The Shattered Citadel
    ];

    // Build silky-smooth continuous cubic spline passing through all landmarks along natural terrain
    final path = _buildSmoothCurvedPath(naturalPathWaypoints);

    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;
    final metric = pathMetrics.first;
    final totalLength = metric.length;

    // 1. Draw subtle ambient drop shadow beneath the trail
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double sDist = 0.0;
    while (sDist < totalLength) {
      final sub = metric.extractPath(sDist, sDist + 6.0);
      canvas.drawPath(sub.shift(const Offset(0, 1.2)), shadowPaint);
      sDist += 12.0;
    }

    // 2. Draw dashed authentic fantasy parchment trail
    final trailPaint = Paint()
      ..color = const Color(0xFF5A3E26).withValues(alpha: 0.75)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double distance = 0.0;
    while (distance < totalLength) {
      final sub = metric.extractPath(distance, distance + 6.0);
      canvas.drawPath(sub, trailPaint);
      distance += 12.0;
    }

    // 3. Draw illuminated golden progress trail
    final milestoneOffsetsOnPath = List<double>.filled(milestones.length, 0.0);
    milestoneOffsetsOnPath[0] = 0.0;
    milestoneOffsetsOnPath[milestones.length - 1] = totalLength;

    double searchOffset = 0.0;
    for (int i = 1; i < milestones.length - 1; i++) {
      final target = milestoneAnchors[i];
      double bestOffset = searchOffset;
      double minDistanceSq = double.infinity;
      for (double d = searchOffset; d <= totalLength; d += 1.5) {
        final pt = metric.getTangentForOffset(d)?.position;
        if (pt != null) {
          final distSq = (pt - target).distanceSquared;
          if (distSq < minDistanceSq) {
            minDistanceSq = distSq;
            bestOffset = d;
          }
        }
      }
      milestoneOffsetsOnPath[i] = bestOffset;
      searchOffset = bestOffset;
    }

    // Dynamic interpolation along the trail based on milestone segments
    double walkedLength = 0.0;
    if (lifetimeSteps <= 0) {
      walkedLength = 0.0;
    } else if (lifetimeSteps >= milestones.last.stepMilestone) {
      walkedLength = totalLength;
    } else {
      int seg = 0;
      for (int i = 0; i < milestones.length - 1; i++) {
        if (lifetimeSteps >= milestones[i].stepMilestone) {
          seg = i;
        } else {
          break;
        }
      }
      final startSteps = milestones[seg].stepMilestone;
      final endSteps = milestones[seg + 1].stepMilestone;
      final segSpan = endSteps - startSteps;
      final double segProgress = segSpan > 0
          ? ((lifetimeSteps - startSteps) / segSpan).clamp(0.0, 1.0)
          : 1.0;
      final startDist = milestoneOffsetsOnPath[seg];
      final endDist = milestoneOffsetsOnPath[seg + 1];
      walkedLength = startDist + segProgress * (endDist - startDist);
    }

    Offset currentPosition = p0;

    if (walkedLength > 0) {
      // Golden trail ambient glow
      final glowPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.35)
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      final walkedSub = metric.extractPath(0.0, walkedLength);
      canvas.drawPath(walkedSub, glowPaint);

      // Core golden progress line
      final walkedPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(walkedSub, walkedPaint);

      // Golden footsteps along the walked path
      final footstepPaint = Paint()
        ..color = const Color(0xFFFFE082)
        ..style = PaintingStyle.fill;
      double footDist = 8.0;
      while (footDist <= walkedLength) {
        final tangent = metric.getTangentForOffset(footDist);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 2.0, footstepPaint);
        }
        footDist += 14.0;
      }

      final curTangent = metric.getTangentForOffset(walkedLength);
      if (curTangent != null) {
        currentPosition = curTangent.position;
      }
    }

    // 4. Draw Milestone Pins & Interactive Destination Guidance
    for (int i = 0; i < milestones.length; i++) {
      final m = milestones[i];
      final pos = milestoneAnchors[i];
      final isReached = lifetimeSteps >= m.stepMilestone;
      final isCitadel = m.stepMilestone == 1000000;
      final isTarget = i == currentTargetIndex && !isReached;

      if (isCitadel) {
        // Draw Grand Shattered Citadel Landmark
        final citadelHalo = Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.50)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(pos, 15, citadelHalo);

        final citadelBase = Paint()
          ..color = const Color(0xFF221333)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 9.5, citadelBase);

        final citadelBorder = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2;
        canvas.drawCircle(pos, 9.5, citadelBorder);

        canvas.drawCircle(pos, 4.0, Paint()..color = const Color(0xFFFFD700));

        // Citadel Label safely positioned above to highlight summit
        _drawPillLabel(
          canvas: canvas,
          center: Offset(pos.dx, pos.dy - 16),
          text: 'Citadel (1M)',
          isCitadel: true,
        );
      } else if (i == 0) {
        // Starting Outpost
        final pinPaint = Paint()
          ..color = const Color(0xFFE5A93C)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 6.5, pinPaint);
        canvas.drawCircle(
          pos,
          6.5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
        canvas.drawCircle(pos, 2.5, Paint()..color = Colors.white);
      } else {
        // Intermediate Journey Milestones
        if (isReached || isTarget) {
          final haloPaint = Paint()
            ..color = isTarget
                ? const Color(0xFFFF9100).withValues(alpha: 0.55)
                : const Color(0xFFFFD700).withValues(alpha: 0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
          canvas.drawCircle(pos, isTarget ? 10.0 : 8.0, haloPaint);
        }

        final pinPaint = Paint()
          ..color = isReached
              ? const Color(0xFFE5A93C)
              : (isTarget ? const Color(0xFFFF9100) : const Color(0xFF2B2035))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, isTarget ? 6.5 : 5.0, pinPaint);

        canvas.drawCircle(
          pos,
          isTarget ? 6.5 : 5.0,
          Paint()
            ..color = isReached
                ? Colors.white
                : (isTarget ? const Color(0xFFFFD700) : const Color(0xFF8C7355))
            ..style = PaintingStyle.stroke
            ..strokeWidth = isTarget ? 2.0 : 1.2,
        );

        if (isReached) {
          canvas.drawCircle(pos, 2.0, Paint()..color = const Color(0xFFFFD700));
        }

        // Display an illuminated callout pill for the active upcoming target landmark
        if (isTarget) {
          _drawPillLabel(
            canvas: canvas,
            center: Offset(pos.dx, pos.dy - 16),
            text: 'Next: ${m.shortName}',
            isCitadel: false,
            isCurrentTarget: true,
          );
        }
      }
    }

    // 5. Draw Current Traveler or Campfire Marker along the walked journey
    if (walkedLength > 0.0 || lifetimeSteps > 0) {
      if (isCampSet) {
        // Pitched Campfire Marker
        final campGlow = Paint()
          ..color = const Color(0xFFFF6D00).withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(currentPosition, 11, campGlow);

        final campMarker = Paint()
          ..color = const Color(0xFFFF9100)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(currentPosition, 6.5, campMarker);

        // Inner fire core
        canvas.drawCircle(currentPosition, 3.0, Paint()..color = const Color(0xFFFFD54F));
      } else {
        // Traveler Active Position Pin
        final pulsePaint = Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.65)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
        canvas.drawCircle(currentPosition, 10, pulsePaint);

        final travelerPin = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(currentPosition, 6.0, travelerPin);

        // Inner adventurer core
        canvas.drawCircle(currentPosition, 2.5, Paint()..color = Colors.white);
      }
    }
  }

  Path _buildSmoothCurvedPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    path.moveTo(points.first.dx, points.first.dy);
    if (points.length == 1) return path;

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

      // Catmull-Rom to Cubic Bézier control points (smooth curvature)
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6.0,
        p1.dy + (p2.dy - p0.dy) / 6.0,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6.0,
        p2.dy - (p3.dy - p1.dy) / 6.0,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _drawPillLabel({
    required Canvas canvas,
    required Offset center,
    required String text,
    bool isCitadel = false,
    bool isCurrentTarget = false,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: isCitadel
            ? const Color(0xFFFFD700)
            : (isCurrentTarget ? const Color(0xFFFFE082) : Colors.white),
        fontSize: isCitadel ? 10.0 : (isCurrentTarget ? 9.5 : 9.0),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5);
    final rect = Rect.fromCenter(
      center: center,
      width: textPainter.width + padding.horizontal,
      height: textPainter.height + padding.vertical,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

    // Pill background
    final bgPaint = Paint()
      ..color = isCitadel
          ? const Color(0xFF1B0E2A).withValues(alpha: 0.90)
          : (isCurrentTarget
              ? const Color(0xFF2D1600).withValues(alpha: 0.90)
              : Colors.black.withValues(alpha: 0.75))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // Pill border
    final borderPaint = Paint()
      ..color = isCitadel
          ? const Color(0xFFFFD700)
          : (isCurrentTarget ? const Color(0xFFFF9100) : Colors.white24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCurrentTarget || isCitadel ? 1.0 : 0.8;
    canvas.drawRRect(rrect, borderPaint);

    // Draw text
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant WindingTrailPainter oldDelegate) {
    return oldDelegate.progressRatio != progressRatio ||
        oldDelegate.lifetimeSteps != lifetimeSteps ||
        oldDelegate.isCampSet != isCampSet ||
        oldDelegate.currentTargetIndex != currentTargetIndex;
  }
}
