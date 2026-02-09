import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController7 extends GetxController {
  final currentStep = 8.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedMood = 'Good'.obs;
  final selectedEnergyLevel = 'Moderate'.obs;
  final selectedHungerLevel = 'Hungry'.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMood(String value) {
    selectedMood.value = value;
  }

  void selectEnergyLevel(String value) {
    selectedEnergyLevel.value = value;
  }

  void selectHungerLevel(String value) {
    selectedHungerLevel.value = value;
  }

  Future<void> onContinue() async {
    if (selectedMood.isEmpty ||
        selectedEnergyLevel.isEmpty ||
        selectedHungerLevel.isEmpty) {
      EasyLoading.showInfo('Please select all options');
      return;
    }

    EasyLoading.show(status: 'Analyzing your vitals...');
    await Future.delayed(const Duration(milliseconds: 1000));
    EasyLoading.showSuccess('Condition Recorded! +${xpPoints.value} XP');

    Get.toNamed(AppRoute.getonboardingScreen8());
  }

  void onBackPressed() {
    Get.back();
  }
}
