import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/controller/onboarding8_controller.dart';

class StepsTextWidget8 extends StatelessWidget {
  const StepsTextWidget8({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 9 / 11',
            style: getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Image.asset(IconPath.trophy, width: 8, height: 14),
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

class ProgressBarWidget8 extends StatelessWidget {
  const ProgressBarWidget8({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController8());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFDE7BB),
                          Color(0xFF9E6D38),
                          Color(0xFFE9B86E),
                          Color(0xFF9D6933),
                          Color(0xFFFEE9BF),
                          Color(0xFF683E23),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingHeaderWidget8 extends StatelessWidget {
  const OnboardingHeaderWidget8({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        "Which meals have you had so far today?",
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

class MealSelectionWidget8 extends StatelessWidget {
  const MealSelectionWidget8({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController8>();

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
  }

  Widget _buildMealOption({
    required String iconPath,
    required String label,
    required String value,
    required OnboardingController8 controller,
  }) {
    return Obx(() {
      final isSelected = controller.selectedMeal.value == value;
      return GestureDetector(
        onTap: () => controller.selectMeal(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xFFFDE7BB),
                      Color(0xFF9E6D38),
                      Color(0xFFE9B86E),
                      Color(0xFF9D6933),
                      Color(0xFFFEE9BF),
                      Color(0xFF683E23),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : const Color(0xFF3A0303),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFF5D2B2B), width: 1.5),
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

class FoodInputWidget8 extends StatelessWidget {
  const FoodInputWidget8({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController8>();

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3A0303).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF6B1717), width: 1),
            ),
            child: TextField(
              controller: controller.foodController,
              maxLines: 3,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF914C4C),
              ),
              decoration: InputDecoration(
                hintText: 'Grilled chicken salad with olive oil dressing...',
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
  }
}

class CalorieInputWidget8 extends StatelessWidget {
  const CalorieInputWidget8({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController8>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consume Calories:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF3A0303).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.calorieController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: getTextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Optional',
                      hintStyle: getTextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                Text(
                  'g',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
