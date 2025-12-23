import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final double? width;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width ?? Get.width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        validator: validator,

        style: getTextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          // ignore: deprecated_member_use
          color: AppColors.textColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.textFieldFillColor,
          hintText: hintText,
          hintStyle: getTextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            // ignore: deprecated_member_use
            color: AppColors.textColor,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.textFieldBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.textFieldBorderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: AppColors.textFieldBorderColor,
              width: 2.0,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
        ),
      ),
    );
  }
}
