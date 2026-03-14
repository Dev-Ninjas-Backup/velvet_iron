import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/qr_code_scan/controller/scan_barcode_controller.dart';

class CameraBox extends StatelessWidget {
  const CameraBox({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Use the controller's shared MobileScannerController
    // instead of creating a new one here — avoids duplicate camera instances
    final scanController = Get.find<ScanBarcodeController>();

    debugPrint('[CameraBox] build — using shared mobileScannerController');

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
          // FIX: Reuse the controller from ScanBarcodeController
          controller: scanController.mobileScannerController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            debugPrint(
              '[CameraBox] onDetect — ${barcodes.length} barcode(s) found',
            );

            for (final barcode in barcodes) {
              final raw = barcode.rawValue;
              debugPrint(
                '[CameraBox] Barcode rawValue: "$raw", format: ${barcode.format}',
              );

              if (raw != null && raw.isNotEmpty) {
                // FIX: Delegate all logic (dedup + stop/start) to the controller
                scanController.onBarcodeDetected(raw);
              } else {
                debugPrint(
                  '[CameraBox] Barcode has null or empty rawValue — skipping',
                );
              }
            }
          },
          errorBuilder: (context, error, child) {
            debugPrint('[CameraBox] MobileScanner error: $error');
            return Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  'Camera Error: ${error.toString()}',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
