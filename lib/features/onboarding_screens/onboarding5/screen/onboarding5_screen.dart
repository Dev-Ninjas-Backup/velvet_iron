import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding5/controller/onboarding5_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding5/widgets/onboarding5_widget.dart';

class OnboardingScreen5 extends StatelessWidget {
  const OnboardingScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController5());

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
                        const StepsTextWidget5(),
                        const SizedBox(height: 16),
                        const ProgressBarWidget5(),
                        const SizedBox(height: 32),
                        const OnboardingHeader5Widget(),
                        const SizedBox(height: 24),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: DateSelectionWidget(),
                        ),
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

            /// Fixed Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 24,
              child: FigmaBackButton(
                onPressed: () => Get.back(),
                applyTheme: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
