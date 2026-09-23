import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/step_journey_model.dart';

class FantasyMapWidget extends StatelessWidget {
  final FantasyMapMetadata metadata;
  final bool isCampSet;
  final int currentSteps;
  final int goal;

  const FantasyMapWidget({
    super.key,
    required this.metadata,
    required this.isCampSet,
    required this.currentSteps,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD6B36A),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Aged Fantasy Map Parchment Background
            Positioned.fill(
              child: Image.asset(
                ImagePath.fantasyAdventureMap,
                fit: BoxFit.cover,
              ),
            ),

            // Subtle dark vignette to make icons pop
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            ),

            // Winding Trail & Footsteps Painter
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: metadata.progressRatio.clamp(0.0, 1.0),
                ),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, animatedRatio, child) {
                  return CustomPaint(
                    painter: _WindingTrailPainter(
                      progressRatio: animatedRatio,
                      unlockedMilestones: metadata.unlockedMilestones,
                      isCampSet: isCampSet,
                    ),
                  );
                },
              ),
            ),

            // Destination Ribbon at the top
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD6B36A), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.navigation_rounded,
                          size: 13,
                          color: Color(0xFFD6B36A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          metadata.nextLandmark,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Campsite Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCampSet
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.85)
                          : Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCampSet ? const Color(0xFF81C784) : const Color(0xFFD6B36A),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCampSet ? Icons.nightlight_round : Icons.directions_walk,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCampSet ? 'Camp Pitched' : 'Traveling',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Landmark Ticker
            Positioned(
              bottom: 8,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place,
                      size: 14,
                      color: Color(0xFFE5A93C),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Last reached: ${metadata.currentLandmark}',
                        style: getTextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${(metadata.progressRatio * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE5A93C),
                      ),
                    ),
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

class _WindingTrailPainter extends CustomPainter {
  final double progressRatio;
  final List<int> unlockedMilestones;
  final bool isCampSet;

  _WindingTrailPainter({
    required this.progressRatio,
    required this.unlockedMilestones,
    required this.isCampSet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Define an elegant winding S-curve across the map:
    // Outpost (left bottom) -> Landmark 25% -> Landmark 50% -> Landmark 75% -> Castle 100% (right top)
    final path = Path();
    final p0 = Offset(w * 0.12, h * 0.74); // Starting Outpost
    final p25 = Offset(w * 0.32, h * 0.58); // 25% Boundary Stone
    final p50 = Offset(w * 0.52, h * 0.68); // 50% Sunstone Spring
    final p75 = Offset(w * 0.72, h * 0.42); // 75% Ridge of Watchers
    final p100 = Offset(w * 0.88, h * 0.28); // 100% Sunken Citadel

    path.moveTo(p0.dx, p0.dy);
    path.quadraticBezierTo(w * 0.20, h * 0.62, p25.dx, p25.dy);
    path.quadraticBezierTo(w * 0.42, h * 0.54, p50.dx, p50.dy);
    path.quadraticBezierTo(w * 0.62, h * 0.78, p75.dx, p75.dy);
    path.quadraticBezierTo(w * 0.80, h * 0.30, p100.dx, p100.dy);

    // 1. Draw dashed trail route
    final trailPaint = Paint()
      ..color = const Color(0xFF4A3525).withValues(alpha: 0.6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;
    final metric = pathMetrics.first;
    final totalLength = metric.length;

    // Draw dashed path
    double distance = 0.0;
    while (distance < totalLength) {
      final sub = metric.extractPath(distance, distance + 6.0);
      canvas.drawPath(sub, trailPaint);
      distance += 12.0;
    }

    // 2. Draw animated glowing footsteps along walked distance
    final walkedLength = totalLength * progressRatio.clamp(0.0, 1.0);
    final footstepPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    double footDist = 10.0;
    Offset currentPosition = p0;
    while (footDist <= walkedLength) {
      final tangent = metric.getTangentForOffset(footDist);
      if (tangent != null) {
        currentPosition = tangent.position;
        canvas.drawCircle(tangent.position, 3.2, footstepPaint);
      }
      footDist += 16.0;
    }

    // 3. Draw Milestone Pins
    final milestones = [
      {'pos': p0, 'pct': 0, 'name': 'Outpost'},
      {'pos': p25, 'pct': 25, 'name': '25%'},
      {'pos': p50, 'pct': 50, 'name': '50%'},
      {'pos': p75, 'pct': 75, 'name': '75%'},
      {'pos': p100, 'pct': 100, 'name': 'Citadel'},
    ];

    for (final m in milestones) {
      final pos = m['pos'] as Offset;
      final pct = m['pct'] as int;
      final isReached = pct == 0 || unlockedMilestones.contains(pct);

      final pinPaint = Paint()
        ..color = isReached ? const Color(0xFFE5A93C) : const Color(0xFF6B533E)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, 6.0, pinPaint);
      canvas.drawCircle(
        pos,
        6.0,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // 4. Draw Current Traveler or Campsite Marker at currentPosition
    if (isCampSet) {
      // Pitched Campfire Marker
      final campGlow = Paint()
        ..color = const Color(0xFFFF6D00).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(currentPosition, 10, campGlow);

      final campMarker = Paint()
        ..color = const Color(0xFFFF9100)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPosition, 6, campMarker);
    } else {
      // Traveler Active Position Pin
      final pulsePaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(currentPosition, 8, pulsePaint);

      final travelerPin = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPosition, 5, travelerPin);
    }
  }

  @override
  bool shouldRepaint(covariant _WindingTrailPainter oldDelegate) {
    return oldDelegate.progressRatio != progressRatio ||
        oldDelegate.isCampSet != isCampSet;
  }
}
