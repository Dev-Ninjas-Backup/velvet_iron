import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/controller/onboarding_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/widgets/onboarding2_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Onboarding2Controller());
    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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

                    CustomButton(
                      label: 'Continue (+${controller.xpPoints.value} XP)',
                      onPressed: () =>
                          Get.toNamed(AppRoute.getonboardingScreen3()),
                    ),

                    const Spacer(flex: 3),
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
