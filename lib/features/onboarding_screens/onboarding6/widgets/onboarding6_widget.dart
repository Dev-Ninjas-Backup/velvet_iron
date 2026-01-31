import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding6/controller/onboarding6_controller.dart';

class StepsTextWidget6 extends StatelessWidget {
  const StepsTextWidget6({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 7 / 11',
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

class ProgressBarWidget6 extends StatelessWidget {
  const ProgressBarWidget6({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController6());

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
                          Color(0xFFE5B46B),
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

class OnboardingHeaderWidget6 extends StatelessWidget {
  const OnboardingHeaderWidget6({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "What is your Weight?",
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

class WeightSelectionWidget extends StatelessWidget {
  const WeightSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController6>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUnitButton(
                label: 'lbs',
                isSelected: controller.selectedUnit,
                onTap: () => controller.selectUnit('lbs'),
              ),
              const SizedBox(width: 6),
              _buildUnitButton(
                label: 'kg',
                isSelected: controller.selectedUnit,
                onTap: () => controller.selectUnit('kg'),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Container(
            height: 50,
            width: 343,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF3A0303),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF6B1717)),
            ),
            child: TextField(
              controller: controller.weightController,
              style: getTextStyle(
                fontSize: 12,
                color: Colors.white,
              ).copyWith(letterSpacing: 1.5),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter current weight',
                labelStyle: getTextStyle(fontSize: 12, color: Colors.white),
                hintStyle: getTextStyle(fontSize: 12, color: Colors.white),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitButton({
    required String label,
    required RxString isSelected,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final selected = isSelected.value == label;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xFF3A0303),
            gradient: selected
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
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
