// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/medication_screen/service/medication_service.dart';
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
  final selectedInjectionDay = 7.obs; // 1 = Mon ... 7 = Sun (Default: Sunday)

  final List<String> medicineTypes = [
    'TABLET',
    'CAPSULE',
    'INJECTION',
    'LIQUID',
    // 'DROPS',
  ];

  final Onboarding9Service _service = Onboarding9Service();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMedicineType(String type) {
    selectedMedicineType.value = type;
  }

  void selectInjectionDay(int day) {
    if (day >= 1 && day <= 7) {
      selectedInjectionDay.value = day;
    }
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
        await SharedPreferencesHelper.setBool('enable_medication_quest', true);
        await SharedPreferencesHelper.setBool('user_takes_medication', true);
        await SharedPreferencesHelper.setInt(
          'preferred_injection_day',
          selectedInjectionDay.value,
        );

        // If injection, schedule weekly on backend for the selected weekday
        if (selectedMedicineType.value == 'INJECTION') {
          try {
            final accessToken = await SharedPreferencesHelper.getAccessToken();
            final refreshToken = await SharedPreferencesHelper.getRefreshToken();
            if (accessToken != null && refreshToken != null) {
              await MedicationService().scheduleMedication(
                name: name.isNotEmpty ? name : 'GLP-1 Injection',
                type: 'INJECTION',
                doseMg: doseMg.toDouble(),
                scheduleTime: DateTime.now().toUtc().toIso8601String(),
                recurrence: 'WEEKLY',
                daysOfWeek: [selectedInjectionDay.value],
                accessToken: accessToken,
                refreshToken: refreshToken,
              );
            }
          } catch (_) {}
        }

        Get.toNamed(AppRoute.getonboardingScreen11());
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> onSkipMedication() async {
    await SharedPreferencesHelper.setBool('enable_medication_quest', false);
    await SharedPreferencesHelper.setBool('user_takes_medication', false);
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
