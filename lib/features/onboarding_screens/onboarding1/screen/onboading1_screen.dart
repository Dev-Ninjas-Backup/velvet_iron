import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/controller/onboarding1_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/widgets/onboarding1_widget.dart';

class OnboadingScreen1 extends StatelessWidget {
  const OnboadingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController1());

    return Scaffold(
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Container(
            decoration: BoxDecoration(
              gradient: themeController.activeTheme.backgroundGradient,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 1.0,
                    child: Image.asset(
                      themeController.activeTheme.id == 'reader'
                          ? ImagePath.magicImageBlue
                          : themeController.activeTheme.id == 'mage'
                          ? ImagePath.magicImagePurple
                          : themeController.activeTheme.id == 'gamer'
                          ? ImagePath.magicImageGreen
                          : ImagePath.magicImageRed,
                      height: 378,
                      width: 411,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(() {
                            final currentSelected =
                                controller.selectedIndex.value;

                            return ListView.builder(
                              itemCount: controller.companions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CompanionCard(
                                  companion: controller.companions[index],
                                  isSelected: currentSelected == index,
                                  onTap: () {
                                    controller.selectCompanion(index);
                                  },
                                  themeController: themeController,
                                );
                              },
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: CustomButton(
                            label: 'Continue(+10 xp)',
                            onPressed: controller.onContinue,
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
                    applyTheme: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
