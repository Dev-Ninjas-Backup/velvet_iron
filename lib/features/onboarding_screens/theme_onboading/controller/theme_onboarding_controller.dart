import 'package:get/get.dart';

class ThemeOnboardingController extends GetxController {
  final currentStep = 1.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedThemeIndex = 0.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  void selectTheme(int index) {
    selectedThemeIndex.value = index;
  }
}
