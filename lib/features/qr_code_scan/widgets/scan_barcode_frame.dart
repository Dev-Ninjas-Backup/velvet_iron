import 'package:flutter/material.dart';
import 'camera_box.dart';
import 'nutrition_fields.dart';
import 'scan_action_buttons.dart';

class ScanBarcodeFrame extends StatelessWidget {
  const ScanBarcodeFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(width: 4, color: const Color(0xFFE9B86E)),
      ),
      padding: const EdgeInsets.only(top: 20, right: 24, bottom: 25, left: 24),
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
            ],
          ),
          const SizedBox(height: 20),
          const CameraBox(),
          const SizedBox(height: 24),
          const NutritionFields(),
          const SizedBox(height: 24),
          const ScanActionButtons(),
        ],
      ),
    );
  }
}
