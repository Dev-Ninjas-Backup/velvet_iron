import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanActionButtons extends StatelessWidget {
  const ScanActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: OutlinedButton(
              onPressed: () {Get.back();},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Clear", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFDE7BB),
                    Color(0xFF9E6D38),
                    Color(0xFFE9B86E),
                    Color(0xFF683E23),
                  ],
                ),
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
  }
}
