import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding5/service/onboarding5_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController5 extends GetxController {
  final currentStep = 6.obs;
  final totalSteps = 11.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  final selectedDay = '08'.obs;
  final selectedMonth = 'January'.obs;
  final selectedYear = '1999'.obs;

  final List<String> days = List.generate(
    31,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = List.generate(
    100,
    (index) => (DateTime.now().year - index).toString(),
  );

  final _onboardingService = OnboardingService();

  String get _formattedDateOfBirth {
    final monthIndex = months.indexOf(selectedMonth.value) + 1;
    final mm = monthIndex.toString().padLeft(2, '0');
    return '${selectedYear.value}-$mm-${selectedDay.value}';
  }

  Future<void> _updateDateOfBirth() async {
         final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      throw Exception('Authentication tokens not found');
    }

    final response = await _onboardingService.updateDateOfBirth(
      accessToken: accessToken,
      refreshToken: refreshToken,
      dateOfBirth: _formattedDateOfBirth,
    );

    // ignore: avoid_print
    print('UpdateDateOfBirth Response: $response');

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update date of birth');
    }
  }


  Future<void> onContinue() async {
    try {
      EasyLoading.show(status: 'Recording your birth in the Codex...');

      await _updateDateOfBirth(); // ← only addition

      EasyLoading.showSuccess('Date of Birth saved Successfully');

      Get.toNamed(AppRoute.getonboardingScreen6());
    } catch (e) {
      EasyLoading.showError('Failed to save date');
    }
  }

  void onBackPressed() {
    Get.back();
  }
}
