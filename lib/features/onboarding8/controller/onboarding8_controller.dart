import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController8 extends GetxController {
  final currentStep = 8.obs;
  final totalSteps = 9.obs;
  final xpPoints = 10.obs;

  final selectedMeal = ''.obs;
  final foodController = TextEditingController();
  final calorieController = TextEditingController();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMeal(String meal) {
    selectedMeal.value = meal;
  }

  void onContinue() {
    if (selectedMeal.isEmpty || foodController.text.isEmpty) {
      Get.snackbar('Error', 'Please select meal and enter food');
      return;
    }
  }

  @override
  void onClose() {
    foodController.dispose();
    calorieController.dispose();
    super.onClose();
  }
}
