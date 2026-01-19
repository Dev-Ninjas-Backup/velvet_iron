import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/login/validation/login_validation.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController userIdentifierController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var rememberMe = false.obs;
  var passwordObscured = true.obs;

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void togglePasswordVisibility() {
    passwordObscured.value = !passwordObscured.value;
  }

  String? userIdentifierValidator(String? value) {
    return LoginValidation.validateUsernameOrEmail(value);
  }

  String? passwordValidator(String? value) {
    return LoginValidation.validatePassword(value);
  }

  void login() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(AppRoute.getwelcomeScreen());
    }
  }

  @override
  void onClose() {
    userIdentifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
