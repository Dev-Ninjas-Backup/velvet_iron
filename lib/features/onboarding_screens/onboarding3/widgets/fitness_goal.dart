import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding3/controller/onboarding3_controller.dart';

class FitnessGoalsWidget extends StatelessWidget {
  const FitnessGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Onboarding3Controller>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(
              controller.goals.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Obx(() {
                  final isSelected = controller.selectedGoal.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectGoal(index),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeController.activeTheme.borderColor,
                          width: 1,
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
                              controller.goals[index],
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.9),
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
