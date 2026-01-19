import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Ensure this import is here

class CameraBox extends StatelessWidget {
  const CameraBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 291,
      height: 234,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MobileScanner(
          // MobileScannerController can be used here if you need to control the flash/camera
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
          },
        ),
      ),
    );
  }
}
