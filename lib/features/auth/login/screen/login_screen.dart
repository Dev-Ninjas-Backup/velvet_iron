import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_text_field.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/auth/login/widgets/remember_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 162, left: 16, right: 16),
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
            Center(
              child: Text(
                'Login to Velvet & Iron Training Codex',
                style: getTextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 62),
            Text(
              'Username *',
              style: getTextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            CustomTextField(hintText: 'yourmail@example.com'),
            SizedBox(height: 12),
            Text(
              'Password *',
              style: getTextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            CustomTextField(hintText: '********', obscureText: true),
            SizedBox(height: 12),
            RememberWidget(),
            SizedBox(height: 30),
            CustomButton(
              label: 'Login',
              onPressed: () {
                Get.toNamed(AppRoute.getwelcomeScreen());
              },
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Divider(color: const Color(0xFFE9B86E), thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or continue with',
                    style: getTextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: const Color(0xFFE9B86E), thickness: 1),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(IconPath.googleIcon, height: 46, width: 46),
                SizedBox(width: 26),
                Image.asset(IconPath.facebookIcon, height: 46, width: 46),
                SizedBox(width: 26),
                Image.asset(IconPath.discordIcon, height: 46, width: 46),
              ],
            ),
            SizedBox(height: 57),
            Center(
              child: RichText(
                text: TextSpan(
                  style: getTextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: 'New adventurer? '),
                    TextSpan(
                      text: 'Sign Up!',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed('/signUpScreen');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
