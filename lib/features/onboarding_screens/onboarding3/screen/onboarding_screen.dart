import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding3/controller/onboarding3_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding3/widgets/fitness_goal.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding3/widgets/onboarding_widget.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Onboarding3Controller());

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
                          children: [
                            const SizedBox(height: 60),
                            const StepsTextWidget3(),
                            const SizedBox(height: 16),
                            const ProgressBarWidget3(),
                            const SizedBox(height: 32),
                            const OnboardingHeader3Widget(),
                            const SizedBox(height: 24),
                            const FitnessGoalsWidget(),
                            const SizedBox(height: 32),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Obx(
                                () => CustomButton(
                                  label: 'Continue (+10 XP)',
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.onContinue,
                                ),
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
