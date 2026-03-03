class Exercise {
  final String id;
  final String userId;
  final String type;
  final String name;
  final String intensity;
  final int duration;
  final String note;
  final bool isTaken;
  final DateTime loggedAt;
  final DateTime? scheduledAt;
  final int earnedXp;
  final String entryType;

  Exercise({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.intensity,
    required this.duration,
    required this.note,
    required this.isTaken,
    required this.loggedAt,
    this.scheduledAt,
    required this.earnedXp,
    required this.entryType,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      name: json['name'],
      intensity: json['intensity'],
      duration: json['duration'],
      note: json['note'] ?? '',
      isTaken: json['isTaken'] ?? false,
      loggedAt: DateTime.parse(json['loggedAt']),
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
      earnedXp: json['earnedXp'] ?? 0,
      entryType: json['entryType'] ?? 'LOG',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'name': name,
      'intensity': intensity,
      'duration': duration,
      'note': note,
      'isTaken': isTaken,
      'loggedAt': loggedAt.toIso8601String(),
      'scheduledAt': scheduledAt?.toIso8601String(),
      'earnedXp': earnedXp,
      'entryType': entryType,
    };
  }
}

class ExerciseStats {
  final int loggedExercises;
  final int timeExercises;

  ExerciseStats({required this.loggedExercises, required this.timeExercises});

  factory ExerciseStats.fromJson(Map<String, dynamic> json) {
    return ExerciseStats(
      loggedExercises: json['loggedExercises'] ?? 0,
      timeExercises: json['timeExercises'] ?? 0,
    );
  }
}
