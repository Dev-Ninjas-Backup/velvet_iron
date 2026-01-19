class MacroGoal {
  int carbs;
  int protein;
  int fats;
  int totalCalories;

  MacroGoal({
    required this.carbs,
    required this.protein,
    required this.fats,
    this.totalCalories = 796,
  });
}
