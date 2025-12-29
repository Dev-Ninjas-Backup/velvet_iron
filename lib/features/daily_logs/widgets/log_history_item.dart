import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class LogHistoryItem extends StatelessWidget {
  const LogHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF521212),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(IconPath.goodEmoji, width: 30, height: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text("Feeling Good", style: getTextStyle(fontSize: 14)),
              ),
              Text("+10 XP", style: getTextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              ImageIcon(
                AssetImage(IconPath.star),
                size: 12,
                color: const Color(0xFFDCAA64),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Moderate & Hungry",
                style: getTextStyle(
                  fontSize: 12,
                  color: const Color(0xFFB43737),
                ),
              ),
              const Spacer(),
              Text("12 Dec, Wed - 09:30 AM", style: getTextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
