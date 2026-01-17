import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class CustomLogContainer extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final String rewardAmount;

  const CustomLogContainer({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    required this.rewardAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 167.5,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF521212),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            children: [
              Image.asset(iconPath, width: 36, height: 36),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      value,
                      style: getTextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Bottom Row
          Row(
            children: [
              Text(
                "Total Rewards:",
                style: getTextStyle(
                  color: const Color(0xFFB43737),
                  fontSize: 10,
                ),
              ),

              const Spacer(),

              Text(
                "$rewardAmount XP",
                style: getTextStyle(
                  color: const Color(0xFFB43737),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
