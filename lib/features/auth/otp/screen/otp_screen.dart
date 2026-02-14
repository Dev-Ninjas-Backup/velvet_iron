import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/auth/otp/controller/otp_controller.dart';
import 'package:velvet_iron/features/auth/otp/widgets/otp_field.dart';

class OtpScreen extends StatelessWidget {
  final String previousPage;
  const OtpScreen({super.key, required this.previousPage});

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.put(OtpController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.authBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: 82,
                left: 16,
                right: 16,
                bottom: 30,
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
                  Center(
                    child: Obx(
                      () => Text(
                        'Please check your mail ${controller.getMaskedEmail()} to see the verification code',
                        style: getTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                  const OtpField(),
                  SizedBox(height: 30),
                  Obx(
                    () => CustomButtonTwo(
                      label: 'Verify',
                      onPressed: controller.isLoading.value
                          ? () {}
                          : () {
                              controller.verifyOtp(previousPage);
                            },
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        bool canResend = controller.remainingSeconds.value == 0;
                        return GestureDetector(
                          onTap: canResend
                              ? () => controller.resendOtp()
                              : null,
                          child: Text(
                            'Resend code',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: canResend
                                  ? AppColors.primaryColor
                                  : AppColors.textColor.withValues(alpha: 0.5),
                              decoration: canResend
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        );
                      }),
                      Obx(() {
                        final int secs = controller.remainingSeconds.value;
                        final String minutes = (secs ~/ 60).toString();
                        final String seconds = (secs % 60).toString().padLeft(
                          2,
                          '0',
                        );
                        return Text(
                          '$minutes:$seconds',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
