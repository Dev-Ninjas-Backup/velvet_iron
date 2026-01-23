import 'package:get/get.dart';

enum PackageType { free, premium }

enum BillingType { monthly, annually }

class OnboardingController11 extends GetxController {
  final currentStep = 11.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedPackage = PackageType.premium.obs;
  final selectedBilling = BillingType.monthly.obs;

  final RxInt selectedSection = 0.obs;

  void selectSection(int index) {
    selectedSection.value = index;
  }

  final benefits = [
    'Full Advance health tracking features',
    'Playful & gamified personalized theme and companions',
    'Daily quote and tips for healths',
    'Free access in advance discord community for  more advance activity',
  ];

  double get progressValue => currentStep.value / totalSteps.value;

  void selectPackage(PackageType type) {
    selectedPackage.value = type;
  }

  void selectBilling(BillingType type) {
    selectedBilling.value = type;
  }
}
