import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/qr_code_scan/widgets/scan_barcode_frame.dart';

class QrcodeScanScreen extends StatelessWidget {
  const QrcodeScanScreen({super.key});
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: themeController.activeTheme.backgroundGradient,
                ),
              ),
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
              const SafeArea(
                child: Center(
                  // Centers the entire frame
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
