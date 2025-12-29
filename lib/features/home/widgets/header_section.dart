import 'package:flutter/material.dart';

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
          children: const [
            Text(
              "Varga Boglárka",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "Adventurer | 550 xp ⭐",
              style: TextStyle(color: Colors.white70),
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
          child: const Icon(Icons.wb_sunny, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xCC521212),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.wb_sunny, color: Colors.white),
        ),
      ],
    );
  }
}
