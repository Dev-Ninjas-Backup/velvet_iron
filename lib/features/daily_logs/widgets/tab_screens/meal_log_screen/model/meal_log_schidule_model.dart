class MealScheduleModel {
  final String id;
  final String userId;
  final String mealType;
  final DateTime scheduledAt;
  final bool isTaken;
  final int earnedXp;
  final double calories;
  final double carbs;
  final double protein;
  final double fats;

  MealScheduleModel({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.scheduledAt,
    required this.isTaken,
    required this.earnedXp,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
  });

  factory MealScheduleModel.fromJson(Map<String, dynamic> json) {
    return MealScheduleModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      mealType: json['mealType'] ?? '',
      scheduledAt: DateTime.parse(json['scheduledAt']),
      isTaken: json['isTaken'] ?? false,
      earnedXp: json['earnedXp'] ?? 0,
      calories: (json['calories'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
    );
  }
}