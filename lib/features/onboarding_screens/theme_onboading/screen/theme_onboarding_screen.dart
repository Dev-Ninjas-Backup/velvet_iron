import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/controller/theme_onboarding_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/widgets/progress_and_step_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class ThemeOnboardingScreen extends StatelessWidget {
  const ThemeOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeOnboardingController());
    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    StepsTextWidgetThemes(),
                    SizedBox(height: 6),
                    ProgressBarWidgetThemes(),
                    SizedBox(height: 40),
                    const ThemesTitleSection(),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        label: 'Continue (+10 XP)',
                        onPressed: () =>
                            Get.toNamed(AppRoute.getonboadingScreen1()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 24,
              child: FigmaBackButton(onPressed: () => Get.back()),
            ),
          ],
        ),
      ),
    );
  }
}
