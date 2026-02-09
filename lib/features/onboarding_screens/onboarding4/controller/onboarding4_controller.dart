import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController4 extends GetxController {
  final currentStep = 5.obs;
  final totalSteps = 11.obs;
  // final xpPoints = 10.obs;

  final selectedGender = RxnInt();

  final List<String> genders = ['Male', 'Female', 'Non-binary'];

  @override
  void onInit() {
    super.onInit();
    selectedGender.value = 0;
  }

  void selectGender(int index) {
    selectedGender.value = index;
  }

  double get progressValue => currentStep.value / totalSteps.value;

  void onBackPressed() {
    Get.back();
  }

  void onContinue() async {
    if (selectedGender.value == null) {
      EasyLoading.showInfo('Please select your gender');
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    EasyLoading.showSuccess('Gender selected Successfully');

    Get.toNamed(AppRoute.getonboardingScreen5());
  }
}
