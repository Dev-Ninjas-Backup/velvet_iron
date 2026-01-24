import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/controller/onboarding7_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/widgets/onboarding7_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingScreen7 extends StatelessWidget {
  const OnboardingScreen7({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController7());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
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
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: CustomButton(
                            label: 'Continue (+10 XP)',
                            onPressed: () =>
                                Get.toNamed(AppRoute.getonboardingScreen8()),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Fixed Back Button
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
