class MealLogModel {
  final String id;
  final String userId;
  final String mealType;
  final int earnedXp;
  final String description;
  final double calories;
  final double carbs;
  final double protein;
  final bool isTaken;
  final double fats;
  final DateTime loggedAt;

  MealLogModel({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.earnedXp,
    required this.description,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.isTaken,
    required this.fats,
    required this.loggedAt,
  });

  factory MealLogModel.fromJson(Map<String, dynamic> json) {
    return MealLogModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      mealType: json['mealType'] ?? '',
      earnedXp: json['earnedXp'] ?? 0,
      description: json['description'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      isTaken: json['isTaken'] ?? false,
      fats: (json['fats'] ?? 0).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mealType': mealType,
      'earnedXp': earnedXp,
      'description': description,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'isTaken': isTaken,
      'fats': fats,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }
}
