import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/widgets/onboarding11_widgets.dart';

class OnboardingScreen11 extends StatelessWidget {
  const OnboardingScreen11({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController11());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    StepsTextWidget11(),
                    const SizedBox(height: 6),
                    ProgressBarWidget11(),
                    const SizedBox(height: 40),
                    OnboardingHeaderWidget11(),
                    const SizedBox(height: 40),
                    PackageSelectionWidget(),
                    const SizedBox(height: 20),
                    MembershipBenefitsWidget(),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        label: 'Continue Subscription (\$9.00)',
                        onPressed: () => Get.dialog(
                          const PopUpDialogue(),
                          barrierDismissible:false, // Prevents closing by tapping outside
                          transitionDuration: const Duration(milliseconds: 500),
                          transitionCurve: Curves.easeInOut,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            /// Back Button
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
