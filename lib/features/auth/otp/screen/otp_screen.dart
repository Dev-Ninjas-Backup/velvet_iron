import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class OtpScreen extends StatelessWidget {
  final String previousPage;
  const OtpScreen({super.key, required this.previousPage});

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
                'OTP Verification',
                style: getTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please check your mail you********ple.com to see the verification code',
              style: getTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 94),
            Text(
              'Otp Code',
              style: getTextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            OtpTextField(),
            SizedBox(height: 30),
            CustomButton(
              label: 'Verify',
              onPressed: () {
                if (previousPage == 'SignUpScreen') {
                  Get.offAllNamed('/loginScreen');
                } else {
                  Get.offAllNamed('/setPasswordScreen');
                }
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resend code to',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  '2:00',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
