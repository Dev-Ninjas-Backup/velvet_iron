import 'package:flutter/material.dart';

class NutritionFields extends StatelessWidget {
  const NutritionFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel("Carbs"),
            _buildLabel("Protein"),
            _buildLabel("Fats"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildTextField(), _buildTextField(), _buildTextField()],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return SizedBox(
      width: 89,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      width: 89,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF6B1717),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE9B86E).withValues(alpha: .5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Text("g", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
