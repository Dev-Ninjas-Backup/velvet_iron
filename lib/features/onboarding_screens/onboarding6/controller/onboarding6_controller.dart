import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController6 extends GetxController {
  final currentStep = 7.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedUnit = 'lbs'.obs;
  final weightController = TextEditingController();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectUnit(String unit) {
    selectedUnit.value = unit;
  }

  Future<void> onContinue() async {
    if (weightController.text.isEmpty) {
      EasyLoading.showInfo('Please enter your weight');
      return;
    }

    EasyLoading.show(status: 'Updating your stats...');
    await Future.delayed(const Duration(milliseconds: 1000));
    EasyLoading.showSuccess('Weight recorded Successfully');

    Get.toNamed(AppRoute.getonboardingScreen7());
  }

  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }
}
