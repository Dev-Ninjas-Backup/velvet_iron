import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/controller/onboarding1_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/widgets/onboarding1_widget.dart';

class OnboadingScreen1 extends StatelessWidget {
  const OnboadingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController1());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const StepsTextWidget(),
                    const ProgressBarWidget(),
                    const SizedBox(height: 20),
                    const TitleSection(),
                    const SizedBox(height: 24),
                    Obx(
                      () => ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.companions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CompanionCard(
                            companion: controller.companions[index],
                            isSelected: controller.selectedIndex.value == index,
                            onTap: () => controller.selectCompanion(index),
                            onUnlock: () => controller.unlockCompanion(index),
                            isUnlocked: controller.isCompanionUnlocked(index),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Obx(
                        () => CustomButtonTwo(
                          label: 'Continue (+${controller.xpPoints.value} XP)',
                          onPressed: controller.onContinue,
                        ),
                      ),
                    ),
                  ],
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
