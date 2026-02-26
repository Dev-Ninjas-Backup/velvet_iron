class MoodLogModel {
  final String mood;
  final String energyLevel;
  final String hungerLevel;
  final String? note;

  const MoodLogModel({
    required this.mood,
    required this.energyLevel,
    required this.hungerLevel,
    this.note,
  });

  static String toApiFormat(String value) =>
      value.trim().toUpperCase().replaceAll(' ', '_');

  Map<String, String> toFields() => {
    'mood': mood,
    'energyLevel': energyLevel,
    'hungerLevel': hungerLevel,
    if (note != null && note!.isNotEmpty) 'note': note!,
  };
}
