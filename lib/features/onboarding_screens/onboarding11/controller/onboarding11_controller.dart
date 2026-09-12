// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:velvet_iron/core/services/revenuecat_service.dart';
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

  // Store companion data for the popup
  final Rx<String?> activeCompanionImage = Rx<String?>(null);
  final Rx<String?> activeCompanionName = Rx<String?>(null);

  // RevenueCat packages
  Package? monthlyPackage;
  Package? annualPackage;
  final RxBool isLoadingOfferings = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOfferings();
  }

  Future<void> loadOfferings() async {
    try {
      isLoadingOfferings.value = true;
      final offering = await RevenueCatService.getCurrentOffering();
      if (offering != null) {
        monthlyPackage = offering.monthly ??
            offering.availablePackages.firstWhereOrNull(
              (p) =>
                  p.identifier == '\$rc_monthly' ||
                  p.storeProduct.identifier.contains('monthly'),
            );

        annualPackage = offering.annual ??
            offering.availablePackages.firstWhereOrNull(
              (p) =>
                  p.identifier == '\$rc_annual' ||
                  p.storeProduct.identifier.contains('annual'),
            );
        update();
      }
    } catch (e) {
      debugPrint('Error loading offerings: $e');
    } finally {
      isLoadingOfferings.value = false;
    }
  }

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

  String get priceText {
    if (selectedBilling.value == BillingType.monthly) {
      return monthlyPackage?.storeProduct.priceString ?? 'USD \$14.99';
    } else {
      return annualPackage?.storeProduct.priceString ?? 'USD \$119.99';
    }
  }

  String get billingPeriodText =>
      selectedBilling.value == BillingType.monthly
          ? '/ per month'
          : '/ per year';

  String get buttonLabel {
    if (selectedPackage.value == PackageType.free) {
      return 'Start 3-Day Free Trial';
    }
    final price = priceText;
    return 'Continue Subscription ($price)';
  }

  /// Fetch active companion before showing popup
  Future<void> fetchActiveCompanion() async {
    try {
      final companionData = await _service.fetchActiveCompanion();
      if (companionData != null) {
        activeCompanionImage.value = companionData['imagePath'] as String?;
        activeCompanionName.value = companionData['name'] as String?;
      }
    } catch (e) {
      debugPrint('Error fetching companion: $e');
    }
  }

  Future<void> onContinueSubscription() async {
    try {
      // 1. If user selected paid Premium, trigger RevenueCat purchase
      if (selectedPackage.value == PackageType.premium) {
        EasyLoading.show(status: 'Processing subscription...');

        Package? packageToBuy = selectedBilling.value == BillingType.monthly
            ? monthlyPackage
            : annualPackage;

        // If not loaded yet, fetch now
        if (packageToBuy == null) {
          final offering = await RevenueCatService.getCurrentOffering();
          if (offering != null) {
            packageToBuy = selectedBilling.value == BillingType.monthly
                ? (offering.monthly ??
                    offering.availablePackages.firstWhereOrNull(
                      (p) =>
                          p.identifier == '\$rc_monthly' ||
                          p.storeProduct.identifier.contains('monthly'),
                    ))
                : (offering.annual ??
                    offering.availablePackages.firstWhereOrNull(
                      (p) =>
                          p.identifier == '\$rc_annual' ||
                          p.storeProduct.identifier.contains('annual'),
                    ));
          }
        }

        if (packageToBuy != null) {
          final customerInfo = await RevenueCatService.purchasePackage(
            packageToBuy,
          );

          // If user cancelled, dismiss and stop
          if (customerInfo == null) {
            EasyLoading.dismiss();
            return;
          }
        } else {
          debugPrint(
            'RevenueCat: Package not found in offering, proceeding with registration flow',
          );
        }
      } else {
        EasyLoading.show(status: 'Activating Free Trial...');
      }

      // 2. Call backend service to complete onboarding
      final result = await _service.completeOnboarding();

      if (result['success'] == true) {
        EasyLoading.showSuccess(
          selectedPackage.value == PackageType.free
              ? 'Free trial activated!'
              : 'Subscription confirmed!',
        );

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
