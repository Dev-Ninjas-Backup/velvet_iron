import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding4/controller/onboarding4_controller.dart';
import 'package:velvet_iron/features/onboarding4/widgets/onboarding4_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController4());

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
                    const SizedBox(height: 60),
                    const StepsTextWidget4(),
                    const SizedBox(height: 16),
                    const ProgressBarWidget4(),
                    const SizedBox(height: 32),
                    const OnboardingHeader4Widget(),
                    const SizedBox(height: 32),
                    const GenderSelectionWidget(),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        label: 'Continue (+10 XP)',
                        onPressed: () => Get.toNamed(AppRoute.getonboardingScreen5()),
                      ),
                    ),

                    const SizedBox(height: 24),
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
