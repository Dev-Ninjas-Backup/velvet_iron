import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding6/controller/onboarding6_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding6/widgets/onboarding6_widget.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding6/widgets/weigth_input.dart';

class OnboardingScreen6 extends StatelessWidget {
  const OnboardingScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController6());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
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
                        const StepsTextWidget6(),
                        const SizedBox(height: 10),
                        const ProgressBarWidget6(),
                        const SizedBox(height: 32),
                        const OnboardingHeaderWidget6(),
                        const SizedBox(height: 24),
                        const WeightSelectionWidget(),
                        const SizedBox(height: 32),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: CustomButtonTwo(
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
              child: FigmaBackButton(onPressed: () => Get.back()),
            ),
          ],
        ),
      ),
    );
  }
}
