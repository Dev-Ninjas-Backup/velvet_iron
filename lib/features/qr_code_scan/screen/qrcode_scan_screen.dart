import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/qr_code_scan/widgets/scan_barcode_frame.dart';

class QrcodeScanScreen extends StatelessWidget {
  const QrcodeScanScreen({super.key});
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              ImagePath.magicImage,
              width: 378,
              height: 411,
              fit: BoxFit.cover,
            ),
          ),
          const SafeArea(
            child: Center(
              // Centers the entire frame
              child: SingleChildScrollView(child: ScanBarcodeFrame()),
            ),
          ),
        ],
      ),
    );
  }
}
