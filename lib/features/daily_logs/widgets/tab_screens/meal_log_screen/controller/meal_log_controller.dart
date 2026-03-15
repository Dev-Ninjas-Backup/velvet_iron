// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_schidule_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/service/meal_log_service.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_history_model.dart';

class MealLogController extends GetxController {
  final selectedMealTab = 0.obs;
  final selectedMealType = 0.obs;

  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;

  // Track if nutrition fields are populated from barcode scan
  final isCarbsFromScan = false.obs;
  final isProteinFromScan = false.obs;
  final isFatsFromScan = false.obs;

  final isLoading = false.obs;
  final loggedMeal = Rxn<MealLogModel>();

  final isScheduleLoading = false.obs;
  final scheduledMeal = Rxn<MealScheduleModel>();
  final isHistoryLoading = false.obs;
  final history = Rxn<MealLogHistoryModel>();

  static const List<String> _mealTypeMap = [
    'BREAKFAST',
    'LUNCH',
    'DINNER',
    'SNACK',
  ];

  void setMealTab(int index) => selectedMealTab.value = index;
  void selectMealType(int index) => selectedMealType.value = index;

  void setDate(DateTime date) => selectedDate.value = date;
  void setTime(TimeOfDay time) => selectedTime.value = time;

  /// Populate nutrition fields from barcode scanner (read-only after population)
  void populateNutritionFromScan({
    required String carbs,
    required String protein,
    required String fats,
  }) {
    carbsController.text = carbs;
    proteinController.text = protein;
    fatController.text = fats;

    // Mark fields as populated from scan (read-only until cleared)
    isCarbsFromScan.value = true;
    isProteinFromScan.value = true;
    isFatsFromScan.value = true;

    print('[MealLogController] Nutrition fields populated from scan:');
    print('[MealLogController]   carbs=$carbs');
    print('[MealLogController]   protein=$protein');
    print('[MealLogController]   fats=$fats');
  }

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  //  history fetch method
  Future<void> fetchHistory() async {
    isHistoryLoading.value = true;
    final result = await MealLogService.getMealLogHistory();
    isHistoryLoading.value = false;

    if (result != null) {
      history.value = result;
      print(
        '[MealLogController] History loaded. totalCount=${result.totalCount}',
      );
      print('[MealLogController] weeklyPresent=${result.weeklyPresent}');
      print('[MealLogController] consumedCalories=${result.consumedCalories}');
      print('[MealLogController] dailyCalories=${result.dailyCalories}');
      EasyLoading.showSuccess('History loaded successfully!');
    } else {
      EasyLoading.showError('Failed to load history. Please try again.');
      print('[MealLogController] History fetch failed.');
    }
  }

  // Submits meal log to API
  Future<void> submitMealLog() async {
    final mealType = _mealTypeMap[selectedMealType.value];
    final description = descriptionController.text.trim();
    final carbs = carbsController.text.trim();
    final protein = proteinController.text.trim();
    final fats = fatController.text.trim();

    if (description.isEmpty) {
      print('MealLogController Description is empty');
      EasyLoading.showError('Please enter a description of your meal.');
      return;
    }
    if (carbs.isEmpty || protein.isEmpty || fats.isEmpty) {
      print('MealLogController Nutrition fields are empty');
      EasyLoading.showError('Please fill in all nutrition fields.');
      return;
    }

    print('[MealLogController] mealType  : $mealType');
    print('[MealLogController] description: $description');
    print('[MealLogController] carbs      : $carbs');
    print('[MealLogController] protein    : $protein');
    print('[MealLogController] fats       : $fats');

    isLoading.value = true;

    final result = await MealLogService.logMeal(
      mealType: mealType,
      description: description,
      carbs: carbs,
      protein: protein,
      fats: fats,
    );

    isLoading.value = false;

    if (result != null) {
      loggedMeal.value = result;
      EasyLoading.showSuccess(
        'Meal logged successfully! +${result.earnedXp} XP',
      );
      _clearFields();
      fetchHistory();
    } else {
      EasyLoading.showError('Failed to log meal. Please try again.');
    }
  }

  String _buildScheduledAt() {
    final date = selectedDate.value;
    final time = selectedTime.value;
    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final utc = combined.toUtc();
    final iso = utc.toIso8601String();
    return '${iso.replaceFirst(RegExp(r'\.\d+Z$'), '')}Z';
  }

  // Submits meal schedule to API
  Future<void> submitMealSchedule() async {
    final mealType = _mealTypeMap[selectedMealType.value];
    final carbs = carbsController.text.trim();
    final protein = proteinController.text.trim();
    final fats = fatController.text.trim();
    final scheduledAt = _buildScheduledAt();

    if (carbs.isEmpty || protein.isEmpty || fats.isEmpty) {
      print('[MealLogController] Nutrition fields are empty');
      EasyLoading.showError('Please fill in all nutrition fields.');
      return;
    }

    print('[MealLogController] mealType   : $mealType');
    print('[MealLogController] scheduledAt: $scheduledAt');
    print('[MealLogController] carbs      : $carbs');
    print('[MealLogController] protein    : $protein');
    print('[MealLogController] fats       : $fats');

    isScheduleLoading.value = true;

    final result = await MealLogService.scheduleMeal(
      mealType: mealType,
      scheduledAt: scheduledAt,
      carbs: carbs,
      protein: protein,
      fats: fats,
    );

    isScheduleLoading.value = false;

    if (result != null) {
      scheduledMeal.value = result;
      EasyLoading.showSuccess(
        'Meal scheduled successfully! +${result.earnedXp} XP',
      );
      _clearFields();
      fetchHistory();
    } else {
      EasyLoading.showError('Failed to schedule meal. Please try again.');
    }
  }

  void _clearFields() {
    descriptionController.clear();
    carbsController.clear();
    proteinController.clear();
    fatController.clear();
    caloriesController.clear();
    selectedMealType.value = 0;
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();

    // Reset scan flags
    isCarbsFromScan.value = false;
    isProteinFromScan.value = false;
    isFatsFromScan.value = false;
  }

  @override
  void onClose() {
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
