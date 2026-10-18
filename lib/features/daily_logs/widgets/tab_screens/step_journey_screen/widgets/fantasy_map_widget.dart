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
      name: "The Starting Outpost",
      shortName: "Outpost",
      lore: "The ancient fortified frontier bastion where your expedition began.",
      fraction: 0.0,
    ),
    JourneyMilestone(
      stepMilestone: 25000,
      name: "The Wayfarer's Arch",
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
      shortName: "The Shattered Citadel",
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final mapSize = Size(constraints.maxWidth, 240);

        return Container(
          height: 240,
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
                          Colors.black.withValues(alpha: 0.20),
                          Colors.black.withValues(alpha: 0.50),
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

                // 5. Top Destination Ribbon
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      // Target / Next Landmark
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
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
                              Flexible(
                                child: Text(
                                  widget.metadata.nextLandmark,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // All Landmarks Guide Button
                      GestureDetector(
                        onTap: () => _showAllLandmarksModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1530).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFD700), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.map_rounded,
                                size: 13,
                                color: Color(0xFFFFD700),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Landmarks (10)',
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
                      const SizedBox(width: 8),

                      // Camp Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.isCampSet
                              ? const Color(0xFF0F1B2B).withValues(alpha: 0.9)
                              : Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD6B36A),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isCampSet ? Icons.nightlight_round : Icons.directions_walk,
                              size: 12,
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
                      color: Colors.black.withValues(alpha: 0.82),
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
                        Text(
                          '${(progressRatio * 100).toStringAsFixed(1)}% (1,000,000 steps)',
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
        );
      },
    );
  }
}

class _WindingTrailPainter extends CustomPainter {
  final double progressRatio;
  final int lifetimeSteps;
  final bool isCampSet;
  final Function(List<Offset>)? onPositionsCalculated;

