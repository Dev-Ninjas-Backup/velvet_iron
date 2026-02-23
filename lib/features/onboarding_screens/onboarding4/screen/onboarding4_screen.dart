import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/controller/onboarding4_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/widgets/gender_selection.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/widgets/onboarding4_widget.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController4());

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            const StepsTextWidget4(),
                            const SizedBox(height: 16),
                            const ProgressBarWidget4(),
                            const SizedBox(height: 32),
                            const OnboardingHeader4Widget(),
                            const SizedBox(height: 24),
                            const GenderSelectionWidget(),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: CustomButton(
                                label: 'Continue (+10 XP)',
                                onPressed: controller.onContinue,
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 24,
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
