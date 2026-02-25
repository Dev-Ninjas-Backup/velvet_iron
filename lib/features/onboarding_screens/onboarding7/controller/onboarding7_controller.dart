import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/model/onboarding7_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/service/onboarding7_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController7 extends GetxController {
  final currentStep = 8.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedMood = 'Good'.obs;
  final selectedEnergyLevel = 'Moderate'.obs;
  final selectedHungerLevel = 'Hungry'.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMood(String value) => selectedMood.value = value;
  void selectEnergyLevel(String value) => selectedEnergyLevel.value = value;
  void selectHungerLevel(String value) => selectedHungerLevel.value = value;

  final _service = Onboarding7Service();

  Future<void> onContinue() async {
    if (selectedMood.isEmpty ||
        selectedEnergyLevel.isEmpty ||
        selectedHungerLevel.isEmpty) {
      EasyLoading.showInfo('Please select all options');
      return;
    }

    EasyLoading.show(status: 'Analyzing your vitals...');

    final model = MoodLogModel(
      mood: MoodLogModel.toApiFormat(selectedMood.value),
      energyLevel: MoodLogModel.toApiFormat(selectedEnergyLevel.value),
      hungerLevel: MoodLogModel.toApiFormat(selectedHungerLevel.value),
    );

    final response = await _service.logMood(
      accessToken: await SharedPreferencesHelper.getAccessToken() ?? '',
      refreshToken: await SharedPreferencesHelper.getRefreshToken() ?? '',
      model: model,
    );

    // ignore: avoid_print
    print('LogMood Response: $response');

    if (response['id'] != null) {
      EasyLoading.showSuccess('Condition Recorded! +${xpPoints.value} XP');
      Get.toNamed(AppRoute.getonboardingScreen8());
    } else {
      EasyLoading.showError(response['message'] ?? 'Failed to record mood');
    }
  }

  void onBackPressed() => Get.back();
}
