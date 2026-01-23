import 'package:get/get.dart';

class OnboardingController5 extends GetxController {
  final currentStep = 6.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

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
}
