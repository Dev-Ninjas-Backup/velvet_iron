import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController9 extends GetxController {
  final currentStep = 10.obs;
  final totalSteps = 11.obs;

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

  Future<void> onContinue() async {
    if (doseNameController.text.isEmpty || doseController.text.isEmpty) {
      EasyLoading.showInfo('Please select meal and enter food');
      return;
    }
    EasyLoading.show(status: 'Calculating nourishment...');
    await Future.delayed(const Duration(milliseconds: 1200));
    EasyLoading.showSuccess('Meal logged Successfully');
    Get.toNamed(AppRoute.getonboardingScreen11());
  }

  void onBackPressed() {
    Get.back();
  }

  @override
  void onClose() {
    doseNameController.dispose();
    doseController.dispose();
    super.onClose();
  }
}
