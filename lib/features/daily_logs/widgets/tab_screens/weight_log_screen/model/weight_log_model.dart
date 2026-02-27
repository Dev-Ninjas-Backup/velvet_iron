class WeightLogRequest {
  final String weight;
  final String? note;

  const WeightLogRequest({required this.weight, this.note});

  Map<String, dynamic> toJson() => {
    'weight': weight,
    if (note != null) 'note': note,
  };
}

// ─────────────────────────────────────────────
// Core Log Entry
// ─────────────────────────────────────────────

class WeightLogModel {
  final String id;
  final String userId;
  final String weight;
  final String? note;
  final DateTime loggedAt;
  final String? weightChange;

  const WeightLogModel({
    required this.id,
    required this.userId,
    required this.weight,
    this.note,
    required this.loggedAt,
    this.weightChange,
  });

  factory WeightLogModel.fromJson(Map<String, dynamic> json) => WeightLogModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    weight: json['weight'] as String,
    note: json['note'] as String?,
    loggedAt: DateTime.parse(json['loggedAt'] as String),
    weightChange: json['weightChange'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'weight': weight,
    if (note != null) 'note': note,
    'loggedAt': loggedAt.toIso8601String(),
    if (weightChange != null) 'weightChange': weightChange,
  };

  WeightLogModel copyWith({
    String? id,
    String? userId,
    String? weight,
    String? note,
    DateTime? loggedAt,
    String? weightChange,
  }) => WeightLogModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    weight: weight ?? this.weight,
    note: note ?? this.note,
    loggedAt: loggedAt ?? this.loggedAt,
    weightChange: weightChange ?? this.weightChange,
  );
}

// ─────────────────────────────────────────────
// Weight History Response
// ─────────────────────────────────────────────

class WeightHistoryModel {
  final dynamic currentWeight;
  final dynamic totalChanges;
  final int totalLogsCount;
  final List<WeightLogModel> history;

  const WeightHistoryModel({
    required this.currentWeight,
    required this.totalChanges,
    required this.totalLogsCount,
    required this.history,
  });

  factory WeightHistoryModel.fromJson(Map<String, dynamic> json) =>
      WeightHistoryModel(
        currentWeight: json['currentWeight'],
        totalChanges: json['totalChanges'],
        totalLogsCount: json['totalLogsCount'] as int,
        history: (json['history'] as List<dynamic>)
            .map((e) => WeightLogModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'currentWeight': currentWeight,
    'totalChanges': totalChanges,
    'totalLogsCount': totalLogsCount,
    'history': history.map((e) => e.toJson()).toList(),
  };
}

// ─────────────────────────────────────────────
// Weekly Summary
// ─────────────────────────────────────────────

class WeeklyWeightEntry {
  final String date;
  final String weight;

  const WeeklyWeightEntry({required this.date, required this.weight});

  factory WeeklyWeightEntry.fromJson(Map<String, dynamic> json) =>
      WeeklyWeightEntry(
        date: json['date'] as String,
        weight: json['weight'] as String,
      );

  Map<String, dynamic> toJson() => {'date': date, 'weight': weight};
}

class WeightWeeklySummaryModel {
  final List<WeeklyWeightEntry> thisWeek;
  final List<WeeklyWeightEntry> lastWeek;
  final dynamic thisWeekAverage;
  final dynamic lastWeekAverage;
  final dynamic weeklyChange;

  const WeightWeeklySummaryModel({
    required this.thisWeek,
    required this.lastWeek,
    required this.thisWeekAverage,
    required this.lastWeekAverage,
    required this.weeklyChange,
  });

  factory WeightWeeklySummaryModel.fromJson(Map<String, dynamic> json) =>
      WeightWeeklySummaryModel(
        thisWeek: (json['thisWeek'] as List<dynamic>)
            .map((e) => WeeklyWeightEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        lastWeek: (json['lastWeek'] as List<dynamic>)
            .map((e) => WeeklyWeightEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        thisWeekAverage: json['thisWeekAverage'],
        lastWeekAverage: json['lastWeekAverage'],
        weeklyChange: json['weeklyChange'],
      );

  Map<String, dynamic> toJson() => {
    'thisWeek': thisWeek.map((e) => e.toJson()).toList(),
    'lastWeek': lastWeek.map((e) => e.toJson()).toList(),
    'thisWeekAverage': thisWeekAverage,
    'lastWeekAverage': lastWeekAverage,
    'weeklyChange': weeklyChange,
  };
}
