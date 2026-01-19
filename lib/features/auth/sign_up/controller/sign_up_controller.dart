import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/otp/screen/otp_screen.dart';
import 'package:velvet_iron/features/auth/sign_up/validation/signup_validation.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var passwordObscured = true.obs;
  var confirmPasswordObscured = true.obs;

  void togglePasswordVisibility() {
    passwordObscured.value = !passwordObscured.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordObscured.value = !confirmPasswordObscured.value;
  }

  String? nameValidator(String? value) {
    return SignUpValidation.validateName(value);
  }

  String? emailValidator(String? value) {
    return SignUpValidation.validateEmail(value);
  }

  String? passwordValidator(String? value) {
    return SignUpValidation.validatePassword(value);
  }

  String? confirmPasswordValidator(String? value) {
    return SignUpValidation.validateConfirmPassword(passwordController.text, value);
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      Get.to(const OtpScreen(previousPage: 'SignUpScreen'));
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
