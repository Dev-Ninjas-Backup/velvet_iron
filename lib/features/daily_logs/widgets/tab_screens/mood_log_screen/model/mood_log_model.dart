class MoodLogModel {
  final int mood;
  final int energyLevel;
  final int hungerLevel;
  final String note;

  MoodLogModel({
    required this.mood,
    required this.energyLevel,
    required this.hungerLevel,
    this.note = '',
  });
}
