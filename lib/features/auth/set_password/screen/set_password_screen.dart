import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/common/widgets/custom_text_field.dart';
import 'package:velvet_iron/features/auth/set_password/controller/set_password_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SetPasswordController controller = Get.put(SetPasswordController());

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
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => CustomTextField(
                            hintText: '********',
                            obscureText: controller.passwordObscured.value,
                            controller: controller.passwordController,
                            validator: controller.passwordValidator,
                            suffixIcon: GestureDetector(
                              onTap: controller.togglePasswordVisibility,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  IconPath.eye,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                        Obx(
                          () => CustomTextField(
                            hintText: '********',
                            obscureText:
                                controller.confirmPasswordObscured.value,
                            controller: controller.confirmPasswordController,
                            validator: controller.confirmPasswordValidator,
                            suffixIcon: GestureDetector(
                              onTap: controller.toggleConfirmPasswordVisibility,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  IconPath.eye,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  Obx(
                    () => CustomButtonTwo(
                      label: 'Update Password',
                      onPressed: controller.isLoading.value
                          ? () {}
                          : () {
                              controller.updatePassword();
                            },
                    ),
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
