import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/auth/forgot_pass/screen/forgot_screen.dart';
import 'package:velvet_iron/features/auth/login/controller/login_controller.dart';

class RememberWidget extends StatelessWidget {
  const RememberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: controller.rememberMe.value,
            onChanged: (value) {
              controller.toggleRememberMe(value);
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        Text(
          'Remember me',
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Get.to(const ForgotScreen());
          },
          child: Text(
            'Forgot Password?',
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

