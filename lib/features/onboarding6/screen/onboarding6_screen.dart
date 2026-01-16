import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding6/controller/onboarding6_controller.dart';
import 'package:velvet_iron/features/onboarding6/widgets/onboarding6_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingScreen6 extends StatelessWidget {
  const OnboardingScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController6());

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
                    const StepsTextWidget6(),
                    const SizedBox(height: 10),
                    const ProgressBarWidget6(),
                    const SizedBox(height: 40),
                    const OnboardingHeaderWidget6(),
                    const SizedBox(height: 40),
                    const WeightSelectionWidget(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        label: 'Continue (+10 XP)',
                        onPressed: () =>
                            Get.toNamed(AppRoute.getonboardingScreen7()),
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
