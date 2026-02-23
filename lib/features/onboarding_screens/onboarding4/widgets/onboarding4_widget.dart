import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding4/controller/onboarding4_controller.dart';

class StepsTextWidget4 extends StatelessWidget {
  const StepsTextWidget4({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 5 / 11',
            style: getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Image.asset(IconPath.trophyAdventure, width: 8, height: 14),
              SizedBox(width: 1.5),
              Text(
                '+10 XP',
                style: getTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressBarWidget4 extends StatelessWidget {
  const ProgressBarWidget4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController4>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    Container(color: Colors.white.withValues(alpha: 0.2)),
                    FractionallySizedBox(
                      widthFactor: controller.progressValue,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              themeController.activeTheme.progressBarGradient,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingHeader4Widget extends StatelessWidget {
  const OnboardingHeader4Widget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "What is your gender?",
        textAlign: TextAlign.center,
        style: getTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
