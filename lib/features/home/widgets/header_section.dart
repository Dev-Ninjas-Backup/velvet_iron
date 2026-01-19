import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  IconPath.trophy,
                  width: 14,
                  height: 14,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 6),
                Text(
                  "Unbound | 220 xp",
                  style: getTextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
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
          child: Image.asset("assets/icons/action1.png", width: 24, height: 24),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xCC521212),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            "assets/icons/progress.png",
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
