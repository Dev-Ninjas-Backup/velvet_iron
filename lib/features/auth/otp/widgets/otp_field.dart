import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/otp/controller/otp_controller.dart';

class OtpField extends StatelessWidget {
  const OtpField({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.find<OtpController>();
    return SizedBox(
      height: 52,
      child: Form(
        key: controller.formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return Container(
              width: 80.25,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF521212),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF6B1717), width: 1.0),
              ),
              child: TextFormField(
                controller: controller.otpControllers[index],
                focusNode: controller.focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 1,
                onChanged: (value) => controller.onOtpChanged(value, index),
                validator: controller.validateOtp,
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: '-',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
