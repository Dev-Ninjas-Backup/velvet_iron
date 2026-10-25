import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/journey_milestone.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/step_journey_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/map_navigation_hud.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/milestone_modals.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/winding_trail_painter.dart';

// Re-export JourneyMilestone so existing imports continue to work seamlessly
export 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/journey_milestone.dart';

class FantasyMapWidget extends StatefulWidget {
  final FantasyMapMetadata metadata;
  final bool isCampSet;
  final int currentSteps;
  final int goal;
  final int? lifetimeSteps;

  const FantasyMapWidget({
    super.key,
    required this.metadata,
    required this.isCampSet,
    required this.currentSteps,
    required this.goal,
    this.lifetimeSteps,
  });

  static const List<JourneyMilestone> journeyMilestones =
      JourneyMilestone.defaultMilestones;

  @override
  State<FantasyMapWidget> createState() => _FantasyMapWidgetState();
}

class _FantasyMapWidgetState extends State<FantasyMapWidget> {
  // Store computed milestone positions for tap detection
  List<Offset> _milestoneOffsets = [];

  void _onMilestonePositionsCalculated(List<Offset> offsets) {
    _milestoneOffsets = offsets;
  }

  void _handleTap(TapUpDetails details, Size mapSize) {
    if (_milestoneOffsets.isEmpty) return;

    final tapPos = details.localPosition;
    int? closestIndex;
    double minDistance = double.infinity;

    for (int i = 0; i < _milestoneOffsets.length; i++) {
      final pos = _milestoneOffsets[i];
      final distance = (pos - tapPos).distance;
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    // If tapped within 42px of any landmark marker
    if (closestIndex != null && minDistance < 42.0) {
      final milestone = FantasyMapWidget.journeyMilestones[closestIndex];
      final effectiveLifetime = widget.lifetimeSteps ??
          (widget.metadata.progressRatio * 1000000).toInt();
      showMilestoneBottomSheet(
        context: context,
        milestone: milestone,
        effectiveLifetime: effectiveLifetime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLifetime = widget.lifetimeSteps ??
        (widget.metadata.progressRatio * 1000000).toInt();
    final progressRatio = (effectiveLifetime / 1000000.0).clamp(0.0, 1.0);

    // Identify current location landmark and upcoming target destination
    int currentTargetIndex = 1;
    int previousMilestoneSteps = 0;
    for (int i = 0; i < FantasyMapWidget.journeyMilestones.length; i++) {
      if (effectiveLifetime <
          FantasyMapWidget.journeyMilestones[i].stepMilestone) {
        currentTargetIndex = i;
        previousMilestoneSteps = i > 0
            ? FantasyMapWidget.journeyMilestones[i - 1].stepMilestone
            : 0;
        break;
      }
      if (i == FantasyMapWidget.journeyMilestones.length - 1) {
        currentTargetIndex = i;
        previousMilestoneSteps =
            FantasyMapWidget.journeyMilestones[i - 1].stepMilestone;
      }
    }

    final String currentLocationName = currentTargetIndex > 1
        ? FantasyMapWidget.journeyMilestones[currentTargetIndex - 1].name
        : "The Outpost";

    final String nextDestinationName =
        FantasyMapWidget.journeyMilestones[currentTargetIndex].name;
    final int targetMilestoneSteps =
        FantasyMapWidget.journeyMilestones[currentTargetIndex].stepMilestone;
    final int legSpan = targetMilestoneSteps - previousMilestoneSteps;
    final int stepsCompletedInLeg =
        (effectiveLifetime - previousMilestoneSteps)
            .clamp(0, legSpan > 0 ? legSpan : 1);
    final double legProgressRatio =
        legSpan > 0 ? (stepsCompletedInLeg / legSpan).clamp(0.0, 1.0) : 1.0;
    final int stepsRemainingInLeg =
        (targetMilestoneSteps - effectiveLifetime).clamp(0, targetMilestoneSteps);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double canvasWidth = constraints.maxWidth;
        // The Aevaryn continent map artwork has aspect ratio 1536 x 1024 = 1.5 (3:2)
        final double canvasHeight = canvasWidth / 1.5;
        final mapSize = Size(canvasWidth, canvasHeight);

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF100B1A),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Ornate Expedition Navigation HUD
                MapNavigationHud(
                  currentLocationName: currentLocationName,
                  nextDestinationName: nextDestinationName,
                  stepsCompletedInLeg: stepsCompletedInLeg,
                  legSpan: legSpan,
                  stepsRemainingInLeg: stepsRemainingInLeg,
                  legProgressRatio: legProgressRatio,
                ),

                // Interactive Map Canvas Area
                SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: Stack(
                    children: [
                      // 1. Aevaryn Continent Map Background (1536 x 1024, exact aspect ratio)
                      Positioned.fill(
                        child: Image.asset(
                          ImagePath.aevarynMap,
                          fit: BoxFit.fill,
                        ),
                      ),

                      // 2. Subtle Vignette Gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.05),
                                Colors.black.withValues(alpha: 0.20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 3. Winding Trail Painter with Landmarks & Destination
                      Positioned.fill(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: effectiveLifetime.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, animatedLifetime, child) {
                            return CustomPaint(
                              painter: WindingTrailPainter(
                                progressRatio:
                                    (animatedLifetime / 1000000.0).clamp(0.0, 1.0),
                                lifetimeSteps: animatedLifetime.toInt(),
                                isCampSet: widget.isCampSet,
                                currentTargetIndex: currentTargetIndex,
                                milestones: FantasyMapWidget.journeyMilestones,
                                onPositionsCalculated:
                                    _onMilestonePositionsCalculated,
                              ),
                            );
                          },
                        ),
                      ),

                      // 4. Tap Detector for Milestone Pins
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTapUp: (details) => _handleTap(details, mapSize),
                        ),
                      ),

                      // 5. Top Canvas Badges: Landmarks Guide & Camp Status
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // All Landmarks Guide Button
                            GestureDetector(
                              onTap: () => showAllLandmarksModal(
                                context: context,
                                milestones: FantasyMapWidget.journeyMilestones,
                                effectiveLifetime: effectiveLifetime,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xF01F1530),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFFFD700), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.map_rounded,
                                      size: 12,
                                      color: Color(0xFFFFD700),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Landmarks',
                                      style: getTextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFD700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Camp Status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: widget.isCampSet
                                    ? const Color(0xF00F1B2B)
                                    : const Color(0xF0140F20),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFD6B36A),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.isCampSet
                                        ? Icons.nightlight_round
                                        : Icons.directions_walk,
                                    size: 11,
                                    color: const Color(0xFFD6B36A),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.isCampSet ? 'Camp Set' : 'Traveling',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD6B36A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 6. Bottom Landmark Ticker & Citadel Progress
                      Positioned(
                        bottom: 8,
                        left: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.castle_rounded,
                                size: 14,
                                color: Color(0xFFFFD700),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Final Goal: The Shattered Citadel',
                                  style: getTextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(progressRatio * 100).toStringAsFixed(1)}% (1M steps)',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
