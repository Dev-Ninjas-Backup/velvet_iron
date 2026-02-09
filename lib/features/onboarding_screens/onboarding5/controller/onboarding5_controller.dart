import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
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

  Future<void> onContinue() async {
    try {
      EasyLoading.show(status: 'Recording your birth in the Codex...');

      await Future.delayed(const Duration(seconds: 1));

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
