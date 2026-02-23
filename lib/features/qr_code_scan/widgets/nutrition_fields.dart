import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class NutritionFields extends StatelessWidget {
  const NutritionFields({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildLabel("Carbs")),
                SizedBox(width: 8),
                Expanded(child: _buildLabel("Protein")),
                SizedBox(width: 8),
                Expanded(child: _buildLabel("Fats")),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildTextField(themeController)),
                SizedBox(width: 8),
                Expanded(child: _buildTextField(themeController)),
                SizedBox(width: 8),
                Expanded(child: _buildTextField(themeController)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return SizedBox(
      width: 89,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(AppThemeController themeController) {
    return Container(
      width: 89,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: themeController.activeTheme.textfieldColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: themeController.activeTheme.accentGoldColor.withValues(
            alpha: .5,
          ),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Text("g", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
