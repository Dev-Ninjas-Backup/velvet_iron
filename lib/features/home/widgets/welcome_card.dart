import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:AppColors.card,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/tree.png', height: 120),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(
                  "Welcome Back Adventurer",
                  textAlign: TextAlign.start,
                  style: getTextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your journey to wellness is a heroic quest. Track your daily progress.",
                  textAlign: TextAlign.start,
                  style: getTextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/book.png', height: 120),
        ],
      ),
    );
  }
}
