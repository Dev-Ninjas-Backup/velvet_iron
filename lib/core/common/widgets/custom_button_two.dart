import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

class CustomButtonTwo extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomButtonTwo({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white),
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(50),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            label,
            style: getTextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 15.5,
            ),
          ),
        ),
      ),
    );
  }
}
