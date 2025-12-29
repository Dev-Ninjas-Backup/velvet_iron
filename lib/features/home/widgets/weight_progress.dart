




import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

class WeightProgress extends StatelessWidget {
  const WeightProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Weight Progress (kg)",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  Text(
                    "This week",
                    style: TextStyle(color: AppColors.gold, fontSize: 14),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
              (index) => Container(
                width: 18,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
