import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/widgets/onboarding11_widgets.dart';

class OnboardingScreen11 extends StatelessWidget {
  const OnboardingScreen11({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController11());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.06),
                    const StepsTextWidget11(),
                    SizedBox(height: screenHeight * 0.01),
                    const ProgressBarWidget11(),
                    SizedBox(height: screenHeight * 0.05),
                    const OnboardingHeaderWidget11(),
                    SizedBox(height: screenHeight * 0.05),
                    const PackageSelectionWidget(),
                    SizedBox(height: screenHeight * 0.03),
                    const MembershipBenefitsWidget(),
                    SizedBox(height: screenHeight * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: CustomButtonTwo(
                        label: 'Continue Subscription (\$9.00)',
                        onPressed: () => Get.dialog(
                          const PopUpDialogue(),
                          barrierDismissible: false,
                          transitionDuration: const Duration(milliseconds: 500),
                          transitionCurve: Curves.easeInOut,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: screenWidth * 0.06,
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
