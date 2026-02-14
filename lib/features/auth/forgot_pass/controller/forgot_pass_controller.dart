// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/forgot_pass/forgot_password_service.dart';
import 'package:velvet_iron/features/auth/forgot_pass/validation/forgot_validation.dart';
import 'package:velvet_iron/features/auth/forgot_pass/model/forgot_pass_model.dart';
import 'package:velvet_iron/features/auth/otp/screen/otp_screen.dart';

class ForgotPassController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();
  final RxBool isLoading = false.obs;

  String? validateEmail(String? value) {
    return ForgotValidation.validateEmail(value);
  }

  ForgotPassModel? buildModel() {
    if (formKey.currentState?.validate() ?? false) {
      return ForgotPassModel(email: emailController.text.trim());
    }
    return null;
  }

  Future<void> submitForgotPassword() async {
    final model = buildModel();

    if (model == null) {
      print('❌ Form validation failed');
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;
      print('🚀 Starting forgot password process...');
      print('📧 Email: ${model.email}');

      EasyLoading.show(status: 'Sending reset code...');

      // CALL API
      final response = await _forgotPasswordService.forgotPassword(
        email: model.email,
      );

      print('📦 Response received:');
      print('   - Success: ${response.isSuccess}');
      print('   - Status Code: ${response.statusCode}');
      print('   - Error Message: ${response.errorMessage}');
      print('   - Response Data: ${response.responseData}');

      EasyLoading.dismiss();

      if (response.isSuccess) {
        print('✅ Forgot password request successful!');

        final message =
            response.responseData['message'] ??
            'Reset code has been sent to your email';
        print('💾 Saving email to SharedPreferences...');
        await SharedPreferencesHelper.saveUserData(
          userId: '',
          email: model.email,
          name: '',
          avatar: '',
          role: '',
        );
        print('✅ Email saved successfully!');

        EasyLoading.showSuccess(message);
        await Future.delayed(const Duration(milliseconds: 800));
        print('🔄 Navigating to OTP screen...');

        Get.to(() => const OtpScreen(previousPage: 'ForgotScreen'));

        print('✅ Navigation completed!');
      } else {
        print('❌ Forgot password request failed!');
        print('   - Error: ${response.errorMessage}');
        EasyLoading.showError(response.errorMessage);
      }
    } catch (e, stackTrace) {
      print('💥 Exception occurred:');
      print('   - Error: $e');
      print('   - Stack Trace: $stackTrace');

      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
      print('🏁 Forgot password process completed!');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
