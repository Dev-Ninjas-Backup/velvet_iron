// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:velvet_iron/core/services/revenuecat_service.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/core/utils/helpers/app_helper.dart';
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
    loadActiveCompanion();
  }

  Future<void> loadActiveCompanion() async {
    final cached = await SharedPreferencesHelper.getActiveCompanion();
    if (cached != null && cached['imagePath'] != null && cached['imagePath']!.isNotEmpty) {
      activeCompanionImage.value = cached['imagePath'];
      activeCompanionName.value = cached['name'];
    }
    await fetchActiveCompanion();
  }

  static String resolveCompanionImage({
    String? explicitPath,
    String? themeId,
  }) {
    if (explicitPath != null && explicitPath.isNotEmpty) {
      return explicitPath;
    }
    if (themeId == 'gamer') {
      return ImagePath.generalLeon;
    } else if (themeId == 'mage') {
      return ImagePath.visepheron;
    } else if (themeId == 'reader') {
      return ImagePath.riven;
    }
    return ImagePath.thyra;
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

  /// Attempts to purchase the selected package via RevenueCat.
  /// Returns `true` if purchase succeeds.
  /// Returns `false` if cancelled, failed, or products unavailable.
  Future<bool> purchaseSelectedPackage() async {
    try {
      Package? packageToBuy = selectedBilling.value == BillingType.monthly
          ? monthlyPackage
          : annualPackage;

      // If not loaded yet, fetch now
      if (packageToBuy == null) {
        EasyLoading.show(status: 'Loading subscription options...');
        final offering = await RevenueCatService.getCurrentOffering();
        if (offering != null) {
          monthlyPackage ??= offering.monthly ??
              offering.availablePackages.firstWhereOrNull(
                (p) =>
                    p.identifier == '\$rc_monthly' ||
                    p.storeProduct.identifier.contains('monthly'),
              );
          annualPackage ??= offering.annual ??
              offering.availablePackages.firstWhereOrNull(
                (p) =>
                    p.identifier == '\$rc_annual' ||
                    p.storeProduct.identifier.contains('annual'),
              );
          update();

          packageToBuy = selectedBilling.value == BillingType.monthly
              ? monthlyPackage
              : annualPackage;
        }
      }

      // If still null, do NOT silently bypass. Show error dialog to user.
      if (packageToBuy == null) {
        EasyLoading.dismiss();
        AppHelperFunctions.showAlert(
          'Subscription Unavailable',
          'Unable to load subscription products from the App Store / Google Play. Please check your internet connection or try again later.',
        );
        return false;
      }

      EasyLoading.show(status: 'Processing subscription...');
      final customerInfo = await RevenueCatService.purchasePackage(
        packageToBuy,
      );
      EasyLoading.dismiss();

      if (customerInfo == null) {
        // User cancelled the store purchase modal
        return false;
      }

      return true;
    } on PlatformException catch (e) {
      EasyLoading.dismiss();
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('User cancelled purchase');
        return false;
      }
      AppHelperFunctions.showAlert(
        'Purchase Error',
        e.message ?? 'An error occurred during purchase. Please try again.',
      );
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      AppHelperFunctions.showAlert(
        'Purchase Error',
        'An error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Finalizes onboarding on the backend and navigates to the home screen
  Future<void> completeOnboardingFlow() async {
    try {
      EasyLoading.show(
        status: selectedPackage.value == PackageType.free
            ? 'Activating Free Trial...'
            : 'Finalizing account...',
      );

      // Call backend service to complete onboarding
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

  /// Alias for backward compatibility
  Future<void> onContinueSubscription() async {
    await completeOnboardingFlow();
  }
}
