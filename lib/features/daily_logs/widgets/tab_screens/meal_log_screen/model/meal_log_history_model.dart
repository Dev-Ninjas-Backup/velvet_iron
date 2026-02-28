

class MealLogEntry {
  final String id;
  final String userId;
  final String mealType;
  final String? description;
  final double calories;
  final double carbs;
  final double protein;
  final double fats;
  final DateTime loggedAt;
  final bool isTaken;
  final int earnedXp;
  final DateTime? scheduledAt;
  final String entryType; 

  MealLogEntry({
    required this.id,
    required this.userId,
    required this.mealType,
    this.description,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.loggedAt,
    required this.isTaken,
    required this.earnedXp,
    this.scheduledAt,
    required this.entryType,
  });

  factory MealLogEntry.fromJson(Map<String, dynamic> json) {
    return MealLogEntry(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      mealType: json['mealType'] ?? '',
      description: json['description'],
      calories: (json['calories'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt']),
      isTaken: json['isTaken'] ?? false,
      earnedXp: json['earnedXp'] ?? 0,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
      entryType: json['entryType'] ?? '',
    );
  }
}

class MacroNeed {
  final double protein;
  final double fat;
  final double carb;

  MacroNeed({required this.protein, required this.fat, required this.carb});

  factory MacroNeed.fromJson(Map<String, dynamic> json) {
    return MacroNeed(
      protein: (json['protein'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      carb: (json['carb'] ?? 0).toDouble(),
    );
  }
}

class MealLogHistoryModel {
  // daily target
  final double dailyCalories;
  final MacroNeed macroNeed;

  // consumed
  final double consumedProtein;
  final double consumedFat;
  final double consumedCarb;
  final double consumedCalories;

  // remaining
  final double remainingProtein;
  final double remainingFat;
  final double remainingCarb;
  final double remainingCalories;

  // weeklyPresent — which days have activity
  final Map<String, bool> weeklyPresent;

  // logs list
  final List<MealLogEntry> logs;

  final int totalCount;
  final int totalEarnedXp;
  final MealLogEntry? nextSchedule;

  MealLogHistoryModel({
    required this.dailyCalories,
    required this.macroNeed,
    required this.consumedProtein,
    required this.consumedFat,
    required this.consumedCarb,
    required this.consumedCalories,
    required this.remainingProtein,
    required this.remainingFat,
    required this.remainingCarb,
    required this.remainingCalories,
    required this.weeklyPresent,
    required this.logs,
    required this.totalCount,
    required this.totalEarnedXp,
    this.nextSchedule,
  });

  factory MealLogHistoryModel.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] ?? {};
    final macroNeedJson = daily['macroNeed'] ?? {};
    final consumed = json['consumed'] ?? {};
    final remaining = json['remaining'] ?? {};
    final weeklyJson = json['weeklyPresent'] ?? {};

    // Parse weeklyPresent map
    final Map<String, bool> weekly = {
      'sunday': weeklyJson['sunday'] ?? false,
      'monday': weeklyJson['monday'] ?? false,
      'tuesday': weeklyJson['tuesday'] ?? false,
      'wednesday': weeklyJson['wednesday'] ?? false,
      'thursday': weeklyJson['thursday'] ?? false,
      'friday': weeklyJson['friday'] ?? false,
      'saturday': weeklyJson['saturday'] ?? false,
    };

    // Parse logs list
    final List<MealLogEntry> logsList = (json['logs'] as List<dynamic>? ?? [])
        .map((e) => MealLogEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    return MealLogHistoryModel(
      dailyCalories: (daily['calories'] ?? 0).toDouble(),
      macroNeed: MacroNeed.fromJson(macroNeedJson),
      consumedProtein: (consumed['protein'] ?? 0).toDouble(),
      consumedFat: (consumed['fat'] ?? 0).toDouble(),
      consumedCarb: (consumed['carb'] ?? 0).toDouble(),
      consumedCalories: (consumed['calories'] ?? 0).toDouble(),
      remainingProtein: (remaining['protein'] ?? 0).toDouble(),
      remainingFat: (remaining['fat'] ?? 0).toDouble(),
      remainingCarb: (remaining['carb'] ?? 0).toDouble(),
      remainingCalories: (remaining['calories'] ?? 0).toDouble(),
      weeklyPresent: weekly,
      logs: logsList,
      totalCount: json['totalCount'] ?? 0,
      totalEarnedXp: json['totalEarnedXp'] ?? 0,
      nextSchedule: json['nextSchedule'] != null
          ? MealLogEntry.fromJson(json['nextSchedule'])
          : null,
    );
  }
}
