// Controller
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding3Controller extends GetxController {
  final currentStep = 3.obs;
  final totalSteps = 9.obs;
  final xpPoints = 10.obs;

  final selectedGoal = RxnInt();

  final List<String> goals = [
    'Transform my body and grow stronger',
    'Track my training and medication',
    'Forge stronger daily habits',
    'Explore the Codex',
  ];

  double get progressValue => currentStep.value / totalSteps.value;

  void onBackPressed() {
    Get.back();
  }

  void selectGoal(int index) {
    selectedGoal.value = index;
  }

  void onContinue() {
    if (selectedGoal.value == null) {
      Get.snackbar(
        'Required',
        'Please select a fitness goal',
        backgroundColor: Colors.orange.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      'Success',
      'Goal selected! +${xpPoints.value} XP',
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
