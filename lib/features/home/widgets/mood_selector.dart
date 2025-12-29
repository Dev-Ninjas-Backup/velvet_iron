import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = ['tired', 'good', 'pissed', 'great', 'poor'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How are you feeling?",
          style: TextStyle(color: Colors.white, fontSize: 20),
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
                  border: Border.all(color: AppColors.gold, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(Icons.mood, color: Colors.white, size: 24),
                      ),
                    ),

                    Text(
                      m,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  "+\nAdd\n+05 xp",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
