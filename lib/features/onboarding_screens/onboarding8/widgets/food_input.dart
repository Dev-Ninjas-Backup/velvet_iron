import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/controller/onboarding8_controller.dart';

class FoodInputWidget8 extends StatelessWidget {
  const FoodInputWidget8({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController8>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What did you eat?',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: themeController.activeTheme.dropdownBackgroundColor
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: themeController.activeTheme.borderColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.foodController,
                  maxLines: 3,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 249, 248, 248),
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Grilled chicken salad with olive oil dressing...',
                    hintStyle: getTextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
