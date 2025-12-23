import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.splashBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Velvet & Iron',
              style: getTextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Training Codex'.toUpperCase(),
              style: getTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: AppColors.subTextColor,
              ),
            ),
            SizedBox(height: 26),
            Image.asset(IconPath.splashIcon, height: 269, width: 272),
          ],
        ),
      ),
    );
  }
}
