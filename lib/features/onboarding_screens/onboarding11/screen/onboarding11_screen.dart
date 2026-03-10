import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
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
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 1.0,
                    child: Image.asset(
                      themeController.activeTheme.id == 'reader'
                          ? ImagePath.magicImageBlue
                          : themeController.activeTheme.id == 'mage'
                          ? ImagePath.magicImagePurple
                          : themeController.activeTheme.id == 'gamer'
                          ? ImagePath.magicImageGreen
                          : ImagePath.magicImageRed,
                      height: 378,
                      width: 411,
                      fit: BoxFit.contain,
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
                          child: CustomButton(
                            label: 'Continue Subscription (\$9.00)',
                            onPressed: () async {
                              // Fetch active companion first
                              await controller.fetchActiveCompanion();

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
                                      controller.onContinueSubscription();
                                    },
                                  ),
                                ),
                              );
                            },
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
