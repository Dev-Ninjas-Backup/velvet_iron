import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/set_password/validation/set_password_validation.dart';
import 'package:velvet_iron/features/auth/set_password/model/set_password_model.dart';

class SetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var passwordObscured = true.obs;
  var confirmPasswordObscured = true.obs;

  void togglePasswordVisibility() =>
      passwordObscured.value = !passwordObscured.value;
  void toggleConfirmPasswordVisibility() =>
      confirmPasswordObscured.value = !confirmPasswordObscured.value;

  String? passwordValidator(String? value) {
    return SetPasswordValidation.validatePassword(value);
  }

  String? confirmPasswordValidator(String? value) {
    return SetPasswordValidation.validateConfirmPassword(
      passwordController.text,
      value,
    );
  }

  SetPasswordModel? buildModel() {
    if (formKey.currentState?.validate() ?? false) {
      return SetPasswordModel(password: passwordController.text.trim());
    }
    return null;
  }

  void updatePassword() {
    final model = buildModel();
    if (model != null) {
      Get.offNamed('/loginScreen');
    } else {
      Get.snackbar('Error', 'Please fix the errors');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
