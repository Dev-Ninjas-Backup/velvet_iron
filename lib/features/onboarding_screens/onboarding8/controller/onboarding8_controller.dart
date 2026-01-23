import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController8 extends GetxController {
  final currentStep = 9.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedMeal = 'Dinner'.obs;
  final foodController = TextEditingController();
  final calorieController = TextEditingController();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMeal(String value) {
    selectedMeal.value = value;
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
