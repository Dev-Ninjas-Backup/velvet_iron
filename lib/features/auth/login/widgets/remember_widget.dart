import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/auth/forgot_pass/screen/forgot_screen.dart';

class RememberWidget extends StatelessWidget {
  const RememberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
          activeColor: Colors.white,
          checkColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        Text(
          'Remember me',
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Get.to(ForgotScreen());
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
