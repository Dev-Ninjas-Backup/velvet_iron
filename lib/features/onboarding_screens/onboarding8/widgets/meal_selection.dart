import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/controller/onboarding8_controller.dart';

class MealSelectionWidget8 extends StatelessWidget {
  const MealSelectionWidget8({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController8>();
    Get.find<AppThemeController>();

    return GetBuilder<AppThemeController>(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Meal:',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMealOption(
                      iconPath: IconPath.breakfast,
                      label: 'Breakfast',
                      value: 'Breakfast',
                      controller: controller,
                    ),
                    const SizedBox(width: 8),
                    _buildMealOption(
                      iconPath: IconPath.lunch,
                      label: 'Lunch',
                      value: 'Lunch',
                      controller: controller,
                    ),
                    const SizedBox(width: 8),
                    _buildMealOption(
                      iconPath: IconPath.dinner,
                      label: 'Dinner',
                      value: 'Dinner',
                      controller: controller,
                    ),
                    const SizedBox(width: 8),
                    _buildMealOption(
                      iconPath: IconPath.snack,
                      label: 'Snack',
                      value: 'Snack',
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealOption({
    required String iconPath,
    required String label,
    required String value,
    required OnboardingController8 controller,
  }) {
    final themeController = Get.find<AppThemeController>();
    return Obx(() {
      final isSelected = controller.selectedMeal.value == value;
      return GestureDetector(
        onTap: () => controller.selectMeal(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? themeController.activeTheme.progressBarGradient
                : null,
            color: isSelected
                ? null
                : themeController.activeTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeController.activeTheme.borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(iconPath, width: 13, height: 13, fit: BoxFit.contain),
              const SizedBox(width: 6),
              Text(
                label,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
