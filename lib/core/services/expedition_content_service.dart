import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class MilestoneInfo {
  final int steps;
  final String name;
  final String lore;
  final String canonicalClue;
  final Map<String, List<String>> dialogue;

  MilestoneInfo({
    required this.steps,
    required this.name,
    required this.lore,
    required this.canonicalClue,
    required this.dialogue,
  });

  factory MilestoneInfo.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawDiag = json['dialogue'] ?? {};
    final Map<String, List<String>> diagMap = {};
    rawDiag.forEach((k, v) {
      if (v is List) {
        diagMap[k] = v.map((e) => e.toString()).toList();
      }
    });

    return MilestoneInfo(
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      lore: json['lore']?.toString() ?? '',
      canonicalClue: json['canonicalClue']?.toString() ?? '',
      dialogue: diagMap,
    );
  }
}

class ExpeditionContentService {
  static final ExpeditionContentService _instance =
      ExpeditionContentService._internal();
  factory ExpeditionContentService() => _instance;
  ExpeditionContentService._internal();

  static const int totalJourneySteps = 1000000;

  bool _isLoaded = false;
  List<MilestoneInfo> _milestones = [];
  Map<String, List<String>> _campsiteDialogue = {};

  Future<void> init() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString(
        'assets/dialogue/expedition_v1_content.json',
      );
      final data = jsonDecode(jsonString);

      if (data['milestones'] is List) {
        _milestones = (data['milestones'] as List)
            .map((e) => MilestoneInfo.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data['campsiteDialogue'] is Map) {
        final Map<String, dynamic> rawCamp = data['campsiteDialogue'];
        _campsiteDialogue = {};
        rawCamp.forEach((k, v) {
          if (v is List) {
            _campsiteDialogue[k] = v.map((e) => e.toString()).toList();
          }
        });
      }
      _isLoaded = true;
    } catch (e) {
      _initFallback();
    }
  }

  void _initFallback() {
    _milestones = [
      MilestoneInfo(
        steps: 25000,
        name: "The Wayfarer's Arch",
        lore:
            "An old stone arch straddles the road, its weathered runes faintly lit despite the absence of any spellcaster.",
        canonicalClue:
            "The first physical sign that the disturbances are affecting places that were never known to contain portals.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 75000,
        name: "Whisperwood",
        lore: "The forest grows unnaturally quiet as the road disappears beneath silver roots.",
        canonicalClue: "Living things can sense the weakening boundary before people can.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 150000,
        name: "Blackwater Crossing",
        lore: "The broad river crossing is unusually turbulent, carrying faint violet currents.",
        canonicalClue: "Evidence that something crossed into Aevaryn.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 250000,
        name: "The Ruins of Vael",
        lore: "Ancient stone colonnades stand half-swallowed by earth and ivy.",
        canonicalClue: "Proof the phenomenon has happened before.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 375000,
        name: "The Witchlight Marsh",
        lore: "Mist clings to dark waters where pale lights drift between twisted weeping willows.",
        canonicalClue: "Foreign energies and Aevarynian magic begin bleeding together.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 500000,
        name: "The Hollow Watchtower",
        lore: "A massive imperial spire towers above the bluffs, vacant for centuries.",
        canonicalClue: "Midpoint revelation: the signs match records from before the Shattering.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 625000,
        name: "The Ashen Pass",
        lore: "Jagged grey cliffs rise steep and unforgiving, dusted with volcanic grey sediment.",
        canonicalClue: "The disturbances are worsening and becoming dangerous.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 750000,
        name: "The Fallen King's Road",
        lore: "Paved with massive basalt blocks, this historic highway led to imperial capitals.",
        canonicalClue: "History reveals why the Citadel matters.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 875000,
        name: "The Obsidian Keep",
        lore: "Dark glass-like stone reflects lightning from distant unnatural storms.",
        canonicalClue: "The crisis is realm-wide and accelerating.",
        dialogue: {},
      ),
      MilestoneInfo(
        steps: 1000000,
        name: "The Shattered Citadel",
        lore: "The ancient fortress surrounding the first primal portal stands before you.",
        canonicalClue: "The summons is revealed; the original portal is stirring again.",
        dialogue: {},
      ),
    ];
    _isLoaded = true;
  }

  List<MilestoneInfo> get milestones => _milestones;

  /// Calculate cumulative journey progression out of 1,000,000 steps
  double getJourneyProgressRatio(int cumulativeSteps) {
    if (cumulativeSteps <= 0) return 0.0;
    return (cumulativeSteps / totalJourneySteps).clamp(0.0, 1.0);
  }

  /// Get current and next landmark info based on cumulative steps
  ({
    MilestoneInfo? currentMilestone,
    MilestoneInfo nextMilestone,
    int stepsToNext,
    double progressToNext,
  }) getLandmarkStatus(int cumulativeSteps) {
    if (_milestones.isEmpty) _initFallback();

    MilestoneInfo? current;
    MilestoneInfo next = _milestones.last;
    int prevSteps = 0;

    for (final m in _milestones) {
      if (cumulativeSteps >= m.steps) {
        current = m;
        prevSteps = m.steps;
      } else {
        next = m;
        break;
      }
    }

    final int stepsToNext = max(0, next.steps - cumulativeSteps);
    final int span = next.steps - prevSteps;
    final double progressToNext = span > 0
        ? ((cumulativeSteps - prevSteps) / span).clamp(0.0, 1.0)
        : 1.0;

    return (
      currentMilestone: current,
      nextMilestone: next,
      stepsToNext: stepsToNext,
      progressToNext: progressToNext,
    );
  }

  /// Get a random campsite quote for the specified companion
  String getRandomCampsiteQuote(String companionKey) {
    final list = _campsiteDialogue[companionKey.toLowerCase()] ?? [];
    if (list.isEmpty) {
      return "Rest well tonight. The road ahead remains long.";
    }
    return list[Random().nextInt(list.length)];
  }

  /// Get resting pose image for companion
  String getRestingPoseAsset(String companionKey) {
    final lower = companionKey.toLowerCase();
    if (lower.contains('riven')) {
      return ImagePath.rivenResting;
    } else if (lower.contains('thyra')) {
      return ImagePath.thyraResting;
    } else if (lower.contains('leon')) {
      return ImagePath.leonResting;
    } else if (lower.contains('visepheron') || lower.contains('dragon')) {
      return ImagePath.visepheronResting;
    }
    return ImagePath.campTentFire;
  }
}
