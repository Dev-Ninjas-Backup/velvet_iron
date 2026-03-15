import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/controller/scan_barcode_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/controller/meal_log_controller.dart';

class ScanActionButtons extends StatelessWidget {
  const ScanActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  try {
                    final scanController = Get.find<ScanBarcodeController>();
                    final mealLogController = Get.find<MealLogController>();

                    final carbs = scanController.carbs.text.trim();
                    final protein = scanController.protein.text.trim();
                    final fats = scanController.fats.text.trim();

                    if (carbs.isNotEmpty &&
                        protein.isNotEmpty &&
                        fats.isNotEmpty) {
                      mealLogController.populateNutritionFromScan(
                        carbs: carbs,
                        protein: protein,
                        fats: fats,
                      );
                      debugPrint(
                        '[ScanActionButtons] Data transferred to MealLogController',
                      );
                    } else {
                      debugPrint(
                        '[ScanActionButtons] ⚠️ Nutrition fields are empty',
                      );
                    }
                  } catch (e) {
                    debugPrint(
                      '[ScanActionButtons] ❌ Error transferring data: $e',
                    );
                  }
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: themeController.activeTheme.progressBarGradient,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
