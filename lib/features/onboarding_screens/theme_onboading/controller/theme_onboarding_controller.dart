import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class ThemeOnboardingController extends GetxController {
  final currentStep = 1.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedThemeIndex = 0.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  void selectTheme(int index) {
    selectedThemeIndex.value = index;
  }

  Future<void> onContinuePressed() async {
    try {
      EasyLoading.show(status: 'Saving Choice');

      await Future.delayed(const Duration(milliseconds: 1000));

      Get.toNamed(AppRoute.getHomeScreen());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
