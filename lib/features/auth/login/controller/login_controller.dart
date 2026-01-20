import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/login/validation/login_validation.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController userIdentifierController;
  late final TextEditingController passwordController;

  final rememberMe = false.obs;
  final passwordObscured = true.obs;

  @override
  void onInit() {
    super.onInit();
    userIdentifierController = TextEditingController();
    passwordController = TextEditingController();
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void togglePasswordVisibility() {
    passwordObscured.toggle();
  }

  String? userIdentifierValidator(String? value) {
    return LoginValidation.validateUsernameOrEmail(value);
  }

  String? passwordValidator(String? value) {
    return LoginValidation.validatePassword(value);
  }

  void login() {
    if (!formKey.currentState!.validate()) return;

    // Remove login screen completely (IMPORTANT)
    Get.offNamed(AppRoute.welcomeScreen);
  }

  @override
  void onClose() {
    // Avoid disposing controllers here to prevent 'used after dispose'
    // errors when the controller lifecycle is managed by GetX navigation.
    super.onClose();
  }
}
