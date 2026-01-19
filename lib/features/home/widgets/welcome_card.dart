import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(ImagePath.tree, height: 144, width: 52),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back Adventurer",
                  textAlign: TextAlign.start,
                  maxLines: 2, // Allow up to 2 lines for the title
                  overflow: TextOverflow.ellipsis, // Add ellipsis if it still overflows
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
                  maxLines: 3, // Allow up to 3 lines for the description
                  overflow: TextOverflow.ellipsis, // Add ellipsis if it still overflows
                  style: getTextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100, // Constrain the width of the book image
            child: Image.asset('assets/images/book.png', height: 120),
          ),
        ],
      ),
    );
  }
}
