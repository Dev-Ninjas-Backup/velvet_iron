import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/controller/onboarding_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/widgets/onboarding2_widget.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/widgets/profile_setup.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Onboarding2Controller());

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            const StepsTextWidget2(),
                            const SizedBox(height: 16),
                            const ProgressBarWidget2(),
                            const SizedBox(height: 24),
                            const SetupTextWidget(),
                            const SizedBox(height: 8),
                            const ProfileSetupWidget(),
                            const SizedBox(height: 24),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: CustomButton(
                                label:
                                    'Continue (+${controller.xpPoints.value} XP)',
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
