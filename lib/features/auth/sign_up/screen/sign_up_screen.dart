import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/common/widgets/custom_text_field.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/auth/sign_up/controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
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
              padding: const EdgeInsets.only(
                top: 82,
                left: 16,
                right: 16,
                bottom: 30,
              ),
              child: Form(
                key: controller.formKey,
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
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Sign Up With Velvet & Iron Training Codex',
                        style: getTextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Email:',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'yourmail@example.com',
                      controller: controller.emailController,
                      validator: controller.emailValidator,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Username:',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: 'Enter your username',
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Password:',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                              height: 5,
                              width: 5,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Confirm Password:',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => CustomTextField(
                        hintText: '********',
                        obscureText: controller.confirmPasswordObscured.value,
                        controller: controller.confirmPasswordController,
                        validator: controller.confirmPasswordValidator,
                        suffixIcon: GestureDetector(
                          onTap: controller.toggleConfirmPasswordVisibility,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              IconPath.eye,
                              height: 5,
                              width: 5,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButtonTwo(
                      label: 'Sign Up',
                      onPressed: () {
                        controller.signUp();
                      },
                    ),
                    const SizedBox(height: 90),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: getTextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log in!',
                              style: getTextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed('/loginScreen');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
