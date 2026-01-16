import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OnboardingController6 extends GetxController {
  final currentStep = 6.obs;
  final totalSteps = 9.obs;
  final xpPoints = 10.obs;

  final selectedUnit = 'lbs'.obs;
  final weightController = TextEditingController();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectUnit(String unit) {
    selectedUnit.value = unit;
  }

  void onContinue() {
    if (weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your weight');
      return;
    }
  }

  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }
}
