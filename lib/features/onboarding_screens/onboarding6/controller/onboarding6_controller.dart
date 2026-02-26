import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding6/service/onboarding6_service.dart';
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


  double _toWeightInLbs(double value) {
    if (selectedUnit.value == 'kg') {
      return value * 2.20462;
    }
    return value; 
  }

  final _onboardingService = Onboarding6Service();

  Future<void> onContinue() async {
    final weightText = weightController.text.trim();

    if (weightText.isEmpty) {
      EasyLoading.showInfo('Please enter your weight');
      return;
    }

    final weight = double.tryParse(weightText);

    if (weight == null) {
      EasyLoading.showInfo('Weight must be a valid number');
      return;
    }

    if (weight <= 0) {
      EasyLoading.showInfo('Weight must be greater than 0');
      return;
    }

    EasyLoading.show(status: 'Updating your stats...');

    final weightInLbs = _toWeightInLbs(weight);

    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
    final refreshToken = await SharedPreferencesHelper.getRefreshToken() ?? '';

    final logResponse = await _onboardingService.logWeight(
      accessToken: accessToken,
      refreshToken: refreshToken,
      weightInLbs: weightInLbs,
    );

    // ignore: avoid_print
    print('LogWeight Response: $logResponse');

    EasyLoading.showSuccess('Weight recorded Successfully');
    Get.toNamed(AppRoute.getonboardingScreen7());
  }

  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }
}
