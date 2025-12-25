import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_text_field.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 82, left: 16, right: 16),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.authBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textFieldFillColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Setup New Password',
                style: getTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Enter New Password:',
              style: getTextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            CustomTextField(hintText: '********', obscureText: true),
            SizedBox(height: 12),
            Text(
              'Confirm New Password:',
              style: getTextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            CustomTextField(hintText: '********', obscureText: true),
            SizedBox(height: 12),
            Text(
              '* Password must be minimum 8 character',
              style: getTextStyle(
                fontSize: 12,
                color: Color(0xFFDCAA64),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            CustomButton(
              label: 'Update Password',
              onPressed: () {
                Get.offNamed('/loginScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
