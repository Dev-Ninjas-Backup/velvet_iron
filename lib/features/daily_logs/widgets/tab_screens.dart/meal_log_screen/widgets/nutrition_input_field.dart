import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class NutritionInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const NutritionInputField({
    super.key,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98.33, // Fill width as requested
      height: 40, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A0303),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF5D2B2B), // Matching your card border color
          width: 1.11,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              cursorColor: const Color(0xFF914C4C),
              style: getTextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: getTextStyle(
                  fontSize: 12,
                  color: const Color(0xFF914C4C), // Suggestion text color
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Text("g", style: getTextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
