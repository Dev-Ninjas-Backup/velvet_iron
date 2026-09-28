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
            final errorMsg = error.toString().toLowerCase();
            if (errorMsg.contains('already started')) {
              // Harmless state race — camera is already running
              return const SizedBox.shrink();
            }
            return Container(
              color: const Color(0xFF141414),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white54,
                      size: 36,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Camera unavailable.\nScan from gallery or enter manually.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => scanController.pickImageAndScan(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Choose from Gallery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
