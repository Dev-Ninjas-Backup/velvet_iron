import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/controller/onboarding4_controller.dart';

class GenderSelectionWidget extends StatelessWidget {
  const GenderSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController4>();
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: List.generate(
              controller.genders.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Obx(() {
                  final isSelected = controller.selectedGender.value == index;

                  return GestureDetector(
                    onTap: () => controller.selectGender(index),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.cardBackgroundColor
                            .withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeController.activeTheme.borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color:
                                    themeController.activeTheme.accentGoldColor,
                                width: 3,
                              ),
                            ),
                            child: isSelected
                                ? Padding(
                                    padding: const EdgeInsets.all(2.50),
                                    child: Center(
                                      child: Container(
                                        width: 15.44,
                                        height: 15.44,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          gradient: themeController
                                              .activeTheme
                                              .progressBarGradient,
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              controller.genders[index],
                              style: getTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
