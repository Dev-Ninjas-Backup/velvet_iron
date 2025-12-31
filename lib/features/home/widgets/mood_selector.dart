import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'label': 'Tired', 'icon': IconPath.tiredEmoji},
      {'label': 'Good', 'icon': IconPath.goodEmoji},
      {'label': 'Pissed', 'icon': IconPath.pissedEmoji},
      {'label': 'Great', 'icon': IconPath.greatEmoji},
      {'label': 'Poor', 'icon': IconPath.poorEmoji},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "How are you feeling?",
          style: getTextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...moods.map(
              (m) => Container(
                width: 55,
                height: 80,
                padding: const EdgeInsets.only(top: 0, bottom: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textFieldBorderColor),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Image.asset(m['icon']!, width: 24, height: 24),
                      ),
                    ),

                    Text(
                      m['label']!,
                      style: getTextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              width: 50,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  "+\nAdd\n+05 xp",
                  textAlign: TextAlign.center,
                  style: getTextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
