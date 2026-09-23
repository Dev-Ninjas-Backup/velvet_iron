class StepTodayResponse {
  final int steps;
  final int goal;
  final String display;
  final double percentage;
  final bool isGoalReached;
  final bool isCampSet;
  final DateTime? campSetAt;
  final int lifetimeSteps;
  final int totalCampsites;
  final FantasyMapMetadata fantasyMap;

  StepTodayResponse({
    required this.steps,
    required this.goal,
    required this.display,
    required this.percentage,
    required this.isGoalReached,
    required this.isCampSet,
    this.campSetAt,
    required this.lifetimeSteps,
    required this.totalCampsites,
    required this.fantasyMap,
  });

  factory StepTodayResponse.fromJson(Map<String, dynamic> json) {
    return StepTodayResponse(
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      goal: (json['goal'] as num?)?.toInt() ?? 8000,
      display: json['display']?.toString() ?? '0 / 8,000 steps',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      isGoalReached: json['isGoalReached'] == true,
      isCampSet: json['isCampSet'] == true,
      campSetAt: json['campSetAt'] != null
          ? DateTime.tryParse(json['campSetAt'].toString())
          : null,
      lifetimeSteps: (json['lifetimeSteps'] as num?)?.toInt() ?? 0,
      totalCampsites: (json['totalCampsites'] as num?)?.toInt() ?? 0,
      fantasyMap: json['fantasyMap'] is Map<String, dynamic>
          ? FantasyMapMetadata.fromJson(json['fantasyMap'])
          : FantasyMapMetadata.empty(),
    );
  }
}

class FantasyMapMetadata {
  final String currentLandmark;
  final String nextLandmark;
  final double progressRatio;
  final List<int> unlockedMilestones;
  final String activeLore;
  final String companionReaction;

  FantasyMapMetadata({
    required this.currentLandmark,
    required this.nextLandmark,
    required this.progressRatio,
    required this.unlockedMilestones,
    required this.activeLore,
    required this.companionReaction,
  });

  factory FantasyMapMetadata.fromJson(Map<String, dynamic> json) {
    return FantasyMapMetadata(
      currentLandmark: json['currentLandmark']?.toString() ?? 'The Starting Outpost',
      nextLandmark: json['nextLandmark']?.toString() ?? 'The Old Boundary Stone',
      progressRatio: (json['progressRatio'] as num?)?.toDouble() ?? 0.0,
      unlockedMilestones: (json['unlockedMilestones'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      activeLore: json['activeLore']?.toString() ??
          'You stand at the beginning of the road. Prepare your supplies for the expedition.',
      companionReaction: json['companionReaction']?.toString() ??
          'A long march begins with a single resolute stride.',
    );
  }

  factory FantasyMapMetadata.empty() {
    return FantasyMapMetadata(
      currentLandmark: 'The Starting Outpost',
      nextLandmark: 'The Old Boundary Stone',
      progressRatio: 0.0,
      unlockedMilestones: [],
      activeLore: 'You stand at the beginning of the road. Prepare your supplies for the expedition.',
      companionReaction: 'A long march begins with a single resolute stride.',
    );
  }
}

class SetUpCampResponse {
  final bool success;
  final bool isCampSet;
  final DateTime? campSetAt;
  final int stepsLocked;
  final int lifetimeSteps;
  final int totalCampsites;
  final int earnedXp;
  final String message;

  SetUpCampResponse({
    required this.success,
    required this.isCampSet,
    this.campSetAt,
    required this.stepsLocked,
    required this.lifetimeSteps,
    required this.totalCampsites,
    required this.earnedXp,
    required this.message,
  });

  factory SetUpCampResponse.fromJson(Map<String, dynamic> json) {
    return SetUpCampResponse(
      success: json['success'] == true,
      isCampSet: json['isCampSet'] == true,
      campSetAt: json['campSetAt'] != null
          ? DateTime.tryParse(json['campSetAt'].toString())
          : null,
      stepsLocked: (json['stepsLocked'] as num?)?.toInt() ?? 0,
      lifetimeSteps: (json['lifetimeSteps'] as num?)?.toInt() ?? 0,
      totalCampsites: (json['totalCampsites'] as num?)?.toInt() ?? 0,
      earnedXp: (json['earnedXp'] as num?)?.toInt() ?? 20,
      message: json['message']?.toString() ?? 'Camp pitched successfully!',
    );
  }
}
