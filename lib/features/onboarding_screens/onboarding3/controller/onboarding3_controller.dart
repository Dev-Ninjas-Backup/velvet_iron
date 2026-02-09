import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class Onboarding3Controller extends GetxController {
  final currentStep = 4.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedGoal = RxnInt();

  final List<String> goals = [
    'Transform my body and grow stronger',
    'Track my training and medication',
    'Forge stronger daily habits',
    'Explore the Codex',
  ];

  double get progressValue => currentStep.value / totalSteps.value;

  @override
  void onInit() {
    super.onInit();
    selectedGoal.value = 0;
  }

  void onBackPressed() {
    Get.back();
  }

  void selectGoal(int index) {
    selectedGoal.value = index;
  }

  void onContinue() async {
    if (selectedGoal.value == null) {
      EasyLoading.showInfo('Please select a fitness goal');
      return;
    }
    EasyLoading.show(status: 'Setting your destiny...');
    await Future.delayed(const Duration(milliseconds: 1000));
    EasyLoading.showSuccess('Goal selected! +${xpPoints.value} XP');

    Get.toNamed(AppRoute.getonboardingScreen4());
  }
}
