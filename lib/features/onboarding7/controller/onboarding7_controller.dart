import 'package:get/get.dart';

class OnboardingController7 extends GetxController {
  final currentStep = 7.obs;
  final totalSteps = 9.obs;
  final xpPoints = 10.obs;

  final selectedMood = ''.obs;
  final selectedEnergyLevel = ''.obs;
  final selectedHungerLevel = ''.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMood(String mood) {
    selectedMood.value = mood;
  }

  void selectEnergyLevel(String level) {
    selectedEnergyLevel.value = level;
  }

  void selectHungerLevel(String level) {
    selectedHungerLevel.value = level;
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
