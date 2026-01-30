import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class NutritionLoadingCard extends StatelessWidget {
  final String amount;
  final String label;
  final double progress;

  const NutritionLoadingCard({
    super.key,
    required this.amount,
    required this.label,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF521212).withValues(alpha: .4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Vertical 'Hug' behavior
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            amount,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6), // Spacer before loading bar
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF380404),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFDE7BB),
                        Color(0xFF9E6D38),
                        Color(0xFFE9B86E),
                        Color(0xFFE5B46B),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
