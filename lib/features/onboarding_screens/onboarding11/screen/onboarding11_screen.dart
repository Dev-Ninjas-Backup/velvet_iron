import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/widgets/onboarding11_widgets.dart';
import 'package:velvet_iron/routes/app_routes.dart';

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    StepsTextWidget11(),
                    SizedBox(height: 8),
                    ProgressBarWidget11(),
                    SizedBox(height: 40),
                    OnboardingHeaderWidget11(),
                    SizedBox(height: 40),
                    PackageSelectionWidget(),
                    SizedBox(height: 30),
                    MembershipBenefitsWidget(),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        label: 'Continue Subscription (\$9.00)',
                        onPressed: () => Get.toNamed(AppRoute.getHomeScreen()),
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
