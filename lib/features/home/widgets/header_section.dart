import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/images/homeProfile.png'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Varga Boglárka",
              style: getTextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Adventurer | 550 xp ⭐",
              style: getTextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xCC521212),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            "assets/icons/action1.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xCC521212),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            "assets/icons/action2.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
