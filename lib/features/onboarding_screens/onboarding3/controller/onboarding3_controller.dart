// ignore_for_file: dead_code

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding3/model/onboarding3_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding3/service/onboarding_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class Onboarding3Controller extends GetxController {
  final currentStep = 4.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedGoal = RxnInt();
  final isLoading = false.obs;

  final Onboarding3Service _onboarding3Service = Onboarding3Service();

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

  Future<void> onContinue() async {
    if (selectedGoal.value == null) {
      EasyLoading.showInfo('Please select a fitness goal');
      return;
    }

    try {
      isLoading(true);
      EasyLoading.show(status: 'Setting your destiny...');

      final response = await _onboarding3Service.updateFitnessGoal(
        goal: goals[selectedGoal.value!],
      );

      if (response.isSuccess) {
        final fitnessGoalResponse = FitnessGoalResponseModel.fromJson(
          response.responseData,
        );
        EasyLoading.showSuccess(
          fitnessGoalResponse.fitnessGoal.isNotEmpty
              ? 'Goal selected! +${xpPoints.value} XP'
              : 'Goal updated!',
        );
        Get.toNamed(AppRoute.getonboardingScreen4());
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }
}
