import 'package:flutter/material.dart';

class AppColors {
  // Font colors
  static const Color primaryFontColor = Color(0xFF141414);

  // TextField colors
  static const Color textFieldFillColor = Color(0xFFF5F5F5);

  // Background & text colors
  static const Color backgroundColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFFFFFFF);

  // Button gradient colors
  static const Color buttonGreen = Color(0xFF094831);

  static const Color primaryColor = Color(0xFF16A26F);

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [buttonGreen, Color(0xFF2E7D5A), Color(0xFF2E7D5A), buttonGreen],
  );
}
