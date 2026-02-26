enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get value {
    switch (this) {
      case MealType.breakfast:
        return 'BREAKFAST';
      case MealType.lunch:
        return 'LUNCH';
      case MealType.dinner:
        return 'DINNER';
      case MealType.snack:
        return 'SNACK';
    }
  }

  static MealType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'breakfast':
        return MealType.breakfast;
      case 'lunch':
        return MealType.lunch;
      case 'dinner':
        return MealType.dinner;
      case 'snack':
        return MealType.snack;
      default:
        return MealType.dinner;
    }
  }
}

class MealLogRequest {
  final MealType mealType;
  final String description;
  final double calories;

  MealLogRequest({
    required this.mealType,
    required this.description,
    required this.calories,
  });

  //  Macro calculations 

  int get carbs => ((calories * 0.45) / 4).round();

  int get protein => ((calories * 0.30) / 4).round();

  int get fats => ((calories * 0.25) / 9).round();

  //  Serialization 

  Map<String, String> toFormData() {
    return {
      'mealType': mealType.value,
      'description': description,
      'carbs': carbs.toString(),
      'protein': protein.toString(),
      'fats': fats.toString(),
    };
  }
}
