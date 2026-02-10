import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  Future<void> updatePassword() async {
    try {
      EasyLoading.show(status: 'Securing your Codex...');
      await Future.delayed(const Duration(milliseconds: 1500));

      EasyLoading.showSuccess('Password Updated Successfully!');
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();
    } catch (e) {
      EasyLoading.showError('Failed to update password');
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
