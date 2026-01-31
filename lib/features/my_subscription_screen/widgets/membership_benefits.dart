import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class MembershipBenefits extends StatelessWidget {
  const MembershipBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    final benefits = [
      "Full advance health tracking features",
      "Playful & gamified personalized theme and companions ",
      "Daily quote and health tips",
      "Free access in advance discord community for  more advance activity ",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(IconPath.membershipIcon, height: 24),
            const SizedBox(width: 8),
            Text(
              "Membership Benefits",
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...benefits.map(
          (e) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.white, size: 18),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        e,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.2)),
            ],
          ),
        ),
      ],
    );
  }
}
