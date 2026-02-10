import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/controller/onboarding9_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/widgets/medicine_formate.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding9/widgets/onboarding9_widget.dart';

class OnboardingScreen9 extends StatelessWidget {
  const OnboardingScreen9({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController9());
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
                        const StepsTextWidget9(),
                        const SizedBox(height: 8),
                        const ProgressBarWidget9(),
                        const SizedBox(height: 32),
                        const OnboardingHeaderWidget9(),
                        const SizedBox(height: 24),
                        const MedicineFormWidget(),
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
