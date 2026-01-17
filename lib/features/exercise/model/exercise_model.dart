class Exercise {
  final String id;
  final String name;
  final String type;
  final int duration;
  final String intensity;
  final DateTime dateTime;
  final String? notes;
  final bool isCompleted;

  Exercise({
    required this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.intensity,
    required this.dateTime,
    this.notes,
    this.isCompleted = false,
  });
}

class ExerciseStats {
  final int loggedExercises;
  final int timeExercises;

  ExerciseStats({
    required this.loggedExercises,
    required this.timeExercises,
  });
}
