// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/otp/screen/otp_screen.dart';
import 'package:velvet_iron/features/auth/services/auth_service.dart';
import 'package:velvet_iron/features/auth/sign_up/validation/signup_validation.dart';
import 'package:velvet_iron/features/auth/user_auth_model.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var passwordObscured = true.obs;
  var confirmPasswordObscured = true.obs;
  var isLoading = false.obs;

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
    return SignUpValidation.validateConfirmPassword(
      passwordController.text,
      value,
    );
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    try {
      isLoading.value = true;
      print('Starting signup process...');
      print('Name: ${nameController.text.trim()}');
      print('Email: ${emailController.text.trim()}');

      EasyLoading.show(status: 'Creating account...');

      final response = await _authService.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      print('Response received:');
      print('Success: ${response.isSuccess}');
      print('Status Code: ${response.statusCode}');
      print('Error Message: ${response.errorMessage}');
      print('Response Data: ${response.responseData}');

      EasyLoading.dismiss();

      if (response.isSuccess && response.responseData != null) {
        final responseBody = response.responseData;

        print('Registration successful!');
        print('Response Body: $responseBody');
        final message = responseBody['message'] ?? 'Registration successful';
        print('Message: $message');

        final userData = UserData.fromJson(responseBody['data']);

        print('User Data:');
        print('ID: ${userData.id}');
        print('Email: ${userData.email}');
        print('Name: ${userData.name}');
        print('Username: ${userData.username}');
        print('Avatar: ${userData.avatar}');
        print('Role: ${userData.role}');
        print('Email Verified: ${userData.emailVerified}');
        print('OTP: ${userData.emailVerificationOtp}');
        print('OTP Expiry: ${userData.emailVerificationExpiry}');

        // Save user data to shared preferences

        print('Saving user data to SharedPreferences...');
        await SharedPreferencesHelper.saveUserData(
          userId: userData.id,
          email: userData.email,
          name: userData.name,
          avatar: userData.avatar,
          role: userData.role,
        );
        print('User data saved successfully!');

        EasyLoading.showSuccess(message);

        // Navigate to OTP screen

        print('Navigating to OTP screen...');
        print('Previous Page: SignUpScreen');
        print('Email: ${userData.email}');
        print('User ID: ${userData.id}');

        Get.to(() => const OtpScreen(previousPage: 'SignUpScreen'));

        print('Navigation completed!');
      } else {
        print('Registration failed!');
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
      print('Signup process completed!');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
