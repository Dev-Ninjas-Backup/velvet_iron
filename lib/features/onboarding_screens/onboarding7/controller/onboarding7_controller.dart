import 'package:get/get.dart';

class OnboardingController7 extends GetxController {
  final currentStep = 7.obs;
  final totalSteps = 9.obs;
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

  void onContinue() {
    if (selectedMood.isEmpty ||
        selectedEnergyLevel.isEmpty ||
        selectedHungerLevel.isEmpty) {
      Get.snackbar('Error', 'Please select all options');
      return;
    }
  }
}
