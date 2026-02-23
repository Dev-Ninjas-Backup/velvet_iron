import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/controller/onboarding7_controller.dart';

class MoodSelectionWidget extends StatelessWidget {
  const MoodSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController7>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        // Select mood emojis based on active theme
        final moodEmojis = {
          'Tired': themeController.activeTheme.id == 'gamer'
              ? IconPath.tiredEmojiGreen
              : themeController.activeTheme.id == 'mage'
              ? IconPath.tiredEmojiPurple
              : themeController.activeTheme.id == 'reader'
              ? IconPath.tiredEmojiWhite
              : IconPath.tiredEmoji,
          'Good': themeController.activeTheme.id == 'gamer'
              ? IconPath.goodEmojiGreen
              : themeController.activeTheme.id == 'mage'
              ? IconPath.goodEmojiPurple
              : themeController.activeTheme.id == 'reader'
              ? IconPath.goodEmojiWhite
              : IconPath.goodEmoji,
          'Pissed': themeController.activeTheme.id == 'gamer'
              ? IconPath.pissedEmojiGreen
              : themeController.activeTheme.id == 'mage'
              ? IconPath.pissedEmojiPurple
              : themeController.activeTheme.id == 'reader'
              ? IconPath.pissedEmojiWhite
              : IconPath.pissedEmoji,
          'Great': themeController.activeTheme.id == 'gamer'
              ? IconPath.greatEmojiGreen
              : themeController.activeTheme.id == 'mage'
              ? IconPath.greatEmojiPurple
              : themeController.activeTheme.id == 'reader'
              ? IconPath.greatEmojiWhite
              : IconPath.greatEmoji,
          'Poor': themeController.activeTheme.id == 'gamer'
              ? IconPath.poorEmojiGreen
              : themeController.activeTheme.id == 'mage'
              ? IconPath.poorEmojiPurple
              : themeController.activeTheme.id == 'reader'
              ? IconPath.poorEmojiWhite
              : IconPath.poorEmoji,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Mood:',
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
                  _buildMoodOption(
                    iconPath: moodEmojis['Tired']!,
                    label: 'Tired',
                    value: 'Tired',
                    controller: controller,
                  ),
                  const SizedBox(width: 6),
                  _buildMoodOption(
                    iconPath: moodEmojis['Good']!,
                    label: 'Good',
                    value: 'Good',
                    controller: controller,
                  ),
                  const SizedBox(width: 6),
                  _buildMoodOption(
                    iconPath: moodEmojis['Pissed']!,
                    label: 'Pissed',
                    value: 'Pissed',
                    controller: controller,
                  ),
                  const SizedBox(width: 6),
                  _buildMoodOption(
                    iconPath: moodEmojis['Great']!,
                    label: 'Great',
                    value: 'Great',
                    controller: controller,
                  ),
                  const SizedBox(width: 6),
                  _buildMoodOption(
                    iconPath: moodEmojis['Poor']!,
                    label: 'Poor',
                    value: 'Poor',
                    controller: controller,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Energy Level:',
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
                  _buildPillOption(
                    label: 'Exhausted',
                    value: 'Exhausted',
                    selectedValue: controller.selectedEnergyLevel,
                    onTap: () => controller.selectEnergyLevel('Exhausted'),
                  ),
                  const SizedBox(width: 8),
                  _buildPillOption(
                    label: 'Low',
                    value: 'Low',
                    selectedValue: controller.selectedEnergyLevel,
                    onTap: () => controller.selectEnergyLevel('Low'),
                  ),
                  const SizedBox(width: 8),
                  _buildPillOption(
                    label: 'Moderate',
                    value: 'Moderate',
                    selectedValue: controller.selectedEnergyLevel,
                    onTap: () => controller.selectEnergyLevel('Moderate'),
                  ),
                  const SizedBox(width: 8),
                  _buildPillOption(
                    label: 'Energized',
                    value: 'Energized',
                    selectedValue: controller.selectedEnergyLevel,
                    onTap: () => controller.selectEnergyLevel('Energized'),
                  ),
                  const SizedBox(width: 8),
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
            Text(
              'Hunger Level:',
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
                  _buildPillOption(
                    label: 'Not Hungry',
                    value: 'Not Hungry',
                    selectedValue: controller.selectedHungerLevel,
                    onTap: () => controller.selectHungerLevel('Not Hungry'),
                  ),
                  const SizedBox(width: 8),
                  _buildPillOption(
                    label: 'Hungry',
                    value: 'Hungry',
                    selectedValue: controller.selectedHungerLevel,
                    onTap: () => controller.selectHungerLevel('Hungry'),
                  ),
                  const SizedBox(width: 8),
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
      },
    );
  }

  Widget _buildMoodOption({
    required String iconPath,
    required String label,
    required String value,
    required OnboardingController7 controller,
  }) {
    final themeController = Get.find<AppThemeController>();

    return Obx(() {
      final isSelected = controller.selectedMood.value == value;
      return GestureDetector(
        onTap: () => controller.selectMood(value),
        child: Container(
          width: 70,
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: isSelected
                ? themeController.activeTheme.progressBarGradient
                : null,
            color: isSelected
                ? null
                : themeController.activeTheme.cardBackgroundColor,
            border: Border.all(
              color: isSelected
                  ? themeController.activeTheme.borderColor
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: themeController.activeTheme.accentGoldColor
                          .withValues(alpha: 0.4),
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
    final themeController = Get.find<AppThemeController>();

    return Obx(() {
      final isSelected = selectedValue.value == value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? themeController.activeTheme.progressBarGradient
                : null,
            color: isSelected
                ? null
                : themeController.activeTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? themeController.activeTheme.borderColor
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
