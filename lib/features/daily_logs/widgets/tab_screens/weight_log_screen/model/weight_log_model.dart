class WeightLogModel {
  final String id;
  final String userId;
  final String weight;
  final String? note;
  final int earnedXp;
  final DateTime loggedAt;
  final String? weightChange;
  final String? changeType;

  WeightLogModel({
    required this.id,
    required this.userId,
    required this.weight,
    this.note,
    required this.earnedXp,
    required this.loggedAt,
    this.weightChange,
    this.changeType,
  });

  factory WeightLogModel.fromJson(Map<String, dynamic> json) {
    return WeightLogModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      weight: json['weight'] ?? '0',
      note: json['note'],
      earnedXp: json['earnedXp'] ?? 0,
      loggedAt: DateTime.parse(json['loggedAt']),
      weightChange: json['weightChange'],
      changeType: json['changeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'note': note,
      'earnedXp': earnedXp,
      'loggedAt': loggedAt.toIso8601String(),
      'weightChange': weightChange,
      'changeType': changeType,
    };
  }
}

class WeightLogHistoryModel {
  final String currentWeight;
  final String totalChanges;
  final int totalLogsCount;
  final List<WeightLogModel> history;

  WeightLogHistoryModel({
    required this.currentWeight,
    required this.totalChanges,
    required this.totalLogsCount,
    required this.history,
  });

  factory WeightLogHistoryModel.fromJson(Map<String, dynamic> json) {
    return WeightLogHistoryModel(
      currentWeight: json['currentWeight'] ?? '0',
      totalChanges: json['totalChanges'] ?? '0',
      totalLogsCount: json['totalLogsCount'] ?? 0,
      history:
          (json['history'] as List<dynamic>?)
              ?.map((item) => WeightLogModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CreateWeightLogRequest {
  final String weight;
  final String? note;

  CreateWeightLogRequest({required this.weight, this.note});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'weight': weight};
    if (note != null && note!.isNotEmpty) {
      data['note'] = note;
    }
    return data;
  }
}

class WeeklyWeightEntry {
  final String date;
  final String weight;

  WeeklyWeightEntry({required this.date, required this.weight});

  factory WeeklyWeightEntry.fromJson(Map<String, dynamic> json) {
    return WeeklyWeightEntry(
      date: json['date'] ?? '',
      weight: json['weight'] ?? '0',
    );
  }
}

class WeeklyWeightChartModel {
  final List<WeeklyWeightEntry> thisWeek;
  final List<WeeklyWeightEntry> lastWeek;
  final String? thisWeekAverage;
  final String? lastWeekAverage;
  final String? weeklyChange;

  WeeklyWeightChartModel({
    required this.thisWeek,
    required this.lastWeek,
    this.thisWeekAverage,
    this.lastWeekAverage,
    this.weeklyChange,
  });

  factory WeeklyWeightChartModel.fromJson(Map<String, dynamic> json) {
    return WeeklyWeightChartModel(
      thisWeek:
          (json['thisWeek'] as List<dynamic>?)
              ?.map((e) => WeeklyWeightEntry.fromJson(e))
              .toList() ??
          [],
      lastWeek:
          (json['lastWeek'] as List<dynamic>?)
              ?.map((e) => WeeklyWeightEntry.fromJson(e))
              .toList() ??
          [],
      thisWeekAverage: json['thisWeekAverage'],
      lastWeekAverage: json['lastWeekAverage'],
      weeklyChange: json['weeklyChange'],
    );
  }
}

class CreateWeightLogResponse {
  final String id;
  final String userId;
  final String weight;
  final String? note;
  final DateTime loggedAt;
  final String? weightChange;

  CreateWeightLogResponse({
    required this.id,
    required this.userId,
    required this.weight,
    this.note,
    required this.loggedAt,
    this.weightChange,
  });

  factory CreateWeightLogResponse.fromJson(Map<String, dynamic> json) {
    return CreateWeightLogResponse(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      weight: json['weight'] ?? '0',
      note: json['note'],
      loggedAt: DateTime.parse(json['loggedAt']),
      weightChange: json['weightChange'],
    );
  }
}
