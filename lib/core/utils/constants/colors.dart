import 'package:flutter/material.dart';

class AppColors {
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color subTextColor = Color(0xFFE0AF67);

  // Font colors
  static const Color primaryFontColor = Color(0xFF141414);

  // TextField colors
  static const Color textFieldFillColor = Color(0xFF521212);
  static const Color textFieldBorderColor = Color(0xFF6B1717);

  // Background & text colors
  static const Color backgroundColor = Color(0xFF1E1E1E);

  // Button gradient colors
  static const Color buttonGreen = Color(0xFF094831);

  static const Color primaryColor = Color(0xFF16A26F);

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFFFDE7BB),
      Color(0xFF9E6D38),
      Color(0xFFE9B86E),
      Color(0xFF9D6933),
      Color(0xFFFEE9BF),
      Color(0xFF683E23),
    ],
  );
}
