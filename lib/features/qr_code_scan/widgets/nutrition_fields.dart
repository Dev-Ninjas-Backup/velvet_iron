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
                // Serving Size & Unit Selector
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: themeController.activeTheme.borderColor.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Serving / Portion Size:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (scanController.servingSizeText.isNotEmpty)
                            Text(
                              "Pkg: ${scanController.servingSizeText}",
                              style: const TextStyle(
                                color: Color(0xFFD6B36A),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Quantity input
                          SizedBox(
                            width: 65,
                            height: 38,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color:
                                    themeController.activeTheme.textfieldColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: themeController
                                      .activeTheme
                                      .accentGoldColor
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: scanController.quantityController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (val) =>
                                      scanController.onQuantityChanged(val),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Unit dropdown
                          Expanded(
                            child: Container(
                              height: 38,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color:
                                    themeController.activeTheme.textfieldColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: themeController
                                      .activeTheme
                                      .accentGoldColor
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: scanController.selectedUnit,
                                  dropdownColor: themeController
                                      .activeTheme
                                      .dropdownBackgroundColor,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  items: scanController.availableUnits.map((u) {
                                    String label = u;
                                    if (u == 'Serving' &&
                                        scanController
                                            .servingSizeText
                                            .isNotEmpty) {
                                      label =
                                          '1 Serving (${scanController.servingSizeText})';
                                    }
                                    return DropdownMenuItem<String>(
                                      value: u,
                                      child: Text(
                                        label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newUnit) {
                                    if (newUnit != null) {
                                      scanController.setUnit(newUnit);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Labels row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildLabel("Carbs")),
                    const SizedBox(width: 6),
                    Expanded(child: _buildLabel("Protein")),
                    const SizedBox(width: 6),
                    Expanded(child: _buildLabel("Fats")),
                    const SizedBox(width: 6),
                    Expanded(child: _buildLabel("Calories")),
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
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildTextField(
                        themeController,
                        scanController.protein,
                        'Protein',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildTextField(
                        themeController,
                        scanController.fats,
                        'Fats',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildTextField(
                        themeController,
                        scanController.calories,
                        'Calories',
                        unit: 'kcal',
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
    String fieldName, {
    String unit = 'g',
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              style: const TextStyle(color: Colors.white, fontSize: 13),
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
          Text(unit, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
