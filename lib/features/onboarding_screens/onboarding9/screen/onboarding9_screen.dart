import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/controller/onboarding9_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/widgets/medicine_formate.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/widgets/onboarding9_widget.dart';

class OnboardingScreen9 extends StatelessWidget {
  const OnboardingScreen9({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController9());

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
                    opacity: 0.2,
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
                            const StepsTextWidget9(),
                            const SizedBox(height: 8),
                            const ProgressBarWidget9(),
                            const SizedBox(height: 32),
                            const OnboardingHeaderWidget9(),
                            const SizedBox(height: 24),
                            const MedicineFormWidget(),
                            const SizedBox(height: 32),
                            Obx(
                              () => CustomButton(
                                label: 'Continue (+10 XP)',
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.onContinue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: controller.onSkipMedication,
                              child: Text(
                                "None / I do not take medication",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white.withValues(alpha: 0.8),
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
