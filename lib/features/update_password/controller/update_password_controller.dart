import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void toggleOldPassword() => isOldPasswordVisible.toggle();
  void toggleNewPassword() => isNewPasswordVisible.toggle();
  void toggleConfirmPassword() => isConfirmPasswordVisible.toggle();
}