// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/model/madication_response_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/service/onboarding9_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController9 extends GetxController {
  final currentStep = 10.obs;
  final totalSteps = 11.obs;

  final isLoading = false.obs;

  final doseNameController = TextEditingController();
  final doseController = TextEditingController();
  final selectedMedicineType = 'TABLET'.obs;

  final List<String> medicineTypes = [
    'TABLET',
    'CAPSULE',
    'INJECTION',
    'SYRUP',
    'DROPS',
  ];

  final Onboarding9Service _service = Onboarding9Service();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMedicineType(String type) {
    selectedMedicineType.value = type;
  }

  Future<void> onContinue() async {
    final name = doseNameController.text.trim();
    final doseText = doseController.text.trim();

    if (name.isEmpty) {
      EasyLoading.showInfo('Please enter medicine name');
      return;
    }
    if (doseText.isEmpty) {
      EasyLoading.showInfo('Please enter dose amount');
      return;
    }

    final doseMg = int.tryParse(doseText);
    if (doseMg == null || doseMg <= 0) {
      EasyLoading.showInfo('Please enter a valid dose');
      return;
    }

    try {
      isLoading(true);
      EasyLoading.show(status: 'Logging medication...');

      final response = await _service.addMedication(
        name: name,
        type: selectedMedicineType.value,
        doseMg: doseMg,
      );

      if (response.isSuccess) {
        final medication = MedicationResponseModel.fromJson(
          response.responseData,
        );
        EasyLoading.showSuccess(
          'Medication logged! +${medication.earnedXp} XP',
        );
        Get.toNamed(AppRoute.getonboardingScreen11());
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
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
