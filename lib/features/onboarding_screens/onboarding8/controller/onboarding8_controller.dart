import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController8 extends GetxController {
  final currentStep = 9.obs;
  final totalSteps = 11.obs;

  final selectedMeal = 'Dinner'.obs;
  final foodController = TextEditingController();
  final calorieController = TextEditingController();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMeal(String value) {
    selectedMeal.value = value;
  }

  Future<void> onContinue() async {
    if (selectedMeal.value.isEmpty || foodController.text.isEmpty) {
      EasyLoading.showInfo('Please select meal and enter food');
      return;
    }
    EasyLoading.show(status: 'Calculating nourishment...');
    await Future.delayed(const Duration(milliseconds: 1200));
    EasyLoading.showSuccess('Meal logged Successfully');
    Get.toNamed(AppRoute.getonboardingScreen9());
  }

  void onBackPressed() {
    Get.back();
  }

  @override
  void onClose() {
    foodController.dispose();
    calorieController.dispose();
    super.onClose();
  }
}
