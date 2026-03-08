import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/service/onboarding11_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

enum PackageType { free, premium }

enum BillingType { monthly, annually }

class OnboardingController11 extends GetxController {
  final currentStep = 11.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedPackage = PackageType.premium.obs;
  final selectedBilling = BillingType.monthly.obs;

  final RxInt selectedSection = 0.obs;

  final Onboarding11Service _service = Onboarding11Service();

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

  Future<void> onContinueSubscription() async {
    try {
      EasyLoading.show(status: 'Processing subscription...');

      // Call the service to complete onboarding
      final result = await _service.completeOnboarding();

      if (result['success'] == true) {
        EasyLoading.showSuccess('Subscription confirmed!');

        // Navigate to home screen after a short delay
        await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed(AppRoute.getHomeScreen());
      } else {
        EasyLoading.showError(
          result['message'] ?? 'Failed to process subscription',
        );
      }
    } catch (e) {
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }
}
