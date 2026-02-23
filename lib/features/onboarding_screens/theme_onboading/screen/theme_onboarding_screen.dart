import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/controller/theme_onboarding_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/widgets/progress_and_step_widget.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/widgets/themes_list_widget.dart';

class ThemeOnboardingScreen extends StatelessWidget {
  const ThemeOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ThemeOnboardingController());
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Container(
            decoration: BoxDecoration(
              gradient: themeController.activeTheme.backgroundGradient,
            ),
            child: Stack(
              children: [
                // Background image with theme color
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
                // Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const StepsTextWidgetThemes(),
                        const SizedBox(height: 6),
                        const ProgressBarWidgetThemes(),
                        const SizedBox(height: 40),
                        const ThemesTitleSection(),
                        const SizedBox(height: 24),
                        const ThemesListWidget(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: CustomButton(
                            label: 'Continue (+10 XP)',
                            onPressed: controller.onContinuePressed,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Back button
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
