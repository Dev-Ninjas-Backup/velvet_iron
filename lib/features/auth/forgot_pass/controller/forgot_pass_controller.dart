import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/forgot_pass/validation/forgot_validation.dart';
import 'package:velvet_iron/features/auth/forgot_pass/model/forgot_pass_model.dart';
import 'package:velvet_iron/features/auth/otp/screen/otp_screen.dart';

class ForgotPassController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? validateEmail(String? value) {
    return ForgotValidation.validateEmail(value);
  }

  ForgotPassModel? buildModel() {
    if (formKey.currentState?.validate() ?? false) {
      return ForgotPassModel(email: emailController.text.trim());
    }
    return null;
  }

  void submitForgotPassword() {
    final model = buildModel();
    if (model != null) {
      Get.to(() => OtpScreen(previousPage: 'ForgotScreen'));
    } else {
      Get.snackbar('Error', 'Please enter a valid email');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
