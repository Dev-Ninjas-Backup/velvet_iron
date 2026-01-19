import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/daily_macro_goal/controller/daily_goal_controller.dart';

class DailyGoalAppBar extends StatelessWidget {
  final double size;

  const DailyGoalAppBar({this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF512212), Color(0xFF512212)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: size * 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Daily Macro Goal',
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyMacroGoalWidget extends StatelessWidget {
  const DailyMacroGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyGoalController>();

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
            color: const Color(0xFF723737).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF310101),
                  Color(0xFF550606),
                  Color(0xFF550606),
                  Color(0xFF310101),
                  Color(0xFF550606),
                  Color(0xFF310101),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFC69C56).withValues(alpha: 0.6),
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
                Text(
                  "729 kcal",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Carbs Input
          _buildInputLabel("Carbs"),
          _buildInputField(
            initialValue: controller.carbs.value.toString(),
            onChanged: (val) => controller.carbs.value = int.tryParse(val) ?? 0,
          ),

          const SizedBox(height: 20),

          // Protein Input
          _buildInputLabel("Protein"),
          _buildInputField(
            initialValue: controller.protein.value.toString(),
            onChanged: (val) =>
                controller.protein.value = int.tryParse(val) ?? 0,
          ),

          const SizedBox(height: 20),

          // Fats Input
          _buildInputLabel("Fats"),
          _buildInputField(
            initialValue: controller.fats.value.toString(),
            onChanged: (val) => controller.fats.value = int.tryParse(val) ?? 0,
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
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A0303),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF512212), width: 1.2),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixText: 'g',
          suffixStyle: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
