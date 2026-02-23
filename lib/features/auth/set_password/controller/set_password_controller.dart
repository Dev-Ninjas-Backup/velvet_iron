// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/set_password/service/set_password_service.dart'; // ← service import করা হয়েছে
import 'package:velvet_iron/features/auth/set_password/validation/set_password_validation.dart';
import 'package:velvet_iron/features/auth/set_password/model/set_password_model.dart';

class SetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final SetPasswordService _setPasswordService = SetPasswordService();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var passwordObscured = true.obs;
  var confirmPasswordObscured = true.obs;

  final RxBool isLoading = false.obs;

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

  Future<void> updatePassword() async {
    final model = buildModel();

    if (model == null) {
      print('Form validation failed');
      Get.snackbar('Error', 'Please fix the errors');
      return;
    }

    final String? email = await SharedPreferencesHelper.getEmail();

    if (email == null || email.isEmpty) {
      print('Email not found in SharedPreferences');
      Get.snackbar('Error', 'Session expired. Please try again.');
      return;
    }

    try {
      isLoading.value = true;
      print('Starting reset password process...');
      print('Email: $email');

      EasyLoading.show(status: 'Updating password...');

      final response = await _setPasswordService.resetPassword(
        email: email,
        newPassword: model.password,
      );

      print('Response received:');
      print('Success: ${response.isSuccess}');
      print('Status Code: ${response.statusCode}');
      print('Error Message: ${response.errorMessage}');
      print('Response Data: ${response.responseData}');

      EasyLoading.dismiss();

      if (response.isSuccess) {
        print('Password reset successful!');

        final message =
            response.responseData['message'] ?? 'Password reset successfully';

        EasyLoading.showSuccess(message);

        // Fields clear করা হচ্ছে
        passwordController.clear();
        confirmPasswordController.clear();

        await Future.delayed(const Duration(milliseconds: 800));

        print('Navigating to login screen...');
        Get.offAllNamed('/loginScreen');
      } else {
        print('Password reset failed!');
        print('Error: ${response.errorMessage}');
        EasyLoading.showError(response.errorMessage);
      }
    } catch (e, stackTrace) {
      print('Exception occurred:');
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
      print('Reset password process completed!');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
