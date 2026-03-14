import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/controller/scan_barcode_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/widgets/scan_barcode_frame.dart';

class QrcodeScanScreen extends StatelessWidget {
  const QrcodeScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Use Get.put only if not already registered, preventing duplicate instances
    if (!Get.isRegistered<ScanBarcodeController>()) {
      Get.put<ScanBarcodeController>(ScanBarcodeController());
      debugPrint('[QrcodeScanScreen] ScanBarcodeController registered');
    } else {
      debugPrint(
        '[QrcodeScanScreen] ScanBarcodeController already registered — reusing',
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: themeController.activeTheme.backgroundGradient,
                ),
              ),
              // Background image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    themeController.activeTheme.backgroundImage,
                    width: 378,
                    height: 411,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Main content
              const SafeArea(
                child: Center(
                  child: SingleChildScrollView(child: ScanBarcodeFrame()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
