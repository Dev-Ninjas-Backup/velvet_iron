import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealLogController extends GetxController {
  final selectedMealTab = 0.obs;
  final selectedMealType = 0.obs;

  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();

  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;

  void setMealTab(int index) => selectedMealTab.value = index;
  void selectMealType(int index) => selectedMealType.value = index;

  void setDate(DateTime date) => selectedDate.value = date;
  void setTime(TimeOfDay time) => selectedTime.value = time;

  @override
  void onClose() {
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.onClose();
  }
}
