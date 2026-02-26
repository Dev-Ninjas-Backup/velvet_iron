import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_macro_goal/controller/daily_goal_controller.dart';

class DailyMacroGoalWidget extends StatelessWidget {
  const DailyMacroGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyGoalController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setup Daily Macro Goal',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: themeController.activeTheme.borderColor.withValues(
                  alpha: 0.5,
                ),
              ),
              const SizedBox(height: 16),

              _buildCaloriesGoalBox(themeController, controller),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: themeController.activeTheme.borderColor.withValues(
                      alpha: 0.5,
                    ),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Carbs"),
                    _buildInputField(
                      themeController: themeController,
                      controller: controller.carbsController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputLabel("Protein"),
                    _buildInputField(
                      themeController: themeController,
                      controller: controller.proteinController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputLabel("Fats"),
                    _buildInputField(
                      themeController: themeController,
                      controller: controller.fatsController,
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

  //  Calories box
  Widget _buildCaloriesGoalBox(
    AppThemeController themeController,
    DailyGoalController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: themeController.activeTheme.backgroundGradient,
        border: Border.all(
          color: themeController.activeTheme.accentGoldColor.withValues(
            alpha: 0.6,
          ),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Daily Calories Goal:",
            style: getTextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          // Reactive — updates live as user types
          Obx(
            () => Text(
              '${controller.totalCalories} kcal',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  //  TextEditingController  API data auto-populate
  Widget _buildInputField({
    required AppThemeController themeController,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeController.activeTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.activeTheme.borderColor,
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: getTextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          suffixText: 'g',
          suffixStyle: getTextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