  _WindingTrailPainter({
    required this.progressRatio,
    required this.lifetimeSteps,
    required this.isCampSet,
    this.onPositionsCalculated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Define the winding road across the fantasy map:
    // Left-bottom outpost -> S-curve through realm -> Citadel at top-right
    final path = Path();
    final p0 = Offset(w * 0.10, h * 0.76); // Outpost
    final p1 = Offset(w * 0.22, h * 0.60); // Wayfarer's Arch
    final p2 = Offset(w * 0.34, h * 0.46); // Whisperwood
    final p3 = Offset(w * 0.44, h * 0.70); // Blackwater Crossing
    final p4 = Offset(w * 0.54, h * 0.54); // Ruins of Vael
    final p5 = Offset(w * 0.62, h * 0.72); // Witchlight Marsh
    final p6 = Offset(w * 0.70, h * 0.48); // Hollow Watchtower
    final p7 = Offset(w * 0.78, h * 0.66); // Ashen Pass
    final p8 = Offset(w * 0.84, h * 0.44); // King's Road
    final p9 = Offset(w * 0.89, h * 0.58); // Obsidian Keep
    final p10 = Offset(w * 0.88, h * 0.26); // The Shattered Citadel (Final Destination)

    path.moveTo(p0.dx, p0.dy);
    path.quadraticBezierTo(w * 0.16, h * 0.68, p1.dx, p1.dy);
    path.quadraticBezierTo(w * 0.28, h * 0.53, p2.dx, p2.dy);
    path.quadraticBezierTo(w * 0.39, h * 0.58, p3.dx, p3.dy);
    path.quadraticBezierTo(w * 0.49, h * 0.62, p4.dx, p4.dy);
    path.quadraticBezierTo(w * 0.58, h * 0.63, p5.dx, p5.dy);
    path.quadraticBezierTo(w * 0.66, h * 0.60, p6.dx, p6.dy);
    path.quadraticBezierTo(w * 0.74, h * 0.57, p7.dx, p7.dy);
    path.quadraticBezierTo(w * 0.81, h * 0.55, p8.dx, p8.dy);
    path.quadraticBezierTo(w * 0.86, h * 0.51, p9.dx, p9.dy);
    path.quadraticBezierTo(w * 0.92, h * 0.42, p10.dx, p10.dy);

    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;
    final metric = pathMetrics.first;
    final totalLength = metric.length;

    // 1. Draw dashed trail route
    final trailPaint = Paint()
      ..color = const Color(0xFF4A3525).withValues(alpha: 0.65)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

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

    double footDist = 8.0;
    Offset currentPosition = p0;
    while (footDist <= walkedLength) {
      final tangent = metric.getTangentForOffset(footDist);
      if (tangent != null) {
        currentPosition = tangent.position;
        canvas.drawCircle(tangent.position, 2.8, footstepPaint);
      }
      footDist += 14.0;
    }

    // 3. Compute milestone pin offsets along path
    final milestoneAnchors = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10];
    onPositionsCalculated?.call(milestoneAnchors);

    // 4. Draw Milestone Pins
    final milestones = FantasyMapWidget.journeyMilestones;

    for (int i = 0; i < milestones.length; i++) {
      final m = milestones[i];
      final pos = milestoneAnchors[i];
      final isReached = lifetimeSteps >= m.stepMilestone;
      final isCitadel = m.stepMilestone == 1000000;

      if (isCitadel) {
        // Draw Grand Shattered Citadel Landmark Anchor
        final citadelHalo = Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(pos, 14, citadelHalo);

        final citadelBase = Paint()
          ..color = const Color(0xFF231435)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 9.0, citadelBase);

        final citadelBorder = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(pos, 9.0, citadelBorder);

        // Center Gold Dot
        canvas.drawCircle(pos, 4.0, Paint()..color = const Color(0xFFFFD700));

        // Draw Permanent Callout Label for The Shattered Citadel
        _drawPillLabel(
          canvas: canvas,
          center: Offset(pos.dx - 48, pos.dy - 16),
          text: 'The Shattered Citadel (1M)',
          isCitadel: true,
        );
      } else if (i == 0) {
        // Starting Outpost
        final pinPaint = Paint()
          ..color = const Color(0xFFE5A93C)
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

        _drawPillLabel(
          canvas: canvas,
          center: Offset(pos.dx + 26, pos.dy + 12),
          text: 'Outpost (0)',
          isCitadel: false,
        );
      } else {
        // Regular Journey Milestones
        final pinPaint = Paint()
          ..color = isReached ? const Color(0xFFE5A93C) : const Color(0xFF5A4432)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 5.0, pinPaint);

        canvas.drawCircle(
          pos,
          5.0,
          Paint()
            ..color = isReached ? Colors.white : Colors.white54
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );

        // Draw short name label for major landmarks to keep map readable
        if (i == 4 || i == 6) {
          _drawPillLabel(
            canvas: canvas,
            center: Offset(pos.dx, pos.dy - 12),
            text: m.shortName,
            isCitadel: false,
          );
        }
      }
    }

    // 5. Draw Current Traveler or Campfire Marker at currentPosition
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
    } else {
      // Traveler Active Position Pin
      final pulsePaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(currentPosition, 9, pulsePaint);

      final travelerPin = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPosition, 5.5, travelerPin);
    }
  }

  void _drawPillLabel({
    required Canvas canvas,
    required Offset center,
    required String text,
    required bool isCitadel,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: isCitadel ? const Color(0xFFFFD700) : Colors.white,
        fontSize: isCitadel ? 9.5 : 8.5,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 2);
    final rect = Rect.fromCenter(
      center: center,
      width: textPainter.width + padding.horizontal,
      height: textPainter.height + padding.vertical,
    );

    final bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isCitadel ? const Color(0xFFFFD700) : Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCitadel ? 1.0 : 0.6;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), bgPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), borderPaint);

    textPainter.paint(
      canvas,
      Offset(rect.left + padding.left, rect.top + padding.top),
    );
  }

  @override
  bool shouldRepaint(covariant _WindingTrailPainter oldDelegate) {
    return oldDelegate.progressRatio != progressRatio ||
        oldDelegate.lifetimeSteps != lifetimeSteps ||
        oldDelegate.isCampSet != isCampSet;
  }
}
