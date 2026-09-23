import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/controller/scan_barcode_controller.dart';
import 'camera_box.dart';
import 'nutrition_fields.dart';
import 'scan_action_buttons.dart';

class ScanBarcodeFrame extends StatelessWidget {
  const ScanBarcodeFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return GetBuilder<ScanBarcodeController>(
          builder: (scanController) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  width: 4,
                  color: themeController
                      .activeTheme
                      .progressBarGradient
                      .colors
                      .first
                      .withValues(alpha: 0.5),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 16,
                right: 20,
                bottom: 25,
                left: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Scan Barcode",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Test sample button
                          IconButton(
                            icon: const Icon(
                              Icons.science_outlined,
                              color: Colors.amberAccent,
                              size: 22,
                            ),
                            tooltip: "Test Sample Barcode (Nutella)",
                            onPressed: () {
                              scanController.testSampleBarcode('3017620422003');
                            },
                          ),
                          // Gallery picker button
                          IconButton(
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white70,
                              size: 22,
                            ),
                            tooltip: "Scan from Gallery",
                            onPressed: () {
                              scanController.pickImageAndScan();
                            },
                          ),
                          // Close button
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 22,
                            ),
                            tooltip: "Close",
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const CameraBox(),
                  if (scanController.productName.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.accentGoldColor
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: themeController.activeTheme.accentGoldColor
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.greenAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              "${scanController.productName} (per 100g)",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const NutritionFields(),
                  const SizedBox(height: 24),
                  const ScanActionButtons(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
