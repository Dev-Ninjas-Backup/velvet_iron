import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/controller/scan_barcode_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/widgets/scan_barcode_frame.dart';

class QrcodeScanScreen extends StatefulWidget {
  const QrcodeScanScreen({super.key});

  @override
  State<QrcodeScanScreen> createState() => _QrcodeScanScreenState();
}

class _QrcodeScanScreenState extends State<QrcodeScanScreen> {
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ScanBarcodeController>()) {
      Get.delete<ScanBarcodeController>();
    }
    Get.put<ScanBarcodeController>(ScanBarcodeController());
    debugPrint('[QrcodeScanScreen] Fresh ScanBarcodeController registered');
  }

  @override
  void dispose() {
    if (Get.isRegistered<ScanBarcodeController>()) {
      Get.delete<ScanBarcodeController>();
      debugPrint('[QrcodeScanScreen] ScanBarcodeController disposed');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                  opacity: 0.40,
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
