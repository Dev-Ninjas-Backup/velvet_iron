import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/widgets/onboarding11_widgets.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/widgets/package_selection.dart';
import 'package:velvet_iron/features/onboarding_screens/subscription_completion_popup.dart';

class OnboardingScreen11 extends StatelessWidget {
  const OnboardingScreen11({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController11());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Container(
            decoration: BoxDecoration(
              gradient: themeController.activeTheme.backgroundGradient,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.40,
                    child: Image.asset(
                      themeController.activeTheme.backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenHeight * 0.06),
                        const StepsTextWidget11(),
                        SizedBox(height: screenHeight * 0.01),
                        const ProgressBarWidget11(),
                        SizedBox(height: screenHeight * 0.05),
                        const OnboardingHeaderWidget11(),
                        SizedBox(height: screenHeight * 0.05),
                        const PackageSelectionWidget(),
                        SizedBox(height: screenHeight * 0.03),
                        const MembershipBenefitsWidget(),
                        SizedBox(height: screenHeight * 0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                          ),
                          child: Obx(
                            () => CustomButton(
                              label: controller.buttonLabel,
                              onPressed: () async {
                                // 1. Preload active companion details
                                await controller.fetchActiveCompanion();

                                // 2. If Premium is selected, trigger StoreKit / Google Play purchase FIRST
                                if (controller.selectedPackage.value ==
                                    PackageType.premium) {
                                  final success =
                                      await controller.purchaseSelectedPackage();
                                  if (!success) {
                                    // User cancelled, purchase failed, or product unavailable
                                    return;
                                  }
                                }

                                // 3. Only show SubscriptionCompletionPopup AFTER payment succeeds (or for free trial)
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Obx(
                                    () => SubscriptionCompletionPopup(
                                      selectedCompanionName:
                                          controller.activeCompanionName.value,
                                      selectedCompanionImage:
                                          controller.activeCompanionImage.value,
                                      onCollectRewards: () {
                                        controller.completeOnboardingFlow();
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: screenWidth * 0.06,
                  child: FigmaBackButton(
                    onPressed: () => Get.back(),
                    applyTheme: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
