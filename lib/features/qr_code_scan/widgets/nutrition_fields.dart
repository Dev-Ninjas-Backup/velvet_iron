import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/controller/scan_barcode_controller.dart';

class NutritionFields extends StatelessWidget {
  const NutritionFields({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Wrap with GetBuilder<ScanBarcodeController> so fields rebuild
    // when update() is called after a successful barcode scan
    return GetBuilder<ScanBarcodeController>(
      builder: (scanController) {
        debugPrint(
          '[NutritionFields] rebuild — '
          'carbs="${scanController.carbs.text}", '
          'protein="${scanController.protein.text}", '
          'fats="${scanController.fats.text}"',
        );

        return GetBuilder<AppThemeController>(
          builder: (themeController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Labels row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildLabel("Carbs")),
                    const SizedBox(width: 8),
                    Expanded(child: _buildLabel("Protein")),
                    const SizedBox(width: 8),
                    Expanded(child: _buildLabel("Fats")),
                  ],
                ),
                const SizedBox(height: 8),
                // Input fields row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        themeController,
                        scanController.carbs,
                        'Carbs',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        themeController,
                        scanController.protein,
                        'Protein',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        themeController,
                        scanController.fats,
                        'Fats',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  Widget _buildTextField(
    AppThemeController themeController,
    TextEditingController controller,
    String fieldName,
  ) {
    return Container(
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
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) {
                debugPrint(
                  '[NutritionFields] $fieldName changed manually to: "$val"',
                );
              },
            ),
          ),
          const Text("g", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
