import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/controller/onboarding7_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/widgets/mood_selection.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/widgets/onboarding7_widget.dart';

class OnboardingScreen7 extends StatelessWidget {
  const OnboardingScreen7({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController7());
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            const StepsTextWidget7(),
                            const SizedBox(height: 8),
                            const ProgressBarWidget7(),
                            const SizedBox(height: 32),
                            const OnboardingHeaderWidget7(),
                            const SizedBox(height: 24),
                            const MoodSelectionWidget(),
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
