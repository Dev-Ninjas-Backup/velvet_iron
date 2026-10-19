import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/step_journey_model.dart';

class JourneyMilestone {
  final int stepMilestone;
  final String name;
  final String shortName;
  final String lore;
  final double fraction; // 0.0 to 1.0 along the trail

  const JourneyMilestone({
    required this.stepMilestone,
    required this.name,
    required this.shortName,
    required this.lore,
    required this.fraction,
  });
}

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

  static const List<JourneyMilestone> journeyMilestones = [
    JourneyMilestone(
      stepMilestone: 0,
      name: "The Outpost",
      shortName: "Outpost",
      lore: "The ancient fortified frontier bastion where your expedition began.",
      fraction: 0.0,
    ),
    JourneyMilestone(
      stepMilestone: 25000,
      name: "Wayfarer's Arch",
      shortName: "Wayfarer's Arch",
      lore: "An old stone arch straddles the road, its weathered runes faintly lit despite the absence of any spellcaster.",
      fraction: 0.09,
    ),
    JourneyMilestone(
      stepMilestone: 75000,
      name: "Whisperwood",
      shortName: "Whisperwood",
      lore: "The forest grows unnaturally quiet as the road disappears beneath silver roots. Living things sense the disturbance.",
      fraction: 0.19,
    ),
    JourneyMilestone(
      stepMilestone: 150000,
      name: "Blackwater Crossing",
      shortName: "Blackwater",
      lore: "A broad river crossing carrying turbulent violet currents, showing evidence that something crossed into Aevaryn.",
      fraction: 0.29,
    ),
    JourneyMilestone(
      stepMilestone: 250000,
      name: "The Ruins of Vael",
      shortName: "Ruins of Vael",
      lore: "Ancient stone colonnades stand half-swallowed by earth and ivy, proving this phenomenon has occurred before.",
      fraction: 0.40,
    ),
    JourneyMilestone(
      stepMilestone: 375000,
      name: "The Witchlight Marsh",
      shortName: "Witchlight Marsh",
      lore: "Mist clings to dark waters where pale lights drift between twisted weeping willows as foreign energies bleed together.",
      fraction: 0.52,
    ),
    JourneyMilestone(
      stepMilestone: 500000,
      name: "The Hollow Watchtower",
      shortName: "Watchtower",
      lore: "A massive imperial spire towers above the bluffs, vacant for centuries. The halfway mark to the Citadel.",
      fraction: 0.64,
    ),
    JourneyMilestone(
      stepMilestone: 625000,
      name: "The Ashen Pass",
      shortName: "Ashen Pass",
      lore: "Jagged grey cliffs rise steep and unforgiving, dusted with volcanic grey sediment as disturbances accelerate.",
      fraction: 0.74,
    ),
    JourneyMilestone(
      stepMilestone: 750000,
      name: "The Fallen King's Road",
      shortName: "King's Road",
      lore: "Paved with massive basalt blocks, this historic highway once carried royal legions toward the primal gateway.",
      fraction: 0.83,
    ),
    JourneyMilestone(
      stepMilestone: 875000,
      name: "The Obsidian Keep",
      shortName: "Obsidian Keep",
      lore: "Dark glass-like stone reflects lightning from distant unnatural storms near the borders of the portal crater.",
      fraction: 0.91,
    ),
    JourneyMilestone(
      stepMilestone: 1000000,
      name: "The Shattered Citadel",
      shortName: "Citadel",
      lore: "The ancient fortress surrounding the first primal portal. The ultimate summit and destination of your 1,000,000-step journey.",
      fraction: 1.0,
    ),
  ];

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

    // If tapped within 36px of any landmark marker
    if (closestIndex != null && minDistance < 36.0) {
      final milestone = FantasyMapWidget.journeyMilestones[closestIndex];
      _showMilestoneBottomSheet(context, milestone);
    }
  }

  void _showMilestoneBottomSheet(BuildContext context, JourneyMilestone milestone) {
    final effectiveLifetime = widget.lifetimeSteps ?? (widget.metadata.progressRatio * 1000000).toInt();
    final isReached = effectiveLifetime >= milestone.stepMilestone;
    final isCitadel = milestone.stepMilestone == 1000000;
    final stepsRemaining = milestone.stepMilestone - effectiveLifetime;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1429),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isCitadel ? const Color(0xFFFFD700) : const Color(0xFFD6B36A),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.7),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isReached
                          ? const Color(0xFFE5A93C).withValues(alpha: 0.2)
                          : Colors.black38,
                      border: Border.all(
                        color: isReached ? const Color(0xFFE5A93C) : Colors.white24,
                      ),
                    ),
                    child: Icon(
                      isCitadel
                          ? Icons.castle_rounded
                          : (isReached ? Icons.check_circle_rounded : Icons.place_rounded),
                      color: isReached ? const Color(0xFFE5A93C) : Colors.white70,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone.name,
                          style: getTextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isCitadel ? const Color(0xFFFFD700) : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isCitadel
                              ? '🏆 Final Destination • 1,000,000 Steps'
                              : 'Milestone: ${milestone.stepMilestone.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps',
                          style: getTextStyle(
                            fontSize: 12,
                            color: isCitadel ? const Color(0xFFE5A93C) : Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isReached
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                          : (stepsRemaining > 0 && stepsRemaining <= 25000
                              ? const Color(0xFFE5A93C).withValues(alpha: 0.2)
                              : Colors.black38),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isReached
                            ? const Color(0xFF4CAF50)
                            : (stepsRemaining > 0 && stepsRemaining <= 25000
                                ? const Color(0xFFE5A93C)
                                : Colors.white24),
                      ),
                    ),
                    child: Text(
                      isReached
                          ? 'Reached'
                          : (stepsRemaining > 0 && stepsRemaining <= 25000
                              ? 'Upcoming'
                              : 'Locked'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isReached
                            ? const Color(0xFF81C784)
                            : (stepsRemaining > 0 && stepsRemaining <= 25000
                                ? const Color(0xFFFFD54F)
                                : Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  milestone.lore,
                  style: getTextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isReached
                        ? '✅ Milestone completed!'
                        : '${stepsRemaining.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps remaining',
                    style: getTextStyle(
                      fontSize: 12,
                      color: isReached ? const Color(0xFF81C784) : const Color(0xFFE5A93C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Close',
                      style: getTextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAllLandmarksModal(BuildContext context) {
    final effectiveLifetime = widget.lifetimeSteps ?? (widget.metadata.progressRatio * 1000000).toInt();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF181224),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Color(0xFFFFD700), width: 1.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expedition Landmarks',
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Journey to The Shattered Citadel (1,000,000 steps)',
                        style: getTextStyle(
                          fontSize: 11,
                          color: const Color(0xFFD6B36A),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: FantasyMapWidget.journeyMilestones.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final m = FantasyMapWidget.journeyMilestones[idx];
                    final isReached = effectiveLifetime >= m.stepMilestone;
                    final isCitadel = m.stepMilestone == 1000000;
                    final stepsLeft = m.stepMilestone - effectiveLifetime;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCitadel
                            ? const Color(0xFFFFD700).withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCitadel
                              ? const Color(0xFFFFD700).withValues(alpha: 0.6)
                              : (isReached ? const Color(0xFFE5A93C).withValues(alpha: 0.4) : Colors.white12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isReached
                                  ? const Color(0xFFE5A93C)
                                  : Colors.black38,
                            ),
                            child: Icon(
                              isCitadel
                                  ? Icons.castle_rounded
                                  : (isReached ? Icons.check : Icons.lock_outline),
                              color: isReached ? Colors.black : Colors.white54,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        m.name,
                                        style: getTextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isCitadel ? const Color(0xFFFFD700) : Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (isCitadel) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFFFFD700), width: 0.5),
                                        ),
                                        child: const Text(
                                          'FINAL',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFD700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${m.stepMilestone.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps',
                                  style: getTextStyle(fontSize: 11, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isReached
                                ? 'Done'
                                : (stepsLeft > 0 ? '${(stepsLeft / 1000).toStringAsFixed(0)}k left' : ''),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isReached ? const Color(0xFF81C784) : const Color(0xFFE5A93C),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLifetime = widget.lifetimeSteps ?? (widget.metadata.progressRatio * 1000000).toInt();
    final progressRatio = (effectiveLifetime / 1000000.0).clamp(0.0, 1.0);

    // Identify current location landmark and upcoming target destination
    int currentTargetIndex = 1;
    int previousMilestoneSteps = 0;
    for (int i = 0; i < FantasyMapWidget.journeyMilestones.length; i++) {
      if (effectiveLifetime < FantasyMapWidget.journeyMilestones[i].stepMilestone) {
        currentTargetIndex = i;
        previousMilestoneSteps = i > 0 ? FantasyMapWidget.journeyMilestones[i - 1].stepMilestone : 0;
        break;
      }
      if (i == FantasyMapWidget.journeyMilestones.length - 1) {
        currentTargetIndex = i;
        previousMilestoneSteps = FantasyMapWidget.journeyMilestones[i - 1].stepMilestone;
      }
    }

    final String currentLocationName = currentTargetIndex > 1
        ? FantasyMapWidget.journeyMilestones[currentTargetIndex - 1].name
        : "The Outpost";

    final String nextDestinationName = FantasyMapWidget.journeyMilestones[currentTargetIndex].name;
    final int targetMilestoneSteps = FantasyMapWidget.journeyMilestones[currentTargetIndex].stepMilestone;
    final int legSpan = targetMilestoneSteps - previousMilestoneSteps;
    final int stepsCompletedInLeg = (effectiveLifetime - previousMilestoneSteps).clamp(0, legSpan > 0 ? legSpan : 1);
    final double legProgressRatio = legSpan > 0 ? (stepsCompletedInLeg / legSpan).clamp(0.0, 1.0) : 1.0;
    final int stepsRemainingInLeg = (targetMilestoneSteps - effectiveLifetime).clamp(0, targetMilestoneSteps);

    String formatNum(int n) =>
        n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    return LayoutBuilder(
      builder: (context, constraints) {
        const double canvasHeight = 220;
        final mapSize = Size(constraints.maxWidth, canvasHeight);

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
                // Top Ornate Expedition Navigation HUD (Current Location, Next Destination, Steps Completed)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xF0120D1F),
                    border: const Border(
                      bottom: BorderSide(
                        color: Color(0xFFD6B36A),
                        width: 1.2,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Current Location
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.place_rounded,
                                      size: 13,
                                      color: Color(0xFFD6B36A),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Current Location',
                                      style: getTextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFD6B36A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentLocationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Journey Arrow
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFFFFD700),
                            ),
                          ),

                          // Next Destination
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Next Destination',
                                      style: getTextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFFFD700),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.navigation_rounded,
                                      size: 13,
                                      color: Color(0xFFFFD700),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  nextDestinationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFFD700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Steps completed toward next landmark
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Steps completed: ${formatNum(stepsCompletedInLeg)} / ${formatNum(legSpan)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            stepsRemainingInLeg > 0
                                ? '${formatNum(stepsRemainingInLeg)} steps to go'
                                : 'Reached!',
                            style: getTextStyle(
                              fontSize: 10.5,
                              color: const Color(0xFFFFD700),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: legProgressRatio,
                          minHeight: 4,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Interactive Map Canvas Area
                SizedBox(
                  height: canvasHeight,
                  child: Stack(
                    children: [
                      // 1. Aged Fantasy Map Parchment Background
                      Positioned.fill(
                        child: Image.asset(
                          ImagePath.fantasyAdventureMap,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 2. Dark Vignette Gradient
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

                      // 3. Winding Trail Painter with Landmarks & Destination
                      Positioned.fill(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: progressRatio,
                          ),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, animatedRatio, child) {
                            return CustomPaint(
                              painter: _WindingTrailPainter(
                                progressRatio: animatedRatio,
                                lifetimeSteps: effectiveLifetime,
                                isCampSet: widget.isCampSet,
                                currentTargetIndex: currentTargetIndex,
                                onPositionsCalculated: _onMilestonePositionsCalculated,
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
                              onTap: () => _showAllLandmarksModal(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xF01F1530),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFFD700), width: 1),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
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
                                    widget.isCampSet ? Icons.nightlight_round : Icons.directions_walk,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

class _WindingTrailPainter extends CustomPainter {
  final double progressRatio;
  final int lifetimeSteps;
  final bool isCampSet;
  final int currentTargetIndex;
  final Function(List<Offset>)? onPositionsCalculated;

  _WindingTrailPainter({
    required this.progressRatio,
    required this.lifetimeSteps,
    required this.isCampSet,
    required this.currentTargetIndex,
    this.onPositionsCalculated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Define cohesive fantasy expedition waypoints across the realm:
    // Gently ascending, organic progression from South-West (Outpost) to North-East (The Shattered Citadel)
    final p0 = Offset(w * 0.09, h * 0.78); // 0: The Starting Outpost
    final p1 = Offset(w * 0.17, h * 0.68); // 1: The Wayfarer's Arch (25k)
    final p2 = Offset(w * 0.27, h * 0.58); // 2: Whisperwood (75k)
    final p3 = Offset(w * 0.37, h * 0.65); // 3: Blackwater Crossing (150k)
    final p4 = Offset(w * 0.47, h * 0.53); // 4: The Ruins of Vael (250k)
    final p5 = Offset(w * 0.57, h * 0.64); // 5: The Witchlight Marsh (375k)
    final p6 = Offset(w * 0.67, h * 0.47); // 6: The Hollow Watchtower (500k)
    final p7 = Offset(w * 0.75, h * 0.56); // 7: The Ashen Pass (625k)
    final p8 = Offset(w * 0.82, h * 0.45); // 8: The Fallen King's Road (750k)
    final p9 = Offset(w * 0.88, h * 0.53); // 9: The Obsidian Keep (875k)
    final p10 = Offset(w * 0.90, h * 0.30); // 10: The Shattered Citadel (1M)

    final milestoneAnchors = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10];
    onPositionsCalculated?.call(milestoneAnchors);

    // Build silky-smooth continuous cubic spline passing through all 11 landmarks
    final path = _buildSmoothCurvedPath(milestoneAnchors);

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
    final walkedLength = totalLength * progressRatio.clamp(0.0, 1.0);
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

    // 4. Draw Milestone Pins & Readability Labels
    final milestones = FantasyMapWidget.journeyMilestones;

    for (int i = 0; i < milestones.length; i++) {
      final m = milestones[i];
      final pos = milestoneAnchors[i];
      final isReached = lifetimeSteps >= m.stepMilestone;
      final isCitadel = m.stepMilestone == 1000000;
      final isTarget = i == currentTargetIndex && !isReached;

      if (isCitadel) {
        // Draw Grand Shattered Citadel Landmark
        final citadelHalo = Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.45)
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

        // Citadel Label safely positioned above/left to never collide with top buttons or other labels
        _drawPillLabel(
          canvas: canvas,
          center: Offset(pos.dx - 14, pos.dy - 16),
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

        _drawPillLabel(
          canvas: canvas,
          center: Offset(pos.dx + 22, pos.dy + 14),
          text: 'Outpost (0)',
          isCitadel: false,
        );
      } else {
        // Intermediate Journey Milestones
        if (isReached || isTarget) {
          final haloPaint = Paint()
            ..color = isTarget
                ? const Color(0xFFFF9100).withValues(alpha: 0.45)
                : const Color(0xFFFFD700).withValues(alpha: 0.30)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
          canvas.drawCircle(pos, 8.0, haloPaint);
        }

        final pinPaint = Paint()
          ..color = isReached
              ? const Color(0xFFE5A93C)
              : (isTarget ? const Color(0xFFFF9100) : const Color(0xFF2B2035))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, isTarget ? 6.0 : 5.0, pinPaint);

        canvas.drawCircle(
          pos,
          isTarget ? 6.0 : 5.0,
          Paint()
            ..color = isReached
                ? Colors.white
                : (isTarget ? const Color(0xFFFFD700) : const Color(0xFF8C7355))
            ..style = PaintingStyle.stroke
            ..strokeWidth = isTarget ? 1.8 : 1.2,
        );

        if (isReached) {
          canvas.drawCircle(pos, 2.0, Paint()..color = const Color(0xFFFFD700));
        }

        // Determine if this milestone should display a readable pill label:
        // Key regional milestones:
        // Whisperwood (i=2), Ruins of Vael (i=4), Hollow Watchtower (i=6)
        // OR the user's active upcoming target milestone (isTarget)
        final bool showLabel = (i == 2 || i == 4 || i == 6 || isTarget);

        if (showLabel) {
          // For i=1 (Wayfarer's Arch), place ABOVE so it never collides with Outpost below it
          final bool placeAbove = (i == 1 || i % 2 == 0);
          final labelCenter = Offset(
            pos.dx,
            placeAbove ? pos.dy - 16 : pos.dy + 16,
          );

          String labelText;
          if (i == 2) {
            labelText = 'Whisperwood';
          } else if (i == 4) {
            labelText = 'Ruins of Vael';
          } else if (i == 6) {
            labelText = 'Watchtower';
          } else {
            labelText = m.shortName;
          }

          _drawPillLabel(
            canvas: canvas,
            center: labelCenter,
            text: labelText,
            isCitadel: false,
            isCurrentTarget: isTarget,
          );
        }
      }
    }

    // 5. Draw Current Traveler or Campfire Marker along the walked journey
    if (progressRatio > 0.005) {
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

    // Subtle drop shadow for crisp readability against busy parchment
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(const Offset(0, 1.2)), const Radius.circular(6)),
      shadowPaint,
    );

    // Dark pill container
    final bgPaint = Paint()
      ..color = isCitadel
          ? const Color(0xF5241434)
          : (isCurrentTarget ? const Color(0xF52A1C3C) : const Color(0xF0140F20))
      ..style = PaintingStyle.fill;

    // Gold / accent border
    final borderPaint = Paint()
      ..color = isCitadel
          ? const Color(0xFFFFD700)
          : (isCurrentTarget ? const Color(0xFFFFB300) : const Color(0xFFD6B36A).withValues(alpha: 0.8))
      ..style = PaintingStyle.stroke
      ..strokeWidth = (isCitadel || isCurrentTarget) ? 1.2 : 0.8;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), bgPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), borderPaint);

    textPainter.paint(
      canvas,
      Offset(rect.left + padding.left, rect.top + padding.top),
    );
  }

  @override
  bool shouldRepaint(covariant _WindingTrailPainter oldDelegate) {
    return oldDelegate.progressRatio != progressRatio ||
        oldDelegate.lifetimeSteps != lifetimeSteps ||
        oldDelegate.isCampSet != isCampSet ||
        oldDelegate.currentTargetIndex != currentTargetIndex;
  }
}
