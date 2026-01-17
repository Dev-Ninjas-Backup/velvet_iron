import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/controller/onboarding7_controller.dart';

class StepsTextWidget7 extends StatelessWidget {
  const StepsTextWidget7({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 7 / 9',
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

class ProgressBarWidget7 extends StatelessWidget {
  const ProgressBarWidget7({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController7());

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

class OnboardingHeaderWidget7 extends StatelessWidget {
  const OnboardingHeaderWidget7({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        "How are You Feeling Today?",
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

class MoodSelectionWidget extends StatelessWidget {
  const MoodSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController7>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Mood Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Select Mood:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Mood Options
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _buildMoodOption(
                iconPath: IconPath.tired,
                label: 'Tired',
                value: 'Tired',
                controller: controller,
              ),
              const SizedBox(width: 12),
              _buildMoodOption(
                iconPath: IconPath.good,
                label: 'Good',
                value: 'Good',
                controller: controller,
              ),
              const SizedBox(width: 12),
              _buildMoodOption(
                iconPath: IconPath.pissed,
                label: 'Pissed',
                value: 'Pissed',
                controller: controller,
              ),
              const SizedBox(width: 12),
              _buildMoodOption(
                iconPath: IconPath.great,
                label: 'Great',
                value: 'Great',
                controller: controller,
              ),
              const SizedBox(width: 12),
              _buildMoodOption(
                iconPath: IconPath.poor,
                label: 'Poor',
                value: 'Poor',
                controller: controller,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Energy Level:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildPillOption(
                label: 'Exhausted',
                value: 'Exhausted',
                selectedValue: controller.selectedEnergyLevel,
                onTap: () => controller.selectEnergyLevel('Exhausted'),
              ),
              _buildPillOption(
                label: 'Low',
                value: 'Low',
                selectedValue: controller.selectedEnergyLevel,
                onTap: () => controller.selectEnergyLevel('Low'),
              ),
              _buildPillOption(
                label: 'Moderate',
                value: 'Moderate',
                selectedValue: controller.selectedEnergyLevel,
                onTap: () => controller.selectEnergyLevel('Moderate'),
              ),
              _buildPillOption(
                label: 'Energized',
                value: 'Energized',
                selectedValue: controller.selectedEnergyLevel,
                onTap: () => controller.selectEnergyLevel('Energized'),
              ),
              _buildPillOption(
                label: 'High',
                value: 'High',
                selectedValue: controller.selectedEnergyLevel,
                onTap: () => controller.selectEnergyLevel('High'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Hunger Level:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildPillOption(
                label: 'Not Hungry',
                value: 'Not Hungry',
                selectedValue: controller.selectedHungerLevel,
                onTap: () => controller.selectHungerLevel('Not Hungry'),
              ),
              _buildPillOption(
                label: 'Hungry',
                value: 'Hungry',
                selectedValue: controller.selectedHungerLevel,
                onTap: () => controller.selectHungerLevel('Hungry'),
              ),
              _buildPillOption(
                label: 'Very Hungry',
                value: 'Very Hungry',
                selectedValue: controller.selectedHungerLevel,
                onTap: () => controller.selectHungerLevel('Very Hungry'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodOption({
    required String iconPath,
    required String label,
    required String value,
    required OnboardingController7 controller,
  }) {
    return Obx(() {
      final isSelected = controller.selectedMood.value == value;
      return GestureDetector(
        onTap: () => controller.selectMood(value),
        child: Container(
          width: 60.6,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
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
            border: Border.all(
              color: isSelected
                  ? Color(0xFF5D2B2B)
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFE5B46B).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 22, height: 24, fit: BoxFit.contain),
              const SizedBox(height: 4),
              Text(
                label,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPillOption({
    required String label,
    required String value,
    required RxString selectedValue,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final isSelected = selectedValue.value == value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            border: Border.all(
              color: isSelected
                  ? Color(0xFF5D2B2B)
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
