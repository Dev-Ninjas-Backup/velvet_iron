class MealLogModel {
  final int mealType;
  final DateTime dateTime;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MealLogModel({
    required this.mealType,
    required this.dateTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
