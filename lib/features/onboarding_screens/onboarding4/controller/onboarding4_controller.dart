import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/model/onboarding4_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/service/onboarding_service.dart';

class OnboardingController4 extends GetxController {
  final currentStep = 5.obs;
  final totalSteps = 11.obs;

  final selectedGender = RxnInt();

  final List<String> genders = ['Male', 'Female', 'Non-binary'];

  String get genderForApi {
    if (selectedGender.value == null) return '';
    switch (genders[selectedGender.value!]) {
      case 'Non-binary':
        return 'OTHER';
      case 'Male':
        return 'MALE';
      case 'Female':
        return 'FEMALE';
      default:
        return genders[selectedGender.value!].toUpperCase();
    }
  }

  final Onboarding4Service _onboarding4Service = Onboarding4Service();

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
    final gender = genderForApi;
    try {
      EasyLoading.show(status: 'Saving...');
      final response = await _onboarding4Service.updateGender(gender: gender);
      if (response.isSuccess) {
        final genderResponse = GenderUpdateResponseModel.fromJson(
          response.responseData,
        );
        // ignore: avoid_print
        print('Gender update response: ${response.responseData}');
        EasyLoading.showSuccess(
          genderResponse.message.isNotEmpty
              ? genderResponse.message
              : 'Gender selected successfully',
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(AppRoute.getonboardingScreen5());
        });
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong!');
    }
  }
}
