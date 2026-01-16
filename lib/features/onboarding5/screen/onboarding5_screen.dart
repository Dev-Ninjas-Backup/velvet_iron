import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding5/controller/onboarding5_controller.dart';
import 'package:velvet_iron/features/onboarding5/widgets/onboarding5_widget.dart';

class OnboardingScreen5 extends StatelessWidget {
  const OnboardingScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController5());

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
                    const StepsTextWidget5(),
                    const SizedBox(height: 16),
                    const ProgressBarWidget5(),
                    const SizedBox(height: 32),
                    const OnboardingHeader5Widget(),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: DateSelectionWidget(),
                    ),
                    const SizedBox(height: 20),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 24),
                    //   child: CustomButton(
                    //     label: 'Continue (+10 XP)',
                    //     onPressed: () => Get.toNamed(AppRoutes.onboarding6),
                    //   ),
                    // ),

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
