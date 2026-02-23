import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/controller/onboarding_controller.dart';

class StepsTextWidget2 extends StatelessWidget {
  const StepsTextWidget2({super.key});
  @override
  Widget build(BuildContext context) {
    Get.find<Onboarding2Controller>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 3 / 11',
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

class ProgressBarWidget2 extends StatelessWidget {
  const ProgressBarWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Onboarding2Controller>();

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

class SetupTextWidget extends StatelessWidget {
  const SetupTextWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),

      child: Column(
        children: [
          Text(
            "Setup Your Profile",
            textAlign: TextAlign.center,
            style: getTextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
