import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/controller/onboarding8_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/widgets/onboarding8_screen.widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingScreen8 extends StatelessWidget {
  const OnboardingScreen8({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController8());
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
                    StepsTextWidget8(),
                    SizedBox(height: 8),
                    ProgressBarWidget8(),
                    SizedBox(height: 40),
                    OnboardingHeaderWidget8(),
                    SizedBox(height: 40),
                    MealSelectionWidget8(),
                    SizedBox(height: 20),
                    FoodInputWidget8(),
                    SizedBox(height: 20),
                    CalorieInputWidget8(),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        label: 'Continue (+10 XP)',
                        onPressed: () =>
                            Get.toNamed(AppRoute.getonboardingScreen9()),
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
