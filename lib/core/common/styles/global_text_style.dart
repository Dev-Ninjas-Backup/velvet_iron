import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  Color color = AppColors.textColor,
}) {
  return GoogleFonts.playfairDisplay(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
  );
}
