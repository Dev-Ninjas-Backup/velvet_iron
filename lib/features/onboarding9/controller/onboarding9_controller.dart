import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController9 extends GetxController {
  final currentStep = 9.obs;
  final totalSteps = 9.obs;
  final xpPoints = 10.obs;

  final doseNameController = TextEditingController();
  final doseController = TextEditingController();
  final selectedMedicineType = 'Injection'.obs;

  final List<String> medicineTypes = [
    'Injection',
    'Tablet',
    'Capsule',
    'Syrup',
    'Drops',
  ];

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMedicineType(String type) {
    selectedMedicineType.value = type;
  }

  void onContinue() {
    if (doseNameController.text.isEmpty || doseController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }  
  
  }

  @override
  void onClose() {
    doseNameController.dispose();
    doseController.dispose();
    super.onClose();
  }
}